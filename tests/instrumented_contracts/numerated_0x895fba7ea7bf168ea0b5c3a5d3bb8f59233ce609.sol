1 // Dependency file: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
30 
31 
32 // pragma solidity ^0.6.2;
33 
34 // import "@openzeppelin/contracts/introspection/IERC165.sol";
35 
36 /**
37  * @dev Required interface of an ERC1155 compliant contract, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
39  *
40  * _Available since v3.1._
41  */
42 interface IERC1155 is IERC165 {
43     /**
44      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
45      */
46     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
47 
48     /**
49      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
50      * transfers.
51      */
52     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
53 
54     /**
55      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
56      * `approved`.
57      */
58     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
59 
60     /**
61      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
62      *
63      * If an {URI} event was emitted for `id`, the standard
64      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
65      * returned by {IERC1155MetadataURI-uri}.
66      */
67     event URI(string value, uint256 indexed id);
68 
69     /**
70      * @dev Returns the amount of tokens of token type `id` owned by `account`.
71      *
72      * Requirements:
73      *
74      * - `account` cannot be the zero address.
75      */
76     function balanceOf(address account, uint256 id) external view returns (uint256);
77 
78     /**
79      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
80      *
81      * Requirements:
82      *
83      * - `accounts` and `ids` must have the same length.
84      */
85     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
86 
87     /**
88      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
89      *
90      * Emits an {ApprovalForAll} event.
91      *
92      * Requirements:
93      *
94      * - `operator` cannot be the caller.
95      */
96     function setApprovalForAll(address operator, bool approved) external;
97 
98     /**
99      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
100      *
101      * See {setApprovalForAll}.
102      */
103     function isApprovedForAll(address account, address operator) external view returns (bool);
104 
105     /**
106      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
107      *
108      * Emits a {TransferSingle} event.
109      *
110      * Requirements:
111      *
112      * - `to` cannot be the zero address.
113      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
114      * - `from` must have a balance of tokens of type `id` of at least `amount`.
115      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
116      * acceptance magic value.
117      */
118     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
119 
120     /**
121      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
122      *
123      * Emits a {TransferBatch} event.
124      *
125      * Requirements:
126      *
127      * - `ids` and `amounts` must have the same length.
128      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
129      * acceptance magic value.
130      */
131     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
132 }
133 
134 
135 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
136 
137 
138 // pragma solidity ^0.6.0;
139 
140 // import "@openzeppelin/contracts/introspection/IERC165.sol";
141 
142 /**
143  * _Available since v3.1._
144  */
145 interface IERC1155Receiver is IERC165 {
146 
147     /**
148         @dev Handles the receipt of a single ERC1155 token type. This function is
149         called at the end of a `safeTransferFrom` after the balance has been updated.
150         To accept the transfer, this must return
151         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
152         (i.e. 0xf23a6e61, or its own function selector).
153         @param operator The address which initiated the transfer (i.e. msg.sender)
154         @param from The address which previously owned the token
155         @param id The ID of the token being transferred
156         @param value The amount of tokens being transferred
157         @param data Additional data with no specified format
158         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
159     */
160     function onERC1155Received(
161         address operator,
162         address from,
163         uint256 id,
164         uint256 value,
165         bytes calldata data
166     )
167         external
168         returns(bytes4);
169 
170     /**
171         @dev Handles the receipt of a multiple ERC1155 token types. This function
172         is called at the end of a `safeBatchTransferFrom` after the balances have
173         been updated. To accept the transfer(s), this must return
174         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
175         (i.e. 0xbc197c81, or its own function selector).
176         @param operator The address which initiated the batch transfer (i.e. msg.sender)
177         @param from The address which previously owned the token
178         @param ids An array containing ids of each token being transferred (order and length must match values array)
179         @param values An array containing amounts of each token being transferred (order and length must match ids array)
180         @param data Additional data with no specified format
181         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
182     */
183     function onERC1155BatchReceived(
184         address operator,
185         address from,
186         uint256[] calldata ids,
187         uint256[] calldata values,
188         bytes calldata data
189     )
190         external
191         returns(bytes4);
192 }
193 
194 
195 // Dependency file: @openzeppelin/contracts/introspection/ERC165.sol
196 
197 
198 // pragma solidity ^0.6.0;
199 
200 // import "@openzeppelin/contracts/introspection/IERC165.sol";
201 
202 /**
203  * @dev Implementation of the {IERC165} interface.
204  *
205  * Contracts may inherit from this and call {_registerInterface} to declare
206  * their support of an interface.
207  */
208 contract ERC165 is IERC165 {
209     /*
210      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
211      */
212     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
213 
214     /**
215      * @dev Mapping of interface ids to whether or not it's supported.
216      */
217     mapping(bytes4 => bool) private _supportedInterfaces;
218 
219     constructor () internal {
220         // Derived contracts need only register support for their own interfaces,
221         // we register support for ERC165 itself here
222         _registerInterface(_INTERFACE_ID_ERC165);
223     }
224 
225     /**
226      * @dev See {IERC165-supportsInterface}.
227      *
228      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
231         return _supportedInterfaces[interfaceId];
232     }
233 
234     /**
235      * @dev Registers the contract as an implementer of the interface defined by
236      * `interfaceId`. Support of the actual ERC165 interface is automatic and
237      * registering its interface id is not required.
238      *
239      * See {IERC165-supportsInterface}.
240      *
241      * Requirements:
242      *
243      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
244      */
245     function _registerInterface(bytes4 interfaceId) internal virtual {
246         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
247         _supportedInterfaces[interfaceId] = true;
248     }
249 }
250 
251 
252 // Dependency file: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
253 
254 
255 // pragma solidity ^0.6.0;
256 
257 // import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
258 // import "@openzeppelin/contracts/introspection/ERC165.sol";
259 
260 /**
261  * @dev _Available since v3.1._
262  */
263 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
264     constructor() public {
265         _registerInterface(
266             ERC1155Receiver(0).onERC1155Received.selector ^
267             ERC1155Receiver(0).onERC1155BatchReceived.selector
268         );
269     }
270 }
271 
272 
273 // Dependency file: @openzeppelin/contracts/utils/EnumerableSet.sol
274 
275 
276 // pragma solidity ^0.6.0;
277 
278 /**
279  * @dev Library for managing
280  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
281  * types.
282  *
283  * Sets have the following properties:
284  *
285  * - Elements are added, removed, and checked for existence in constant time
286  * (O(1)).
287  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
288  *
289  * ```
290  * contract Example {
291  *     // Add the library methods
292  *     using EnumerableSet for EnumerableSet.AddressSet;
293  *
294  *     // Declare a set state variable
295  *     EnumerableSet.AddressSet private mySet;
296  * }
297  * ```
298  *
299  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
300  * (`UintSet`) are supported.
301  */
302 library EnumerableSet {
303     // To implement this library for multiple types with as little code
304     // repetition as possible, we write it in terms of a generic Set type with
305     // bytes32 values.
306     // The Set implementation uses private functions, and user-facing
307     // implementations (such as AddressSet) are just wrappers around the
308     // underlying Set.
309     // This means that we can only create new EnumerableSets for types that fit
310     // in bytes32.
311 
312     struct Set {
313         // Storage of set values
314         bytes32[] _values;
315 
316         // Position of the value in the `values` array, plus 1 because index 0
317         // means a value is not in the set.
318         mapping (bytes32 => uint256) _indexes;
319     }
320 
321     /**
322      * @dev Add a value to a set. O(1).
323      *
324      * Returns true if the value was added to the set, that is if it was not
325      * already present.
326      */
327     function _add(Set storage set, bytes32 value) private returns (bool) {
328         if (!_contains(set, value)) {
329             set._values.push(value);
330             // The value is stored at length-1, but we add 1 to all indexes
331             // and use 0 as a sentinel value
332             set._indexes[value] = set._values.length;
333             return true;
334         } else {
335             return false;
336         }
337     }
338 
339     /**
340      * @dev Removes a value from a set. O(1).
341      *
342      * Returns true if the value was removed from the set, that is if it was
343      * present.
344      */
345     function _remove(Set storage set, bytes32 value) private returns (bool) {
346         // We read and store the value's index to prevent multiple reads from the same storage slot
347         uint256 valueIndex = set._indexes[value];
348 
349         if (valueIndex != 0) { // Equivalent to contains(set, value)
350             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
351             // the array, and then remove the last element (sometimes called as 'swap and pop').
352             // This modifies the order of the array, as noted in {at}.
353 
354             uint256 toDeleteIndex = valueIndex - 1;
355             uint256 lastIndex = set._values.length - 1;
356 
357             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
358             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
359 
360             bytes32 lastvalue = set._values[lastIndex];
361 
362             // Move the last value to the index where the value to delete is
363             set._values[toDeleteIndex] = lastvalue;
364             // Update the index for the moved value
365             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
366 
367             // Delete the slot where the moved value was stored
368             set._values.pop();
369 
370             // Delete the index for the deleted slot
371             delete set._indexes[value];
372 
373             return true;
374         } else {
375             return false;
376         }
377     }
378 
379     /**
380      * @dev Returns true if the value is in the set. O(1).
381      */
382     function _contains(Set storage set, bytes32 value) private view returns (bool) {
383         return set._indexes[value] != 0;
384     }
385 
386     /**
387      * @dev Returns the number of values on the set. O(1).
388      */
389     function _length(Set storage set) private view returns (uint256) {
390         return set._values.length;
391     }
392 
393    /**
394     * @dev Returns the value stored at position `index` in the set. O(1).
395     *
396     * Note that there are no guarantees on the ordering of values inside the
397     * array, and it may change when more values are added or removed.
398     *
399     * Requirements:
400     *
401     * - `index` must be strictly less than {length}.
402     */
403     function _at(Set storage set, uint256 index) private view returns (bytes32) {
404         require(set._values.length > index, "EnumerableSet: index out of bounds");
405         return set._values[index];
406     }
407 
408     // AddressSet
409 
410     struct AddressSet {
411         Set _inner;
412     }
413 
414     /**
415      * @dev Add a value to a set. O(1).
416      *
417      * Returns true if the value was added to the set, that is if it was not
418      * already present.
419      */
420     function add(AddressSet storage set, address value) internal returns (bool) {
421         return _add(set._inner, bytes32(uint256(value)));
422     }
423 
424     /**
425      * @dev Removes a value from a set. O(1).
426      *
427      * Returns true if the value was removed from the set, that is if it was
428      * present.
429      */
430     function remove(AddressSet storage set, address value) internal returns (bool) {
431         return _remove(set._inner, bytes32(uint256(value)));
432     }
433 
434     /**
435      * @dev Returns true if the value is in the set. O(1).
436      */
437     function contains(AddressSet storage set, address value) internal view returns (bool) {
438         return _contains(set._inner, bytes32(uint256(value)));
439     }
440 
441     /**
442      * @dev Returns the number of values in the set. O(1).
443      */
444     function length(AddressSet storage set) internal view returns (uint256) {
445         return _length(set._inner);
446     }
447 
448    /**
449     * @dev Returns the value stored at position `index` in the set. O(1).
450     *
451     * Note that there are no guarantees on the ordering of values inside the
452     * array, and it may change when more values are added or removed.
453     *
454     * Requirements:
455     *
456     * - `index` must be strictly less than {length}.
457     */
458     function at(AddressSet storage set, uint256 index) internal view returns (address) {
459         return address(uint256(_at(set._inner, index)));
460     }
461 
462 
463     // UintSet
464 
465     struct UintSet {
466         Set _inner;
467     }
468 
469     /**
470      * @dev Add a value to a set. O(1).
471      *
472      * Returns true if the value was added to the set, that is if it was not
473      * already present.
474      */
475     function add(UintSet storage set, uint256 value) internal returns (bool) {
476         return _add(set._inner, bytes32(value));
477     }
478 
479     /**
480      * @dev Removes a value from a set. O(1).
481      *
482      * Returns true if the value was removed from the set, that is if it was
483      * present.
484      */
485     function remove(UintSet storage set, uint256 value) internal returns (bool) {
486         return _remove(set._inner, bytes32(value));
487     }
488 
489     /**
490      * @dev Returns true if the value is in the set. O(1).
491      */
492     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
493         return _contains(set._inner, bytes32(value));
494     }
495 
496     /**
497      * @dev Returns the number of values on the set. O(1).
498      */
499     function length(UintSet storage set) internal view returns (uint256) {
500         return _length(set._inner);
501     }
502 
503    /**
504     * @dev Returns the value stored at position `index` in the set. O(1).
505     *
506     * Note that there are no guarantees on the ordering of values inside the
507     * array, and it may change when more values are added or removed.
508     *
509     * Requirements:
510     *
511     * - `index` must be strictly less than {length}.
512     */
513     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
514         return uint256(_at(set._inner, index));
515     }
516 }
517 
518 
519 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
520 
521 
522 // pragma solidity ^0.6.0;
523 
524 /*
525  * @dev Provides information about the current execution context, including the
526  * sender of the transaction and its data. While these are generally available
527  * via msg.sender and msg.data, they should not be accessed in such a direct
528  * manner, since when dealing with GSN meta-transactions the account sending and
529  * paying for execution may not be the actual sender (as far as an application
530  * is concerned).
531  *
532  * This contract is only required for intermediate, library-like contracts.
533  */
534 abstract contract Context {
535     function _msgSender() internal view virtual returns (address payable) {
536         return msg.sender;
537     }
538 
539     function _msgData() internal view virtual returns (bytes memory) {
540         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
541         return msg.data;
542     }
543 }
544 
545 
546 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
547 
548 
549 // pragma solidity ^0.6.0;
550 
551 // import "@openzeppelin/contracts/GSN/Context.sol";
552 /**
553  * @dev Contract module which provides a basic access control mechanism, where
554  * there is an account (an owner) that can be granted exclusive access to
555  * specific functions.
556  *
557  * By default, the owner account will be the one that deploys the contract. This
558  * can later be changed with {transferOwnership}.
559  *
560  * This module is used through inheritance. It will make available the modifier
561  * `onlyOwner`, which can be applied to your functions to restrict their use to
562  * the owner.
563  */
564 contract Ownable is Context {
565     address private _owner;
566 
567     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
568 
569     /**
570      * @dev Initializes the contract setting the deployer as the initial owner.
571      */
572     constructor () internal {
573         address msgSender = _msgSender();
574         _owner = msgSender;
575         emit OwnershipTransferred(address(0), msgSender);
576     }
577 
578     /**
579      * @dev Returns the address of the current owner.
580      */
581     function owner() public view returns (address) {
582         return _owner;
583     }
584 
585     /**
586      * @dev Throws if called by any account other than the owner.
587      */
588     modifier onlyOwner() {
589         require(_owner == _msgSender(), "Ownable: caller is not the owner");
590         _;
591     }
592 
593     /**
594      * @dev Leaves the contract without owner. It will not be possible to call
595      * `onlyOwner` functions anymore. Can only be called by the current owner.
596      *
597      * NOTE: Renouncing ownership will leave the contract without an owner,
598      * thereby removing any functionality that is only available to the owner.
599      */
600     function renounceOwnership() public virtual onlyOwner {
601         emit OwnershipTransferred(_owner, address(0));
602         _owner = address(0);
603     }
604 
605     /**
606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
607      * Can only be called by the current owner.
608      */
609     function transferOwnership(address newOwner) public virtual onlyOwner {
610         require(newOwner != address(0), "Ownable: new owner is the zero address");
611         emit OwnershipTransferred(_owner, newOwner);
612         _owner = newOwner;
613     }
614 }
615 
616 
617 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
618 
619 
620 // pragma solidity ^0.6.0;
621 
622 /**
623  * @dev Wrappers over Solidity's arithmetic operations with added overflow
624  * checks.
625  *
626  * Arithmetic operations in Solidity wrap on overflow. This can easily result
627  * in bugs, because programmers usually assume that an overflow raises an
628  * error, which is the standard behavior in high level programming languages.
629  * `SafeMath` restores this intuition by reverting the transaction when an
630  * operation overflows.
631  *
632  * Using this library instead of the unchecked operations eliminates an entire
633  * class of bugs, so it's recommended to use it always.
634  */
635 library SafeMath {
636     /**
637      * @dev Returns the addition of two unsigned integers, reverting on
638      * overflow.
639      *
640      * Counterpart to Solidity's `+` operator.
641      *
642      * Requirements:
643      *
644      * - Addition cannot overflow.
645      */
646     function add(uint256 a, uint256 b) internal pure returns (uint256) {
647         uint256 c = a + b;
648         require(c >= a, "SafeMath: addition overflow");
649 
650         return c;
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting on
655      * overflow (when the result is negative).
656      *
657      * Counterpart to Solidity's `-` operator.
658      *
659      * Requirements:
660      *
661      * - Subtraction cannot overflow.
662      */
663     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
664         return sub(a, b, "SafeMath: subtraction overflow");
665     }
666 
667     /**
668      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
669      * overflow (when the result is negative).
670      *
671      * Counterpart to Solidity's `-` operator.
672      *
673      * Requirements:
674      *
675      * - Subtraction cannot overflow.
676      */
677     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
678         require(b <= a, errorMessage);
679         uint256 c = a - b;
680 
681         return c;
682     }
683 
684     /**
685      * @dev Returns the multiplication of two unsigned integers, reverting on
686      * overflow.
687      *
688      * Counterpart to Solidity's `*` operator.
689      *
690      * Requirements:
691      *
692      * - Multiplication cannot overflow.
693      */
694     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
695         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
696         // benefit is lost if 'b' is also tested.
697         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
698         if (a == 0) {
699             return 0;
700         }
701 
702         uint256 c = a * b;
703         require(c / a == b, "SafeMath: multiplication overflow");
704 
705         return c;
706     }
707 
708     /**
709      * @dev Returns the integer division of two unsigned integers. Reverts on
710      * division by zero. The result is rounded towards zero.
711      *
712      * Counterpart to Solidity's `/` operator. Note: this function uses a
713      * `revert` opcode (which leaves remaining gas untouched) while Solidity
714      * uses an invalid opcode to revert (consuming all remaining gas).
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function div(uint256 a, uint256 b) internal pure returns (uint256) {
721         return div(a, b, "SafeMath: division by zero");
722     }
723 
724     /**
725      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
726      * division by zero. The result is rounded towards zero.
727      *
728      * Counterpart to Solidity's `/` operator. Note: this function uses a
729      * `revert` opcode (which leaves remaining gas untouched) while Solidity
730      * uses an invalid opcode to revert (consuming all remaining gas).
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
737         require(b > 0, errorMessage);
738         uint256 c = a / b;
739         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
740 
741         return c;
742     }
743 
744     /**
745      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
746      * Reverts when dividing by zero.
747      *
748      * Counterpart to Solidity's `%` operator. This function uses a `revert`
749      * opcode (which leaves remaining gas untouched) while Solidity uses an
750      * invalid opcode to revert (consuming all remaining gas).
751      *
752      * Requirements:
753      *
754      * - The divisor cannot be zero.
755      */
756     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
757         return mod(a, b, "SafeMath: modulo by zero");
758     }
759 
760     /**
761      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
762      * Reverts with custom message when dividing by zero.
763      *
764      * Counterpart to Solidity's `%` operator. This function uses a `revert`
765      * opcode (which leaves remaining gas untouched) while Solidity uses an
766      * invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
773         require(b != 0, errorMessage);
774         return a % b;
775     }
776 }
777 
778 
779 // Dependency file: @openzeppelin/contracts/math/Math.sol
780 
781 
782 // pragma solidity ^0.6.0;
783 
784 /**
785  * @dev Standard math utilities missing in the Solidity language.
786  */
787 library Math {
788     /**
789      * @dev Returns the largest of two numbers.
790      */
791     function max(uint256 a, uint256 b) internal pure returns (uint256) {
792         return a >= b ? a : b;
793     }
794 
795     /**
796      * @dev Returns the smallest of two numbers.
797      */
798     function min(uint256 a, uint256 b) internal pure returns (uint256) {
799         return a < b ? a : b;
800     }
801 
802     /**
803      * @dev Returns the average of two numbers. The result is rounded towards
804      * zero.
805      */
806     function average(uint256 a, uint256 b) internal pure returns (uint256) {
807         // (a + b) / 2 can overflow, so we distribute
808         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
809     }
810 }
811 
812 
813 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
814 
815 
816 // pragma solidity ^0.6.0;
817 
818 /**
819  * @dev Contract module that helps prevent reentrant calls to a function.
820  *
821  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
822  * available, which can be applied to functions to make sure there are no nested
823  * (reentrant) calls to them.
824  *
825  * Note that because there is a single `nonReentrant` guard, functions marked as
826  * `nonReentrant` may not call one another. This can be worked around by making
827  * those functions `private`, and then adding `external` `nonReentrant` entry
828  * points to them.
829  *
830  * TIP: If you would like to learn more about reentrancy and alternative ways
831  * to protect against it, check out our blog post
832  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
833  */
834 contract ReentrancyGuard {
835     // Booleans are more expensive than uint256 or any type that takes up a full
836     // word because each write operation emits an extra SLOAD to first read the
837     // slot's contents, replace the bits taken up by the boolean, and then write
838     // back. This is the compiler's defense against contract upgrades and
839     // pointer aliasing, and it cannot be disabled.
840 
841     // The values being non-zero value makes deployment a bit more expensive,
842     // but in exchange the refund on every call to nonReentrant will be lower in
843     // amount. Since refunds are capped to a percentage of the total
844     // transaction's gas, it is best to keep them low in cases like this one, to
845     // increase the likelihood of the full refund coming into effect.
846     uint256 private constant _NOT_ENTERED = 1;
847     uint256 private constant _ENTERED = 2;
848 
849     uint256 private _status;
850 
851     constructor () internal {
852         _status = _NOT_ENTERED;
853     }
854 
855     /**
856      * @dev Prevents a contract from calling itself, directly or indirectly.
857      * Calling a `nonReentrant` function from another `nonReentrant`
858      * function is not supported. It is possible to prevent this from happening
859      * by making the `nonReentrant` function external, and make it call a
860      * `private` function that does the actual work.
861      */
862     modifier nonReentrant() {
863         // On the first call to nonReentrant, _notEntered will be true
864         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
865 
866         // Any calls to nonReentrant after this point will fail
867         _status = _ENTERED;
868 
869         _;
870 
871         // By storing the original value once again, a refund is triggered (see
872         // https://eips.ethereum.org/EIPS/eip-2200)
873         _status = _NOT_ENTERED;
874     }
875 }
876 
877 
878 // Dependency file: contracts/AlpacaPresaleV2/AccessControl.sol
879 
880 
881 // pragma solidity =0.6.12;
882 
883 // import "@openzeppelin/contracts/access/Ownable.sol";
884 // import "@openzeppelin/contracts/utils/EnumerableSet.sol";
885 
886 contract AccessControl is Ownable {
887     using EnumerableSet for EnumerableSet.AddressSet;
888 
889     /* ========== STATE VARIABLES ========== */
890 
891     uint256 public startBlock;
892 
893     uint256 public endBlock;
894 
895     bool internal whitelistEnabled = true;
896 
897     // Set of address that are approved to purchase alpaca
898     EnumerableSet.AddressSet internal whitelist;
899 
900     /* ========== EXTERNAL MUTATIVE FUNCTIONS ========== */
901 
902     function setStartBlock(uint256 _block) external onlyOwner {
903         startBlock = _block;
904     }
905 
906     function setEndBlock(uint256 _block) external onlyOwner {
907         endBlock = _block;
908     }
909 
910     function setWhitelistEnabled(bool _enabled) external onlyOwner {
911         whitelistEnabled = _enabled;
912     }
913 
914     /**
915      * @dev Allow owner to change alpaca price
916      */
917     function addToWhitelist(address[] calldata _addresses) external onlyOwner {
918         for (uint256 i = 0; i < _addresses.length; i++) {
919             whitelist.add(_addresses[i]);
920         }
921     }
922 
923     /* ========== MODIFIER ========== */
924 
925     modifier whenInProgress() {
926         require(block.number >= startBlock, "Event not yet started");
927         require(block.number < endBlock, "Event Ended");
928         _;
929     }
930 
931     modifier whenEnded() {
932         require(block.number >= endBlock, "Event not yet ended");
933         _;
934     }
935 }
936 
937 
938 // Root file: contracts/AlpacaPresaleV2/AlpacaPresaleV2.sol
939 
940 
941 pragma solidity =0.6.12;
942 
943 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
944 // import "@openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol";
945 // import "@openzeppelin/contracts/utils/EnumerableSet.sol";
946 // import "@openzeppelin/contracts/access/Ownable.sol";
947 // import "@openzeppelin/contracts/math/SafeMath.sol";
948 // import "@openzeppelin/contracts/math/Math.sol";
949 // import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
950 
951 // import "contracts/AlpacaPresaleV2/AccessControl.sol";
952 
953 contract AlpacaPresaleV2 is
954     Ownable,
955     AccessControl,
956     ReentrancyGuard,
957     ERC1155Receiver
958 {
959     using SafeMath for uint256;
960     using Math for uint256;
961     using EnumerableSet for EnumerableSet.UintSet;
962     using EnumerableSet for EnumerableSet.AddressSet;
963 
964     /* ========== STATE VARIABLES ========== */
965 
966     IERC1155 public cryptoAlpaca;
967 
968     uint256 public pricePerAlpaca = 0.02 ether;
969 
970     uint256 public maxAdoptionCount = 30;
971 
972     // Mapping from address to alpaca count
973     mapping(address => uint256) private accountAddoptionCount;
974 
975     // Set of alpaca IDs this contract owns
976     EnumerableSet.UintSet private presaleAlpacaIDs;
977 
978     /* ========== CONSTRUCTOR ========== */
979 
980     constructor(IERC1155 _cryptoAlpaca) public {
981         cryptoAlpaca = _cryptoAlpaca;
982     }
983 
984     /* ========== OWNER ONLY ========== */
985 
986     /**
987      * @dev Allow owner to change alpaca price
988      */
989     function setPricePerAlpaca(uint256 _price) public onlyOwner {
990         pricePerAlpaca = _price;
991     }
992 
993     /**
994      * @dev Allow owner to update maximum number alpaca a given user can adopt
995      */
996     function setMaxAdoptionCount(uint256 _maxAdoptionCount) public onlyOwner {
997         maxAdoptionCount = _maxAdoptionCount;
998     }
999 
1000     /**
1001      * @dev Allow owner to transfer a alpaca that didn't get adopted during presale
1002      */
1003     function reclaim(uint256 _id, address _to) public onlyOwner whenEnded {
1004         cryptoAlpaca.safeTransferFrom(address(this), _to, _id, 1, "");
1005     }
1006 
1007     /**
1008      * @dev Allow owner to transfer all alpaca that didn't get adopted during presale
1009      */
1010     function reclaimAll(address _to) public onlyOwner whenEnded {
1011         uint256 length = presaleAlpacaIDs.length();
1012         uint256[] memory ids = new uint256[](length);
1013         uint256[] memory amount = new uint256[](length);
1014         for (uint256 i = 0; i < length; i++) {
1015             ids[i] = presaleAlpacaIDs.at(i);
1016             amount[i] = 1;
1017         }
1018 
1019         cryptoAlpaca.safeBatchTransferFrom(address(this), _to, ids, amount, "");
1020     }
1021 
1022     /**
1023      * @dev Allows owner to withdrawal the presale balance to an account.
1024      */
1025     function withdraw(address payable _to) external onlyOwner {
1026         _to.transfer(address(this).balance);
1027     }
1028 
1029     /* ========== EXTERNAL MUTATIVE FUNCTIONS ========== */
1030 
1031     /**
1032      * @dev Adopt _count number of alpaca
1033      */
1034     function adoptAlpaca(uint256 _count)
1035         public
1036         payable
1037         whenInProgress
1038         nonReentrant
1039     {
1040         require(_count > 0, "AlpacaPresale: must adopt at least one alpaca");
1041         require(whitelist.contains(msg.sender), "AlpacaPresale: unauthorized");
1042 
1043         address account = msg.sender;
1044         uint256 credit = canAdoptCount(account);
1045         require(
1046             _count <= credit,
1047             "AlpacaPresale: adoption count larger than maximum adoption limit"
1048         );
1049 
1050         require(
1051             msg.value >= getAdoptionPrice(_count),
1052             "AlpacaPresale: insufficient funds"
1053         );
1054 
1055         uint256[] memory ids = new uint256[](_count);
1056         uint256[] memory counts = new uint256[](_count);
1057         for (uint256 i = 0; i < _count; i++) {
1058             ids[i] = _randRemoveAlpaca();
1059             counts[i] = 1;
1060         }
1061 
1062         accountAddoptionCount[account] += _count;
1063 
1064         cryptoAlpaca.safeBatchTransferFrom(
1065             address(this),
1066             account,
1067             ids,
1068             counts,
1069             ""
1070         );
1071     }
1072 
1073     /* ========== VIEW ========== */
1074 
1075     /**
1076      * @dev returns if `_account` is whitelisted to adopt alpaca
1077      */
1078     function allowedToAdopt(address _account) public view returns (bool) {
1079         return whitelistEnabled ? whitelist.contains(_account) : true;
1080     }
1081 
1082     /**
1083      * @dev returns number of _account has adopted presale alpaca
1084      */
1085     function getAdoptionCount(address _account) public view returns (uint256) {
1086         return accountAddoptionCount[_account];
1087     }
1088 
1089     /**
1090      * @dev total adoption price if adopt _count many
1091      */
1092     function getAdoptionPrice(uint256 _count) public view returns (uint256) {
1093         return _count.mul(pricePerAlpaca);
1094     }
1095 
1096     /**
1097      * @dev number of presale alpaca this contract owns
1098      */
1099     function getPresaleAlpacaCount() public view returns (uint256) {
1100         return presaleAlpacaIDs.length();
1101     }
1102 
1103     /**
1104      * @dev how many more _account can adopt alpaca
1105      */
1106     function canAdoptCount(address _account) public view returns (uint256) {
1107         if (!allowedToAdopt(_account)) {
1108             return 0;
1109         }
1110 
1111         uint256 credit = maxAdoptionCount.sub(accountAddoptionCount[_account]);
1112 
1113         uint256 alpacaCount = presaleAlpacaIDs.length();
1114 
1115         return credit.min(alpacaCount);
1116     }
1117 
1118     /**
1119      * @dev onERC1155Received implementation per IERC1155Receiver spec
1120      */
1121     function onERC1155Received(
1122         address,
1123         address,
1124         uint256 id,
1125         uint256,
1126         bytes calldata
1127     ) external override returns (bytes4) {
1128         require(
1129             msg.sender == address(cryptoAlpaca),
1130             "AlpacaPresale: received alpaca from unauthenticated contract"
1131         );
1132 
1133         uint256[] memory ids = new uint256[](1);
1134         ids[0] = id;
1135 
1136         _receivedAlpaca(ids);
1137 
1138         return
1139             bytes4(
1140                 keccak256(
1141                     "onERC1155Received(address,address,uint256,uint256,bytes)"
1142                 )
1143             );
1144     }
1145 
1146     /**
1147      * @dev onERC1155BatchReceived implementation per IERC1155Receiver spec
1148      */
1149     function onERC1155BatchReceived(
1150         address,
1151         address,
1152         uint256[] calldata ids,
1153         uint256[] calldata,
1154         bytes calldata
1155     ) external override returns (bytes4) {
1156         require(
1157             msg.sender == address(cryptoAlpaca),
1158             "AlpacaPresale: received alpaca from unauthenticated contract"
1159         );
1160 
1161         _receivedAlpaca(ids);
1162 
1163         return
1164             bytes4(
1165                 keccak256(
1166                     "onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"
1167                 )
1168             );
1169     }
1170 
1171     /* ========== PRIVATE ========== */
1172 
1173     /**
1174      * @dev randomly select and remove a alpaca
1175      * returns selected alpaca ID
1176      */
1177     function _randRemoveAlpaca() private returns (uint256) {
1178         require(presaleAlpacaIDs.length() > 0, "No more presale alpaca");
1179 
1180         uint256 totalLength = presaleAlpacaIDs.length();
1181 
1182         uint256 randIndex = uint256(blockhash(block.number - 1));
1183         randIndex = uint256(keccak256(abi.encodePacked(randIndex, totalLength)))
1184             .mod(totalLength);
1185 
1186         uint256 randID = presaleAlpacaIDs.at(uint256(randIndex));
1187 
1188         require(presaleAlpacaIDs.remove(randID));
1189 
1190         return randID;
1191     }
1192 
1193     function _receivedAlpaca(uint256[] memory ids) private {
1194         for (uint256 i = 0; i < ids.length; i++) {
1195             presaleAlpacaIDs.add(ids[i]);
1196         }
1197     }
1198 }