1 // SPDX-License-Identifier: MIT
2 // produced by the Solididy File Flattener (c) David Appleton 2018 - 2020 and beyond
3 // contact : calistralabs@gmail.com
4 // source  : https://github.com/DaveAppleton/SolidityFlattery
5 // released under Apache 2.0 licence
6 // input  C:\Users\slive\Documents\NFT_Projects\PineapplesDayOut\pineapples-contract\contracts\PineapplesDayOut.sol
7 // flattened :  Friday, 20-Aug-21 05:07:28 UTC
8 pragma solidity 0.7.6;
9 
10 interface IERC721 {
11     /**
12      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
15 
16     /**
17      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
18      */
19     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
20 
21     /**
22      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
23      */
24     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
25 
26     /**
27      * @dev Returns the number of tokens in ``owner``'s account.
28      */
29     function balanceOf(address owner) external view returns (uint256 balance);
30 
31     /**
32      * @dev Returns the owner of the `tokenId` token.
33      *
34      * Requirements:
35      *
36      * - `tokenId` must exist.
37      */
38     function ownerOf(uint256 tokenId) external view returns (address owner);
39 
40     /**
41      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
42      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
43      *
44      * Requirements:
45      *
46      * - `from` cannot be the zero address.
47      * - `to` cannot be the zero address.
48      * - `tokenId` token must exist and be owned by `from`.
49      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
50      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
51      *
52      * Emits a {Transfer} event.
53      */
54     function safeTransferFrom(address from, address to, uint256 tokenId) external;
55 
56     /**
57      * @dev Transfers `tokenId` token from `from` to `to`.
58      *
59      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must be owned by `from`.
66      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address from, address to, uint256 tokenId) external;
71 
72     /**
73      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
74      * The approval is cleared when the token is transferred.
75      *
76      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
77      *
78      * Requirements:
79      *
80      * - The caller must own the token or be an approved operator.
81      * - `tokenId` must exist.
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address to, uint256 tokenId) external;
86 
87     /**
88      * @dev Returns the account approved for `tokenId` token.
89      *
90      * Requirements:
91      *
92      * - `tokenId` must exist.
93      */
94     function getApproved(uint256 tokenId) external view returns (address operator);
95 
96     /**
97      * @dev Approve or remove `operator` as an operator for the caller.
98      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
99      *
100      * Requirements:
101      *
102      * - The `operator` cannot be the caller.
103      *
104      * Emits an {ApprovalForAll} event.
105      */
106     function setApprovalForAll(address operator, bool _approved) external;
107 
108     /**
109      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
110      *
111      * See {setApprovalForAll}
112      */
113     function isApprovedForAll(address owner, address operator) external view returns (bool);
114 
115     /**
116       * @dev Safely transfers `tokenId` token from `from` to `to`.
117       *
118       * Requirements:
119       *
120       * - `from` cannot be the zero address.
121       * - `to` cannot be the zero address.
122       * - `tokenId` token must exist and be owned by `from`.
123       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
124       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
125       *
126       * Emits a {Transfer} event.
127       */
128     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
129 }
130 
131 interface IERC721Enumerable {
132 
133     /**
134      * @dev Returns the total amount of tokens stored by the contract.
135      */
136     function totalSupply() external view returns (uint256);
137 
138     /**
139      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
140      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
141      */
142     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
143 
144     /**
145      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
146      * Use along with {totalSupply} to enumerate all tokens.
147      */
148     function tokenByIndex(uint256 index) external view returns (uint256);
149 }
150 
151 interface IERC721Receiver {
152     /**
153      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
154      * by `operator` from `from`, this function is called.
155      *
156      * It must return its Solidity selector to confirm the token transfer.
157      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
158      *
159      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
160      */
161     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
162 }
163 
164 interface IERC165 {
165     /**
166      * @dev Returns true if this contract implements the interface defined by
167      * `interfaceId`. See the corresponding
168      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
169      * to learn more about how these ids are created.
170      *
171      * This function call must use less than 30 000 gas.
172      */
173     function supportsInterface(bytes4 interfaceId) external view returns (bool);
174 }
175 
176 library Address {
177     /**
178      * @dev Returns true if `account` is a contract.
179      *
180      * [IMPORTANT]
181      * ====
182      * It is unsafe to assume that an address for which this function returns
183      * false is an externally-owned account (EOA) and not a contract.
184      *
185      * Among others, `isContract` will return false for the following
186      * types of addresses:
187      *
188      *  - an externally-owned account
189      *  - a contract in construction
190      *  - an address where a contract will be created
191      *  - an address where a contract lived, but was destroyed
192      * ====
193      */
194     function isContract(address account) internal view returns (bool) {
195         // This method relies on extcodesize, which returns 0 for contracts in
196         // construction, since the code is only stored at the end of the
197         // constructor execution.
198 
199         uint256 size;
200         // solhint-disable-next-line no-inline-assembly
201         assembly { size := extcodesize(account) }
202         return size > 0;
203     }
204 
205     /**
206      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
207      * `recipient`, forwarding all available gas and reverting on errors.
208      *
209      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
210      * of certain opcodes, possibly making contracts go over the 2300 gas limit
211      * imposed by `transfer`, making them unable to receive funds via
212      * `transfer`. {sendValue} removes this limitation.
213      *
214      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
215      *
216      * IMPORTANT: because control is transferred to `recipient`, care must be
217      * taken to not create reentrancy vulnerabilities. Consider using
218      * {ReentrancyGuard} or the
219      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
220      */
221     function sendValue(address payable recipient, uint256 amount) internal {
222         require(address(this).balance >= amount, "Address: insufficient balance");
223 
224         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
225         (bool success, ) = recipient.call{ value: amount }("");
226         require(success, "Address: unable to send value, recipient may have reverted");
227     }
228 
229     /**
230      * @dev Performs a Solidity function call using a low level `call`. A
231      * plain`call` is an unsafe replacement for a function call: use this
232      * function instead.
233      *
234      * If `target` reverts with a revert reason, it is bubbled up by this
235      * function (like regular Solidity function calls).
236      *
237      * Returns the raw returned data. To convert to the expected return value,
238      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
239      *
240      * Requirements:
241      *
242      * - `target` must be a contract.
243      * - calling `target` with `data` must not revert.
244      *
245      * _Available since v3.1._
246      */
247     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
248       return functionCall(target, data, "Address: low-level call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
253      * `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
258         return functionCallWithValue(target, data, 0, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but also transferring `value` wei to `target`.
264      *
265      * Requirements:
266      *
267      * - the calling contract must have an ETH balance of at least `value`.
268      * - the called Solidity function must be `payable`.
269      *
270      * _Available since v3.1._
271      */
272     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
278      * with `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
283         require(address(this).balance >= value, "Address: insufficient balance for call");
284         require(isContract(target), "Address: call to non-contract");
285 
286         // solhint-disable-next-line avoid-low-level-calls
287         (bool success, bytes memory returndata) = target.call{ value: value }(data);
288         return _verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
298         return functionStaticCall(target, data, "Address: low-level static call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
303      * but performing a static call.
304      *
305      * _Available since v3.3._
306      */
307     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         // solhint-disable-next-line avoid-low-level-calls
311         (bool success, bytes memory returndata) = target.staticcall(data);
312         return _verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         require(isContract(target), "Address: delegate call to non-contract");
333 
334         // solhint-disable-next-line avoid-low-level-calls
335         (bool success, bytes memory returndata) = target.delegatecall(data);
336         return _verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
340         if (success) {
341             return returndata;
342         } else {
343             // Look for revert reason and bubble it up if present
344             if (returndata.length > 0) {
345                 // The easiest way to bubble the revert reason is using memory via assembly
346 
347                 // solhint-disable-next-line no-inline-assembly
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 library EnumerableSet {
360     // To implement this library for multiple types with as little code
361     // repetition as possible, we write it in terms of a generic Set type with
362     // bytes32 values.
363     // The Set implementation uses private functions, and user-facing
364     // implementations (such as AddressSet) are just wrappers around the
365     // underlying Set.
366     // This means that we can only create new EnumerableSets for types that fit
367     // in bytes32.
368 
369     struct Set {
370         // Storage of set values
371         bytes32[] _values;
372 
373         // Position of the value in the `values` array, plus 1 because index 0
374         // means a value is not in the set.
375         mapping (bytes32 => uint256) _indexes;
376     }
377 
378     /**
379      * @dev Add a value to a set. O(1).
380      *
381      * Returns true if the value was added to the set, that is if it was not
382      * already present.
383      */
384     function _add(Set storage set, bytes32 value) private returns (bool) {
385         if (!_contains(set, value)) {
386             set._values.push(value);
387             // The value is stored at length-1, but we add 1 to all indexes
388             // and use 0 as a sentinel value
389             set._indexes[value] = set._values.length;
390             return true;
391         } else {
392             return false;
393         }
394     }
395 
396     /**
397      * @dev Removes a value from a set. O(1).
398      *
399      * Returns true if the value was removed from the set, that is if it was
400      * present.
401      */
402     function _remove(Set storage set, bytes32 value) private returns (bool) {
403         // We read and store the value's index to prevent multiple reads from the same storage slot
404         uint256 valueIndex = set._indexes[value];
405 
406         if (valueIndex != 0) { // Equivalent to contains(set, value)
407             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
408             // the array, and then remove the last element (sometimes called as 'swap and pop').
409             // This modifies the order of the array, as noted in {at}.
410 
411             uint256 toDeleteIndex = valueIndex - 1;
412             uint256 lastIndex = set._values.length - 1;
413 
414             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
415             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
416 
417             bytes32 lastvalue = set._values[lastIndex];
418 
419             // Move the last value to the index where the value to delete is
420             set._values[toDeleteIndex] = lastvalue;
421             // Update the index for the moved value
422             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
423 
424             // Delete the slot where the moved value was stored
425             set._values.pop();
426 
427             // Delete the index for the deleted slot
428             delete set._indexes[value];
429 
430             return true;
431         } else {
432             return false;
433         }
434     }
435 
436     /**
437      * @dev Returns true if the value is in the set. O(1).
438      */
439     function _contains(Set storage set, bytes32 value) private view returns (bool) {
440         return set._indexes[value] != 0;
441     }
442 
443     /**
444      * @dev Returns the number of values on the set. O(1).
445      */
446     function _length(Set storage set) private view returns (uint256) {
447         return set._values.length;
448     }
449 
450    /**
451     * @dev Returns the value stored at position `index` in the set. O(1).
452     *
453     * Note that there are no guarantees on the ordering of values inside the
454     * array, and it may change when more values are added or removed.
455     *
456     * Requirements:
457     *
458     * - `index` must be strictly less than {length}.
459     */
460     function _at(Set storage set, uint256 index) private view returns (bytes32) {
461         require(set._values.length > index, "EnumerableSet: index out of bounds");
462         return set._values[index];
463     }
464 
465     // Bytes32Set
466 
467     struct Bytes32Set {
468         Set _inner;
469     }
470 
471     /**
472      * @dev Add a value to a set. O(1).
473      *
474      * Returns true if the value was added to the set, that is if it was not
475      * already present.
476      */
477     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
478         return _add(set._inner, value);
479     }
480 
481     /**
482      * @dev Removes a value from a set. O(1).
483      *
484      * Returns true if the value was removed from the set, that is if it was
485      * present.
486      */
487     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
488         return _remove(set._inner, value);
489     }
490 
491     /**
492      * @dev Returns true if the value is in the set. O(1).
493      */
494     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
495         return _contains(set._inner, value);
496     }
497 
498     /**
499      * @dev Returns the number of values in the set. O(1).
500      */
501     function length(Bytes32Set storage set) internal view returns (uint256) {
502         return _length(set._inner);
503     }
504 
505    /**
506     * @dev Returns the value stored at position `index` in the set. O(1).
507     *
508     * Note that there are no guarantees on the ordering of values inside the
509     * array, and it may change when more values are added or removed.
510     *
511     * Requirements:
512     *
513     * - `index` must be strictly less than {length}.
514     */
515     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
516         return _at(set._inner, index);
517     }
518 
519     // AddressSet
520 
521     struct AddressSet {
522         Set _inner;
523     }
524 
525     /**
526      * @dev Add a value to a set. O(1).
527      *
528      * Returns true if the value was added to the set, that is if it was not
529      * already present.
530      */
531     function add(AddressSet storage set, address value) internal returns (bool) {
532         return _add(set._inner, bytes32(uint256(uint160(value))));
533     }
534 
535     /**
536      * @dev Removes a value from a set. O(1).
537      *
538      * Returns true if the value was removed from the set, that is if it was
539      * present.
540      */
541     function remove(AddressSet storage set, address value) internal returns (bool) {
542         return _remove(set._inner, bytes32(uint256(uint160(value))));
543     }
544 
545     /**
546      * @dev Returns true if the value is in the set. O(1).
547      */
548     function contains(AddressSet storage set, address value) internal view returns (bool) {
549         return _contains(set._inner, bytes32(uint256(uint160(value))));
550     }
551 
552     /**
553      * @dev Returns the number of values in the set. O(1).
554      */
555     function length(AddressSet storage set) internal view returns (uint256) {
556         return _length(set._inner);
557     }
558 
559    /**
560     * @dev Returns the value stored at position `index` in the set. O(1).
561     *
562     * Note that there are no guarantees on the ordering of values inside the
563     * array, and it may change when more values are added or removed.
564     *
565     * Requirements:
566     *
567     * - `index` must be strictly less than {length}.
568     */
569     function at(AddressSet storage set, uint256 index) internal view returns (address) {
570         return address(uint160(uint256(_at(set._inner, index))));
571     }
572 
573 
574     // UintSet
575 
576     struct UintSet {
577         Set _inner;
578     }
579 
580     /**
581      * @dev Add a value to a set. O(1).
582      *
583      * Returns true if the value was added to the set, that is if it was not
584      * already present.
585      */
586     function add(UintSet storage set, uint256 value) internal returns (bool) {
587         return _add(set._inner, bytes32(value));
588     }
589 
590     /**
591      * @dev Removes a value from a set. O(1).
592      *
593      * Returns true if the value was removed from the set, that is if it was
594      * present.
595      */
596     function remove(UintSet storage set, uint256 value) internal returns (bool) {
597         return _remove(set._inner, bytes32(value));
598     }
599 
600     /**
601      * @dev Returns true if the value is in the set. O(1).
602      */
603     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
604         return _contains(set._inner, bytes32(value));
605     }
606 
607     /**
608      * @dev Returns the number of values on the set. O(1).
609      */
610     function length(UintSet storage set) internal view returns (uint256) {
611         return _length(set._inner);
612     }
613 
614    /**
615     * @dev Returns the value stored at position `index` in the set. O(1).
616     *
617     * Note that there are no guarantees on the ordering of values inside the
618     * array, and it may change when more values are added or removed.
619     *
620     * Requirements:
621     *
622     * - `index` must be strictly less than {length}.
623     */
624     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
625         return uint256(_at(set._inner, index));
626     }
627 }
628 
629 library EnumerableMap {
630     // To implement this library for multiple types with as little code
631     // repetition as possible, we write it in terms of a generic Map type with
632     // bytes32 keys and values.
633     // The Map implementation uses private functions, and user-facing
634     // implementations (such as Uint256ToAddressMap) are just wrappers around
635     // the underlying Map.
636     // This means that we can only create new EnumerableMaps for types that fit
637     // in bytes32.
638 
639     struct MapEntry {
640         bytes32 _key;
641         bytes32 _value;
642     }
643 
644     struct Map {
645         // Storage of map keys and values
646         MapEntry[] _entries;
647 
648         // Position of the entry defined by a key in the `entries` array, plus 1
649         // because index 0 means a key is not in the map.
650         mapping (bytes32 => uint256) _indexes;
651     }
652 
653     /**
654      * @dev Adds a key-value pair to a map, or updates the value for an existing
655      * key. O(1).
656      *
657      * Returns true if the key was added to the map, that is if it was not
658      * already present.
659      */
660     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
661         // We read and store the key's index to prevent multiple reads from the same storage slot
662         uint256 keyIndex = map._indexes[key];
663 
664         if (keyIndex == 0) { // Equivalent to !contains(map, key)
665             map._entries.push(MapEntry({ _key: key, _value: value }));
666             // The entry is stored at length-1, but we add 1 to all indexes
667             // and use 0 as a sentinel value
668             map._indexes[key] = map._entries.length;
669             return true;
670         } else {
671             map._entries[keyIndex - 1]._value = value;
672             return false;
673         }
674     }
675 
676     /**
677      * @dev Removes a key-value pair from a map. O(1).
678      *
679      * Returns true if the key was removed from the map, that is if it was present.
680      */
681     function _remove(Map storage map, bytes32 key) private returns (bool) {
682         // We read and store the key's index to prevent multiple reads from the same storage slot
683         uint256 keyIndex = map._indexes[key];
684 
685         if (keyIndex != 0) { // Equivalent to contains(map, key)
686             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
687             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
688             // This modifies the order of the array, as noted in {at}.
689 
690             uint256 toDeleteIndex = keyIndex - 1;
691             uint256 lastIndex = map._entries.length - 1;
692 
693             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
694             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
695 
696             MapEntry storage lastEntry = map._entries[lastIndex];
697 
698             // Move the last entry to the index where the entry to delete is
699             map._entries[toDeleteIndex] = lastEntry;
700             // Update the index for the moved entry
701             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
702 
703             // Delete the slot where the moved entry was stored
704             map._entries.pop();
705 
706             // Delete the index for the deleted slot
707             delete map._indexes[key];
708 
709             return true;
710         } else {
711             return false;
712         }
713     }
714 
715     /**
716      * @dev Returns true if the key is in the map. O(1).
717      */
718     function _contains(Map storage map, bytes32 key) private view returns (bool) {
719         return map._indexes[key] != 0;
720     }
721 
722     /**
723      * @dev Returns the number of key-value pairs in the map. O(1).
724      */
725     function _length(Map storage map) private view returns (uint256) {
726         return map._entries.length;
727     }
728 
729    /**
730     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
731     *
732     * Note that there are no guarantees on the ordering of entries inside the
733     * array, and it may change when more entries are added or removed.
734     *
735     * Requirements:
736     *
737     * - `index` must be strictly less than {length}.
738     */
739     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
740         require(map._entries.length > index, "EnumerableMap: index out of bounds");
741 
742         MapEntry storage entry = map._entries[index];
743         return (entry._key, entry._value);
744     }
745 
746     /**
747      * @dev Tries to returns the value associated with `key`.  O(1).
748      * Does not revert if `key` is not in the map.
749      */
750     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
751         uint256 keyIndex = map._indexes[key];
752         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
753         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
754     }
755 
756     /**
757      * @dev Returns the value associated with `key`.  O(1).
758      *
759      * Requirements:
760      *
761      * - `key` must be in the map.
762      */
763     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
764         uint256 keyIndex = map._indexes[key];
765         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
766         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
767     }
768 
769     /**
770      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
771      *
772      * CAUTION: This function is deprecated because it requires allocating memory for the error
773      * message unnecessarily. For custom revert reasons use {_tryGet}.
774      */
775     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
776         uint256 keyIndex = map._indexes[key];
777         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
778         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
779     }
780 
781     // UintToAddressMap
782 
783     struct UintToAddressMap {
784         Map _inner;
785     }
786 
787     /**
788      * @dev Adds a key-value pair to a map, or updates the value for an existing
789      * key. O(1).
790      *
791      * Returns true if the key was added to the map, that is if it was not
792      * already present.
793      */
794     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
795         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
796     }
797 
798     /**
799      * @dev Removes a value from a set. O(1).
800      *
801      * Returns true if the key was removed from the map, that is if it was present.
802      */
803     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
804         return _remove(map._inner, bytes32(key));
805     }
806 
807     /**
808      * @dev Returns true if the key is in the map. O(1).
809      */
810     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
811         return _contains(map._inner, bytes32(key));
812     }
813 
814     /**
815      * @dev Returns the number of elements in the map. O(1).
816      */
817     function length(UintToAddressMap storage map) internal view returns (uint256) {
818         return _length(map._inner);
819     }
820 
821    /**
822     * @dev Returns the element stored at position `index` in the set. O(1).
823     * Note that there are no guarantees on the ordering of values inside the
824     * array, and it may change when more values are added or removed.
825     *
826     * Requirements:
827     *
828     * - `index` must be strictly less than {length}.
829     */
830     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
831         (bytes32 key, bytes32 value) = _at(map._inner, index);
832         return (uint256(key), address(uint160(uint256(value))));
833     }
834 
835     /**
836      * @dev Tries to returns the value associated with `key`.  O(1).
837      * Does not revert if `key` is not in the map.
838      *
839      * _Available since v3.4._
840      */
841     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
842         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
843         return (success, address(uint160(uint256(value))));
844     }
845 
846     /**
847      * @dev Returns the value associated with `key`.  O(1).
848      *
849      * Requirements:
850      *
851      * - `key` must be in the map.
852      */
853     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
854         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
855     }
856 
857     /**
858      * @dev Same as {get}, with a custom error message when `key` is not in the map.
859      *
860      * CAUTION: This function is deprecated because it requires allocating memory for the error
861      * message unnecessarily. For custom revert reasons use {tryGet}.
862      */
863     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
864         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
865     }
866 }
867 
868 library Strings {
869     /**
870      * @dev Converts a `uint256` to its ASCII `string` representation.
871      */
872     function toString(uint256 value) internal pure returns (string memory) {
873         // Inspired by OraclizeAPI's implementation - MIT licence
874         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
875 
876         if (value == 0) {
877             return "0";
878         }
879         uint256 temp = value;
880         uint256 digits;
881         while (temp != 0) {
882             digits++;
883             temp /= 10;
884         }
885         bytes memory buffer = new bytes(digits);
886         uint256 index = digits - 1;
887         temp = value;
888         while (temp != 0) {
889             buffer[index--] = bytes1(uint8(48 + temp % 10));
890             temp /= 10;
891         }
892         return string(buffer);
893     }
894 }
895 
896 library SafeMath {
897     /**
898      * @dev Returns the addition of two unsigned integers, with an overflow flag.
899      *
900      * _Available since v3.4._
901      */
902     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
903         uint256 c = a + b;
904         if (c < a) return (false, 0);
905         return (true, c);
906     }
907 
908     /**
909      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
910      *
911      * _Available since v3.4._
912      */
913     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
914         if (b > a) return (false, 0);
915         return (true, a - b);
916     }
917 
918     /**
919      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
920      *
921      * _Available since v3.4._
922      */
923     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
924         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
925         // benefit is lost if 'b' is also tested.
926         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
927         if (a == 0) return (true, 0);
928         uint256 c = a * b;
929         if (c / a != b) return (false, 0);
930         return (true, c);
931     }
932 
933     /**
934      * @dev Returns the division of two unsigned integers, with a division by zero flag.
935      *
936      * _Available since v3.4._
937      */
938     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
939         if (b == 0) return (false, 0);
940         return (true, a / b);
941     }
942 
943     /**
944      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
945      *
946      * _Available since v3.4._
947      */
948     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
949         if (b == 0) return (false, 0);
950         return (true, a % b);
951     }
952 
953     /**
954      * @dev Returns the addition of two unsigned integers, reverting on
955      * overflow.
956      *
957      * Counterpart to Solidity's `+` operator.
958      *
959      * Requirements:
960      *
961      * - Addition cannot overflow.
962      */
963     function add(uint256 a, uint256 b) internal pure returns (uint256) {
964         uint256 c = a + b;
965         require(c >= a, "SafeMath: addition overflow");
966         return c;
967     }
968 
969     /**
970      * @dev Returns the subtraction of two unsigned integers, reverting on
971      * overflow (when the result is negative).
972      *
973      * Counterpart to Solidity's `-` operator.
974      *
975      * Requirements:
976      *
977      * - Subtraction cannot overflow.
978      */
979     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
980         require(b <= a, "SafeMath: subtraction overflow");
981         return a - b;
982     }
983 
984     /**
985      * @dev Returns the multiplication of two unsigned integers, reverting on
986      * overflow.
987      *
988      * Counterpart to Solidity's `*` operator.
989      *
990      * Requirements:
991      *
992      * - Multiplication cannot overflow.
993      */
994     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
995         if (a == 0) return 0;
996         uint256 c = a * b;
997         require(c / a == b, "SafeMath: multiplication overflow");
998         return c;
999     }
1000 
1001     /**
1002      * @dev Returns the integer division of two unsigned integers, reverting on
1003      * division by zero. The result is rounded towards zero.
1004      *
1005      * Counterpart to Solidity's `/` operator. Note: this function uses a
1006      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1007      * uses an invalid opcode to revert (consuming all remaining gas).
1008      *
1009      * Requirements:
1010      *
1011      * - The divisor cannot be zero.
1012      */
1013     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1014         require(b > 0, "SafeMath: division by zero");
1015         return a / b;
1016     }
1017 
1018     /**
1019      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1020      * reverting when dividing by zero.
1021      *
1022      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1023      * opcode (which leaves remaining gas untouched) while Solidity uses an
1024      * invalid opcode to revert (consuming all remaining gas).
1025      *
1026      * Requirements:
1027      *
1028      * - The divisor cannot be zero.
1029      */
1030     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1031         require(b > 0, "SafeMath: modulo by zero");
1032         return a % b;
1033     }
1034 
1035     /**
1036      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1037      * overflow (when the result is negative).
1038      *
1039      * CAUTION: This function is deprecated because it requires allocating memory for the error
1040      * message unnecessarily. For custom revert reasons use {trySub}.
1041      *
1042      * Counterpart to Solidity's `-` operator.
1043      *
1044      * Requirements:
1045      *
1046      * - Subtraction cannot overflow.
1047      */
1048     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1049         require(b <= a, errorMessage);
1050         return a - b;
1051     }
1052 
1053     /**
1054      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1055      * division by zero. The result is rounded towards zero.
1056      *
1057      * CAUTION: This function is deprecated because it requires allocating memory for the error
1058      * message unnecessarily. For custom revert reasons use {tryDiv}.
1059      *
1060      * Counterpart to Solidity's `/` operator. Note: this function uses a
1061      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1062      * uses an invalid opcode to revert (consuming all remaining gas).
1063      *
1064      * Requirements:
1065      *
1066      * - The divisor cannot be zero.
1067      */
1068     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1069         require(b > 0, errorMessage);
1070         return a / b;
1071     }
1072 
1073     /**
1074      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1075      * reverting with custom message when dividing by zero.
1076      *
1077      * CAUTION: This function is deprecated because it requires allocating memory for the error
1078      * message unnecessarily. For custom revert reasons use {tryMod}.
1079      *
1080      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1081      * opcode (which leaves remaining gas untouched) while Solidity uses an
1082      * invalid opcode to revert (consuming all remaining gas).
1083      *
1084      * Requirements:
1085      *
1086      * - The divisor cannot be zero.
1087      */
1088     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1089         require(b > 0, errorMessage);
1090         return a % b;
1091     }
1092 }
1093 
1094 abstract contract Context {
1095     function _msgSender() internal view virtual returns (address payable) {
1096         return msg.sender;
1097     }
1098 
1099     function _msgData() internal view virtual returns (bytes memory) {
1100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1101         return msg.data;
1102     }
1103 }
1104 
1105 interface IERC721Metadata {
1106 
1107     /**
1108      * @dev Returns the token collection name.
1109      */
1110     function name() external view returns (string memory);
1111 
1112     /**
1113      * @dev Returns the token collection symbol.
1114      */
1115     function symbol() external view returns (string memory);
1116 
1117     /**
1118      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1119      */
1120     function tokenURI(uint256 tokenId) external view returns (string memory);
1121 }
1122 
1123 abstract contract ERC165 is IERC165 {
1124     /*
1125      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1126      */
1127     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1128 
1129     /**
1130      * @dev Mapping of interface ids to whether or not it's supported.
1131      */
1132     mapping(bytes4 => bool) private _supportedInterfaces;
1133 
1134     constructor () {
1135         // Derived contracts need only register support for their own interfaces,
1136         // we register support for ERC165 itself here
1137         _registerInterface(_INTERFACE_ID_ERC165);
1138     }
1139 
1140     /**
1141      * @dev See {IERC165-supportsInterface}.
1142      *
1143      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1144      */
1145     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1146         return _supportedInterfaces[interfaceId];
1147     }
1148 
1149     /**
1150      * @dev Registers the contract as an implementer of the interface defined by
1151      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1152      * registering its interface id is not required.
1153      *
1154      * See {IERC165-supportsInterface}.
1155      *
1156      * Requirements:
1157      *
1158      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1159      */
1160     function _registerInterface(bytes4 interfaceId) internal virtual {
1161         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1162         _supportedInterfaces[interfaceId] = true;
1163     }
1164 }
1165 
1166 abstract contract Ownable is Context {
1167     address private _owner;
1168 
1169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1170 
1171     /**
1172      * @dev Initializes the contract setting the deployer as the initial owner.
1173      */
1174     constructor () {
1175         address msgSender = _msgSender();
1176         _owner = msgSender;
1177         emit OwnershipTransferred(address(0), msgSender);
1178     }
1179 
1180     /**
1181      * @dev Returns the address of the current owner.
1182      */
1183     function owner() public view virtual returns (address) {
1184         return _owner;
1185     }
1186 
1187     /**
1188      * @dev Throws if called by any account other than the owner.
1189      */
1190     modifier onlyOwner() {
1191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1192         _;
1193     }
1194 
1195     /**
1196      * @dev Leaves the contract without owner. It will not be possible to call
1197      * `onlyOwner` functions anymore. Can only be called by the current owner.
1198      *
1199      * NOTE: Renouncing ownership will leave the contract without an owner,
1200      * thereby removing any functionality that is only available to the owner.
1201      */
1202     function renounceOwnership() public virtual onlyOwner {
1203         emit OwnershipTransferred(_owner, address(0));
1204         _owner = address(0);
1205     }
1206 
1207     /**
1208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1209      * Can only be called by the current owner.
1210      */
1211     function transferOwnership(address newOwner) public virtual onlyOwner {
1212         require(newOwner != address(0), "Ownable: new owner is the zero address");
1213         emit OwnershipTransferred(_owner, newOwner);
1214         _owner = newOwner;
1215     }
1216 }
1217 
1218 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1219     using SafeMath for uint256;
1220     using Address for address;
1221     using EnumerableSet for EnumerableSet.UintSet;
1222     using EnumerableMap for EnumerableMap.UintToAddressMap;
1223     using Strings for uint256;
1224 
1225     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1226     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1227     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1228 
1229     // Mapping from holder address to their (enumerable) set of owned tokens
1230     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1231 
1232     // Enumerable mapping from token ids to their owners
1233     EnumerableMap.UintToAddressMap private _tokenOwners;
1234 
1235     // Mapping from token ID to approved address
1236     mapping (uint256 => address) private _tokenApprovals;
1237 
1238     // Mapping from owner to operator approvals
1239     mapping (address => mapping (address => bool)) private _operatorApprovals;
1240 
1241     // Token name
1242     string private _name;
1243 
1244     // Token symbol
1245     string private _symbol;
1246 
1247     // Optional mapping for token URIs
1248     mapping (uint256 => string) private _tokenURIs;
1249 
1250     // Base URI
1251     string private _baseURI;
1252 
1253     /*
1254      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1255      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1256      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1257      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1258      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1259      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1260      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1261      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1262      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1263      *
1264      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1265      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1266      */
1267     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1268 
1269     /*
1270      *     bytes4(keccak256('name()')) == 0x06fdde03
1271      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1272      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1273      *
1274      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1275      */
1276     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1277 
1278     /*
1279      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1280      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1281      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1282      *
1283      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1284      */
1285     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1286 
1287     /**
1288      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1289      */
1290     constructor (string memory name_, string memory symbol_) {
1291         _name = name_;
1292         _symbol = symbol_;
1293 
1294         // register the supported interfaces to conform to ERC721 via ERC165
1295         _registerInterface(_INTERFACE_ID_ERC721);
1296         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1297         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1298     }
1299 
1300     /**
1301      * @dev See {IERC721-balanceOf}.
1302      */
1303     function balanceOf(address owner) public view virtual override returns (uint256) {
1304         require(owner != address(0), "ERC721: balance query for the zero address");
1305         return _holderTokens[owner].length();
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-ownerOf}.
1310      */
1311     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1312         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Metadata-name}.
1317      */
1318     function name() public view virtual override returns (string memory) {
1319         return _name;
1320     }
1321 
1322     /**
1323      * @dev See {IERC721Metadata-symbol}.
1324      */
1325     function symbol() public view virtual override returns (string memory) {
1326         return _symbol;
1327     }
1328 
1329     /**
1330      * @dev See {IERC721Metadata-tokenURI}.
1331      */
1332     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1333         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1334 
1335         string memory _tokenURI = _tokenURIs[tokenId];
1336         string memory base = baseURI();
1337 
1338         // If there is no base URI, return the token URI.
1339         if (bytes(base).length == 0) {
1340             return _tokenURI;
1341         }
1342         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1343         if (bytes(_tokenURI).length > 0) {
1344             return string(abi.encodePacked(base, _tokenURI));
1345         }
1346         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1347         return string(abi.encodePacked(base, tokenId.toString()));
1348     }
1349 
1350     /**
1351     * @dev Returns the base URI set via {_setBaseURI}. This will be
1352     * automatically added as a prefix in {tokenURI} to each token's URI, or
1353     * to the token ID if no specific URI is set for that token ID.
1354     */
1355     function baseURI() public view virtual returns (string memory) {
1356         return _baseURI;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1361      */
1362     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1363         return _holderTokens[owner].at(index);
1364     }
1365 
1366     /**
1367      * @dev See {IERC721Enumerable-totalSupply}.
1368      */
1369     function totalSupply() public view virtual override returns (uint256) {
1370         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1371         return _tokenOwners.length();
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Enumerable-tokenByIndex}.
1376      */
1377     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1378         (uint256 tokenId, ) = _tokenOwners.at(index);
1379         return tokenId;
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-approve}.
1384      */
1385     function approve(address to, uint256 tokenId) public virtual override {
1386         address owner = ERC721.ownerOf(tokenId);
1387         require(to != owner, "ERC721: approval to current owner");
1388 
1389         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1390             "ERC721: approve caller is not owner nor approved for all"
1391         );
1392 
1393         _approve(to, tokenId);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-getApproved}.
1398      */
1399     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1400         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1401 
1402         return _tokenApprovals[tokenId];
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-setApprovalForAll}.
1407      */
1408     function setApprovalForAll(address operator, bool approved) public virtual override {
1409         require(operator != _msgSender(), "ERC721: approve to caller");
1410 
1411         _operatorApprovals[_msgSender()][operator] = approved;
1412         emit ApprovalForAll(_msgSender(), operator, approved);
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-isApprovedForAll}.
1417      */
1418     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1419         return _operatorApprovals[owner][operator];
1420     }
1421 
1422     /**
1423      * @dev See {IERC721-transferFrom}.
1424      */
1425     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1426         //solhint-disable-next-line max-line-length
1427         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1428 
1429         _transfer(from, to, tokenId);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-safeTransferFrom}.
1434      */
1435     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1436         safeTransferFrom(from, to, tokenId, "");
1437     }
1438 
1439     /**
1440      * @dev See {IERC721-safeTransferFrom}.
1441      */
1442     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1443         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1444         _safeTransfer(from, to, tokenId, _data);
1445     }
1446 
1447     /**
1448      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1449      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1450      *
1451      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1452      *
1453      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1454      * implement alternative mechanisms to perform token transfer, such as signature-based.
1455      *
1456      * Requirements:
1457      *
1458      * - `from` cannot be the zero address.
1459      * - `to` cannot be the zero address.
1460      * - `tokenId` token must exist and be owned by `from`.
1461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1466         _transfer(from, to, tokenId);
1467         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1468     }
1469 
1470     /**
1471      * @dev Returns whether `tokenId` exists.
1472      *
1473      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1474      *
1475      * Tokens start existing when they are minted (`_mint`),
1476      * and stop existing when they are burned (`_burn`).
1477      */
1478     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1479         return _tokenOwners.contains(tokenId);
1480     }
1481 
1482     /**
1483      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1484      *
1485      * Requirements:
1486      *
1487      * - `tokenId` must exist.
1488      */
1489     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1490         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1491         address owner = ERC721.ownerOf(tokenId);
1492         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1493     }
1494 
1495     /**
1496      * @dev Safely mints `tokenId` and transfers it to `to`.
1497      *
1498      * Requirements:
1499      d*
1500      * - `tokenId` must not exist.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function _safeMint(address to, uint256 tokenId) internal virtual {
1506         _safeMint(to, tokenId, "");
1507     }
1508 
1509     /**
1510      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1511      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1512      */
1513     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1514         _mint(to, tokenId);
1515         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1516     }
1517 
1518     /**
1519      * @dev Mints `tokenId` and transfers it to `to`.
1520      *
1521      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1522      *
1523      * Requirements:
1524      *
1525      * - `tokenId` must not exist.
1526      * - `to` cannot be the zero address.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function _mint(address to, uint256 tokenId) internal virtual {
1531         require(to != address(0), "ERC721: mint to the zero address");
1532         require(!_exists(tokenId), "ERC721: token already minted");
1533 
1534         _beforeTokenTransfer(address(0), to, tokenId);
1535 
1536         _holderTokens[to].add(tokenId);
1537 
1538         _tokenOwners.set(tokenId, to);
1539 
1540         emit Transfer(address(0), to, tokenId);
1541     }
1542 
1543     /**
1544      * @dev Destroys `tokenId`.
1545      * The approval is cleared when the token is burned.
1546      *
1547      * Requirements:
1548      *
1549      * - `tokenId` must exist.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function _burn(uint256 tokenId) internal virtual {
1554         address owner = ERC721.ownerOf(tokenId); // internal owner
1555 
1556         _beforeTokenTransfer(owner, address(0), tokenId);
1557 
1558         // Clear approvals
1559         _approve(address(0), tokenId);
1560 
1561         // Clear metadata (if any)
1562         if (bytes(_tokenURIs[tokenId]).length != 0) {
1563             delete _tokenURIs[tokenId];
1564         }
1565 
1566         _holderTokens[owner].remove(tokenId);
1567 
1568         _tokenOwners.remove(tokenId);
1569 
1570         emit Transfer(owner, address(0), tokenId);
1571     }
1572 
1573     /**
1574      * @dev Transfers `tokenId` from `from` to `to`.
1575      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1576      *
1577      * Requirements:
1578      *
1579      * - `to` cannot be the zero address.
1580      * - `tokenId` token must be owned by `from`.
1581      *
1582      * Emits a {Transfer} event.
1583      */
1584     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1585         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1586         require(to != address(0), "ERC721: transfer to the zero address");
1587 
1588         _beforeTokenTransfer(from, to, tokenId);
1589 
1590         // Clear approvals from the previous owner
1591         _approve(address(0), tokenId);
1592 
1593         _holderTokens[from].remove(tokenId);
1594         _holderTokens[to].add(tokenId);
1595 
1596         _tokenOwners.set(tokenId, to);
1597 
1598         emit Transfer(from, to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1603      *
1604      * Requirements:
1605      *
1606      * - `tokenId` must exist.
1607      */
1608     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1609         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1610         _tokenURIs[tokenId] = _tokenURI;
1611     }
1612 
1613     /**
1614      * @dev Internal function to set the base URI for all token IDs. It is
1615      * automatically added as a prefix to the value returned in {tokenURI},
1616      * or to the token ID if {tokenURI} is empty.
1617      */
1618     function _setBaseURI(string memory baseURI_) internal virtual {
1619         _baseURI = baseURI_;
1620     }
1621 
1622     /**
1623      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1624      * The call is not executed if the target address is not a contract.
1625      *
1626      * @param from address representing the previous owner of the given token ID
1627      * @param to target address that will receive the tokens
1628      * @param tokenId uint256 ID of the token to be transferred
1629      * @param _data bytes optional data to send along with the call
1630      * @return bool whether the call correctly returned the expected magic value
1631      */
1632     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1633         private returns (bool)
1634     {
1635         if (!to.isContract()) {
1636             return true;
1637         }
1638         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1639             IERC721Receiver(to).onERC721Received.selector,
1640             _msgSender(),
1641             from,
1642             tokenId,
1643             _data
1644         ), "ERC721: transfer to non ERC721Receiver implementer");
1645         bytes4 retval = abi.decode(returndata, (bytes4));
1646         return (retval == _ERC721_RECEIVED);
1647     }
1648 
1649     /**
1650      * @dev Approve `to` to operate on `tokenId`
1651      *
1652      * Emits an {Approval} event.
1653      */
1654     function _approve(address to, uint256 tokenId) internal virtual {
1655         _tokenApprovals[tokenId] = to;
1656         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1657     }
1658 
1659     /**
1660      * @dev Hook that is called before any token transfer. This includes minting
1661      * and burning.
1662      *
1663      * Calling conditions:
1664      *
1665      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1666      * transferred to `to`.
1667      * - When `from` is zero, `tokenId` will be minted for `to`.
1668      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1669      * - `from` cannot be the zero address.
1670      * - `to` cannot be the zero address.
1671      *
1672      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1673      */
1674     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1675 }
1676 
1677 contract PineapplesDayOut is ERC721, Ownable {
1678   using Strings for uint256;
1679 
1680   string _baseTokenURI;
1681   uint256 public price = 20000000000000000;   // .02 ETH
1682   bool public saleIsActive = false;
1683   // Reserve 120 Pineapples for team - Giveaways/Prizes/Presales etc
1684   uint public _reserve = 116;
1685   
1686   mapping (string => address) public team;
1687   
1688   constructor(address _t1, address _t2, address _t3, address _t4, string memory baseURI) ERC721("PineapplesDayOut", "PDO") {
1689     setBaseURI(baseURI);
1690 
1691     team["Alina#4526"] = _t1;
1692     team["vandemlau#0301"] = _t2;
1693     team["kashushu"] = _t3;
1694     team["PineappleHead#4535"] = _t4;
1695 
1696     // team gets the first 4 pineapples
1697     _safeMint( team["Alina#4526"], 0);
1698     _safeMint( team["vandemlau#0301"], 1);
1699     _safeMint( team["kashushu"], 2);
1700     _safeMint( team["PineappleHead#4535"], 3);
1701   }
1702   /** 
1703    * Mint a number of tigers straight in target wallet.
1704    * @param _to: The target wallet address, make sure it's the correct wallet.
1705    * @param _numberOfTokens: The number of tokens to mint.
1706    * @dev This function can only be called by the contract owner as it is a free mint.
1707    */
1708   function airdropPineapple(address _to, uint _numberOfTokens) public onlyOwner {
1709     require(_numberOfTokens <= _reserve, "Not enough Pineapples left in reserve");
1710     uint totalSupply = totalSupply();
1711     require(totalSupply + _numberOfTokens < 5001, "Purchase would exceed max supply of Pineapples");
1712     for(uint i = 0; i < _numberOfTokens; i++) {
1713       uint mintIndex = totalSupply + i;
1714       _safeMint(_to, mintIndex);
1715     }
1716     _reserve -= _numberOfTokens;
1717   }
1718   /** 
1719    * Mint a number of tigers straight in the caller's wallet.
1720    * @param _numberOfTokens: The number of tokens to mint.
1721    */
1722   function mintPineapple(uint _numberOfTokens) public payable {
1723     require(saleIsActive, "Sale must be active to mint a Pineapple");
1724     require(_numberOfTokens < 21, "Can only mint 20 tokens at a time");
1725     uint totalSupply = totalSupply();
1726     require(totalSupply + _numberOfTokens + _reserve < 5001, "Purchase would exceed max supply of Pineapples");
1727     require(msg.value >= price * _numberOfTokens, "Ether value sent is not correct");
1728     for(uint i = 0; i < _numberOfTokens; i++) {
1729       uint mintIndex = totalSupply + i;
1730       _safeMint(msg.sender, mintIndex);
1731     }
1732   }
1733   function flipSaleState() public onlyOwner {
1734     saleIsActive = !saleIsActive;
1735     emit SalesFlipped(saleIsActive);
1736   }
1737   function setBaseURI(string memory baseURI) public onlyOwner {
1738     _baseTokenURI = baseURI;
1739   }
1740   // Might wanna adjust price later on.
1741   function setPrice(uint256 _newPrice) public onlyOwner() {
1742     price = _newPrice;
1743   }
1744   function withdraw() public onlyOwner {
1745     uint balance = address(this).balance / 10;
1746     uint _remains = address(this).balance - balance;
1747     uint _each = _remains / 4;
1748     require(payable(team["Alina#4526"]).send(_each));
1749     require(payable(team["vandemlau#0301"]).send(_each));
1750     require(payable(team["kashushu"]).send(_each));
1751     require(payable(team["PineappleHead#4535"]).send(_each));
1752     msg.sender.transfer(balance);
1753   }
1754   function updateAddress(string memory _id, address _new) public onlyOwner() {
1755     team[_id] = _new;
1756   }
1757   function getBaseURI() public view returns(string memory) {
1758     return _baseTokenURI;
1759   }
1760   function getPrice() public view returns(uint256){
1761     return price;
1762   }
1763   function tokenURI(uint256 tokenId) public override view returns(string memory) {
1764     return string(abi.encodePacked(_baseTokenURI, tokenId.toString()));
1765   }
1766   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1767     uint256 tokenCount = balanceOf(_owner);
1768     if (tokenCount == 0) {
1769       // Return an empty array
1770       return new uint256[](0);
1771     } else {
1772       uint256[] memory result = new uint256[](tokenCount);
1773       for (uint i = 0; i < tokenCount; i++) {
1774         result[i] = tokenOfOwnerByIndex(_owner, i);
1775       }
1776       return result;
1777     }
1778   }
1779   /**
1780     * @dev Emitted when `saleIsActive` switches.
1781     */
1782   event SalesFlipped(bool saleIsActive);
1783 }