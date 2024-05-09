1 pragma solidity 0.6.6;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8 
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 interface IERC721 is IERC165 {
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
34     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
35 
36     /**
37      * @dev Returns the number of NFTs in ``owner``'s account.
38      */
39     function balanceOf(address owner) external view returns (uint256 balance);
40 
41     /**
42      * @dev Returns the owner of the NFT specified by `tokenId`.
43      */
44     function ownerOf(uint256 tokenId) external view returns (address owner);
45 
46     /**
47      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
48      * another (`to`).
49      *
50      *
51      *
52      * Requirements:
53      * - `from`, `to` cannot be zero.
54      * - `tokenId` must be owned by `from`.
55      * - If the caller is not `from`, it must be have been allowed to move this
56      * NFT by either {approve} or {setApprovalForAll}.
57      */
58     function safeTransferFrom(address from, address to, uint256 tokenId) external;
59     /**
60      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
61      * another (`to`).
62      *
63      * Requirements:
64      * - If the caller is not `from`, it must be approved to move this NFT by
65      * either {approve} or {setApprovalForAll}.
66      */
67     function transferFrom(address from, address to, uint256 tokenId) external;
68     function approve(address to, uint256 tokenId) external;
69     function getApproved(uint256 tokenId) external view returns (address operator);
70 
71     function setApprovalForAll(address operator, bool _approved) external;
72     function isApprovedForAll(address owner, address operator) external view returns (bool);
73 
74 
75     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
76 }
77 
78 interface IERC721Metadata is IERC721 {
79     function name() external view returns (string memory);
80     function symbol() external view returns (string memory);
81     function tokenURI(uint256 tokenId) external view returns (string memory);
82 }
83 
84 interface IERC721Enumerable is IERC721 {
85     function totalSupply() external view returns (uint256);
86     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
87 
88     function tokenByIndex(uint256 index) external view returns (uint256);
89 }
90 
91 contract ERC165 is IERC165 {
92     /*
93      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
94      */
95     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
96 
97     /**
98      * @dev Mapping of interface ids to whether or not it's supported.
99      */
100     mapping(bytes4 => bool) private _supportedInterfaces;
101 
102     constructor () internal {
103         // Derived contracts need only register support for their own interfaces,
104         // we register support for ERC165 itself here
105         _registerInterface(_INTERFACE_ID_ERC165);
106     }
107 
108     /**
109      * @dev See {IERC165-supportsInterface}.
110      *
111      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
114         return _supportedInterfaces[interfaceId];
115     }
116 
117     /**
118      * @dev Registers the contract as an implementer of the interface defined by
119      * `interfaceId`. Support of the actual ERC165 interface is automatic and
120      * registering its interface id is not required.
121      *
122      * See {IERC165-supportsInterface}.
123      *
124      * Requirements:
125      *
126      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
127      */
128     function _registerInterface(bytes4 interfaceId) internal virtual {
129         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
130         _supportedInterfaces[interfaceId] = true;
131     }
132 }
133 
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      * - Addition cannot overflow.
143      */
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         // Solidity only automatically asserts when dividing by 0
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 library EnumerableSet {
271     // To implement this library for multiple types with as little code
272     // repetition as possible, we write it in terms of a generic Set type with
273     // bytes32 values.
274     // The Set implementation uses private functions, and user-facing
275     // implementations (such as AddressSet) are just wrappers around the
276     // underlying Set.
277     // This means that we can only create new EnumerableSets for types that fit
278     // in bytes32.
279 
280     struct Set {
281         // Storage of set values
282         bytes32[] _values;
283 
284         // Position of the value in the `values` array, plus 1 because index 0
285         // means a value is not in the set.
286         mapping (bytes32 => uint256) _indexes;
287     }
288 
289     /**
290      * @dev Add a value to a set. O(1).
291      *
292      * Returns true if the value was added to the set, that is if it was not
293      * already present.
294      */
295     function _add(Set storage set, bytes32 value) private returns (bool) {
296         if (!_contains(set, value)) {
297             set._values.push(value);
298             // The value is stored at length-1, but we add 1 to all indexes
299             // and use 0 as a sentinel value
300             set._indexes[value] = set._values.length;
301             return true;
302         } else {
303             return false;
304         }
305     }
306 
307     /**
308      * @dev Removes a value from a set. O(1).
309      *
310      * Returns true if the value was removed from the set, that is if it was
311      * present.
312      */
313     function _remove(Set storage set, bytes32 value) private returns (bool) {
314         // We read and store the value's index to prevent multiple reads from the same storage slot
315         uint256 valueIndex = set._indexes[value];
316 
317         if (valueIndex != 0) { // Equivalent to contains(set, value)
318             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
319             // the array, and then remove the last element (sometimes called as 'swap and pop').
320             // This modifies the order of the array, as noted in {at}.
321 
322             uint256 toDeleteIndex = valueIndex - 1;
323             uint256 lastIndex = set._values.length - 1;
324 
325             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
326             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
327 
328             bytes32 lastvalue = set._values[lastIndex];
329 
330             // Move the last value to the index where the value to delete is
331             set._values[toDeleteIndex] = lastvalue;
332             // Update the index for the moved value
333             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
334 
335             // Delete the slot where the moved value was stored
336             set._values.pop();
337 
338             // Delete the index for the deleted slot
339             delete set._indexes[value];
340 
341             return true;
342         } else {
343             return false;
344         }
345     }
346 
347     /**
348      * @dev Returns true if the value is in the set. O(1).
349      */
350     function _contains(Set storage set, bytes32 value) private view returns (bool) {
351         return set._indexes[value] != 0;
352     }
353 
354     /**
355      * @dev Returns the number of values on the set. O(1).
356      */
357     function _length(Set storage set) private view returns (uint256) {
358         return set._values.length;
359     }
360 
361    /**
362     * @dev Returns the value stored at position `index` in the set. O(1).
363     *
364     * Note that there are no guarantees on the ordering of values inside the
365     * array, and it may change when more values are added or removed.
366     *
367     * Requirements:
368     *
369     * - `index` must be strictly less than {length}.
370     */
371     function _at(Set storage set, uint256 index) private view returns (bytes32) {
372         require(set._values.length > index, "EnumerableSet: index out of bounds");
373         return set._values[index];
374     }
375 
376     // AddressSet
377 
378     struct AddressSet {
379         Set _inner;
380     }
381 
382     /**
383      * @dev Add a value to a set. O(1).
384      *
385      * Returns true if the value was added to the set, that is if it was not
386      * already present.
387      */
388     function add(AddressSet storage set, address value) internal returns (bool) {
389         return _add(set._inner, bytes32(uint256(value)));
390     }
391 
392     /**
393      * @dev Removes a value from a set. O(1).
394      *
395      * Returns true if the value was removed from the set, that is if it was
396      * present.
397      */
398     function remove(AddressSet storage set, address value) internal returns (bool) {
399         return _remove(set._inner, bytes32(uint256(value)));
400     }
401 
402     /**
403      * @dev Returns true if the value is in the set. O(1).
404      */
405     function contains(AddressSet storage set, address value) internal view returns (bool) {
406         return _contains(set._inner, bytes32(uint256(value)));
407     }
408 
409     /**
410      * @dev Returns the number of values in the set. O(1).
411      */
412     function length(AddressSet storage set) internal view returns (uint256) {
413         return _length(set._inner);
414     }
415 
416    /**
417     * @dev Returns the value stored at position `index` in the set. O(1).
418     *
419     * Note that there are no guarantees on the ordering of values inside the
420     * array, and it may change when more values are added or removed.
421     *
422     * Requirements:
423     *
424     * - `index` must be strictly less than {length}.
425     */
426     function at(AddressSet storage set, uint256 index) internal view returns (address) {
427         return address(uint256(_at(set._inner, index)));
428     }
429 
430 
431     // UintSet
432 
433     struct UintSet {
434         Set _inner;
435     }
436 
437     /**
438      * @dev Add a value to a set. O(1).
439      *
440      * Returns true if the value was added to the set, that is if it was not
441      * already present.
442      */
443     function add(UintSet storage set, uint256 value) internal returns (bool) {
444         return _add(set._inner, bytes32(value));
445     }
446 
447     /**
448      * @dev Removes a value from a set. O(1).
449      *
450      * Returns true if the value was removed from the set, that is if it was
451      * present.
452      */
453     function remove(UintSet storage set, uint256 value) internal returns (bool) {
454         return _remove(set._inner, bytes32(value));
455     }
456 
457     /**
458      * @dev Returns true if the value is in the set. O(1).
459      */
460     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
461         return _contains(set._inner, bytes32(value));
462     }
463 
464     /**
465      * @dev Returns the number of values on the set. O(1).
466      */
467     function length(UintSet storage set) internal view returns (uint256) {
468         return _length(set._inner);
469     }
470 
471    /**
472     * @dev Returns the value stored at position `index` in the set. O(1).
473     *
474     * Note that there are no guarantees on the ordering of values inside the
475     * array, and it may change when more values are added or removed.
476     *
477     * Requirements:
478     *
479     * - `index` must be strictly less than {length}.
480     */
481     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
482         return uint256(_at(set._inner, index));
483     }
484 }
485 
486 library EnumerableMap {
487     // To implement this library for multiple types with as little code
488     // repetition as possible, we write it in terms of a generic Map type with
489     // bytes32 keys and values.
490     // The Map implementation uses private functions, and user-facing
491     // implementations (such as Uint256ToAddressMap) are just wrappers around
492     // the underlying Map.
493     // This means that we can only create new EnumerableMaps for types that fit
494     // in bytes32.
495 
496     struct MapEntry {
497         bytes32 _key;
498         bytes32 _value;
499     }
500 
501     struct Map {
502         // Storage of map keys and values
503         MapEntry[] _entries;
504 
505         // Position of the entry defined by a key in the `entries` array, plus 1
506         // because index 0 means a key is not in the map.
507         mapping (bytes32 => uint256) _indexes;
508     }
509 
510     /**
511      * @dev Adds a key-value pair to a map, or updates the value for an existing
512      * key. O(1).
513      *
514      * Returns true if the key was added to the map, that is if it was not
515      * already present.
516      */
517     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
518         // We read and store the key's index to prevent multiple reads from the same storage slot
519         uint256 keyIndex = map._indexes[key];
520 
521         if (keyIndex == 0) { // Equivalent to !contains(map, key)
522             map._entries.push(MapEntry({ _key: key, _value: value }));
523             // The entry is stored at length-1, but we add 1 to all indexes
524             // and use 0 as a sentinel value
525             map._indexes[key] = map._entries.length;
526             return true;
527         } else {
528             map._entries[keyIndex - 1]._value = value;
529             return false;
530         }
531     }
532 
533     /**
534      * @dev Removes a key-value pair from a map. O(1).
535      *
536      * Returns true if the key was removed from the map, that is if it was present.
537      */
538     function _remove(Map storage map, bytes32 key) private returns (bool) {
539         // We read and store the key's index to prevent multiple reads from the same storage slot
540         uint256 keyIndex = map._indexes[key];
541 
542         if (keyIndex != 0) { // Equivalent to contains(map, key)
543             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
544             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
545             // This modifies the order of the array, as noted in {at}.
546 
547             uint256 toDeleteIndex = keyIndex - 1;
548             uint256 lastIndex = map._entries.length - 1;
549 
550             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
551             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
552 
553             MapEntry storage lastEntry = map._entries[lastIndex];
554 
555             // Move the last entry to the index where the entry to delete is
556             map._entries[toDeleteIndex] = lastEntry;
557             // Update the index for the moved entry
558             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
559 
560             // Delete the slot where the moved entry was stored
561             map._entries.pop();
562 
563             // Delete the index for the deleted slot
564             delete map._indexes[key];
565 
566             return true;
567         } else {
568             return false;
569         }
570     }
571 
572     /**
573      * @dev Returns true if the key is in the map. O(1).
574      */
575     function _contains(Map storage map, bytes32 key) private view returns (bool) {
576         return map._indexes[key] != 0;
577     }
578 
579     /**
580      * @dev Returns the number of key-value pairs in the map. O(1).
581      */
582     function _length(Map storage map) private view returns (uint256) {
583         return map._entries.length;
584     }
585 
586    /**
587     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
588     *
589     * Note that there are no guarantees on the ordering of entries inside the
590     * array, and it may change when more entries are added or removed.
591     *
592     * Requirements:
593     *
594     * - `index` must be strictly less than {length}.
595     */
596     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
597         require(map._entries.length > index, "EnumerableMap: index out of bounds");
598 
599         MapEntry storage entry = map._entries[index];
600         return (entry._key, entry._value);
601     }
602 
603     /**
604      * @dev Returns the value associated with `key`.  O(1).
605      *
606      * Requirements:
607      *
608      * - `key` must be in the map.
609      */
610     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
611         return _get(map, key, "EnumerableMap: nonexistent key");
612     }
613 
614     /**
615      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
616      */
617     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
618         uint256 keyIndex = map._indexes[key];
619         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
620         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
621     }
622 
623     // UintToAddressMap
624 
625     struct UintToAddressMap {
626         Map _inner;
627     }
628 
629     /**
630      * @dev Adds a key-value pair to a map, or updates the value for an existing
631      * key. O(1).
632      *
633      * Returns true if the key was added to the map, that is if it was not
634      * already present.
635      */
636     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
637         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
638     }
639 
640     /**
641      * @dev Removes a value from a set. O(1).
642      *
643      * Returns true if the key was removed from the map, that is if it was present.
644      */
645     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
646         return _remove(map._inner, bytes32(key));
647     }
648 
649     /**
650      * @dev Returns true if the key is in the map. O(1).
651      */
652     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
653         return _contains(map._inner, bytes32(key));
654     }
655 
656     /**
657      * @dev Returns the number of elements in the map. O(1).
658      */
659     function length(UintToAddressMap storage map) internal view returns (uint256) {
660         return _length(map._inner);
661     }
662 
663    /**
664     * @dev Returns the element stored at position `index` in the set. O(1).
665     * Note that there are no guarantees on the ordering of values inside the
666     * array, and it may change when more values are added or removed.
667     *
668     * Requirements:
669     *
670     * - `index` must be strictly less than {length}.
671     */
672     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
673         (bytes32 key, bytes32 value) = _at(map._inner, index);
674         return (uint256(key), address(uint256(value)));
675     }
676 
677     /**
678      * @dev Returns the value associated with `key`.  O(1).
679      *
680      * Requirements:
681      *
682      * - `key` must be in the map.
683      */
684     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
685         return address(uint256(_get(map._inner, bytes32(key))));
686     }
687 
688     /**
689      * @dev Same as {get}, with a custom error message when `key` is not in the map.
690      */
691     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
692         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
693     }
694 }
695 
696 library Strings {
697     /**
698      * @dev Converts a `uint256` to its ASCII `string` representation.
699      */
700     function toString(uint256 value) internal pure returns (string memory) {
701         // Inspired by OraclizeAPI's implementation - MIT licence
702         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
703 
704         if (value == 0) {
705             return "0";
706         }
707         uint256 temp = value;
708         uint256 digits;
709         while (temp != 0) {
710             digits++;
711             temp /= 10;
712         }
713         bytes memory buffer = new bytes(digits);
714         uint256 index = digits - 1;
715         temp = value;
716         while (temp != 0) {
717             buffer[index--] = byte(uint8(48 + temp % 10));
718             temp /= 10;
719         }
720         return string(buffer);
721     }
722 }
723 
724 /**
725  * @dev Collection of functions related to the address type
726  */
727 library Address {
728     /**
729      * @dev Returns true if `account` is a contract.
730      *
731      * [IMPORTANT]
732      * ====
733      * It is unsafe to assume that an address for which this function returns
734      * false is an externally-owned account (EOA) and not a contract.
735      *
736      * Among others, `isContract` will return false for the following
737      * types of addresses:
738      *
739      *  - an externally-owned account
740      *  - a contract in construction
741      *  - an address where a contract will be created
742      *  - an address where a contract lived, but was destroyed
743      * ====
744      */
745     function isContract(address account) internal view returns (bool) {
746         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
747         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
748         // for accounts without code, i.e. `keccak256('')`
749         bytes32 codehash;
750         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
751         // solhint-disable-next-line no-inline-assembly
752         assembly { codehash := extcodehash(account) }
753         return (codehash != accountHash && codehash != 0x0);
754     }
755 
756     /**
757      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
758      * `recipient`, forwarding all available gas and reverting on errors.
759      *
760      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
761      * of certain opcodes, possibly making contracts go over the 2300 gas limit
762      * imposed by `transfer`, making them unable to receive funds via
763      * `transfer`. {sendValue} removes this limitation.
764      *
765      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
766      *
767      * IMPORTANT: because control is transferred to `recipient`, care must be
768      * taken to not create reentrancy vulnerabilities. Consider using
769      * {ReentrancyGuard} or the
770      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
771      */
772     function sendValue(address payable recipient, uint256 amount) internal {
773         require(address(this).balance >= amount, "Address: insufficient balance");
774 
775         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
776         (bool success, ) = recipient.call{ value: amount }("");
777         require(success, "Address: unable to send value, recipient may have reverted");
778     }
779 }
780 
781 /**
782  * @dev Contract module that allows children to implement role-based access
783  * control mechanisms.
784  *
785  * Roles are referred to by their `bytes32` identifier. These should be exposed
786  * in the external API and be unique. The best way to achieve this is by
787  * using `public constant` hash digests:
788  *
789  * ```
790  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
791  * ```
792  *
793  * Roles can be used to represent a set of permissions. To restrict access to a
794  * function call, use {hasRole}:
795  *
796  * ```
797  * function foo() public {
798  *     require(hasRole(MY_ROLE, _msgSender()));
799  *     ...
800  * }
801  * ```
802  *
803  * Roles can be granted and revoked dynamically via the {grantRole} and
804  * {revokeRole} functions. Each role has an associated admin role, and only
805  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
806  *
807  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
808  * that only accounts with this role will be able to grant or revoke other
809  * roles. More complex role relationships can be created by using
810  * {_setRoleAdmin}.
811  */
812 abstract contract AccessControl is Context {
813     using EnumerableSet for EnumerableSet.AddressSet;
814     using Address for address;
815 
816     struct RoleData {
817         EnumerableSet.AddressSet members;
818         bytes32 adminRole;
819     }
820 
821     mapping (bytes32 => RoleData) private _roles;
822 
823     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
824 
825     /**
826      * @dev Emitted when `account` is granted `role`.
827      *
828      * `sender` is the account that originated the contract call, an admin role
829      * bearer except when using {_setupRole}.
830      */
831     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
832 
833     /**
834      * @dev Emitted when `account` is revoked `role`.
835      *
836      * `sender` is the account that originated the contract call:
837      *   - if using `revokeRole`, it is the admin role bearer
838      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
839      */
840     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
841 
842     /**
843      * @dev Returns `true` if `account` has been granted `role`.
844      */
845     function hasRole(bytes32 role, address account) public view returns (bool) {
846         return _roles[role].members.contains(account);
847     }
848 
849     /**
850      * @dev Returns the number of accounts that have `role`. Can be used
851      * together with {getRoleMember} to enumerate all bearers of a role.
852      */
853     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
854         return _roles[role].members.length();
855     }
856 
857     /**
858      * @dev Returns one of the accounts that have `role`. `index` must be a
859      * value between 0 and {getRoleMemberCount}, non-inclusive.
860      *
861      * Role bearers are not sorted in any particular way, and their ordering may
862      * change at any point.
863      *
864      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
865      * you perform all queries on the same block. See the following
866      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
867      * for more information.
868      */
869     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
870         return _roles[role].members.at(index);
871     }
872 
873     /**
874      * @dev Returns the admin role that controls `role`. See {grantRole} and
875      * {revokeRole}.
876      *
877      * To change a role's admin, use {_setRoleAdmin}.
878      */
879     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
880         return _roles[role].adminRole;
881     }
882 
883     /**
884      * @dev Grants `role` to `account`.
885      *
886      * If `account` had not been already granted `role`, emits a {RoleGranted}
887      * event.
888      *
889      * Requirements:
890      *
891      * - the caller must have ``role``'s admin role.
892      */
893     function grantRole(bytes32 role, address account) public virtual {
894         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
895 
896         _grantRole(role, account);
897     }
898 
899     /**
900      * @dev Revokes `role` from `account`.
901      *
902      * If `account` had been granted `role`, emits a {RoleRevoked} event.
903      *
904      * Requirements:
905      *
906      * - the caller must have ``role``'s admin role.
907      */
908     function revokeRole(bytes32 role, address account) public virtual {
909         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
910 
911         _revokeRole(role, account);
912     }
913 
914     /**
915      * @dev Revokes `role` from the calling account.
916      *
917      * Roles are often managed via {grantRole} and {revokeRole}: this function's
918      * purpose is to provide a mechanism for accounts to lose their privileges
919      * if they are compromised (such as when a trusted device is misplaced).
920      *
921      * If the calling account had been granted `role`, emits a {RoleRevoked}
922      * event.
923      *
924      * Requirements:
925      *
926      * - the caller must be `account`.
927      */
928     function renounceRole(bytes32 role, address account) public virtual {
929         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
930 
931         _revokeRole(role, account);
932     }
933 
934     /**
935      * @dev Grants `role` to `account`.
936      *
937      * If `account` had not been already granted `role`, emits a {RoleGranted}
938      * event. Note that unlike {grantRole}, this function doesn't perform any
939      * checks on the calling account.
940      *
941      * [WARNING]
942      * ====
943      * This function should only be called from the constructor when setting
944      * up the initial roles for the system.
945      *
946      * Using this function in any other way is effectively circumventing the admin
947      * system imposed by {AccessControl}.
948      * ====
949      */
950     function _setupRole(bytes32 role, address account) internal virtual {
951         _grantRole(role, account);
952     }
953 
954     /**
955      * @dev Sets `adminRole` as ``role``'s admin role.
956      */
957     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
958         _roles[role].adminRole = adminRole;
959     }
960 
961     function _grantRole(bytes32 role, address account) private {
962         if (_roles[role].members.add(account)) {
963             emit RoleGranted(role, account, _msgSender());
964         }
965     }
966 
967     function _revokeRole(bytes32 role, address account) private {
968         if (_roles[role].members.remove(account)) {
969             emit RoleRevoked(role, account, _msgSender());
970         }
971     }
972 }
973 
974 /**
975  * @title ERC721 token receiver interface
976  * @dev Interface for any contract that wants to support safeTransfers
977  * from ERC721 asset contracts.
978  */
979 abstract contract IERC721Receiver {
980     /**
981      * @notice Handle the receipt of an NFT
982      * @dev The ERC721 smart contract calls this function on the recipient
983      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
984      * otherwise the caller will revert the transaction. The selector to be
985      * returned can be obtained as `this.onERC721Received.selector`. This
986      * function MAY throw to revert and reject the transfer.
987      * Note: the ERC721 contract address is always the message sender.
988      * @param operator The address which called `safeTransferFrom` function
989      * @param from The address which previously owned the token
990      * @param tokenId The NFT identifier which is being transferred
991      * @param data Additional data with no specified format
992      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
993      */
994     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
995     public virtual returns (bytes4);
996 }
997 
998 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
999     using SafeMath for uint256;
1000     using Address for address;
1001     using EnumerableSet for EnumerableSet.UintSet;
1002     using EnumerableMap for EnumerableMap.UintToAddressMap;
1003     using Strings for uint256;
1004 
1005     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1006     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1007     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1008 
1009     // Mapping from holder address to their (enumerable) set of owned tokens
1010     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1011 
1012     // Enumerable mapping from token ids to their owners
1013     EnumerableMap.UintToAddressMap private _tokenOwners;
1014 
1015     // Mapping from token ID to approved address
1016     mapping (uint256 => address) private _tokenApprovals;
1017 
1018     // Mapping from owner to operator approvals
1019     mapping (address => mapping (address => bool)) private _operatorApprovals;
1020 
1021     // Token name
1022     string private _name;
1023 
1024     // Token symbol
1025     string private _symbol;
1026 
1027     // Optional mapping for token URIs
1028     mapping(uint256 => string) private _tokenURIs;
1029 
1030     // Base URI
1031     string private _baseURI;
1032 
1033     /*
1034      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1035      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1036      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1037      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1038      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1039      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1040      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1041      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1042      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1043      *
1044      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1045      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1046      */
1047     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1048 
1049     /*
1050      *     bytes4(keccak256('name()')) == 0x06fdde03
1051      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1052      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1053      *
1054      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1055      */
1056     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1057 
1058     /*
1059      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1060      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1061      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1062      *
1063      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1064      */
1065     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1066 
1067     constructor (string memory name, string memory symbol) public {
1068         _name = name;
1069         _symbol = symbol;
1070 
1071         // register the supported interfaces to conform to ERC721 via ERC165
1072         _registerInterface(_INTERFACE_ID_ERC721);
1073         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1074         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1075     }
1076 
1077     /**
1078      * @dev Gets the balance of the specified address.
1079      * @param owner address to query the balance of
1080      * @return uint256 representing the amount owned by the passed address
1081      */
1082     function balanceOf(address owner) public view override returns (uint256) {
1083         require(owner != address(0), "ERC721: balance query for the zero address");
1084 
1085         return _holderTokens[owner].length();
1086     }
1087 
1088     /**
1089      * @dev Gets the owner of the specified token ID.
1090      * @param tokenId uint256 ID of the token to query the owner of
1091      * @return address currently marked as the owner of the given token ID
1092      */
1093     function ownerOf(uint256 tokenId) public view override returns (address) {
1094         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1095     }
1096 
1097     /**
1098      * @dev Gets the token name.
1099      * @return string representing the token name
1100      */
1101     function name() public view override returns (string memory) {
1102         return _name;
1103     }
1104 
1105     /**
1106      * @dev Gets the token symbol.
1107      * @return string representing the token symbol
1108      */
1109     function symbol() public view override returns (string memory) {
1110         return _symbol;
1111     }
1112 
1113     /**
1114      * @dev Returns the URI for a given token ID. May return an empty string.
1115      *
1116      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1117      * token's own URI (via {_setTokenURI}).
1118      *
1119      * If there is a base URI but no token URI, the token's ID will be used as
1120      * its URI when appending it to the base URI. This pattern for autogenerated
1121      * token URIs can lead to large gas savings.
1122      *
1123      * .Examples
1124      * |===
1125      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1126      * | ""
1127      * | ""
1128      * | ""
1129      * | ""
1130      * | "token.uri/123"
1131      * | "token.uri/123"
1132      * | "token.uri/"
1133      * | "123"
1134      * | "token.uri/123"
1135      * | "token.uri/"
1136      * | ""
1137      * | "token.uri/<tokenId>"
1138      * |===
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      */
1144     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1145         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1146 
1147         string memory _tokenURI = _tokenURIs[tokenId];
1148 
1149         // If there is no base URI, return the token URI.
1150         if (bytes(_baseURI).length == 0) {
1151             return _tokenURI;
1152         }
1153         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1154         if (bytes(_tokenURI).length > 0) {
1155             return string(abi.encodePacked(_baseURI, _tokenURI));
1156         }
1157         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1158         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1159     }
1160 
1161     /**
1162     * @dev Returns the base URI set via {_setBaseURI}. This will be
1163     * automatically added as a prefix in {tokenURI} to each token's URI, or
1164     * to the token ID if no specific URI is set for that token ID.
1165     */
1166     function baseURI() public view returns (string memory) {
1167         return _baseURI;
1168     }
1169 
1170     /**
1171      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1172      * @param owner address owning the tokens list to be accessed
1173      * @param index uint256 representing the index to be accessed of the requested tokens list
1174      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1175      */
1176     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1177         return _holderTokens[owner].at(index);
1178     }
1179 
1180     /**
1181      * @dev Gets the total amount of tokens stored by the contract.
1182      * @return uint256 representing the total amount of tokens
1183      */
1184     function totalSupply() public view override returns (uint256) {
1185         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1186         return _tokenOwners.length();
1187     }
1188 
1189     /**
1190      * @dev Gets the token ID at a given index of all the tokens in this contract
1191      * Reverts if the index is greater or equal to the total number of tokens.
1192      * @param index uint256 representing the index to be accessed of the tokens list
1193      * @return uint256 token ID at the given index of the tokens list
1194      */
1195     function tokenByIndex(uint256 index) public view override returns (uint256) {
1196         (uint256 tokenId, ) = _tokenOwners.at(index);
1197         return tokenId;
1198     }
1199 
1200     /**
1201      * @dev Approves another address to transfer the given token ID
1202      * The zero address indicates there is no approved address.
1203      * There can only be one approved address per token at a given time.
1204      * Can only be called by the token owner or an approved operator.
1205      * @param to address to be approved for the given token ID
1206      * @param tokenId uint256 ID of the token to be approved
1207      */
1208     function approve(address to, uint256 tokenId) public virtual override {
1209         address owner = ownerOf(tokenId);
1210         require(to != owner, "ERC721: approval to current owner");
1211 
1212         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1213             "ERC721: approve caller is not owner nor approved for all"
1214         );
1215 
1216         _approve(to, tokenId);
1217     }
1218 
1219     /**
1220      * @dev Gets the approved address for a token ID, or zero if no address set
1221      * Reverts if the token ID does not exist.
1222      * @param tokenId uint256 ID of the token to query the approval of
1223      * @return address currently approved for the given token ID
1224      */
1225     function getApproved(uint256 tokenId) public view override returns (address) {
1226         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1227 
1228         return _tokenApprovals[tokenId];
1229     }
1230 
1231     /**
1232      * @dev Sets or unsets the approval of a given operator
1233      * An operator is allowed to transfer all tokens of the sender on their behalf.
1234      * @param operator operator address to set the approval
1235      * @param approved representing the status of the approval to be set
1236      */
1237     function setApprovalForAll(address operator, bool approved) public virtual override {
1238         require(operator != _msgSender(), "ERC721: approve to caller");
1239 
1240         _operatorApprovals[_msgSender()][operator] = approved;
1241         emit ApprovalForAll(_msgSender(), operator, approved);
1242     }
1243 
1244     /**
1245      * @dev Tells whether an operator is approved by a given owner.
1246      * @param owner owner address which you want to query the approval of
1247      * @param operator operator address which you want to query the approval of
1248      * @return bool whether the given operator is approved by the given owner
1249      */
1250     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1251         return _operatorApprovals[owner][operator];
1252     }
1253 
1254     /**
1255      * @dev Transfers the ownership of a given token ID to another address.
1256      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1257      * Requires the msg.sender to be the owner, approved, or operator.
1258      * @param from current owner of the token
1259      * @param to address to receive the ownership of the given token ID
1260      * @param tokenId uint256 ID of the token to be transferred
1261      */
1262     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1263         //solhint-disable-next-line max-line-length
1264         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1265 
1266         _transfer(from, to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev Safely transfers the ownership of a given token ID to another address
1271      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1272      * which is called upon a safe transfer, and return the magic value
1273      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1274      * the transfer is reverted.
1275      * Requires the msg.sender to be the owner, approved, or operator
1276      * @param from current owner of the token
1277      * @param to address to receive the ownership of the given token ID
1278      * @param tokenId uint256 ID of the token to be transferred
1279      */
1280     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1281         safeTransferFrom(from, to, tokenId, "");
1282     }
1283 
1284     /**
1285      * @dev Safely transfers the ownership of a given token ID to another address
1286      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1287      * which is called upon a safe transfer, and return the magic value
1288      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1289      * the transfer is reverted.
1290      * Requires the _msgSender() to be the owner, approved, or operator
1291      * @param from current owner of the token
1292      * @param to address to receive the ownership of the given token ID
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes data to send along with a safe transfer check
1295      */
1296     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1297         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1298         _safeTransfer(from, to, tokenId, _data);
1299     }
1300 
1301     /**
1302      * @dev Safely transfers the ownership of a given token ID to another address
1303      * If the target address is a contract, it must implement `onERC721Received`,
1304      * which is called upon a safe transfer, and return the magic value
1305      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1306      * the transfer is reverted.
1307      * Requires the msg.sender to be the owner, approved, or operator
1308      * @param from current owner of the token
1309      * @param to address to receive the ownership of the given token ID
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes data to send along with a safe transfer check
1312      */
1313     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1314         _transfer(from, to, tokenId);
1315         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1316     }
1317 
1318     /**
1319      * @dev Returns whether the specified token exists.
1320      * @param tokenId uint256 ID of the token to query the existence of
1321      * @return bool whether the token exists
1322      */
1323     function _exists(uint256 tokenId) internal view returns (bool) {
1324         return _tokenOwners.contains(tokenId);
1325     }
1326 
1327     /**
1328      * @dev Returns whether the given spender can transfer a given token ID.
1329      * @param spender address of the spender to query
1330      * @param tokenId uint256 ID of the token to be transferred
1331      * @return bool whether the msg.sender is approved for the given token ID,
1332      * is an operator of the owner, or is the owner of the token
1333      */
1334     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1335         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1336         address owner = ownerOf(tokenId);
1337         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1338     }
1339 
1340     /**
1341      * @dev Internal function to safely mint a new token.
1342      * Reverts if the given token ID already exists.
1343      * If the target address is a contract, it must implement `onERC721Received`,
1344      * which is called upon a safe transfer, and return the magic value
1345      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1346      * the transfer is reverted.
1347      * @param to The address that will own the minted token
1348      * @param tokenId uint256 ID of the token to be minted
1349      */
1350     function _safeMint(address to, uint256 tokenId) internal virtual {
1351         _safeMint(to, tokenId, "");
1352     }
1353 
1354     /**
1355      * @dev Internal function to safely mint a new token.
1356      * Reverts if the given token ID already exists.
1357      * If the target address is a contract, it must implement `onERC721Received`,
1358      * which is called upon a safe transfer, and return the magic value
1359      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1360      * the transfer is reverted.
1361      * @param to The address that will own the minted token
1362      * @param tokenId uint256 ID of the token to be minted
1363      * @param _data bytes data to send along with a safe transfer check
1364      */
1365     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1366         _mint(to, tokenId);
1367         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1368     }
1369 
1370     /**
1371      * @dev Internal function to mint a new token.
1372      * Reverts if the given token ID already exists.
1373      * @param to The address that will own the minted token
1374      * @param tokenId uint256 ID of the token to be minted
1375      */
1376     function _mint(address to, uint256 tokenId) internal virtual {
1377         require(to != address(0), "ERC721: mint to the zero address");
1378         require(!_exists(tokenId), "ERC721: token already minted");
1379 
1380         _beforeTokenTransfer(address(0), to, tokenId);
1381 
1382         _holderTokens[to].add(tokenId);
1383 
1384         _tokenOwners.set(tokenId, to);
1385 
1386         emit Transfer(address(0), to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Internal function to burn a specific token.
1391      * Reverts if the token does not exist.
1392      * @param tokenId uint256 ID of the token being burned
1393      */
1394     function _burn(uint256 tokenId) internal virtual {
1395         address owner = ownerOf(tokenId);
1396 
1397         _beforeTokenTransfer(owner, address(0), tokenId);
1398 
1399         // Clear approvals
1400         _approve(address(0), tokenId);
1401 
1402         // Clear metadata (if any)
1403         if (bytes(_tokenURIs[tokenId]).length != 0) {
1404             delete _tokenURIs[tokenId];
1405         }
1406 
1407         _holderTokens[owner].remove(tokenId);
1408 
1409         _tokenOwners.remove(tokenId);
1410 
1411         emit Transfer(owner, address(0), tokenId);
1412     }
1413 
1414     /**
1415      * @dev Internal function to transfer ownership of a given token ID to another address.
1416      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1417      * @param from current owner of the token
1418      * @param to address to receive the ownership of the given token ID
1419      * @param tokenId uint256 ID of the token to be transferred
1420      */
1421     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1422         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1423         require(to != address(0), "ERC721: transfer to the zero address");
1424 
1425         _beforeTokenTransfer(from, to, tokenId);
1426 
1427         // Clear approvals from the previous owner
1428         _approve(address(0), tokenId);
1429 
1430         _holderTokens[from].remove(tokenId);
1431         _holderTokens[to].add(tokenId);
1432 
1433         _tokenOwners.set(tokenId, to);
1434 
1435         emit Transfer(from, to, tokenId);
1436     }
1437 
1438     /**
1439      * @dev Internal function to set the token URI for a given token.
1440      *
1441      * Reverts if the token ID does not exist.
1442      *
1443      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1444      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1445      * it and save gas.
1446      */
1447     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1448         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1449         _tokenURIs[tokenId] = _tokenURI;
1450     }
1451 
1452     /**
1453      * @dev Internal function to set the base URI for all token IDs. It is
1454      * automatically added as a prefix to the value returned in {tokenURI},
1455      * or to the token ID if {tokenURI} is empty.
1456      */
1457     function _setBaseURI(string memory baseURI_) internal virtual {
1458         _baseURI = baseURI_;
1459     }
1460 
1461     /**
1462      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1463      * The call is not executed if the target address is not a contract.
1464      *
1465      * @param from address representing the previous owner of the given token ID
1466      * @param to target address that will receive the tokens
1467      * @param tokenId uint256 ID of the token to be transferred
1468      * @param _data bytes optional data to send along with the call
1469      * @return bool whether the call correctly returned the expected magic value
1470      */
1471     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1472         private returns (bool)
1473     {
1474         if (!to.isContract()) {
1475             return true;
1476         }
1477         // solhint-disable-next-line avoid-low-level-calls
1478         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1479             IERC721Receiver(to).onERC721Received.selector,
1480             _msgSender(),
1481             from,
1482             tokenId,
1483             _data
1484         ));
1485         if (!success) {
1486             if (returndata.length > 0) {
1487                 // solhint-disable-next-line no-inline-assembly
1488                 assembly {
1489                     let returndata_size := mload(returndata)
1490                     revert(add(32, returndata), returndata_size)
1491                 }
1492             } else {
1493                 revert("ERC721: transfer to non ERC721Receiver implementer");
1494             }
1495         } else {
1496             bytes4 retval = abi.decode(returndata, (bytes4));
1497             return (retval == _ERC721_RECEIVED);
1498         }
1499     }
1500 
1501     function _approve(address to, uint256 tokenId) private {
1502         _tokenApprovals[tokenId] = to;
1503         emit Approval(ownerOf(tokenId), to, tokenId);
1504     }
1505 
1506     /**
1507      * @dev Hook that is called before any token transfer. This includes minting
1508      * and burning.
1509      *
1510      * Calling conditions:
1511      *
1512      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1513      * transferred to `to`.
1514      * - when `from` is zero, `tokenId` will be minted for `to`.
1515      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1516      * - `from` and `to` are never both zero.
1517      *
1518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1519      */
1520     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1521 }
1522 
1523 contract Ownable is Context {
1524     address private _owner;
1525 
1526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1527 
1528     /**
1529      * @dev Initializes the contract setting the deployer as the initial owner.
1530      */
1531     constructor () internal {
1532         address msgSender = _msgSender();
1533         _owner = msgSender;
1534         emit OwnershipTransferred(address(0), msgSender);
1535     }
1536 
1537     /**
1538      * @dev Returns the address of the current owner.
1539      */
1540     function owner() public view returns (address) {
1541         return _owner;
1542     }
1543 
1544     /**
1545      * @dev Throws if called by any account other than the owner.
1546      */
1547     modifier onlyOwner() {
1548         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1549         _;
1550     }
1551 
1552     /**
1553      * @dev Leaves the contract without owner. It will not be possible to call
1554      * `onlyOwner` functions anymore. Can only be called by the current owner.
1555      *
1556      * NOTE: Renouncing ownership will leave the contract without an owner,
1557      * thereby removing any functionality that is only available to the owner.
1558      */
1559     function renounceOwnership() public virtual onlyOwner {
1560         emit OwnershipTransferred(_owner, address(0));
1561         _owner = address(0);
1562     }
1563 
1564     /**
1565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1566      * Can only be called by the current owner.
1567      */
1568     function transferOwnership(address newOwner) public virtual onlyOwner {
1569         require(newOwner != address(0), "Ownable: new owner is the zero address");
1570         emit OwnershipTransferred(_owner, newOwner);
1571         _owner = newOwner;
1572     }
1573 }
1574 
1575 contract MinterAccess is Ownable, AccessControl {
1576     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1577 
1578     modifier onlyMinter {
1579         require(hasRole(MINTER_ROLE, _msgSender()), "Sender is not a minter");
1580         _;
1581     }
1582 
1583     constructor() public {
1584         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1585         _setupRole(MINTER_ROLE, msg.sender);
1586     }
1587 
1588     function addMinter(address account) external {
1589         grantRole(MINTER_ROLE, account);
1590     }
1591 
1592     function renounceMinter(address account) external {
1593         renounceRole(MINTER_ROLE, account);
1594     }
1595 
1596     function revokeMinter(address account) external {
1597         revokeRole(MINTER_ROLE, account);
1598     }
1599 }
1600 
1601 interface ISorareCards {
1602     function createCard(
1603         uint256 playerId,
1604         uint16 season,
1605         uint8 scarcity,
1606         uint16 serialNumber,
1607         bytes32 metadata,
1608         uint16 clubId
1609     ) external returns (uint256);
1610 
1611     function getCard(uint256 _cardId)
1612         external
1613         view
1614         returns (
1615             uint256 playerId,
1616             uint16 season,
1617             uint256 scarcity,
1618             uint16 serialNumber,
1619             bytes memory metadata,
1620             uint16 clubId
1621         );
1622 
1623     function getPlayer(uint256 playerId)
1624         external
1625         view
1626         returns (
1627             string memory name,
1628             uint16 yearOfBirth,
1629             uint8 monthOfBirth,
1630             uint8 dayOfBirth
1631         );
1632 
1633     function getClub(uint16 clubId)
1634         external
1635         view
1636         returns (
1637             string memory name,
1638             string memory country,
1639             string memory city,
1640             uint16 yearFounded
1641         );
1642 
1643     function cardExists(uint256 cardId) external view returns (bool);
1644 }
1645 
1646 contract RelayRecipient is Ownable {
1647     address private _relayAddress;
1648 
1649     constructor(address relayAddress) public {
1650         require(relayAddress != address(0), "Custom relay address is required");
1651         _relayAddress = relayAddress;
1652     }
1653 
1654     function blockRelay() public onlyOwner {
1655         _relayAddress = address(this);
1656     }
1657 
1658     function getRelayAddress() public view returns (address) {
1659         return _relayAddress;
1660     }
1661 
1662     /**
1663      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1664      * and the end-user for relayed calls (where msg.sender is actually `Relay` contract).
1665      *
1666      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1667      */
1668     // prettier-ignore
1669     function _msgSender() internal override virtual view returns (address payable) {
1670         if (msg.sender != _relayAddress) {
1671             return msg.sender;
1672         } else {
1673             return _getRelayedCallSender();
1674         }
1675     }
1676 
1677     /**
1678      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1679      * and a reduced version for relayed calls (where msg.data contains additional information).
1680      *
1681      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1682      */
1683     // prettier-ignore
1684     function _msgData() internal override virtual view returns (bytes memory) {
1685         if (msg.sender != _relayAddress) {
1686             return msg.data;
1687         } else {
1688             return _getRelayedCallData();
1689         }
1690     }
1691 
1692     function _getRelayedCallSender()
1693         private
1694         pure
1695         returns (address payable result)
1696     {
1697         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1698         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1699         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1700         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1701         // bytes. This can always be done due to the 32-byte prefix.
1702 
1703         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1704         // easiest/most-efficient way to perform this operation.
1705 
1706         // These fields are not accessible from assembly
1707         bytes memory array = msg.data;
1708         uint256 index = msg.data.length;
1709 
1710         // solhint-disable-next-line no-inline-assembly
1711         assembly {
1712             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1713             result := and(
1714                 mload(add(array, index)),
1715                 0xffffffffffffffffffffffffffffffffffffffff
1716             )
1717         }
1718         return result;
1719     }
1720 
1721     function _getRelayedCallData() private pure returns (bytes memory) {
1722         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1723         // we must strip the last 20 bytes (length of an address type) from it.
1724 
1725         uint256 actualDataLength = msg.data.length - 20;
1726         bytes memory actualData = new bytes(actualDataLength);
1727 
1728         for (uint256 i = 0; i < actualDataLength; ++i) {
1729             actualData[i] = msg.data[i];
1730         }
1731 
1732         return actualData;
1733     }
1734 }
1735 
1736 library NFTClient {
1737     bytes4 public constant interfaceIdERC721 = 0x80ac58cd;
1738 
1739     function requireERC721(address _candidate) public view {
1740         require(
1741             IERC721Enumerable(_candidate).supportsInterface(interfaceIdERC721),
1742             "IS_NOT_721_TOKEN"
1743         );
1744     }
1745 
1746     function transferTokens(
1747         IERC721Enumerable _nftContract,
1748         address _from,
1749         address _to,
1750         uint256[] memory _tokenIds
1751     ) public {
1752         for (uint256 index = 0; index < _tokenIds.length; index++) {
1753             if (_tokenIds[index] == 0) {
1754                 break;
1755             }
1756 
1757             _nftContract.safeTransferFrom(_from, _to, _tokenIds[index]);
1758         }
1759     }
1760 
1761     function transferAll(
1762         IERC721Enumerable _nftContract,
1763         address _sender,
1764         address _receiver
1765     ) public {
1766         uint256 balance = _nftContract.balanceOf(_sender);
1767         while (balance > 0) {
1768             _nftContract.safeTransferFrom(
1769                 _sender,
1770                 _receiver,
1771                 _nftContract.tokenOfOwnerByIndex(_sender, balance - 1)
1772             );
1773             balance--;
1774         }
1775     }
1776 
1777     // /// @dev Pagination of owner tokens
1778     // /// @param owner - address of the token owner
1779     // /// @param page - page number
1780     // /// @param rows - number of rows per page
1781     function tokensOfOwner(
1782         address _nftContract,
1783         address owner,
1784         uint8 page,
1785         uint8 rows
1786     ) public view returns (uint256[] memory) {
1787         requireERC721(_nftContract);
1788 
1789         IERC721Enumerable nftContract = IERC721Enumerable(_nftContract);
1790 
1791         uint256 tokenCount = nftContract.balanceOf(owner);
1792         uint256 offset = page * rows;
1793         uint256 range = offset > tokenCount
1794             ? 0
1795             : min(tokenCount - offset, rows);
1796         uint256[] memory tokens = new uint256[](range);
1797         for (uint256 index = 0; index < range; index++) {
1798             tokens[index] = nftContract.tokenOfOwnerByIndex(
1799                 owner,
1800                 offset + index
1801             );
1802         }
1803         return tokens;
1804     }
1805 
1806     function min(uint256 a, uint256 b) private pure returns (uint256) {
1807         return a > b ? b : a;
1808     }
1809 }
1810 
1811 interface ISorareTokens {
1812     function createCardAndMintToken(
1813         uint256 playerId,
1814         uint16 season,
1815         uint8 scarcity,
1816         uint16 serialNumber,
1817         bytes32 metadata,
1818         uint16 clubId,
1819         address to
1820     ) external returns (uint256);
1821 
1822     function mintToken(uint256 cardId, address to) external returns (uint256);
1823 }
1824 
1825 interface INextContract {
1826     function migrateTokens(uint256[] calldata tokenIds, address to) external;
1827 }
1828 
1829 contract SorareTokens is
1830     MinterAccess,
1831     RelayRecipient,
1832     ERC721("Sorare", "SOR"),
1833     ISorareTokens
1834 {
1835     ISorareCards public sorareCards;
1836     INextContract public nextContract;
1837 
1838     constructor(address sorareCardsAddress, address relayAddress)
1839         public
1840         RelayRecipient(relayAddress)
1841     {
1842         require(
1843             sorareCardsAddress != address(0),
1844             "SorareCards address is required"
1845         );
1846         sorareCards = ISorareCards(sorareCardsAddress);
1847     }
1848 
1849     /// @dev Set the prefix for the tokenURIs.
1850     function setTokenURIPrefix(string memory prefix) public onlyOwner {
1851         _setBaseURI(prefix);
1852     }
1853 
1854     /// @dev Set the potential next version contract
1855     function setNextContract(address nextContractAddress) public onlyOwner {
1856         require(
1857             address(nextContract) == address(0),
1858             "NextContract already set"
1859         );
1860         nextContract = INextContract(nextContractAddress);
1861     }
1862 
1863     /// @dev Creates a new card in the Cards contract and mints the token
1864     // prettier-ignore
1865     function createCardAndMintToken(
1866         uint256 playerId,
1867         uint16 season,
1868         uint8 scarcity,
1869         uint16 serialNumber,
1870         bytes32 metadata,
1871         uint16 clubId,
1872         address to
1873     ) public onlyMinter override returns (uint256) {
1874         uint256 cardId = sorareCards.createCard(
1875             playerId,
1876             season,
1877             scarcity,
1878             serialNumber,
1879             metadata,
1880             clubId
1881         );
1882 
1883         _mint(to, cardId);
1884         return cardId;
1885     }
1886 
1887     /// @dev Mints a token for an existing card
1888     // prettier-ignore
1889     function mintToken(uint256 cardId, address to)
1890         public
1891         override
1892         onlyMinter
1893         returns (uint256)
1894     {
1895         require(sorareCards.cardExists(cardId), "Card does not exist");
1896 
1897         _mint(to, cardId);
1898         return cardId;
1899     }
1900 
1901     /// @dev Migrates tokens to a potential new version of this contract
1902     /// @param tokenIds - list of tokens to transfer
1903     function migrateTokens(uint256[] calldata tokenIds) external {
1904         require(address(nextContract) != address(0), "Next contract not set");
1905 
1906         for (uint256 index = 0; index < tokenIds.length; index++) {
1907             transferFrom(_msgSender(), address(this), tokenIds[index]);
1908         }
1909 
1910         nextContract.migrateTokens(tokenIds, _msgSender());
1911     }
1912 
1913     /// @dev Pagination of owner tokens
1914     /// @param owner - address of the token owner
1915     /// @param page - page number
1916     /// @param rows - number of rows per page
1917     function tokensOfOwner(address owner, uint8 page, uint8 rows)
1918         public
1919         view
1920         returns (uint256[] memory)
1921     {
1922         return NFTClient.tokensOfOwner(address(this), owner, page, rows);
1923     }
1924 
1925     function getCard(uint256 tokenId)
1926         public
1927         view
1928         returns (
1929             uint256 playerId,
1930             uint16 season,
1931             uint256 scarcity,
1932             uint16 serialNumber,
1933             bytes memory metadata,
1934             uint16 clubId
1935         )
1936     {
1937         (
1938             playerId,
1939             season,
1940             scarcity,
1941             serialNumber,
1942             metadata,
1943             clubId
1944         ) = sorareCards.getCard(tokenId);
1945     }
1946 
1947     function getPlayer(uint256 playerId)
1948         external
1949         view
1950         returns (
1951             string memory name,
1952             uint16 yearOfBirth,
1953             uint8 monthOfBirth,
1954             uint8 dayOfBirth
1955         )
1956     {
1957         (name, yearOfBirth, monthOfBirth, dayOfBirth) = sorareCards.getPlayer(
1958             playerId
1959         );
1960     }
1961 
1962     // prettier-ignore
1963     function getClub(uint16 clubId)
1964         external
1965         view
1966         returns (
1967             string memory name,
1968             string memory country,
1969             string memory city,
1970             uint16 yearFounded
1971         )
1972     {
1973         (name, country, city, yearFounded) = sorareCards.getClub(clubId);
1974     }
1975 
1976     // prettier-ignore
1977     function _msgSender() internal view override(RelayRecipient, Context) returns (address payable) {
1978         return RelayRecipient._msgSender();
1979     }
1980 
1981     // prettier-ignore
1982     function _msgData() internal view override(RelayRecipient, Context) returns (bytes memory) {
1983         return RelayRecipient._msgData();
1984     }
1985 }