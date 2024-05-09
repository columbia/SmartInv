1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
2 
3 /// @credits: manifold.xyz
4 
5 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
6 //                                                                                                                           //
7 //                                                                                                                           //
8 //    ....................................................................................................................   //
9 //    ....................................................................................................................   //
10 //    ....................................................................................................................   //
11 //    ....................................................................................................................   //
12 //    ....................................................................................................................   //
13 //    ....................................................................................................................   //
14 //    ....................................................................................................................   //
15 //    ....................................................................................................................   //
16 //    ..... MMMMMMMMMMMMMM  MMMMMMMMMMM ..MMMM..MMMM ...MMMM .,MMMMMMMMMM .MMMNMMMMMMM,..MMMM..MMMMMMMMMMMMMMMMMMMMMMMMN..   //
17 //    .... :MMM........... MMMM... MMM  ...MMMM .MMMM ..MMM.. MMMM....... MMMM....MMMM....MMMM..MMMM ........ MMM ........   //
18 //    .....MMMM...................MMMM......MMMM. MMMM MMMM  MMMM ...............MMMM .....MMMM. MMMMMMMMMM ...MMMM.......   //
19 //    ....MMMM...:::MMM,.MMMM:MMMM  ...:MMM,.MMM......MMMM .MMMM ....... MMMM:MMMM .. .MMMM,MMMM..MMM .........MMMM.......   //
20 //    ...MMMM .....MMMM..MMM . MMMM ...MMMM..MMMM....MMMM..MMMM.........MMMM . MMM ...MMMM.. MMMM.MMMM..........MMMM......   //
21 //    ..MMMMMMMMM.MMMM  MMMM... MMMM  MMMM....MMMM..MMMM .MMMMMMMMMMM .MMMM... MMMM. MMMM...  MMM..MMMM ........ MMMM.....   //
22 //    ....................................................................................................................   //
23 //    ....................................................................................................................   //
24 //    ....................................................................................................................   //
25 //    ....................................................................................................................   //
26 //    ....................................................................................................................   //
27 //    ....................................................................................................................   //
28 //    ....................................................................................................................   //
29 //    ....................................................................................................................   //
30 //                                                                                                                           //
31 //                                                                                                                           //
32 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 
59 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
60 
61 
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Implementation of the {IERC165} interface.
67  *
68  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
69  * for the additional interface id that will be supported. For example:
70  *
71  * ```solidity
72  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
73  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
74  * }
75  * ```
76  *
77  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
78  */
79 abstract contract ERC165 is IERC165 {
80     /**
81      * @dev See {IERC165-supportsInterface}.
82      */
83     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
84         return interfaceId == type(IERC165).interfaceId;
85     }
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.2.0
90 
91 
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Library for managing
97  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
98  * types.
99  *
100  * Sets have the following properties:
101  *
102  * - Elements are added, removed, and checked for existence in constant time
103  * (O(1)).
104  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
105  *
106  * ```
107  * contract Example {
108  *     // Add the library methods
109  *     using EnumerableSet for EnumerableSet.AddressSet;
110  *
111  *     // Declare a set state variable
112  *     EnumerableSet.AddressSet private mySet;
113  * }
114  * ```
115  *
116  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
117  * and `uint256` (`UintSet`) are supported.
118  */
119 library EnumerableSet {
120     // To implement this library for multiple types with as little code
121     // repetition as possible, we write it in terms of a generic Set type with
122     // bytes32 values.
123     // The Set implementation uses private functions, and user-facing
124     // implementations (such as AddressSet) are just wrappers around the
125     // underlying Set.
126     // This means that we can only create new EnumerableSets for types that fit
127     // in bytes32.
128 
129     struct Set {
130         // Storage of set values
131         bytes32[] _values;
132         // Position of the value in the `values` array, plus 1 because index 0
133         // means a value is not in the set.
134         mapping(bytes32 => uint256) _indexes;
135     }
136 
137     /**
138      * @dev Add a value to a set. O(1).
139      *
140      * Returns true if the value was added to the set, that is if it was not
141      * already present.
142      */
143     function _add(Set storage set, bytes32 value) private returns (bool) {
144         if (!_contains(set, value)) {
145             set._values.push(value);
146             // The value is stored at length-1, but we add 1 to all indexes
147             // and use 0 as a sentinel value
148             set._indexes[value] = set._values.length;
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155     /**
156      * @dev Removes a value from a set. O(1).
157      *
158      * Returns true if the value was removed from the set, that is if it was
159      * present.
160      */
161     function _remove(Set storage set, bytes32 value) private returns (bool) {
162         // We read and store the value's index to prevent multiple reads from the same storage slot
163         uint256 valueIndex = set._indexes[value];
164 
165         if (valueIndex != 0) {
166             // Equivalent to contains(set, value)
167             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
168             // the array, and then remove the last element (sometimes called as 'swap and pop').
169             // This modifies the order of the array, as noted in {at}.
170 
171             uint256 toDeleteIndex = valueIndex - 1;
172             uint256 lastIndex = set._values.length - 1;
173 
174             if (lastIndex != toDeleteIndex) {
175                 bytes32 lastvalue = set._values[lastIndex];
176 
177                 // Move the last value to the index where the value to delete is
178                 set._values[toDeleteIndex] = lastvalue;
179                 // Update the index for the moved value
180                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
181             }
182 
183             // Delete the slot where the moved value was stored
184             set._values.pop();
185 
186             // Delete the index for the deleted slot
187             delete set._indexes[value];
188 
189             return true;
190         } else {
191             return false;
192         }
193     }
194 
195     /**
196      * @dev Returns true if the value is in the set. O(1).
197      */
198     function _contains(Set storage set, bytes32 value) private view returns (bool) {
199         return set._indexes[value] != 0;
200     }
201 
202     /**
203      * @dev Returns the number of values on the set. O(1).
204      */
205     function _length(Set storage set) private view returns (uint256) {
206         return set._values.length;
207     }
208 
209     /**
210      * @dev Returns the value stored at position `index` in the set. O(1).
211      *
212      * Note that there are no guarantees on the ordering of values inside the
213      * array, and it may change when more values are added or removed.
214      *
215      * Requirements:
216      *
217      * - `index` must be strictly less than {length}.
218      */
219     function _at(Set storage set, uint256 index) private view returns (bytes32) {
220         return set._values[index];
221     }
222 
223     // Bytes32Set
224 
225     struct Bytes32Set {
226         Set _inner;
227     }
228 
229     /**
230      * @dev Add a value to a set. O(1).
231      *
232      * Returns true if the value was added to the set, that is if it was not
233      * already present.
234      */
235     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
236         return _add(set._inner, value);
237     }
238 
239     /**
240      * @dev Removes a value from a set. O(1).
241      *
242      * Returns true if the value was removed from the set, that is if it was
243      * present.
244      */
245     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
246         return _remove(set._inner, value);
247     }
248 
249     /**
250      * @dev Returns true if the value is in the set. O(1).
251      */
252     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
253         return _contains(set._inner, value);
254     }
255 
256     /**
257      * @dev Returns the number of values in the set. O(1).
258      */
259     function length(Bytes32Set storage set) internal view returns (uint256) {
260         return _length(set._inner);
261     }
262 
263     /**
264      * @dev Returns the value stored at position `index` in the set. O(1).
265      *
266      * Note that there are no guarantees on the ordering of values inside the
267      * array, and it may change when more values are added or removed.
268      *
269      * Requirements:
270      *
271      * - `index` must be strictly less than {length}.
272      */
273     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
274         return _at(set._inner, index);
275     }
276 
277     // AddressSet
278 
279     struct AddressSet {
280         Set _inner;
281     }
282 
283     /**
284      * @dev Add a value to a set. O(1).
285      *
286      * Returns true if the value was added to the set, that is if it was not
287      * already present.
288      */
289     function add(AddressSet storage set, address value) internal returns (bool) {
290         return _add(set._inner, bytes32(uint256(uint160(value))));
291     }
292 
293     /**
294      * @dev Removes a value from a set. O(1).
295      *
296      * Returns true if the value was removed from the set, that is if it was
297      * present.
298      */
299     function remove(AddressSet storage set, address value) internal returns (bool) {
300         return _remove(set._inner, bytes32(uint256(uint160(value))));
301     }
302 
303     /**
304      * @dev Returns true if the value is in the set. O(1).
305      */
306     function contains(AddressSet storage set, address value) internal view returns (bool) {
307         return _contains(set._inner, bytes32(uint256(uint160(value))));
308     }
309 
310     /**
311      * @dev Returns the number of values in the set. O(1).
312      */
313     function length(AddressSet storage set) internal view returns (uint256) {
314         return _length(set._inner);
315     }
316 
317     /**
318      * @dev Returns the value stored at position `index` in the set. O(1).
319      *
320      * Note that there are no guarantees on the ordering of values inside the
321      * array, and it may change when more values are added or removed.
322      *
323      * Requirements:
324      *
325      * - `index` must be strictly less than {length}.
326      */
327     function at(AddressSet storage set, uint256 index) internal view returns (address) {
328         return address(uint160(uint256(_at(set._inner, index))));
329     }
330 
331     // UintSet
332 
333     struct UintSet {
334         Set _inner;
335     }
336 
337     /**
338      * @dev Add a value to a set. O(1).
339      *
340      * Returns true if the value was added to the set, that is if it was not
341      * already present.
342      */
343     function add(UintSet storage set, uint256 value) internal returns (bool) {
344         return _add(set._inner, bytes32(value));
345     }
346 
347     /**
348      * @dev Removes a value from a set. O(1).
349      *
350      * Returns true if the value was removed from the set, that is if it was
351      * present.
352      */
353     function remove(UintSet storage set, uint256 value) internal returns (bool) {
354         return _remove(set._inner, bytes32(value));
355     }
356 
357     /**
358      * @dev Returns true if the value is in the set. O(1).
359      */
360     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
361         return _contains(set._inner, bytes32(value));
362     }
363 
364     /**
365      * @dev Returns the number of values on the set. O(1).
366      */
367     function length(UintSet storage set) internal view returns (uint256) {
368         return _length(set._inner);
369     }
370 
371     /**
372      * @dev Returns the value stored at position `index` in the set. O(1).
373      *
374      * Note that there are no guarantees on the ordering of values inside the
375      * array, and it may change when more values are added or removed.
376      *
377      * Requirements:
378      *
379      * - `index` must be strictly less than {length}.
380      */
381     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
382         return uint256(_at(set._inner, index));
383     }
384 }
385 
386 
387 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
388 
389 
390 
391 pragma solidity ^0.8.0;
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 
414 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
415 
416 
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev Contract module which provides a basic access control mechanism, where
422  * there is an account (an owner) that can be granted exclusive access to
423  * specific functions.
424  *
425  * By default, the owner account will be the one that deploys the contract. This
426  * can later be changed with {transferOwnership}.
427  *
428  * This module is used through inheritance. It will make available the modifier
429  * `onlyOwner`, which can be applied to your functions to restrict their use to
430  * the owner.
431  */
432 abstract contract Ownable is Context {
433     address private _owner;
434 
435     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
436 
437     /**
438      * @dev Initializes the contract setting the deployer as the initial owner.
439      */
440     constructor() {
441         _setOwner(_msgSender());
442     }
443 
444     /**
445      * @dev Returns the address of the current owner.
446      */
447     function owner() public view virtual returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(owner() == _msgSender(), "Ownable: caller is not the owner");
456         _;
457     }
458 
459     /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         _setOwner(address(0));
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         _setOwner(newOwner);
477     }
478 
479     function _setOwner(address newOwner) private {
480         address oldOwner = _owner;
481         _owner = newOwner;
482         emit OwnershipTransferred(oldOwner, newOwner);
483     }
484 }
485 
486 
487 // File contracts/creator/access/IAdminControl.sol
488 
489 
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface for admin control
495  */
496 interface IAdminControl is IERC165 {
497 
498     event AdminApproved(address indexed account, address indexed sender);
499     event AdminRevoked(address indexed account, address indexed sender);
500 
501     /**
502      * @dev gets address of all admins
503      */
504     function getAdmins() external view returns (address[] memory);
505 
506     /**
507      * @dev add an admin.  Can only be called by contract owner.
508      */
509     function approveAdmin(address admin) external;
510 
511     /**
512      * @dev remove an admin.  Can only be called by contract owner.
513      */
514     function revokeAdmin(address admin) external;
515 
516     /**
517      * @dev checks whether or not given address is an admin
518      * Returns True if they are
519      */
520     function isAdmin(address admin) external view returns (bool);
521 
522 }
523 
524 
525 // File contracts/creator/access/AdminControl.sol
526 
527 
528 
529 pragma solidity ^0.8.0;
530 
531 
532 
533 
534 
535 
536 abstract contract AdminControl is Ownable, IAdminControl, ERC165 {
537     using EnumerableSet for EnumerableSet.AddressSet;
538 
539     // Track registered admins
540     EnumerableSet.AddressSet private _admins;
541 
542     /**
543      * @dev See {IERC165-supportsInterface}.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
546         return interfaceId == type(IAdminControl).interfaceId
547             || super.supportsInterface(interfaceId);
548     }
549 
550     /**
551      * @dev Only allows approved admins to call the specified function
552      */
553     modifier adminRequired() {
554         require(owner() == msg.sender || _admins.contains(msg.sender), "AdminControl: Must be owner or admin");
555         _;
556     }   
557 
558     /**
559      * @dev See {IAdminControl-getAdmins}.
560      */
561     function getAdmins() external view override returns (address[] memory admins) {
562         admins = new address[](_admins.length());
563         for (uint i = 0; i < _admins.length(); i++) {
564             admins[i] = _admins.at(i);
565         }
566         return admins;
567     }
568 
569     /**
570      * @dev See {IAdminControl-approveAdmin}.
571      */
572     function approveAdmin(address admin) external override onlyOwner {
573         if (!_admins.contains(admin)) {
574             emit AdminApproved(admin, msg.sender);
575             _admins.add(admin);
576         }
577     }
578 
579     /**
580      * @dev See {IAdminControl-revokeAdmin}.
581      */
582     function revokeAdmin(address admin) external override onlyOwner {
583         if (_admins.contains(admin)) {
584             emit AdminRevoked(admin, msg.sender);
585             _admins.remove(admin);
586         }
587     }
588 
589     /**
590      * @dev See {IAdminControl-isAdmin}.
591      */
592     function isAdmin(address admin) public override view returns (bool) {
593         return (owner() == admin || _admins.contains(admin));
594     }
595 
596 }
597 
598 
599 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.2.0
600 
601 
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Contract module that helps prevent reentrant calls to a function.
607  *
608  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
609  * available, which can be applied to functions to make sure there are no nested
610  * (reentrant) calls to them.
611  *
612  * Note that because there is a single `nonReentrant` guard, functions marked as
613  * `nonReentrant` may not call one another. This can be worked around by making
614  * those functions `private`, and then adding `external` `nonReentrant` entry
615  * points to them.
616  *
617  * TIP: If you would like to learn more about reentrancy and alternative ways
618  * to protect against it, check out our blog post
619  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
620  */
621 abstract contract ReentrancyGuard {
622     // Booleans are more expensive than uint256 or any type that takes up a full
623     // word because each write operation emits an extra SLOAD to first read the
624     // slot's contents, replace the bits taken up by the boolean, and then write
625     // back. This is the compiler's defense against contract upgrades and
626     // pointer aliasing, and it cannot be disabled.
627 
628     // The values being non-zero value makes deployment a bit more expensive,
629     // but in exchange the refund on every call to nonReentrant will be lower in
630     // amount. Since refunds are capped to a percentage of the total
631     // transaction's gas, it is best to keep them low in cases like this one, to
632     // increase the likelihood of the full refund coming into effect.
633     uint256 private constant _NOT_ENTERED = 1;
634     uint256 private constant _ENTERED = 2;
635 
636     uint256 private _status;
637 
638     constructor() {
639         _status = _NOT_ENTERED;
640     }
641 
642     /**
643      * @dev Prevents a contract from calling itself, directly or indirectly.
644      * Calling a `nonReentrant` function from another `nonReentrant`
645      * function is not supported. It is possible to prevent this from happening
646      * by making the `nonReentrant` function external, and make it call a
647      * `private` function that does the actual work.
648      */
649     modifier nonReentrant() {
650         // On the first call to nonReentrant, _notEntered will be true
651         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
652 
653         // Any calls to nonReentrant after this point will fail
654         _status = _ENTERED;
655 
656         _;
657 
658         // By storing the original value once again, a refund is triggered (see
659         // https://eips.ethereum.org/EIPS/eip-2200)
660         _status = _NOT_ENTERED;
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
666 
667 
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev String operations.
673  */
674 library Strings {
675     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
676 
677     /**
678      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
679      */
680     function toString(uint256 value) internal pure returns (string memory) {
681         // Inspired by OraclizeAPI's implementation - MIT licence
682         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
683 
684         if (value == 0) {
685             return "0";
686         }
687         uint256 temp = value;
688         uint256 digits;
689         while (temp != 0) {
690             digits++;
691             temp /= 10;
692         }
693         bytes memory buffer = new bytes(digits);
694         while (value != 0) {
695             digits -= 1;
696             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
697             value /= 10;
698         }
699         return string(buffer);
700     }
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
704      */
705     function toHexString(uint256 value) internal pure returns (string memory) {
706         if (value == 0) {
707             return "0x00";
708         }
709         uint256 temp = value;
710         uint256 length = 0;
711         while (temp != 0) {
712             length++;
713             temp >>= 8;
714         }
715         return toHexString(value, length);
716     }
717 
718     /**
719      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
720      */
721     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
722         bytes memory buffer = new bytes(2 * length + 2);
723         buffer[0] = "0";
724         buffer[1] = "x";
725         for (uint256 i = 2 * length + 1; i > 1; --i) {
726             buffer[i] = _HEX_SYMBOLS[value & 0xf];
727             value >>= 4;
728         }
729         require(value == 0, "Strings: hex length insufficient");
730         return string(buffer);
731     }
732 }
733 
734 
735 // File @openzeppelin/contracts/utils/introspection/ERC165Checker.sol@v4.2.0
736 
737 
738 
739 pragma solidity ^0.8.0;
740 
741 /**
742  * @dev Library used to query support of an interface declared via {IERC165}.
743  *
744  * Note that these functions return the actual result of the query: they do not
745  * `revert` if an interface is not supported. It is up to the caller to decide
746  * what to do in these cases.
747  */
748 library ERC165Checker {
749     // As per the EIP-165 spec, no interface should ever match 0xffffffff
750     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
751 
752     /**
753      * @dev Returns true if `account` supports the {IERC165} interface,
754      */
755     function supportsERC165(address account) internal view returns (bool) {
756         // Any contract that implements ERC165 must explicitly indicate support of
757         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
758         return
759             _supportsERC165Interface(account, type(IERC165).interfaceId) &&
760             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
761     }
762 
763     /**
764      * @dev Returns true if `account` supports the interface defined by
765      * `interfaceId`. Support for {IERC165} itself is queried automatically.
766      *
767      * See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
770         // query support of both ERC165 as per the spec and support of _interfaceId
771         return supportsERC165(account) && _supportsERC165Interface(account, interfaceId);
772     }
773 
774     /**
775      * @dev Returns a boolean array where each value corresponds to the
776      * interfaces passed in and whether they're supported or not. This allows
777      * you to batch check interfaces for a contract where your expectation
778      * is that some interfaces may not be supported.
779      *
780      * See {IERC165-supportsInterface}.
781      *
782      * _Available since v3.4._
783      */
784     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds)
785         internal
786         view
787         returns (bool[] memory)
788     {
789         // an array of booleans corresponding to interfaceIds and whether they're supported or not
790         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
791 
792         // query support of ERC165 itself
793         if (supportsERC165(account)) {
794             // query support of each interface in interfaceIds
795             for (uint256 i = 0; i < interfaceIds.length; i++) {
796                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
797             }
798         }
799 
800         return interfaceIdsSupported;
801     }
802 
803     /**
804      * @dev Returns true if `account` supports all the interfaces defined in
805      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
806      *
807      * Batch-querying can lead to gas savings by skipping repeated checks for
808      * {IERC165} support.
809      *
810      * See {IERC165-supportsInterface}.
811      */
812     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
813         // query support of ERC165 itself
814         if (!supportsERC165(account)) {
815             return false;
816         }
817 
818         // query support of each interface in _interfaceIds
819         for (uint256 i = 0; i < interfaceIds.length; i++) {
820             if (!_supportsERC165Interface(account, interfaceIds[i])) {
821                 return false;
822             }
823         }
824 
825         // all interfaces supported
826         return true;
827     }
828 
829     /**
830      * @notice Query if a contract implements an interface, does not check ERC165 support
831      * @param account The address of the contract to query for support of an interface
832      * @param interfaceId The interface identifier, as specified in ERC-165
833      * @return true if the contract at account indicates support of the interface with
834      * identifier interfaceId, false otherwise
835      * @dev Assumes that account contains a contract that supports ERC165, otherwise
836      * the behavior of this method is undefined. This precondition can be checked
837      * with {supportsERC165}.
838      * Interface identification is specified in ERC-165.
839      */
840     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
841         bytes memory encodedParams = abi.encodeWithSelector(IERC165(account).supportsInterface.selector, interfaceId);
842         (bool success, bytes memory result) = account.staticcall{gas: 30000}(encodedParams);
843         if (result.length < 32) return false;
844         return success && abi.decode(result, (bool));
845     }
846 }
847 
848 
849 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.2.0
850 
851 
852 
853 pragma solidity ^0.8.0;
854 
855 /**
856  * @dev Collection of functions related to the address type
857  */
858 library AddressUpgradeable {
859     /**
860      * @dev Returns true if `account` is a contract.
861      *
862      * [IMPORTANT]
863      * ====
864      * It is unsafe to assume that an address for which this function returns
865      * false is an externally-owned account (EOA) and not a contract.
866      *
867      * Among others, `isContract` will return false for the following
868      * types of addresses:
869      *
870      *  - an externally-owned account
871      *  - a contract in construction
872      *  - an address where a contract will be created
873      *  - an address where a contract lived, but was destroyed
874      * ====
875      */
876     function isContract(address account) internal view returns (bool) {
877         // This method relies on extcodesize, which returns 0 for contracts in
878         // construction, since the code is only stored at the end of the
879         // constructor execution.
880 
881         uint256 size;
882         assembly {
883             size := extcodesize(account)
884         }
885         return size > 0;
886     }
887 
888     /**
889      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
890      * `recipient`, forwarding all available gas and reverting on errors.
891      *
892      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
893      * of certain opcodes, possibly making contracts go over the 2300 gas limit
894      * imposed by `transfer`, making them unable to receive funds via
895      * `transfer`. {sendValue} removes this limitation.
896      *
897      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
898      *
899      * IMPORTANT: because control is transferred to `recipient`, care must be
900      * taken to not create reentrancy vulnerabilities. Consider using
901      * {ReentrancyGuard} or the
902      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
903      */
904     function sendValue(address payable recipient, uint256 amount) internal {
905         require(address(this).balance >= amount, "Address: insufficient balance");
906 
907         (bool success, ) = recipient.call{value: amount}("");
908         require(success, "Address: unable to send value, recipient may have reverted");
909     }
910 
911     /**
912      * @dev Performs a Solidity function call using a low level `call`. A
913      * plain `call` is an unsafe replacement for a function call: use this
914      * function instead.
915      *
916      * If `target` reverts with a revert reason, it is bubbled up by this
917      * function (like regular Solidity function calls).
918      *
919      * Returns the raw returned data. To convert to the expected return value,
920      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
921      *
922      * Requirements:
923      *
924      * - `target` must be a contract.
925      * - calling `target` with `data` must not revert.
926      *
927      * _Available since v3.1._
928      */
929     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
930         return functionCall(target, data, "Address: low-level call failed");
931     }
932 
933     /**
934      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
935      * `errorMessage` as a fallback revert reason when `target` reverts.
936      *
937      * _Available since v3.1._
938      */
939     function functionCall(
940         address target,
941         bytes memory data,
942         string memory errorMessage
943     ) internal returns (bytes memory) {
944         return functionCallWithValue(target, data, 0, errorMessage);
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
949      * but also transferring `value` wei to `target`.
950      *
951      * Requirements:
952      *
953      * - the calling contract must have an ETH balance of at least `value`.
954      * - the called Solidity function must be `payable`.
955      *
956      * _Available since v3.1._
957      */
958     function functionCallWithValue(
959         address target,
960         bytes memory data,
961         uint256 value
962     ) internal returns (bytes memory) {
963         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
964     }
965 
966     /**
967      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
968      * with `errorMessage` as a fallback revert reason when `target` reverts.
969      *
970      * _Available since v3.1._
971      */
972     function functionCallWithValue(
973         address target,
974         bytes memory data,
975         uint256 value,
976         string memory errorMessage
977     ) internal returns (bytes memory) {
978         require(address(this).balance >= value, "Address: insufficient balance for call");
979         require(isContract(target), "Address: call to non-contract");
980 
981         (bool success, bytes memory returndata) = target.call{value: value}(data);
982         return _verifyCallResult(success, returndata, errorMessage);
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
987      * but performing a static call.
988      *
989      * _Available since v3.3._
990      */
991     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
992         return functionStaticCall(target, data, "Address: low-level static call failed");
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
997      * but performing a static call.
998      *
999      * _Available since v3.3._
1000      */
1001     function functionStaticCall(
1002         address target,
1003         bytes memory data,
1004         string memory errorMessage
1005     ) internal view returns (bytes memory) {
1006         require(isContract(target), "Address: static call to non-contract");
1007 
1008         (bool success, bytes memory returndata) = target.staticcall(data);
1009         return _verifyCallResult(success, returndata, errorMessage);
1010     }
1011 
1012     function _verifyCallResult(
1013         bool success,
1014         bytes memory returndata,
1015         string memory errorMessage
1016     ) private pure returns (bytes memory) {
1017         if (success) {
1018             return returndata;
1019         } else {
1020             // Look for revert reason and bubble it up if present
1021             if (returndata.length > 0) {
1022                 // The easiest way to bubble the revert reason is using memory via assembly
1023 
1024                 assembly {
1025                     let returndata_size := mload(returndata)
1026                     revert(add(32, returndata), returndata_size)
1027                 }
1028             } else {
1029                 revert(errorMessage);
1030             }
1031         }
1032     }
1033 }
1034 
1035 
1036 // File contracts/creator/extensions/ICreatorExtensionTokenURI.sol
1037 
1038 
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 
1043 
1044 /**
1045  * @dev Implement this if you want your extension to have overloadable URI's
1046  */
1047 interface ICreatorExtensionTokenURI is IERC165 {
1048 
1049     /**
1050      * Get the uri for a given creator/tokenId
1051      */
1052     function tokenURI(address creator, uint256 tokenId) external view returns (string memory);
1053 }
1054 
1055 
1056 // File contracts/creator/core/ICreatorCore.sol
1057 
1058 
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 
1063 
1064 /**
1065  * @dev Core creator interface
1066  */
1067 interface ICreatorCore is IERC165 {
1068 
1069     event ExtensionRegistered(address indexed extension, address indexed sender);
1070     event ExtensionUnregistered(address indexed extension, address indexed sender);
1071     event ExtensionBlacklisted(address indexed extension, address indexed sender);
1072     event MintPermissionsUpdated(address indexed extension, address indexed permissions, address indexed sender);
1073     event RoyaltiesUpdated(uint256 indexed tokenId, address payable[] receivers, uint256[] basisPoints);
1074     event DefaultRoyaltiesUpdated(address payable[] receivers, uint256[] basisPoints);
1075     event ExtensionRoyaltiesUpdated(address indexed extension, address payable[] receivers, uint256[] basisPoints);
1076     event ExtensionApproveTransferUpdated(address indexed extension, bool enabled);
1077 
1078     /**
1079      * @dev gets address of all extensions
1080      */
1081     function getExtensions() external view returns (address[] memory);
1082 
1083     /**
1084      * @dev add an extension.  Can only be called by contract owner or admin.
1085      * extension address must point to a contract implementing ICreatorExtension.
1086      * Returns True if newly added, False if already added.
1087      */
1088     function registerExtension(address extension, string calldata baseURI) external;
1089 
1090     /**
1091      * @dev add an extension.  Can only be called by contract owner or admin.
1092      * extension address must point to a contract implementing ICreatorExtension.
1093      * Returns True if newly added, False if already added.
1094      */
1095     function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external;
1096 
1097     /**
1098      * @dev add an extension.  Can only be called by contract owner or admin.
1099      * Returns True if removed, False if already removed.
1100      */
1101     function unregisterExtension(address extension) external;
1102 
1103     /**
1104      * @dev blacklist an extension.  Can only be called by contract owner or admin.
1105      * This function will destroy all ability to reference the metadata of any tokens created
1106      * by the specified extension. It will also unregister the extension if needed.
1107      * Returns True if removed, False if already removed.
1108      */
1109     function blacklistExtension(address extension) external;
1110 
1111     /**
1112      * @dev set the baseTokenURI of an extension.  Can only be called by extension.
1113      */
1114     function setBaseTokenURIExtension(string calldata uri) external;
1115 
1116     /**
1117      * @dev set the baseTokenURI of an extension.  Can only be called by extension.
1118      * For tokens with no uri configured, tokenURI will return "uri+tokenId"
1119      */
1120     function setBaseTokenURIExtension(string calldata uri, bool identical) external;
1121 
1122     /**
1123      * @dev set the common prefix of an extension.  Can only be called by extension.
1124      * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"
1125      * Useful if you want to use ipfs/arweave
1126      */
1127     function setTokenURIPrefixExtension(string calldata prefix) external;
1128 
1129     /**
1130      * @dev set the tokenURI of a token extension.  Can only be called by extension that minted token.
1131      */
1132     function setTokenURIExtension(uint256 tokenId, string calldata uri) external;
1133 
1134     /**
1135      * @dev set the tokenURI of a token extension for multiple tokens.  Can only be called by extension that minted token.
1136      */
1137     function setTokenURIExtension(uint256[] memory tokenId, string[] calldata uri) external;
1138 
1139     /**
1140      * @dev set the baseTokenURI for tokens with no extension.  Can only be called by owner/admin.
1141      * For tokens with no uri configured, tokenURI will return "uri+tokenId"
1142      */
1143     function setBaseTokenURI(string calldata uri) external;
1144 
1145     /**
1146      * @dev set the common prefix for tokens with no extension.  Can only be called by owner/admin.
1147      * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"
1148      * Useful if you want to use ipfs/arweave
1149      */
1150     function setTokenURIPrefix(string calldata prefix) external;
1151 
1152     /**
1153      * @dev set the tokenURI of a token with no extension.  Can only be called by owner/admin.
1154      */
1155     function setTokenURI(uint256 tokenId, string calldata uri) external;
1156 
1157     /**
1158      * @dev set the tokenURI of multiple tokens with no extension.  Can only be called by owner/admin.
1159      */
1160     function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external;
1161 
1162     /**
1163      * @dev set a permissions contract for an extension.  Used to control minting.
1164      */
1165     function setMintPermissions(address extension, address permissions) external;
1166 
1167     /**
1168      * @dev Configure so transfers of tokens created by the caller (must be extension) gets approval
1169      * from the extension before transferring
1170      */
1171     function setApproveTransferExtension(bool enabled) external;
1172 
1173     /**
1174      * @dev get the extension of a given token
1175      */
1176     function tokenExtension(uint256 tokenId) external view returns (address);
1177 
1178     /**
1179      * @dev Set default royalties
1180      */
1181     function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1182 
1183     /**
1184      * @dev Set royalties of a token
1185      */
1186     function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1187 
1188     /**
1189      * @dev Set royalties of an extension
1190      */
1191     function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1192 
1193     /**
1194      * @dev Get royalites of a token.  Returns list of receivers and basisPoints
1195      */
1196     function getRoyalties(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);
1197     
1198     // Royalty support for various other standards
1199     function getFeeRecipients(uint256 tokenId) external view returns (address payable[] memory);
1200     function getFeeBps(uint256 tokenId) external view returns (uint[] memory);
1201     function getFees(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);
1202     function royaltyInfo(uint256 tokenId, uint256 value, bytes calldata data) external view returns (address, uint256, bytes memory);
1203 
1204 }
1205 
1206 
1207 // File contracts/creator/core/CreatorCore.sol
1208 
1209 
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 
1214 
1215 
1216 
1217 
1218 
1219 
1220 /**
1221  * @dev Core creator implementation
1222  */
1223 abstract contract CreatorCore is ReentrancyGuard, ICreatorCore, ERC165 {
1224     using Strings for uint256;
1225     using EnumerableSet for EnumerableSet.AddressSet;
1226     using AddressUpgradeable for address;
1227 
1228     uint256 _tokenCount = 0;
1229 
1230     // Track registered extensions data
1231     EnumerableSet.AddressSet internal _extensions;
1232     EnumerableSet.AddressSet internal _blacklistedExtensions;
1233     mapping (address => address) internal _extensionPermissions;
1234     mapping (address => bool) internal _extensionApproveTransfers;
1235     
1236     // For tracking which extension a token was minted by
1237     mapping (uint256 => address) internal _tokensExtension;
1238 
1239     // The baseURI for a given extension
1240     mapping (address => string) private _extensionBaseURI;
1241     mapping (address => bool) private _extensionBaseURIIdentical;
1242 
1243     // The prefix for any tokens with a uri configured
1244     mapping (address => string) private _extensionURIPrefix;
1245 
1246     // Mapping for individual token URIs
1247     mapping (uint256 => string) internal _tokenURIs;
1248 
1249     
1250     // Royalty configurations
1251     mapping (address => address payable[]) internal _extensionRoyaltyReceivers;
1252     mapping (address => uint256[]) internal _extensionRoyaltyBPS;
1253     mapping (uint256 => address payable[]) internal _tokenRoyaltyReceivers;
1254     mapping (uint256 => uint256[]) internal _tokenRoyaltyBPS;
1255 
1256     /**
1257      * External interface identifiers for royalties
1258      */
1259 
1260     /**
1261      *  @dev CreatorCore
1262      *
1263      *  bytes4(keccak256('getRoyalties(uint256)')) == 0xbb3bafd6
1264      *
1265      *  => 0xbb3bafd6 = 0xbb3bafd6
1266      */
1267     bytes4 private constant _INTERFACE_ID_ROYALTIES_CREATORCORE = 0xbb3bafd6;
1268 
1269     /**
1270      *  @dev Rarible: RoyaltiesV1
1271      *
1272      *  bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1273      *  bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1274      *
1275      *  => 0xb9c4d9fb ^ 0x0ebd4c7f = 0xb7799584
1276      */
1277     bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;
1278 
1279     /**
1280      *  @dev Foundation
1281      *
1282      *  bytes4(keccak256('getFees(uint256)')) == 0xd5a06d4c
1283      *
1284      *  => 0xd5a06d4c = 0xd5a06d4c
1285      */
1286     bytes4 private constant _INTERFACE_ID_ROYALTIES_FOUNDATION = 0xd5a06d4c;
1287 
1288     /**
1289      *  @dev EIP-2981
1290      *
1291      * bytes4(keccak256("royaltyInfo(uint256,uint256,bytes)")) == 0x6057361d
1292      *
1293      * => 0x6057361d = 0x6057361d
1294      */
1295     bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x6057361d;
1296 
1297     /**
1298      * @dev See {IERC165-supportsInterface}.
1299      */
1300     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1301         return interfaceId == type(ICreatorCore).interfaceId || super.supportsInterface(interfaceId)
1302             || interfaceId == _INTERFACE_ID_ROYALTIES_CREATORCORE || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE
1303             || interfaceId == _INTERFACE_ID_ROYALTIES_FOUNDATION || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981;
1304     }
1305 
1306     /**
1307      * @dev Only allows registered extensions to call the specified function
1308      */
1309     modifier extensionRequired() {
1310         require(_extensions.contains(msg.sender), "CreatorCore: Must be registered extension");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Only allows non-blacklisted extensions
1316      */
1317     modifier nonBlacklistRequired(address extension) {
1318         require(!_blacklistedExtensions.contains(extension), "CreatorCore: Extension blacklisted");
1319         _;
1320     }   
1321 
1322     /**
1323      * @dev See {ICreatorCore-getExtensions}.
1324      */
1325     function getExtensions() external view override returns (address[] memory extensions) {
1326         extensions = new address[](_extensions.length());
1327         for (uint i = 0; i < _extensions.length(); i++) {
1328             extensions[i] = _extensions.at(i);
1329         }
1330         return extensions;
1331     }
1332 
1333     /**
1334      * @dev Register an extension
1335      */
1336     function _registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) internal {
1337         require(extension.isContract(), "Creator: Extension must be a contract");
1338         if (!_extensions.contains(extension)) {
1339             _extensionBaseURI[extension] = baseURI;
1340             _extensionBaseURIIdentical[extension] = baseURIIdentical;
1341             emit ExtensionRegistered(extension, msg.sender);
1342             _extensions.add(extension);
1343         }
1344     }
1345 
1346     /**
1347      * @dev Unregister an extension
1348      */
1349     function _unregisterExtension(address extension) internal {
1350        if (_extensions.contains(extension)) {
1351            emit ExtensionUnregistered(extension, msg.sender);
1352            _extensions.remove(extension);
1353        }
1354     }
1355 
1356     /**
1357      * @dev Blacklist an extension
1358      */
1359     function _blacklistExtension(address extension) internal {
1360        require(extension != address(this), "CreatorCore: Cannot blacklist yourself");
1361        if (_extensions.contains(extension)) {
1362            emit ExtensionUnregistered(extension, msg.sender);
1363            _extensions.remove(extension);
1364        }
1365        if (!_blacklistedExtensions.contains(extension)) {
1366            emit ExtensionBlacklisted(extension, msg.sender);
1367            _blacklistedExtensions.add(extension);
1368        }
1369     }
1370 
1371     /**
1372      * @dev Set base token uri for an extension
1373      */
1374     function _setBaseTokenURIExtension(string calldata uri, bool identical) internal {
1375         _extensionBaseURI[msg.sender] = uri;
1376         _extensionBaseURIIdentical[msg.sender] = identical;
1377     }
1378 
1379     /**
1380      * @dev Set token uri prefix for an extension
1381      */
1382     function _setTokenURIPrefixExtension(string calldata prefix) internal {
1383         _extensionURIPrefix[msg.sender] = prefix;
1384     }
1385 
1386     /**
1387      * @dev Set token uri for a token of an extension
1388      */
1389     function _setTokenURIExtension(uint256 tokenId, string calldata uri) internal {
1390         require(_tokensExtension[tokenId] == msg.sender, "CreatorCore: Invalid token");
1391         _tokenURIs[tokenId] = uri;
1392     }
1393 
1394     /**
1395      * @dev Set base token uri for tokens with no extension
1396      */
1397     function _setBaseTokenURI(string memory uri) internal {
1398         _extensionBaseURI[address(this)] = uri;
1399     }
1400 
1401     /**
1402      * @dev Set token uri prefix for tokens with no extension
1403      */
1404     function _setTokenURIPrefix(string calldata prefix) internal {
1405         _extensionURIPrefix[address(this)] = prefix;
1406     }
1407 
1408 
1409     /**
1410      * @dev Set token uri for a token with no extension
1411      */
1412     function _setTokenURI(uint256 tokenId, string calldata uri) internal {
1413         require(_tokensExtension[tokenId] == address(this), "CreatorCore: Invalid token");
1414         _tokenURIs[tokenId] = uri;
1415     }
1416 
1417     /**
1418      * @dev Retrieve a token's URI
1419      */
1420     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1421         address extension = _tokensExtension[tokenId];
1422         require(!_blacklistedExtensions.contains(extension), "CreatorCore: Extension blacklisted");
1423 
1424         if (bytes(_tokenURIs[tokenId]).length != 0) {
1425             if (bytes(_extensionURIPrefix[extension]).length != 0) {
1426                 return string(abi.encodePacked(_extensionURIPrefix[extension],_tokenURIs[tokenId]));
1427             }
1428             return _tokenURIs[tokenId];
1429         }
1430 
1431         if (ERC165Checker.supportsInterface(extension, type(ICreatorExtensionTokenURI).interfaceId)) {
1432             return ICreatorExtensionTokenURI(extension).tokenURI(address(this), tokenId);
1433         }
1434 
1435         if (!_extensionBaseURIIdentical[extension]) {
1436             return string(abi.encodePacked(_extensionBaseURI[extension], tokenId.toString()));
1437         } else {
1438             return _extensionBaseURI[extension];
1439         }
1440     }
1441 
1442     /**
1443      * Get token extension
1444      */
1445     function _tokenExtension(uint256 tokenId) internal view returns (address extension) {
1446         extension = _tokensExtension[tokenId];
1447 
1448         require(extension != address(this), "CreatorCore: No extension for token");
1449         require(!_blacklistedExtensions.contains(extension), "CreatorCore: Extension blacklisted");
1450 
1451         return extension;
1452     }
1453 
1454     /**
1455      * Helper to get royalties for a token
1456      */
1457     function _getRoyalties(uint256 tokenId) view internal returns (address payable[] storage, uint256[] storage) {
1458         return (_getRoyaltyReceivers(tokenId), _getRoyaltyBPS(tokenId));
1459     }
1460 
1461     /**
1462      * Helper to get royalty receivers for a token
1463      */
1464     function _getRoyaltyReceivers(uint256 tokenId) view internal returns (address payable[] storage) {
1465         if (_tokenRoyaltyReceivers[tokenId].length > 0) {
1466             return _tokenRoyaltyReceivers[tokenId];
1467         } else if (_extensionRoyaltyReceivers[_tokensExtension[tokenId]].length > 0) {
1468             return _extensionRoyaltyReceivers[_tokensExtension[tokenId]];
1469         }
1470         return _extensionRoyaltyReceivers[address(this)];        
1471     }
1472 
1473     /**
1474      * Helper to get royalty basis points for a token
1475      */
1476     function _getRoyaltyBPS(uint256 tokenId) view internal returns (uint256[] storage) {
1477         if (_tokenRoyaltyBPS[tokenId].length > 0) {
1478             return _tokenRoyaltyBPS[tokenId];
1479         } else if (_extensionRoyaltyBPS[_tokensExtension[tokenId]].length > 0) {
1480             return _extensionRoyaltyBPS[_tokensExtension[tokenId]];
1481         }
1482         return _extensionRoyaltyBPS[address(this)];        
1483     }
1484 
1485     function _getRoyaltyInfo(uint256 tokenId, uint256 value) view internal returns (address receiver, uint256 amount, bytes memory data){
1486         address payable[] storage receivers = _getRoyaltyReceivers(tokenId);
1487         require(receivers.length <= 1, "CreatorCore: Only works if there are at most 1 royalty receivers");
1488         
1489         if (receivers.length == 0) {
1490             return (address(this), 0, data);
1491         }
1492         return (receivers[0], _getRoyaltyBPS(tokenId)[0]*value/10000, data);
1493     }
1494 
1495     /**
1496      * Set royalties for a token
1497      */
1498     function _setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) internal {
1499         require(receivers.length == basisPoints.length, "CreatorCore: Invalid input");
1500         uint256 totalBasisPoints;
1501         for (uint i = 0; i < basisPoints.length; i++) {
1502             totalBasisPoints += basisPoints[i];
1503         }
1504         require(totalBasisPoints < 10000, "CreatorCore: Invalid total royalties");
1505         _tokenRoyaltyReceivers[tokenId] = receivers;
1506         _tokenRoyaltyBPS[tokenId] = basisPoints;
1507         emit RoyaltiesUpdated(tokenId, receivers, basisPoints);
1508     }
1509 
1510     /**
1511      * Set royalties for all tokens of an extension
1512      */
1513     function _setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) internal {
1514         require(receivers.length == basisPoints.length, "CreatorCore: Invalid input");
1515         uint256 totalBasisPoints;
1516         for (uint i = 0; i < basisPoints.length; i++) {
1517             totalBasisPoints += basisPoints[i];
1518         }
1519         require(totalBasisPoints < 10000, "CreatorCore: Invalid total royalties");
1520         _extensionRoyaltyReceivers[extension] = receivers;
1521         _extensionRoyaltyBPS[extension] = basisPoints;
1522         if (extension == address(this)) {
1523             emit DefaultRoyaltiesUpdated(receivers, basisPoints);
1524         } else {
1525             emit ExtensionRoyaltiesUpdated(extension, receivers, basisPoints);
1526         }
1527     }
1528 
1529 
1530 }
1531 
1532 
1533 // File contracts/creator/extensions/ERC721/IERC721CreatorExtensionApproveTransfer.sol
1534 
1535 
1536 
1537 pragma solidity ^0.8.0;
1538 
1539 
1540 
1541 /**
1542  * Implement this if you want your extension to approve a transfer
1543  */
1544 interface IERC721CreatorExtensionApproveTransfer is IERC165 {
1545 
1546     /**
1547      * @dev Set whether or not the creator will check the extension for approval of token transfer
1548      */
1549     function setApproveTransfer(address creator, bool enabled) external;
1550 
1551     /**
1552      * @dev Called by creator contract to approve a transfer
1553      */
1554     function approveTransfer(address from, address to, uint256 tokenId) external returns (bool);
1555 }
1556 
1557 
1558 // File contracts/creator/extensions/ERC721/IERC721CreatorExtensionBurnable.sol
1559 
1560 
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 
1566 /**
1567  * @dev Your extension is required to implement this interface if it wishes
1568  * to receive the onBurn callback whenever a token the extension created is
1569  * burned
1570  */
1571 interface IERC721CreatorExtensionBurnable is IERC165 {
1572     /**
1573      * @dev callback handler for burn events
1574      */
1575     function onBurn(address owner, uint256 tokenId) external;
1576 }
1577 
1578 
1579 // File contracts/creator/permissions/ERC721/IERC721CreatorMintPermissions.sol
1580 
1581 
1582 
1583 pragma solidity ^0.8.0;
1584 
1585 
1586 
1587 /**
1588  * @dev Required interface of an ERC721Creator compliant extension contracts.
1589  */
1590 interface IERC721CreatorMintPermissions is IERC165 {
1591 
1592     /**
1593      * @dev get approval to mint
1594      */
1595     function approveMint(address extension, address to, uint256 tokenId) external;
1596 }
1597 
1598 
1599 // File contracts/creator/core/IERC721CreatorCore.sol
1600 
1601 
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 
1607 /**
1608  * @dev Core ERC721 creator interface
1609  */
1610 interface IERC721CreatorCore is ICreatorCore {
1611 
1612     /**
1613      * @dev mint a token with no extension. Can only be called by an admin.
1614      * Returns tokenId minted
1615      */
1616     function mintBase(address to) external returns (uint256);
1617 
1618     /**
1619      * @dev mint a token with no extension. Can only be called by an admin.
1620      * Returns tokenId minted
1621      */
1622     function mintBase(address to, string calldata uri) external returns (uint256);
1623 
1624     /**
1625      * @dev batch mint a token with no extension. Can only be called by an admin.
1626      * Returns tokenId minted
1627      */
1628     function mintBaseBatch(address to, uint16 count) external returns (uint256[] memory);
1629 
1630     /**
1631      * @dev batch mint a token with no extension. Can only be called by an admin.
1632      * Returns tokenId minted
1633      */
1634     function mintBaseBatch(address to, string[] calldata uris) external returns (uint256[] memory);
1635 
1636     /**
1637      * @dev mint a token. Can only be called by a registered extension.
1638      * Returns tokenId minted
1639      */
1640     function mintExtension(address to) external returns (uint256);
1641 
1642     /**
1643      * @dev mint a token. Can only be called by a registered extension.
1644      * Returns tokenId minted
1645      */
1646     function mintExtension(address to, string calldata uri) external returns (uint256);
1647 
1648     /**
1649      * @dev batch mint a token. Can only be called by a registered extension.
1650      * Returns tokenIds minted
1651      */
1652     function mintExtensionBatch(address to, uint16 count) external returns (uint256[] memory);
1653 
1654     /**
1655      * @dev batch mint a token. Can only be called by a registered extension.
1656      * Returns tokenId minted
1657      */
1658     function mintExtensionBatch(address to, string[] calldata uris) external returns (uint256[] memory);
1659 
1660     /**
1661      * @dev burn a token. Can only be called by token owner or approved address.
1662      * On burn, calls back to the registered extension's onBurn method
1663      */
1664     function burn(uint256 tokenId) external;
1665 
1666 }
1667 
1668 
1669 // File contracts/creator/core/ERC721CreatorCore.sol
1670 
1671 
1672 
1673 pragma solidity ^0.8.0;
1674 
1675 
1676 
1677 
1678 
1679 
1680 
1681 /**
1682  * @dev Core ERC721 creator implementation
1683  */
1684 abstract contract ERC721CreatorCore is CreatorCore, IERC721CreatorCore {
1685 
1686     using EnumerableSet for EnumerableSet.AddressSet;
1687 
1688     /**
1689      * @dev See {IERC165-supportsInterface}.
1690      */
1691     function supportsInterface(bytes4 interfaceId) public view virtual override(CreatorCore, IERC165) returns (bool) {
1692         return interfaceId == type(IERC721CreatorCore).interfaceId || super.supportsInterface(interfaceId);
1693     }
1694 
1695     /**
1696      * @dev See {ICreatorCore-setApproveTransferExtension}.
1697      */
1698     function setApproveTransferExtension(bool enabled) external override extensionRequired {
1699         require(!enabled || ERC165Checker.supportsInterface(msg.sender, type(IERC721CreatorExtensionApproveTransfer).interfaceId), "ERC721CreatorCore: Requires extension to implement IERC721CreatorExtensionApproveTransfer");
1700         if (_extensionApproveTransfers[msg.sender] != enabled) {
1701             _extensionApproveTransfers[msg.sender] = enabled;
1702             emit ExtensionApproveTransferUpdated(msg.sender, enabled);
1703         }
1704     }
1705 
1706     /**
1707      * @dev Set mint permissions for an extension
1708      */
1709     function _setMintPermissions(address extension, address permissions) internal {
1710         require(_extensions.contains(extension), "CreatorCore: Invalid extension");
1711         require(permissions == address(0x0) || ERC165Checker.supportsInterface(permissions, type(IERC721CreatorMintPermissions).interfaceId), "ERC721CreatorCore: Invalid address");
1712         if (_extensionPermissions[extension] != permissions) {
1713             _extensionPermissions[extension] = permissions;
1714             emit MintPermissionsUpdated(extension, permissions, msg.sender);
1715         }
1716     }
1717 
1718     /**
1719      * Check if an extension can mint
1720      */
1721     function _checkMintPermissions(address to, uint256 tokenId) internal {
1722         if (_extensionPermissions[msg.sender] != address(0x0)) {
1723             IERC721CreatorMintPermissions(_extensionPermissions[msg.sender]).approveMint(msg.sender, to, tokenId);
1724         }
1725     }
1726 
1727     /**
1728      * Override for post mint actions
1729      */
1730     function _postMintBase(address, uint256) internal virtual {}
1731 
1732     
1733     /**
1734      * Override for post mint actions
1735      */
1736     function _postMintExtension(address, uint256) internal virtual {}
1737 
1738     /**
1739      * Post-burning callback and metadata cleanup
1740      */
1741     function _postBurn(address owner, uint256 tokenId) internal virtual {
1742         // Callback to originating extension if needed
1743         if (_tokensExtension[tokenId] != address(this)) {
1744            if (ERC165Checker.supportsInterface(_tokensExtension[tokenId], type(IERC721CreatorExtensionBurnable).interfaceId)) {
1745                IERC721CreatorExtensionBurnable(_tokensExtension[tokenId]).onBurn(owner, tokenId);
1746            }
1747         }
1748         // Clear metadata (if any)
1749         if (bytes(_tokenURIs[tokenId]).length != 0) {
1750             delete _tokenURIs[tokenId];
1751         }    
1752         // Delete token origin extension tracking
1753         delete _tokensExtension[tokenId];    
1754     }
1755 
1756     /**
1757      * Approve a transfer
1758      */
1759     function _approveTransfer(address from, address to, uint256 tokenId) internal {
1760        if (_extensionApproveTransfers[_tokensExtension[tokenId]]) {
1761            require(IERC721CreatorExtensionApproveTransfer(_tokensExtension[tokenId]).approveTransfer(from, to, tokenId), "ERC721Creator: Extension approval failure");
1762        }
1763     }
1764 
1765 }
1766 
1767 
1768 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
1769 
1770 
1771 
1772 pragma solidity ^0.8.0;
1773 
1774 /**
1775  * @dev Required interface of an ERC721 compliant contract.
1776  */
1777 interface IERC721 is IERC165 {
1778     /**
1779      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1780      */
1781     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1782 
1783     /**
1784      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1785      */
1786     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1787 
1788     /**
1789      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1790      */
1791     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1792 
1793     /**
1794      * @dev Returns the number of tokens in ``owner``'s account.
1795      */
1796     function balanceOf(address owner) external view returns (uint256 balance);
1797 
1798     /**
1799      * @dev Returns the owner of the `tokenId` token.
1800      *
1801      * Requirements:
1802      *
1803      * - `tokenId` must exist.
1804      */
1805     function ownerOf(uint256 tokenId) external view returns (address owner);
1806 
1807     /**
1808      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1809      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1810      *
1811      * Requirements:
1812      *
1813      * - `from` cannot be the zero address.
1814      * - `to` cannot be the zero address.
1815      * - `tokenId` token must exist and be owned by `from`.
1816      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1818      *
1819      * Emits a {Transfer} event.
1820      */
1821     function safeTransferFrom(
1822         address from,
1823         address to,
1824         uint256 tokenId
1825     ) external;
1826 
1827     /**
1828      * @dev Transfers `tokenId` token from `from` to `to`.
1829      *
1830      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1831      *
1832      * Requirements:
1833      *
1834      * - `from` cannot be the zero address.
1835      * - `to` cannot be the zero address.
1836      * - `tokenId` token must be owned by `from`.
1837      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1838      *
1839      * Emits a {Transfer} event.
1840      */
1841     function transferFrom(
1842         address from,
1843         address to,
1844         uint256 tokenId
1845     ) external;
1846 
1847     /**
1848      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1849      * The approval is cleared when the token is transferred.
1850      *
1851      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1852      *
1853      * Requirements:
1854      *
1855      * - The caller must own the token or be an approved operator.
1856      * - `tokenId` must exist.
1857      *
1858      * Emits an {Approval} event.
1859      */
1860     function approve(address to, uint256 tokenId) external;
1861 
1862     /**
1863      * @dev Returns the account approved for `tokenId` token.
1864      *
1865      * Requirements:
1866      *
1867      * - `tokenId` must exist.
1868      */
1869     function getApproved(uint256 tokenId) external view returns (address operator);
1870 
1871     /**
1872      * @dev Approve or remove `operator` as an operator for the caller.
1873      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1874      *
1875      * Requirements:
1876      *
1877      * - The `operator` cannot be the caller.
1878      *
1879      * Emits an {ApprovalForAll} event.
1880      */
1881     function setApprovalForAll(address operator, bool _approved) external;
1882 
1883     /**
1884      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1885      *
1886      * See {setApprovalForAll}
1887      */
1888     function isApprovedForAll(address owner, address operator) external view returns (bool);
1889 
1890     /**
1891      * @dev Safely transfers `tokenId` token from `from` to `to`.
1892      *
1893      * Requirements:
1894      *
1895      * - `from` cannot be the zero address.
1896      * - `to` cannot be the zero address.
1897      * - `tokenId` token must exist and be owned by `from`.
1898      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function safeTransferFrom(
1904         address from,
1905         address to,
1906         uint256 tokenId,
1907         bytes calldata data
1908     ) external;
1909 }
1910 
1911 
1912 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
1913 
1914 
1915 
1916 pragma solidity ^0.8.0;
1917 
1918 /**
1919  * @title ERC721 token receiver interface
1920  * @dev Interface for any contract that wants to support safeTransfers
1921  * from ERC721 asset contracts.
1922  */
1923 interface IERC721Receiver {
1924     /**
1925      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1926      * by `operator` from `from`, this function is called.
1927      *
1928      * It must return its Solidity selector to confirm the token transfer.
1929      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1930      *
1931      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1932      */
1933     function onERC721Received(
1934         address operator,
1935         address from,
1936         uint256 tokenId,
1937         bytes calldata data
1938     ) external returns (bytes4);
1939 }
1940 
1941 
1942 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
1943 
1944 
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 /**
1949  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1950  * @dev See https://eips.ethereum.org/EIPS/eip-721
1951  */
1952 interface IERC721Metadata is IERC721 {
1953     /**
1954      * @dev Returns the token collection name.
1955      */
1956     function name() external view returns (string memory);
1957 
1958     /**
1959      * @dev Returns the token collection symbol.
1960      */
1961     function symbol() external view returns (string memory);
1962 
1963     /**
1964      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1965      */
1966     function tokenURI(uint256 tokenId) external view returns (string memory);
1967 }
1968 
1969 
1970 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
1971 
1972 
1973 
1974 pragma solidity ^0.8.0;
1975 
1976 /**
1977  * @dev Collection of functions related to the address type
1978  */
1979 library Address {
1980     /**
1981      * @dev Returns true if `account` is a contract.
1982      *
1983      * [IMPORTANT]
1984      * ====
1985      * It is unsafe to assume that an address for which this function returns
1986      * false is an externally-owned account (EOA) and not a contract.
1987      *
1988      * Among others, `isContract` will return false for the following
1989      * types of addresses:
1990      *
1991      *  - an externally-owned account
1992      *  - a contract in construction
1993      *  - an address where a contract will be created
1994      *  - an address where a contract lived, but was destroyed
1995      * ====
1996      */
1997     function isContract(address account) internal view returns (bool) {
1998         // This method relies on extcodesize, which returns 0 for contracts in
1999         // construction, since the code is only stored at the end of the
2000         // constructor execution.
2001 
2002         uint256 size;
2003         assembly {
2004             size := extcodesize(account)
2005         }
2006         return size > 0;
2007     }
2008 
2009     /**
2010      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2011      * `recipient`, forwarding all available gas and reverting on errors.
2012      *
2013      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2014      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2015      * imposed by `transfer`, making them unable to receive funds via
2016      * `transfer`. {sendValue} removes this limitation.
2017      *
2018      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2019      *
2020      * IMPORTANT: because control is transferred to `recipient`, care must be
2021      * taken to not create reentrancy vulnerabilities. Consider using
2022      * {ReentrancyGuard} or the
2023      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2024      */
2025     function sendValue(address payable recipient, uint256 amount) internal {
2026         require(address(this).balance >= amount, "Address: insufficient balance");
2027 
2028         (bool success, ) = recipient.call{value: amount}("");
2029         require(success, "Address: unable to send value, recipient may have reverted");
2030     }
2031 
2032     /**
2033      * @dev Performs a Solidity function call using a low level `call`. A
2034      * plain `call` is an unsafe replacement for a function call: use this
2035      * function instead.
2036      *
2037      * If `target` reverts with a revert reason, it is bubbled up by this
2038      * function (like regular Solidity function calls).
2039      *
2040      * Returns the raw returned data. To convert to the expected return value,
2041      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2042      *
2043      * Requirements:
2044      *
2045      * - `target` must be a contract.
2046      * - calling `target` with `data` must not revert.
2047      *
2048      * _Available since v3.1._
2049      */
2050     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2051         return functionCall(target, data, "Address: low-level call failed");
2052     }
2053 
2054     /**
2055      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2056      * `errorMessage` as a fallback revert reason when `target` reverts.
2057      *
2058      * _Available since v3.1._
2059      */
2060     function functionCall(
2061         address target,
2062         bytes memory data,
2063         string memory errorMessage
2064     ) internal returns (bytes memory) {
2065         return functionCallWithValue(target, data, 0, errorMessage);
2066     }
2067 
2068     /**
2069      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2070      * but also transferring `value` wei to `target`.
2071      *
2072      * Requirements:
2073      *
2074      * - the calling contract must have an ETH balance of at least `value`.
2075      * - the called Solidity function must be `payable`.
2076      *
2077      * _Available since v3.1._
2078      */
2079     function functionCallWithValue(
2080         address target,
2081         bytes memory data,
2082         uint256 value
2083     ) internal returns (bytes memory) {
2084         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2085     }
2086 
2087     /**
2088      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2089      * with `errorMessage` as a fallback revert reason when `target` reverts.
2090      *
2091      * _Available since v3.1._
2092      */
2093     function functionCallWithValue(
2094         address target,
2095         bytes memory data,
2096         uint256 value,
2097         string memory errorMessage
2098     ) internal returns (bytes memory) {
2099         require(address(this).balance >= value, "Address: insufficient balance for call");
2100         require(isContract(target), "Address: call to non-contract");
2101 
2102         (bool success, bytes memory returndata) = target.call{value: value}(data);
2103         return _verifyCallResult(success, returndata, errorMessage);
2104     }
2105 
2106     /**
2107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2108      * but performing a static call.
2109      *
2110      * _Available since v3.3._
2111      */
2112     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2113         return functionStaticCall(target, data, "Address: low-level static call failed");
2114     }
2115 
2116     /**
2117      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2118      * but performing a static call.
2119      *
2120      * _Available since v3.3._
2121      */
2122     function functionStaticCall(
2123         address target,
2124         bytes memory data,
2125         string memory errorMessage
2126     ) internal view returns (bytes memory) {
2127         require(isContract(target), "Address: static call to non-contract");
2128 
2129         (bool success, bytes memory returndata) = target.staticcall(data);
2130         return _verifyCallResult(success, returndata, errorMessage);
2131     }
2132 
2133     /**
2134      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2135      * but performing a delegate call.
2136      *
2137      * _Available since v3.4._
2138      */
2139     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2140         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2141     }
2142 
2143     /**
2144      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2145      * but performing a delegate call.
2146      *
2147      * _Available since v3.4._
2148      */
2149     function functionDelegateCall(
2150         address target,
2151         bytes memory data,
2152         string memory errorMessage
2153     ) internal returns (bytes memory) {
2154         require(isContract(target), "Address: delegate call to non-contract");
2155 
2156         (bool success, bytes memory returndata) = target.delegatecall(data);
2157         return _verifyCallResult(success, returndata, errorMessage);
2158     }
2159 
2160     function _verifyCallResult(
2161         bool success,
2162         bytes memory returndata,
2163         string memory errorMessage
2164     ) private pure returns (bytes memory) {
2165         if (success) {
2166             return returndata;
2167         } else {
2168             // Look for revert reason and bubble it up if present
2169             if (returndata.length > 0) {
2170                 // The easiest way to bubble the revert reason is using memory via assembly
2171 
2172                 assembly {
2173                     let returndata_size := mload(returndata)
2174                     revert(add(32, returndata), returndata_size)
2175                 }
2176             } else {
2177                 revert(errorMessage);
2178             }
2179         }
2180     }
2181 }
2182 
2183 
2184 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
2185 
2186 
2187 
2188 pragma solidity ^0.8.0;
2189 
2190 
2191 
2192 
2193 
2194 
2195 
2196 /**
2197  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2198  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2199  * {ERC721Enumerable}.
2200  */
2201 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2202     using Address for address;
2203     using Strings for uint256;
2204 
2205     // Token name
2206     string private _name;
2207 
2208     // Token symbol
2209     string private _symbol;
2210 
2211     // Mapping from token ID to owner address
2212     mapping(uint256 => address) private _owners;
2213 
2214     // Mapping owner address to token count
2215     mapping(address => uint256) private _balances;
2216 
2217     // Mapping from token ID to approved address
2218     mapping(uint256 => address) private _tokenApprovals;
2219 
2220     // Mapping from owner to operator approvals
2221     mapping(address => mapping(address => bool)) private _operatorApprovals;
2222 
2223     /**
2224      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2225      */
2226     constructor(string memory name_, string memory symbol_) {
2227         _name = name_;
2228         _symbol = symbol_;
2229     }
2230 
2231     /**
2232      * @dev See {IERC165-supportsInterface}.
2233      */
2234     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2235         return
2236             interfaceId == type(IERC721).interfaceId ||
2237             interfaceId == type(IERC721Metadata).interfaceId ||
2238             super.supportsInterface(interfaceId);
2239     }
2240 
2241     /**
2242      * @dev See {IERC721-balanceOf}.
2243      */
2244     function balanceOf(address owner) public view virtual override returns (uint256) {
2245         require(owner != address(0), "ERC721: balance query for the zero address");
2246         return _balances[owner];
2247     }
2248 
2249     /**
2250      * @dev See {IERC721-ownerOf}.
2251      */
2252     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2253         address owner = _owners[tokenId];
2254         require(owner != address(0), "ERC721: owner query for nonexistent token");
2255         return owner;
2256     }
2257 
2258     /**
2259      * @dev See {IERC721Metadata-name}.
2260      */
2261     function name() public view virtual override returns (string memory) {
2262         return _name;
2263     }
2264 
2265     /**
2266      * @dev See {IERC721Metadata-symbol}.
2267      */
2268     function symbol() public view virtual override returns (string memory) {
2269         return _symbol;
2270     }
2271 
2272     /**
2273      * @dev See {IERC721Metadata-tokenURI}.
2274      */
2275     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2276         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2277 
2278         string memory baseURI = _baseURI();
2279         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2280     }
2281 
2282     /**
2283      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2284      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2285      * by default, can be overriden in child contracts.
2286      */
2287     function _baseURI() internal view virtual returns (string memory) {
2288         return "";
2289     }
2290 
2291     /**
2292      * @dev See {IERC721-approve}.
2293      */
2294     function approve(address to, uint256 tokenId) public virtual override {
2295         address owner = ERC721.ownerOf(tokenId);
2296         require(to != owner, "ERC721: approval to current owner");
2297 
2298         require(
2299             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2300             "ERC721: approve caller is not owner nor approved for all"
2301         );
2302 
2303         _approve(to, tokenId);
2304     }
2305 
2306     /**
2307      * @dev See {IERC721-getApproved}.
2308      */
2309     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2310         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2311 
2312         return _tokenApprovals[tokenId];
2313     }
2314 
2315     /**
2316      * @dev See {IERC721-setApprovalForAll}.
2317      */
2318     function setApprovalForAll(address operator, bool approved) public virtual override {
2319         require(operator != _msgSender(), "ERC721: approve to caller");
2320 
2321         _operatorApprovals[_msgSender()][operator] = approved;
2322         emit ApprovalForAll(_msgSender(), operator, approved);
2323     }
2324 
2325     /**
2326      * @dev See {IERC721-isApprovedForAll}.
2327      */
2328     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2329         return _operatorApprovals[owner][operator];
2330     }
2331 
2332     /**
2333      * @dev See {IERC721-transferFrom}.
2334      */
2335     function transferFrom(
2336         address from,
2337         address to,
2338         uint256 tokenId
2339     ) public virtual override {
2340         //solhint-disable-next-line max-line-length
2341         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2342 
2343         _transfer(from, to, tokenId);
2344     }
2345 
2346     /**
2347      * @dev See {IERC721-safeTransferFrom}.
2348      */
2349     function safeTransferFrom(
2350         address from,
2351         address to,
2352         uint256 tokenId
2353     ) public virtual override {
2354         safeTransferFrom(from, to, tokenId, "");
2355     }
2356 
2357     /**
2358      * @dev See {IERC721-safeTransferFrom}.
2359      */
2360     function safeTransferFrom(
2361         address from,
2362         address to,
2363         uint256 tokenId,
2364         bytes memory _data
2365     ) public virtual override {
2366         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2367         _safeTransfer(from, to, tokenId, _data);
2368     }
2369 
2370     /**
2371      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2372      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2373      *
2374      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2375      *
2376      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2377      * implement alternative mechanisms to perform token transfer, such as signature-based.
2378      *
2379      * Requirements:
2380      *
2381      * - `from` cannot be the zero address.
2382      * - `to` cannot be the zero address.
2383      * - `tokenId` token must exist and be owned by `from`.
2384      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2385      *
2386      * Emits a {Transfer} event.
2387      */
2388     function _safeTransfer(
2389         address from,
2390         address to,
2391         uint256 tokenId,
2392         bytes memory _data
2393     ) internal virtual {
2394         _transfer(from, to, tokenId);
2395         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2396     }
2397 
2398     /**
2399      * @dev Returns whether `tokenId` exists.
2400      *
2401      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2402      *
2403      * Tokens start existing when they are minted (`_mint`),
2404      * and stop existing when they are burned (`_burn`).
2405      */
2406     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2407         return _owners[tokenId] != address(0);
2408     }
2409 
2410     /**
2411      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2412      *
2413      * Requirements:
2414      *
2415      * - `tokenId` must exist.
2416      */
2417     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2418         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2419         address owner = ERC721.ownerOf(tokenId);
2420         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2421     }
2422 
2423     /**
2424      * @dev Safely mints `tokenId` and transfers it to `to`.
2425      *
2426      * Requirements:
2427      *
2428      * - `tokenId` must not exist.
2429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2430      *
2431      * Emits a {Transfer} event.
2432      */
2433     function _safeMint(address to, uint256 tokenId) internal virtual {
2434         _safeMint(to, tokenId, "");
2435     }
2436 
2437     /**
2438      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2439      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2440      */
2441     function _safeMint(
2442         address to,
2443         uint256 tokenId,
2444         bytes memory _data
2445     ) internal virtual {
2446         _mint(to, tokenId);
2447         require(
2448             _checkOnERC721Received(address(0), to, tokenId, _data),
2449             "ERC721: transfer to non ERC721Receiver implementer"
2450         );
2451     }
2452 
2453     /**
2454      * @dev Mints `tokenId` and transfers it to `to`.
2455      *
2456      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2457      *
2458      * Requirements:
2459      *
2460      * - `tokenId` must not exist.
2461      * - `to` cannot be the zero address.
2462      *
2463      * Emits a {Transfer} event.
2464      */
2465     function _mint(address to, uint256 tokenId) internal virtual {
2466         require(to != address(0), "ERC721: mint to the zero address");
2467         require(!_exists(tokenId), "ERC721: token already minted");
2468 
2469         _beforeTokenTransfer(address(0), to, tokenId);
2470 
2471         _balances[to] += 1;
2472         _owners[tokenId] = to;
2473 
2474         emit Transfer(address(0), to, tokenId);
2475     }
2476 
2477     /**
2478      * @dev Destroys `tokenId`.
2479      * The approval is cleared when the token is burned.
2480      *
2481      * Requirements:
2482      *
2483      * - `tokenId` must exist.
2484      *
2485      * Emits a {Transfer} event.
2486      */
2487     function _burn(uint256 tokenId) internal virtual {
2488         address owner = ERC721.ownerOf(tokenId);
2489 
2490         _beforeTokenTransfer(owner, address(0), tokenId);
2491 
2492         // Clear approvals
2493         _approve(address(0), tokenId);
2494 
2495         _balances[owner] -= 1;
2496         delete _owners[tokenId];
2497 
2498         emit Transfer(owner, address(0), tokenId);
2499     }
2500 
2501     /**
2502      * @dev Transfers `tokenId` from `from` to `to`.
2503      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2504      *
2505      * Requirements:
2506      *
2507      * - `to` cannot be the zero address.
2508      * - `tokenId` token must be owned by `from`.
2509      *
2510      * Emits a {Transfer} event.
2511      */
2512     function _transfer(
2513         address from,
2514         address to,
2515         uint256 tokenId
2516     ) internal virtual {
2517         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2518         require(to != address(0), "ERC721: transfer to the zero address");
2519 
2520         _beforeTokenTransfer(from, to, tokenId);
2521 
2522         // Clear approvals from the previous owner
2523         _approve(address(0), tokenId);
2524 
2525         _balances[from] -= 1;
2526         _balances[to] += 1;
2527         _owners[tokenId] = to;
2528 
2529         emit Transfer(from, to, tokenId);
2530     }
2531 
2532     /**
2533      * @dev Approve `to` to operate on `tokenId`
2534      *
2535      * Emits a {Approval} event.
2536      */
2537     function _approve(address to, uint256 tokenId) internal virtual {
2538         _tokenApprovals[tokenId] = to;
2539         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2540     }
2541 
2542     /**
2543      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2544      * The call is not executed if the target address is not a contract.
2545      *
2546      * @param from address representing the previous owner of the given token ID
2547      * @param to target address that will receive the tokens
2548      * @param tokenId uint256 ID of the token to be transferred
2549      * @param _data bytes optional data to send along with the call
2550      * @return bool whether the call correctly returned the expected magic value
2551      */
2552     function _checkOnERC721Received(
2553         address from,
2554         address to,
2555         uint256 tokenId,
2556         bytes memory _data
2557     ) private returns (bool) {
2558         if (to.isContract()) {
2559             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2560                 return retval == IERC721Receiver(to).onERC721Received.selector;
2561             } catch (bytes memory reason) {
2562                 if (reason.length == 0) {
2563                     revert("ERC721: transfer to non ERC721Receiver implementer");
2564                 } else {
2565                     assembly {
2566                         revert(add(32, reason), mload(reason))
2567                     }
2568                 }
2569             }
2570         } else {
2571             return true;
2572         }
2573     }
2574 
2575     /**
2576      * @dev Hook that is called before any token transfer. This includes minting
2577      * and burning.
2578      *
2579      * Calling conditions:
2580      *
2581      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2582      * transferred to `to`.
2583      * - When `from` is zero, `tokenId` will be minted for `to`.
2584      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2585      * - `from` and `to` are never both zero.
2586      *
2587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2588      */
2589     function _beforeTokenTransfer(
2590         address from,
2591         address to,
2592         uint256 tokenId
2593     ) internal virtual {}
2594 }
2595 
2596 
2597 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
2598 
2599 
2600 
2601 pragma solidity ^0.8.0;
2602 
2603 /**
2604  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2605  * @dev See https://eips.ethereum.org/EIPS/eip-721
2606  */
2607 interface IERC721Enumerable is IERC721 {
2608     /**
2609      * @dev Returns the total amount of tokens stored by the contract.
2610      */
2611     function totalSupply() external view returns (uint256);
2612 
2613     /**
2614      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2615      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2616      */
2617     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2618 
2619     /**
2620      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2621      * Use along with {totalSupply} to enumerate all tokens.
2622      */
2623     function tokenByIndex(uint256 index) external view returns (uint256);
2624 }
2625 
2626 
2627 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
2628 
2629 
2630 
2631 pragma solidity ^0.8.0;
2632 
2633 
2634 /**
2635  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2636  * enumerability of all the token ids in the contract as well as all token ids owned by each
2637  * account.
2638  */
2639 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2640     // Mapping from owner to list of owned token IDs
2641     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2642 
2643     // Mapping from token ID to index of the owner tokens list
2644     mapping(uint256 => uint256) private _ownedTokensIndex;
2645 
2646     // Array with all token ids, used for enumeration
2647     uint256[] private _allTokens;
2648 
2649     // Mapping from token id to position in the allTokens array
2650     mapping(uint256 => uint256) private _allTokensIndex;
2651 
2652     /**
2653      * @dev See {IERC165-supportsInterface}.
2654      */
2655     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2656         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2657     }
2658 
2659     /**
2660      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2661      */
2662     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2663         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2664         return _ownedTokens[owner][index];
2665     }
2666 
2667     /**
2668      * @dev See {IERC721Enumerable-totalSupply}.
2669      */
2670     function totalSupply() public view virtual override returns (uint256) {
2671         return _allTokens.length;
2672     }
2673 
2674     /**
2675      * @dev See {IERC721Enumerable-tokenByIndex}.
2676      */
2677     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2678         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2679         return _allTokens[index];
2680     }
2681 
2682     /**
2683      * @dev Hook that is called before any token transfer. This includes minting
2684      * and burning.
2685      *
2686      * Calling conditions:
2687      *
2688      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2689      * transferred to `to`.
2690      * - When `from` is zero, `tokenId` will be minted for `to`.
2691      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2692      * - `from` cannot be the zero address.
2693      * - `to` cannot be the zero address.
2694      *
2695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2696      */
2697     function _beforeTokenTransfer(
2698         address from,
2699         address to,
2700         uint256 tokenId
2701     ) internal virtual override {
2702         super._beforeTokenTransfer(from, to, tokenId);
2703 
2704         if (from == address(0)) {
2705             _addTokenToAllTokensEnumeration(tokenId);
2706         } else if (from != to) {
2707             _removeTokenFromOwnerEnumeration(from, tokenId);
2708         }
2709         if (to == address(0)) {
2710             _removeTokenFromAllTokensEnumeration(tokenId);
2711         } else if (to != from) {
2712             _addTokenToOwnerEnumeration(to, tokenId);
2713         }
2714     }
2715 
2716     /**
2717      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2718      * @param to address representing the new owner of the given token ID
2719      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2720      */
2721     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2722         uint256 length = ERC721.balanceOf(to);
2723         _ownedTokens[to][length] = tokenId;
2724         _ownedTokensIndex[tokenId] = length;
2725     }
2726 
2727     /**
2728      * @dev Private function to add a token to this extension's token tracking data structures.
2729      * @param tokenId uint256 ID of the token to be added to the tokens list
2730      */
2731     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2732         _allTokensIndex[tokenId] = _allTokens.length;
2733         _allTokens.push(tokenId);
2734     }
2735 
2736     /**
2737      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2738      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2739      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2740      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2741      * @param from address representing the previous owner of the given token ID
2742      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2743      */
2744     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2745         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2746         // then delete the last slot (swap and pop).
2747 
2748         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2749         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2750 
2751         // When the token to delete is the last token, the swap operation is unnecessary
2752         if (tokenIndex != lastTokenIndex) {
2753             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2754 
2755             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2756             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2757         }
2758 
2759         // This also deletes the contents at the last position of the array
2760         delete _ownedTokensIndex[tokenId];
2761         delete _ownedTokens[from][lastTokenIndex];
2762     }
2763 
2764     /**
2765      * @dev Private function to remove a token from this extension's token tracking data structures.
2766      * This has O(1) time complexity, but alters the order of the _allTokens array.
2767      * @param tokenId uint256 ID of the token to be removed from the tokens list
2768      */
2769     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2770         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2771         // then delete the last slot (swap and pop).
2772 
2773         uint256 lastTokenIndex = _allTokens.length - 1;
2774         uint256 tokenIndex = _allTokensIndex[tokenId];
2775 
2776         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2777         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2778         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2779         uint256 lastTokenId = _allTokens[lastTokenIndex];
2780 
2781         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2782         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2783 
2784         // This also deletes the contents at the last position of the array
2785         delete _allTokensIndex[tokenId];
2786         _allTokens.pop();
2787     }
2788 }
2789 
2790 
2791 // File contracts/creator/ERC721Creator.sol
2792 
2793 
2794 
2795 pragma solidity ^0.8.0;
2796 
2797 
2798 
2799 
2800 /**
2801  * @dev ERC721Creator implementation
2802  */
2803 contract ERC721Creator is AdminControl, ERC721Enumerable, ERC721CreatorCore {
2804 
2805     constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
2806     }
2807 
2808     /**
2809      * @dev See {IERC165-supportsInterface}.
2810      */
2811     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721CreatorCore, AdminControl) returns (bool) {
2812         return ERC721CreatorCore.supportsInterface(interfaceId) || ERC721.supportsInterface(interfaceId) || AdminControl.supportsInterface(interfaceId);
2813     }
2814 
2815     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2816         _approveTransfer(from, to, tokenId);    
2817     }
2818 
2819     /**
2820      * @dev See {ICreatorCore-registerExtension}.
2821      */
2822     function registerExtension(address extension, string calldata baseURI) external override adminRequired nonBlacklistRequired(extension) {
2823         _registerExtension(extension, baseURI, false);
2824     }
2825 
2826     /**
2827      * @dev See {ICreatorCore-registerExtension}.
2828      */
2829     function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external override adminRequired nonBlacklistRequired(extension) {
2830         _registerExtension(extension, baseURI, baseURIIdentical);
2831     }
2832 
2833 
2834     /**
2835      * @dev See {ICreatorCore-unregisterExtension}.
2836      */
2837     function unregisterExtension(address extension) external override adminRequired {
2838         _unregisterExtension(extension);
2839     }
2840 
2841     /**
2842      * @dev See {ICreatorCore-blacklistExtension}.
2843      */
2844     function blacklistExtension(address extension) external override adminRequired {
2845         _blacklistExtension(extension);
2846     }
2847 
2848     /**
2849      * @dev See {ICreatorCore-setBaseTokenURIExtension}.
2850      */
2851     function setBaseTokenURIExtension(string calldata uri) external override extensionRequired {
2852         _setBaseTokenURIExtension(uri, false);
2853     }
2854 
2855     /**
2856      * @dev See {ICreatorCore-setBaseTokenURIExtension}.
2857      */
2858     function setBaseTokenURIExtension(string calldata uri, bool identical) external override extensionRequired {
2859         _setBaseTokenURIExtension(uri, identical);
2860     }
2861 
2862     /**
2863      * @dev See {ICreatorCore-setTokenURIPrefixExtension}.
2864      */
2865     function setTokenURIPrefixExtension(string calldata prefix) external override extensionRequired {
2866         _setTokenURIPrefixExtension(prefix);
2867     }
2868 
2869     /**
2870      * @dev See {ICreatorCore-setTokenURIExtension}.
2871      */
2872     function setTokenURIExtension(uint256 tokenId, string calldata uri) external override extensionRequired {
2873         _setTokenURIExtension(tokenId, uri);
2874     }
2875 
2876     /**
2877      * @dev See {ICreatorCore-setTokenURIExtension}.
2878      */
2879     function setTokenURIExtension(uint256[] memory tokenIds, string[] calldata uris) external override extensionRequired {
2880         require(tokenIds.length == uris.length, "ERC721Creator: Invalid input");
2881         for (uint i = 0; i < tokenIds.length; i++) {
2882             _setTokenURIExtension(tokenIds[i], uris[i]);            
2883         }
2884     }
2885 
2886     /**
2887      * @dev See {ICreatorCore-setBaseTokenURI}.
2888      */
2889     function setBaseTokenURI(string calldata uri) external override adminRequired {
2890         _setBaseTokenURI(uri);
2891     }
2892 
2893     /**
2894      * @dev See {ICreatorCore-setTokenURIPrefix}.
2895      */
2896     function setTokenURIPrefix(string calldata prefix) external override adminRequired {
2897         _setTokenURIPrefix(prefix);
2898     }
2899 
2900     /**
2901      * @dev See {ICreatorCore-setTokenURI}.
2902      */
2903     function setTokenURI(uint256 tokenId, string calldata uri) external override adminRequired {
2904         _setTokenURI(tokenId, uri);
2905     }
2906 
2907     /**
2908      * @dev See {ICreatorCore-setTokenURI}.
2909      */
2910     function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external override adminRequired {
2911         require(tokenIds.length == uris.length, "ERC721Creator: Invalid input");
2912         for (uint i = 0; i < tokenIds.length; i++) {
2913             _setTokenURI(tokenIds[i], uris[i]);            
2914         }
2915     }
2916 
2917     /**
2918      * @dev See {ICreatorCore-setMintPermissions}.
2919      */
2920     function setMintPermissions(address extension, address permissions) external override adminRequired {
2921         _setMintPermissions(extension, permissions);
2922     }
2923 
2924     /**
2925      * @dev See {IERC721CreatorCore-mintBase}.
2926      */
2927     function mintBase(address to) public virtual override nonReentrant adminRequired returns(uint256) {
2928         return _mintBase(to, "");
2929     }
2930 
2931     /**
2932      * @dev See {IERC721CreatorCore-mintBase}.
2933      */
2934     function mintBase(address to, string calldata uri) public virtual override nonReentrant adminRequired returns(uint256) {
2935         return _mintBase(to, uri);
2936     }
2937 
2938     /**
2939      * @dev See {IERC721CreatorCore-mintBaseBatch}.
2940      */
2941     function mintBaseBatch(address to, uint16 count) public virtual override nonReentrant adminRequired returns(uint256[] memory tokenIds) {
2942         tokenIds = new uint256[](count);
2943         for (uint16 i = 0; i < count; i++) {
2944             tokenIds[i] = _mintBase(to, "");
2945         }
2946         return tokenIds;
2947     }
2948 
2949     /**
2950      * @dev See {IERC721CreatorCore-mintBaseBatch}.
2951      */
2952     function mintBaseBatch(address to, string[] calldata uris) public virtual override nonReentrant adminRequired returns(uint256[] memory tokenIds) {
2953         tokenIds = new uint256[](uris.length);
2954         for (uint i = 0; i < uris.length; i++) {
2955             tokenIds[i] = _mintBase(to, uris[i]);
2956         }
2957         return tokenIds;
2958     }
2959 
2960     /**
2961      * @dev Mint token with no extension
2962      */
2963     function _mintBase(address to, string memory uri) internal virtual returns(uint256 tokenId) {
2964         _tokenCount++;
2965         tokenId = _tokenCount;
2966 
2967         // Track the extension that minted the token
2968         _tokensExtension[tokenId] = address(this);
2969 
2970         _safeMint(to, tokenId);
2971 
2972         if (bytes(uri).length > 0) {
2973             _tokenURIs[tokenId] = uri;
2974         }
2975 
2976         // Call post mint
2977         _postMintBase(to, tokenId);
2978         return tokenId;
2979     }
2980 
2981 
2982     /**
2983      * @dev See {IERC721CreatorCore-mintExtension}.
2984      */
2985     function mintExtension(address to) public virtual override nonReentrant extensionRequired returns(uint256) {
2986         return _mintExtension(to, "");
2987     }
2988 
2989     /**
2990      * @dev See {IERC721CreatorCore-mintExtension}.
2991      */
2992     function mintExtension(address to, string calldata uri) public virtual override nonReentrant extensionRequired returns(uint256) {
2993         return _mintExtension(to, uri);
2994     }
2995 
2996     /**
2997      * @dev See {IERC721CreatorCore-mintExtensionBatch}.
2998      */
2999     function mintExtensionBatch(address to, uint16 count) public virtual override nonReentrant extensionRequired returns(uint256[] memory tokenIds) {
3000         tokenIds = new uint256[](count);
3001         for (uint16 i = 0; i < count; i++) {
3002             tokenIds[i] = _mintExtension(to, "");
3003         }
3004         return tokenIds;
3005     }
3006 
3007     /**
3008      * @dev See {IERC721CreatorCore-mintExtensionBatch}.
3009      */
3010     function mintExtensionBatch(address to, string[] calldata uris) public virtual override nonReentrant extensionRequired returns(uint256[] memory tokenIds) {
3011         tokenIds = new uint256[](uris.length);
3012         for (uint i = 0; i < uris.length; i++) {
3013             tokenIds[i] = _mintExtension(to, uris[i]);
3014         }
3015     }
3016     
3017     /**
3018      * @dev Mint token via extension
3019      */
3020     function _mintExtension(address to, string memory uri) internal virtual returns(uint256 tokenId) {
3021         _tokenCount++;
3022         tokenId = _tokenCount;
3023 
3024         _checkMintPermissions(to, tokenId);
3025 
3026         // Track the extension that minted the token
3027         _tokensExtension[tokenId] = msg.sender;
3028 
3029         _safeMint(to, tokenId);
3030 
3031         if (bytes(uri).length > 0) {
3032             _tokenURIs[tokenId] = uri;
3033         }
3034         
3035         // Call post mint
3036         _postMintExtension(to, tokenId);
3037         return tokenId;
3038     }
3039 
3040     /**
3041      * @dev See {IERC721CreatorCore-tokenExtension}.
3042      */
3043     function tokenExtension(uint256 tokenId) public view virtual override returns (address) {
3044         require(_exists(tokenId), "Nonexistent token");
3045         return _tokenExtension(tokenId);
3046     }
3047 
3048     /**
3049      * @dev See {IERC721CreatorCore-burn}.
3050      */
3051     function burn(uint256 tokenId) public virtual override nonReentrant {
3052         require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Creator: caller is not owner nor approved");
3053         address owner = ownerOf(tokenId);
3054         _burn(tokenId);
3055         _postBurn(owner, tokenId);
3056     }
3057 
3058     /**
3059      * @dev See {ICreatorCore-setRoyalties}.
3060      */
3061     function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
3062         _setRoyaltiesExtension(address(this), receivers, basisPoints);
3063     }
3064 
3065     /**
3066      * @dev See {ICreatorCore-setRoyalties}.
3067      */
3068     function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
3069         require(_exists(tokenId), "Nonexistent token");
3070         _setRoyalties(tokenId, receivers, basisPoints);
3071     }
3072 
3073     /**
3074      * @dev See {ICreatorCore-setRoyaltiesExtension}.
3075      */
3076     function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
3077         _setRoyaltiesExtension(extension, receivers, basisPoints);
3078     }
3079 
3080     /**
3081      * @dev {See ICreatorCore-getRoyalties}.
3082      */
3083     function getRoyalties(uint256 tokenId) external view virtual override returns (address payable[] memory, uint256[] memory) {
3084         require(_exists(tokenId), "Nonexistent token");
3085         return _getRoyalties(tokenId);
3086     }
3087 
3088     /**
3089      * @dev {See ICreatorCore-getFees}.
3090      */
3091     function getFees(uint256 tokenId) external view virtual override returns (address payable[] memory, uint256[] memory) {
3092         require(_exists(tokenId), "Nonexistent token");
3093         return _getRoyalties(tokenId);
3094     }
3095 
3096     /**
3097      * @dev {See ICreatorCore-getFeeRecipients}.
3098      */
3099     function getFeeRecipients(uint256 tokenId) external view virtual override returns (address payable[] memory) {
3100         require(_exists(tokenId), "Nonexistent token");
3101         return _getRoyaltyReceivers(tokenId);
3102     }
3103 
3104     /**
3105      * @dev {See ICreatorCore-getFeeBps}.
3106      */
3107     function getFeeBps(uint256 tokenId) external view virtual override returns (uint[] memory) {
3108         require(_exists(tokenId), "Nonexistent token");
3109         return _getRoyaltyBPS(tokenId);
3110     }
3111     
3112     /**
3113      * @dev {See ICreatorCore-royaltyInfo}.
3114      */
3115     function royaltyInfo(uint256 tokenId, uint256 value, bytes calldata) external view virtual override returns (address, uint256, bytes memory) {
3116         require(_exists(tokenId), "Nonexistent token");
3117         return _getRoyaltyInfo(tokenId, value);
3118     } 
3119 
3120     /**
3121      * @dev See {IERC721Metadata-tokenURI}.
3122      */
3123     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3124         require(_exists(tokenId), "Nonexistent token");
3125         return _tokenURI(tokenId);
3126     }
3127     
3128 }
3129 
3130 
3131 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
3132 
3133 
3134 
3135 pragma solidity ^0.8.0;
3136 
3137 // CAUTION
3138 // This version of SafeMath should only be used with Solidity 0.8 or later,
3139 // because it relies on the compiler's built in overflow checks.
3140 
3141 /**
3142  * @dev Wrappers over Solidity's arithmetic operations.
3143  *
3144  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
3145  * now has built in overflow checking.
3146  */
3147 library SafeMath {
3148     /**
3149      * @dev Returns the addition of two unsigned integers, with an overflow flag.
3150      *
3151      * _Available since v3.4._
3152      */
3153     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3154         unchecked {
3155             uint256 c = a + b;
3156             if (c < a) return (false, 0);
3157             return (true, c);
3158         }
3159     }
3160 
3161     /**
3162      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
3163      *
3164      * _Available since v3.4._
3165      */
3166     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3167         unchecked {
3168             if (b > a) return (false, 0);
3169             return (true, a - b);
3170         }
3171     }
3172 
3173     /**
3174      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
3175      *
3176      * _Available since v3.4._
3177      */
3178     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3179         unchecked {
3180             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
3181             // benefit is lost if 'b' is also tested.
3182             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
3183             if (a == 0) return (true, 0);
3184             uint256 c = a * b;
3185             if (c / a != b) return (false, 0);
3186             return (true, c);
3187         }
3188     }
3189 
3190     /**
3191      * @dev Returns the division of two unsigned integers, with a division by zero flag.
3192      *
3193      * _Available since v3.4._
3194      */
3195     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3196         unchecked {
3197             if (b == 0) return (false, 0);
3198             return (true, a / b);
3199         }
3200     }
3201 
3202     /**
3203      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
3204      *
3205      * _Available since v3.4._
3206      */
3207     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3208         unchecked {
3209             if (b == 0) return (false, 0);
3210             return (true, a % b);
3211         }
3212     }
3213 
3214     /**
3215      * @dev Returns the addition of two unsigned integers, reverting on
3216      * overflow.
3217      *
3218      * Counterpart to Solidity's `+` operator.
3219      *
3220      * Requirements:
3221      *
3222      * - Addition cannot overflow.
3223      */
3224     function add(uint256 a, uint256 b) internal pure returns (uint256) {
3225         return a + b;
3226     }
3227 
3228     /**
3229      * @dev Returns the subtraction of two unsigned integers, reverting on
3230      * overflow (when the result is negative).
3231      *
3232      * Counterpart to Solidity's `-` operator.
3233      *
3234      * Requirements:
3235      *
3236      * - Subtraction cannot overflow.
3237      */
3238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3239         return a - b;
3240     }
3241 
3242     /**
3243      * @dev Returns the multiplication of two unsigned integers, reverting on
3244      * overflow.
3245      *
3246      * Counterpart to Solidity's `*` operator.
3247      *
3248      * Requirements:
3249      *
3250      * - Multiplication cannot overflow.
3251      */
3252     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3253         return a * b;
3254     }
3255 
3256     /**
3257      * @dev Returns the integer division of two unsigned integers, reverting on
3258      * division by zero. The result is rounded towards zero.
3259      *
3260      * Counterpart to Solidity's `/` operator.
3261      *
3262      * Requirements:
3263      *
3264      * - The divisor cannot be zero.
3265      */
3266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3267         return a / b;
3268     }
3269 
3270     /**
3271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3272      * reverting when dividing by zero.
3273      *
3274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3275      * opcode (which leaves remaining gas untouched) while Solidity uses an
3276      * invalid opcode to revert (consuming all remaining gas).
3277      *
3278      * Requirements:
3279      *
3280      * - The divisor cannot be zero.
3281      */
3282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
3283         return a % b;
3284     }
3285 
3286     /**
3287      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
3288      * overflow (when the result is negative).
3289      *
3290      * CAUTION: This function is deprecated because it requires allocating memory for the error
3291      * message unnecessarily. For custom revert reasons use {trySub}.
3292      *
3293      * Counterpart to Solidity's `-` operator.
3294      *
3295      * Requirements:
3296      *
3297      * - Subtraction cannot overflow.
3298      */
3299     function sub(
3300         uint256 a,
3301         uint256 b,
3302         string memory errorMessage
3303     ) internal pure returns (uint256) {
3304         unchecked {
3305             require(b <= a, errorMessage);
3306             return a - b;
3307         }
3308     }
3309 
3310     /**
3311      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
3312      * division by zero. The result is rounded towards zero.
3313      *
3314      * Counterpart to Solidity's `/` operator. Note: this function uses a
3315      * `revert` opcode (which leaves remaining gas untouched) while Solidity
3316      * uses an invalid opcode to revert (consuming all remaining gas).
3317      *
3318      * Requirements:
3319      *
3320      * - The divisor cannot be zero.
3321      */
3322     function div(
3323         uint256 a,
3324         uint256 b,
3325         string memory errorMessage
3326     ) internal pure returns (uint256) {
3327         unchecked {
3328             require(b > 0, errorMessage);
3329             return a / b;
3330         }
3331     }
3332 
3333     /**
3334      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3335      * reverting with custom message when dividing by zero.
3336      *
3337      * CAUTION: This function is deprecated because it requires allocating memory for the error
3338      * message unnecessarily. For custom revert reasons use {tryMod}.
3339      *
3340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3341      * opcode (which leaves remaining gas untouched) while Solidity uses an
3342      * invalid opcode to revert (consuming all remaining gas).
3343      *
3344      * Requirements:
3345      *
3346      * - The divisor cannot be zero.
3347      */
3348     function mod(
3349         uint256 a,
3350         uint256 b,
3351         string memory errorMessage
3352     ) internal pure returns (uint256) {
3353         unchecked {
3354             require(b > 0, errorMessage);
3355             return a % b;
3356         }
3357     }
3358 }
3359 
3360 
3361 // File contracts/GrayCraft2.sol
3362 
3363 pragma solidity ^0.8.0;
3364 
3365 
3366 contract GRAYCRAFT2 is ERC721Creator {
3367     using SafeMath for uint256;
3368     string public constant GRAYCRAFT_PROVENANCE = "9128513b2c6a083408da8815a69ab3c617c2116350b790ac6ab299aeef2e3d4d";
3369     address public constant GRAYCRAFT_ADDRESS = 0x9030807ba4C71831808408CbF892bfA1261A6E7D; // GrayCraft 1 address
3370     uint256 public constant CRAFT_PRICE = 80000000000000000; // 0.08 ETH
3371     uint256 public constant MAX_CRAFT_PURCHASE = 20; // max purchase per txn
3372     uint256 public constant EXCLUSIVE_EXPIRY_DATE = 1633003200; // 30th Sep 2021
3373     uint256 public constant MAX_GRAYCRAFT = 10000; // max of 10,000 Gray Craft 2
3374 
3375     bool public saleIsActive = false; // determines whether sales is active
3376     uint256 reservedGrayCraft = 500; // reserved for owner/giveaway
3377     uint256 exclusiveOwnership = 77; // reserved for graycraft 1 owners
3378     mapping (uint256 => bool) exclusiveClaim; // tokenId => hasClaimed
3379 
3380     event AssetMinted(uint256 indexed tokenId, address owner);
3381 
3382     constructor() ERC721Creator("GRAYCRAFT2", "GRAY2") {}
3383 
3384     /* ========== External public sales functions ========== */
3385 
3386     // @dev give away exclusive supply to owners of GrayCraft1
3387     function claimExclusive(uint256 tokenId) external nonReentrant {
3388         require(saleIsActive); // Sale must be active
3389         require(exclusiveOwnership > 0); // Exceeds exclusive ownership supply
3390         require(!exclusiveClaim[tokenId], "Has claimed before");
3391         require(ERC721(GRAYCRAFT_ADDRESS).ownerOf(tokenId) == msg.sender); // Not authorised
3392 
3393         exclusiveClaim[tokenId] = true;
3394 
3395         _mintBase(msg.sender, Strings.toString(_tokenCount+1));
3396         emit AssetMinted(_tokenCount, msg.sender);
3397 
3398         exclusiveOwnership = exclusiveOwnership.sub(1);
3399     }
3400 
3401     // @dev mints graycrafts for the general public
3402     function mintGraycraft(uint numberOfTokens) external payable {
3403         require(saleIsActive); // Sale must be active
3404         require(numberOfTokens <= MAX_CRAFT_PURCHASE); // Max mint of 20
3405         // we ensure that this function mints a maximum of (10000 - 77 = 9923) graycrafts
3406         // `exclusiveOwnership` decrements with each mint
3407         // 50 <= 10000 - 76
3408         require(totalSupply().add(numberOfTokens) <= MAX_GRAYCRAFT.sub(exclusiveOwnership)); // Max supply exceeded
3409         require(CRAFT_PRICE.mul(numberOfTokens) <= msg.value); // Value sent is not correct
3410         
3411         for (uint i = 0; i < numberOfTokens; i++) {
3412             if (totalSupply() < MAX_GRAYCRAFT) {
3413                 _mintBase(msg.sender, Strings.toString(_tokenCount+1));
3414                 emit AssetMinted(_tokenCount, msg.sender);
3415             }
3416         }
3417     }
3418 
3419     /* ========== External owner functions ========== */
3420 
3421     // @dev withdraw funds
3422     function withdraw() external onlyOwner {
3423         uint balance = address(this).balance;
3424         payable(msg.sender).transfer(balance);
3425     }
3426 
3427     // @dev reserve GrayCraft for owner, max of 500
3428     function reserveGrayCraft(uint256 amount) external onlyOwner {        
3429         require(amount <= reservedGrayCraft); // Exceeds reserved supply
3430         uint i;
3431         for (i = 0; i < amount; i++) {
3432             _mintBase(msg.sender, Strings.toString(_tokenCount+1));
3433             emit AssetMinted(_tokenCount, msg.sender);
3434         }
3435         reservedGrayCraft = reservedGrayCraft.sub(amount);
3436     }
3437 
3438     // @dev owners can force claim GrayCraft1 exclusive
3439     function ownerClaimExclusive(uint256 tokenId) external onlyOwner {
3440         require(block.timestamp > EXCLUSIVE_EXPIRY_DATE); // Not allowed to claim
3441         require(saleIsActive); // Sale must be active
3442         require(exclusiveOwnership > 0); // Exceeds exclusive ownership supply
3443         require(!exclusiveClaim[tokenId], "Has claimed before");
3444 
3445         exclusiveClaim[tokenId] = true;
3446 
3447         _mintBase(msg.sender, Strings.toString(_tokenCount+1));
3448         emit AssetMinted(_tokenCount, msg.sender);
3449 
3450         exclusiveOwnership = exclusiveOwnership.sub(1);
3451     }
3452 
3453     // @dev flips the state for sales
3454     function flipSaleState() external onlyOwner {
3455         saleIsActive = !saleIsActive;
3456     }
3457 }