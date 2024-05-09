1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with GSN meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 
51 
52 
53 /**
54  * @dev String operations.
55  */
56 library Strings {
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` representation.
59      */
60     function toString(uint256 value) internal pure returns (string memory) {
61         // Inspired by OraclizeAPI's implementation - MIT licence
62         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
63 
64         if (value == 0) {
65             return "0";
66         }
67         uint256 temp = value;
68         uint256 digits;
69         while (temp != 0) {
70             digits++;
71             temp /= 10;
72         }
73         bytes memory buffer = new bytes(digits);
74         uint256 index = digits - 1;
75         temp = value;
76         while (temp != 0) {
77             buffer[index--] = byte(uint8(48 + temp % 10));
78             temp /= 10;
79         }
80         return string(buffer);
81     }
82 }
83 
84 
85 
86 
87 
88 
89 /**
90  * @dev Implementation of the {IERC165} interface.
91  *
92  * Contracts may inherit from this and call {_registerInterface} to declare
93  * their support of an interface.
94  */
95 contract ERC165 is IERC165 {
96     /*
97      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
98      */
99     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
100 
101     /**
102      * @dev Mapping of interface ids to whether or not it's supported.
103      */
104     mapping(bytes4 => bool) private _supportedInterfaces;
105 
106     constructor () internal {
107         // Derived contracts need only register support for their own interfaces,
108         // we register support for ERC165 itself here
109         _registerInterface(_INTERFACE_ID_ERC165);
110     }
111 
112     /**
113      * @dev See {IERC165-supportsInterface}.
114      *
115      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
118         return _supportedInterfaces[interfaceId];
119     }
120 
121     /**
122      * @dev Registers the contract as an implementer of the interface defined by
123      * `interfaceId`. Support of the actual ERC165 interface is automatic and
124      * registering its interface id is not required.
125      *
126      * See {IERC165-supportsInterface}.
127      *
128      * Requirements:
129      *
130      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
131      */
132     function _registerInterface(bytes4 interfaceId) internal virtual {
133         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
134         _supportedInterfaces[interfaceId] = true;
135     }
136 }
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 
147 
148 
149 
150 
151 
152 /**
153  * @dev Required interface of an ERC721 compliant contract.
154  */
155 interface IERC721 is IERC165 {
156     /**
157      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
160 
161     /**
162      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
163      */
164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165 
166     /**
167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
168      */
169     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
170 
171     /**
172      * @dev Returns the number of tokens in ``owner``'s account.
173      */
174     function balanceOf(address owner) external view returns (uint256 balance);
175 
176     /**
177      * @dev Returns the owner of the `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function ownerOf(uint256 tokenId) external view returns (address owner);
184 
185     /**
186      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
187      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must exist and be owned by `from`.
194      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(address from, address to, uint256 tokenId) external;
200 
201     /**
202      * @dev Transfers `tokenId` token from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address from, address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external;
231 
232     /**
233      * @dev Returns the account approved for `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function getApproved(uint256 tokenId) external view returns (address operator);
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     /**
261       * @dev Safely transfers `tokenId` token from `from` to `to`.
262       *
263       * Requirements:
264       *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267       * - `tokenId` token must exist and be owned by `from`.
268       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
269       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270       *
271       * Emits a {Transfer} event.
272       */
273     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
274 }
275 
276 
277 
278 
279 
280 
281 
282 /**
283  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
284  * @dev See https://eips.ethereum.org/EIPS/eip-721
285  */
286 interface IERC721Metadata is IERC721 {
287 
288     /**
289      * @dev Returns the token collection name.
290      */
291     function name() external view returns (string memory);
292 
293     /**
294      * @dev Returns the token collection symbol.
295      */
296     function symbol() external view returns (string memory);
297 
298     /**
299      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
300      */
301     function tokenURI(uint256 tokenId) external view returns (string memory);
302 }
303 
304 
305 
306 
307 
308 
309 
310 /**
311  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
312  * @dev See https://eips.ethereum.org/EIPS/eip-721
313  */
314 interface IERC721Enumerable is IERC721 {
315 
316     /**
317      * @dev Returns the total amount of tokens stored by the contract.
318      */
319     function totalSupply() external view returns (uint256);
320 
321     /**
322      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
323      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
324      */
325     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
326 
327     /**
328      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
329      * Use along with {totalSupply} to enumerate all tokens.
330      */
331     function tokenByIndex(uint256 index) external view returns (uint256);
332 }
333 
334 
335 
336 
337 
338 /**
339  * @title ERC721 token receiver interface
340  * @dev Interface for any contract that wants to support safeTransfers
341  * from ERC721 asset contracts.
342  */
343 interface IERC721Receiver {
344     /**
345      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
346      * by `operator` from `from`, this function is called.
347      *
348      * It must return its Solidity selector to confirm the token transfer.
349      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
350      *
351      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
352      */
353     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
354     external returns (bytes4);
355 }
356 
357 
358 
359 
360 
361 
362 /**
363  * @dev Wrappers over Solidity's arithmetic operations with added overflow
364  * checks.
365  *
366  * Arithmetic operations in Solidity wrap on overflow. This can easily result
367  * in bugs, because programmers usually assume that an overflow raises an
368  * error, which is the standard behavior in high level programming languages.
369  * `SafeMath` restores this intuition by reverting the transaction when an
370  * operation overflows.
371  *
372  * Using this library instead of the unchecked operations eliminates an entire
373  * class of bugs, so it's recommended to use it always.
374  */
375 library SafeMath {
376     /**
377      * @dev Returns the addition of two unsigned integers, reverting on
378      * overflow.
379      *
380      * Counterpart to Solidity's `+` operator.
381      *
382      * Requirements:
383      *
384      * - Addition cannot overflow.
385      */
386     function add(uint256 a, uint256 b) internal pure returns (uint256) {
387         uint256 c = a + b;
388         require(c >= a, "SafeMath: addition overflow");
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the subtraction of two unsigned integers, reverting on
395      * overflow (when the result is negative).
396      *
397      * Counterpart to Solidity's `-` operator.
398      *
399      * Requirements:
400      *
401      * - Subtraction cannot overflow.
402      */
403     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
404         return sub(a, b, "SafeMath: subtraction overflow");
405     }
406 
407     /**
408      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
409      * overflow (when the result is negative).
410      *
411      * Counterpart to Solidity's `-` operator.
412      *
413      * Requirements:
414      *
415      * - Subtraction cannot overflow.
416      */
417     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
418         require(b <= a, errorMessage);
419         uint256 c = a - b;
420 
421         return c;
422     }
423 
424     /**
425      * @dev Returns the multiplication of two unsigned integers, reverting on
426      * overflow.
427      *
428      * Counterpart to Solidity's `*` operator.
429      *
430      * Requirements:
431      *
432      * - Multiplication cannot overflow.
433      */
434     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
436         // benefit is lost if 'b' is also tested.
437         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
438         if (a == 0) {
439             return 0;
440         }
441 
442         uint256 c = a * b;
443         require(c / a == b, "SafeMath: multiplication overflow");
444 
445         return c;
446     }
447 
448     /**
449      * @dev Returns the integer division of two unsigned integers. Reverts on
450      * division by zero. The result is rounded towards zero.
451      *
452      * Counterpart to Solidity's `/` operator. Note: this function uses a
453      * `revert` opcode (which leaves remaining gas untouched) while Solidity
454      * uses an invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function div(uint256 a, uint256 b) internal pure returns (uint256) {
461         return div(a, b, "SafeMath: division by zero");
462     }
463 
464     /**
465      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
466      * division by zero. The result is rounded towards zero.
467      *
468      * Counterpart to Solidity's `/` operator. Note: this function uses a
469      * `revert` opcode (which leaves remaining gas untouched) while Solidity
470      * uses an invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      *
474      * - The divisor cannot be zero.
475      */
476     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
477         require(b > 0, errorMessage);
478         uint256 c = a / b;
479         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
480 
481         return c;
482     }
483 
484     /**
485      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
486      * Reverts when dividing by zero.
487      *
488      * Counterpart to Solidity's `%` operator. This function uses a `revert`
489      * opcode (which leaves remaining gas untouched) while Solidity uses an
490      * invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
497         return mod(a, b, "SafeMath: modulo by zero");
498     }
499 
500     /**
501      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
502      * Reverts with custom message when dividing by zero.
503      *
504      * Counterpart to Solidity's `%` operator. This function uses a `revert`
505      * opcode (which leaves remaining gas untouched) while Solidity uses an
506      * invalid opcode to revert (consuming all remaining gas).
507      *
508      * Requirements:
509      *
510      * - The divisor cannot be zero.
511      */
512     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b != 0, errorMessage);
514         return a % b;
515     }
516 }
517 
518 
519 
520 
521 
522 /**
523  * @dev Collection of functions related to the address type
524  */
525 library Address {
526     /**
527      * @dev Returns true if `account` is a contract.
528      *
529      * [IMPORTANT]
530      * ====
531      * It is unsafe to assume that an address for which this function returns
532      * false is an externally-owned account (EOA) and not a contract.
533      *
534      * Among others, `isContract` will return false for the following
535      * types of addresses:
536      *
537      *  - an externally-owned account
538      *  - a contract in construction
539      *  - an address where a contract will be created
540      *  - an address where a contract lived, but was destroyed
541      * ====
542      */
543     function isContract(address account) internal view returns (bool) {
544         // This method relies in extcodesize, which returns 0 for contracts in
545         // construction, since the code is only stored at the end of the
546         // constructor execution.
547 
548         uint256 size;
549         // solhint-disable-next-line no-inline-assembly
550         assembly { size := extcodesize(account) }
551         return size > 0;
552     }
553 
554     /**
555      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
556      * `recipient`, forwarding all available gas and reverting on errors.
557      *
558      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
559      * of certain opcodes, possibly making contracts go over the 2300 gas limit
560      * imposed by `transfer`, making them unable to receive funds via
561      * `transfer`. {sendValue} removes this limitation.
562      *
563      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
564      *
565      * IMPORTANT: because control is transferred to `recipient`, care must be
566      * taken to not create reentrancy vulnerabilities. Consider using
567      * {ReentrancyGuard} or the
568      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
569      */
570     function sendValue(address payable recipient, uint256 amount) internal {
571         require(address(this).balance >= amount, "Address: insufficient balance");
572 
573         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
574         (bool success, ) = recipient.call{ value: amount }("");
575         require(success, "Address: unable to send value, recipient may have reverted");
576     }
577 
578     /**
579      * @dev Performs a Solidity function call using a low level `call`. A
580      * plain`call` is an unsafe replacement for a function call: use this
581      * function instead.
582      *
583      * If `target` reverts with a revert reason, it is bubbled up by this
584      * function (like regular Solidity function calls).
585      *
586      * Returns the raw returned data. To convert to the expected return value,
587      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
588      *
589      * Requirements:
590      *
591      * - `target` must be a contract.
592      * - calling `target` with `data` must not revert.
593      *
594      * _Available since v3.1._
595      */
596     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
597       return functionCall(target, data, "Address: low-level call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
602      * `errorMessage` as a fallback revert reason when `target` reverts.
603      *
604      * _Available since v3.1._
605      */
606     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
607         return _functionCallWithValue(target, data, 0, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but also transferring `value` wei to `target`.
613      *
614      * Requirements:
615      *
616      * - the calling contract must have an ETH balance of at least `value`.
617      * - the called Solidity function must be `payable`.
618      *
619      * _Available since v3.1._
620      */
621     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
622         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
623     }
624 
625     /**
626      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
627      * with `errorMessage` as a fallback revert reason when `target` reverts.
628      *
629      * _Available since v3.1._
630      */
631     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
632         require(address(this).balance >= value, "Address: insufficient balance for call");
633         return _functionCallWithValue(target, data, value, errorMessage);
634     }
635 
636     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
637         require(isContract(target), "Address: call to non-contract");
638 
639         // solhint-disable-next-line avoid-low-level-calls
640         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
641         if (success) {
642             return returndata;
643         } else {
644             // Look for revert reason and bubble it up if present
645             if (returndata.length > 0) {
646                 // The easiest way to bubble the revert reason is using memory via assembly
647 
648                 // solhint-disable-next-line no-inline-assembly
649                 assembly {
650                     let returndata_size := mload(returndata)
651                     revert(add(32, returndata), returndata_size)
652                 }
653             } else {
654                 revert(errorMessage);
655             }
656         }
657     }
658 }
659 
660 
661 
662 
663 
664 /**
665  * @dev Library for managing
666  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
667  * types.
668  *
669  * Sets have the following properties:
670  *
671  * - Elements are added, removed, and checked for existence in constant time
672  * (O(1)).
673  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
674  *
675  * ```
676  * contract Example {
677  *     // Add the library methods
678  *     using EnumerableSet for EnumerableSet.AddressSet;
679  *
680  *     // Declare a set state variable
681  *     EnumerableSet.AddressSet private mySet;
682  * }
683  * ```
684  *
685  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
686  * (`UintSet`) are supported.
687  */
688 library EnumerableSet {
689     // To implement this library for multiple types with as little code
690     // repetition as possible, we write it in terms of a generic Set type with
691     // bytes32 values.
692     // The Set implementation uses private functions, and user-facing
693     // implementations (such as AddressSet) are just wrappers around the
694     // underlying Set.
695     // This means that we can only create new EnumerableSets for types that fit
696     // in bytes32.
697 
698     struct Set {
699         // Storage of set values
700         bytes32[] _values;
701 
702         // Position of the value in the `values` array, plus 1 because index 0
703         // means a value is not in the set.
704         mapping (bytes32 => uint256) _indexes;
705     }
706 
707     /**
708      * @dev Add a value to a set. O(1).
709      *
710      * Returns true if the value was added to the set, that is if it was not
711      * already present.
712      */
713     function _add(Set storage set, bytes32 value) private returns (bool) {
714         if (!_contains(set, value)) {
715             set._values.push(value);
716             // The value is stored at length-1, but we add 1 to all indexes
717             // and use 0 as a sentinel value
718             set._indexes[value] = set._values.length;
719             return true;
720         } else {
721             return false;
722         }
723     }
724 
725     /**
726      * @dev Removes a value from a set. O(1).
727      *
728      * Returns true if the value was removed from the set, that is if it was
729      * present.
730      */
731     function _remove(Set storage set, bytes32 value) private returns (bool) {
732         // We read and store the value's index to prevent multiple reads from the same storage slot
733         uint256 valueIndex = set._indexes[value];
734 
735         if (valueIndex != 0) { // Equivalent to contains(set, value)
736             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
737             // the array, and then remove the last element (sometimes called as 'swap and pop').
738             // This modifies the order of the array, as noted in {at}.
739 
740             uint256 toDeleteIndex = valueIndex - 1;
741             uint256 lastIndex = set._values.length - 1;
742 
743             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
744             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
745 
746             bytes32 lastvalue = set._values[lastIndex];
747 
748             // Move the last value to the index where the value to delete is
749             set._values[toDeleteIndex] = lastvalue;
750             // Update the index for the moved value
751             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
752 
753             // Delete the slot where the moved value was stored
754             set._values.pop();
755 
756             // Delete the index for the deleted slot
757             delete set._indexes[value];
758 
759             return true;
760         } else {
761             return false;
762         }
763     }
764 
765     /**
766      * @dev Returns true if the value is in the set. O(1).
767      */
768     function _contains(Set storage set, bytes32 value) private view returns (bool) {
769         return set._indexes[value] != 0;
770     }
771 
772     /**
773      * @dev Returns the number of values on the set. O(1).
774      */
775     function _length(Set storage set) private view returns (uint256) {
776         return set._values.length;
777     }
778 
779    /**
780     * @dev Returns the value stored at position `index` in the set. O(1).
781     *
782     * Note that there are no guarantees on the ordering of values inside the
783     * array, and it may change when more values are added or removed.
784     *
785     * Requirements:
786     *
787     * - `index` must be strictly less than {length}.
788     */
789     function _at(Set storage set, uint256 index) private view returns (bytes32) {
790         require(set._values.length > index, "EnumerableSet: index out of bounds");
791         return set._values[index];
792     }
793 
794     // AddressSet
795 
796     struct AddressSet {
797         Set _inner;
798     }
799 
800     /**
801      * @dev Add a value to a set. O(1).
802      *
803      * Returns true if the value was added to the set, that is if it was not
804      * already present.
805      */
806     function add(AddressSet storage set, address value) internal returns (bool) {
807         return _add(set._inner, bytes32(uint256(value)));
808     }
809 
810     /**
811      * @dev Removes a value from a set. O(1).
812      *
813      * Returns true if the value was removed from the set, that is if it was
814      * present.
815      */
816     function remove(AddressSet storage set, address value) internal returns (bool) {
817         return _remove(set._inner, bytes32(uint256(value)));
818     }
819 
820     /**
821      * @dev Returns true if the value is in the set. O(1).
822      */
823     function contains(AddressSet storage set, address value) internal view returns (bool) {
824         return _contains(set._inner, bytes32(uint256(value)));
825     }
826 
827     /**
828      * @dev Returns the number of values in the set. O(1).
829      */
830     function length(AddressSet storage set) internal view returns (uint256) {
831         return _length(set._inner);
832     }
833 
834    /**
835     * @dev Returns the value stored at position `index` in the set. O(1).
836     *
837     * Note that there are no guarantees on the ordering of values inside the
838     * array, and it may change when more values are added or removed.
839     *
840     * Requirements:
841     *
842     * - `index` must be strictly less than {length}.
843     */
844     function at(AddressSet storage set, uint256 index) internal view returns (address) {
845         return address(uint256(_at(set._inner, index)));
846     }
847 
848 
849     // UintSet
850 
851     struct UintSet {
852         Set _inner;
853     }
854 
855     /**
856      * @dev Add a value to a set. O(1).
857      *
858      * Returns true if the value was added to the set, that is if it was not
859      * already present.
860      */
861     function add(UintSet storage set, uint256 value) internal returns (bool) {
862         return _add(set._inner, bytes32(value));
863     }
864 
865     /**
866      * @dev Removes a value from a set. O(1).
867      *
868      * Returns true if the value was removed from the set, that is if it was
869      * present.
870      */
871     function remove(UintSet storage set, uint256 value) internal returns (bool) {
872         return _remove(set._inner, bytes32(value));
873     }
874 
875     /**
876      * @dev Returns true if the value is in the set. O(1).
877      */
878     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
879         return _contains(set._inner, bytes32(value));
880     }
881 
882     /**
883      * @dev Returns the number of values on the set. O(1).
884      */
885     function length(UintSet storage set) internal view returns (uint256) {
886         return _length(set._inner);
887     }
888 
889    /**
890     * @dev Returns the value stored at position `index` in the set. O(1).
891     *
892     * Note that there are no guarantees on the ordering of values inside the
893     * array, and it may change when more values are added or removed.
894     *
895     * Requirements:
896     *
897     * - `index` must be strictly less than {length}.
898     */
899     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
900         return uint256(_at(set._inner, index));
901     }
902 }
903 
904 
905 
906 
907 
908 /**
909  * @dev Library for managing an enumerable variant of Solidity's
910  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
911  * type.
912  *
913  * Maps have the following properties:
914  *
915  * - Entries are added, removed, and checked for existence in constant time
916  * (O(1)).
917  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
918  *
919  * ```
920  * contract Example {
921  *     // Add the library methods
922  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
923  *
924  *     // Declare a set state variable
925  *     EnumerableMap.UintToAddressMap private myMap;
926  * }
927  * ```
928  *
929  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
930  * supported.
931  */
932 library EnumerableMap {
933     // To implement this library for multiple types with as little code
934     // repetition as possible, we write it in terms of a generic Map type with
935     // bytes32 keys and values.
936     // The Map implementation uses private functions, and user-facing
937     // implementations (such as Uint256ToAddressMap) are just wrappers around
938     // the underlying Map.
939     // This means that we can only create new EnumerableMaps for types that fit
940     // in bytes32.
941 
942     struct MapEntry {
943         bytes32 _key;
944         bytes32 _value;
945     }
946 
947     struct Map {
948         // Storage of map keys and values
949         MapEntry[] _entries;
950 
951         // Position of the entry defined by a key in the `entries` array, plus 1
952         // because index 0 means a key is not in the map.
953         mapping (bytes32 => uint256) _indexes;
954     }
955 
956     /**
957      * @dev Adds a key-value pair to a map, or updates the value for an existing
958      * key. O(1).
959      *
960      * Returns true if the key was added to the map, that is if it was not
961      * already present.
962      */
963     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
964         // We read and store the key's index to prevent multiple reads from the same storage slot
965         uint256 keyIndex = map._indexes[key];
966 
967         if (keyIndex == 0) { // Equivalent to !contains(map, key)
968             map._entries.push(MapEntry({ _key: key, _value: value }));
969             // The entry is stored at length-1, but we add 1 to all indexes
970             // and use 0 as a sentinel value
971             map._indexes[key] = map._entries.length;
972             return true;
973         } else {
974             map._entries[keyIndex - 1]._value = value;
975             return false;
976         }
977     }
978 
979     /**
980      * @dev Removes a key-value pair from a map. O(1).
981      *
982      * Returns true if the key was removed from the map, that is if it was present.
983      */
984     function _remove(Map storage map, bytes32 key) private returns (bool) {
985         // We read and store the key's index to prevent multiple reads from the same storage slot
986         uint256 keyIndex = map._indexes[key];
987 
988         if (keyIndex != 0) { // Equivalent to contains(map, key)
989             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
990             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
991             // This modifies the order of the array, as noted in {at}.
992 
993             uint256 toDeleteIndex = keyIndex - 1;
994             uint256 lastIndex = map._entries.length - 1;
995 
996             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
997             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
998 
999             MapEntry storage lastEntry = map._entries[lastIndex];
1000 
1001             // Move the last entry to the index where the entry to delete is
1002             map._entries[toDeleteIndex] = lastEntry;
1003             // Update the index for the moved entry
1004             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1005 
1006             // Delete the slot where the moved entry was stored
1007             map._entries.pop();
1008 
1009             // Delete the index for the deleted slot
1010             delete map._indexes[key];
1011 
1012             return true;
1013         } else {
1014             return false;
1015         }
1016     }
1017 
1018     /**
1019      * @dev Returns true if the key is in the map. O(1).
1020      */
1021     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1022         return map._indexes[key] != 0;
1023     }
1024 
1025     /**
1026      * @dev Returns the number of key-value pairs in the map. O(1).
1027      */
1028     function _length(Map storage map) private view returns (uint256) {
1029         return map._entries.length;
1030     }
1031 
1032    /**
1033     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1034     *
1035     * Note that there are no guarantees on the ordering of entries inside the
1036     * array, and it may change when more entries are added or removed.
1037     *
1038     * Requirements:
1039     *
1040     * - `index` must be strictly less than {length}.
1041     */
1042     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1043         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1044 
1045         MapEntry storage entry = map._entries[index];
1046         return (entry._key, entry._value);
1047     }
1048 
1049     /**
1050      * @dev Returns the value associated with `key`.  O(1).
1051      *
1052      * Requirements:
1053      *
1054      * - `key` must be in the map.
1055      */
1056     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1057         return _get(map, key, "EnumerableMap: nonexistent key");
1058     }
1059 
1060     /**
1061      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1062      */
1063     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1064         uint256 keyIndex = map._indexes[key];
1065         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1066         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1067     }
1068 
1069     // UintToAddressMap
1070 
1071     struct UintToAddressMap {
1072         Map _inner;
1073     }
1074 
1075     /**
1076      * @dev Adds a key-value pair to a map, or updates the value for an existing
1077      * key. O(1).
1078      *
1079      * Returns true if the key was added to the map, that is if it was not
1080      * already present.
1081      */
1082     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1083         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1084     }
1085 
1086     /**
1087      * @dev Removes a value from a set. O(1).
1088      *
1089      * Returns true if the key was removed from the map, that is if it was present.
1090      */
1091     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1092         return _remove(map._inner, bytes32(key));
1093     }
1094 
1095     /**
1096      * @dev Returns true if the key is in the map. O(1).
1097      */
1098     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1099         return _contains(map._inner, bytes32(key));
1100     }
1101 
1102     /**
1103      * @dev Returns the number of elements in the map. O(1).
1104      */
1105     function length(UintToAddressMap storage map) internal view returns (uint256) {
1106         return _length(map._inner);
1107     }
1108 
1109    /**
1110     * @dev Returns the element stored at position `index` in the set. O(1).
1111     * Note that there are no guarantees on the ordering of values inside the
1112     * array, and it may change when more values are added or removed.
1113     *
1114     * Requirements:
1115     *
1116     * - `index` must be strictly less than {length}.
1117     */
1118     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1119         (bytes32 key, bytes32 value) = _at(map._inner, index);
1120         return (uint256(key), address(uint256(value)));
1121     }
1122 
1123     /**
1124      * @dev Returns the value associated with `key`.  O(1).
1125      *
1126      * Requirements:
1127      *
1128      * - `key` must be in the map.
1129      */
1130     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1131         return address(uint256(_get(map._inner, bytes32(key))));
1132     }
1133 
1134     /**
1135      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1136      */
1137     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1138         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1139     }
1140 }
1141 
1142 
1143 
1144 /**
1145  * @title ERC721 Non-Fungible Token Standard basic implementation
1146  * @dev see https://eips.ethereum.org/EIPS/eip-721
1147  */
1148 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1149     using SafeMath for uint256;
1150     using Address for address;
1151     using EnumerableSet for EnumerableSet.UintSet;
1152     using EnumerableMap for EnumerableMap.UintToAddressMap;
1153     using Strings for uint256;
1154 
1155     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1156     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1157     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1158 
1159     // Mapping from holder address to their (enumerable) set of owned tokens
1160     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1161 
1162     // Enumerable mapping from token ids to their owners
1163     EnumerableMap.UintToAddressMap private _tokenOwners;
1164 
1165     // Mapping from token ID to approved address
1166     mapping (uint256 => address) private _tokenApprovals;
1167 
1168     // Mapping from owner to operator approvals
1169     mapping (address => mapping (address => bool)) private _operatorApprovals;
1170 
1171     // Token name
1172     string private _name;
1173 
1174     // Token symbol
1175     string private _symbol;
1176 
1177     // Optional mapping for token URIs
1178     mapping (uint256 => string) private _tokenURIs;
1179 
1180     // Base URI
1181     string private _baseURI;
1182 
1183     /*
1184      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1185      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1186      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1187      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1188      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1189      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1190      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1191      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1192      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1193      *
1194      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1195      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1196      */
1197     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1198 
1199     /*
1200      *     bytes4(keccak256('name()')) == 0x06fdde03
1201      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1202      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1203      *
1204      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1205      */
1206     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1207 
1208     /*
1209      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1210      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1211      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1212      *
1213      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1214      */
1215     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1216 
1217     /**
1218      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1219      */
1220     constructor (string memory name, string memory symbol) public {
1221         _name = name;
1222         _symbol = symbol;
1223 
1224         // register the supported interfaces to conform to ERC721 via ERC165
1225         _registerInterface(_INTERFACE_ID_ERC721);
1226         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1227         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-balanceOf}.
1232      */
1233     function balanceOf(address owner) public view override returns (uint256) {
1234         require(owner != address(0), "ERC721: balance query for the zero address");
1235 
1236         return _holderTokens[owner].length();
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-ownerOf}.
1241      */
1242     function ownerOf(uint256 tokenId) public view override returns (address) {
1243         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-name}.
1248      */
1249     function name() public view override returns (string memory) {
1250         return _name;
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Metadata-symbol}.
1255      */
1256     function symbol() public view override returns (string memory) {
1257         return _symbol;
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Metadata-tokenURI}.
1262      */
1263     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1264         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1265 
1266         string memory _tokenURI = _tokenURIs[tokenId];
1267 
1268         // If there is no base URI, return the token URI.
1269         if (bytes(_baseURI).length == 0) {
1270             return _tokenURI;
1271         }
1272         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1273         if (bytes(_tokenURI).length > 0) {
1274             return string(abi.encodePacked(_baseURI, _tokenURI));
1275         }
1276         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1277         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1278     }
1279 
1280     /**
1281     * @dev Returns the base URI set via {_setBaseURI}. This will be
1282     * automatically added as a prefix in {tokenURI} to each token's URI, or
1283     * to the token ID if no specific URI is set for that token ID.
1284     */
1285     function baseURI() public view returns (string memory) {
1286         return _baseURI;
1287     }
1288 
1289     /**
1290      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1291      */
1292     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1293         return _holderTokens[owner].at(index);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view override returns (uint256) {
1300         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1301         return _tokenOwners.length();
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Enumerable-tokenByIndex}.
1306      */
1307     function tokenByIndex(uint256 index) public view override returns (uint256) {
1308         (uint256 tokenId, ) = _tokenOwners.at(index);
1309         return tokenId;
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-approve}.
1314      */
1315     function approve(address to, uint256 tokenId) public virtual override {
1316         address owner = ownerOf(tokenId);
1317         require(to != owner, "ERC721: approval to current owner");
1318 
1319         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1320             "ERC721: approve caller is not owner nor approved for all"
1321         );
1322 
1323         _approve(to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-getApproved}.
1328      */
1329     function getApproved(uint256 tokenId) public view override returns (address) {
1330         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1331 
1332         return _tokenApprovals[tokenId];
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-setApprovalForAll}.
1337      */
1338     function setApprovalForAll(address operator, bool approved) public virtual override {
1339         require(operator != _msgSender(), "ERC721: approve to caller");
1340 
1341         _operatorApprovals[_msgSender()][operator] = approved;
1342         emit ApprovalForAll(_msgSender(), operator, approved);
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-isApprovedForAll}.
1347      */
1348     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1349         return _operatorApprovals[owner][operator];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-transferFrom}.
1354      */
1355     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1356         //solhint-disable-next-line max-line-length
1357         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1358 
1359         _transfer(from, to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-safeTransferFrom}.
1364      */
1365     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1366         safeTransferFrom(from, to, tokenId, "");
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-safeTransferFrom}.
1371      */
1372     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1373         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1374         _safeTransfer(from, to, tokenId, _data);
1375     }
1376 
1377     /**
1378      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1379      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1380      *
1381      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1382      *
1383      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1384      * implement alternative mechanisms to perform token transfer, such as signature-based.
1385      *
1386      * Requirements:
1387      *
1388      * - `from` cannot be the zero address.
1389      * - `to` cannot be the zero address.
1390      * - `tokenId` token must exist and be owned by `from`.
1391      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1396         _transfer(from, to, tokenId);
1397         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1398     }
1399 
1400     /**
1401      * @dev Returns whether `tokenId` exists.
1402      *
1403      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1404      *
1405      * Tokens start existing when they are minted (`_mint`),
1406      * and stop existing when they are burned (`_burn`).
1407      */
1408     function _exists(uint256 tokenId) internal view returns (bool) {
1409         return _tokenOwners.contains(tokenId);
1410     }
1411 
1412     /**
1413      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1420         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1421         address owner = ownerOf(tokenId);
1422         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1423     }
1424 
1425     /**
1426      * @dev Safely mints `tokenId` and transfers it to `to`.
1427      *
1428      * Requirements:
1429      d*
1430      * - `tokenId` must not exist.
1431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _safeMint(address to, uint256 tokenId) internal virtual {
1436         _safeMint(to, tokenId, "");
1437     }
1438 
1439     /**
1440      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1441      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1442      */
1443     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1444         _mint(to, tokenId);
1445         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1446     }
1447 
1448     /**
1449      * @dev Mints `tokenId` and transfers it to `to`.
1450      *
1451      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1452      *
1453      * Requirements:
1454      *
1455      * - `tokenId` must not exist.
1456      * - `to` cannot be the zero address.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _mint(address to, uint256 tokenId) internal virtual {
1461         require(to != address(0), "ERC721: mint to the zero address");
1462         require(!_exists(tokenId), "ERC721: token already minted");
1463 
1464         _beforeTokenTransfer(address(0), to, tokenId);
1465 
1466         _holderTokens[to].add(tokenId);
1467 
1468         _tokenOwners.set(tokenId, to);
1469 
1470         emit Transfer(address(0), to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev Destroys `tokenId`.
1475      * The approval is cleared when the token is burned.
1476      *
1477      * Requirements:
1478      *
1479      * - `tokenId` must exist.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function _burn(uint256 tokenId) internal virtual {
1484         address owner = ownerOf(tokenId);
1485 
1486         _beforeTokenTransfer(owner, address(0), tokenId);
1487 
1488         // Clear approvals
1489         _approve(address(0), tokenId);
1490 
1491         // Clear metadata (if any)
1492         if (bytes(_tokenURIs[tokenId]).length != 0) {
1493             delete _tokenURIs[tokenId];
1494         }
1495 
1496         _holderTokens[owner].remove(tokenId);
1497 
1498         _tokenOwners.remove(tokenId);
1499 
1500         emit Transfer(owner, address(0), tokenId);
1501     }
1502 
1503     /**
1504      * @dev Transfers `tokenId` from `from` to `to`.
1505      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1506      *
1507      * Requirements:
1508      *
1509      * - `to` cannot be the zero address.
1510      * - `tokenId` token must be owned by `from`.
1511      *
1512      * Emits a {Transfer} event.
1513      */
1514     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1515         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1516         require(to != address(0), "ERC721: transfer to the zero address");
1517 
1518         _beforeTokenTransfer(from, to, tokenId);
1519 
1520         // Clear approvals from the previous owner
1521         _approve(address(0), tokenId);
1522 
1523         _holderTokens[from].remove(tokenId);
1524         _holderTokens[to].add(tokenId);
1525 
1526         _tokenOwners.set(tokenId, to);
1527 
1528         emit Transfer(from, to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must exist.
1537      */
1538     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1539         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1540         _tokenURIs[tokenId] = _tokenURI;
1541     }
1542 
1543     /**
1544      * @dev Internal function to set the base URI for all token IDs. It is
1545      * automatically added as a prefix to the value returned in {tokenURI},
1546      * or to the token ID if {tokenURI} is empty.
1547      */
1548     function _setBaseURI(string memory baseURI_) internal virtual {
1549         _baseURI = baseURI_;
1550     }
1551 
1552     /**
1553      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1554      * The call is not executed if the target address is not a contract.
1555      *
1556      * @param from address representing the previous owner of the given token ID
1557      * @param to target address that will receive the tokens
1558      * @param tokenId uint256 ID of the token to be transferred
1559      * @param _data bytes optional data to send along with the call
1560      * @return bool whether the call correctly returned the expected magic value
1561      */
1562     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1563         private returns (bool)
1564     {
1565         if (!to.isContract()) {
1566             return true;
1567         }
1568         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1569             IERC721Receiver(to).onERC721Received.selector,
1570             _msgSender(),
1571             from,
1572             tokenId,
1573             _data
1574         ), "ERC721: transfer to non ERC721Receiver implementer");
1575         bytes4 retval = abi.decode(returndata, (bytes4));
1576         return (retval == _ERC721_RECEIVED);
1577     }
1578 
1579     function _approve(address to, uint256 tokenId) private {
1580         _tokenApprovals[tokenId] = to;
1581         emit Approval(ownerOf(tokenId), to, tokenId);
1582     }
1583 
1584     /**
1585      * @dev Hook that is called before any token transfer. This includes minting
1586      * and burning.
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1594      * - `from` cannot be the zero address.
1595      * - `to` cannot be the zero address.
1596      *
1597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1598      */
1599     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1600 }
1601 
1602 
1603 
1604 
1605 
1606 
1607 
1608 /**
1609  * @dev Contract module which provides a basic access control mechanism, where
1610  * there is an account (an owner) that can be granted exclusive access to
1611  * specific functions.
1612  *
1613  * By default, the owner account will be the one that deploys the contract. This
1614  * can later be changed with {transferOwnership}.
1615  *
1616  * This module is used through inheritance. It will make available the modifier
1617  * `onlyOwner`, which can be applied to your functions to restrict their use to
1618  * the owner.
1619  */
1620 contract Ownable is Context {
1621     address private _owner;
1622 
1623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1624 
1625     /**
1626      * @dev Initializes the contract setting the deployer as the initial owner.
1627      */
1628     constructor () internal {
1629         address msgSender = _msgSender();
1630         _owner = msgSender;
1631         emit OwnershipTransferred(address(0), msgSender);
1632     }
1633 
1634     /**
1635      * @dev Returns the address of the current owner.
1636      */
1637     function owner() public view returns (address) {
1638         return _owner;
1639     }
1640 
1641     /**
1642      * @dev Throws if called by any account other than the owner.
1643      */
1644     modifier onlyOwner() {
1645         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1646         _;
1647     }
1648 
1649     /**
1650      * @dev Leaves the contract without owner. It will not be possible to call
1651      * `onlyOwner` functions anymore. Can only be called by the current owner.
1652      *
1653      * NOTE: Renouncing ownership will leave the contract without an owner,
1654      * thereby removing any functionality that is only available to the owner.
1655      */
1656     function renounceOwnership() public virtual onlyOwner {
1657         emit OwnershipTransferred(_owner, address(0));
1658         _owner = address(0);
1659     }
1660 
1661     /**
1662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1663      * Can only be called by the current owner.
1664      */
1665     function transferOwnership(address newOwner) public virtual onlyOwner {
1666         require(newOwner != address(0), "Ownable: new owner is the zero address");
1667         emit OwnershipTransferred(_owner, newOwner);
1668         _owner = newOwner;
1669     }
1670 }
1671 
1672 
1673 contract HasSecondarySaleFees is ERC165 {
1674 	
1675 	mapping(uint256 => address payable[]) royaltyAddressMemory;
1676 	mapping(uint256 => uint256[]) royaltyMemory;  
1677 	mapping(uint256 => uint256) artworkNFTReference;
1678 		
1679    /*
1680 	* bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1681 	* bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1682 	*
1683 	* => 0x0ebd4c7f ^ 0xb9c4d9fb == 0xb7799584
1684 	*/
1685 	
1686 	bytes4 private constant _INTERFACE_ID_FEES = 0xb7799584;
1687 	
1688 	constructor() public {
1689 		_registerInterface(_INTERFACE_ID_FEES);
1690 	}
1691 
1692 	function getFeeRecipients(uint256 id) external view returns (address payable[] memory){
1693 		uint256 NFTRef = artworkNFTReference[id];
1694 		return royaltyAddressMemory[NFTRef];
1695 	}
1696 
1697 	function getFeeBps(uint256 id) external view returns (uint[] memory){
1698 		uint256 NFTRef = artworkNFTReference[id];
1699 		return royaltyMemory[NFTRef];
1700 	}
1701 }
1702 
1703 
1704 contract NFTBoxesNFT is ERC721, Ownable, HasSecondarySaleFees {
1705 	using SafeMath for uint256;    
1706 
1707 	uint256 NFTIndex;
1708 	address public boxContract;
1709 
1710 	mapping(address => bool) public authorisedCaller;
1711 
1712 	mapping(uint256 => string) hashIPFSMemory;
1713 	mapping(uint256 => string) hashArweaveMemory;
1714 	mapping(uint256 => string) artistNameMemory;
1715 	mapping(uint256 => string) artistNoteMemory;
1716 	mapping(uint256 => address) signatureAddressMemory;
1717 	mapping(uint256 => string) signatureHashMemory;
1718 	mapping(uint256 => string) signatureMessageMemory;
1719 	mapping(uint256 => uint256) editionSizeMemory;
1720 	mapping(uint256 => string) artTitleMemory;
1721 	mapping(uint256 => string) artworkTypeMemory;
1722 	mapping(uint256 => uint256) editionNumberMemory;
1723 	mapping(uint256 => string) boxDetailsMemory;
1724 
1725 	mapping(uint256 => uint256) totalCreated;
1726 	mapping(uint256 => uint256) totalMinted;
1727   
1728 	mapping (uint256 => bool) mintingActive;
1729 
1730 	constructor() ERC721("NFTBoxes", "[NFT]") public {
1731 	updateURI("https://nftboxes.azurewebsites.net/api/HttpTrigger?id=");
1732 	NFTIndex = 1;
1733 	boxContract = 0x6A53Dc033D85D98B59F6dc596588860d962a3Cf6;
1734 	}  
1735 
1736 	event NewNFTMouldCreated(uint256 NFTIndex, string artworkHashIPFS, string artworkHashArweave, string artistName, 
1737 	uint256 editionSize, string artTitle, string artworkType, string artworkSeries);
1738 	event NewNFTMouldSignatures(uint256 NFTIndex, address signatureAddress, string signatureHash, string signatureMessage);
1739 	event NewNFTCreatedFor(uint256 NFTId, uint256 tokenId, address recipient);
1740 	event CloseNFTWindow(uint256 NFTId);
1741 	
1742 	modifier authorised() {
1743 		require(authorisedCaller[msg.sender] || msg.sender == owner(), "VendingMachine: Not authorised to execute");
1744 		_;
1745 	}
1746 
1747 	function setCaller(address _caller, bool _value) external onlyOwner {
1748 		authorisedCaller[_caller] = _value;
1749 	}
1750 
1751 	function createNFTMould(
1752 		string memory artworkHashIPFS,
1753 		string memory artworkHashArweave,
1754 		string memory artistName,
1755 		string memory artistNote,
1756 		address signatureAddress,
1757 		string memory signatureHash,
1758 		string memory signatureMessage, 
1759 		uint256 editionSize,
1760 		string memory artTitle,
1761 		string memory artworkType,
1762 		string memory boxDetails,
1763 		address payable[] memory royaltyAddress,
1764 		uint256[] memory royaltyBps) 
1765 		public authorised {
1766 		mintingActive[NFTIndex] = true;
1767 		
1768 		hashIPFSMemory[NFTIndex] = artworkHashIPFS;
1769 		hashArweaveMemory[NFTIndex] = artworkHashArweave;
1770 		artistNameMemory[NFTIndex] = artistName;
1771 		artistNoteMemory[NFTIndex] = artistNote;
1772 		
1773 		signatureAddressMemory[NFTIndex] = signatureAddress;
1774 		signatureHashMemory[NFTIndex] = signatureHash;
1775 		signatureMessageMemory[NFTIndex] = signatureMessage;
1776 		
1777 		editionSizeMemory[NFTIndex] = editionSize;
1778 		artTitleMemory[NFTIndex] = artTitle;
1779 		artworkTypeMemory[NFTIndex] = artworkType;
1780 		boxDetailsMemory[NFTIndex] = boxDetails;
1781  
1782 		totalCreated[NFTIndex] = 0;
1783 		totalMinted[NFTIndex] = 0;
1784 		
1785 		royaltyAddressMemory[NFTIndex] = royaltyAddress;
1786 		royaltyMemory[NFTIndex] = royaltyBps;
1787 		
1788 		emit NewNFTMouldCreated(NFTIndex, artworkHashIPFS, artworkHashArweave, artistName, editionSize, artTitle, artworkType, boxDetails);
1789 		emit NewNFTMouldSignatures(NFTIndex, signatureAddress, signatureHash, signatureMessage);
1790 			
1791 		NFTIndex = NFTIndex + 1;
1792 	}
1793 
1794 	function NFTMachineFor(uint256 NFTId, address _recipient) public authorised {
1795 		require(mintingActive[NFTId] == true, "Mint not active");
1796 		uint256 editionId = totalMinted[NFTId] + 1;
1797 		require(editionId <= editionSizeMemory[NFTId], "Cannot mint more");
1798 		
1799 		uint256 tokenId = totalSupply() + 1;
1800 		artworkNFTReference[tokenId] = NFTId;
1801 		editionNumberMemory[tokenId] = editionId;
1802 		_safeMint(_recipient, tokenId);
1803 
1804 		totalMinted[NFTId] = editionId;
1805 		
1806 		if (totalMinted[NFTId] == editionSizeMemory[NFTId]) {
1807 			_closeNFTWindow(NFTId);
1808 		}
1809 		
1810 		emit NewNFTCreatedFor(NFTId, tokenId, _recipient);
1811 	}
1812 
1813 	function closeNFTWindow(uint256 NFTId) public onlyOwner {
1814 		mintingActive[NFTId] = false;
1815 		editionSizeMemory[NFTId] = totalMinted[NFTId];
1816 		
1817 		emit CloseNFTWindow(NFTId); 
1818 	}
1819 
1820 	function _closeNFTWindow(uint256 NFTId) internal {
1821 		mintingActive[NFTId] = false;
1822 		editionSizeMemory[NFTId] = totalMinted[NFTId];
1823 		
1824 		emit CloseNFTWindow(NFTId); 
1825 	}
1826 	
1827 	function withdrawFunds() public onlyOwner {
1828 		msg.sender.transfer(address(this).balance);
1829 	}
1830 
1831 	function getFileData(uint256 tokenId) public view returns (string memory hashIPFS, string memory hashArweave, string memory artworkType) {
1832 		require(_exists(tokenId), "Token does not exist.");
1833 		uint256 NFTRef = artworkNFTReference[tokenId];
1834 		
1835 		hashIPFS = hashIPFSMemory[NFTRef];
1836 		hashArweave = hashArweaveMemory[NFTRef];
1837 		artworkType = artworkTypeMemory[NFTRef];        
1838 	}
1839 
1840 	function getMetadata(uint256 tokenId) public view returns (string memory artistName, string memory artistNote, uint256 editionSize, string memory artTitle, uint256 editionNumber, string memory boxDetails, bool isActive) {
1841 		require(_exists(tokenId), "Token does not exist.");
1842 		uint256 NFTRef = artworkNFTReference[tokenId];
1843 		
1844 		artistName = artistNameMemory[NFTRef];
1845 		artistNote = artistNoteMemory[NFTRef];
1846 		editionSize = editionSizeMemory[NFTRef];
1847 		artTitle = artTitleMemory[NFTRef];
1848 		editionNumber = editionNumberMemory[tokenId];
1849 		boxDetails = boxDetailsMemory[NFTRef];
1850 
1851 		isActive = mintingActive[NFTRef];
1852 	}
1853 
1854 	function getSignatureData(uint256 tokenId) public view returns (address signatureAddress, string memory signatureHash, string memory signatureMessage) {
1855 		require(_exists(tokenId), "Token does not exist.");
1856 		uint256 NFTRef = artworkNFTReference[tokenId];
1857 		
1858 		signatureAddress = signatureAddressMemory[NFTRef];
1859 		signatureHash = signatureHashMemory[NFTRef];
1860 		signatureMessage = signatureMessageMemory[NFTRef];
1861 	}
1862 
1863 	function NFTMouldFileData(uint256 NFTId) public view returns (string memory hashIPFS, string memory hashArweave, string memory artworkType, uint256 unmintedEditions) {
1864 		hashIPFS = hashIPFSMemory[NFTId];
1865 		hashArweave = hashArweaveMemory[NFTId];
1866 		artworkType = artworkTypeMemory[NFTId];
1867 		unmintedEditions = editionSizeMemory[NFTId] - totalMinted[NFTId];
1868 	}
1869 
1870 	function NFTMouldMetadata(uint256 NFTId) public view returns (string memory artistName, string memory artistNote, uint256 editionSize, string memory artTitle, string memory boxDetails, bool isActive) {
1871 		artistName = artistNameMemory[NFTId];
1872 		artistNote = artistNoteMemory[NFTId];
1873 		editionSize = editionSizeMemory[NFTId];
1874 		artTitle = artTitleMemory[NFTId];
1875 		boxDetails = boxDetailsMemory[NFTId];
1876 		
1877 		isActive = mintingActive[NFTId];
1878 	}
1879 
1880 	function NFTMouldSignatureData(uint256 NFTId) public view returns (address signatureAddress, string memory signatureHash, string memory signatureMessage) {
1881 		signatureAddress = signatureAddressMemory[NFTId];
1882 		signatureHash = signatureHashMemory[NFTId];
1883 		signatureMessage = signatureMessageMemory[NFTId];
1884 	}    
1885 	
1886 	function updateURI(string memory newURI) public onlyOwner {
1887 		_setBaseURI(newURI);
1888 	}
1889 
1890 	function updateBoxContract(address newBoxContract) public onlyOwner {
1891 		boxContract = newBoxContract;
1892 	}       
1893 }