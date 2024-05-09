1 pragma solidity >=0.6.0 <0.8.0;
2 pragma abicoder v2;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 // SPDX-License-Identifier: MIT
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 /**
49  * @dev Required interface of an ERC721 compliant contract.
50  */
51 interface IERC721 is IERC165 {
52     /**
53      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
59      */
60     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
61 
62     /**
63      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
64      */
65     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
66 
67     /**
68      * @dev Returns the number of tokens in ``owner``'s account.
69      */
70     function balanceOf(address owner) external view returns (uint256 balance);
71 
72     /**
73      * @dev Returns the owner of the `tokenId` token.
74      *
75      * Requirements:
76      *
77      * - `tokenId` must exist.
78      */
79     function ownerOf(uint256 tokenId) external view returns (address owner);
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
83      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(address from, address to, uint256 tokenId) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(address from, address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157       * @dev Safely transfers `tokenId` token from `from` to `to`.
158       *
159       * Requirements:
160       *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163       * - `tokenId` token must exist and be owned by `from`.
164       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166       *
167       * Emits a {Transfer} event.
168       */
169     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
170 }
171 
172 /**
173  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
174  * @dev See https://eips.ethereum.org/EIPS/eip-721
175  */
176 interface IERC721Metadata is IERC721 {
177 
178     /**
179      * @dev Returns the token collection name.
180      */
181     function name() external view returns (string memory);
182 
183     /**
184      * @dev Returns the token collection symbol.
185      */
186     function symbol() external view returns (string memory);
187 
188     /**
189      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
190      */
191     function tokenURI(uint256 tokenId) external view returns (string memory);
192 }
193 
194 
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Enumerable is IERC721 {
200 
201     /**
202      * @dev Returns the total amount of tokens stored by the contract.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
208      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
209      */
210     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
211 
212     /**
213      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
214      * Use along with {totalSupply} to enumerate all tokens.
215      */
216     function tokenByIndex(uint256 index) external view returns (uint256);
217 }
218 
219 /**
220  * @title ERC721 token receiver interface
221  * @dev Interface for any contract that wants to support safeTransfers
222  * from ERC721 asset contracts.
223  */
224 interface IERC721Receiver {
225     /**
226      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
227      * by `operator` from `from`, this function is called.
228      *
229      * It must return its Solidity selector to confirm the token transfer.
230      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
231      *
232      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
233      */
234     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
235 }
236 
237 
238 /**
239  * @dev Implementation of the {IERC165} interface.
240  *
241  * Contracts may inherit from this and call {_registerInterface} to declare
242  * their support of an interface.
243  */
244 abstract contract ERC165 is IERC165 {
245     /*
246      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
247      */
248     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
249 
250     /**
251      * @dev Mapping of interface ids to whether or not it's supported.
252      */
253     mapping(bytes4 => bool) private _supportedInterfaces;
254 
255     constructor () internal {
256         // Derived contracts need only register support for their own interfaces,
257         // we register support for ERC165 itself here
258         _registerInterface(_INTERFACE_ID_ERC165);
259     }
260 
261     /**
262      * @dev See {IERC165-supportsInterface}.
263      *
264      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
265      */
266     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
267         return _supportedInterfaces[interfaceId];
268     }
269 
270     /**
271      * @dev Registers the contract as an implementer of the interface defined by
272      * `interfaceId`. Support of the actual ERC165 interface is automatic and
273      * registering its interface id is not required.
274      *
275      * See {IERC165-supportsInterface}.
276      *
277      * Requirements:
278      *
279      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
280      */
281     function _registerInterface(bytes4 interfaceId) internal virtual {
282         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
283         _supportedInterfaces[interfaceId] = true;
284     }
285 }
286 
287 
288 pragma solidity >=0.6.0 <0.8.0;
289 
290 /**
291  * @dev Wrappers over Solidity's arithmetic operations with added overflow
292  * checks.
293  *
294  * Arithmetic operations in Solidity wrap on overflow. This can easily result
295  * in bugs, because programmers usually assume that an overflow raises an
296  * error, which is the standard behavior in high level programming languages.
297  * `SafeMath` restores this intuition by reverting the transaction when an
298  * operation overflows.
299  *
300  * Using this library instead of the unchecked operations eliminates an entire
301  * class of bugs, so it's recommended to use it always.
302  */
303 library SafeMath {
304     /**
305      * @dev Returns the addition of two unsigned integers, reverting on
306      * overflow.
307      *
308      * Counterpart to Solidity's `+` operator.
309      *
310      * Requirements:
311      *
312      * - Addition cannot overflow.
313      */
314     function add(uint256 a, uint256 b) internal pure returns (uint256) {
315         uint256 c = a + b;
316         require(c >= a, "SafeMath: addition overflow");
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332         return sub(a, b, "SafeMath: subtraction overflow");
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
337      * overflow (when the result is negative).
338      *
339      * Counterpart to Solidity's `-` operator.
340      *
341      * Requirements:
342      *
343      * - Subtraction cannot overflow.
344      */
345     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
346         require(b <= a, errorMessage);
347         uint256 c = a - b;
348 
349         return c;
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, reverting on
354      * overflow.
355      *
356      * Counterpart to Solidity's `*` operator.
357      *
358      * Requirements:
359      *
360      * - Multiplication cannot overflow.
361      */
362     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
364         // benefit is lost if 'b' is also tested.
365         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
366         if (a == 0) {
367             return 0;
368         }
369 
370         uint256 c = a * b;
371         require(c / a == b, "SafeMath: multiplication overflow");
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the integer division of two unsigned integers. Reverts on
378      * division by zero. The result is rounded towards zero.
379      *
380      * Counterpart to Solidity's `/` operator. Note: this function uses a
381      * `revert` opcode (which leaves remaining gas untouched) while Solidity
382      * uses an invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      *
386      * - The divisor cannot be zero.
387      */
388     function div(uint256 a, uint256 b) internal pure returns (uint256) {
389         return div(a, b, "SafeMath: division by zero");
390     }
391 
392     /**
393      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
394      * division by zero. The result is rounded towards zero.
395      *
396      * Counterpart to Solidity's `/` operator. Note: this function uses a
397      * `revert` opcode (which leaves remaining gas untouched) while Solidity
398      * uses an invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      *
402      * - The divisor cannot be zero.
403      */
404     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b > 0, errorMessage);
406         uint256 c = a / b;
407         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
414      * Reverts when dividing by zero.
415      *
416      * Counterpart to Solidity's `%` operator. This function uses a `revert`
417      * opcode (which leaves remaining gas untouched) while Solidity uses an
418      * invalid opcode to revert (consuming all remaining gas).
419      *
420      * Requirements:
421      *
422      * - The divisor cannot be zero.
423      */
424     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
425         return mod(a, b, "SafeMath: modulo by zero");
426     }
427 
428     /**
429      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
430      * Reverts with custom message when dividing by zero.
431      *
432      * Counterpart to Solidity's `%` operator. This function uses a `revert`
433      * opcode (which leaves remaining gas untouched) while Solidity uses an
434      * invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      *
438      * - The divisor cannot be zero.
439      */
440     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
441         require(b != 0, errorMessage);
442         return a % b;
443     }
444 }
445 
446 
447 pragma solidity >=0.6.2 <0.8.0;
448 
449 /**
450  * @dev Collection of functions related to the address type
451  */
452 library Address {
453     /**
454      * @dev Returns true if `account` is a contract.
455      *
456      * [IMPORTANT]
457      * ====
458      * It is unsafe to assume that an address for which this function returns
459      * false is an externally-owned account (EOA) and not a contract.
460      *
461      * Among others, `isContract` will return false for the following
462      * types of addresses:
463      *
464      *  - an externally-owned account
465      *  - a contract in construction
466      *  - an address where a contract will be created
467      *  - an address where a contract lived, but was destroyed
468      * ====
469      */
470     function isContract(address account) internal view returns (bool) {
471         // This method relies on extcodesize, which returns 0 for contracts in
472         // construction, since the code is only stored at the end of the
473         // constructor execution.
474 
475         uint256 size;
476         // solhint-disable-next-line no-inline-assembly
477         assembly { size := extcodesize(account) }
478         return size > 0;
479     }
480 
481     /**
482      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
483      * `recipient`, forwarding all available gas and reverting on errors.
484      *
485      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
486      * of certain opcodes, possibly making contracts go over the 2300 gas limit
487      * imposed by `transfer`, making them unable to receive funds via
488      * `transfer`. {sendValue} removes this limitation.
489      *
490      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
491      *
492      * IMPORTANT: because control is transferred to `recipient`, care must be
493      * taken to not create reentrancy vulnerabilities. Consider using
494      * {ReentrancyGuard} or the
495      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
496      */
497     function sendValue(address payable recipient, uint256 amount) internal {
498         require(address(this).balance >= amount, "Address: insufficient balance");
499 
500         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
501         (bool success, ) = recipient.call{ value: amount }("");
502         require(success, "Address: unable to send value, recipient may have reverted");
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain`call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
524       return functionCall(target, data, "Address: low-level call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, 0, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but also transferring `value` wei to `target`.
540      *
541      * Requirements:
542      *
543      * - the calling contract must have an ETH balance of at least `value`.
544      * - the called Solidity function must be `payable`.
545      *
546      * _Available since v3.1._
547      */
548     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
554      * with `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
559         require(address(this).balance >= value, "Address: insufficient balance for call");
560         require(isContract(target), "Address: call to non-contract");
561 
562         // solhint-disable-next-line avoid-low-level-calls
563         (bool success, bytes memory returndata) = target.call{ value: value }(data);
564         return _verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a static call.
570      *
571      * _Available since v3.3._
572      */
573     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
574         return functionStaticCall(target, data, "Address: low-level static call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a static call.
580      *
581      * _Available since v3.3._
582      */
583     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
584         require(isContract(target), "Address: static call to non-contract");
585 
586         // solhint-disable-next-line avoid-low-level-calls
587         (bool success, bytes memory returndata) = target.staticcall(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a delegate call.
594      *
595      * _Available since v3.3._
596      */
597     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
598         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.3._
606      */
607     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
608         require(isContract(target), "Address: delegate call to non-contract");
609 
610         // solhint-disable-next-line avoid-low-level-calls
611         (bool success, bytes memory returndata) = target.delegatecall(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 // solhint-disable-next-line no-inline-assembly
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 
636 pragma solidity >=0.6.0 <0.8.0;
637 
638 /**
639  * @dev Library for managing
640  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
641  * types.
642  *
643  * Sets have the following properties:
644  *
645  * - Elements are added, removed, and checked for existence in constant time
646  * (O(1)).
647  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
648  *
649  * ```
650  * contract Example {
651  *     // Add the library methods
652  *     using EnumerableSet for EnumerableSet.AddressSet;
653  *
654  *     // Declare a set state variable
655  *     EnumerableSet.AddressSet private mySet;
656  * }
657  * ```
658  *
659  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
660  * and `uint256` (`UintSet`) are supported.
661  */
662 library EnumerableSet {
663     // To implement this library for multiple types with as little code
664     // repetition as possible, we write it in terms of a generic Set type with
665     // bytes32 values.
666     // The Set implementation uses private functions, and user-facing
667     // implementations (such as AddressSet) are just wrappers around the
668     // underlying Set.
669     // This means that we can only create new EnumerableSets for types that fit
670     // in bytes32.
671 
672     struct Set {
673         // Storage of set values
674         bytes32[] _values;
675 
676         // Position of the value in the `values` array, plus 1 because index 0
677         // means a value is not in the set.
678         mapping (bytes32 => uint256) _indexes;
679     }
680 
681     /**
682      * @dev Add a value to a set. O(1).
683      *
684      * Returns true if the value was added to the set, that is if it was not
685      * already present.
686      */
687     function _add(Set storage set, bytes32 value) private returns (bool) {
688         if (!_contains(set, value)) {
689             set._values.push(value);
690             // The value is stored at length-1, but we add 1 to all indexes
691             // and use 0 as a sentinel value
692             set._indexes[value] = set._values.length;
693             return true;
694         } else {
695             return false;
696         }
697     }
698 
699     /**
700      * @dev Removes a value from a set. O(1).
701      *
702      * Returns true if the value was removed from the set, that is if it was
703      * present.
704      */
705     function _remove(Set storage set, bytes32 value) private returns (bool) {
706         // We read and store the value's index to prevent multiple reads from the same storage slot
707         uint256 valueIndex = set._indexes[value];
708 
709         if (valueIndex != 0) { // Equivalent to contains(set, value)
710             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
711             // the array, and then remove the last element (sometimes called as 'swap and pop').
712             // This modifies the order of the array, as noted in {at}.
713 
714             uint256 toDeleteIndex = valueIndex - 1;
715             uint256 lastIndex = set._values.length - 1;
716 
717             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
718             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
719 
720             bytes32 lastvalue = set._values[lastIndex];
721 
722             // Move the last value to the index where the value to delete is
723             set._values[toDeleteIndex] = lastvalue;
724             // Update the index for the moved value
725             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
726 
727             // Delete the slot where the moved value was stored
728             set._values.pop();
729 
730             // Delete the index for the deleted slot
731             delete set._indexes[value];
732 
733             return true;
734         } else {
735             return false;
736         }
737     }
738 
739     /**
740      * @dev Returns true if the value is in the set. O(1).
741      */
742     function _contains(Set storage set, bytes32 value) private view returns (bool) {
743         return set._indexes[value] != 0;
744     }
745 
746     /**
747      * @dev Returns the number of values on the set. O(1).
748      */
749     function _length(Set storage set) private view returns (uint256) {
750         return set._values.length;
751     }
752 
753    /**
754     * @dev Returns the value stored at position `index` in the set. O(1).
755     *
756     * Note that there are no guarantees on the ordering of values inside the
757     * array, and it may change when more values are added or removed.
758     *
759     * Requirements:
760     *
761     * - `index` must be strictly less than {length}.
762     */
763     function _at(Set storage set, uint256 index) private view returns (bytes32) {
764         require(set._values.length > index, "EnumerableSet: index out of bounds");
765         return set._values[index];
766     }
767 
768     // Bytes32Set
769 
770     struct Bytes32Set {
771         Set _inner;
772     }
773 
774     /**
775      * @dev Add a value to a set. O(1).
776      *
777      * Returns true if the value was added to the set, that is if it was not
778      * already present.
779      */
780     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
781         return _add(set._inner, value);
782     }
783 
784     /**
785      * @dev Removes a value from a set. O(1).
786      *
787      * Returns true if the value was removed from the set, that is if it was
788      * present.
789      */
790     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
791         return _remove(set._inner, value);
792     }
793 
794     /**
795      * @dev Returns true if the value is in the set. O(1).
796      */
797     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
798         return _contains(set._inner, value);
799     }
800 
801     /**
802      * @dev Returns the number of values in the set. O(1).
803      */
804     function length(Bytes32Set storage set) internal view returns (uint256) {
805         return _length(set._inner);
806     }
807 
808    /**
809     * @dev Returns the value stored at position `index` in the set. O(1).
810     *
811     * Note that there are no guarantees on the ordering of values inside the
812     * array, and it may change when more values are added or removed.
813     *
814     * Requirements:
815     *
816     * - `index` must be strictly less than {length}.
817     */
818     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
819         return _at(set._inner, index);
820     }
821 
822     // AddressSet
823 
824     struct AddressSet {
825         Set _inner;
826     }
827 
828     /**
829      * @dev Add a value to a set. O(1).
830      *
831      * Returns true if the value was added to the set, that is if it was not
832      * already present.
833      */
834     function add(AddressSet storage set, address value) internal returns (bool) {
835         return _add(set._inner, bytes32(uint256(value)));
836     }
837 
838     /**
839      * @dev Removes a value from a set. O(1).
840      *
841      * Returns true if the value was removed from the set, that is if it was
842      * present.
843      */
844     function remove(AddressSet storage set, address value) internal returns (bool) {
845         return _remove(set._inner, bytes32(uint256(value)));
846     }
847 
848     /**
849      * @dev Returns true if the value is in the set. O(1).
850      */
851     function contains(AddressSet storage set, address value) internal view returns (bool) {
852         return _contains(set._inner, bytes32(uint256(value)));
853     }
854 
855     /**
856      * @dev Returns the number of values in the set. O(1).
857      */
858     function length(AddressSet storage set) internal view returns (uint256) {
859         return _length(set._inner);
860     }
861 
862    /**
863     * @dev Returns the value stored at position `index` in the set. O(1).
864     *
865     * Note that there are no guarantees on the ordering of values inside the
866     * array, and it may change when more values are added or removed.
867     *
868     * Requirements:
869     *
870     * - `index` must be strictly less than {length}.
871     */
872     function at(AddressSet storage set, uint256 index) internal view returns (address) {
873         return address(uint256(_at(set._inner, index)));
874     }
875 
876 
877     // UintSet
878 
879     struct UintSet {
880         Set _inner;
881     }
882 
883     /**
884      * @dev Add a value to a set. O(1).
885      *
886      * Returns true if the value was added to the set, that is if it was not
887      * already present.
888      */
889     function add(UintSet storage set, uint256 value) internal returns (bool) {
890         return _add(set._inner, bytes32(value));
891     }
892 
893     /**
894      * @dev Removes a value from a set. O(1).
895      *
896      * Returns true if the value was removed from the set, that is if it was
897      * present.
898      */
899     function remove(UintSet storage set, uint256 value) internal returns (bool) {
900         return _remove(set._inner, bytes32(value));
901     }
902 
903     /**
904      * @dev Returns true if the value is in the set. O(1).
905      */
906     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
907         return _contains(set._inner, bytes32(value));
908     }
909 
910     /**
911      * @dev Returns the number of values on the set. O(1).
912      */
913     function length(UintSet storage set) internal view returns (uint256) {
914         return _length(set._inner);
915     }
916 
917    /**
918     * @dev Returns the value stored at position `index` in the set. O(1).
919     *
920     * Note that there are no guarantees on the ordering of values inside the
921     * array, and it may change when more values are added or removed.
922     *
923     * Requirements:
924     *
925     * - `index` must be strictly less than {length}.
926     */
927     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
928         return uint256(_at(set._inner, index));
929     }
930 }
931 
932 pragma solidity >=0.6.0 <0.8.0;
933 
934 /**
935  * @dev Library for managing an enumerable variant of Solidity's
936  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
937  * type.
938  *
939  * Maps have the following properties:
940  *
941  * - Entries are added, removed, and checked for existence in constant time
942  * (O(1)).
943  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
944  *
945  * ```
946  * contract Example {
947  *     // Add the library methods
948  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
949  *
950  *     // Declare a set state variable
951  *     EnumerableMap.UintToAddressMap private myMap;
952  * }
953  * ```
954  *
955  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
956  * supported.
957  */
958 library EnumerableMap {
959     // To implement this library for multiple types with as little code
960     // repetition as possible, we write it in terms of a generic Map type with
961     // bytes32 keys and values.
962     // The Map implementation uses private functions, and user-facing
963     // implementations (such as Uint256ToAddressMap) are just wrappers around
964     // the underlying Map.
965     // This means that we can only create new EnumerableMaps for types that fit
966     // in bytes32.
967 
968     struct MapEntry {
969         bytes32 _key;
970         bytes32 _value;
971     }
972 
973     struct Map {
974         // Storage of map keys and values
975         MapEntry[] _entries;
976 
977         // Position of the entry defined by a key in the `entries` array, plus 1
978         // because index 0 means a key is not in the map.
979         mapping (bytes32 => uint256) _indexes;
980     }
981 
982     /**
983      * @dev Adds a key-value pair to a map, or updates the value for an existing
984      * key. O(1).
985      *
986      * Returns true if the key was added to the map, that is if it was not
987      * already present.
988      */
989     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
990         // We read and store the key's index to prevent multiple reads from the same storage slot
991         uint256 keyIndex = map._indexes[key];
992 
993         if (keyIndex == 0) { // Equivalent to !contains(map, key)
994             map._entries.push(MapEntry({ _key: key, _value: value }));
995             // The entry is stored at length-1, but we add 1 to all indexes
996             // and use 0 as a sentinel value
997             map._indexes[key] = map._entries.length;
998             return true;
999         } else {
1000             map._entries[keyIndex - 1]._value = value;
1001             return false;
1002         }
1003     }
1004 
1005     /**
1006      * @dev Removes a key-value pair from a map. O(1).
1007      *
1008      * Returns true if the key was removed from the map, that is if it was present.
1009      */
1010     function _remove(Map storage map, bytes32 key) private returns (bool) {
1011         // We read and store the key's index to prevent multiple reads from the same storage slot
1012         uint256 keyIndex = map._indexes[key];
1013 
1014         if (keyIndex != 0) { // Equivalent to contains(map, key)
1015             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1016             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1017             // This modifies the order of the array, as noted in {at}.
1018 
1019             uint256 toDeleteIndex = keyIndex - 1;
1020             uint256 lastIndex = map._entries.length - 1;
1021 
1022             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1023             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1024 
1025             MapEntry storage lastEntry = map._entries[lastIndex];
1026 
1027             // Move the last entry to the index where the entry to delete is
1028             map._entries[toDeleteIndex] = lastEntry;
1029             // Update the index for the moved entry
1030             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1031 
1032             // Delete the slot where the moved entry was stored
1033             map._entries.pop();
1034 
1035             // Delete the index for the deleted slot
1036             delete map._indexes[key];
1037 
1038             return true;
1039         } else {
1040             return false;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Returns true if the key is in the map. O(1).
1046      */
1047     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1048         return map._indexes[key] != 0;
1049     }
1050 
1051     /**
1052      * @dev Returns the number of key-value pairs in the map. O(1).
1053      */
1054     function _length(Map storage map) private view returns (uint256) {
1055         return map._entries.length;
1056     }
1057 
1058    /**
1059     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1060     *
1061     * Note that there are no guarantees on the ordering of entries inside the
1062     * array, and it may change when more entries are added or removed.
1063     *
1064     * Requirements:
1065     *
1066     * - `index` must be strictly less than {length}.
1067     */
1068     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1069         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1070 
1071         MapEntry storage entry = map._entries[index];
1072         return (entry._key, entry._value);
1073     }
1074 
1075     /**
1076      * @dev Returns the value associated with `key`.  O(1).
1077      *
1078      * Requirements:
1079      *
1080      * - `key` must be in the map.
1081      */
1082     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1083         return _get(map, key, "EnumerableMap: nonexistent key");
1084     }
1085 
1086     /**
1087      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1088      */
1089     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1090         uint256 keyIndex = map._indexes[key];
1091         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1092         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1093     }
1094 
1095     // UintToAddressMap
1096 
1097     struct UintToAddressMap {
1098         Map _inner;
1099     }
1100 
1101     /**
1102      * @dev Adds a key-value pair to a map, or updates the value for an existing
1103      * key. O(1).
1104      *
1105      * Returns true if the key was added to the map, that is if it was not
1106      * already present.
1107      */
1108     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1109         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1110     }
1111 
1112     /**
1113      * @dev Removes a value from a set. O(1).
1114      *
1115      * Returns true if the key was removed from the map, that is if it was present.
1116      */
1117     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1118         return _remove(map._inner, bytes32(key));
1119     }
1120 
1121     /**
1122      * @dev Returns true if the key is in the map. O(1).
1123      */
1124     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1125         return _contains(map._inner, bytes32(key));
1126     }
1127 
1128     /**
1129      * @dev Returns the number of elements in the map. O(1).
1130      */
1131     function length(UintToAddressMap storage map) internal view returns (uint256) {
1132         return _length(map._inner);
1133     }
1134 
1135    /**
1136     * @dev Returns the element stored at position `index` in the set. O(1).
1137     * Note that there are no guarantees on the ordering of values inside the
1138     * array, and it may change when more values are added or removed.
1139     *
1140     * Requirements:
1141     *
1142     * - `index` must be strictly less than {length}.
1143     */
1144     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1145         (bytes32 key, bytes32 value) = _at(map._inner, index);
1146         return (uint256(key), address(uint256(value)));
1147     }
1148 
1149     /**
1150      * @dev Returns the value associated with `key`.  O(1).
1151      *
1152      * Requirements:
1153      *
1154      * - `key` must be in the map.
1155      */
1156     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1157         return address(uint256(_get(map._inner, bytes32(key))));
1158     }
1159 
1160     /**
1161      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1162      */
1163     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1164         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1165     }
1166 }
1167 
1168 
1169 pragma solidity >=0.6.0 <0.8.0;
1170 
1171 /**
1172  * @dev String operations.
1173  */
1174 library Strings {
1175     /**
1176      * @dev Converts a `uint256` to its ASCII `string` representation.
1177      */
1178     function toString(uint256 value) internal pure returns (string memory) {
1179         // Inspired by OraclizeAPI's implementation - MIT licence
1180         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1181 
1182         if (value == 0) {
1183             return "0";
1184         }
1185         uint256 temp = value;
1186         uint256 digits;
1187         while (temp != 0) {
1188             digits++;
1189             temp /= 10;
1190         }
1191         bytes memory buffer = new bytes(digits);
1192         uint256 index = digits - 1;
1193         temp = value;
1194         while (temp != 0) {
1195             buffer[index--] = byte(uint8(48 + temp % 10));
1196             temp /= 10;
1197         }
1198         return string(buffer);
1199     }
1200 }
1201 
1202 /**
1203  * @title ERC721 Non-Fungible Token Standard basic implementation
1204  * @dev see https://eips.ethereum.org/EIPS/eip-721
1205  */
1206 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1207     using SafeMath for uint256;
1208     using Address for address;
1209     using EnumerableSet for EnumerableSet.UintSet;
1210     using EnumerableMap for EnumerableMap.UintToAddressMap;
1211     using Strings for uint256;
1212 
1213     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1214     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1215     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1216 
1217     // Mapping from holder address to their (enumerable) set of owned tokens
1218     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1219 
1220     // Enumerable mapping from token ids to their owners
1221     EnumerableMap.UintToAddressMap private _tokenOwners;
1222 
1223     // Mapping from token ID to approved address
1224     mapping (uint256 => address) private _tokenApprovals;
1225 
1226     // Mapping from owner to operator approvals
1227     mapping (address => mapping (address => bool)) private _operatorApprovals;
1228 
1229     // Token name
1230     string private _name;
1231 
1232     // Token symbol
1233     string private _symbol;
1234 
1235     // Optional mapping for token URIs
1236     mapping (uint256 => string) private _tokenURIs;
1237 
1238     // Base URI
1239     string private _baseURI;
1240 
1241     /*
1242      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1243      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1244      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1245      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1246      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1247      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1248      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1249      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1250      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1251      *
1252      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1253      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1254      */
1255     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1256 
1257     /*
1258      *     bytes4(keccak256('name()')) == 0x06fdde03
1259      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1260      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1261      *
1262      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1263      */
1264     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1265 
1266     /*
1267      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1268      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1269      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1270      *
1271      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1272      */
1273     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1274 
1275     /**
1276      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1277      */
1278     constructor (string memory name_, string memory symbol_) public {
1279         _name = name_;
1280         _symbol = symbol_;
1281 
1282         // register the supported interfaces to conform to ERC721 via ERC165
1283         _registerInterface(_INTERFACE_ID_ERC721);
1284         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1285         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-balanceOf}.
1290      */
1291     function balanceOf(address owner) public view override returns (uint256) {
1292         require(owner != address(0), "ERC721: balance query for the zero address");
1293 
1294         return _holderTokens[owner].length();
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-ownerOf}.
1299      */
1300     function ownerOf(uint256 tokenId) public view override returns (address) {
1301         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Metadata-name}.
1306      */
1307     function name() public view override returns (string memory) {
1308         return _name;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Metadata-symbol}.
1313      */
1314     function symbol() public view override returns (string memory) {
1315         return _symbol;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Metadata-tokenURI}.
1320      */
1321     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1322         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1323         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1324     }
1325     
1326     /**
1327     * @dev Returns the base URI set via {_setBaseURI}. This will be
1328     * automatically added as a prefix in {tokenURI} to each token's URI, or
1329     * to the token ID if no specific URI is set for that token ID.
1330     */
1331     function baseURI() public view returns (string memory) {
1332         return _baseURI;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1337      */
1338     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1339         return _holderTokens[owner].at(index);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Enumerable-totalSupply}.
1344      */
1345     function totalSupply() public view override returns (uint256) {
1346         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1347         return _tokenOwners.length();
1348     }
1349 
1350     /**
1351      * @dev See {IERC721Enumerable-tokenByIndex}.
1352      */
1353     function tokenByIndex(uint256 index) public view override returns (uint256) {
1354         (uint256 tokenId, ) = _tokenOwners.at(index);
1355         return tokenId;
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-approve}.
1360      */
1361     function approve(address to, uint256 tokenId) public virtual override {
1362         address owner = ownerOf(tokenId);
1363         require(to != owner, "ERC721: approval to current owner");
1364 
1365         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1366             "ERC721: approve caller is not owner nor approved for all"
1367         );
1368 
1369         _approve(to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-getApproved}.
1374      */
1375     function getApproved(uint256 tokenId) public view override returns (address) {
1376         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1377 
1378         return _tokenApprovals[tokenId];
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-setApprovalForAll}.
1383      */
1384     function setApprovalForAll(address operator, bool approved) public virtual override {
1385         require(operator != _msgSender(), "ERC721: approve to caller");
1386 
1387         _operatorApprovals[_msgSender()][operator] = approved;
1388         emit ApprovalForAll(_msgSender(), operator, approved);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-isApprovedForAll}.
1393      */
1394     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1395         return _operatorApprovals[owner][operator];
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-transferFrom}.
1400      */
1401     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1402         //solhint-disable-next-line max-line-length
1403         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1404 
1405         _transfer(from, to, tokenId);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-safeTransferFrom}.
1410      */
1411     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1412         safeTransferFrom(from, to, tokenId, "");
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-safeTransferFrom}.
1417      */
1418     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1419         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1420         _safeTransfer(from, to, tokenId, _data);
1421     }
1422 
1423     /**
1424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1426      *
1427      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1428      *
1429      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1430      * implement alternative mechanisms to perform token transfer, such as signature-based.
1431      *
1432      * Requirements:
1433      *
1434      * - `from` cannot be the zero address.
1435      * - `to` cannot be the zero address.
1436      * - `tokenId` token must exist and be owned by `from`.
1437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1442         _transfer(from, to, tokenId);
1443         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1444     }
1445 
1446     /**
1447      * @dev Returns whether `tokenId` exists.
1448      *
1449      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1450      *
1451      * Tokens start existing when they are minted (`_mint`),
1452      * and stop existing when they are burned (`_burn`).
1453      */
1454     function _exists(uint256 tokenId) internal view returns (bool) {
1455         return _tokenOwners.contains(tokenId);
1456     }
1457 
1458     /**
1459      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1460      *
1461      * Requirements:
1462      *
1463      * - `tokenId` must exist.
1464      */
1465     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1466         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1467         address owner = ownerOf(tokenId);
1468         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1469     }
1470 
1471     /**
1472      * @dev Safely mints `tokenId` and transfers it to `to`.
1473      *
1474      * Requirements:
1475      d*
1476      * - `tokenId` must not exist.
1477      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function _safeMint(address to, uint256 tokenId) internal virtual {
1482         _safeMint(to, tokenId, "");
1483     }
1484 
1485     /**
1486      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1487      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1488      */
1489     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1490         _mint(to, tokenId);
1491         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1492     }
1493 
1494     /**
1495      * @dev Mints `tokenId` and transfers it to `to`.
1496      *
1497      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1498      *
1499      * Requirements:
1500      *
1501      * - `tokenId` must not exist.
1502      * - `to` cannot be the zero address.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _mint(address to, uint256 tokenId) internal virtual {
1507         require(to != address(0), "ERC721: mint to the zero address");
1508         require(!_exists(tokenId), "ERC721: token already minted");
1509 
1510         _beforeTokenTransfer(address(0), to, tokenId);
1511 
1512         _holderTokens[to].add(tokenId);
1513 
1514         _tokenOwners.set(tokenId, to);
1515 
1516         emit Transfer(address(0), to, tokenId);
1517     }
1518 
1519     /**
1520      * @dev Destroys `tokenId`.
1521      * The approval is cleared when the token is burned.
1522      *
1523      * Requirements:
1524      *
1525      * - `tokenId` must exist.
1526      *
1527      * Emits a {Transfer} event.
1528      */
1529     function _burn(uint256 tokenId) internal virtual {
1530         address owner = ownerOf(tokenId);
1531 
1532         _beforeTokenTransfer(owner, address(0), tokenId);
1533 
1534         // Clear approvals
1535         _approve(address(0), tokenId);
1536 
1537         // Clear metadata (if any)
1538         if (bytes(_tokenURIs[tokenId]).length != 0) {
1539             delete _tokenURIs[tokenId];
1540         }
1541 
1542         _holderTokens[owner].remove(tokenId);
1543 
1544         _tokenOwners.remove(tokenId);
1545 
1546         emit Transfer(owner, address(0), tokenId);
1547     }
1548 
1549     /**
1550      * @dev Transfers `tokenId` from `from` to `to`.
1551      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1552      *
1553      * Requirements:
1554      *
1555      * - `to` cannot be the zero address.
1556      * - `tokenId` token must be owned by `from`.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1561         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1562         require(to != address(0), "ERC721: transfer to the zero address");
1563 
1564         _beforeTokenTransfer(from, to, tokenId);
1565 
1566         // Clear approvals from the previous owner
1567         _approve(address(0), tokenId);
1568 
1569         _holderTokens[from].remove(tokenId);
1570         _holderTokens[to].add(tokenId);
1571 
1572         _tokenOwners.set(tokenId, to);
1573 
1574         emit Transfer(from, to, tokenId);
1575     }
1576 
1577     /**
1578      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1579      *
1580      * Requirements:
1581      *
1582      * - `tokenId` must exist.
1583      */
1584     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1585         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1586         _tokenURIs[tokenId] = _tokenURI;
1587     }
1588 
1589     /**
1590      * @dev Internal function to set the base URI for all token IDs. It is
1591      * automatically added as a prefix to the value returned in {tokenURI},
1592      * or to the token ID if {tokenURI} is empty.
1593      */
1594     function _setBaseURI(string memory baseURI_) internal virtual {
1595         _baseURI = baseURI_;
1596     }
1597 
1598     /**
1599      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1600      * The call is not executed if the target address is not a contract.
1601      *
1602      * @param from address representing the previous owner of the given token ID
1603      * @param to target address that will receive the tokens
1604      * @param tokenId uint256 ID of the token to be transferred
1605      * @param _data bytes optional data to send along with the call
1606      * @return bool whether the call correctly returned the expected magic value
1607      */
1608     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1609         private returns (bool)
1610     {
1611         if (!to.isContract()) {
1612             return true;
1613         }
1614         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1615             IERC721Receiver(to).onERC721Received.selector,
1616             _msgSender(),
1617             from,
1618             tokenId,
1619             _data
1620         ), "ERC721: transfer to non ERC721Receiver implementer");
1621         bytes4 retval = abi.decode(returndata, (bytes4));
1622         return (retval == _ERC721_RECEIVED);
1623     }
1624 
1625     function _approve(address to, uint256 tokenId) private {
1626         _tokenApprovals[tokenId] = to;
1627         emit Approval(ownerOf(tokenId), to, tokenId);
1628     }
1629 
1630     /**
1631      * @dev Hook that is called before any token transfer. This includes minting
1632      * and burning.
1633      *
1634      * Calling conditions:
1635      *
1636      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1637      * transferred to `to`.
1638      * - When `from` is zero, `tokenId` will be minted for `to`.
1639      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1640      * - `from` cannot be the zero address.
1641      * - `to` cannot be the zero address.
1642      *
1643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1644      */
1645     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1646 }
1647 
1648 /**
1649  * @dev Contract module which provides a basic access control mechanism, where
1650  * there is an account (an owner) that can be granted exclusive access to
1651  * specific functions.
1652  *
1653  * By default, the owner account will be the one that deploys the contract. This
1654  * can later be changed with {transferOwnership}.
1655  *
1656  * This module is used through inheritance. It will make available the modifier
1657  * `onlyOwner`, which can be applied to your functions to restrict their use to
1658  * the owner.
1659  */
1660 abstract contract Ownable is Context {
1661     address private _owner;
1662 
1663     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1664 
1665     /**
1666      * @dev Initializes the contract setting the deployer as the initial owner.
1667      */
1668     constructor () internal {
1669         address msgSender = _msgSender();
1670         _owner = msgSender;
1671         emit OwnershipTransferred(address(0), msgSender);
1672     }
1673 
1674     /**
1675      * @dev Returns the address of the current owner.
1676      */
1677     function owner() public view returns (address) {
1678         return _owner;
1679     }
1680 
1681     /**
1682      * @dev Throws if called by any account other than the owner.
1683      */
1684     modifier onlyOwner() {
1685         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1686         _;
1687     }
1688 
1689     /**
1690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1691      * Can only be called by the current owner.
1692      */
1693     function transferOwnership(address newOwner) public virtual onlyOwner {
1694         require(newOwner != address(0), "Ownable: new owner is the zero address");
1695         emit OwnershipTransferred(_owner, newOwner);
1696         _owner = newOwner;
1697     }
1698 } 
1699 
1700 
1701 /**
1702  * @title Roles
1703  * @dev Library for managing addresses assigned to a Role.
1704  */
1705 library Roles {
1706     struct Role {
1707         mapping (address => bool) bearer;
1708     }
1709 
1710     /**
1711      * @dev Give an account access to this role.
1712      */
1713     function add(Role storage role, address account) internal {
1714         require(!has(role, account), "Roles: account already has role");
1715         role.bearer[account] = true;
1716     }
1717 
1718     /**
1719      * @dev Remove an account's access to this role.
1720      */
1721     function remove(Role storage role, address account) internal {
1722         require(has(role, account), "Roles: account does not have role");
1723         role.bearer[account] = false;
1724     }
1725 
1726     /**
1727      * @dev Check if an account has this role.
1728      * @return bool
1729      */
1730     function has(Role storage role, address account) internal view returns (bool) {
1731         require(account != address(0), "Roles: account is the zero address");
1732         return role.bearer[account];
1733     }
1734 }
1735 
1736 interface JOYContract {
1737     function ownerOf(uint256 tokenId) external view returns (address owner);
1738 }
1739  
1740 contract JOYtoys is ERC721, Ownable {
1741     using SafeMath for uint256;    
1742 
1743     string public joyGalleryLink;
1744     uint256 JOYtoyIndex;
1745     address payable public joyWallet;
1746     
1747     mapping(uint256 => string[30]) JOYtoyArtwork;
1748     mapping(uint256 => string[30]) artworkTypeMemory;    
1749     mapping(uint256 => bool[30]) artworkSlotFilled;    
1750     mapping(uint256 => address[5]) royaltyAddressMemory;
1751     mapping(uint256 => uint256[5]) royaltyPercentageMemory;    
1752     
1753     mapping(uint256 => string) toyNameMemory;
1754     mapping(uint256 => string) featuresMemory;
1755     mapping(uint256 => uint256) editionSizeMemory;
1756     mapping(uint256 => string) powerMemory;
1757     mapping(uint256 => uint256) editionNumberMemory;
1758     mapping(uint256 => uint256) totalCreated;
1759     mapping(uint256 => uint256) totalMinted;
1760     mapping(uint256 => bool) vendingMachineMode;
1761     mapping(uint256 => uint256) priceMemory;
1762     mapping(uint256 => uint256) royaltyLengthMemory;
1763     mapping(uint256 => uint256) royaltyMemory;
1764     mapping(uint256 => uint256) artworkJOYtoyReference;
1765     mapping (uint256 => bool) toyMintingActive;
1766 
1767     mapping(uint256 => uint256) joyCollabTokenId;    
1768     mapping(uint256 => address) joyHolderCollaborator;
1769     mapping(uint256 => bool) joyHolderCollabActive;
1770     mapping(uint256 => uint256) joyHolderCollabPercent;
1771     mapping(uint256 => string) collaboratorNamesMemory;
1772 
1773     string JOYtoyURI1;
1774     string JOYtoyURI2;
1775     
1776     address public joyContractAddress;
1777     JOYContract joyWorld;
1778     
1779     string public artist = "John Orion Young";
1780     string public artworkTypeList;
1781     
1782     constructor() ERC721("JOYWORLD JOYtoys", "JOYtoy") public {
1783     JOYtoyIndex = 1;
1784     updateURI("https://joyworld.azurewebsites.net/api/HttpTrigger?id=");
1785     updateJOYtoyURI("https://joyworldmulti.azurewebsites.net/api/HttpTrigger?id=", "&artworkIndex=");
1786     joyWallet = 0x9aE048c47aef066E03593D5Edb230E3fa80c3f17;
1787     joyContractAddress = 0x6c7B6cc55d4098400aC787C8793205D3E86C37C9;
1788     joyWorld = JOYContract(joyContractAddress);
1789     }  
1790 
1791     event NewJOYtoyCreated(string artworkHash, string artworkType, string power, string toyName, string feature, uint256 editionSize, bool vendingMachine, uint256 price, uint256 royalty, uint256 JOYtoyIndex);
1792     event AddJOYtoyRoyalties(uint256 JOYtoyId, uint256 count);
1793     event AddJOYCollector(uint256 JOYtoyId, uint256 joyTokenId, uint256 joyCollectorPercent, bool collectorActive);    
1794     event ClearRoyalties(uint256 JOYtoyId);
1795     event NewArtworkAdded(uint256 JOYtoyToUpdate, string artworkHash, string artworkType, uint256 artworkIndex);  
1796     event UpdateFeature(uint256 JOYtoyToUpdate, string newFeatures);
1797     event UpdatePrice(uint256 JOYtoyToUpdate, uint256 price);
1798     event CloseJOYtoyWindow(uint256 JOYtoyId);
1799     
1800     function createJOYtoy(string memory artworkHash, string memory artworkType, string memory power, string memory toyName, string memory feature, uint256 editionSize, bool vendingMachine, uint256 price, uint256 royalty) public onlyOwner {
1801         toyMintingActive[JOYtoyIndex] = true;
1802         
1803         JOYtoyArtwork[JOYtoyIndex][1] = artworkHash;
1804         artworkTypeMemory[JOYtoyIndex][1] = artworkType;
1805         powerMemory[JOYtoyIndex] = power;
1806         toyNameMemory[JOYtoyIndex] = toyName;
1807         featuresMemory[JOYtoyIndex] = feature;
1808         editionSizeMemory[JOYtoyIndex] = editionSize;
1809         totalCreated[JOYtoyIndex] = 0;
1810         totalMinted[JOYtoyIndex] = 0;
1811         artworkSlotFilled[JOYtoyIndex][1] = true;
1812         vendingMachineMode[JOYtoyIndex] = vendingMachine;
1813         priceMemory[JOYtoyIndex] = price;
1814         royaltyMemory[JOYtoyIndex] = royalty;
1815         
1816         emit NewJOYtoyCreated(artworkHash, artworkType, power, toyName, feature, editionSize, vendingMachine, price, royalty, JOYtoyIndex);
1817             
1818         JOYtoyIndex = JOYtoyIndex + 1;
1819     }
1820     
1821     function addJOYtoyRoyalties(uint256 JOYtoyId, address[] memory royaltyAddresses, uint256[] memory royaltyPercentage, string memory collaboratorNames) public onlyOwner {
1822         require(royaltyAddresses.length == royaltyPercentage.length);
1823         require(royaltyAddresses.length <= 5);
1824         
1825         uint256 totalCollaboratorRoyalties;
1826         collaboratorNamesMemory[JOYtoyId] = collaboratorNames;
1827         
1828         for(uint256 i=0; i<royaltyAddresses.length; i++){
1829             royaltyAddressMemory[JOYtoyId][i] = royaltyAddresses[i];
1830             royaltyPercentageMemory[JOYtoyId][i] = royaltyPercentage[i];
1831             totalCollaboratorRoyalties = totalCollaboratorRoyalties + royaltyPercentage[i];
1832         }
1833         
1834         royaltyLengthMemory[JOYtoyId] = royaltyAddresses.length;
1835         
1836         emit AddJOYtoyRoyalties(JOYtoyId, royaltyAddresses.length);
1837     }
1838     
1839     function getRoyalties(uint256 JOYtoyId) public view returns (address[5] memory addresses, uint256[5] memory percentages) {
1840         for(uint256 i=0; i<royaltyLengthMemory[JOYtoyId]; i++){
1841             addresses[i] = royaltyAddressMemory[JOYtoyId][i];
1842             percentages[i] = royaltyPercentageMemory[JOYtoyId][i];
1843         }    
1844     }
1845     
1846     function addJOYCollector(uint256 JOYtoyId, uint256 joyTokenId, uint256 joyCollectorPercent, bool collectorActive) public onlyOwner {
1847         joyCollabTokenId[JOYtoyId] = joyTokenId;
1848         joyHolderCollaborator[JOYtoyId] = originalJOYOwner(joyTokenId);
1849         joyHolderCollabPercent[JOYtoyId] = joyCollectorPercent;
1850         joyHolderCollabActive[JOYtoyId] = collectorActive;
1851         
1852         emit AddJOYCollector(JOYtoyId, joyTokenId, joyCollectorPercent, collectorActive);
1853     }
1854     
1855     function getJoyCollaborator(uint256 JOYtoyId) public view returns (uint256 joyTokenId, address joyTokenHolder, uint256 joyCollectorPercent, bool collectorActive) {
1856         joyTokenId = joyCollabTokenId[JOYtoyId];
1857         joyTokenHolder = joyHolderCollaborator[JOYtoyId];
1858         joyCollectorPercent = joyHolderCollabPercent[JOYtoyId];
1859         collectorActive = joyHolderCollabActive[JOYtoyId];
1860     }
1861     
1862     function clearRoyalties(uint256 JOYtoyId) public onlyOwner {
1863         for(uint256 i=0; i<royaltyLengthMemory[JOYtoyId]; i++){
1864             royaltyAddressMemory[JOYtoyId][i] = 0x0000000000000000000000000000000000000000;
1865             royaltyPercentageMemory[JOYtoyId][i] = 0;
1866         }
1867         
1868         collaboratorNamesMemory[JOYtoyId] = "";
1869         royaltyLengthMemory[JOYtoyId] = 0;
1870         
1871         emit ClearRoyalties(JOYtoyId);
1872     }
1873   
1874     function addJOYtoyArtwork(uint256 JOYtoyToUpdate, string memory artworkHash, string memory artworkType, uint256 artworkIndex) public onlyOwner{
1875         require(artworkSlotFilled[JOYtoyToUpdate][artworkIndex] == false);
1876         
1877         JOYtoyArtwork[JOYtoyToUpdate][artworkIndex] = artworkHash;
1878         artworkTypeMemory[JOYtoyToUpdate][artworkIndex] = artworkType;
1879             
1880         artworkSlotFilled[JOYtoyToUpdate][artworkIndex] = true;
1881         
1882         emit NewArtworkAdded(JOYtoyToUpdate, artworkHash, artworkType, artworkIndex);
1883     }
1884 
1885     function updateFeature(uint256 JOYtoyToUpdate, string memory newFeatures) public onlyOwner{
1886         featuresMemory[JOYtoyToUpdate] = newFeatures; 
1887         
1888         emit UpdateFeature(JOYtoyToUpdate, newFeatures);
1889     }
1890    
1891     function updatePrice(uint256 JOYtoyToUpdate, uint256 price) public onlyOwner{
1892         priceMemory[JOYtoyToUpdate] = price;
1893         
1894         emit UpdatePrice(JOYtoyToUpdate, price/10**18);
1895     }
1896     
1897     function mintJOYtoy(uint256 JOYtoyId, uint256 amountToMint) public onlyOwner {
1898         require(toyMintingActive[JOYtoyId] == true);
1899         require(totalMinted[JOYtoyId] + amountToMint <= editionSizeMemory[JOYtoyId]);
1900         
1901         for(uint256 i=totalMinted[JOYtoyId]; i<amountToMint + totalMinted[JOYtoyId]; i++) {
1902             uint256 tokenId = totalSupply() + 1;
1903             artworkJOYtoyReference[tokenId] = JOYtoyId;
1904             editionNumberMemory[tokenId] = i + 1;
1905 
1906             _safeMint(msg.sender, tokenId);
1907         }
1908 
1909         totalMinted[JOYtoyId] = totalMinted[JOYtoyId] + amountToMint;
1910         
1911         if (totalMinted[JOYtoyId] == editionSizeMemory[JOYtoyId]) {
1912             closeJOYtoyWindow(JOYtoyId);
1913         }
1914     }
1915 
1916     function JOYtoyMachine(uint256 JOYtoyId) public payable {
1917         require(toyMintingActive[JOYtoyId] == true);
1918         require(totalMinted[JOYtoyId] + 1 <= editionSizeMemory[JOYtoyId]);
1919         require(vendingMachineMode[JOYtoyId] == true);
1920         require(msg.value == priceMemory[JOYtoyId]);
1921         
1922         uint256 tokenId = totalSupply() + 1;
1923         artworkJOYtoyReference[tokenId] = JOYtoyId;
1924         editionNumberMemory[tokenId] = totalMinted[JOYtoyId] + 1;
1925         
1926         (address[5] memory royaltyAddress, uint256[5] memory percentage) = getRoyalties(JOYtoyId); 
1927         
1928         for(uint256 i=0; i<royaltyLengthMemory[JOYtoyId]; i++){
1929             address payable artistWallet = address(uint160(royaltyAddress[i]));
1930             artistWallet.transfer(msg.value/100*percentage[i]);   
1931         }
1932         
1933         if(joyHolderCollabActive[JOYtoyId] == true){
1934             address payable joyHolder = address(uint160(joyHolderCollaborator[JOYtoyId]));
1935             uint256 joyHolderPercentage = joyHolderCollabPercent[JOYtoyId];
1936             
1937             joyHolder.transfer(msg.value/100*joyHolderPercentage);
1938         }
1939         
1940         joyWallet.transfer(address(this).balance);
1941 
1942         _safeMint(msg.sender, tokenId);
1943 
1944         totalMinted[JOYtoyId] = totalMinted[JOYtoyId] + 1;
1945         
1946         if (totalMinted[JOYtoyId] == editionSizeMemory[JOYtoyId]) {
1947             closeJOYtoyWindow(JOYtoyId);
1948         }
1949     }
1950 
1951     function closeJOYtoyWindow(uint256 JOYtoyId) public onlyOwner {
1952         toyMintingActive[JOYtoyId] = false;
1953         editionSizeMemory[JOYtoyId] = totalMinted[JOYtoyId];
1954         
1955         emit CloseJOYtoyWindow(JOYtoyId); 
1956     }
1957     
1958     function withdrawFunds() public onlyOwner {
1959         msg.sender.transfer(address(this).balance);
1960     }
1961 
1962     function getJOYtoyArtworkData(uint256 JOYtoyId, uint256 index) public view returns (string memory artworkHash, string memory artworkType, uint256 unmintedEditions) {
1963         artworkHash = JOYtoyArtwork[JOYtoyId][index];
1964         artworkType = artworkTypeMemory[JOYtoyId][index];
1965         unmintedEditions = editionSizeMemory[JOYtoyId] - totalMinted[JOYtoyId];
1966 
1967     }
1968     
1969     function getMetadata(uint256 tokenId) public view returns (string memory toyName, string memory power, uint256 editionSize, uint256 editionNumber, bool vendingMachine, string memory feature, uint256 price, string memory collaborators, bool toyActive) {
1970         require(_exists(tokenId), "Token does not exist.");
1971         uint256 JOYtoyRef = artworkJOYtoyReference[tokenId];
1972         
1973         toyName = toyNameMemory[JOYtoyRef];
1974         power = powerMemory[JOYtoyRef];
1975         editionSize = editionSizeMemory[JOYtoyRef];
1976         editionNumber = editionNumberMemory[tokenId];
1977         vendingMachine = vendingMachineMode[JOYtoyRef];
1978         feature = featuresMemory[JOYtoyRef];
1979         price = priceMemory[JOYtoyRef];
1980         collaborators = collaboratorNamesMemory[JOYtoyRef];
1981         toyActive = toyMintingActive[JOYtoyRef];
1982     }
1983     
1984     function getRoyaltyData(uint256 tokenId) public view returns (address artistAddress, uint256 royaltyFeeById) {
1985         require(_exists(tokenId), "Token does not exist.");
1986         uint256 JOYtoyRef = artworkJOYtoyReference[tokenId];
1987         
1988         artistAddress = joyWallet;
1989         royaltyFeeById = royaltyMemory[JOYtoyRef];
1990     }
1991     
1992     function getArtworkData(uint256 tokenId, uint256 index) public view returns (string memory artworkHash, string memory artworkType) {
1993         require(_exists(tokenId), "Token does not exist.");
1994         uint256 JOYtoyRef = artworkJOYtoyReference[tokenId];
1995         
1996         artworkHash = JOYtoyArtwork[JOYtoyRef][index];
1997         artworkType = artworkTypeMemory[JOYtoyRef][index];        
1998     }
1999     
2000     function updateGalleryLink(string memory newURL) public onlyOwner {
2001         joyGalleryLink = newURL;
2002     }
2003 
2004     function updatePaymentWallet(address payable newWallet) public onlyOwner {
2005         joyWallet = newWallet;
2006     }
2007     
2008     function updateURI(string memory newURI) public onlyOwner {
2009         _setBaseURI(newURI);
2010     }
2011     
2012     function updateJOYtoyURI(string memory newURI1, string memory newURI2) public onlyOwner {
2013         JOYtoyURI1 = newURI1;
2014         JOYtoyURI2 = newURI2;
2015     }
2016     
2017     function JOYtoyURI(uint256 tokenId, uint256 artworkIndex) external view returns (string memory) {
2018         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2019         return string(abi.encodePacked(JOYtoyURI1, integerToString(tokenId), JOYtoyURI2, integerToString(artworkIndex)));
2020     }
2021     
2022     function originalJOYOwner(uint256 joyTokenId) public view returns (address ownerOfJOY) {
2023         ownerOfJOY = joyWorld.ownerOf(joyTokenId);        
2024     }
2025     
2026     function updateArtworkTypeList(string memory newArtworkTypeList) public onlyOwner {
2027         artworkTypeList = newArtworkTypeList; 
2028     }
2029 
2030     function updateJOYContractAddress(address newJOYaddress) public onlyOwner {
2031         joyContractAddress = newJOYaddress;
2032         joyWorld = JOYContract(joyContractAddress);
2033     }    
2034     
2035     function integerToString(uint _i) internal pure returns (string memory) {
2036         if (_i == 0) {
2037             return "0";
2038         }
2039         
2040         uint j = _i;
2041         uint len;
2042       
2043         while (j != 0) {
2044             len++;
2045             j /= 10;
2046         }
2047       
2048         bytes memory bstr = new bytes(len);
2049         uint k = len - 1;
2050       
2051         while (_i != 0) {
2052             bstr[k--] = byte(uint8(48 + _i % 10));
2053             _i /= 10;
2054         }
2055       return string(bstr);
2056     }    
2057        
2058 }