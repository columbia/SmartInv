1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 
5 contract OperatorFilterer {
6     error OperatorNotAllowed(address operator);
7 
8     IOperatorFilterRegistry constant operatorFilterRegistry =
9         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
10 
11     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
12         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
13         // will not revert, but the contract will need to be registered with the registry once it is deployed in
14         // order for the modifier to filter addresses.
15         if (address(operatorFilterRegistry).code.length > 0) {
16             if (subscribe) {
17                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
18             } else {
19                 if (subscriptionOrRegistrantToCopy != address(0)) {
20                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
21                 } else {
22                     operatorFilterRegistry.register(address(this));
23                 }
24             }
25         }
26     }
27 
28     modifier onlyAllowedOperator() virtual {
29         // Check registry code length to facilitate testing in environments without a deployed registry.
30         if (address(operatorFilterRegistry).code.length > 0) {
31             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
32                 revert OperatorNotAllowed(msg.sender);
33             }
34         }
35         _;
36     }
37 }
38 
39 contract DefaultOperatorFilterer is OperatorFilterer {
40     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
41 
42     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
43 }
44 
45 library EnumerableSet {
46     // To implement this library for multiple types with as little code
47     // repetition as possible, we write it in terms of a generic Set type with
48     // bytes32 values.
49     // The Set implementation uses private functions, and user-facing
50     // implementations (such as AddressSet) are just wrappers around the
51     // underlying Set.
52     // This means that we can only create new EnumerableSets for types that fit
53     // in bytes32.
54 
55     struct Set {
56         // Storage of set values
57         bytes32[] _values;
58         // Position of the value in the `values` array, plus 1 because index 0
59         // means a value is not in the set.
60         mapping(bytes32 => uint256) _indexes;
61     }
62 
63     /**
64      * @dev Add a value to a set. O(1).
65      *
66      * Returns true if the value was added to the set, that is if it was not
67      * already present.
68      */
69     function _add(Set storage set, bytes32 value) private returns (bool) {
70         if (!_contains(set, value)) {
71             set._values.push(value);
72             // The value is stored at length-1, but we add 1 to all indexes
73             // and use 0 as a sentinel value
74             set._indexes[value] = set._values.length;
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     /**
82      * @dev Removes a value from a set. O(1).
83      *
84      * Returns true if the value was removed from the set, that is if it was
85      * present.
86      */
87     function _remove(Set storage set, bytes32 value) private returns (bool) {
88         // We read and store the value's index to prevent multiple reads from the same storage slot
89         uint256 valueIndex = set._indexes[value];
90 
91         if (valueIndex != 0) {
92             // Equivalent to contains(set, value)
93             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
94             // the array, and then remove the last element (sometimes called as 'swap and pop').
95             // This modifies the order of the array, as noted in {at}.
96 
97             uint256 toDeleteIndex = valueIndex - 1;
98             uint256 lastIndex = set._values.length - 1;
99 
100             if (lastIndex != toDeleteIndex) {
101                 bytes32 lastValue = set._values[lastIndex];
102 
103                 // Move the last value to the index where the value to delete is
104                 set._values[toDeleteIndex] = lastValue;
105                 // Update the index for the moved value
106                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
107             }
108 
109             // Delete the slot where the moved value was stored
110             set._values.pop();
111 
112             // Delete the index for the deleted slot
113             delete set._indexes[value];
114 
115             return true;
116         } else {
117             return false;
118         }
119     }
120 
121     /**
122      * @dev Returns true if the value is in the set. O(1).
123      */
124     function _contains(Set storage set, bytes32 value) private view returns (bool) {
125         return set._indexes[value] != 0;
126     }
127 
128     /**
129      * @dev Returns the number of values on the set. O(1).
130      */
131     function _length(Set storage set) private view returns (uint256) {
132         return set._values.length;
133     }
134 
135     /**
136      * @dev Returns the value stored at position `index` in the set. O(1).
137      *
138      * Note that there are no guarantees on the ordering of values inside the
139      * array, and it may change when more values are added or removed.
140      *
141      * Requirements:
142      *
143      * - `index` must be strictly less than {length}.
144      */
145     function _at(Set storage set, uint256 index) private view returns (bytes32) {
146         return set._values[index];
147     }
148 
149     /**
150      * @dev Return the entire set in an array
151      *
152      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
153      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
154      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
155      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
156      */
157     function _values(Set storage set) private view returns (bytes32[] memory) {
158         return set._values;
159     }
160 
161     // Bytes32Set
162 
163     struct Bytes32Set {
164         Set _inner;
165     }
166 
167     /**
168      * @dev Add a value to a set. O(1).
169      *
170      * Returns true if the value was added to the set, that is if it was not
171      * already present.
172      */
173     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
174         return _add(set._inner, value);
175     }
176 
177     /**
178      * @dev Removes a value from a set. O(1).
179      *
180      * Returns true if the value was removed from the set, that is if it was
181      * present.
182      */
183     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
184         return _remove(set._inner, value);
185     }
186 
187     /**
188      * @dev Returns true if the value is in the set. O(1).
189      */
190     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
191         return _contains(set._inner, value);
192     }
193 
194     /**
195      * @dev Returns the number of values in the set. O(1).
196      */
197     function length(Bytes32Set storage set) internal view returns (uint256) {
198         return _length(set._inner);
199     }
200 
201     /**
202      * @dev Returns the value stored at position `index` in the set. O(1).
203      *
204      * Note that there are no guarantees on the ordering of values inside the
205      * array, and it may change when more values are added or removed.
206      *
207      * Requirements:
208      *
209      * - `index` must be strictly less than {length}.
210      */
211     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
212         return _at(set._inner, index);
213     }
214 
215     /**
216      * @dev Return the entire set in an array
217      *
218      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
219      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
220      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
221      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
222      */
223     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
224         bytes32[] memory store = _values(set._inner);
225         bytes32[] memory result;
226 
227         /// @solidity memory-safe-assembly
228         assembly {
229             result := store
230         }
231 
232         return result;
233     }
234 
235     // AddressSet
236 
237     struct AddressSet {
238         Set _inner;
239     }
240 
241     /**
242      * @dev Add a value to a set. O(1).
243      *
244      * Returns true if the value was added to the set, that is if it was not
245      * already present.
246      */
247     function add(AddressSet storage set, address value) internal returns (bool) {
248         return _add(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     /**
252      * @dev Removes a value from a set. O(1).
253      *
254      * Returns true if the value was removed from the set, that is if it was
255      * present.
256      */
257     function remove(AddressSet storage set, address value) internal returns (bool) {
258         return _remove(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     /**
262      * @dev Returns true if the value is in the set. O(1).
263      */
264     function contains(AddressSet storage set, address value) internal view returns (bool) {
265         return _contains(set._inner, bytes32(uint256(uint160(value))));
266     }
267 
268     /**
269      * @dev Returns the number of values in the set. O(1).
270      */
271     function length(AddressSet storage set) internal view returns (uint256) {
272         return _length(set._inner);
273     }
274 
275     /**
276      * @dev Returns the value stored at position `index` in the set. O(1).
277      *
278      * Note that there are no guarantees on the ordering of values inside the
279      * array, and it may change when more values are added or removed.
280      *
281      * Requirements:
282      *
283      * - `index` must be strictly less than {length}.
284      */
285     function at(AddressSet storage set, uint256 index) internal view returns (address) {
286         return address(uint160(uint256(_at(set._inner, index))));
287     }
288 
289     /**
290      * @dev Return the entire set in an array
291      *
292      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
293      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
294      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
295      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
296      */
297     function values(AddressSet storage set) internal view returns (address[] memory) {
298         bytes32[] memory store = _values(set._inner);
299         address[] memory result;
300 
301         /// @solidity memory-safe-assembly
302         assembly {
303             result := store
304         }
305 
306         return result;
307     }
308 
309     // UintSet
310 
311     struct UintSet {
312         Set _inner;
313     }
314 
315     /**
316      * @dev Add a value to a set. O(1).
317      *
318      * Returns true if the value was added to the set, that is if it was not
319      * already present.
320      */
321     function add(UintSet storage set, uint256 value) internal returns (bool) {
322         return _add(set._inner, bytes32(value));
323     }
324 
325     /**
326      * @dev Removes a value from a set. O(1).
327      *
328      * Returns true if the value was removed from the set, that is if it was
329      * present.
330      */
331     function remove(UintSet storage set, uint256 value) internal returns (bool) {
332         return _remove(set._inner, bytes32(value));
333     }
334 
335     /**
336      * @dev Returns true if the value is in the set. O(1).
337      */
338     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
339         return _contains(set._inner, bytes32(value));
340     }
341 
342     /**
343      * @dev Returns the number of values in the set. O(1).
344      */
345     function length(UintSet storage set) internal view returns (uint256) {
346         return _length(set._inner);
347     }
348 
349     /**
350      * @dev Returns the value stored at position `index` in the set. O(1).
351      *
352      * Note that there are no guarantees on the ordering of values inside the
353      * array, and it may change when more values are added or removed.
354      *
355      * Requirements:
356      *
357      * - `index` must be strictly less than {length}.
358      */
359     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
360         return uint256(_at(set._inner, index));
361     }
362 
363     /**
364      * @dev Return the entire set in an array
365      *
366      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
367      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
368      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
369      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
370      */
371     function values(UintSet storage set) internal view returns (uint256[] memory) {
372         bytes32[] memory store = _values(set._inner);
373         uint256[] memory result;
374 
375         /// @solidity memory-safe-assembly
376         assembly {
377             result := store
378         }
379 
380         return result;
381     }
382 }
383 
384 interface IOperatorFilterRegistry {
385     function isOperatorAllowed(address registrant, address operator) external returns (bool);
386     function register(address registrant) external;
387     function registerAndSubscribe(address registrant, address subscription) external;
388     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
389     function updateOperator(address registrant, address operator, bool filtered) external;
390     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
391     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
392     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
393     function subscribe(address registrant, address registrantToSubscribe) external;
394     function unsubscribe(address registrant, bool copyExistingEntries) external;
395     function subscriptionOf(address addr) external returns (address registrant);
396     function subscribers(address registrant) external returns (address[] memory);
397     function subscriberAt(address registrant, uint256 index) external returns (address);
398     function copyEntriesOf(address registrant, address registrantToCopy) external;
399     function isOperatorFiltered(address registrant, address operator) external returns (bool);
400     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
401     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
402     function filteredOperators(address addr) external returns (address[] memory);
403     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
404     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
405     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
406     function isRegistered(address addr) external returns (bool);
407     function codeHashOf(address addr) external returns (bytes32);
408 }
409 
410 interface IERC721A {
411     /**
412      * The caller must own the token or be an approved operator.
413      */
414     error ApprovalCallerNotOwnerNorApproved();
415 
416     /**
417      * The token does not exist.
418      */
419     error ApprovalQueryForNonexistentToken();
420 
421     /**
422      * Cannot query the balance for the zero address.
423      */
424     error BalanceQueryForZeroAddress();
425 
426     /**
427      * Cannot mint to the zero address.
428      */
429     error MintToZeroAddress();
430 
431     /**
432      * The quantity of tokens minted must be more than zero.
433      */
434     error MintZeroQuantity();
435 
436     /**
437      * The token does not exist.
438      */
439     error OwnerQueryForNonexistentToken();
440 
441     /**
442      * The caller must own the token or be an approved operator.
443      */
444     error TransferCallerNotOwnerNorApproved();
445 
446     /**
447      * The token must be owned by `from`.
448      */
449     error TransferFromIncorrectOwner();
450 
451     /**
452      * Cannot safely transfer to a contract that does not implement the
453      * ERC721Receiver interface.
454      */
455     error TransferToNonERC721ReceiverImplementer();
456 
457     /**
458      * Cannot transfer to the zero address.
459      */
460     error TransferToZeroAddress();
461 
462     /**
463      * The token does not exist.
464      */
465     error URIQueryForNonexistentToken();
466 
467     /**
468      * The `quantity` minted with ERC2309 exceeds the safety limit.
469      */
470     error MintERC2309QuantityExceedsLimit();
471 
472     /**
473      * The `extraData` cannot be set on an unintialized ownership slot.
474      */
475     error OwnershipNotInitializedForExtraData();
476 
477     // =============================================================
478     //                            STRUCTS
479     // =============================================================
480 
481     struct TokenOwnership {
482         // The address of the owner.
483         address addr;
484         // Stores the start time of ownership with minimal overhead for tokenomics.
485         uint64 startTimestamp;
486         // Whether the token has been burned.
487         bool burned;
488         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
489         uint24 extraData;
490     }
491 
492     // =============================================================
493     //                         TOKEN COUNTERS
494     // =============================================================
495 
496     /**
497      * @dev Returns the total number of tokens in existence.
498      * Burned tokens will reduce the count.
499      * To get the total number of tokens minted, please see {_totalMinted}.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     // =============================================================
504     //                            IERC165
505     // =============================================================
506 
507     /**
508      * @dev Returns true if this contract implements the interface defined by
509      * `interfaceId`. See the corresponding
510      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
511      * to learn more about how these ids are created.
512      *
513      * This function call must use less than 30000 gas.
514      */
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 
517     // =============================================================
518     //                            IERC721
519     // =============================================================
520 
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables
533      * (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in `owner`'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`,
553      * checking first that contract recipients are aware of the ERC721 protocol
554      * to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move
562      * this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement
564      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external payable;
574 
575     /**
576      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) external payable;
583 
584     /**
585      * @dev Transfers `tokenId` from `from` to `to`.
586      *
587      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
588      * whenever possible.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      * - If the caller is not `from`, it must be approved to move this token
596      * by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external payable;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the
611      * zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external payable;
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom}
625      * for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}.
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 
651     // =============================================================
652     //                        IERC721Metadata
653     // =============================================================
654 
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 
670     // =============================================================
671     //                           IERC2309
672     // =============================================================
673 
674     /**
675      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
676      * (inclusive) is transferred from `from` to `to`, as defined in the
677      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
678      *
679      * See {_mintERC2309} for more details.
680      */
681     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
682 }
683 
684 library segments {
685 
686     // TODO -- Change metadata if blob - implement hue value - implement burned - implement type (palette or blob)
687     function getMetadata(uint tokenId, string memory hue) internal pure returns (string memory) {
688 
689         string memory json;
690 
691             json = string(abi.encodePacked(
692             '{"name": "LavaLamp #',
693             uint2str(tokenId),
694             '", "description": "We all live in different blobs.", "attributes":[{"trait_type": "HUE", "value": ',
695             hue,
696             '}], "image": "data:image/svg+xml;base64,',
697             Base64.encode(bytes(renderSvg(hue))),
698             '"}'
699         ));
700         
701 
702         return string(abi.encodePacked(
703             "data:application/json;base64,",
704             Base64.encode(bytes(json))
705         ));
706     }
707 
708     function uint2str(
709         uint _i
710     ) internal pure returns (string memory _uintAsString) {
711         if (_i == 0) {
712             return "0";
713         }
714         uint j = _i;
715         uint len;
716         while (j != 0) {
717             len++;
718             j /= 10;
719         }
720         bytes memory bstr = new bytes(len);
721         uint k = len;
722         while (_i != 0) {
723             k = k - 1;
724             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
725             bytes1 b1 = bytes1(temp);
726             bstr[k] = b1;
727             _i /= 10;
728         }
729         return string(bstr);
730     }
731 
732     function renderSvg(string memory hue) internal pure returns (string memory svg) {
733         svg = '<svg version="1.1"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"  xmlns:a="http://ns.adobe.com/AdobeSVGViewerExtensions/3.0/"  x="0px" y="0px" width="600px" height="600px" viewBox="0 0 600 600"  enable-background="new 0 0 600 600" xml:space="preserve">';
734         svg = string(abi.encodePacked(svg,'<defs><style> :root{--hue: ', hue));
735 
736         svg = string(abi.encodePacked(svg,'; --hueComplement: calc(var(--hue) + 180); --hueRightAnalogous: calc(var(--hue) + 30); --hueLeftAnalogous: calc(var(--hue) - 30); --accentV1: hsl(var(--hueRightAnalogous) 50% 50%); --accentV2: hsl(var(--hueLeftAnalogous) 50% 50%); } body { background-color:#000; overflow: hidden; } @keyframes updown { 0% { transform: translateY(0) scale(0.2); } 50% { transform: translateY(-100px) scale(0.1); } 100% { transform: translateY(0) scale(0.2); } } .blob { transform-origin: 50% 70%; animation-name: updown; animation-duration: 30s; animation-iteration-count: infinite; animation-direction: alternate; } .blob2 { transform-origin: 50% 30%; animation-duration: 40s; } .blob3{ transform-origin: 50% 45%; animation-duration: 18s; } .blob4{ transform-origin: 50% 55%; animation-duration: 24s; } </style> <linearGradient id="a" y1="1" xmlns="http://www.w3.org/2000/svg"> <stop stop-color="var(--accentV1)" offset="0"/> <stop stop-color="var(--accentV2)" offset="1"/> </linearGradient> <filter id="d"> <feGaussianBlur in="SourceGraphic" result="blur" stdDeviation="8"/> <feColorMatrix in="blur" mode="matrix" result="cm" values="1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 21 -9"/> </filter> <radialGradient id="g" cx="300" cy="300" r="350" gradientUnits="userSpaceOnUse"> <stop stop-color="#471A19" offset=".071429"/> <stop stop-color="#290F0E" offset=".3107"/> <stop stop-color="#120706" offset=".553"/> <stop stop-color="#050202" offset=".7828"/> <stop offset=".9847"/> </radialGradient> <clipPath id="f"> <path id="e" d="m262 174h60l33.5 182.3s2.7 12.8 2.5 22.8h-131s-0.7-9.3 0-18c0.6-8.2 35-187.1 35-187.1z"/> </clipPath> <linearGradient id="b" x1="292" x2="292" y1="135" y2="174" gradientUnits="userSpaceOnUse"> <stop offset=".015306"/> <stop stop-color="#050202" offset=".233"/> <stop stop-color="#120706" offset=".4808"/> <stop stop-color="#290F0E" offset=".7421"/> <stop stop-color="#471A19" offset="1"/> </linearGradient> <linearGradient id="c" x1="292.38" x2="292.38" y1="470" y2="379" gradientUnits="userSpaceOnUse"> <stop offset=".005102"/> <stop stop-color="#050202" offset=".2251"/> <stop stop-color="#120706" offset=".4754"/> <stop stop-color="#290F0E" offset=".7394"/> <stop stop-color="#471A19" offset="1"/> </linearGradient> </defs> <rect width="600" height="600" fill="url(#g)"/> <use fill="var(--accentV1)" opacity=".1" xlink:href="#e"/> <polygon points="269 135 262 174 322 174 316 135" fill="url(#b)"/> <path d="m226.8 379c2.6 43 23.9 54.6 28.3 60.2 3.3 5.4-10 30.8-10 30.8h95.5s-16.5-25.1-14.5-30.8 26-15.2 32-60.2h-131.3z" fill="url(#c)"/> <rect y="470" width="600" height="130"/> <g clip-path="url(#f)" fill="url(#a)" filter="url(#d)"> <path fill="url(#a)" class="blob" d="M337,323.5Q240,407,165,323.5Q90,240,165,161.5Q240,83,337,161.5Q434,240,337,323.5Z" /> <path fill="url(#a)" class="blob blob2" d="M324,343.5Q240,447,154.5,343.5Q69,240,154.5,147Q240,54,324,147Q408,240,324,343.5Z" /> <path fill="url(#a)" class="blob blob3" d="M324,343.5Q240,447,154.5,343.5Q69,240,154.5,147Q240,54,324,147Q408,240,324,343.5Z" /> <path fill="url(#a)" class="blob blob4" d="M395,324.5Q338,409,234,420Q130,431,81,335.5Q32,240,83,148.5Q134,57,237.5,60.5Q341,64,396.5,152Q452,240,395,324.5Z" /> <path d="m354 381.2c6.8 3.4 5.4 7.4-5.6 10.4-10.7 3.1-31.1 5.1-54.4 8.4s-43.7 0.8-54.4-2.4c-11-3.4-12.4-7.6-5.6-13.8 6.8-7 18.9-14.6 29.6-17.4 11-3.3 20.6-1.8 30.4-1.4s19.4 5.1 30.4 8.3c10.7 3.5 22.8 5.3 29.6 7.9z"/> </g> </svg>')); 
737         
738         return string(abi.encodePacked(svg));
739     }
740 }
741 
742 abstract contract Context {
743     function _msgSender() internal view virtual returns (address) {
744         return msg.sender;
745     }
746 
747     function _msgData() internal view virtual returns (bytes calldata) {
748         return msg.data;
749     }
750 }
751 
752 abstract contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
756 
757     /**
758      * @dev Initializes the contract setting the deployer as the initial owner.
759      */
760     constructor() {
761         _transferOwnership(_msgSender());
762     }
763 
764     /**
765      * @dev Throws if called by any account other than the owner.
766      */
767     modifier onlyOwner() {
768         _checkOwner();
769         _;
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view virtual returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if the sender is not the owner.
781      */
782     function _checkOwner() internal view virtual {
783         require(owner() == _msgSender(), "Ownable: caller is not the owner");
784     }
785 
786     /**
787      * @dev Leaves the contract without owner. It will not be possible to call
788      * `onlyOwner` functions anymore. Can only be called by the current owner.
789      *
790      * NOTE: Renouncing ownership will leave the contract without an owner,
791      * thereby removing any functionality that is only available to the owner.
792      */
793     function renounceOwnership() public virtual onlyOwner {
794         _transferOwnership(address(0));
795     }
796 
797     /**
798      * @dev Transfers ownership of the contract to a new account (`newOwner`).
799      * Can only be called by the current owner.
800      */
801     function transferOwnership(address newOwner) public virtual onlyOwner {
802         require(newOwner != address(0), "Ownable: new owner is the zero address");
803         _transferOwnership(newOwner);
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      * Internal function without access restriction.
809      */
810     function _transferOwnership(address newOwner) internal virtual {
811         address oldOwner = _owner;
812         _owner = newOwner;
813         emit OwnershipTransferred(oldOwner, newOwner);
814     }
815 }
816 
817 interface ERC721A__IERC721Receiver {
818     function onERC721Received(
819         address operator,
820         address from,
821         uint256 tokenId,
822         bytes calldata data
823     ) external returns (bytes4);
824 }
825 
826 contract ERC721A is IERC721A {
827     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
828     struct TokenApprovalRef {
829         address value;
830     }
831 
832     // =============================================================
833     //                           CONSTANTS
834     // =============================================================
835 
836     // Mask of an entry in packed address data.
837     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
838 
839     // The bit position of `numberMinted` in packed address data.
840     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
841 
842     // The bit position of `numberBurned` in packed address data.
843     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
844 
845     // The bit position of `aux` in packed address data.
846     uint256 private constant _BITPOS_AUX = 192;
847 
848     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
849     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
850 
851     // The bit position of `startTimestamp` in packed ownership.
852     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
853 
854     // The bit mask of the `burned` bit in packed ownership.
855     uint256 private constant _BITMASK_BURNED = 1 << 224;
856 
857     // The bit position of the `nextInitialized` bit in packed ownership.
858     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
859 
860     // The bit mask of the `nextInitialized` bit in packed ownership.
861     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
862 
863     // The bit position of `extraData` in packed ownership.
864     uint256 private constant _BITPOS_EXTRA_DATA = 232;
865 
866     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
867     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
868 
869     // The mask of the lower 160 bits for addresses.
870     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
871 
872     // The maximum `quantity` that can be minted with {_mintERC2309}.
873     // This limit is to prevent overflows on the address data entries.
874     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
875     // is required to cause an overflow, which is unrealistic.
876     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
877 
878     // The `Transfer` event signature is given by:
879     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
880     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
881         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
882 
883     // =============================================================
884     //                            STORAGE
885     // =============================================================
886 
887     // The next token ID to be minted.
888     uint256 private _currentIndex;
889 
890     // The number of tokens burned.
891     uint256 private _burnCounter;
892 
893     // Token name
894     string private _name;
895 
896     // Token symbol
897     string private _symbol;
898 
899     // Mapping from token ID to ownership details
900     // An empty struct value does not necessarily mean the token is unowned.
901     // See {_packedOwnershipOf} implementation for details.
902     //
903     // Bits Layout:
904     // - [0..159]   `addr`
905     // - [160..223] `startTimestamp`
906     // - [224]      `burned`
907     // - [225]      `nextInitialized`
908     // - [232..255] `extraData`
909     mapping(uint256 => uint256) private _packedOwnerships;
910 
911     // Mapping owner address to address data.
912     //
913     // Bits Layout:
914     // - [0..63]    `balance`
915     // - [64..127]  `numberMinted`
916     // - [128..191] `numberBurned`
917     // - [192..255] `aux`
918     mapping(address => uint256) private _packedAddressData;
919 
920     // Mapping from token ID to approved address.
921     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
922 
923     // Mapping from owner to operator approvals
924     mapping(address => mapping(address => bool)) private _operatorApprovals;
925 
926     // =============================================================
927     //                          CONSTRUCTOR
928     // =============================================================
929 
930     constructor(string memory name_, string memory symbol_) {
931         _name = name_;
932         _symbol = symbol_;
933         _currentIndex = _startTokenId();
934     }
935 
936     // =============================================================
937     //                   TOKEN COUNTING OPERATIONS
938     // =============================================================
939 
940     /**
941      * @dev Returns the starting token ID.
942      * To change the starting token ID, please override this function.
943      */
944     function _startTokenId() internal view virtual returns (uint256) {
945         return 1;
946     }
947 
948     /**
949      * @dev Returns the next token ID to be minted.
950      */
951     function _nextTokenId() internal view virtual returns (uint256) {
952         return _currentIndex;
953     }
954 
955     /**
956      * @dev Returns the total number of tokens in existence.
957      * Burned tokens will reduce the count.
958      * To get the total number of tokens minted, please see {_totalMinted}.
959      */
960     function totalSupply() public view virtual override returns (uint256) {
961         // Counter underflow is impossible as _burnCounter cannot be incremented
962         // more than `_currentIndex - _startTokenId()` times.
963         unchecked {
964             return _currentIndex - _burnCounter - _startTokenId();
965         }
966     }
967 
968     /**
969      * @dev Returns the total amount of tokens minted in the contract.
970      */
971     function _totalMinted() internal view virtual returns (uint256) {
972         // Counter underflow is impossible as `_currentIndex` does not decrement,
973         // and it is initialized to `_startTokenId()`.
974         unchecked {
975             return _currentIndex - _startTokenId();
976         }
977     }
978 
979     /**
980      * @dev Returns the total number of tokens burned.
981      */
982     function _totalBurned() internal view virtual returns (uint256) {
983         return _burnCounter;
984     }
985 
986     // =============================================================
987     //                    ADDRESS DATA OPERATIONS
988     // =============================================================
989 
990     /**
991      * @dev Returns the number of tokens in `owner`'s account.
992      */
993     function balanceOf(address owner) public view virtual override returns (uint256) {
994         if (owner == address(0)) revert BalanceQueryForZeroAddress();
995         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
996     }
997 
998     /**
999      * Returns the number of tokens minted by `owner`.
1000      */
1001     function _numberMinted(address owner) internal view returns (uint256) {
1002         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1003     }
1004 
1005     /**
1006      * Returns the number of tokens burned by or on behalf of `owner`.
1007      */
1008     function _numberBurned(address owner) internal view returns (uint256) {
1009         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1010     }
1011 
1012     /**
1013      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1014      */
1015     function _getAux(address owner) internal view returns (uint64) {
1016         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1017     }
1018 
1019     /**
1020      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1021      * If there are multiple variables, please pack them into a uint64.
1022      */
1023     function _setAux(address owner, uint64 aux) internal virtual {
1024         uint256 packed = _packedAddressData[owner];
1025         uint256 auxCasted;
1026         // Cast `aux` with assembly to avoid redundant masking.
1027         assembly {
1028             auxCasted := aux
1029         }
1030         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1031         _packedAddressData[owner] = packed;
1032     }
1033 
1034     // =============================================================
1035     //                            IERC165
1036     // =============================================================
1037 
1038     /**
1039      * @dev Returns true if this contract implements the interface defined by
1040      * `interfaceId`. See the corresponding
1041      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1042      * to learn more about how these ids are created.
1043      *
1044      * This function call must use less than 30000 gas.
1045      */
1046     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1047         // The interface IDs are constants representing the first 4 bytes
1048         // of the XOR of all function selectors in the interface.
1049         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1050         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1051         return
1052             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1053             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1054             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1055     }
1056 
1057     // =============================================================
1058     //                        IERC721Metadata
1059     // =============================================================
1060 
1061     /**
1062      * @dev Returns the token collection name.
1063      */
1064     function name() public view virtual override returns (string memory) {
1065         return _name;
1066     }
1067 
1068     /**
1069      * @dev Returns the token collection symbol.
1070      */
1071     function symbol() public view virtual override returns (string memory) {
1072         return _symbol;
1073     }
1074 
1075     /**
1076      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1077      */
1078     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1079         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1080 
1081         string memory baseURI = _baseURI();
1082         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1083     }
1084 
1085     /**
1086      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1087      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1088      * by default, it can be overridden in child contracts.
1089      */
1090     function _baseURI() internal view virtual returns (string memory) {
1091         return '';
1092     }
1093 
1094     // =============================================================
1095     //                     OWNERSHIPS OPERATIONS
1096     // =============================================================
1097 
1098     /**
1099      * @dev Returns the owner of the `tokenId` token.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      */
1105     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1106         return address(uint160(_packedOwnershipOf(tokenId)));
1107     }
1108 
1109     /**
1110      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1111      * It gradually moves to O(1) as tokens get transferred around over time.
1112      */
1113     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1114         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1115     }
1116 
1117     /**
1118      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1119      */
1120     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1121         return _unpackedOwnership(_packedOwnerships[index]);
1122     }
1123 
1124     /**
1125      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1126      */
1127     function _initializeOwnershipAt(uint256 index) internal virtual {
1128         if (_packedOwnerships[index] == 0) {
1129             _packedOwnerships[index] = _packedOwnershipOf(index);
1130         }
1131     }
1132 
1133     /**
1134      * Returns the packed ownership data of `tokenId`.
1135      */
1136     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1137         uint256 curr = tokenId;
1138 
1139         unchecked {
1140             if (_startTokenId() <= curr)
1141                 if (curr < _currentIndex) {
1142                     uint256 packed = _packedOwnerships[curr];
1143                     // If not burned.
1144                     if (packed & _BITMASK_BURNED == 0) {
1145                         // Invariant:
1146                         // There will always be an initialized ownership slot
1147                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1148                         // before an unintialized ownership slot
1149                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1150                         // Hence, `curr` will not underflow.
1151                         //
1152                         // We can directly compare the packed value.
1153                         // If the address is zero, packed will be zero.
1154                         while (packed == 0) {
1155                             packed = _packedOwnerships[--curr];
1156                         }
1157                         return packed;
1158                     }
1159                 }
1160         }
1161         revert OwnerQueryForNonexistentToken();
1162     }
1163 
1164     /**
1165      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1166      */
1167     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1168         ownership.addr = address(uint160(packed));
1169         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1170         ownership.burned = packed & _BITMASK_BURNED != 0;
1171         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1172     }
1173 
1174     /**
1175      * @dev Packs ownership data into a single uint256.
1176      */
1177     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1178         assembly {
1179             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1180             owner := and(owner, _BITMASK_ADDRESS)
1181             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1182             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1183         }
1184     }
1185 
1186     /**
1187      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1188      */
1189     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1190         // For branchless setting of the `nextInitialized` flag.
1191         assembly {
1192             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1193             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1194         }
1195     }
1196 
1197     // =============================================================
1198     //                      APPROVAL OPERATIONS
1199     // =============================================================
1200 
1201     /**
1202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1203      * The approval is cleared when the token is transferred.
1204      *
1205      * Only a single account can be approved at a time, so approving the
1206      * zero address clears previous approvals.
1207      *
1208      * Requirements:
1209      *
1210      * - The caller must own the token or be an approved operator.
1211      * - `tokenId` must exist.
1212      *
1213      * Emits an {Approval} event.
1214      */
1215     function approve(address to, uint256 tokenId) public payable virtual override {
1216         address owner = ownerOf(tokenId);
1217 
1218         if (_msgSenderERC721A() != owner)
1219             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1220                 revert ApprovalCallerNotOwnerNorApproved();
1221             }
1222 
1223         _tokenApprovals[tokenId].value = to;
1224         emit Approval(owner, to, tokenId);
1225     }
1226 
1227     /**
1228      * @dev Returns the account approved for `tokenId` token.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      */
1234     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1235         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1236 
1237         return _tokenApprovals[tokenId].value;
1238     }
1239 
1240     /**
1241      * @dev Approve or remove `operator` as an operator for the caller.
1242      * Operators can call {transferFrom} or {safeTransferFrom}
1243      * for any token owned by the caller.
1244      *
1245      * Requirements:
1246      *
1247      * - The `operator` cannot be the caller.
1248      *
1249      * Emits an {ApprovalForAll} event.
1250      */
1251     function setApprovalForAll(address operator, bool approved) public virtual override {
1252         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1253         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1254     }
1255 
1256     /**
1257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1258      *
1259      * See {setApprovalForAll}.
1260      */
1261     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1262         return _operatorApprovals[owner][operator];
1263     }
1264 
1265     /**
1266      * @dev Returns whether `tokenId` exists.
1267      *
1268      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1269      *
1270      * Tokens start existing when they are minted. See {_mint}.
1271      */
1272     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1273         return
1274             _startTokenId() <= tokenId &&
1275             tokenId < _currentIndex && // If within bounds,
1276             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1277     }
1278 
1279     /**
1280      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1281      */
1282     function _isSenderApprovedOrOwner(
1283         address approvedAddress,
1284         address owner,
1285         address msgSender
1286     ) private pure returns (bool result) {
1287         assembly {
1288             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1289             owner := and(owner, _BITMASK_ADDRESS)
1290             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1291             msgSender := and(msgSender, _BITMASK_ADDRESS)
1292             // `msgSender == owner || msgSender == approvedAddress`.
1293             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1294         }
1295     }
1296 
1297     /**
1298      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1299      */
1300     function _getApprovedSlotAndAddress(uint256 tokenId)
1301         private
1302         view
1303         returns (uint256 approvedAddressSlot, address approvedAddress)
1304     {
1305         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1306         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1307         assembly {
1308             approvedAddressSlot := tokenApproval.slot
1309             approvedAddress := sload(approvedAddressSlot)
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                      TRANSFER OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Transfers `tokenId` from `from` to `to`.
1319      *
1320      * Requirements:
1321      *
1322      * - `from` cannot be the zero address.
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must be owned by `from`.
1325      * - If the caller is not `from`, it must be approved to move this token
1326      * by either {approve} or {setApprovalForAll}.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function transferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) public payable virtual override {
1335         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1336 
1337         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1338 
1339         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1340 
1341         // The nested ifs save around 20+ gas over a compound boolean condition.
1342         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1343             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1344 
1345         if (to == address(0)) revert TransferToZeroAddress();
1346 
1347         _beforeTokenTransfers(from, to, tokenId, 1);
1348 
1349         // Clear approvals from the previous owner.
1350         assembly {
1351             if approvedAddress {
1352                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1353                 sstore(approvedAddressSlot, 0)
1354             }
1355         }
1356 
1357         // Underflow of the sender's balance is impossible because we check for
1358         // ownership above and the recipient's balance can't realistically overflow.
1359         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1360         unchecked {
1361             // We can directly increment and decrement the balances.
1362             --_packedAddressData[from]; // Updates: `balance -= 1`.
1363             ++_packedAddressData[to]; // Updates: `balance += 1`.
1364 
1365             // Updates:
1366             // - `address` to the next owner.
1367             // - `startTimestamp` to the timestamp of transfering.
1368             // - `burned` to `false`.
1369             // - `nextInitialized` to `true`.
1370             _packedOwnerships[tokenId] = _packOwnershipData(
1371                 to,
1372                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1373             );
1374 
1375             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1376             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1377                 uint256 nextTokenId = tokenId + 1;
1378                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1379                 if (_packedOwnerships[nextTokenId] == 0) {
1380                     // If the next slot is within bounds.
1381                     if (nextTokenId != _currentIndex) {
1382                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1383                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1384                     }
1385                 }
1386             }
1387         }
1388 
1389         emit Transfer(from, to, tokenId);
1390         _afterTokenTransfers(from, to, tokenId, 1);
1391     }
1392 
1393     /**
1394      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1395      */
1396     function safeTransferFrom(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) public payable virtual override {
1401         safeTransferFrom(from, to, tokenId, '');
1402     }
1403 
1404     /**
1405      * @dev Safely transfers `tokenId` token from `from` to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - `from` cannot be the zero address.
1410      * - `to` cannot be the zero address.
1411      * - `tokenId` token must exist and be owned by `from`.
1412      * - If the caller is not `from`, it must be approved to move this token
1413      * by either {approve} or {setApprovalForAll}.
1414      * - If `to` refers to a smart contract, it must implement
1415      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId,
1423         bytes memory _data
1424     ) public payable virtual override {
1425         transferFrom(from, to, tokenId);
1426         if (to.code.length != 0)
1427             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1428                 revert TransferToNonERC721ReceiverImplementer();
1429             }
1430     }
1431 
1432     /**
1433      * @dev Hook that is called before a set of serially-ordered token IDs
1434      * are about to be transferred. This includes minting.
1435      * And also called before burning one token.
1436      *
1437      * `startTokenId` - the first token ID to be transferred.
1438      * `quantity` - the amount to be transferred.
1439      *
1440      * Calling conditions:
1441      *
1442      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1443      * transferred to `to`.
1444      * - When `from` is zero, `tokenId` will be minted for `to`.
1445      * - When `to` is zero, `tokenId` will be burned by `from`.
1446      * - `from` and `to` are never both zero.
1447      */
1448     function _beforeTokenTransfers(
1449         address from,
1450         address to,
1451         uint256 startTokenId,
1452         uint256 quantity
1453     ) internal virtual {}
1454 
1455     /**
1456      * @dev Hook that is called after a set of serially-ordered token IDs
1457      * have been transferred. This includes minting.
1458      * And also called after one token has been burned.
1459      *
1460      * `startTokenId` - the first token ID to be transferred.
1461      * `quantity` - the amount to be transferred.
1462      *
1463      * Calling conditions:
1464      *
1465      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1466      * transferred to `to`.
1467      * - When `from` is zero, `tokenId` has been minted for `to`.
1468      * - When `to` is zero, `tokenId` has been burned by `from`.
1469      * - `from` and `to` are never both zero.
1470      */
1471     function _afterTokenTransfers(
1472         address from,
1473         address to,
1474         uint256 startTokenId,
1475         uint256 quantity
1476     ) internal virtual {}
1477 
1478     /**
1479      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1480      *
1481      * `from` - Previous owner of the given token ID.
1482      * `to` - Target address that will receive the token.
1483      * `tokenId` - Token ID to be transferred.
1484      * `_data` - Optional data to send along with the call.
1485      *
1486      * Returns whether the call correctly returned the expected magic value.
1487      */
1488     function _checkContractOnERC721Received(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) private returns (bool) {
1494         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1495             bytes4 retval
1496         ) {
1497             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1498         } catch (bytes memory reason) {
1499             if (reason.length == 0) {
1500                 revert TransferToNonERC721ReceiverImplementer();
1501             } else {
1502                 assembly {
1503                     revert(add(32, reason), mload(reason))
1504                 }
1505             }
1506         }
1507     }
1508 
1509     // =============================================================
1510     //                        MINT OPERATIONS
1511     // =============================================================
1512 
1513     /**
1514      * @dev Mints `quantity` tokens and transfers them to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - `to` cannot be the zero address.
1519      * - `quantity` must be greater than 0.
1520      *
1521      * Emits a {Transfer} event for each mint.
1522      */
1523     function _mint(address to, uint256 quantity) internal virtual {
1524         uint256 startTokenId = _currentIndex;
1525         if (quantity == 0) revert MintZeroQuantity();
1526 
1527         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1528 
1529         // Overflows are incredibly unrealistic.
1530         // `balance` and `numberMinted` have a maximum limit of 2**64.
1531         // `tokenId` has a maximum limit of 2**256.
1532         unchecked {
1533             // Updates:
1534             // - `balance += quantity`.
1535             // - `numberMinted += quantity`.
1536             //
1537             // We can directly add to the `balance` and `numberMinted`.
1538             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1539 
1540             // Updates:
1541             // - `address` to the owner.
1542             // - `startTimestamp` to the timestamp of minting.
1543             // - `burned` to `false`.
1544             // - `nextInitialized` to `quantity == 1`.
1545             _packedOwnerships[startTokenId] = _packOwnershipData(
1546                 to,
1547                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1548             );
1549 
1550             uint256 toMasked;
1551             uint256 end = startTokenId + quantity;
1552 
1553             // Use assembly to loop and emit the `Transfer` event for gas savings.
1554             // The duplicated `log4` removes an extra check and reduces stack juggling.
1555             // The assembly, together with the surrounding Solidity code, have been
1556             // delicately arranged to nudge the compiler into producing optimized opcodes.
1557             assembly {
1558                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1559                 toMasked := and(to, _BITMASK_ADDRESS)
1560                 // Emit the `Transfer` event.
1561                 log4(
1562                     0, // Start of data (0, since no data).
1563                     0, // End of data (0, since no data).
1564                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1565                     0, // `address(0)`.
1566                     toMasked, // `to`.
1567                     startTokenId // `tokenId`.
1568                 )
1569 
1570                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1571                 // that overflows uint256 will make the loop run out of gas.
1572                 // The compiler will optimize the `iszero` away for performance.
1573                 for {
1574                     let tokenId := add(startTokenId, 1)
1575                 } iszero(eq(tokenId, end)) {
1576                     tokenId := add(tokenId, 1)
1577                 } {
1578                     // Emit the `Transfer` event. Similar to above.
1579                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1580                 }
1581             }
1582             if (toMasked == 0) revert MintToZeroAddress();
1583 
1584             _currentIndex = end;
1585         }
1586         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1587     }
1588 
1589     /**
1590      * @dev Mints `quantity` tokens and transfers them to `to`.
1591      *
1592      * This function is intended for efficient minting only during contract creation.
1593      *
1594      * It emits only one {ConsecutiveTransfer} as defined in
1595      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1596      * instead of a sequence of {Transfer} event(s).
1597      *
1598      * Calling this function outside of contract creation WILL make your contract
1599      * non-compliant with the ERC721 standard.
1600      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1601      * {ConsecutiveTransfer} event is only permissible during contract creation.
1602      *
1603      * Requirements:
1604      *
1605      * - `to` cannot be the zero address.
1606      * - `quantity` must be greater than 0.
1607      *
1608      * Emits a {ConsecutiveTransfer} event.
1609      */
1610     function _mintERC2309(address to, uint256 quantity) internal virtual {
1611         uint256 startTokenId = _currentIndex;
1612         if (to == address(0)) revert MintToZeroAddress();
1613         if (quantity == 0) revert MintZeroQuantity();
1614         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1615 
1616         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1617 
1618         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1619         unchecked {
1620             // Updates:
1621             // - `balance += quantity`.
1622             // - `numberMinted += quantity`.
1623             //
1624             // We can directly add to the `balance` and `numberMinted`.
1625             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1626 
1627             // Updates:
1628             // - `address` to the owner.
1629             // - `startTimestamp` to the timestamp of minting.
1630             // - `burned` to `false`.
1631             // - `nextInitialized` to `quantity == 1`.
1632             _packedOwnerships[startTokenId] = _packOwnershipData(
1633                 to,
1634                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1635             );
1636 
1637             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1638 
1639             _currentIndex = startTokenId + quantity;
1640         }
1641         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1642     }
1643 
1644     /**
1645      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1646      *
1647      * Requirements:
1648      *
1649      * - If `to` refers to a smart contract, it must implement
1650      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1651      * - `quantity` must be greater than 0.
1652      *
1653      * See {_mint}.
1654      *
1655      * Emits a {Transfer} event for each mint.
1656      */
1657     function _safeMint(
1658         address to,
1659         uint256 quantity,
1660         bytes memory _data
1661     ) internal virtual {
1662         _mint(to, quantity);
1663 
1664         unchecked {
1665             if (to.code.length != 0) {
1666                 uint256 end = _currentIndex;
1667                 uint256 index = end - quantity;
1668                 do {
1669                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1670                         revert TransferToNonERC721ReceiverImplementer();
1671                     }
1672                 } while (index < end);
1673                 // Reentrancy protection.
1674                 if (_currentIndex != end) revert();
1675             }
1676         }
1677     }
1678 
1679     /**
1680      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1681      */
1682     function _safeMint(address to, uint256 quantity) internal virtual {
1683         _safeMint(to, quantity, '');
1684     }
1685 
1686     // =============================================================
1687     //                        BURN OPERATIONS
1688     // =============================================================
1689 
1690     /**
1691      * @dev Equivalent to `_burn(tokenId, false)`.
1692      */
1693     function _burn(uint256 tokenId) internal virtual {
1694         _burn(tokenId, false);
1695     }
1696 
1697     /**
1698      * @dev Destroys `tokenId`.
1699      * The approval is cleared when the token is burned.
1700      *
1701      * Requirements:
1702      *
1703      * - `tokenId` must exist.
1704      *
1705      * Emits a {Transfer} event.
1706      */
1707     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1708         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1709 
1710         address from = address(uint160(prevOwnershipPacked));
1711 
1712         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1713 
1714         if (approvalCheck) {
1715             // The nested ifs save around 20+ gas over a compound boolean condition.
1716             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1717                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1718         }
1719 
1720         _beforeTokenTransfers(from, address(0), tokenId, 1);
1721 
1722         // Clear approvals from the previous owner.
1723         assembly {
1724             if approvedAddress {
1725                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1726                 sstore(approvedAddressSlot, 0)
1727             }
1728         }
1729 
1730         // Underflow of the sender's balance is impossible because we check for
1731         // ownership above and the recipient's balance can't realistically overflow.
1732         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1733         unchecked {
1734             // Updates:
1735             // - `balance -= 1`.
1736             // - `numberBurned += 1`.
1737             //
1738             // We can directly decrement the balance, and increment the number burned.
1739             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1740             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1741 
1742             // Updates:
1743             // - `address` to the last owner.
1744             // - `startTimestamp` to the timestamp of burning.
1745             // - `burned` to `true`.
1746             // - `nextInitialized` to `true`.
1747             _packedOwnerships[tokenId] = _packOwnershipData(
1748                 from,
1749                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1750             );
1751 
1752             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1753             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1754                 uint256 nextTokenId = tokenId + 1;
1755                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1756                 if (_packedOwnerships[nextTokenId] == 0) {
1757                     // If the next slot is within bounds.
1758                     if (nextTokenId != _currentIndex) {
1759                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1760                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1761                     }
1762                 }
1763             }
1764         }
1765 
1766         emit Transfer(from, address(0), tokenId);
1767         _afterTokenTransfers(from, address(0), tokenId, 1);
1768 
1769         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1770         unchecked {
1771             _burnCounter++;
1772         }
1773     }
1774 
1775     // =============================================================
1776     //                     EXTRA DATA OPERATIONS
1777     // =============================================================
1778 
1779     /**
1780      * @dev Directly sets the extra data for the ownership data `index`.
1781      */
1782     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1783         uint256 packed = _packedOwnerships[index];
1784         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1785         uint256 extraDataCasted;
1786         // Cast `extraData` with assembly to avoid redundant masking.
1787         assembly {
1788             extraDataCasted := extraData
1789         }
1790         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1791         _packedOwnerships[index] = packed;
1792     }
1793 
1794     /**
1795      * @dev Called during each token transfer to set the 24bit `extraData` field.
1796      * Intended to be overridden by the cosumer contract.
1797      *
1798      * `previousExtraData` - the value of `extraData` before transfer.
1799      *
1800      * Calling conditions:
1801      *
1802      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1803      * transferred to `to`.
1804      * - When `from` is zero, `tokenId` will be minted for `to`.
1805      * - When `to` is zero, `tokenId` will be burned by `from`.
1806      * - `from` and `to` are never both zero.
1807      */
1808     function _extraData(
1809         address from,
1810         address to,
1811         uint24 previousExtraData
1812     ) internal view virtual returns (uint24) {}
1813 
1814     /**
1815      * @dev Returns the next extra data for the packed ownership data.
1816      * The returned result is shifted into position.
1817      */
1818     function _nextExtraData(
1819         address from,
1820         address to,
1821         uint256 prevOwnershipPacked
1822     ) private view returns (uint256) {
1823         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1824         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1825     }
1826 
1827     // =============================================================
1828     //                       OTHER OPERATIONS
1829     // =============================================================
1830 
1831     /**
1832      * @dev Returns the message sender (defaults to `msg.sender`).
1833      *
1834      * If you are writing GSN compatible contracts, you need to override this function.
1835      */
1836     function _msgSenderERC721A() internal view virtual returns (address) {
1837         return msg.sender;
1838     }
1839 
1840     /**
1841      * @dev Converts a uint256 to its ASCII string decimal representation.
1842      */
1843     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1844         assembly {
1845             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1846             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1847             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1848             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1849             let m := add(mload(0x40), 0xa0)
1850             // Update the free memory pointer to allocate.
1851             mstore(0x40, m)
1852             // Assign the `str` to the end.
1853             str := sub(m, 0x20)
1854             // Zeroize the slot after the string.
1855             mstore(str, 0)
1856 
1857             // Cache the end of the memory to calculate the length later.
1858             let end := str
1859 
1860             // We write the string from rightmost digit to leftmost digit.
1861             // The following is essentially a do-while loop that also handles the zero case.
1862             // prettier-ignore
1863             for { let temp := value } 1 {} {
1864                 str := sub(str, 1)
1865                 // Write the character to the pointer.
1866                 // The ASCII index of the '0' character is 48.
1867                 mstore8(str, add(48, mod(temp, 10)))
1868                 // Keep dividing `temp` until zero.
1869                 temp := div(temp, 10)
1870                 // prettier-ignore
1871                 if iszero(temp) { break }
1872             }
1873 
1874             let length := sub(end, str)
1875             // Move the pointer 32 bytes leftwards to make room for the length.
1876             str := sub(str, 0x20)
1877             // Store the length.
1878             mstore(str, length)
1879         }
1880     }
1881 }
1882 
1883 library Base64 {
1884     /**
1885      * @dev Base64 Encoding/Decoding Table
1886      */
1887     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1888 
1889     /**
1890      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1891      */
1892     function encode(bytes memory data) internal pure returns (string memory) {
1893         /**
1894          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1895          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1896          */
1897         if (data.length == 0) return "";
1898 
1899         // Loads the table into memory
1900         string memory table = _TABLE;
1901 
1902         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1903         // and split into 4 numbers of 6 bits.
1904         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1905         // - `data.length + 2`  -> Round up
1906         // - `/ 3`              -> Number of 3-bytes chunks
1907         // - `4 *`              -> 4 characters for each chunk
1908         string memory result = new string(4 * ((data.length + 2) / 3));
1909 
1910         /// @solidity memory-safe-assembly
1911         assembly {
1912             // Prepare the lookup table (skip the first "length" byte)
1913             let tablePtr := add(table, 1)
1914 
1915             // Prepare result pointer, jump over length
1916             let resultPtr := add(result, 32)
1917 
1918             // Run over the input, 3 bytes at a time
1919             for {
1920                 let dataPtr := data
1921                 let endPtr := add(data, mload(data))
1922             } lt(dataPtr, endPtr) {
1923 
1924             } {
1925                 // Advance 3 bytes
1926                 dataPtr := add(dataPtr, 3)
1927                 let input := mload(dataPtr)
1928 
1929                 // To write each character, shift the 3 bytes (18 bits) chunk
1930                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1931                 // and apply logical AND with 0x3F which is the number of
1932                 // the previous character in the ASCII table prior to the Base64 Table
1933                 // The result is then added to the table to get the character to write,
1934                 // and finally write it in the result pointer but with a left shift
1935                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1936 
1937                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1938                 resultPtr := add(resultPtr, 1) // Advance
1939 
1940                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1941                 resultPtr := add(resultPtr, 1) // Advance
1942 
1943                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1944                 resultPtr := add(resultPtr, 1) // Advance
1945 
1946                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1947                 resultPtr := add(resultPtr, 1) // Advance
1948             }
1949 
1950             // When data `bytes` is not exactly 3 bytes long
1951             // it is padded with `=` characters at the end
1952             switch mod(mload(data), 3)
1953             case 1 {
1954                 mstore8(sub(resultPtr, 1), 0x3d)
1955                 mstore8(sub(resultPtr, 2), 0x3d)
1956             }
1957             case 2 {
1958                 mstore8(sub(resultPtr, 1), 0x3d)
1959             }
1960         }
1961 
1962         return result;
1963     }
1964 }
1965 
1966 /// @title EIP-721 Metadata Update Extension
1967 interface IERC4906 is IERC721A {
1968     /// @dev This event emits when the metadata of a token is changed.
1969     /// Third-party platforms such as NFT marketplaces can listen to
1970     /// the event and auto-update the tokens in their apps.
1971     event MetadataUpdate(uint256 _tokenId);
1972 }
1973 
1974 contract LavaLamp is ERC721A, Ownable, DefaultOperatorFilterer, IERC4906 {
1975 
1976     mapping(uint => string) public hueValues;
1977     mapping(uint => bool) public isBurned;
1978     mapping(uint => bool) public isBlob;
1979 
1980     uint public maxWalletFree = 5;
1981 
1982     uint public MAX_SUPPLY = 2222;
1983 
1984     mapping(address => uint) public mintedPerAcc;
1985 
1986     enum Step {
1987         Before,
1988         PublicSale
1989     }
1990 
1991     Step public sellingStep;
1992 
1993     function mintForOwner() public onlyOwner{
1994         for (uint i = 0; i < 30; i++) {
1995             createNFT(_nextTokenId() + i); // init values
1996         }
1997         _mint(msg.sender, 30);
1998     }
1999 
2000     function uint2str(
2001         uint _i
2002     ) internal pure returns (string memory _uintAsString) {
2003         if (_i == 0) {
2004             return "0";
2005         }
2006         uint j = _i;
2007         uint len;
2008         while (j != 0) {
2009             len++;
2010             j /= 10;
2011         }
2012         bytes memory bstr = new bytes(len);
2013         uint k = len;
2014         while (_i != 0) {
2015             k = k - 1;
2016             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
2017             bytes1 b1 = bytes1(temp);
2018             bstr[k] = b1;
2019             _i /= 10;
2020         }
2021         return string(bstr);
2022     }
2023 
2024     function str2num(string memory numString) public pure returns(uint) {
2025         uint  val=0;
2026         bytes   memory stringBytes = bytes(numString);
2027         for (uint  i =  0; i<stringBytes.length; i++) {
2028             uint exp = stringBytes.length - i;
2029             bytes1 ival = stringBytes[i];
2030             uint8 uval = uint8(ival);
2031            uint jval = uval - uint(0x30);
2032    
2033            val +=  (uint(jval) * (10**(exp-1))); 
2034         }
2035       return val;
2036     }
2037 
2038     function changeMaxTxFree(uint newValue) public onlyOwner{
2039         maxWalletFree = newValue;
2040     }
2041 
2042     function createNFT(uint _ID) internal {       
2043         uint uintValue = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _ID))) % 1001;
2044         string memory hue = uint2str(uintValue);
2045         hueValues[_ID] = hue;
2046     }
2047 
2048     constructor() ERC721A("LavaLamp", "LavaLamp") {}
2049 
2050     function mint(uint quantity) public {
2051         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
2052         if(mintedPerAcc[msg.sender] + quantity > maxWalletFree) revert("Max exceeded");
2053         if(totalSupply() + quantity > MAX_SUPPLY) revert("Max supply exceeded");
2054         require(tx.origin == msg.sender, "Not the same caller");
2055         for (uint i = 0; i < quantity; i++) {
2056             createNFT(_nextTokenId() + i); // init values
2057         }
2058         _mint(msg.sender, quantity);
2059         mintedPerAcc[msg.sender] += quantity;
2060     }
2061 
2062     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator payable {
2063         super.transferFrom(from, to, tokenId);
2064     }
2065 
2066     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator payable {
2067         super.safeTransferFrom(from, to, tokenId);
2068     }
2069 
2070     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2071         public
2072         override(ERC721A, IERC721A)
2073         onlyAllowedOperator
2074         payable
2075     {
2076         super.safeTransferFrom(from, to, tokenId, data);
2077     }
2078 
2079     function setStep(uint _step) external onlyOwner {
2080         sellingStep = Step(_step);
2081     }
2082 
2083     function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2084         return segments.getMetadata(tokenId, hueValues[tokenId]);
2085     }
2086 
2087     function withdraw() external onlyOwner {
2088         require(payable(msg.sender).send(address(this).balance));
2089     }
2090 }