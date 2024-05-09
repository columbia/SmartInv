1 pragma solidity ^0.6.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 interface ICryptoPunk {
6     struct Offer {
7         bool isForSale;
8         uint punkIndex;
9         address seller;
10         uint minValue;          // in ether
11         address onlySellTo;     // specify to sell only to a specific person
12     }
13 
14     function punkIndexToAddress(uint punkIndex) external view returns (address);
15     function punksOfferedForSale(uint punkIndex) external view returns (Offer memory);
16     function buyPunk(uint punkIndex) external payable;
17     function transferPunk(address to, uint punkIndex) external;
18 }
19 
20 contract UserProxy {
21 
22     address private _owner;
23 
24     /**
25      * @dev Initializes the contract settings
26      */
27     constructor()
28     public
29     {
30         _owner = msg.sender;
31     }
32 
33     /**
34      * @dev Transfers punk to the smart contract owner
35      */
36     function transfer(address punkContract, uint256 punkIndex)
37     external
38     returns (bool)
39     {
40         if (_owner != msg.sender) {
41             return false;
42         }
43 
44         (bool result,) = punkContract.call(abi.encodeWithSignature("transferPunk(address,uint256)", _owner, punkIndex));
45 
46         return result;
47     }
48 
49 }
50 
51 /*
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with GSN meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 contract Context {
62     // Empty internal constructor, to prevent people from mistakenly deploying
63     // an instance of this contract, which should be used via inheritance.
64     constructor () internal { }
65 
66     function _msgSender() internal view virtual returns (address payable) {
67         return msg.sender;
68     }
69 
70     function _msgData() internal view virtual returns (bytes memory) {
71         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
72         return msg.data;
73     }
74 }
75 
76 /**
77  * @dev Interface of the ERC165 standard, as defined in the
78  * https://eips.ethereum.org/EIPS/eip-165[EIP].
79  *
80  * Implementers can declare support of contract interfaces, which can then be
81  * queried by others ({ERC165Checker}).
82  *
83  * For an implementation, see {ERC165}.
84  */
85 interface IERC165 {
86     /**
87      * @dev Returns true if this contract implements the interface defined by
88      * `interfaceId`. See the corresponding
89      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
90      * to learn more about how these ids are created.
91      *
92      * This function call must use less than 30 000 gas.
93      */
94     function supportsInterface(bytes4 interfaceId) external view returns (bool);
95 }
96 
97 /**
98  * @dev Required interface of an ERC721 compliant contract.
99  */
100 interface IERC721 is IERC165 {
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
103     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
104 
105     /**
106      * @dev Returns the number of NFTs in ``owner``'s account.
107      */
108     function balanceOf(address owner) external view returns (uint256 balance);
109 
110     /**
111      * @dev Returns the owner of the NFT specified by `tokenId`.
112      */
113     function ownerOf(uint256 tokenId) external view returns (address owner);
114 
115     /**
116      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
117      * another (`to`).
118      *
119      *
120      *
121      * Requirements:
122      * - `from`, `to` cannot be zero.
123      * - `tokenId` must be owned by `from`.
124      * - If the caller is not `from`, it must be have been allowed to move this
125      * NFT by either {approve} or {setApprovalForAll}.
126      */
127     function safeTransferFrom(address from, address to, uint256 tokenId) external;
128     /**
129      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
130      * another (`to`).
131      *
132      * Requirements:
133      * - If the caller is not `from`, it must be approved to move this NFT by
134      * either {approve} or {setApprovalForAll}.
135      */
136     function transferFrom(address from, address to, uint256 tokenId) external;
137     function approve(address to, uint256 tokenId) external;
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     function setApprovalForAll(address operator, bool _approved) external;
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143 
144     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
145 }
146 
147 /**
148  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
149  * @dev See https://eips.ethereum.org/EIPS/eip-721
150  */
151 interface IERC721Metadata is IERC721 {
152     function name() external view returns (string memory);
153     function symbol() external view returns (string memory);
154     function tokenURI(uint256 tokenId) external view returns (string memory);
155 }
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
168 /**
169  * @title ERC721 token receiver interface
170  * @dev Interface for any contract that wants to support safeTransfers
171  * from ERC721 asset contracts.
172  */
173 abstract contract IERC721Receiver {
174     /**
175      * @notice Handle the receipt of an NFT
176      * @dev The ERC721 smart contract calls this function on the recipient
177      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
178      * otherwise the caller will revert the transaction. The selector to be
179      * returned can be obtained as `this.onERC721Received.selector`. This
180      * function MAY throw to revert and reject the transfer.
181      * Note: the ERC721 contract address is always the message sender.
182      * @param operator The address which called `safeTransferFrom` function
183      * @param from The address which previously owned the token
184      * @param tokenId The NFT identifier which is being transferred
185      * @param data Additional data with no specified format
186      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
187      */
188     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
189     public virtual returns (bytes4);
190 }
191 
192 /**
193  * @dev Implementation of the {IERC165} interface.
194  *
195  * Contracts may inherit from this and call {_registerInterface} to declare
196  * their support of an interface.
197  */
198 contract ERC165 is IERC165 {
199     /*
200      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
201      */
202     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
203 
204     /**
205      * @dev Mapping of interface ids to whether or not it's supported.
206      */
207     mapping(bytes4 => bool) private _supportedInterfaces;
208 
209     constructor () internal {
210         // Derived contracts need only register support for their own interfaces,
211         // we register support for ERC165 itself here
212         _registerInterface(_INTERFACE_ID_ERC165);
213     }
214 
215     /**
216      * @dev See {IERC165-supportsInterface}.
217      *
218      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
219      */
220     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
221         return _supportedInterfaces[interfaceId];
222     }
223 
224     /**
225      * @dev Registers the contract as an implementer of the interface defined by
226      * `interfaceId`. Support of the actual ERC165 interface is automatic and
227      * registering its interface id is not required.
228      *
229      * See {IERC165-supportsInterface}.
230      *
231      * Requirements:
232      *
233      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
234      */
235     function _registerInterface(bytes4 interfaceId) internal virtual {
236         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
237         _supportedInterfaces[interfaceId] = true;
238     }
239 }
240 
241 /**
242  * @dev Wrappers over Solidity's arithmetic operations with added overflow
243  * checks.
244  *
245  * Arithmetic operations in Solidity wrap on overflow. This can easily result
246  * in bugs, because programmers usually assume that an overflow raises an
247  * error, which is the standard behavior in high level programming languages.
248  * `SafeMath` restores this intuition by reverting the transaction when an
249  * operation overflows.
250  *
251  * Using this library instead of the unchecked operations eliminates an entire
252  * class of bugs, so it's recommended to use it always.
253  */
254 library SafeMath {
255     /**
256      * @dev Returns the addition of two unsigned integers, reverting on
257      * overflow.
258      *
259      * Counterpart to Solidity's `+` operator.
260      *
261      * Requirements:
262      * - Addition cannot overflow.
263      */
264     function add(uint256 a, uint256 b) internal pure returns (uint256) {
265         uint256 c = a + b;
266         require(c >= a, "SafeMath: addition overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the subtraction of two unsigned integers, reverting on
273      * overflow (when the result is negative).
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return sub(a, b, "SafeMath: subtraction overflow");
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * Counterpart to Solidity's `-` operator.
289      *
290      * Requirements:
291      * - Subtraction cannot overflow.
292      */
293     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b <= a, errorMessage);
295         uint256 c = a - b;
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      * - Multiplication cannot overflow.
308      */
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
311         // benefit is lost if 'b' is also tested.
312         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
313         if (a == 0) {
314             return 0;
315         }
316 
317         uint256 c = a * b;
318         require(c / a == b, "SafeMath: multiplication overflow");
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      */
334     function div(uint256 a, uint256 b) internal pure returns (uint256) {
335         return div(a, b, "SafeMath: division by zero");
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
340      * division by zero. The result is rounded towards zero.
341      *
342      * Counterpart to Solidity's `/` operator. Note: this function uses a
343      * `revert` opcode (which leaves remaining gas untouched) while Solidity
344      * uses an invalid opcode to revert (consuming all remaining gas).
345      *
346      * Requirements:
347      * - The divisor cannot be zero.
348      */
349     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
350         // Solidity only automatically asserts when dividing by 0
351         require(b > 0, errorMessage);
352         uint256 c = a / b;
353         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
360      * Reverts when dividing by zero.
361      *
362      * Counterpart to Solidity's `%` operator. This function uses a `revert`
363      * opcode (which leaves remaining gas untouched) while Solidity uses an
364      * invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      * - The divisor cannot be zero.
368      */
369     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
370         return mod(a, b, "SafeMath: modulo by zero");
371     }
372 
373     /**
374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
375      * Reverts with custom message when dividing by zero.
376      *
377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
378      * opcode (which leaves remaining gas untouched) while Solidity uses an
379      * invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      * - The divisor cannot be zero.
383      */
384     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
385         require(b != 0, errorMessage);
386         return a % b;
387     }
388 }
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
413         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
414         // for accounts without code, i.e. `keccak256('')`
415         bytes32 codehash;
416         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
417         // solhint-disable-next-line no-inline-assembly
418         assembly { codehash := extcodehash(account) }
419         return (codehash != accountHash && codehash != 0x0);
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * IMPORTANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
442         (bool success, ) = recipient.call{ value: amount }("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 }
446 
447 /**
448  * @dev Library for managing
449  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
450  * types.
451  *
452  * Sets have the following properties:
453  *
454  * - Elements are added, removed, and checked for existence in constant time
455  * (O(1)).
456  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
457  *
458  * ```
459  * contract Example {
460  *     // Add the library methods
461  *     using EnumerableSet for EnumerableSet.AddressSet;
462  *
463  *     // Declare a set state variable
464  *     EnumerableSet.AddressSet private mySet;
465  * }
466  * ```
467  *
468  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
469  * (`UintSet`) are supported.
470  */
471 library EnumerableSet {
472     // To implement this library for multiple types with as little code
473     // repetition as possible, we write it in terms of a generic Set type with
474     // bytes32 values.
475     // The Set implementation uses private functions, and user-facing
476     // implementations (such as AddressSet) are just wrappers around the
477     // underlying Set.
478     // This means that we can only create new EnumerableSets for types that fit
479     // in bytes32.
480 
481     struct Set {
482         // Storage of set values
483         bytes32[] _values;
484 
485         // Position of the value in the `values` array, plus 1 because index 0
486         // means a value is not in the set.
487         mapping (bytes32 => uint256) _indexes;
488     }
489 
490     /**
491      * @dev Add a value to a set. O(1).
492      *
493      * Returns true if the value was added to the set, that is if it was not
494      * already present.
495      */
496     function _add(Set storage set, bytes32 value) private returns (bool) {
497         if (!_contains(set, value)) {
498             set._values.push(value);
499             // The value is stored at length-1, but we add 1 to all indexes
500             // and use 0 as a sentinel value
501             set._indexes[value] = set._values.length;
502             return true;
503         } else {
504             return false;
505         }
506     }
507 
508     /**
509      * @dev Removes a value from a set. O(1).
510      *
511      * Returns true if the value was removed from the set, that is if it was
512      * present.
513      */
514     function _remove(Set storage set, bytes32 value) private returns (bool) {
515         // We read and store the value's index to prevent multiple reads from the same storage slot
516         uint256 valueIndex = set._indexes[value];
517 
518         if (valueIndex != 0) { // Equivalent to contains(set, value)
519             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
520             // the array, and then remove the last element (sometimes called as 'swap and pop').
521             // This modifies the order of the array, as noted in {at}.
522 
523             uint256 toDeleteIndex = valueIndex - 1;
524             uint256 lastIndex = set._values.length - 1;
525 
526             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
527             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
528 
529             bytes32 lastvalue = set._values[lastIndex];
530 
531             // Move the last value to the index where the value to delete is
532             set._values[toDeleteIndex] = lastvalue;
533             // Update the index for the moved value
534             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
535 
536             // Delete the slot where the moved value was stored
537             set._values.pop();
538 
539             // Delete the index for the deleted slot
540             delete set._indexes[value];
541 
542             return true;
543         } else {
544             return false;
545         }
546     }
547 
548     /**
549      * @dev Returns true if the value is in the set. O(1).
550      */
551     function _contains(Set storage set, bytes32 value) private view returns (bool) {
552         return set._indexes[value] != 0;
553     }
554 
555     /**
556      * @dev Returns the number of values on the set. O(1).
557      */
558     function _length(Set storage set) private view returns (uint256) {
559         return set._values.length;
560     }
561 
562    /**
563     * @dev Returns the value stored at position `index` in the set. O(1).
564     *
565     * Note that there are no guarantees on the ordering of values inside the
566     * array, and it may change when more values are added or removed.
567     *
568     * Requirements:
569     *
570     * - `index` must be strictly less than {length}.
571     */
572     function _at(Set storage set, uint256 index) private view returns (bytes32) {
573         require(set._values.length > index, "EnumerableSet: index out of bounds");
574         return set._values[index];
575     }
576 
577     // AddressSet
578 
579     struct AddressSet {
580         Set _inner;
581     }
582 
583     /**
584      * @dev Add a value to a set. O(1).
585      *
586      * Returns true if the value was added to the set, that is if it was not
587      * already present.
588      */
589     function add(AddressSet storage set, address value) internal returns (bool) {
590         return _add(set._inner, bytes32(uint256(value)));
591     }
592 
593     /**
594      * @dev Removes a value from a set. O(1).
595      *
596      * Returns true if the value was removed from the set, that is if it was
597      * present.
598      */
599     function remove(AddressSet storage set, address value) internal returns (bool) {
600         return _remove(set._inner, bytes32(uint256(value)));
601     }
602 
603     /**
604      * @dev Returns true if the value is in the set. O(1).
605      */
606     function contains(AddressSet storage set, address value) internal view returns (bool) {
607         return _contains(set._inner, bytes32(uint256(value)));
608     }
609 
610     /**
611      * @dev Returns the number of values in the set. O(1).
612      */
613     function length(AddressSet storage set) internal view returns (uint256) {
614         return _length(set._inner);
615     }
616 
617    /**
618     * @dev Returns the value stored at position `index` in the set. O(1).
619     *
620     * Note that there are no guarantees on the ordering of values inside the
621     * array, and it may change when more values are added or removed.
622     *
623     * Requirements:
624     *
625     * - `index` must be strictly less than {length}.
626     */
627     function at(AddressSet storage set, uint256 index) internal view returns (address) {
628         return address(uint256(_at(set._inner, index)));
629     }
630 
631 
632     // UintSet
633 
634     struct UintSet {
635         Set _inner;
636     }
637 
638     /**
639      * @dev Add a value to a set. O(1).
640      *
641      * Returns true if the value was added to the set, that is if it was not
642      * already present.
643      */
644     function add(UintSet storage set, uint256 value) internal returns (bool) {
645         return _add(set._inner, bytes32(value));
646     }
647 
648     /**
649      * @dev Removes a value from a set. O(1).
650      *
651      * Returns true if the value was removed from the set, that is if it was
652      * present.
653      */
654     function remove(UintSet storage set, uint256 value) internal returns (bool) {
655         return _remove(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Returns true if the value is in the set. O(1).
660      */
661     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
662         return _contains(set._inner, bytes32(value));
663     }
664 
665     /**
666      * @dev Returns the number of values on the set. O(1).
667      */
668     function length(UintSet storage set) internal view returns (uint256) {
669         return _length(set._inner);
670     }
671 
672    /**
673     * @dev Returns the value stored at position `index` in the set. O(1).
674     *
675     * Note that there are no guarantees on the ordering of values inside the
676     * array, and it may change when more values are added or removed.
677     *
678     * Requirements:
679     *
680     * - `index` must be strictly less than {length}.
681     */
682     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
683         return uint256(_at(set._inner, index));
684     }
685 }
686 
687 /**
688  * @dev Library for managing an enumerable variant of Solidity's
689  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
690  * type.
691  *
692  * Maps have the following properties:
693  *
694  * - Entries are added, removed, and checked for existence in constant time
695  * (O(1)).
696  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
697  *
698  * ```
699  * contract Example {
700  *     // Add the library methods
701  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
702  *
703  *     // Declare a set state variable
704  *     EnumerableMap.UintToAddressMap private myMap;
705  * }
706  * ```
707  *
708  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
709  * supported.
710  */
711 library EnumerableMap {
712     // To implement this library for multiple types with as little code
713     // repetition as possible, we write it in terms of a generic Map type with
714     // bytes32 keys and values.
715     // The Map implementation uses private functions, and user-facing
716     // implementations (such as Uint256ToAddressMap) are just wrappers around
717     // the underlying Map.
718     // This means that we can only create new EnumerableMaps for types that fit
719     // in bytes32.
720 
721     struct MapEntry {
722         bytes32 _key;
723         bytes32 _value;
724     }
725 
726     struct Map {
727         // Storage of map keys and values
728         MapEntry[] _entries;
729 
730         // Position of the entry defined by a key in the `entries` array, plus 1
731         // because index 0 means a key is not in the map.
732         mapping (bytes32 => uint256) _indexes;
733     }
734 
735     /**
736      * @dev Adds a key-value pair to a map, or updates the value for an existing
737      * key. O(1).
738      *
739      * Returns true if the key was added to the map, that is if it was not
740      * already present.
741      */
742     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
743         // We read and store the key's index to prevent multiple reads from the same storage slot
744         uint256 keyIndex = map._indexes[key];
745 
746         if (keyIndex == 0) { // Equivalent to !contains(map, key)
747             map._entries.push(MapEntry({ _key: key, _value: value }));
748             // The entry is stored at length-1, but we add 1 to all indexes
749             // and use 0 as a sentinel value
750             map._indexes[key] = map._entries.length;
751             return true;
752         } else {
753             map._entries[keyIndex - 1]._value = value;
754             return false;
755         }
756     }
757 
758     /**
759      * @dev Removes a key-value pair from a map. O(1).
760      *
761      * Returns true if the key was removed from the map, that is if it was present.
762      */
763     function _remove(Map storage map, bytes32 key) private returns (bool) {
764         // We read and store the key's index to prevent multiple reads from the same storage slot
765         uint256 keyIndex = map._indexes[key];
766 
767         if (keyIndex != 0) { // Equivalent to contains(map, key)
768             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
769             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
770             // This modifies the order of the array, as noted in {at}.
771 
772             uint256 toDeleteIndex = keyIndex - 1;
773             uint256 lastIndex = map._entries.length - 1;
774 
775             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
776             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
777 
778             MapEntry storage lastEntry = map._entries[lastIndex];
779 
780             // Move the last entry to the index where the entry to delete is
781             map._entries[toDeleteIndex] = lastEntry;
782             // Update the index for the moved entry
783             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
784 
785             // Delete the slot where the moved entry was stored
786             map._entries.pop();
787 
788             // Delete the index for the deleted slot
789             delete map._indexes[key];
790 
791             return true;
792         } else {
793             return false;
794         }
795     }
796 
797     /**
798      * @dev Returns true if the key is in the map. O(1).
799      */
800     function _contains(Map storage map, bytes32 key) private view returns (bool) {
801         return map._indexes[key] != 0;
802     }
803 
804     /**
805      * @dev Returns the number of key-value pairs in the map. O(1).
806      */
807     function _length(Map storage map) private view returns (uint256) {
808         return map._entries.length;
809     }
810 
811    /**
812     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
813     *
814     * Note that there are no guarantees on the ordering of entries inside the
815     * array, and it may change when more entries are added or removed.
816     *
817     * Requirements:
818     *
819     * - `index` must be strictly less than {length}.
820     */
821     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
822         require(map._entries.length > index, "EnumerableMap: index out of bounds");
823 
824         MapEntry storage entry = map._entries[index];
825         return (entry._key, entry._value);
826     }
827 
828     /**
829      * @dev Returns the value associated with `key`.  O(1).
830      *
831      * Requirements:
832      *
833      * - `key` must be in the map.
834      */
835     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
836         return _get(map, key, "EnumerableMap: nonexistent key");
837     }
838 
839     /**
840      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
841      */
842     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
843         uint256 keyIndex = map._indexes[key];
844         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
845         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
846     }
847 
848     // UintToAddressMap
849 
850     struct UintToAddressMap {
851         Map _inner;
852     }
853 
854     /**
855      * @dev Adds a key-value pair to a map, or updates the value for an existing
856      * key. O(1).
857      *
858      * Returns true if the key was added to the map, that is if it was not
859      * already present.
860      */
861     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
862         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
863     }
864 
865     /**
866      * @dev Removes a value from a set. O(1).
867      *
868      * Returns true if the key was removed from the map, that is if it was present.
869      */
870     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
871         return _remove(map._inner, bytes32(key));
872     }
873 
874     /**
875      * @dev Returns true if the key is in the map. O(1).
876      */
877     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
878         return _contains(map._inner, bytes32(key));
879     }
880 
881     /**
882      * @dev Returns the number of elements in the map. O(1).
883      */
884     function length(UintToAddressMap storage map) internal view returns (uint256) {
885         return _length(map._inner);
886     }
887 
888    /**
889     * @dev Returns the element stored at position `index` in the set. O(1).
890     * Note that there are no guarantees on the ordering of values inside the
891     * array, and it may change when more values are added or removed.
892     *
893     * Requirements:
894     *
895     * - `index` must be strictly less than {length}.
896     */
897     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
898         (bytes32 key, bytes32 value) = _at(map._inner, index);
899         return (uint256(key), address(uint256(value)));
900     }
901 
902     /**
903      * @dev Returns the value associated with `key`.  O(1).
904      *
905      * Requirements:
906      *
907      * - `key` must be in the map.
908      */
909     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
910         return address(uint256(_get(map._inner, bytes32(key))));
911     }
912 
913     /**
914      * @dev Same as {get}, with a custom error message when `key` is not in the map.
915      */
916     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
917         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
918     }
919 }
920 
921 /**
922  * @dev String operations.
923  */
924 library Strings {
925     /**
926      * @dev Converts a `uint256` to its ASCII `string` representation.
927      */
928     function toString(uint256 value) internal pure returns (string memory) {
929         // Inspired by OraclizeAPI's implementation - MIT licence
930         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
931 
932         if (value == 0) {
933             return "0";
934         }
935         uint256 temp = value;
936         uint256 digits;
937         while (temp != 0) {
938             digits++;
939             temp /= 10;
940         }
941         bytes memory buffer = new bytes(digits);
942         uint256 index = digits - 1;
943         temp = value;
944         while (temp != 0) {
945             buffer[index--] = byte(uint8(48 + temp % 10));
946             temp /= 10;
947         }
948         return string(buffer);
949     }
950 }
951 
952 /**
953  * @title ERC721 Non-Fungible Token Standard basic implementation
954  * @dev see https://eips.ethereum.org/EIPS/eip-721
955  */
956 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
957     using SafeMath for uint256;
958     using Address for address;
959     using EnumerableSet for EnumerableSet.UintSet;
960     using EnumerableMap for EnumerableMap.UintToAddressMap;
961     using Strings for uint256;
962 
963     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
964     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
965     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
966 
967     // Mapping from holder address to their (enumerable) set of owned tokens
968     mapping (address => EnumerableSet.UintSet) private _holderTokens;
969 
970     // Enumerable mapping from token ids to their owners
971     EnumerableMap.UintToAddressMap private _tokenOwners;
972 
973     // Mapping from token ID to approved address
974     mapping (uint256 => address) private _tokenApprovals;
975 
976     // Mapping from owner to operator approvals
977     mapping (address => mapping (address => bool)) private _operatorApprovals;
978 
979     // Token name
980     string private _name;
981 
982     // Token symbol
983     string private _symbol;
984 
985     // Optional mapping for token URIs
986     mapping(uint256 => string) private _tokenURIs;
987 
988     // Base URI
989     string private _baseURI;
990 
991     /*
992      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
993      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
994      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
995      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
996      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
997      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
998      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
999      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1000      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1001      *
1002      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1003      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1004      */
1005     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1006 
1007     /*
1008      *     bytes4(keccak256('name()')) == 0x06fdde03
1009      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1010      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1011      *
1012      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1013      */
1014     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1015 
1016     /*
1017      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1018      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1019      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1020      *
1021      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1022      */
1023     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1024 
1025     constructor (string memory name, string memory symbol) public {
1026         _name = name;
1027         _symbol = symbol;
1028 
1029         // register the supported interfaces to conform to ERC721 via ERC165
1030         _registerInterface(_INTERFACE_ID_ERC721);
1031         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1032         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1033     }
1034 
1035     /**
1036      * @dev Gets the balance of the specified address.
1037      * @param owner address to query the balance of
1038      * @return uint256 representing the amount owned by the passed address
1039      */
1040     function balanceOf(address owner) public view override returns (uint256) {
1041         require(owner != address(0), "ERC721: balance query for the zero address");
1042 
1043         return _holderTokens[owner].length();
1044     }
1045 
1046     /**
1047      * @dev Gets the owner of the specified token ID.
1048      * @param tokenId uint256 ID of the token to query the owner of
1049      * @return address currently marked as the owner of the given token ID
1050      */
1051     function ownerOf(uint256 tokenId) public view override returns (address) {
1052         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1053     }
1054 
1055     /**
1056      * @dev Gets the token name.
1057      * @return string representing the token name
1058      */
1059     function name() public view override returns (string memory) {
1060         return _name;
1061     }
1062 
1063     /**
1064      * @dev Gets the token symbol.
1065      * @return string representing the token symbol
1066      */
1067     function symbol() public view override returns (string memory) {
1068         return _symbol;
1069     }
1070 
1071     /**
1072      * @dev Returns the URI for a given token ID. May return an empty string.
1073      *
1074      * If a base URI is set (via {_setBaseURI}), it is added as a prefix to the
1075      * token's own URI (via {_setTokenURI}).
1076      *
1077      * If there is a base URI but no token URI, the token's ID will be used as
1078      * its URI when appending it to the base URI. This pattern for autogenerated
1079      * token URIs can lead to large gas savings.
1080      *
1081      * .Examples
1082      * |===
1083      * |`_setBaseURI()` |`_setTokenURI()` |`tokenURI()`
1084      * | ""
1085      * | ""
1086      * | ""
1087      * | ""
1088      * | "token.uri/123"
1089      * | "token.uri/123"
1090      * | "token.uri/"
1091      * | "123"
1092      * | "token.uri/123"
1093      * | "token.uri/"
1094      * | ""
1095      * | "token.uri/<tokenId>"
1096      * |===
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      */
1102     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1103         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1104 
1105         string memory _tokenURI = _tokenURIs[tokenId];
1106 
1107         // If there is no base URI, return the token URI.
1108         if (bytes(_baseURI).length == 0) {
1109             return _tokenURI;
1110         }
1111         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1112         if (bytes(_tokenURI).length > 0) {
1113             return string(abi.encodePacked(_baseURI, _tokenURI));
1114         }
1115         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1116         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1117     }
1118 
1119     /**
1120     * @dev Returns the base URI set via {_setBaseURI}. This will be
1121     * automatically added as a prefix in {tokenURI} to each token's URI, or
1122     * to the token ID if no specific URI is set for that token ID.
1123     */
1124     function baseURI() public view returns (string memory) {
1125         return _baseURI;
1126     }
1127 
1128     /**
1129      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1130      * @param owner address owning the tokens list to be accessed
1131      * @param index uint256 representing the index to be accessed of the requested tokens list
1132      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1133      */
1134     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1135         return _holderTokens[owner].at(index);
1136     }
1137 
1138     /**
1139      * @dev Gets the total amount of tokens stored by the contract.
1140      * @return uint256 representing the total amount of tokens
1141      */
1142     function totalSupply() public view override returns (uint256) {
1143         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1144         return _tokenOwners.length();
1145     }
1146 
1147     /**
1148      * @dev Gets the token ID at a given index of all the tokens in this contract
1149      * Reverts if the index is greater or equal to the total number of tokens.
1150      * @param index uint256 representing the index to be accessed of the tokens list
1151      * @return uint256 token ID at the given index of the tokens list
1152      */
1153     function tokenByIndex(uint256 index) public view override returns (uint256) {
1154         (uint256 tokenId, ) = _tokenOwners.at(index);
1155         return tokenId;
1156     }
1157 
1158     /**
1159      * @dev Approves another address to transfer the given token ID
1160      * The zero address indicates there is no approved address.
1161      * There can only be one approved address per token at a given time.
1162      * Can only be called by the token owner or an approved operator.
1163      * @param to address to be approved for the given token ID
1164      * @param tokenId uint256 ID of the token to be approved
1165      */
1166     function approve(address to, uint256 tokenId) public virtual override {
1167         address owner = ownerOf(tokenId);
1168         require(to != owner, "ERC721: approval to current owner");
1169 
1170         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1171             "ERC721: approve caller is not owner nor approved for all"
1172         );
1173 
1174         _approve(to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev Gets the approved address for a token ID, or zero if no address set
1179      * Reverts if the token ID does not exist.
1180      * @param tokenId uint256 ID of the token to query the approval of
1181      * @return address currently approved for the given token ID
1182      */
1183     function getApproved(uint256 tokenId) public view override returns (address) {
1184         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1185 
1186         return _tokenApprovals[tokenId];
1187     }
1188 
1189     /**
1190      * @dev Sets or unsets the approval of a given operator
1191      * An operator is allowed to transfer all tokens of the sender on their behalf.
1192      * @param operator operator address to set the approval
1193      * @param approved representing the status of the approval to be set
1194      */
1195     function setApprovalForAll(address operator, bool approved) public virtual override {
1196         require(operator != _msgSender(), "ERC721: approve to caller");
1197 
1198         _operatorApprovals[_msgSender()][operator] = approved;
1199         emit ApprovalForAll(_msgSender(), operator, approved);
1200     }
1201 
1202     /**
1203      * @dev Tells whether an operator is approved by a given owner.
1204      * @param owner owner address which you want to query the approval of
1205      * @param operator operator address which you want to query the approval of
1206      * @return bool whether the given operator is approved by the given owner
1207      */
1208     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1209         return _operatorApprovals[owner][operator];
1210     }
1211 
1212     /**
1213      * @dev Transfers the ownership of a given token ID to another address.
1214      * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1215      * Requires the msg.sender to be the owner, approved, or operator.
1216      * @param from current owner of the token
1217      * @param to address to receive the ownership of the given token ID
1218      * @param tokenId uint256 ID of the token to be transferred
1219      */
1220     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1221         //solhint-disable-next-line max-line-length
1222         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1223 
1224         _transfer(from, to, tokenId);
1225     }
1226 
1227     /**
1228      * @dev Safely transfers the ownership of a given token ID to another address
1229      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1230      * which is called upon a safe transfer, and return the magic value
1231      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1232      * the transfer is reverted.
1233      * Requires the msg.sender to be the owner, approved, or operator
1234      * @param from current owner of the token
1235      * @param to address to receive the ownership of the given token ID
1236      * @param tokenId uint256 ID of the token to be transferred
1237      */
1238     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1239         safeTransferFrom(from, to, tokenId, "");
1240     }
1241 
1242     /**
1243      * @dev Safely transfers the ownership of a given token ID to another address
1244      * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
1245      * which is called upon a safe transfer, and return the magic value
1246      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1247      * the transfer is reverted.
1248      * Requires the _msgSender() to be the owner, approved, or operator
1249      * @param from current owner of the token
1250      * @param to address to receive the ownership of the given token ID
1251      * @param tokenId uint256 ID of the token to be transferred
1252      * @param _data bytes data to send along with a safe transfer check
1253      */
1254     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1255         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1256         _safeTransfer(from, to, tokenId, _data);
1257     }
1258 
1259     /**
1260      * @dev Safely transfers the ownership of a given token ID to another address
1261      * If the target address is a contract, it must implement `onERC721Received`,
1262      * which is called upon a safe transfer, and return the magic value
1263      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1264      * the transfer is reverted.
1265      * Requires the msg.sender to be the owner, approved, or operator
1266      * @param from current owner of the token
1267      * @param to address to receive the ownership of the given token ID
1268      * @param tokenId uint256 ID of the token to be transferred
1269      * @param _data bytes data to send along with a safe transfer check
1270      */
1271     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1272         _transfer(from, to, tokenId);
1273         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1274     }
1275 
1276     /**
1277      * @dev Returns whether the specified token exists.
1278      * @param tokenId uint256 ID of the token to query the existence of
1279      * @return bool whether the token exists
1280      */
1281     function _exists(uint256 tokenId) internal view returns (bool) {
1282         return _tokenOwners.contains(tokenId);
1283     }
1284 
1285     /**
1286      * @dev Returns whether the given spender can transfer a given token ID.
1287      * @param spender address of the spender to query
1288      * @param tokenId uint256 ID of the token to be transferred
1289      * @return bool whether the msg.sender is approved for the given token ID,
1290      * is an operator of the owner, or is the owner of the token
1291      */
1292     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1293         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1294         address owner = ownerOf(tokenId);
1295         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1296     }
1297 
1298     /**
1299      * @dev Internal function to safely mint a new token.
1300      * Reverts if the given token ID already exists.
1301      * If the target address is a contract, it must implement `onERC721Received`,
1302      * which is called upon a safe transfer, and return the magic value
1303      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1304      * the transfer is reverted.
1305      * @param to The address that will own the minted token
1306      * @param tokenId uint256 ID of the token to be minted
1307      */
1308     function _safeMint(address to, uint256 tokenId) internal virtual {
1309         _safeMint(to, tokenId, "");
1310     }
1311 
1312     /**
1313      * @dev Internal function to safely mint a new token.
1314      * Reverts if the given token ID already exists.
1315      * If the target address is a contract, it must implement `onERC721Received`,
1316      * which is called upon a safe transfer, and return the magic value
1317      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1318      * the transfer is reverted.
1319      * @param to The address that will own the minted token
1320      * @param tokenId uint256 ID of the token to be minted
1321      * @param _data bytes data to send along with a safe transfer check
1322      */
1323     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1324         _mint(to, tokenId);
1325         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1326     }
1327 
1328     /**
1329      * @dev Internal function to mint a new token.
1330      * Reverts if the given token ID already exists.
1331      * @param to The address that will own the minted token
1332      * @param tokenId uint256 ID of the token to be minted
1333      */
1334     function _mint(address to, uint256 tokenId) internal virtual {
1335         require(to != address(0), "ERC721: mint to the zero address");
1336         require(!_exists(tokenId), "ERC721: token already minted");
1337 
1338         _beforeTokenTransfer(address(0), to, tokenId);
1339 
1340         _holderTokens[to].add(tokenId);
1341 
1342         _tokenOwners.set(tokenId, to);
1343 
1344         emit Transfer(address(0), to, tokenId);
1345     }
1346 
1347     /**
1348      * @dev Internal function to burn a specific token.
1349      * Reverts if the token does not exist.
1350      * @param tokenId uint256 ID of the token being burned
1351      */
1352     function _burn(uint256 tokenId) internal virtual {
1353         address owner = ownerOf(tokenId);
1354 
1355         _beforeTokenTransfer(owner, address(0), tokenId);
1356 
1357         // Clear approvals
1358         _approve(address(0), tokenId);
1359 
1360         // Clear metadata (if any)
1361         if (bytes(_tokenURIs[tokenId]).length != 0) {
1362             delete _tokenURIs[tokenId];
1363         }
1364 
1365         _holderTokens[owner].remove(tokenId);
1366 
1367         _tokenOwners.remove(tokenId);
1368 
1369         emit Transfer(owner, address(0), tokenId);
1370     }
1371 
1372     /**
1373      * @dev Internal function to transfer ownership of a given token ID to another address.
1374      * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1375      * @param from current owner of the token
1376      * @param to address to receive the ownership of the given token ID
1377      * @param tokenId uint256 ID of the token to be transferred
1378      */
1379     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1380         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1381         require(to != address(0), "ERC721: transfer to the zero address");
1382 
1383         _beforeTokenTransfer(from, to, tokenId);
1384 
1385         // Clear approvals from the previous owner
1386         _approve(address(0), tokenId);
1387 
1388         _holderTokens[from].remove(tokenId);
1389         _holderTokens[to].add(tokenId);
1390 
1391         _tokenOwners.set(tokenId, to);
1392 
1393         emit Transfer(from, to, tokenId);
1394     }
1395 
1396     /**
1397      * @dev Internal function to set the token URI for a given token.
1398      *
1399      * Reverts if the token ID does not exist.
1400      *
1401      * TIP: If all token IDs share a prefix (for example, if your URIs look like
1402      * `https://api.myproject.com/token/<id>`), use {_setBaseURI} to store
1403      * it and save gas.
1404      */
1405     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1406         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1407         _tokenURIs[tokenId] = _tokenURI;
1408     }
1409 
1410     /**
1411      * @dev Internal function to set the base URI for all token IDs. It is
1412      * automatically added as a prefix to the value returned in {tokenURI},
1413      * or to the token ID if {tokenURI} is empty.
1414      */
1415     function _setBaseURI(string memory baseURI_) internal virtual {
1416         _baseURI = baseURI_;
1417     }
1418 
1419     /**
1420      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1421      * The call is not executed if the target address is not a contract.
1422      *
1423      * @param from address representing the previous owner of the given token ID
1424      * @param to target address that will receive the tokens
1425      * @param tokenId uint256 ID of the token to be transferred
1426      * @param _data bytes optional data to send along with the call
1427      * @return bool whether the call correctly returned the expected magic value
1428      */
1429     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1430         private returns (bool)
1431     {
1432         if (!to.isContract()) {
1433             return true;
1434         }
1435         // solhint-disable-next-line avoid-low-level-calls
1436         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
1437             IERC721Receiver(to).onERC721Received.selector,
1438             _msgSender(),
1439             from,
1440             tokenId,
1441             _data
1442         ));
1443         if (!success) {
1444             if (returndata.length > 0) {
1445                 // solhint-disable-next-line no-inline-assembly
1446                 assembly {
1447                     let returndata_size := mload(returndata)
1448                     revert(add(32, returndata), returndata_size)
1449                 }
1450             } else {
1451                 revert("ERC721: transfer to non ERC721Receiver implementer");
1452             }
1453         } else {
1454             bytes4 retval = abi.decode(returndata, (bytes4));
1455             return (retval == _ERC721_RECEIVED);
1456         }
1457     }
1458 
1459     function _approve(address to, uint256 tokenId) private {
1460         _tokenApprovals[tokenId] = to;
1461         emit Approval(ownerOf(tokenId), to, tokenId);
1462     }
1463 
1464     /**
1465      * @dev Hook that is called before any token transfer. This includes minting
1466      * and burning.
1467      *
1468      * Calling conditions:
1469      *
1470      * - when `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1471      * transferred to `to`.
1472      * - when `from` is zero, `tokenId` will be minted for `to`.
1473      * - when `to` is zero, ``from``'s `tokenId` will be burned.
1474      * - `from` and `to` are never both zero.
1475      *
1476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1477      */
1478     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1479 }
1480 
1481 /**
1482  * @dev Contract module which provides a basic access control mechanism, where
1483  * there is an account (an owner) that can be granted exclusive access to
1484  * specific functions.
1485  *
1486  * By default, the owner account will be the one that deploys the contract. This
1487  * can later be changed with {transferOwnership}.
1488  *
1489  * This module is used through inheritance. It will make available the modifier
1490  * `onlyOwner`, which can be applied to your functions to restrict their use to
1491  * the owner.
1492  */
1493 contract Ownable is Context {
1494     address private _owner;
1495 
1496     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1497 
1498     /**
1499      * @dev Initializes the contract setting the deployer as the initial owner.
1500      */
1501     constructor () internal {
1502         address msgSender = _msgSender();
1503         _owner = msgSender;
1504         emit OwnershipTransferred(address(0), msgSender);
1505     }
1506 
1507     /**
1508      * @dev Returns the address of the current owner.
1509      */
1510     function owner() public view returns (address) {
1511         return _owner;
1512     }
1513 
1514     /**
1515      * @dev Throws if called by any account other than the owner.
1516      */
1517     modifier onlyOwner() {
1518         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1519         _;
1520     }
1521 
1522     /**
1523      * @dev Leaves the contract without owner. It will not be possible to call
1524      * `onlyOwner` functions anymore. Can only be called by the current owner.
1525      *
1526      * NOTE: Renouncing ownership will leave the contract without an owner,
1527      * thereby removing any functionality that is only available to the owner.
1528      */
1529     function renounceOwnership() public virtual onlyOwner {
1530         emit OwnershipTransferred(_owner, address(0));
1531         _owner = address(0);
1532     }
1533 
1534     /**
1535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1536      * Can only be called by the current owner.
1537      */
1538     function transferOwnership(address newOwner) public virtual onlyOwner {
1539         require(newOwner != address(0), "Ownable: new owner is the zero address");
1540         emit OwnershipTransferred(_owner, newOwner);
1541         _owner = newOwner;
1542     }
1543 }
1544 
1545 contract WrappedV1Punk is Ownable, ERC721 {
1546 
1547     event ProxyRegistered(address user, address proxy);
1548 
1549     // Instance of cryptopunk smart contract
1550     ICryptoPunk private _punkContract;
1551 
1552     uint constant public totalPunkSupply = 10000; // supply is one more than in reality because of a hidden 0 index punk
1553     uint private _fees;
1554 
1555     // Mapping from user address to proxy address
1556     mapping(address => address) private _proxies;
1557 
1558     // get an address from a punkIndex
1559     mapping (uint => address) public punkIndexToAddress;
1560 
1561     // Add marketplace
1562     struct Offer {
1563         bool isForSale;
1564         uint punkIndex;
1565         address seller;
1566         uint minValue;          // in ether
1567         address onlySellTo;     // specify to sell only to a specific person
1568     }
1569 
1570     struct Bid {
1571         bool hasBid;
1572         uint punkIndex;
1573         address bidder;
1574         uint value;
1575     }
1576 
1577     // A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
1578     mapping (uint => Offer) public punksOfferedForSale;
1579 
1580     // A record of the highest punk bid
1581     mapping (uint => Bid) public punkBids;
1582 
1583     mapping (address => uint) public pendingWithdrawals;
1584 
1585     event PunkOffered(uint indexed punkIndex, uint minValue, address indexed toAddress);
1586     event PunkBidEntered(uint indexed punkIndex, uint value, address indexed fromAddress);
1587     event PunkBidWithdrawn(uint indexed punkIndex, uint value, address indexed fromAddress);
1588     event PunkBought(uint indexed punkIndex, uint value, address indexed fromAddress, address indexed toAddress);
1589     event PunkNoLongerForSale(uint indexed punkIndex);
1590     event Wrapped(uint indexed punkIndex);
1591     event Unwrapped(uint indexed punkIndex);
1592 
1593     /**
1594      * @dev Initializes the contract settings
1595      */
1596     constructor(address punkContract)
1597     public
1598     ERC721("Wrapped V1 Cryptopunks", "WV1PUNKS")
1599     {
1600         _punkContract = ICryptoPunk(punkContract);
1601         _fees = 25;
1602     }
1603 
1604     /**
1605      * @dev Gets address of cryptopunk smart contract
1606      */
1607     function punkContract()
1608     public
1609     view
1610     returns (address)
1611     {
1612         return address(_punkContract);
1613     }
1614 
1615     /**
1616      * @dev Sets the base URI for all token
1617      */
1618     function setBaseURI(string memory baseUri)
1619     public
1620     onlyOwner
1621     {
1622         _setBaseURI(baseUri);
1623     }
1624 
1625     /**
1626      * @dev Registers proxy
1627      */
1628     function registerProxy()
1629     public
1630     {
1631         address sender = _msgSender();
1632 
1633         require(_proxies[sender] == address(0), "PunkWrapper: caller has registered the proxy");
1634 
1635         address proxy = address(new UserProxy());
1636 
1637         _proxies[sender] = proxy;
1638 
1639         emit ProxyRegistered(sender, proxy);
1640     }
1641 
1642     /**
1643      * @dev Gets proxy address
1644      */
1645     function proxyInfo(address user)
1646     public
1647     view
1648     returns (address)
1649     {
1650         return _proxies[user];
1651     }
1652 
1653     /**
1654      * @dev Mints a wrapped punk
1655      */
1656     function mint(uint punkIndex)
1657     public
1658     {
1659         address sender = _msgSender();
1660 
1661         UserProxy proxy = UserProxy(_proxies[sender]);
1662 
1663         require(proxy.transfer(address(_punkContract), punkIndex), "PunkWrapper: transfer fail");
1664 
1665         punkIndexToAddress[punkIndex] = sender;
1666         _mint(sender, punkIndex);
1667     }
1668 
1669     /**
1670      * @dev Burns a specific wrapped punk
1671      */
1672     function burn(uint punkIndex)
1673     public
1674     {
1675         address sender = _msgSender();
1676 
1677         require(_isApprovedOrOwner(sender, punkIndex), "PunkWrapper: caller is not owner nor approved");
1678         punkIndexToAddress[punkIndex] = address(0x0);
1679 
1680         // Check for the case where there is a bid from the new owner and refund it.
1681         // Any other bid can stay in place.
1682         Bid memory bid = punkBids[punkIndex];
1683         // Kill bid and refund value
1684         pendingWithdrawals[bid.bidder] += bid.value;
1685         punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1686         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, sender, 0, address(0x0));
1687 
1688         _burn(punkIndex);
1689 
1690         // Transfers ownership of punk on original cryptopunk smart contract to caller
1691         _punkContract.transferPunk(sender, punkIndex);
1692     }
1693 
1694     /**
1695      * @dev Internal function to transfer ownership of a given punk index to another address
1696      */
1697     function _transferFrom(address from, address to, uint punkIndex)
1698     internal
1699     {
1700         punkIndexToAddress[punkIndex] = to;
1701         super._transfer(from, to, uint256(punkIndex));
1702     }
1703 
1704     function transferFrom(address from, address to, uint punkIndex) public override {
1705         punkIndexToAddress[punkIndex] = to;
1706         super.transferFrom(from, to, uint256(punkIndex));
1707 
1708         // Check for the case where there is a bid from the new owner and refund it.
1709         // Any other bid can stay in place.
1710         Bid memory bid = punkBids[punkIndex];
1711         if (bid.bidder == to) {
1712             // Kill bid and refund value
1713             pendingWithdrawals[to] += bid.value;
1714             punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1715         }
1716     }
1717 
1718     function _safeTransferFrom(address from, address to, uint punkIndex)
1719     internal
1720     {
1721         punkIndexToAddress[punkIndex] = to;
1722         super.safeTransferFrom(from, to, uint256(punkIndex));
1723     }
1724 
1725     function safeTransferFrom(address from, address to, uint punkIndex) public override {
1726         _safeTransferFrom(from, to, uint256(punkIndex));
1727 
1728         // Check for the case where there is a bid from the new owner and refund it.
1729         // Any other bid can stay in place.
1730         Bid memory bid = punkBids[punkIndex];
1731         if (bid.bidder == to) {
1732             // Kill bid and refund value
1733             pendingWithdrawals[to] += bid.value;
1734             punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1735         }
1736     }
1737 
1738     function punkNoLongerForSale(uint punkIndex) public {
1739         require(punkIndexToAddress[punkIndex] == msg.sender);
1740         require(punkIndex <= totalPunkSupply);
1741         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, address(0x0));
1742         emit PunkNoLongerForSale(punkIndex);
1743     }
1744 
1745     function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) public {
1746         require(punkIndexToAddress[punkIndex] == msg.sender);
1747         require(punkIndex <= totalPunkSupply);
1748         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, address(0x0));
1749         emit PunkOffered(punkIndex, minSalePriceInWei, address(0x0));
1750     }
1751 
1752     function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) public {
1753         require(punkIndexToAddress[punkIndex] == msg.sender);
1754         require(punkIndex <= totalPunkSupply);
1755         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, toAddress);
1756         emit PunkOffered(punkIndex, minSalePriceInWei, toAddress);
1757     }
1758 
1759     function withdraw() public {
1760         uint amount = pendingWithdrawals[msg.sender];
1761         pendingWithdrawals[msg.sender] = 0;
1762         msg.sender.transfer(amount);
1763     }
1764 
1765     function enterBidForPunk(uint punkIndex) public payable {
1766         require(punkIndex < totalPunkSupply);
1767         require(punkIndexToAddress[punkIndex] != address(0x0));
1768         require(punkIndexToAddress[punkIndex] != msg.sender);
1769         require(msg.value > 0);
1770         Bid memory existing = punkBids[punkIndex];
1771         require(msg.value > existing.value);
1772         if (existing.value > 0) {
1773             // Refund the failing bid
1774             pendingWithdrawals[existing.bidder] += existing.value;
1775         }
1776         punkBids[punkIndex] = Bid(true, punkIndex, msg.sender, msg.value);
1777         emit PunkBidEntered(punkIndex, msg.value, msg.sender);
1778     }
1779 
1780     function acceptBidForPunk(uint punkIndex, uint minPrice) public {
1781         require(punkIndex < totalPunkSupply);
1782         require(punkIndexToAddress[punkIndex] == msg.sender);
1783         address seller = msg.sender;
1784         Bid memory bid = punkBids[punkIndex];
1785         require(bid.value > 0);
1786         require(minPrice > 0);
1787         require(bid.value >= minPrice);
1788 
1789         _safeTransferFrom(seller, bid.bidder, punkIndex);
1790 
1791         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, bid.bidder, 0, address(0x0));
1792         uint amount = (bid.value * (1000-_fees)) / 1000;
1793         punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1794         pendingWithdrawals[seller] += amount;
1795         pendingWithdrawals[owner()] += (bid.value - amount);
1796 
1797         emit PunkBought(punkIndex, bid.value, seller, bid.bidder);
1798     }
1799 
1800     function buyPunk(uint punkIndex) external payable {
1801         Offer memory offer = punksOfferedForSale[punkIndex];
1802         if (!offer.isForSale) revert();                // punk not actually for sale
1803         if (offer.onlySellTo != address(0x0) && offer.onlySellTo != msg.sender) revert();  // punk not supposed to be sold to this user
1804         if (msg.value < offer.minValue) revert();   // Didn't send enough ETH
1805         if (offer.seller != punkIndexToAddress[punkIndex]) revert(); // Seller no longer owner of punk
1806 
1807         address seller = offer.seller;
1808 
1809         _transferFrom(seller, msg.sender, punkIndex);
1810         uint amount = (msg.value * (1000-_fees)) / 1000;
1811         punkNoLongerForSale(punkIndex);
1812         pendingWithdrawals[offer.seller] += amount;
1813         pendingWithdrawals[owner()] += (msg.value - amount);
1814 
1815         emit PunkBought(punkIndex, msg.value, offer.seller, msg.sender);
1816 
1817         // Check for the case where there is a bid from the new owner and refund it.
1818         // Any other bid can stay in place.
1819         Bid memory bid = punkBids[punkIndex];
1820         if (bid.bidder == msg.sender) {
1821             // Kill bid and refund value
1822             pendingWithdrawals[msg.sender] += bid.value;
1823             punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1824         }
1825     }
1826 
1827     function withdrawBidForPunk(uint punkIndex) public {
1828         require(punkIndex < totalPunkSupply);
1829         require(punkIndexToAddress[punkIndex] != address(0x0));
1830         require(punkIndexToAddress[punkIndex] != msg.sender);
1831         Bid memory bid = punkBids[punkIndex];
1832         require(bid.bidder == msg.sender);
1833         emit PunkBidWithdrawn(punkIndex, bid.value, msg.sender);
1834         uint amount = bid.value;
1835         punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
1836         // Refund the bid money
1837         msg.sender.transfer(amount);
1838     }
1839 
1840     // aggregate getter to build better frontend
1841     function getPunksForAddress(address _user, uint256 userBal) external view returns(uint256[] memory) {
1842         uint256[] memory punks = new uint256[](userBal);
1843         uint256 j =0;
1844         uint256 i=0;
1845         for (i=0; i<10000; i++) {
1846             if ( _punkContract.punkIndexToAddress(i) == _user ) {
1847                 punks[j] = i;
1848                 j++;
1849             }
1850         }
1851 
1852         return punks;
1853     }
1854 
1855     function getWrappedPunksForAddress(address _user, uint256 userBal) external view returns(uint256[] memory) {
1856         uint256[] memory wrappedPunks = new uint256[](userBal);
1857         uint256 j =0;
1858         uint256 i=0;
1859         for (i=0; i<10000; i++) {
1860             if ( punkIndexToAddress[i] == _user ) {
1861                 wrappedPunks[j] = i;
1862                 j++;
1863             }
1864         }
1865 
1866         return wrappedPunks;
1867     }
1868 
1869     function getPunkOwners() external view returns (address[] memory) {
1870         address[] memory owners = new address[](totalPunkSupply);
1871 
1872         for (uint i = 0; i < totalPunkSupply; i++) {
1873             owners[i] = _punkContract.punkIndexToAddress(i);
1874         }
1875         return owners;
1876     }
1877 
1878     function getWrappedPunkOwners() external view returns (address[] memory) {
1879         address[] memory wrappedOwners = new address[](totalPunkSupply);
1880 
1881         for (uint i = 0; i < totalPunkSupply; i++) {
1882             wrappedOwners[i] = punkIndexToAddress[i];
1883         }
1884         return wrappedOwners;
1885     }
1886 
1887     function getAllPunkBids() external view returns (uint[] memory) {
1888         uint[] memory wrappedPunkBids = new uint[](totalPunkSupply);
1889 
1890         for (uint i = 0; i < totalPunkSupply; i++) {
1891             if( punkBids[i].hasBid )
1892                 wrappedPunkBids[i] = punkBids[i].value;
1893         }
1894 
1895         return wrappedPunkBids;
1896     }
1897 
1898     function getAllPunkOffers() external view returns (uint[] memory) {
1899         uint[] memory wrappedPunkOffers = new uint[](totalPunkSupply);
1900 
1901         for (uint i = 0; i < totalPunkSupply; i++) {
1902             if( punksOfferedForSale[i].isForSale)
1903                 wrappedPunkOffers[i] = punksOfferedForSale[i].minValue;
1904         }
1905 
1906         return wrappedPunkOffers;
1907     }
1908 
1909     function setFees(uint fees) public onlyOwner {
1910         _fees = fees;
1911     }
1912 }