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
47         _setOwner(_msgSender());
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
73         _setOwner(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _setOwner(newOwner);
83     }
84 
85     function _setOwner(address newOwner) private {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 
93 pragma solidity ^0.8.0;
94 
95 // CAUTION
96 // This version of SafeMath should only be used with Solidity 0.8 or later,
97 // because it relies on the compiler's built in overflow checks.
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations.
101  *
102  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
103  * now has built in overflow checking.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, with an overflow flag.
108      *
109      * _Available since v3.4._
110      */
111     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             uint256 c = a + b;
114             if (c < a) return (false, 0);
115             return (true, c);
116         }
117     }
118 
119     /**
120      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             if (b > a) return (false, 0);
127             return (true, a - b);
128         }
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139             // benefit is lost if 'b' is also tested.
140             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
141             if (a == 0) return (true, 0);
142             uint256 c = a * b;
143             if (c / a != b) return (false, 0);
144             return (true, c);
145         }
146     }
147 
148     /**
149      * @dev Returns the division of two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b == 0) return (false, 0);
156             return (true, a / b);
157         }
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             if (b == 0) return (false, 0);
168             return (true, a % b);
169         }
170     }
171 
172     /**
173      * @dev Returns the addition of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `+` operator.
177      *
178      * Requirements:
179      *
180      * - Addition cannot overflow.
181      */
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a + b;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a * b;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers, reverting on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator.
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a / b;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a % b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {trySub}.
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b <= a, errorMessage);
264             return a - b;
265         }
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         unchecked {
286             require(b > 0, errorMessage);
287             return a / b;
288         }
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * reverting with custom message when dividing by zero.
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {tryMod}.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function mod(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b > 0, errorMessage);
313             return a % b;
314         }
315     }
316 }
317 
318 
319 pragma solidity ^0.8.0;
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
344  * @dev Required interface of an ERC721 compliant contract.
345  */
346 interface IERC721 is IERC165 {
347     /**
348      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
354      */
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
359      */
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     /**
363      * @dev Returns the number of tokens in ``owner``'s account.
364      */
365     function balanceOf(address owner) external view returns (uint256 balance);
366 
367     /**
368      * @dev Returns the owner of the `tokenId` token.
369      *
370      * Requirements:
371      *
372      * - `tokenId` must exist.
373      */
374     function ownerOf(uint256 tokenId) external view returns (address owner);
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Returns the account approved for `tokenId` token.
433      *
434      * Requirements:
435      *
436      * - `tokenId` must exist.
437      */
438     function getApproved(uint256 tokenId) external view returns (address operator);
439 
440     /**
441      * @dev Approve or remove `operator` as an operator for the caller.
442      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The `operator` cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId,
476         bytes calldata data
477     ) external;
478 }
479 
480 
481 /**
482  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
483  * @dev See https://eips.ethereum.org/EIPS/eip-721
484  */
485 interface IERC721Enumerable is IERC721 {
486     /**
487      * @dev Returns the total amount of tokens stored by the contract.
488      */
489     function totalSupply() external view returns (uint256);
490 
491     /**
492      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
493      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
494      */
495     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
496 
497     /**
498      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
499      * Use along with {totalSupply} to enumerate all tokens.
500      */
501     function tokenByIndex(uint256 index) external view returns (uint256);
502 }
503 
504 
505 /**
506  * @title ERC721 token receiver interface
507  * @dev Interface for any contract that wants to support safeTransfers
508  * from ERC721 asset contracts.
509  */
510 interface IERC721Receiver {
511     /**
512      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
513      * by `operator` from `from`, this function is called.
514      *
515      * It must return its Solidity selector to confirm the token transfer.
516      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
517      *
518      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
519      */
520     function onERC721Received(
521         address operator,
522         address from,
523         uint256 tokenId,
524         bytes calldata data
525     ) external returns (bytes4);
526 }
527 
528 
529 /**
530  * @dev Library for managing
531  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
532  * types.
533  *
534  * Sets have the following properties:
535  *
536  * - Elements are added, removed, and checked for existence in constant time
537  * (O(1)).
538  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
539  *
540  * ```
541  * contract Example {
542  *     // Add the library methods
543  *     using EnumerableSet for EnumerableSet.AddressSet;
544  *
545  *     // Declare a set state variable
546  *     EnumerableSet.AddressSet private mySet;
547  * }
548  * ```
549  *
550  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
551  * and `uint256` (`UintSet`) are supported.
552  */
553 library EnumerableSet {
554     // To implement this library for multiple types with as little code
555     // repetition as possible, we write it in terms of a generic Set type with
556     // bytes32 values.
557     // The Set implementation uses private functions, and user-facing
558     // implementations (such as AddressSet) are just wrappers around the
559     // underlying Set.
560     // This means that we can only create new EnumerableSets for types that fit
561     // in bytes32.
562 
563     struct Set {
564         // Storage of set values
565         bytes32[] _values;
566         // Position of the value in the `values` array, plus 1 because index 0
567         // means a value is not in the set.
568         mapping(bytes32 => uint256) _indexes;
569     }
570 
571     /**
572      * @dev Add a value to a set. O(1).
573      *
574      * Returns true if the value was added to the set, that is if it was not
575      * already present.
576      */
577     function _add(Set storage set, bytes32 value) private returns (bool) {
578         if (!_contains(set, value)) {
579             set._values.push(value);
580             // The value is stored at length-1, but we add 1 to all indexes
581             // and use 0 as a sentinel value
582             set._indexes[value] = set._values.length;
583             return true;
584         } else {
585             return false;
586         }
587     }
588 
589     /**
590      * @dev Removes a value from a set. O(1).
591      *
592      * Returns true if the value was removed from the set, that is if it was
593      * present.
594      */
595     function _remove(Set storage set, bytes32 value) private returns (bool) {
596         // We read and store the value's index to prevent multiple reads from the same storage slot
597         uint256 valueIndex = set._indexes[value];
598 
599         if (valueIndex != 0) {
600             // Equivalent to contains(set, value)
601             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
602             // the array, and then remove the last element (sometimes called as 'swap and pop').
603             // This modifies the order of the array, as noted in {at}.
604 
605             uint256 toDeleteIndex = valueIndex - 1;
606             uint256 lastIndex = set._values.length - 1;
607 
608             if (lastIndex != toDeleteIndex) {
609                 bytes32 lastvalue = set._values[lastIndex];
610 
611                 // Move the last value to the index where the value to delete is
612                 set._values[toDeleteIndex] = lastvalue;
613                 // Update the index for the moved value
614                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
615             }
616 
617             // Delete the slot where the moved value was stored
618             set._values.pop();
619 
620             // Delete the index for the deleted slot
621             delete set._indexes[value];
622 
623             return true;
624         } else {
625             return false;
626         }
627     }
628 
629     /**
630      * @dev Returns true if the value is in the set. O(1).
631      */
632     function _contains(Set storage set, bytes32 value) private view returns (bool) {
633         return set._indexes[value] != 0;
634     }
635 
636     /**
637      * @dev Returns the number of values on the set. O(1).
638      */
639     function _length(Set storage set) private view returns (uint256) {
640         return set._values.length;
641     }
642 
643     /**
644      * @dev Returns the value stored at position `index` in the set. O(1).
645      *
646      * Note that there are no guarantees on the ordering of values inside the
647      * array, and it may change when more values are added or removed.
648      *
649      * Requirements:
650      *
651      * - `index` must be strictly less than {length}.
652      */
653     function _at(Set storage set, uint256 index) private view returns (bytes32) {
654         return set._values[index];
655     }
656 
657     /**
658      * @dev Return the entire set in an array
659      *
660      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
661      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
662      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
663      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
664      */
665     function _values(Set storage set) private view returns (bytes32[] memory) {
666         return set._values;
667     }
668 
669     // Bytes32Set
670 
671     struct Bytes32Set {
672         Set _inner;
673     }
674 
675     /**
676      * @dev Add a value to a set. O(1).
677      *
678      * Returns true if the value was added to the set, that is if it was not
679      * already present.
680      */
681     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
682         return _add(set._inner, value);
683     }
684 
685     /**
686      * @dev Removes a value from a set. O(1).
687      *
688      * Returns true if the value was removed from the set, that is if it was
689      * present.
690      */
691     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
692         return _remove(set._inner, value);
693     }
694 
695     /**
696      * @dev Returns true if the value is in the set. O(1).
697      */
698     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
699         return _contains(set._inner, value);
700     }
701 
702     /**
703      * @dev Returns the number of values in the set. O(1).
704      */
705     function length(Bytes32Set storage set) internal view returns (uint256) {
706         return _length(set._inner);
707     }
708 
709     /**
710      * @dev Returns the value stored at position `index` in the set. O(1).
711      *
712      * Note that there are no guarantees on the ordering of values inside the
713      * array, and it may change when more values are added or removed.
714      *
715      * Requirements:
716      *
717      * - `index` must be strictly less than {length}.
718      */
719     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
720         return _at(set._inner, index);
721     }
722 
723     /**
724      * @dev Return the entire set in an array
725      *
726      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
727      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
728      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
729      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
730      */
731     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
732         return _values(set._inner);
733     }
734 
735     // AddressSet
736 
737     struct AddressSet {
738         Set _inner;
739     }
740 
741     /**
742      * @dev Add a value to a set. O(1).
743      *
744      * Returns true if the value was added to the set, that is if it was not
745      * already present.
746      */
747     function add(AddressSet storage set, address value) internal returns (bool) {
748         return _add(set._inner, bytes32(uint256(uint160(value))));
749     }
750 
751     /**
752      * @dev Removes a value from a set. O(1).
753      *
754      * Returns true if the value was removed from the set, that is if it was
755      * present.
756      */
757     function remove(AddressSet storage set, address value) internal returns (bool) {
758         return _remove(set._inner, bytes32(uint256(uint160(value))));
759     }
760 
761     /**
762      * @dev Returns true if the value is in the set. O(1).
763      */
764     function contains(AddressSet storage set, address value) internal view returns (bool) {
765         return _contains(set._inner, bytes32(uint256(uint160(value))));
766     }
767 
768     /**
769      * @dev Returns the number of values in the set. O(1).
770      */
771     function length(AddressSet storage set) internal view returns (uint256) {
772         return _length(set._inner);
773     }
774 
775     /**
776      * @dev Returns the value stored at position `index` in the set. O(1).
777      *
778      * Note that there are no guarantees on the ordering of values inside the
779      * array, and it may change when more values are added or removed.
780      *
781      * Requirements:
782      *
783      * - `index` must be strictly less than {length}.
784      */
785     function at(AddressSet storage set, uint256 index) internal view returns (address) {
786         return address(uint160(uint256(_at(set._inner, index))));
787     }
788 
789     /**
790      * @dev Return the entire set in an array
791      *
792      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
793      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
794      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
795      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
796      */
797     function values(AddressSet storage set) internal view returns (address[] memory) {
798         bytes32[] memory store = _values(set._inner);
799         address[] memory result;
800 
801         assembly {
802             result := store
803         }
804 
805         return result;
806     }
807 
808     // UintSet
809 
810     struct UintSet {
811         Set _inner;
812     }
813 
814     /**
815      * @dev Add a value to a set. O(1).
816      *
817      * Returns true if the value was added to the set, that is if it was not
818      * already present.
819      */
820     function add(UintSet storage set, uint256 value) internal returns (bool) {
821         return _add(set._inner, bytes32(value));
822     }
823 
824     /**
825      * @dev Removes a value from a set. O(1).
826      *
827      * Returns true if the value was removed from the set, that is if it was
828      * present.
829      */
830     function remove(UintSet storage set, uint256 value) internal returns (bool) {
831         return _remove(set._inner, bytes32(value));
832     }
833 
834     /**
835      * @dev Returns true if the value is in the set. O(1).
836      */
837     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
838         return _contains(set._inner, bytes32(value));
839     }
840 
841     /**
842      * @dev Returns the number of values on the set. O(1).
843      */
844     function length(UintSet storage set) internal view returns (uint256) {
845         return _length(set._inner);
846     }
847 
848     /**
849      * @dev Returns the value stored at position `index` in the set. O(1).
850      *
851      * Note that there are no guarantees on the ordering of values inside the
852      * array, and it may change when more values are added or removed.
853      *
854      * Requirements:
855      *
856      * - `index` must be strictly less than {length}.
857      */
858     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
859         return uint256(_at(set._inner, index));
860     }
861 
862     /**
863      * @dev Return the entire set in an array
864      *
865      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
866      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
867      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
868      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
869      */
870     function values(UintSet storage set) internal view returns (uint256[] memory) {
871         bytes32[] memory store = _values(set._inner);
872         uint256[] memory result;
873 
874         assembly {
875             result := store
876         }
877 
878         return result;
879     }
880 }
881 
882 
883 /**
884  * @dev Contract module that helps prevent reentrant calls to a function.
885  *
886  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
887  * available, which can be applied to functions to make sure there are no nested
888  * (reentrant) calls to them.
889  *
890  * Note that because there is a single `nonReentrant` guard, functions marked as
891  * `nonReentrant` may not call one another. This can be worked around by making
892  * those functions `private`, and then adding `external` `nonReentrant` entry
893  * points to them.
894  *
895  * TIP: If you would like to learn more about reentrancy and alternative ways
896  * to protect against it, check out our blog post
897  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
898  */
899 abstract contract ReentrancyGuard {
900     // Booleans are more expensive than uint256 or any type that takes up a full
901     // word because each write operation emits an extra SLOAD to first read the
902     // slot's contents, replace the bits taken up by the boolean, and then write
903     // back. This is the compiler's defense against contract upgrades and
904     // pointer aliasing, and it cannot be disabled.
905 
906     // The values being non-zero value makes deployment a bit more expensive,
907     // but in exchange the refund on every call to nonReentrant will be lower in
908     // amount. Since refunds are capped to a percentage of the total
909     // transaction's gas, it is best to keep them low in cases like this one, to
910     // increase the likelihood of the full refund coming into effect.
911     uint256 private constant _NOT_ENTERED = 1;
912     uint256 private constant _ENTERED = 2;
913 
914     uint256 private _status;
915 
916     constructor() {
917         _status = _NOT_ENTERED;
918     }
919 
920     /**
921      * @dev Prevents a contract from calling itself, directly or indirectly.
922      * Calling a `nonReentrant` function from another `nonReentrant`
923      * function is not supported. It is possible to prevent this from happening
924      * by making the `nonReentrant` function external, and make it call a
925      * `private` function that does the actual work.
926      */
927     modifier nonReentrant() {
928         // On the first call to nonReentrant, _notEntered will be true
929         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
930 
931         // Any calls to nonReentrant after this point will fail
932         _status = _ENTERED;
933 
934         _;
935 
936         // By storing the original value once again, a refund is triggered (see
937         // https://eips.ethereum.org/EIPS/eip-2200)
938         _status = _NOT_ENTERED;
939     }
940 }
941 
942 
943 /**
944  * @dev Standard math utilities missing in the Solidity language.
945  */
946 library Math {
947     /**
948      * @dev Returns the largest of two numbers.
949      */
950     function max(uint256 a, uint256 b) internal pure returns (uint256) {
951         return a >= b ? a : b;
952     }
953 
954     /**
955      * @dev Returns the smallest of two numbers.
956      */
957     function min(uint256 a, uint256 b) internal pure returns (uint256) {
958         return a < b ? a : b;
959     }
960 
961     /**
962      * @dev Returns the average of two numbers. The result is rounded towards
963      * zero.
964      */
965     function average(uint256 a, uint256 b) internal pure returns (uint256) {
966         // (a + b) / 2 can overflow.
967         return (a & b) + (a ^ b) / 2;
968     }
969 
970     /**
971      * @dev Returns the ceiling of the division of two numbers.
972      *
973      * This differs from standard division with `/` in that it rounds up instead
974      * of rounding down.
975      */
976     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
977         // (a + b - 1) / b can overflow on addition, so we distribute.
978         return a / b + (a % b == 0 ? 0 : 1);
979     }
980 }
981 
982 
983 /**
984  * @dev Contract module which allows children to implement an emergency stop
985  * mechanism that can be triggered by an authorized account.
986  *
987  * This module is used through inheritance. It will make available the
988  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
989  * the functions of your contract. Note that they will not be pausable by
990  * simply including this module, only once the modifiers are put in place.
991  */
992 abstract contract Pausable is Context {
993     /**
994      * @dev Emitted when the pause is triggered by `account`.
995      */
996     event Paused(address account);
997 
998     /**
999      * @dev Emitted when the pause is lifted by `account`.
1000      */
1001     event Unpaused(address account);
1002 
1003     bool private _paused;
1004 
1005     /**
1006      * @dev Initializes the contract in unpaused state.
1007      */
1008     constructor() {
1009         _paused = false;
1010     }
1011 
1012     /**
1013      * @dev Returns true if the contract is paused, and false otherwise.
1014      */
1015     function paused() public view virtual returns (bool) {
1016         return _paused;
1017     }
1018 
1019     /**
1020      * @dev Modifier to make a function callable only when the contract is not paused.
1021      *
1022      * Requirements:
1023      *
1024      * - The contract must not be paused.
1025      */
1026     modifier whenNotPaused() {
1027         require(!paused(), "Pausable: paused");
1028         _;
1029     }
1030 
1031     /**
1032      * @dev Modifier to make a function callable only when the contract is paused.
1033      *
1034      * Requirements:
1035      *
1036      * - The contract must be paused.
1037      */
1038     modifier whenPaused() {
1039         require(paused(), "Pausable: not paused");
1040         _;
1041     }
1042 
1043     /**
1044      * @dev Triggers stopped state.
1045      *
1046      * Requirements:
1047      *
1048      * - The contract must not be paused.
1049      */
1050     function _pause() internal virtual whenNotPaused {
1051         _paused = true;
1052         emit Paused(_msgSender());
1053     }
1054 
1055     /**
1056      * @dev Returns to normal state.
1057      *
1058      * Requirements:
1059      *
1060      * - The contract must be paused.
1061      */
1062     function _unpause() internal virtual whenPaused {
1063         _paused = false;
1064         emit Unpaused(_msgSender());
1065     }
1066 }
1067 
1068 
1069 /**
1070  * @dev Interface of the ERC20 standard as defined in the EIP.
1071  */
1072 interface IERC20 {
1073     /**
1074      * @dev Returns the amount of tokens in existence.
1075      */
1076     function totalSupply() external view returns (uint256);
1077 
1078     /**
1079      * @dev Returns the amount of tokens owned by `account`.
1080      */
1081     function balanceOf(address account) external view returns (uint256);
1082 
1083     /**
1084      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1085      *
1086      * Returns a boolean value indicating whether the operation succeeded.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function transfer(address recipient, uint256 amount) external returns (bool);
1091 
1092     /**
1093      * @dev Returns the remaining number of tokens that `spender` will be
1094      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1095      * zero by default.
1096      *
1097      * This value changes when {approve} or {transferFrom} are called.
1098      */
1099     function allowance(address owner, address spender) external view returns (uint256);
1100 
1101     /**
1102      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1103      *
1104      * Returns a boolean value indicating whether the operation succeeded.
1105      *
1106      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1107      * that someone may use both the old and the new allowance by unfortunate
1108      * transaction ordering. One possible solution to mitigate this race
1109      * condition is to first reduce the spender's allowance to 0 and set the
1110      * desired value afterwards:
1111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1112      *
1113      * Emits an {Approval} event.
1114      */
1115     function approve(address spender, uint256 amount) external returns (bool);
1116 
1117     /**
1118      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1119      * allowance mechanism. `amount` is then deducted from the caller's
1120      * allowance.
1121      *
1122      * Returns a boolean value indicating whether the operation succeeded.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function transferFrom(
1127         address sender,
1128         address recipient,
1129         uint256 amount
1130     ) external returns (bool);
1131 
1132     /**
1133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1134      * another (`to`).
1135      *
1136      * Note that `value` may be zero.
1137      */
1138     event Transfer(address indexed from, address indexed to, uint256 value);
1139 
1140     /**
1141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1142      * a call to {approve}. `value` is the new allowance.
1143      */
1144     event Approval(address indexed owner, address indexed spender, uint256 value);
1145 }
1146 
1147 /**
1148  * @dev String operations.
1149  */
1150 library Strings {
1151     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1152 
1153     /**
1154      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1155      */
1156     function toString(uint256 value) internal pure returns (string memory) {
1157         // Inspired by OraclizeAPI's implementation - MIT licence
1158         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1159 
1160         if (value == 0) {
1161             return "0";
1162         }
1163         uint256 temp = value;
1164         uint256 digits;
1165         while (temp != 0) {
1166             digits++;
1167             temp /= 10;
1168         }
1169         bytes memory buffer = new bytes(digits);
1170         while (value != 0) {
1171             digits -= 1;
1172             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1173             value /= 10;
1174         }
1175         return string(buffer);
1176     }
1177 
1178     /**
1179      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1180      */
1181     function toHexString(uint256 value) internal pure returns (string memory) {
1182         if (value == 0) {
1183             return "0x00";
1184         }
1185         uint256 temp = value;
1186         uint256 length = 0;
1187         while (temp != 0) {
1188             length++;
1189             temp >>= 8;
1190         }
1191         return toHexString(value, length);
1192     }
1193 
1194     /**
1195      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1196      */
1197     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1198         bytes memory buffer = new bytes(2 * length + 2);
1199         buffer[0] = "0";
1200         buffer[1] = "x";
1201         for (uint256 i = 2 * length + 1; i > 1; --i) {
1202             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1203             value >>= 4;
1204         }
1205         require(value == 0, "Strings: hex length insufficient");
1206         return string(buffer);
1207     }
1208 }
1209 
1210 
1211 /**
1212  * @dev These functions deal with verification of Merkle Trees proofs.
1213  *
1214  * The proofs can be generated using the JavaScript library
1215  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1216  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1217  *
1218  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1219  *
1220  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1221  * hashing, or use a hash function other than keccak256 for hashing leaves.
1222  * This is because the concatenation of a sorted pair of internal nodes in
1223  * the merkle tree could be reinterpreted as a leaf value.
1224  */
1225 library MerkleProof {
1226     /**
1227      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1228      * defined by `root`. For this, a `proof` must be provided, containing
1229      * sibling hashes on the branch from the leaf to the root of the tree. Each
1230      * pair of leaves and each pair of pre-images are assumed to be sorted.
1231      */
1232     function verify(
1233         bytes32[] memory proof,
1234         bytes32 root,
1235         bytes32 leaf
1236     ) internal pure returns (bool) {
1237         return processProof(proof, leaf) == root;
1238     }
1239 
1240     /**
1241      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1242      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1243      * hash matches the root of the tree. When processing the proof, the pairs
1244      * of leafs & pre-images are assumed to be sorted.
1245      *
1246      * _Available since v4.4._
1247      */
1248     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1249         bytes32 computedHash = leaf;
1250         for (uint256 i = 0; i < proof.length; i++) {
1251             bytes32 proofElement = proof[i];
1252             if (computedHash <= proofElement) {
1253                 // Hash(current computed hash + current element of the proof)
1254                 computedHash = _efficientHash(computedHash, proofElement);
1255             } else {
1256                 // Hash(current element of the proof + current computed hash)
1257                 computedHash = _efficientHash(proofElement, computedHash);
1258             }
1259         }
1260         return computedHash;
1261     }
1262 
1263     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1264         assembly {
1265             mstore(0x00, a)
1266             mstore(0x20, b)
1267             value := keccak256(0x00, 0x40)
1268         }
1269     }
1270 }
1271 
1272 contract LostStaking is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1273     using EnumerableSet for EnumerableSet.UintSet; 
1274     
1275     //addresses 
1276     address public stakingDestinationAddress;
1277     address public stakingLostGirlAddr;
1278     address public erc20Address;
1279     address public ownerAddr;
1280 
1281     bytes32 private merkleRoot1;
1282     bytes32 private merkleRoot2;
1283     bytes32 private merkleRoot3;
1284     bytes32 private merkleRoot4;
1285 
1286     //uint256's 
1287     uint256 public expiration;
1288   
1289     // mappings 
1290     mapping(address => EnumerableSet.UintSet) _deposits;
1291     mapping(address => mapping(uint256 => uint256)) _depositBlocks;
1292     mapping(address => mapping(uint256 => uint256)) _depositRarity;
1293     mapping(uint256 => uint256) _rewardArray;
1294     mapping(uint256 => uint256) _rewardRarity;
1295 
1296     struct markelData{
1297         bytes32[] merkleProof;
1298         uint256 _indexNum;
1299     }
1300 
1301     constructor(
1302       address _stakingDestinationAddress, // NFT Contract Address
1303       address _stakingLostGirlAddress, //NFT Contract lostgirl
1304       uint256 _expiration,  //in days
1305       address _erc20Address, // Token address
1306       uint256[] memory rewardArray,
1307       uint256[] memory rewardRarity
1308     ) {
1309         stakingLostGirlAddr = _stakingLostGirlAddress;
1310         stakingDestinationAddress = _stakingDestinationAddress;
1311         expiration = block.timestamp + (_expiration * 1 days);
1312         erc20Address = _erc20Address;
1313         ownerAddr = msg.sender;
1314         
1315         for (uint256 i; i < rewardArray.length; i++) {
1316             _rewardArray[i] = rewardArray[i];
1317         }
1318 
1319         for (uint256 i; i < rewardRarity.length; i++) {
1320             _rewardRarity[i] = rewardRarity[i];
1321         }
1322         
1323         _pause();
1324     }
1325     
1326 
1327     modifier isExpired() {
1328         require(0 < ((expiration - block.timestamp) / 60 ), "Close Staking");
1329         _;
1330     }
1331 
1332     function pause() external onlyOwner {
1333         _pause();
1334     }
1335 
1336     function unpause() external onlyOwner {
1337         _unpause();
1338     }
1339 
1340     function updateMarkelTree(bytes32 _merkleRoot1, bytes32 _merkleRoot2, bytes32 _merkleRoot3, bytes32 _merkleRoot4) external onlyOwner(){
1341         merkleRoot1 = _merkleRoot1;
1342         merkleRoot2 = _merkleRoot2;
1343         merkleRoot3 = _merkleRoot3;
1344         merkleRoot4 = _merkleRoot4;
1345     }
1346 
1347     /* STAKING MECHANICS */
1348 
1349     // Set a multiplier for how many to0x3E6DEab9Cb952b29FcDCC2f4F88bE8E1858B50Bckens to earn each time a block passes.
1350     function updateReward(uint256[] memory _updateReward) external onlyOwner() {
1351         for (uint256 i; i < _updateReward.length; i++) {
1352             _rewardArray[i] = _updateReward[i];
1353         }
1354     }
1355 
1356     // Set a multiplier for how many tokens to earn each time a block passes.
1357     function updateRarity(uint256[] memory _updateRarity) external onlyOwner() {
1358         for (uint256 i; i < _updateRarity.length; i++) {
1359             _rewardRarity[i] = _updateRarity[i];
1360         }
1361     }
1362 
1363     // Set this to a block to disable the ability to continue accruing tokens past that block number.
1364     function setExpiration(uint256 _expiration) external onlyOwner() {
1365         expiration = expiration + (_expiration * 1 days);
1366     }
1367 
1368     //check Lostboy Balance. 
1369     function balanceOfLostGirl(address account, uint256 tokens) external view returns (uint256 balance) {
1370         uint256 balanceOfd = IERC721(stakingLostGirlAddr).balanceOf(account);
1371         
1372         if(balanceOfd > 0 && balanceOfd <= 3){
1373             return (tokens*_rewardArray[0]);
1374         }else if(balanceOfd >= 4 && balanceOfd <= 6){
1375             return (tokens*_rewardArray[1]);
1376         }else if(balanceOfd >= 7 && balanceOfd <= 9){
1377             return (tokens*_rewardArray[2]);
1378         }else if(balanceOfd >= 10 && balanceOfd <= 15){
1379             return (tokens*_rewardArray[3]);
1380         }else if(balanceOfd > 15){
1381             return (tokens*_rewardArray[4]);
1382         }
1383         return (tokens*100);
1384     }
1385 
1386     //check deposit amount. 
1387     function depositsOf(address account) external view returns (uint256[] memory) {
1388       EnumerableSet.UintSet storage depositSet = _deposits[account];
1389       uint256[] memory tokenIds = new uint256[] (depositSet.length());
1390 
1391       for (uint256 i; i < depositSet.length(); i++) {
1392         tokenIds[i] = depositSet.at(i);
1393       }
1394       return tokenIds;
1395     }
1396 
1397     function calculateRewards(address account, uint256[] memory tokenIds) external view returns (uint256[] memory rewards) 
1398     {
1399       rewards = new uint256[](tokenIds.length);
1400 
1401       for (uint256 i; i < tokenIds.length; i++) {
1402 
1403             uint256 tokenId = tokenIds[i];
1404         
1405             if(_deposits[account].contains(tokenId)){
1406                 uint256 diff = (block.timestamp - _depositBlocks[account][tokenId]) / 60 / 60 / 24;
1407                 uint256 tokenCount = _rewardRarity[_depositRarity[account][tokenId]] * diff;
1408                 rewards[i] = this.balanceOfLostGirl(account, tokenCount);
1409             }else{
1410                 rewards[i] = 0;
1411             }
1412       }
1413 
1414       return rewards;
1415     }
1416 
1417     //reward amount by address/tokenIds[]
1418     function calculateReward(address account, uint256 tokenId) public view isExpired returns (uint256) {
1419         uint256 diff = (block.timestamp - _depositBlocks[account][tokenId]) / 60 / 60 / 24;
1420         uint256 totalToken = (_rewardRarity[_depositRarity[account][tokenId]] * ((_deposits[account].contains(tokenId) ? 1 : 0) * diff));
1421         return this.balanceOfLostGirl(account, totalToken);
1422     }
1423 
1424     //reward claim function 
1425     function claimRewards(uint256[] calldata tokenIds) public whenNotPaused {
1426         uint256 reward; 
1427         uint256 blockCur = block.timestamp;
1428 
1429         for (uint256 i; i < tokenIds.length; i++) {
1430             reward += calculateReward(msg.sender, tokenIds[i]);
1431 
1432             _depositBlocks[msg.sender][tokenIds[i]] = blockCur;
1433         }
1434         
1435         if (reward > 0) {
1436             IERC20(erc20Address).transferFrom(ownerAddr, msg.sender, (((reward * 10**18)/100)/100));
1437         } 
1438     } 
1439 
1440     function deposit(markelData[] memory _markelData) public {
1441         
1442         for (uint256 i; i < _markelData.length; i++) {
1443 
1444             string memory indexNum = Strings.toString(_markelData[i]._indexNum);
1445 
1446             bool matchSuccess = false;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
1447             uint256 _rarityValue = 0; 
1448 
1449             if(MerkleProof.verify(_markelData[i].merkleProof, merkleRoot1, keccak256(abi.encodePacked(indexNum)))){
1450                 _rarityValue = 0;
1451             }else if(MerkleProof.verify(_markelData[i].merkleProof, merkleRoot2, keccak256(abi.encodePacked(indexNum)))){
1452                 _rarityValue = 1;
1453             }else if(MerkleProof.verify(_markelData[i].merkleProof, merkleRoot3, keccak256(abi.encodePacked(indexNum)))){
1454                 _rarityValue = 2;
1455             }else if(MerkleProof.verify(_markelData[i].merkleProof, merkleRoot4, keccak256(abi.encodePacked(indexNum)))){
1456                 _rarityValue = 3;
1457             }else{
1458                 require(matchSuccess, "Invalid merkel data");
1459             }
1460 
1461             uint256 blockCur1 = block.timestamp;
1462             _depositBlocks[msg.sender][_markelData[i]._indexNum] = blockCur1;
1463             _depositRarity[msg.sender][_markelData[i]._indexNum] = _rarityValue;
1464             
1465             IERC721(stakingDestinationAddress).safeTransferFrom(
1466                 msg.sender,
1467                 address(this),
1468                 _markelData[i]._indexNum,
1469                 ""
1470             );
1471 
1472             _deposits[msg.sender].add(_markelData[i]._indexNum);
1473 
1474         }
1475     }
1476 
1477     //withdrawal function.
1478     function withdraw(uint256[] calldata tokenIds) external whenNotPaused nonReentrant() {
1479         claimRewards(tokenIds);
1480 
1481         for (uint256 i; i < tokenIds.length; i++) {
1482             require( _deposits[msg.sender].contains(tokenIds[i]), "Staking: token not deposited");
1483         
1484             _deposits[msg.sender].remove(tokenIds[i]);
1485 
1486             IERC721(stakingDestinationAddress).safeTransferFrom(
1487                 address(this),
1488                 msg.sender,
1489                 tokenIds[i],
1490                 ""
1491             );
1492         }
1493     }
1494  
1495     function onERC721Received(
1496         address,
1497         address,
1498         uint256,
1499         bytes calldata
1500     ) external pure override returns (bytes4) {
1501         return IERC721Receiver.onERC721Received.selector;
1502     }
1503 }