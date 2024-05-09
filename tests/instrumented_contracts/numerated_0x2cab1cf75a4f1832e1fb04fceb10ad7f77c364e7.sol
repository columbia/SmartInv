1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 /**
6  * @title MerkleProof
7  * @dev Merkle proof verification based on
8  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
9  */
10 library MerkleProof {
11   /**
12    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
13    * and each pair of pre-images are sorted.
14    * @param proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
15    * @param root Merkle root
16    * @param leaf Leaf of Merkle tree
17    */
18   function verify(
19     bytes32[] calldata proof,
20     bytes32 root,
21     bytes32 leaf
22   )
23     internal
24     pure
25     returns (bool)
26   {
27     bytes32 computedHash = leaf;
28 
29     for (uint256 i = 0; i < proof.length; i++) {
30       bytes32 proofElement = proof[i];
31 
32       if (computedHash < proofElement) {
33         // Hash(current computed hash + current element of the proof)
34         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
35       } else {
36         // Hash(current element of the proof + current computed hash)
37         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
38       }
39     }
40 
41     // Check if the computed hash (root) is equal to the provided root
42     return computedHash == root;
43   }
44 }
45 
46 /**
47  * @dev Provides information about the current execution context, including the
48  * sender of the transaction and its data. While these are generally available
49  * via msg.sender and msg.data, they should not be accessed in such a direct
50  * manner, since when dealing with meta-transactions the account sending and
51  * paying for execution may not be the actual sender (as far as an application
52  * is concerned).
53  *
54  * This contract is only required for intermediate, library-like contracts.
55  */
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 
61     function _msgData() internal view virtual returns (bytes calldata) {
62         return msg.data;
63     }
64 }
65 
66 /**
67  * @dev Contract module that helps prevent reentrant calls to a function.
68  *
69  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
70  * available, which can be applied to functions to make sure there are no nested
71  * (reentrant) calls to them.
72  *
73  * Note that because there is a single `nonReentrant` guard, functions marked as
74  * `nonReentrant` may not call one another. This can be worked around by making
75  * those functions `private`, and then adding `external` `nonReentrant` entry
76  * points to them.
77  *
78  * TIP: If you would like to learn more about reentrancy and alternative ways
79  * to protect against it, check out our blog post
80  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
81  */
82 abstract contract ReentrancyGuard {
83     // Booleans are more expensive than uint256 or any type that takes up a full
84     // word because each write operation emits an extra SLOAD to first read the
85     // slot's contents, replace the bits taken up by the boolean, and then write
86     // back. This is the compiler's defense against contract upgrades and
87     // pointer aliasing, and it cannot be disabled.
88 
89     // The values being non-zero value makes deployment a bit more expensive,
90     // but in exchange the refund on every call to nonReentrant will be lower in
91     // amount. Since refunds are capped to a percentage of the total
92     // transaction's gas, it is best to keep them low in cases like this one, to
93     // increase the likelihood of the full refund coming into effect.
94     uint256 private constant _NOT_ENTERED = 1;
95     uint256 private constant _ENTERED = 2;
96 
97     uint256 private _status;
98 
99     constructor() {
100         _status = _NOT_ENTERED;
101     }
102 
103     /**
104      * @dev Prevents a contract from calling itself, directly or indirectly.
105      * Calling a `nonReentrant` function from another `nonReentrant`
106      * function is not supported. It is possible to prevent this from happening
107      * by making the `nonReentrant` function external, and making it call a
108      * `private` function that does the actual work.
109      */
110     modifier nonReentrant() {
111         // On the first call to nonReentrant, _notEntered will be true
112         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
113 
114         // Any calls to nonReentrant after this point will fail
115         _status = _ENTERED;
116 
117         _;
118 
119         // By storing the original value once again, a refund is triggered (see
120         // https://eips.ethereum.org/EIPS/eip-2200)
121         _status = _NOT_ENTERED;
122     }
123 }
124 
125 /**
126  * @dev Contract module which provides a basic access control mechanism, where
127  * there is an account (an owner) that can be granted exclusive access to
128  * specific functions.
129  *
130  * By default, the owner account will be the one that deploys the contract. This
131  * can later be changed with {transferOwnership}.
132  *
133  * This module is used through inheritance. It will make available the modifier
134  * `onlyOwner`, which can be applied to your functions to restrict their use to
135  * the owner.
136  */
137 abstract contract Ownable is Context {
138     address private _owner;
139 
140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142     /**
143      * @dev Initializes the contract setting the deployer as the initial owner.
144      */
145     constructor() {
146         _setOwner(_msgSender());
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         _setOwner(address(0));
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         _setOwner(newOwner);
182     }
183 
184     function _setOwner(address newOwner) private {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 interface iFeasted {
192     function getFeastedInfo(uint tokenId) external view returns(uint);
193 }
194 
195 /**
196  * @dev Interface of ERC721A.
197  */
198 interface IERC721A {
199     /**
200      * The caller must own the token or be an approved operator.
201      */
202     error ApprovalCallerNotOwnerNorApproved();
203 
204     /**
205      * The token does not exist.
206      */
207     error ApprovalQueryForNonexistentToken();
208 
209     /**
210      * The caller cannot approve to their own address.
211      */
212     error ApproveToCaller();
213 
214     /**
215      * Cannot query the balance for the zero address.
216      */
217     error BalanceQueryForZeroAddress();
218 
219     /**
220      * Cannot mint to the zero address.
221      */
222     error MintToZeroAddress();
223 
224     /**
225      * The quantity of tokens minted must be more than zero.
226      */
227     error MintZeroQuantity();
228 
229     /**
230      * The token does not exist.
231      */
232     error OwnerQueryForNonexistentToken();
233 
234     /**
235      * The caller must own the token or be an approved operator.
236      */
237     error TransferCallerNotOwnerNorApproved();
238 
239     /**
240      * The token must be owned by `from`.
241      */
242     error TransferFromIncorrectOwner();
243 
244     /**
245      * Cannot safely transfer to a contract that does not implement the
246      * ERC721Receiver interface.
247      */
248     error TransferToNonERC721ReceiverImplementer();
249 
250     /**
251      * Cannot transfer to the zero address.
252      */
253     error TransferToZeroAddress();
254 
255     /**
256      * The token does not exist.
257      */
258     error URIQueryForNonexistentToken();
259 
260     /**
261      * The `quantity` minted with ERC2309 exceeds the safety limit.
262      */
263     error MintERC2309QuantityExceedsLimit();
264 
265     /**
266      * The `extraData` cannot be set on an unintialized ownership slot.
267      */
268     error OwnershipNotInitializedForExtraData();
269 
270     // =============================================================
271     //                            STRUCTS
272     // =============================================================
273 
274     struct TokenOwnership {
275         // The address of the owner.
276         address addr;
277         // Stores the start time of ownership with minimal overhead for tokenomics.
278         uint64 startTimestamp;
279         // Whether the token has been burned.
280         bool burned;
281         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
282         uint24 extraData;
283     }
284 
285     // =============================================================
286     //                         TOKEN COUNTERS
287     // =============================================================
288 
289     /**
290      * @dev Returns the total number of tokens in existence.
291      * Burned tokens will reduce the count.
292      * To get the total number of tokens minted, please see {_totalMinted}.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     // =============================================================
297     //                            IERC165
298     // =============================================================
299 
300     /**
301      * @dev Returns true if this contract implements the interface defined by
302      * `interfaceId`. See the corresponding
303      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
304      * to learn more about how these ids are created.
305      *
306      * This function call must use less than 30000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
309 
310     // =============================================================
311     //                            IERC721
312     // =============================================================
313 
314     /**
315      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
321      */
322     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
323 
324     /**
325      * @dev Emitted when `owner` enables or disables
326      * (`approved`) `operator` to manage all of its assets.
327      */
328     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
329 
330     /**
331      * @dev Returns the number of tokens in `owner`'s account.
332      */
333     function balanceOf(address owner) external view returns (uint256 balance);
334 
335     /**
336      * @dev Returns the owner of the `tokenId` token.
337      *
338      * Requirements:
339      *
340      * - `tokenId` must exist.
341      */
342     function ownerOf(uint256 tokenId) external view returns (address owner);
343 
344     /**
345      * @dev Safely transfers `tokenId` token from `from` to `to`,
346      * checking first that contract recipients are aware of the ERC721 protocol
347      * to prevent tokens from being forever locked.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be have been allowed to move
355      * this token by either {approve} or {setApprovalForAll}.
356      * - If `to` refers to a smart contract, it must implement
357      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
358      *
359      * Emits a {Transfer} event.
360      */
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 tokenId,
365         bytes calldata data
366     ) external;
367 
368     /**
369      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external;
376 
377     /**
378      * @dev Transfers `tokenId` from `from` to `to`.
379      *
380      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
381      * whenever possible.
382      *
383      * Requirements:
384      *
385      * - `from` cannot be the zero address.
386      * - `to` cannot be the zero address.
387      * - `tokenId` token must be owned by `from`.
388      * - If the caller is not `from`, it must be approved to move this token
389      * by either {approve} or {setApprovalForAll}.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399     /**
400      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
401      * The approval is cleared when the token is transferred.
402      *
403      * Only a single account can be approved at a time, so approving the
404      * zero address clears previous approvals.
405      *
406      * Requirements:
407      *
408      * - The caller must own the token or be an approved operator.
409      * - `tokenId` must exist.
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address to, uint256 tokenId) external;
414 
415     /**
416      * @dev Approve or remove `operator` as an operator for the caller.
417      * Operators can call {transferFrom} or {safeTransferFrom}
418      * for any token owned by the caller.
419      *
420      * Requirements:
421      *
422      * - The `operator` cannot be the caller.
423      *
424      * Emits an {ApprovalForAll} event.
425      */
426     function setApprovalForAll(address operator, bool _approved) external;
427 
428     /**
429      * @dev Returns the account approved for `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function getApproved(uint256 tokenId) external view returns (address operator);
436 
437     /**
438      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
439      *
440      * See {setApprovalForAll}.
441      */
442     function isApprovedForAll(address owner, address operator) external view returns (bool);
443 
444     // =============================================================
445     //                        IERC721Metadata
446     // =============================================================
447 
448     /**
449      * @dev Returns the token collection name.
450      */
451     function name() external view returns (string memory);
452 
453     /**
454      * @dev Returns the token collection symbol.
455      */
456     function symbol() external view returns (string memory);
457 
458     /**
459      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
460      */
461     function tokenURI(uint256 tokenId) external view returns (string memory);
462 
463     // =============================================================
464     //                           IERC2309
465     // =============================================================
466 
467     /**
468      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
469      * (inclusive) is transferred from `from` to `to`, as defined in the
470      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
471      *
472      * See {_mintERC2309} for more details.
473      */
474     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
475 }
476 
477 /**
478  * @dev Interface of ERC721 token receiver.
479  */
480 interface ERC721A__IERC721Receiver {
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 /**
490  * @title ERC721A
491  *
492  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
493  * Non-Fungible Token Standard, including the Metadata extension.
494  * Optimized for lower gas during batch mints.
495  *
496  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
497  * starting from `_startTokenId()`.
498  *
499  * Assumptions:
500  *
501  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
502  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
503  */
504 contract ERC721A is IERC721A, iFeasted {
505     // Reference type for token approval.
506     struct TokenApprovalRef {
507         address value;
508     }
509 
510     // =============================================================
511     //                           CONSTANTS
512     // =============================================================
513 
514     // Mask of an entry in packed address data.
515     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
516 
517     // The bit position of `numberMinted` in packed address data.
518     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
519 
520     // The bit position of `numberBurned` in packed address data.
521     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
522 
523     // The bit position of `aux` in packed address data.
524     uint256 private constant _BITPOS_AUX = 192;
525 
526     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
527     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
528 
529     // The bit position of `startTimestamp` in packed ownership.
530     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
531 
532     // The bit mask of the `burned` bit in packed ownership.
533     uint256 private constant _BITMASK_BURNED = 1 << 224;
534 
535     // The bit position of the `nextInitialized` bit in packed ownership.
536     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
537 
538     // The bit mask of the `nextInitialized` bit in packed ownership.
539     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
540 
541     // The bit position of `extraData` in packed ownership.
542     uint256 private constant _BITPOS_EXTRA_DATA = 232;
543 
544     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
545     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
546 
547     // The mask of the lower 160 bits for addresses.
548     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
549 
550     // The maximum `quantity` that can be minted with {_mintERC2309}.
551     // This limit is to prevent overflows on the address data entries.
552     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
553     // is required to cause an overflow, which is unrealistic.
554     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
555 
556     // The `Transfer` event signature is given by:
557     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
558     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
559         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
560 
561     // =============================================================
562     //                            STORAGE
563     // =============================================================
564 
565     // The next token ID to be minted.
566     uint256 private _currentIndex = 1;
567 
568     // The number of tokens burned.
569     uint256 private _burnCounter;
570 
571     // Cannibal ID Counter
572     uint256 internal feastCounter = 1;
573 
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Cannibal URI
581     string public cannibalURI;
582 
583     // Mapping from token ID to ownership details
584     // An empty struct value does not necessarily mean the token is unowned.
585     // See {_packedOwnershipOf} implementation for details.
586     //
587     // Bits Layout:
588     // - [0..159]   `addr`
589     // - [160..223] `startTimestamp`
590     // - [224]      `burned`
591     // - [225]      `nextInitialized`
592     // - [232..255] `extraData`
593     mapping(uint256 => uint256) private _packedOwnerships;
594 
595     // Mapping owner address to address data.
596     //
597     // Bits Layout:
598     // - [0..63]    `balance`
599     // - [64..127]  `numberMinted`
600     // - [128..191] `numberBurned`
601     // - [192..255] `aux`
602     mapping(address => uint256) private _packedAddressData;
603 
604     // Mapping from token ID to approved address.
605     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
606 
607     // Mapping from owner to operator approvals
608     mapping(address => mapping(address => bool)) private _operatorApprovals;
609 
610     // Mapping from token ID to CannibalURI
611     mapping(uint => uint) public _feastedURI;
612 
613     // Mapping from token ID to feast function used
614     mapping(uint => uint) public _feastedCounters;
615 
616     // =============================================================
617     //                          CONSTRUCTOR
618     // =============================================================
619 
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623         _currentIndex = _startTokenId();
624     }
625 
626     // =============================================================
627     //                   TOKEN COUNTING OPERATIONS
628     // =============================================================
629 
630     /**
631      * @dev Returns the starting token ID.
632      * To change the starting token ID, please override this function.
633      */
634     function _startTokenId() internal view virtual returns (uint256) {
635         return 1;
636     }
637 
638     /**
639      * @dev Returns the next token ID to be minted.
640      */
641     function _nextTokenId() internal view virtual returns (uint256) {
642         return _currentIndex;
643     }
644 
645     /**
646      * @dev Returns the total number of tokens in existence.
647      * Burned tokens will reduce the count.
648      * To get the total number of tokens minted, please see {_totalMinted}.
649      */
650     function totalSupply() public view virtual override returns (uint256) {
651         // Counter underflow is impossible as _burnCounter cannot be incremented
652         // more than `_currentIndex - _startTokenId()` times.
653         unchecked {
654             return _currentIndex - _burnCounter - _startTokenId();
655         }
656     }
657 
658     function getFeastedInfo(uint tokenId) public view virtual override returns(uint) {
659         return _feastedCounters[tokenId];
660     }
661 
662     /**
663      * @dev Returns the total amount of tokens minted in the contract.
664      */
665     function _totalMinted() internal view virtual returns (uint256) {
666         // Counter underflow is impossible as `_currentIndex` does not decrement,
667         // and it is initialized to `_startTokenId()`.
668         unchecked {
669             return _currentIndex - _startTokenId();
670         }
671     }
672 
673     /**
674      * @dev Returns the total number of tokens burned.
675      */
676     function _totalBurned() internal view virtual returns (uint256) {
677         return _burnCounter;
678     }
679 
680     // =============================================================
681     //                    ADDRESS DATA OPERATIONS
682     // =============================================================
683 
684     /**
685      * @dev Returns the number of tokens in `owner`'s account.
686      */
687     function balanceOf(address owner) public view virtual override returns (uint256) {
688         if (owner == address(0)) revert BalanceQueryForZeroAddress();
689         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the number of tokens minted by `owner`.
694      */
695     function _numberMinted(address owner) internal view returns (uint256) {
696         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
697     }
698 
699     /**
700      * Returns the number of tokens burned by or on behalf of `owner`.
701      */
702     function _numberBurned(address owner) internal view returns (uint256) {
703         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
704     }
705 
706     /**
707      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
708      */
709     function _getAux(address owner) internal view returns (uint64) {
710         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
711     }
712 
713     /**
714      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
715      * If there are multiple variables, please pack them into a uint64.
716      */
717     function _setAux(address owner, uint64 aux) internal virtual {
718         uint256 packed = _packedAddressData[owner];
719         uint256 auxCasted;
720         // Cast `aux` with assembly to avoid redundant masking.
721         assembly {
722             auxCasted := aux
723         }
724         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
725         _packedAddressData[owner] = packed;
726     }
727 
728     // =============================================================
729     //                            IERC165
730     // =============================================================
731 
732     /**
733      * @dev Returns true if this contract implements the interface defined by
734      * `interfaceId`. See the corresponding
735      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
736      * to learn more about how these ids are created.
737      *
738      * This function call must use less than 30000 gas.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         // The interface IDs are constants representing the first 4 bytes
742         // of the XOR of all function selectors in the interface.
743         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
744         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
745         return
746             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
747             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
748             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
749     }
750 
751     // =============================================================
752     //                        IERC721Metadata
753     // =============================================================
754 
755     /**
756      * @dev Returns the token collection name.
757      */
758     function name() public view virtual override returns (string memory) {
759         return _name;
760     }
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() public view virtual override returns (string memory) {
766         return _symbol;
767     }
768 
769     /**
770      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
771      */
772     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
773         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
774 
775         if(_feastedURI[tokenId] > 0){
776             return bytes(cannibalURI).length != 0 ? string(abi.encodePacked(cannibalURI, _toString(_feastedURI[tokenId]), ".json")) : '';
777         }else{
778             string memory baseURI = _baseURI();
779             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
780         }
781     }
782 
783     /**
784      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
785      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
786      * by default, it can be overridden in child contracts.
787      */
788     function _baseURI() internal view virtual returns (string memory) {
789         return '';
790     }
791 
792     // =============================================================
793     //                     OWNERSHIPS OPERATIONS
794     // =============================================================
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
804         return address(uint160(_packedOwnershipOf(tokenId)));
805     }
806 
807     /**
808      * @dev Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around over time.
810      */
811     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
812         return _unpackedOwnership(_packedOwnershipOf(tokenId));
813     }
814 
815     /**
816      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
817      */
818     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
819         return _unpackedOwnership(_packedOwnerships[index]);
820     }
821 
822     /**
823      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
824      */
825     function _initializeOwnershipAt(uint256 index) internal virtual {
826         if (_packedOwnerships[index] == 0) {
827             _packedOwnerships[index] = _packedOwnershipOf(index);
828         }
829     }
830 
831     /**
832      * Returns the packed ownership data of `tokenId`.
833      */
834     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
835         uint256 curr = tokenId;
836 
837         unchecked {
838             if (_startTokenId() <= curr)
839                 if (curr < _currentIndex) {
840                     uint256 packed = _packedOwnerships[curr];
841                     // If not burned.
842                     if (packed & _BITMASK_BURNED == 0) {
843                         // Invariant:
844                         // There will always be an initialized ownership slot
845                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
846                         // before an unintialized ownership slot
847                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
848                         // Hence, `curr` will not underflow.
849                         //
850                         // We can directly compare the packed value.
851                         // If the address is zero, packed will be zero.
852                         while (packed == 0) {
853                             packed = _packedOwnerships[--curr];
854                         }
855                         return packed;
856                     }
857                 }
858         }
859         revert OwnerQueryForNonexistentToken();
860     }
861 
862     /**
863      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
864      */
865     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
866         ownership.addr = address(uint160(packed));
867         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
868         ownership.burned = packed & _BITMASK_BURNED != 0;
869         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
870     }
871 
872     /**
873      * @dev Packs ownership data into a single uint256.
874      */
875     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
876         assembly {
877             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
878             owner := and(owner, _BITMASK_ADDRESS)
879             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
880             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
881         }
882     }
883 
884     /**
885      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
886      */
887     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
888         // For branchless setting of the `nextInitialized` flag.
889         assembly {
890             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
891             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
892         }
893     }
894 
895     // =============================================================
896     //                      APPROVAL OPERATIONS
897     // =============================================================
898 
899     /**
900      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
901      * The approval is cleared when the token is transferred.
902      *
903      * Only a single account can be approved at a time, so approving the
904      * zero address clears previous approvals.
905      *
906      * Requirements:
907      *
908      * - The caller must own the token or be an approved operator.
909      * - `tokenId` must exist.
910      *
911      * Emits an {Approval} event.
912      */
913     function approve(address to, uint256 tokenId) public virtual override {
914         address owner = ownerOf(tokenId);
915 
916         if (_msgSenderERC721A() != owner)
917             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
918                 revert ApprovalCallerNotOwnerNorApproved();
919             }
920 
921         _tokenApprovals[tokenId].value = to;
922         emit Approval(owner, to, tokenId);
923     }
924 
925     /**
926      * @dev Returns the account approved for `tokenId` token.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
933         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
934 
935         return _tokenApprovals[tokenId].value;
936     }
937 
938     /**
939      * @dev Approve or remove `operator` as an operator for the caller.
940      * Operators can call {transferFrom} or {safeTransferFrom}
941      * for any token owned by the caller.
942      *
943      * Requirements:
944      *
945      * - The `operator` cannot be the caller.
946      *
947      * Emits an {ApprovalForAll} event.
948      */
949     function setApprovalForAll(address operator, bool approved) public virtual override {
950         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
951 
952         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
953         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
954     }
955 
956     /**
957      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
958      *
959      * See {setApprovalForAll}.
960      */
961     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
962         return _operatorApprovals[owner][operator];
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted. See {_mint}.
971      */
972     function _exists(uint256 tokenId) internal view virtual returns (bool) {
973         return
974             _startTokenId() <= tokenId &&
975             tokenId < _currentIndex && // If within bounds,
976             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
977     }
978 
979     /**
980      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
981      */
982     function _isSenderApprovedOrOwner(
983         address approvedAddress,
984         address owner,
985         address msgSender
986     ) private pure returns (bool result) {
987         assembly {
988             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
989             owner := and(owner, _BITMASK_ADDRESS)
990             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
991             msgSender := and(msgSender, _BITMASK_ADDRESS)
992             // `msgSender == owner || msgSender == approvedAddress`.
993             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
994         }
995     }
996 
997     /**
998      * @dev Returns the storage slot and value for the approved address of `tokenId`.
999      */
1000     function _getApprovedSlotAndAddress(uint256 tokenId)
1001         private
1002         view
1003         returns (uint256 approvedAddressSlot, address approvedAddress)
1004     {
1005         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1006         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1007         assembly {
1008             approvedAddressSlot := tokenApproval.slot
1009             approvedAddress := sload(approvedAddressSlot)
1010         }
1011     }
1012 
1013     // =============================================================
1014     //                      TRANSFER OPERATIONS
1015     // =============================================================
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      * - If the caller is not `from`, it must be approved to move this token
1026      * by either {approve} or {setApprovalForAll}.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1036 
1037         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1038 
1039         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1040 
1041         // The nested ifs save around 20+ gas over a compound boolean condition.
1042         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1043             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1044 
1045         if (to == address(0)) revert TransferToZeroAddress();
1046 
1047         _beforeTokenTransfers(from, to, tokenId, 1);
1048 
1049         // Clear approvals from the previous owner.
1050         assembly {
1051             if approvedAddress {
1052                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1053                 sstore(approvedAddressSlot, 0)
1054             }
1055         }
1056 
1057         // Underflow of the sender's balance is impossible because we check for
1058         // ownership above and the recipient's balance can't realistically overflow.
1059         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1060         unchecked {
1061             // We can directly increment and decrement the balances.
1062             --_packedAddressData[from]; // Updates: `balance -= 1`.
1063             ++_packedAddressData[to]; // Updates: `balance += 1`.
1064 
1065             // Updates:
1066             // - `address` to the next owner.
1067             // - `startTimestamp` to the timestamp of transfering.
1068             // - `burned` to `false`.
1069             // - `nextInitialized` to `true`.
1070             _packedOwnerships[tokenId] = _packOwnershipData(
1071                 to,
1072                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1073             );
1074 
1075             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1076             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1077                 uint256 nextTokenId = tokenId + 1;
1078                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1079                 if (_packedOwnerships[nextTokenId] == 0) {
1080                     // If the next slot is within bounds.
1081                     if (nextTokenId != _currentIndex) {
1082                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1083                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1084                     }
1085                 }
1086             }
1087         }
1088 
1089         emit Transfer(from, to, tokenId);
1090         _afterTokenTransfers(from, to, tokenId, 1);
1091     }
1092 
1093     /**
1094      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         safeTransferFrom(from, to, tokenId, '');
1102     }
1103 
1104     /**
1105      * @dev Safely transfers `tokenId` token from `from` to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `from` cannot be the zero address.
1110      * - `to` cannot be the zero address.
1111      * - `tokenId` token must exist and be owned by `from`.
1112      * - If the caller is not `from`, it must be approved to move this token
1113      * by either {approve} or {setApprovalForAll}.
1114      * - If `to` refers to a smart contract, it must implement
1115      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId,
1123         bytes memory _data
1124     ) public virtual override {
1125         transferFrom(from, to, tokenId);
1126         if (to.code.length != 0)
1127             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1128                 revert TransferToNonERC721ReceiverImplementer();
1129             }
1130     }
1131 
1132     /**
1133      * @dev Hook that is called before a set of serially-ordered token IDs
1134      * are about to be transferred. This includes minting.
1135      * And also called before burning one token.
1136      *
1137      * `startTokenId` - the first token ID to be transferred.
1138      * `quantity` - the amount to be transferred.
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, `tokenId` will be burned by `from`.
1146      * - `from` and `to` are never both zero.
1147      */
1148     function _beforeTokenTransfers(
1149         address from,
1150         address to,
1151         uint256 startTokenId,
1152         uint256 quantity
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after a set of serially-ordered token IDs
1157      * have been transferred. This includes minting.
1158      * And also called after one token has been burned.
1159      *
1160      * `startTokenId` - the first token ID to be transferred.
1161      * `quantity` - the amount to be transferred.
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` has been minted for `to`.
1168      * - When `to` is zero, `tokenId` has been burned by `from`.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _afterTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1180      *
1181      * `from` - Previous owner of the given token ID.
1182      * `to` - Target address that will receive the token.
1183      * `tokenId` - Token ID to be transferred.
1184      * `_data` - Optional data to send along with the call.
1185      *
1186      * Returns whether the call correctly returned the expected magic value.
1187      */
1188     function _checkContractOnERC721Received(
1189         address from,
1190         address to,
1191         uint256 tokenId,
1192         bytes memory _data
1193     ) private returns (bool) {
1194         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1195             bytes4 retval
1196         ) {
1197             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1198         } catch (bytes memory reason) {
1199             if (reason.length == 0) {
1200                 revert TransferToNonERC721ReceiverImplementer();
1201             } else {
1202                 assembly {
1203                     revert(add(32, reason), mload(reason))
1204                 }
1205             }
1206         }
1207     }
1208 
1209     // =============================================================
1210     //                        MINT OPERATIONS
1211     // =============================================================
1212 
1213     /**
1214      * @dev Mints `quantity` tokens and transfers them to `to`.
1215      *
1216      * Requirements:
1217      *
1218      * - `to` cannot be the zero address.
1219      * - `quantity` must be greater than 0.
1220      *
1221      * Emits a {Transfer} event for each mint.
1222      */
1223     function _mint(address to, uint256 quantity) internal virtual {
1224         uint256 startTokenId = _currentIndex;
1225         if (quantity == 0) revert MintZeroQuantity();
1226 
1227         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1228 
1229         // Overflows are incredibly unrealistic.
1230         // `balance` and `numberMinted` have a maximum limit of 2**64.
1231         // `tokenId` has a maximum limit of 2**256.
1232         unchecked {
1233             // Updates:
1234             // - `balance += quantity`.
1235             // - `numberMinted += quantity`.
1236             //
1237             // We can directly add to the `balance` and `numberMinted`.
1238             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1239 
1240             // Updates:
1241             // - `address` to the owner.
1242             // - `startTimestamp` to the timestamp of minting.
1243             // - `burned` to `false`.
1244             // - `nextInitialized` to `quantity == 1`.
1245             _packedOwnerships[startTokenId] = _packOwnershipData(
1246                 to,
1247                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1248             );
1249 
1250             uint256 toMasked;
1251             uint256 end = startTokenId + quantity;
1252 
1253             // Use assembly to loop and emit the `Transfer` event for gas savings.
1254             assembly {
1255                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1256                 toMasked := and(to, _BITMASK_ADDRESS)
1257                 // Emit the `Transfer` event.
1258                 log4(
1259                     0, // Start of data (0, since no data).
1260                     0, // End of data (0, since no data).
1261                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1262                     0, // `address(0)`.
1263                     toMasked, // `to`.
1264                     startTokenId // `tokenId`.
1265                 )
1266 
1267                 for {
1268                     let tokenId := add(startTokenId, 1)
1269                 } iszero(eq(tokenId, end)) {
1270                     tokenId := add(tokenId, 1)
1271                 } {
1272                     // Emit the `Transfer` event. Similar to above.
1273                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1274                 }
1275             }
1276             if (toMasked == 0) revert MintToZeroAddress();
1277 
1278             _currentIndex = end;
1279         }
1280         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1281     }
1282 
1283     /**
1284      * @dev Mints `quantity` tokens and transfers them to `to`.
1285      *
1286      * This function is intended for efficient minting only during contract creation.
1287      *
1288      * It emits only one {ConsecutiveTransfer} as defined in
1289      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1290      * instead of a sequence of {Transfer} event(s).
1291      *
1292      * Calling this function outside of contract creation WILL make your contract
1293      * non-compliant with the ERC721 standard.
1294      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1295      * {ConsecutiveTransfer} event is only permissible during contract creation.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `quantity` must be greater than 0.
1301      *
1302      * Emits a {ConsecutiveTransfer} event.
1303      */
1304     function _mintERC2309(address to, uint256 quantity) internal virtual {
1305         uint256 startTokenId = _currentIndex;
1306         if (to == address(0)) revert MintToZeroAddress();
1307         if (quantity == 0) revert MintZeroQuantity();
1308         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1309 
1310         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1311 
1312         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1313         unchecked {
1314             // Updates:
1315             // - `balance += quantity`.
1316             // - `numberMinted += quantity`.
1317             //
1318             // We can directly add to the `balance` and `numberMinted`.
1319             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1320 
1321             // Updates:
1322             // - `address` to the owner.
1323             // - `startTimestamp` to the timestamp of minting.
1324             // - `burned` to `false`.
1325             // - `nextInitialized` to `quantity == 1`.
1326             _packedOwnerships[startTokenId] = _packOwnershipData(
1327                 to,
1328                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1329             );
1330 
1331             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1332 
1333             _currentIndex = startTokenId + quantity;
1334         }
1335         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1336     }
1337 
1338     /**
1339      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1340      *
1341      * Requirements:
1342      *
1343      * - If `to` refers to a smart contract, it must implement
1344      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1345      * - `quantity` must be greater than 0.
1346      *
1347      * See {_mint}.
1348      *
1349      * Emits a {Transfer} event for each mint.
1350      */
1351     function _safeMint(
1352         address to,
1353         uint256 quantity,
1354         bytes memory _data
1355     ) internal virtual {
1356         _mint(to, quantity);
1357 
1358         unchecked {
1359             if (to.code.length != 0) {
1360                 uint256 end = _currentIndex;
1361                 uint256 index = end - quantity;
1362                 do {
1363                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1364                         revert TransferToNonERC721ReceiverImplementer();
1365                     }
1366                 } while (index < end);
1367                 // Reentrancy protection.
1368                 if (_currentIndex != end) revert();
1369             }
1370         }
1371     }
1372 
1373     /**
1374      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1375      */
1376     function _safeMint(address to, uint256 quantity) internal virtual {
1377         _safeMint(to, quantity, '');
1378     }
1379 
1380     // =============================================================
1381     //                        BURN OPERATIONS
1382     // =============================================================
1383 
1384     /**
1385      * @dev Equivalent to `_burn(tokenId, false)`.
1386      */
1387     function _burn(uint256 tokenId) internal virtual {
1388         _burn(tokenId, false);
1389     }
1390 
1391     /**
1392      * @dev Destroys `tokenId`.
1393      * The approval is cleared when the token is burned.
1394      *
1395      * Requirements:
1396      *
1397      * - `tokenId` must exist.
1398      *
1399      * Emits a {Transfer} event.
1400      */
1401     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1402         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1403 
1404         address from = address(uint160(prevOwnershipPacked));
1405 
1406         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1407 
1408         if (approvalCheck) {
1409             // The nested ifs save around 20+ gas over a compound boolean condition.
1410             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1411                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1412         }
1413 
1414         _beforeTokenTransfers(from, address(0), tokenId, 1);
1415 
1416         // Clear approvals from the previous owner.
1417         assembly {
1418             if approvedAddress {
1419                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1420                 sstore(approvedAddressSlot, 0)
1421             }
1422         }
1423 
1424         // Underflow of the sender's balance is impossible because we check for
1425         // ownership above and the recipient's balance can't realistically overflow.
1426         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1427         unchecked {
1428             // Updates:
1429             // - `balance -= 1`.
1430             // - `numberBurned += 1`.
1431             //
1432             // We can directly decrement the balance, and increment the number burned.
1433             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1434             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1435 
1436             // Updates:
1437             // - `address` to the last owner.
1438             // - `startTimestamp` to the timestamp of burning.
1439             // - `burned` to `true`.
1440             // - `nextInitialized` to `true`.
1441             _packedOwnerships[tokenId] = _packOwnershipData(
1442                 from,
1443                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1444             );
1445 
1446             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1447             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1448                 uint256 nextTokenId = tokenId + 1;
1449                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1450                 if (_packedOwnerships[nextTokenId] == 0) {
1451                     // If the next slot is within bounds.
1452                     if (nextTokenId != _currentIndex) {
1453                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1454                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1455                     }
1456                 }
1457             }
1458         }
1459 
1460         emit Transfer(from, address(0), tokenId);
1461         _afterTokenTransfers(from, address(0), tokenId, 1);
1462 
1463         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1464         unchecked {
1465             _burnCounter++;
1466         }
1467     }
1468 
1469     // =============================================================
1470     //                     EXTRA DATA OPERATIONS
1471     // =============================================================
1472 
1473     /**
1474      * @dev Directly sets the extra data for the ownership data `index`.
1475      */
1476     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1477         uint256 packed = _packedOwnerships[index];
1478         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1479         uint256 extraDataCasted;
1480         // Cast `extraData` with assembly to avoid redundant masking.
1481         assembly {
1482             extraDataCasted := extraData
1483         }
1484         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1485         _packedOwnerships[index] = packed;
1486     }
1487 
1488     /**
1489      * @dev Called during each token transfer to set the 24bit `extraData` field.
1490      * Intended to be overridden by the cosumer contract.
1491      *
1492      * `previousExtraData` - the value of `extraData` before transfer.
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` will be minted for `to`.
1499      * - When `to` is zero, `tokenId` will be burned by `from`.
1500      * - `from` and `to` are never both zero.
1501      */
1502     function _extraData(
1503         address from,
1504         address to,
1505         uint24 previousExtraData
1506     ) internal view virtual returns (uint24) {}
1507 
1508     /**
1509      * @dev Returns the next extra data for the packed ownership data.
1510      * The returned result is shifted into position.
1511      */
1512     function _nextExtraData(
1513         address from,
1514         address to,
1515         uint256 prevOwnershipPacked
1516     ) private view returns (uint256) {
1517         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1518         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1519     }
1520 
1521     // =============================================================
1522     //                       OTHER OPERATIONS
1523     // =============================================================
1524 
1525     /**
1526      * @dev Returns the message sender (defaults to `msg.sender`).
1527      *
1528      * If you are writing GSN compatible contracts, you need to override this function.
1529      */
1530     function _msgSenderERC721A() internal view virtual returns (address) {
1531         return msg.sender;
1532     }
1533 
1534     /**
1535      * @dev Converts a uint256 to its ASCII string decimal representation.
1536      */
1537     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1538         assembly {
1539             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1540             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1541             // We will need 1 32-byte word to store the length,
1542             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1543             str := add(mload(0x40), 0x80)
1544             // Update the free memory pointer to allocate.
1545             mstore(0x40, str)
1546 
1547             // Cache the end of the memory to calculate the length later.
1548             let end := str
1549 
1550             // We write the string from rightmost digit to leftmost digit.
1551             // The following is essentially a do-while loop that also handles the zero case.
1552             // prettier-ignore
1553             for { let temp := value } 1 {} {
1554                 str := sub(str, 1)
1555                 // Write the character to the pointer.
1556                 // The ASCII index of the '0' character is 48.
1557                 mstore8(str, add(48, mod(temp, 10)))
1558                 // Keep dividing `temp` until zero.
1559                 temp := div(temp, 10)
1560                 // prettier-ignore
1561                 if iszero(temp) { break }
1562             }
1563 
1564             let length := sub(end, str)
1565             // Move the pointer 32 bytes leftwards to make room for the length.
1566             str := sub(str, 0x20)
1567             // Store the length.
1568             mstore(str, length)
1569         }
1570     }
1571 }
1572 
1573 /*
1574        ________  __    __  ________         ______    ______   __    __  __    __  ______  _______    ______   __        ______   
1575       |        \|  \  |  \|        \       /      \  /      \ |  \  |  \|  \  |  \|      \|       \  /      \ |  \      /      \ 
1576        \$$$$$$$$| $$  | $$| $$$$$$$$      |  $$$$$$\|  $$$$$$\| $$\ | $$| $$\ | $$ \$$$$$$| $$$$$$$\|  $$$$$$\| $$     |  $$$$$$\
1577          | $$   | $$__| $$| $$__          | $$   \$$| $$__| $$| $$$\| $$| $$$\| $$  | $$  | $$__/ $$| $$__| $$| $$     | $$___\$$
1578          | $$   | $$    $$| $$  \         | $$      | $$    $$| $$$$\ $$| $$$$\ $$  | $$  | $$    $$| $$    $$| $$      \$$    \ 
1579          | $$   | $$$$$$$$| $$$$$         | $$   __ | $$$$$$$$| $$\$$ $$| $$\$$ $$  | $$  | $$$$$$$\| $$$$$$$$| $$      _\$$$$$$\
1580          | $$   | $$  | $$| $$_____       | $$__/  \| $$  | $$| $$ \$$$$| $$ \$$$$ _| $$_ | $$__/ $$| $$  | $$| $$_____|  \__| $$
1581          | $$   | $$  | $$| $$     \       \$$    $$| $$  | $$| $$  \$$$| $$  \$$$|   $$ \| $$    $$| $$  | $$| $$     \\$$    $$
1582           \$$    \$$   \$$ \$$$$$$$$        \$$$$$$  \$$   \$$ \$$   \$$ \$$   \$$ \$$$$$$ \$$$$$$$  \$$   \$$ \$$$$$$$$ \$$$$$$ 
1583                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
1584 */
1585 
1586 contract TheCannibals is ERC721A, Ownable, ReentrancyGuard {
1587 
1588     // ---------------------------------------------------------------------------------------------
1589     // INIZIALIZATION
1590     // ---------------------------------------------------------------------------------------------
1591 
1592     constructor() ERC721A("The Cannibals", "FEAST") {
1593         uri = "ipfs://bafybeiaeogtfn42mvewxj7fijbhivgtdiwrbvskiczlbmhgjti254l55fa/";
1594         _safeMint(0x0Dc63950FB46d0496d0812E38e9E6E75e62f51Dd, 25);
1595         _safeMint(0x5d849DAfCb92baF7426EFD6D6bFbA74d823D27C7, 15);
1596         _safeMint(0x6a7E0BD754FbA5355EFd85BF0896DD80D7FC64D3, 15);
1597         _safeMint(0xb23e3c30CEE40b6F07cee3705E3Ab2198c3b9F2D, 15);
1598         _safeMint(0x3079a30EC75471a58dF4ecF0E559007B2F014AFC, 15);
1599         _safeMint(0x62A48d25C509585eF1b94aDA62E7Eb16E0969c41, 10);
1600         _safeMint(0xEd001B005C1BFFE13694990e7b9abE74d98D5178, 50);
1601         _safeMint(0x1Ae93A64c6F013411d2BC94980A658392C40E3D1, 3);
1602         _safeMint(0x721386D3a8Be59c4090A0804f671755b18C22E24, 3);
1603         _safeMint(0x91757aaA0863b894865E5701a9a9c49E2e54e52D, 3);
1604         _safeMint(0xde26eCF4bd74bb7cA4c9c08C30Fd8638b369e579, 3);
1605         _safeMint(0xFF157f3e833F30599c2dA884F7Ba207c07f411C9, 5);
1606         _safeMint(0xCaF98643f0ef432A23A1B63123a99AaDF795e544, 5);
1607         _safeMint(0xa5c0722e0141c75fcFA1BdE7D390850Eb046D939, 5);
1608         _safeMint(0xB441712335946D3Ef454182EAf598dea053e35a0, 14);
1609         _safeMint(0x03a1190Da7346f36c504C222e0Eef9A1B0C33e6A, 14);
1610         platinumMinted += 200;
1611     }
1612 
1613     // ---------------------------------------------------------------------------------------------
1614     // EVENTS
1615     // ---------------------------------------------------------------------------------------------
1616 
1617     event CannibalReveal (string cannibalURI);
1618     event TicketReveal (string previousURI, string newURI);    
1619     event Feast (address wallet, uint feasted, uint feastedOn);
1620 
1621     // ---------------------------------------------------------------------------------------------
1622     // CONSTANTS
1623     // ---------------------------------------------------------------------------------------------
1624 
1625     uint16 private constant MAX_PER_TX = 3; 
1626     uint16 private constant MAX_PER_WALLET = 3; 
1627     uint32 private constant VIP_SUPPLY = 7000;       
1628     uint32 private constant MAX_SUPPLY = 10000;
1629     uint32 private constant PLATINUM_SUPPLY = 3000; 
1630     uint64 private constant VIP_PRICE = 0.015 ether;    
1631     uint64 private constant PUBLIC_PRICE = 0.025 ether;
1632 
1633     // ---------------------------------------------------------------------------------------------
1634     // VARIABLES
1635     // ---------------------------------------------------------------------------------------------
1636 
1637     string public uri;
1638     uint public vipMinted;
1639     uint public platinumMinted;
1640     bool public lockBaseURI;
1641     bool public lockCannibalURI;    
1642     bytes32 public vipMerkleRoot;  
1643     bytes32 public platinumMerkleRoot;      
1644 
1645     // ---------------------------------------------------------------------------------------------
1646     // ENUMS
1647     // ---------------------------------------------------------------------------------------------
1648 
1649     enum State {INACTIVE, WHITELIST, PUBLIC, FEAST}
1650     State public status;
1651 
1652     // ---------------------------------------------------------------------------------------------
1653     // MAPPINGS
1654     // ---------------------------------------------------------------------------------------------
1655 
1656     mapping(address => uint) public _vipClaimed; 
1657     mapping(address => bool) public _platinumClaimed;
1658 
1659     // ---------------------------------------------------------------------------------------------
1660     // OVERRIDES 
1661     // ---------------------------------------------------------------------------------------------
1662 
1663     function _baseURI() internal view virtual override returns (string memory) {
1664         return uri;
1665     }
1666 
1667     // ---------------------------------------------------------------------------------------------
1668     // OWNER SETTERS
1669     // ---------------------------------------------------------------------------------------------
1670 
1671     function setSaleStatus(uint option) external onlyOwner {
1672         if(option == 0) {
1673             status = State.INACTIVE;
1674         }else if(option == 1){
1675             status = State.WHITELIST;
1676         }else if(option == 2){
1677             status = State.PUBLIC;
1678         }else if(option == 3){
1679             status = State.FEAST;
1680         }
1681     }
1682 
1683     function setTicketURI(string calldata _uri) external onlyOwner {
1684         require(!lockBaseURI, "ALREADY_REVEALED!");
1685         string memory previousURI;
1686         previousURI = uri;
1687         uri = _uri;
1688         lockBaseURI = true;       
1689         emit TicketReveal(previousURI, _uri);
1690     }
1691 
1692     function setCannibalURI(string calldata _cannibalURI) external onlyOwner {
1693         require(!lockCannibalURI, "ALREADY_REVEALED!");
1694         cannibalURI = _cannibalURI;
1695         lockCannibalURI = true;
1696         emit CannibalReveal(_cannibalURI);
1697     }
1698 
1699     function setVipMerkleRoot(bytes32 _vipMerkleRoot) external onlyOwner {
1700         vipMerkleRoot = _vipMerkleRoot;
1701     }
1702 
1703     function setPlatinumMerkleRoot(bytes32 _platinumMerkleRoot) external onlyOwner {
1704         platinumMerkleRoot = _platinumMerkleRoot;
1705     }
1706 
1707     function withdraw(uint amount) external onlyOwner nonReentrant {
1708         require(address(this).balance >= amount, "Address: insufficient balance");
1709         (bool success, ) = msg.sender.call{value: amount}("");
1710         require(success, "Address: unable to send value, recipient may have reverted");
1711     }
1712 
1713     // ---------------------------------------------------------------------------------------------
1714     // PUBLIC SETTERS
1715     // ---------------------------------------------------------------------------------------------
1716 
1717     function publicMint(uint amount) external payable nonReentrant {
1718         require(amount <= MAX_PER_TX, "EXCEEDS_MAX_PER_TX!");          
1719         require(status == State.PUBLIC, "PUBLIC_SALE_NOT_ACTIVE!");
1720         require(msg.value == amount * PUBLIC_PRICE, "INCORRECT_VALUE!");
1721         require(_totalMinted() + amount <= MAX_SUPPLY + 1, "EXCEEDS_MAX_SUPPLY!");
1722         _safeMint(msg.sender, amount);
1723     }
1724 
1725     function platinumMint(bytes32[] calldata _merkleProof) external nonReentrant {
1726         require(status == State.WHITELIST, "WHITELIST_SALE_NOT_ACTIVE!");
1727         require(!_platinumClaimed[msg.sender], "ALREADY_CLAIMED!");        
1728         require(platinumMinted <= PLATINUM_SUPPLY, "EXCEEDS_PLATINUM_SUPPLY!");
1729         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1730         require(MerkleProof.verify(_merkleProof, platinumMerkleRoot, leaf), "INVALID_MERKLE_PROOF!");
1731         platinumMinted++;        
1732         _platinumClaimed[msg.sender] = true;
1733         _safeMint(msg.sender, 1);
1734     }
1735 
1736     function vipMint(bytes32[] calldata _merkleProof, uint amount) external payable nonReentrant {
1737         require(status == State.WHITELIST, "WHITELIST_SALE_NOT_ACTIVE!");
1738         require(amount <= MAX_PER_TX, "EXCEEDS_MAX_PER_TX!");
1739         require(msg.value == amount * VIP_PRICE, "INCORRECT_VALUE!");
1740         require(vipMinted + amount <= VIP_SUPPLY + 1, "EXCEEDS_VIP_SUPPLY!");        
1741         require(_vipClaimed[msg.sender] + amount <= MAX_PER_WALLET, "EXCEEDS_MAX_PER_WALLET!");
1742         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1743         require(MerkleProof.verify(_merkleProof, vipMerkleRoot, leaf) || MerkleProof.verify(_merkleProof, platinumMerkleRoot, leaf), "INVALID_MERKLE_PROOF!");
1744         vipMinted += amount;          
1745         _vipClaimed[msg.sender] += amount;        
1746         _safeMint(msg.sender, amount);
1747     }
1748 
1749     function feast(uint feasted, uint feastedOn) external nonReentrant {  
1750         require(status == State.FEAST, "FEAST_NOT_ACTIVE!");  
1751         require(_feastedCounters[feastedOn] == 0, "CANNOT_BE_FEASTED_ON!");                
1752         require(ownerOf(feasted) == msg.sender && ownerOf(feastedOn) == msg.sender, "NOT_THE_OWNER!");
1753         _feastedCounters[feasted]++;        
1754         if(_feastedURI[feasted] == 0){
1755             _feastedURI[feasted] = feastCounter;
1756             feastCounter++;
1757         }
1758         _burn(feastedOn);
1759         emit Feast(msg.sender, feasted, feastedOn);
1760     } 
1761 }