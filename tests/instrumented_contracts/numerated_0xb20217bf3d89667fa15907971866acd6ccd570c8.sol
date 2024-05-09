1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-23
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 
10 interface IERC165 {
11     /**
12      * @dev Returns true ifa this contract implements the interface defined by
13      * `interfaceId`. See the corresponding
14      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
15      * to learn more about how these ids are created.
16      *
17      * This function call must use less than 30 000 gas.
18      */
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 interface IERC721 is IERC165 {
22     /**
23      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
24      */
25     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
26 
27     /**
28      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
29      */
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31 
32     /**
33      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
34      */
35     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
36 
37     /**
38      * @dev Returns the number of tokens in ``owner``'s account.
39      */
40     function balanceOf(address owner) external view returns (uint256 balance);
41 
42     /**
43      * @dev Returns the owner of the `tokenId` token.
44      *
45      * Requirements:
46      *
47      * - `tokenId` must exist.
48      */
49     function ownerOf(uint256 tokenId) external view returns (address owner);
50 
51     /**
52      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
53      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
54      *
55      * Requirements:
56      *
57      * - `from` cannot be the zero address.
58      * - `to` cannot be the zero address.
59      * - `tokenId` token must exist and be owned by `from`.
60      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
61      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
62      *
63      * Emits a {Transfer} event.
64      */
65     function safeTransferFrom(address from, address to, uint256 tokenId) external;
66 
67     /**
68      * @dev Transfers `tokenId` token from `from` to `to`.
69      *
70      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must be owned by `from`.
77      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address from, address to, uint256 tokenId) external;
82 
83     /**
84      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
85      * The approval is cleared when the token is transferred.
86      *
87      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
88      *
89      * Requirements:
90      *
91      * - The caller must own the token or be an approved operator.
92      * - `tokenId` must exist.
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Returns the account approved for `tokenId` token.
100      *
101      * Requirements:
102      *
103      * - `tokenId` must exist.
104      */
105     function getApproved(uint256 tokenId) external view returns (address operator);
106 
107     /**
108      * @dev Approve or remove `operator` as an operator for the caller.
109      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
110      *
111      * Requirements:
112      *
113      * - The `operator` cannot be the caller.
114      *
115      * Emits an {ApprovalForAll} event.
116      */
117     function setApprovalForAll(address operator, bool _approved) external;
118 
119     /**
120      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
121      *
122      * See {setApprovalForAll}
123      */
124     function isApprovedForAll(address owner, address operator) external view returns (bool);
125 
126     /**
127       * @dev Safely transfers `tokenId` token from `from` to `to`.
128       *
129       * Requirements:
130       *
131       * - `from` cannot be the zero address.
132       * - `to` cannot be the zero address.
133       * - `tokenId` token must exist and be owned by `from`.
134       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
135       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
136       *
137       * Emits a {Transfer} event.
138       */
139     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
140 }
141 interface IERC721Metadata is IERC721 {
142 
143     /**
144      * @dev Returns the token collection name.
145      */
146     function name() external view returns (string memory);
147 
148     /**
149      * @dev Returns the token collection symbol.
150      */
151     function symbol() external view returns (string memory);
152 
153     /**
154      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
155      */
156     function tokenURI(uint256 tokenId) external view returns (string memory);
157 }
158 interface IERC721Enumerable is IERC721 {
159 
160     /**
161      * @dev Returns the total amount of tokens stored by the contract.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
167      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
168      */
169     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
170 
171     /**
172      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
173      * Use along with {totalSupply} to enumerate all tokens.
174      */
175     function tokenByIndex(uint256 index) external view returns (uint256);
176 }
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
186      */
187     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
188 }
189 abstract contract ERC165 is IERC165 {
190     /**
191      * @dev Mapping of interface ids to whether or not it's supported.
192      */
193     mapping(bytes4 => bool) private _supportedInterfaces;
194 
195     constructor () {
196         // Derived contracts need only register support for their own interfaces,
197         // we register support for ERC165 itself here
198         _registerInterface(type(IERC165).interfaceId);
199     }
200 
201     /**
202      * @dev See {IERC165-supportsInterface}.
203      *
204      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
205      */
206     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
207         return _supportedInterfaces[interfaceId];
208     }
209 
210     /**
211      * @dev Registers the contract as an implementer of the interface defined by
212      * `interfaceId`. Support of the actual ERC165 interface is automatic and
213      * registering its interface id is not required.
214      *
215      * See {IERC165-supportsInterface}.
216      *
217      * Requirements:
218      *
219      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
220      */
221     function _registerInterface(bytes4 interfaceId) internal virtual {
222         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
223         _supportedInterfaces[interfaceId] = true;
224     }
225 }
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         // solhint-disable-next-line no-inline-assembly
251         assembly { size := extcodesize(account) }
252         return size > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
275         (bool success, ) = recipient.call{ value: amount }("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain`call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298       return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, 0, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but also transferring `value` wei to `target`.
314      *
315      * Requirements:
316      *
317      * - the calling contract must have an ETH balance of at least `value`.
318      * - the called Solidity function must be `payable`.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         // solhint-disable-next-line avoid-low-level-calls
337         (bool success, bytes memory returndata) = target.call{ value: value }(data);
338         return _verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but performing a static call.
344      *
345      * _Available since v3.3._
346      */
347     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
348         return functionStaticCall(target, data, "Address: low-level static call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.staticcall(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.delegatecall(data);
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
408 library EnumerableSet {
409     // To implement this library for multiple types with as little code
410     // repetition as possible, we write it in terms of a generic Set type with
411     // bytes32 values.
412     // The Set implementation uses private functions, and user-facing
413     // implementations (such as AddressSet) are just wrappers around the
414     // underlying Set.
415     // This means that we can only create new EnumerableSets for types that fit
416     // in bytes32.
417 
418     struct Set {
419         // Storage of set values
420         bytes32[] _values;
421 
422         // Position of the value in the `values` array, plus 1 because index 0
423         // means a value is not in the set.
424         mapping (bytes32 => uint256) _indexes;
425     }
426 
427     /**
428      * @dev Add a value to a set. O(1).
429      *
430      * Returns true if the value was added to the set, that is if it was not
431      * already present.
432      */
433     function _add(Set storage set, bytes32 value) private returns (bool) {
434         if (!_contains(set, value)) {
435             set._values.push(value);
436             // The value is stored at length-1, but we add 1 to all indexes
437             // and use 0 as a sentinel value
438             set._indexes[value] = set._values.length;
439             return true;
440         } else {
441             return false;
442         }
443     }
444 
445     /**
446      * @dev Removes a value from a set. O(1).
447      *
448      * Returns true if the value was removed from the set, that is if it was
449      * present.
450      */
451     function _remove(Set storage set, bytes32 value) private returns (bool) {
452         // We read and store the value's index to prevent multiple reads from the same storage slot
453         uint256 valueIndex = set._indexes[value];
454 
455         if (valueIndex != 0) { // Equivalent to contains(set, value)
456             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
457             // the array, and then remove the last element (sometimes called as 'swap and pop').
458             // This modifies the order of the array, as noted in {at}.
459 
460             uint256 toDeleteIndex = valueIndex - 1;
461             uint256 lastIndex = set._values.length - 1;
462 
463             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
464             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
465 
466             bytes32 lastvalue = set._values[lastIndex];
467 
468             // Move the last value to the index where the value to delete is
469             set._values[toDeleteIndex] = lastvalue;
470             // Update the index for the moved value
471             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
472 
473             // Delete the slot where the moved value was stored
474             set._values.pop();
475 
476             // Delete the index for the deleted slot
477             delete set._indexes[value];
478 
479             return true;
480         } else {
481             return false;
482         }
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function _contains(Set storage set, bytes32 value) private view returns (bool) {
489         return set._indexes[value] != 0;
490     }
491 
492     /**
493      * @dev Returns the number of values on the set. O(1).
494      */
495     function _length(Set storage set) private view returns (uint256) {
496         return set._values.length;
497     }
498 
499    /**
500     * @dev Returns the value stored at position `index` in the set. O(1).
501     *
502     * Note that there are no guarantees on the ordering of values inside the
503     * array, and it may change when more values are added or removed.
504     *
505     * Requirements:
506     *
507     * - `index` must be strictly less than {length}.
508     */
509     function _at(Set storage set, uint256 index) private view returns (bytes32) {
510         require(set._values.length > index, "EnumerableSet: index out of bounds");
511         return set._values[index];
512     }
513 
514     // Bytes32Set
515 
516     struct Bytes32Set {
517         Set _inner;
518     }
519 
520     /**
521      * @dev Add a value to a set. O(1).
522      *
523      * Returns true if the value was added to the set, that is if it was not
524      * already present.
525      */
526     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
527         return _add(set._inner, value);
528     }
529 
530     /**
531      * @dev Removes a value from a set. O(1).
532      *
533      * Returns true if the value was removed from the set, that is if it was
534      * present.
535      */
536     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
537         return _remove(set._inner, value);
538     }
539 
540     /**
541      * @dev Returns true if the value is in the set. O(1).
542      */
543     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
544         return _contains(set._inner, value);
545     }
546 
547     /**
548      * @dev Returns the number of values in the set. O(1).
549      */
550     function length(Bytes32Set storage set) internal view returns (uint256) {
551         return _length(set._inner);
552     }
553 
554    /**
555     * @dev Returns the value stored at position `index` in the set. O(1).
556     *
557     * Note that there are no guarantees on the ordering of values inside the
558     * array, and it may change when more values are added or removed.
559     *
560     * Requirements:
561     *
562     * - `index` must be strictly less than {length}.
563     */
564     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
565         return _at(set._inner, index);
566     }
567 
568     // AddressSet
569 
570     struct AddressSet {
571         Set _inner;
572     }
573 
574     /**
575      * @dev Add a value to a set. O(1).
576      *
577      * Returns true if the value was added to the set, that is if it was not
578      * already present.
579      */
580     function add(AddressSet storage set, address value) internal returns (bool) {
581         return _add(set._inner, bytes32(uint256(uint160(value))));
582     }
583 
584     /**
585      * @dev Removes a value from a set. O(1).
586      *
587      * Returns true if the value was removed from the set, that is if it was
588      * present.
589      */
590     function remove(AddressSet storage set, address value) internal returns (bool) {
591         return _remove(set._inner, bytes32(uint256(uint160(value))));
592     }
593 
594     /**
595      * @dev Returns true if the value is in the set. O(1).
596      */
597     function contains(AddressSet storage set, address value) internal view returns (bool) {
598         return _contains(set._inner, bytes32(uint256(uint160(value))));
599     }
600 
601     /**
602      * @dev Returns the number of values in the set. O(1).
603      */
604     function length(AddressSet storage set) internal view returns (uint256) {
605         return _length(set._inner);
606     }
607 
608    /**
609     * @dev Returns the value stored at position `index` in the set. O(1).
610     *
611     * Note that there are no guarantees on the ordering of values inside the
612     * array, and it may change when more values are added or removed.
613     *
614     * Requirements:
615     *
616     * - `index` must be strictly less than {length}.
617     */
618     function at(AddressSet storage set, uint256 index) internal view returns (address) {
619         return address(uint160(uint256(_at(set._inner, index))));
620     }
621 
622 
623     // UintSet
624 
625     struct UintSet {
626         Set _inner;
627     }
628 
629     /**
630      * @dev Add a value to a set. O(1).
631      *
632      * Returns true if the value was added to the set, that is if it was not
633      * already present.
634      */
635     function add(UintSet storage set, uint256 value) internal returns (bool) {
636         return _add(set._inner, bytes32(value));
637     }
638 
639     /**
640      * @dev Removes a value from a set. O(1).
641      *
642      * Returns true if the value was removed from the set, that is if it was
643      * present.
644      */
645     function remove(UintSet storage set, uint256 value) internal returns (bool) {
646         return _remove(set._inner, bytes32(value));
647     }
648 
649     /**
650      * @dev Returns true if the value is in the set. O(1).
651      */
652     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
653         return _contains(set._inner, bytes32(value));
654     }
655 
656     /**
657      * @dev Returns the number of values on the set. O(1).
658      */
659     function length(UintSet storage set) internal view returns (uint256) {
660         return _length(set._inner);
661     }
662 
663    /**
664     * @dev Returns the value stored at position `index` in the set. O(1).
665     *
666     * Note that there are no guarantees on the ordering of values inside the
667     * array, and it may change when more values are added or removed.
668     *
669     * Requirements:
670     *
671     * - `index` must be strictly less than {length}.
672     */
673     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
674         return uint256(_at(set._inner, index));
675     }
676 }
677 library EnumerableMap {
678     // To implement this library for multiple types with as little code
679     // repetition as possible, we write it in terms of a generic Map type with
680     // bytes32 keys and values.
681     // The Map implementation uses private functions, and user-facing
682     // implementations (such as Uint256ToAddressMap) are just wrappers around
683     // the underlying Map.
684     // This means that we can only create new EnumerableMaps for types that fit
685     // in bytes32.
686 
687     struct MapEntry {
688         bytes32 _key;
689         bytes32 _value;
690     }
691 
692     struct Map {
693         // Storage of map keys and values
694         MapEntry[] _entries;
695 
696         // Position of the entry defined by a key in the `entries` array, plus 1
697         // because index 0 means a key is not in the map.
698         mapping (bytes32 => uint256) _indexes;
699     }
700 
701     /**
702      * @dev Adds a key-value pair to a map, or updates the value for an existing
703      * key. O(1).
704      *
705      * Returns true if the key was added to the map, that is if it was not
706      * already present.
707      */
708     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
709         // We read and store the key's index to prevent multiple reads from the same storage slot
710         uint256 keyIndex = map._indexes[key];
711 
712         if (keyIndex == 0) { // Equivalent to !contains(map, key)
713             map._entries.push(MapEntry({ _key: key, _value: value }));
714             // The entry is stored at length-1, but we add 1 to all indexes
715             // and use 0 as a sentinel value
716             map._indexes[key] = map._entries.length;
717             return true;
718         } else {
719             map._entries[keyIndex - 1]._value = value;
720             return false;
721         }
722     }
723 
724     /**
725      * @dev Removes a key-value pair from a map. O(1).
726      *
727      * Returns true if the key was removed from the map, that is if it was present.
728      */
729     function _remove(Map storage map, bytes32 key) private returns (bool) {
730         // We read and store the key's index to prevent multiple reads from the same storage slot
731         uint256 keyIndex = map._indexes[key];
732 
733         if (keyIndex != 0) { // Equivalent to contains(map, key)
734             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
735             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
736             // This modifies the order of the array, as noted in {at}.
737 
738             uint256 toDeleteIndex = keyIndex - 1;
739             uint256 lastIndex = map._entries.length - 1;
740 
741             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
742             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
743 
744             MapEntry storage lastEntry = map._entries[lastIndex];
745 
746             // Move the last entry to the index where the entry to delete is
747             map._entries[toDeleteIndex] = lastEntry;
748             // Update the index for the moved entry
749             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
750 
751             // Delete the slot where the moved entry was stored
752             map._entries.pop();
753 
754             // Delete the index for the deleted slot
755             delete map._indexes[key];
756 
757             return true;
758         } else {
759             return false;
760         }
761     }
762 
763     /**
764      * @dev Returns true if the key is in the map. O(1).
765      */
766     function _contains(Map storage map, bytes32 key) private view returns (bool) {
767         return map._indexes[key] != 0;
768     }
769 
770     /**
771      * @dev Returns the number of key-value pairs in the map. O(1).
772      */
773     function _length(Map storage map) private view returns (uint256) {
774         return map._entries.length;
775     }
776 
777    /**
778     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
779     *
780     * Note that there are no guarantees on the ordering of entries inside the
781     * array, and it may change when more entries are added or removed.
782     *
783     * Requirements:
784     *
785     * - `index` must be strictly less than {length}.
786     */
787     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
788         require(map._entries.length > index, "EnumerableMap: index out of bounds");
789 
790         MapEntry storage entry = map._entries[index];
791         return (entry._key, entry._value);
792     }
793 
794     /**
795      * @dev Tries to returns the value associated with `key`.  O(1).
796      * Does not revert if `key` is not in the map.
797      */
798     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
799         uint256 keyIndex = map._indexes[key];
800         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
801         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
802     }
803 
804     /**
805      * @dev Returns the value associated with `key`.  O(1).
806      *
807      * Requirements:
808      *
809      * - `key` must be in the map.
810      */
811     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
812         uint256 keyIndex = map._indexes[key];
813         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
814         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
815     }
816 
817     /**
818      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
819      *
820      * CAUTION: This function is deprecated because it requires allocating memory for the error
821      * message unnecessarily. For custom revert reasons use {_tryGet}.
822      */
823     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
824         uint256 keyIndex = map._indexes[key];
825         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
826         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
827     }
828 
829     // UintToAddressMap
830 
831     struct UintToAddressMap {
832         Map _inner;
833     }
834 
835     /**
836      * @dev Adds a key-value pair to a map, or updates the value for an existing
837      * key. O(1).
838      *
839      * Returns true if the key was added to the map, that is if it was not
840      * already present.
841      */
842     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
843         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
844     }
845 
846     /**
847      * @dev Removes a value from a set. O(1).
848      *
849      * Returns true if the key was removed from the map, that is if it was present.
850      */
851     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
852         return _remove(map._inner, bytes32(key));
853     }
854 
855     /**
856      * @dev Returns true if the key is in the map. O(1).
857      */
858     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
859         return _contains(map._inner, bytes32(key));
860     }
861 
862     /**
863      * @dev Returns the number of elements in the map. O(1).
864      */
865     function length(UintToAddressMap storage map) internal view returns (uint256) {
866         return _length(map._inner);
867     }
868 
869    /**
870     * @dev Returns the element stored at position `index` in the set. O(1).
871     * Note that there are no guarantees on the ordering of values inside the
872     * array, and it may change when more values are added or removed.
873     *
874     * Requirements:
875     *
876     * - `index` must be strictly less than {length}.
877     */
878     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
879         (bytes32 key, bytes32 value) = _at(map._inner, index);
880         return (uint256(key), address(uint160(uint256(value))));
881     }
882 
883     /**
884      * @dev Tries to returns the value associated with `key`.  O(1).
885      * Does not revert if `key` is not in the map.
886      *
887      * _Available since v3.4._
888      */
889     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
890         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
891         return (success, address(uint160(uint256(value))));
892     }
893 
894     /**
895      * @dev Returns the value associated with `key`.  O(1).
896      *
897      * Requirements:
898      *
899      * - `key` must be in the map.
900      */
901     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
902         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
903     }
904 
905     /**
906      * @dev Same as {get}, with a custom error message when `key` is not in the map.
907      *
908      * CAUTION: This function is deprecated because it requires allocating memory for the error
909      * message unnecessarily. For custom revert reasons use {tryGet}.
910      */
911     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
912         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
913     }
914 }
915 library Strings {
916     /**
917      * @dev Converts a `uint256` to its ASCII `string` representation.
918      */
919     function toString(uint256 value) internal pure returns (string memory) {
920         // Inspired by OraclizeAPI's implementation - MIT licence
921         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
922 
923         if (value == 0) {
924             return "0";
925         }
926         uint256 temp = value;
927         uint256 digits;
928         while (temp != 0) {
929             digits++;
930             temp /= 10;
931         }
932         bytes memory buffer = new bytes(digits);
933         uint256 index = digits;
934         temp = value;
935         while (temp != 0) {
936             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
937             temp /= 10;
938         }
939         return string(buffer);
940     }
941 }
942 library Counters {
943     struct Counter {
944         // This variable should never be directly accessed by users of the library: interactions must be restricted to
945         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
946         // this feature: see https://github.com/ethereum/solidity/issues/4637
947         uint256 _value; // default: 0
948     }
949 
950     function current(Counter storage counter) internal view returns (uint256) {
951         return counter._value;
952     }
953 
954     function increment(Counter storage counter) internal {
955         unchecked {
956             counter._value += 1;
957         }
958     }
959 
960     function decrement(Counter storage counter) internal {
961         uint256 value = counter._value;
962         require(value > 0, "Counter: decrement overflow");
963         unchecked {
964             counter._value = value - 1;
965         }
966     }
967 }
968 contract Ownable {
969 
970     address private owner;
971     
972     event OwnerSet(address indexed oldOwner, address indexed newOwner);
973     
974     modifier onlyOwner() {
975         require(msg.sender == owner, "Caller is not owner");
976         _;
977     }
978 
979     constructor() {
980         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
981         emit OwnerSet(address(0), owner);
982     }
983 
984 
985     function changeOwner(address newOwner) public onlyOwner {
986         emit OwnerSet(owner, newOwner);
987         owner = newOwner;
988     }
989 
990     function getOwner() external view returns (address) {
991         return owner;
992     }
993 }
994 
995 contract ERC721 is ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
996     using Address for address;
997     using EnumerableSet for EnumerableSet.UintSet;
998     using EnumerableMap for EnumerableMap.UintToAddressMap;
999     using Strings for uint256;
1000     using Counters for Counters.Counter;
1001 
1002     // Map the selling contracts that can mint tokens
1003     mapping (address => bool) public minters;
1004     
1005     // Contract that calculates the stake profits
1006     address public profitsContract;
1007     
1008     // Mapping from holder address to their (enumerable) set of owned tokens
1009     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1010 
1011     // Enumerable mapping from token ids to their owners
1012     EnumerableMap.UintToAddressMap private _tokenOwners;
1013 
1014     // Mapping from token ID to approved address
1015     mapping (uint256 => address) private _tokenApprovals;
1016 
1017     // Mapping from owner to operator approvals
1018     mapping (address => mapping (address => bool)) private _operatorApprovals;
1019     
1020     struct Coin {
1021         address tokenAddress;
1022         string symbol;
1023         string name;
1024     }
1025     
1026     mapping (uint256 => Coin) public tradeCoins;
1027     
1028     struct assetType {
1029         uint64 maxAmount;
1030         uint64 mintedAmount;
1031         uint64 coinIndex;
1032         string copyright;
1033     }
1034     
1035     mapping (uint256 => assetType) public assetsByType;
1036     
1037     struct assetDetail {
1038         uint256 value;
1039         uint32 lastTrade;
1040         uint32 lastPayment;
1041         uint32 typeDetail;
1042         uint32 customDetails;
1043     }
1044     
1045     mapping (uint256 => assetDetail) assetsDetails;
1046     address public sellingContract;
1047     uint256 public polkaCitizens = 0;
1048 
1049     // Token name
1050     string private _name;
1051 
1052     // Token symbol
1053     string private _symbol;
1054 
1055     // Base URI
1056     string private _baseURI;
1057     
1058     Counters.Counter private _tokenIdTracker;
1059 
1060     /**
1061      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1062      */
1063     constructor () {
1064         _name ="Polka City 3D Asset";
1065         _symbol = "PC3D";
1066         _baseURI = "https://polkacity.app/3dnftassets/";
1067         
1068         // include ETH as coin
1069         
1070         tradeCoins[1].tokenAddress = address(0x0);
1071         tradeCoins[1].symbol = "ETH";
1072         tradeCoins[1].name = "Ethereum";
1073         
1074         // include POLC as coin
1075         
1076         tradeCoins[2].tokenAddress = 0x0daD676DA510e71e31464A765a8548b47f47bdad;
1077         tradeCoins[2].symbol = "POLC";
1078         tradeCoins[2].name = "Polka City Token";
1079         
1080         // register the supported interfaces to conform to ERC721 via ERC165
1081         _registerInterface(type(IERC721).interfaceId);
1082         _registerInterface(type(IERC721Metadata).interfaceId);
1083         _registerInterface(type(IERC721Enumerable).interfaceId);
1084     }
1085 
1086     function initAssets(uint64 _assetType, uint64 _maxAmount, uint64 _coinIndex, string memory _copyright) private {
1087         assetsByType[_assetType].maxAmount = _maxAmount;
1088         assetsByType[_assetType].mintedAmount = 0;
1089         assetsByType[_assetType].coinIndex = _coinIndex;
1090         assetsByType[_assetType].copyright = _copyright;
1091     }
1092     
1093     /**
1094      * @dev See {IERC721-balanceOf}.
1095      */
1096     function balanceOf(address _owner) public view virtual override returns (uint256) {
1097         require(_owner != address(0), "ERC721: balance query for the zero address");
1098         return _holderTokens[_owner].length();
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-ownerOf}.
1103      */
1104     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1105         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Metadata-name}.
1110      */
1111     function name() public view virtual override returns (string memory) {
1112         return _name;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Metadata-symbol}.
1117      */
1118     function symbol() public view virtual override returns (string memory) {
1119         return _symbol;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-tokenURI}.
1124      */
1125     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1126         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1127         string memory base = baseURI();
1128         return string(abi.encodePacked(base,( uint256(assetsDetails[tokenId].customDetails).toString())));
1129     }
1130 
1131     function baseURI() public view virtual returns (string memory) {
1132         return _baseURI;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1137      */
1138     function tokenOfOwnerByIndex(address _owner, uint256 index) public view virtual override returns (uint256) {
1139         return _holderTokens[_owner].at(index);
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-totalSupply}.
1144      */
1145     function totalSupply() public view virtual override returns (uint256) {
1146         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1147         return _tokenOwners.length();
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-tokenByIndex}.
1152      */
1153     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1154         (uint256 tokenId, ) = _tokenOwners.at(index);
1155         return (tokenId);
1156     }
1157     
1158     function getTokenDetails(uint256 index) public view returns (uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment, uint256 initialvalue, string memory coin) {
1159         uint256 coinIndex = uint256(assetsByType[(assetsDetails[index].typeDetail)].coinIndex);
1160         
1161         return ( 
1162         assetsDetails[index].typeDetail, 
1163         assetsDetails[index].customDetails, 
1164         assetsDetails[index].lastTrade, 
1165         assetsDetails[index].lastPayment,
1166         assetsDetails[index].value,
1167         tradeCoins[coinIndex].symbol
1168         );
1169     }
1170     
1171 
1172     /**
1173      * @dev See {IERC721-approve}.
1174      */
1175     function approve(address to, uint256 tokenId) public virtual override {
1176         address _owner = ERC721.ownerOf(tokenId);
1177         require(to != _owner, "ERC721: approval to current owner");
1178 
1179         require(msg.sender == _owner || ERC721.isApprovedForAll(_owner, msg.sender),
1180             "ERC721: approve caller is not owner nor approved for all"
1181         );
1182 
1183         _approve(to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-getApproved}.
1188      */
1189     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1190         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1191 
1192         return _tokenApprovals[tokenId];
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-setApprovalForAll}.
1197      */
1198     function setApprovalForAll(address operator, bool approved) public virtual override {
1199         require(operator != msg.sender, "ERC721: approve to caller");
1200 
1201         _operatorApprovals[msg.sender][operator] = approved;
1202         emit ApprovalForAll(msg.sender, operator, approved);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-isApprovedForAll}.
1207      */
1208     function isApprovedForAll(address _owner, address operator) public view virtual override returns (bool) {
1209         return _operatorApprovals[_owner][operator];
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-transferFrom}.
1214      */
1215     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1216         //solhint-disable-next-line max-line-length
1217         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1218 
1219         _transfer(from, to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-safeTransferFrom}.
1224      */
1225     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1226         safeTransferFrom(from, to, tokenId, "");
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-safeTransferFrom}.
1231      */
1232     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1233         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1234         _safeTransfer(from, to, tokenId, _data);
1235     }
1236 
1237     /**
1238      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1239      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1240      *
1241      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1242      *
1243      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1244      * implement alternative mechanisms to perform token transfer, such as signature-based.
1245      *
1246      * Requirements:
1247      *
1248      * - `from` cannot be the zero address.
1249      * - `to` cannot be the zero address.
1250      * - `tokenId` token must exist and be owned by `from`.
1251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1256         _transfer(from, to, tokenId);
1257         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1258     }
1259 
1260     /**
1261      * @dev Returns whether `tokenId` exists.
1262      *
1263      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1264      *
1265      * Tokens start existing when they are minted (`_mint`),
1266      * and stop existing when they are burned (`_burn`).
1267      */
1268     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1269         return _tokenOwners.contains(tokenId);
1270     }
1271 
1272     /**
1273      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      */
1279     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1280         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1281         address _owner = ERC721.ownerOf(tokenId);
1282         return (spender == _owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(_owner, spender));
1283     }
1284 
1285     /**
1286      * @dev Safely mints `tokenId` and transfers it to `to`.
1287      *
1288      * Requirements:
1289      d*
1290      * - `tokenId` must not exist.
1291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _safeMint(address to, uint256 tokenId) internal virtual {
1296         _safeMint(to, tokenId, "");
1297     }
1298 
1299     /**
1300      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1301      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1302      */
1303     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1304         _mint(to, tokenId);
1305         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1306     }
1307 
1308     /**
1309      * @dev Mints `tokenId` and transfers it to `to`.
1310      *
1311      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must not exist.
1316      * - `to` cannot be the zero address.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _mint(address to, uint256 tokenId) internal virtual {
1321         require(to != address(0), "ERC721: mint to the zero address");
1322         require(!_exists(tokenId), "ERC721: token already minted");
1323 
1324         _beforeTokenTransfer(address(0), to, tokenId);
1325 
1326         _holderTokens[to].add(tokenId);
1327 
1328         _tokenOwners.set(tokenId, to);
1329 
1330         emit Transfer(address(0), to, tokenId);
1331     }
1332 
1333 
1334     /**
1335      * @dev Transfers `tokenId` from `from` to `to`.
1336      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1337      *
1338      * Requirements:
1339      *
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must be owned by `from`.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1346         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1347         require(to != address(0), "ERC721: transfer to the zero address");
1348 
1349         _beforeTokenTransfer(from, to, tokenId);
1350 
1351         // Clear approvals from the previous owner
1352         _approve(address(0), tokenId);
1353 
1354         _holderTokens[from].remove(tokenId);
1355         _holderTokens[to].add(tokenId);
1356 
1357         _tokenOwners.set(tokenId, to);
1358         assetsDetails[tokenId].lastTrade = uint32(block.timestamp);
1359         assetsDetails[tokenId].lastPayment = uint32(block.timestamp);
1360         checkCitizen(to, true);
1361         checkCitizen(from, false);
1362 
1363         emit Transfer(from, to, tokenId);
1364     }
1365 
1366 
1367     function setBaseURI(string memory baseURI_) public onlyOwner {
1368         _baseURI = baseURI_;
1369     }
1370 
1371     /**
1372      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1373      * The call is not executed if the target address is not a contract.
1374      *
1375      * @param from address representing the previous owner of the given token ID
1376      * @param to target address that will receive the tokens
1377      * @param tokenId uint256 ID of the token to be transferred
1378      * @param _data bytes optional data to send along with the call
1379      * @return bool whether the call correctly returned the expected magic value
1380      */
1381     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1382         private returns (bool)
1383     {
1384         if (to.isContract()) {
1385             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1386                 return retval == IERC721Receiver(to).onERC721Received.selector;
1387             } catch (bytes memory reason) {
1388                 if (reason.length == 0) {
1389                     revert("ERC721: transfer to non ERC721Receiver implementer");
1390                 } else {
1391                     // solhint-disable-next-line no-inline-assembly
1392                     assembly {
1393                         revert(add(32, reason), mload(reason))
1394                     }
1395                 }
1396             }
1397         } else {
1398             return true;
1399         }
1400     }
1401 
1402     function _approve(address to, uint256 tokenId) private {
1403         _tokenApprovals[tokenId] = to;
1404         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before any token transfer. This includes minting
1409      * and burning.
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1417      * - `from` cannot be the zero address.
1418      * - `to` cannot be the zero address.
1419      *
1420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1421      */
1422     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1423     
1424     function checkCitizen(address _citizen, bool _addAsset) private {
1425         uint256 citizenBalance = _holderTokens[_citizen].length();
1426         if (citizenBalance > 0) {
1427             if (_addAsset == true && citizenBalance == 1) {
1428                 polkaCitizens++;
1429             }
1430         } else {
1431             polkaCitizens--;
1432         }
1433     }
1434     
1435     function mint(address to, uint32 _assetType, uint256 _value, uint32 _customDetails) public virtual returns (bool success) {
1436         require(minters[msg.sender] == true, "Not allowed");
1437         require(assetsByType[_assetType].maxAmount > assetsByType[_assetType].mintedAmount, "Max mintable amount reached for this asset" );
1438         uint256 curIndex = _tokenIdTracker.current();
1439         _mint(to, curIndex);
1440         assetsDetails[curIndex].typeDetail = _assetType;
1441         assetsDetails[curIndex].value = _value;
1442         assetsDetails[curIndex].lastTrade = uint32(block.timestamp);
1443         assetsDetails[curIndex].lastPayment = uint32(block.timestamp);
1444         assetsDetails[curIndex].customDetails = _customDetails;
1445         assetsByType[_assetType].mintedAmount += 1;
1446         _tokenIdTracker.increment();
1447         checkCitizen(to, true);
1448         return true;
1449     }
1450     
1451     function setMinter(address _minterAddress, bool _canMint) public onlyOwner {
1452         minters[_minterAddress] = _canMint;
1453     }
1454     
1455     function setProfitsContract(address _contract) public onlyOwner {
1456         profitsContract = _contract;
1457     }
1458     
1459     function setPaymentDate(uint256 _asset) public {
1460         require(msg.sender == profitsContract);
1461         assetsDetails[_asset].lastPayment = uint32(block.timestamp);
1462     }
1463     
1464     function addAssetType(uint64 _assetType, uint64 _maxAmount, uint64 _coinIndex, string memory _copyright) public onlyOwner {
1465         require(_maxAmount > 0);
1466         initAssets( _assetType, _maxAmount, _coinIndex, _copyright);
1467     }
1468     
1469     function modifyAssetType(uint64 _typeId, uint64 _maxAmount, uint64 _coinIndex, string memory _copyright) public onlyOwner {
1470         assetsByType[_typeId].copyright = _copyright;
1471         assetsByType[_typeId].maxAmount = _maxAmount;
1472         assetsByType[_typeId].coinIndex = _coinIndex;
1473     }
1474     
1475     function fixAsset(uint256 _assetId, uint32 _customDetails) public {
1476         require(minters[msg.sender] == true, "Not allowed");
1477         assetsDetails[_assetId].customDetails = _customDetails;
1478     }
1479     
1480     function addCoin(uint256 _coinIndex, address _tokenAddress, string memory _tokenSymbol, string memory _tokenName) public onlyOwner {
1481         tradeCoins[_coinIndex].tokenAddress = _tokenAddress;
1482         tradeCoins[_coinIndex].symbol = _tokenSymbol;
1483         tradeCoins[_coinIndex].name = _tokenName;
1484     }
1485 
1486     
1487 }