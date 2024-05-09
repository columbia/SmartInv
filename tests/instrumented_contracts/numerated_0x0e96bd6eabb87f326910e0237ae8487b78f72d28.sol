1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 
97 // CAUTION
98 // This version of SafeMath should only be used with Solidity 0.8 or later,
99 // because it relies on the compiler's built in overflow checks.
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations.
103  *
104  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
105  * now has built in overflow checking.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             uint256 c = a + b;
116             if (c < a) return (false, 0);
117             return (true, c);
118         }
119     }
120 
121     /**
122      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
123      *
124      * _Available since v3.4._
125      */
126     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
127         unchecked {
128             if (b > a) return (false, 0);
129             return (true, a - b);
130         }
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141             // benefit is lost if 'b' is also tested.
142             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143             if (a == 0) return (true, 0);
144             uint256 c = a * b;
145             if (c / a != b) return (false, 0);
146             return (true, c);
147         }
148     }
149 
150     /**
151      * @dev Returns the division of two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             if (b == 0) return (false, 0);
158             return (true, a / b);
159         }
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             if (b == 0) return (false, 0);
170             return (true, a % b);
171         }
172     }
173 
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a + b;
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         return a - b;
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `*` operator.
207      *
208      * Requirements:
209      *
210      * - Multiplication cannot overflow.
211      */
212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
213         return a * b;
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers, reverting on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator.
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a / b;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a % b;
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * CAUTION: This function is deprecated because it requires allocating memory for the error
251      * message unnecessarily. For custom revert reasons use {trySub}.
252      *
253      * Counterpart to Solidity's `-` operator.
254      *
255      * Requirements:
256      *
257      * - Subtraction cannot overflow.
258      */
259     function sub(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b <= a, errorMessage);
266             return a - b;
267         }
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b > 0, errorMessage);
289             return a / b;
290         }
291     }
292 
293     /**
294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
295      * reverting with custom message when dividing by zero.
296      *
297      * CAUTION: This function is deprecated because it requires allocating memory for the error
298      * message unnecessarily. For custom revert reasons use {tryMod}.
299      *
300      * Counterpart to Solidity's `%` operator. This function uses a `revert`
301      * opcode (which leaves remaining gas untouched) while Solidity uses an
302      * invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function mod(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b > 0, errorMessage);
315             return a % b;
316         }
317     }
318 }
319 
320 
321 /**
322  * @dev Interface of the ERC165 standard, as defined in the
323  * https://eips.ethereum.org/EIPS/eip-165[EIP].
324  *
325  * Implementers can declare support of contract interfaces, which can then be
326  * queried by others ({ERC165Checker}).
327  *
328  * For an implementation, see {ERC165}.
329  */
330 interface IERC165 {
331     /**
332      * @dev Returns true if this contract implements the interface defined by
333      * `interfaceId`. See the corresponding
334      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
335      * to learn more about how these ids are created.
336      *
337      * This function call must use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 }
341 
342 
343 /**
344  * @dev Implementation of the {IERC165} interface.
345  *
346  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
347  * for the additional interface id that will be supported. For example:
348  *
349  * ```solidity
350  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
351  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
352  * }
353  * ```
354  *
355  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
356  */
357 abstract contract ERC165 is IERC165 {
358     /**
359      * @dev See {IERC165-supportsInterface}.
360      */
361     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
362         return interfaceId == type(IERC165).interfaceId;
363     }
364 }
365 
366 
367 /**
368  * @dev Required interface of an ERC721 compliant contract.
369  */
370 interface IERC721 is IERC165 {
371     /**
372      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
375 
376     /**
377      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
378      */
379     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
383      */
384     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
385 
386     /**
387      * @dev Returns the number of tokens in ``owner``'s account.
388      */
389     function balanceOf(address owner) external view returns (uint256 balance);
390 
391     /**
392      * @dev Returns the owner of the `tokenId` token.
393      *
394      * Requirements:
395      *
396      * - `tokenId` must exist.
397      */
398     function ownerOf(uint256 tokenId) external view returns (address owner);
399 
400     /**
401      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
402      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Transfers `tokenId` token from `from` to `to`.
422      *
423      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Returns the account approved for `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function getApproved(uint256 tokenId) external view returns (address operator);
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId,
500         bytes calldata data
501     ) external;
502 }
503 
504 
505 /**
506  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
507  * @dev See https://eips.ethereum.org/EIPS/eip-721
508  */
509 interface IERC721Enumerable is IERC721 {
510     /**
511      * @dev Returns the total amount of tokens stored by the contract.
512      */
513     function totalSupply() external view returns (uint256);
514 
515     /**
516      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
517      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
518      */
519     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
520 
521     /**
522      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
523      * Use along with {totalSupply} to enumerate all tokens.
524      */
525     function tokenByIndex(uint256 index) external view returns (uint256);
526 }
527 
528 
529 
530 
531 
532 interface IERC721Receiver {
533     /**
534      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
535      * by `operator` from `from`, this function is called.
536      *
537      * It must return its Solidity selector to confirm the token transfer.
538      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
539      *
540      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
541      */
542     function onERC721Received(
543         address operator,
544         address from,
545         uint256 tokenId,
546         bytes calldata data
547     ) external returns (bytes4);
548 }
549 
550 
551 /**
552  * @dev Library for managing
553  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
554  * types.
555  *
556  * Sets have the following properties:
557  *
558  * - Elements are added, removed, and checked for existence in constant time
559  * (O(1)).
560  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
561  *
562  * ```
563  * contract Example {
564  *     // Add the library methods
565  *     using EnumerableSet for EnumerableSet.AddressSet;
566  *
567  *     // Declare a set state variable
568  *     EnumerableSet.AddressSet private mySet;
569  * }
570  * ```
571  *
572  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
573  * and `uint256` (`UintSet`) are supported.
574  */
575 library EnumerableSet {
576     // To implement this library for multiple types with as little code
577     // repetition as possible, we write it in terms of a generic Set type with
578     // bytes32 values.
579     // The Set implementation uses private functions, and user-facing
580     // implementations (such as AddressSet) are just wrappers around the
581     // underlying Set.
582     // This means that we can only create new EnumerableSets for types that fit
583     // in bytes32.
584 
585     struct Set {
586         // Storage of set values
587         bytes32[] _values;
588         // Position of the value in the `values` array, plus 1 because index 0
589         // means a value is not in the set.
590         mapping(bytes32 => uint256) _indexes;
591     }
592 
593     /**
594      * @dev Add a value to a set. O(1).
595      *
596      * Returns true if the value was added to the set, that is if it was not
597      * already present.
598      */
599     function _add(Set storage set, bytes32 value) private returns (bool) {
600         if (!_contains(set, value)) {
601             set._values.push(value);
602             // The value is stored at length-1, but we add 1 to all indexes
603             // and use 0 as a sentinel value
604             set._indexes[value] = set._values.length;
605             return true;
606         } else {
607             return false;
608         }
609     }
610 
611     /**
612      * @dev Removes a value from a set. O(1).
613      *
614      * Returns true if the value was removed from the set, that is if it was
615      * present.
616      */
617     function _remove(Set storage set, bytes32 value) private returns (bool) {
618         // We read and store the value's index to prevent multiple reads from the same storage slot
619         uint256 valueIndex = set._indexes[value];
620 
621         if (valueIndex != 0) {
622             // Equivalent to contains(set, value)
623             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
624             // the array, and then remove the last element (sometimes called as 'swap and pop').
625             // This modifies the order of the array, as noted in {at}.
626 
627             uint256 toDeleteIndex = valueIndex - 1;
628             uint256 lastIndex = set._values.length - 1;
629 
630             if (lastIndex != toDeleteIndex) {
631                 bytes32 lastvalue = set._values[lastIndex];
632 
633                 // Move the last value to the index where the value to delete is
634                 set._values[toDeleteIndex] = lastvalue;
635                 // Update the index for the moved value
636                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
637             }
638 
639             // Delete the slot where the moved value was stored
640             set._values.pop();
641 
642             // Delete the index for the deleted slot
643             delete set._indexes[value];
644 
645             return true;
646         } else {
647             return false;
648         }
649     }
650 
651     /**
652      * @dev Returns true if the value is in the set. O(1).
653      */
654     function _contains(Set storage set, bytes32 value) private view returns (bool) {
655         return set._indexes[value] != 0;
656     }
657 
658     /**
659      * @dev Returns the number of values on the set. O(1).
660      */
661     function _length(Set storage set) private view returns (uint256) {
662         return set._values.length;
663     }
664 
665     /**
666      * @dev Returns the value stored at position `index` in the set. O(1).
667      *
668      * Note that there are no guarantees on the ordering of values inside the
669      * array, and it may change when more values are added or removed.
670      *
671      * Requirements:
672      *
673      * - `index` must be strictly less than {length}.
674      */
675     function _at(Set storage set, uint256 index) private view returns (bytes32) {
676         return set._values[index];
677     }
678 
679     /**
680      * @dev Return the entire set in an array
681      *
682      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
683      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
684      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
685      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
686      */
687     function _values(Set storage set) private view returns (bytes32[] memory) {
688         return set._values;
689     }
690 
691     // Bytes32Set
692 
693     struct Bytes32Set {
694         Set _inner;
695     }
696 
697     /**
698      * @dev Add a value to a set. O(1).
699      *
700      * Returns true if the value was added to the set, that is if it was not
701      * already present.
702      */
703     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
704         return _add(set._inner, value);
705     }
706 
707     /**
708      * @dev Removes a value from a set. O(1).
709      *
710      * Returns true if the value was removed from the set, that is if it was
711      * present.
712      */
713     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
714         return _remove(set._inner, value);
715     }
716 
717     /**
718      * @dev Returns true if the value is in the set. O(1).
719      */
720     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
721         return _contains(set._inner, value);
722     }
723 
724     /**
725      * @dev Returns the number of values in the set. O(1).
726      */
727     function length(Bytes32Set storage set) internal view returns (uint256) {
728         return _length(set._inner);
729     }
730 
731     /**
732      * @dev Returns the value stored at position `index` in the set. O(1).
733      *
734      * Note that there are no guarantees on the ordering of values inside the
735      * array, and it may change when more values are added or removed.
736      *
737      * Requirements:
738      *
739      * - `index` must be strictly less than {length}.
740      */
741     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
742         return _at(set._inner, index);
743     }
744 
745     /**
746      * @dev Return the entire set in an array
747      *
748      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
749      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
750      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
751      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
752      */
753     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
754         return _values(set._inner);
755     }
756 
757     // AddressSet
758 
759     struct AddressSet {
760         Set _inner;
761     }
762 
763     /**
764      * @dev Add a value to a set. O(1).
765      *
766      * Returns true if the value was added to the set, that is if it was not
767      * already present.
768      */
769     function add(AddressSet storage set, address value) internal returns (bool) {
770         return _add(set._inner, bytes32(uint256(uint160(value))));
771     }
772 
773     /**
774      * @dev Removes a value from a set. O(1).
775      *
776      * Returns true if the value was removed from the set, that is if it was
777      * present.
778      */
779     function remove(AddressSet storage set, address value) internal returns (bool) {
780         return _remove(set._inner, bytes32(uint256(uint160(value))));
781     }
782 
783     /**
784      * @dev Returns true if the value is in the set. O(1).
785      */
786     function contains(AddressSet storage set, address value) internal view returns (bool) {
787         return _contains(set._inner, bytes32(uint256(uint160(value))));
788     }
789 
790     /**
791      * @dev Returns the number of values in the set. O(1).
792      */
793     function length(AddressSet storage set) internal view returns (uint256) {
794         return _length(set._inner);
795     }
796 
797     /**
798      * @dev Returns the value stored at position `index` in the set. O(1).
799      *
800      * Note that there are no guarantees on the ordering of values inside the
801      * array, and it may change when more values are added or removed.
802      *
803      * Requirements:
804      *
805      * - `index` must be strictly less than {length}.
806      */
807     function at(AddressSet storage set, uint256 index) internal view returns (address) {
808         return address(uint160(uint256(_at(set._inner, index))));
809     }
810 
811     /**
812      * @dev Return the entire set in an array
813      *
814      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
815      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
816      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
817      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
818      */
819     function values(AddressSet storage set) internal view returns (address[] memory) {
820         bytes32[] memory store = _values(set._inner);
821         address[] memory result;
822 
823         assembly {
824             result := store
825         }
826 
827         return result;
828     }
829 
830     // UintSet
831 
832     struct UintSet {
833         Set _inner;
834     }
835 
836     /**
837      * @dev Add a value to a set. O(1).
838      *
839      * Returns true if the value was added to the set, that is if it was not
840      * already present.
841      */
842     function add(UintSet storage set, uint256 value) internal returns (bool) {
843         return _add(set._inner, bytes32(value));
844     }
845 
846     /**
847      * @dev Removes a value from a set. O(1).
848      *
849      * Returns true if the value was removed from the set, that is if it was
850      * present.
851      */
852     function remove(UintSet storage set, uint256 value) internal returns (bool) {
853         return _remove(set._inner, bytes32(value));
854     }
855 
856     /**
857      * @dev Returns true if the value is in the set. O(1).
858      */
859     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
860         return _contains(set._inner, bytes32(value));
861     }
862 
863     /**
864      * @dev Returns the number of values on the set. O(1).
865      */
866     function length(UintSet storage set) internal view returns (uint256) {
867         return _length(set._inner);
868     }
869 
870     /**
871      * @dev Returns the value stored at position `index` in the set. O(1).
872      *
873      * Note that there are no guarantees on the ordering of values inside the
874      * array, and it may change when more values are added or removed.
875      *
876      * Requirements:
877      *
878      * - `index` must be strictly less than {length}.
879      */
880     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
881         return uint256(_at(set._inner, index));
882     }
883 
884     /**
885      * @dev Return the entire set in an array
886      *
887      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
888      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
889      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
890      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
891      */
892     function values(UintSet storage set) internal view returns (uint256[] memory) {
893         bytes32[] memory store = _values(set._inner);
894         uint256[] memory result;
895 
896         assembly {
897             result := store
898         }
899 
900         return result;
901     }
902 }
903 
904 
905 /**
906  * @dev Contract module that helps prevent reentrant calls to a function.
907  *
908  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
909  * available, which can be applied to functions to make sure there are no nested
910  * (reentrant) calls to them.
911  *
912  * Note that because there is a single `nonReentrant` guard, functions marked as
913  * `nonReentrant` may not call one another. This can be worked around by making
914  * those functions `private`, and then adding `external` `nonReentrant` entry
915  * points to them.
916  *
917  * TIP: If you would like to learn more about reentrancy and alternative ways
918  * to protect against it, check out our blog post
919  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
920  */
921 abstract contract ReentrancyGuard {
922     // Booleans are more expensive than uint256 or any type that takes up a full
923     // word because each write operation emits an extra SLOAD to first read the
924     // slot's contents, replace the bits taken up by the boolean, and then write
925     // back. This is the compiler's defense against contract upgrades and
926     // pointer aliasing, and it cannot be disabled.
927 
928     // The values being non-zero value makes deployment a bit more expensive,
929     // but in exchange the refund on every call to nonReentrant will be lower in
930     // amount. Since refunds are capped to a percentage of the total
931     // transaction's gas, it is best to keep them low in cases like this one, to
932     // increase the likelihood of the full refund coming into effect.
933     uint256 private constant _NOT_ENTERED = 1;
934     uint256 private constant _ENTERED = 2;
935 
936     uint256 private _status;
937 
938     constructor() {
939         _status = _NOT_ENTERED;
940     }
941 
942     /**
943      * @dev Prevents a contract from calling itself, directly or indirectly.
944      * Calling a `nonReentrant` function from another `nonReentrant`
945      * function is not supported. It is possible to prevent this from happening
946      * by making the `nonReentrant` function external, and making it call a
947      * `private` function that does the actual work.
948      */
949     modifier nonReentrant() {
950         // On the first call to nonReentrant, _notEntered will be true
951         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
952 
953         // Any calls to nonReentrant after this point will fail
954         _status = _ENTERED;
955 
956         _;
957 
958         // By storing the original value once again, a refund is triggered (see
959         // https://eips.ethereum.org/EIPS/eip-2200)
960         _status = _NOT_ENTERED;
961     }
962 }
963 
964 /**
965  * @dev Standard math utilities missing in the Solidity language.
966  */
967 library Math {
968     /**
969      * @dev Returns the largest of two numbers.
970      */
971     function max(uint256 a, uint256 b) internal pure returns (uint256) {
972         return a >= b ? a : b;
973     }
974 
975     /**
976      * @dev Returns the smallest of two numbers.
977      */
978     function min(uint256 a, uint256 b) internal pure returns (uint256) {
979         return a < b ? a : b;
980     }
981 
982     /**
983      * @dev Returns the average of two numbers. The result is rounded towards
984      * zero.
985      */
986     function average(uint256 a, uint256 b) internal pure returns (uint256) {
987         // (a + b) / 2 can overflow.
988         return (a & b) + (a ^ b) / 2;
989     }
990 
991     /**
992      * @dev Returns the ceiling of the division of two numbers.
993      *
994      * This differs from standard division with `/` in that it rounds up instead
995      * of rounding down.
996      */
997     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
998         // (a + b - 1) / b can overflow on addition, so we distribute.
999         return a / b + (a % b == 0 ? 0 : 1);
1000     }
1001 }
1002 
1003 
1004 /**
1005  * @dev Contract module which allows children to implement an emergency stop
1006  * mechanism that can be triggered by an authorized account.
1007  *
1008  * This module is used through inheritance. It will make available the
1009  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1010  * the functions of your contract. Note that they will not be pausable by
1011  * simply including this module, only once the modifiers are put in place.
1012  */
1013 abstract contract Pausable is Context {
1014     /**
1015      * @dev Emitted when the pause is triggered by `account`.
1016      */
1017     event Paused(address account);
1018 
1019     /**
1020      * @dev Emitted when the pause is lifted by `account`.
1021      */
1022     event Unpaused(address account);
1023 
1024     bool private _paused;
1025 
1026     /**
1027      * @dev Initializes the contract in unpaused state.
1028      */
1029     constructor() {
1030         _paused = false;
1031     }
1032 
1033     /**
1034      * @dev Returns true if the contract is paused, and false otherwise.
1035      */
1036     function paused() public view virtual returns (bool) {
1037         return _paused;
1038     }
1039 
1040     /**
1041      * @dev Modifier to make a function callable only when the contract is not paused.
1042      *
1043      * Requirements:
1044      *
1045      * - The contract must not be paused.
1046      */
1047     modifier whenNotPaused() {
1048         require(!paused(), "Pausable: paused");
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Modifier to make a function callable only when the contract is paused.
1054      *
1055      * Requirements:
1056      *
1057      * - The contract must be paused.
1058      */
1059     modifier whenPaused() {
1060         require(paused(), "Pausable: not paused");
1061         _;
1062     }
1063 
1064     /**
1065      * @dev Triggers stopped state.
1066      *
1067      * Requirements:
1068      *
1069      * - The contract must not be paused.
1070      */
1071     function _pause() internal virtual whenNotPaused {
1072         _paused = true;
1073         emit Paused(_msgSender());
1074     }
1075 
1076     /**
1077      * @dev Returns to normal state.
1078      *
1079      * Requirements:
1080      *
1081      * - The contract must be paused.
1082      */
1083     function _unpause() internal virtual whenPaused {
1084         _paused = false;
1085         emit Unpaused(_msgSender());
1086     }
1087 }
1088 
1089 /**
1090  * @dev Interface of the ERC20 standard as defined in the EIP.
1091  */
1092 interface IERC20 {
1093     /**
1094      * @dev Returns the amount of tokens in existence.
1095      */
1096     function totalSupply() external view returns (uint256);
1097 
1098     /**
1099      * @dev Returns the amount of tokens owned by `account`.
1100      */
1101     function balanceOf(address account) external view returns (uint256);
1102 
1103     /**
1104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1105      *
1106      * Returns a boolean value indicating whether the operation succeeded.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function transfer(address recipient, uint256 amount) external returns (bool);
1111 
1112     /**
1113      * @dev Returns the remaining number of tokens that `spender` will be
1114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1115      * zero by default.
1116      *
1117      * This value changes when {approve} or {transferFrom} are called.
1118      */
1119     function allowance(address owner, address spender) external view returns (uint256);
1120 
1121     /**
1122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1123      *
1124      * Returns a boolean value indicating whether the operation succeeded.
1125      *
1126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1127      * that someone may use both the old and the new allowance by unfortunate
1128      * transaction ordering. One possible solution to mitigate this race
1129      * condition is to first reduce the spender's allowance to 0 and set the
1130      * desired value afterwards:
1131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1132      *
1133      * Emits an {Approval} event.
1134      */
1135     function approve(address spender, uint256 amount) external returns (bool);
1136 
1137     /**
1138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1139      * allowance mechanism. `amount` is then deducted from the caller's
1140      * allowance.
1141      *
1142      * Returns a boolean value indicating whether the operation succeeded.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function transferFrom(
1147         address sender,
1148         address recipient,
1149         uint256 amount
1150     ) external returns (bool);
1151 
1152     /**
1153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1154      * another (`to`).
1155      *
1156      * Note that `value` may be zero.
1157      */
1158     event Transfer(address indexed from, address indexed to, uint256 value);
1159 
1160     /**
1161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1162      * a call to {approve}. `value` is the new allowance.
1163      */
1164     event Approval(address indexed owner, address indexed spender, uint256 value);
1165 }
1166 
1167 
1168 
1169 contract ZooGangStaking is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1170     using EnumerableSet for EnumerableSet.UintSet; 
1171     
1172     address public stackable;
1173     address public erc20Address;
1174 
1175     //uint256's 
1176     uint256 public expiration; 
1177     //rate governs how often you receive your token
1178     uint256 public rate; 
1179   
1180     // mappings 
1181     mapping(address => EnumerableSet.UintSet) private _deposits;
1182     mapping(address => mapping(uint256 => uint256)) public _depositBlocks;
1183 
1184     constructor(
1185       address _stackable,
1186       uint256 _rate,
1187       uint256 _expiration,
1188       address _erc20Address
1189     ) {
1190         stackable = _stackable;
1191         rate = _rate;
1192         expiration = block.number + _expiration;
1193         erc20Address = _erc20Address;
1194         _pause();
1195     }
1196 
1197     function pause() public onlyOwner {
1198         _pause();
1199     }
1200 
1201     function unpause() public onlyOwner {
1202         _unpause();
1203     }
1204 
1205 /* STAKING MECHANICS */
1206 
1207     function setStackable(address _stackable) external onlyOwner {
1208         stackable = _stackable;
1209     }
1210 
1211     // Set a multiplier for how many tokens to earn each time a block passes.
1212     function setRate(uint256 _rate) external onlyOwner {
1213         rate = _rate;
1214     }
1215 
1216     // Set this to a block to disable the ability to continue accruing tokens past that block number.
1217     function setExpiration(uint256 _expiration) external onlyOwner {
1218         expiration = block.number + _expiration;
1219     }
1220 
1221     //check deposit amount. 
1222     function depositsOf(address account) public view returns (uint256[] memory) {
1223       EnumerableSet.UintSet storage depositSet = _deposits[account];
1224       uint256[] memory tokenIds = new uint256[] (depositSet.length());
1225 
1226       for (uint256 i; i < depositSet.length(); i++) {
1227         tokenIds[i] = depositSet.at(i);
1228       }
1229 
1230       return tokenIds;
1231     }
1232 
1233     function calculateRewards(address account, uint256[] memory tokenIds) external view returns (uint256[] memory rewards) {
1234       rewards = new uint256[](tokenIds.length);
1235 
1236       for (uint256 i; i < tokenIds.length; i++) {
1237         uint256 tokenId = tokenIds[i];
1238 
1239         rewards[i] = 
1240           rate * 
1241           (_deposits[account].contains(tokenId) ? 1 : 0) * 
1242           (Math.min(block.number, expiration) - 
1243             _depositBlocks[account][tokenId]);
1244       }
1245 
1246       return rewards;
1247     }
1248 
1249     function calculateRewards(address account) external view returns (uint256[] memory rewards) {
1250       uint256[] memory tokenIds = depositsOf(account);
1251       rewards = new uint256[](tokenIds.length);
1252 
1253       for (uint256 i; i < tokenIds.length; i++) {
1254         uint256 tokenId = tokenIds[i];
1255 
1256         rewards[i] = 
1257           rate * 
1258           (_deposits[account].contains(tokenId) ? 1 : 0) * 
1259           (Math.min(block.number, expiration) - 
1260             _depositBlocks[account][tokenId]);
1261       }
1262 
1263       return rewards;
1264     }
1265 
1266 
1267     //reward amount by address/tokenIds[]
1268     function calculateReward(address account, uint256 tokenId) internal view returns (uint256) {
1269       require(Math.min(block.number, expiration) > _depositBlocks[account][tokenId], "Invalid blocks");
1270       return rate * 
1271           (_deposits[account].contains(tokenId) ? 1 : 0) * 
1272           (Math.min(block.number, expiration) - 
1273             _depositBlocks[account][tokenId]);
1274     }
1275 
1276     //reward claim function 
1277     function claimRewards(uint256[] calldata tokenIds) public whenNotPaused {
1278       uint256 reward; 
1279       uint256 blockCur = Math.min(block.number, expiration);
1280 
1281       for (uint256 i; i < tokenIds.length; i++) {
1282         reward += calculateReward(msg.sender, tokenIds[i]);
1283         _depositBlocks[msg.sender][tokenIds[i]] = blockCur;
1284       }
1285 
1286       if (reward > 0) {
1287         IERC20(erc20Address).transfer(msg.sender, reward);
1288       }
1289     }
1290 
1291     //deposit function. 
1292     function deposit(uint256[] calldata tokenIds) external whenNotPaused {
1293         require(msg.sender != stackable, "Invalid address");
1294         claimRewards(tokenIds);
1295 
1296         for (uint256 i; i < tokenIds.length; i++) {
1297             IERC721(stackable).safeTransferFrom(
1298                 msg.sender,
1299                 address(this),
1300                 tokenIds[i],
1301                 ""
1302             );
1303 
1304             _deposits[msg.sender].add(tokenIds[i]);
1305         }
1306     }
1307 
1308     //withdrawal function.
1309     function withdraw(uint256[] calldata tokenIds) external whenNotPaused nonReentrant {
1310         claimRewards(tokenIds);
1311 
1312         for (uint256 i; i < tokenIds.length; i++) {
1313             require(
1314                 _deposits[msg.sender].contains(tokenIds[i]),
1315                 "Staking: token not deposited"
1316             );
1317 
1318             _deposits[msg.sender].remove(tokenIds[i]);
1319 
1320             IERC721(stackable).safeTransferFrom(
1321                 address(this),
1322                 msg.sender,
1323                 tokenIds[i],
1324                 ""
1325             );
1326         }
1327     }
1328 
1329     //withdrawal function.
1330     function withdrawTokens() external onlyOwner {
1331         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1332         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
1333     }
1334 
1335     function onERC721Received(
1336         address,
1337         address,
1338         uint256,
1339         bytes calldata
1340     ) external pure override returns (bytes4) {
1341         return IERC721Receiver.onERC721Received.selector;
1342     }
1343 
1344     
1345     function getTokensByOwner(address owner) external view returns(uint256[] memory tokens) {
1346         uint256 balance = IERC721(stackable).balanceOf(owner);
1347 
1348         if (balance > 0) {
1349             tokens = new uint256[](balance);
1350             for (uint256 i = 0; i < balance; i++) {
1351                 tokens[i] = IERC721Enumerable(stackable).tokenOfOwnerByIndex(owner,i);
1352             }
1353         } 
1354 
1355     }
1356 
1357 }