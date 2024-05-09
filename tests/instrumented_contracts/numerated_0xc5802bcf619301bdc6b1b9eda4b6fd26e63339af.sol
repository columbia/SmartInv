1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 // SPDX-License-Identifier: MIT
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 // SPDX-License-Identifier: MIT
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/GSN/Context.sol
465 
466 // SPDX-License-Identifier: MIT
467 
468 pragma solidity ^0.6.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/introspection/IERC165.sol
492 
493 // SPDX-License-Identifier: MIT
494 
495 pragma solidity ^0.6.0;
496 
497 /**
498  * @dev Interface of the ERC165 standard, as defined in the
499  * https://eips.ethereum.org/EIPS/eip-165[EIP].
500  *
501  * Implementers can declare support of contract interfaces, which can then be
502  * queried by others ({ERC165Checker}).
503  *
504  * For an implementation, see {ERC165}.
505  */
506 interface IERC165 {
507     /**
508      * @dev Returns true if this contract implements the interface defined by
509      * `interfaceId`. See the corresponding
510      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
511      * to learn more about how these ids are created.
512      *
513      * This function call must use less than 30 000 gas.
514      */
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
519 
520 // SPDX-License-Identifier: MIT
521 
522 pragma solidity ^0.6.2;
523 
524 
525 /**
526  * @dev Required interface of an ERC721 compliant contract.
527  */
528 interface IERC721 is IERC165 {
529     /**
530      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
531      */
532     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
536      */
537     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(address from, address to, uint256 tokenId) external;
573 
574     /**
575      * @dev Transfers `tokenId` token from `from` to `to`.
576      *
577      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      *
586      * Emits a {Transfer} event.
587      */
588     function transferFrom(address from, address to, uint256 tokenId) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Approve or remove `operator` as an operator for the caller.
616      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
617      *
618      * Requirements:
619      *
620      * - The `operator` cannot be the caller.
621      *
622      * Emits an {ApprovalForAll} event.
623      */
624     function setApprovalForAll(address operator, bool _approved) external;
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 
633     /**
634       * @dev Safely transfers `tokenId` token from `from` to `to`.
635       *
636       * Requirements:
637       *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640       * - `tokenId` token must exist and be owned by `from`.
641       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643       *
644       * Emits a {Transfer} event.
645       */
646     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
650 
651 // SPDX-License-Identifier: MIT
652 
653 pragma solidity ^0.6.2;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661 
662     /**
663      * @dev Returns the token collection name.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the token collection symbol.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
679 
680 // SPDX-License-Identifier: MIT
681 
682 pragma solidity ^0.6.2;
683 
684 
685 /**
686  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
687  * @dev See https://eips.ethereum.org/EIPS/eip-721
688  */
689 interface IERC721Enumerable is IERC721 {
690 
691     /**
692      * @dev Returns the total amount of tokens stored by the contract.
693      */
694     function totalSupply() external view returns (uint256);
695 
696     /**
697      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
698      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
699      */
700     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
701 
702     /**
703      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
704      * Use along with {totalSupply} to enumerate all tokens.
705      */
706     function tokenByIndex(uint256 index) external view returns (uint256);
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
710 
711 // SPDX-License-Identifier: MIT
712 
713 pragma solidity ^0.6.0;
714 
715 /**
716  * @title ERC721 token receiver interface
717  * @dev Interface for any contract that wants to support safeTransfers
718  * from ERC721 asset contracts.
719  */
720 interface IERC721Receiver {
721     /**
722      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
723      * by `operator` from `from`, this function is called.
724      *
725      * It must return its Solidity selector to confirm the token transfer.
726      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
727      *
728      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
729      */
730     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
731     external returns (bytes4);
732 }
733 
734 // File: @openzeppelin/contracts/introspection/ERC165.sol
735 
736 // SPDX-License-Identifier: MIT
737 
738 pragma solidity ^0.6.0;
739 
740 
741 /**
742  * @dev Implementation of the {IERC165} interface.
743  *
744  * Contracts may inherit from this and call {_registerInterface} to declare
745  * their support of an interface.
746  */
747 contract ERC165 is IERC165 {
748     /*
749      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
750      */
751     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
752 
753     /**
754      * @dev Mapping of interface ids to whether or not it's supported.
755      */
756     mapping(bytes4 => bool) private _supportedInterfaces;
757 
758     constructor () internal {
759         // Derived contracts need only register support for their own interfaces,
760         // we register support for ERC165 itself here
761         _registerInterface(_INTERFACE_ID_ERC165);
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      *
767      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
768      */
769     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
770         return _supportedInterfaces[interfaceId];
771     }
772 
773     /**
774      * @dev Registers the contract as an implementer of the interface defined by
775      * `interfaceId`. Support of the actual ERC165 interface is automatic and
776      * registering its interface id is not required.
777      *
778      * See {IERC165-supportsInterface}.
779      *
780      * Requirements:
781      *
782      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
783      */
784     function _registerInterface(bytes4 interfaceId) internal virtual {
785         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
786         _supportedInterfaces[interfaceId] = true;
787     }
788 }
789 
790 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
791 
792 // SPDX-License-Identifier: MIT
793 
794 pragma solidity ^0.6.0;
795 
796 /**
797  * @dev Library for managing
798  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
799  * types.
800  *
801  * Sets have the following properties:
802  *
803  * - Elements are added, removed, and checked for existence in constant time
804  * (O(1)).
805  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
806  *
807  * ```
808  * contract Example {
809  *     // Add the library methods
810  *     using EnumerableSet for EnumerableSet.AddressSet;
811  *
812  *     // Declare a set state variable
813  *     EnumerableSet.AddressSet private mySet;
814  * }
815  * ```
816  *
817  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
818  * (`UintSet`) are supported.
819  */
820 library EnumerableSet {
821     // To implement this library for multiple types with as little code
822     // repetition as possible, we write it in terms of a generic Set type with
823     // bytes32 values.
824     // The Set implementation uses private functions, and user-facing
825     // implementations (such as AddressSet) are just wrappers around the
826     // underlying Set.
827     // This means that we can only create new EnumerableSets for types that fit
828     // in bytes32.
829 
830     struct Set {
831         // Storage of set values
832         bytes32[] _values;
833 
834         // Position of the value in the `values` array, plus 1 because index 0
835         // means a value is not in the set.
836         mapping (bytes32 => uint256) _indexes;
837     }
838 
839     /**
840      * @dev Add a value to a set. O(1).
841      *
842      * Returns true if the value was added to the set, that is if it was not
843      * already present.
844      */
845     function _add(Set storage set, bytes32 value) private returns (bool) {
846         if (!_contains(set, value)) {
847             set._values.push(value);
848             // The value is stored at length-1, but we add 1 to all indexes
849             // and use 0 as a sentinel value
850             set._indexes[value] = set._values.length;
851             return true;
852         } else {
853             return false;
854         }
855     }
856 
857     /**
858      * @dev Removes a value from a set. O(1).
859      *
860      * Returns true if the value was removed from the set, that is if it was
861      * present.
862      */
863     function _remove(Set storage set, bytes32 value) private returns (bool) {
864         // We read and store the value's index to prevent multiple reads from the same storage slot
865         uint256 valueIndex = set._indexes[value];
866 
867         if (valueIndex != 0) { // Equivalent to contains(set, value)
868             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
869             // the array, and then remove the last element (sometimes called as 'swap and pop').
870             // This modifies the order of the array, as noted in {at}.
871 
872             uint256 toDeleteIndex = valueIndex - 1;
873             uint256 lastIndex = set._values.length - 1;
874 
875             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
876             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
877 
878             bytes32 lastvalue = set._values[lastIndex];
879 
880             // Move the last value to the index where the value to delete is
881             set._values[toDeleteIndex] = lastvalue;
882             // Update the index for the moved value
883             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
884 
885             // Delete the slot where the moved value was stored
886             set._values.pop();
887 
888             // Delete the index for the deleted slot
889             delete set._indexes[value];
890 
891             return true;
892         } else {
893             return false;
894         }
895     }
896 
897     /**
898      * @dev Returns true if the value is in the set. O(1).
899      */
900     function _contains(Set storage set, bytes32 value) private view returns (bool) {
901         return set._indexes[value] != 0;
902     }
903 
904     /**
905      * @dev Returns the number of values on the set. O(1).
906      */
907     function _length(Set storage set) private view returns (uint256) {
908         return set._values.length;
909     }
910 
911    /**
912     * @dev Returns the value stored at position `index` in the set. O(1).
913     *
914     * Note that there are no guarantees on the ordering of values inside the
915     * array, and it may change when more values are added or removed.
916     *
917     * Requirements:
918     *
919     * - `index` must be strictly less than {length}.
920     */
921     function _at(Set storage set, uint256 index) private view returns (bytes32) {
922         require(set._values.length > index, "EnumerableSet: index out of bounds");
923         return set._values[index];
924     }
925 
926     // AddressSet
927 
928     struct AddressSet {
929         Set _inner;
930     }
931 
932     /**
933      * @dev Add a value to a set. O(1).
934      *
935      * Returns true if the value was added to the set, that is if it was not
936      * already present.
937      */
938     function add(AddressSet storage set, address value) internal returns (bool) {
939         return _add(set._inner, bytes32(uint256(value)));
940     }
941 
942     /**
943      * @dev Removes a value from a set. O(1).
944      *
945      * Returns true if the value was removed from the set, that is if it was
946      * present.
947      */
948     function remove(AddressSet storage set, address value) internal returns (bool) {
949         return _remove(set._inner, bytes32(uint256(value)));
950     }
951 
952     /**
953      * @dev Returns true if the value is in the set. O(1).
954      */
955     function contains(AddressSet storage set, address value) internal view returns (bool) {
956         return _contains(set._inner, bytes32(uint256(value)));
957     }
958 
959     /**
960      * @dev Returns the number of values in the set. O(1).
961      */
962     function length(AddressSet storage set) internal view returns (uint256) {
963         return _length(set._inner);
964     }
965 
966    /**
967     * @dev Returns the value stored at position `index` in the set. O(1).
968     *
969     * Note that there are no guarantees on the ordering of values inside the
970     * array, and it may change when more values are added or removed.
971     *
972     * Requirements:
973     *
974     * - `index` must be strictly less than {length}.
975     */
976     function at(AddressSet storage set, uint256 index) internal view returns (address) {
977         return address(uint256(_at(set._inner, index)));
978     }
979 
980 
981     // UintSet
982 
983     struct UintSet {
984         Set _inner;
985     }
986 
987     /**
988      * @dev Add a value to a set. O(1).
989      *
990      * Returns true if the value was added to the set, that is if it was not
991      * already present.
992      */
993     function add(UintSet storage set, uint256 value) internal returns (bool) {
994         return _add(set._inner, bytes32(value));
995     }
996 
997     /**
998      * @dev Removes a value from a set. O(1).
999      *
1000      * Returns true if the value was removed from the set, that is if it was
1001      * present.
1002      */
1003     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1004         return _remove(set._inner, bytes32(value));
1005     }
1006 
1007     /**
1008      * @dev Returns true if the value is in the set. O(1).
1009      */
1010     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1011         return _contains(set._inner, bytes32(value));
1012     }
1013 
1014     /**
1015      * @dev Returns the number of values on the set. O(1).
1016      */
1017     function length(UintSet storage set) internal view returns (uint256) {
1018         return _length(set._inner);
1019     }
1020 
1021    /**
1022     * @dev Returns the value stored at position `index` in the set. O(1).
1023     *
1024     * Note that there are no guarantees on the ordering of values inside the
1025     * array, and it may change when more values are added or removed.
1026     *
1027     * Requirements:
1028     *
1029     * - `index` must be strictly less than {length}.
1030     */
1031     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1032         return uint256(_at(set._inner, index));
1033     }
1034 }
1035 
1036 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1037 
1038 // SPDX-License-Identifier: MIT
1039 
1040 pragma solidity ^0.6.0;
1041 
1042 /**
1043  * @dev Library for managing an enumerable variant of Solidity's
1044  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1045  * type.
1046  *
1047  * Maps have the following properties:
1048  *
1049  * - Entries are added, removed, and checked for existence in constant time
1050  * (O(1)).
1051  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1052  *
1053  * ```
1054  * contract Example {
1055  *     // Add the library methods
1056  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1057  *
1058  *     // Declare a set state variable
1059  *     EnumerableMap.UintToAddressMap private myMap;
1060  * }
1061  * ```
1062  *
1063  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1064  * supported.
1065  */
1066 library EnumerableMap {
1067     // To implement this library for multiple types with as little code
1068     // repetition as possible, we write it in terms of a generic Map type with
1069     // bytes32 keys and values.
1070     // The Map implementation uses private functions, and user-facing
1071     // implementations (such as Uint256ToAddressMap) are just wrappers around
1072     // the underlying Map.
1073     // This means that we can only create new EnumerableMaps for types that fit
1074     // in bytes32.
1075 
1076     struct MapEntry {
1077         bytes32 _key;
1078         bytes32 _value;
1079     }
1080 
1081     struct Map {
1082         // Storage of map keys and values
1083         MapEntry[] _entries;
1084 
1085         // Position of the entry defined by a key in the `entries` array, plus 1
1086         // because index 0 means a key is not in the map.
1087         mapping (bytes32 => uint256) _indexes;
1088     }
1089 
1090     /**
1091      * @dev Adds a key-value pair to a map, or updates the value for an existing
1092      * key. O(1).
1093      *
1094      * Returns true if the key was added to the map, that is if it was not
1095      * already present.
1096      */
1097     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1098         // We read and store the key's index to prevent multiple reads from the same storage slot
1099         uint256 keyIndex = map._indexes[key];
1100 
1101         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1102             map._entries.push(MapEntry({ _key: key, _value: value }));
1103             // The entry is stored at length-1, but we add 1 to all indexes
1104             // and use 0 as a sentinel value
1105             map._indexes[key] = map._entries.length;
1106             return true;
1107         } else {
1108             map._entries[keyIndex - 1]._value = value;
1109             return false;
1110         }
1111     }
1112 
1113     /**
1114      * @dev Removes a key-value pair from a map. O(1).
1115      *
1116      * Returns true if the key was removed from the map, that is if it was present.
1117      */
1118     function _remove(Map storage map, bytes32 key) private returns (bool) {
1119         // We read and store the key's index to prevent multiple reads from the same storage slot
1120         uint256 keyIndex = map._indexes[key];
1121 
1122         if (keyIndex != 0) { // Equivalent to contains(map, key)
1123             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1124             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1125             // This modifies the order of the array, as noted in {at}.
1126 
1127             uint256 toDeleteIndex = keyIndex - 1;
1128             uint256 lastIndex = map._entries.length - 1;
1129 
1130             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1131             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1132 
1133             MapEntry storage lastEntry = map._entries[lastIndex];
1134 
1135             // Move the last entry to the index where the entry to delete is
1136             map._entries[toDeleteIndex] = lastEntry;
1137             // Update the index for the moved entry
1138             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1139 
1140             // Delete the slot where the moved entry was stored
1141             map._entries.pop();
1142 
1143             // Delete the index for the deleted slot
1144             delete map._indexes[key];
1145 
1146             return true;
1147         } else {
1148             return false;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Returns true if the key is in the map. O(1).
1154      */
1155     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1156         return map._indexes[key] != 0;
1157     }
1158 
1159     /**
1160      * @dev Returns the number of key-value pairs in the map. O(1).
1161      */
1162     function _length(Map storage map) private view returns (uint256) {
1163         return map._entries.length;
1164     }
1165 
1166    /**
1167     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1168     *
1169     * Note that there are no guarantees on the ordering of entries inside the
1170     * array, and it may change when more entries are added or removed.
1171     *
1172     * Requirements:
1173     *
1174     * - `index` must be strictly less than {length}.
1175     */
1176     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1177         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1178 
1179         MapEntry storage entry = map._entries[index];
1180         return (entry._key, entry._value);
1181     }
1182 
1183     /**
1184      * @dev Returns the value associated with `key`.  O(1).
1185      *
1186      * Requirements:
1187      *
1188      * - `key` must be in the map.
1189      */
1190     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1191         return _get(map, key, "EnumerableMap: nonexistent key");
1192     }
1193 
1194     /**
1195      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1196      */
1197     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1198         uint256 keyIndex = map._indexes[key];
1199         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1200         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1201     }
1202 
1203     // UintToAddressMap
1204 
1205     struct UintToAddressMap {
1206         Map _inner;
1207     }
1208 
1209     /**
1210      * @dev Adds a key-value pair to a map, or updates the value for an existing
1211      * key. O(1).
1212      *
1213      * Returns true if the key was added to the map, that is if it was not
1214      * already present.
1215      */
1216     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1217         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1218     }
1219 
1220     /**
1221      * @dev Removes a value from a set. O(1).
1222      *
1223      * Returns true if the key was removed from the map, that is if it was present.
1224      */
1225     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1226         return _remove(map._inner, bytes32(key));
1227     }
1228 
1229     /**
1230      * @dev Returns true if the key is in the map. O(1).
1231      */
1232     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1233         return _contains(map._inner, bytes32(key));
1234     }
1235 
1236     /**
1237      * @dev Returns the number of elements in the map. O(1).
1238      */
1239     function length(UintToAddressMap storage map) internal view returns (uint256) {
1240         return _length(map._inner);
1241     }
1242 
1243    /**
1244     * @dev Returns the element stored at position `index` in the set. O(1).
1245     * Note that there are no guarantees on the ordering of values inside the
1246     * array, and it may change when more values are added or removed.
1247     *
1248     * Requirements:
1249     *
1250     * - `index` must be strictly less than {length}.
1251     */
1252     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1253         (bytes32 key, bytes32 value) = _at(map._inner, index);
1254         return (uint256(key), address(uint256(value)));
1255     }
1256 
1257     /**
1258      * @dev Returns the value associated with `key`.  O(1).
1259      *
1260      * Requirements:
1261      *
1262      * - `key` must be in the map.
1263      */
1264     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1265         return address(uint256(_get(map._inner, bytes32(key))));
1266     }
1267 
1268     /**
1269      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1270      */
1271     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1272         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1273     }
1274 }
1275 
1276 // File: @openzeppelin/contracts/utils/Strings.sol
1277 
1278 // SPDX-License-Identifier: MIT
1279 
1280 pragma solidity ^0.6.0;
1281 
1282 /**
1283  * @dev String operations.
1284  */
1285 library Strings {
1286     /**
1287      * @dev Converts a `uint256` to its ASCII `string` representation.
1288      */
1289     function toString(uint256 value) internal pure returns (string memory) {
1290         // Inspired by OraclizeAPI's implementation - MIT licence
1291         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1292 
1293         if (value == 0) {
1294             return "0";
1295         }
1296         uint256 temp = value;
1297         uint256 digits;
1298         while (temp != 0) {
1299             digits++;
1300             temp /= 10;
1301         }
1302         bytes memory buffer = new bytes(digits);
1303         uint256 index = digits - 1;
1304         temp = value;
1305         while (temp != 0) {
1306             buffer[index--] = byte(uint8(48 + temp % 10));
1307             temp /= 10;
1308         }
1309         return string(buffer);
1310     }
1311 }
1312 
1313 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1314 
1315 // SPDX-License-Identifier: MIT
1316 
1317 pragma solidity ^0.6.0;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 
1330 /**
1331  * @title ERC721 Non-Fungible Token Standard basic implementation
1332  * @dev see https://eips.ethereum.org/EIPS/eip-721
1333  */
1334 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1335     using SafeMath for uint256;
1336     using Address for address;
1337     using EnumerableSet for EnumerableSet.UintSet;
1338     using EnumerableMap for EnumerableMap.UintToAddressMap;
1339     using Strings for uint256;
1340 
1341     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1342     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1343     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1344 
1345     // Mapping from holder address to their (enumerable) set of owned tokens
1346     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1347 
1348     // Enumerable mapping from token ids to their owners
1349     EnumerableMap.UintToAddressMap private _tokenOwners;
1350 
1351     // Mapping from token ID to approved address
1352     mapping (uint256 => address) private _tokenApprovals;
1353 
1354     // Mapping from owner to operator approvals
1355     mapping (address => mapping (address => bool)) private _operatorApprovals;
1356 
1357     // Token name
1358     string private _name;
1359 
1360     // Token symbol
1361     string private _symbol;
1362 
1363     // Optional mapping for token URIs
1364     mapping (uint256 => string) private _tokenURIs;
1365 
1366     // Base URI
1367     string private _baseURI;
1368 
1369     /*
1370      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1371      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1372      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1373      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1374      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1375      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1376      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1377      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1378      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1379      *
1380      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1381      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1382      */
1383     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1384 
1385     /*
1386      *     bytes4(keccak256('name()')) == 0x06fdde03
1387      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1388      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1389      *
1390      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1391      */
1392     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1393 
1394     /*
1395      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1396      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1397      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1398      *
1399      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1400      */
1401     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1402 
1403     /**
1404      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1405      */
1406     constructor (string memory name, string memory symbol) public {
1407         _name = name;
1408         _symbol = symbol;
1409 
1410         // register the supported interfaces to conform to ERC721 via ERC165
1411         _registerInterface(_INTERFACE_ID_ERC721);
1412         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1413         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-balanceOf}.
1418      */
1419     function balanceOf(address owner) public view override returns (uint256) {
1420         require(owner != address(0), "ERC721: balance query for the zero address");
1421 
1422         return _holderTokens[owner].length();
1423     }
1424 
1425     /**
1426      * @dev See {IERC721-ownerOf}.
1427      */
1428     function ownerOf(uint256 tokenId) public view override returns (address) {
1429         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Metadata-name}.
1434      */
1435     function name() public view override returns (string memory) {
1436         return _name;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Metadata-symbol}.
1441      */
1442     function symbol() public view override returns (string memory) {
1443         return _symbol;
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Metadata-tokenURI}.
1448      */
1449     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1450         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1451 
1452         string memory _tokenURI = _tokenURIs[tokenId];
1453 
1454         // If there is no base URI, return the token URI.
1455         if (bytes(_baseURI).length == 0) {
1456             return _tokenURI;
1457         }
1458         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1459         if (bytes(_tokenURI).length > 0) {
1460             return string(abi.encodePacked(_baseURI, _tokenURI));
1461         }
1462         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1463         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1464     }
1465 
1466     /**
1467     * @dev Returns the base URI set via {_setBaseURI}. This will be
1468     * automatically added as a prefix in {tokenURI} to each token's URI, or
1469     * to the token ID if no specific URI is set for that token ID.
1470     */
1471     function baseURI() public view returns (string memory) {
1472         return _baseURI;
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1477      */
1478     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1479         return _holderTokens[owner].at(index);
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Enumerable-totalSupply}.
1484      */
1485     function totalSupply() public view override returns (uint256) {
1486         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1487         return _tokenOwners.length();
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Enumerable-tokenByIndex}.
1492      */
1493     function tokenByIndex(uint256 index) public view override returns (uint256) {
1494         (uint256 tokenId, ) = _tokenOwners.at(index);
1495         return tokenId;
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-approve}.
1500      */
1501     function approve(address to, uint256 tokenId) public virtual override {
1502         address owner = ownerOf(tokenId);
1503         require(to != owner, "ERC721: approval to current owner");
1504 
1505         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1506             "ERC721: approve caller is not owner nor approved for all"
1507         );
1508 
1509         _approve(to, tokenId);
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-getApproved}.
1514      */
1515     function getApproved(uint256 tokenId) public view override returns (address) {
1516         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1517 
1518         return _tokenApprovals[tokenId];
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-setApprovalForAll}.
1523      */
1524     function setApprovalForAll(address operator, bool approved) public virtual override {
1525         require(operator != _msgSender(), "ERC721: approve to caller");
1526 
1527         _operatorApprovals[_msgSender()][operator] = approved;
1528         emit ApprovalForAll(_msgSender(), operator, approved);
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-isApprovedForAll}.
1533      */
1534     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1535         return _operatorApprovals[owner][operator];
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-transferFrom}.
1540      */
1541     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1542         //solhint-disable-next-line max-line-length
1543         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1544 
1545         _transfer(from, to, tokenId);
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-safeTransferFrom}.
1550      */
1551     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1552         safeTransferFrom(from, to, tokenId, "");
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-safeTransferFrom}.
1557      */
1558     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1559         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1560         _safeTransfer(from, to, tokenId, _data);
1561     }
1562 
1563     /**
1564      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1565      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1566      *
1567      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1568      *
1569      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1570      * implement alternative mechanisms to perform token transfer, such as signature-based.
1571      *
1572      * Requirements:
1573      *
1574      * - `from` cannot be the zero address.
1575      * - `to` cannot be the zero address.
1576      * - `tokenId` token must exist and be owned by `from`.
1577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1582         _transfer(from, to, tokenId);
1583         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1584     }
1585 
1586     /**
1587      * @dev Returns whether `tokenId` exists.
1588      *
1589      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1590      *
1591      * Tokens start existing when they are minted (`_mint`),
1592      * and stop existing when they are burned (`_burn`).
1593      */
1594     function _exists(uint256 tokenId) internal view returns (bool) {
1595         return _tokenOwners.contains(tokenId);
1596     }
1597 
1598     /**
1599      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1600      *
1601      * Requirements:
1602      *
1603      * - `tokenId` must exist.
1604      */
1605     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1606         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1607         address owner = ownerOf(tokenId);
1608         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1609     }
1610 
1611     /**
1612      * @dev Safely mints `tokenId` and transfers it to `to`.
1613      *
1614      * Requirements:
1615      d*
1616      * - `tokenId` must not exist.
1617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1618      *
1619      * Emits a {Transfer} event.
1620      */
1621     function _safeMint(address to, uint256 tokenId) internal virtual {
1622         _safeMint(to, tokenId, "");
1623     }
1624 
1625     /**
1626      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1627      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1628      */
1629     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1630         _mint(to, tokenId);
1631         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1632     }
1633 
1634     /**
1635      * @dev Mints `tokenId` and transfers it to `to`.
1636      *
1637      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1638      *
1639      * Requirements:
1640      *
1641      * - `tokenId` must not exist.
1642      * - `to` cannot be the zero address.
1643      *
1644      * Emits a {Transfer} event.
1645      */
1646     function _mint(address to, uint256 tokenId) internal virtual {
1647         require(to != address(0), "ERC721: mint to the zero address");
1648         require(!_exists(tokenId), "ERC721: token already minted");
1649 
1650         _beforeTokenTransfer(address(0), to, tokenId);
1651 
1652         _holderTokens[to].add(tokenId);
1653 
1654         _tokenOwners.set(tokenId, to);
1655 
1656         emit Transfer(address(0), to, tokenId);
1657     }
1658 
1659     /**
1660      * @dev Destroys `tokenId`.
1661      * The approval is cleared when the token is burned.
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must exist.
1666      *
1667      * Emits a {Transfer} event.
1668      */
1669     function _burn(uint256 tokenId) internal virtual {
1670         address owner = ownerOf(tokenId);
1671 
1672         _beforeTokenTransfer(owner, address(0), tokenId);
1673 
1674         // Clear approvals
1675         _approve(address(0), tokenId);
1676 
1677         // Clear metadata (if any)
1678         if (bytes(_tokenURIs[tokenId]).length != 0) {
1679             delete _tokenURIs[tokenId];
1680         }
1681 
1682         _holderTokens[owner].remove(tokenId);
1683 
1684         _tokenOwners.remove(tokenId);
1685 
1686         emit Transfer(owner, address(0), tokenId);
1687     }
1688 
1689     /**
1690      * @dev Transfers `tokenId` from `from` to `to`.
1691      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1692      *
1693      * Requirements:
1694      *
1695      * - `to` cannot be the zero address.
1696      * - `tokenId` token must be owned by `from`.
1697      *
1698      * Emits a {Transfer} event.
1699      */
1700     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1701         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1702         require(to != address(0), "ERC721: transfer to the zero address");
1703 
1704         _beforeTokenTransfer(from, to, tokenId);
1705 
1706         // Clear approvals from the previous owner
1707         _approve(address(0), tokenId);
1708 
1709         _holderTokens[from].remove(tokenId);
1710         _holderTokens[to].add(tokenId);
1711 
1712         _tokenOwners.set(tokenId, to);
1713 
1714         emit Transfer(from, to, tokenId);
1715     }
1716 
1717     /**
1718      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1719      *
1720      * Requirements:
1721      *
1722      * - `tokenId` must exist.
1723      */
1724     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1725         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1726         _tokenURIs[tokenId] = _tokenURI;
1727     }
1728 
1729     /**
1730      * @dev Internal function to set the base URI for all token IDs. It is
1731      * automatically added as a prefix to the value returned in {tokenURI},
1732      * or to the token ID if {tokenURI} is empty.
1733      */
1734     function _setBaseURI(string memory baseURI_) internal virtual {
1735         _baseURI = baseURI_;
1736     }
1737 
1738     /**
1739      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1740      * The call is not executed if the target address is not a contract.
1741      *
1742      * @param from address representing the previous owner of the given token ID
1743      * @param to target address that will receive the tokens
1744      * @param tokenId uint256 ID of the token to be transferred
1745      * @param _data bytes optional data to send along with the call
1746      * @return bool whether the call correctly returned the expected magic value
1747      */
1748     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1749         private returns (bool)
1750     {
1751         if (!to.isContract()) {
1752             return true;
1753         }
1754         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1755             IERC721Receiver(to).onERC721Received.selector,
1756             _msgSender(),
1757             from,
1758             tokenId,
1759             _data
1760         ), "ERC721: transfer to non ERC721Receiver implementer");
1761         bytes4 retval = abi.decode(returndata, (bytes4));
1762         return (retval == _ERC721_RECEIVED);
1763     }
1764 
1765     function _approve(address to, uint256 tokenId) private {
1766         _tokenApprovals[tokenId] = to;
1767         emit Approval(ownerOf(tokenId), to, tokenId);
1768     }
1769 
1770     /**
1771      * @dev Hook that is called before any token transfer. This includes minting
1772      * and burning.
1773      *
1774      * Calling conditions:
1775      *
1776      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1777      * transferred to `to`.
1778      * - When `from` is zero, `tokenId` will be minted for `to`.
1779      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1780      * - `from` cannot be the zero address.
1781      * - `to` cannot be the zero address.
1782      *
1783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1784      */
1785     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1786 }
1787 
1788 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
1789 
1790 // SPDX-License-Identifier: MIT
1791 
1792 pragma solidity ^0.6.0;
1793 
1794 
1795 
1796 /**
1797  * @title ERC721 Burnable Token
1798  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1799  */
1800 abstract contract ERC721Burnable is Context, ERC721 {
1801     /**
1802      * @dev Burns `tokenId`. See {ERC721-_burn}.
1803      *
1804      * Requirements:
1805      *
1806      * - The caller must own `tokenId` or be an approved operator.
1807      */
1808     function burn(uint256 tokenId) public virtual {
1809         //solhint-disable-next-line max-line-length
1810         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1811         _burn(tokenId);
1812     }
1813 }
1814 
1815 // File: @openzeppelin/contracts/utils/Counters.sol
1816 
1817 // SPDX-License-Identifier: MIT
1818 
1819 pragma solidity ^0.6.0;
1820 
1821 
1822 /**
1823  * @title Counters
1824  * @author Matt Condon (@shrugs)
1825  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1826  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1827  *
1828  * Include with `using Counters for Counters.Counter;`
1829  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1830  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1831  * directly accessed.
1832  */
1833 library Counters {
1834     using SafeMath for uint256;
1835 
1836     struct Counter {
1837         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1838         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1839         // this feature: see https://github.com/ethereum/solidity/issues/4637
1840         uint256 _value; // default: 0
1841     }
1842 
1843     function current(Counter storage counter) internal view returns (uint256) {
1844         return counter._value;
1845     }
1846 
1847     function increment(Counter storage counter) internal {
1848         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1849         counter._value += 1;
1850     }
1851 
1852     function decrement(Counter storage counter) internal {
1853         counter._value = counter._value.sub(1);
1854     }
1855 }
1856 
1857 // File: @openzeppelin/contracts/access/Ownable.sol
1858 
1859 // SPDX-License-Identifier: MIT
1860 
1861 pragma solidity ^0.6.0;
1862 
1863 /**
1864  * @dev Contract module which provides a basic access control mechanism, where
1865  * there is an account (an owner) that can be granted exclusive access to
1866  * specific functions.
1867  *
1868  * By default, the owner account will be the one that deploys the contract. This
1869  * can later be changed with {transferOwnership}.
1870  *
1871  * This module is used through inheritance. It will make available the modifier
1872  * `onlyOwner`, which can be applied to your functions to restrict their use to
1873  * the owner.
1874  */
1875 contract Ownable is Context {
1876     address private _owner;
1877 
1878     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1879 
1880     /**
1881      * @dev Initializes the contract setting the deployer as the initial owner.
1882      */
1883     constructor () internal {
1884         address msgSender = _msgSender();
1885         _owner = msgSender;
1886         emit OwnershipTransferred(address(0), msgSender);
1887     }
1888 
1889     /**
1890      * @dev Returns the address of the current owner.
1891      */
1892     function owner() public view returns (address) {
1893         return _owner;
1894     }
1895 
1896     /**
1897      * @dev Throws if called by any account other than the owner.
1898      */
1899     modifier onlyOwner() {
1900         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1901         _;
1902     }
1903 
1904     /**
1905      * @dev Leaves the contract without owner. It will not be possible to call
1906      * `onlyOwner` functions anymore. Can only be called by the current owner.
1907      *
1908      * NOTE: Renouncing ownership will leave the contract without an owner,
1909      * thereby removing any functionality that is only available to the owner.
1910      */
1911     function renounceOwnership() public virtual onlyOwner {
1912         emit OwnershipTransferred(_owner, address(0));
1913         _owner = address(0);
1914     }
1915 
1916     /**
1917      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1918      * Can only be called by the current owner.
1919      */
1920     function transferOwnership(address newOwner) public virtual onlyOwner {
1921         require(newOwner != address(0), "Ownable: new owner is the zero address");
1922         emit OwnershipTransferred(_owner, newOwner);
1923         _owner = newOwner;
1924     }
1925 }
1926 
1927 // File: contracts/NFTStaker.sol
1928 
1929 pragma solidity ^0.6.1;
1930 
1931 
1932 
1933 
1934 
1935 
1936 contract NFTStaker is ERC721Burnable, Ownable {
1937 
1938   using SafeERC20 for IERC20;
1939   using Counters for Counters.Counter;
1940 
1941   struct Stake {
1942     uint256 amount;
1943     uint256 startBlock;
1944     uint256 rewardId;
1945     bool hasMinted;
1946   }
1947 
1948   struct Reward {
1949     address minter;
1950     uint256 amount;
1951     uint256 startBlock;
1952     uint256 endBlock;
1953     bool isStaked;
1954   }
1955 
1956   Counters.Counter private _rewardIds;
1957   IERC20 public token;
1958   uint256 public totalStaked;
1959   string public _contractURI;
1960 
1961   mapping(address => Stake) public stakeRecords;
1962   mapping(uint256 => Reward) public rewardRecords;
1963 
1964   constructor(address tokenAddress, string memory name, string memory symbol, string memory baseURI) ERC721(name, symbol) public {
1965     token = IERC20(tokenAddress);
1966     _setBaseURI(baseURI);
1967   }
1968 
1969   function addStake(uint256 numTokens) public returns(bool){
1970     require(numTokens > 0, "must stake > 0");
1971     require(stakeRecords[msg.sender].amount == 0, "already staking");
1972 
1973     // Update the mapping used to keep track of nfts
1974     _rewardIds.increment();
1975     uint256 currId = _rewardIds.current();
1976     stakeRecords[msg.sender] = Stake(
1977       numTokens,
1978       block.number,
1979       currId,
1980       false
1981     );
1982     // Update the totalStaked count
1983     totalStaked = totalStaked + numTokens;
1984 
1985     // Transfer tokens to contract
1986     token.safeTransferFrom(msg.sender, address(this), numTokens);
1987     return true;
1988   }
1989 
1990   function removeStake() public returns(bool) {
1991     uint256 numTokens = stakeRecords[msg.sender].amount;
1992     uint256 currId = stakeRecords[msg.sender].rewardId;
1993 
1994     require(numTokens > 0, "not staking");
1995 
1996     // Reduce the totalStaked count
1997     totalStaked = totalStaked - numTokens;
1998 
1999     // Remove the mapping
2000     delete stakeRecords[msg.sender];
2001 
2002     // Update the NFT's records
2003     rewardRecords[currId].endBlock = block.number;
2004     rewardRecords[currId].isStaked = false;
2005 
2006     // Transfer the staked tokens back
2007     token.safeTransfer(msg.sender, numTokens);
2008     return true;
2009   }
2010 
2011   function mintReward() public returns (uint256) {
2012     // require stake to be valid before minting
2013     require(stakeRecords[msg.sender].amount > 0, "must be staking");
2014     require(stakeRecords[msg.sender].hasMinted == false, "already minted");
2015 
2016     // set hasMinted to true to prevent multiple mintings per stake
2017     stakeRecords[msg.sender].hasMinted = true;
2018 
2019     // Set NFT data
2020     uint256 newRewardId = stakeRecords[msg.sender].rewardId;
2021     rewardRecords[newRewardId] = Reward(
2022       msg.sender,
2023       stakeRecords[msg.sender].amount,
2024       stakeRecords[msg.sender].startBlock,
2025       0,
2026       true
2027     );
2028     _safeMint(msg.sender, newRewardId);
2029     return newRewardId;
2030   }
2031 
2032   function rescue(address otherTokenAddress, address to, uint256 numTokens) public onlyOwner {
2033     require(otherTokenAddress != address(token), "rescuing staked token");
2034     IERC20 otherToken = IERC20(otherTokenAddress);
2035     otherToken.safeTransfer(to, numTokens);
2036   }
2037 
2038   function setBaseURI(string memory uri) public onlyOwner {
2039     _setBaseURI(uri);
2040   }
2041 
2042   function setContractURI(string memory uri) public onlyOwner {
2043     _contractURI = uri;
2044   }
2045 
2046   function contractURI() public view returns (string memory) {
2047     return _contractURI;
2048   }
2049 }