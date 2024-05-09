1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title ERC721 token receiver interface
12  * @dev Interface for any contract that wants to support safeTransfers
13  * from ERC721 asset contracts.
14  */
15 interface IERC721Receiver {
16     /**
17      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
18      * by `operator` from `from`, this function is called.
19      *
20      * It must return its Solidity selector to confirm the token transfer.
21      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
22      *
23      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
24      */
25     function onERC721Received(
26         address operator,
27         address from,
28         uint256 tokenId,
29         bytes calldata data
30     ) external returns (bytes4);
31 }
32 
33 
34 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
35 
36 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
37 
38 
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 
61 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
62 
63 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
64 
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
77      */
78     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
82      */
83     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Transfers `tokenId` token from `from` to `to`.
121      *
122      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must be owned by `from`.
129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address from,
135         address to,
136         uint256 tokenId
137     ) external;
138 
139     /**
140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
141      * The approval is cleared when the token is transferred.
142      *
143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
144      *
145      * Requirements:
146      *
147      * - The caller must own the token or be an approved operator.
148      * - `tokenId` must exist.
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Approve or remove `operator` as an operator for the caller.
165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
166      *
167      * Requirements:
168      *
169      * - The `operator` cannot be the caller.
170      *
171      * Emits an {ApprovalForAll} event.
172      */
173     function setApprovalForAll(address operator, bool _approved) external;
174 
175     /**
176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
177      *
178      * See {setApprovalForAll}
179      */
180     function isApprovedForAll(address owner, address operator) external view returns (bool);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 }
202 
203 
204 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
205 
206 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
207 
208 
209 /**
210  * @dev Provides information about the current execution context, including the
211  * sender of the transaction and its data. While these are generally available
212  * via msg.sender and msg.data, they should not be accessed in such a direct
213  * manner, since when dealing with meta-transactions the account sending and
214  * paying for execution may not be the actual sender (as far as an application
215  * is concerned).
216  *
217  * This contract is only required for intermediate, library-like contracts.
218  */
219 abstract contract Context {
220     function _msgSender() internal view virtual returns (address) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes calldata) {
225         return msg.data;
226     }
227 }
228 
229 
230 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
231 
232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 
306 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.5.0
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
309 
310 
311 /**
312  * @dev Library for managing
313  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
314  * types.
315  *
316  * Sets have the following properties:
317  *
318  * - Elements are added, removed, and checked for existence in constant time
319  * (O(1)).
320  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
321  *
322  * ```
323  * contract Example {
324  *     // Add the library methods
325  *     using EnumerableSet for EnumerableSet.AddressSet;
326  *
327  *     // Declare a set state variable
328  *     EnumerableSet.AddressSet private mySet;
329  * }
330  * ```
331  *
332  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
333  * and `uint256` (`UintSet`) are supported.
334  */
335 library EnumerableSet {
336     // To implement this library for multiple types with as little code
337     // repetition as possible, we write it in terms of a generic Set type with
338     // bytes32 values.
339     // The Set implementation uses private functions, and user-facing
340     // implementations (such as AddressSet) are just wrappers around the
341     // underlying Set.
342     // This means that we can only create new EnumerableSets for types that fit
343     // in bytes32.
344 
345     struct Set {
346         // Storage of set values
347         bytes32[] _values;
348         // Position of the value in the `values` array, plus 1 because index 0
349         // means a value is not in the set.
350         mapping(bytes32 => uint256) _indexes;
351     }
352 
353     /**
354      * @dev Add a value to a set. O(1).
355      *
356      * Returns true if the value was added to the set, that is if it was not
357      * already present.
358      */
359     function _add(Set storage set, bytes32 value) private returns (bool) {
360         if (!_contains(set, value)) {
361             set._values.push(value);
362             // The value is stored at length-1, but we add 1 to all indexes
363             // and use 0 as a sentinel value
364             set._indexes[value] = set._values.length;
365             return true;
366         } else {
367             return false;
368         }
369     }
370 
371     /**
372      * @dev Removes a value from a set. O(1).
373      *
374      * Returns true if the value was removed from the set, that is if it was
375      * present.
376      */
377     function _remove(Set storage set, bytes32 value) private returns (bool) {
378         // We read and store the value's index to prevent multiple reads from the same storage slot
379         uint256 valueIndex = set._indexes[value];
380 
381         if (valueIndex != 0) {
382             // Equivalent to contains(set, value)
383             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
384             // the array, and then remove the last element (sometimes called as 'swap and pop').
385             // This modifies the order of the array, as noted in {at}.
386 
387             uint256 toDeleteIndex = valueIndex - 1;
388             uint256 lastIndex = set._values.length - 1;
389 
390             if (lastIndex != toDeleteIndex) {
391                 bytes32 lastvalue = set._values[lastIndex];
392 
393                 // Move the last value to the index where the value to delete is
394                 set._values[toDeleteIndex] = lastvalue;
395                 // Update the index for the moved value
396                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
397             }
398 
399             // Delete the slot where the moved value was stored
400             set._values.pop();
401 
402             // Delete the index for the deleted slot
403             delete set._indexes[value];
404 
405             return true;
406         } else {
407             return false;
408         }
409     }
410 
411     /**
412      * @dev Returns true if the value is in the set. O(1).
413      */
414     function _contains(Set storage set, bytes32 value) private view returns (bool) {
415         return set._indexes[value] != 0;
416     }
417 
418     /**
419      * @dev Returns the number of values on the set. O(1).
420      */
421     function _length(Set storage set) private view returns (uint256) {
422         return set._values.length;
423     }
424 
425     /**
426      * @dev Returns the value stored at position `index` in the set. O(1).
427      *
428      * Note that there are no guarantees on the ordering of values inside the
429      * array, and it may change when more values are added or removed.
430      *
431      * Requirements:
432      *
433      * - `index` must be strictly less than {length}.
434      */
435     function _at(Set storage set, uint256 index) private view returns (bytes32) {
436         return set._values[index];
437     }
438 
439     /**
440      * @dev Return the entire set in an array
441      *
442      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
443      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
444      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
445      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
446      */
447     function _values(Set storage set) private view returns (bytes32[] memory) {
448         return set._values;
449     }
450 
451     // Bytes32Set
452 
453     struct Bytes32Set {
454         Set _inner;
455     }
456 
457     /**
458      * @dev Add a value to a set. O(1).
459      *
460      * Returns true if the value was added to the set, that is if it was not
461      * already present.
462      */
463     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
464         return _add(set._inner, value);
465     }
466 
467     /**
468      * @dev Removes a value from a set. O(1).
469      *
470      * Returns true if the value was removed from the set, that is if it was
471      * present.
472      */
473     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
474         return _remove(set._inner, value);
475     }
476 
477     /**
478      * @dev Returns true if the value is in the set. O(1).
479      */
480     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
481         return _contains(set._inner, value);
482     }
483 
484     /**
485      * @dev Returns the number of values in the set. O(1).
486      */
487     function length(Bytes32Set storage set) internal view returns (uint256) {
488         return _length(set._inner);
489     }
490 
491     /**
492      * @dev Returns the value stored at position `index` in the set. O(1).
493      *
494      * Note that there are no guarantees on the ordering of values inside the
495      * array, and it may change when more values are added or removed.
496      *
497      * Requirements:
498      *
499      * - `index` must be strictly less than {length}.
500      */
501     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
502         return _at(set._inner, index);
503     }
504 
505     /**
506      * @dev Return the entire set in an array
507      *
508      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
509      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
510      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
511      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
512      */
513     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
514         return _values(set._inner);
515     }
516 
517     // AddressSet
518 
519     struct AddressSet {
520         Set _inner;
521     }
522 
523     /**
524      * @dev Add a value to a set. O(1).
525      *
526      * Returns true if the value was added to the set, that is if it was not
527      * already present.
528      */
529     function add(AddressSet storage set, address value) internal returns (bool) {
530         return _add(set._inner, bytes32(uint256(uint160(value))));
531     }
532 
533     /**
534      * @dev Removes a value from a set. O(1).
535      *
536      * Returns true if the value was removed from the set, that is if it was
537      * present.
538      */
539     function remove(AddressSet storage set, address value) internal returns (bool) {
540         return _remove(set._inner, bytes32(uint256(uint160(value))));
541     }
542 
543     /**
544      * @dev Returns true if the value is in the set. O(1).
545      */
546     function contains(AddressSet storage set, address value) internal view returns (bool) {
547         return _contains(set._inner, bytes32(uint256(uint160(value))));
548     }
549 
550     /**
551      * @dev Returns the number of values in the set. O(1).
552      */
553     function length(AddressSet storage set) internal view returns (uint256) {
554         return _length(set._inner);
555     }
556 
557     /**
558      * @dev Returns the value stored at position `index` in the set. O(1).
559      *
560      * Note that there are no guarantees on the ordering of values inside the
561      * array, and it may change when more values are added or removed.
562      *
563      * Requirements:
564      *
565      * - `index` must be strictly less than {length}.
566      */
567     function at(AddressSet storage set, uint256 index) internal view returns (address) {
568         return address(uint160(uint256(_at(set._inner, index))));
569     }
570 
571     /**
572      * @dev Return the entire set in an array
573      *
574      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
575      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
576      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
577      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
578      */
579     function values(AddressSet storage set) internal view returns (address[] memory) {
580         bytes32[] memory store = _values(set._inner);
581         address[] memory result;
582 
583         assembly {
584             result := store
585         }
586 
587         return result;
588     }
589 
590     // UintSet
591 
592     struct UintSet {
593         Set _inner;
594     }
595 
596     /**
597      * @dev Add a value to a set. O(1).
598      *
599      * Returns true if the value was added to the set, that is if it was not
600      * already present.
601      */
602     function add(UintSet storage set, uint256 value) internal returns (bool) {
603         return _add(set._inner, bytes32(value));
604     }
605 
606     /**
607      * @dev Removes a value from a set. O(1).
608      *
609      * Returns true if the value was removed from the set, that is if it was
610      * present.
611      */
612     function remove(UintSet storage set, uint256 value) internal returns (bool) {
613         return _remove(set._inner, bytes32(value));
614     }
615 
616     /**
617      * @dev Returns true if the value is in the set. O(1).
618      */
619     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
620         return _contains(set._inner, bytes32(value));
621     }
622 
623     /**
624      * @dev Returns the number of values on the set. O(1).
625      */
626     function length(UintSet storage set) internal view returns (uint256) {
627         return _length(set._inner);
628     }
629 
630     /**
631      * @dev Returns the value stored at position `index` in the set. O(1).
632      *
633      * Note that there are no guarantees on the ordering of values inside the
634      * array, and it may change when more values are added or removed.
635      *
636      * Requirements:
637      *
638      * - `index` must be strictly less than {length}.
639      */
640     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
641         return uint256(_at(set._inner, index));
642     }
643 
644     /**
645      * @dev Return the entire set in an array
646      *
647      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
648      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
649      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
650      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
651      */
652     function values(UintSet storage set) internal view returns (uint256[] memory) {
653         bytes32[] memory store = _values(set._inner);
654         uint256[] memory result;
655 
656         assembly {
657             result := store
658         }
659 
660         return result;
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/math/Math.sol@v4.5.0
666 
667 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
668 
669 
670 /**
671  * @dev Standard math utilities missing in the Solidity language.
672  */
673 library Math {
674     /**
675      * @dev Returns the largest of two numbers.
676      */
677     function max(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a >= b ? a : b;
679     }
680 
681     /**
682      * @dev Returns the smallest of two numbers.
683      */
684     function min(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a < b ? a : b;
686     }
687 
688     /**
689      * @dev Returns the average of two numbers. The result is rounded towards
690      * zero.
691      */
692     function average(uint256 a, uint256 b) internal pure returns (uint256) {
693         // (a + b) / 2 can overflow.
694         return (a & b) + (a ^ b) / 2;
695     }
696 
697     /**
698      * @dev Returns the ceiling of the division of two numbers.
699      *
700      * This differs from standard division with `/` in that it rounds up instead
701      * of rounding down.
702      */
703     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
704         // (a + b - 1) / b can overflow on addition, so we distribute.
705         return a / b + (a % b == 0 ? 0 : 1);
706     }
707 }
708 
709 
710 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
711 
712 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
713 
714 
715 /**
716  * @dev These functions deal with verification of Merkle Trees proofs.
717  *
718  * The proofs can be generated using the JavaScript library
719  * https://github.com/miguelmota/merkletreejs[merkletreejs].
720  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
721  *
722  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
723  */
724 library MerkleProof {
725     /**
726      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
727      * defined by `root`. For this, a `proof` must be provided, containing
728      * sibling hashes on the branch from the leaf to the root of the tree. Each
729      * pair of leaves and each pair of pre-images are assumed to be sorted.
730      */
731     function verify(
732         bytes32[] memory proof,
733         bytes32 root,
734         bytes32 leaf
735     ) internal pure returns (bool) {
736         return processProof(proof, leaf) == root;
737     }
738 
739     /**
740      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
741      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
742      * hash matches the root of the tree. When processing the proof, the pairs
743      * of leafs & pre-images are assumed to be sorted.
744      *
745      * _Available since v4.4._
746      */
747     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
748         bytes32 computedHash = leaf;
749         for (uint256 i = 0; i < proof.length; i++) {
750             bytes32 proofElement = proof[i];
751             if (computedHash <= proofElement) {
752                 // Hash(current computed hash + current element of the proof)
753                 computedHash = _efficientHash(computedHash, proofElement);
754             } else {
755                 // Hash(current element of the proof + current computed hash)
756                 computedHash = _efficientHash(proofElement, computedHash);
757             }
758         }
759         return computedHash;
760     }
761 
762     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
763         assembly {
764             mstore(0x00, a)
765             mstore(0x20, b)
766             value := keccak256(0x00, 0x40)
767         }
768     }
769 }
770 
771 
772 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
773 
774 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
775 
776 
777 /**
778  * @dev Interface of the ERC20 standard as defined in the EIP.
779  */
780 interface IERC20 {
781     /**
782      * @dev Returns the amount of tokens in existence.
783      */
784     function totalSupply() external view returns (uint256);
785 
786     /**
787      * @dev Returns the amount of tokens owned by `account`.
788      */
789     function balanceOf(address account) external view returns (uint256);
790 
791     /**
792      * @dev Moves `amount` tokens from the caller's account to `to`.
793      *
794      * Returns a boolean value indicating whether the operation succeeded.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transfer(address to, uint256 amount) external returns (bool);
799 
800     /**
801      * @dev Returns the remaining number of tokens that `spender` will be
802      * allowed to spend on behalf of `owner` through {transferFrom}. This is
803      * zero by default.
804      *
805      * This value changes when {approve} or {transferFrom} are called.
806      */
807     function allowance(address owner, address spender) external view returns (uint256);
808 
809     /**
810      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
811      *
812      * Returns a boolean value indicating whether the operation succeeded.
813      *
814      * IMPORTANT: Beware that changing an allowance with this method brings the risk
815      * that someone may use both the old and the new allowance by unfortunate
816      * transaction ordering. One possible solution to mitigate this race
817      * condition is to first reduce the spender's allowance to 0 and set the
818      * desired value afterwards:
819      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
820      *
821      * Emits an {Approval} event.
822      */
823     function approve(address spender, uint256 amount) external returns (bool);
824 
825     /**
826      * @dev Moves `amount` tokens from `from` to `to` using the
827      * allowance mechanism. `amount` is then deducted from the caller's
828      * allowance.
829      *
830      * Returns a boolean value indicating whether the operation succeeded.
831      *
832      * Emits a {Transfer} event.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 amount
838     ) external returns (bool);
839 
840     /**
841      * @dev Emitted when `value` tokens are moved from one account (`from`) to
842      * another (`to`).
843      *
844      * Note that `value` may be zero.
845      */
846     event Transfer(address indexed from, address indexed to, uint256 value);
847 
848     /**
849      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
850      * a call to {approve}. `value` is the new allowance.
851      */
852     event Approval(address indexed owner, address indexed spender, uint256 value);
853 }
854 
855 
856 // File contracts/interfaces/IJungleCoin.sol
857 
858 
859 interface IJungleCoin is IERC20 {
860     function mint(address _account, uint _amount) external;
861     function burn(uint _amount) external;
862 }
863 
864 
865 // File hardhat/console.sol@v2.8.4
866 
867 
868 library console {
869 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
870 
871 	function _sendLogPayload(bytes memory payload) private view {
872 		uint256 payloadLength = payload.length;
873 		address consoleAddress = CONSOLE_ADDRESS;
874 		assembly {
875 			let payloadStart := add(payload, 32)
876 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
877 		}
878 	}
879 
880 	function log() internal view {
881 		_sendLogPayload(abi.encodeWithSignature("log()"));
882 	}
883 
884 	function logInt(int p0) internal view {
885 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
886 	}
887 
888 	function logUint(uint p0) internal view {
889 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
890 	}
891 
892 	function logString(string memory p0) internal view {
893 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
894 	}
895 
896 	function logBool(bool p0) internal view {
897 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
898 	}
899 
900 	function logAddress(address p0) internal view {
901 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
902 	}
903 
904 	function logBytes(bytes memory p0) internal view {
905 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
906 	}
907 
908 	function logBytes1(bytes1 p0) internal view {
909 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
910 	}
911 
912 	function logBytes2(bytes2 p0) internal view {
913 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
914 	}
915 
916 	function logBytes3(bytes3 p0) internal view {
917 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
918 	}
919 
920 	function logBytes4(bytes4 p0) internal view {
921 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
922 	}
923 
924 	function logBytes5(bytes5 p0) internal view {
925 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
926 	}
927 
928 	function logBytes6(bytes6 p0) internal view {
929 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
930 	}
931 
932 	function logBytes7(bytes7 p0) internal view {
933 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
934 	}
935 
936 	function logBytes8(bytes8 p0) internal view {
937 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
938 	}
939 
940 	function logBytes9(bytes9 p0) internal view {
941 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
942 	}
943 
944 	function logBytes10(bytes10 p0) internal view {
945 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
946 	}
947 
948 	function logBytes11(bytes11 p0) internal view {
949 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
950 	}
951 
952 	function logBytes12(bytes12 p0) internal view {
953 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
954 	}
955 
956 	function logBytes13(bytes13 p0) internal view {
957 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
958 	}
959 
960 	function logBytes14(bytes14 p0) internal view {
961 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
962 	}
963 
964 	function logBytes15(bytes15 p0) internal view {
965 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
966 	}
967 
968 	function logBytes16(bytes16 p0) internal view {
969 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
970 	}
971 
972 	function logBytes17(bytes17 p0) internal view {
973 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
974 	}
975 
976 	function logBytes18(bytes18 p0) internal view {
977 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
978 	}
979 
980 	function logBytes19(bytes19 p0) internal view {
981 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
982 	}
983 
984 	function logBytes20(bytes20 p0) internal view {
985 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
986 	}
987 
988 	function logBytes21(bytes21 p0) internal view {
989 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
990 	}
991 
992 	function logBytes22(bytes22 p0) internal view {
993 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
994 	}
995 
996 	function logBytes23(bytes23 p0) internal view {
997 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
998 	}
999 
1000 	function logBytes24(bytes24 p0) internal view {
1001 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1002 	}
1003 
1004 	function logBytes25(bytes25 p0) internal view {
1005 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1006 	}
1007 
1008 	function logBytes26(bytes26 p0) internal view {
1009 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1010 	}
1011 
1012 	function logBytes27(bytes27 p0) internal view {
1013 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1014 	}
1015 
1016 	function logBytes28(bytes28 p0) internal view {
1017 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1018 	}
1019 
1020 	function logBytes29(bytes29 p0) internal view {
1021 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1022 	}
1023 
1024 	function logBytes30(bytes30 p0) internal view {
1025 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1026 	}
1027 
1028 	function logBytes31(bytes31 p0) internal view {
1029 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1030 	}
1031 
1032 	function logBytes32(bytes32 p0) internal view {
1033 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1034 	}
1035 
1036 	function log(uint p0) internal view {
1037 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1038 	}
1039 
1040 	function log(string memory p0) internal view {
1041 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1042 	}
1043 
1044 	function log(bool p0) internal view {
1045 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1046 	}
1047 
1048 	function log(address p0) internal view {
1049 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1050 	}
1051 
1052 	function log(uint p0, uint p1) internal view {
1053 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1054 	}
1055 
1056 	function log(uint p0, string memory p1) internal view {
1057 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1058 	}
1059 
1060 	function log(uint p0, bool p1) internal view {
1061 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1062 	}
1063 
1064 	function log(uint p0, address p1) internal view {
1065 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1066 	}
1067 
1068 	function log(string memory p0, uint p1) internal view {
1069 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1070 	}
1071 
1072 	function log(string memory p0, string memory p1) internal view {
1073 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1074 	}
1075 
1076 	function log(string memory p0, bool p1) internal view {
1077 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1078 	}
1079 
1080 	function log(string memory p0, address p1) internal view {
1081 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1082 	}
1083 
1084 	function log(bool p0, uint p1) internal view {
1085 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1086 	}
1087 
1088 	function log(bool p0, string memory p1) internal view {
1089 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1090 	}
1091 
1092 	function log(bool p0, bool p1) internal view {
1093 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1094 	}
1095 
1096 	function log(bool p0, address p1) internal view {
1097 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1098 	}
1099 
1100 	function log(address p0, uint p1) internal view {
1101 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1102 	}
1103 
1104 	function log(address p0, string memory p1) internal view {
1105 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1106 	}
1107 
1108 	function log(address p0, bool p1) internal view {
1109 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1110 	}
1111 
1112 	function log(address p0, address p1) internal view {
1113 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1114 	}
1115 
1116 	function log(uint p0, uint p1, uint p2) internal view {
1117 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1118 	}
1119 
1120 	function log(uint p0, uint p1, string memory p2) internal view {
1121 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1122 	}
1123 
1124 	function log(uint p0, uint p1, bool p2) internal view {
1125 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1126 	}
1127 
1128 	function log(uint p0, uint p1, address p2) internal view {
1129 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1130 	}
1131 
1132 	function log(uint p0, string memory p1, uint p2) internal view {
1133 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1134 	}
1135 
1136 	function log(uint p0, string memory p1, string memory p2) internal view {
1137 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1138 	}
1139 
1140 	function log(uint p0, string memory p1, bool p2) internal view {
1141 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1142 	}
1143 
1144 	function log(uint p0, string memory p1, address p2) internal view {
1145 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1146 	}
1147 
1148 	function log(uint p0, bool p1, uint p2) internal view {
1149 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1150 	}
1151 
1152 	function log(uint p0, bool p1, string memory p2) internal view {
1153 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1154 	}
1155 
1156 	function log(uint p0, bool p1, bool p2) internal view {
1157 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1158 	}
1159 
1160 	function log(uint p0, bool p1, address p2) internal view {
1161 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1162 	}
1163 
1164 	function log(uint p0, address p1, uint p2) internal view {
1165 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1166 	}
1167 
1168 	function log(uint p0, address p1, string memory p2) internal view {
1169 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1170 	}
1171 
1172 	function log(uint p0, address p1, bool p2) internal view {
1173 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1174 	}
1175 
1176 	function log(uint p0, address p1, address p2) internal view {
1177 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1178 	}
1179 
1180 	function log(string memory p0, uint p1, uint p2) internal view {
1181 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1182 	}
1183 
1184 	function log(string memory p0, uint p1, string memory p2) internal view {
1185 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1186 	}
1187 
1188 	function log(string memory p0, uint p1, bool p2) internal view {
1189 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1190 	}
1191 
1192 	function log(string memory p0, uint p1, address p2) internal view {
1193 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1194 	}
1195 
1196 	function log(string memory p0, string memory p1, uint p2) internal view {
1197 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1198 	}
1199 
1200 	function log(string memory p0, string memory p1, string memory p2) internal view {
1201 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1202 	}
1203 
1204 	function log(string memory p0, string memory p1, bool p2) internal view {
1205 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1206 	}
1207 
1208 	function log(string memory p0, string memory p1, address p2) internal view {
1209 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1210 	}
1211 
1212 	function log(string memory p0, bool p1, uint p2) internal view {
1213 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1214 	}
1215 
1216 	function log(string memory p0, bool p1, string memory p2) internal view {
1217 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1218 	}
1219 
1220 	function log(string memory p0, bool p1, bool p2) internal view {
1221 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1222 	}
1223 
1224 	function log(string memory p0, bool p1, address p2) internal view {
1225 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1226 	}
1227 
1228 	function log(string memory p0, address p1, uint p2) internal view {
1229 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1230 	}
1231 
1232 	function log(string memory p0, address p1, string memory p2) internal view {
1233 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1234 	}
1235 
1236 	function log(string memory p0, address p1, bool p2) internal view {
1237 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1238 	}
1239 
1240 	function log(string memory p0, address p1, address p2) internal view {
1241 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1242 	}
1243 
1244 	function log(bool p0, uint p1, uint p2) internal view {
1245 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1246 	}
1247 
1248 	function log(bool p0, uint p1, string memory p2) internal view {
1249 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1250 	}
1251 
1252 	function log(bool p0, uint p1, bool p2) internal view {
1253 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1254 	}
1255 
1256 	function log(bool p0, uint p1, address p2) internal view {
1257 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1258 	}
1259 
1260 	function log(bool p0, string memory p1, uint p2) internal view {
1261 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1262 	}
1263 
1264 	function log(bool p0, string memory p1, string memory p2) internal view {
1265 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1266 	}
1267 
1268 	function log(bool p0, string memory p1, bool p2) internal view {
1269 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1270 	}
1271 
1272 	function log(bool p0, string memory p1, address p2) internal view {
1273 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1274 	}
1275 
1276 	function log(bool p0, bool p1, uint p2) internal view {
1277 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1278 	}
1279 
1280 	function log(bool p0, bool p1, string memory p2) internal view {
1281 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1282 	}
1283 
1284 	function log(bool p0, bool p1, bool p2) internal view {
1285 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1286 	}
1287 
1288 	function log(bool p0, bool p1, address p2) internal view {
1289 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1290 	}
1291 
1292 	function log(bool p0, address p1, uint p2) internal view {
1293 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1294 	}
1295 
1296 	function log(bool p0, address p1, string memory p2) internal view {
1297 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1298 	}
1299 
1300 	function log(bool p0, address p1, bool p2) internal view {
1301 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1302 	}
1303 
1304 	function log(bool p0, address p1, address p2) internal view {
1305 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1306 	}
1307 
1308 	function log(address p0, uint p1, uint p2) internal view {
1309 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1310 	}
1311 
1312 	function log(address p0, uint p1, string memory p2) internal view {
1313 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1314 	}
1315 
1316 	function log(address p0, uint p1, bool p2) internal view {
1317 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1318 	}
1319 
1320 	function log(address p0, uint p1, address p2) internal view {
1321 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1322 	}
1323 
1324 	function log(address p0, string memory p1, uint p2) internal view {
1325 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1326 	}
1327 
1328 	function log(address p0, string memory p1, string memory p2) internal view {
1329 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1330 	}
1331 
1332 	function log(address p0, string memory p1, bool p2) internal view {
1333 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1334 	}
1335 
1336 	function log(address p0, string memory p1, address p2) internal view {
1337 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1338 	}
1339 
1340 	function log(address p0, bool p1, uint p2) internal view {
1341 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1342 	}
1343 
1344 	function log(address p0, bool p1, string memory p2) internal view {
1345 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1346 	}
1347 
1348 	function log(address p0, bool p1, bool p2) internal view {
1349 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1350 	}
1351 
1352 	function log(address p0, bool p1, address p2) internal view {
1353 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1354 	}
1355 
1356 	function log(address p0, address p1, uint p2) internal view {
1357 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1358 	}
1359 
1360 	function log(address p0, address p1, string memory p2) internal view {
1361 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1362 	}
1363 
1364 	function log(address p0, address p1, bool p2) internal view {
1365 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1366 	}
1367 
1368 	function log(address p0, address p1, address p2) internal view {
1369 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1370 	}
1371 
1372 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1373 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1374 	}
1375 
1376 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1377 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1378 	}
1379 
1380 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1381 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1382 	}
1383 
1384 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1385 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1386 	}
1387 
1388 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1389 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1390 	}
1391 
1392 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1393 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1394 	}
1395 
1396 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1397 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1398 	}
1399 
1400 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1401 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1402 	}
1403 
1404 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1405 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1406 	}
1407 
1408 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1409 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1410 	}
1411 
1412 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1413 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1414 	}
1415 
1416 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1417 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1418 	}
1419 
1420 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1421 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1422 	}
1423 
1424 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1425 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1426 	}
1427 
1428 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1429 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1430 	}
1431 
1432 	function log(uint p0, uint p1, address p2, address p3) internal view {
1433 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1434 	}
1435 
1436 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1437 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1438 	}
1439 
1440 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1441 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1442 	}
1443 
1444 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1445 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1446 	}
1447 
1448 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1449 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1450 	}
1451 
1452 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1453 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1454 	}
1455 
1456 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1457 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1458 	}
1459 
1460 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1461 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1462 	}
1463 
1464 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1465 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1466 	}
1467 
1468 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1469 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1470 	}
1471 
1472 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1473 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1474 	}
1475 
1476 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1477 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1478 	}
1479 
1480 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1481 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1482 	}
1483 
1484 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1485 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1486 	}
1487 
1488 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1489 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1490 	}
1491 
1492 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1493 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1494 	}
1495 
1496 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1497 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1498 	}
1499 
1500 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1501 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1502 	}
1503 
1504 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1505 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1506 	}
1507 
1508 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1509 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1510 	}
1511 
1512 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1513 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1514 	}
1515 
1516 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1517 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1518 	}
1519 
1520 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1521 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1522 	}
1523 
1524 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1525 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1526 	}
1527 
1528 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1529 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1530 	}
1531 
1532 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1533 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1534 	}
1535 
1536 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1537 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1538 	}
1539 
1540 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1541 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1542 	}
1543 
1544 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1545 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1546 	}
1547 
1548 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1549 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1550 	}
1551 
1552 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1553 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1554 	}
1555 
1556 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1557 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1558 	}
1559 
1560 	function log(uint p0, bool p1, address p2, address p3) internal view {
1561 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1562 	}
1563 
1564 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1565 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1566 	}
1567 
1568 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1569 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1570 	}
1571 
1572 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1573 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1574 	}
1575 
1576 	function log(uint p0, address p1, uint p2, address p3) internal view {
1577 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1578 	}
1579 
1580 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1581 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1582 	}
1583 
1584 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1585 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1586 	}
1587 
1588 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1589 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1590 	}
1591 
1592 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1593 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1594 	}
1595 
1596 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1597 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1598 	}
1599 
1600 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1601 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1602 	}
1603 
1604 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1605 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1606 	}
1607 
1608 	function log(uint p0, address p1, bool p2, address p3) internal view {
1609 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1610 	}
1611 
1612 	function log(uint p0, address p1, address p2, uint p3) internal view {
1613 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1614 	}
1615 
1616 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1617 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1618 	}
1619 
1620 	function log(uint p0, address p1, address p2, bool p3) internal view {
1621 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1622 	}
1623 
1624 	function log(uint p0, address p1, address p2, address p3) internal view {
1625 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1626 	}
1627 
1628 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1629 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1630 	}
1631 
1632 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1633 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1634 	}
1635 
1636 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1637 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1638 	}
1639 
1640 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1641 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1642 	}
1643 
1644 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1645 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1646 	}
1647 
1648 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1649 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1650 	}
1651 
1652 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1653 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1654 	}
1655 
1656 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1657 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1658 	}
1659 
1660 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1662 	}
1663 
1664 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1666 	}
1667 
1668 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1670 	}
1671 
1672 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1674 	}
1675 
1676 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1678 	}
1679 
1680 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1682 	}
1683 
1684 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1686 	}
1687 
1688 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1690 	}
1691 
1692 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1694 	}
1695 
1696 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1698 	}
1699 
1700 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1702 	}
1703 
1704 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1706 	}
1707 
1708 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1710 	}
1711 
1712 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1714 	}
1715 
1716 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1718 	}
1719 
1720 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1722 	}
1723 
1724 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1726 	}
1727 
1728 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1730 	}
1731 
1732 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1734 	}
1735 
1736 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1738 	}
1739 
1740 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1742 	}
1743 
1744 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1746 	}
1747 
1748 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1750 	}
1751 
1752 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1754 	}
1755 
1756 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1758 	}
1759 
1760 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1762 	}
1763 
1764 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1766 	}
1767 
1768 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1770 	}
1771 
1772 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1774 	}
1775 
1776 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1778 	}
1779 
1780 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1782 	}
1783 
1784 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1786 	}
1787 
1788 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1790 	}
1791 
1792 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1794 	}
1795 
1796 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1798 	}
1799 
1800 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1802 	}
1803 
1804 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1806 	}
1807 
1808 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1810 	}
1811 
1812 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1814 	}
1815 
1816 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1818 	}
1819 
1820 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1822 	}
1823 
1824 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1826 	}
1827 
1828 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1830 	}
1831 
1832 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1834 	}
1835 
1836 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1838 	}
1839 
1840 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1842 	}
1843 
1844 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1846 	}
1847 
1848 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1850 	}
1851 
1852 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1854 	}
1855 
1856 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1858 	}
1859 
1860 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1862 	}
1863 
1864 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1866 	}
1867 
1868 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1870 	}
1871 
1872 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1874 	}
1875 
1876 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1878 	}
1879 
1880 	function log(string memory p0, address p1, address p2, address p3) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1882 	}
1883 
1884 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1886 	}
1887 
1888 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1890 	}
1891 
1892 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1894 	}
1895 
1896 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1898 	}
1899 
1900 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1902 	}
1903 
1904 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1906 	}
1907 
1908 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1910 	}
1911 
1912 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1914 	}
1915 
1916 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1918 	}
1919 
1920 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1922 	}
1923 
1924 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1926 	}
1927 
1928 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1930 	}
1931 
1932 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1934 	}
1935 
1936 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1938 	}
1939 
1940 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1942 	}
1943 
1944 	function log(bool p0, uint p1, address p2, address p3) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1946 	}
1947 
1948 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1950 	}
1951 
1952 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1954 	}
1955 
1956 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1958 	}
1959 
1960 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1962 	}
1963 
1964 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1966 	}
1967 
1968 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1970 	}
1971 
1972 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1974 	}
1975 
1976 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1978 	}
1979 
1980 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1982 	}
1983 
1984 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1986 	}
1987 
1988 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1990 	}
1991 
1992 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1994 	}
1995 
1996 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1998 	}
1999 
2000 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2002 	}
2003 
2004 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2006 	}
2007 
2008 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2010 	}
2011 
2012 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2014 	}
2015 
2016 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2018 	}
2019 
2020 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2022 	}
2023 
2024 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2026 	}
2027 
2028 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2030 	}
2031 
2032 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2034 	}
2035 
2036 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2038 	}
2039 
2040 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2042 	}
2043 
2044 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2046 	}
2047 
2048 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2050 	}
2051 
2052 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2054 	}
2055 
2056 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2058 	}
2059 
2060 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2062 	}
2063 
2064 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2066 	}
2067 
2068 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2070 	}
2071 
2072 	function log(bool p0, bool p1, address p2, address p3) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2074 	}
2075 
2076 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2078 	}
2079 
2080 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2082 	}
2083 
2084 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2086 	}
2087 
2088 	function log(bool p0, address p1, uint p2, address p3) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2090 	}
2091 
2092 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2094 	}
2095 
2096 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2098 	}
2099 
2100 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2102 	}
2103 
2104 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2106 	}
2107 
2108 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2110 	}
2111 
2112 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2114 	}
2115 
2116 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2118 	}
2119 
2120 	function log(bool p0, address p1, bool p2, address p3) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2122 	}
2123 
2124 	function log(bool p0, address p1, address p2, uint p3) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2126 	}
2127 
2128 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2130 	}
2131 
2132 	function log(bool p0, address p1, address p2, bool p3) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2134 	}
2135 
2136 	function log(bool p0, address p1, address p2, address p3) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2138 	}
2139 
2140 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2142 	}
2143 
2144 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2146 	}
2147 
2148 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2150 	}
2151 
2152 	function log(address p0, uint p1, uint p2, address p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(address p0, uint p1, bool p2, address p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(address p0, uint p1, address p2, uint p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(address p0, uint p1, address p2, bool p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(address p0, uint p1, address p2, address p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(address p0, string memory p1, address p2, address p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(address p0, bool p1, uint p2, address p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(address p0, bool p1, bool p2, address p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(address p0, bool p1, address p2, uint p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(address p0, bool p1, address p2, bool p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(address p0, bool p1, address p2, address p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(address p0, address p1, uint p2, uint p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(address p0, address p1, uint p2, bool p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(address p0, address p1, uint p2, address p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(address p0, address p1, string memory p2, address p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(address p0, address p1, bool p2, uint p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(address p0, address p1, bool p2, bool p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(address p0, address p1, bool p2, address p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(address p0, address p1, address p2, uint p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(address p0, address p1, address p2, string memory p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(address p0, address p1, address p2, bool p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(address p0, address p1, address p2, address p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2394 	}
2395 
2396 }
2397 
2398 
2399 // File contracts/CubStaking.sol
2400 
2401 
2402 
2403 
2404 
2405 
2406 
2407 
2408 
2409 contract CubStaking is IERC721Receiver, Ownable {
2410     using EnumerableSet for EnumerableSet.UintSet;
2411 
2412     address public jungleCoin;
2413     address public royalCubs;
2414     uint256 public expiration; //expiry block number (avg 15s per block)
2415 
2416     mapping(address => EnumerableSet.UintSet) private _deposits;
2417     // user => tokenId => last interacted block
2418     mapping(address => mapping(uint256 => uint256)) public depositBlocks;
2419     // mapping (uint256 => uint256) public tokenRarity;
2420     mapping (uint256 => bytes32) public tokenRarityRoot;
2421     // tokens per day per rarity
2422     uint256[] public rewardRate;   
2423     bool public started;
2424 
2425     constructor(
2426         address _jungleCoin,
2427         address _royalCubs,
2428         uint256 _expiration,
2429         uint256 _baseRewardRate
2430     ) {
2431         jungleCoin = _jungleCoin;
2432         royalCubs = _royalCubs;
2433         expiration = block.number + _expiration;
2434         // number of tokens Per day
2435         rewardRate.push(_baseRewardRate);
2436         started = false;
2437     }
2438 
2439     function setRate(uint256 _rarity, uint256 _rate) public onlyOwner() {
2440         require(_rarity <= rewardRate.length, "Cannot skip");
2441         if (_rarity == rewardRate.length) {
2442             rewardRate.push(_rate);
2443         } else {
2444             rewardRate[_rarity] = _rate;
2445         }
2446     }
2447 
2448     function setRarityRoot(uint256 _rarity, bytes32 _root) public onlyOwner() {
2449         tokenRarityRoot[_rarity] = _root;
2450     }
2451 
2452     function setExpiration(uint256 _expiration) public onlyOwner() {
2453         expiration = _expiration;
2454     }
2455     
2456     function toggleStart() public onlyOwner() {
2457         started = !started;
2458     }
2459 
2460     function setTokenAddress(address _tokenAddress) public onlyOwner() {
2461         // Used to change rewards token if needed
2462         jungleCoin = _tokenAddress;
2463     }
2464 
2465     function onERC721Received(
2466         address,
2467         address,
2468         uint256,
2469         bytes calldata
2470     ) external pure override returns (bytes4) {
2471         return IERC721Receiver.onERC721Received.selector;
2472     }
2473 
2474     function depositsOf(address account)
2475         external
2476         view
2477         returns (uint256[] memory)
2478     {
2479         EnumerableSet.UintSet storage depositSet = _deposits[account];
2480         uint256[] memory tokenIds = new uint256[](depositSet.length());
2481 
2482         for (uint256 i; i < depositSet.length(); i++) {
2483             tokenIds[i] = depositSet.at(i);
2484         }
2485 
2486         return tokenIds;
2487     }
2488 
2489     function findRate(uint256 rarity)
2490         public
2491         view
2492         returns (uint256 rate) 
2493     {
2494         uint256 perDay = rewardRate[rarity];
2495         
2496         // 6000 blocks per day
2497         // perDay / 6000 = reward per block
2498 
2499         rate = (perDay * 1e18) / 6000;
2500         
2501         return rate;
2502     }
2503 
2504     function calculateRewards(
2505         address account,
2506         uint256[] memory tokenIds,
2507         uint256[] memory rarities
2508     )
2509         public
2510         view
2511         returns (uint256[] memory rewards)
2512     {
2513         rewards = new uint256[](tokenIds.length);
2514 
2515         for (uint256 i; i < tokenIds.length; i++) {
2516             uint256 tokenId = tokenIds[i];
2517             uint256 rarity = rarities[i];
2518             uint256 rate = findRate(rarity);
2519             rewards[i] =
2520                 rate *
2521                 (_deposits[account].contains(tokenId) ? 1 : 0) *
2522                 (Math.min(block.number, expiration) -
2523                     depositBlocks[account][tokenId]);
2524         }
2525     }
2526 
2527     function claimRewards(
2528         uint256[] calldata tokenIds,
2529         uint256[] calldata rarities,
2530         bytes32[][] calldata proofs
2531     ) public {
2532         uint256 reward;
2533         uint256 curblock = Math.min(block.number, expiration);
2534 
2535         _verifyRarities(tokenIds, rarities, proofs);
2536         uint256[] memory rewards = calculateRewards(msg.sender, tokenIds, rarities);
2537 
2538         for (uint256 i; i < tokenIds.length; i++) {
2539             reward += rewards[i];
2540             depositBlocks[msg.sender][tokenIds[i]] = curblock;
2541         }
2542 
2543         if (reward > 0) {
2544             IJungleCoin(jungleCoin).mint(msg.sender, reward);
2545         }
2546     }
2547 
2548     function deposit(uint256[] calldata tokenIds) external {
2549         require(started, "not started yet");
2550 
2551         uint256 curblock = Math.min(block.number, expiration);
2552         for (uint256 i; i < tokenIds.length; i++) {
2553             depositBlocks[msg.sender][tokenIds[i]] = curblock;
2554         }
2555         
2556         for (uint256 i; i < tokenIds.length; i++) {
2557             IERC721(royalCubs).safeTransferFrom(
2558                 msg.sender,
2559                 address(this),
2560                 tokenIds[i],
2561                 ''
2562             );
2563             _deposits[msg.sender].add(tokenIds[i]);
2564         }
2565     }
2566 
2567     function adminDeposit(uint256[] calldata tokenIds) onlyOwner() external {
2568         uint256 curblock = Math.min(block.number, expiration);
2569         for (uint256 i; i < tokenIds.length; i++) {
2570             depositBlocks[msg.sender][tokenIds[i]] = curblock;
2571         }
2572 
2573         for (uint256 i; i < tokenIds.length; i++) {
2574             IERC721(royalCubs).safeTransferFrom(
2575                 msg.sender,
2576                 address(this),
2577                 tokenIds[i],
2578                 ''
2579             );
2580             _deposits[msg.sender].add(tokenIds[i]);
2581         }
2582     }
2583 
2584     function withdraw(
2585         uint256[] calldata tokenIds,
2586         uint256[] calldata rarities,
2587         bytes32[][] calldata proofs
2588     ) external {
2589         claimRewards(tokenIds, rarities, proofs);
2590 
2591         for (uint256 i; i < tokenIds.length; i++) {
2592             require(
2593                 _deposits[msg.sender].contains(tokenIds[i]),
2594                 "Token not deposited"
2595             );
2596 
2597             _deposits[msg.sender].remove(tokenIds[i]);
2598 
2599             IERC721(royalCubs).safeTransferFrom(
2600                 address(this),
2601                 msg.sender,
2602                 tokenIds[i],
2603                 ''
2604             );
2605         }
2606     }
2607 
2608     function emergencyWithdraw(uint256[] calldata tokenIds) external {
2609         for (uint256 i; i < tokenIds.length; i++) {
2610             require(
2611                 _deposits[msg.sender].contains(tokenIds[i]),
2612                 "Token not deposited"
2613             );
2614 
2615             _deposits[msg.sender].remove(tokenIds[i]);
2616 
2617             IERC721(royalCubs).safeTransferFrom(
2618                 address(this),
2619                 msg.sender,
2620                 tokenIds[i],
2621                 ''
2622             );
2623         }
2624     }
2625 
2626     function _verifyRarities(
2627         uint[] memory _tokenIds,
2628         uint[] memory _rarities,
2629         bytes32[][] calldata _proofs
2630     ) internal view {
2631         for (uint i = 0; i < _tokenIds.length; i++) {
2632             if (_rarities[i] > 0) {
2633                 require(_isRarity(_tokenIds[i], _rarities[i], _proofs[i]));
2634             }
2635         }
2636     }
2637 
2638     function _isRarity(
2639         uint _tokenId,
2640         uint _rarity,
2641         bytes32[] calldata _proof
2642     ) internal view returns (bool) {
2643         bytes32 root = tokenRarityRoot[_rarity];
2644         return MerkleProof.verify(_proof, root, _leaf(_tokenId));
2645     }
2646 
2647     function _leaf(uint _tokenId) internal pure returns (bytes32) {
2648         return keccak256(abi.encodePacked(_tokenId));
2649     }
2650 
2651     receive() external payable {}
2652 
2653     function salvage() external onlyOwner {
2654         payable(owner()).transfer(address(this).balance);
2655     }
2656 }