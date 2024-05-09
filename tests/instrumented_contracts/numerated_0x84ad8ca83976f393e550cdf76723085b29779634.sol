1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 /**
26  * @dev String operations.
27  */
28 library Strings {
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` representation.
31      */
32     function toString(uint256 value) internal pure returns (string memory) {
33         // Inspired by OraclizeAPI's implementation - MIT licence
34         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
35 
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         uint256 index = digits - 1;
47         temp = value;
48         while (temp != 0) {
49             buffer[index--] = byte(uint8(48 + temp % 10));
50             temp /= 10;
51         }
52         return string(buffer);
53     }
54 }
55 
56 
57 
58 
59 
60 /*
61  * @dev Provides information about the current execution context, including the
62  * sender of the transaction and its data. While these are generally available
63  * via msg.sender and msg.data, they should not be accessed in such a direct
64  * manner, since when dealing with GSN meta-transactions the account sending and
65  * paying for execution may not be the actual sender (as far as an application
66  * is concerned).
67  *
68  * This contract is only required for intermediate, library-like contracts.
69  */
70 contract Context {
71     // Empty internal constructor, to prevent people from mistakenly deploying
72     // an instance of this contract, which should be used via inheritance.
73     constructor () internal { }
74 
75     function _msgSender() internal view virtual returns (address payable) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 
86 
87 
88 
89 /**
90  * @dev Required interface of an ERC721 compliant contract.
91  */
92 interface IERC721 is IERC165 {
93     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
94     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
95     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
96 
97     /**
98      * @dev Returns the number of NFTs in ``owner``'s account.
99      */
100     function balanceOf(address owner) external view returns (uint256 balance);
101 
102     /**
103      * @dev Returns the owner of the NFT specified by `tokenId`.
104      */
105     function ownerOf(uint256 tokenId) external view returns (address owner);
106 
107     /**
108      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
109      * another (`to`).
110      *
111      *
112      *
113      * Requirements:
114      * - `from`, `to` cannot be zero.
115      * - `tokenId` must be owned by `from`.
116      * - If the caller is not `from`, it must be have been allowed to move this
117      * NFT by either {approve} or {setApprovalForAll}.
118      */
119     function safeTransferFrom(address from, address to, uint256 tokenId) external;
120     /**
121      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
122      * another (`to`).
123      *
124      * Requirements:
125      * - If the caller is not `from`, it must be approved to move this NFT by
126      * either {approve} or {setApprovalForAll}.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129     function approve(address to, uint256 tokenId) external;
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     function setApprovalForAll(address operator, bool _approved) external;
133     function isApprovedForAll(address owner, address operator) external view returns (bool);
134 
135 
136     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
137 }
138 
139 
140 
141 
142 
143 /**
144  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
145  * @dev See https://eips.ethereum.org/EIPS/eip-721
146  */
147 interface IERC721Metadata is IERC721 {
148     function name() external view returns (string memory);
149     function symbol() external view returns (string memory);
150     function tokenURI(uint256 tokenId) external view returns (string memory);
151 }
152 
153 
154 
155 
156 
157 /**
158  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
159  * @dev See https://eips.ethereum.org/EIPS/eip-721
160  */
161 interface IERC721Enumerable is IERC721 {
162     function totalSupply() external view returns (uint256);
163     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
164 
165     function tokenByIndex(uint256 index) external view returns (uint256);
166 }
167 
168 
169 
170 /**
171  * @title ERC721 token receiver interface
172  * @dev Interface for any contract that wants to support safeTransfers
173  * from ERC721 asset contracts.
174  */
175 abstract contract IERC721Receiver {
176     /**
177      * @notice Handle the receipt of an NFT
178      * @dev The ERC721 smart contract calls this function on the recipient
179      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
180      * otherwise the caller will revert the transaction. The selector to be
181      * returned can be obtained as `this.onERC721Received.selector`. This
182      * function MAY throw to revert and reject the transfer.
183      * Note: the ERC721 contract address is always the message sender.
184      * @param operator The address which called `safeTransferFrom` function
185      * @param from The address which previously owned the token
186      * @param tokenId The NFT identifier which is being transferred
187      * @param data Additional data with no specified format
188      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
189      */
190     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
191     public virtual returns (bytes4);
192 }
193 
194 
195 
196 
197 
198 /**
199  * @dev Implementation of the {IERC165} interface.
200  *
201  * Contracts may inherit from this and call {_registerInterface} to declare
202  * their support of an interface.
203  */
204 contract ERC165 is IERC165 {
205     /*
206      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
207      */
208     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
209 
210     /**
211      * @dev Mapping of interface ids to whether or not it's supported.
212      */
213     mapping(bytes4 => bool) private _supportedInterfaces;
214 
215     constructor () internal {
216         // Derived contracts need only register support for their own interfaces,
217         // we register support for ERC165 itself here
218         _registerInterface(_INTERFACE_ID_ERC165);
219     }
220 
221     /**
222      * @dev See {IERC165-supportsInterface}.
223      *
224      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
225      */
226     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
227         return _supportedInterfaces[interfaceId];
228     }
229 
230     /**
231      * @dev Registers the contract as an implementer of the interface defined by
232      * `interfaceId`. Support of the actual ERC165 interface is automatic and
233      * registering its interface id is not required.
234      *
235      * See {IERC165-supportsInterface}.
236      *
237      * Requirements:
238      *
239      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
240      */
241     function _registerInterface(bytes4 interfaceId) internal virtual {
242         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
243         _supportedInterfaces[interfaceId] = true;
244     }
245 }
246 
247 
248 
249 /**
250  * @dev Wrappers over Solidity's arithmetic operations with added overflow
251  * checks.
252  *
253  * Arithmetic operations in Solidity wrap on overflow. This can easily result
254  * in bugs, because programmers usually assume that an overflow raises an
255  * error, which is the standard behavior in high level programming languages.
256  * `SafeMath` restores this intuition by reverting the transaction when an
257  * operation overflows.
258  *
259  * Using this library instead of the unchecked operations eliminates an entire
260  * class of bugs, so it's recommended to use it always.
261  */
262 library SafeMath {
263     /**
264      * @dev Returns the addition of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `+` operator.
268      *
269      * Requirements:
270      * - Addition cannot overflow.
271      */
272     function add(uint256 a, uint256 b) internal pure returns (uint256) {
273         uint256 c = a + b;
274         require(c >= a, "SafeMath: addition overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      * - Subtraction cannot overflow.
287      */
288     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289         return sub(a, b, "SafeMath: subtraction overflow");
290     }
291 
292     /**
293      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
294      * overflow (when the result is negative).
295      *
296      * Counterpart to Solidity's `-` operator.
297      *
298      * Requirements:
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         uint256 c = a - b;
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the multiplication of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `*` operator.
313      *
314      * Requirements:
315      * - Multiplication cannot overflow.
316      */
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
319         // benefit is lost if 'b' is also tested.
320         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
321         if (a == 0) {
322             return 0;
323         }
324 
325         uint256 c = a * b;
326         require(c / a == b, "SafeMath: multiplication overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the integer division of two unsigned integers. Reverts on
333      * division by zero. The result is rounded towards zero.
334      *
335      * Counterpart to Solidity's `/` operator. Note: this function uses a
336      * `revert` opcode (which leaves remaining gas untouched) while Solidity
337      * uses an invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      */
342     function div(uint256 a, uint256 b) internal pure returns (uint256) {
343         return div(a, b, "SafeMath: division by zero");
344     }
345 
346     /**
347      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
348      * division by zero. The result is rounded towards zero.
349      *
350      * Counterpart to Solidity's `/` operator. Note: this function uses a
351      * `revert` opcode (which leaves remaining gas untouched) while Solidity
352      * uses an invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      * - The divisor cannot be zero.
356      */
357     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
358         // Solidity only automatically asserts when dividing by 0
359         require(b > 0, errorMessage);
360         uint256 c = a / b;
361         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
368      * Reverts when dividing by zero.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      * - The divisor cannot be zero.
376      */
377     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
378         return mod(a, b, "SafeMath: modulo by zero");
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
383      * Reverts with custom message when dividing by zero.
384      *
385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
386      * opcode (which leaves remaining gas untouched) while Solidity uses an
387      * invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      * - The divisor cannot be zero.
391      */
392     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
393         require(b != 0, errorMessage);
394         return a % b;
395     }
396 }
397 
398 
399 
400 /**
401  * @dev Collection of functions related to the address type
402  */
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
423         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
424         // for accounts without code, i.e. `keccak256('')`
425         bytes32 codehash;
426         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
427         // solhint-disable-next-line no-inline-assembly
428         assembly { codehash := extcodehash(account) }
429         return (codehash != accountHash && codehash != 0x0);
430     }
431 
432     /**
433      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
434      * `recipient`, forwarding all available gas and reverting on errors.
435      *
436      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
437      * of certain opcodes, possibly making contracts go over the 2300 gas limit
438      * imposed by `transfer`, making them unable to receive funds via
439      * `transfer`. {sendValue} removes this limitation.
440      *
441      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
442      *
443      * IMPORTANT: because control is transferred to `recipient`, care must be
444      * taken to not create reentrancy vulnerabilities. Consider using
445      * {ReentrancyGuard} or the
446      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
447      */
448     function sendValue(address payable recipient, uint256 amount) internal {
449         require(address(this).balance >= amount, "Address: insufficient balance");
450 
451         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
452         (bool success, ) = recipient.call{ value: amount }("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 }
456 
457 
458 
459 /**
460  * @dev Library for managing
461  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
462  * types.
463  *
464  * Sets have the following properties:
465  *
466  * - Elements are added, removed, and checked for existence in constant time
467  * (O(1)).
468  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
469  *
470  * ```
471  * contract Example {
472  *     // Add the library methods
473  *     using EnumerableSet for EnumerableSet.AddressSet;
474  *
475  *     // Declare a set state variable
476  *     EnumerableSet.AddressSet private mySet;
477  * }
478  * ```
479  *
480  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
481  * (`UintSet`) are supported.
482  */
483 library EnumerableSet {
484     // To implement this library for multiple types with as little code
485     // repetition as possible, we write it in terms of a generic Set type with
486     // bytes32 values.
487     // The Set implementation uses private functions, and user-facing
488     // implementations (such as AddressSet) are just wrappers around the
489     // underlying Set.
490     // This means that we can only create new EnumerableSets for types that fit
491     // in bytes32.
492 
493     struct Set {
494         // Storage of set values
495         bytes32[] _values;
496 
497         // Position of the value in the `values` array, plus 1 because index 0
498         // means a value is not in the set.
499         mapping (bytes32 => uint256) _indexes;
500     }
501 
502     /**
503      * @dev Add a value to a set. O(1).
504      *
505      * Returns true if the value was added to the set, that is if it was not
506      * already present.
507      */
508     function _add(Set storage set, bytes32 value) private returns (bool) {
509         if (!_contains(set, value)) {
510             set._values.push(value);
511             // The value is stored at length-1, but we add 1 to all indexes
512             // and use 0 as a sentinel value
513             set._indexes[value] = set._values.length;
514             return true;
515         } else {
516             return false;
517         }
518     }
519 
520     /**
521      * @dev Removes a value from a set. O(1).
522      *
523      * Returns true if the value was removed from the set, that is if it was
524      * present.
525      */
526     function _remove(Set storage set, bytes32 value) private returns (bool) {
527         // We read and store the value's index to prevent multiple reads from the same storage slot
528         uint256 valueIndex = set._indexes[value];
529 
530         if (valueIndex != 0) { // Equivalent to contains(set, value)
531             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
532             // the array, and then remove the last element (sometimes called as 'swap and pop').
533             // This modifies the order of the array, as noted in {at}.
534 
535             uint256 toDeleteIndex = valueIndex - 1;
536             uint256 lastIndex = set._values.length - 1;
537 
538             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
539             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
540 
541             bytes32 lastvalue = set._values[lastIndex];
542 
543             // Move the last value to the index where the value to delete is
544             set._values[toDeleteIndex] = lastvalue;
545             // Update the index for the moved value
546             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
547 
548             // Delete the slot where the moved value was stored
549             set._values.pop();
550 
551             // Delete the index for the deleted slot
552             delete set._indexes[value];
553 
554             return true;
555         } else {
556             return false;
557         }
558     }
559 
560     /**
561      * @dev Returns true if the value is in the set. O(1).
562      */
563     function _contains(Set storage set, bytes32 value) private view returns (bool) {
564         return set._indexes[value] != 0;
565     }
566 
567     /**
568      * @dev Returns the number of values on the set. O(1).
569      */
570     function _length(Set storage set) private view returns (uint256) {
571         return set._values.length;
572     }
573 
574    /**
575     * @dev Returns the value stored at position `index` in the set. O(1).
576     *
577     * Note that there are no guarantees on the ordering of values inside the
578     * array, and it may change when more values are added or removed.
579     *
580     * Requirements:
581     *
582     * - `index` must be strictly less than {length}.
583     */
584     function _at(Set storage set, uint256 index) private view returns (bytes32) {
585         require(set._values.length > index, "EnumerableSet: index out of bounds");
586         return set._values[index];
587     }
588 
589     // AddressSet
590 
591     struct AddressSet {
592         Set _inner;
593     }
594 
595     /**
596      * @dev Add a value to a set. O(1).
597      *
598      * Returns true if the value was added to the set, that is if it was not
599      * already present.
600      */
601     function add(AddressSet storage set, address value) internal returns (bool) {
602         return _add(set._inner, bytes32(uint256(value)));
603     }
604 
605     /**
606      * @dev Removes a value from a set. O(1).
607      *
608      * Returns true if the value was removed from the set, that is if it was
609      * present.
610      */
611     function remove(AddressSet storage set, address value) internal returns (bool) {
612         return _remove(set._inner, bytes32(uint256(value)));
613     }
614 
615     /**
616      * @dev Returns true if the value is in the set. O(1).
617      */
618     function contains(AddressSet storage set, address value) internal view returns (bool) {
619         return _contains(set._inner, bytes32(uint256(value)));
620     }
621 
622     /**
623      * @dev Returns the number of values in the set. O(1).
624      */
625     function length(AddressSet storage set) internal view returns (uint256) {
626         return _length(set._inner);
627     }
628 
629    /**
630     * @dev Returns the value stored at position `index` in the set. O(1).
631     *
632     * Note that there are no guarantees on the ordering of values inside the
633     * array, and it may change when more values are added or removed.
634     *
635     * Requirements:
636     *
637     * - `index` must be strictly less than {length}.
638     */
639     function at(AddressSet storage set, uint256 index) internal view returns (address) {
640         return address(uint256(_at(set._inner, index)));
641     }
642 
643 
644     // UintSet
645 
646     struct UintSet {
647         Set _inner;
648     }
649 
650     /**
651      * @dev Add a value to a set. O(1).
652      *
653      * Returns true if the value was added to the set, that is if it was not
654      * already present.
655      */
656     function add(UintSet storage set, uint256 value) internal returns (bool) {
657         return _add(set._inner, bytes32(value));
658     }
659 
660     /**
661      * @dev Removes a value from a set. O(1).
662      *
663      * Returns true if the value was removed from the set, that is if it was
664      * present.
665      */
666     function remove(UintSet storage set, uint256 value) internal returns (bool) {
667         return _remove(set._inner, bytes32(value));
668     }
669 
670     /**
671      * @dev Returns true if the value is in the set. O(1).
672      */
673     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
674         return _contains(set._inner, bytes32(value));
675     }
676 
677     /**
678      * @dev Returns the number of values on the set. O(1).
679      */
680     function length(UintSet storage set) internal view returns (uint256) {
681         return _length(set._inner);
682     }
683 
684    /**
685     * @dev Returns the value stored at position `index` in the set. O(1).
686     *
687     * Note that there are no guarantees on the ordering of values inside the
688     * array, and it may change when more values are added or removed.
689     *
690     * Requirements:
691     *
692     * - `index` must be strictly less than {length}.
693     */
694     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
695         return uint256(_at(set._inner, index));
696     }
697 }
698 
699 
700 
701 /**
702  * @dev Library for managing an enumerable variant of Solidity's
703  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
704  * type.
705  *
706  * Maps have the following properties:
707  *
708  * - Entries are added, removed, and checked for existence in constant time
709  * (O(1)).
710  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
711  *
712  * ```
713  * contract Example {
714  *     // Add the library methods
715  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
716  *
717  *     // Declare a set state variable
718  *     EnumerableMap.UintToAddressMap private myMap;
719  * }
720  * ```
721  *
722  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
723  * supported.
724  */
725 library EnumerableMap {
726     // To implement this library for multiple types with as little code
727     // repetition as possible, we write it in terms of a generic Map type with
728     // bytes32 keys and values.
729     // The Map implementation uses private functions, and user-facing
730     // implementations (such as Uint256ToAddressMap) are just wrappers around
731     // the underlying Map.
732     // This means that we can only create new EnumerableMaps for types that fit
733     // in bytes32.
734 
735     struct MapEntry {
736         bytes32 _key;
737         bytes32 _value;
738     }
739 
740     struct Map {
741         // Storage of map keys and values
742         MapEntry[] _entries;
743 
744         // Position of the entry defined by a key in the `entries` array, plus 1
745         // because index 0 means a key is not in the map.
746         mapping (bytes32 => uint256) _indexes;
747     }
748 
749     /**
750      * @dev Adds a key-value pair to a map, or updates the value for an existing
751      * key. O(1).
752      *
753      * Returns true if the key was added to the map, that is if it was not
754      * already present.
755      */
756     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
757         // We read and store the key's index to prevent multiple reads from the same storage slot
758         uint256 keyIndex = map._indexes[key];
759 
760         if (keyIndex == 0) { // Equivalent to !contains(map, key)
761             map._entries.push(MapEntry({ _key: key, _value: value }));
762             // The entry is stored at length-1, but we add 1 to all indexes
763             // and use 0 as a sentinel value
764             map._indexes[key] = map._entries.length;
765             return true;
766         } else {
767             map._entries[keyIndex - 1]._value = value;
768             return false;
769         }
770     }
771 
772     /**
773      * @dev Removes a key-value pair from a map. O(1).
774      *
775      * Returns true if the key was removed from the map, that is if it was present.
776      */
777     function _remove(Map storage map, bytes32 key) private returns (bool) {
778         // We read and store the key's index to prevent multiple reads from the same storage slot
779         uint256 keyIndex = map._indexes[key];
780 
781         if (keyIndex != 0) { // Equivalent to contains(map, key)
782             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
783             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
784             // This modifies the order of the array, as noted in {at}.
785 
786             uint256 toDeleteIndex = keyIndex - 1;
787             uint256 lastIndex = map._entries.length - 1;
788 
789             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
790             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
791 
792             MapEntry storage lastEntry = map._entries[lastIndex];
793 
794             // Move the last entry to the index where the entry to delete is
795             map._entries[toDeleteIndex] = lastEntry;
796             // Update the index for the moved entry
797             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
798 
799             // Delete the slot where the moved entry was stored
800             map._entries.pop();
801 
802             // Delete the index for the deleted slot
803             delete map._indexes[key];
804 
805             return true;
806         } else {
807             return false;
808         }
809     }
810 
811     /**
812      * @dev Returns true if the key is in the map. O(1).
813      */
814     function _contains(Map storage map, bytes32 key) private view returns (bool) {
815         return map._indexes[key] != 0;
816     }
817 
818     /**
819      * @dev Returns the number of key-value pairs in the map. O(1).
820      */
821     function _length(Map storage map) private view returns (uint256) {
822         return map._entries.length;
823     }
824 
825    /**
826     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
827     *
828     * Note that there are no guarantees on the ordering of entries inside the
829     * array, and it may change when more entries are added or removed.
830     *
831     * Requirements:
832     *
833     * - `index` must be strictly less than {length}.
834     */
835     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
836         require(map._entries.length > index, "EnumerableMap: index out of bounds");
837 
838         MapEntry storage entry = map._entries[index];
839         return (entry._key, entry._value);
840     }
841 
842     /**
843      * @dev Returns the value associated with `key`.  O(1).
844      *
845      * Requirements:
846      *
847      * - `key` must be in the map.
848      */
849     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
850         return _get(map, key, "EnumerableMap: nonexistent key");
851     }
852 
853     /**
854      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
855      */
856     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
857         uint256 keyIndex = map._indexes[key];
858         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
859         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
860     }
861 
862     // UintToAddressMap
863 
864     struct UintToAddressMap {
865         Map _inner;
866     }
867 
868     /**
869      * @dev Adds a key-value pair to a map, or updates the value for an existing
870      * key. O(1).
871      *
872      * Returns true if the key was added to the map, that is if it was not
873      * already present.
874      */
875     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
876         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
877     }
878 
879     /**
880      * @dev Removes a value from a set. O(1).
881      *
882      * Returns true if the key was removed from the map, that is if it was present.
883      */
884     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
885         return _remove(map._inner, bytes32(key));
886     }
887 
888     /**
889      * @dev Returns true if the key is in the map. O(1).
890      */
891     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
892         return _contains(map._inner, bytes32(key));
893     }
894 
895     /**
896      * @dev Returns the number of elements in the map. O(1).
897      */
898     function length(UintToAddressMap storage map) internal view returns (uint256) {
899         return _length(map._inner);
900     }
901 
902    /**
903     * @dev Returns the element stored at position `index` in the set. O(1).
904     * Note that there are no guarantees on the ordering of values inside the
905     * array, and it may change when more values are added or removed.
906     *
907     * Requirements:
908     *
909     * - `index` must be strictly less than {length}.
910     */
911     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
912         (bytes32 key, bytes32 value) = _at(map._inner, index);
913         return (uint256(key), address(uint256(value)));
914     }
915 
916     /**
917      * @dev Returns the value associated with `key`.  O(1).
918      *
919      * Requirements:
920      *
921      * - `key` must be in the map.
922      */
923     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
924         return address(uint256(_get(map._inner, bytes32(key))));
925     }
926 
927     /**
928      * @dev Same as {get}, with a custom error message when `key` is not in the map.
929      */
930     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
931         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
932     }
933 }
934 
935 
936 
937 /**
938  * @title ERC721 Non-Fungible Token Standard basic implementation
939  * @dev see https://eips.ethereum.org/EIPS/eip-721
940  */
941 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
942     using SafeMath for uint256;
943     using Address for address;
944     using EnumerableSet for EnumerableSet.UintSet;
945     using EnumerableMap for EnumerableMap.UintToAddressMap;
946     using Strings for uint256;
947 
948     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
949     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
950     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
951 
952     // Mapping from holder address to their (enumerable) set of owned tokens
953     mapping (address => EnumerableSet.UintSet) private _holderTokens;
954 
955     // Enumerable mapping from token ids to their owners
956     EnumerableMap.UintToAddressMap private _tokenOwners;
957 
958     // Mapping from token ID to approved address
959     mapping (uint256 => address) private _tokenApprovals;
960 
961     // Mapping from owner to operator approvals
962     mapping (address => mapping (address => bool)) private _operatorApprovals;
963 
964     // Token name
965     string private _name;
966 
967     // Token symbol
968     string private _symbol;
969 
970     // Optional mapping for token URIs
971     mapping(uint256 => string) private _tokenURIs;
972 
973     // Base URI
974     string private _baseURI;
975 
976     /*
977      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
978      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
979      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
980      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
981      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
982      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
983      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
984      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
985      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
986      *
987      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
988      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
989      */
990     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
991 
992     /*
993      *     bytes4(keccak256('name()')) == 0x06fdde03
994      *     bytes4(keccak256('symbol()')) == 0x95d89b41
995      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
996      *
997      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
998      */
999     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1000 
1001     /*
1002      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1003      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1004      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1005      *
1006      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1007      */
1008     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1009 
1010     constructor (string memory name, string memory symbol) public {
1011         _name = name;
1012         _symbol = symbol;
1013 
1014         // register the supported interfaces to conform to ERC721 via ERC165
1015         _registerInterface(_INTERFACE_ID_ERC721);
1016         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1017         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1018     }
1019 
1020     /**
1021      * @dev Gets the balance of the specified address.
1022      * @param owner address to query the balance of
1023      * @return uint256 representing the amount owned by the passed address
1024      */
1025     function balanceOf(address owner) public view override returns (uint256) {
1026         require(owner != address(0), "ERC721: balance query for the zero address");
1027 
1028         return _holderTokens[owner].length();
1029     }
1030 
1031     /**
1032      * @dev Gets the owner of the specified token ID.
1033      * @param tokenId uint256 ID of the token to query the owner of
1034      * @return address currently marked as the owner of the given token ID
1035      */
1036     function ownerOf(uint256 tokenId) public view override returns (address) {
1037         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1038     }
1039 
1040     /**
1041      * @dev Gets the token name.
1042      * @return string representing the token name
1043      */
1044     function name() public view override returns (string memory) {
1045         return _name;
1046     }
1047 
1048     /**
1049      * @dev Gets the token symbol.
1050      * @return string representing the token symbol
1051      */
1052     function symbol() public view override returns (string memory) {
1053         return _symbol;
1054     }
1055 
1056     /**
1057      * @dev Returns the URI for a given token ID. May return an empty string.
1058      *
1059      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1060      * token's own URI (via {_setTokenURI}).
1061      *
1062      * If there is a base URI but no token URI, the token's ID will be used as
1063      * its URI when appending it to the base URI. This pattern for autogenerated
1064      * token URIs can lead to large gas savings.
1065      *
1066      * .Examples
1067      * |===
1068      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1069      * | ""
1070      * | ""
1071      * | ""
1072      * | ""
1073      * | "token.uri/123"
1074      * | "token.uri/123"
1075      * | "token.uri/"
1076      * | "123"
1077      * | "token.uri/123"
1078      * | "token.uri/"
1079      * | ""
1080      * | "token.uri/<tokenId>"
1081      * |===
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      */
1087     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1088         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1089 
1090         string memory _tokenURI = _tokenURIs[tokenId];
1091 
1092         // If there is no base URI, return the token URI.
1093         if (bytes(_baseURI).length == 0) {
1094             return _tokenURI;
1095         }
1096         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1097         if (bytes(_tokenURI).length > 0) {
1098             return string(abi.encodePacked(_baseURI, _tokenURI));
1099         }
1100         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1101         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1102     }
1103 
1104     /**
1105     * @dev Returns the base URI set via {_setBaseURI}. This will be
1106     * automatically added as a prefix in {tokenURI} to each token's URI, or
1107     * to the token ID if no specific URI is set for that token ID.
1108     */
1109     function baseURI() public view returns (string memory) {
1110         return _baseURI;
1111     }
1112 
1113     /**
1114      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1115      * @param owner address owning the tokens list to be accessed
1116      * @param index uint256 representing the index to be accessed of the requested tokens list
1117      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1120         return _holderTokens[owner].at(index);
1121     }
1122 
1123     /**
1124      * @dev Gets the total amount of tokens stored by the contract.
1125      * @return uint256 representing the total amount of tokens
1126      */
1127     function totalSupply() public view override returns (uint256) {
1128         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1129         return _tokenOwners.length();
1130     }
1131 
1132     /**
1133      * @dev Gets the token ID at a given index of all the tokens in this contract
1134      * Reverts if the index is greater or equal to the total number of tokens.
1135      * @param index uint256 representing the index to be accessed of the tokens list
1136      * @return uint256 token ID at the given index of the tokens list
1137      */
1138     function tokenByIndex(uint256 index) public view override returns (uint256) {
1139         (uint256 tokenId, ) = _tokenOwners.at(index);
1140         return tokenId;
1141     }
1142 
1143     /**
1144      * @dev Approves another address to transfer the given token ID
1145      * The zero address indicates there is no approved address.
1146      * There can only be one approved address per token at a given time.
1147      * Can only be called by the token owner or an approved operator.
1148      * @param to address to be approved for the given token ID
1149      * @param tokenId uint256 ID of the token to be approved
1150      */
1151     function approve(address to, uint256 tokenId) public virtual override {
1152         address owner = ownerOf(tokenId);
1153         require(to != owner, "ERC721: approval to current owner");
1154 
1155         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1156             "ERC721: approve caller is not owner nor approved for all"
1157         );
1158 
1159         _approve(to, tokenId);
1160     }
1161 
1162     /**
1163      * @dev Gets the approved address for a token ID, or zero if no address set
1164      * Reverts if the token ID does not exist.
1165      * @param tokenId uint256 ID of the token to query the approval of
1166      * @return address currently approved for the given token ID
1167      */
1168     function getApproved(uint256 tokenId) public view override returns (address) {
1169         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1170 
1171         return _tokenApprovals[tokenId];
1172     }
1173 
1174     /**
1175      * @dev Sets or unsets the approval of a given operator
1176      * An operator is allowed to transfer all tokens of the sender on their behalf.
1177      * @param operator operator address to set the approval
1178      * @param approved representing the status of the approval to be set
1179      */
1180     function setApprovalForAll(address operator, bool approved) public virtual override {
1181         require(operator != _msgSender(), "ERC721: approve to caller");
1182 
1183         _operatorApprovals[_msgSender()][operator] = approved;
1184         emit ApprovalForAll(_msgSender(), operator, approved);
1185     }
1186 
1187     /**
1188      * @dev Tells whether an operator is approved by a given owner.
1189      * @param owner owner address which you want to query the approval of
1190      * @param operator operator address which you want to query the approval of
1191      * @return bool whether the given operator is approved by the given owner
1192      */
1193     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1194         return _operatorApprovals[owner][operator];
1195     }
1196 
1197     /**
1198      * @dev Transfers the ownership of a given token ID to another address.
1199      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1200      * Requires the msg.sender to be the owner, approved, or operator.
1201      * @param from current owner of the token
1202      * @param to address to receive the ownership of the given token ID
1203      * @param tokenId uint256 ID of the token to be transferred
1204      */
1205     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1206         //solhint-disable-next-line max-line-length
1207         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1208 
1209         _transfer(from, to, tokenId);
1210     }
1211 
1212     /**
1213      * @dev Safely transfers the ownership of a given token ID to another address
1214      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1215      * which is called upon a safe transfer, and return the magic value
1216      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1217      * the transfer is reverted.
1218      * Requires the msg.sender to be the owner, approved, or operator
1219      * @param from current owner of the token
1220      * @param to address to receive the ownership of the given token ID
1221      * @param tokenId uint256 ID of the token to be transferred
1222      */
1223     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1224         safeTransferFrom(from, to, tokenId, "");
1225     }
1226 
1227     /**
1228      * @dev Safely transfers the ownership of a given token ID to another address
1229      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1230      * which is called upon a safe transfer, and return the magic value
1231      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1232      * the transfer is reverted.
1233      * Requires the _msgSender() to be the owner, approved, or operator
1234      * @param from current owner of the token
1235      * @param to address to receive the ownership of the given token ID
1236      * @param tokenId uint256 ID of the token to be transferred
1237      * @param _data bytes data to send along with a safe transfer check
1238      */
1239     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1240         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1241         _safeTransfer(from, to, tokenId, _data);
1242     }
1243 
1244     /**
1245      * @dev Safely transfers the ownership of a given token ID to another address
1246      * If the target address is a contract, it must implement `onERC721Received`,
1247      * which is called upon a safe transfer, and return the magic value
1248      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1249      * the transfer is reverted.
1250      * Requires the msg.sender to be the owner, approved, or operator
1251      * @param from current owner of the token
1252      * @param to address to receive the ownership of the given token ID
1253      * @param tokenId uint256 ID of the token to be transferred
1254      * @param _data bytes data to send along with a safe transfer check
1255      */
1256     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1257         _transfer(from, to, tokenId);
1258         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1259     }
1260 
1261     /**
1262      * @dev Returns whether the specified token exists.
1263      * @param tokenId uint256 ID of the token to query the existence of
1264      * @return bool whether the token exists
1265      */
1266     function _exists(uint256 tokenId) internal view returns (bool) {
1267         return _tokenOwners.contains(tokenId);
1268     }
1269 
1270     /**
1271      * @dev Returns whether the given spender can transfer a given token ID.
1272      * @param spender address of the spender to query
1273      * @param tokenId uint256 ID of the token to be transferred
1274      * @return bool whether the msg.sender is approved for the given token ID,
1275      * is an operator of the owner, or is the owner of the token
1276      */
1277     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1278         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1279         address owner = ownerOf(tokenId);
1280         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1281     }
1282 
1283     /**
1284      * @dev Internal function to safely mint a new token.
1285      * Reverts if the given token ID already exists.
1286      * If the target address is a contract, it must implement `onERC721Received`,
1287      * which is called upon a safe transfer, and return the magic value
1288      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1289      * the transfer is reverted.
1290      * @param to The address that will own the minted token
1291      * @param tokenId uint256 ID of the token to be minted
1292      */
1293     function _safeMint(address to, uint256 tokenId) internal virtual {
1294         _safeMint(to, tokenId, "");
1295     }
1296 
1297     /**
1298      * @dev Internal function to safely mint a new token.
1299      * Reverts if the given token ID already exists.
1300      * If the target address is a contract, it must implement `onERC721Received`,
1301      * which is called upon a safe transfer, and return the magic value
1302      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1303      * the transfer is reverted.
1304      * @param to The address that will own the minted token
1305      * @param tokenId uint256 ID of the token to be minted
1306      * @param _data bytes data to send along with a safe transfer check
1307      */
1308     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1309         _mint(to, tokenId);
1310         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1311     }
1312 
1313     /**
1314      * @dev Internal function to mint a new token.
1315      * Reverts if the given token ID already exists.
1316      * @param to The address that will own the minted token
1317      * @param tokenId uint256 ID of the token to be minted
1318      */
1319     function _mint(address to, uint256 tokenId) internal virtual {
1320         require(to != address(0), "ERC721: mint to the zero address");
1321         require(!_exists(tokenId), "ERC721: token already minted");
1322 
1323         _beforeTokenTransfer(address(0), to, tokenId);
1324 
1325         _holderTokens[to].add(tokenId);
1326 
1327         _tokenOwners.set(tokenId, to);
1328 
1329         emit Transfer(address(0), to, tokenId);
1330     }
1331 
1332     /**
1333      * @dev Internal function to burn a specific token.
1334      * Reverts if the token does not exist.
1335      * @param tokenId uint256 ID of the token being burned
1336      */
1337     function _burn(uint256 tokenId) internal virtual {
1338         address owner = ownerOf(tokenId);
1339 
1340         _beforeTokenTransfer(owner, address(0), tokenId);
1341 
1342         // Clear approvals
1343         _approve(address(0), tokenId);
1344 
1345         // Clear metadata (if any)
1346         if (bytes(_tokenURIs[tokenId]).length != 0) {
1347             delete _tokenURIs[tokenId];
1348         }
1349 
1350         _holderTokens[owner].remove(tokenId);
1351 
1352         _tokenOwners.remove(tokenId);
1353 
1354         emit Transfer(owner, address(0), tokenId);
1355     }
1356 
1357     /**
1358      * @dev Internal function to transfer ownership of a given token ID to another address.
1359      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1360      * @param from current owner of the token
1361      * @param to address to receive the ownership of the given token ID
1362      * @param tokenId uint256 ID of the token to be transferred
1363      */
1364     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1365         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1366         require(to != address(0), "ERC721: transfer to the zero address");
1367 
1368         _beforeTokenTransfer(from, to, tokenId);
1369 
1370         // Clear approvals from the previous owner
1371         _approve(address(0), tokenId);
1372 
1373         _holderTokens[from].remove(tokenId);
1374         _holderTokens[to].add(tokenId);
1375 
1376         _tokenOwners.set(tokenId, to);
1377 
1378         emit Transfer(from, to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Internal function to set the token URI for a given token.
1383      *
1384      * Reverts if the token ID does not exist.
1385      *
1386      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1387      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1388      * it and save gas.
1389      */
1390     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1391         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1392         _tokenURIs[tokenId] = _tokenURI;
1393     }
1394 
1395     /**
1396      * @dev Internal function to set the base URI for all token IDs. It is
1397      * automatically added as a prefix to the value returned in {tokenURI},
1398      * or to the token ID if {tokenURI} is empty.
1399      */
1400     function _setBaseURI(string memory baseURI_) internal virtual {
1401         _baseURI = baseURI_;
1402     }
1403 
1404     /**
1405      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1406      * The call is not executed if the target address is not a contract.
1407      *
1408      * @param from address representing the previous owner of the given token ID
1409      * @param to target address that will receive the tokens
1410      * @param tokenId uint256 ID of the token to be transferred
1411      * @param _data bytes optional data to send along with the call
1412      * @return bool whether the call correctly returned the expected magic value
1413      */
1414     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1415         private returns (bool)
1416     {
1417         if (!to.isContract()) {
1418             return true;
1419         }
1420         // solhint-disable-next-line avoid-low-level-calls
1421         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1422             IERC721Receiver(to).onERC721Received.selector,
1423             _msgSender(),
1424             from,
1425             tokenId,
1426             _data
1427         ));
1428         if (!success) {
1429             if (returndata.length > 0) {
1430                 // solhint-disable-next-line no-inline-assembly
1431                 assembly {
1432                     let returndata_size := mload(returndata)
1433                     revert(add(32, returndata), returndata_size)
1434                 }
1435             } else {
1436                 revert("ERC721: transfer to non ERC721Receiver implementer");
1437             }
1438         } else {
1439             bytes4 retval = abi.decode(returndata, (bytes4));
1440             return (retval == _ERC721_RECEIVED);
1441         }
1442     }
1443 
1444     function _approve(address to, uint256 tokenId) private {
1445         _tokenApprovals[tokenId] = to;
1446         emit Approval(ownerOf(tokenId), to, tokenId);
1447     }
1448 
1449     /**
1450      * @dev Hook that is called before any token transfer. This includes minting
1451      * and burning.
1452      *
1453      * Calling conditions:
1454      *
1455      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1456      * transferred to `to`.
1457      * - when `from` is zero, `tokenId` will be minted for `to`.
1458      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1459      * - `from` and `to` are never both zero.
1460      *
1461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1462      */
1463     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1464 }
1465 
1466 /* SPDX-License-Identifier: <SPDX-License> */
1467 contract Froggies is ERC721("Froggie Frens", "FRENS"){
1468 
1469     address public owner;
1470     uint256 public price = 50000000000000000; // 0.05 eth
1471     uint256 public maxSupply = 10000;
1472     uint256 public maxPublicAvailableFroggies = 6969;
1473     uint256 public maxBurnAvailableFroggies = maxSupply - maxPublicAvailableFroggies;
1474 
1475     uint256 public froggiesMintedFromBurn;
1476     uint256 public froggiesMinted;
1477 
1478     bool public rerollEnabled;
1479     uint256 release;
1480     uint256 public counter = 0;
1481 
1482     constructor(uint256 _release) public {
1483         require(block.timestamp < _release);
1484         _setBaseURI("https://froggiefrens.xyz/token/");
1485         release = _release;
1486         owner = msg.sender;
1487         rerollEnabled = false;
1488     }
1489 
1490     function swamp(uint256 _amount) public payable{
1491         require(block.timestamp >= release, "Not yet available");
1492         require(_amount <= 5, "Only 5 per tx!");
1493         require((froggiesMinted + _amount) <= maxPublicAvailableFroggies, "Public Mint Sold Out");
1494         require(msg.value == (price * _amount), "Invalid Pricing");
1495 
1496         for(uint256 i = 0; i < _amount; i++) {
1497             _mint(msg.sender, counter);
1498             froggiesMinted += 1;
1499             counter += 1;
1500         }
1501     }
1502 
1503     function reroll(uint256[] memory _tokens) public {
1504         require(_tokens.length > 1);
1505         require(rerollEnabled || froggiesMinted == maxPublicAvailableFroggies, "Reroll not yet available");
1506         require(froggiesMintedFromBurn + (_tokens.length - 1) < maxBurnAvailableFroggies, "Invalid amount");
1507         for (uint256 i = 0; i < _tokens.length; i++) {
1508             require(ownerOf(_tokens[i]) == msg.sender, "You don't own these tokens!");
1509             _burn(_tokens[i]);
1510         }
1511 
1512         for(uint256 i = 0; i < _tokens.length - 1; i++) {
1513             _mint(msg.sender, counter);
1514             counter += 1;
1515             froggiesMintedFromBurn += 1;
1516         }
1517     }
1518 
1519     function mintCustom(address _to, uint256 _tokenID) public {
1520         require(msg.sender == owner);
1521         require(_tokenID > maxSupply);
1522         _mint(_to, _tokenID); 
1523     }
1524 
1525     function enableReroll() public {
1526         require(msg.sender == owner);
1527         rerollEnabled = true;
1528     }
1529 
1530     function setURI(string memory _uri) public {
1531         require(msg.sender == owner);
1532         _setBaseURI(_uri);
1533     }
1534 
1535     function changeOwner(address _newOwner) public {
1536         require(msg.sender == owner);
1537         owner = _newOwner;
1538     }
1539 
1540     function claimETH() public {
1541         require(msg.sender == owner);
1542         payable(owner).transfer(address(this).balance);
1543     }
1544 
1545 
1546 }