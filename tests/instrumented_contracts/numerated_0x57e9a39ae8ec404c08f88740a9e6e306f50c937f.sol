1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC165 {
7     /**
8      * @dev Returns true if this contract implements the interface defined by
9      * `interfaceId`. See the corresponding
10      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
11      * to learn more about how these ids are created.
12      *
13      * This function call must use less than 30 000 gas.
14      */
15     function supportsInterface(bytes4 interfaceId) external view returns (bool);
16 }
17 interface IERC721 is IERC165 {
18     /**
19      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22 
23     /**
24      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
25      */
26     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
27 
28     /**
29      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
30      */
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     /**
34      * @dev Returns the number of tokens in ``owner``'s account.
35      */
36     function balanceOf(address owner) external view returns (uint256 balance);
37 
38     /**
39      * @dev Returns the owner of the `tokenId` token.
40      *
41      * Requirements:
42      *
43      * - `tokenId` must exist.
44      */
45     function ownerOf(uint256 tokenId) external view returns (address owner);
46 
47     /**
48      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
49      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
50      *
51      * Requirements:
52      *
53      * - `from` cannot be the zero address.
54      * - `to` cannot be the zero address.
55      * - `tokenId` token must exist and be owned by `from`.
56      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
57      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
58      *
59      * Emits a {Transfer} event.
60      */
61     function safeTransferFrom(address from, address to, uint256 tokenId) external;
62 
63     /**
64      * @dev Transfers `tokenId` token from `from` to `to`.
65      *
66      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address from, address to, uint256 tokenId) external;
78 
79     /**
80      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
81      * The approval is cleared when the token is transferred.
82      *
83      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
84      *
85      * Requirements:
86      *
87      * - The caller must own the token or be an approved operator.
88      * - `tokenId` must exist.
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address to, uint256 tokenId) external;
93 
94     /**
95      * @dev Returns the account approved for `tokenId` token.
96      *
97      * Requirements:
98      *
99      * - `tokenId` must exist.
100      */
101     function getApproved(uint256 tokenId) external view returns (address operator);
102 
103     /**
104      * @dev Approve or remove `operator` as an operator for the caller.
105      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
106      *
107      * Requirements:
108      *
109      * - The `operator` cannot be the caller.
110      *
111      * Emits an {ApprovalForAll} event.
112      */
113     function setApprovalForAll(address operator, bool _approved) external;
114 
115     /**
116      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
117      *
118      * See {setApprovalForAll}
119      */
120     function isApprovedForAll(address owner, address operator) external view returns (bool);
121 
122     /**
123       * @dev Safely transfers `tokenId` token from `from` to `to`.
124       *
125       * Requirements:
126       *
127       * - `from` cannot be the zero address.
128       * - `to` cannot be the zero address.
129       * - `tokenId` token must exist and be owned by `from`.
130       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
132       *
133       * Emits a {Transfer} event.
134       */
135     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
136 }
137 interface IERC721Metadata is IERC721 {
138 
139     /**
140      * @dev Returns the token collection name.
141      */
142     function name() external view returns (string memory);
143 
144     /**
145      * @dev Returns the token collection symbol.
146      */
147     function symbol() external view returns (string memory);
148 
149     /**
150      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
151      */
152     function tokenURI(uint256 tokenId) external view returns (string memory);
153 }
154 interface IERC721Enumerable is IERC721 {
155 
156     /**
157      * @dev Returns the total amount of tokens stored by the contract.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
163      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
164      */
165     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
166 
167     /**
168      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
169      * Use along with {totalSupply} to enumerate all tokens.
170      */
171     function tokenByIndex(uint256 index) external view returns (uint256);
172 }
173 interface IERC721Receiver {
174     /**
175      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
176      * by `operator` from `from`, this function is called.
177      *
178      * It must return its Solidity selector to confirm the token transfer.
179      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
180      *
181      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
182      */
183     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
184 }
185 abstract contract ERC165 is IERC165 {
186     /**
187      * @dev Mapping of interface ids to whether or not it's supported.
188      */
189     mapping(bytes4 => bool) private _supportedInterfaces;
190 
191     constructor () {
192         // Derived contracts need only register support for their own interfaces,
193         // we register support for ERC165 itself here
194         _registerInterface(type(IERC165).interfaceId);
195     }
196 
197     /**
198      * @dev See {IERC165-supportsInterface}.
199      *
200      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
203         return _supportedInterfaces[interfaceId];
204     }
205 
206     /**
207      * @dev Registers the contract as an implementer of the interface defined by
208      * `interfaceId`. Support of the actual ERC165 interface is automatic and
209      * registering its interface id is not required.
210      *
211      * See {IERC165-supportsInterface}.
212      *
213      * Requirements:
214      *
215      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
216      */
217     function _registerInterface(bytes4 interfaceId) internal virtual {
218         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
219         _supportedInterfaces[interfaceId] = true;
220     }
221 }
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         // solhint-disable-next-line no-inline-assembly
247         assembly { size := extcodesize(account) }
248         return size > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
271         (bool success, ) = recipient.call{ value: amount }("");
272         require(success, "Address: unable to send value, recipient may have reverted");
273     }
274 
275     /**
276      * @dev Performs a Solidity function call using a low level `call`. A
277      * plain`call` is an unsafe replacement for a function call: use this
278      * function instead.
279      *
280      * If `target` reverts with a revert reason, it is bubbled up by this
281      * function (like regular Solidity function calls).
282      *
283      * Returns the raw returned data. To convert to the expected return value,
284      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
285      *
286      * Requirements:
287      *
288      * - `target` must be a contract.
289      * - calling `target` with `data` must not revert.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
294       return functionCall(target, data, "Address: low-level call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
299      * `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but also transferring `value` wei to `target`.
310      *
311      * Requirements:
312      *
313      * - the calling contract must have an ETH balance of at least `value`.
314      * - the called Solidity function must be `payable`.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
324      * with `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         // solhint-disable-next-line avoid-low-level-calls
333         (bool success, bytes memory returndata) = target.call{ value: value }(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.staticcall(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         require(isContract(target), "Address: delegate call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.delegatecall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 library EnumerableSet {
405     // To implement this library for multiple types with as little code
406     // repetition as possible, we write it in terms of a generic Set type with
407     // bytes32 values.
408     // The Set implementation uses private functions, and user-facing
409     // implementations (such as AddressSet) are just wrappers around the
410     // underlying Set.
411     // This means that we can only create new EnumerableSets for types that fit
412     // in bytes32.
413 
414     struct Set {
415         // Storage of set values
416         bytes32[] _values;
417 
418         // Position of the value in the `values` array, plus 1 because index 0
419         // means a value is not in the set.
420         mapping (bytes32 => uint256) _indexes;
421     }
422 
423     /**
424      * @dev Add a value to a set. O(1).
425      *
426      * Returns true if the value was added to the set, that is if it was not
427      * already present.
428      */
429     function _add(Set storage set, bytes32 value) private returns (bool) {
430         if (!_contains(set, value)) {
431             set._values.push(value);
432             // The value is stored at length-1, but we add 1 to all indexes
433             // and use 0 as a sentinel value
434             set._indexes[value] = set._values.length;
435             return true;
436         } else {
437             return false;
438         }
439     }
440 
441     /**
442      * @dev Removes a value from a set. O(1).
443      *
444      * Returns true if the value was removed from the set, that is if it was
445      * present.
446      */
447     function _remove(Set storage set, bytes32 value) private returns (bool) {
448         // We read and store the value's index to prevent multiple reads from the same storage slot
449         uint256 valueIndex = set._indexes[value];
450 
451         if (valueIndex != 0) { // Equivalent to contains(set, value)
452             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
453             // the array, and then remove the last element (sometimes called as 'swap and pop').
454             // This modifies the order of the array, as noted in {at}.
455 
456             uint256 toDeleteIndex = valueIndex - 1;
457             uint256 lastIndex = set._values.length - 1;
458 
459             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
460             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
461 
462             bytes32 lastvalue = set._values[lastIndex];
463 
464             // Move the last value to the index where the value to delete is
465             set._values[toDeleteIndex] = lastvalue;
466             // Update the index for the moved value
467             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
468 
469             // Delete the slot where the moved value was stored
470             set._values.pop();
471 
472             // Delete the index for the deleted slot
473             delete set._indexes[value];
474 
475             return true;
476         } else {
477             return false;
478         }
479     }
480 
481     /**
482      * @dev Returns true if the value is in the set. O(1).
483      */
484     function _contains(Set storage set, bytes32 value) private view returns (bool) {
485         return set._indexes[value] != 0;
486     }
487 
488     /**
489      * @dev Returns the number of values on the set. O(1).
490      */
491     function _length(Set storage set) private view returns (uint256) {
492         return set._values.length;
493     }
494 
495    /**
496     * @dev Returns the value stored at position `index` in the set. O(1).
497     *
498     * Note that there are no guarantees on the ordering of values inside the
499     * array, and it may change when more values are added or removed.
500     *
501     * Requirements:
502     *
503     * - `index` must be strictly less than {length}.
504     */
505     function _at(Set storage set, uint256 index) private view returns (bytes32) {
506         require(set._values.length > index, "EnumerableSet: index out of bounds");
507         return set._values[index];
508     }
509 
510     // Bytes32Set
511 
512     struct Bytes32Set {
513         Set _inner;
514     }
515 
516     /**
517      * @dev Add a value to a set. O(1).
518      *
519      * Returns true if the value was added to the set, that is if it was not
520      * already present.
521      */
522     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
523         return _add(set._inner, value);
524     }
525 
526     /**
527      * @dev Removes a value from a set. O(1).
528      *
529      * Returns true if the value was removed from the set, that is if it was
530      * present.
531      */
532     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
533         return _remove(set._inner, value);
534     }
535 
536     /**
537      * @dev Returns true if the value is in the set. O(1).
538      */
539     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
540         return _contains(set._inner, value);
541     }
542 
543     /**
544      * @dev Returns the number of values in the set. O(1).
545      */
546     function length(Bytes32Set storage set) internal view returns (uint256) {
547         return _length(set._inner);
548     }
549 
550    /**
551     * @dev Returns the value stored at position `index` in the set. O(1).
552     *
553     * Note that there are no guarantees on the ordering of values inside the
554     * array, and it may change when more values are added or removed.
555     *
556     * Requirements:
557     *
558     * - `index` must be strictly less than {length}.
559     */
560     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
561         return _at(set._inner, index);
562     }
563 
564     // AddressSet
565 
566     struct AddressSet {
567         Set _inner;
568     }
569 
570     /**
571      * @dev Add a value to a set. O(1).
572      *
573      * Returns true if the value was added to the set, that is if it was not
574      * already present.
575      */
576     function add(AddressSet storage set, address value) internal returns (bool) {
577         return _add(set._inner, bytes32(uint256(uint160(value))));
578     }
579 
580     /**
581      * @dev Removes a value from a set. O(1).
582      *
583      * Returns true if the value was removed from the set, that is if it was
584      * present.
585      */
586     function remove(AddressSet storage set, address value) internal returns (bool) {
587         return _remove(set._inner, bytes32(uint256(uint160(value))));
588     }
589 
590     /**
591      * @dev Returns true if the value is in the set. O(1).
592      */
593     function contains(AddressSet storage set, address value) internal view returns (bool) {
594         return _contains(set._inner, bytes32(uint256(uint160(value))));
595     }
596 
597     /**
598      * @dev Returns the number of values in the set. O(1).
599      */
600     function length(AddressSet storage set) internal view returns (uint256) {
601         return _length(set._inner);
602     }
603 
604    /**
605     * @dev Returns the value stored at position `index` in the set. O(1).
606     *
607     * Note that there are no guarantees on the ordering of values inside the
608     * array, and it may change when more values are added or removed.
609     *
610     * Requirements:
611     *
612     * - `index` must be strictly less than {length}.
613     */
614     function at(AddressSet storage set, uint256 index) internal view returns (address) {
615         return address(uint160(uint256(_at(set._inner, index))));
616     }
617 
618 
619     // UintSet
620 
621     struct UintSet {
622         Set _inner;
623     }
624 
625     /**
626      * @dev Add a value to a set. O(1).
627      *
628      * Returns true if the value was added to the set, that is if it was not
629      * already present.
630      */
631     function add(UintSet storage set, uint256 value) internal returns (bool) {
632         return _add(set._inner, bytes32(value));
633     }
634 
635     /**
636      * @dev Removes a value from a set. O(1).
637      *
638      * Returns true if the value was removed from the set, that is if it was
639      * present.
640      */
641     function remove(UintSet storage set, uint256 value) internal returns (bool) {
642         return _remove(set._inner, bytes32(value));
643     }
644 
645     /**
646      * @dev Returns true if the value is in the set. O(1).
647      */
648     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
649         return _contains(set._inner, bytes32(value));
650     }
651 
652     /**
653      * @dev Returns the number of values on the set. O(1).
654      */
655     function length(UintSet storage set) internal view returns (uint256) {
656         return _length(set._inner);
657     }
658 
659    /**
660     * @dev Returns the value stored at position `index` in the set. O(1).
661     *
662     * Note that there are no guarantees on the ordering of values inside the
663     * array, and it may change when more values are added or removed.
664     *
665     * Requirements:
666     *
667     * - `index` must be strictly less than {length}.
668     */
669     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
670         return uint256(_at(set._inner, index));
671     }
672 }
673 library EnumerableMap {
674     // To implement this library for multiple types with as little code
675     // repetition as possible, we write it in terms of a generic Map type with
676     // bytes32 keys and values.
677     // The Map implementation uses private functions, and user-facing
678     // implementations (such as Uint256ToAddressMap) are just wrappers around
679     // the underlying Map.
680     // This means that we can only create new EnumerableMaps for types that fit
681     // in bytes32.
682 
683     struct MapEntry {
684         bytes32 _key;
685         bytes32 _value;
686     }
687 
688     struct Map {
689         // Storage of map keys and values
690         MapEntry[] _entries;
691 
692         // Position of the entry defined by a key in the `entries` array, plus 1
693         // because index 0 means a key is not in the map.
694         mapping (bytes32 => uint256) _indexes;
695     }
696 
697     /**
698      * @dev Adds a key-value pair to a map, or updates the value for an existing
699      * key. O(1).
700      *
701      * Returns true if the key was added to the map, that is if it was not
702      * already present.
703      */
704     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
705         // We read and store the key's index to prevent multiple reads from the same storage slot
706         uint256 keyIndex = map._indexes[key];
707 
708         if (keyIndex == 0) { // Equivalent to !contains(map, key)
709             map._entries.push(MapEntry({ _key: key, _value: value }));
710             // The entry is stored at length-1, but we add 1 to all indexes
711             // and use 0 as a sentinel value
712             map._indexes[key] = map._entries.length;
713             return true;
714         } else {
715             map._entries[keyIndex - 1]._value = value;
716             return false;
717         }
718     }
719 
720     /**
721      * @dev Removes a key-value pair from a map. O(1).
722      *
723      * Returns true if the key was removed from the map, that is if it was present.
724      */
725     function _remove(Map storage map, bytes32 key) private returns (bool) {
726         // We read and store the key's index to prevent multiple reads from the same storage slot
727         uint256 keyIndex = map._indexes[key];
728 
729         if (keyIndex != 0) { // Equivalent to contains(map, key)
730             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
731             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
732             // This modifies the order of the array, as noted in {at}.
733 
734             uint256 toDeleteIndex = keyIndex - 1;
735             uint256 lastIndex = map._entries.length - 1;
736 
737             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
738             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
739 
740             MapEntry storage lastEntry = map._entries[lastIndex];
741 
742             // Move the last entry to the index where the entry to delete is
743             map._entries[toDeleteIndex] = lastEntry;
744             // Update the index for the moved entry
745             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
746 
747             // Delete the slot where the moved entry was stored
748             map._entries.pop();
749 
750             // Delete the index for the deleted slot
751             delete map._indexes[key];
752 
753             return true;
754         } else {
755             return false;
756         }
757     }
758 
759     /**
760      * @dev Returns true if the key is in the map. O(1).
761      */
762     function _contains(Map storage map, bytes32 key) private view returns (bool) {
763         return map._indexes[key] != 0;
764     }
765 
766     /**
767      * @dev Returns the number of key-value pairs in the map. O(1).
768      */
769     function _length(Map storage map) private view returns (uint256) {
770         return map._entries.length;
771     }
772 
773    /**
774     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
775     *
776     * Note that there are no guarantees on the ordering of entries inside the
777     * array, and it may change when more entries are added or removed.
778     *
779     * Requirements:
780     *
781     * - `index` must be strictly less than {length}.
782     */
783     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
784         require(map._entries.length > index, "EnumerableMap: index out of bounds");
785 
786         MapEntry storage entry = map._entries[index];
787         return (entry._key, entry._value);
788     }
789 
790     /**
791      * @dev Tries to returns the value associated with `key`.  O(1).
792      * Does not revert if `key` is not in the map.
793      */
794     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
795         uint256 keyIndex = map._indexes[key];
796         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
797         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
798     }
799 
800     /**
801      * @dev Returns the value associated with `key`.  O(1).
802      *
803      * Requirements:
804      *
805      * - `key` must be in the map.
806      */
807     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
808         uint256 keyIndex = map._indexes[key];
809         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
810         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
811     }
812 
813     /**
814      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
815      *
816      * CAUTION: This function is deprecated because it requires allocating memory for the error
817      * message unnecessarily. For custom revert reasons use {_tryGet}.
818      */
819     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
820         uint256 keyIndex = map._indexes[key];
821         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
822         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
823     }
824 
825     // UintToAddressMap
826 
827     struct UintToAddressMap {
828         Map _inner;
829     }
830 
831     /**
832      * @dev Adds a key-value pair to a map, or updates the value for an existing
833      * key. O(1).
834      *
835      * Returns true if the key was added to the map, that is if it was not
836      * already present.
837      */
838     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
839         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the key was removed from the map, that is if it was present.
846      */
847     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
848         return _remove(map._inner, bytes32(key));
849     }
850 
851     /**
852      * @dev Returns true if the key is in the map. O(1).
853      */
854     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
855         return _contains(map._inner, bytes32(key));
856     }
857 
858     /**
859      * @dev Returns the number of elements in the map. O(1).
860      */
861     function length(UintToAddressMap storage map) internal view returns (uint256) {
862         return _length(map._inner);
863     }
864 
865    /**
866     * @dev Returns the element stored at position `index` in the set. O(1).
867     * Note that there are no guarantees on the ordering of values inside the
868     * array, and it may change when more values are added or removed.
869     *
870     * Requirements:
871     *
872     * - `index` must be strictly less than {length}.
873     */
874     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
875         (bytes32 key, bytes32 value) = _at(map._inner, index);
876         return (uint256(key), address(uint160(uint256(value))));
877     }
878 
879     /**
880      * @dev Tries to returns the value associated with `key`.  O(1).
881      * Does not revert if `key` is not in the map.
882      *
883      * _Available since v3.4._
884      */
885     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
886         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
887         return (success, address(uint160(uint256(value))));
888     }
889 
890     /**
891      * @dev Returns the value associated with `key`.  O(1).
892      *
893      * Requirements:
894      *
895      * - `key` must be in the map.
896      */
897     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
898         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
899     }
900 
901     /**
902      * @dev Same as {get}, with a custom error message when `key` is not in the map.
903      *
904      * CAUTION: This function is deprecated because it requires allocating memory for the error
905      * message unnecessarily. For custom revert reasons use {tryGet}.
906      */
907     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
908         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
909     }
910 }
911 library Strings {
912     /**
913      * @dev Converts a `uint256` to its ASCII `string` representation.
914      */
915     function toString(uint256 value) internal pure returns (string memory) {
916         // Inspired by OraclizeAPI's implementation - MIT licence
917         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
918 
919         if (value == 0) {
920             return "0";
921         }
922         uint256 temp = value;
923         uint256 digits;
924         while (temp != 0) {
925             digits++;
926             temp /= 10;
927         }
928         bytes memory buffer = new bytes(digits);
929         uint256 index = digits;
930         temp = value;
931         while (temp != 0) {
932             buffer[--index] = bytes1(uint8(48 + uint256(temp % 10)));
933             temp /= 10;
934         }
935         return string(buffer);
936     }
937 }
938 library Counters {
939     struct Counter {
940         // This variable should never be directly accessed by users of the library: interactions must be restricted to
941         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
942         // this feature: see https://github.com/ethereum/solidity/issues/4637
943         uint256 _value; // default: 0
944     }
945 
946     function current(Counter storage counter) internal view returns (uint256) {
947         return counter._value;
948     }
949 
950     function increment(Counter storage counter) internal {
951         unchecked {
952             counter._value += 1;
953         }
954     }
955 
956     function decrement(Counter storage counter) internal {
957         uint256 value = counter._value;
958         require(value > 0, "Counter: decrement overflow");
959         unchecked {
960             counter._value = value - 1;
961         }
962     }
963 }
964 contract Ownable {
965 
966     address private owner;
967     
968     event OwnerSet(address indexed oldOwner, address indexed newOwner);
969     
970     modifier onlyOwner() {
971         require(msg.sender == owner, "Caller is not owner");
972         _;
973     }
974 
975     constructor() {
976         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
977         emit OwnerSet(address(0), owner);
978     }
979 
980 
981     function changeOwner(address newOwner) public onlyOwner {
982         emit OwnerSet(owner, newOwner);
983         owner = newOwner;
984     }
985 
986     function getOwner() external view returns (address) {
987         return owner;
988     }
989 }
990 
991 contract ERC721 is ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
992     using Address for address;
993     using EnumerableSet for EnumerableSet.UintSet;
994     using EnumerableMap for EnumerableMap.UintToAddressMap;
995     using Strings for uint256;
996     using Counters for Counters.Counter;
997 
998     // Map the selling contracts that can mint tokens
999     mapping (address => bool) public minters;
1000     
1001     // Contract that calculates the stake profits
1002     address public profitsContract;
1003     
1004     // Mapping from holder address to their (enumerable) set of owned tokens
1005     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1006 
1007     // Enumerable mapping from token ids to their owners
1008     EnumerableMap.UintToAddressMap private _tokenOwners;
1009 
1010     // Mapping from token ID to approved address
1011     mapping (uint256 => address) private _tokenApprovals;
1012 
1013     // Mapping from owner to operator approvals
1014     mapping (address => mapping (address => bool)) private _operatorApprovals;
1015     
1016     struct assetType {
1017         uint64 maxAmount;
1018         uint64 mintedAmount;
1019         uint128 baseValue;
1020     }
1021     
1022     mapping (uint256 => assetType) public assetsByType;
1023     
1024     struct assetDetail {
1025         uint128 value;
1026         uint32 lastTrade;
1027         uint32 lastPayment;
1028         uint32 typeDetail;
1029         uint32 customDetails;
1030     }
1031     
1032     mapping (uint256 => assetDetail) assetsDetails;
1033     address public sellingContract;
1034     uint256 public polkaCitizens = 0;
1035 
1036     // Token name
1037     string private _name;
1038 
1039     // Token symbol
1040     string private _symbol;
1041 
1042     // Base URI
1043     string private _baseURI;
1044     
1045     Counters.Counter private _tokenIdTracker;
1046 
1047     /**
1048      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1049      */
1050     constructor () {
1051         _name ="Polka City Asset";
1052         _symbol = "PCA";
1053         _baseURI = "https://polkacity.app/nftasset/";
1054         
1055         initAssets(1, 1000, 1500);
1056         initAssets(2, 750, 3000);
1057         initAssets(3, 500, 7500);
1058         initAssets(4, 300, 10000);
1059         initAssets(5, 200, 15000);
1060         initAssets(6, 50, 75000);
1061         initAssets(7, 50, 65500);
1062         initAssets(8, 50, 40000);
1063         initAssets(9, 50, 90000);
1064         initAssets(10, 50, 55000);
1065         initAssets(11, 50, 105000);
1066         initAssets(12, 50, 50000);
1067         initAssets(13, 50, 22500);
1068         initAssets(14, 50, 30000);
1069         initAssets(15, 50, 45000);
1070         
1071         // register the supported interfaces to conform to ERC721 via ERC165
1072         _registerInterface(type(IERC721).interfaceId);
1073         _registerInterface(type(IERC721Metadata).interfaceId);
1074         _registerInterface(type(IERC721Enumerable).interfaceId);
1075     }
1076 
1077     function initAssets(uint64 _assetType, uint64 _maxAmount, uint256 _baseValue) private {
1078         assetsByType[_assetType].maxAmount = _maxAmount;
1079         assetsByType[_assetType].mintedAmount = 0;
1080         assetsByType[_assetType].baseValue = uint128(_baseValue * (10 ** 18));
1081     }
1082     
1083     /**
1084      * @dev See {IERC721-balanceOf}.
1085      */
1086     function balanceOf(address _owner) public view virtual override returns (uint256) {
1087         require(_owner != address(0), "ERC721: balance query for the zero address");
1088         return _holderTokens[_owner].length();
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-ownerOf}.
1093      */
1094     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1095         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1096     }
1097 
1098     /**
1099      * @dev See {IERC721Metadata-name}.
1100      */
1101     function name() public view virtual override returns (string memory) {
1102         return _name;
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Metadata-symbol}.
1107      */
1108     function symbol() public view virtual override returns (string memory) {
1109         return _symbol;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Metadata-tokenURI}.
1114      */
1115     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1116         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1117         string memory base = baseURI();
1118         return string(abi.encodePacked(base, assetsDetails[tokenId].customDetails));
1119     }
1120 
1121     function baseURI() public view virtual returns (string memory) {
1122         return _baseURI;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1127      */
1128     function tokenOfOwnerByIndex(address _owner, uint256 index) public view virtual override returns (uint256) {
1129         return _holderTokens[_owner].at(index);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134      */
1135     function totalSupply() public view virtual override returns (uint256) {
1136         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1137         return _tokenOwners.length();
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Enumerable-tokenByIndex}.
1142      */
1143     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1144         (uint256 tokenId, ) = _tokenOwners.at(index);
1145         return (tokenId);
1146     }
1147     
1148     function getTokenDetails(uint256 index) public view returns (uint128 lastvalue, uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment) {
1149         return (assetsDetails[index].value, 
1150         assetsDetails[index].typeDetail, 
1151         assetsDetails[index].customDetails, 
1152         assetsDetails[index].lastTrade, 
1153         assetsDetails[index].lastPayment);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-approve}.
1158      */
1159     function approve(address to, uint256 tokenId) public virtual override {
1160         address _owner = ERC721.ownerOf(tokenId);
1161         require(to != _owner, "ERC721: approval to current owner");
1162 
1163         require(msg.sender == _owner || ERC721.isApprovedForAll(_owner, msg.sender),
1164             "ERC721: approve caller is not owner nor approved for all"
1165         );
1166 
1167         _approve(to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-getApproved}.
1172      */
1173     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1174         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1175 
1176         return _tokenApprovals[tokenId];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-setApprovalForAll}.
1181      */
1182     function setApprovalForAll(address operator, bool approved) public virtual override {
1183         require(operator != msg.sender, "ERC721: approve to caller");
1184 
1185         _operatorApprovals[msg.sender][operator] = approved;
1186         emit ApprovalForAll(msg.sender, operator, approved);
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-isApprovedForAll}.
1191      */
1192     function isApprovedForAll(address _owner, address operator) public view virtual override returns (bool) {
1193         return _operatorApprovals[_owner][operator];
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-transferFrom}.
1198      */
1199     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1200         //solhint-disable-next-line max-line-length
1201         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1202 
1203         _transfer(from, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-safeTransferFrom}.
1208      */
1209     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1210         safeTransferFrom(from, to, tokenId, "");
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-safeTransferFrom}.
1215      */
1216     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1217         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
1218         _safeTransfer(from, to, tokenId, _data);
1219     }
1220 
1221     /**
1222      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1223      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1224      *
1225      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1226      *
1227      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1228      * implement alternative mechanisms to perform token transfer, such as signature-based.
1229      *
1230      * Requirements:
1231      *
1232      * - `from` cannot be the zero address.
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must exist and be owned by `from`.
1235      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1240         _transfer(from, to, tokenId);
1241         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1242     }
1243 
1244     /**
1245      * @dev Returns whether `tokenId` exists.
1246      *
1247      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1248      *
1249      * Tokens start existing when they are minted (`_mint`),
1250      * and stop existing when they are burned (`_burn`).
1251      */
1252     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1253         return _tokenOwners.contains(tokenId);
1254     }
1255 
1256     /**
1257      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      */
1263     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1264         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1265         address _owner = ERC721.ownerOf(tokenId);
1266         return (spender == _owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(_owner, spender));
1267     }
1268 
1269     /**
1270      * @dev Safely mints `tokenId` and transfers it to `to`.
1271      *
1272      * Requirements:
1273      d*
1274      * - `tokenId` must not exist.
1275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _safeMint(address to, uint256 tokenId) internal virtual {
1280         _safeMint(to, tokenId, "");
1281     }
1282 
1283     /**
1284      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1285      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1286      */
1287     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1288         _mint(to, tokenId);
1289         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1290     }
1291 
1292     /**
1293      * @dev Mints `tokenId` and transfers it to `to`.
1294      *
1295      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1296      *
1297      * Requirements:
1298      *
1299      * - `tokenId` must not exist.
1300      * - `to` cannot be the zero address.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _mint(address to, uint256 tokenId) internal virtual {
1305         require(to != address(0), "ERC721: mint to the zero address");
1306         require(!_exists(tokenId), "ERC721: token already minted");
1307 
1308         _beforeTokenTransfer(address(0), to, tokenId);
1309 
1310         _holderTokens[to].add(tokenId);
1311 
1312         _tokenOwners.set(tokenId, to);
1313 
1314         emit Transfer(address(0), to, tokenId);
1315     }
1316 
1317 
1318     /**
1319      * @dev Transfers `tokenId` from `from` to `to`.
1320      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1321      *
1322      * Requirements:
1323      *
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must be owned by `from`.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1330         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1331         require(to != address(0), "ERC721: transfer to the zero address");
1332 
1333         _beforeTokenTransfer(from, to, tokenId);
1334 
1335         // Clear approvals from the previous owner
1336         _approve(address(0), tokenId);
1337 
1338         _holderTokens[from].remove(tokenId);
1339         _holderTokens[to].add(tokenId);
1340 
1341         _tokenOwners.set(tokenId, to);
1342         assetsDetails[tokenId].lastTrade = uint32(block.timestamp);
1343         checkCitizen(to, true);
1344         checkCitizen(from, false);
1345 
1346         emit Transfer(from, to, tokenId);
1347     }
1348 
1349 
1350     function setBaseURI(string memory baseURI_) public onlyOwner {
1351         _baseURI = baseURI_;
1352     }
1353 
1354     /**
1355      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1356      * The call is not executed if the target address is not a contract.
1357      *
1358      * @param from address representing the previous owner of the given token ID
1359      * @param to target address that will receive the tokens
1360      * @param tokenId uint256 ID of the token to be transferred
1361      * @param _data bytes optional data to send along with the call
1362      * @return bool whether the call correctly returned the expected magic value
1363      */
1364     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1365         private returns (bool)
1366     {
1367         if (to.isContract()) {
1368             try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
1369                 return retval == IERC721Receiver(to).onERC721Received.selector;
1370             } catch (bytes memory reason) {
1371                 if (reason.length == 0) {
1372                     revert("ERC721: transfer to non ERC721Receiver implementer");
1373                 } else {
1374                     // solhint-disable-next-line no-inline-assembly
1375                     assembly {
1376                         revert(add(32, reason), mload(reason))
1377                     }
1378                 }
1379             }
1380         } else {
1381             return true;
1382         }
1383     }
1384 
1385     function _approve(address to, uint256 tokenId) private {
1386         _tokenApprovals[tokenId] = to;
1387         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1388     }
1389 
1390     /**
1391      * @dev Hook that is called before any token transfer. This includes minting
1392      * and burning.
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1400      * - `from` cannot be the zero address.
1401      * - `to` cannot be the zero address.
1402      *
1403      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1404      */
1405     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1406     
1407     function checkCitizen(address _citizen, bool _addAsset) private {
1408         uint256 citizenBalance = _holderTokens[_citizen].length();
1409         if (citizenBalance > 0) {
1410             if (_addAsset == true && citizenBalance == 1) {
1411                 polkaCitizens++;
1412             }
1413         } else {
1414             polkaCitizens--;
1415         }
1416     }
1417     
1418     function mint(address to, uint32 _assetType, uint32 _customDetails) public virtual returns (bool success) {
1419         require(minters[msg.sender] == true, "Not allowed");
1420         require(assetsByType[_assetType].maxAmount > assetsByType[_assetType].mintedAmount, "Max mintable amount reached for this asset" );
1421         uint256 curIndex = _tokenIdTracker.current();
1422         _mint(to, curIndex);
1423         assetsDetails[curIndex].typeDetail = _assetType;
1424         assetsDetails[curIndex].value = assetsByType[_assetType].baseValue;
1425         assetsDetails[curIndex].lastTrade = uint32(block.timestamp);
1426         assetsDetails[curIndex].lastPayment = uint32(block.timestamp);
1427         assetsDetails[curIndex].customDetails = _customDetails;
1428         assetsByType[_assetType].mintedAmount += 1;
1429         _tokenIdTracker.increment();
1430         checkCitizen(to, true);
1431         return true;
1432     }
1433     
1434     function setMinter(address _minterAddress, bool _canMint) public onlyOwner {
1435         minters[_minterAddress] = _canMint;
1436     }
1437     
1438     function setProfitsContract(address _contract) public onlyOwner {
1439         profitsContract = _contract;
1440     }
1441     
1442     function setPaymentDate(uint256 _asset) public {
1443         require(msg.sender == profitsContract);
1444         assetsDetails[_asset].lastPayment = uint32(block.timestamp);
1445     }
1446     
1447     function addAssetType(uint64 _assetId, uint64 _maxAmount, uint256 _baseValue) public onlyOwner {
1448         require(_maxAmount > 0 && _baseValue > 0);
1449         require(assetsByType[_assetId].maxAmount > 0);
1450         initAssets(_assetId, _maxAmount, _baseValue);
1451     }
1452 
1453     
1454 }