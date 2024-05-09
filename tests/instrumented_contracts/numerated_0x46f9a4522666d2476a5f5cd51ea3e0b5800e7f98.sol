1 // Sources flattened with hardhat v2.0.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SignedSafeMath.sol@v3.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @title SignedSafeMath
11  * @dev Signed math operations with safety checks that revert on error.
12  */
13 library SignedSafeMath {
14     int256 constant private _INT256_MIN = -2**255;
15 
16         /**
17      * @dev Returns the multiplication of two signed integers, reverting on
18      * overflow.
19      *
20      * Counterpart to Solidity's `*` operator.
21      *
22      * Requirements:
23      *
24      * - Multiplication cannot overflow.
25      */
26     function mul(int256 a, int256 b) internal pure returns (int256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
35 
36         int256 c = a * b;
37         require(c / a == b, "SignedSafeMath: multiplication overflow");
38 
39         return c;
40     }
41 
42     /**
43      * @dev Returns the integer division of two signed integers. Reverts on
44      * division by zero. The result is rounded towards zero.
45      *
46      * Counterpart to Solidity's `/` operator. Note: this function uses a
47      * `revert` opcode (which leaves remaining gas untouched) while Solidity
48      * uses an invalid opcode to revert (consuming all remaining gas).
49      *
50      * Requirements:
51      *
52      * - The divisor cannot be zero.
53      */
54     function div(int256 a, int256 b) internal pure returns (int256) {
55         require(b != 0, "SignedSafeMath: division by zero");
56         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
57 
58         int256 c = a / b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the subtraction of two signed integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      *
71      * - Subtraction cannot overflow.
72      */
73     function sub(int256 a, int256 b) internal pure returns (int256) {
74         int256 c = a - b;
75         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the addition of two signed integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      *
88      * - Addition cannot overflow.
89      */
90     function add(int256 a, int256 b) internal pure returns (int256) {
91         int256 c = a + b;
92         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
93 
94         return c;
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.1.0
100 
101 
102 
103 pragma solidity ^0.6.0;
104 
105 /**
106  * @dev Library for managing an enumerable variant of Solidity's
107  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
108  * type.
109  *
110  * Maps have the following properties:
111  *
112  * - Entries are added, removed, and checked for existence in constant time
113  * (O(1)).
114  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
115  *
116  * ```
117  * contract Example {
118  *     // Add the library methods
119  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
120  *
121  *     // Declare a set state variable
122  *     EnumerableMap.UintToAddressMap private myMap;
123  * }
124  * ```
125  *
126  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
127  * supported.
128  */
129 library EnumerableMap {
130     // To implement this library for multiple types with as little code
131     // repetition as possible, we write it in terms of a generic Map type with
132     // bytes32 keys and values.
133     // The Map implementation uses private functions, and user-facing
134     // implementations (such as Uint256ToAddressMap) are just wrappers around
135     // the underlying Map.
136     // This means that we can only create new EnumerableMaps for types that fit
137     // in bytes32.
138 
139     struct MapEntry {
140         bytes32 _key;
141         bytes32 _value;
142     }
143 
144     struct Map {
145         // Storage of map keys and values
146         MapEntry[] _entries;
147 
148         // Position of the entry defined by a key in the `entries` array, plus 1
149         // because index 0 means a key is not in the map.
150         mapping (bytes32 => uint256) _indexes;
151     }
152 
153     /**
154      * @dev Adds a key-value pair to a map, or updates the value for an existing
155      * key. O(1).
156      *
157      * Returns true if the key was added to the map, that is if it was not
158      * already present.
159      */
160     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
161         // We read and store the key's index to prevent multiple reads from the same storage slot
162         uint256 keyIndex = map._indexes[key];
163 
164         if (keyIndex == 0) { // Equivalent to !contains(map, key)
165             map._entries.push(MapEntry({ _key: key, _value: value }));
166             // The entry is stored at length-1, but we add 1 to all indexes
167             // and use 0 as a sentinel value
168             map._indexes[key] = map._entries.length;
169             return true;
170         } else {
171             map._entries[keyIndex - 1]._value = value;
172             return false;
173         }
174     }
175 
176     /**
177      * @dev Removes a key-value pair from a map. O(1).
178      *
179      * Returns true if the key was removed from the map, that is if it was present.
180      */
181     function _remove(Map storage map, bytes32 key) private returns (bool) {
182         // We read and store the key's index to prevent multiple reads from the same storage slot
183         uint256 keyIndex = map._indexes[key];
184 
185         if (keyIndex != 0) { // Equivalent to contains(map, key)
186             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
187             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
188             // This modifies the order of the array, as noted in {at}.
189 
190             uint256 toDeleteIndex = keyIndex - 1;
191             uint256 lastIndex = map._entries.length - 1;
192 
193             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
194             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
195 
196             MapEntry storage lastEntry = map._entries[lastIndex];
197 
198             // Move the last entry to the index where the entry to delete is
199             map._entries[toDeleteIndex] = lastEntry;
200             // Update the index for the moved entry
201             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
202 
203             // Delete the slot where the moved entry was stored
204             map._entries.pop();
205 
206             // Delete the index for the deleted slot
207             delete map._indexes[key];
208 
209             return true;
210         } else {
211             return false;
212         }
213     }
214 
215     /**
216      * @dev Returns true if the key is in the map. O(1).
217      */
218     function _contains(Map storage map, bytes32 key) private view returns (bool) {
219         return map._indexes[key] != 0;
220     }
221 
222     /**
223      * @dev Returns the number of key-value pairs in the map. O(1).
224      */
225     function _length(Map storage map) private view returns (uint256) {
226         return map._entries.length;
227     }
228 
229    /**
230     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
231     *
232     * Note that there are no guarantees on the ordering of entries inside the
233     * array, and it may change when more entries are added or removed.
234     *
235     * Requirements:
236     *
237     * - `index` must be strictly less than {length}.
238     */
239     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
240         require(map._entries.length > index, "EnumerableMap: index out of bounds");
241 
242         MapEntry storage entry = map._entries[index];
243         return (entry._key, entry._value);
244     }
245 
246     /**
247      * @dev Returns the value associated with `key`.  O(1).
248      *
249      * Requirements:
250      *
251      * - `key` must be in the map.
252      */
253     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
254         return _get(map, key, "EnumerableMap: nonexistent key");
255     }
256 
257     /**
258      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
259      */
260     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
261         uint256 keyIndex = map._indexes[key];
262         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
263         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
264     }
265 
266     // UintToAddressMap
267 
268     struct UintToAddressMap {
269         Map _inner;
270     }
271 
272     /**
273      * @dev Adds a key-value pair to a map, or updates the value for an existing
274      * key. O(1).
275      *
276      * Returns true if the key was added to the map, that is if it was not
277      * already present.
278      */
279     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
280         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
281     }
282 
283     /**
284      * @dev Removes a value from a set. O(1).
285      *
286      * Returns true if the key was removed from the map, that is if it was present.
287      */
288     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
289         return _remove(map._inner, bytes32(key));
290     }
291 
292     /**
293      * @dev Returns true if the key is in the map. O(1).
294      */
295     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
296         return _contains(map._inner, bytes32(key));
297     }
298 
299     /**
300      * @dev Returns the number of elements in the map. O(1).
301      */
302     function length(UintToAddressMap storage map) internal view returns (uint256) {
303         return _length(map._inner);
304     }
305 
306    /**
307     * @dev Returns the element stored at position `index` in the set. O(1).
308     * Note that there are no guarantees on the ordering of values inside the
309     * array, and it may change when more values are added or removed.
310     *
311     * Requirements:
312     *
313     * - `index` must be strictly less than {length}.
314     */
315     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
316         (bytes32 key, bytes32 value) = _at(map._inner, index);
317         return (uint256(key), address(uint256(value)));
318     }
319 
320     /**
321      * @dev Returns the value associated with `key`.  O(1).
322      *
323      * Requirements:
324      *
325      * - `key` must be in the map.
326      */
327     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
328         return address(uint256(_get(map._inner, bytes32(key))));
329     }
330 
331     /**
332      * @dev Same as {get}, with a custom error message when `key` is not in the map.
333      */
334     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
335         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
336     }
337 }
338 
339 
340 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
341 
342 
343 
344 pragma solidity ^0.6.0;
345 
346 /*
347  * @dev Provides information about the current execution context, including the
348  * sender of the transaction and its data. While these are generally available
349  * via msg.sender and msg.data, they should not be accessed in such a direct
350  * manner, since when dealing with GSN meta-transactions the account sending and
351  * paying for execution may not be the actual sender (as far as an application
352  * is concerned).
353  *
354  * This contract is only required for intermediate, library-like contracts.
355  */
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address payable) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes memory) {
362         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
363         return msg.data;
364     }
365 }
366 
367 
368 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0
369 
370 
371 
372 pragma solidity ^0.6.0;
373 
374 /**
375  * @dev Interface of the ERC165 standard, as defined in the
376  * https://eips.ethereum.org/EIPS/eip-165[EIP].
377  *
378  * Implementers can declare support of contract interfaces, which can then be
379  * queried by others ({ERC165Checker}).
380  *
381  * For an implementation, see {ERC165}.
382  */
383 interface IERC165 {
384     /**
385      * @dev Returns true if this contract implements the interface defined by
386      * `interfaceId`. See the corresponding
387      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
388      * to learn more about how these ids are created.
389      *
390      * This function call must use less than 30 000 gas.
391      */
392     function supportsInterface(bytes4 interfaceId) external view returns (bool);
393 }
394 
395 
396 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.1.0
397 
398 
399 
400 pragma solidity ^0.6.2;
401 
402 /**
403  * @dev Required interface of an ERC721 compliant contract.
404  */
405 interface IERC721 is IERC165 {
406     /**
407      * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
413      */
414     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
415 
416     /**
417      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
418      */
419     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
420 
421     /**
422      * @dev Returns the number of tokens in ``owner``'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
437      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(address from, address to, uint256 tokenId) external;
450 
451     /**
452      * @dev Transfers `tokenId` token from `from` to `to`.
453      *
454      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(address from, address to, uint256 tokenId) external;
466 
467     /**
468      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
469      * The approval is cleared when the token is transferred.
470      *
471      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
472      *
473      * Requirements:
474      *
475      * - The caller must own the token or be an approved operator.
476      * - `tokenId` must exist.
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address to, uint256 tokenId) external;
481 
482     /**
483      * @dev Returns the account approved for `tokenId` token.
484      *
485      * Requirements:
486      *
487      * - `tokenId` must exist.
488      */
489     function getApproved(uint256 tokenId) external view returns (address operator);
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
494      *
495      * Requirements:
496      *
497      * - The `operator` cannot be the caller.
498      *
499      * Emits an {ApprovalForAll} event.
500      */
501     function setApprovalForAll(address operator, bool _approved) external;
502 
503     /**
504      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
505      *
506      * See {setApprovalForAll}
507      */
508     function isApprovedForAll(address owner, address operator) external view returns (bool);
509 
510     /**
511       * @dev Safely transfers `tokenId` token from `from` to `to`.
512       *
513       * Requirements:
514       *
515      * - `from` cannot be the zero address.
516      * - `to` cannot be the zero address.
517       * - `tokenId` token must exist and be owned by `from`.
518       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
519       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
520       *
521       * Emits a {Transfer} event.
522       */
523     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
524 }
525 
526 
527 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.1.0
528 
529 
530 
531 pragma solidity ^0.6.2;
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538 
539     /**
540      * @dev Returns the token collection name.
541      */
542     function name() external view returns (string memory);
543 
544     /**
545      * @dev Returns the token collection symbol.
546      */
547     function symbol() external view returns (string memory);
548 
549     /**
550      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
551      */
552     function tokenURI(uint256 tokenId) external view returns (string memory);
553 }
554 
555 
556 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.1.0
557 
558 
559 
560 pragma solidity ^0.6.2;
561 
562 /**
563  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
564  * @dev See https://eips.ethereum.org/EIPS/eip-721
565  */
566 interface IERC721Enumerable is IERC721 {
567 
568     /**
569      * @dev Returns the total amount of tokens stored by the contract.
570      */
571     function totalSupply() external view returns (uint256);
572 
573     /**
574      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
575      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
576      */
577     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
578 
579     /**
580      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
581      * Use along with {totalSupply} to enumerate all tokens.
582      */
583     function tokenByIndex(uint256 index) external view returns (uint256);
584 }
585 
586 
587 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.1.0
588 
589 
590 
591 pragma solidity ^0.6.0;
592 
593 /**
594  * @title ERC721 token receiver interface
595  * @dev Interface for any contract that wants to support safeTransfers
596  * from ERC721 asset contracts.
597  */
598 interface IERC721Receiver {
599     /**
600      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
601      * by `operator` from `from`, this function is called.
602      *
603      * It must return its Solidity selector to confirm the token transfer.
604      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
605      *
606      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
607      */
608     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
609     external returns (bytes4);
610 }
611 
612 
613 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0
614 
615 
616 
617 pragma solidity ^0.6.0;
618 
619 /**
620  * @dev Implementation of the {IERC165} interface.
621  *
622  * Contracts may inherit from this and call {_registerInterface} to declare
623  * their support of an interface.
624  */
625 contract ERC165 is IERC165 {
626     /*
627      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
628      */
629     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
630 
631     /**
632      * @dev Mapping of interface ids to whether or not it's supported.
633      */
634     mapping(bytes4 => bool) private _supportedInterfaces;
635 
636     constructor () internal {
637         // Derived contracts need only register support for their own interfaces,
638         // we register support for ERC165 itself here
639         _registerInterface(_INTERFACE_ID_ERC165);
640     }
641 
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      *
645      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
646      */
647     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
648         return _supportedInterfaces[interfaceId];
649     }
650 
651     /**
652      * @dev Registers the contract as an implementer of the interface defined by
653      * `interfaceId`. Support of the actual ERC165 interface is automatic and
654      * registering its interface id is not required.
655      *
656      * See {IERC165-supportsInterface}.
657      *
658      * Requirements:
659      *
660      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
661      */
662     function _registerInterface(bytes4 interfaceId) internal virtual {
663         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
664         _supportedInterfaces[interfaceId] = true;
665     }
666 }
667 
668 
669 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
670 
671 
672 
673 pragma solidity ^0.6.0;
674 
675 /**
676  * @dev Wrappers over Solidity's arithmetic operations with added overflow
677  * checks.
678  *
679  * Arithmetic operations in Solidity wrap on overflow. This can easily result
680  * in bugs, because programmers usually assume that an overflow raises an
681  * error, which is the standard behavior in high level programming languages.
682  * `SafeMath` restores this intuition by reverting the transaction when an
683  * operation overflows.
684  *
685  * Using this library instead of the unchecked operations eliminates an entire
686  * class of bugs, so it's recommended to use it always.
687  */
688 library SafeMath {
689     /**
690      * @dev Returns the addition of two unsigned integers, reverting on
691      * overflow.
692      *
693      * Counterpart to Solidity's `+` operator.
694      *
695      * Requirements:
696      *
697      * - Addition cannot overflow.
698      */
699     function add(uint256 a, uint256 b) internal pure returns (uint256) {
700         uint256 c = a + b;
701         require(c >= a, "SafeMath: addition overflow");
702 
703         return c;
704     }
705 
706     /**
707      * @dev Returns the subtraction of two unsigned integers, reverting on
708      * overflow (when the result is negative).
709      *
710      * Counterpart to Solidity's `-` operator.
711      *
712      * Requirements:
713      *
714      * - Subtraction cannot overflow.
715      */
716     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
717         return sub(a, b, "SafeMath: subtraction overflow");
718     }
719 
720     /**
721      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
722      * overflow (when the result is negative).
723      *
724      * Counterpart to Solidity's `-` operator.
725      *
726      * Requirements:
727      *
728      * - Subtraction cannot overflow.
729      */
730     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
731         require(b <= a, errorMessage);
732         uint256 c = a - b;
733 
734         return c;
735     }
736 
737     /**
738      * @dev Returns the multiplication of two unsigned integers, reverting on
739      * overflow.
740      *
741      * Counterpart to Solidity's `*` operator.
742      *
743      * Requirements:
744      *
745      * - Multiplication cannot overflow.
746      */
747     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
748         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
749         // benefit is lost if 'b' is also tested.
750         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
751         if (a == 0) {
752             return 0;
753         }
754 
755         uint256 c = a * b;
756         require(c / a == b, "SafeMath: multiplication overflow");
757 
758         return c;
759     }
760 
761     /**
762      * @dev Returns the integer division of two unsigned integers. Reverts on
763      * division by zero. The result is rounded towards zero.
764      *
765      * Counterpart to Solidity's `/` operator. Note: this function uses a
766      * `revert` opcode (which leaves remaining gas untouched) while Solidity
767      * uses an invalid opcode to revert (consuming all remaining gas).
768      *
769      * Requirements:
770      *
771      * - The divisor cannot be zero.
772      */
773     function div(uint256 a, uint256 b) internal pure returns (uint256) {
774         return div(a, b, "SafeMath: division by zero");
775     }
776 
777     /**
778      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
779      * division by zero. The result is rounded towards zero.
780      *
781      * Counterpart to Solidity's `/` operator. Note: this function uses a
782      * `revert` opcode (which leaves remaining gas untouched) while Solidity
783      * uses an invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
790         require(b > 0, errorMessage);
791         uint256 c = a / b;
792         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
793 
794         return c;
795     }
796 
797     /**
798      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
799      * Reverts when dividing by zero.
800      *
801      * Counterpart to Solidity's `%` operator. This function uses a `revert`
802      * opcode (which leaves remaining gas untouched) while Solidity uses an
803      * invalid opcode to revert (consuming all remaining gas).
804      *
805      * Requirements:
806      *
807      * - The divisor cannot be zero.
808      */
809     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
810         return mod(a, b, "SafeMath: modulo by zero");
811     }
812 
813     /**
814      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
815      * Reverts with custom message when dividing by zero.
816      *
817      * Counterpart to Solidity's `%` operator. This function uses a `revert`
818      * opcode (which leaves remaining gas untouched) while Solidity uses an
819      * invalid opcode to revert (consuming all remaining gas).
820      *
821      * Requirements:
822      *
823      * - The divisor cannot be zero.
824      */
825     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
826         require(b != 0, errorMessage);
827         return a % b;
828     }
829 }
830 
831 
832 // File @openzeppelin/contracts/utils/Address.sol@v3.1.0
833 
834 
835 
836 pragma solidity ^0.6.2;
837 
838 /**
839  * @dev Collection of functions related to the address type
840  */
841 library Address {
842     /**
843      * @dev Returns true if `account` is a contract.
844      *
845      * [IMPORTANT]
846      * ====
847      * It is unsafe to assume that an address for which this function returns
848      * false is an externally-owned account (EOA) and not a contract.
849      *
850      * Among others, `isContract` will return false for the following
851      * types of addresses:
852      *
853      *  - an externally-owned account
854      *  - a contract in construction
855      *  - an address where a contract will be created
856      *  - an address where a contract lived, but was destroyed
857      * ====
858      */
859     function isContract(address account) internal view returns (bool) {
860         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
861         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
862         // for accounts without code, i.e. `keccak256('')`
863         bytes32 codehash;
864         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
865         // solhint-disable-next-line no-inline-assembly
866         assembly { codehash := extcodehash(account) }
867         return (codehash != accountHash && codehash != 0x0);
868     }
869 
870     /**
871      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
872      * `recipient`, forwarding all available gas and reverting on errors.
873      *
874      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
875      * of certain opcodes, possibly making contracts go over the 2300 gas limit
876      * imposed by `transfer`, making them unable to receive funds via
877      * `transfer`. {sendValue} removes this limitation.
878      *
879      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
880      *
881      * IMPORTANT: because control is transferred to `recipient`, care must be
882      * taken to not create reentrancy vulnerabilities. Consider using
883      * {ReentrancyGuard} or the
884      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
885      */
886     function sendValue(address payable recipient, uint256 amount) internal {
887         require(address(this).balance >= amount, "Address: insufficient balance");
888 
889         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
890         (bool success, ) = recipient.call{ value: amount }("");
891         require(success, "Address: unable to send value, recipient may have reverted");
892     }
893 
894     /**
895      * @dev Performs a Solidity function call using a low level `call`. A
896      * plain`call` is an unsafe replacement for a function call: use this
897      * function instead.
898      *
899      * If `target` reverts with a revert reason, it is bubbled up by this
900      * function (like regular Solidity function calls).
901      *
902      * Returns the raw returned data. To convert to the expected return value,
903      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
904      *
905      * Requirements:
906      *
907      * - `target` must be a contract.
908      * - calling `target` with `data` must not revert.
909      *
910      * _Available since v3.1._
911      */
912     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
913       return functionCall(target, data, "Address: low-level call failed");
914     }
915 
916     /**
917      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
918      * `errorMessage` as a fallback revert reason when `target` reverts.
919      *
920      * _Available since v3.1._
921      */
922     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
923         return _functionCallWithValue(target, data, 0, errorMessage);
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
928      * but also transferring `value` wei to `target`.
929      *
930      * Requirements:
931      *
932      * - the calling contract must have an ETH balance of at least `value`.
933      * - the called Solidity function must be `payable`.
934      *
935      * _Available since v3.1._
936      */
937     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
938         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
939     }
940 
941     /**
942      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
943      * with `errorMessage` as a fallback revert reason when `target` reverts.
944      *
945      * _Available since v3.1._
946      */
947     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
948         require(address(this).balance >= value, "Address: insufficient balance for call");
949         return _functionCallWithValue(target, data, value, errorMessage);
950     }
951 
952     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
953         require(isContract(target), "Address: call to non-contract");
954 
955         // solhint-disable-next-line avoid-low-level-calls
956         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
957         if (success) {
958             return returndata;
959         } else {
960             // Look for revert reason and bubble it up if present
961             if (returndata.length > 0) {
962                 // The easiest way to bubble the revert reason is using memory via assembly
963 
964                 // solhint-disable-next-line no-inline-assembly
965                 assembly {
966                     let returndata_size := mload(returndata)
967                     revert(add(32, returndata), returndata_size)
968                 }
969             } else {
970                 revert(errorMessage);
971             }
972         }
973     }
974 }
975 
976 
977 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.1.0
978 
979 
980 
981 pragma solidity ^0.6.0;
982 
983 /**
984  * @dev Library for managing
985  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
986  * types.
987  *
988  * Sets have the following properties:
989  *
990  * - Elements are added, removed, and checked for existence in constant time
991  * (O(1)).
992  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
993  *
994  * ```
995  * contract Example {
996  *     // Add the library methods
997  *     using EnumerableSet for EnumerableSet.AddressSet;
998  *
999  *     // Declare a set state variable
1000  *     EnumerableSet.AddressSet private mySet;
1001  * }
1002  * ```
1003  *
1004  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1005  * (`UintSet`) are supported.
1006  */
1007 library EnumerableSet {
1008     // To implement this library for multiple types with as little code
1009     // repetition as possible, we write it in terms of a generic Set type with
1010     // bytes32 values.
1011     // The Set implementation uses private functions, and user-facing
1012     // implementations (such as AddressSet) are just wrappers around the
1013     // underlying Set.
1014     // This means that we can only create new EnumerableSets for types that fit
1015     // in bytes32.
1016 
1017     struct Set {
1018         // Storage of set values
1019         bytes32[] _values;
1020 
1021         // Position of the value in the `values` array, plus 1 because index 0
1022         // means a value is not in the set.
1023         mapping (bytes32 => uint256) _indexes;
1024     }
1025 
1026     /**
1027      * @dev Add a value to a set. O(1).
1028      *
1029      * Returns true if the value was added to the set, that is if it was not
1030      * already present.
1031      */
1032     function _add(Set storage set, bytes32 value) private returns (bool) {
1033         if (!_contains(set, value)) {
1034             set._values.push(value);
1035             // The value is stored at length-1, but we add 1 to all indexes
1036             // and use 0 as a sentinel value
1037             set._indexes[value] = set._values.length;
1038             return true;
1039         } else {
1040             return false;
1041         }
1042     }
1043 
1044     /**
1045      * @dev Removes a value from a set. O(1).
1046      *
1047      * Returns true if the value was removed from the set, that is if it was
1048      * present.
1049      */
1050     function _remove(Set storage set, bytes32 value) private returns (bool) {
1051         // We read and store the value's index to prevent multiple reads from the same storage slot
1052         uint256 valueIndex = set._indexes[value];
1053 
1054         if (valueIndex != 0) { // Equivalent to contains(set, value)
1055             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1056             // the array, and then remove the last element (sometimes called as 'swap and pop').
1057             // This modifies the order of the array, as noted in {at}.
1058 
1059             uint256 toDeleteIndex = valueIndex - 1;
1060             uint256 lastIndex = set._values.length - 1;
1061 
1062             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1063             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1064 
1065             bytes32 lastvalue = set._values[lastIndex];
1066 
1067             // Move the last value to the index where the value to delete is
1068             set._values[toDeleteIndex] = lastvalue;
1069             // Update the index for the moved value
1070             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1071 
1072             // Delete the slot where the moved value was stored
1073             set._values.pop();
1074 
1075             // Delete the index for the deleted slot
1076             delete set._indexes[value];
1077 
1078             return true;
1079         } else {
1080             return false;
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns true if the value is in the set. O(1).
1086      */
1087     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1088         return set._indexes[value] != 0;
1089     }
1090 
1091     /**
1092      * @dev Returns the number of values on the set. O(1).
1093      */
1094     function _length(Set storage set) private view returns (uint256) {
1095         return set._values.length;
1096     }
1097 
1098    /**
1099     * @dev Returns the value stored at position `index` in the set. O(1).
1100     *
1101     * Note that there are no guarantees on the ordering of values inside the
1102     * array, and it may change when more values are added or removed.
1103     *
1104     * Requirements:
1105     *
1106     * - `index` must be strictly less than {length}.
1107     */
1108     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1109         require(set._values.length > index, "EnumerableSet: index out of bounds");
1110         return set._values[index];
1111     }
1112 
1113     // AddressSet
1114 
1115     struct AddressSet {
1116         Set _inner;
1117     }
1118 
1119     /**
1120      * @dev Add a value to a set. O(1).
1121      *
1122      * Returns true if the value was added to the set, that is if it was not
1123      * already present.
1124      */
1125     function add(AddressSet storage set, address value) internal returns (bool) {
1126         return _add(set._inner, bytes32(uint256(value)));
1127     }
1128 
1129     /**
1130      * @dev Removes a value from a set. O(1).
1131      *
1132      * Returns true if the value was removed from the set, that is if it was
1133      * present.
1134      */
1135     function remove(AddressSet storage set, address value) internal returns (bool) {
1136         return _remove(set._inner, bytes32(uint256(value)));
1137     }
1138 
1139     /**
1140      * @dev Returns true if the value is in the set. O(1).
1141      */
1142     function contains(AddressSet storage set, address value) internal view returns (bool) {
1143         return _contains(set._inner, bytes32(uint256(value)));
1144     }
1145 
1146     /**
1147      * @dev Returns the number of values in the set. O(1).
1148      */
1149     function length(AddressSet storage set) internal view returns (uint256) {
1150         return _length(set._inner);
1151     }
1152 
1153    /**
1154     * @dev Returns the value stored at position `index` in the set. O(1).
1155     *
1156     * Note that there are no guarantees on the ordering of values inside the
1157     * array, and it may change when more values are added or removed.
1158     *
1159     * Requirements:
1160     *
1161     * - `index` must be strictly less than {length}.
1162     */
1163     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1164         return address(uint256(_at(set._inner, index)));
1165     }
1166 
1167 
1168     // UintSet
1169 
1170     struct UintSet {
1171         Set _inner;
1172     }
1173 
1174     /**
1175      * @dev Add a value to a set. O(1).
1176      *
1177      * Returns true if the value was added to the set, that is if it was not
1178      * already present.
1179      */
1180     function add(UintSet storage set, uint256 value) internal returns (bool) {
1181         return _add(set._inner, bytes32(value));
1182     }
1183 
1184     /**
1185      * @dev Removes a value from a set. O(1).
1186      *
1187      * Returns true if the value was removed from the set, that is if it was
1188      * present.
1189      */
1190     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1191         return _remove(set._inner, bytes32(value));
1192     }
1193 
1194     /**
1195      * @dev Returns true if the value is in the set. O(1).
1196      */
1197     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1198         return _contains(set._inner, bytes32(value));
1199     }
1200 
1201     /**
1202      * @dev Returns the number of values on the set. O(1).
1203      */
1204     function length(UintSet storage set) internal view returns (uint256) {
1205         return _length(set._inner);
1206     }
1207 
1208    /**
1209     * @dev Returns the value stored at position `index` in the set. O(1).
1210     *
1211     * Note that there are no guarantees on the ordering of values inside the
1212     * array, and it may change when more values are added or removed.
1213     *
1214     * Requirements:
1215     *
1216     * - `index` must be strictly less than {length}.
1217     */
1218     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1219         return uint256(_at(set._inner, index));
1220     }
1221 }
1222 
1223 
1224 // File @openzeppelin/contracts/utils/Strings.sol@v3.1.0
1225 
1226 
1227 
1228 pragma solidity ^0.6.0;
1229 
1230 /**
1231  * @dev String operations.
1232  */
1233 library Strings {
1234     /**
1235      * @dev Converts a `uint256` to its ASCII `string` representation.
1236      */
1237     function toString(uint256 value) internal pure returns (string memory) {
1238         // Inspired by OraclizeAPI's implementation - MIT licence
1239         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1240 
1241         if (value == 0) {
1242             return "0";
1243         }
1244         uint256 temp = value;
1245         uint256 digits;
1246         while (temp != 0) {
1247             digits++;
1248             temp /= 10;
1249         }
1250         bytes memory buffer = new bytes(digits);
1251         uint256 index = digits - 1;
1252         temp = value;
1253         while (temp != 0) {
1254             buffer[index--] = byte(uint8(48 + temp % 10));
1255             temp /= 10;
1256         }
1257         return string(buffer);
1258     }
1259 }
1260 
1261 
1262 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.1.0
1263 
1264 
1265 
1266 pragma solidity ^0.6.0;
1267 
1268 
1269 
1270 
1271 
1272 
1273 
1274 
1275 
1276 
1277 
1278 /**
1279  * @title ERC721 Non-Fungible Token Standard basic implementation
1280  * @dev see https://eips.ethereum.org/EIPS/eip-721
1281  */
1282 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1283     using SafeMath for uint256;
1284     using Address for address;
1285     using EnumerableSet for EnumerableSet.UintSet;
1286     using EnumerableMap for EnumerableMap.UintToAddressMap;
1287     using Strings for uint256;
1288 
1289     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1290     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1291     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1292 
1293     // Mapping from holder address to their (enumerable) set of owned tokens
1294     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1295 
1296     // Enumerable mapping from token ids to their owners
1297     EnumerableMap.UintToAddressMap private _tokenOwners;
1298 
1299     // Mapping from token ID to approved address
1300     mapping (uint256 => address) private _tokenApprovals;
1301 
1302     // Mapping from owner to operator approvals
1303     mapping (address => mapping (address => bool)) private _operatorApprovals;
1304 
1305     // Token name
1306     string private _name;
1307 
1308     // Token symbol
1309     string private _symbol;
1310 
1311     // Optional mapping for token URIs
1312     mapping(uint256 => string) private _tokenURIs;
1313 
1314     // Base URI
1315     string private _baseURI;
1316 
1317     /*
1318      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1319      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1320      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1321      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1322      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1323      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1324      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1325      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1326      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1327      *
1328      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1329      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1330      */
1331     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1332 
1333     /*
1334      *     bytes4(keccak256('name()')) == 0x06fdde03
1335      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1336      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1337      *
1338      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1339      */
1340     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1341 
1342     /*
1343      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1344      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1345      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1346      *
1347      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1348      */
1349     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1350 
1351     /**
1352      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1353      */
1354     constructor (string memory name, string memory symbol) public {
1355         _name = name;
1356         _symbol = symbol;
1357 
1358         // register the supported interfaces to conform to ERC721 via ERC165
1359         _registerInterface(_INTERFACE_ID_ERC721);
1360         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1361         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-balanceOf}.
1366      */
1367     function balanceOf(address owner) public view override returns (uint256) {
1368         require(owner != address(0), "ERC721: balance query for the zero address");
1369 
1370         return _holderTokens[owner].length();
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-ownerOf}.
1375      */
1376     function ownerOf(uint256 tokenId) public view override returns (address) {
1377         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1378     }
1379 
1380     /**
1381      * @dev See {IERC721Metadata-name}.
1382      */
1383     function name() public view override returns (string memory) {
1384         return _name;
1385     }
1386 
1387     /**
1388      * @dev See {IERC721Metadata-symbol}.
1389      */
1390     function symbol() public view override returns (string memory) {
1391         return _symbol;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-tokenURI}.
1396      */
1397     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1398         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1399 
1400         string memory _tokenURI = _tokenURIs[tokenId];
1401 
1402         // If there is no base URI, return the token URI.
1403         if (bytes(_baseURI).length == 0) {
1404             return _tokenURI;
1405         }
1406         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1407         if (bytes(_tokenURI).length > 0) {
1408             return string(abi.encodePacked(_baseURI, _tokenURI));
1409         }
1410         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1411         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1412     }
1413 
1414     /**
1415     * @dev Returns the base URI set via {_setBaseURI}. This will be
1416     * automatically added as a prefix in {tokenURI} to each token's URI, or
1417     * to the token ID if no specific URI is set for that token ID.
1418     */
1419     function baseURI() public view returns (string memory) {
1420         return _baseURI;
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1425      */
1426     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1427         return _holderTokens[owner].at(index);
1428     }
1429 
1430     /**
1431      * @dev See {IERC721Enumerable-totalSupply}.
1432      */
1433     function totalSupply() public view override returns (uint256) {
1434         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1435         return _tokenOwners.length();
1436     }
1437 
1438     /**
1439      * @dev See {IERC721Enumerable-tokenByIndex}.
1440      */
1441     function tokenByIndex(uint256 index) public view override returns (uint256) {
1442         (uint256 tokenId, ) = _tokenOwners.at(index);
1443         return tokenId;
1444     }
1445 
1446     /**
1447      * @dev See {IERC721-approve}.
1448      */
1449     function approve(address to, uint256 tokenId) public virtual override {
1450         address owner = ownerOf(tokenId);
1451         require(to != owner, "ERC721: approval to current owner");
1452 
1453         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1454             "ERC721: approve caller is not owner nor approved for all"
1455         );
1456 
1457         _approve(to, tokenId);
1458     }
1459 
1460     /**
1461      * @dev See {IERC721-getApproved}.
1462      */
1463     function getApproved(uint256 tokenId) public view override returns (address) {
1464         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1465 
1466         return _tokenApprovals[tokenId];
1467     }
1468 
1469     /**
1470      * @dev See {IERC721-setApprovalForAll}.
1471      */
1472     function setApprovalForAll(address operator, bool approved) public virtual override {
1473         require(operator != _msgSender(), "ERC721: approve to caller");
1474 
1475         _operatorApprovals[_msgSender()][operator] = approved;
1476         emit ApprovalForAll(_msgSender(), operator, approved);
1477     }
1478 
1479     /**
1480      * @dev See {IERC721-isApprovedForAll}.
1481      */
1482     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1483         return _operatorApprovals[owner][operator];
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-transferFrom}.
1488      */
1489     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1490         //solhint-disable-next-line max-line-length
1491         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1492 
1493         _transfer(from, to, tokenId);
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-safeTransferFrom}.
1498      */
1499     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1500         safeTransferFrom(from, to, tokenId, "");
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-safeTransferFrom}.
1505      */
1506     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1507         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1508         _safeTransfer(from, to, tokenId, _data);
1509     }
1510 
1511     /**
1512      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1513      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1514      *
1515      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1516      *
1517      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1518      * implement alternative mecanisms to perform token transfer, such as signature-based.
1519      *
1520      * Requirements:
1521      *
1522      * - `from` cannot be the zero address.
1523      * - `to` cannot be the zero address.
1524      * - `tokenId` token must exist and be owned by `from`.
1525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1526      *
1527      * Emits a {Transfer} event.
1528      */
1529     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1530         _transfer(from, to, tokenId);
1531         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1532     }
1533 
1534     /**
1535      * @dev Returns whether `tokenId` exists.
1536      *
1537      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1538      *
1539      * Tokens start existing when they are minted (`_mint`),
1540      * and stop existing when they are burned (`_burn`).
1541      */
1542     function _exists(uint256 tokenId) internal view returns (bool) {
1543         return _tokenOwners.contains(tokenId);
1544     }
1545 
1546     /**
1547      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1548      *
1549      * Requirements:
1550      *
1551      * - `tokenId` must exist.
1552      */
1553     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1554         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1555         address owner = ownerOf(tokenId);
1556         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1557     }
1558 
1559     /**
1560      * @dev Safely mints `tokenId` and transfers it to `to`.
1561      *
1562      * Requirements:
1563      d*
1564      * - `tokenId` must not exist.
1565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1566      *
1567      * Emits a {Transfer} event.
1568      */
1569     function _safeMint(address to, uint256 tokenId) internal virtual {
1570         _safeMint(to, tokenId, "");
1571     }
1572 
1573     /**
1574      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1575      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1576      */
1577     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1578         _mint(to, tokenId);
1579         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1580     }
1581 
1582     /**
1583      * @dev Mints `tokenId` and transfers it to `to`.
1584      *
1585      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1586      *
1587      * Requirements:
1588      *
1589      * - `tokenId` must not exist.
1590      * - `to` cannot be the zero address.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _mint(address to, uint256 tokenId) internal virtual {
1595         require(to != address(0), "ERC721: mint to the zero address");
1596         require(!_exists(tokenId), "ERC721: token already minted");
1597 
1598         _beforeTokenTransfer(address(0), to, tokenId);
1599 
1600         _holderTokens[to].add(tokenId);
1601 
1602         _tokenOwners.set(tokenId, to);
1603 
1604         emit Transfer(address(0), to, tokenId);
1605     }
1606 
1607     /**
1608      * @dev Destroys `tokenId`.
1609      * The approval is cleared when the token is burned.
1610      *
1611      * Requirements:
1612      *
1613      * - `tokenId` must exist.
1614      *
1615      * Emits a {Transfer} event.
1616      */
1617     function _burn(uint256 tokenId) internal virtual {
1618         address owner = ownerOf(tokenId);
1619 
1620         _beforeTokenTransfer(owner, address(0), tokenId);
1621 
1622         // Clear approvals
1623         _approve(address(0), tokenId);
1624 
1625         // Clear metadata (if any)
1626         if (bytes(_tokenURIs[tokenId]).length != 0) {
1627             delete _tokenURIs[tokenId];
1628         }
1629 
1630         _holderTokens[owner].remove(tokenId);
1631 
1632         _tokenOwners.remove(tokenId);
1633 
1634         emit Transfer(owner, address(0), tokenId);
1635     }
1636 
1637     /**
1638      * @dev Transfers `tokenId` from `from` to `to`.
1639      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1640      *
1641      * Requirements:
1642      *
1643      * - `to` cannot be the zero address.
1644      * - `tokenId` token must be owned by `from`.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1649         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1650         require(to != address(0), "ERC721: transfer to the zero address");
1651 
1652         _beforeTokenTransfer(from, to, tokenId);
1653 
1654         // Clear approvals from the previous owner
1655         _approve(address(0), tokenId);
1656 
1657         _holderTokens[from].remove(tokenId);
1658         _holderTokens[to].add(tokenId);
1659 
1660         _tokenOwners.set(tokenId, to);
1661 
1662         emit Transfer(from, to, tokenId);
1663     }
1664 
1665     /**
1666      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must exist.
1671      */
1672     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1673         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1674         _tokenURIs[tokenId] = _tokenURI;
1675     }
1676 
1677     /**
1678      * @dev Internal function to set the base URI for all token IDs. It is
1679      * automatically added as a prefix to the value returned in {tokenURI},
1680      * or to the token ID if {tokenURI} is empty.
1681      */
1682     function _setBaseURI(string memory baseURI_) internal virtual {
1683         _baseURI = baseURI_;
1684     }
1685 
1686     /**
1687      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1688      * The call is not executed if the target address is not a contract.
1689      *
1690      * @param from address representing the previous owner of the given token ID
1691      * @param to target address that will receive the tokens
1692      * @param tokenId uint256 ID of the token to be transferred
1693      * @param _data bytes optional data to send along with the call
1694      * @return bool whether the call correctly returned the expected magic value
1695      */
1696     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1697         private returns (bool)
1698     {
1699         if (!to.isContract()) {
1700             return true;
1701         }
1702         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1703             IERC721Receiver(to).onERC721Received.selector,
1704             _msgSender(),
1705             from,
1706             tokenId,
1707             _data
1708         ), "ERC721: transfer to non ERC721Receiver implementer");
1709         bytes4 retval = abi.decode(returndata, (bytes4));
1710         return (retval == _ERC721_RECEIVED);
1711     }
1712 
1713     function _approve(address to, uint256 tokenId) private {
1714         _tokenApprovals[tokenId] = to;
1715         emit Approval(ownerOf(tokenId), to, tokenId);
1716     }
1717 
1718     /**
1719      * @dev Hook that is called before any token transfer. This includes minting
1720      * and burning.
1721      *
1722      * Calling conditions:
1723      *
1724      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1725      * transferred to `to`.
1726      * - When `from` is zero, `tokenId` will be minted for `to`.
1727      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1728      * - `from` cannot be the zero address.
1729      * - `to` cannot be the zero address.
1730      *
1731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1732      */
1733     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1734 }
1735 
1736 
1737 // File @openzeppelin/contracts/access/AccessControl.sol@v3.1.0
1738 
1739 
1740 
1741 pragma solidity ^0.6.0;
1742 
1743 
1744 
1745 /**
1746  * @dev Contract module that allows children to implement role-based access
1747  * control mechanisms.
1748  *
1749  * Roles are referred to by their `bytes32` identifier. These should be exposed
1750  * in the external API and be unique. The best way to achieve this is by
1751  * using `public constant` hash digests:
1752  *
1753  * ```
1754  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1755  * ```
1756  *
1757  * Roles can be used to represent a set of permissions. To restrict access to a
1758  * function call, use {hasRole}:
1759  *
1760  * ```
1761  * function foo() public {
1762  *     require(hasRole(MY_ROLE, msg.sender));
1763  *     ...
1764  * }
1765  * ```
1766  *
1767  * Roles can be granted and revoked dynamically via the {grantRole} and
1768  * {revokeRole} functions. Each role has an associated admin role, and only
1769  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1770  *
1771  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1772  * that only accounts with this role will be able to grant or revoke other
1773  * roles. More complex role relationships can be created by using
1774  * {_setRoleAdmin}.
1775  *
1776  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1777  * grant and revoke this role. Extra precautions should be taken to secure
1778  * accounts that have been granted it.
1779  */
1780 abstract contract AccessControl is Context {
1781     using EnumerableSet for EnumerableSet.AddressSet;
1782     using Address for address;
1783 
1784     struct RoleData {
1785         EnumerableSet.AddressSet members;
1786         bytes32 adminRole;
1787     }
1788 
1789     mapping (bytes32 => RoleData) private _roles;
1790 
1791     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1792 
1793     /**
1794      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1795      *
1796      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1797      * {RoleAdminChanged} not being emitted signaling this.
1798      *
1799      * _Available since v3.1._
1800      */
1801     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1802 
1803     /**
1804      * @dev Emitted when `account` is granted `role`.
1805      *
1806      * `sender` is the account that originated the contract call, an admin role
1807      * bearer except when using {_setupRole}.
1808      */
1809     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1810 
1811     /**
1812      * @dev Emitted when `account` is revoked `role`.
1813      *
1814      * `sender` is the account that originated the contract call:
1815      *   - if using `revokeRole`, it is the admin role bearer
1816      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1817      */
1818     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1819 
1820     /**
1821      * @dev Returns `true` if `account` has been granted `role`.
1822      */
1823     function hasRole(bytes32 role, address account) public view returns (bool) {
1824         return _roles[role].members.contains(account);
1825     }
1826 
1827     /**
1828      * @dev Returns the number of accounts that have `role`. Can be used
1829      * together with {getRoleMember} to enumerate all bearers of a role.
1830      */
1831     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1832         return _roles[role].members.length();
1833     }
1834 
1835     /**
1836      * @dev Returns one of the accounts that have `role`. `index` must be a
1837      * value between 0 and {getRoleMemberCount}, non-inclusive.
1838      *
1839      * Role bearers are not sorted in any particular way, and their ordering may
1840      * change at any point.
1841      *
1842      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1843      * you perform all queries on the same block. See the following
1844      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1845      * for more information.
1846      */
1847     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1848         return _roles[role].members.at(index);
1849     }
1850 
1851     /**
1852      * @dev Returns the admin role that controls `role`. See {grantRole} and
1853      * {revokeRole}.
1854      *
1855      * To change a role's admin, use {_setRoleAdmin}.
1856      */
1857     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1858         return _roles[role].adminRole;
1859     }
1860 
1861     /**
1862      * @dev Grants `role` to `account`.
1863      *
1864      * If `account` had not been already granted `role`, emits a {RoleGranted}
1865      * event.
1866      *
1867      * Requirements:
1868      *
1869      * - the caller must have ``role``'s admin role.
1870      */
1871     function grantRole(bytes32 role, address account) public virtual {
1872         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1873 
1874         _grantRole(role, account);
1875     }
1876 
1877     /**
1878      * @dev Revokes `role` from `account`.
1879      *
1880      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1881      *
1882      * Requirements:
1883      *
1884      * - the caller must have ``role``'s admin role.
1885      */
1886     function revokeRole(bytes32 role, address account) public virtual {
1887         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1888 
1889         _revokeRole(role, account);
1890     }
1891 
1892     /**
1893      * @dev Revokes `role` from the calling account.
1894      *
1895      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1896      * purpose is to provide a mechanism for accounts to lose their privileges
1897      * if they are compromised (such as when a trusted device is misplaced).
1898      *
1899      * If the calling account had been granted `role`, emits a {RoleRevoked}
1900      * event.
1901      *
1902      * Requirements:
1903      *
1904      * - the caller must be `account`.
1905      */
1906     function renounceRole(bytes32 role, address account) public virtual {
1907         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1908 
1909         _revokeRole(role, account);
1910     }
1911 
1912     /**
1913      * @dev Grants `role` to `account`.
1914      *
1915      * If `account` had not been already granted `role`, emits a {RoleGranted}
1916      * event. Note that unlike {grantRole}, this function doesn't perform any
1917      * checks on the calling account.
1918      *
1919      * [WARNING]
1920      * ====
1921      * This function should only be called from the constructor when setting
1922      * up the initial roles for the system.
1923      *
1924      * Using this function in any other way is effectively circumventing the admin
1925      * system imposed by {AccessControl}.
1926      * ====
1927      */
1928     function _setupRole(bytes32 role, address account) internal virtual {
1929         _grantRole(role, account);
1930     }
1931 
1932     /**
1933      * @dev Sets `adminRole` as ``role``'s admin role.
1934      *
1935      * Emits a {RoleAdminChanged} event.
1936      */
1937     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1938         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1939         _roles[role].adminRole = adminRole;
1940     }
1941 
1942     function _grantRole(bytes32 role, address account) private {
1943         if (_roles[role].members.add(account)) {
1944             emit RoleGranted(role, account, _msgSender());
1945         }
1946     }
1947 
1948     function _revokeRole(bytes32 role, address account) private {
1949         if (_roles[role].members.remove(account)) {
1950             emit RoleRevoked(role, account, _msgSender());
1951         }
1952     }
1953 }
1954 
1955 
1956 // File @openzeppelin/contracts/utils/Counters.sol@v3.1.0
1957 
1958 
1959 
1960 pragma solidity ^0.6.0;
1961 
1962 /**
1963  * @title Counters
1964  * @author Matt Condon (@shrugs)
1965  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1966  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1967  *
1968  * Include with `using Counters for Counters.Counter;`
1969  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1970  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1971  * directly accessed.
1972  */
1973 library Counters {
1974     using SafeMath for uint256;
1975 
1976     struct Counter {
1977         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1978         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1979         // this feature: see https://github.com/ethereum/solidity/issues/4637
1980         uint256 _value; // default: 0
1981     }
1982 
1983     function current(Counter storage counter) internal view returns (uint256) {
1984         return counter._value;
1985     }
1986 
1987     function increment(Counter storage counter) internal {
1988         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1989         counter._value += 1;
1990     }
1991 
1992     function decrement(Counter storage counter) internal {
1993         counter._value = counter._value.sub(1);
1994     }
1995 }
1996 
1997 
1998 // File contracts/structs/TinyBox.sol
1999 
2000 
2001 pragma solidity ^0.6.4;
2002 
2003 struct TinyBox {
2004     uint128 randomness;
2005     uint16 hue;
2006     uint8 saturation;
2007     uint8 lightness;
2008     uint8 shapes;
2009     uint8 hatching;
2010     uint8 widthMin;
2011     uint8 widthMax;
2012     uint8 heightMin;
2013     uint8 heightMax;
2014     uint8 spread;
2015     uint8 grid;
2016     uint8 mirroring;
2017     uint8 bkg; // bkg shade/transparent setting default
2018     uint8 duration; // animation duration default
2019     uint8 options; // 8 boolean values packed - 0th is the animate flag
2020 }
2021 
2022 
2023 // File contracts/libraries/FixidityLib.sol
2024 
2025 
2026 pragma solidity ^0.6.8;
2027 
2028 /**
2029  * @title FixidityLib
2030  * @author Gadi Guy, Alberto Cuesta Canada
2031  * @notice This library provides fixed point arithmetic with protection against
2032  * overflow. 
2033  * All operations are done with int256 and the operands must have been created 
2034  * with any of the newFrom* functions, which shift the comma digits() to the 
2035  * right and check for limits.
2036  * When using this library be sure of using maxNewFixed() as the upper limit for
2037  * creation of fixed point numbers. Use maxFixedMul(), maxFixedDiv() and
2038  * maxFixedAdd() if you want to be certain that those operations don't 
2039  * overflow.
2040  */
2041     library FixidityLib {
2042 
2043     /**
2044      * @notice Number of positions that the comma is shifted to the right.
2045      */
2046     function digits() public pure returns(uint8) {
2047         return 24;
2048     }
2049     
2050     /**
2051      * @notice This is 1 in the fixed point units used in this library.
2052      * @dev Test fixed1() equals 10^digits()
2053      * Hardcoded to 24 digits.
2054      */
2055     function fixed1() public pure returns(int256) {
2056         return 1000000000000000000000000;
2057     }
2058 
2059     /**
2060      * @notice The amount of decimals lost on each multiplication operand.
2061      * @dev Test mulPrecision() equals sqrt(fixed1)
2062      * Hardcoded to 24 digits.
2063      */
2064     function mulPrecision() public pure returns(int256) {
2065         return 1000000000000;
2066     }
2067 
2068     /**
2069      * @notice Maximum value that can be represented in an int256
2070      * @dev Test maxInt256() equals 2^255 -1
2071      */
2072     function maxInt256() public pure returns(int256) {
2073         return 57896044618658097711785492504343953926634992332820282019728792003956564819967;
2074     }
2075 
2076     /**
2077      * @notice Minimum value that can be represented in an int256
2078      * @dev Test minInt256 equals (2^255) * (-1)
2079      */
2080     function minInt256() public pure returns(int256) {
2081         return -57896044618658097711785492504343953926634992332820282019728792003956564819968;
2082     }
2083 
2084     /**
2085      * @notice Maximum value that can be converted to fixed point. Optimize for
2086      * @dev deployment. 
2087      * Test maxNewFixed() equals maxInt256() / fixed1()
2088      * Hardcoded to 24 digits.
2089      */
2090     function maxNewFixed() public pure returns(int256) {
2091         return 57896044618658097711785492504343953926634992332820282;
2092     }
2093 
2094     /**
2095      * @notice Maximum value that can be converted to fixed point. Optimize for
2096      * deployment. 
2097      * @dev Test minNewFixed() equals -(maxInt256()) / fixed1()
2098      * Hardcoded to 24 digits.
2099      */
2100     function minNewFixed() public pure returns(int256) {
2101         return -57896044618658097711785492504343953926634992332820282;
2102     }
2103 
2104     /**
2105      * @notice Maximum value that can be safely used as an addition operator.
2106      * @dev Test maxFixedAdd() equals maxInt256()-1 / 2
2107      * Test add(maxFixedAdd(),maxFixedAdd()) equals maxFixedAdd() + maxFixedAdd()
2108      * Test add(maxFixedAdd()+1,maxFixedAdd()) throws 
2109      * Test add(-maxFixedAdd(),-maxFixedAdd()) equals -maxFixedAdd() - maxFixedAdd()
2110      * Test add(-maxFixedAdd(),-maxFixedAdd()-1) throws 
2111      */
2112     function maxFixedAdd() public pure returns(int256) {
2113         return 28948022309329048855892746252171976963317496166410141009864396001978282409983;
2114     }
2115 
2116     /**
2117      * @notice Maximum negative value that can be safely in a subtraction.
2118      * @dev Test maxFixedSub() equals minInt256() / 2
2119      */
2120     function maxFixedSub() public pure returns(int256) {
2121         return -28948022309329048855892746252171976963317496166410141009864396001978282409984;
2122     }
2123 
2124     /**
2125      * @notice Maximum value that can be safely used as a multiplication operator.
2126      * @dev Calculated as sqrt(maxInt256()*fixed1()). 
2127      * Be careful with your sqrt() implementation. I couldn't find a calculator
2128      * that would give the exact square root of maxInt256*fixed1 so this number
2129      * is below the real number by no more than 3*10**28. It is safe to use as
2130      * a limit for your multiplications, although powers of two of numbers over
2131      * this value might still work.
2132      * Test multiply(maxFixedMul(),maxFixedMul()) equals maxFixedMul() * maxFixedMul()
2133      * Test multiply(maxFixedMul(),maxFixedMul()+1) throws 
2134      * Test multiply(-maxFixedMul(),maxFixedMul()) equals -maxFixedMul() * maxFixedMul()
2135      * Test multiply(-maxFixedMul(),maxFixedMul()+1) throws 
2136      * Hardcoded to 24 digits.
2137      */
2138     function maxFixedMul() public pure returns(int256) {
2139         return 240615969168004498257251713877715648331380787511296;
2140     }
2141 
2142     /**
2143      * @notice Maximum value that can be safely used as a dividend.
2144      * @dev divide(maxFixedDiv,newFixedFraction(1,fixed1())) = maxInt256().
2145      * Test maxFixedDiv() equals maxInt256()/fixed1()
2146      * Test divide(maxFixedDiv(),multiply(mulPrecision(),mulPrecision())) = maxFixedDiv()*(10^digits())
2147      * Test divide(maxFixedDiv()+1,multiply(mulPrecision(),mulPrecision())) throws
2148      * Hardcoded to 24 digits.
2149      */
2150     function maxFixedDiv() public pure returns(int256) {
2151         return 57896044618658097711785492504343953926634992332820282;
2152     }
2153 
2154     /**
2155      * @notice Maximum value that can be safely used as a divisor.
2156      * @dev Test maxFixedDivisor() equals fixed1()*fixed1() - Or 10**(digits()*2)
2157      * Test divide(10**(digits()*2 + 1),10**(digits()*2)) = returns 10*fixed1()
2158      * Test divide(10**(digits()*2 + 1),10**(digits()*2 + 1)) = throws
2159      * Hardcoded to 24 digits.
2160      */
2161     function maxFixedDivisor() public pure returns(int256) {
2162         return 1000000000000000000000000000000000000000000000000;
2163     }
2164 
2165     /**
2166      * @notice Converts an int256 to fixed point units, equivalent to multiplying
2167      * by 10^digits().
2168      * @dev Test newFixed(0) returns 0
2169      * Test newFixed(1) returns fixed1()
2170      * Test newFixed(maxNewFixed()) returns maxNewFixed() * fixed1()
2171      * Test newFixed(maxNewFixed()+1) fails
2172      */
2173     function newFixed(int256 x)
2174         public
2175         pure
2176         returns (int256)
2177     {
2178         assert(x <= maxNewFixed());
2179         assert(x >= minNewFixed());
2180         return x * fixed1();
2181     }
2182 
2183     /**
2184      * @notice Converts an int256 in the fixed point representation of this 
2185      * library to a non decimal. All decimal digits will be truncated.
2186      */
2187     function fromFixed(int256 x)
2188         public
2189         pure
2190         returns (int256)
2191     {
2192         return x / fixed1();
2193     }
2194 
2195     /**
2196      * @notice Converts an int256 which is already in some fixed point 
2197      * representation to a different fixed precision representation.
2198      * Both the origin and destination precisions must be 38 or less digits.
2199      * Origin values with a precision higher than the destination precision
2200      * will be truncated accordingly.
2201      * @dev 
2202      * Test convertFixed(1,0,0) returns 1;
2203      * Test convertFixed(1,1,1) returns 1;
2204      * Test convertFixed(1,1,0) returns 0;
2205      * Test convertFixed(1,0,1) returns 10;
2206      * Test convertFixed(10,1,0) returns 1;
2207      * Test convertFixed(10,0,1) returns 100;
2208      * Test convertFixed(100,1,0) returns 10;
2209      * Test convertFixed(100,0,1) returns 1000;
2210      * Test convertFixed(1000,2,0) returns 10;
2211      * Test convertFixed(1000,0,2) returns 100000;
2212      * Test convertFixed(1000,2,1) returns 100;
2213      * Test convertFixed(1000,1,2) returns 10000;
2214      * Test convertFixed(maxInt256,1,0) returns maxInt256/10;
2215      * Test convertFixed(maxInt256,0,1) throws
2216      * Test convertFixed(maxInt256,38,0) returns maxInt256/(10**38);
2217      * Test convertFixed(1,0,38) returns 10**38;
2218      * Test convertFixed(maxInt256,39,0) throws
2219      * Test convertFixed(1,0,39) throws
2220      */
2221     function convertFixed(int256 x, uint8 _originDigits, uint8 _destinationDigits)
2222         public
2223         pure
2224         returns (int256)
2225     {
2226         assert(_originDigits <= 38 && _destinationDigits <= 38);
2227         
2228         uint8 decimalDifference;
2229         if ( _originDigits > _destinationDigits ){
2230             decimalDifference = _originDigits - _destinationDigits;
2231             return x/(uint128(10)**uint128(decimalDifference));
2232         }
2233         else if ( _originDigits < _destinationDigits ){
2234             decimalDifference = _destinationDigits - _originDigits;
2235             // Cast uint8 -> uint128 is safe
2236             // Exponentiation is safe:
2237             //     _originDigits and _destinationDigits limited to 38 or less
2238             //     decimalDifference = abs(_destinationDigits - _originDigits)
2239             //     decimalDifference < 38
2240             //     10**38 < 2**128-1
2241             assert(x <= maxInt256()/uint128(10)**uint128(decimalDifference));
2242             assert(x >= minInt256()/uint128(10)**uint128(decimalDifference));
2243             return x*(uint128(10)**uint128(decimalDifference));
2244         }
2245         // _originDigits == digits()) 
2246         return x;
2247     }
2248 
2249     /**
2250      * @notice Converts an int256 which is already in some fixed point 
2251      * representation to that of this library. The _originDigits parameter is the
2252      * precision of x. Values with a precision higher than FixidityLib.digits()
2253      * will be truncated accordingly.
2254      */
2255     function newFixed(int256 x, uint8 _originDigits)
2256         public
2257         pure
2258         returns (int256)
2259     {
2260         return convertFixed(x, _originDigits, digits());
2261     }
2262 
2263     /**
2264      * @notice Converts an int256 in the fixed point representation of this 
2265      * library to a different representation. The _destinationDigits parameter is the
2266      * precision of the output x. Values with a precision below than 
2267      * FixidityLib.digits() will be truncated accordingly.
2268      */
2269     function fromFixed(int256 x, uint8 _destinationDigits)
2270         public
2271         pure
2272         returns (int256)
2273     {
2274         return convertFixed(x, digits(), _destinationDigits);
2275     }
2276 
2277     /**
2278      * @notice Converts two int256 representing a fraction to fixed point units,
2279      * equivalent to multiplying dividend and divisor by 10^digits().
2280      * @dev 
2281      * Test newFixedFraction(maxFixedDiv()+1,1) fails
2282      * Test newFixedFraction(1,maxFixedDiv()+1) fails
2283      * Test newFixedFraction(1,0) fails     
2284      * Test newFixedFraction(0,1) returns 0
2285      * Test newFixedFraction(1,1) returns fixed1()
2286      * Test newFixedFraction(maxFixedDiv(),1) returns maxFixedDiv()*fixed1()
2287      * Test newFixedFraction(1,fixed1()) returns 1
2288      * Test newFixedFraction(1,fixed1()-1) returns 0
2289      */
2290     function newFixedFraction(
2291         int256 numerator, 
2292         int256 denominator
2293         )
2294         public
2295         pure
2296         returns (int256)
2297     {
2298         assert(numerator <= maxNewFixed());
2299         assert(denominator <= maxNewFixed());
2300         assert(denominator != 0);
2301         int256 convertedNumerator = newFixed(numerator);
2302         int256 convertedDenominator = newFixed(denominator);
2303         return divide(convertedNumerator, convertedDenominator);
2304     }
2305 
2306     /**
2307      * @notice Returns the integer part of a fixed point number.
2308      * @dev 
2309      * Test integer(0) returns 0
2310      * Test integer(fixed1()) returns fixed1()
2311      * Test integer(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
2312      * Test integer(-fixed1()) returns -fixed1()
2313      * Test integer(newFixed(-maxNewFixed())) returns -maxNewFixed()*fixed1()
2314      */
2315     function integer(int256 x) public pure returns (int256) {
2316         return (x / fixed1()) * fixed1(); // Can't overflow
2317     }
2318 
2319     /**
2320      * @notice Returns the fractional part of a fixed point number. 
2321      * In the case of a negative number the fractional is also negative.
2322      * @dev 
2323      * Test fractional(0) returns 0
2324      * Test fractional(fixed1()) returns 0
2325      * Test fractional(fixed1()-1) returns 10^24-1
2326      * Test fractional(-fixed1()) returns 0
2327      * Test fractional(-fixed1()+1) returns -10^24-1
2328      */
2329     function fractional(int256 x) public pure returns (int256) {
2330         return x - (x / fixed1()) * fixed1(); // Can't overflow
2331     }
2332 
2333     /**
2334      * @notice Converts to positive if negative.
2335      * Due to int256 having one more negative number than positive numbers 
2336      * abs(minInt256) reverts.
2337      * @dev 
2338      * Test abs(0) returns 0
2339      * Test abs(fixed1()) returns -fixed1()
2340      * Test abs(-fixed1()) returns fixed1()
2341      * Test abs(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
2342      * Test abs(newFixed(minNewFixed())) returns -minNewFixed()*fixed1()
2343      */
2344     function abs(int256 x) public pure returns (int256) {
2345         if (x >= 0) {
2346             return x;
2347         } else {
2348             int256 result = -x;
2349             assert (result > 0);
2350             return result;
2351         }
2352     }
2353 
2354     /**
2355      * @notice x+y. If any operator is higher than maxFixedAdd() it 
2356      * might overflow.
2357      * In solidity maxInt256 + 1 = minInt256 and viceversa.
2358      * @dev 
2359      * Test add(maxFixedAdd(),maxFixedAdd()) returns maxInt256()-1
2360      * Test add(maxFixedAdd()+1,maxFixedAdd()+1) fails
2361      * Test add(-maxFixedSub(),-maxFixedSub()) returns minInt256()
2362      * Test add(-maxFixedSub()-1,-maxFixedSub()-1) fails
2363      * Test add(maxInt256(),maxInt256()) fails
2364      * Test add(minInt256(),minInt256()) fails
2365      */
2366     function add(int256 x, int256 y) public pure returns (int256) {
2367         int256 z = x + y;
2368         if (x > 0 && y > 0) assert(z > x && z > y);
2369         if (x < 0 && y < 0) assert(z < x && z < y);
2370         return z;
2371     }
2372 
2373     /**
2374      * @notice x-y. You can use add(x,-y) instead. 
2375      * @dev Tests covered by add(x,y)
2376      */
2377     function subtract(int256 x, int256 y) public pure returns (int256) {
2378         return add(x,-y);
2379     }
2380 
2381     /**
2382      * @notice x*y. If any of the operators is higher than maxFixedMul() it 
2383      * might overflow.
2384      * @dev 
2385      * Test multiply(0,0) returns 0
2386      * Test multiply(maxFixedMul(),0) returns 0
2387      * Test multiply(0,maxFixedMul()) returns 0
2388      * Test multiply(maxFixedMul(),fixed1()) returns maxFixedMul()
2389      * Test multiply(fixed1(),maxFixedMul()) returns maxFixedMul()
2390      * Test all combinations of (2,-2), (2, 2.5), (2, -2.5) and (0.5, -0.5)
2391      * Test multiply(fixed1()/mulPrecision(),fixed1()*mulPrecision())
2392      * Test multiply(maxFixedMul()-1,maxFixedMul()) equals multiply(maxFixedMul(),maxFixedMul()-1)
2393      * Test multiply(maxFixedMul(),maxFixedMul()) returns maxInt256() // Probably not to the last digits
2394      * Test multiply(maxFixedMul()+1,maxFixedMul()) fails
2395      * Test multiply(maxFixedMul(),maxFixedMul()+1) fails
2396      */
2397     function multiply(int256 x, int256 y) public pure returns (int256) {
2398         if (x == 0 || y == 0) return 0;
2399         if (y == fixed1()) return x;
2400         if (x == fixed1()) return y;
2401 
2402         // Separate into integer and fractional parts
2403         // x = x1 + x2, y = y1 + y2
2404         int256 x1 = integer(x) / fixed1();
2405         int256 x2 = fractional(x);
2406         int256 y1 = integer(y) / fixed1();
2407         int256 y2 = fractional(y);
2408         
2409         // (x1 + x2) * (y1 + y2) = (x1 * y1) + (x1 * y2) + (x2 * y1) + (x2 * y2)
2410         int256 x1y1 = x1 * y1;
2411         if (x1 != 0) assert(x1y1 / x1 == y1); // Overflow x1y1
2412         
2413         // x1y1 needs to be multiplied back by fixed1
2414         // solium-disable-next-line mixedcase
2415         int256 fixed_x1y1 = x1y1 * fixed1();
2416         if (x1y1 != 0) assert(fixed_x1y1 / x1y1 == fixed1()); // Overflow x1y1 * fixed1
2417         x1y1 = fixed_x1y1;
2418 
2419         int256 x2y1 = x2 * y1;
2420         if (x2 != 0) assert(x2y1 / x2 == y1); // Overflow x2y1
2421 
2422         int256 x1y2 = x1 * y2;
2423         if (x1 != 0) assert(x1y2 / x1 == y2); // Overflow x1y2
2424 
2425         x2 = x2 / mulPrecision();
2426         y2 = y2 / mulPrecision();
2427         int256 x2y2 = x2 * y2;
2428         if (x2 != 0) assert(x2y2 / x2 == y2); // Overflow x2y2
2429 
2430         // result = fixed1() * x1 * y1 + x1 * y2 + x2 * y1 + x2 * y2 / fixed1();
2431         int256 result = x1y1;
2432         result = add(result, x2y1); // Add checks for overflow
2433         result = add(result, x1y2); // Add checks for overflow
2434         result = add(result, x2y2); // Add checks for overflow
2435         return result;
2436     }
2437     
2438     /**
2439      * @notice 1/x
2440      * @dev 
2441      * Test reciprocal(0) fails
2442      * Test reciprocal(fixed1()) returns fixed1()
2443      * Test reciprocal(fixed1()*fixed1()) returns 1 // Testing how the fractional is truncated
2444      * Test reciprocal(2*fixed1()*fixed1()) returns 0 // Testing how the fractional is truncated
2445      */
2446     function reciprocal(int256 x) public pure returns (int256) {
2447         assert(x != 0);
2448         return (fixed1()*fixed1()) / x; // Can't overflow
2449     }
2450 
2451     /**
2452      * @notice x/y. If the dividend is higher than maxFixedDiv() it 
2453      * might overflow. You can use multiply(x,reciprocal(y)) instead.
2454      * There is a loss of precision on division for the lower mulPrecision() decimals.
2455      * @dev 
2456      * Test divide(fixed1(),0) fails
2457      * Test divide(maxFixedDiv(),1) = maxFixedDiv()*(10^digits())
2458      * Test divide(maxFixedDiv()+1,1) throws
2459      * Test divide(maxFixedDiv(),maxFixedDiv()) returns fixed1()
2460      */
2461     function divide(int256 x, int256 y) public pure returns (int256) {
2462         if (y == fixed1()) return x;
2463         assert(y != 0);
2464         assert(y <= maxFixedDivisor());
2465         return multiply(x, reciprocal(y));
2466     }
2467 }
2468 
2469 
2470 // File contracts/libraries/Utils.sol
2471 
2472 
2473 pragma solidity ^0.6.4;
2474 library Utils {
2475     using SignedSafeMath for int256;
2476     using Strings for *;
2477 
2478     function stringToUint(string memory s)
2479         internal
2480         pure
2481         returns (uint256 result)
2482     {
2483         bytes memory b = bytes(s);
2484         uint256 i;
2485         result = 0;
2486         for (i = 0; i < b.length; i++) {
2487             uint256 c = uint256(uint8(b[i]));
2488             if (c >= 48 && c <= 57) {
2489                 result = result * 10 + (c - 48);
2490             }
2491         }
2492     }
2493 
2494     // special toString for signed ints
2495     function toString(int256 val) public pure returns (string memory out) {
2496         out = (val < 0) ? 
2497             string(abi.encodePacked("-", uint256(val.mul(-1)).toString())) :
2498             uint256(val).toString();
2499     }
2500 
2501     function zeroPad(int256 value, uint256 places) internal pure returns (string memory out) {
2502         out = toString(value);
2503         for (uint i=(places-1); i>0; i--)
2504             if (value < int256(10**i))
2505                 out = string(abi.encodePacked("0", out));
2506     }
2507 }
2508 
2509 
2510 // File contracts/libraries/Random.sol
2511 
2512 
2513 pragma solidity ^0.6.4;
2514 library Random {
2515     using SafeMath for uint256;
2516     using SignedSafeMath for int256;
2517 
2518     /**
2519      * Initialize the pool with the entropy of the blockhashes of the num of blocks starting from 0
2520      * The argument "seed" allows you to select a different sequence of random numbers for the same block range.
2521      */
2522     function init(
2523         uint256 seed
2524     ) internal view returns (bytes32[] memory) {
2525         uint256 blocks = 2;
2526         bytes32[] memory pool = new bytes32[](3);
2527         bytes32 salt = keccak256(abi.encodePacked(uint256(0), seed));
2528         for (uint256 i = 0; i < blocks; i++) {
2529             // Add some salt to each blockhash
2530             pool[i + 1] = keccak256(
2531                 abi.encodePacked(blockhash(i), salt)
2532             );
2533         }
2534         return pool;
2535     }
2536 
2537     /**
2538      * Advances to the next 256-bit random number in the pool of hash chains.
2539      */
2540     function next(bytes32[] memory pool) internal pure returns (uint256) {
2541         require(pool.length > 1, "Random.next: invalid pool");
2542         uint256 roundRobinIdx = (uint256(pool[0]) % (pool.length - 1)) + 1;
2543         bytes32 hash = keccak256(abi.encodePacked(pool[roundRobinIdx]));
2544         pool[0] = bytes32(uint256(pool[0]) + 1);
2545         pool[roundRobinIdx] = hash;
2546         return uint256(hash);
2547     }
2548 
2549     /**
2550      * Produces random integer values, uniformly distributed on the closed interval [a, b]
2551      */
2552     function uniform(
2553         bytes32[] memory pool,
2554         int256 a,
2555         int256 b
2556     ) internal pure returns (int256) {
2557         require(a <= b, "Random.uniform: invalid interval");
2558         return int256(next(pool) % uint256(b - a + 1)) + a;
2559     }
2560 
2561     /**
2562      * Produces random integer values, with weighted distributions for values in a set
2563      */
2564     function weighted(
2565         bytes32[] memory pool,
2566         uint8[7] memory thresholds,
2567         uint16 total
2568     ) internal pure returns (uint8) {
2569         int256 p = uniform(pool, 1, total);
2570         int256 s = 0;
2571         for (uint8 i=0; i<7; i++) {
2572             s = s.add(thresholds[i]);
2573             if (p <= s) return i;
2574         }
2575     }
2576 
2577     /**
2578      * Produces random integer values, with weighted distributions for values in a set
2579      */
2580     function weighted(
2581         bytes32[] memory pool,
2582         uint8[24] memory thresholds,
2583         uint16 total
2584     ) internal pure returns (uint8) {
2585         int256 p = uniform(pool, 1, total);
2586         int256 s = 0;
2587         for (uint8 i=0; i<24; i++) {
2588             s = s.add(thresholds[i]);
2589             if (p <= s) return i;
2590         }
2591     }
2592 }
2593 
2594 
2595 // File contracts/TinyBoxesBase.sol
2596 
2597 
2598 pragma solidity ^0.6.8;
2599 pragma experimental ABIEncoderV2;
2600 interface RandomizerInt {
2601     function returnValue() external view returns (bytes32);
2602 }
2603 
2604 contract TinyBoxesBase is ERC721, AccessControl  {
2605     using Counters for Counters.Counter;
2606     using Random for bytes32[];
2607 
2608     Counters.Counter public _tokenIds;
2609     Counters.Counter public _tokenPromoIds;
2610 
2611     RandomizerInt entropySource;
2612 
2613     // set contract config constants
2614 
2615     address payable skyfly = 0x7A832c86002323a5de3a317b3281Eb88EC3b2C00;
2616     address payable natealex = 0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3;
2617 
2618     uint256 public constant price = 100000000000000000; // in wei - 0.1 ETH
2619     uint256 public constant referalPercent = 10;
2620     uint256 public constant referalNewPercent = 15;
2621     uint256 UINT_MAX = uint256(-1);
2622     uint256 MAX_PROMOS = 100;
2623 
2624     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE"); // define the admin role identifier
2625     uint16 public constant TOKEN_LIMIT = 2222;
2626     uint8 public constant ANIMATION_COUNT = 24;
2627     uint8 public constant SCHEME_COUNT = 11;
2628     uint8 public constant avgBlockTime = 14; // avg time per block mined in seconds
2629     uint16 public constant phaseLen = TOKEN_LIMIT / SCHEME_COUNT; // token count per phase
2630     uint32 public constant phaseCountdownTime = 6 hours; // time to pause between phases
2631     
2632     // set dynamic contract config
2633     bool public paused = true;
2634     uint256 public blockStart; // next block that minting will start on, countdown end point
2635     uint256 public phaseCountdown = uint256(phaseCountdownTime / avgBlockTime); // blocks to pause between phases
2636     string public contractURI = "https://tinybox.shop/TinyBoxes.json";
2637 
2638     // mapping to store all the boxes info
2639     mapping(uint256 => TinyBox) internal boxes;
2640 
2641     event SettingsChanged(uint8[3] settings);
2642 
2643     /**
2644      * @dev Contract constructor.
2645      * @notice Constructor inherits ERC721
2646      */
2647     constructor(address entropySourceAddress) public ERC721("TinyBoxes", "[#][#]") {
2648         _setupRole(ADMIN_ROLE, msg.sender);
2649         entropySource = RandomizerInt(entropySourceAddress);
2650     }
2651 
2652     // Require Functions
2653 
2654     /**
2655      * @notice  only allow acounts of a specified role to call a function
2656      */
2657     function onlyRole(bytes32 _role) view internal {
2658         // Check that the calling account has the required role
2659         require(hasRole(_role, msg.sender), "DENIED");
2660     }
2661 
2662     /**
2663      * @notice check if tokens are sold out
2664      */
2665     function notSoldOut() view internal {
2666         require(_tokenIds.current() < TOKEN_LIMIT, "SOLD OUT");
2667     }
2668 
2669     /**
2670      * @notice check if minting is paused
2671      */
2672     function notPaused() view internal {
2673         require(!paused, "Paused");
2674     }
2675 
2676     /**
2677      * @notice check if minting is waiting for a countdown
2678      */
2679     function notCountdown() view internal {
2680         require(block.number >= blockStart, "WAIT");
2681     }
2682 
2683     // Store Mgmt. Functions
2684 
2685     /**
2686      * @dev pause minting
2687      */
2688     function setPause(bool state) external {
2689         onlyRole(ADMIN_ROLE);
2690         paused = state;
2691     }
2692 
2693     /**
2694      * @dev set start block for next phase
2695      */
2696     function startCountdown(uint256 startBlock) external {
2697         onlyRole(ADMIN_ROLE);
2698         require(startBlock > block.number,"Must be future block");
2699         blockStart = startBlock;
2700         paused = false;
2701     }
2702 
2703     // Randomizer functions
2704 
2705     /**
2706      * @dev set Randomizer
2707      */
2708     function setRandom(address rand) external {
2709         onlyRole(ADMIN_ROLE);
2710         entropySource = RandomizerInt(rand);
2711     }
2712 
2713     /**
2714      * @dev test Randomizer
2715      */
2716     function testRandom() external view returns (bytes32) {
2717         onlyRole(ADMIN_ROLE);
2718         return entropySource.returnValue();
2719     }
2720 
2721     /**
2722      * @dev Call the Randomizer and get some randomness
2723      */
2724     function getRandomness(uint256 id, uint256 seed)
2725         internal view returns (uint128 randomnesss)
2726     {
2727         uint256 randomness = uint256(keccak256(abi.encodePacked(
2728             entropySource.returnValue(),
2729             id,
2730             seed
2731         ))); // mix local and Randomizer entropy for the box randomness
2732         return uint128(randomness % (2**128)); // cut off half the bits
2733     }
2734 
2735     // Metadata URI Functions
2736 
2737     /**
2738      * @dev Set the tokens URI
2739      * @param _id of a token to update
2740      * @param _uri for the token
2741      * @dev Only the admin can call this
2742      */
2743     function setTokenURI(uint256 _id, string calldata _uri) external {
2744         onlyRole(ADMIN_ROLE);
2745         _setTokenURI(_id, _uri);
2746     }
2747 
2748     /**
2749      * @dev Update the base URI field
2750      * @param _uri base for all tokens 
2751      * @dev Only the admin can call this
2752      */
2753     function setBaseURI(string calldata _uri) external {
2754         onlyRole(ADMIN_ROLE);
2755         _setBaseURI(_uri);
2756     }
2757 
2758     /**
2759      * @dev Update the contract URI field
2760      * @dev Only the admin can call this
2761      */
2762     function setContractURI(string calldata _uri) external {
2763         onlyRole(ADMIN_ROLE);
2764         contractURI = _uri;
2765     }
2766 
2767     // Utility Functions
2768 
2769     /**
2770      * @dev check current phase
2771      */
2772     function currentPhase() public view returns (uint8) {
2773         return uint8(_tokenIds.current().div(phaseLen));
2774     }
2775 
2776     /**
2777      * @dev calculate the true id for the limited editions
2778      */
2779     function trueID(uint256 id) public pure returns (int8) {
2780         return int8(int256(id));
2781     }
2782 
2783     /**
2784      * @dev check if id is one of limited editions
2785      * @param id of token to check
2786      */
2787     function isTokenLE(uint256 id) public view returns (bool) {
2788         return id > UINT_MAX - MAX_PROMOS;
2789     }
2790 
2791     // Token Info - Data & Settings
2792 
2793     /**
2794      * @dev Lookup all token data in one call
2795      * @param _id for which we want token data
2796      * @return randomness of the token
2797      * @return animation of token
2798      * @return shapes of token
2799      * @return hatching of token
2800      * @return size of token
2801      * @return spacing of token
2802      * @return mirroring of token
2803      * @return color for palette root
2804      * @return contrast of the palette
2805      * @return shades for palette
2806      * @return scheme for palette
2807      */
2808     function tokenData(uint256 _id)
2809         external
2810         view
2811         returns (
2812             uint128 randomness,
2813             uint256 animation,
2814             uint8 shapes,
2815             uint8 hatching,
2816             uint8[4] memory size,
2817             uint8[2] memory spacing,
2818             uint8 mirroring,
2819             uint16[3] memory color,
2820             uint8 contrast,
2821             uint8 shades,
2822             uint8 scheme
2823         )
2824     {
2825         TinyBox memory box = boxes[_id];
2826         uint8[4] memory parts = calcedParts(box, _id);
2827 
2828         animation = parts[0];
2829         scheme = parts[1];
2830         shades = parts[2];
2831         contrast = parts[3];
2832 
2833         randomness = box.randomness;
2834         mirroring = box.mirroring;
2835         shapes = box.shapes;
2836         hatching = box.hatching;
2837         color = [box.hue, box.saturation, box.lightness];
2838         size = [box.widthMin, box.widthMax, box.heightMin, box.heightMax];
2839         spacing = [box.spread, box.grid];
2840     }
2841 
2842     /**
2843      * @dev read the dynamic rendering settings of a token
2844      * @param id of the token to fetch settings for
2845      */
2846     function readSettings(uint256 id) external view returns (uint8 bkg, uint8 duration, uint8 options) {
2847         TinyBox memory box = boxes[id];
2848         bkg = box.bkg;
2849         duration = box.duration;
2850         options = box.options;
2851     }
2852 
2853     /**
2854      * @dev set the dynamic rendering options of a token
2855      * @param id of the token to update
2856      * @param settings new settings values
2857      */
2858     function changeSettings(uint256 id, uint8[3] calldata settings) external {
2859         require(msg.sender == ownerOf(id) || msg.sender == getApproved(id), "Insuf. Permissions");
2860         require(settings[0] <= 101, "Invalid Bkg");
2861         require(settings[1] > 0, "Invalid Duration");
2862         boxes[id].bkg = settings[0];
2863         boxes[id].duration = settings[1];
2864         boxes[id].options = settings[2];
2865         emit SettingsChanged(settings);
2866     }
2867 
2868     /**
2869      * @dev Calculate the randomized and phased values
2870      */
2871     function calcedParts(TinyBox memory box, uint256 id) internal view returns (uint8[4] memory parts)
2872     {
2873         if (id < TOKEN_LIMIT) { // Normal Tokens
2874             bytes32[] memory pool = Random.init(box.randomness);
2875             uint8[7] memory shadesBins = [4,6,9,6,4,2,1];
2876             uint8[24] memory animationBins = [
2877                 175, // Snap Spin 90
2878                 200, // Snap Spin 180
2879                 175, // Snap Spin 270
2880                 160, // Snap Spin Tri
2881                 150, // Snap Spin Quad
2882                 140, // Snap Spin Tetra
2883                 95, // Spin
2884                 100, // Slow Mo
2885                 90, // Clockwork
2886                 20, // Spread
2887                 10, // Staggered Spread
2888                 80, // Jitter
2889                 75, // Giggle
2890                 85, // Jolt
2891                 110, // Grow n Shrink
2892                 105, // Squash n Stretch
2893                 50, // Round
2894                 90, // Glide
2895                 70, // Wave
2896                 40, // Fade
2897                 140, // Skew X
2898                 130, // Skew Y
2899                 100, // Stretch
2900                 110 // Jello
2901             ];
2902             // Generate Random parts from the tokens randomness
2903             parts[0] = uint8(pool.weighted(animationBins, 2500)); // animation
2904             parts[1] = uint8(id.div(phaseLen)); // scheme
2905             parts[2] = uint8(uint256(pool.weighted(shadesBins, 32)).add(1)); //, shades
2906             parts[3] = uint8(pool.uniform(0, box.lightness)); // contrast
2907         } else { // Limited Editions
2908             // Set the parts directly from packed values in the randomness
2909             // Anim(5), Scheme(4), Shades(3), Contrast(7) & Vanity Rand String(17xASCII(7))
2910             parts[0] = uint8(box.randomness / 2**123); // animation
2911             parts[1] = uint8((box.randomness / 2**119) % 2**4); // scheme
2912             parts[2] = uint8((box.randomness / 2**116) % 2**3); //, shades
2913             parts[3] = uint8((box.randomness / 2**109) % 2**7); // contrast
2914         }
2915     }
2916 
2917     /**
2918      * @dev Validate the parameters for the docs
2919      */
2920     function validateParams(uint8 shapes, uint8 hatching, uint16[3] memory color, uint8[4] memory size, uint8[2] memory position, bool exclusive) public pure {
2921         require(shapes > 0 && shapes < 31, "invalid shape count");
2922         require(hatching <= shapes, "invalid hatching");
2923         require(color[2] <= 360, "invalid color");
2924         require(color[1] <= 100, "invalid saturation");
2925         if (!exclusive) require(color[1] >= 20, "invalid saturation");
2926         require(color[2] <= 100, "invalid lightness");
2927         require(size[0] <= size[1], "invalid width range");
2928         require(size[2] <= size[3], "invalid height range");
2929         require(position[0] <= 100, "invalid spread");
2930     }
2931 }
2932 
2933 
2934 // File contracts/TinyBoxesStore.sol
2935 
2936 
2937 pragma solidity ^0.6.8;
2938 
2939 contract TinyBoxesStore is TinyBoxesBase {
2940     using SafeMath for uint256;
2941     using SignedSafeMath for int256;
2942     using Utils for *;
2943 
2944     event RedeemedLE(address by, uint256 id);
2945 
2946     /**
2947      * @dev Contract constructor.
2948      */
2949     constructor(address entropySourceAddress)
2950         public
2951         TinyBoxesBase(entropySourceAddress)
2952     {}
2953 
2954     // Payment Functions
2955 
2956     /**
2957      * @dev receive direct ETH transfers
2958      * @notice for splitting royalties
2959      */
2960     receive() external payable {
2961         _splitFunds(msg.value); 
2962     }
2963 
2964     /**
2965      * @dev withdraw any funds leftover in contract
2966      */
2967     function withdraw() external {
2968         onlyRole(ADMIN_ROLE);
2969         msg.sender.transfer(address(this).balance);
2970     }
2971 
2972     /**
2973      * @dev Split payments
2974      */
2975     function _splitFunds(uint256 amount) internal {
2976         if (amount > 0) {
2977             uint256 partA = amount.mul(60).div(100);
2978             skyfly.transfer(partA);
2979             natealex.transfer(amount.sub(partA));
2980         }
2981     }
2982 
2983     /**
2984      * @dev handle the payment for tokens
2985      */
2986     function handlePayment(uint256 referalID, address recipient) internal {
2987         // check for suficient payment
2988         require(msg.value >= price, "insuficient payment");
2989         // give the buyer change
2990         if (msg.value > price) msg.sender.transfer(msg.value.sub(price));
2991         // lookup the referer by the referal token id owner
2992         address payable referer = _exists(referalID) ? payable(ownerOf(referalID)) : tx.origin;
2993         // give a higher percent for refering a new user
2994         uint256 percent = (balanceOf(tx.origin) == 0) ? referalNewPercent : referalPercent;
2995         // referer can't be sender or reciever - no self referals
2996         uint256 referal = (referer != msg.sender && referer != tx.origin && referer != recipient) ? 
2997             price.mul(percent).div(100) : 0; 
2998         // pay referal percentage
2999         if (referal > 0) referer.transfer(referal);
3000         // split remaining payment
3001         _splitFunds(price.sub(referal));
3002     }
3003 
3004     /**
3005      * @dev Check if a TinyBox Promo Token is unredeemed
3006      * @param id of the token to check
3007      */
3008     function unredeemed(uint256 id) public view returns (bool) {
3009         return boxes[id].shapes == 0;
3010     }
3011 
3012     // Token Creation Functions
3013 
3014     /**
3015      * @dev Create a new LimitedEdition TinyBox Token
3016      * @param recipient of the new LE TinyBox token
3017      */
3018     function mintLE(address recipient) external {
3019         onlyRole(ADMIN_ROLE);
3020         require(_tokenPromoIds.current() < MAX_PROMOS, "NO MORE");
3021         uint256 id = UINT_MAX - _tokenPromoIds.current();
3022         _safeMint(recipient, id); // mint the new token to the recipient address
3023         _tokenPromoIds.increment();
3024     }
3025 
3026     /**
3027      * @dev Create a new TinyBox Token
3028      * @param _seed of token
3029      * @param shapes count and hatching mod value
3030      * @param color settings (hue, sat, light, contrast, shades)
3031      * @param size range for boxes
3032      * @param spacing grid and spread params
3033      * @param recipient of the token
3034      * @return id of the new token
3035      */
3036     function create(
3037         string calldata _seed,
3038         uint8[2] calldata shapes,
3039         uint16[3] calldata color,
3040         uint8[4] calldata size,
3041         uint8[2] calldata spacing,
3042         uint8 mirroring,
3043         address recipient,
3044         uint256 referalID
3045     ) external payable returns (uint256) {
3046         notSoldOut();
3047         notPaused();
3048         notCountdown();
3049         handlePayment(referalID, recipient);
3050         // check box parameters
3051         validateParams(shapes[0], shapes[1], color, size, spacing, false);
3052         // make sure caller is never the 0 address
3053         require(recipient != address(0), "0x00 Recipient Invalid");
3054         // check payment and give change
3055         (referalID, recipient);
3056         // get next id & increment the counter for the next callhandlePayment
3057         uint256 id = _tokenIds.current();
3058         _tokenIds.increment();
3059         // check if its time to pause for next phase countdown
3060         if (_tokenIds.current().mod(phaseLen) == 0)
3061             blockStart = block.number.add(phaseCountdown.mul(currentPhase()));
3062         // add block number and new token id to the seed value
3063         uint256 seed = _seed.stringToUint();
3064         // request randomness
3065         uint128 rand = getRandomness(id, seed);
3066         // create a new box object in storage
3067         boxes[id] = TinyBox({
3068             randomness: rand,
3069             hue: color[0],
3070             saturation: (rand % 200 == 0) ? uint8(0) : uint8(color[1]), // 0.5% chance of grayscale
3071             lightness: uint8(color[2]),
3072             shapes: shapes[0],
3073             hatching: shapes[1],
3074             widthMin: size[0],
3075             widthMax: size[1],
3076             heightMin: size[2],
3077             heightMax: size[3],
3078             spread: spacing[0],
3079             grid: spacing[1],
3080             mirroring: mirroring,
3081             bkg: 0,
3082             duration: 10,
3083             options: 1
3084         });
3085         _safeMint(recipient, id); // mint the new token to the recipient address
3086     }
3087 
3088     /**
3089      * @dev Create a Limited Edition TinyBox Token from a Promo token
3090      * @param seed for the token
3091      * @param shapes count and hatching mod value
3092      * @param color settings (hue, sat, light, contrast, shades)
3093      * @param size range for boxes
3094      * @param spacing grid and spread params
3095      */
3096     function redeemLE(
3097         uint128 seed,
3098         uint8[2] calldata shapes,
3099         uint16[3] calldata color,
3100         uint8[4] calldata size,
3101         uint8[2] calldata spacing,
3102         uint8 mirroring,
3103         uint256 id
3104     ) external {
3105         notPaused();
3106         //  check owner is caller
3107         require(ownerOf(id) == msg.sender, "NOPE");
3108         // check token is unredeemed
3109         require(unredeemed(id), "USED");
3110         // check box parameters are valid
3111         validateParams(shapes[0], shapes[1], color, size, spacing, true);
3112         // create a new box object
3113         boxes[id] = TinyBox({
3114             randomness: uint128(seed),
3115             hue: color[0],
3116             saturation: uint8(color[1]),
3117             lightness: uint8(color[2]),
3118             shapes: shapes[0],
3119             hatching: shapes[1],
3120             widthMin: size[0],
3121             widthMax: size[1],
3122             heightMin: size[2],
3123             heightMax: size[3],
3124             spread: spacing[0],
3125             grid: spacing[1],
3126             mirroring: mirroring,
3127             bkg: 0,
3128             duration: 10,
3129             options: 1
3130         });
3131         emit RedeemedLE(msg.sender, id);
3132     }
3133 }
3134 
3135 
3136 // File contracts/TinyBoxes.sol
3137 
3138 
3139 pragma solidity ^0.6.8;
3140 
3141 interface Renderer {
3142     function perpetualRenderer(
3143         TinyBox calldata box,
3144         uint256 id,
3145         address owner,
3146         uint8[4] calldata dVals,
3147         string calldata _slot
3148     ) external view returns (string memory);
3149 }
3150 
3151 contract TinyBoxes is TinyBoxesStore {
3152     Renderer renderer;
3153 
3154     /**
3155      * @dev Contract constructor.
3156      * @notice Constructor inherits from TinyBoxesStore
3157      */
3158     constructor(address rand, address _renderer)
3159         public
3160         TinyBoxesStore(rand)
3161     {
3162         renderer = Renderer(_renderer);
3163     }
3164 
3165     /**
3166      * @dev update the Renderer to a new contract
3167      */
3168     function updateRenderer(address _renderer) external {
3169         onlyRole(ADMIN_ROLE);
3170         renderer = Renderer(_renderer);
3171     }
3172 
3173     /**
3174      * @dev Generate the token SVG art
3175      * @param _id for which we want art
3176      * @return SVG art of token 
3177      */
3178     function tokenArt(uint256 _id)
3179         external
3180         view
3181         returns (string memory)
3182     {
3183         TinyBox memory box = boxes[_id];
3184         return renderer.perpetualRenderer(box, _id, ownerOf(_id), calcedParts(box, _id), "");
3185     }
3186 
3187     /**
3188      * @dev Generate the token SVG art with specific options
3189      * @param _id for which we want art
3190      * @param bkg for the token
3191      * @param duration animation duration modifier
3192      * @param options bits - 0th is the animate switch to turn on or off animation
3193      * @param slot string for embeding custom additions
3194      * @return animated SVG art of token
3195      */
3196     function tokenArt(uint256 _id, uint8 bkg, uint8 duration, uint8 options, string calldata slot)
3197         external
3198         view
3199         returns (string memory)
3200     {
3201         TinyBox memory box = boxes[_id];
3202         box.bkg = bkg;
3203         box.options = options;
3204         box.duration = duration;
3205         return renderer.perpetualRenderer(box ,_id, ownerOf(_id), calcedParts(box, _id), slot);
3206     }
3207     
3208     /**
3209      * @dev Generate the token SVG art preview for given parameters
3210      * @param seed for renderer RNG
3211      * @param shapes count and hatching mod
3212      * @param color settings (hue, sat, light, contrast, shades)
3213      * @param size for shapes
3214      * @param spacing grid and spread
3215      * @param traits mirroring, scheme, shades, animation
3216      * @param settings adjustable render options - bkg, duration, options
3217      * @param slot string to enter at end of SVG markup
3218      * @return preview SVG art
3219      */
3220     function renderPreview(
3221         string calldata seed,
3222         uint16[3] calldata color,
3223         uint8[2] calldata shapes,
3224         uint8[4] calldata size,
3225         uint8[2] calldata spacing,
3226         uint8 mirroring,
3227         uint8[3] calldata settings,
3228         uint8[4] calldata traits,
3229         string calldata slot
3230     ) external view returns (string memory) {
3231         validateParams(shapes[0], shapes[1], color, size, spacing, true);
3232         TinyBox memory box = TinyBox({
3233             randomness: uint128(seed.stringToUint()),
3234             hue: color[0],
3235             saturation: uint8(color[1]),
3236             lightness: uint8(color[2]),
3237             shapes: shapes[0],
3238             hatching: shapes[1],
3239             widthMin: size[0],
3240             widthMax: size[1],
3241             heightMin: size[2],
3242             heightMax: size[3],
3243             spread: spacing[0],
3244             mirroring: mirroring,
3245             grid: spacing[1],
3246             bkg: settings[0],
3247             duration: settings[1],
3248             options: settings[2]
3249         });
3250         return renderer.perpetualRenderer(box, 0, address(0), traits, slot);
3251     }
3252 }