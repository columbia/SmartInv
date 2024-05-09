1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
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
81 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
82 
83 
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
243 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
244 
245 
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
387 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
388 
389 
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
464 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev Interface of the ERC165 standard, as defined in the
472  * https://eips.ethereum.org/EIPS/eip-165[EIP].
473  *
474  * Implementers can declare support of contract interfaces, which can then be
475  * queried by others ({ERC165Checker}).
476  *
477  * For an implementation, see {ERC165}.
478  */
479 interface IERC165 {
480     /**
481      * @dev Returns true if this contract implements the interface defined by
482      * `interfaceId`. See the corresponding
483      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
484      * to learn more about how these ids are created.
485      *
486      * This function call must use less than 30 000 gas.
487      */
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
492 
493 
494 
495 pragma solidity ^0.6.2;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(address from, address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(address from, address to, uint256 tokenId) external;
562 
563     /**
564      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
565      * The approval is cleared when the token is transferred.
566      *
567      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
568      *
569      * Requirements:
570      *
571      * - The caller must own the token or be an approved operator.
572      * - `tokenId` must exist.
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address to, uint256 tokenId) external;
577 
578     /**
579      * @dev Returns the account approved for `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function getApproved(uint256 tokenId) external view returns (address operator);
586 
587     /**
588      * @dev Approve or remove `operator` as an operator for the caller.
589      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
590      *
591      * Requirements:
592      *
593      * - The `operator` cannot be the caller.
594      *
595      * Emits an {ApprovalForAll} event.
596      */
597     function setApprovalForAll(address operator, bool _approved) external;
598 
599     /**
600      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
601      *
602      * See {setApprovalForAll}
603      */
604     function isApprovedForAll(address owner, address operator) external view returns (bool);
605 
606     /**
607       * @dev Safely transfers `tokenId` token from `from` to `to`.
608       *
609       * Requirements:
610       *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613       * - `tokenId` token must exist and be owned by `from`.
614       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616       *
617       * Emits a {Transfer} event.
618       */
619     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
620 }
621 
622 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
623 
624 
625 
626 pragma solidity ^0.6.0;
627 
628 /**
629  * @title ERC721 token receiver interface
630  * @dev Interface for any contract that wants to support safeTransfers
631  * from ERC721 asset contracts.
632  */
633 interface IERC721Receiver {
634     /**
635      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
636      * by `operator` from `from`, this function is called.
637      *
638      * It must return its Solidity selector to confirm the token transfer.
639      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
640      *
641      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
642      */
643     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
644     external returns (bytes4);
645 }
646 
647 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
648 
649 
650 
651 pragma solidity ^0.6.0;
652 
653 /**
654  * @dev Library for managing
655  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
656  * types.
657  *
658  * Sets have the following properties:
659  *
660  * - Elements are added, removed, and checked for existence in constant time
661  * (O(1)).
662  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
663  *
664  * ```
665  * contract Example {
666  *     // Add the library methods
667  *     using EnumerableSet for EnumerableSet.AddressSet;
668  *
669  *     // Declare a set state variable
670  *     EnumerableSet.AddressSet private mySet;
671  * }
672  * ```
673  *
674  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
675  * (`UintSet`) are supported.
676  */
677 library EnumerableSet {
678     // To implement this library for multiple types with as little code
679     // repetition as possible, we write it in terms of a generic Set type with
680     // bytes32 values.
681     // The Set implementation uses private functions, and user-facing
682     // implementations (such as AddressSet) are just wrappers around the
683     // underlying Set.
684     // This means that we can only create new EnumerableSets for types that fit
685     // in bytes32.
686 
687     struct Set {
688         // Storage of set values
689         bytes32[] _values;
690 
691         // Position of the value in the `values` array, plus 1 because index 0
692         // means a value is not in the set.
693         mapping (bytes32 => uint256) _indexes;
694     }
695 
696     /**
697      * @dev Add a value to a set. O(1).
698      *
699      * Returns true if the value was added to the set, that is if it was not
700      * already present.
701      */
702     function _add(Set storage set, bytes32 value) private returns (bool) {
703         if (!_contains(set, value)) {
704             set._values.push(value);
705             // The value is stored at length-1, but we add 1 to all indexes
706             // and use 0 as a sentinel value
707             set._indexes[value] = set._values.length;
708             return true;
709         } else {
710             return false;
711         }
712     }
713 
714     /**
715      * @dev Removes a value from a set. O(1).
716      *
717      * Returns true if the value was removed from the set, that is if it was
718      * present.
719      */
720     function _remove(Set storage set, bytes32 value) private returns (bool) {
721         // We read and store the value's index to prevent multiple reads from the same storage slot
722         uint256 valueIndex = set._indexes[value];
723 
724         if (valueIndex != 0) { // Equivalent to contains(set, value)
725             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
726             // the array, and then remove the last element (sometimes called as 'swap and pop').
727             // This modifies the order of the array, as noted in {at}.
728 
729             uint256 toDeleteIndex = valueIndex - 1;
730             uint256 lastIndex = set._values.length - 1;
731 
732             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
733             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
734 
735             bytes32 lastvalue = set._values[lastIndex];
736 
737             // Move the last value to the index where the value to delete is
738             set._values[toDeleteIndex] = lastvalue;
739             // Update the index for the moved value
740             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
741 
742             // Delete the slot where the moved value was stored
743             set._values.pop();
744 
745             // Delete the index for the deleted slot
746             delete set._indexes[value];
747 
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754     /**
755      * @dev Returns true if the value is in the set. O(1).
756      */
757     function _contains(Set storage set, bytes32 value) private view returns (bool) {
758         return set._indexes[value] != 0;
759     }
760 
761     /**
762      * @dev Returns the number of values on the set. O(1).
763      */
764     function _length(Set storage set) private view returns (uint256) {
765         return set._values.length;
766     }
767 
768    /**
769     * @dev Returns the value stored at position `index` in the set. O(1).
770     *
771     * Note that there are no guarantees on the ordering of values inside the
772     * array, and it may change when more values are added or removed.
773     *
774     * Requirements:
775     *
776     * - `index` must be strictly less than {length}.
777     */
778     function _at(Set storage set, uint256 index) private view returns (bytes32) {
779         require(set._values.length > index, "EnumerableSet: index out of bounds");
780         return set._values[index];
781     }
782 
783     // AddressSet
784 
785     struct AddressSet {
786         Set _inner;
787     }
788 
789     /**
790      * @dev Add a value to a set. O(1).
791      *
792      * Returns true if the value was added to the set, that is if it was not
793      * already present.
794      */
795     function add(AddressSet storage set, address value) internal returns (bool) {
796         return _add(set._inner, bytes32(uint256(value)));
797     }
798 
799     /**
800      * @dev Removes a value from a set. O(1).
801      *
802      * Returns true if the value was removed from the set, that is if it was
803      * present.
804      */
805     function remove(AddressSet storage set, address value) internal returns (bool) {
806         return _remove(set._inner, bytes32(uint256(value)));
807     }
808 
809     /**
810      * @dev Returns true if the value is in the set. O(1).
811      */
812     function contains(AddressSet storage set, address value) internal view returns (bool) {
813         return _contains(set._inner, bytes32(uint256(value)));
814     }
815 
816     /**
817      * @dev Returns the number of values in the set. O(1).
818      */
819     function length(AddressSet storage set) internal view returns (uint256) {
820         return _length(set._inner);
821     }
822 
823    /**
824     * @dev Returns the value stored at position `index` in the set. O(1).
825     *
826     * Note that there are no guarantees on the ordering of values inside the
827     * array, and it may change when more values are added or removed.
828     *
829     * Requirements:
830     *
831     * - `index` must be strictly less than {length}.
832     */
833     function at(AddressSet storage set, uint256 index) internal view returns (address) {
834         return address(uint256(_at(set._inner, index)));
835     }
836 
837 
838     // UintSet
839 
840     struct UintSet {
841         Set _inner;
842     }
843 
844     /**
845      * @dev Add a value to a set. O(1).
846      *
847      * Returns true if the value was added to the set, that is if it was not
848      * already present.
849      */
850     function add(UintSet storage set, uint256 value) internal returns (bool) {
851         return _add(set._inner, bytes32(value));
852     }
853 
854     /**
855      * @dev Removes a value from a set. O(1).
856      *
857      * Returns true if the value was removed from the set, that is if it was
858      * present.
859      */
860     function remove(UintSet storage set, uint256 value) internal returns (bool) {
861         return _remove(set._inner, bytes32(value));
862     }
863 
864     /**
865      * @dev Returns true if the value is in the set. O(1).
866      */
867     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
868         return _contains(set._inner, bytes32(value));
869     }
870 
871     /**
872      * @dev Returns the number of values on the set. O(1).
873      */
874     function length(UintSet storage set) internal view returns (uint256) {
875         return _length(set._inner);
876     }
877 
878    /**
879     * @dev Returns the value stored at position `index` in the set. O(1).
880     *
881     * Note that there are no guarantees on the ordering of values inside the
882     * array, and it may change when more values are added or removed.
883     *
884     * Requirements:
885     *
886     * - `index` must be strictly less than {length}.
887     */
888     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
889         return uint256(_at(set._inner, index));
890     }
891 }
892 
893 
894 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
895 
896 
897 
898 pragma solidity ^0.6.0;
899 
900 /*
901  * @dev Provides information about the current execution context, including the
902  * sender of the transaction and its data. While these are generally available
903  * via msg.sender and msg.data, they should not be accessed in such a direct
904  * manner, since when dealing with GSN meta-transactions the account sending and
905  * paying for execution may not be the actual sender (as far as an application
906  * is concerned).
907  *
908  * This contract is only required for intermediate, library-like contracts.
909  */
910 abstract contract Context {
911     function _msgSender() internal view virtual returns (address payable) {
912         return msg.sender;
913     }
914 
915     function _msgData() internal view virtual returns (bytes memory) {
916         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
917         return msg.data;
918     }
919 }
920 
921 // File: @openzeppelin\contracts\access\Ownable.sol
922 
923 
924 
925 pragma solidity ^0.6.0;
926 
927 /**
928  * @dev Contract module which provides a basic access control mechanism, where
929  * there is an account (an owner) that can be granted exclusive access to
930  * specific functions.
931  *
932  * By default, the owner account will be the one that deploys the contract. This
933  * can later be changed with {transferOwnership}.
934  *
935  * This module is used through inheritance. It will make available the modifier
936  * `onlyOwner`, which can be applied to your functions to restrict their use to
937  * the owner.
938  */
939 contract Ownable is Context {
940     address private _owner;
941 
942     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
943 
944     /**
945      * @dev Initializes the contract setting the deployer as the initial owner.
946      */
947     constructor () internal {
948         address msgSender = _msgSender();
949         _owner = msgSender;
950         emit OwnershipTransferred(address(0), msgSender);
951     }
952 
953     /**
954      * @dev Returns the address of the current owner.
955      */
956     function owner() public view returns (address) {
957         return _owner;
958     }
959 
960     /**
961      * @dev Throws if called by any account other than the owner.
962      */
963     modifier onlyOwner() {
964         require(_owner == _msgSender(), "Ownable: caller is not the owner");
965         _;
966     }
967 
968     /**
969      * @dev Leaves the contract without owner. It will not be possible to call
970      * `onlyOwner` functions anymore. Can only be called by the current owner.
971      *
972      * NOTE: Renouncing ownership will leave the contract without an owner,
973      * thereby removing any functionality that is only available to the owner.
974      */
975     function renounceOwnership() public virtual onlyOwner {
976         emit OwnershipTransferred(_owner, address(0));
977         _owner = address(0);
978     }
979 
980     /**
981      * @dev Transfers ownership of the contract to a new account (`newOwner`).
982      * Can only be called by the current owner.
983      */
984     function transferOwnership(address newOwner) public virtual onlyOwner {
985         require(newOwner != address(0), "Ownable: new owner is the zero address");
986         emit OwnershipTransferred(_owner, newOwner);
987         _owner = newOwner;
988     }
989 }
990 
991 // File: contracts\ITMC.sol
992 
993 pragma solidity ^0.6.0;
994 
995 interface ITMC{
996 
997     function mint(address to, uint256 amount) external;
998     function transfer(address recipient, uint256 amount) external returns (bool);
999     function balanceOf(address a) external returns (uint256);
1000 }
1001 
1002 // File: contracts\PausableStaking.sol
1003 
1004 pragma solidity ^0.6.0;
1005 
1006 
1007 contract PausableStaking is Ownable{
1008   
1009     bool public pausedDeposit;
1010     bool public pausedWithdraw;
1011 
1012     modifier whenNotPausedDeposit() {
1013         require(!pausedDeposit, "Deposit is paused!");
1014         _;
1015     }
1016 
1017     modifier whenPausedDeposit {
1018         require(pausedDeposit, "Deposit is not paused!");
1019         _;
1020     }
1021 
1022     function pauseDeposit() public onlyOwner whenNotPausedDeposit {
1023         pausedDeposit = true;
1024     }
1025 
1026     function unpauseDeposit() public onlyOwner whenPausedDeposit {
1027         pausedDeposit = false;
1028     }
1029 
1030 
1031      modifier whenNotPausedWithdraw() {
1032         require(!pausedWithdraw, "Incubate is paused!");
1033         _;
1034     }
1035 
1036     modifier whenPausedWithdraw {
1037         require(pausedWithdraw, "Incubate is not paused!");
1038         _;
1039     }
1040 
1041     function pauseWithdraw() public onlyOwner whenNotPausedWithdraw {
1042         pausedWithdraw = true;
1043     }
1044 
1045     function unpauseWithdraw() public onlyOwner whenPausedWithdraw {
1046         pausedWithdraw = false;
1047     }
1048 
1049 
1050 
1051 }
1052 
1053 // File: contracts\ITAMAGRewardCalc.sol
1054 
1055 pragma solidity ^0.6.12;
1056 
1057 interface ITAMAGRewardCalc{
1058     // make sure this amt roughly on same magnitude with 1e18
1059     function getVirtualAmt(uint256 tamagId) external view returns (uint256);
1060 }
1061 
1062 // File: contracts\MasterPool.sol
1063 
1064 pragma solidity ^0.6.12;
1065 
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 // MasterChef is the master of TMC. He can make TMC and he is a fair guy.
1078 //
1079 // Note that it's ownable and the owner wields tremendous power. The ownership
1080 // will be transferred to a governance smart contract once TMC is sufficiently
1081 // distributed and the community can show to govern itself.
1082 //
1083 // Have fun reading it. Hopefully it's bug-free. God bless.
1084 contract MasterPool is Ownable, IERC721Receiver, PausableStaking  {
1085     using SafeMath for uint256;
1086     using SafeERC20 for IERC20;
1087     using EnumerableSet for EnumerableSet.UintSet;
1088 
1089 
1090     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public override returns (bytes4){
1091         // return IERC721Receiver(0).onERC721Received.selector;
1092         return 0x150b7a02;
1093     }
1094     
1095     // Info of each user.
1096     struct UserInfo {
1097         uint256 amount;     // How many LP tokens the user has provided.
1098         uint256 rewardDebt; // Reward debt. See explanation below.
1099         EnumerableSet.UintSet tamagIds;
1100 
1101         //
1102         // We do some fancy math here. Basically, any point in time, the amount of TMCs
1103         // entitled to a user but is pending to be distributed is:
1104         //
1105         //   pending reward = (user.amount * pool.accTmcPerShare) - user.rewardDebt
1106         //
1107         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1108         //   1. The pool's `accTmcPerShare` (and `lastRewardBlock`) gets updated.
1109         //   2. User receives the pending reward sent to his/her address.
1110         //   3. User's `amount` gets updated.
1111         //   4. User's `rewardDebt` gets updated.
1112     }
1113 
1114     // Info of each pool.1
1115     struct PoolInfo {
1116         IERC20 lpToken;           // Address of LP token contract.
1117         uint256 allocPoint;       // How many allocation points assigned to this pool. TMCs to distribute per block.
1118         uint256 lastRewardBlock;  // Last block number that TMCs distribution occurs.
1119         uint256 accTmcPerShare; // Accumulated TMCs per share, times 1e12. See below.
1120         
1121         IERC721 tamag;
1122         uint256 totalAmount;
1123         EnumerableSet.UintSet tamagIds;
1124     }
1125 
1126     // The TMC TOKEN!
1127     ITMC public tmc;
1128     // Dev address.
1129     address public devAddr;
1130     // divider for dev fee. 100 = 1% dev fee.
1131     uint256 public devFeeDivider = 100;
1132     // Block number when bonus TMC period ends.
1133     uint256 public bonusEndBlock;
1134     // TMC tokens created per block.
1135     uint256 public tmcPerBlock;
1136     // Bonus muliplier for early stakers.
1137     uint256 public constant BONUS_MULTIPLIER = 1;
1138 
1139     ITAMAGRewardCalc public tamagRewardCalc;
1140 
1141     // Info of each pool.
1142     PoolInfo[] private poolInfo;
1143     // Info of each user that stakes LP tokens.
1144     mapping (uint256 => mapping (address => UserInfo)) private userInfo;
1145     // Total allocation points. Must be the sum of all allocation points in all pools.
1146     uint256 public totalAllocPoint = 0;
1147     // The block number when TMC mining starts.
1148     uint256 public startBlock;
1149 
1150     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1151     event DepositTamag(address indexed user, uint256 indexed _pid, uint256 indexed tamagId, uint256 virtualAmt);
1152     
1153     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1154     event WithdrawTamag(address indexed user, uint256 indexed _pid, uint256 indexed tamagId);
1155 
1156     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1157     event EmergencyWithdrawTamag(address indexed user, uint256 indexed _pid, uint256 indexed tamagId);
1158 
1159     event PoolUpdated(uint256 mintToDev, uint256 mintToPool);
1160 
1161     constructor(
1162         address _tmc,
1163         address _devAddr,
1164         uint256 _tmcPerBlock,
1165         uint256 _startBlock,
1166         uint256 _bonusEndBlock,
1167         address _tamagRewardCalc
1168     ) public {
1169         tmc = ITMC(_tmc);
1170         devAddr = _devAddr;
1171         tmcPerBlock = _tmcPerBlock;
1172         bonusEndBlock = _bonusEndBlock;
1173         startBlock = _startBlock;
1174         tamagRewardCalc = ITAMAGRewardCalc(_tamagRewardCalc);
1175 
1176         pauseDeposit();
1177         pauseWithdraw();
1178     }
1179 
1180     // MUST MASS UPDATE POOLS FIRST then u can call this!
1181     function setTMCPerBlock(uint256 i) public onlyOwner{
1182         tmcPerBlock = i;
1183     }
1184     function setTamagRewardCalc(address a) public onlyOwner {
1185         tamagRewardCalc = ITAMAGRewardCalc(a);
1186 
1187     }
1188     function setDevAddress(address a) public onlyOwner {
1189         devAddr = a;
1190     }
1191 
1192     function setDevFeeDivider(uint256 divider) public onlyOwner{
1193         devFeeDivider = divider;
1194     }
1195 
1196     function poolLength() external view returns (uint256) {
1197         return poolInfo.length;
1198     }
1199 
1200     // Add a new lp to the pool. Can only be called by the owner.
1201     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1202     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1203         if (_withUpdate) {
1204             massUpdatePools();
1205         }
1206         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1207         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1208 
1209         PoolInfo memory p;
1210         p.lpToken = _lpToken;
1211         p.allocPoint = _allocPoint;
1212         p.lastRewardBlock = lastRewardBlock;
1213         p.accTmcPerShare = 0;
1214         poolInfo.push(p);
1215 
1216     }
1217     // Add a new lp to the pool. Can only be called by the owner.
1218     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1219     function addTamagPool(uint256 _allocPoint, IERC721 _tamagToken, bool _withUpdate) public onlyOwner {
1220         if (_withUpdate) {
1221             massUpdatePools();
1222         }
1223         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1224         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1225         PoolInfo memory p;
1226         p.allocPoint = _allocPoint;
1227         p.lastRewardBlock = lastRewardBlock;
1228         p.accTmcPerShare = 0;
1229         p.tamag = _tamagToken;
1230         p.totalAmount = 0;    
1231         poolInfo.push(p);
1232     }
1233     // Update the given pool's TMC allocation point. Can only be called by the owner.
1234     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1235         if (_withUpdate) {
1236             massUpdatePools();
1237         }
1238         poolInfo[_pid].allocPoint = _allocPoint;
1239     }
1240 
1241 
1242     // check TAMAG traits and OG label
1243 
1244     // Return reward multiplier over the given _from to _to block.
1245     // specific to each pool
1246     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1247         if (_to <= bonusEndBlock) {
1248             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1249         } else if (_from >= bonusEndBlock) {
1250             return _to.sub(_from);
1251         } else {
1252             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1253                 _to.sub(bonusEndBlock)
1254             );
1255         }
1256     }
1257 
1258     // View function to see pending TMCs on frontend.
1259     function pendingTMCForTamag(uint256 _pid, address _user, uint256 tamagId) external view returns (uint256) {
1260         PoolInfo storage pool = poolInfo[_pid];
1261         UserInfo storage user = userInfo[_pid][_user];
1262         uint256 accTmcPerShare = pool.accTmcPerShare;
1263         uint256 lpSupply;
1264         if (!isTamagPool(_pid)){
1265             lpSupply = pool.lpToken.balanceOf(address(this));
1266         }else {
1267             lpSupply = pool.totalAmount;
1268         }
1269 
1270         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1271             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1272             uint256 tmcReward = multiplier.mul(tmcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1273             accTmcPerShare = accTmcPerShare.add(tmcReward.mul(1e12).div(lpSupply));
1274         }
1275         uint256 tamagVirtualAmount = tamagRewardCalc.getVirtualAmt(tamagId);
1276         return user.amount.mul(accTmcPerShare).div(1e12).sub(user.rewardDebt).mul(tamagVirtualAmount).div(user.amount);
1277 
1278     }
1279 
1280     // View function to see pending TMCs on frontend.
1281     function pendingTMC(uint256 _pid, address _user) external view returns (uint256) {
1282         PoolInfo storage pool = poolInfo[_pid];
1283         UserInfo storage user = userInfo[_pid][_user];
1284         uint256 accTmcPerShare = pool.accTmcPerShare;
1285         uint256 lpSupply;
1286         if (!isTamagPool(_pid)){
1287             lpSupply = pool.lpToken.balanceOf(address(this));
1288         }else {
1289             lpSupply = pool.totalAmount;
1290         }
1291 
1292         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1293             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1294             uint256 tmcReward = multiplier.mul(tmcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1295             accTmcPerShare = accTmcPerShare.add(tmcReward.mul(1e12).div(lpSupply));
1296         }
1297         return user.amount.mul(accTmcPerShare).div(1e12).sub(user.rewardDebt);
1298     }
1299 
1300     // Update reward variables for all pools. Be careful of gas spending!
1301     function massUpdatePools() public {
1302         uint256 length = poolInfo.length;
1303         for (uint256 pid = 0; pid < length; ++pid) {
1304             updatePool(pid);
1305         }
1306     }
1307     // Update reward variables of the given pool to be up-to-date.
1308     function updatePool(uint256 _pid) public {
1309         PoolInfo storage pool = poolInfo[_pid];
1310         if (block.number <= pool.lastRewardBlock) {
1311             return;
1312         }
1313         uint256 lpSupply;
1314         if (!isTamagPool(_pid)){
1315             lpSupply = pool.lpToken.balanceOf(address(this));
1316         }else {
1317             lpSupply = pool.totalAmount;
1318         }
1319 
1320         if (lpSupply == 0) {
1321             pool.lastRewardBlock = block.number;
1322             return;
1323         }
1324         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1325         uint256 tmcReward = multiplier.mul(tmcPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1326         tmc.mint(devAddr, tmcReward.div(devFeeDivider));
1327         tmc.mint(address(this), tmcReward);
1328         PoolUpdated(tmcReward.div(devFeeDivider),tmcReward);
1329         pool.accTmcPerShare = pool.accTmcPerShare.add(tmcReward.mul(1e12).div(lpSupply));
1330         pool.lastRewardBlock = block.number;
1331     }
1332     function getTotalStakedTamag(uint256 _pid) public view returns (uint256) {
1333         PoolInfo storage pool = poolInfo[_pid];
1334         return pool.tamagIds.length();
1335     }
1336     function getTotalStakedTamagByIndex(uint256 _pid, uint256 index) public view  returns (uint256){
1337         PoolInfo storage pool = poolInfo[_pid];
1338         require (index < getTotalStakedTamag(_pid),"invalid index");
1339         return pool.tamagIds.at(index);
1340     }
1341     function getUserTotalStakedTamag(uint256 _pid) public view  returns (uint256){
1342         return userInfo[_pid][_msgSender()].tamagIds.length();
1343     }
1344     function getUserStakedTamagByIndex(uint256 _pid, uint256 index) public view  returns (uint256){
1345         require (index < getUserTotalStakedTamag(_pid),"invalid index");
1346         return userInfo[_pid][_msgSender()].tamagIds.at(index);
1347     }
1348     function claimTamagRewards(uint256 _pid) public whenNotPausedDeposit{
1349         require(isTamagPool(_pid), "not tamag pool");
1350         PoolInfo storage pool = poolInfo[_pid];
1351         UserInfo storage user = userInfo[_pid][_msgSender()];
1352 
1353         updatePool(_pid);
1354 
1355         if (user.amount > 0) {
1356             uint256 pending = user.amount.mul(pool.accTmcPerShare).div(1e12).sub(user.rewardDebt);
1357             if(pending > 0) {
1358                 safeTmcTransfer(_msgSender(), pending);
1359             }
1360         }
1361         user.rewardDebt = user.amount.mul(pool.accTmcPerShare).div(1e12);
1362     }
1363     function depositTamagMulti(uint256 _pid, uint256 tamagId) public whenNotPausedDeposit{
1364     
1365     }
1366 
1367     function depositTamag(uint256 _pid, uint256 tamagId) public whenNotPausedDeposit{
1368 
1369         require(isTamagPool(_pid), "not tamag pool");
1370         PoolInfo storage pool = poolInfo[_pid];
1371         UserInfo storage user = userInfo[_pid][_msgSender()];
1372         require(!user.tamagIds.contains(tamagId), "Tamag already staked!");
1373 
1374         updatePool(_pid);
1375         if (user.amount > 0) {
1376             uint256 pending = user.amount.mul(pool.accTmcPerShare).div(1e12).sub(user.rewardDebt);
1377             if(pending > 0) {
1378                 safeTmcTransfer(_msgSender(), pending);
1379             }
1380         }
1381         // convert tamag to virtual amount
1382         uint256 tamagVirtualAmount = tamagRewardCalc.getVirtualAmt(tamagId);
1383         pool.tamag.safeTransferFrom(_msgSender(), address(this), tamagId);
1384         user.amount = user.amount.add(tamagVirtualAmount);
1385         user.tamagIds.add(tamagId);
1386         pool.totalAmount = pool.totalAmount.add(tamagVirtualAmount);
1387         pool.tamagIds.add(tamagId);
1388         user.rewardDebt = user.amount.mul(pool.accTmcPerShare).div(1e12);
1389         emit DepositTamag(_msgSender(), _pid, tamagId, tamagVirtualAmount);
1390     }
1391 
1392     // Deposit LP tokens to MasterChef for TMC allocation.
1393     function deposit(uint256 _pid, uint256 _amount) public whenNotPausedDeposit{
1394         require(!isTamagPool(_pid), "not erc20 pool");
1395         PoolInfo storage pool = poolInfo[_pid];
1396         UserInfo storage user = userInfo[_pid][_msgSender()];
1397         updatePool(_pid);
1398         if (user.amount > 0) {
1399             uint256 pending = user.amount.mul(pool.accTmcPerShare).div(1e12).sub(user.rewardDebt);
1400             if(pending > 0) {
1401                 safeTmcTransfer(_msgSender(), pending);
1402             }
1403         }
1404         if (_amount > 0) {
1405             pool.lpToken.safeTransferFrom(_msgSender(), address(this), _amount);
1406             user.amount = user.amount.add(_amount);
1407         }
1408         user.rewardDebt = user.amount.mul(pool.accTmcPerShare).div(1e12);
1409         emit Deposit(_msgSender(), _pid, _amount);
1410     }
1411 
1412     function isTamagPool(uint256 _pid) public view returns (bool){
1413         PoolInfo storage pool = poolInfo[_pid];
1414         return address(pool.lpToken) == address(0) && address(pool.tamag) != address(0);
1415     }
1416 
1417     // Withdraw LP tokens from MasterChef.
1418     function withdraw(uint256 _pid, uint256 _amount) public whenNotPausedWithdraw{
1419         require(!isTamagPool(_pid), "not erc20 pool");
1420         PoolInfo storage pool = poolInfo[_pid];
1421         UserInfo storage user = userInfo[_pid][_msgSender()];
1422         require(user.amount >= _amount, "withdraw: not good");
1423         updatePool(_pid);
1424         uint256 pending = user.amount.mul(pool.accTmcPerShare).div(1e12).sub(user.rewardDebt);
1425         if(pending > 0) {
1426             safeTmcTransfer(_msgSender(), pending);
1427         }
1428         if(_amount > 0) {
1429             user.amount = user.amount.sub(_amount);
1430             pool.lpToken.safeTransfer(_msgSender(), _amount);
1431         }
1432         user.rewardDebt = user.amount.mul(pool.accTmcPerShare).div(1e12);
1433         emit Withdraw(_msgSender(), _pid, _amount);
1434     }
1435 
1436     // Withdraw TAMAG tokens from MasterChef.
1437     function withdrawTamag(uint256 _pid, uint256 tamagId) public whenNotPausedWithdraw{
1438 
1439         require(isTamagPool(_pid), "not tamag pool");
1440         PoolInfo storage pool = poolInfo[_pid];
1441         require (pool.tamagIds.contains(tamagId), "pool don't have tamag");
1442         UserInfo storage user = userInfo[_pid][_msgSender()];
1443         require(user.tamagIds.contains(tamagId), "tamag not yet staked by user");
1444         
1445         updatePool(_pid);
1446 
1447         uint256 pending = user.amount.mul(pool.accTmcPerShare).div(1e12).sub(user.rewardDebt);
1448         if(pending > 0) {
1449             safeTmcTransfer(_msgSender(), pending);
1450         }
1451 
1452         uint256 tamagVirtualAmount = tamagRewardCalc.getVirtualAmt(tamagId);
1453 
1454         user.amount = user.amount.sub(tamagVirtualAmount);
1455         user.tamagIds.remove(tamagId);
1456 
1457         pool.totalAmount = pool.totalAmount.sub(tamagVirtualAmount);
1458         pool.tamagIds.remove(tamagId);
1459 
1460         pool.tamag.safeTransferFrom(address(this), _msgSender(), tamagId);
1461 
1462         user.rewardDebt = user.amount.mul(pool.accTmcPerShare).div(1e12);
1463         emit WithdrawTamag(_msgSender(), _pid, tamagId);
1464     }
1465 
1466     // Withdraw without caring about rewards. EMERGENCY ONLY.
1467     function emergencyWithdraw(uint256 _pid) public {
1468         PoolInfo storage pool = poolInfo[_pid];
1469         UserInfo storage user = userInfo[_pid][_msgSender()];
1470         uint256 amount = user.amount;
1471         user.amount = 0;
1472         user.rewardDebt = 0;
1473         pool.lpToken.safeTransfer(_msgSender(), amount);
1474         emit EmergencyWithdraw(_msgSender(), _pid, amount);
1475     }
1476     
1477     // Withdraw without caring about rewards. EMERGENCY ONLY.
1478     function emergencyWithdrawTamag(uint256 _pid, uint256 tamagId) public {
1479         require(isTamagPool(_pid), "not tamag pool");
1480         PoolInfo storage pool = poolInfo[_pid];
1481         require (pool.tamagIds.contains(tamagId), "pool don't have tamag");
1482         UserInfo storage user = userInfo[_pid][_msgSender()];
1483         require (user.tamagIds.contains(tamagId), "tamag not in pool");
1484 
1485         uint256 tamagVirtualAmount = tamagRewardCalc.getVirtualAmt(tamagId);
1486 
1487         user.amount = user.amount.sub(tamagVirtualAmount);
1488         user.tamagIds.remove(tamagId);
1489 
1490         pool.totalAmount = pool.totalAmount.sub(tamagVirtualAmount);
1491         pool.tamagIds.remove(tamagId);
1492 
1493         pool.tamag.safeTransferFrom(address(this), _msgSender(), tamagId);
1494         emit EmergencyWithdraw(_msgSender(), _pid, tamagId);
1495     }
1496 
1497     // Safe tmc transfer function, just in case if rounding error causes pool to not have enough TMCs.
1498     function safeTmcTransfer(address _to, uint256 _amount) internal {
1499         uint256 tmcBal = tmc.balanceOf(address(this));
1500         if (_amount > tmcBal) {
1501             tmc.transfer(_to, tmcBal);
1502         } else {
1503             tmc.transfer(_to, _amount);
1504         }
1505     }
1506 
1507     // utility methods for poolInfo, userInfo
1508     function getUserInfo(uint256 _pid, address a) public view returns (uint256, uint256){
1509         UserInfo storage user = userInfo[_pid][a];
1510         uint256 amount = user.amount;
1511         uint256 rewardDebt = user.rewardDebt;
1512         return (amount, rewardDebt);
1513     }
1514     // utility methods for poolInfo, userInfo
1515     function getUserInfoTamagIdSize(uint256 _pid, address a) public view returns (uint256){
1516         return userInfo[_pid][a].tamagIds.length();
1517     }
1518     function getUserInfoTamagIdAtIndex(uint256 _pid, address a, uint256 i) public view returns(uint256){
1519         return userInfo[_pid][a].tamagIds.at(i);
1520     }
1521     function getUserInfoTamagIdContains(uint256 _pid, address a, uint256 tamagId) public view returns(bool){
1522         return userInfo[_pid][a].tamagIds.contains(tamagId);
1523     }
1524 
1525     // utility methods for poolInfo, userInfo
1526     function getPool(uint256 poolIndex) public view returns (address lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint256 accTmcPerShare, address tamag, uint256 totalAmount){
1527         PoolInfo storage pool = poolInfo[poolIndex];
1528         return (address(pool.lpToken), pool.allocPoint, pool.lastRewardBlock, pool.accTmcPerShare, address(pool.tamag), pool.totalAmount);
1529     }
1530 
1531     // utility methods for poolInfo, userInfo
1532     function getPoolTamagIdSize(uint256 poolIndex) public view returns (uint256){
1533         return poolInfo[poolIndex].tamagIds.length();
1534     }
1535     function getPoolTamagIdAtIndex(uint256 poolIndex, uint256 i) public view returns(uint256){
1536         return poolInfo[poolIndex].tamagIds.at(i);
1537     }
1538     function getPoolTamagIdContains(uint256 poolIndex, uint256 tamagId) public view returns(bool){
1539         return poolInfo[poolIndex].tamagIds.contains(tamagId);
1540     }
1541 }