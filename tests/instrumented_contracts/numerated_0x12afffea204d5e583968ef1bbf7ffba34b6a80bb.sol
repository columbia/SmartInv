1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf)
42         internal
43         pure
44         returns (bytes32)
45     {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b)
61         private
62         pure
63         returns (bytes32 value)
64     {
65         assembly {
66             mstore(0x00, a)
67             mstore(0x20, b)
68             value := keccak256(0x00, 0x40)
69         }
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(
121         address indexed previousOwner,
122         address indexed newOwner
123     );
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(
164             newOwner != address(0),
165             "Ownable: new owner is the zero address"
166         );
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // File: contracts/IERC721A.sol
182 
183 // ERC721A Contracts v4.1.0
184 // Creator: Chiru Labs
185 
186 pragma solidity ^0.8.4;
187 
188 /**
189  * @dev Interface of an ERC721A compliant contract.
190  */
191 interface IERC721A {
192     /**
193      * The caller must own the token or be an approved operator.
194      */
195     error ApprovalCallerNotOwnerNorApproved();
196 
197     /**
198      * The token does not exist.
199      */
200     error ApprovalQueryForNonexistentToken();
201 
202     /**
203      * The caller cannot approve to their own address.
204      */
205     error ApproveToCaller();
206 
207     /**
208      * Cannot query the balance for the zero address.
209      */
210     error BalanceQueryForZeroAddress();
211 
212     /**
213      * Cannot mint to the zero address.
214      */
215     error MintToZeroAddress();
216 
217     /**
218      * The quantity of tokens minted must be more than zero.
219      */
220     error MintZeroQuantity();
221 
222     /**
223      * The token does not exist.
224      */
225     error OwnerQueryForNonexistentToken();
226 
227     /**
228      * The caller must own the token or be an approved operator.
229      */
230     error TransferCallerNotOwnerNorApproved();
231 
232     /**
233      * The token must be owned by `from`.
234      */
235     error TransferFromIncorrectOwner();
236 
237     /**
238      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
239      */
240     error TransferToNonERC721ReceiverImplementer();
241 
242     /**
243      * Cannot transfer to the zero address.
244      */
245     error TransferToZeroAddress();
246 
247     /**
248      * The token does not exist.
249      */
250     error URIQueryForNonexistentToken();
251 
252     /**
253      * The `quantity` minted with ERC2309 exceeds the safety limit.
254      */
255     error MintERC2309QuantityExceedsLimit();
256 
257     /**
258      * The `extraData` cannot be set on an unintialized ownership slot.
259      */
260     error OwnershipNotInitializedForExtraData();
261 
262     struct TokenOwnership {
263         // The address of the owner.
264         address addr;
265         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
266         uint64 startTimestamp;
267         // Whether the token has been burned.
268         bool burned;
269         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
270         uint24 extraData;
271     }
272 
273     /**
274      * @dev Returns the total amount of tokens stored by the contract.
275      *
276      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
277      */
278     function totalSupply() external view returns (uint256);
279 
280     // ==============================
281     //            IERC165
282     // ==============================
283 
284     /**
285      * @dev Returns true if this contract implements the interface defined by
286      * `interfaceId`. See the corresponding
287      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
288      * to learn more about how these ids are created.
289      *
290      * This function call must use less than 30 000 gas.
291      */
292     function supportsInterface(bytes4 interfaceId) external view returns (bool);
293 
294     // ==============================
295     //            IERC721
296     // ==============================
297 
298     /**
299      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
300      */
301     event Transfer(
302         address indexed from,
303         address indexed to,
304         uint256 indexed tokenId
305     );
306 
307     /**
308      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
309      */
310     event Approval(
311         address indexed owner,
312         address indexed approved,
313         uint256 indexed tokenId
314     );
315 
316     /**
317      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
318      */
319     event ApprovalForAll(
320         address indexed owner,
321         address indexed operator,
322         bool approved
323     );
324 
325     /**
326      * @dev Returns the number of tokens in ``owner``'s account.
327      */
328     function balanceOf(address owner) external view returns (uint256 balance);
329 
330     /**
331      * @dev Returns the owner of the `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function ownerOf(uint256 tokenId) external view returns (address owner);
338 
339     /**
340      * @dev Safely transfers `tokenId` token from `from` to `to`.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `tokenId` token must exist and be owned by `from`.
347      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
348      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
349      *
350      * Emits a {Transfer} event.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId,
356         bytes calldata data
357     ) external;
358 
359     /**
360      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
361      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must exist and be owned by `from`.
368      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
370      *
371      * Emits a {Transfer} event.
372      */
373     function safeTransferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) external;
378 
379     /**
380      * @dev Transfers `tokenId` token from `from` to `to`.
381      *
382      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must be owned by `from`.
389      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
403      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
404      *
405      * Requirements:
406      *
407      * - The caller must own the token or be an approved operator.
408      * - `tokenId` must exist.
409      *
410      * Emits an {Approval} event.
411      */
412     function approve(address to, uint256 tokenId) external;
413 
414     /**
415      * @dev Approve or remove `operator` as an operator for the caller.
416      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
417      *
418      * Requirements:
419      *
420      * - The `operator` cannot be the caller.
421      *
422      * Emits an {ApprovalForAll} event.
423      */
424     function setApprovalForAll(address operator, bool _approved) external;
425 
426     /**
427      * @dev Returns the account approved for `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function getApproved(uint256 tokenId)
434         external
435         view
436         returns (address operator);
437 
438     /**
439      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
440      *
441      * See {setApprovalForAll}
442      */
443     function isApprovedForAll(address owner, address operator)
444         external
445         view
446         returns (bool);
447 
448     // ==============================
449     //        IERC721Metadata
450     // ==============================
451 
452     /**
453      * @dev Returns the token collection name.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the token collection symbol.
459      */
460     function symbol() external view returns (string memory);
461 
462     /**
463      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
464      */
465     function tokenURI(uint256 tokenId) external view returns (string memory);
466 
467     // ==============================
468     //            IERC2309
469     // ==============================
470 
471     /**
472      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
473      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
474      */
475     event ConsecutiveTransfer(
476         uint256 indexed fromTokenId,
477         uint256 toTokenId,
478         address indexed from,
479         address indexed to
480     );
481 }
482 
483 // File: contracts/ERC721A.sol
484 
485 // ERC721A Contracts v4.1.0
486 // Creator: Chiru Labs
487 
488 pragma solidity ^0.8.4;
489 
490 /**
491  * @dev ERC721 token receiver interface.
492  */
493 interface ERC721A__IERC721Receiver {
494     function onERC721Received(
495         address operator,
496         address from,
497         uint256 tokenId,
498         bytes calldata data
499     ) external returns (bytes4);
500 }
501 
502 /**
503  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
504  * including the Metadata extension. Built to optimize for lower gas during batch mints.
505  *
506  * Assumes serials are sequentially minted starting at `_startTokenId()`
507  * (defaults to 0, e.g. 0, 1, 2, 3..).
508  *
509  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
510  *
511  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
512  */
513 contract ERC721A is IERC721A {
514     // Mask of an entry in packed address data.
515     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
516 
517     // The bit position of `numberMinted` in packed address data.
518     uint256 private constant BITPOS_NUMBER_MINTED = 64;
519 
520     // The bit position of `numberBurned` in packed address data.
521     uint256 private constant BITPOS_NUMBER_BURNED = 128;
522 
523     // The bit position of `aux` in packed address data.
524     uint256 private constant BITPOS_AUX = 192;
525 
526     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
527     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
528 
529     // The bit position of `startTimestamp` in packed ownership.
530     uint256 private constant BITPOS_START_TIMESTAMP = 160;
531 
532     // The bit mask of the `burned` bit in packed ownership.
533     uint256 private constant BITMASK_BURNED = 1 << 224;
534 
535     // The bit position of the `nextInitialized` bit in packed ownership.
536     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
537 
538     // The bit mask of the `nextInitialized` bit in packed ownership.
539     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
540 
541     // The bit position of `extraData` in packed ownership.
542     uint256 private constant BITPOS_EXTRA_DATA = 232;
543 
544     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
545     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
546 
547     // The mask of the lower 160 bits for addresses.
548     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
549 
550     // The maximum `quantity` that can be minted with `_mintERC2309`.
551     // This limit is to prevent overflows on the address data entries.
552     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
553     // is required to cause an overflow, which is unrealistic.
554     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
555 
556     // The tokenId of the next token to be minted.
557     uint256 private _currentIndex;
558 
559     // The number of tokens burned.
560     uint256 private _burnCounter;
561 
562     // Token name
563     string private _name;
564 
565     // Token symbol
566     string private _symbol;
567 
568     // Mapping from token ID to ownership details
569     // An empty struct value does not necessarily mean the token is unowned.
570     // See `_packedOwnershipOf` implementation for details.
571     //
572     // Bits Layout:
573     // - [0..159]   `addr`
574     // - [160..223] `startTimestamp`
575     // - [224]      `burned`
576     // - [225]      `nextInitialized`
577     // - [232..255] `extraData`
578     mapping(uint256 => uint256) private _packedOwnerships;
579 
580     // Mapping owner address to address data.
581     //
582     // Bits Layout:
583     // - [0..63]    `balance`
584     // - [64..127]  `numberMinted`
585     // - [128..191] `numberBurned`
586     // - [192..255] `aux`
587     mapping(address => uint256) private _packedAddressData;
588 
589     // Mapping from token ID to approved address.
590     mapping(uint256 => address) private _tokenApprovals;
591 
592     // Mapping from owner to operator approvals
593     mapping(address => mapping(address => bool)) private _operatorApprovals;
594 
595     constructor(string memory name_, string memory symbol_) {
596         _name = name_;
597         _symbol = symbol_;
598         _currentIndex = _startTokenId();
599     }
600 
601     /**
602      * @dev Returns the starting token ID.
603      * To change the starting token ID, please override this function.
604      */
605     function _startTokenId() internal view virtual returns (uint256) {
606         return 0;
607     }
608 
609     /**
610      * @dev Returns the next token ID to be minted.
611      */
612     function _nextTokenId() internal view returns (uint256) {
613         return _currentIndex;
614     }
615 
616     /**
617      * @dev Returns the total number of tokens in existence.
618      * Burned tokens will reduce the count.
619      * To get the total number of tokens minted, please see `_totalMinted`.
620      */
621     function totalSupply() public view override returns (uint256) {
622         // Counter underflow is impossible as _burnCounter cannot be incremented
623         // more than `_currentIndex - _startTokenId()` times.
624         unchecked {
625             return _currentIndex - _burnCounter - _startTokenId();
626         }
627     }
628 
629     /**
630      * @dev Returns the total amount of tokens minted in the contract.
631      */
632     function _totalMinted() internal view returns (uint256) {
633         // Counter underflow is impossible as _currentIndex does not decrement,
634         // and it is initialized to `_startTokenId()`
635         unchecked {
636             return _currentIndex - _startTokenId();
637         }
638     }
639 
640     /**
641      * @dev Returns the total number of tokens burned.
642      */
643     function _totalBurned() internal view returns (uint256) {
644         return _burnCounter;
645     }
646 
647     /**
648      * @dev See {IERC165-supportsInterface}.
649      */
650     function supportsInterface(bytes4 interfaceId)
651         public
652         view
653         virtual
654         override
655         returns (bool)
656     {
657         // The interface IDs are constants representing the first 4 bytes of the XOR of
658         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
659         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
660         return
661             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
662             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
663             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view override returns (uint256) {
670         if (owner == address(0)) revert BalanceQueryForZeroAddress();
671         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
672     }
673 
674     /**
675      * Returns the number of tokens minted by `owner`.
676      */
677     function _numberMinted(address owner) internal view returns (uint256) {
678         return
679             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
680             BITMASK_ADDRESS_DATA_ENTRY;
681     }
682 
683     /**
684      * Returns the number of tokens burned by or on behalf of `owner`.
685      */
686     function _numberBurned(address owner) internal view returns (uint256) {
687         return
688             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
689             BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
694      */
695     function _getAux(address owner) internal view returns (uint64) {
696         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
697     }
698 
699     /**
700      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
701      * If there are multiple variables, please pack them into a uint64.
702      */
703     function _setAux(address owner, uint64 aux) internal {
704         uint256 packed = _packedAddressData[owner];
705         uint256 auxCasted;
706         // Cast `aux` with assembly to avoid redundant masking.
707         assembly {
708             auxCasted := aux
709         }
710         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
711         _packedAddressData[owner] = packed;
712     }
713 
714     /**
715      * Returns the packed ownership data of `tokenId`.
716      */
717     function _packedOwnershipOf(uint256 tokenId)
718         private
719         view
720         returns (uint256)
721     {
722         uint256 curr = tokenId;
723 
724         unchecked {
725             if (_startTokenId() <= curr)
726                 if (curr < _currentIndex) {
727                     uint256 packed = _packedOwnerships[curr];
728                     // If not burned.
729                     if (packed & BITMASK_BURNED == 0) {
730                         // Invariant:
731                         // There will always be an ownership that has an address and is not burned
732                         // before an ownership that does not have an address and is not burned.
733                         // Hence, curr will not underflow.
734                         //
735                         // We can directly compare the packed value.
736                         // If the address is zero, packed is zero.
737                         while (packed == 0) {
738                             packed = _packedOwnerships[--curr];
739                         }
740                         return packed;
741                     }
742                 }
743         }
744         revert OwnerQueryForNonexistentToken();
745     }
746 
747     /**
748      * Returns the unpacked `TokenOwnership` struct from `packed`.
749      */
750     function _unpackedOwnership(uint256 packed)
751         private
752         pure
753         returns (TokenOwnership memory ownership)
754     {
755         ownership.addr = address(uint160(packed));
756         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
757         ownership.burned = packed & BITMASK_BURNED != 0;
758         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
759     }
760 
761     /**
762      * Returns the unpacked `TokenOwnership` struct at `index`.
763      */
764     function _ownershipAt(uint256 index)
765         internal
766         view
767         returns (TokenOwnership memory)
768     {
769         return _unpackedOwnership(_packedOwnerships[index]);
770     }
771 
772     /**
773      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
774      */
775     function _initializeOwnershipAt(uint256 index) internal {
776         if (_packedOwnerships[index] == 0) {
777             _packedOwnerships[index] = _packedOwnershipOf(index);
778         }
779     }
780 
781     /**
782      * Gas spent here starts off proportional to the maximum mint batch size.
783      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
784      */
785     function _ownershipOf(uint256 tokenId)
786         internal
787         view
788         returns (TokenOwnership memory)
789     {
790         return _unpackedOwnership(_packedOwnershipOf(tokenId));
791     }
792 
793     /**
794      * @dev Packs ownership data into a single uint256.
795      */
796     function _packOwnershipData(address owner, uint256 flags)
797         private
798         view
799         returns (uint256 result)
800     {
801         assembly {
802             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
803             owner := and(owner, BITMASK_ADDRESS)
804             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
805             result := or(
806                 owner,
807                 or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags)
808             )
809         }
810     }
811 
812     /**
813      * @dev See {IERC721-ownerOf}.
814      */
815     function ownerOf(uint256 tokenId) public view override returns (address) {
816         return address(uint160(_packedOwnershipOf(tokenId)));
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-name}.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-symbol}.
828      */
829     function symbol() public view virtual override returns (string memory) {
830         return _symbol;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-tokenURI}.
835      */
836     function tokenURI(uint256 tokenId)
837         public
838         view
839         virtual
840         override
841         returns (string memory)
842     {
843         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
844 
845         string memory baseURI = _baseURI();
846         return
847             bytes(baseURI).length != 0
848                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
849                 : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, it can be overridden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
863      */
864     function _nextInitializedFlag(uint256 quantity)
865         private
866         pure
867         returns (uint256 result)
868     {
869         // For branchless setting of the `nextInitialized` flag.
870         assembly {
871             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
872             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
873         }
874     }
875 
876     /**
877      * @dev See {IERC721-approve}.
878      */
879     function approve(address to, uint256 tokenId) public override {
880         address owner = ownerOf(tokenId);
881 
882         if (_msgSenderERC721A() != owner)
883             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
884                 revert ApprovalCallerNotOwnerNorApproved();
885             }
886 
887         _tokenApprovals[tokenId] = to;
888         emit Approval(owner, to, tokenId);
889     }
890 
891     /**
892      * @dev See {IERC721-getApproved}.
893      */
894     function getApproved(uint256 tokenId)
895         public
896         view
897         override
898         returns (address)
899     {
900         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved)
909         public
910         virtual
911         override
912     {
913         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
914 
915         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
916         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
917     }
918 
919     /**
920      * @dev See {IERC721-isApprovedForAll}.
921      */
922     function isApprovedForAll(address owner, address operator)
923         public
924         view
925         virtual
926         override
927         returns (bool)
928     {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         safeTransferFrom(from, to, tokenId, "");
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) public virtual override {
952         transferFrom(from, to, tokenId);
953         if (to.code.length != 0)
954             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
955                 revert TransferToNonERC721ReceiverImplementer();
956             }
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return
968             _startTokenId() <= tokenId &&
969             tokenId < _currentIndex && // If within bounds,
970             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
971     }
972 
973     /**
974      * @dev Equivalent to `_safeMint(to, quantity, '')`.
975      */
976     function _safeMint(address to, uint256 quantity) internal {
977         _safeMint(to, quantity, "");
978     }
979 
980     /**
981      * @dev Safely mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - If `to` refers to a smart contract, it must implement
986      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
987      * - `quantity` must be greater than 0.
988      *
989      * See {_mint}.
990      *
991      * Emits a {Transfer} event for each mint.
992      */
993     function _safeMint(
994         address to,
995         uint256 quantity,
996         bytes memory _data
997     ) internal {
998         _mint(to, quantity);
999 
1000         unchecked {
1001             if (to.code.length != 0) {
1002                 uint256 end = _currentIndex;
1003                 uint256 index = end - quantity;
1004                 do {
1005                     if (
1006                         !_checkContractOnERC721Received(
1007                             address(0),
1008                             to,
1009                             index++,
1010                             _data
1011                         )
1012                     ) {
1013                         revert TransferToNonERC721ReceiverImplementer();
1014                     }
1015                 } while (index < end);
1016                 // Reentrancy protection.
1017                 if (_currentIndex != end) revert();
1018             }
1019         }
1020     }
1021 
1022     /**
1023      * @dev Mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `quantity` must be greater than 0.
1029      *
1030      * Emits a {Transfer} event for each mint.
1031      */
1032     function _mint(address to, uint256 quantity) internal {
1033         uint256 startTokenId = _currentIndex;
1034         if (to == address(0)) revert MintToZeroAddress();
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] +=
1049                 quantity *
1050                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1051 
1052             // Updates:
1053             // - `address` to the owner.
1054             // - `startTimestamp` to the timestamp of minting.
1055             // - `burned` to `false`.
1056             // - `nextInitialized` to `quantity == 1`.
1057             _packedOwnerships[startTokenId] = _packOwnershipData(
1058                 to,
1059                 _nextInitializedFlag(quantity) |
1060                     _nextExtraData(address(0), to, 0)
1061             );
1062 
1063             uint256 tokenId = startTokenId;
1064             uint256 end = startTokenId + quantity;
1065             do {
1066                 emit Transfer(address(0), to, tokenId++);
1067             } while (tokenId < end);
1068 
1069             _currentIndex = end;
1070         }
1071         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1072     }
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * This function is intended for efficient minting only during contract creation.
1078      *
1079      * It emits only one {ConsecutiveTransfer} as defined in
1080      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1081      * instead of a sequence of {Transfer} event(s).
1082      *
1083      * Calling this function outside of contract creation WILL make your contract
1084      * non-compliant with the ERC721 standard.
1085      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1086      * {ConsecutiveTransfer} event is only permissible during contract creation.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {ConsecutiveTransfer} event.
1094      */
1095     function _mintERC2309(address to, uint256 quantity) internal {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT)
1100             revert MintERC2309QuantityExceedsLimit();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1105         unchecked {
1106             // Updates:
1107             // - `balance += quantity`.
1108             // - `numberMinted += quantity`.
1109             //
1110             // We can directly add to the `balance` and `numberMinted`.
1111             _packedAddressData[to] +=
1112                 quantity *
1113                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1114 
1115             // Updates:
1116             // - `address` to the owner.
1117             // - `startTimestamp` to the timestamp of minting.
1118             // - `burned` to `false`.
1119             // - `nextInitialized` to `quantity == 1`.
1120             _packedOwnerships[startTokenId] = _packOwnershipData(
1121                 to,
1122                 _nextInitializedFlag(quantity) |
1123                     _nextExtraData(address(0), to, 0)
1124             );
1125 
1126             emit ConsecutiveTransfer(
1127                 startTokenId,
1128                 startTokenId + quantity - 1,
1129                 address(0),
1130                 to
1131             );
1132 
1133             _currentIndex = startTokenId + quantity;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1140      */
1141     function _getApprovedAddress(uint256 tokenId)
1142         private
1143         view
1144         returns (uint256 approvedAddressSlot, address approvedAddress)
1145     {
1146         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1147         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1148         assembly {
1149             // Compute the slot.
1150             mstore(0x00, tokenId)
1151             mstore(0x20, tokenApprovalsPtr.slot)
1152             approvedAddressSlot := keccak256(0x00, 0x40)
1153             // Load the slot's value from storage.
1154             approvedAddress := sload(approvedAddressSlot)
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1160      */
1161     function _isOwnerOrApproved(
1162         address approvedAddress,
1163         address from,
1164         address msgSender
1165     ) private pure returns (bool result) {
1166         assembly {
1167             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1168             from := and(from, BITMASK_ADDRESS)
1169             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1170             msgSender := and(msgSender, BITMASK_ADDRESS)
1171             // `msgSender == from || msgSender == approvedAddress`.
1172             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1173         }
1174     }
1175 
1176     /**
1177      * @dev Transfers `tokenId` from `from` to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `tokenId` token must be owned by `from`.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function transferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) public virtual override {
1191         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1192 
1193         if (address(uint160(prevOwnershipPacked)) != from)
1194             revert TransferFromIncorrectOwner();
1195 
1196         (
1197             uint256 approvedAddressSlot,
1198             address approvedAddress
1199         ) = _getApprovedAddress(tokenId);
1200 
1201         // The nested ifs save around 20+ gas over a compound boolean condition.
1202         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1203             if (!isApprovedForAll(from, _msgSenderERC721A()))
1204                 revert TransferCallerNotOwnerNorApproved();
1205 
1206         if (to == address(0)) revert TransferToZeroAddress();
1207 
1208         _beforeTokenTransfers(from, to, tokenId, 1);
1209 
1210         // Clear approvals from the previous owner.
1211         assembly {
1212             if approvedAddress {
1213                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1214                 sstore(approvedAddressSlot, 0)
1215             }
1216         }
1217 
1218         // Underflow of the sender's balance is impossible because we check for
1219         // ownership above and the recipient's balance can't realistically overflow.
1220         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1221         unchecked {
1222             // We can directly increment and decrement the balances.
1223             --_packedAddressData[from]; // Updates: `balance -= 1`.
1224             ++_packedAddressData[to]; // Updates: `balance += 1`.
1225 
1226             // Updates:
1227             // - `address` to the next owner.
1228             // - `startTimestamp` to the timestamp of transfering.
1229             // - `burned` to `false`.
1230             // - `nextInitialized` to `true`.
1231             _packedOwnerships[tokenId] = _packOwnershipData(
1232                 to,
1233                 BITMASK_NEXT_INITIALIZED |
1234                     _nextExtraData(from, to, prevOwnershipPacked)
1235             );
1236 
1237             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1238             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1239                 uint256 nextTokenId = tokenId + 1;
1240                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1241                 if (_packedOwnerships[nextTokenId] == 0) {
1242                     // If the next slot is within bounds.
1243                     if (nextTokenId != _currentIndex) {
1244                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1245                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1246                     }
1247                 }
1248             }
1249         }
1250 
1251         emit Transfer(from, to, tokenId);
1252         _afterTokenTransfers(from, to, tokenId, 1);
1253     }
1254 
1255     /**
1256      * @dev Equivalent to `_burn(tokenId, false)`.
1257      */
1258     function _burn(uint256 tokenId) internal virtual {
1259         _burn(tokenId, false);
1260     }
1261 
1262     /**
1263      * @dev Destroys `tokenId`.
1264      * The approval is cleared when the token is burned.
1265      *
1266      * Requirements:
1267      *
1268      * - `tokenId` must exist.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1273         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1274 
1275         address from = address(uint160(prevOwnershipPacked));
1276 
1277         (
1278             uint256 approvedAddressSlot,
1279             address approvedAddress
1280         ) = _getApprovedAddress(tokenId);
1281 
1282         if (approvalCheck) {
1283             // The nested ifs save around 20+ gas over a compound boolean condition.
1284             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1285                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1286                     revert TransferCallerNotOwnerNorApproved();
1287         }
1288 
1289         _beforeTokenTransfers(from, address(0), tokenId, 1);
1290 
1291         // Clear approvals from the previous owner.
1292         assembly {
1293             if approvedAddress {
1294                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1295                 sstore(approvedAddressSlot, 0)
1296             }
1297         }
1298 
1299         // Underflow of the sender's balance is impossible because we check for
1300         // ownership above and the recipient's balance can't realistically overflow.
1301         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1302         unchecked {
1303             // Updates:
1304             // - `balance -= 1`.
1305             // - `numberBurned += 1`.
1306             //
1307             // We can directly decrement the balance, and increment the number burned.
1308             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1309             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1310 
1311             // Updates:
1312             // - `address` to the last owner.
1313             // - `startTimestamp` to the timestamp of burning.
1314             // - `burned` to `true`.
1315             // - `nextInitialized` to `true`.
1316             _packedOwnerships[tokenId] = _packOwnershipData(
1317                 from,
1318                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) |
1319                     _nextExtraData(from, address(0), prevOwnershipPacked)
1320             );
1321 
1322             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1323             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1324                 uint256 nextTokenId = tokenId + 1;
1325                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1326                 if (_packedOwnerships[nextTokenId] == 0) {
1327                     // If the next slot is within bounds.
1328                     if (nextTokenId != _currentIndex) {
1329                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1330                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1331                     }
1332                 }
1333             }
1334         }
1335 
1336         emit Transfer(from, address(0), tokenId);
1337         _afterTokenTransfers(from, address(0), tokenId, 1);
1338 
1339         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1340         unchecked {
1341             _burnCounter++;
1342         }
1343     }
1344 
1345     /**
1346      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1347      *
1348      * @param from address representing the previous owner of the given token ID
1349      * @param to target address that will receive the tokens
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @param _data bytes optional data to send along with the call
1352      * @return bool whether the call correctly returned the expected magic value
1353      */
1354     function _checkContractOnERC721Received(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) private returns (bool) {
1360         try
1361             ERC721A__IERC721Receiver(to).onERC721Received(
1362                 _msgSenderERC721A(),
1363                 from,
1364                 tokenId,
1365                 _data
1366             )
1367         returns (bytes4 retval) {
1368             return
1369                 retval ==
1370                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1371         } catch (bytes memory reason) {
1372             if (reason.length == 0) {
1373                 revert TransferToNonERC721ReceiverImplementer();
1374             } else {
1375                 assembly {
1376                     revert(add(32, reason), mload(reason))
1377                 }
1378             }
1379         }
1380     }
1381 
1382     /**
1383      * @dev Directly sets the extra data for the ownership data `index`.
1384      */
1385     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1386         uint256 packed = _packedOwnerships[index];
1387         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1388         uint256 extraDataCasted;
1389         // Cast `extraData` with assembly to avoid redundant masking.
1390         assembly {
1391             extraDataCasted := extraData
1392         }
1393         packed =
1394             (packed & BITMASK_EXTRA_DATA_COMPLEMENT) |
1395             (extraDataCasted << BITPOS_EXTRA_DATA);
1396         _packedOwnerships[index] = packed;
1397     }
1398 
1399     /**
1400      * @dev Returns the next extra data for the packed ownership data.
1401      * The returned result is shifted into position.
1402      */
1403     function _nextExtraData(
1404         address from,
1405         address to,
1406         uint256 prevOwnershipPacked
1407     ) private view returns (uint256) {
1408         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1409         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1410     }
1411 
1412     /**
1413      * @dev Called during each token transfer to set the 24bit `extraData` field.
1414      * Intended to be overridden by the cosumer contract.
1415      *
1416      * `previousExtraData` - the value of `extraData` before transfer.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _extraData(
1427         address from,
1428         address to,
1429         uint24 previousExtraData
1430     ) internal view virtual returns (uint24) {}
1431 
1432     /**
1433      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1434      * This includes minting.
1435      * And also called before burning one token.
1436      *
1437      * startTokenId - the first token id to be transferred
1438      * quantity - the amount to be transferred
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
1456      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1457      * This includes minting.
1458      * And also called after one token has been burned.
1459      *
1460      * startTokenId - the first token id to be transferred
1461      * quantity - the amount to be transferred
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
1479      * @dev Returns the message sender (defaults to `msg.sender`).
1480      *
1481      * If you are writing GSN compatible contracts, you need to override this function.
1482      */
1483     function _msgSenderERC721A() internal view virtual returns (address) {
1484         return msg.sender;
1485     }
1486 
1487     /**
1488      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1489      */
1490     function _toString(uint256 value)
1491         internal
1492         pure
1493         returns (string memory ptr)
1494     {
1495         assembly {
1496             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1497             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1498             // We will need 1 32-byte word to store the length,
1499             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1500             ptr := add(mload(0x40), 128)
1501             // Update the free memory pointer to allocate.
1502             mstore(0x40, ptr)
1503 
1504             // Cache the end of the memory to calculate the length later.
1505             let end := ptr
1506 
1507             // We write the string from the rightmost digit to the leftmost digit.
1508             // The following is essentially a do-while loop that also handles the zero case.
1509             // Costs a bit more than early returning for the zero case,
1510             // but cheaper in terms of deployment and overall runtime costs.
1511             for {
1512                 // Initialize and perform the first pass without check.
1513                 let temp := value
1514                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1515                 ptr := sub(ptr, 1)
1516                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1517                 mstore8(ptr, add(48, mod(temp, 10)))
1518                 temp := div(temp, 10)
1519             } temp {
1520                 // Keep dividing `temp` until zero.
1521                 temp := div(temp, 10)
1522             } {
1523                 // Body of the for loop.
1524                 ptr := sub(ptr, 1)
1525                 mstore8(ptr, add(48, mod(temp, 10)))
1526             }
1527 
1528             let length := sub(end, ptr)
1529             // Move the pointer 32 bytes leftwards to make room for the length.
1530             ptr := sub(ptr, 32)
1531             // Store the length.
1532             mstore(ptr, length)
1533         }
1534     }
1535 }
1536 
1537 // File: contracts/IERC721AQueryable.sol
1538 
1539 // ERC721A Contracts v4.1.0
1540 // Creator: Chiru Labs
1541 
1542 pragma solidity ^0.8.4;
1543 
1544 /**
1545  * @dev Interface of an ERC721AQueryable compliant contract.
1546  */
1547 interface IERC721AQueryable is IERC721A {
1548     /**
1549      * Invalid query range (`start` >= `stop`).
1550      */
1551     error InvalidQueryRange();
1552 
1553     /**
1554      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1555      *
1556      * If the `tokenId` is out of bounds:
1557      *   - `addr` = `address(0)`
1558      *   - `startTimestamp` = `0`
1559      *   - `burned` = `false`
1560      *
1561      * If the `tokenId` is burned:
1562      *   - `addr` = `<Address of owner before token was burned>`
1563      *   - `startTimestamp` = `<Timestamp when token was burned>`
1564      *   - `burned = `true`
1565      *
1566      * Otherwise:
1567      *   - `addr` = `<Address of owner>`
1568      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1569      *   - `burned = `false`
1570      */
1571     function explicitOwnershipOf(uint256 tokenId)
1572         external
1573         view
1574         returns (TokenOwnership memory);
1575 
1576     /**
1577      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1578      * See {ERC721AQueryable-explicitOwnershipOf}
1579      */
1580     function explicitOwnershipsOf(uint256[] memory tokenIds)
1581         external
1582         view
1583         returns (TokenOwnership[] memory);
1584 
1585     /**
1586      * @dev Returns an array of token IDs owned by `owner`,
1587      * in the range [`start`, `stop`)
1588      * (i.e. `start <= tokenId < stop`).
1589      *
1590      * This function allows for tokens to be queried if the collection
1591      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1592      *
1593      * Requirements:
1594      *
1595      * - `start` < `stop`
1596      */
1597     function tokensOfOwnerIn(
1598         address owner,
1599         uint256 start,
1600         uint256 stop
1601     ) external view returns (uint256[] memory);
1602 
1603     /**
1604      * @dev Returns an array of token IDs owned by `owner`.
1605      *
1606      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1607      * It is meant to be called off-chain.
1608      *
1609      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1610      * multiple smaller scans if the collection is large enough to cause
1611      * an out-of-gas error (10K pfp collections should be fine).
1612      */
1613     function tokensOfOwner(address owner)
1614         external
1615         view
1616         returns (uint256[] memory);
1617 }
1618 
1619 // File: contracts/ERC721AQueryable.sol
1620 
1621 // ERC721A Contracts v4.1.0
1622 // Creator: Chiru Labs
1623 
1624 pragma solidity ^0.8.4;
1625 
1626 /**
1627  * @title ERC721A Queryable
1628  * @dev ERC721A subclass with convenience query functions.
1629  */
1630 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1631     /**
1632      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1633      *
1634      * If the `tokenId` is out of bounds:
1635      *   - `addr` = `address(0)`
1636      *   - `startTimestamp` = `0`
1637      *   - `burned` = `false`
1638      *   - `extraData` = `0`
1639      *
1640      * If the `tokenId` is burned:
1641      *   - `addr` = `<Address of owner before token was burned>`
1642      *   - `startTimestamp` = `<Timestamp when token was burned>`
1643      *   - `burned = `true`
1644      *   - `extraData` = `<Extra data when token was burned>`
1645      *
1646      * Otherwise:
1647      *   - `addr` = `<Address of owner>`
1648      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1649      *   - `burned = `false`
1650      *   - `extraData` = `<Extra data at start of ownership>`
1651      */
1652     function explicitOwnershipOf(uint256 tokenId)
1653         public
1654         view
1655         override
1656         returns (TokenOwnership memory)
1657     {
1658         TokenOwnership memory ownership;
1659         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1660             return ownership;
1661         }
1662         ownership = _ownershipAt(tokenId);
1663         if (ownership.burned) {
1664             return ownership;
1665         }
1666         return _ownershipOf(tokenId);
1667     }
1668 
1669     /**
1670      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1671      * See {ERC721AQueryable-explicitOwnershipOf}
1672      */
1673     function explicitOwnershipsOf(uint256[] memory tokenIds)
1674         external
1675         view
1676         override
1677         returns (TokenOwnership[] memory)
1678     {
1679         unchecked {
1680             uint256 tokenIdsLength = tokenIds.length;
1681             TokenOwnership[] memory ownerships = new TokenOwnership[](
1682                 tokenIdsLength
1683             );
1684             for (uint256 i; i != tokenIdsLength; ++i) {
1685                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1686             }
1687             return ownerships;
1688         }
1689     }
1690 
1691     /**
1692      * @dev Returns an array of token IDs owned by `owner`,
1693      * in the range [`start`, `stop`)
1694      * (i.e. `start <= tokenId < stop`).
1695      *
1696      * This function allows for tokens to be queried if the collection
1697      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1698      *
1699      * Requirements:
1700      *
1701      * - `start` < `stop`
1702      */
1703     function tokensOfOwnerIn(
1704         address owner,
1705         uint256 start,
1706         uint256 stop
1707     ) external view override returns (uint256[] memory) {
1708         unchecked {
1709             if (start >= stop) revert InvalidQueryRange();
1710             uint256 tokenIdsIdx;
1711             uint256 stopLimit = _nextTokenId();
1712             // Set `start = max(start, _startTokenId())`.
1713             if (start < _startTokenId()) {
1714                 start = _startTokenId();
1715             }
1716             // Set `stop = min(stop, stopLimit)`.
1717             if (stop > stopLimit) {
1718                 stop = stopLimit;
1719             }
1720             uint256 tokenIdsMaxLength = balanceOf(owner);
1721             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1722             // to cater for cases where `balanceOf(owner)` is too big.
1723             if (start < stop) {
1724                 uint256 rangeLength = stop - start;
1725                 if (rangeLength < tokenIdsMaxLength) {
1726                     tokenIdsMaxLength = rangeLength;
1727                 }
1728             } else {
1729                 tokenIdsMaxLength = 0;
1730             }
1731             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1732             if (tokenIdsMaxLength == 0) {
1733                 return tokenIds;
1734             }
1735             // We need to call `explicitOwnershipOf(start)`,
1736             // because the slot at `start` may not be initialized.
1737             TokenOwnership memory ownership = explicitOwnershipOf(start);
1738             address currOwnershipAddr;
1739             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1740             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1741             if (!ownership.burned) {
1742                 currOwnershipAddr = ownership.addr;
1743             }
1744             for (
1745                 uint256 i = start;
1746                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1747                 ++i
1748             ) {
1749                 ownership = _ownershipAt(i);
1750                 if (ownership.burned) {
1751                     continue;
1752                 }
1753                 if (ownership.addr != address(0)) {
1754                     currOwnershipAddr = ownership.addr;
1755                 }
1756                 if (currOwnershipAddr == owner) {
1757                     tokenIds[tokenIdsIdx++] = i;
1758                 }
1759             }
1760             // Downsize the array to fit.
1761             assembly {
1762                 mstore(tokenIds, tokenIdsIdx)
1763             }
1764             return tokenIds;
1765         }
1766     }
1767 
1768     /**
1769      * @dev Returns an array of token IDs owned by `owner`.
1770      *
1771      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1772      * It is meant to be called off-chain.
1773      *
1774      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1775      * multiple smaller scans if the collection is large enough to cause
1776      * an out-of-gas error (10K pfp collections should be fine).
1777      */
1778     function tokensOfOwner(address owner)
1779         external
1780         view
1781         override
1782         returns (uint256[] memory)
1783     {
1784         unchecked {
1785             uint256 tokenIdsIdx;
1786             address currOwnershipAddr;
1787             uint256 tokenIdsLength = balanceOf(owner);
1788             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1789             TokenOwnership memory ownership;
1790             for (
1791                 uint256 i = _startTokenId();
1792                 tokenIdsIdx != tokenIdsLength;
1793                 ++i
1794             ) {
1795                 ownership = _ownershipAt(i);
1796                 if (ownership.burned) {
1797                     continue;
1798                 }
1799                 if (ownership.addr != address(0)) {
1800                     currOwnershipAddr = ownership.addr;
1801                 }
1802                 if (currOwnershipAddr == owner) {
1803                     tokenIds[tokenIdsIdx++] = i;
1804                 }
1805             }
1806             return tokenIds;
1807         }
1808     }
1809 }
1810 
1811 // File: contracts/MetaBears.sol
1812 
1813 pragma solidity >=0.8.12 <0.9.0;
1814 
1815 error Paused();
1816 error MaxPresaleTransactionMintAmountExceeded();
1817 error MaxPresaleMintAmountExceeded();
1818 error MaxTransactionMintAmountExceeded();
1819 error MaxMintAmountExceeded();
1820 error InvalidMintAmount();
1821 error SupplyExceeded();
1822 error PresaleOnly();
1823 error PresaleOver();
1824 error InvalidValue();
1825 error NotWhitelisted();
1826 error NewSupplyToLow();
1827 error NewSupplyToHigh();
1828 error NewReserveSupplyToHigh();
1829 error ReserveSupplyEmpty();
1830 error AddressesExceedReserveSupply();
1831 error ReserveSupplyExceeded();
1832 error InvalidAddressAmount();
1833 error InvalidAirdropAmount();
1834 error NoBalanceToWithdraw();
1835 error WithdrawFailed();
1836 
1837 contract MetaBears is ERC721A, ERC721AQueryable, Ownable {
1838     using MerkleProof for bytes32[];
1839 
1840     bytes32 merkleRoot;
1841 
1842     string public baseURI;
1843 
1844     bool public isPaused = true;
1845     bool public isRevealed = false;
1846     bool public isPresale = true;
1847 
1848     uint256 public maxSupply = 3333;
1849     uint256 public presaleMaxTxMintAmount = 5;
1850     uint256 public presaleMaxMintAmount = 5;
1851     uint256 public maxTxMintAmount = 5;
1852     uint256 public maxMintAmount = 5;
1853     uint256 public cost = 0.03 ether;
1854     uint256 public reserveSupply = 250;
1855 
1856     event NewMetaBearMinted(address sender, uint256 mintAmount);
1857 
1858     constructor(
1859         string memory _name,
1860         string memory _symbol,
1861         string memory _initBaseURI
1862     ) ERC721A(_name, _symbol) {
1863         setBaseURI(_initBaseURI);
1864     }
1865 
1866     modifier mustPassChecks(uint256 _mintAmount) {
1867         if (isPaused) revert Paused();
1868         if (isPresale && _mintAmount > presaleMaxTxMintAmount)
1869             revert MaxPresaleTransactionMintAmountExceeded();
1870         if (
1871             isPresale &&
1872             _getAux(msg.sender) + _mintAmount > presaleMaxTxMintAmount
1873         ) revert MaxPresaleMintAmountExceeded();
1874         if (_mintAmount < 1) revert InvalidMintAmount();
1875         if (_mintAmount > maxTxMintAmount)
1876             revert MaxTransactionMintAmountExceeded();
1877         if ((_getAux(msg.sender) + _mintAmount) > maxMintAmount)
1878             revert MaxMintAmountExceeded();
1879         if (totalSupply() + _mintAmount > maxSupply - reserveSupply)
1880             revert SupplyExceeded();
1881         _;
1882     }
1883 
1884     function _startTokenId() internal view virtual override returns (uint256) {
1885         return 1;
1886     }
1887 
1888     function _baseURI() internal view virtual override returns (string memory) {
1889         return baseURI;
1890     }
1891 
1892     function tokenURI(uint256 tokenId)
1893         public
1894         view
1895         virtual
1896         override(ERC721A, IERC721A)
1897         returns (string memory)
1898     {
1899         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
1900         string memory currentBaseURI = _baseURI();
1901         return
1902             bytes(currentBaseURI).length > 0
1903                 ? string.concat(currentBaseURI, _toString(tokenId), ".json")
1904                 : "";
1905     }
1906 
1907     function mint(uint256 _mintAmount)
1908         external
1909         payable
1910         mustPassChecks(_mintAmount)
1911     {
1912         if (isPresale) revert PresaleOnly();
1913         if (msg.value != cost * _mintAmount) revert InvalidValue();
1914         _safeMint(msg.sender, _mintAmount);
1915         _setAux(msg.sender, uint64(_getAux(msg.sender) + _mintAmount));
1916         emit NewMetaBearMinted(msg.sender, _mintAmount);
1917     }
1918 
1919     function presaleMint(uint256 _mintAmount, bytes32[] memory proof)
1920         external
1921         payable
1922         mustPassChecks(_mintAmount)
1923     {
1924         if (!isPresale) revert PresaleOver();
1925         if (!proof.verify(merkleRoot, keccak256(abi.encodePacked(msg.sender))))
1926             revert NotWhitelisted();
1927         if (
1928             msg.value !=
1929             (
1930                 _getAux(msg.sender) == 0
1931                     ? cost * (_mintAmount - 1)
1932                     : cost * _mintAmount
1933             )
1934         ) revert InvalidValue();
1935         _safeMint(msg.sender, _mintAmount);
1936         _setAux(msg.sender, uint64(_getAux(msg.sender) + _mintAmount));
1937         emit NewMetaBearMinted(msg.sender, _mintAmount);
1938     }
1939 
1940     function mintedTotalOf(address _owner) public view returns (uint256) {
1941         return _getAux(_owner);
1942     }
1943 
1944     function ownerMint(uint256 _mintAmount) external onlyOwner {
1945         if (_mintAmount < 1) revert InvalidMintAmount();
1946         if (totalSupply() + _mintAmount > maxSupply - reserveSupply)
1947             revert SupplyExceeded();
1948         _safeMint(msg.sender, _mintAmount);
1949         _setAux(msg.sender, uint64(_getAux(msg.sender) + _mintAmount));
1950     }
1951 
1952     function toggleIsPaused() external onlyOwner {
1953         isPaused = !isPaused;
1954     }
1955 
1956     function toggleIsPresale() external onlyOwner {
1957         isPresale = !isPresale;
1958     }
1959 
1960     function toggleIsRevealed() external onlyOwner {
1961         isRevealed = !isRevealed;
1962     }
1963 
1964     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
1965         if (_newMaxSupply < totalSupply() + reserveSupply)
1966             revert NewSupplyToLow();
1967         if (_newMaxSupply > maxSupply) revert NewSupplyToHigh();
1968         maxSupply = _newMaxSupply;
1969     }
1970 
1971     function setCost(uint256 _newCost) external onlyOwner {
1972         cost = _newCost;
1973     }
1974 
1975     function setReserveSupply(uint256 _newReserveSupply) external onlyOwner {
1976         if (_newReserveSupply > maxSupply - totalSupply())
1977             revert NewReserveSupplyToHigh();
1978         reserveSupply = _newReserveSupply;
1979     }
1980 
1981     function setMerkleRoot(bytes32 root) external onlyOwner {
1982         merkleRoot = root;
1983     }
1984 
1985     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1986         baseURI = _newBaseURI;
1987     }
1988 
1989     function setPresaleMaxMintAmount(uint256 _newpresaleMaxMintAmount)
1990         external
1991         onlyOwner
1992     {
1993         presaleMaxMintAmount = _newpresaleMaxMintAmount;
1994     }
1995 
1996     function setPresaleMaxTxMintAmount(uint256 _newpresaleMaxTxMintAmount)
1997         external
1998         onlyOwner
1999     {
2000         presaleMaxTxMintAmount = _newpresaleMaxTxMintAmount;
2001     }
2002 
2003     function setMaxTxMintAmount(uint256 _newMaxTxMintAmount)
2004         external
2005         onlyOwner
2006     {
2007         maxTxMintAmount = _newMaxTxMintAmount;
2008     }
2009 
2010     function setMaxMintAmount(uint256 _newMaxMintAmount) external onlyOwner {
2011         maxMintAmount = _newMaxMintAmount;
2012     }
2013 
2014     function airdrop(address[] calldata _address) external onlyOwner {
2015         if (reserveSupply == 0) revert ReserveSupplyEmpty();
2016         if (_address.length > reserveSupply)
2017             revert AddressesExceedReserveSupply();
2018         if (_address.length < 1) revert InvalidAddressAmount();
2019         if (totalSupply() + _address.length > maxSupply)
2020             revert SupplyExceeded();
2021         for (uint256 i = 0; i != _address.length; i++) {
2022             _safeMint(_address[i], 1);
2023         }
2024         reserveSupply = reserveSupply - _address.length;
2025     }
2026 
2027     function airdropMultipleToAddress(address _address, uint256 _mintAmount)
2028         external
2029         onlyOwner
2030     {
2031         if (reserveSupply == 0) revert ReserveSupplyEmpty();
2032         if (_mintAmount > reserveSupply) revert ReserveSupplyExceeded();
2033         if (_mintAmount < 1) revert InvalidAirdropAmount();
2034         if (totalSupply() + _mintAmount > maxSupply) revert SupplyExceeded();
2035 
2036         _safeMint(_address, _mintAmount);
2037 
2038         reserveSupply = reserveSupply - _mintAmount;
2039     }
2040 
2041     function withdraw() external onlyOwner {
2042         uint256 balance = address(this).balance;
2043         if (balance == 0) revert NoBalanceToWithdraw();
2044         (bool successA, ) = payable(0xF9fb3484254827D5ca0Ef4Ff78d22FB0AB4cEE36)
2045             .call{value: (balance / 100) * 25}("");
2046         (bool successB, ) = payable(0x09a71e88590AF466FEf8b764BB75Ca69B375D198)
2047             .call{value: (balance / 100) * 35}("");
2048         (bool successC, ) = payable(0xB50462606681071a739286fE12B8ed0be6Fe4a9E)
2049             .call{value: (balance / 100) * 15}("");
2050         (bool successD, ) = payable(0x9Adc62347c77074344cDD8Ee22f1bBd4E5441558)
2051             .call{value: (balance / 100) * 10}("");
2052         (bool successE, ) = payable(0x818b64B27653D3ce14bB976d118bEd0944A4A031)
2053             .call{value: (balance / 100) * 5}("");
2054         (bool successF, ) = payable(0x51D8f89Fae2e82c4bAcF6Ec270f36624bc9C6D1E)
2055             .call{value: (balance / 100) * 10}("");
2056         if (
2057             !(successA &&
2058                 successB &&
2059                 successC &&
2060                 successD &&
2061                 successE &&
2062                 successF)
2063         ) revert WithdrawFailed();
2064     }
2065 }