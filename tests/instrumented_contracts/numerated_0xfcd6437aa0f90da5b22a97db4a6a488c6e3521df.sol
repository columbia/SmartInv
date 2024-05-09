1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 /**
48  * @dev Required interface of an ERC721 compliant contract.
49  */
50 interface IERC721 is IERC165 {
51     /**
52      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
53      */
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
65 
66     /**
67      * @dev Returns the number of tokens in ``owner``'s account.
68      */
69     function balanceOf(address owner) external view returns (uint256 balance);
70 
71     /**
72      * @dev Returns the owner of the `tokenId` token.
73      *
74      * Requirements:
75      *
76      * - `tokenId` must exist.
77      */
78     function ownerOf(uint256 tokenId) external view returns (address owner);
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(address from, address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156       * @dev Safely transfers `tokenId` token from `from` to `to`.
157       *
158       * Requirements:
159       *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162       * - `tokenId` token must exist and be owned by `from`.
163       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165       *
166       * Emits a {Transfer} event.
167       */
168     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
169 }
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Metadata is IERC721 {
176 
177     /**
178      * @dev Returns the token collection name.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the token collection symbol.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
189      */
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191 }
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Enumerable is IERC721 {
198 
199     /**
200      * @dev Returns the total amount of tokens stored by the contract.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
206      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
207      */
208     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
209 
210     /**
211      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
212      * Use along with {totalSupply} to enumerate all tokens.
213      */
214     function tokenByIndex(uint256 index) external view returns (uint256);
215 }
216 
217 /**
218  * @title ERC721 token receiver interface
219  * @dev Interface for any contract that wants to support safeTransfers
220  * from ERC721 asset contracts.
221  */
222 interface IERC721Receiver {
223     /**
224      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
225      * by `operator` from `from`, this function is called.
226      *
227      * It must return its Solidity selector to confirm the token transfer.
228      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
229      *
230      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
231      */
232     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
233 }
234 
235 /**
236  * @dev Implementation of the {IERC165} interface.
237  *
238  * Contracts may inherit from this and call {_registerInterface} to declare
239  * their support of an interface.
240  */
241 abstract contract ERC165 is IERC165 {
242     /*
243      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
244      */
245     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
246 
247     /**
248      * @dev Mapping of interface ids to whether or not it's supported.
249      */
250     mapping(bytes4 => bool) private _supportedInterfaces;
251 
252     constructor () {
253         // Derived contracts need only register support for their own interfaces,
254         // we register support for ERC165 itself here
255         _registerInterface(_INTERFACE_ID_ERC165);
256     }
257 
258     /**
259      * @dev See {IERC165-supportsInterface}.
260      *
261      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
262      */
263     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
264         return _supportedInterfaces[interfaceId];
265     }
266 
267     /**
268      * @dev Registers the contract as an implementer of the interface defined by
269      * `interfaceId`. Support of the actual ERC165 interface is automatic and
270      * registering its interface id is not required.
271      *
272      * See {IERC165-supportsInterface}.
273      *
274      * Requirements:
275      *
276      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
277      */
278     function _registerInterface(bytes4 interfaceId) internal virtual {
279         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
280         _supportedInterfaces[interfaceId] = true;
281     }
282 }
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize, which returns 0 for contracts in
307         // construction, since the code is only stored at the end of the
308         // constructor execution.
309 
310         uint256 size;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { size := extcodesize(account) }
313         return size > 0;
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(address(this).balance >= amount, "Address: insufficient balance");
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{ value: amount }("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359       return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: value }(data);
399         return _verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
419         require(isContract(target), "Address: static call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a delegate call.
429      *
430      * _Available since v3.3._
431      */
432     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
433         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a delegate call.
439      *
440      * _Available since v3.3._
441      */
442     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
443         require(isContract(target), "Address: delegate call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
451         if (success) {
452             return returndata;
453         } else {
454             // Look for revert reason and bubble it up if present
455             if (returndata.length > 0) {
456                 // The easiest way to bubble the revert reason is using memory via assembly
457 
458                 // solhint-disable-next-line no-inline-assembly
459                 assembly {
460                     let returndata_size := mload(returndata)
461                     revert(add(32, returndata), returndata_size)
462                 }
463             } else {
464                 revert(errorMessage);
465             }
466         }
467     }
468 }
469 
470 /**
471  * @dev Library for managing
472  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
473  * types.
474  *
475  * Sets have the following properties:
476  *
477  * - Elements are added, removed, and checked for existence in constant time
478  * (O(1)).
479  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
480  *
481  * ```
482  * contract Example {
483  *     // Add the library methods
484  *     using EnumerableSet for EnumerableSet.AddressSet;
485  *
486  *     // Declare a set state variable
487  *     EnumerableSet.AddressSet private mySet;
488  * }
489  * ```
490  *
491  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
492  * and `uint256` (`UintSet`) are supported.
493  */
494 library EnumerableSet {
495     // To implement this library for multiple types with as little code
496     // repetition as possible, we write it in terms of a generic Set type with
497     // bytes32 values.
498     // The Set implementation uses private functions, and user-facing
499     // implementations (such as AddressSet) are just wrappers around the
500     // underlying Set.
501     // This means that we can only create new EnumerableSets for types that fit
502     // in bytes32.
503 
504     struct Set {
505         // Storage of set values
506         bytes32[] _values;
507 
508         // Position of the value in the `values` array, plus 1 because index 0
509         // means a value is not in the set.
510         mapping (bytes32 => uint256) _indexes;
511     }
512 
513     /**
514      * @dev Add a value to a set. O(1).
515      *
516      * Returns true if the value was added to the set, that is if it was not
517      * already present.
518      */
519     function _add(Set storage set, bytes32 value) private returns (bool) {
520         if (!_contains(set, value)) {
521             set._values.push(value);
522             // The value is stored at length-1, but we add 1 to all indexes
523             // and use 0 as a sentinel value
524             set._indexes[value] = set._values.length;
525             return true;
526         } else {
527             return false;
528         }
529     }
530 
531     /**
532      * @dev Removes a value from a set. O(1).
533      *
534      * Returns true if the value was removed from the set, that is if it was
535      * present.
536      */
537     function _remove(Set storage set, bytes32 value) private returns (bool) {
538         // We read and store the value's index to prevent multiple reads from the same storage slot
539         uint256 valueIndex = set._indexes[value];
540 
541         if (valueIndex != 0) { // Equivalent to contains(set, value)
542             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
543             // the array, and then remove the last element (sometimes called as 'swap and pop').
544             // This modifies the order of the array, as noted in {at}.
545 
546             uint256 toDeleteIndex = valueIndex - 1;
547             uint256 lastIndex = set._values.length - 1;
548 
549             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
550             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
551 
552             bytes32 lastvalue = set._values[lastIndex];
553 
554             // Move the last value to the index where the value to delete is
555             set._values[toDeleteIndex] = lastvalue;
556             // Update the index for the moved value
557             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
558 
559             // Delete the slot where the moved value was stored
560             set._values.pop();
561 
562             // Delete the index for the deleted slot
563             delete set._indexes[value];
564 
565             return true;
566         } else {
567             return false;
568         }
569     }
570 
571     /**
572      * @dev Returns true if the value is in the set. O(1).
573      */
574     function _contains(Set storage set, bytes32 value) private view returns (bool) {
575         return set._indexes[value] != 0;
576     }
577 
578     /**
579      * @dev Returns the number of values on the set. O(1).
580      */
581     function _length(Set storage set) private view returns (uint256) {
582         return set._values.length;
583     }
584 
585    /**
586     * @dev Returns the value stored at position `index` in the set. O(1).
587     *
588     * Note that there are no guarantees on the ordering of values inside the
589     * array, and it may change when more values are added or removed.
590     *
591     * Requirements:
592     *
593     * - `index` must be strictly less than {length}.
594     */
595     function _at(Set storage set, uint256 index) private view returns (bytes32) {
596         require(set._values.length > index, "EnumerableSet: index out of bounds");
597         return set._values[index];
598     }
599 
600     // Bytes32Set
601 
602     struct Bytes32Set {
603         Set _inner;
604     }
605 
606     /**
607      * @dev Add a value to a set. O(1).
608      *
609      * Returns true if the value was added to the set, that is if it was not
610      * already present.
611      */
612     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
613         return _add(set._inner, value);
614     }
615 
616     /**
617      * @dev Removes a value from a set. O(1).
618      *
619      * Returns true if the value was removed from the set, that is if it was
620      * present.
621      */
622     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
623         return _remove(set._inner, value);
624     }
625 
626     /**
627      * @dev Returns true if the value is in the set. O(1).
628      */
629     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
630         return _contains(set._inner, value);
631     }
632 
633     /**
634      * @dev Returns the number of values in the set. O(1).
635      */
636     function length(Bytes32Set storage set) internal view returns (uint256) {
637         return _length(set._inner);
638     }
639 
640    /**
641     * @dev Returns the value stored at position `index` in the set. O(1).
642     *
643     * Note that there are no guarantees on the ordering of values inside the
644     * array, and it may change when more values are added or removed.
645     *
646     * Requirements:
647     *
648     * - `index` must be strictly less than {length}.
649     */
650     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
651         return _at(set._inner, index);
652     }
653 
654     // AddressSet
655 
656     struct AddressSet {
657         Set _inner;
658     }
659 
660     /**
661      * @dev Add a value to a set. O(1).
662      *
663      * Returns true if the value was added to the set, that is if it was not
664      * already present.
665      */
666     function add(AddressSet storage set, address value) internal returns (bool) {
667         return _add(set._inner, bytes32(uint256(uint160(value))));
668     }
669 
670     /**
671      * @dev Removes a value from a set. O(1).
672      *
673      * Returns true if the value was removed from the set, that is if it was
674      * present.
675      */
676     function remove(AddressSet storage set, address value) internal returns (bool) {
677         return _remove(set._inner, bytes32(uint256(uint160(value))));
678     }
679 
680     /**
681      * @dev Returns true if the value is in the set. O(1).
682      */
683     function contains(AddressSet storage set, address value) internal view returns (bool) {
684         return _contains(set._inner, bytes32(uint256(uint160(value))));
685     }
686 
687     /**
688      * @dev Returns the number of values in the set. O(1).
689      */
690     function length(AddressSet storage set) internal view returns (uint256) {
691         return _length(set._inner);
692     }
693 
694    /**
695     * @dev Returns the value stored at position `index` in the set. O(1).
696     *
697     * Note that there are no guarantees on the ordering of values inside the
698     * array, and it may change when more values are added or removed.
699     *
700     * Requirements:
701     *
702     * - `index` must be strictly less than {length}.
703     */
704     function at(AddressSet storage set, uint256 index) internal view returns (address) {
705         return address(uint160(uint256(_at(set._inner, index))));
706     }
707 
708 
709     // UintSet
710 
711     struct UintSet {
712         Set _inner;
713     }
714 
715     /**
716      * @dev Add a value to a set. O(1).
717      *
718      * Returns true if the value was added to the set, that is if it was not
719      * already present.
720      */
721     function add(UintSet storage set, uint256 value) internal returns (bool) {
722         return _add(set._inner, bytes32(value));
723     }
724 
725     /**
726      * @dev Removes a value from a set. O(1).
727      *
728      * Returns true if the value was removed from the set, that is if it was
729      * present.
730      */
731     function remove(UintSet storage set, uint256 value) internal returns (bool) {
732         return _remove(set._inner, bytes32(value));
733     }
734 
735     /**
736      * @dev Returns true if the value is in the set. O(1).
737      */
738     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
739         return _contains(set._inner, bytes32(value));
740     }
741 
742     /**
743      * @dev Returns the number of values on the set. O(1).
744      */
745     function length(UintSet storage set) internal view returns (uint256) {
746         return _length(set._inner);
747     }
748 
749    /**
750     * @dev Returns the value stored at position `index` in the set. O(1).
751     *
752     * Note that there are no guarantees on the ordering of values inside the
753     * array, and it may change when more values are added or removed.
754     *
755     * Requirements:
756     *
757     * - `index` must be strictly less than {length}.
758     */
759     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
760         return uint256(_at(set._inner, index));
761     }
762 }
763 
764 /**
765  * @dev Library for managing an enumerable variant of Solidity's
766  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
767  * type.
768  *
769  * Maps have the following properties:
770  *
771  * - Entries are added, removed, and checked for existence in constant time
772  * (O(1)).
773  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
774  *
775  * ```
776  * contract Example {
777  *     // Add the library methods
778  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
779  *
780  *     // Declare a set state variable
781  *     EnumerableMap.UintToAddressMap private myMap;
782  * }
783  * ```
784  *
785  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
786  * supported.
787  */
788 library EnumerableMap {
789     // To implement this library for multiple types with as little code
790     // repetition as possible, we write it in terms of a generic Map type with
791     // bytes32 keys and values.
792     // The Map implementation uses private functions, and user-facing
793     // implementations (such as Uint256ToAddressMap) are just wrappers around
794     // the underlying Map.
795     // This means that we can only create new EnumerableMaps for types that fit
796     // in bytes32.
797 
798     struct MapEntry {
799         bytes32 _key;
800         bytes32 _value;
801     }
802 
803     struct Map {
804         // Storage of map keys and values
805         MapEntry[] _entries;
806 
807         // Position of the entry defined by a key in the `entries` array, plus 1
808         // because index 0 means a key is not in the map.
809         mapping (bytes32 => uint256) _indexes;
810     }
811 
812     /**
813      * @dev Adds a key-value pair to a map, or updates the value for an existing
814      * key. O(1).
815      *
816      * Returns true if the key was added to the map, that is if it was not
817      * already present.
818      */
819     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
820         // We read and store the key's index to prevent multiple reads from the same storage slot
821         uint256 keyIndex = map._indexes[key];
822 
823         if (keyIndex == 0) { // Equivalent to !contains(map, key)
824             map._entries.push(MapEntry({ _key: key, _value: value }));
825             // The entry is stored at length-1, but we add 1 to all indexes
826             // and use 0 as a sentinel value
827             map._indexes[key] = map._entries.length;
828             return true;
829         } else {
830             map._entries[keyIndex - 1]._value = value;
831             return false;
832         }
833     }
834 
835     /**
836      * @dev Removes a key-value pair from a map. O(1).
837      *
838      * Returns true if the key was removed from the map, that is if it was present.
839      */
840     function _remove(Map storage map, bytes32 key) private returns (bool) {
841         // We read and store the key's index to prevent multiple reads from the same storage slot
842         uint256 keyIndex = map._indexes[key];
843 
844         if (keyIndex != 0) { // Equivalent to contains(map, key)
845             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
846             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
847             // This modifies the order of the array, as noted in {at}.
848 
849             uint256 toDeleteIndex = keyIndex - 1;
850             uint256 lastIndex = map._entries.length - 1;
851 
852             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
853             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
854 
855             MapEntry storage lastEntry = map._entries[lastIndex];
856 
857             // Move the last entry to the index where the entry to delete is
858             map._entries[toDeleteIndex] = lastEntry;
859             // Update the index for the moved entry
860             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
861 
862             // Delete the slot where the moved entry was stored
863             map._entries.pop();
864 
865             // Delete the index for the deleted slot
866             delete map._indexes[key];
867 
868             return true;
869         } else {
870             return false;
871         }
872     }
873 
874     /**
875      * @dev Returns true if the key is in the map. O(1).
876      */
877     function _contains(Map storage map, bytes32 key) private view returns (bool) {
878         return map._indexes[key] != 0;
879     }
880 
881     /**
882      * @dev Returns the number of key-value pairs in the map. O(1).
883      */
884     function _length(Map storage map) private view returns (uint256) {
885         return map._entries.length;
886     }
887 
888    /**
889     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
890     *
891     * Note that there are no guarantees on the ordering of entries inside the
892     * array, and it may change when more entries are added or removed.
893     *
894     * Requirements:
895     *
896     * - `index` must be strictly less than {length}.
897     */
898     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
899         require(map._entries.length > index, "EnumerableMap: index out of bounds");
900 
901         MapEntry storage entry = map._entries[index];
902         return (entry._key, entry._value);
903     }
904 
905     /**
906      * @dev Returns the value associated with `key`.  O(1).
907      *
908      * Requirements:
909      *
910      * - `key` must be in the map.
911      */
912     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
913         return _get(map, key, "EnumerableMap: nonexistent key");
914     }
915 
916     /**
917      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
918      */
919     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
920         uint256 keyIndex = map._indexes[key];
921         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
922         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
923     }
924 
925     // UintToAddressMap
926 
927     struct UintToAddressMap {
928         Map _inner;
929     }
930 
931     /**
932      * @dev Adds a key-value pair to a map, or updates the value for an existing
933      * key. O(1).
934      *
935      * Returns true if the key was added to the map, that is if it was not
936      * already present.
937      */
938     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
939         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
940     }
941 
942     /**
943      * @dev Removes a value from a set. O(1).
944      *
945      * Returns true if the key was removed from the map, that is if it was present.
946      */
947     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
948         return _remove(map._inner, bytes32(key));
949     }
950 
951     /**
952      * @dev Returns true if the key is in the map. O(1).
953      */
954     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
955         return _contains(map._inner, bytes32(key));
956     }
957 
958     /**
959      * @dev Returns the number of elements in the map. O(1).
960      */
961     function length(UintToAddressMap storage map) internal view returns (uint256) {
962         return _length(map._inner);
963     }
964 
965    /**
966     * @dev Returns the element stored at position `index` in the set. O(1).
967     * Note that there are no guarantees on the ordering of values inside the
968     * array, and it may change when more values are added or removed.
969     *
970     * Requirements:
971     *
972     * - `index` must be strictly less than {length}.
973     */
974     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
975         (bytes32 key, bytes32 value) = _at(map._inner, index);
976         return (uint256(key), address(uint160(uint256(value))));
977     }
978 
979     /**
980      * @dev Returns the value associated with `key`.  O(1).
981      *
982      * Requirements:
983      *
984      * - `key` must be in the map.
985      */
986     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
987         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
988     }
989 
990     /**
991      * @dev Same as {get}, with a custom error message when `key` is not in the map.
992      */
993     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
994         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
995     }
996 }
997 
998 /**
999  * @dev String operations.
1000  */
1001 library Strings {
1002     /**
1003      * @dev Converts a `uint256` to its ASCII `string` representation.
1004      */
1005     function toString(uint256 value) internal pure returns (string memory) {
1006         // Inspired by OraclizeAPI's implementation - MIT licence
1007         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1008 
1009         if (value == 0) {
1010             return "0";
1011         }
1012         uint256 temp = value;
1013         uint256 digits;
1014         while (temp != 0) {
1015             digits++;
1016             temp /= 10;
1017         }
1018         bytes memory buffer = new bytes(digits);
1019         uint256 index = digits;
1020         temp = value;
1021         while (temp != 0) {
1022             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
1023             temp /= 10;
1024         }
1025         return string(buffer);
1026     }
1027 }
1028 
1029 /**
1030  * @title ERC721 Non-Fungible Token Standard basic implementation
1031  * @dev see https://eips.ethereum.org/EIPS/eip-721
1032  */
1033 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1034     using Address for address;
1035     using EnumerableSet for EnumerableSet.UintSet;
1036     using EnumerableMap for EnumerableMap.UintToAddressMap;
1037     using Strings for uint256;
1038 
1039     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1040     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1041     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1042 
1043     // Mapping from holder address to their (enumerable) set of owned tokens
1044     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1045 
1046     // Enumerable mapping from token ids to their owners
1047     EnumerableMap.UintToAddressMap private _tokenOwners;
1048 
1049     // Mapping from token ID to approved address
1050     mapping (uint256 => address) private _tokenApprovals;
1051 
1052     // Mapping from owner to operator approvals
1053     mapping (address => mapping (address => bool)) private _operatorApprovals;
1054 
1055     // Token name
1056     string private _name;
1057 
1058     // Token symbol
1059     string private _symbol;
1060 
1061     // Optional mapping for token URIs
1062     mapping (uint256 => string) private _tokenURIs;
1063 
1064     // Base URI
1065     string private _baseURI;
1066 
1067     /*
1068      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1069      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1070      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1071      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1072      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1073      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1074      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1075      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1076      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1077      *
1078      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1079      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1080      */
1081     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1082 
1083     /*
1084      *     bytes4(keccak256('name()')) == 0x06fdde03
1085      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1086      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1087      *
1088      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1089      */
1090     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1091 
1092     /*
1093      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1094      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1095      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1096      *
1097      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1098      */
1099     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1100 
1101     /**
1102      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1103      */
1104     constructor (string memory name_, string memory symbol_) {
1105         _name = name_;
1106         _symbol = symbol_;
1107 
1108         // register the supported interfaces to conform to ERC721 via ERC165
1109         _registerInterface(_INTERFACE_ID_ERC721);
1110         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1111         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-balanceOf}.
1116      */
1117     function balanceOf(address owner) public view override returns (uint256) {
1118         require(owner != address(0), "ERC721: balance query for the zero address");
1119 
1120         return _holderTokens[owner].length();
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-ownerOf}.
1125      */
1126     function ownerOf(uint256 tokenId) public view override returns (address) {
1127         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Metadata-name}.
1132      */
1133     function name() public view override returns (string memory) {
1134         return _name;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-symbol}.
1139      */
1140     function symbol() public view override returns (string memory) {
1141         return _symbol;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Metadata-tokenURI}.
1146      */
1147     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1148         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1149 
1150         string memory _tokenURI = _tokenURIs[tokenId];
1151 
1152         // If there is no base URI, return the token URI.
1153         if (bytes(_baseURI).length == 0) {
1154             return _tokenURI;
1155         }
1156         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1157         if (bytes(_tokenURI).length > 0) {
1158             return string(abi.encodePacked(_baseURI, _tokenURI));
1159         }
1160         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1161         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1162     }
1163 
1164     /**
1165     * @dev Returns the base URI set via {_setBaseURI}. This will be
1166     * automatically added as a prefix in {tokenURI} to each token's URI, or
1167     * to the token ID if no specific URI is set for that token ID.
1168     */
1169     function baseURI() public view returns (string memory) {
1170         return _baseURI;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1175      */
1176     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1177         return _holderTokens[owner].at(index);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Enumerable-totalSupply}.
1182      */
1183     function totalSupply() public view override returns (uint256) {
1184         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1185         return _tokenOwners.length();
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Enumerable-tokenByIndex}.
1190      */
1191     function tokenByIndex(uint256 index) public view override returns (uint256) {
1192         (uint256 tokenId, ) = _tokenOwners.at(index);
1193         return tokenId;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-approve}.
1198      */
1199     function approve(address to, uint256 tokenId) public virtual override {
1200         address owner = ownerOf(tokenId);
1201         require(to != owner, "ERC721: approval to current owner");
1202 
1203         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1204             "ERC721: approve caller is not owner nor approved for all"
1205         );
1206 
1207         _approve(to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-getApproved}.
1212      */
1213     function getApproved(uint256 tokenId) public view override returns (address) {
1214         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1215 
1216         return _tokenApprovals[tokenId];
1217     }
1218 
1219     /**
1220      * @dev See {IERC721-setApprovalForAll}.
1221      */
1222     function setApprovalForAll(address operator, bool approved) public virtual override {
1223         require(operator != _msgSender(), "ERC721: approve to caller");
1224 
1225         _operatorApprovals[_msgSender()][operator] = approved;
1226         emit ApprovalForAll(_msgSender(), operator, approved);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-isApprovedForAll}.
1231      */
1232     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1233         return _operatorApprovals[owner][operator];
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-transferFrom}.
1238      */
1239     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1240         //solhint-disable-next-line max-line-length
1241         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1242 
1243         _transfer(from, to, tokenId);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-safeTransferFrom}.
1248      */
1249     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1250         safeTransferFrom(from, to, tokenId, "");
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-safeTransferFrom}.
1255      */
1256     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1257         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1258         _safeTransfer(from, to, tokenId, _data);
1259     }
1260 
1261     /**
1262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1264      *
1265      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1266      *
1267      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1268      * implement alternative mechanisms to perform token transfer, such as signature-based.
1269      *
1270      * Requirements:
1271      *
1272      * - `from` cannot be the zero address.
1273      * - `to` cannot be the zero address.
1274      * - `tokenId` token must exist and be owned by `from`.
1275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1280         _transfer(from, to, tokenId);
1281         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1282     }
1283 
1284     /**
1285      * @dev Returns whether `tokenId` exists.
1286      *
1287      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1288      *
1289      * Tokens start existing when they are minted (`_mint`),
1290      * and stop existing when they are burned (`_burn`).
1291      */
1292     function _exists(uint256 tokenId) internal view returns (bool) {
1293         return _tokenOwners.contains(tokenId);
1294     }
1295 
1296     /**
1297      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must exist.
1302      */
1303     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1304         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1305         address owner = ownerOf(tokenId);
1306         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1307     }
1308 
1309     /**
1310      * @dev Safely mints `tokenId` and transfers it to `to`.
1311      *
1312      * Requirements:
1313      d*
1314      * - `tokenId` must not exist.
1315      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _safeMint(address to, uint256 tokenId) internal virtual {
1320         _safeMint(to, tokenId, "");
1321     }
1322 
1323     /**
1324      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1325      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1326      */
1327     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1328         _mint(to, tokenId);
1329         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1330     }
1331 
1332     /**
1333      * @dev Mints `tokenId` and transfers it to `to`.
1334      *
1335      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1336      *
1337      * Requirements:
1338      *
1339      * - `tokenId` must not exist.
1340      * - `to` cannot be the zero address.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function _mint(address to, uint256 tokenId) internal virtual {
1345         require(to != address(0), "ERC721: mint to the zero address");
1346         require(!_exists(tokenId), "ERC721: token already minted");
1347 
1348         _beforeTokenTransfer(address(0), to, tokenId);
1349 
1350         _holderTokens[to].add(tokenId);
1351 
1352         _tokenOwners.set(tokenId, to);
1353 
1354         emit Transfer(address(0), to, tokenId);
1355     }
1356 
1357     /**
1358      * @dev Destroys `tokenId`.
1359      * The approval is cleared when the token is burned.
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must exist.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _burn(uint256 tokenId) internal virtual {
1368         address owner = ownerOf(tokenId);
1369 
1370         _beforeTokenTransfer(owner, address(0), tokenId);
1371 
1372         // Clear approvals
1373         _approve(address(0), tokenId);
1374 
1375         // Clear metadata (if any)
1376         if (bytes(_tokenURIs[tokenId]).length != 0) {
1377             delete _tokenURIs[tokenId];
1378         }
1379 
1380         _holderTokens[owner].remove(tokenId);
1381 
1382         _tokenOwners.remove(tokenId);
1383 
1384         emit Transfer(owner, address(0), tokenId);
1385     }
1386 
1387     /**
1388      * @dev Transfers `tokenId` from `from` to `to`.
1389      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1390      *
1391      * Requirements:
1392      *
1393      * - `to` cannot be the zero address.
1394      * - `tokenId` token must be owned by `from`.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1399         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1400         require(to != address(0), "ERC721: transfer to the zero address");
1401 
1402         _beforeTokenTransfer(from, to, tokenId);
1403 
1404         // Clear approvals from the previous owner
1405         _approve(address(0), tokenId);
1406 
1407         _holderTokens[from].remove(tokenId);
1408         _holderTokens[to].add(tokenId);
1409 
1410         _tokenOwners.set(tokenId, to);
1411 
1412         emit Transfer(from, to, tokenId);
1413     }
1414 
1415     /**
1416      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1423         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1424         _tokenURIs[tokenId] = _tokenURI;
1425     }
1426 
1427     /**
1428      * @dev Internal function to set the base URI for all token IDs. It is
1429      * automatically added as a prefix to the value returned in {tokenURI},
1430      * or to the token ID if {tokenURI} is empty.
1431      */
1432     function _setBaseURI(string memory baseURI_) internal virtual {
1433         _baseURI = baseURI_;
1434     }
1435 
1436     /**
1437      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1438      * The call is not executed if the target address is not a contract.
1439      *
1440      * @param from address representing the previous owner of the given token ID
1441      * @param to target address that will receive the tokens
1442      * @param tokenId uint256 ID of the token to be transferred
1443      * @param _data bytes optional data to send along with the call
1444      * @return bool whether the call correctly returned the expected magic value
1445      */
1446     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1447         private returns (bool)
1448     {
1449         if (!to.isContract()) {
1450             return true;
1451         }
1452         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1453             IERC721Receiver(to).onERC721Received.selector,
1454             _msgSender(),
1455             from,
1456             tokenId,
1457             _data
1458         ), "ERC721: transfer to non ERC721Receiver implementer");
1459         bytes4 retval = abi.decode(returndata, (bytes4));
1460         return (retval == _ERC721_RECEIVED);
1461     }
1462 
1463     function _approve(address to, uint256 tokenId) private {
1464         _tokenApprovals[tokenId] = to;
1465         emit Approval(ownerOf(tokenId), to, tokenId);
1466     }
1467 
1468     /**
1469      * @dev Hook that is called before any token transfer. This includes minting
1470      * and burning.
1471      *
1472      * Calling conditions:
1473      *
1474      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1475      * transferred to `to`.
1476      * - When `from` is zero, `tokenId` will be minted for `to`.
1477      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1478      * - `from` cannot be the zero address.
1479      * - `to` cannot be the zero address.
1480      *
1481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1482      */
1483     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1484 }
1485 
1486 /**
1487  * @title ERC721 Burnable Token
1488  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1489  */
1490 abstract contract ERC721Burnable is Context, ERC721 {
1491     /**
1492      * @dev Burns `tokenId`. See {ERC721-_burn}.
1493      *
1494      * Requirements:
1495      *
1496      * - The caller must own `tokenId` or be an approved operator.
1497      */
1498     function burn(uint256 tokenId) public virtual {
1499         //solhint-disable-next-line max-line-length
1500         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1501         _burn(tokenId);
1502     }
1503 }
1504 
1505 /**
1506  * @dev Contract module which provides a basic access control mechanism, where
1507  * there is an account (an owner) that can be granted exclusive access to
1508  * specific functions.
1509  *
1510  * By default, the owner account will be the one that deploys the contract. This
1511  * can later be changed with {transferOwnership}.
1512  *
1513  * This module is used through inheritance. It will make available the modifier
1514  * `onlyOwner`, which can be applied to your functions to restrict their use to
1515  * the owner.
1516  */
1517 abstract contract Ownable is Context {
1518     address private _owner;
1519 
1520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1521 
1522     /**
1523      * @dev Initializes the contract setting the deployer as the initial owner.
1524      */
1525     constructor () {
1526         address msgSender = _msgSender();
1527         _owner = msgSender;
1528         emit OwnershipTransferred(address(0), msgSender);
1529     }
1530 
1531     /**
1532      * @dev Returns the address of the current owner.
1533      */
1534     function owner() public view returns (address) {
1535         return _owner;
1536     }
1537 
1538     /**
1539      * @dev Throws if called by any account other than the owner.
1540      */
1541     modifier onlyOwner() {
1542         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1543         _;
1544     }
1545 
1546     /**
1547      * @dev Leaves the contract without owner. It will not be possible to call
1548      * `onlyOwner` functions anymore. Can only be called by the current owner.
1549      *
1550      * NOTE: Renouncing ownership will leave the contract without an owner,
1551      * thereby removing any functionality that is only available to the owner.
1552      */
1553     function renounceOwnership() public virtual onlyOwner {
1554         emit OwnershipTransferred(_owner, address(0));
1555         _owner = address(0);
1556     }
1557 
1558     /**
1559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1560      * Can only be called by the current owner.
1561      */
1562     function transferOwnership(address newOwner) public virtual onlyOwner {
1563         require(newOwner != address(0), "Ownable: new owner is the zero address");
1564         emit OwnershipTransferred(_owner, newOwner);
1565         _owner = newOwner;
1566     }
1567 }
1568 
1569 contract FightClub is ERC721Burnable, Ownable {
1570 
1571     string public FC_PROVENANCE = "";
1572 
1573     uint256 public constant MAX_FC = 6666;
1574 
1575     uint256 public constant MINT_PRICE = 0.06666 ether; //0.06666 ETH
1576 
1577     address payable immutable ownerAddress;
1578 
1579     bool public mintIsActive = false;
1580 
1581     mapping(address => uint256) public minted;
1582 
1583     constructor() ERC721("Fight Club", "FC") {
1584         ownerAddress = payable(msg.sender);
1585     }
1586 
1587     function withdraw() external onlyOwner {
1588         uint balance = address(this).balance;
1589         payable(msg.sender).transfer(balance);
1590     }
1591 
1592     /**
1593      * Set some NFTs aside
1594      */
1595     function reserve() public onlyOwner {        
1596         uint supply = totalSupply();
1597         for (uint i = 0; i < 15; i++) {
1598             _safeMint(msg.sender, supply + i);
1599         }
1600     }
1601 
1602     /*     
1603     * Set provenance once it's calculated
1604     */
1605     function setProvenanceHash(string memory provenanceHash) external onlyOwner {
1606         FC_PROVENANCE = provenanceHash;
1607     }
1608 
1609     function setBaseURI(string memory baseURI) external onlyOwner {
1610         _setBaseURI(baseURI);
1611     }
1612 
1613     /*
1614     * Pause sale if active, make active if paused
1615     */
1616     function flipMintState() external onlyOwner {
1617         mintIsActive = !mintIsActive;
1618     }
1619 
1620     /**
1621     * Mints FC
1622     */
1623     function mintFC(uint256 noOfTokens) external payable {
1624         require(mintIsActive, "Fight Club sale is not active");
1625         if(totalSupply()>1000) {
1626             require(minted[msg.sender]+noOfTokens <= 12, "Cannot buy more then 12 nfts per Wallet");
1627             require(msg.value == (noOfTokens * MINT_PRICE)," Wrong eth value sent");
1628         }
1629         else {
1630             require(minted[msg.sender]+noOfTokens <= 5, "Cannot buy more then 5 free nfts per Wallet");
1631         }
1632         require(totalSupply()+noOfTokens <= MAX_FC, "All FCs has been minted");
1633         ownerAddress.transfer(msg.value);
1634         
1635         minted[msg.sender]+=noOfTokens;
1636         for(uint256 i=0; i<noOfTokens; i++)
1637         {
1638             uint mintIndex = totalSupply();
1639             if (totalSupply() < MAX_FC) {
1640                 _safeMint(msg.sender, mintIndex);
1641             }
1642         }
1643     }
1644 }