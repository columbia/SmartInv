1 // SPDX-License-Identifier: GPL-3.0-only
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity >=0.6.2 <0.8.0;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: value }(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
410 
411 
412 pragma solidity >=0.6.0 <0.8.0;
413 
414 
415 
416 /**
417  * @title SafeERC20
418  * @dev Wrappers around ERC20 operations that throw on failure (when the token
419  * contract returns false). Tokens that return no value (and instead revert or
420  * throw on failure) are also supported, non-reverting calls are assumed to be
421  * successful.
422  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
423  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
424  */
425 library SafeERC20 {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     function safeTransfer(IERC20 token, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
431     }
432 
433     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
434         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
435     }
436 
437     /**
438      * @dev Deprecated. This function has issues similar to the ones found in
439      * {IERC20-approve}, and its usage is discouraged.
440      *
441      * Whenever possible, use {safeIncreaseAllowance} and
442      * {safeDecreaseAllowance} instead.
443      */
444     function safeApprove(IERC20 token, address spender, uint256 value) internal {
445         // safeApprove should only be called when setting an initial allowance,
446         // or when resetting it to zero. To increase and decrease it, use
447         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
448         // solhint-disable-next-line max-line-length
449         require((value == 0) || (token.allowance(address(this), spender) == 0),
450             "SafeERC20: approve from non-zero to non-zero allowance"
451         );
452         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
453     }
454 
455     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
456         uint256 newAllowance = token.allowance(address(this), spender).add(value);
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
458     }
459 
460     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     /**
466      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
467      * on the return value: the return value is optional (but if data is returned, it must not be false).
468      * @param token The token targeted by the call.
469      * @param data The call data (encoded using abi.encode or one of its variants).
470      */
471     function _callOptionalReturn(IERC20 token, bytes memory data) private {
472         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
473         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
474         // the target address contains contract code and also asserts for success in the low-level call.
475 
476         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
477         if (returndata.length > 0) { // Return data is optional
478             // solhint-disable-next-line max-line-length
479             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/introspection/IERC165.sol
485 
486 
487 pragma solidity >=0.6.0 <0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
511 
512 
513 pragma solidity >=0.6.2 <0.8.0;
514 
515 /**
516  * @dev Required interface of an ERC721 compliant contract.
517  */
518 interface IERC721 is IERC165 {
519     /**
520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
526      */
527     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
528 
529     /**
530      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
531      */
532     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
533 
534     /**
535      * @dev Returns the number of tokens in ``owner``'s account.
536      */
537     function balanceOf(address owner) external view returns (uint256 balance);
538 
539     /**
540      * @dev Returns the owner of the `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function ownerOf(uint256 tokenId) external view returns (address owner);
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
550      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(address from, address to, uint256 tokenId) external;
563 
564     /**
565      * @dev Transfers `tokenId` token from `from` to `to`.
566      *
567      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
568      *
569      * Requirements:
570      *
571      * - `from` cannot be the zero address.
572      * - `to` cannot be the zero address.
573      * - `tokenId` token must be owned by `from`.
574      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
575      *
576      * Emits a {Transfer} event.
577      */
578     function transferFrom(address from, address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
582      * The approval is cleared when the token is transferred.
583      *
584      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
585      *
586      * Requirements:
587      *
588      * - The caller must own the token or be an approved operator.
589      * - `tokenId` must exist.
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Approve or remove `operator` as an operator for the caller.
606      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
607      *
608      * Requirements:
609      *
610      * - The `operator` cannot be the caller.
611      *
612      * Emits an {ApprovalForAll} event.
613      */
614     function setApprovalForAll(address operator, bool _approved) external;
615 
616     /**
617      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
618      *
619      * See {setApprovalForAll}
620      */
621     function isApprovedForAll(address owner, address operator) external view returns (bool);
622 
623     /**
624       * @dev Safely transfers `tokenId` token from `from` to `to`.
625       *
626       * Requirements:
627       *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630       * - `tokenId` token must exist and be owned by `from`.
631       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633       *
634       * Emits a {Transfer} event.
635       */
636     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
637 }
638 
639 // File: @openzeppelin/contracts/GSN/Context.sol
640 
641 
642 pragma solidity >=0.6.0 <0.8.0;
643 
644 /*
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with GSN meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address payable) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes memory) {
660         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
661         return msg.data;
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/Ownable.sol
666 
667 
668 pragma solidity >=0.6.0 <0.8.0;
669 
670 /**
671  * @dev Contract module which provides a basic access control mechanism, where
672  * there is an account (an owner) that can be granted exclusive access to
673  * specific functions.
674  *
675  * By default, the owner account will be the one that deploys the contract. This
676  * can later be changed with {transferOwnership}.
677  *
678  * This module is used through inheritance. It will make available the modifier
679  * `onlyOwner`, which can be applied to your functions to restrict their use to
680  * the owner.
681  */
682 abstract contract Ownable is Context {
683     address private _owner;
684 
685     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
686 
687     /**
688      * @dev Initializes the contract setting the deployer as the initial owner.
689      */
690     constructor () internal {
691         address msgSender = _msgSender();
692         _owner = msgSender;
693         emit OwnershipTransferred(address(0), msgSender);
694     }
695 
696     /**
697      * @dev Returns the address of the current owner.
698      */
699     function owner() public view returns (address) {
700         return _owner;
701     }
702 
703     /**
704      * @dev Throws if called by any account other than the owner.
705      */
706     modifier onlyOwner() {
707         require(_owner == _msgSender(), "Ownable: caller is not the owner");
708         _;
709     }
710 
711     /**
712      * @dev Leaves the contract without owner. It will not be possible to call
713      * `onlyOwner` functions anymore. Can only be called by the current owner.
714      *
715      * NOTE: Renouncing ownership will leave the contract without an owner,
716      * thereby removing any functionality that is only available to the owner.
717      */
718     function renounceOwnership() public virtual onlyOwner {
719         emit OwnershipTransferred(_owner, address(0));
720         _owner = address(0);
721     }
722 
723     /**
724      * @dev Transfers ownership of the contract to a new account (`newOwner`).
725      * Can only be called by the current owner.
726      */
727     function transferOwnership(address newOwner) public virtual onlyOwner {
728         require(newOwner != address(0), "Ownable: new owner is the zero address");
729         emit OwnershipTransferred(_owner, newOwner);
730         _owner = newOwner;
731     }
732 }
733 
734 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
735 
736 
737 pragma solidity >=0.6.0 <0.8.0;
738 
739 /**
740  * @title ERC721 token receiver interface
741  * @dev Interface for any contract that wants to support safeTransfers
742  * from ERC721 asset contracts.
743  */
744 interface IERC721Receiver {
745     /**
746      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
747      * by `operator` from `from`, this function is called.
748      *
749      * It must return its Solidity selector to confirm the token transfer.
750      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
751      *
752      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
753      */
754     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/ERC721Holder.sol
758 
759 
760 pragma solidity >=0.6.0 <0.8.0;
761 
762   /**
763    * @dev Implementation of the {IERC721Receiver} interface.
764    *
765    * Accepts all token transfers. 
766    * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
767    */
768 contract ERC721Holder is IERC721Receiver {
769 
770     /**
771      * @dev See {IERC721Receiver-onERC721Received}.
772      *
773      * Always returns `IERC721Receiver.onERC721Received.selector`.
774      */
775     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
776         return this.onERC721Received.selector;
777     }
778 }
779 
780 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
781 
782 
783 pragma solidity >=0.6.0 <0.8.0;
784 
785 /**
786  * @dev Contract module that helps prevent reentrant calls to a function.
787  *
788  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
789  * available, which can be applied to functions to make sure there are no nested
790  * (reentrant) calls to them.
791  *
792  * Note that because there is a single `nonReentrant` guard, functions marked as
793  * `nonReentrant` may not call one another. This can be worked around by making
794  * those functions `private`, and then adding `external` `nonReentrant` entry
795  * points to them.
796  *
797  * TIP: If you would like to learn more about reentrancy and alternative ways
798  * to protect against it, check out our blog post
799  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
800  */
801 abstract contract ReentrancyGuard {
802     // Booleans are more expensive than uint256 or any type that takes up a full
803     // word because each write operation emits an extra SLOAD to first read the
804     // slot's contents, replace the bits taken up by the boolean, and then write
805     // back. This is the compiler's defense against contract upgrades and
806     // pointer aliasing, and it cannot be disabled.
807 
808     // The values being non-zero value makes deployment a bit more expensive,
809     // but in exchange the refund on every call to nonReentrant will be lower in
810     // amount. Since refunds are capped to a percentage of the total
811     // transaction's gas, it is best to keep them low in cases like this one, to
812     // increase the likelihood of the full refund coming into effect.
813     uint256 private constant _NOT_ENTERED = 1;
814     uint256 private constant _ENTERED = 2;
815 
816     uint256 private _status;
817 
818     constructor () internal {
819         _status = _NOT_ENTERED;
820     }
821 
822     /**
823      * @dev Prevents a contract from calling itself, directly or indirectly.
824      * Calling a `nonReentrant` function from another `nonReentrant`
825      * function is not supported. It is possible to prevent this from happening
826      * by making the `nonReentrant` function external, and make it call a
827      * `private` function that does the actual work.
828      */
829     modifier nonReentrant() {
830         // On the first call to nonReentrant, _notEntered will be true
831         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
832 
833         // Any calls to nonReentrant after this point will fail
834         _status = _ENTERED;
835 
836         _;
837 
838         // By storing the original value once again, a refund is triggered (see
839         // https://eips.ethereum.org/EIPS/eip-2200)
840         _status = _NOT_ENTERED;
841     }
842 }
843 
844 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
845 
846 
847 pragma solidity >=0.6.2 <0.8.0;
848 
849 /**
850  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
851  * @dev See https://eips.ethereum.org/EIPS/eip-721
852  */
853 interface IERC721Metadata is IERC721 {
854 
855     /**
856      * @dev Returns the token collection name.
857      */
858     function name() external view returns (string memory);
859 
860     /**
861      * @dev Returns the token collection symbol.
862      */
863     function symbol() external view returns (string memory);
864 
865     /**
866      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
867      */
868     function tokenURI(uint256 tokenId) external view returns (string memory);
869 }
870 
871 // File: contracts/v1.5/SafeERC721.sol
872 
873 pragma solidity ^0.6.0;
874 
875 
876 library SafeERC721
877 {
878 	function safeName(IERC721Metadata _metadata) internal view returns (string memory _name)
879 	{
880 		try _metadata.name() returns (string memory _n) { return _n; } catch {}
881 	}
882 
883 	function safeSymbol(IERC721Metadata _metadata) internal view returns (string memory _symbol)
884 	{
885 		try _metadata.symbol() returns (string memory _s) { return _s; } catch {}
886 	}
887 
888 	function safeTokenURI(IERC721Metadata _metadata, uint256 _tokenId) internal view returns (string memory _tokenURI)
889 	{
890 		try _metadata.tokenURI(_tokenId) returns (string memory _t) { return _t; } catch {}
891 	}
892 
893 	function safeTransfer(IERC721 _token, address _to, uint256 _tokenId) internal
894 	{
895 		address _from = address(this);
896 		try _token.transferFrom(_from, _to, _tokenId) { return; } catch {}
897 		// attempts to handle non-conforming ERC721 contracts
898 		_token.approve(_from, _tokenId);
899 		_token.transferFrom(_from, _to, _tokenId);
900 	}
901 }
902 
903 // File: contracts/v1.5/CollectivePurchase.sol
904 
905 pragma solidity ^0.6.0;
906 
907 
908 
909 
910 
911 
912 
913 interface IAuctionFractionalizer
914 {
915 	function fractionalize(address _target, uint256 _tokenId, string memory _name, string memory _symbol, uint8 _decimals, uint256 _fractionsCount, uint256 _fractionPrice, address _paymentToken, uint256 _kickoff, uint256 _duration, uint256 _fee) external returns (address _fractions);
916 }
917 
918 contract CollectivePurchase is ERC721Holder, Ownable, ReentrancyGuard
919 {
920 	using SafeERC20 for IERC20;
921 	using SafeERC721 for IERC721;
922 	using SafeMath for uint256;
923 
924 	enum State { Created, Funded, Started, Ended }
925 
926 	struct BuyerInfo {
927 		uint256 amount;
928 	}
929 
930 	struct ListingInfo {
931 		State state;
932 		address payable seller;
933 		address collection;
934 		uint256 tokenId;
935 		address paymentToken;
936 		uint256 reservePrice;
937 		uint256 limitPrice;
938 		uint256 extension;
939 		uint256 priceMultiplier;
940 		bytes extra;
941 		uint256 amount;
942 		uint256 cutoff;
943 		uint256 fractionsCount;
944 		address fractions;
945 		mapping (address => BuyerInfo) buyers;
946 	}
947 
948 	uint8 constant public FRACTIONS_DECIMALS = 6;
949 	uint256 constant public FRACTIONS_COUNT = 100000e6;
950 
951 	uint256 public immutable fee;
952 	address payable public immutable vault;
953 	mapping (bytes32 => address) public fractionalizers;
954 
955 	mapping (address => uint256) private balances;
956 	mapping (address => mapping (uint256 => bool)) private items;
957 
958 	ListingInfo[] public listings;
959 
960 	modifier onlySeller(uint256 _listingId)
961 	{
962 		ListingInfo storage _listing = listings[_listingId];
963 		require(msg.sender == _listing.seller, "access denied");
964 		_;
965 	}
966 
967 	modifier inState(uint256 _listingId, State _state)
968 	{
969 		ListingInfo storage _listing = listings[_listingId];
970 		require(_state == _listing.state, "not available");
971 		_;
972 	}
973 
974 	modifier notInState(uint256 _listingId, State _state)
975 	{
976 		ListingInfo storage _listing = listings[_listingId];
977 		require(_state != _listing.state, "not available");
978 		_;
979 	}
980 
981 	constructor (uint256 _fee, address payable _vault) public
982 	{
983 		require(_fee <= 1e18, "invalid fee");
984 		require(_vault != address(0), "invalid address");
985 		fee = _fee;
986 		vault = _vault;
987 	}
988 
989 	function listingCount() external view returns (uint256 _count)
990 	{
991 		return listings.length;
992 	}
993 
994 	function buyers(uint256 _listingId, address _buyer) external view returns (uint256 _amount)
995 	{
996 		ListingInfo storage _listing = listings[_listingId];
997 		BuyerInfo storage _info = _listing.buyers[_buyer];
998 		return _info.amount;
999 	}
1000 
1001 	function status(uint256 _listingId) external view returns (string memory _status)
1002 	{
1003 		ListingInfo storage _listing = listings[_listingId];
1004 		if (_listing.state == State.Created) return "CREATED";
1005 		if (_listing.state == State.Funded) return "FUNDED";
1006 		if (_listing.state == State.Started) return now <= _listing.cutoff ? "STARTED" : "ENDING";
1007 		return "ENDED";
1008 	}
1009 
1010 	function maxJoinAmount(uint256 _listingId) external view returns (uint256 _amount)
1011 	{
1012 		ListingInfo storage _listing = listings[_listingId];
1013 		return _listing.limitPrice - _listing.amount;
1014 	}
1015 
1016 	function buyerFractionsCount(uint256 _listingId, address _buyer) external view inState(_listingId, State.Ended) returns (uint256 _fractionsCount)
1017 	{
1018 		ListingInfo storage _listing = listings[_listingId];
1019 		uint256 _amount = _listing.buyers[_buyer].amount;
1020 		_fractionsCount = (_amount * _listing.fractionsCount) / _listing.reservePrice;
1021 		return _fractionsCount;
1022 	}
1023 
1024 	function sellerPayout(uint256 _listingId) external view returns (uint256 _netAmount, uint256 _feeAmount, uint256 _netFractionsCount, uint256 _feeFractionsCount)
1025 	{
1026 		ListingInfo storage _listing = listings[_listingId];
1027 		uint256 _reservePrice = _listing.reservePrice;
1028 		uint256 _amount = _listing.amount;
1029 		_feeAmount = (_amount * fee) / 1e18;
1030 		_netAmount = _amount - _feeAmount;
1031 		_feeFractionsCount = 0;
1032 		_netFractionsCount = 0;
1033 		if (_reservePrice > _amount) {
1034 			uint256 _missingAmount = _reservePrice - _amount;
1035 			uint256 _missingFeeAmount = (_missingAmount * fee) / 1e18;
1036 			uint256 _missingNetAmount = _missingAmount - _missingFeeAmount;
1037 			uint256 _fractionsCount = _issuing(_listing.extra);
1038 			_feeFractionsCount = _fractionsCount * _missingFeeAmount / _reservePrice;
1039 			_netFractionsCount = _fractionsCount * _missingNetAmount / _reservePrice;
1040 		}
1041 	}
1042 
1043 	function addFractionalizer(bytes32 _type, address _fractionalizer) external onlyOwner
1044 	{
1045 		require(fractionalizers[_type] == address(0), "already defined");
1046 		fractionalizers[_type] = _fractionalizer;
1047 		emit AddFractionalizer(_type, _fractionalizer);
1048 	}
1049 
1050 	function list(address _collection, uint256 _tokenId, address _paymentToken, uint256 _reservePrice, uint256 _limitPrice, uint256 _extension, uint256 _priceMultiplier, bytes calldata _extra) external nonReentrant returns (uint256 _listingId)
1051 	{
1052 		address payable _seller = msg.sender;
1053 		require(_limitPrice * 1e18 / _limitPrice == 1e18, "price overflow");
1054 		require(0 < _reservePrice && _reservePrice <= _limitPrice, "invalid price");
1055 		require(30 minutes <= _extension && _extension <= 731 days, "invalid duration");
1056 		require(0 < _priceMultiplier && _priceMultiplier <= 10000, "invalid multiplier"); // from 1% up to 100x
1057 		_validate(_extra);
1058 		IERC721(_collection).transferFrom(_seller, address(this), _tokenId);
1059 		items[_collection][_tokenId] = true;
1060 		_listingId = listings.length;
1061 		listings.push(ListingInfo({
1062 			state: State.Created,
1063 			seller: _seller,
1064 			collection: _collection,
1065 			tokenId: _tokenId,
1066 			paymentToken: _paymentToken,
1067 			reservePrice: _reservePrice,
1068 			limitPrice: _limitPrice,
1069 			extension: _extension,
1070 			priceMultiplier: _priceMultiplier,
1071 			extra: _extra,
1072 			amount: 0,
1073 			cutoff: uint256(-1),
1074 			fractionsCount: 0,
1075 			fractions: address(0)
1076 		}));
1077 		emit Listed(_listingId);
1078 		return _listingId;
1079 	}
1080 
1081 	function cancel(uint256 _listingId) external nonReentrant onlySeller(_listingId) inState(_listingId, State.Created)
1082 	{
1083 		ListingInfo storage _listing = listings[_listingId];
1084 		_listing.state = State.Ended;
1085 		items[_listing.collection][_listing.tokenId] = false;
1086 		IERC721(_listing.collection).safeTransfer(_listing.seller, _listing.tokenId);
1087 		emit Canceled(_listingId);
1088 	}
1089 
1090 	function updatePrice(uint256 _listingId, uint256 _newReservePrice, uint256 _newLimitPrice) external onlySeller(_listingId) inState(_listingId, State.Created)
1091 	{
1092 		require(_newLimitPrice * 1e18 / _newLimitPrice == 1e18, "price overflow");
1093 		require(0 < _newReservePrice && _newReservePrice <= _newLimitPrice, "invalid price");
1094 		ListingInfo storage _listing = listings[_listingId];
1095 		uint256 _oldReservePrice = _listing.reservePrice;
1096 		uint256 _oldLimitPrice = _listing.limitPrice;
1097 		_listing.reservePrice = _newReservePrice;
1098 		_listing.limitPrice = _newLimitPrice;
1099 		emit UpdatePrice(_listingId, _oldReservePrice, _oldLimitPrice, _newReservePrice, _newLimitPrice);
1100 	}
1101 
1102 	function accept(uint256 _listingId) external onlySeller(_listingId) inState(_listingId, State.Funded)
1103 	{
1104 		ListingInfo storage _listing = listings[_listingId];
1105 		uint256 _amount = _listing.reservePrice - _listing.amount;
1106 		uint256 _feeAmount = (_amount * fee) / 1e18;
1107 		uint256 _netAmount = _amount - _feeAmount;
1108 		_listing.state = State.Started;
1109 		_listing.cutoff = now - 1;
1110 		_listing.buyers[vault].amount += _feeAmount;
1111 		_listing.buyers[_listing.seller].amount += _netAmount;
1112 		emit Sold(_listingId);
1113 	}
1114 
1115 	function join(uint256 _listingId, uint256 _amount) external payable nonReentrant notInState(_listingId, State.Ended)
1116 	{
1117 		address payable _buyer = msg.sender;
1118 		uint256 _value = msg.value;
1119 		ListingInfo storage _listing = listings[_listingId];
1120 		require(now <= _listing.cutoff, "not available");
1121 		uint256 _leftAmount = _listing.limitPrice - _listing.amount;
1122 		require(_amount <= _leftAmount, "limit exceeded");
1123 		_safeTransferFrom(_listing.paymentToken, _buyer, _value, payable(address(this)), _amount);
1124 		balances[_listing.paymentToken] += _amount;
1125 		_listing.amount += _amount;
1126 		_listing.buyers[_buyer].amount += _amount;
1127 		if (_listing.state == State.Created) _listing.state = State.Funded;
1128 		if (_listing.state == State.Funded) {
1129 			if (_listing.amount >= _listing.reservePrice) {
1130 				_listing.state = State.Started;
1131 				_listing.cutoff = now + _listing.extension;
1132 				emit Sold(_listingId);
1133 			}
1134 		}
1135 		if (_listing.state == State.Started) _listing.reservePrice = _listing.amount;
1136 		emit Join(_listingId, _buyer, _amount);
1137 	}
1138 
1139 	function leave(uint256 _listingId) external nonReentrant inState(_listingId, State.Funded)
1140 	{
1141 		address payable _buyer = msg.sender;
1142 		ListingInfo storage _listing = listings[_listingId];
1143 		uint256 _amount = _listing.buyers[_buyer].amount;
1144 		require(_amount > 0, "insufficient balance");
1145 		_listing.buyers[_buyer].amount = 0;
1146 		_listing.amount -= _amount;
1147 		balances[_listing.paymentToken] -= _amount;
1148 		if (_listing.amount == 0) _listing.state = State.Created;
1149 		_safeTransfer(_listing.paymentToken, _buyer, _amount);
1150 		emit Leave(_listingId, _buyer, _amount);
1151 	}
1152 
1153 	function relist(uint256 _listingId) public nonReentrant inState(_listingId, State.Started)
1154 	{
1155 		ListingInfo storage _listing = listings[_listingId];
1156 		require(now > _listing.cutoff, "not available");
1157 		uint256 _fractionPrice = (_listing.reservePrice + (FRACTIONS_COUNT - 1)) / FRACTIONS_COUNT;
1158 		uint256 _relistFractionPrice = (_listing.priceMultiplier * _fractionPrice + 99) / 100;
1159 		_listing.state = State.Ended;
1160 		_listing.fractions = _fractionalize(_listingId, _relistFractionPrice);
1161 		_listing.fractionsCount = _balanceOf(_listing.fractions);
1162 		items[_listing.collection][_listing.tokenId] = false;
1163 		balances[_listing.fractions] = _listing.fractionsCount;
1164 		emit Relisted(_listingId);
1165 	}
1166 
1167 	function payout(uint256 _listingId) public nonReentrant inState(_listingId, State.Ended)
1168 	{
1169 		ListingInfo storage _listing = listings[_listingId];
1170 		uint256 _amount = _listing.amount;
1171 		require(_amount > 0, "insufficient balance");
1172 		uint256 _feeAmount = (_amount * fee) / 1e18;
1173 		uint256 _netAmount = _amount - _feeAmount;
1174 		_listing.amount = 0;
1175 		balances[_listing.paymentToken] -= _amount;
1176 		_safeTransfer(_listing.paymentToken, vault, _feeAmount);
1177 		_safeTransfer(_listing.paymentToken, _listing.seller, _netAmount);
1178 		emit Payout(_listingId, _listing.seller, _netAmount, _feeAmount);
1179 	}
1180 
1181 	function claim(uint256 _listingId, address payable _buyer) public nonReentrant inState(_listingId, State.Ended)
1182 	{
1183 		ListingInfo storage _listing = listings[_listingId];
1184 		uint256 _amount = _listing.buyers[_buyer].amount;
1185 		require(_amount > 0, "insufficient balance");
1186 		uint256 _fractionsCount = (_amount * _listing.fractionsCount) / _listing.reservePrice;
1187 		_listing.buyers[_buyer].amount = 0;
1188 		balances[_listing.fractions] -= _fractionsCount;
1189 		_safeTransfer(_listing.fractions, _buyer, _fractionsCount);
1190 		emit Claim(_listingId, _buyer, _amount, _fractionsCount);
1191 	}
1192 
1193 	function relistPayoutAndClaim(uint256 _listingId, address payable[] calldata _buyers) external
1194 	{
1195 		ListingInfo storage _listing = listings[_listingId];
1196 		if (_listing.state != State.Ended) {
1197 			relist(_listingId);
1198 		}
1199 		if (_listing.amount > 0) {
1200 			payout(_listingId);
1201 		}
1202 		if (_listing.buyers[vault].amount > 0) {
1203 			claim(_listingId, vault);
1204 		}
1205 		if (_listing.buyers[_listing.seller].amount > 0) {
1206 			claim(_listingId, _listing.seller);
1207 		}
1208 		for (uint256 _i = 0; _i < _buyers.length; _i++) {
1209 			address payable _buyer = _buyers[_i];
1210 			if (_listing.buyers[_buyer].amount > 0) {
1211 				claim(_listingId, _buyer);
1212 			}
1213 		}
1214 	}
1215 
1216 	function recoverLostFunds(address _token, address payable _to) external onlyOwner nonReentrant
1217 	{
1218 		uint256 _balance = balances[_token];
1219 		uint256 _current = _balanceOf(_token);
1220 		if (_current > _balance) {
1221 			uint256 _excess = _current - _balance;
1222 			_safeTransfer(_token, _to, _excess);
1223 		}
1224 	}
1225 
1226 	function recoverLostItem(address _collection, uint256 _tokenId, address _to) external onlyOwner nonReentrant
1227 	{
1228 		if (items[_collection][_tokenId]) return;
1229 		IERC721(_collection).safeTransfer(_to, _tokenId);
1230 	}
1231 
1232 	function _validate(bytes calldata _extra) internal view
1233 	{
1234 		(bytes32 _type,,, uint256 _duration, uint256 _fee) = abi.decode(_extra, (bytes32, string, string, uint256, uint256));
1235 		require(fractionalizers[_type] != address(0), "unsupported type");
1236 		require(30 minutes <= _duration && _duration <= 731 days, "invalid duration");
1237 		require(_fee <= 1e18, "invalid fee");
1238 	}
1239 
1240 	function _issuing(bytes storage _extra) internal pure returns (uint256 _fractionsCount)
1241 	{
1242 		(,,,, uint256 _fee) = abi.decode(_extra, (bytes32, string, string, uint256, uint256));
1243 		return FRACTIONS_COUNT - (FRACTIONS_COUNT * _fee / 1e18);
1244 	}
1245 
1246 	function _fractionalize(uint256 _listingId, uint256 _fractionPrice) internal returns (address _fractions)
1247 	{
1248 		ListingInfo storage _listing = listings[_listingId];
1249 		(bytes32 _type, string memory _name, string memory _symbol, uint256 _duration, uint256 _fee) = abi.decode(_listing.extra, (bytes32, string, string, uint256, uint256));
1250 		IERC721(_listing.collection).approve(fractionalizers[_type], _listing.tokenId);
1251 		return IAuctionFractionalizer(fractionalizers[_type]).fractionalize(_listing.collection, _listing.tokenId, _name, _symbol, FRACTIONS_DECIMALS, FRACTIONS_COUNT, _fractionPrice, _listing.paymentToken, 0, _duration, _fee);
1252 	}
1253 
1254 	function _balanceOf(address _token) internal view returns (uint256 _balance)
1255 	{
1256 		if (_token == address(0)) {
1257 			return address(this).balance;
1258 		} else {
1259 			return IERC20(_token).balanceOf(address(this));
1260 		}
1261 	}
1262 
1263 	function _safeTransfer(address _token, address payable _to, uint256 _amount) internal
1264 	{
1265 		if (_token == address(0)) {
1266 			_to.transfer(_amount);
1267 		} else {
1268 			IERC20(_token).safeTransfer(_to, _amount);
1269 		}
1270 	}
1271 
1272 	function _safeTransferFrom(address _token, address payable _from, uint256 _value, address payable _to, uint256 _amount) internal
1273 	{
1274 		if (_token == address(0)) {
1275 			require(_value == _amount, "invalid value");
1276 			if (_to != address(this)) _to.transfer(_amount);
1277 		} else {
1278 			require(_value == 0, "invalid value");
1279 			IERC20(_token).safeTransferFrom(_from, _to, _amount);
1280 		}
1281 	}
1282 
1283 	event AddFractionalizer(bytes32 indexed _type, address indexed _fractionalizer);
1284 	event Listed(uint256 indexed _listingId);
1285 	event Sold(uint256 indexed _listingId);
1286 	event Relisted(uint256 indexed _listingId);
1287 	event Canceled(uint256 indexed _listingId);
1288 	event UpdatePrice(uint256 indexed _listingId, uint256 _oldReservePrice, uint256 _oldLimitPrice, uint256 _newReservePrice, uint256 _newLimitPrice);
1289 	event Join(uint256 indexed _listingId, address indexed _buyer, uint256 _amount);
1290 	event Leave(uint256 indexed _listingId, address indexed _buyer, uint256 _amount);
1291 	event Payout(uint256 indexed _listingId, address indexed _seller, uint256 _netAmount, uint256 _feeAmount);
1292 	event Claim(uint256 indexed _listingId, address indexed _buyer, uint256 _amount, uint256 _fractionsCount);
1293 }
1294 
1295 // File: contracts/v1.5/OpenCollectivePurchase.sol
1296 
1297 pragma solidity ^0.6.0;
1298 
1299 
1300 
1301 
1302 
1303 
1304 
1305 interface FlashAcquireCallee
1306 {
1307 	function flashAcquireCall(address _sender, uint256 _listingId, bytes calldata _data) external;
1308 }
1309 
1310 contract OpenCollectivePurchase is ERC721Holder, Ownable, ReentrancyGuard
1311 {
1312 	using SafeERC20 for IERC20;
1313 	using SafeERC721 for IERC721;
1314 
1315 	enum State { Created, Acquired, Ended }
1316 
1317 	struct BuyerInfo {
1318 		uint256 amount;
1319 	}
1320 
1321 	struct ListingInfo {
1322 		State state;
1323 		address payable seller;
1324 		address collection;
1325 		uint256 tokenId;
1326 		bool listed;
1327 		address paymentToken;
1328 		uint256 reservePrice;
1329 		uint256 priceMultiplier;
1330 		bytes extra;
1331 		uint256 amount;
1332 		uint256 fractionsCount;
1333 		address fractions;
1334 		uint256 fee;
1335 		mapping (address => BuyerInfo) buyers;
1336 	}
1337 
1338 	struct CreatorInfo {
1339 		address payable creator;
1340 		uint256 fee;
1341 	}
1342 
1343 	uint8 constant public FRACTIONS_DECIMALS = 6;
1344 	uint256 constant public FRACTIONS_COUNT = 100000e6;
1345 
1346 	uint256 public fee;
1347 	address payable public immutable vault;
1348 	mapping (bytes32 => address) public fractionalizers;
1349 
1350 	mapping (address => uint256) private balances;
1351 	mapping (address => mapping (uint256 => bool)) private items;
1352 	ListingInfo[] public listings;
1353 	CreatorInfo[] public creators;
1354 
1355 	modifier inState(uint256 _listingId, State _state)
1356 	{
1357 		ListingInfo storage _listing = listings[_listingId];
1358 		require(_state == _listing.state, "not available");
1359 		_;
1360 	}
1361 
1362 	modifier onlyCreator(uint256 _listingId)
1363 	{
1364 		CreatorInfo storage _creator = creators[_listingId];
1365 		require(msg.sender == _creator.creator, "not available");
1366 		_;
1367 	}
1368 
1369 	constructor (uint256 _fee, address payable _vault) public
1370 	{
1371 		require(_fee <= 100e16, "invalid fee");
1372 		require(_vault != address(0), "invalid address");
1373 		fee = _fee;
1374 		vault = _vault;
1375 	}
1376 
1377 	function listingCount() external view returns (uint256 _count)
1378 	{
1379 		return listings.length;
1380 	}
1381 
1382 	function buyers(uint256 _listingId, address _buyer) external view returns (uint256 _amount)
1383 	{
1384 		ListingInfo storage _listing = listings[_listingId];
1385 		BuyerInfo storage _info = _listing.buyers[_buyer];
1386 		return _info.amount;
1387 	}
1388 
1389 	function status(uint256 _listingId) external view returns (string memory _status)
1390 	{
1391 		ListingInfo storage _listing = listings[_listingId];
1392 		if (_listing.state == State.Created) return "CREATED";
1393 		if (_listing.state == State.Acquired) return "ACQUIRED";
1394 		return "ENDED";
1395 	}
1396 
1397 	function buyerFractionsCount(uint256 _listingId, address _buyer) external view inState(_listingId, State.Ended) returns (uint256 _fractionsCount)
1398 	{
1399 		ListingInfo storage _listing = listings[_listingId];
1400 		uint256 _amount = _listing.buyers[_buyer].amount;
1401 		_fractionsCount = (_amount * _listing.fractionsCount) / _listing.reservePrice;
1402 		return _fractionsCount;
1403 	}
1404 
1405 	function sellerPayout(uint256 _listingId) external view returns (uint256 _netAmount, uint256 _feeAmount, uint256 _creatorFeeAmount)
1406 	{
1407 		ListingInfo storage _listing = listings[_listingId];
1408 		CreatorInfo storage _creator = creators[_listingId];
1409 		uint256 _amount = _listing.amount;
1410 		_feeAmount = (_amount * _listing.fee) / 1e18;
1411 		_creatorFeeAmount = (_amount * _creator.fee) / 1e18;
1412 		_netAmount = _amount - (_feeAmount + _creatorFeeAmount);
1413 	}
1414 
1415 	function setFee(uint256 _fee) external onlyOwner
1416 	{
1417 		require(_fee <= 100e16, "invalid fee");
1418 		fee = _fee;
1419 		emit UpdateFee(_fee);
1420 	}
1421 
1422 	function setCreatorFee(uint256 _listingId, uint256 _fee) external onlyCreator(_listingId) inState(_listingId, State.Created)
1423 	{
1424 		ListingInfo storage _listing = listings[_listingId];
1425 		CreatorInfo storage _creator = creators[_listingId];
1426 		require(_listing.fee + _fee <= 100e16, "invalid fee");
1427 		_creator.fee = _fee;
1428 		emit UpdateCreatorFee(_listingId, _fee);
1429 	}
1430 
1431 	function addFractionalizer(bytes32 _type, address _fractionalizer) external onlyOwner
1432 	{
1433 		require(fractionalizers[_type] == address(0), "already defined");
1434 		fractionalizers[_type] = _fractionalizer;
1435 		emit AddFractionalizer(_type, _fractionalizer);
1436 	}
1437 
1438 	function list(address _collection, uint256 _tokenId, bool _listed, uint256 _fee, address _paymentToken, uint256 _priceMultiplier, bytes calldata _extra) external nonReentrant returns (uint256 _listingId)
1439 	{
1440 		address payable _creator = msg.sender;
1441 		require(fee + _fee <= 100e16, "invalid fee");
1442 		require(0 < _priceMultiplier && _priceMultiplier <= 10000, "invalid multiplier"); // from 1% up to 100x
1443 		_validate(_extra);
1444 		_listingId = listings.length;
1445 		listings.push(ListingInfo({
1446 			state: State.Created,
1447 			seller: address(0),
1448 			collection: _collection,
1449 			tokenId: _tokenId,
1450 			listed: _listed,
1451 			paymentToken: _paymentToken,
1452 			reservePrice: 0,
1453 			priceMultiplier: _priceMultiplier,
1454 			extra: _extra,
1455 			amount: 0,
1456 			fractionsCount: 0,
1457 			fractions: address(0),
1458 			fee: fee
1459 		}));
1460 		creators.push(CreatorInfo({
1461 			creator: _creator,
1462 			fee: _fee
1463 		}));
1464 		emit Listed(_listingId, _creator);
1465 		return _listingId;
1466 	}
1467 
1468 	function join(uint256 _listingId, uint256 _amount, uint256 _maxReservePrice) external payable nonReentrant inState(_listingId, State.Created)
1469 	{
1470 		address payable _buyer = msg.sender;
1471 		uint256 _value = msg.value;
1472 		ListingInfo storage _listing = listings[_listingId];
1473 		require(_listing.reservePrice <= _maxReservePrice, "price slippage");
1474 		_safeTransferFrom(_listing.paymentToken, _buyer, _value, payable(address(this)), _amount);
1475 		balances[_listing.paymentToken] += _amount;
1476 		_listing.amount += _amount;
1477 		_listing.buyers[_buyer].amount += _amount;
1478 		_listing.reservePrice = _listing.amount;
1479 		emit Join(_listingId, _buyer, _amount);
1480 	}
1481 
1482 	function leave(uint256 _listingId) external nonReentrant inState(_listingId, State.Created)
1483 	{
1484 		address payable _buyer = msg.sender;
1485 		ListingInfo storage _listing = listings[_listingId];
1486 		uint256 _amount = _listing.buyers[_buyer].amount;
1487 		require(_amount > 0, "insufficient balance");
1488 		_listing.buyers[_buyer].amount = 0;
1489 		_listing.amount -= _amount;
1490 		_listing.reservePrice = _listing.amount;
1491 		balances[_listing.paymentToken] -= _amount;
1492 		_safeTransfer(_listing.paymentToken, _buyer, _amount);
1493 		emit Leave(_listingId, _buyer, _amount);
1494 	}
1495 
1496 	function acquire(uint256 _listingId, uint256 _minReservePrice) public nonReentrant inState(_listingId, State.Created)
1497 	{
1498 		address payable _seller = msg.sender;
1499 		ListingInfo storage _listing = listings[_listingId];
1500 		require(_listing.reservePrice >= _minReservePrice, "price slippage");
1501 		IERC721(_listing.collection).transferFrom(_seller, address(this), _listing.tokenId);
1502 		items[_listing.collection][_listing.tokenId] = true;
1503 		_listing.state = State.Acquired;
1504 		_listing.seller = _seller;
1505 		emit Acquired(_listingId);
1506 	}
1507 
1508 	function flashAcquire(uint256 _listingId, uint256 _minReservePrice, address payable _to, bytes calldata _data) external inState(_listingId, State.Created)
1509 	{
1510 		ListingInfo storage _listing = listings[_listingId];
1511 		require(_listing.reservePrice >= _minReservePrice, "price slippage");
1512 		_listing.state = State.Ended;
1513 		_listing.seller = _to;
1514 		payout(_listingId);
1515 		_listing.state = State.Created;
1516 		_listing.seller = address(0);
1517 		FlashAcquireCallee(_to).flashAcquireCall(msg.sender, _listingId, _data);
1518 		require(_listing.state == State.Acquired, "not acquired");
1519 		require(_listing.seller == _to, "unexpected seller");
1520 	}
1521 
1522 	function relist(uint256 _listingId) public nonReentrant inState(_listingId, State.Acquired)
1523 	{
1524 		ListingInfo storage _listing = listings[_listingId];
1525 		uint256 _fractionPrice = (_listing.reservePrice + (FRACTIONS_COUNT - 1)) / FRACTIONS_COUNT;
1526 		uint256 _relistFractionPrice = (_listing.priceMultiplier * _fractionPrice + 99) / 100;
1527 		_listing.state = State.Ended;
1528 		_listing.fractions = _fractionalize(_listingId, _relistFractionPrice);
1529 		_listing.fractionsCount = _balanceOf(_listing.fractions);
1530 		items[_listing.collection][_listing.tokenId] = false;
1531 		balances[_listing.fractions] = _listing.fractionsCount;
1532 		emit Relisted(_listingId);
1533 	}
1534 
1535 	function payout(uint256 _listingId) public nonReentrant inState(_listingId, State.Ended)
1536 	{
1537 		ListingInfo storage _listing = listings[_listingId];
1538 		CreatorInfo storage _creator = creators[_listingId];
1539 		uint256 _amount = _listing.amount;
1540 		require(_amount > 0, "insufficient balance");
1541 		uint256 _feeAmount = (_amount * _listing.fee) / 1e18;
1542 		uint256 _creatorFeeAmount = (_amount * _creator.fee) / 1e18;
1543 		uint256 _netAmount = _amount - (_feeAmount + _creatorFeeAmount);
1544 		_listing.amount = 0;
1545 		balances[_listing.paymentToken] -= _amount;
1546 		_safeTransfer(_listing.paymentToken, _creator.creator, _creatorFeeAmount);
1547 		_safeTransfer(_listing.paymentToken, vault, _feeAmount);
1548 		_safeTransfer(_listing.paymentToken, _listing.seller, _netAmount);
1549 		emit Payout(_listingId, _listing.seller, _netAmount, _feeAmount, _creatorFeeAmount);
1550 	}
1551 
1552 	function claim(uint256 _listingId, address payable _buyer) public nonReentrant inState(_listingId, State.Ended)
1553 	{
1554 		ListingInfo storage _listing = listings[_listingId];
1555 		uint256 _amount = _listing.buyers[_buyer].amount;
1556 		require(_amount > 0, "insufficient balance");
1557 		uint256 _fractionsCount = (_amount * _listing.fractionsCount) / _listing.reservePrice;
1558 		_listing.buyers[_buyer].amount = 0;
1559 		balances[_listing.fractions] -= _fractionsCount;
1560 		_safeTransfer(_listing.fractions, _buyer, _fractionsCount);
1561 		emit Claim(_listingId, _buyer, _amount, _fractionsCount);
1562 	}
1563 
1564 	function relistPayoutAndClaim(uint256 _listingId, address payable[] calldata _buyers) external
1565 	{
1566 		ListingInfo storage _listing = listings[_listingId];
1567 		if (_listing.state != State.Ended) {
1568 			relist(_listingId);
1569 		}
1570 		if (_listing.amount > 0) {
1571 			payout(_listingId);
1572 		}
1573 		for (uint256 _i = 0; _i < _buyers.length; _i++) {
1574 			address payable _buyer = _buyers[_i];
1575 			if (_listing.buyers[_buyer].amount > 0) {
1576 				claim(_listingId, _buyer);
1577 			}
1578 		}
1579 	}
1580 
1581 	function recoverLostFunds(address _token, address payable _to) external onlyOwner nonReentrant
1582 	{
1583 		uint256 _balance = balances[_token];
1584 		uint256 _current = _balanceOf(_token);
1585 		if (_current > _balance) {
1586 			uint256 _excess = _current - _balance;
1587 			_safeTransfer(_token, _to, _excess);
1588 		}
1589 	}
1590 
1591 	function recoverLostItem(address _collection, uint256 _tokenId, address _to) external onlyOwner nonReentrant
1592 	{
1593 		if (items[_collection][_tokenId]) return;
1594 		IERC721(_collection).safeTransfer(_to, _tokenId);
1595 	}
1596 
1597 	function _validate(bytes calldata _extra) internal view
1598 	{
1599 		(bytes32 _type,,, uint256 _duration, uint256 _fee) = abi.decode(_extra, (bytes32, string, string, uint256, uint256));
1600 		require(fractionalizers[_type] != address(0), "unsupported type");
1601 		require(30 minutes <= _duration && _duration <= 731 days, "invalid duration");
1602 		require(_fee <= 100e16, "invalid fee");
1603 	}
1604 
1605 	function _issuing(bytes storage _extra) internal pure returns (uint256 _fractionsCount)
1606 	{
1607 		(,,,, uint256 _fee) = abi.decode(_extra, (bytes32, string, string, uint256, uint256));
1608 		return FRACTIONS_COUNT - (FRACTIONS_COUNT * _fee / 1e18);
1609 	}
1610 
1611 	function _fractionalize(uint256 _listingId, uint256 _fractionPrice) internal returns (address _fractions)
1612 	{
1613 		ListingInfo storage _listing = listings[_listingId];
1614 		(bytes32 _type, string memory _name, string memory _symbol, uint256 _duration, uint256 _fee) = abi.decode(_listing.extra, (bytes32, string, string, uint256, uint256));
1615 		IERC721(_listing.collection).approve(fractionalizers[_type], _listing.tokenId);
1616 		return IAuctionFractionalizer(fractionalizers[_type]).fractionalize(_listing.collection, _listing.tokenId, _name, _symbol, FRACTIONS_DECIMALS, FRACTIONS_COUNT, _fractionPrice, _listing.paymentToken, 0, _duration, _fee);
1617 	}
1618 
1619 	function _balanceOf(address _token) internal view returns (uint256 _balance)
1620 	{
1621 		if (_token == address(0)) {
1622 			return address(this).balance;
1623 		} else {
1624 			return IERC20(_token).balanceOf(address(this));
1625 		}
1626 	}
1627 
1628 	function _safeTransfer(address _token, address payable _to, uint256 _amount) internal
1629 	{
1630 		if (_token == address(0)) {
1631 			_to.transfer(_amount);
1632 		} else {
1633 			IERC20(_token).safeTransfer(_to, _amount);
1634 		}
1635 	}
1636 
1637 	function _safeTransferFrom(address _token, address payable _from, uint256 _value, address payable _to, uint256 _amount) internal
1638 	{
1639 		if (_token == address(0)) {
1640 			require(_value == _amount, "invalid value");
1641 			if (_to != address(this)) _to.transfer(_amount);
1642 		} else {
1643 			require(_value == 0, "invalid value");
1644 			IERC20(_token).safeTransferFrom(_from, _to, _amount);
1645 		}
1646 	}
1647 
1648 	event UpdateFee(uint256 _fee);
1649 	event UpdateCreatorFee(uint256 indexed _listingId, uint256 _fee);
1650 	event AddFractionalizer(bytes32 indexed _type, address indexed _fractionalizer);
1651 	event Listed(uint256 indexed _listingId, address indexed _creator);
1652 	event Acquired(uint256 indexed _listingId);
1653 	event Relisted(uint256 indexed _listingId);
1654 	event Join(uint256 indexed _listingId, address indexed _buyer, uint256 _amount);
1655 	event Leave(uint256 indexed _listingId, address indexed _buyer, uint256 _amount);
1656 	event Payout(uint256 indexed _listingId, address indexed _seller, uint256 _netAmount, uint256 _feeAmount, uint256 _creatorFeeAmount);
1657 	event Claim(uint256 indexed _listingId, address indexed _buyer, uint256 _amount, uint256 _fractionsCount);
1658 }
1659 
1660 // File: contracts/v1.5/ExternalAcquirer.sol
1661 
1662 pragma solidity 0.6.12;
1663 
1664 
1665 
1666 
1667 contract ExternalAcquirer is FlashAcquireCallee
1668 {
1669 	using SafeERC20 for IERC20;
1670 	using Address for address payable;
1671 
1672 	address immutable public collective;
1673 	address payable immutable public vault;
1674 
1675 	constructor (address _collective) public
1676 	{
1677 		collective = _collective;
1678 		vault = OpenCollectivePurchase(_collective).vault();
1679 	}
1680 
1681 	function acquire(uint256 _listingId, bool _relist, bytes calldata _data) external
1682 	{
1683 		OpenCollectivePurchase(collective).flashAcquire(_listingId, 0, address(this), _data);
1684 		if (_relist) {
1685 			OpenCollectivePurchase(collective).relist(_listingId);
1686 		}
1687 	}
1688 
1689 	function flashAcquireCall(address _source, uint256 _listingId, bytes calldata _data) external override
1690 	{
1691 		require(msg.sender == collective, "invalid sender");
1692 		require(_source == address(this), "invalid source");
1693 		(address _spender, address _target, bytes memory _calldata) = abi.decode(_data, (address, address, bytes));
1694 		(,,address _collection, uint256 _tokenId,, address _paymentToken,,,,,,,) = OpenCollectivePurchase(collective).listings(_listingId);
1695 		if (_paymentToken == address(0)) {
1696 			uint256 _balance = address(this).balance;
1697 			(bool _success, bytes memory _returndata) = _target.call{value: _balance}(_calldata);
1698 			require(_success, string(_returndata));
1699 			_balance = address(this).balance;
1700 			if (_balance > 0) {
1701 				vault.sendValue(_balance);
1702 			}
1703 		} else {
1704 			uint256 _balance = IERC20(_paymentToken).balanceOf(address(this));
1705 			IERC20(_paymentToken).safeApprove(_spender, _balance);
1706 			(bool _success, bytes memory _returndata) = _target.call(_calldata);
1707 			require(_success, string(_returndata));
1708 			IERC20(_paymentToken).safeApprove(_spender, 0);
1709 			_balance = IERC20(_paymentToken).balanceOf(address(this));
1710 			if (_balance > 0) {
1711 				IERC20(_paymentToken).safeTransfer(vault, _balance);
1712 			}
1713 		}
1714 		IERC721(_collection).approve(collective, _tokenId);
1715 		OpenCollectivePurchase(collective).acquire(_listingId, 0);
1716 	}
1717 
1718 	receive() external payable
1719 	{
1720 	}
1721 }