1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.2.0
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46         // Position of the value in the `values` array, plus 1 because index 0
47         // means a value is not in the set.
48         mapping(bytes32 => uint256) _indexes;
49     }
50 
51     /**
52      * @dev Add a value to a set. O(1).
53      *
54      * Returns true if the value was added to the set, that is if it was not
55      * already present.
56      */
57     function _add(Set storage set, bytes32 value) private returns (bool) {
58         if (!_contains(set, value)) {
59             set._values.push(value);
60             // The value is stored at length-1, but we add 1 to all indexes
61             // and use 0 as a sentinel value
62             set._indexes[value] = set._values.length;
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /**
70      * @dev Removes a value from a set. O(1).
71      *
72      * Returns true if the value was removed from the set, that is if it was
73      * present.
74      */
75     function _remove(Set storage set, bytes32 value) private returns (bool) {
76         // We read and store the value's index to prevent multiple reads from the same storage slot
77         uint256 valueIndex = set._indexes[value];
78 
79         if (valueIndex != 0) {
80             // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             if (lastIndex != toDeleteIndex) {
89                 bytes32 lastvalue = set._values[lastIndex];
90 
91                 // Move the last value to the index where the value to delete is
92                 set._values[toDeleteIndex] = lastvalue;
93                 // Update the index for the moved value
94                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
95             }
96 
97             // Delete the slot where the moved value was stored
98             set._values.pop();
99 
100             // Delete the index for the deleted slot
101             delete set._indexes[value];
102 
103             return true;
104         } else {
105             return false;
106         }
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function _contains(Set storage set, bytes32 value) private view returns (bool) {
113         return set._indexes[value] != 0;
114     }
115 
116     /**
117      * @dev Returns the number of values on the set. O(1).
118      */
119     function _length(Set storage set) private view returns (uint256) {
120         return set._values.length;
121     }
122 
123     /**
124      * @dev Returns the value stored at position `index` in the set. O(1).
125      *
126      * Note that there are no guarantees on the ordering of values inside the
127      * array, and it may change when more values are added or removed.
128      *
129      * Requirements:
130      *
131      * - `index` must be strictly less than {length}.
132      */
133     function _at(Set storage set, uint256 index) private view returns (bytes32) {
134         return set._values[index];
135     }
136 
137     // Bytes32Set
138 
139     struct Bytes32Set {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
150         return _add(set._inner, value);
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
160         return _remove(set._inner, value);
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
167         return _contains(set._inner, value);
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(Bytes32Set storage set) internal view returns (uint256) {
174         return _length(set._inner);
175     }
176 
177     /**
178      * @dev Returns the value stored at position `index` in the set. O(1).
179      *
180      * Note that there are no guarantees on the ordering of values inside the
181      * array, and it may change when more values are added or removed.
182      *
183      * Requirements:
184      *
185      * - `index` must be strictly less than {length}.
186      */
187     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
188         return _at(set._inner, index);
189     }
190 
191     // AddressSet
192 
193     struct AddressSet {
194         Set _inner;
195     }
196 
197     /**
198      * @dev Add a value to a set. O(1).
199      *
200      * Returns true if the value was added to the set, that is if it was not
201      * already present.
202      */
203     function add(AddressSet storage set, address value) internal returns (bool) {
204         return _add(set._inner, bytes32(uint256(uint160(value))));
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(AddressSet storage set, address value) internal returns (bool) {
214         return _remove(set._inner, bytes32(uint256(uint160(value))));
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(AddressSet storage set, address value) internal view returns (bool) {
221         return _contains(set._inner, bytes32(uint256(uint160(value))));
222     }
223 
224     /**
225      * @dev Returns the number of values in the set. O(1).
226      */
227     function length(AddressSet storage set) internal view returns (uint256) {
228         return _length(set._inner);
229     }
230 
231     /**
232      * @dev Returns the value stored at position `index` in the set. O(1).
233      *
234      * Note that there are no guarantees on the ordering of values inside the
235      * array, and it may change when more values are added or removed.
236      *
237      * Requirements:
238      *
239      * - `index` must be strictly less than {length}.
240      */
241     function at(AddressSet storage set, uint256 index) internal view returns (address) {
242         return address(uint160(uint256(_at(set._inner, index))));
243     }
244 
245     // UintSet
246 
247     struct UintSet {
248         Set _inner;
249     }
250 
251     /**
252      * @dev Add a value to a set. O(1).
253      *
254      * Returns true if the value was added to the set, that is if it was not
255      * already present.
256      */
257     function add(UintSet storage set, uint256 value) internal returns (bool) {
258         return _add(set._inner, bytes32(value));
259     }
260 
261     /**
262      * @dev Removes a value from a set. O(1).
263      *
264      * Returns true if the value was removed from the set, that is if it was
265      * present.
266      */
267     function remove(UintSet storage set, uint256 value) internal returns (bool) {
268         return _remove(set._inner, bytes32(value));
269     }
270 
271     /**
272      * @dev Returns true if the value is in the set. O(1).
273      */
274     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
275         return _contains(set._inner, bytes32(value));
276     }
277 
278     /**
279      * @dev Returns the number of values on the set. O(1).
280      */
281     function length(UintSet storage set) internal view returns (uint256) {
282         return _length(set._inner);
283     }
284 
285     /**
286      * @dev Returns the value stored at position `index` in the set. O(1).
287      *
288      * Note that there are no guarantees on the ordering of values inside the
289      * array, and it may change when more values are added or removed.
290      *
291      * Requirements:
292      *
293      * - `index` must be strictly less than {length}.
294      */
295     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
296         return uint256(_at(set._inner, index));
297     }
298 }
299 
300 
301 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.2.0
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Library for managing an enumerable variant of Solidity's
309  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
310  * type.
311  *
312  * Maps have the following properties:
313  *
314  * - Entries are added, removed, and checked for existence in constant time
315  * (O(1)).
316  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
317  *
318  * ```
319  * contract Example {
320  *     // Add the library methods
321  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
322  *
323  *     // Declare a set state variable
324  *     EnumerableMap.UintToAddressMap private myMap;
325  * }
326  * ```
327  *
328  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
329  * supported.
330  */
331 library EnumerableMap {
332     using EnumerableSet for EnumerableSet.Bytes32Set;
333 
334     // To implement this library for multiple types with as little code
335     // repetition as possible, we write it in terms of a generic Map type with
336     // bytes32 keys and values.
337     // The Map implementation uses private functions, and user-facing
338     // implementations (such as Uint256ToAddressMap) are just wrappers around
339     // the underlying Map.
340     // This means that we can only create new EnumerableMaps for types that fit
341     // in bytes32.
342 
343     struct Map {
344         // Storage of keys
345         EnumerableSet.Bytes32Set _keys;
346         mapping(bytes32 => bytes32) _values;
347     }
348 
349     /**
350      * @dev Adds a key-value pair to a map, or updates the value for an existing
351      * key. O(1).
352      *
353      * Returns true if the key was added to the map, that is if it was not
354      * already present.
355      */
356     function _set(
357         Map storage map,
358         bytes32 key,
359         bytes32 value
360     ) private returns (bool) {
361         map._values[key] = value;
362         return map._keys.add(key);
363     }
364 
365     /**
366      * @dev Removes a key-value pair from a map. O(1).
367      *
368      * Returns true if the key was removed from the map, that is if it was present.
369      */
370     function _remove(Map storage map, bytes32 key) private returns (bool) {
371         delete map._values[key];
372         return map._keys.remove(key);
373     }
374 
375     /**
376      * @dev Returns true if the key is in the map. O(1).
377      */
378     function _contains(Map storage map, bytes32 key) private view returns (bool) {
379         return map._keys.contains(key);
380     }
381 
382     /**
383      * @dev Returns the number of key-value pairs in the map. O(1).
384      */
385     function _length(Map storage map) private view returns (uint256) {
386         return map._keys.length();
387     }
388 
389     /**
390      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
391      *
392      * Note that there are no guarantees on the ordering of entries inside the
393      * array, and it may change when more entries are added or removed.
394      *
395      * Requirements:
396      *
397      * - `index` must be strictly less than {length}.
398      */
399     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
400         bytes32 key = map._keys.at(index);
401         return (key, map._values[key]);
402     }
403 
404     /**
405      * @dev Tries to returns the value associated with `key`.  O(1).
406      * Does not revert if `key` is not in the map.
407      */
408     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
409         bytes32 value = map._values[key];
410         if (value == bytes32(0)) {
411             return (_contains(map, key), bytes32(0));
412         } else {
413             return (true, value);
414         }
415     }
416 
417     /**
418      * @dev Returns the value associated with `key`.  O(1).
419      *
420      * Requirements:
421      *
422      * - `key` must be in the map.
423      */
424     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
425         bytes32 value = map._values[key];
426         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
427         return value;
428     }
429 
430     /**
431      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
432      *
433      * CAUTION: This function is deprecated because it requires allocating memory for the error
434      * message unnecessarily. For custom revert reasons use {_tryGet}.
435      */
436     function _get(
437         Map storage map,
438         bytes32 key,
439         string memory errorMessage
440     ) private view returns (bytes32) {
441         bytes32 value = map._values[key];
442         require(value != 0 || _contains(map, key), errorMessage);
443         return value;
444     }
445 
446     // UintToAddressMap
447 
448     struct UintToAddressMap {
449         Map _inner;
450     }
451 
452     /**
453      * @dev Adds a key-value pair to a map, or updates the value for an existing
454      * key. O(1).
455      *
456      * Returns true if the key was added to the map, that is if it was not
457      * already present.
458      */
459     function set(
460         UintToAddressMap storage map,
461         uint256 key,
462         address value
463     ) internal returns (bool) {
464         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
465     }
466 
467     /**
468      * @dev Removes a value from a set. O(1).
469      *
470      * Returns true if the key was removed from the map, that is if it was present.
471      */
472     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
473         return _remove(map._inner, bytes32(key));
474     }
475 
476     /**
477      * @dev Returns true if the key is in the map. O(1).
478      */
479     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
480         return _contains(map._inner, bytes32(key));
481     }
482 
483     /**
484      * @dev Returns the number of elements in the map. O(1).
485      */
486     function length(UintToAddressMap storage map) internal view returns (uint256) {
487         return _length(map._inner);
488     }
489 
490     /**
491      * @dev Returns the element stored at position `index` in the set. O(1).
492      * Note that there are no guarantees on the ordering of values inside the
493      * array, and it may change when more values are added or removed.
494      *
495      * Requirements:
496      *
497      * - `index` must be strictly less than {length}.
498      */
499     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
500         (bytes32 key, bytes32 value) = _at(map._inner, index);
501         return (uint256(key), address(uint160(uint256(value))));
502     }
503 
504     /**
505      * @dev Tries to returns the value associated with `key`.  O(1).
506      * Does not revert if `key` is not in the map.
507      *
508      * _Available since v3.4._
509      */
510     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
511         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
512         return (success, address(uint160(uint256(value))));
513     }
514 
515     /**
516      * @dev Returns the value associated with `key`.  O(1).
517      *
518      * Requirements:
519      *
520      * - `key` must be in the map.
521      */
522     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
523         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
524     }
525 
526     /**
527      * @dev Same as {get}, with a custom error message when `key` is not in the map.
528      *
529      * CAUTION: This function is deprecated because it requires allocating memory for the error
530      * message unnecessarily. For custom revert reasons use {tryGet}.
531      */
532     function get(
533         UintToAddressMap storage map,
534         uint256 key,
535         string memory errorMessage
536     ) internal view returns (address) {
537         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
538     }
539 }
540 
541 
542 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
543 
544 
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @dev Interface of the ERC165 standard, as defined in the
550  * https://eips.ethereum.org/EIPS/eip-165[EIP].
551  *
552  * Implementers can declare support of contract interfaces, which can then be
553  * queried by others ({ERC165Checker}).
554  *
555  * For an implementation, see {ERC165}.
556  */
557 interface IERC165 {
558     /**
559      * @dev Returns true if this contract implements the interface defined by
560      * `interfaceId`. See the corresponding
561      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
562      * to learn more about how these ids are created.
563      *
564      * This function call must use less than 30 000 gas.
565      */
566     function supportsInterface(bytes4 interfaceId) external view returns (bool);
567 }
568 
569 
570 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
571 
572 
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers `tokenId` token from `from` to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
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
693      * @dev Safely transfers `tokenId` token from `from` to `to`.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes calldata data
710     ) external;
711 }
712 
713 
714 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
715 
716 
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Metadata is IERC721 {
725     /**
726      * @dev Returns the token collection name.
727      */
728     function name() external view returns (string memory);
729 
730     /**
731      * @dev Returns the token collection symbol.
732      */
733     function symbol() external view returns (string memory);
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) external view returns (string memory);
739 }
740 
741 
742 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
743 
744 
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
750  * @dev See https://eips.ethereum.org/EIPS/eip-721
751  */
752 interface IERC721Enumerable is IERC721 {
753     /**
754      * @dev Returns the total amount of tokens stored by the contract.
755      */
756     function totalSupply() external view returns (uint256);
757 
758     /**
759      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
760      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
761      */
762     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
763 
764     /**
765      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
766      * Use along with {totalSupply} to enumerate all tokens.
767      */
768     function tokenByIndex(uint256 index) external view returns (uint256);
769 }
770 
771 
772 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
773 
774 
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @title ERC721 token receiver interface
780  * @dev Interface for any contract that wants to support safeTransfers
781  * from ERC721 asset contracts.
782  */
783 interface IERC721Receiver {
784     /**
785      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
786      * by `operator` from `from`, this function is called.
787      *
788      * It must return its Solidity selector to confirm the token transfer.
789      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
790      *
791      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
792      */
793     function onERC721Received(
794         address operator,
795         address from,
796         uint256 tokenId,
797         bytes calldata data
798     ) external returns (bytes4);
799 }
800 
801 
802 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
803 
804 
805 
806 pragma solidity ^0.8.0;
807 
808 /**
809  * @dev Collection of functions related to the address type
810  */
811 library Address {
812     /**
813      * @dev Returns true if `account` is a contract.
814      *
815      * [IMPORTANT]
816      * ====
817      * It is unsafe to assume that an address for which this function returns
818      * false is an externally-owned account (EOA) and not a contract.
819      *
820      * Among others, `isContract` will return false for the following
821      * types of addresses:
822      *
823      *  - an externally-owned account
824      *  - a contract in construction
825      *  - an address where a contract will be created
826      *  - an address where a contract lived, but was destroyed
827      * ====
828      */
829     function isContract(address account) internal view returns (bool) {
830         // This method relies on extcodesize, which returns 0 for contracts in
831         // construction, since the code is only stored at the end of the
832         // constructor execution.
833 
834         uint256 size;
835         assembly {
836             size := extcodesize(account)
837         }
838         return size > 0;
839     }
840 
841     /**
842      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
843      * `recipient`, forwarding all available gas and reverting on errors.
844      *
845      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
846      * of certain opcodes, possibly making contracts go over the 2300 gas limit
847      * imposed by `transfer`, making them unable to receive funds via
848      * `transfer`. {sendValue} removes this limitation.
849      *
850      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
851      *
852      * IMPORTANT: because control is transferred to `recipient`, care must be
853      * taken to not create reentrancy vulnerabilities. Consider using
854      * {ReentrancyGuard} or the
855      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
856      */
857     function sendValue(address payable recipient, uint256 amount) internal {
858         require(address(this).balance >= amount, "Address: insufficient balance");
859 
860         (bool success, ) = recipient.call{value: amount}("");
861         require(success, "Address: unable to send value, recipient may have reverted");
862     }
863 
864     /**
865      * @dev Performs a Solidity function call using a low level `call`. A
866      * plain `call` is an unsafe replacement for a function call: use this
867      * function instead.
868      *
869      * If `target` reverts with a revert reason, it is bubbled up by this
870      * function (like regular Solidity function calls).
871      *
872      * Returns the raw returned data. To convert to the expected return value,
873      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
874      *
875      * Requirements:
876      *
877      * - `target` must be a contract.
878      * - calling `target` with `data` must not revert.
879      *
880      * _Available since v3.1._
881      */
882     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
883         return functionCall(target, data, "Address: low-level call failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
888      * `errorMessage` as a fallback revert reason when `target` reverts.
889      *
890      * _Available since v3.1._
891      */
892     function functionCall(
893         address target,
894         bytes memory data,
895         string memory errorMessage
896     ) internal returns (bytes memory) {
897         return functionCallWithValue(target, data, 0, errorMessage);
898     }
899 
900     /**
901      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
902      * but also transferring `value` wei to `target`.
903      *
904      * Requirements:
905      *
906      * - the calling contract must have an ETH balance of at least `value`.
907      * - the called Solidity function must be `payable`.
908      *
909      * _Available since v3.1._
910      */
911     function functionCallWithValue(
912         address target,
913         bytes memory data,
914         uint256 value
915     ) internal returns (bytes memory) {
916         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
921      * with `errorMessage` as a fallback revert reason when `target` reverts.
922      *
923      * _Available since v3.1._
924      */
925     function functionCallWithValue(
926         address target,
927         bytes memory data,
928         uint256 value,
929         string memory errorMessage
930     ) internal returns (bytes memory) {
931         require(address(this).balance >= value, "Address: insufficient balance for call");
932         require(isContract(target), "Address: call to non-contract");
933 
934         (bool success, bytes memory returndata) = target.call{value: value}(data);
935         return _verifyCallResult(success, returndata, errorMessage);
936     }
937 
938     /**
939      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
940      * but performing a static call.
941      *
942      * _Available since v3.3._
943      */
944     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
945         return functionStaticCall(target, data, "Address: low-level static call failed");
946     }
947 
948     /**
949      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
950      * but performing a static call.
951      *
952      * _Available since v3.3._
953      */
954     function functionStaticCall(
955         address target,
956         bytes memory data,
957         string memory errorMessage
958     ) internal view returns (bytes memory) {
959         require(isContract(target), "Address: static call to non-contract");
960 
961         (bool success, bytes memory returndata) = target.staticcall(data);
962         return _verifyCallResult(success, returndata, errorMessage);
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
967      * but performing a delegate call.
968      *
969      * _Available since v3.4._
970      */
971     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
972         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
973     }
974 
975     /**
976      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
977      * but performing a delegate call.
978      *
979      * _Available since v3.4._
980      */
981     function functionDelegateCall(
982         address target,
983         bytes memory data,
984         string memory errorMessage
985     ) internal returns (bytes memory) {
986         require(isContract(target), "Address: delegate call to non-contract");
987 
988         (bool success, bytes memory returndata) = target.delegatecall(data);
989         return _verifyCallResult(success, returndata, errorMessage);
990     }
991 
992     function _verifyCallResult(
993         bool success,
994         bytes memory returndata,
995         string memory errorMessage
996     ) private pure returns (bytes memory) {
997         if (success) {
998             return returndata;
999         } else {
1000             // Look for revert reason and bubble it up if present
1001             if (returndata.length > 0) {
1002                 // The easiest way to bubble the revert reason is using memory via assembly
1003 
1004                 assembly {
1005                     let returndata_size := mload(returndata)
1006                     revert(add(32, returndata), returndata_size)
1007                 }
1008             } else {
1009                 revert(errorMessage);
1010             }
1011         }
1012     }
1013 }
1014 
1015 
1016 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
1017 
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 /*
1023  * @dev Provides information about the current execution context, including the
1024  * sender of the transaction and its data. While these are generally available
1025  * via msg.sender and msg.data, they should not be accessed in such a direct
1026  * manner, since when dealing with meta-transactions the account sending and
1027  * paying for execution may not be the actual sender (as far as an application
1028  * is concerned).
1029  *
1030  * This contract is only required for intermediate, library-like contracts.
1031  */
1032 abstract contract Context {
1033     function _msgSender() internal view virtual returns (address) {
1034         return msg.sender;
1035     }
1036 
1037     function _msgData() internal view virtual returns (bytes calldata) {
1038         return msg.data;
1039     }
1040 }
1041 
1042 
1043 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
1044 
1045 
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @dev String operations.
1051  */
1052 library Strings {
1053     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1054 
1055     /**
1056      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1057      */
1058     function toString(uint256 value) internal pure returns (string memory) {
1059         // Inspired by OraclizeAPI's implementation - MIT licence
1060         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1061 
1062         if (value == 0) {
1063             return "0";
1064         }
1065         uint256 temp = value;
1066         uint256 digits;
1067         while (temp != 0) {
1068             digits++;
1069             temp /= 10;
1070         }
1071         bytes memory buffer = new bytes(digits);
1072         while (value != 0) {
1073             digits -= 1;
1074             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1075             value /= 10;
1076         }
1077         return string(buffer);
1078     }
1079 
1080     /**
1081      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1082      */
1083     function toHexString(uint256 value) internal pure returns (string memory) {
1084         if (value == 0) {
1085             return "0x00";
1086         }
1087         uint256 temp = value;
1088         uint256 length = 0;
1089         while (temp != 0) {
1090             length++;
1091             temp >>= 8;
1092         }
1093         return toHexString(value, length);
1094     }
1095 
1096     /**
1097      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1098      */
1099     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1100         bytes memory buffer = new bytes(2 * length + 2);
1101         buffer[0] = "0";
1102         buffer[1] = "x";
1103         for (uint256 i = 2 * length + 1; i > 1; --i) {
1104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1105             value >>= 4;
1106         }
1107         require(value == 0, "Strings: hex length insufficient");
1108         return string(buffer);
1109     }
1110 }
1111 
1112 
1113 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1114 
1115 
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 // CAUTION
1120 // This version of SafeMath should only be used with Solidity 0.8 or later,
1121 // because it relies on the compiler's built in overflow checks.
1122 
1123 /**
1124  * @dev Wrappers over Solidity's arithmetic operations.
1125  *
1126  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1127  * now has built in overflow checking.
1128  */
1129 library SafeMath {
1130     /**
1131      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1132      *
1133      * _Available since v3.4._
1134      */
1135     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1136         unchecked {
1137             uint256 c = a + b;
1138             if (c < a) return (false, 0);
1139             return (true, c);
1140         }
1141     }
1142 
1143     /**
1144      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1145      *
1146      * _Available since v3.4._
1147      */
1148     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1149         unchecked {
1150             if (b > a) return (false, 0);
1151             return (true, a - b);
1152         }
1153     }
1154 
1155     /**
1156      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1157      *
1158      * _Available since v3.4._
1159      */
1160     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1161         unchecked {
1162             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1163             // benefit is lost if 'b' is also tested.
1164             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1165             if (a == 0) return (true, 0);
1166             uint256 c = a * b;
1167             if (c / a != b) return (false, 0);
1168             return (true, c);
1169         }
1170     }
1171 
1172     /**
1173      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1174      *
1175      * _Available since v3.4._
1176      */
1177     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1178         unchecked {
1179             if (b == 0) return (false, 0);
1180             return (true, a / b);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1186      *
1187      * _Available since v3.4._
1188      */
1189     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1190         unchecked {
1191             if (b == 0) return (false, 0);
1192             return (true, a % b);
1193         }
1194     }
1195 
1196     /**
1197      * @dev Returns the addition of two unsigned integers, reverting on
1198      * overflow.
1199      *
1200      * Counterpart to Solidity's `+` operator.
1201      *
1202      * Requirements:
1203      *
1204      * - Addition cannot overflow.
1205      */
1206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1207         return a + b;
1208     }
1209 
1210     /**
1211      * @dev Returns the subtraction of two unsigned integers, reverting on
1212      * overflow (when the result is negative).
1213      *
1214      * Counterpart to Solidity's `-` operator.
1215      *
1216      * Requirements:
1217      *
1218      * - Subtraction cannot overflow.
1219      */
1220     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1221         return a - b;
1222     }
1223 
1224     /**
1225      * @dev Returns the multiplication of two unsigned integers, reverting on
1226      * overflow.
1227      *
1228      * Counterpart to Solidity's `*` operator.
1229      *
1230      * Requirements:
1231      *
1232      * - Multiplication cannot overflow.
1233      */
1234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1235         return a * b;
1236     }
1237 
1238     /**
1239      * @dev Returns the integer division of two unsigned integers, reverting on
1240      * division by zero. The result is rounded towards zero.
1241      *
1242      * Counterpart to Solidity's `/` operator.
1243      *
1244      * Requirements:
1245      *
1246      * - The divisor cannot be zero.
1247      */
1248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1249         return a / b;
1250     }
1251 
1252     /**
1253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1254      * reverting when dividing by zero.
1255      *
1256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1257      * opcode (which leaves remaining gas untouched) while Solidity uses an
1258      * invalid opcode to revert (consuming all remaining gas).
1259      *
1260      * Requirements:
1261      *
1262      * - The divisor cannot be zero.
1263      */
1264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1265         return a % b;
1266     }
1267 
1268     /**
1269      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1270      * overflow (when the result is negative).
1271      *
1272      * CAUTION: This function is deprecated because it requires allocating memory for the error
1273      * message unnecessarily. For custom revert reasons use {trySub}.
1274      *
1275      * Counterpart to Solidity's `-` operator.
1276      *
1277      * Requirements:
1278      *
1279      * - Subtraction cannot overflow.
1280      */
1281     function sub(
1282         uint256 a,
1283         uint256 b,
1284         string memory errorMessage
1285     ) internal pure returns (uint256) {
1286         unchecked {
1287             require(b <= a, errorMessage);
1288             return a - b;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1294      * division by zero. The result is rounded towards zero.
1295      *
1296      * Counterpart to Solidity's `/` operator. Note: this function uses a
1297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1298      * uses an invalid opcode to revert (consuming all remaining gas).
1299      *
1300      * Requirements:
1301      *
1302      * - The divisor cannot be zero.
1303      */
1304     function div(
1305         uint256 a,
1306         uint256 b,
1307         string memory errorMessage
1308     ) internal pure returns (uint256) {
1309         unchecked {
1310             require(b > 0, errorMessage);
1311             return a / b;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1317      * reverting with custom message when dividing by zero.
1318      *
1319      * CAUTION: This function is deprecated because it requires allocating memory for the error
1320      * message unnecessarily. For custom revert reasons use {tryMod}.
1321      *
1322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1323      * opcode (which leaves remaining gas untouched) while Solidity uses an
1324      * invalid opcode to revert (consuming all remaining gas).
1325      *
1326      * Requirements:
1327      *
1328      * - The divisor cannot be zero.
1329      */
1330     function mod(
1331         uint256 a,
1332         uint256 b,
1333         string memory errorMessage
1334     ) internal pure returns (uint256) {
1335         unchecked {
1336             require(b > 0, errorMessage);
1337             return a % b;
1338         }
1339     }
1340 }
1341 
1342 
1343 // File contracts/ERC721/ERC165.sol
1344 
1345 
1346 
1347 pragma solidity ^0.8.4;
1348 
1349 abstract contract ERC165 is IERC165 {
1350     /*
1351      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1352      */
1353     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1354 
1355     /**
1356      * @dev Mapping of interface ids to whether or not it's supported.
1357      */
1358     mapping(bytes4 => bool) private _supportedInterfaces;
1359 
1360     constructor() {
1361         // Derived contracts need only register support for their own interfaces,
1362         // we register support for ERC165 itself here
1363         _registerInterface(_INTERFACE_ID_ERC165);
1364     }
1365 
1366     /**
1367      * @dev See {IERC165-supportsInterface}.
1368      *
1369      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1370      */
1371     function supportsInterface(bytes4 interfaceId)
1372         public
1373         view
1374         virtual
1375         override
1376         returns (bool)
1377     {
1378         return _supportedInterfaces[interfaceId];
1379     }
1380 
1381     /**
1382      * @dev Registers the contract as an implementer of the interface defined by
1383      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1384      * registering its interface id is not required.
1385      *
1386      * See {IERC165-supportsInterface}.
1387      *
1388      * Requirements:
1389      *
1390      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1391      */
1392     function _registerInterface(bytes4 interfaceId) internal virtual {
1393         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1394         _supportedInterfaces[interfaceId] = true;
1395     }
1396 }
1397 
1398 
1399 // File contracts/ERC721/ERC721.sol
1400 
1401 // contracts/Aworld.sol
1402 
1403 
1404 pragma solidity ^0.8.4;
1405 
1406 
1407 
1408 
1409 
1410 
1411 
1412 
1413 
1414 
1415 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1416     using SafeMath for uint256;
1417     using Address for address;
1418     using EnumerableSet for EnumerableSet.UintSet;
1419     using EnumerableMap for EnumerableMap.UintToAddressMap;
1420     using Strings for uint256;
1421 
1422     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1423     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1424     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1425 
1426     // Mapping from holder address to their (enumerable) set of owned tokens
1427     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1428 
1429     // Enumerable mapping from token ids to their owners
1430     EnumerableMap.UintToAddressMap private _tokenOwners;
1431 
1432     // Mapping from token ID to approved address
1433     mapping(uint256 => address) private _tokenApprovals;
1434 
1435     // Mapping from owner to operator approvals
1436     mapping(address => mapping(address => bool)) private _operatorApprovals;
1437 
1438     // Token name
1439     string private _name;
1440 
1441     // Token symbol
1442     string private _symbol;
1443 
1444     // Optional mapping for token URIs
1445     mapping(uint256 => string) private _tokenURIs;
1446 
1447     // Base URI
1448     string private _baseURI;
1449 
1450     /*
1451      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1452      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1453      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1454      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1455      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1456      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1457      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1458      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1459      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1460      *
1461      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1462      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1463      */
1464     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1465 
1466     /*
1467      *     bytes4(keccak256('name()')) == 0x06fdde03
1468      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1469      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1470      *
1471      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1472      */
1473     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1474 
1475     /*
1476      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1477      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1478      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1479      *
1480      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1481      */
1482     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1483 
1484     /**
1485      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1486      */
1487     // todo
1488     constructor(string memory name_, string memory symbol_) {
1489         _name = name_;
1490         _symbol = symbol_;
1491 
1492         // register the supported interfaces to conform to ERC721 via ERC165
1493         _registerInterface(_INTERFACE_ID_ERC721);
1494         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1495         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-balanceOf}.
1500      */
1501     function balanceOf(address owner) public view virtual override returns (uint256) {
1502         require(owner != address(0), 'ERC721: balance query for the zero address');
1503         return _holderTokens[owner].length();
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-ownerOf}.
1508      */
1509     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1510         return _tokenOwners.get(tokenId, 'ERC721: owner query for nonexistent token');
1511     }
1512 
1513     /**
1514      * @dev See {IERC721Metadata-name}.
1515      */
1516     function name() public view virtual override returns (string memory) {
1517         return _name;
1518     }
1519 
1520     /**
1521      * @dev See {IERC721Metadata-symbol}.
1522      */
1523     function symbol() public view virtual override returns (string memory) {
1524         return _symbol;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Metadata-tokenURI}.
1529      */
1530     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1531         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1532 
1533         string memory _tokenURI = _tokenURIs[tokenId];
1534         string memory base = baseURI();
1535 
1536         // If there is no base URI, return the token URI.
1537         if (bytes(base).length == 0) {
1538             return _tokenURI;
1539         }
1540         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1541         if (bytes(_tokenURI).length > 0) {
1542             return string(abi.encodePacked(base, _tokenURI));
1543         }
1544         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1545         return string(abi.encodePacked(base, tokenId.toString()));
1546     }
1547 
1548     /**
1549      * @dev Returns the base URI set via {_setBaseURI}. This will be
1550      * automatically added as a prefix in {tokenURI} to each token's URI, or
1551      * to the token ID if no specific URI is set for that token ID.
1552      */
1553     function baseURI() public view virtual returns (string memory) {
1554         return _baseURI;
1555     }
1556 
1557     /**
1558      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1559      */
1560     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1561         return _holderTokens[owner].at(index);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721Enumerable-totalSupply}.
1566      */
1567     function totalSupply() public view virtual override returns (uint256) {
1568         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1569         return _tokenOwners.length();
1570     }
1571 
1572     /**
1573      * @dev See {IERC721Enumerable-tokenByIndex}.
1574      */
1575     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1576         (uint256 tokenId, ) = _tokenOwners.at(index);
1577         return tokenId;
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-approve}.
1582      */
1583     function approve(address to, uint256 tokenId) public virtual override {
1584         address owner = ERC721.ownerOf(tokenId);
1585         require(to != owner, 'ERC721: approval to current owner');
1586 
1587         require(
1588             _msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1589             'ERC721: approve caller is not owner nor approved for all'
1590         );
1591 
1592         _approve(to, tokenId);
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-getApproved}.
1597      */
1598     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1599         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
1600 
1601         return _tokenApprovals[tokenId];
1602     }
1603 
1604     /**
1605      * @dev See {IERC721-setApprovalForAll}.
1606      */
1607     function setApprovalForAll(address operator, bool approved) public virtual override {
1608         require(operator != _msgSender(), 'ERC721: approve to caller');
1609 
1610         _operatorApprovals[_msgSender()][operator] = approved;
1611         emit ApprovalForAll(_msgSender(), operator, approved);
1612     }
1613 
1614     /**
1615      * @dev See {IERC721-isApprovedForAll}.
1616      */
1617     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1618         return _operatorApprovals[owner][operator];
1619     }
1620 
1621     /**
1622      * @dev See {IERC721-transferFrom}.
1623      */
1624     function transferFrom(
1625         address from,
1626         address to,
1627         uint256 tokenId
1628     ) public virtual override {
1629         //solhint-disable-next-line max-line-length
1630         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
1631 
1632         _transfer(from, to, tokenId);
1633     }
1634 
1635     /**
1636      * @dev See {IERC721-safeTransferFrom}.
1637      */
1638     function safeTransferFrom(
1639         address from,
1640         address to,
1641         uint256 tokenId
1642     ) public virtual override {
1643         safeTransferFrom(from, to, tokenId, '');
1644     }
1645 
1646     /**
1647      * @dev See {IERC721-safeTransferFrom}.
1648      */
1649     function safeTransferFrom(
1650         address from,
1651         address to,
1652         uint256 tokenId,
1653         bytes memory _data
1654     ) public virtual override {
1655         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
1656         _safeTransfer(from, to, tokenId, _data);
1657     }
1658 
1659     /**
1660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1662      *
1663      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1664      *
1665      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1666      * implement alternative mechanisms to perform token transfer, such as signature-based.
1667      *
1668      * Requirements:
1669      *
1670      * - `from` cannot be the zero address.
1671      * - `to` cannot be the zero address.
1672      * - `tokenId` token must exist and be owned by `from`.
1673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _safeTransfer(
1678         address from,
1679         address to,
1680         uint256 tokenId,
1681         bytes memory _data
1682     ) internal virtual {
1683         _transfer(from, to, tokenId);
1684         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
1685     }
1686 
1687     /**
1688      * @dev Returns whether `tokenId` exists.
1689      *
1690      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1691      *
1692      * Tokens start existing when they are minted (`_mint`),
1693      * and stop existing when they are burned (`_burn`).
1694      */
1695     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1696         return _tokenOwners.contains(tokenId);
1697     }
1698 
1699     /**
1700      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1701      *
1702      * Requirements:
1703      *
1704      * - `tokenId` must exist.
1705      */
1706     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1707         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
1708         address owner = ERC721.ownerOf(tokenId);
1709         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1710     }
1711 
1712     /**
1713      * @dev Safely mints `tokenId` and transfers it to `to`.
1714      *
1715      * Requirements:
1716      d*
1717      * - `tokenId` must not exist.
1718      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1719      *
1720      * Emits a {Transfer} event.
1721      */
1722     function _safeMint(address to, uint256 tokenId) internal virtual {
1723         _safeMint(to, tokenId, '');
1724     }
1725 
1726     /**
1727      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1728      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1729      */
1730     function _safeMint(
1731         address to,
1732         uint256 tokenId,
1733         bytes memory _data
1734     ) internal virtual {
1735         _mint(to, tokenId);
1736         require(
1737             _checkOnERC721Received(address(0), to, tokenId, _data),
1738             'ERC721: transfer to non ERC721Receiver implementer'
1739         );
1740     }
1741 
1742     /**
1743      * @dev Mints `tokenId` and transfers it to `to`.
1744      *
1745      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1746      *
1747      * Requirements:
1748      *
1749      * - `tokenId` must not exist.
1750      * - `to` cannot be the zero address.
1751      *
1752      * Emits a {Transfer} event.
1753      */
1754     function _mint(address to, uint256 tokenId) internal virtual {
1755         require(to != address(0), 'ERC721: mint to the zero address');
1756         require(!_exists(tokenId), 'ERC721: token already minted');
1757 
1758         _beforeTokenTransfer(address(0), to, tokenId);
1759 
1760         _holderTokens[to].add(tokenId);
1761 
1762         _tokenOwners.set(tokenId, to);
1763 
1764         emit Transfer(address(0), to, tokenId);
1765     }
1766 
1767     /**
1768      * @dev Destroys `tokenId`.
1769      * The approval is cleared when the token is burned.
1770      *
1771      * Requirements:
1772      *
1773      * - `tokenId` must exist.
1774      *
1775      * Emits a {Transfer} event.
1776      */
1777     function _burn(uint256 tokenId) internal virtual {
1778         address owner = ERC721.ownerOf(tokenId); // internal owner
1779 
1780         _beforeTokenTransfer(owner, address(0), tokenId);
1781 
1782         // Clear approvals
1783         _approve(address(0), tokenId);
1784 
1785         // Clear metadata (if any)
1786         if (bytes(_tokenURIs[tokenId]).length != 0) {
1787             delete _tokenURIs[tokenId];
1788         }
1789 
1790         _holderTokens[owner].remove(tokenId);
1791 
1792         _tokenOwners.remove(tokenId);
1793 
1794         emit Transfer(owner, address(0), tokenId);
1795     }
1796 
1797     /**
1798      * @dev Transfers `tokenId` from `from` to `to`.
1799      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1800      *
1801      * Requirements:
1802      *
1803      * - `to` cannot be the zero address.
1804      * - `tokenId` token must be owned by `from`.
1805      *
1806      * Emits a {Transfer} event.
1807      */
1808     function _transfer(
1809         address from,
1810         address to,
1811         uint256 tokenId
1812     ) internal virtual {
1813         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own'); // internal owner
1814         require(to != address(0), 'ERC721: transfer to the zero address');
1815 
1816         _beforeTokenTransfer(from, to, tokenId);
1817 
1818         // Clear approvals from the previous owner
1819         _approve(address(0), tokenId);
1820 
1821         _holderTokens[from].remove(tokenId);
1822         _holderTokens[to].add(tokenId);
1823 
1824         _tokenOwners.set(tokenId, to);
1825 
1826         emit Transfer(from, to, tokenId);
1827     }
1828 
1829     /**
1830      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1831      *
1832      * Requirements:
1833      *
1834      * - `tokenId` must exist.
1835      */
1836     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1837         require(_exists(tokenId), 'ERC721Metadata: URI set of nonexistent token');
1838         _tokenURIs[tokenId] = _tokenURI;
1839     }
1840 
1841     /**
1842      * @dev Internal function to set the base URI for all token IDs. It is
1843      * automatically added as a prefix to the value returned in {tokenURI},
1844      * or to the token ID if {tokenURI} is empty.
1845      */
1846     function _setBaseURI(string memory baseURI_) internal virtual {
1847         _baseURI = baseURI_;
1848     }
1849 
1850     /**
1851      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1852      * The call is not executed if the target address is not a contract.
1853      *
1854      * @param from address representing the previous owner of the given token ID
1855      * @param to target address that will receive the tokens
1856      * @param tokenId uint256 ID of the token to be transferred
1857      * @param _data bytes optional data to send along with the call
1858      * @return bool whether the call correctly returned the expected magic value
1859      */
1860     function _checkOnERC721Received(
1861         address from,
1862         address to,
1863         uint256 tokenId,
1864         bytes memory _data
1865     ) private returns (bool) {
1866         if (!to.isContract()) {
1867             return true;
1868         }
1869         bytes memory returndata = to.functionCall(
1870             abi.encodeWithSelector(IERC721Receiver(to).onERC721Received.selector, _msgSender(), from, tokenId, _data),
1871             'ERC721: transfer to non ERC721Receiver implementer'
1872         );
1873         bytes4 retval = abi.decode(returndata, (bytes4));
1874         return (retval == _ERC721_RECEIVED);
1875     }
1876 
1877     /**
1878      * @dev Approve `to` to operate on `tokenId`
1879      *
1880      * Emits an {Approval} event.
1881      */
1882     function _approve(address to, uint256 tokenId) internal virtual {
1883         _tokenApprovals[tokenId] = to;
1884         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1885     }
1886 
1887     /**
1888      * @dev Hook that is called before any token transfer. This includes minting
1889      * and burning.
1890      *
1891      * Calling conditions:
1892      *
1893      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1894      * transferred to `to`.
1895      * - When `from` is zero, `tokenId` will be minted for `to`.
1896      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1897      * - `from` cannot be the zero address.
1898      * - `to` cannot be the zero address.
1899      *
1900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1901      */
1902     function _beforeTokenTransfer(
1903         address from,
1904         address to,
1905         uint256 tokenId
1906     ) internal virtual {}
1907 
1908     function balanceOfCryptid(address _owner) public view returns (uint256) {
1909         uint256 genesisNumber = 0;
1910         for (uint256 i = 1; i <= 50; i++) {
1911             if (_holderTokens[_owner].contains(i)) {
1912                 genesisNumber += 1;
1913             }
1914         }
1915         return balanceOf(_owner) - genesisNumber;
1916     }
1917 }
1918 
1919 
1920 // File contracts/AworldBase.sol
1921 
1922 // contracts/AworldBase.sol
1923 
1924 
1925 pragma solidity ^0.8.4;
1926 
1927 contract AworldBase {
1928     /**
1929      * @dev Emitted when draw `tokenId` token to be redeem.
1930      */
1931     event Draw(uint256 indexed tokenId, address indexed owner, uint256 rn);
1932     event MintCryptid(uint256 indexed tokenId, address indexed owner, uint256 rn);
1933 
1934     using EnumerableSet for EnumerableSet.UintSet;
1935     EnumerableSet.UintSet internal _toBeRevealedCryptidAnimals;
1936 
1937     uint256 private nonce;
1938 
1939     function getToBeRevealedCryptidNumber() public view returns (uint256) {
1940         return _toBeRevealedCryptidAnimals.length();
1941     }
1942 
1943     // generete randan number for animal creation
1944     function _getRandNumber() internal returns (uint256) {
1945         nonce++;
1946         return uint256(keccak256(abi.encodePacked(block.difficulty, block.number, block.timestamp, nonce)));
1947     }
1948 
1949     function _getRNwithTokenId(uint256 tokenId) internal view returns (uint256) {
1950         return uint256(keccak256(abi.encodePacked(block.difficulty, block.number, block.timestamp, tokenId)));
1951     }
1952 }
1953 
1954 
1955 // File @openzeppelin/contracts/utils/Counters.sol@v4.2.0
1956 
1957 
1958 
1959 pragma solidity ^0.8.0;
1960 
1961 /**
1962  * @title Counters
1963  * @author Matt Condon (@shrugs)
1964  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1965  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1966  *
1967  * Include with `using Counters for Counters.Counter;`
1968  */
1969 library Counters {
1970     struct Counter {
1971         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1972         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1973         // this feature: see https://github.com/ethereum/solidity/issues/4637
1974         uint256 _value; // default: 0
1975     }
1976 
1977     function current(Counter storage counter) internal view returns (uint256) {
1978         return counter._value;
1979     }
1980 
1981     function increment(Counter storage counter) internal {
1982         unchecked {
1983             counter._value += 1;
1984         }
1985     }
1986 
1987     function decrement(Counter storage counter) internal {
1988         uint256 value = counter._value;
1989         require(value > 0, "Counter: decrement overflow");
1990         unchecked {
1991             counter._value = value - 1;
1992         }
1993     }
1994 
1995     function reset(Counter storage counter) internal {
1996         counter._value = 0;
1997     }
1998 }
1999 
2000 
2001 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
2002 
2003 
2004 
2005 pragma solidity ^0.8.0;
2006 
2007 /**
2008  * @dev Contract module which provides a basic access control mechanism, where
2009  * there is an account (an owner) that can be granted exclusive access to
2010  * specific functions.
2011  *
2012  * By default, the owner account will be the one that deploys the contract. This
2013  * can later be changed with {transferOwnership}.
2014  *
2015  * This module is used through inheritance. It will make available the modifier
2016  * `onlyOwner`, which can be applied to your functions to restrict their use to
2017  * the owner.
2018  */
2019 abstract contract Ownable is Context {
2020     address private _owner;
2021 
2022     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2023 
2024     /**
2025      * @dev Initializes the contract setting the deployer as the initial owner.
2026      */
2027     constructor() {
2028         _setOwner(_msgSender());
2029     }
2030 
2031     /**
2032      * @dev Returns the address of the current owner.
2033      */
2034     function owner() public view virtual returns (address) {
2035         return _owner;
2036     }
2037 
2038     /**
2039      * @dev Throws if called by any account other than the owner.
2040      */
2041     modifier onlyOwner() {
2042         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2043         _;
2044     }
2045 
2046     /**
2047      * @dev Leaves the contract without owner. It will not be possible to call
2048      * `onlyOwner` functions anymore. Can only be called by the current owner.
2049      *
2050      * NOTE: Renouncing ownership will leave the contract without an owner,
2051      * thereby removing any functionality that is only available to the owner.
2052      */
2053     function renounceOwnership() public virtual onlyOwner {
2054         _setOwner(address(0));
2055     }
2056 
2057     /**
2058      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2059      * Can only be called by the current owner.
2060      */
2061     function transferOwnership(address newOwner) public virtual onlyOwner {
2062         require(newOwner != address(0), "Ownable: new owner is the zero address");
2063         _setOwner(newOwner);
2064     }
2065 
2066     function _setOwner(address newOwner) private {
2067         address oldOwner = _owner;
2068         _owner = newOwner;
2069         emit OwnershipTransferred(oldOwner, newOwner);
2070     }
2071 }
2072 
2073 
2074 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.2.0
2075 
2076 
2077 
2078 pragma solidity ^0.8.0;
2079 
2080 /**
2081  * @dev Contract module that helps prevent reentrant calls to a function.
2082  *
2083  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2084  * available, which can be applied to functions to make sure there are no nested
2085  * (reentrant) calls to them.
2086  *
2087  * Note that because there is a single `nonReentrant` guard, functions marked as
2088  * `nonReentrant` may not call one another. This can be worked around by making
2089  * those functions `private`, and then adding `external` `nonReentrant` entry
2090  * points to them.
2091  *
2092  * TIP: If you would like to learn more about reentrancy and alternative ways
2093  * to protect against it, check out our blog post
2094  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2095  */
2096 abstract contract ReentrancyGuard {
2097     // Booleans are more expensive than uint256 or any type that takes up a full
2098     // word because each write operation emits an extra SLOAD to first read the
2099     // slot's contents, replace the bits taken up by the boolean, and then write
2100     // back. This is the compiler's defense against contract upgrades and
2101     // pointer aliasing, and it cannot be disabled.
2102 
2103     // The values being non-zero value makes deployment a bit more expensive,
2104     // but in exchange the refund on every call to nonReentrant will be lower in
2105     // amount. Since refunds are capped to a percentage of the total
2106     // transaction's gas, it is best to keep them low in cases like this one, to
2107     // increase the likelihood of the full refund coming into effect.
2108     uint256 private constant _NOT_ENTERED = 1;
2109     uint256 private constant _ENTERED = 2;
2110 
2111     uint256 private _status;
2112 
2113     constructor() {
2114         _status = _NOT_ENTERED;
2115     }
2116 
2117     /**
2118      * @dev Prevents a contract from calling itself, directly or indirectly.
2119      * Calling a `nonReentrant` function from another `nonReentrant`
2120      * function is not supported. It is possible to prevent this from happening
2121      * by making the `nonReentrant` function external, and make it call a
2122      * `private` function that does the actual work.
2123      */
2124     modifier nonReentrant() {
2125         // On the first call to nonReentrant, _notEntered will be true
2126         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2127 
2128         // Any calls to nonReentrant after this point will fail
2129         _status = _ENTERED;
2130 
2131         _;
2132 
2133         // By storing the original value once again, a refund is triggered (see
2134         // https://eips.ethereum.org/EIPS/eip-2200)
2135         _status = _NOT_ENTERED;
2136     }
2137 }
2138 
2139 
2140 // File contracts/AWorld.sol
2141 
2142 // contracts/Aworld.sol
2143 
2144 
2145 pragma solidity ^0.8.4;
2146 
2147 
2148 
2149 
2150 
2151 contract Aworld is ERC721, Ownable, AworldBase, ReentrancyGuard {
2152     using Counters for Counters.Counter;
2153     using SafeMath for uint256;
2154     using EnumerableSet for EnumerableSet.UintSet;
2155 
2156     string public AW_PROVENANCE = '';
2157 
2158     uint256 public awGenesisPrice = 0.28 ether;
2159     uint256 public awCryptidPrice = 0.18 ether;
2160     uint256 public threeBundleCryptidPrice = 0.51 ether;
2161     uint256 public tenBundleCryptidPrice = 1.5 ether;
2162 
2163     uint256 public constant MAX_CRYPTID_PURCHASE = 10;
2164 
2165     uint256 public constant MAX_AWS = 10000;
2166     uint256 public constant MAX_GENESIS_SALE = 50;
2167     uint256 public constant MAX_CRYPTID_SALE = 9950;
2168 
2169     bool public saleIsActive = false;
2170 
2171     Counters.Counter public genesistokenIds;
2172     Counters.Counter public cryptidtokenIds;
2173 
2174     constructor() ERC721('AWorld Avatar NFT', 'AW') {
2175         for (uint256 i = 0; i < 50; i++) {
2176             cryptidtokenIds.increment();
2177         }
2178     }
2179 
2180     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
2181         uint256 tokenCount = balanceOf(_owner);
2182         if (tokenCount == 0) {
2183             // Return an empty array
2184             return new uint256[](0);
2185         } else {
2186             uint256[] memory result = new uint256[](tokenCount);
2187             uint256 index;
2188             for (index = 0; index < tokenCount; index++) {
2189                 result[index] = tokenOfOwnerByIndex(_owner, index);
2190             }
2191             return result;
2192         }
2193     }
2194 
2195     // withdraw eth from contract
2196     function withdraw() public onlyOwner {
2197         uint256 balance = address(this).balance;
2198         payable(msg.sender).transfer(balance);
2199     }
2200 
2201     // return discounted price of blind aworld nft
2202     function _getBundleCryptidPrice(uint256 mintNumber) internal view returns (uint256) {
2203         uint256 bundlePrice = mintNumber * awCryptidPrice;
2204         if (mintNumber == 3) {
2205             return threeBundleCryptidPrice;
2206         } else if (mintNumber == 10) {
2207             return tenBundleCryptidPrice;
2208         } else {
2209             return bundlePrice;
2210         }
2211     }
2212 
2213     function changePrice(uint256 newPrice, uint8 priceType) public onlyOwner {
2214         require(priceType >= 0 && 3 >= priceType, 'The price type is not supported');
2215         if (priceType == 0) {
2216             awGenesisPrice = newPrice;
2217         } else if (priceType == 1) {
2218             awCryptidPrice = newPrice;
2219         } else if (priceType == 2) {
2220             threeBundleCryptidPrice = newPrice;
2221         } else {
2222             tenBundleCryptidPrice = newPrice;
2223         }
2224     }
2225 
2226     // mint genesis aworld animals
2227     function mintGenesisAW() public payable nonReentrant {
2228         require(saleIsActive, 'Sale must be active to mint Aworld');
2229         require(
2230             genesistokenIds.current() < MAX_GENESIS_SALE,
2231             'Purchase would exceed max supply of Aworld genesis animals'
2232         );
2233         require(awGenesisPrice <= msg.value, 'Ether value sent is not correct');
2234         genesistokenIds.increment();
2235         uint256 tokenId = genesistokenIds.current();
2236         _safeMint(msg.sender, tokenId);
2237         // _genesisAnimals.add(tokenId);
2238     }
2239 
2240     // mint cryptids
2241     function mintCryptidAW(uint256 numberOfTokens) public payable nonReentrant {
2242         require(saleIsActive, 'Sale must be active to mint Aworld');
2243         require(numberOfTokens <= MAX_CRYPTID_PURCHASE, 'Mint too much Aworld animals at a time');
2244         require(
2245             cryptidtokenIds.current() + numberOfTokens <= MAX_AWS,
2246             'Purchase would exceed max supply of Aworld cryptids'
2247         );
2248         require(_getBundleCryptidPrice(numberOfTokens) <= msg.value, 'Ether value sent is not correct');
2249         for (uint256 i = 0; i < numberOfTokens; i++) {
2250             cryptidtokenIds.increment();
2251             uint256 tokenId = cryptidtokenIds.current();
2252             _safeMint(msg.sender, tokenId);
2253             _toBeRevealedCryptidAnimals.add(tokenId);
2254             emit MintCryptid(tokenId, msg.sender, _getRNwithTokenId(tokenId));
2255         }
2256     }
2257 
2258     // draw random cryptids to reveal
2259     function drawAnimals(uint256 drawNumbers) public onlyOwner {
2260         require(drawNumbers <= getToBeRevealedCryptidNumber(), 'Not enough cryptid should be revealed');
2261         for (uint256 i = 0; i < drawNumbers; i++) {
2262             uint256 rn = _getRandNumber();
2263             uint256 drawId = rn.mod(getToBeRevealedCryptidNumber());
2264             uint256 tokenId = _toBeRevealedCryptidAnimals.at(drawId);
2265             _toBeRevealedCryptidAnimals.remove(tokenId);
2266             address owner = ownerOf(tokenId);
2267 
2268             emit Draw(tokenId, owner, _getRNwithTokenId(tokenId));
2269         }
2270     }
2271 
2272     // set provenance if all cryptids revealed
2273     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2274         AW_PROVENANCE = provenanceHash;
2275     }
2276 
2277     // set baseUri
2278     function setBaseURI(string memory baseURI) public onlyOwner {
2279         _setBaseURI(baseURI);
2280     }
2281 
2282     /*
2283      * Pause sale if active, make active if paused
2284      */
2285     function flipSaleState() public onlyOwner {
2286         saleIsActive = !saleIsActive;
2287     }
2288 
2289     // airdrop genesis aworld animals if needed
2290     function airdropGenesis(address receiver, uint256 amount) external onlyOwner {
2291         require(
2292             genesistokenIds.current().add(amount) <= MAX_GENESIS_SALE,
2293             'Airdrop amount will exceed max supply of Aworld genesis animals'
2294         );
2295         for (uint256 i = 0; i < amount; i++) {
2296             genesistokenIds.increment();
2297             uint256 tokenId = genesistokenIds.current();
2298             _safeMint(receiver, tokenId);
2299         }
2300     }
2301 
2302     // airdrop cryptids if needed
2303     function airdropCryptid(address receiver, uint256 amount) public onlyOwner {
2304         require(
2305             cryptidtokenIds.current().add(amount) <= MAX_AWS,
2306             'Airdrop amount will exceed max supply of Aworld cryptids'
2307         );
2308         for (uint256 i = 0; i < amount; i++) {
2309             cryptidtokenIds.increment();
2310             uint256 tokenId = cryptidtokenIds.current();
2311             _safeMint(receiver, tokenId);
2312             _toBeRevealedCryptidAnimals.add(tokenId);
2313             emit MintCryptid(tokenId, receiver, _getRNwithTokenId(tokenId));
2314         }
2315     }
2316 
2317     // batch airdrop cryptids if needed
2318     function airdropBatchCryptid(address[] memory receivers, uint256 amount) external onlyOwner {
2319         require(
2320             cryptidtokenIds.current().add(amount.mul(receivers.length)) <= MAX_AWS,
2321             'Airdrop amount will exceed max supply of Aworld cryptids'
2322         );
2323         for (uint256 i = 0; i < receivers.length; i++) {
2324             airdropCryptid(receivers[i], amount);
2325         }
2326     }
2327 }