1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-19
3 */
4 
5 pragma solidity ^0.6.0;
6 // produced by the Solididy File Flattener (c) David Appleton 2018
7 // contact : dave@akomba.com
8 // released under Apache 2.0 licence
9 // input  /Users/daveappleton/Documents/akombalabs/ZBCToken/contracts/ZBCToken.sol
10 // flattened :  Friday, 19-Jun-20 15:50:13 UTC
11 library EnumerableMap {
12     // To implement this library for multiple types with as little code
13     // repetition as possible, we write it in terms of a generic Map type with
14     // bytes32 keys and values.
15     // The Map implementation uses private functions, and user-facing
16     // implementations (such as Uint256ToAddressMap) are just wrappers around
17     // the underlying Map.
18     // This means that we can only create new EnumerableMaps for types that fit
19     // in bytes32.
20 
21     struct MapEntry {
22         bytes32 _key;
23         bytes32 _value;
24     }
25 
26     struct Map {
27         // Storage of map keys and values
28         MapEntry[] _entries;
29 
30         // Position of the entry defined by a key in the `entries` array, plus 1
31         // because index 0 means a key is not in the map.
32         mapping (bytes32 => uint256) _indexes;
33     }
34 
35     /**
36      * @dev Adds a key-value pair to a map, or updates the value for an existing
37      * key. O(1).
38      *
39      * Returns true if the key was added to the map, that is if it was not
40      * already present.
41      */
42     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
43         // We read and store the key's index to prevent multiple reads from the same storage slot
44         uint256 keyIndex = map._indexes[key];
45 
46         if (keyIndex == 0) { // Equivalent to !contains(map, key)
47             map._entries.push(MapEntry({ _key: key, _value: value }));
48             // The entry is stored at length-1, but we add 1 to all indexes
49             // and use 0 as a sentinel value
50             map._indexes[key] = map._entries.length;
51             return true;
52         } else {
53             map._entries[keyIndex - 1]._value = value;
54             return false;
55         }
56     }
57 
58     /**
59      * @dev Removes a key-value pair from a map. O(1).
60      *
61      * Returns true if the key was removed from the map, that is if it was present.
62      */
63     function _remove(Map storage map, bytes32 key) private returns (bool) {
64         // We read and store the key's index to prevent multiple reads from the same storage slot
65         uint256 keyIndex = map._indexes[key];
66 
67         if (keyIndex != 0) { // Equivalent to contains(map, key)
68             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
69             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
70             // This modifies the order of the array, as noted in {at}.
71 
72             uint256 toDeleteIndex = keyIndex - 1;
73             uint256 lastIndex = map._entries.length - 1;
74 
75             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
76             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
77 
78             MapEntry storage lastEntry = map._entries[lastIndex];
79 
80             // Move the last entry to the index where the entry to delete is
81             map._entries[toDeleteIndex] = lastEntry;
82             // Update the index for the moved entry
83             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
84 
85             // Delete the slot where the moved entry was stored
86             map._entries.pop();
87 
88             // Delete the index for the deleted slot
89             delete map._indexes[key];
90 
91             return true;
92         } else {
93             return false;
94         }
95     }
96 
97     /**
98      * @dev Returns true if the key is in the map. O(1).
99      */
100     function _contains(Map storage map, bytes32 key) private view returns (bool) {
101         return map._indexes[key] != 0;
102     }
103 
104     /**
105      * @dev Returns the number of key-value pairs in the map. O(1).
106      */
107     function _length(Map storage map) private view returns (uint256) {
108         return map._entries.length;
109     }
110 
111    /**
112     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
113     *
114     * Note that there are no guarantees on the ordering of entries inside the
115     * array, and it may change when more entries are added or removed.
116     *
117     * Requirements:
118     *
119     * - `index` must be strictly less than {length}.
120     */
121     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
122         require(map._entries.length > index, "EnumerableMap: index out of bounds");
123 
124         MapEntry storage entry = map._entries[index];
125         return (entry._key, entry._value);
126     }
127 
128     /**
129      * @dev Returns the value associated with `key`.  O(1).
130      *
131      * Requirements:
132      *
133      * - `key` must be in the map.
134      */
135     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
136         return _get(map, key, "EnumerableMap: nonexistent key");
137     }
138 
139     /**
140      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
141      */
142     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
143         uint256 keyIndex = map._indexes[key];
144         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
145         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
146     }
147 
148     // UintToAddressMap
149 
150     struct UintToAddressMap {
151         Map _inner;
152     }
153 
154     /**
155      * @dev Adds a key-value pair to a map, or updates the value for an existing
156      * key. O(1).
157      *
158      * Returns true if the key was added to the map, that is if it was not
159      * already present.
160      */
161     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
162         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
163     }
164 
165     /**
166      * @dev Removes a value from a set. O(1).
167      *
168      * Returns true if the key was removed from the map, that is if it was present.
169      */
170     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
171         return _remove(map._inner, bytes32(key));
172     }
173 
174     /**
175      * @dev Returns true if the key is in the map. O(1).
176      */
177     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
178         return _contains(map._inner, bytes32(key));
179     }
180 
181     /**
182      * @dev Returns the number of elements in the map. O(1).
183      */
184     function length(UintToAddressMap storage map) internal view returns (uint256) {
185         return _length(map._inner);
186     }
187 
188    /**
189     * @dev Returns the element stored at position `index` in the set. O(1).
190     * Note that there are no guarantees on the ordering of values inside the
191     * array, and it may change when more values are added or removed.
192     *
193     * Requirements:
194     *
195     * - `index` must be strictly less than {length}.
196     */
197     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
198         (bytes32 key, bytes32 value) = _at(map._inner, index);
199         return (uint256(key), address(uint256(value)));
200     }
201 
202     /**
203      * @dev Returns the value associated with `key`.  O(1).
204      *
205      * Requirements:
206      *
207      * - `key` must be in the map.
208      */
209     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
210         return address(uint256(_get(map._inner, bytes32(key))));
211     }
212 
213     /**
214      * @dev Same as {get}, with a custom error message when `key` is not in the map.
215      */
216     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
217         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
218     }
219 }
220 
221 interface IERC165 {
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 }
232 
233 library SafeMath {
234     /**
235      * @dev Returns the addition of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `+` operator.
239      *
240      * Requirements:
241      * - Addition cannot overflow.
242      */
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         uint256 c = a + b;
245         require(c >= a, "SafeMath: addition overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting on
252      * overflow (when the result is negative).
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      * - Subtraction cannot overflow.
258      */
259     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260         return sub(a, b, "SafeMath: subtraction overflow");
261     }
262 
263     /**
264      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
265      * overflow (when the result is negative).
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      * - Subtraction cannot overflow.
271      */
272     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b <= a, errorMessage);
274         uint256 c = a - b;
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the multiplication of two unsigned integers, reverting on
281      * overflow.
282      *
283      * Counterpart to Solidity's `*` operator.
284      *
285      * Requirements:
286      * - Multiplication cannot overflow.
287      */
288     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
289         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
290         // benefit is lost if 'b' is also tested.
291         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
292         if (a == 0) {
293             return 0;
294         }
295 
296         uint256 c = a * b;
297         require(c / a == b, "SafeMath: multiplication overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the integer division of two unsigned integers. Reverts on
304      * division by zero. The result is rounded towards zero.
305      *
306      * Counterpart to Solidity's `/` operator. Note: this function uses a
307      * `revert` opcode (which leaves remaining gas untouched) while Solidity
308      * uses an invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      * - The divisor cannot be zero.
312      */
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return div(a, b, "SafeMath: division by zero");
315     }
316 
317     /**
318      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
319      * division by zero. The result is rounded towards zero.
320      *
321      * Counterpart to Solidity's `/` operator. Note: this function uses a
322      * `revert` opcode (which leaves remaining gas untouched) while Solidity
323      * uses an invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      */
328     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         require(b > 0, errorMessage);
330         uint256 c = a / b;
331         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
348         return mod(a, b, "SafeMath: modulo by zero");
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
353      * Reverts with custom message when dividing by zero.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      * - The divisor cannot be zero.
361      */
362     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
363         require(b != 0, errorMessage);
364         return a % b;
365     }
366 }
367 
368 library Strings {
369     /**
370      * @dev Converts a `uint256` to its ASCII `string` representation.
371      */
372     function toString(uint256 value) internal pure returns (string memory) {
373         // Inspired by OraclizeAPI's implementation - MIT licence
374         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
375 
376         if (value == 0) {
377             return "0";
378         }
379         uint256 temp = value;
380         uint256 digits;
381         while (temp != 0) {
382             digits++;
383             temp /= 10;
384         }
385         bytes memory buffer = new bytes(digits);
386         uint256 index = digits - 1;
387         temp = value;
388         while (temp != 0) {
389             buffer[index--] = byte(uint8(48 + temp % 10));
390             temp /= 10;
391         }
392         return string(buffer);
393     }
394 }
395 
396 abstract contract Context {
397     function _msgSender() internal view virtual returns (address payable) {
398         return msg.sender;
399     }
400 
401     function _msgData() internal view virtual returns (bytes memory) {
402         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
403         return msg.data;
404     }
405 }
406 
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
427         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
428         // for accounts without code, i.e. `keccak256('')`
429         bytes32 codehash;
430         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
431         // solhint-disable-next-line no-inline-assembly
432         assembly { codehash := extcodehash(account) }
433         return (codehash != accountHash && codehash != 0x0);
434     }
435 
436     /**
437      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
438      * `recipient`, forwarding all available gas and reverting on errors.
439      *
440      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
441      * of certain opcodes, possibly making contracts go over the 2300 gas limit
442      * imposed by `transfer`, making them unable to receive funds via
443      * `transfer`. {sendValue} removes this limitation.
444      *
445      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
446      *
447      * IMPORTANT: because control is transferred to `recipient`, care must be
448      * taken to not create reentrancy vulnerabilities. Consider using
449      * {ReentrancyGuard} or the
450      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
451      */
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(address(this).balance >= amount, "Address: insufficient balance");
454 
455         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
456         (bool success, ) = recipient.call{ value: amount }("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 }
460 
461 interface IERC721Receiver {
462     /**
463      * @notice Handle the receipt of an NFT
464      * @dev The ERC721 smart contract calls this function on the recipient
465      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
466      * otherwise the caller will revert the transaction. The selector to be
467      * returned can be obtained as `this.onERC721Received.selector`. This
468      * function MAY throw to revert and reject the transfer.
469      * Note: the ERC721 contract address is always the message sender.
470      * @param operator The address which called `safeTransferFrom` function
471      * @param from The address which previously owned the token
472      * @param tokenId The NFT identifier which is being transferred
473      * @param data Additional data with no specified format
474      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
475      */
476     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
477     external returns (bytes4);
478 }
479 
480 library EnumerableSet {
481     // To implement this library for multiple types with as little code
482     // repetition as possible, we write it in terms of a generic Set type with
483     // bytes32 values.
484     // The Set implementation uses private functions, and user-facing
485     // implementations (such as AddressSet) are just wrappers around the
486     // underlying Set.
487     // This means that we can only create new EnumerableSets for types that fit
488     // in bytes32.
489 
490     struct Set {
491         // Storage of set values
492         bytes32[] _values;
493 
494         // Position of the value in the `values` array, plus 1 because index 0
495         // means a value is not in the set.
496         mapping (bytes32 => uint256) _indexes;
497     }
498 
499     /**
500      * @dev Add a value to a set. O(1).
501      *
502      * Returns true if the value was added to the set, that is if it was not
503      * already present.
504      */
505     function _add(Set storage set, bytes32 value) private returns (bool) {
506         if (!_contains(set, value)) {
507             set._values.push(value);
508             // The value is stored at length-1, but we add 1 to all indexes
509             // and use 0 as a sentinel value
510             set._indexes[value] = set._values.length;
511             return true;
512         } else {
513             return false;
514         }
515     }
516 
517     /**
518      * @dev Removes a value from a set. O(1).
519      *
520      * Returns true if the value was removed from the set, that is if it was
521      * present.
522      */
523     function _remove(Set storage set, bytes32 value) private returns (bool) {
524         // We read and store the value's index to prevent multiple reads from the same storage slot
525         uint256 valueIndex = set._indexes[value];
526 
527         if (valueIndex != 0) { // Equivalent to contains(set, value)
528             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
529             // the array, and then remove the last element (sometimes called as 'swap and pop').
530             // This modifies the order of the array, as noted in {at}.
531 
532             uint256 toDeleteIndex = valueIndex - 1;
533             uint256 lastIndex = set._values.length - 1;
534 
535             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
536             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
537 
538             bytes32 lastvalue = set._values[lastIndex];
539 
540             // Move the last value to the index where the value to delete is
541             set._values[toDeleteIndex] = lastvalue;
542             // Update the index for the moved value
543             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
544 
545             // Delete the slot where the moved value was stored
546             set._values.pop();
547 
548             // Delete the index for the deleted slot
549             delete set._indexes[value];
550 
551             return true;
552         } else {
553             return false;
554         }
555     }
556 
557     /**
558      * @dev Returns true if the value is in the set. O(1).
559      */
560     function _contains(Set storage set, bytes32 value) private view returns (bool) {
561         return set._indexes[value] != 0;
562     }
563 
564     /**
565      * @dev Returns the number of values on the set. O(1).
566      */
567     function _length(Set storage set) private view returns (uint256) {
568         return set._values.length;
569     }
570 
571    /**
572     * @dev Returns the value stored at position `index` in the set. O(1).
573     *
574     * Note that there are no guarantees on the ordering of values inside the
575     * array, and it may change when more values are added or removed.
576     *
577     * Requirements:
578     *
579     * - `index` must be strictly less than {length}.
580     */
581     function _at(Set storage set, uint256 index) private view returns (bytes32) {
582         require(set._values.length > index, "EnumerableSet: index out of bounds");
583         return set._values[index];
584     }
585 
586     // AddressSet
587 
588     struct AddressSet {
589         Set _inner;
590     }
591 
592     /**
593      * @dev Add a value to a set. O(1).
594      *
595      * Returns true if the value was added to the set, that is if it was not
596      * already present.
597      */
598     function add(AddressSet storage set, address value) internal returns (bool) {
599         return _add(set._inner, bytes32(uint256(value)));
600     }
601 
602     /**
603      * @dev Removes a value from a set. O(1).
604      *
605      * Returns true if the value was removed from the set, that is if it was
606      * present.
607      */
608     function remove(AddressSet storage set, address value) internal returns (bool) {
609         return _remove(set._inner, bytes32(uint256(value)));
610     }
611 
612     /**
613      * @dev Returns true if the value is in the set. O(1).
614      */
615     function contains(AddressSet storage set, address value) internal view returns (bool) {
616         return _contains(set._inner, bytes32(uint256(value)));
617     }
618 
619     /**
620      * @dev Returns the number of values in the set. O(1).
621      */
622     function length(AddressSet storage set) internal view returns (uint256) {
623         return _length(set._inner);
624     }
625 
626    /**
627     * @dev Returns the value stored at position `index` in the set. O(1).
628     *
629     * Note that there are no guarantees on the ordering of values inside the
630     * array, and it may change when more values are added or removed.
631     *
632     * Requirements:
633     *
634     * - `index` must be strictly less than {length}.
635     */
636     function at(AddressSet storage set, uint256 index) internal view returns (address) {
637         return address(uint256(_at(set._inner, index)));
638     }
639 
640 
641     // UintSet
642 
643     struct UintSet {
644         Set _inner;
645     }
646 
647     /**
648      * @dev Add a value to a set. O(1).
649      *
650      * Returns true if the value was added to the set, that is if it was not
651      * already present.
652      */
653     function add(UintSet storage set, uint256 value) internal returns (bool) {
654         return _add(set._inner, bytes32(value));
655     }
656 
657     /**
658      * @dev Removes a value from a set. O(1).
659      *
660      * Returns true if the value was removed from the set, that is if it was
661      * present.
662      */
663     function remove(UintSet storage set, uint256 value) internal returns (bool) {
664         return _remove(set._inner, bytes32(value));
665     }
666 
667     /**
668      * @dev Returns true if the value is in the set. O(1).
669      */
670     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
671         return _contains(set._inner, bytes32(value));
672     }
673 
674     /**
675      * @dev Returns the number of values on the set. O(1).
676      */
677     function length(UintSet storage set) internal view returns (uint256) {
678         return _length(set._inner);
679     }
680 
681    /**
682     * @dev Returns the value stored at position `index` in the set. O(1).
683     *
684     * Note that there are no guarantees on the ordering of values inside the
685     * array, and it may change when more values are added or removed.
686     *
687     * Requirements:
688     *
689     * - `index` must be strictly less than {length}.
690     */
691     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
692         return uint256(_at(set._inner, index));
693     }
694 }
695 
696 interface IERC721 is IERC165 {
697     /**
698      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
699      */
700     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
701 
702     /**
703      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
704      */
705     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
706 
707     /**
708      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
709      */
710     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
711 
712     /**
713      * @dev Returns the number of tokens in ``owner``'s account.
714      */
715     function balanceOf(address owner) external view returns (uint256 balance);
716 
717     /**
718      * @dev Returns the owner of the `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function ownerOf(uint256 tokenId) external view returns (address owner);
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729      *
730      * Requirements:
731      *
732      * - `from`, `to` cannot be zero.
733      * - `tokenId` token must exist and be owned by `from`.
734      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function safeTransferFrom(address from, address to, uint256 tokenId) external;
740 
741     /**
742      * @dev Transfers `tokenId` token from `from` to `to`.
743      *
744      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
745      *
746      * Requirements:
747      *
748      * - `from`, `to` cannot be zero.
749      * - `tokenId` token must be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      *
752      * Emits a {Transfer} event.
753      */
754     function transferFrom(address from, address to, uint256 tokenId) external;
755 
756     /**
757      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
758      * The approval is cleared when the token is transferred.
759      *
760      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
761      *
762      * Requirements:
763      *
764      * - The caller must own the token or be an approved operator.
765      * - `tokenId` must exist.
766      *
767      * Emits an {Approval} event.
768      */
769     function approve(address to, uint256 tokenId) external;
770 
771     /**
772      * @dev Returns the account approved for `tokenId` token.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must exist.
777      */
778     function getApproved(uint256 tokenId) external view returns (address operator);
779 
780     /**
781      * @dev Approve or remove `operator` as an operator for the caller.
782      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
783      *
784      * Requirements:
785      *
786      * - The `operator` cannot be the caller.
787      *
788      * Emits an {ApprovalForAll} event.
789      */
790     function setApprovalForAll(address operator, bool _approved) external;
791 
792     /**
793      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
794      *
795      * See {setApprovalForAll}
796      */
797     function isApprovedForAll(address owner, address operator) external view returns (bool);
798 
799     /**
800       * @dev Safely transfers `tokenId` token from `from` to `to`.
801       *
802       * Requirements:
803       *
804       * - `from`, `to` cannot be zero.
805       * - `tokenId` token must exist and be owned by `from`.
806       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
807       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808       *
809       * Emits a {Transfer} event.
810       */
811     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
812 }
813 
814 contract ERC165 is IERC165 {
815     /*
816      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
817      */
818     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
819 
820     /**
821      * @dev Mapping of interface ids to whether or not it's supported.
822      */
823     mapping(bytes4 => bool) private _supportedInterfaces;
824 
825     constructor () internal {
826         // Derived contracts need only register support for their own interfaces,
827         // we register support for ERC165 itself here
828         _registerInterface(_INTERFACE_ID_ERC165);
829     }
830 
831     /**
832      * @dev See {IERC165-supportsInterface}.
833      *
834      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
835      */
836     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
837         return _supportedInterfaces[interfaceId];
838     }
839 
840     /**
841      * @dev Registers the contract as an implementer of the interface defined by
842      * `interfaceId`. Support of the actual ERC165 interface is automatic and
843      * registering its interface id is not required.
844      *
845      * See {IERC165-supportsInterface}.
846      *
847      * Requirements:
848      *
849      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
850      */
851     function _registerInterface(bytes4 interfaceId) internal virtual {
852         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
853         _supportedInterfaces[interfaceId] = true;
854     }
855 }
856 
857 interface IERC721Metadata is IERC721 {
858 
859     /**
860      * @dev Returns the token collection name.
861      */
862     function name() external view returns (string memory);
863 
864     /**
865      * @dev Returns the token collection symbol.
866      */
867     function symbol() external view returns (string memory);
868 
869     /**
870      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
871      */
872     function tokenURI(uint256 tokenId) external view returns (string memory);
873 }
874 
875 interface IERC721Enumerable is IERC721 {
876 
877     /**
878      * @dev Returns the total amount of tokens stored by the contract.
879      */
880     function totalSupply() external view returns (uint256);
881 
882     /**
883      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
884      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
885      */
886     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
887 
888     /**
889      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
890      * Use along with {totalSupply} to enumerate all tokens.
891      */
892     function tokenByIndex(uint256 index) external view returns (uint256);
893 }
894 
895 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
896     using SafeMath for uint256;
897     using Address for address;
898     using EnumerableSet for EnumerableSet.UintSet;
899     using EnumerableMap for EnumerableMap.UintToAddressMap;
900     using Strings for uint256;
901 
902     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
903     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
904     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
905 
906     // Mapping from holder address to their (enumerable) set of owned tokens
907     mapping (address => EnumerableSet.UintSet) private _holderTokens;
908 
909     // Enumerable mapping from token ids to their owners
910     EnumerableMap.UintToAddressMap private _tokenOwners;
911 
912     // Mapping from token ID to approved address
913     mapping (uint256 => address) private _tokenApprovals;
914 
915     // Mapping from owner to operator approvals
916     mapping (address => mapping (address => bool)) private _operatorApprovals;
917 
918     // Token name
919     string private _name;
920 
921     // Token symbol
922     string private _symbol;
923 
924     // Optional mapping for token URIs
925     mapping(uint256 => string) private _tokenURIs;
926 
927     // Base URI
928     string private _baseURI;
929 
930     /*
931      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
932      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
933      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
934      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
935      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
936      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
937      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
938      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
939      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
940      *
941      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
942      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
943      */
944     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
945 
946     /*
947      *     bytes4(keccak256('name()')) == 0x06fdde03
948      *     bytes4(keccak256('symbol()')) == 0x95d89b41
949      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
950      *
951      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
952      */
953     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
954 
955     /*
956      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
957      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
958      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
959      *
960      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
961      */
962     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
963 
964     constructor (string memory name, string memory symbol) public {
965         _name = name;
966         _symbol = symbol;
967 
968         // register the supported interfaces to conform to ERC721 via ERC165
969         _registerInterface(_INTERFACE_ID_ERC721);
970         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
971         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
972     }
973 
974     /**
975      * @dev Gets the balance of the specified address.
976      * @param owner address to query the balance of
977      * @return uint256 representing the amount owned by the passed address
978      */
979     function balanceOf(address owner) public view override returns (uint256) {
980         require(owner != address(0), "ERC721: balance query for the zero address");
981 
982         return _holderTokens[owner].length();
983     }
984 
985     /**
986      * @dev Gets the owner of the specified token ID.
987      * @param tokenId uint256 ID of the token to query the owner of
988      * @return address currently marked as the owner of the given token ID
989      */
990     function ownerOf(uint256 tokenId) public view override returns (address) {
991         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
992     }
993 
994     /**
995      * @dev Gets the token name.
996      * @return string representing the token name
997      */
998     function name() public view override returns (string memory) {
999         return _name;
1000     }
1001 
1002     /**
1003      * @dev Gets the token symbol.
1004      * @return string representing the token symbol
1005      */
1006     function symbol() public view override returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev Returns the URI for a given token ID. May return an empty string.
1012      *
1013      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1014      * token's own URI (via {_setTokenURI}).
1015      *
1016      * If there is a base URI but no token URI, the token's ID will be used as
1017      * its URI when appending it to the base URI. This pattern for autogenerated
1018      * token URIs can lead to large gas savings.
1019      *
1020      * .Examples
1021      * |===
1022      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1023      * | ""
1024      * | ""
1025      * | ""
1026      * | ""
1027      * | "token.uri/123"
1028      * | "token.uri/123"
1029      * | "token.uri/"
1030      * | "123"
1031      * | "token.uri/123"
1032      * | "token.uri/"
1033      * | ""
1034      * | "token.uri/<tokenId>"
1035      * |===
1036      *
1037      * Requirements:
1038      *
1039      * - `tokenId` must exist.
1040      */
1041     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1042         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1043 
1044         string memory _tokenURI = _tokenURIs[tokenId];
1045 
1046         // If there is no base URI, return the token URI.
1047         if (bytes(_baseURI).length == 0) {
1048             return _tokenURI;
1049         }
1050         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1051         if (bytes(_tokenURI).length > 0) {
1052             return string(abi.encodePacked(_baseURI, _tokenURI));
1053         }
1054         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1055         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1056     }
1057 
1058     /**
1059     * @dev Returns the base URI set via {_setBaseURI}. This will be
1060     * automatically added as a prefix in {tokenURI} to each token's URI, or
1061     * to the token ID if no specific URI is set for that token ID.
1062     */
1063     function baseURI() public view returns (string memory) {
1064         return _baseURI;
1065     }
1066 
1067     /**
1068      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1069      * @param owner address owning the tokens list to be accessed
1070      * @param index uint256 representing the index to be accessed of the requested tokens list
1071      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1072      */
1073     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1074         return _holderTokens[owner].at(index);
1075     }
1076 
1077     /**
1078      * @dev Gets the total amount of tokens stored by the contract.
1079      * @return uint256 representing the total amount of tokens
1080      */
1081     function totalSupply() public view override returns (uint256) {
1082         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1083         return _tokenOwners.length();
1084     }
1085 
1086     /**
1087      * @dev Gets the token ID at a given index of all the tokens in this contract
1088      * Reverts if the index is greater or equal to the total number of tokens.
1089      * @param index uint256 representing the index to be accessed of the tokens list
1090      * @return uint256 token ID at the given index of the tokens list
1091      */
1092     function tokenByIndex(uint256 index) public view override returns (uint256) {
1093         (uint256 tokenId, ) = _tokenOwners.at(index);
1094         return tokenId;
1095     }
1096 
1097     /**
1098      * @dev Approves another address to transfer the given token ID
1099      * The zero address indicates there is no approved address.
1100      * There can only be one approved address per token at a given time.
1101      * Can only be called by the token owner or an approved operator.
1102      * @param to address to be approved for the given token ID
1103      * @param tokenId uint256 ID of the token to be approved
1104      */
1105     function approve(address to, uint256 tokenId) public virtual override {
1106         address owner = ownerOf(tokenId);
1107         require(to != owner, "ERC721: approval to current owner");
1108 
1109         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1110             "ERC721: approve caller is not owner nor approved for all"
1111         );
1112 
1113         _approve(to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Gets the approved address for a token ID, or zero if no address set
1118      * Reverts if the token ID does not exist.
1119      * @param tokenId uint256 ID of the token to query the approval of
1120      * @return address currently approved for the given token ID
1121      */
1122     function getApproved(uint256 tokenId) public view override returns (address) {
1123         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1124 
1125         return _tokenApprovals[tokenId];
1126     }
1127 
1128     /**
1129      * @dev Sets or unsets the approval of a given operator
1130      * An operator is allowed to transfer all tokens of the sender on their behalf.
1131      * @param operator operator address to set the approval
1132      * @param approved representing the status of the approval to be set
1133      */
1134     function setApprovalForAll(address operator, bool approved) public virtual override {
1135         require(operator != _msgSender(), "ERC721: approve to caller");
1136 
1137         _operatorApprovals[_msgSender()][operator] = approved;
1138         emit ApprovalForAll(_msgSender(), operator, approved);
1139     }
1140 
1141     /**
1142      * @dev Tells whether an operator is approved by a given owner.
1143      * @param owner owner address which you want to query the approval of
1144      * @param operator operator address which you want to query the approval of
1145      * @return bool whether the given operator is approved by the given owner
1146      */
1147     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1148         return _operatorApprovals[owner][operator];
1149     }
1150 
1151     /**
1152      * @dev Transfers the ownership of a given token ID to another address.
1153      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1154      * Requires the msg.sender to be the owner, approved, or operator.
1155      * @param from current owner of the token
1156      * @param to address to receive the ownership of the given token ID
1157      * @param tokenId uint256 ID of the token to be transferred
1158      */
1159     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1160         //solhint-disable-next-line max-line-length
1161         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1162 
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev Safely transfers the ownership of a given token ID to another address
1168      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1169      * which is called upon a safe transfer, and return the magic value
1170      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1171      * the transfer is reverted.
1172      * Requires the msg.sender to be the owner, approved, or operator
1173      * @param from current owner of the token
1174      * @param to address to receive the ownership of the given token ID
1175      * @param tokenId uint256 ID of the token to be transferred
1176      */
1177     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1178         safeTransferFrom(from, to, tokenId, "");
1179     }
1180 
1181     /**
1182      * @dev Safely transfers the ownership of a given token ID to another address
1183      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1184      * which is called upon a safe transfer, and return the magic value
1185      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1186      * the transfer is reverted.
1187      * Requires the _msgSender() to be the owner, approved, or operator
1188      * @param from current owner of the token
1189      * @param to address to receive the ownership of the given token ID
1190      * @param tokenId uint256 ID of the token to be transferred
1191      * @param _data bytes data to send along with a safe transfer check
1192      */
1193     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1194         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1195         _safeTransfer(from, to, tokenId, _data);
1196     }
1197 
1198     /**
1199      * @dev Safely transfers the ownership of a given token ID to another address
1200      * If the target address is a contract, it must implement `onERC721Received`,
1201      * which is called upon a safe transfer, and return the magic value
1202      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1203      * the transfer is reverted.
1204      * Requires the msg.sender to be the owner, approved, or operator
1205      * @param from current owner of the token
1206      * @param to address to receive the ownership of the given token ID
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes data to send along with a safe transfer check
1209      */
1210     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1211         _transfer(from, to, tokenId);
1212         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1213     }
1214 
1215     /**
1216      * @dev Returns whether the specified token exists.
1217      * @param tokenId uint256 ID of the token to query the existence of
1218      * @return bool whether the token exists
1219      */
1220     function _exists(uint256 tokenId) internal view returns (bool) {
1221         return _tokenOwners.contains(tokenId);
1222     }
1223 
1224     /**
1225      * @dev Returns whether the given spender can transfer a given token ID.
1226      * @param spender address of the spender to query
1227      * @param tokenId uint256 ID of the token to be transferred
1228      * @return bool whether the msg.sender is approved for the given token ID,
1229      * is an operator of the owner, or is the owner of the token
1230      */
1231     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1232         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1233         address owner = ownerOf(tokenId);
1234         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1235     }
1236 
1237     /**
1238      * @dev Internal function to safely mint a new token.
1239      * Reverts if the given token ID already exists.
1240      * If the target address is a contract, it must implement `onERC721Received`,
1241      * which is called upon a safe transfer, and return the magic value
1242      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1243      * the transfer is reverted.
1244      * @param to The address that will own the minted token
1245      * @param tokenId uint256 ID of the token to be minted
1246      */
1247     function _safeMint(address to, uint256 tokenId) internal virtual {
1248         _safeMint(to, tokenId, "");
1249     }
1250 
1251     /**
1252      * @dev Internal function to safely mint a new token.
1253      * Reverts if the given token ID already exists.
1254      * If the target address is a contract, it must implement `onERC721Received`,
1255      * which is called upon a safe transfer, and return the magic value
1256      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1257      * the transfer is reverted.
1258      * @param to The address that will own the minted token
1259      * @param tokenId uint256 ID of the token to be minted
1260      * @param _data bytes data to send along with a safe transfer check
1261      */
1262     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1263         _mint(to, tokenId);
1264         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1265     }
1266 
1267     /**
1268      * @dev Internal function to mint a new token.
1269      * Reverts if the given token ID already exists.
1270      * @param to The address that will own the minted token
1271      * @param tokenId uint256 ID of the token to be minted
1272      */
1273     function _mint(address to, uint256 tokenId) internal virtual {
1274         require(to != address(0), "ERC721: mint to the zero address");
1275         require(!_exists(tokenId), "ERC721: token already minted");
1276 
1277         _beforeTokenTransfer(address(0), to, tokenId);
1278 
1279         _holderTokens[to].add(tokenId);
1280 
1281         _tokenOwners.set(tokenId, to);
1282 
1283         emit Transfer(address(0), to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev Internal function to burn a specific token.
1288      * Reverts if the token does not exist.
1289      * @param tokenId uint256 ID of the token being burned
1290      */
1291     function _burn(uint256 tokenId) internal virtual {
1292         address owner = ownerOf(tokenId);
1293 
1294         _beforeTokenTransfer(owner, address(0), tokenId);
1295 
1296         // Clear approvals
1297         _approve(address(0), tokenId);
1298 
1299         // Clear metadata (if any)
1300         if (bytes(_tokenURIs[tokenId]).length != 0) {
1301             delete _tokenURIs[tokenId];
1302         }
1303 
1304         _holderTokens[owner].remove(tokenId);
1305 
1306         _tokenOwners.remove(tokenId);
1307 
1308         emit Transfer(owner, address(0), tokenId);
1309     }
1310 
1311     /**
1312      * @dev Internal function to transfer ownership of a given token ID to another address.
1313      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1314      * @param from current owner of the token
1315      * @param to address to receive the ownership of the given token ID
1316      * @param tokenId uint256 ID of the token to be transferred
1317      */
1318     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1319         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1320         require(to != address(0), "ERC721: transfer to the zero address");
1321 
1322         _beforeTokenTransfer(from, to, tokenId);
1323 
1324         // Clear approvals from the previous owner
1325         _approve(address(0), tokenId);
1326 
1327         _holderTokens[from].remove(tokenId);
1328         _holderTokens[to].add(tokenId);
1329 
1330         _tokenOwners.set(tokenId, to);
1331 
1332         emit Transfer(from, to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev Internal function to set the token URI for a given token.
1337      *
1338      * Reverts if the token ID does not exist.
1339      *
1340      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1341      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1342      * it and save gas.
1343      */
1344     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1345         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1346         _tokenURIs[tokenId] = _tokenURI;
1347     }
1348 
1349     /**
1350      * @dev Internal function to set the base URI for all token IDs. It is
1351      * automatically added as a prefix to the value returned in {tokenURI},
1352      * or to the token ID if {tokenURI} is empty.
1353      */
1354     function _setBaseURI(string memory baseURI_) internal virtual {
1355         _baseURI = baseURI_;
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1360      * The call is not executed if the target address is not a contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1369         private returns (bool)
1370     {
1371         if (!to.isContract()) {
1372             return true;
1373         }
1374         // solhint-disable-next-line avoid-low-level-calls
1375         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1376             IERC721Receiver(to).onERC721Received.selector,
1377             _msgSender(),
1378             from,
1379             tokenId,
1380             _data
1381         ));
1382         if (!success) {
1383             if (returndata.length > 0) {
1384                 // solhint-disable-next-line no-inline-assembly
1385                 assembly {
1386                     let returndata_size := mload(returndata)
1387                     revert(add(32, returndata), returndata_size)
1388                 }
1389             } else {
1390                 revert("ERC721: transfer to non ERC721Receiver implementer");
1391             }
1392         } else {
1393             bytes4 retval = abi.decode(returndata, (bytes4));
1394             return (retval == _ERC721_RECEIVED);
1395         }
1396     }
1397 
1398     function _approve(address to, uint256 tokenId) private {
1399         _tokenApprovals[tokenId] = to;
1400         emit Approval(ownerOf(tokenId), to, tokenId);
1401     }
1402 
1403     /**
1404      * @dev Hook that is called before any token transfer. This includes minting
1405      * and burning.
1406      *
1407      * Calling conditions:
1408      *
1409      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1410      * transferred to `to`.
1411      * - when `from` is zero, `tokenId` will be minted for `to`.
1412      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1413      * - `from` and `to` are never both zero.
1414      *
1415      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1416      */
1417     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1418 }
1419 
1420 abstract contract  ZBMetadata is ERC165, ERC721  {
1421     // for the zoobc address field, we can check:
1422     // - length is 66
1423     // - first 3 chars match 'ZBC'
1424     // - the chars at indexes [3, 12, 21, 30, 39, 48, 57] match '_'
1425     // - all other chars are between A-Z or 2-7
1426 
1427     // for node public key, we check the same, except with prefix 'ZNK'
1428 
1429     // for genesis message, we require that user can only use [a-z, A-Z, 0-9, space]
1430 
1431     uint constant mask = 1 << 3 | 1 << 12 | 1 << 21 | 1 << 30 | 1 << 39 | 1 << 48 | 1 << 57;
1432 
1433     uint256 constant private accountAddressLength = 66;
1434     uint256 constant private nodePublicKeyLength = 66;
1435     uint256 constant private maxGenesisMessageLength = 100;
1436 
1437     struct Details {
1438         string    accountAddress;
1439         string    nodePublicKey;
1440         string    genesisMessage;
1441     }
1442 
1443 
1444     uint public lastModificationDate;
1445 
1446     // Optional mapping for token URIs
1447     mapping(uint256 => Details) private _tokenDetails;
1448     mapping(bytes32 => uint) public _allocatedAccountAddresses;
1449     mapping(bytes32 => uint) public _allocatedNodePublicKeys;
1450 
1451     modifier mValidAddress(string memory _address) {
1452         bool ok;
1453         bool zero;
1454         (ok,zero) = lengthOK(_address,accountAddressLength);
1455         if (!zero) {
1456             require(ok,"Account Address should be empty or 66 characters");
1457             require(matches(_address,0,"ZBC"),"Address should start with 'ZBC'");
1458             require(checkChars(_address,3),"Address should have '_' in positions [3, 12, 21, 30, 39, 48, 57], other chars A-Z or 2-7");
1459         } 
1460         _;
1461     }
1462     modifier mValidPubKey(string memory _key) {
1463         bool ok;
1464         bool zero;
1465         (ok,zero) = lengthOK(_key,nodePublicKeyLength);
1466         if (!zero) {
1467             require(ok,"Node Public Key should be empty or 66 characters");
1468             require(matches(_key,0,"ZNK"),"Address should start with 'ZNK'");
1469             require(checkChars(_key,3),"Address should have '_' in positions [3, 12, 21, 30, 39, 48, 57], other chars A-Z or 2-7");
1470         }
1471         _;
1472     }
1473     modifier mValidGenesis(string memory genesisMessage) {
1474         require(bytes(genesisMessage).length <= maxGenesisMessageLength,"Genesis Message is too long");
1475         require(alphaNumSpace(genesisMessage),"Only AlphaNumerics and spaces allowed in genesis message");
1476         _;
1477     }
1478 
1479     function lengthOK(string memory str, uint required) internal pure returns (bool ok, bool isZero) {
1480         uint len = bytes(str).length;
1481         ok = (len == required || len == 0);
1482         isZero = len == 0;
1483         return (ok,isZero);
1484     }
1485 
1486 
1487     function alphaNumSpace(string memory str) public pure returns (bool){
1488         bytes memory b = bytes(str);
1489 
1490         for(uint i; i<b.length; i++){
1491             bytes1 char = b[i];
1492             if(
1493                 !(char >= 0x30 && char <= 0x39) && //9-0
1494                 !(char >= 0x41 && char <= 0x5A) && //A-Z
1495                 !(char >= 0x61 && char <= 0x7A) && //a-z
1496                 !(char == 0x20) // <space>
1497             )
1498                 return false;
1499         }
1500         return true;
1501     }
1502 
1503     function matches(string memory haystack, uint pos, string memory needle ) internal pure returns (bool) {
1504         bytes memory hay = bytes(haystack);
1505         bytes memory ndl = bytes(needle);
1506         for (uint i = 0; i < ndl.length; i++) {
1507             if (hay[pos+i] != ndl[i]) return false;
1508         }
1509         return true;
1510     }
1511 
1512     function isBase32(byte b) internal pure returns (bool) {
1513         return (
1514             (b >= 0x32 && b <= 0x37) || //2-7
1515             (b >= 0x41 && b <= 0x5A)  //A-Z
1516         );
1517     }
1518     
1519     function checkChar(string memory haystack, uint i) internal pure returns (bool) {
1520         bytes memory hay = bytes(haystack);
1521          if (1 << i & mask != 0) {
1522             if (hay[i] != '_') return false;
1523         } else {
1524             // check valid chars
1525             if (!isBase32(hay[i])) return false;
1526         }
1527         return true;
1528     }
1529 
1530     function checkChars(string memory haystack, uint start) internal pure returns (bool) {
1531         for (uint i = start; i < bytes(haystack).length; i++) {
1532             if (!checkChar(haystack,i)) return false;
1533         }
1534         return true;
1535     }
1536 
1537     /**
1538     * @dev Returns an URI for a given token ID
1539     * Throws if the token ID does not exist. May return an empty string.
1540     * @param tokenId uint256 ID of the token to query
1541     */
1542     function tokenDetails(uint256 tokenId) internal view returns (Details memory) {
1543         require(_exists(tokenId),"token does not exist");
1544         return _tokenDetails[tokenId];
1545     }
1546 
1547     function makeURI(uint num) public pure returns (string memory) {
1548         bytes memory data = bytes("0000");
1549         uint16 val = uint16(num);
1550         for (int pos = 3; pos >=0; pos--) {
1551             data[uint(pos)] = byte(48 + uint8(val % 10));
1552             val /= 10;
1553         }
1554         return string(data);
1555     }
1556 
1557     /**
1558     * @dev Internal function to set the token URI for a given token
1559     * Reverts if the token ID does not exist
1560     * @param tokenId uint256 ID of the token to set its URI
1561     * @param accountAddress Address
1562     * @param nodePublicKey as requested
1563     * @param genesisMessage for
1564     */
1565     function setData(uint256 tokenId, string memory accountAddress, string memory nodePublicKey, string memory genesisMessage) public {
1566         require(msg.sender == ownerOf(tokenId),"unauthorised access");
1567         _setData(tokenId,accountAddress,nodePublicKey,genesisMessage);
1568     }
1569     
1570     function _setData(
1571         uint256 tokenId, 
1572         string memory accountAddress, 
1573         string memory nodePublicKey, 
1574         string memory genesisMessage) 
1575         internal 
1576         mValidAddress(accountAddress)
1577         mValidPubKey(nodePublicKey)
1578         mValidGenesis(genesisMessage)
1579     {
1580         require(_exists(tokenId),"Token ID does not exist");
1581         require(now <= lastModificationDate,"too late to change now"); // maybe just return? transfer?
1582         // require(bytes(genesisMessage).length <= maxGenesisMessageLength,"Genesis Message is too long");
1583         // require(alphaNumSpace(genesisMessage),"Only AlphaNumerics and spaces allowed in genesis message");
1584         Details storage thisTokenDetails = _tokenDetails[tokenId];
1585         // check that address is unique
1586         bytes32 oldAddressHash = keccak256(bytes(thisTokenDetails.accountAddress));
1587         _allocatedAccountAddresses[oldAddressHash] = 0;
1588         if (bytes(accountAddress).length != 0) {
1589             bytes32 hash = keccak256(bytes(accountAddress));
1590             require(_allocatedAccountAddresses[hash] == 0, "This accountAddress has already a token");
1591             _allocatedAccountAddresses[hash] = tokenId;
1592         }
1593         // check that nodePublicKey is unique
1594         bytes32 oldNodeHash = keccak256(bytes(thisTokenDetails.nodePublicKey));
1595         _allocatedNodePublicKeys[oldNodeHash] = 0;
1596         if (bytes(nodePublicKey).length != 0) {
1597             bytes32 hash = keccak256(bytes(nodePublicKey));
1598             require(_allocatedNodePublicKeys[hash] == 0, "This nodePublicKey has already a token");
1599             _allocatedNodePublicKeys[hash] = tokenId;
1600         }
1601         thisTokenDetails.accountAddress = accountAddress;
1602         thisTokenDetails.nodePublicKey = nodePublicKey;
1603         thisTokenDetails.genesisMessage = genesisMessage;
1604         //_tokenDetails[tokenId] = thisTokenDetails;
1605     }
1606 
1607     function getAccountAddress(uint256 tokenId) public view returns (string memory) {
1608         return tokenDetails(tokenId).accountAddress;
1609     }
1610     function getNodePublicKey(uint256 tokenId) public view returns (string memory) {
1611         return tokenDetails(tokenId).nodePublicKey;
1612     }
1613     function getGenesisMessage(uint256 tokenId) public view returns (string memory) {
1614         return tokenDetails(tokenId).genesisMessage;
1615     }
1616 
1617     function setAccountAddress(uint256 tokenId, string  memory _accountAddress) public {
1618         Details memory oldDetails = tokenDetails(tokenId);
1619         setData(tokenId,_accountAddress,oldDetails.nodePublicKey, oldDetails.genesisMessage);
1620     }
1621 
1622     function setAccountNodePublicKey(uint256 tokenId, string  memory _nodePublicKey) public {
1623         Details memory oldDetails = tokenDetails(tokenId);
1624         setData(tokenId,oldDetails.accountAddress,_nodePublicKey, oldDetails.genesisMessage);
1625     }
1626 
1627     function setAccountGenesisMessage(uint256 tokenId, string  memory _genesisMessage) public {
1628         Details memory oldDetails = tokenDetails(tokenId);
1629         setData(tokenId,oldDetails.accountAddress,oldDetails.nodePublicKey, _genesisMessage);
1630     }
1631 
1632     function canModify() public view returns (bool) {
1633         return now <= lastModificationDate;
1634     }
1635 
1636 }
1637 
1638 contract ZBCToken is ERC721, ZBMetadata {
1639 
1640     uint public MAX_ZB_TOKEN;
1641     uint private nextToken;
1642     uint public lastTransferDate;
1643     address private _creator = msg.sender;
1644     address private target;
1645 
1646     constructor (
1647         address _target,
1648         uint256 _lastModification,
1649         uint256 _lastTransfer,
1650         uint numTokens,
1651         string memory name,
1652         string memory symbol)
1653         public  ERC721(name,symbol)
1654     {
1655         require(_lastModification > _lastTransfer,"last mod must be after last transfer");
1656         require(_lastTransfer > now, "deadlines must be in the future");
1657         lastModificationDate = _lastModification;
1658         lastTransferDate = _lastTransfer;
1659         target = _target;
1660         MAX_ZB_TOKEN = numTokens;
1661         super._setBaseURI("https://zoobc.io/i/BZ");
1662     }
1663 
1664     function exists(uint256 tokenId) public view returns (bool){
1665         return super._exists(tokenId);
1666     }
1667 
1668     function allTokensMinted() public view returns (bool) {
1669         return (nextToken > MAX_ZB_TOKEN);
1670     }
1671 
1672 
1673     function mintBlankZBTokens(uint numTokens) public {
1674         require(msg.sender==_creator,"I'm sorry, you can't do that");
1675         require(!allTokensMinted(),"All the tokens are minted");
1676         uint numToMint = numTokens;
1677         if (numTokens + nextToken - 1 > MAX_ZB_TOKEN) {
1678             numToMint = MAX_ZB_TOKEN - nextToken + 1;
1679         }
1680         for (uint j = 0; j < numToMint; j++) {
1681             super._mint(target, nextToken);
1682             super._setTokenURI(nextToken,super.makeURI(nextToken));
1683             nextToken++;
1684         }
1685     }
1686 
1687 
1688 
1689     function _beforeTokenTransfer(address , address , uint256 tokenId) internal override {
1690         if (!super._exists(tokenId)) {
1691             return;
1692         }
1693         require(now <= lastTransferDate,"Tokens can no longer be transferred");
1694         super._setData(tokenId, "","","");
1695     }
1696 
1697     function canTransfer() public view returns (bool) {
1698         return now <= lastTransferDate;
1699     }
1700 
1701 }