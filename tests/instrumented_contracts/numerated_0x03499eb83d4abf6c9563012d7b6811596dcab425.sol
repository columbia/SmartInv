1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 abstract contract ReentrancyGuard {
7     // Booleans are more expensive than uint256 or any type that takes up a full
8     // word because each write operation emits an extra SLOAD to first read the
9     // slot's contents, replace the bits taken up by the boolean, and then write
10     // back. This is the compiler's defense against contract upgrades and
11     // pointer aliasing, and it cannot be disabled.
12 
13     // The values being non-zero value makes deployment a bit more expensive,
14     // but in exchange the refund on every call to nonReentrant will be lower in
15     // amount. Since refunds are capped to a percentage of the total
16     // transaction's gas, it is best to keep them low in cases like this one, to
17     // increase the likelihood of the full refund coming into effect.
18     uint256 private constant _NOT_ENTERED = 1;
19     uint256 private constant _ENTERED = 2;
20 
21     uint256 private _status;
22 
23     constructor () internal {
24         _status = _NOT_ENTERED;
25     }
26 
27     /**
28      * @dev Prevents a contract from calling itself, directly or indirectly.
29      * Calling a `nonReentrant` function from another `nonReentrant`
30      * function is not supported. It is possible to prevent this from happening
31      * by making the `nonReentrant` function external, and make it call a
32      * `private` function that does the actual work.
33      */
34     modifier nonReentrant() {
35         // On the first call to nonReentrant, _notEntered will be true
36         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
37 
38         // Any calls to nonReentrant after this point will fail
39         _status = _ENTERED;
40 
41         _;
42 
43         // By storing the original value once again, a refund is triggered (see
44         // https://eips.ethereum.org/EIPS/eip-2200)
45         _status = _NOT_ENTERED;
46     }
47 }
48 
49 /*
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with GSN meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address payable) {
62         return payable(msg.sender);
63     }
64 
65     function _msgData() internal view virtual returns (bytes memory) {
66         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
67         return msg.data;
68     }
69 }
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 
84 contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     /**
90      * @dev Initializes the contract setting the deployer as the initial owner.
91      */
92     constructor ()  {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     /**
114      * @dev Leaves the contract without owner. It will not be possible to call
115      * `onlyOwner` functions anymore. Can only be called by the current owner.
116      *
117      * NOTE: Renouncing ownership will leave the contract without an owner,
118      * thereby removing any functionality that is only available to the owner.
119      */
120     function renounceOwnership() public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Can only be called by the current owner.
128      */
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         emit OwnershipTransferred(_owner, newOwner);
132         _owner = newOwner;
133     }
134 }
135 
136 /**
137  * @dev Wrappers over Solidity's arithmetic operations with added overflow
138  * checks.
139  *
140  * Arithmetic operations in Solidity wrap on overflow. This can easily result
141  * in bugs, because programmers usually assume that an overflow raises an
142  * error, which is the standard behavior in high level programming languages.
143  * `SafeMath` restores this intuition by reverting the transaction when an
144  * operation overflows.
145  *
146  * Using this library instead of the unchecked operations eliminates an entire
147  * class of bugs, so it's recommended to use it always.
148  */
149 
150 library SafeMath {
151     /**
152      * @dev Returns the addition of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `+` operator.
156      *
157      * Requirements:
158      *
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;
163         require(c >= a, "SafeMath: addition overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179         return sub(a, b, "SafeMath: subtraction overflow");
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b <= a, errorMessage);
194         uint256 c = a - b;
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      *
207      * - Multiplication cannot overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213         if (a == 0) {
214             return 0;
215         }
216 
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return div(a, b, "SafeMath: division by zero");
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
272         return mod(a, b, "SafeMath: modulo by zero");
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * Reverts with custom message when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 library Address {
294     /**
295      * @dev Returns true if `account` is a contract.
296      *
297      * [IMPORTANT]
298      * ====
299      * It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      *
302      * Among others, `isContract` will return false for the following
303      * types of addresses:
304      *
305      *  - an externally-owned account
306      *  - a contract in construction
307      *  - an address where a contract will be created
308      *  - an address where a contract lived, but was destroyed
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // This method relies on extcodesize, which returns 0 for contracts in
313         // construction, since the code is only stored at the end of the
314         // constructor execution.
315 
316         uint256 size;
317         // solhint-disable-next-line no-inline-assembly
318         assembly { size := extcodesize(account) }
319         return size > 0;
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{ value: amount }("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 
346     /**
347      * @dev Performs a Solidity function call using a low level `call`. A
348      * plain`call` is an unsafe replacement for a function call: use this
349      * function instead.
350      *
351      * If `target` reverts with a revert reason, it is bubbled up by this
352      * function (like regular Solidity function calls).
353      *
354      * Returns the raw returned data. To convert to the expected return value,
355      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356      *
357      * Requirements:
358      *
359      * - `target` must be a contract.
360      * - calling `target` with `data` must not revert.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
365       return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
375         return _functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         return _functionCallWithValue(target, data, value, errorMessage);
402     }
403 
404     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
405         require(isContract(target), "Address: call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415 
416                 // solhint-disable-next-line no-inline-assembly
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 /**
429  * @dev Interface of the ERC20 standard as defined in the EIP.
430  */
431 interface IERC20 {
432     /**
433      * @dev Returns the amount of tokens in existence.
434      */
435     function totalSupply() external view returns (uint256);
436 
437     /**
438      * @dev Returns the amount of tokens owned by `account`.
439      */
440     function balanceOf(address account) external view returns (uint256);
441 
442     /**
443      * @dev Moves `amount` tokens from the caller's account to `recipient`.
444      *
445      * Returns a boolean value indicating whether the operation succeeded.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transfer(address recipient, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Returns the remaining number of tokens that `spender` will be
453      * allowed to spend on behalf of `owner` through {transferFrom}. This is
454      * zero by default.
455      *
456      * This value changes when {approve} or {transferFrom} are called.
457      */
458     function allowance(address owner, address spender) external view returns (uint256);
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * IMPORTANT: Beware that changing an allowance with this method brings the risk
466      * that someone may use both the old and the new allowance by unfortunate
467      * transaction ordering. One possible solution to mitigate this race
468      * condition is to first reduce the spender's allowance to 0 and set the
469      * desired value afterwards:
470      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address spender, uint256 amount) external returns (bool);
475 
476     /**
477      * @dev Moves `amount` tokens from `sender` to `recipient` using the
478      * allowance mechanism. `amount` is then deducted from the caller's
479      * allowance.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Emitted when `value` tokens are moved from one account (`from`) to
489      * another (`to`).
490      *
491      * Note that `value` may be zero.
492      */
493     event Transfer(address indexed from, address indexed to, uint256 value);
494 
495     /**
496      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
497      * a call to {approve}. `value` is the new allowance.
498      */
499     event Approval(address indexed owner, address indexed spender, uint256 value);
500 }
501 /**
502  * @title SafeERC20
503  * @dev Wrappers around ERC20 operations that throw on failure (when the token
504  * contract returns false). Tokens that return no value (and instead revert or
505  * throw on failure) are also supported, non-reverting calls are assumed to be
506  * successful.
507  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
508  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
509  */
510 library SafeERC20 {
511     using SafeMath for uint256;
512     using Address for address;
513 
514     function safeTransfer(IERC20 token, address to, uint256 value) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
519         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
520     }
521 
522     /**
523      * @dev Deprecated. This function has issues similar to the ones found in
524      * {IERC20-approve}, and its usage is discouraged.
525      *
526      * Whenever possible, use {safeIncreaseAllowance} and
527      * {safeDecreaseAllowance} instead.
528      */
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function _callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
559         // the target address contains contract code and also asserts for success in the low-level call.
560 
561         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
562         if (returndata.length > 0) { // Return data is optional
563             // solhint-disable-next-line max-line-length
564             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
565         }
566     }
567 }
568 
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
582 
583 
584 /**
585  * @dev Required interface of an ERC721 compliant contract.
586  */
587 interface IERC721 is IERC165 {
588     /**
589      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
590      */
591     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
595      */
596     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
600      */
601     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
602 
603     /**
604      * @dev Returns the number of tokens in ``owner``'s account.
605      */
606     function balanceOf(address owner) external view returns (uint256 balance);
607 
608     /**
609      * @dev Returns the owner of the `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function ownerOf(uint256 tokenId) external view returns (address owner);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
619      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must exist and be owned by `from`.
626      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
628      *
629      * Emits a {Transfer} event.
630      */
631     function safeTransferFrom(address from, address to, uint256 tokenId) external;
632 
633     /**
634      * @dev Transfers `tokenId` token from `from` to `to`.
635      *
636      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(address from, address to, uint256 tokenId) external;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - `tokenId` must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 
692     /**
693       * @dev Safely transfers `tokenId` token from `from` to `to`.
694       *
695       * Requirements:
696       *
697       * - `from` cannot be the zero address.
698       * - `to` cannot be the zero address.
699       * - `tokenId` token must exist and be owned by `from`.
700       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702       *
703       * Emits a {Transfer} event.
704       */
705     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
706 }
707 
708 
709 // MasterChef is the master of Chiz. He can make Chiz and he is a fair guy.
710 // Note that it's ownable and the owner wields tremendous power. The ownership
711 // will be transferred to a governance smart contract once Chiz is sufficiently
712 // distributed and the community can show to govern itself.
713 //
714 // Have fun reading it. Hopefully it's bug-free. God bless.
715 // European boys play fair, don't worry.
716 
717 contract CHIZchefV2 is Ownable, ReentrancyGuard {
718     using SafeMath for uint256;
719     using SafeERC20 for IERC20;
720 
721     // Info of each user.
722     struct UserInfo {
723         uint256 amount;         // How many LP tokens the user has provided.
724         uint256 rewardDebt;     // Reward debt. See explanation below.
725         //
726         // We do some fancy math here. Basically, any point in time, the amount of CHIZ
727         // entitled to a user but is pending to be distributed is:
728         //
729         //   pending reward = (user.amount * pool.accChizPerShare) - user.rewardDebt
730         //
731         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
732         //   1. The pool's `accChizPerShare` (and `lastRewardBlock`) gets updated.
733         //   2. User receives the pending reward sent to his/her address.
734         //   3. User's `amount` gets updated.
735         //   4. User's `rewardDebt` gets updated.
736     }
737 
738     // Info of each pool.
739     struct PoolInfo {
740         IERC20 lpToken;           // Address of LP token contract.
741         uint256 allocPoint;       // How many allocation points assigned to this pool. CHIZes to distribute per block.
742         uint256 lastRewardBlock;  // Last block number that CHIZes distribution occurs.
743         uint256 accChizPerShare;   // Accumulated CHIZes per share, times 1e36. See below.
744         uint16 depositFeeBP;      // Deposit fee in basis points
745 	    uint256 lpSupply;
746         bool isPoolPrivileged; 
747     }
748 
749     // The CHIZ TOKEN!
750     IERC20 public chizToken;
751     IERC721 public nftPrivilegeContractOne;
752     IERC721 public nftPrivilegeContractTwo;
753     address public devAddress;
754     address public feeAddress;
755     uint256 constant max_chiz_reward_amount = 30000000 ether;
756 
757     // CHIZ tokens created per block.
758     uint256 public chizPerBlock = 20 ether;
759     // CHIZ tokens distributed so far
760     uint256 public chizDistributedAmount = 0;
761 
762     // Info of each pool.
763     PoolInfo[] public poolInfo;
764     // Info of each user that stakes LP tokens.
765     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
766     // Total allocation points. Must be the sum of all allocation points in all pools.
767     uint256 public totalAllocPoint = 0;
768     // The block number when CHIZ mining starts.
769     uint256 public startBlock;
770     // The block number when farming ends.
771     uint256 public endBlock;
772 
773     uint256 public constant MAXIMUM_EMISSION_RATE = 300 ether;
774 
775     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
776     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
777     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
778     event SetFeeAddress(address indexed user, address indexed newAddress);
779     event SetDevAddress(address indexed user, address indexed newAddress);
780     event UpdateEmissionRate(address indexed user, uint256 chizPerBlock);
781     event PoolAdd(address indexed user, IERC20 lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint16 depositFeeBP);
782     event PoolSet(address indexed user, IERC20 lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint16 depositFeeBP);
783     event UpdateStartBlock(address indexed user, uint256 startBlock);
784     constructor(
785         IERC721 _nftPrivilegeContractOne,
786         IERC721 _nftPrivilegeContractTwo,
787         IERC20 _chizToken,
788         uint256 _startBlock,
789         address _devAddress,
790         address _feeAddress
791         
792     ) public {
793         nftPrivilegeContractOne = _nftPrivilegeContractOne;
794         nftPrivilegeContractTwo = _nftPrivilegeContractTwo;
795         chizToken = _chizToken;
796         startBlock = _startBlock;
797         devAddress = _devAddress;
798         feeAddress = _feeAddress;
799         endBlock = _startBlock;
800         
801     }
802 
803     function poolLength() external view returns (uint256) {
804         return poolInfo.length;
805     }
806 
807     mapping(IERC20 => bool) public poolExistence;
808     modifier nonDuplicated(IERC20 _lpToken) {
809         require(poolExistence[_lpToken] == false, "nonDuplicated: duplicated");
810         _;
811     }
812 
813     // Add a new lp to the pool. Can only be called by the owner.
814     function add(uint256 _allocPoint, IERC20 _lpToken, uint16 _depositFeeBP, bool _isPoolPrivileged) external onlyOwner {
815 	    _lpToken.balanceOf(address(this));
816         require(_depositFeeBP <= 500, "add: invalid deposit fee basis points");
817 
818         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
819         totalAllocPoint = totalAllocPoint.add(_allocPoint);
820         poolExistence[_lpToken] = true;
821         poolInfo.push(PoolInfo({
822             lpToken: _lpToken,
823             allocPoint: _allocPoint,
824             lastRewardBlock: lastRewardBlock,
825             accChizPerShare: 0,
826             depositFeeBP: _depositFeeBP,
827 	        lpSupply: 0,
828             isPoolPrivileged: _isPoolPrivileged
829         }));
830 	    emit PoolAdd(msg.sender, _lpToken, _allocPoint,lastRewardBlock,_depositFeeBP);
831     }
832 
833     // Update the given pool's CHIZ allocation point and deposit fee. Can only be called by the owner.
834     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP) external onlyOwner {
835         require(_depositFeeBP <= 500, "set: invalid deposit fee basis points");
836         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
837         poolInfo[_pid].allocPoint = _allocPoint;
838         poolInfo[_pid].depositFeeBP = _depositFeeBP;
839 	    emit PoolSet(msg.sender, poolInfo[_pid].lpToken, _allocPoint,poolInfo[_pid].lastRewardBlock,_depositFeeBP);
840     }
841 
842     // Return reward multiplier over the given _from to _to block.
843     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
844         if (chizDistributedAmount >= max_chiz_reward_amount) return 0;
845  
846         return _to.sub(_from);
847     }
848 
849     // View function to see pending CHIZes on frontend.
850     function pendingChiz(uint256 _pid, address _user) external view returns (uint256) {
851         PoolInfo storage pool = poolInfo[_pid];
852         UserInfo storage user = userInfo[_pid][_user];
853         uint256 accChizPerShare = pool.accChizPerShare;
854 
855         if (block.number > pool.lastRewardBlock && pool.lpSupply != 0 && totalAllocPoint > 0) {
856             uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
857             uint256 multiplier = getMultiplier(pool.lastRewardBlock, lastBlock);
858             uint256 chizReward = multiplier.mul(chizPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
859             accChizPerShare = accChizPerShare.add(chizReward.mul(1e36).div(pool.lpSupply));
860         }
861         return user.amount.mul(accChizPerShare).div(1e36).sub(user.rewardDebt);
862     }
863 
864     // Update reward variables for all pools. Be careful of gas spending!
865     function massUpdatePools() public {
866         uint256 length = poolInfo.length;
867         for (uint256 pid = 0; pid < length; ++pid) {
868             updatePool(pid);
869         }
870     }
871 
872     // Update reward variables of the given pool to be up-to-date.
873     function updatePool(uint256 _pid) public {
874         PoolInfo storage pool = poolInfo[_pid];
875         uint256 lastBlock = block.number < endBlock ? block.number : endBlock;
876         if (lastBlock <= pool.lastRewardBlock) {
877             return;
878         }
879         if (pool.lpSupply == 0 || pool.allocPoint == 0) {
880             pool.lastRewardBlock = lastBlock;
881             return;
882         }
883         uint256 multiplier = getMultiplier(pool.lastRewardBlock, lastBlock);
884         uint256 chizReward = multiplier.mul(chizPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
885 
886         if(chizDistributedAmount.add(chizReward.mul(102).div(100)) <= max_chiz_reward_amount){
887             chizToken.safeTransfer(devAddress, chizReward.div(50));
888         }
889 
890         pool.accChizPerShare = pool.accChizPerShare.add(chizReward.mul(1e36).div(pool.lpSupply));
891         pool.lastRewardBlock = block.number;
892     }
893 
894     // Deposit LP tokens to MasterChef for CHIZ allocation.
895     function deposit(uint256 _pid, uint256 _amount) nonReentrant external {
896         PoolInfo storage pool = poolInfo[_pid];
897         UserInfo storage user = userInfo[_pid][msg.sender];
898         if(pool.isPoolPrivileged){
899             // Privileged Pool NFT Check
900             require(nftPrivilegeContractOne.balanceOf(msg.sender) > 0 && nftPrivilegeContractTwo.balanceOf(msg.sender) > 0, "NFTs are required for deposit");
901 
902         }
903         updatePool(_pid);
904         if (user.amount > 0) {
905             uint256 pending = user.amount.mul(pool.accChizPerShare).div(1e36).sub(user.rewardDebt);
906             if (pending > 0) {
907                 safeChizTransfer(msg.sender, pending);
908             }
909         }
910         if (_amount > 0) {
911 	        uint256 balanceBefore = pool.lpToken.balanceOf(address(this));
912             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
913             _amount = pool.lpToken.balanceOf(address(this)).sub(balanceBefore);
914             require(_amount > 0, "we dont accept deposits of 0");
915             if (pool.depositFeeBP > 0) {
916                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
917                 pool.lpToken.safeTransfer(feeAddress, depositFee);
918                 user.amount = user.amount.add(_amount).sub(depositFee);
919 		        pool.lpSupply = pool.lpSupply.add(_amount).sub(depositFee);
920             } else {
921                 user.amount = user.amount.add(_amount);
922 		        pool.lpSupply = pool.lpSupply.add(_amount);
923             }
924         }
925         user.rewardDebt = user.amount.mul(pool.accChizPerShare).div(1e36);
926         emit Deposit(msg.sender, _pid, _amount);
927     }
928 
929     // Withdraw LP tokens from MasterChef.
930     function withdraw(uint256 _pid, uint256 _amount) nonReentrant external {
931         PoolInfo storage pool = poolInfo[_pid];
932         UserInfo storage user = userInfo[_pid][msg.sender];
933         require(user.amount >= _amount, "withdraw: not good");
934         updatePool(_pid);
935         uint256 pending = user.amount.mul(pool.accChizPerShare).div(1e36).sub(user.rewardDebt);
936         if (pending > 0) {
937             safeChizTransfer(msg.sender, pending);
938         }
939         if (_amount > 0) {
940             user.amount = user.amount.sub(_amount);
941             pool.lpToken.safeTransfer(address(msg.sender), _amount);
942 	        pool.lpSupply = pool.lpSupply.sub(_amount);
943         }
944         user.rewardDebt = user.amount.mul(pool.accChizPerShare).div(1e36);
945         emit Withdraw(msg.sender, _pid, _amount);
946     }
947 
948     // Withdraw without caring about rewards. EMERGENCY ONLY.
949     function emergencyWithdraw(uint256 _pid) nonReentrant external{
950         PoolInfo storage pool = poolInfo[_pid];
951         UserInfo storage user = userInfo[_pid][msg.sender];
952         uint256 amount = user.amount;
953 	    pool.lpSupply = pool.lpSupply.sub(user.amount);
954         user.amount = 0;
955         user.rewardDebt = 0;
956         pool.lpToken.safeTransfer(address(msg.sender), amount);
957         emit EmergencyWithdraw(msg.sender, _pid, amount);
958     }
959 
960     // Safe chiz transfer function, just in case if rounding error causes pool to not have enough CHIZ.
961     function safeChizTransfer(address _to, uint256 _amount) internal {
962         uint256 chizBal = chizToken.balanceOf(address(this));
963         bool transferSuccess = false;
964         if (_amount > chizBal) {
965             transferSuccess = chizToken.transfer(_to, chizBal);
966             chizDistributedAmount = chizDistributedAmount.add(chizBal);
967         } else {
968             transferSuccess = chizToken.transfer(_to, _amount);
969             chizDistributedAmount = chizDistributedAmount.add(_amount);
970         }
971         require(transferSuccess, "safeChizTransfer: Transfer failed");
972     }
973 
974     // Update dev address by the previous dev.
975     function setDevAddress(address _devAddress) external onlyOwner {
976 	require(_devAddress != address(0), "!nonzero");
977         devAddress = _devAddress;
978         emit SetDevAddress(msg.sender, _devAddress);
979     }
980 
981     function setFeeAddress(address _feeAddress) external onlyOwner {
982 	require(_feeAddress != address(0), "!nonzero");
983         feeAddress = _feeAddress;
984         emit SetFeeAddress(msg.sender, _feeAddress);
985     }
986 
987     function updateEmissionRate(uint256 _chizPerBlock) external onlyOwner {
988         require(_chizPerBlock <= MAXIMUM_EMISSION_RATE, "Too High");
989         massUpdatePools();
990         chizPerBlock = _chizPerBlock;
991         emit UpdateEmissionRate(msg.sender, _chizPerBlock);
992     }
993 
994     // Only update before start of farm
995     function updateStartBlock(uint256 _startBlock) onlyOwner external{
996         require(startBlock > block.number, "Farm already started");
997         uint256 length = poolInfo.length;
998         for(uint256 pid = 0; pid < length; ++pid){
999             PoolInfo storage pool = poolInfo[pid];
1000             pool.lastRewardBlock = _startBlock;
1001         }
1002             startBlock = _startBlock;
1003         emit UpdateStartBlock(msg.sender, _startBlock);
1004     }
1005      // Fund the farm, increase the end block
1006     function fund(uint256 _amount) public onlyOwner {
1007         require(block.number < endBlock, "fund: too late, the farm is closed");
1008 
1009         chizToken.transferFrom(address(msg.sender), address(this), _amount);
1010         endBlock += _amount.div(chizPerBlock);
1011     }
1012 }