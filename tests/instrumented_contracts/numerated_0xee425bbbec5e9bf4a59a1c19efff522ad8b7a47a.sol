1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 //import "../utils/Context.sol";
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 // CAUTION
107 // This version of SafeMath should only be used with Solidity 0.8 or later,
108 // because it relies on the compiler's built in overflow checks.
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations.
112  *
113  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
114  * now has built in overflow checking.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             uint256 c = a + b;
125             if (c < a) return (false, 0);
126             return (true, c);
127         }
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         unchecked {
137             if (b > a) return (false, 0);
138             return (true, a - b);
139         }
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150             // benefit is lost if 'b' is also tested.
151             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152             if (a == 0) return (true, 0);
153             uint256 c = a * b;
154             if (c / a != b) return (false, 0);
155             return (true, c);
156         }
157     }
158 
159     /**
160      * @dev Returns the division of two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             if (b == 0) return (false, 0);
167             return (true, a / b);
168         }
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         unchecked {
178             if (b == 0) return (false, 0);
179             return (true, a % b);
180         }
181     }
182 
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a + b;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting on
199      * overflow (when the result is negative).
200      *
201      * Counterpart to Solidity's `-` operator.
202      *
203      * Requirements:
204      *
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a - b;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a * b;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers, reverting on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator.
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a / b;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * reverting when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a % b;
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
257      * overflow (when the result is negative).
258      *
259      * CAUTION: This function is deprecated because it requires allocating memory for the error
260      * message unnecessarily. For custom revert reasons use {trySub}.
261      *
262      * Counterpart to Solidity's `-` operator.
263      *
264      * Requirements:
265      *
266      * - Subtraction cannot overflow.
267      */
268     function sub(
269         uint256 a,
270         uint256 b,
271         string memory errorMessage
272     ) internal pure returns (uint256) {
273         unchecked {
274             require(b <= a, errorMessage);
275             return a - b;
276         }
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(
292         uint256 a,
293         uint256 b,
294         string memory errorMessage
295     ) internal pure returns (uint256) {
296         unchecked {
297             require(b > 0, errorMessage);
298             return a / b;
299         }
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         unchecked {
323             require(b > 0, errorMessage);
324             return a % b;
325         }
326     }
327 }
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 //import "../../utils/introspection/IERC165.sol";
359 
360 /**
361  * @dev Required interface of an ERC721 compliant contract.
362  */
363 interface IERC721 is IERC165 {
364     /**
365      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
368 
369     /**
370      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
371      */
372     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
373 
374     /**
375      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
376      */
377     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
378 
379     /**
380      * @dev Returns the number of tokens in ``owner``'s account.
381      */
382     function balanceOf(address owner) external view returns (uint256 balance);
383 
384     /**
385      * @dev Returns the owner of the `tokenId` token.
386      *
387      * Requirements:
388      *
389      * - `tokenId` must exist.
390      */
391     function ownerOf(uint256 tokenId) external view returns (address owner);
392 
393     /**
394      * @dev Safely transfers `tokenId` token from `from` to `to`.
395      *
396      * Requirements:
397      *
398      * - `from` cannot be the zero address.
399      * - `to` cannot be the zero address.
400      * - `tokenId` token must exist and be owned by `from`.
401      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
403      *
404      * Emits a {Transfer} event.
405      */
406     function safeTransferFrom(
407         address from,
408         address to,
409         uint256 tokenId,
410         bytes calldata data
411     ) external;
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers `tokenId` token from `from` to `to`.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Approve or remove `operator` as an operator for the caller.
470      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
471      *
472      * Requirements:
473      *
474      * - The `operator` cannot be the caller.
475      *
476      * Emits an {ApprovalForAll} event.
477      */
478     function setApprovalForAll(address operator, bool _approved) external;
479 
480     /**
481      * @dev Returns the account approved for `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function getApproved(uint256 tokenId) external view returns (address operator);
488 
489     /**
490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 }
496 
497 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 //import "../IERC721.sol";
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Enumerable is IERC721 {
508     /**
509      * @dev Returns the total amount of tokens stored by the contract.
510      */
511     function totalSupply() external view returns (uint256);
512 
513     /**
514      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
515      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
516      */
517     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
518 
519     /**
520      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
521      * Use along with {totalSupply} to enumerate all tokens.
522      */
523     function tokenByIndex(uint256 index) external view returns (uint256);
524 }
525 
526 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Library for managing
559  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
560  * types.
561  *
562  * Sets have the following properties:
563  *
564  * - Elements are added, removed, and checked for existence in constant time
565  * (O(1)).
566  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
567  *
568  * ```
569  * contract Example {
570  *     // Add the library methods
571  *     using EnumerableSet for EnumerableSet.AddressSet;
572  *
573  *     // Declare a set state variable
574  *     EnumerableSet.AddressSet private mySet;
575  * }
576  * ```
577  *
578  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
579  * and `uint256` (`UintSet`) are supported.
580  */
581 library EnumerableSet {
582     // To implement this library for multiple types with as little code
583     // repetition as possible, we write it in terms of a generic Set type with
584     // bytes32 values.
585     // The Set implementation uses private functions, and user-facing
586     // implementations (such as AddressSet) are just wrappers around the
587     // underlying Set.
588     // This means that we can only create new EnumerableSets for types that fit
589     // in bytes32.
590 
591     struct Set {
592         // Storage of set values
593         bytes32[] _values;
594         // Position of the value in the `values` array, plus 1 because index 0
595         // means a value is not in the set.
596         mapping(bytes32 => uint256) _indexes;
597     }
598 
599     /**
600      * @dev Add a value to a set. O(1).
601      *
602      * Returns true if the value was added to the set, that is if it was not
603      * already present.
604      */
605     function _add(Set storage set, bytes32 value) private returns (bool) {
606         if (!_contains(set, value)) {
607             set._values.push(value);
608             // The value is stored at length-1, but we add 1 to all indexes
609             // and use 0 as a sentinel value
610             set._indexes[value] = set._values.length;
611             return true;
612         } else {
613             return false;
614         }
615     }
616 
617     /**
618      * @dev Removes a value from a set. O(1).
619      *
620      * Returns true if the value was removed from the set, that is if it was
621      * present.
622      */
623     function _remove(Set storage set, bytes32 value) private returns (bool) {
624         // We read and store the value's index to prevent multiple reads from the same storage slot
625         uint256 valueIndex = set._indexes[value];
626 
627         if (valueIndex != 0) {
628             // Equivalent to contains(set, value)
629             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
630             // the array, and then remove the last element (sometimes called as 'swap and pop').
631             // This modifies the order of the array, as noted in {at}.
632 
633             uint256 toDeleteIndex = valueIndex - 1;
634             uint256 lastIndex = set._values.length - 1;
635 
636             if (lastIndex != toDeleteIndex) {
637                 bytes32 lastValue = set._values[lastIndex];
638 
639                 // Move the last value to the index where the value to delete is
640                 set._values[toDeleteIndex] = lastValue;
641                 // Update the index for the moved value
642                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
643             }
644 
645             // Delete the slot where the moved value was stored
646             set._values.pop();
647 
648             // Delete the index for the deleted slot
649             delete set._indexes[value];
650 
651             return true;
652         } else {
653             return false;
654         }
655     }
656 
657     /**
658      * @dev Returns true if the value is in the set. O(1).
659      */
660     function _contains(Set storage set, bytes32 value) private view returns (bool) {
661         return set._indexes[value] != 0;
662     }
663 
664     /**
665      * @dev Returns the number of values on the set. O(1).
666      */
667     function _length(Set storage set) private view returns (uint256) {
668         return set._values.length;
669     }
670 
671     /**
672      * @dev Returns the value stored at position `index` in the set. O(1).
673      *
674      * Note that there are no guarantees on the ordering of values inside the
675      * array, and it may change when more values are added or removed.
676      *
677      * Requirements:
678      *
679      * - `index` must be strictly less than {length}.
680      */
681     function _at(Set storage set, uint256 index) private view returns (bytes32) {
682         return set._values[index];
683     }
684 
685     /**
686      * @dev Return the entire set in an array
687      *
688      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
689      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
690      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
691      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
692      */
693     function _values(Set storage set) private view returns (bytes32[] memory) {
694         return set._values;
695     }
696 
697     // Bytes32Set
698 
699     struct Bytes32Set {
700         Set _inner;
701     }
702 
703     /**
704      * @dev Add a value to a set. O(1).
705      *
706      * Returns true if the value was added to the set, that is if it was not
707      * already present.
708      */
709     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
710         return _add(set._inner, value);
711     }
712 
713     /**
714      * @dev Removes a value from a set. O(1).
715      *
716      * Returns true if the value was removed from the set, that is if it was
717      * present.
718      */
719     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
720         return _remove(set._inner, value);
721     }
722 
723     /**
724      * @dev Returns true if the value is in the set. O(1).
725      */
726     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
727         return _contains(set._inner, value);
728     }
729 
730     /**
731      * @dev Returns the number of values in the set. O(1).
732      */
733     function length(Bytes32Set storage set) internal view returns (uint256) {
734         return _length(set._inner);
735     }
736 
737     /**
738      * @dev Returns the value stored at position `index` in the set. O(1).
739      *
740      * Note that there are no guarantees on the ordering of values inside the
741      * array, and it may change when more values are added or removed.
742      *
743      * Requirements:
744      *
745      * - `index` must be strictly less than {length}.
746      */
747     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
748         return _at(set._inner, index);
749     }
750 
751     /**
752      * @dev Return the entire set in an array
753      *
754      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
755      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
756      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
757      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
758      */
759     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
760         return _values(set._inner);
761     }
762 
763     // AddressSet
764 
765     struct AddressSet {
766         Set _inner;
767     }
768 
769     /**
770      * @dev Add a value to a set. O(1).
771      *
772      * Returns true if the value was added to the set, that is if it was not
773      * already present.
774      */
775     function add(AddressSet storage set, address value) internal returns (bool) {
776         return _add(set._inner, bytes32(uint256(uint160(value))));
777     }
778 
779     /**
780      * @dev Removes a value from a set. O(1).
781      *
782      * Returns true if the value was removed from the set, that is if it was
783      * present.
784      */
785     function remove(AddressSet storage set, address value) internal returns (bool) {
786         return _remove(set._inner, bytes32(uint256(uint160(value))));
787     }
788 
789     /**
790      * @dev Returns true if the value is in the set. O(1).
791      */
792     function contains(AddressSet storage set, address value) internal view returns (bool) {
793         return _contains(set._inner, bytes32(uint256(uint160(value))));
794     }
795 
796     /**
797      * @dev Returns the number of values in the set. O(1).
798      */
799     function length(AddressSet storage set) internal view returns (uint256) {
800         return _length(set._inner);
801     }
802 
803     /**
804      * @dev Returns the value stored at position `index` in the set. O(1).
805      *
806      * Note that there are no guarantees on the ordering of values inside the
807      * array, and it may change when more values are added or removed.
808      *
809      * Requirements:
810      *
811      * - `index` must be strictly less than {length}.
812      */
813     function at(AddressSet storage set, uint256 index) internal view returns (address) {
814         return address(uint160(uint256(_at(set._inner, index))));
815     }
816 
817     /**
818      * @dev Return the entire set in an array
819      *
820      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
821      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
822      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
823      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
824      */
825     function values(AddressSet storage set) internal view returns (address[] memory) {
826         bytes32[] memory store = _values(set._inner);
827         address[] memory result;
828 
829         assembly {
830             result := store
831         }
832 
833         return result;
834     }
835 
836     // UintSet
837 
838     struct UintSet {
839         Set _inner;
840     }
841 
842     /**
843      * @dev Add a value to a set. O(1).
844      *
845      * Returns true if the value was added to the set, that is if it was not
846      * already present.
847      */
848     function add(UintSet storage set, uint256 value) internal returns (bool) {
849         return _add(set._inner, bytes32(value));
850     }
851 
852     /**
853      * @dev Removes a value from a set. O(1).
854      *
855      * Returns true if the value was removed from the set, that is if it was
856      * present.
857      */
858     function remove(UintSet storage set, uint256 value) internal returns (bool) {
859         return _remove(set._inner, bytes32(value));
860     }
861 
862     /**
863      * @dev Returns true if the value is in the set. O(1).
864      */
865     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
866         return _contains(set._inner, bytes32(value));
867     }
868 
869     /**
870      * @dev Returns the number of values on the set. O(1).
871      */
872     function length(UintSet storage set) internal view returns (uint256) {
873         return _length(set._inner);
874     }
875 
876     /**
877      * @dev Returns the value stored at position `index` in the set. O(1).
878      *
879      * Note that there are no guarantees on the ordering of values inside the
880      * array, and it may change when more values are added or removed.
881      *
882      * Requirements:
883      *
884      * - `index` must be strictly less than {length}.
885      */
886     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
887         return uint256(_at(set._inner, index));
888     }
889 
890     /**
891      * @dev Return the entire set in an array
892      *
893      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
894      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
895      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
896      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
897      */
898     function values(UintSet storage set) internal view returns (uint256[] memory) {
899         bytes32[] memory store = _values(set._inner);
900         uint256[] memory result;
901 
902         assembly {
903             result := store
904         }
905 
906         return result;
907     }
908 }
909 
910 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 /**
915  * @dev Contract module that helps prevent reentrant calls to a function.
916  *
917  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
918  * available, which can be applied to functions to make sure there are no nested
919  * (reentrant) calls to them.
920  *
921  * Note that because there is a single `nonReentrant` guard, functions marked as
922  * `nonReentrant` may not call one another. This can be worked around by making
923  * those functions `private`, and then adding `external` `nonReentrant` entry
924  * points to them.
925  *
926  * TIP: If you would like to learn more about reentrancy and alternative ways
927  * to protect against it, check out our blog post
928  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
929  */
930 abstract contract ReentrancyGuard {
931     // Booleans are more expensive than uint256 or any type that takes up a full
932     // word because each write operation emits an extra SLOAD to first read the
933     // slot's contents, replace the bits taken up by the boolean, and then write
934     // back. This is the compiler's defense against contract upgrades and
935     // pointer aliasing, and it cannot be disabled.
936 
937     // The values being non-zero value makes deployment a bit more expensive,
938     // but in exchange the refund on every call to nonReentrant will be lower in
939     // amount. Since refunds are capped to a percentage of the total
940     // transaction's gas, it is best to keep them low in cases like this one, to
941     // increase the likelihood of the full refund coming into effect.
942     uint256 private constant _NOT_ENTERED = 1;
943     uint256 private constant _ENTERED = 2;
944 
945     uint256 private _status;
946 
947     constructor() {
948         _status = _NOT_ENTERED;
949     }
950 
951     /**
952      * @dev Prevents a contract from calling itself, directly or indirectly.
953      * Calling a `nonReentrant` function from another `nonReentrant`
954      * function is not supported. It is possible to prevent this from happening
955      * by making the `nonReentrant` function external, and making it call a
956      * `private` function that does the actual work.
957      */
958     modifier nonReentrant() {
959         // On the first call to nonReentrant, _notEntered will be true
960         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
961 
962         // Any calls to nonReentrant after this point will fail
963         _status = _ENTERED;
964 
965         _;
966 
967         // By storing the original value once again, a refund is triggered (see
968         // https://eips.ethereum.org/EIPS/eip-2200)
969         _status = _NOT_ENTERED;
970     }
971 }
972 
973 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Standard math utilities missing in the Solidity language.
979  */
980 library Math {
981     /**
982      * @dev Returns the largest of two numbers.
983      */
984     function max(uint256 a, uint256 b) internal pure returns (uint256) {
985         return a >= b ? a : b;
986     }
987 
988     /**
989      * @dev Returns the smallest of two numbers.
990      */
991     function min(uint256 a, uint256 b) internal pure returns (uint256) {
992         return a < b ? a : b;
993     }
994 
995     /**
996      * @dev Returns the average of two numbers. The result is rounded towards
997      * zero.
998      */
999     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1000         // (a + b) / 2 can overflow.
1001         return (a & b) + (a ^ b) / 2;
1002     }
1003 
1004     /**
1005      * @dev Returns the ceiling of the division of two numbers.
1006      *
1007      * This differs from standard division with `/` in that it rounds up instead
1008      * of rounding down.
1009      */
1010     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1011         // (a + b - 1) / b can overflow on addition, so we distribute.
1012         return a / b + (a % b == 0 ? 0 : 1);
1013     }
1014 }
1015 
1016 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 //import "../utils/Context.sol";
1021 
1022 /**
1023  * @dev Contract module which allows children to implement an emergency stop
1024  * mechanism that can be triggered by an authorized account.
1025  *
1026  * This module is used through inheritance. It will make available the
1027  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1028  * the functions of your contract. Note that they will not be pausable by
1029  * simply including this module, only once the modifiers are put in place.
1030  */
1031 abstract contract Pausable is Context {
1032     /**
1033      * @dev Emitted when the pause is triggered by `account`.
1034      */
1035     event Paused(address account);
1036 
1037     /**
1038      * @dev Emitted when the pause is lifted by `account`.
1039      */
1040     event Unpaused(address account);
1041 
1042     bool private _paused;
1043 
1044     /**
1045      * @dev Initializes the contract in unpaused state.
1046      */
1047     constructor() {
1048         _paused = false;
1049     }
1050 
1051     /**
1052      * @dev Returns true if the contract is paused, and false otherwise.
1053      */
1054     function paused() public view virtual returns (bool) {
1055         return _paused;
1056     }
1057 
1058     /**
1059      * @dev Modifier to make a function callable only when the contract is not paused.
1060      *
1061      * Requirements:
1062      *
1063      * - The contract must not be paused.
1064      */
1065     modifier whenNotPaused() {
1066         require(!paused(), "Pausable: paused");
1067         _;
1068     }
1069 
1070     /**
1071      * @dev Modifier to make a function callable only when the contract is paused.
1072      *
1073      * Requirements:
1074      *
1075      * - The contract must be paused.
1076      */
1077     modifier whenPaused() {
1078         require(paused(), "Pausable: not paused");
1079         _;
1080     }
1081 
1082     /**
1083      * @dev Triggers stopped state.
1084      *
1085      * Requirements:
1086      *
1087      * - The contract must not be paused.
1088      */
1089     function _pause() internal virtual whenNotPaused {
1090         _paused = true;
1091         emit Paused(_msgSender());
1092     }
1093 
1094     /**
1095      * @dev Returns to normal state.
1096      *
1097      * Requirements:
1098      *
1099      * - The contract must be paused.
1100      */
1101     function _unpause() internal virtual whenPaused {
1102         _paused = false;
1103         emit Unpaused(_msgSender());
1104     }
1105 }
1106 
1107 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 /**
1112  * @dev Interface of the ERC20 standard as defined in the EIP.
1113  */
1114 interface IERC20 {
1115     /**
1116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1117      * another (`to`).
1118      *
1119      * Note that `value` may be zero.
1120      */
1121     event Transfer(address indexed from, address indexed to, uint256 value);
1122 
1123     /**
1124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1125      * a call to {approve}. `value` is the new allowance.
1126      */
1127     event Approval(address indexed owner, address indexed spender, uint256 value);
1128 
1129     /**
1130      * @dev Returns the amount of tokens in existence.
1131      */
1132     function totalSupply() external view returns (uint256);
1133 
1134     /**
1135      * @dev Returns the amount of tokens owned by `account`.
1136      */
1137     function balanceOf(address account) external view returns (uint256);
1138 
1139     /**
1140      * @dev Moves `amount` tokens from the caller's account to `to`.
1141      *
1142      * Returns a boolean value indicating whether the operation succeeded.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function transfer(address to, uint256 amount) external returns (bool);
1147 
1148     /**
1149      * @dev Returns the remaining number of tokens that `spender` will be
1150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1151      * zero by default.
1152      *
1153      * This value changes when {approve} or {transferFrom} are called.
1154      */
1155     function allowance(address owner, address spender) external view returns (uint256);
1156 
1157     /**
1158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1159      *
1160      * Returns a boolean value indicating whether the operation succeeded.
1161      *
1162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1163      * that someone may use both the old and the new allowance by unfortunate
1164      * transaction ordering. One possible solution to mitigate this race
1165      * condition is to first reduce the spender's allowance to 0 and set the
1166      * desired value afterwards:
1167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1168      *
1169      * Emits an {Approval} event.
1170      */
1171     function approve(address spender, uint256 amount) external returns (bool);
1172 
1173     /**
1174      * @dev Moves `amount` tokens from `from` to `to` using the
1175      * allowance mechanism. `amount` is then deducted from the caller's
1176      * allowance.
1177      *
1178      * Returns a boolean value indicating whether the operation succeeded.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 amount
1186     ) external returns (bool);
1187 }
1188 
1189 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1190 
1191 pragma solidity ^0.8.1;
1192 
1193 /**
1194  * @dev Collection of functions related to the address type
1195  */
1196 library Address {
1197     /**
1198      * @dev Returns true if `account` is a contract.
1199      *
1200      * [IMPORTANT]
1201      * ====
1202      * It is unsafe to assume that an address for which this function returns
1203      * false is an externally-owned account (EOA) and not a contract.
1204      *
1205      * Among others, `isContract` will return false for the following
1206      * types of addresses:
1207      *
1208      *  - an externally-owned account
1209      *  - a contract in construction
1210      *  - an address where a contract will be created
1211      *  - an address where a contract lived, but was destroyed
1212      * ====
1213      *
1214      * [IMPORTANT]
1215      * ====
1216      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1217      *
1218      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1219      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1220      * constructor.
1221      * ====
1222      */
1223     function isContract(address account) internal view returns (bool) {
1224         // This method relies on extcodesize/address.code.length, which returns 0
1225         // for contracts in construction, since the code is only stored at the end
1226         // of the constructor execution.
1227 
1228         return account.code.length > 0;
1229     }
1230 
1231     /**
1232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1233      * `recipient`, forwarding all available gas and reverting on errors.
1234      *
1235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1237      * imposed by `transfer`, making them unable to receive funds via
1238      * `transfer`. {sendValue} removes this limitation.
1239      *
1240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1241      *
1242      * IMPORTANT: because control is transferred to `recipient`, care must be
1243      * taken to not create reentrancy vulnerabilities. Consider using
1244      * {ReentrancyGuard} or the
1245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1246      */
1247     function sendValue(address payable recipient, uint256 amount) internal {
1248         require(address(this).balance >= amount, "Address: insufficient balance");
1249 
1250         (bool success, ) = recipient.call{value: amount}("");
1251         require(success, "Address: unable to send value, recipient may have reverted");
1252     }
1253 
1254     /**
1255      * @dev Performs a Solidity function call using a low level `call`. A
1256      * plain `call` is an unsafe replacement for a function call: use this
1257      * function instead.
1258      *
1259      * If `target` reverts with a revert reason, it is bubbled up by this
1260      * function (like regular Solidity function calls).
1261      *
1262      * Returns the raw returned data. To convert to the expected return value,
1263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1264      *
1265      * Requirements:
1266      *
1267      * - `target` must be a contract.
1268      * - calling `target` with `data` must not revert.
1269      *
1270      * _Available since v3.1._
1271      */
1272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1273         return functionCall(target, data, "Address: low-level call failed");
1274     }
1275 
1276     /**
1277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1278      * `errorMessage` as a fallback revert reason when `target` reverts.
1279      *
1280      * _Available since v3.1._
1281      */
1282     function functionCall(
1283         address target,
1284         bytes memory data,
1285         string memory errorMessage
1286     ) internal returns (bytes memory) {
1287         return functionCallWithValue(target, data, 0, errorMessage);
1288     }
1289 
1290     /**
1291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1292      * but also transferring `value` wei to `target`.
1293      *
1294      * Requirements:
1295      *
1296      * - the calling contract must have an ETH balance of at least `value`.
1297      * - the called Solidity function must be `payable`.
1298      *
1299      * _Available since v3.1._
1300      */
1301     function functionCallWithValue(
1302         address target,
1303         bytes memory data,
1304         uint256 value
1305     ) internal returns (bytes memory) {
1306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1307     }
1308 
1309     /**
1310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1311      * with `errorMessage` as a fallback revert reason when `target` reverts.
1312      *
1313      * _Available since v3.1._
1314      */
1315     function functionCallWithValue(
1316         address target,
1317         bytes memory data,
1318         uint256 value,
1319         string memory errorMessage
1320     ) internal returns (bytes memory) {
1321         require(address(this).balance >= value, "Address: insufficient balance for call");
1322         require(isContract(target), "Address: call to non-contract");
1323 
1324         (bool success, bytes memory returndata) = target.call{value: value}(data);
1325         return verifyCallResult(success, returndata, errorMessage);
1326     }
1327 
1328     /**
1329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1330      * but performing a static call.
1331      *
1332      * _Available since v3.3._
1333      */
1334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1335         return functionStaticCall(target, data, "Address: low-level static call failed");
1336     }
1337 
1338     /**
1339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1340      * but performing a static call.
1341      *
1342      * _Available since v3.3._
1343      */
1344     function functionStaticCall(
1345         address target,
1346         bytes memory data,
1347         string memory errorMessage
1348     ) internal view returns (bytes memory) {
1349         require(isContract(target), "Address: static call to non-contract");
1350 
1351         (bool success, bytes memory returndata) = target.staticcall(data);
1352         return verifyCallResult(success, returndata, errorMessage);
1353     }
1354 
1355     /**
1356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1357      * but performing a delegate call.
1358      *
1359      * _Available since v3.4._
1360      */
1361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1363     }
1364 
1365     /**
1366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1367      * but performing a delegate call.
1368      *
1369      * _Available since v3.4._
1370      */
1371     function functionDelegateCall(
1372         address target,
1373         bytes memory data,
1374         string memory errorMessage
1375     ) internal returns (bytes memory) {
1376         require(isContract(target), "Address: delegate call to non-contract");
1377 
1378         (bool success, bytes memory returndata) = target.delegatecall(data);
1379         return verifyCallResult(success, returndata, errorMessage);
1380     }
1381 
1382     /**
1383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1384      * revert reason using the provided one.
1385      *
1386      * _Available since v4.3._
1387      */
1388     function verifyCallResult(
1389         bool success,
1390         bytes memory returndata,
1391         string memory errorMessage
1392     ) internal pure returns (bytes memory) {
1393         if (success) {
1394             return returndata;
1395         } else {
1396             // Look for revert reason and bubble it up if present
1397             if (returndata.length > 0) {
1398                 // The easiest way to bubble the revert reason is using memory via assembly
1399 
1400                 assembly {
1401                     let returndata_size := mload(returndata)
1402                     revert(add(32, returndata), returndata_size)
1403                 }
1404             } else {
1405                 revert(errorMessage);
1406             }
1407         }
1408     }
1409 }
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 // import "@openzeppelin/contracts/access/Ownable.sol";
1414 // import "@openzeppelin/contracts/utils/Address.sol";
1415 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
1416 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
1417 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
1418 // import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
1419 // import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1420 // import '@openzeppelin/contracts/utils/math/Math.sol';
1421 // import "@openzeppelin/contracts/security/Pausable.sol";
1422 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1423 
1424 
1425 contract NftStaking is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1426     using Address for address;
1427     using SafeMath for uint;
1428     using EnumerableSet for EnumerableSet.UintSet; 
1429     
1430     //addresses 
1431     address nullAddress = 0x0000000000000000000000000000000000000000;
1432     address public stakingDestinationAddress;
1433     address public erc20Address;
1434 
1435     //uint256's 
1436     uint256 public expiration; 
1437     //rate governs how often you receive your token
1438     uint256 public rate; 
1439 
1440     // unstaking possible after LOCKUP_TIME
1441     uint public LOCKUP_TIME = 30 days;
1442 
1443     // Contracts are not allowed to deposit, claim or withdraw
1444     modifier noContractsAllowed() {
1445         require(!(address(msg.sender).isContract()) && tx.origin == msg.sender, "No Contracts Allowed!");
1446         _;
1447     }
1448 
1449     event RateChanged(uint256 newRate);
1450     event ExpirationChanged(uint256 newExpiration);
1451     event LockTimeChanged(uint newLockTime);
1452   
1453     // mappings 
1454     mapping(address => EnumerableSet.UintSet) private _deposits;
1455     mapping(address => mapping(uint256 => uint256)) public _depositBlocks;
1456     mapping (address => uint) public stakingTime;
1457 
1458     constructor(
1459       address _stakingDestinationAddress,
1460       uint256 _rate,
1461       uint256 _expiration,
1462       address _erc20Address
1463     ) {
1464         stakingDestinationAddress = _stakingDestinationAddress;
1465         rate = _rate;
1466         expiration = block.number + _expiration;
1467         erc20Address = _erc20Address;
1468         _pause();
1469     }
1470 
1471     function pause() public onlyOwner {
1472         _pause();
1473     }
1474 
1475     function unpause() public onlyOwner {
1476         _unpause();
1477     }
1478 
1479 /* STAKING MECHANICS */
1480 
1481     // Set a multiplier for how many tokens to earn each time a block passes.
1482     function setRate(uint256 _rate) public onlyOwner() {
1483       rate = _rate;
1484       emit RateChanged(rate);
1485     }
1486 
1487     // Set this to a block to disable the ability to continue accruing tokens past that block number.
1488     function setExpiration(uint256 _expiration) public onlyOwner() {
1489       expiration = block.number + _expiration;
1490       emit ExpirationChanged(expiration);
1491     }
1492 
1493     //Set Lock Time
1494     function setLockTime(uint _lockTime) public onlyOwner() {
1495       LOCKUP_TIME = _lockTime;
1496       emit LockTimeChanged(LOCKUP_TIME);
1497     }
1498 
1499     //check deposit amount. 
1500     function depositsOf(address account)
1501       external 
1502       view 
1503       returns (uint256[] memory)
1504     {
1505       EnumerableSet.UintSet storage depositSet = _deposits[account];
1506       uint256[] memory tokenIds = new uint256[] (depositSet.length());
1507 
1508       for (uint256 i; i < depositSet.length(); i++) {
1509         tokenIds[i] = depositSet.at(i);
1510       }
1511 
1512       return tokenIds;
1513     }
1514 
1515     function calculateRewards(address account, uint256[] memory tokenIds) 
1516       public 
1517       view 
1518       returns (uint256[] memory rewards) 
1519     {
1520       rewards = new uint256[](tokenIds.length);
1521 
1522       for (uint256 i; i < tokenIds.length; i++) {
1523         uint256 tokenId = tokenIds[i];
1524 
1525         rewards[i] = 
1526           rate * 
1527           (_deposits[account].contains(tokenId) ? 1 : 0) * 
1528           (Math.min(block.number, expiration) - 
1529             _depositBlocks[account][tokenId]);
1530       }
1531 
1532       return rewards;
1533     }
1534 
1535     //reward amount by address/tokenIds[]
1536     function calculateReward(address account, uint256 tokenId) 
1537       public 
1538       view 
1539       returns (uint256) 
1540     {
1541       // require(Math.min(block.number, expiration) > _depositBlocks[account][tokenId], "Invalid blocks");
1542       return rate * 
1543           (_deposits[account].contains(tokenId) ? 1 : 0) * 
1544           (Math.min(block.number, expiration) - 
1545             _depositBlocks[account][tokenId]);
1546     }
1547 
1548     //Update Account and Auto-claim 
1549     function updateAccount(uint256[] calldata tokenIds) private {
1550       uint256 reward; 
1551       uint256 blockCur = Math.min(block.number, expiration);
1552 
1553       for (uint256 i; i < tokenIds.length; i++) {
1554         reward += calculateReward(msg.sender, tokenIds[i]);
1555         _depositBlocks[msg.sender][tokenIds[i]] = blockCur;
1556       }
1557 
1558       if (reward > 0) {
1559         require(IERC20(erc20Address).transfer(msg.sender, reward), "Could not transfer Reward Token!");
1560       }
1561     }
1562 
1563     //Reward claim function
1564     function claimRewards(uint256[] calldata tokenIds) external whenNotPaused noContractsAllowed nonReentrant(){
1565       updateAccount(tokenIds);
1566     }
1567 
1568     //deposit function. 
1569     function deposit(uint256[] calldata tokenIds) external whenNotPaused noContractsAllowed nonReentrant() {
1570         require(msg.sender != stakingDestinationAddress, "Invalid address");
1571         require(block.number < expiration, "Staking has finished, no more deposits!");
1572         updateAccount(tokenIds);
1573 
1574         for (uint256 i; i < tokenIds.length; i++) {
1575             IERC721(stakingDestinationAddress).safeTransferFrom(
1576                 msg.sender,
1577                 address(this),
1578                 tokenIds[i],
1579                 ""
1580             );
1581 
1582             _deposits[msg.sender].add(tokenIds[i]);
1583         }
1584         stakingTime[msg.sender] = block.timestamp;
1585     }
1586 
1587     //withdrawal function.
1588     function withdraw(uint256[] calldata tokenIds) external whenNotPaused noContractsAllowed nonReentrant() {
1589 
1590     	require(block.timestamp.sub(stakingTime[msg.sender]) > LOCKUP_TIME, "You recently staked, please wait before withdrawing.");
1591 
1592         updateAccount(tokenIds);
1593 
1594         for (uint256 i; i < tokenIds.length; i++) {
1595             require(
1596                 _deposits[msg.sender].contains(tokenIds[i]),
1597                 "Staking: token not deposited"
1598             );
1599 
1600             _deposits[msg.sender].remove(tokenIds[i]);
1601 
1602             IERC721(stakingDestinationAddress).safeTransferFrom(
1603                 address(this),
1604                 msg.sender,
1605                 tokenIds[i],
1606                 ""
1607             );
1608         }
1609     }
1610 
1611     //withdraw without caring about Rewards
1612     function emergencyWithdraw(uint256[] calldata tokenIds) external noContractsAllowed nonReentrant() {
1613         require(block.timestamp.sub(stakingTime[msg.sender]) > LOCKUP_TIME, "You recently staked, please wait before withdrawing.");
1614         
1615         for (uint256 i; i < tokenIds.length; i++) {
1616             require(
1617                 _deposits[msg.sender].contains(tokenIds[i]),
1618                 "Staking: token not deposited"
1619             );
1620 
1621             _deposits[msg.sender].remove(tokenIds[i]);
1622 
1623             IERC721(stakingDestinationAddress).safeTransferFrom(
1624                 address(this),
1625                 msg.sender,
1626                 tokenIds[i],
1627                 ""
1628             );
1629         }
1630     }
1631 
1632     //withdrawal function.
1633     function withdrawTokens() external onlyOwner {
1634         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1635         require(IERC20(erc20Address).transfer(msg.sender, tokenSupply), "Could not transfer Reward Token!");
1636     }
1637 
1638     // Prevent sending ERC721 tokens directly to this contract
1639     function onERC721Received(
1640         address,
1641         address,
1642         uint256,
1643         bytes calldata
1644     ) external pure override returns (bytes4) {
1645         return IERC721Receiver.onERC721Received.selector;
1646     }
1647 }