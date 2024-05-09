1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  *
19  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
20  * hashing, or use a hash function other than keccak256 for hashing leaves.
21  * This is because the concatenation of a sorted pair of internal nodes in
22  * the merkle tree could be reinterpreted as a leaf value.
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(
32         bytes32[] memory proof,
33         bytes32 root,
34         bytes32 leaf
35     ) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
41      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
42      * hash matches the root of the tree. When processing the proof, the pairs
43      * of leafs & pre-images are assumed to be sorted.
44      *
45      * _Available since v4.4._
46      */
47     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
48         bytes32 computedHash = leaf;
49         for (uint256 i = 0; i < proof.length; i++) {
50             bytes32 proofElement = proof[i];
51             if (computedHash <= proofElement) {
52                 // Hash(current computed hash + current element of the proof)
53                 computedHash = _efficientHash(computedHash, proofElement);
54             } else {
55                 // Hash(current element of the proof + current computed hash)
56                 computedHash = _efficientHash(proofElement, computedHash);
57             }
58         }
59         return computedHash;
60     }
61 
62     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
63         assembly {
64             mstore(0x00, a)
65             mstore(0x20, b)
66             value := keccak256(0x00, 0x40)
67         }
68     }
69 }
70 
71 
72 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
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
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _transferOwnership(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 
176 // File erc721a/contracts/IERC721A.sol@v4.0.0
177 
178 // ERC721A Contracts v4.0.0
179 // Creator: Chiru Labs
180 
181 pragma solidity ^0.8.4;
182 
183 /**
184  * @dev Interface of an ERC721A compliant contract.
185  */
186 interface IERC721A {
187     /**
188      * The caller must own the token or be an approved operator.
189      */
190     error ApprovalCallerNotOwnerNorApproved();
191 
192     /**
193      * The token does not exist.
194      */
195     error ApprovalQueryForNonexistentToken();
196 
197     /**
198      * The caller cannot approve to their own address.
199      */
200     error ApproveToCaller();
201 
202     /**
203      * The caller cannot approve to the current owner.
204      */
205     error ApprovalToCurrentOwner();
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
252     struct TokenOwnership {
253         // The address of the owner.
254         address addr;
255         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
256         uint64 startTimestamp;
257         // Whether the token has been burned.
258         bool burned;
259     }
260 
261     /**
262      * @dev Returns the total amount of tokens stored by the contract.
263      *
264      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     // ==============================
269     //            IERC165
270     // ==============================
271 
272     /**
273      * @dev Returns true if this contract implements the interface defined by
274      * `interfaceId`. See the corresponding
275      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
276      * to learn more about how these ids are created.
277      *
278      * This function call must use less than 30 000 gas.
279      */
280     function supportsInterface(bytes4 interfaceId) external view returns (bool);
281 
282     // ==============================
283     //            IERC721
284     // ==============================
285 
286     /**
287      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
290 
291     /**
292      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
293      */
294     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
295 
296     /**
297      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
298      */
299     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
300 
301     /**
302      * @dev Returns the number of tokens in ``owner``'s account.
303      */
304     function balanceOf(address owner) external view returns (uint256 balance);
305 
306     /**
307      * @dev Returns the owner of the `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function ownerOf(uint256 tokenId) external view returns (address owner);
314 
315     /**
316      * @dev Safely transfers `tokenId` token from `from` to `to`.
317      *
318      * Requirements:
319      *
320      * - `from` cannot be the zero address.
321      * - `to` cannot be the zero address.
322      * - `tokenId` token must exist and be owned by `from`.
323      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
324      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
325      *
326      * Emits a {Transfer} event.
327      */
328     function safeTransferFrom(
329         address from,
330         address to,
331         uint256 tokenId,
332         bytes calldata data
333     ) external;
334 
335     /**
336      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
337      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
338      *
339      * Requirements:
340      *
341      * - `from` cannot be the zero address.
342      * - `to` cannot be the zero address.
343      * - `tokenId` token must exist and be owned by `from`.
344      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
345      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
346      *
347      * Emits a {Transfer} event.
348      */
349     function safeTransferFrom(
350         address from,
351         address to,
352         uint256 tokenId
353     ) external;
354 
355     /**
356      * @dev Transfers `tokenId` token from `from` to `to`.
357      *
358      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must be owned by `from`.
365      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transferFrom(
370         address from,
371         address to,
372         uint256 tokenId
373     ) external;
374 
375     /**
376      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
377      * The approval is cleared when the token is transferred.
378      *
379      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
380      *
381      * Requirements:
382      *
383      * - The caller must own the token or be an approved operator.
384      * - `tokenId` must exist.
385      *
386      * Emits an {Approval} event.
387      */
388     function approve(address to, uint256 tokenId) external;
389 
390     /**
391      * @dev Approve or remove `operator` as an operator for the caller.
392      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
393      *
394      * Requirements:
395      *
396      * - The `operator` cannot be the caller.
397      *
398      * Emits an {ApprovalForAll} event.
399      */
400     function setApprovalForAll(address operator, bool _approved) external;
401 
402     /**
403      * @dev Returns the account approved for `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function getApproved(uint256 tokenId) external view returns (address operator);
410 
411     /**
412      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
413      *
414      * See {setApprovalForAll}
415      */
416     function isApprovedForAll(address owner, address operator) external view returns (bool);
417 
418     // ==============================
419     //        IERC721Metadata
420     // ==============================
421 
422     /**
423      * @dev Returns the token collection name.
424      */
425     function name() external view returns (string memory);
426 
427     /**
428      * @dev Returns the token collection symbol.
429      */
430     function symbol() external view returns (string memory);
431 
432     /**
433      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
434      */
435     function tokenURI(uint256 tokenId) external view returns (string memory);
436 }
437 
438 
439 // File erc721a/contracts/ERC721A.sol@v4.0.0
440 
441 // ERC721A Contracts v4.0.0
442 // Creator: Chiru Labs
443 
444 pragma solidity ^0.8.4;
445 
446 /**
447  * @dev ERC721 token receiver interface.
448  */
449 interface ERC721A__IERC721Receiver {
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 /**
459  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
460  * the Metadata extension. Built to optimize for lower gas during batch mints.
461  *
462  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
463  *
464  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
465  *
466  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
467  */
468 contract ERC721A is IERC721A {
469     // Mask of an entry in packed address data.
470     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
471 
472     // The bit position of `numberMinted` in packed address data.
473     uint256 private constant BITPOS_NUMBER_MINTED = 64;
474 
475     // The bit position of `numberBurned` in packed address data.
476     uint256 private constant BITPOS_NUMBER_BURNED = 128;
477 
478     // The bit position of `aux` in packed address data.
479     uint256 private constant BITPOS_AUX = 192;
480 
481     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
482     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
483 
484     // The bit position of `startTimestamp` in packed ownership.
485     uint256 private constant BITPOS_START_TIMESTAMP = 160;
486 
487     // The bit mask of the `burned` bit in packed ownership.
488     uint256 private constant BITMASK_BURNED = 1 << 224;
489     
490     // The bit position of the `nextInitialized` bit in packed ownership.
491     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
492 
493     // The bit mask of the `nextInitialized` bit in packed ownership.
494     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
495 
496     // The tokenId of the next token to be minted.
497     uint256 private _currentIndex;
498 
499     // The number of tokens burned.
500     uint256 private _burnCounter;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned.
510     // See `_packedOwnershipOf` implementation for details.
511     //
512     // Bits Layout:
513     // - [0..159]   `addr`
514     // - [160..223] `startTimestamp`
515     // - [224]      `burned`
516     // - [225]      `nextInitialized`
517     mapping(uint256 => uint256) private _packedOwnerships;
518 
519     // Mapping owner address to address data.
520     //
521     // Bits Layout:
522     // - [0..63]    `balance`
523     // - [64..127]  `numberMinted`
524     // - [128..191] `numberBurned`
525     // - [192..255] `aux`
526     mapping(address => uint256) private _packedAddressData;
527 
528     // Mapping from token ID to approved address.
529     mapping(uint256 => address) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     constructor(string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537         _currentIndex = _startTokenId();
538     }
539 
540     /**
541      * @dev Returns the starting token ID. 
542      * To change the starting token ID, please override this function.
543      */
544     function _startTokenId() internal view virtual returns (uint256) {
545         return 0;
546     }
547 
548     /**
549      * @dev Returns the next token ID to be minted.
550      */
551     function _nextTokenId() internal view returns (uint256) {
552         return _currentIndex;
553     }
554 
555     /**
556      * @dev Returns the total number of tokens in existence.
557      * Burned tokens will reduce the count. 
558      * To get the total number of tokens minted, please see `_totalMinted`.
559      */
560     function totalSupply() public view override returns (uint256) {
561         // Counter underflow is impossible as _burnCounter cannot be incremented
562         // more than `_currentIndex - _startTokenId()` times.
563         unchecked {
564             return _currentIndex - _burnCounter - _startTokenId();
565         }
566     }
567 
568     /**
569      * @dev Returns the total amount of tokens minted in the contract.
570      */
571     function _totalMinted() internal view returns (uint256) {
572         // Counter underflow is impossible as _currentIndex does not decrement,
573         // and it is initialized to `_startTokenId()`
574         unchecked {
575             return _currentIndex - _startTokenId();
576         }
577     }
578 
579     /**
580      * @dev Returns the total number of tokens burned.
581      */
582     function _totalBurned() internal view returns (uint256) {
583         return _burnCounter;
584     }
585 
586     /**
587      * @dev See {IERC165-supportsInterface}.
588      */
589     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590         // The interface IDs are constants representing the first 4 bytes of the XOR of
591         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
592         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
593         return
594             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
595             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
596             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
597     }
598 
599     /**
600      * @dev See {IERC721-balanceOf}.
601      */
602     function balanceOf(address owner) public view override returns (uint256) {
603         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
604         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the number of tokens minted by `owner`.
609      */
610     function _numberMinted(address owner) internal view returns (uint256) {
611         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens burned by or on behalf of `owner`.
616      */
617     function _numberBurned(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
623      */
624     function _getAux(address owner) internal view returns (uint64) {
625         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
626     }
627 
628     /**
629      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
630      * If there are multiple variables, please pack them into a uint64.
631      */
632     function _setAux(address owner, uint64 aux) internal {
633         uint256 packed = _packedAddressData[owner];
634         uint256 auxCasted;
635         assembly { // Cast aux without masking.
636             auxCasted := aux
637         }
638         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
639         _packedAddressData[owner] = packed;
640     }
641 
642     /**
643      * Returns the packed ownership data of `tokenId`.
644      */
645     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
646         uint256 curr = tokenId;
647 
648         unchecked {
649             if (_startTokenId() <= curr)
650                 if (curr < _currentIndex) {
651                     uint256 packed = _packedOwnerships[curr];
652                     // If not burned.
653                     if (packed & BITMASK_BURNED == 0) {
654                         // Invariant:
655                         // There will always be an ownership that has an address and is not burned
656                         // before an ownership that does not have an address and is not burned.
657                         // Hence, curr will not underflow.
658                         //
659                         // We can directly compare the packed value.
660                         // If the address is zero, packed is zero.
661                         while (packed == 0) {
662                             packed = _packedOwnerships[--curr];
663                         }
664                         return packed;
665                     }
666                 }
667         }
668         revert OwnerQueryForNonexistentToken();
669     }
670 
671     /**
672      * Returns the unpacked `TokenOwnership` struct from `packed`.
673      */
674     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
675         ownership.addr = address(uint160(packed));
676         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
677         ownership.burned = packed & BITMASK_BURNED != 0;
678     }
679 
680     /**
681      * Returns the unpacked `TokenOwnership` struct at `index`.
682      */
683     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
684         return _unpackedOwnership(_packedOwnerships[index]);
685     }
686 
687     /**
688      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
689      */
690     function _initializeOwnershipAt(uint256 index) internal {
691         if (_packedOwnerships[index] == 0) {
692             _packedOwnerships[index] = _packedOwnershipOf(index);
693         }
694     }
695 
696     /**
697      * Gas spent here starts off proportional to the maximum mint batch size.
698      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
699      */
700     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
701         return _unpackedOwnership(_packedOwnershipOf(tokenId));
702     }
703 
704     /**
705      * @dev See {IERC721-ownerOf}.
706      */
707     function ownerOf(uint256 tokenId) public view override returns (address) {
708         return address(uint160(_packedOwnershipOf(tokenId)));
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
729         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
730 
731         string memory baseURI = _baseURI();
732         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
733     }
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, can be overriden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return '';
742     }
743 
744     /**
745      * @dev Casts the address to uint256 without masking.
746      */
747     function _addressToUint256(address value) private pure returns (uint256 result) {
748         assembly {
749             result := value
750         }
751     }
752 
753     /**
754      * @dev Casts the boolean to uint256 without branching.
755      */
756     function _boolToUint256(bool value) private pure returns (uint256 result) {
757         assembly {
758             result := value
759         }
760     }
761 
762     /**
763      * @dev See {IERC721-approve}.
764      */
765     function approve(address to, uint256 tokenId) public override {
766         address owner = address(uint160(_packedOwnershipOf(tokenId)));
767         if (to == owner) revert ApprovalToCurrentOwner();
768 
769         if (_msgSenderERC721A() != owner)
770             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
771                 revert ApprovalCallerNotOwnerNorApproved();
772             }
773 
774         _tokenApprovals[tokenId] = to;
775         emit Approval(owner, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-getApproved}.
780      */
781     function getApproved(uint256 tokenId) public view override returns (address) {
782         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
783 
784         return _tokenApprovals[tokenId];
785     }
786 
787     /**
788      * @dev See {IERC721-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved) public virtual override {
791         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
792 
793         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
794         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
795     }
796 
797     /**
798      * @dev See {IERC721-isApprovedForAll}.
799      */
800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
801         return _operatorApprovals[owner][operator];
802     }
803 
804     /**
805      * @dev See {IERC721-transferFrom}.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) public virtual override {
812         _transfer(from, to, tokenId);
813     }
814 
815     /**
816      * @dev See {IERC721-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) public virtual override {
823         safeTransferFrom(from, to, tokenId, '');
824     }
825 
826     /**
827      * @dev See {IERC721-safeTransferFrom}.
828      */
829     function safeTransferFrom(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) public virtual override {
835         _transfer(from, to, tokenId);
836         if (to.code.length != 0)
837             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
838                 revert TransferToNonERC721ReceiverImplementer();
839             }
840     }
841 
842     /**
843      * @dev Returns whether `tokenId` exists.
844      *
845      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
846      *
847      * Tokens start existing when they are minted (`_mint`),
848      */
849     function _exists(uint256 tokenId) internal view returns (bool) {
850         return
851             _startTokenId() <= tokenId &&
852             tokenId < _currentIndex && // If within bounds,
853             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
854     }
855 
856     /**
857      * @dev Equivalent to `_safeMint(to, quantity, '')`.
858      */
859     function _safeMint(address to, uint256 quantity) internal {
860         _safeMint(to, quantity, '');
861     }
862 
863     /**
864      * @dev Safely mints `quantity` tokens and transfers them to `to`.
865      *
866      * Requirements:
867      *
868      * - If `to` refers to a smart contract, it must implement
869      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
870      * - `quantity` must be greater than 0.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _safeMint(
875         address to,
876         uint256 quantity,
877         bytes memory _data
878     ) internal {
879         uint256 startTokenId = _currentIndex;
880         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
881         if (quantity == 0) revert MintZeroQuantity();
882 
883         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
884 
885         // Overflows are incredibly unrealistic.
886         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
887         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
888         unchecked {
889             // Updates:
890             // - `balance += quantity`.
891             // - `numberMinted += quantity`.
892             //
893             // We can directly add to the balance and number minted.
894             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
895 
896             // Updates:
897             // - `address` to the owner.
898             // - `startTimestamp` to the timestamp of minting.
899             // - `burned` to `false`.
900             // - `nextInitialized` to `quantity == 1`.
901             _packedOwnerships[startTokenId] =
902                 _addressToUint256(to) |
903                 (block.timestamp << BITPOS_START_TIMESTAMP) |
904                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
905 
906             uint256 updatedIndex = startTokenId;
907             uint256 end = updatedIndex + quantity;
908 
909             if (to.code.length != 0) {
910                 do {
911                     emit Transfer(address(0), to, updatedIndex);
912                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
913                         revert TransferToNonERC721ReceiverImplementer();
914                     }
915                 } while (updatedIndex < end);
916                 // Reentrancy protection
917                 if (_currentIndex != startTokenId) revert();
918             } else {
919                 do {
920                     emit Transfer(address(0), to, updatedIndex++);
921                 } while (updatedIndex < end);
922             }
923             _currentIndex = updatedIndex;
924         }
925         _afterTokenTransfers(address(0), to, startTokenId, quantity);
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 quantity) internal {
939         uint256 startTokenId = _currentIndex;
940         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
941         if (quantity == 0) revert MintZeroQuantity();
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are incredibly unrealistic.
946         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
947         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
948         unchecked {
949             // Updates:
950             // - `balance += quantity`.
951             // - `numberMinted += quantity`.
952             //
953             // We can directly add to the balance and number minted.
954             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
955 
956             // Updates:
957             // - `address` to the owner.
958             // - `startTimestamp` to the timestamp of minting.
959             // - `burned` to `false`.
960             // - `nextInitialized` to `quantity == 1`.
961             _packedOwnerships[startTokenId] =
962                 _addressToUint256(to) |
963                 (block.timestamp << BITPOS_START_TIMESTAMP) |
964                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
965 
966             uint256 updatedIndex = startTokenId;
967             uint256 end = updatedIndex + quantity;
968 
969             do {
970                 emit Transfer(address(0), to, updatedIndex++);
971             } while (updatedIndex < end);
972 
973             _currentIndex = updatedIndex;
974         }
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _transfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) private {
993         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
994 
995         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
996 
997         address approvedAddress = _tokenApprovals[tokenId];
998 
999         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1000             isApprovedForAll(from, _msgSenderERC721A()) ||
1001             approvedAddress == _msgSenderERC721A());
1002 
1003         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1004         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1005 
1006         _beforeTokenTransfers(from, to, tokenId, 1);
1007 
1008         // Clear approvals from the previous owner.
1009         if (_addressToUint256(approvedAddress) != 0) {
1010             delete _tokenApprovals[tokenId];
1011         }
1012 
1013         // Underflow of the sender's balance is impossible because we check for
1014         // ownership above and the recipient's balance can't realistically overflow.
1015         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1016         unchecked {
1017             // We can directly increment and decrement the balances.
1018             --_packedAddressData[from]; // Updates: `balance -= 1`.
1019             ++_packedAddressData[to]; // Updates: `balance += 1`.
1020 
1021             // Updates:
1022             // - `address` to the next owner.
1023             // - `startTimestamp` to the timestamp of transfering.
1024             // - `burned` to `false`.
1025             // - `nextInitialized` to `true`.
1026             _packedOwnerships[tokenId] =
1027                 _addressToUint256(to) |
1028                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1029                 BITMASK_NEXT_INITIALIZED;
1030 
1031             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1032             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1033                 uint256 nextTokenId = tokenId + 1;
1034                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1035                 if (_packedOwnerships[nextTokenId] == 0) {
1036                     // If the next slot is within bounds.
1037                     if (nextTokenId != _currentIndex) {
1038                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1039                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1040                     }
1041                 }
1042             }
1043         }
1044 
1045         emit Transfer(from, to, tokenId);
1046         _afterTokenTransfers(from, to, tokenId, 1);
1047     }
1048 
1049     /**
1050      * @dev Equivalent to `_burn(tokenId, false)`.
1051      */
1052     function _burn(uint256 tokenId) internal virtual {
1053         _burn(tokenId, false);
1054     }
1055 
1056     /**
1057      * @dev Destroys `tokenId`.
1058      * The approval is cleared when the token is burned.
1059      *
1060      * Requirements:
1061      *
1062      * - `tokenId` must exist.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1067         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1068 
1069         address from = address(uint160(prevOwnershipPacked));
1070         address approvedAddress = _tokenApprovals[tokenId];
1071 
1072         if (approvalCheck) {
1073             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1074                 isApprovedForAll(from, _msgSenderERC721A()) ||
1075                 approvedAddress == _msgSenderERC721A());
1076 
1077             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         }
1079 
1080         _beforeTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         // Clear approvals from the previous owner.
1083         if (_addressToUint256(approvedAddress) != 0) {
1084             delete _tokenApprovals[tokenId];
1085         }
1086 
1087         // Underflow of the sender's balance is impossible because we check for
1088         // ownership above and the recipient's balance can't realistically overflow.
1089         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1090         unchecked {
1091             // Updates:
1092             // - `balance -= 1`.
1093             // - `numberBurned += 1`.
1094             //
1095             // We can directly decrement the balance, and increment the number burned.
1096             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1097             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1098 
1099             // Updates:
1100             // - `address` to the last owner.
1101             // - `startTimestamp` to the timestamp of burning.
1102             // - `burned` to `true`.
1103             // - `nextInitialized` to `true`.
1104             _packedOwnerships[tokenId] =
1105                 _addressToUint256(from) |
1106                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1107                 BITMASK_BURNED | 
1108                 BITMASK_NEXT_INITIALIZED;
1109 
1110             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1111             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1112                 uint256 nextTokenId = tokenId + 1;
1113                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1114                 if (_packedOwnerships[nextTokenId] == 0) {
1115                     // If the next slot is within bounds.
1116                     if (nextTokenId != _currentIndex) {
1117                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1118                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1119                     }
1120                 }
1121             }
1122         }
1123 
1124         emit Transfer(from, address(0), tokenId);
1125         _afterTokenTransfers(from, address(0), tokenId, 1);
1126 
1127         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1128         unchecked {
1129             _burnCounter++;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1135      *
1136      * @param from address representing the previous owner of the given token ID
1137      * @param to target address that will receive the tokens
1138      * @param tokenId uint256 ID of the token to be transferred
1139      * @param _data bytes optional data to send along with the call
1140      * @return bool whether the call correctly returned the expected magic value
1141      */
1142     function _checkContractOnERC721Received(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) private returns (bool) {
1148         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1149             bytes4 retval
1150         ) {
1151             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1152         } catch (bytes memory reason) {
1153             if (reason.length == 0) {
1154                 revert TransferToNonERC721ReceiverImplementer();
1155             } else {
1156                 assembly {
1157                     revert(add(32, reason), mload(reason))
1158                 }
1159             }
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1165      * And also called before burning one token.
1166      *
1167      * startTokenId - the first token id to be transferred
1168      * quantity - the amount to be transferred
1169      *
1170      * Calling conditions:
1171      *
1172      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1173      * transferred to `to`.
1174      * - When `from` is zero, `tokenId` will be minted for `to`.
1175      * - When `to` is zero, `tokenId` will be burned by `from`.
1176      * - `from` and `to` are never both zero.
1177      */
1178     function _beforeTokenTransfers(
1179         address from,
1180         address to,
1181         uint256 startTokenId,
1182         uint256 quantity
1183     ) internal virtual {}
1184 
1185     /**
1186      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1187      * minting.
1188      * And also called after one token has been burned.
1189      *
1190      * startTokenId - the first token id to be transferred
1191      * quantity - the amount to be transferred
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` has been minted for `to`.
1198      * - When `to` is zero, `tokenId` has been burned by `from`.
1199      * - `from` and `to` are never both zero.
1200      */
1201     function _afterTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 
1208     /**
1209      * @dev Returns the message sender (defaults to `msg.sender`).
1210      *
1211      * If you are writing GSN compatible contracts, you need to override this function.
1212      */
1213     function _msgSenderERC721A() internal view virtual returns (address) {
1214         return msg.sender;
1215     }
1216 
1217     /**
1218      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1219      */
1220     function _toString(uint256 value) internal pure returns (string memory ptr) {
1221         assembly {
1222             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1223             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1224             // We will need 1 32-byte word to store the length, 
1225             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1226             ptr := add(mload(0x40), 128)
1227             // Update the free memory pointer to allocate.
1228             mstore(0x40, ptr)
1229 
1230             // Cache the end of the memory to calculate the length later.
1231             let end := ptr
1232 
1233             // We write the string from the rightmost digit to the leftmost digit.
1234             // The following is essentially a do-while loop that also handles the zero case.
1235             // Costs a bit more than early returning for the zero case,
1236             // but cheaper in terms of deployment and overall runtime costs.
1237             for { 
1238                 // Initialize and perform the first pass without check.
1239                 let temp := value
1240                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1241                 ptr := sub(ptr, 1)
1242                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1243                 mstore8(ptr, add(48, mod(temp, 10)))
1244                 temp := div(temp, 10)
1245             } temp { 
1246                 // Keep dividing `temp` until zero.
1247                 temp := div(temp, 10)
1248             } { // Body of the for loop.
1249                 ptr := sub(ptr, 1)
1250                 mstore8(ptr, add(48, mod(temp, 10)))
1251             }
1252             
1253             let length := sub(end, ptr)
1254             // Move the pointer 32 bytes leftwards to make room for the length.
1255             ptr := sub(ptr, 32)
1256             // Store the length.
1257             mstore(ptr, length)
1258         }
1259     }
1260 }
1261 
1262 
1263 // File contracts/WithdrawFairly.sol
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 contract WithdrawFairly {
1268     error Unauthorized();
1269     error ZeroBalance();
1270     error TransferFailed();
1271 
1272     struct Part {
1273         address wallet;
1274         uint16 salePart;
1275         uint16 royaltiesPart;
1276     }
1277 
1278     Part[] public parts;
1279     mapping(address => bool) public callers;
1280 
1281     constructor(){
1282         parts.push(Part(0xecB4278af1379c38Eab140063fFC426f05FEde28, 1000, 1000));
1283         callers[0xecB4278af1379c38Eab140063fFC426f05FEde28] = true;
1284         parts.push(Part(0xE1580cA711094CF2888716a54c5A892245653435, 1000, 2000));
1285         callers[0xE1580cA711094CF2888716a54c5A892245653435] = true;
1286         parts.push(Part(0xc6738fd2235042956ffbE94C77d0958D3927Ed89, 350, 0));
1287         callers[0xc6738fd2235042956ffbE94C77d0958D3927Ed89] = true;
1288         parts.push(Part(0x158C2406D5BA83F9019398753c1b4aF1A61819B6, 770, 0));
1289         callers[0x158C2406D5BA83F9019398753c1b4aF1A61819B6] = true;
1290         parts.push(Part(0x06DcBa9ef76B9C6a129Df78D55f99989905e5F96, 800, 2800));
1291         callers[0x06DcBa9ef76B9C6a129Df78D55f99989905e5F96] = true;
1292         parts.push(Part(0x9d246cA915ea31be43B4eF151e473d6e8Bc892eF, 2837, 2172));
1293         callers[0x9d246cA915ea31be43B4eF151e473d6e8Bc892eF] = true;
1294         parts.push(Part(0x2af89f045fB0B17Ad218423Cff3744ee25a69845, 2600, 2028));
1295         callers[0x2af89f045fB0B17Ad218423Cff3744ee25a69845] = true;
1296         parts.push(Part(0x0b7BeF50CE4D522636E955179DEC09a55f7aF845, 643, 0));
1297         callers[0x0b7BeF50CE4D522636E955179DEC09a55f7aF845] = true;
1298     }
1299 
1300     function shareSalesPart() external {
1301         if (!callers[msg.sender])
1302             revert Unauthorized();
1303 
1304         uint256 balance = address(this).balance;
1305 
1306         if (balance == 0)
1307             revert ZeroBalance();
1308 
1309         for (uint256 i; i < parts.length;){
1310             if (parts[i].salePart > 0)
1311                 _withdraw(parts[i].wallet, balance * parts[i].salePart / 10000);
1312 
1313             unchecked {
1314                 i++;
1315             }
1316         }
1317     }
1318 
1319     function shareRoyaltiesPart() external {
1320         if (!callers[msg.sender])
1321             revert Unauthorized();
1322 
1323         uint256 balance = address(this).balance;
1324 
1325         if (balance == 0)
1326             revert ZeroBalance();
1327 
1328         for (uint256 i; i < parts.length;) {
1329             if (parts[i].royaltiesPart > 0)
1330                 _withdraw(parts[i].wallet, balance * parts[i].royaltiesPart / 10000);
1331 
1332             unchecked {
1333                 i++;
1334             }
1335         }
1336     }
1337 
1338     function _withdraw(address _address, uint256 _amount) private {
1339         (bool success, ) = _address.call{value: _amount}("");
1340         
1341         if (!success)
1342             revert TransferFailed();
1343     }
1344 
1345     receive() external payable {}
1346 
1347 }
1348 
1349 
1350 // File contracts/MoonLanderzNFT.sol
1351 
1352 pragma solidity ^0.8.7;
1353 
1354 // @author: 0x0
1355 
1356 contract MoonLanderzNFT is ERC721A, Ownable, WithdrawFairly {
1357     error AlreadyRevealed();
1358     error ZeroValueParam();
1359     error AmountParamGtThanMax();
1360     error CollectionSoldOut();
1361     error CollectionNotSoldOut();
1362     error NotPresale();
1363     error MaxPresaleMints();
1364     error NotWhitelisted();
1365     error NotSale();
1366     error MaxSaleTxMintsReached();
1367     error IncorrectETHValue();
1368     error NotEnoughNFTs();
1369 
1370     // Minting data
1371     uint256 public constant SALE_PRICE = 0.088 ether;
1372 
1373     uint64 public constant SPECIAL_SUPPLY = 5;
1374     uint64 public constant TEAM_SUPPLY = 145;
1375     // Represents total mint supply including team supply excluding special
1376     // = totalSupply (7890) - special
1377     uint64 public constant MINT_SUPPLY = 7890 - SPECIAL_SUPPLY;
1378 
1379     // Validating whitelisted addresses using merkle tree
1380     bytes32 public merkleRoot;
1381 
1382     // Metadata data
1383     string public baseURI;
1384     string public unrevealedURI;
1385     string public specialUnrevealedURI;
1386     string public specialURI;
1387 
1388     uint256 public presaleStart;
1389     uint256 public presaleEnd;
1390 
1391     uint256 private teamCount;
1392     uint256 private specialCount;
1393 
1394     event MerkleRootUpdated(bytes32 root);
1395     event SetUnrevealedURI(string unrevealedURI_);
1396     event SetSpecialUnrevealedURI(string specialUnrevealedURI_);
1397     event Reveal(string baseURI_);
1398     event RevealSpecial(string specialURI_);
1399 
1400     constructor(
1401         uint256 presaleStart_,
1402         uint256 presaleEnd_,
1403         bytes32 merkleRoot_
1404     )
1405         ERC721A("MoonLanderz", "MLZ")
1406     {
1407         presaleStart = presaleStart_;
1408         presaleEnd = presaleEnd_;
1409         merkleRoot = merkleRoot_;
1410     }
1411 
1412     function setUnrevealedURI(string calldata unrevealedURI_) 
1413         external
1414         onlyOwner
1415     {
1416         unrevealedURI = unrevealedURI_;
1417 
1418         emit SetUnrevealedURI(unrevealedURI_);
1419     }
1420 
1421      function setSpecialUnrevealedURI(string calldata specialUnrevealedURI_)
1422         external
1423         onlyOwner
1424     {
1425         specialUnrevealedURI = specialUnrevealedURI_;
1426 
1427         emit SetSpecialUnrevealedURI(specialUnrevealedURI_);
1428     }
1429 
1430     function updateMerkleRoot(bytes32 root) external onlyOwner {
1431         merkleRoot = root;
1432 
1433         emit MerkleRootUpdated(root);
1434     }
1435 
1436     function reveal(string calldata baseURI_) external onlyOwner {
1437         if (bytes(baseURI).length > 0)
1438             revert AlreadyRevealed();
1439 
1440         baseURI = baseURI_;
1441 
1442         emit Reveal(baseURI_);
1443     }
1444 
1445     function revealSpecial(string calldata specialURI_) external onlyOwner {
1446         if (bytes(specialURI).length > 0)
1447             revert AlreadyRevealed();
1448 
1449         specialURI = specialURI_;
1450 
1451         emit RevealSpecial(specialURI_);
1452     }
1453 
1454     function teamMint(uint256 amount, address to) external onlyOwner {
1455         teamCount += amount;
1456 
1457         if (teamCount > TEAM_SUPPLY)
1458             revert AmountParamGtThanMax();
1459         // If not minted before sold out, then lost in profit of public sale
1460         if (isSoldOut(amount))
1461             revert CollectionSoldOut();
1462 
1463         _mint(to, amount);
1464     }
1465 
1466     function specialMint(uint256 amount, address to) external onlyOwner {
1467         // Required cuz of ERC721A mint mechanism
1468         // specials will have TOTAL + TEAM + i (>1) ids
1469         // Splits URI metadata no stress xSensei!
1470         if (!isSoldOut(1))
1471             revert CollectionNotSoldOut();
1472 
1473         specialCount += amount;
1474 
1475         if (specialCount > SPECIAL_SUPPLY)
1476             revert AmountParamGtThanMax();
1477 
1478         _mint(to, amount);
1479     }
1480 
1481     function totalMinted() external view returns (uint256) {
1482         return _totalMinted();
1483     }
1484 
1485     function publicMintNumber(address _owner) external view returns (uint256) {
1486         return _getAux(_owner);
1487     }
1488 
1489     function privateMintNumber(address _owner) external view returns (uint256) {
1490         return _numberMinted(_owner) - _getAux(_owner);
1491     }
1492 
1493     function presaleMint(bytes32[] calldata _proof)
1494         external
1495         payable
1496     {
1497         if (!isPresale())
1498             revert NotPresale();
1499 
1500         if (_numberMinted(msg.sender) != 0)
1501             revert MaxPresaleMints();
1502 
1503         if (!_isWhiteListed(msg.sender, _proof))
1504             revert NotWhitelisted();
1505 
1506         if (msg.value != SALE_PRICE)
1507             revert IncorrectETHValue();
1508 
1509         _mint(msg.sender, 1);
1510     }
1511 
1512     function saleMint(uint256 amount) external payable {
1513         // Arbitrary limiting to 3 max / tx
1514         if (amount > 3) 
1515             revert MaxSaleTxMintsReached();
1516 
1517         if (!isSale())
1518             revert NotSale();
1519 
1520         if (isSoldOut(amount))
1521             revert NotEnoughNFTs();
1522 
1523         if (msg.value != SALE_PRICE * amount)
1524             revert IncorrectETHValue();
1525 
1526         _mint(msg.sender, amount);
1527     }
1528 
1529     function isPresale() public view returns (bool) {
1530         return block.timestamp > presaleStart &&
1531             block.timestamp < presaleEnd;
1532     }
1533 
1534     function isSale() public view returns (bool) {
1535         return block.timestamp > presaleEnd;
1536     }
1537 
1538     function isSoldOut(uint256 nftWanted) public view returns (bool) {
1539         return _totalMinted() + nftWanted > MINT_SUPPLY;
1540     }
1541 
1542     function tokenURI(uint256 _nftId)
1543         public
1544         view
1545         override
1546         returns (string memory)
1547     {
1548         if (!_exists(_nftId))
1549             revert URIQueryForNonexistentToken();
1550 
1551         // Checks if is special => 1/1
1552         if (_nftId > MINT_SUPPLY) {
1553             return bytes(specialURI).length != 0 ? 
1554                 string(abi.encodePacked(specialURI, _toString(_nftId), ".json")) :
1555                 specialUnrevealedURI;
1556         } else {
1557             return bytes(baseURI).length != 0 ?
1558                 string(abi.encodePacked(baseURI, _toString(_nftId), ".json")) :
1559                 unrevealedURI;
1560         }
1561     }
1562 
1563     function _startTokenId() internal pure override returns (uint256) {
1564         return 1;
1565     }
1566 
1567     function _isWhiteListed(address account, bytes32[] calldata proof)
1568         private
1569         view
1570         returns(bool)
1571     {
1572         return _verify(_leaf(account), proof);
1573     }
1574 
1575     function _leaf(address account) private pure returns(bytes32) {
1576         return keccak256(abi.encodePacked(account));
1577     }
1578 
1579     function _verify(bytes32 leaf, bytes32[] memory proof)
1580         private
1581         view
1582         returns (bool)
1583     {
1584         return MerkleProof.verify(proof, merkleRoot, leaf);
1585     }
1586 }