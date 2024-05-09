1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev These functions deal with verification of Merkle Trees proofs.
81  *
82  * The proofs can be generated using the JavaScript library
83  * https://github.com/miguelmota/merkletreejs[merkletreejs].
84  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
85  *
86  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
87  *
88  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
89  * hashing, or use a hash function other than keccak256 for hashing leaves.
90  * This is because the concatenation of a sorted pair of internal nodes in
91  * the merkle tree could be reinterpreted as a leaf value.
92  */
93 library MerkleProof {
94     /**
95      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
96      * defined by `root`. For this, a `proof` must be provided, containing
97      * sibling hashes on the branch from the leaf to the root of the tree. Each
98      * pair of leaves and each pair of pre-images are assumed to be sorted.
99      */
100     function verify(
101         bytes32[] memory proof,
102         bytes32 root,
103         bytes32 leaf
104     ) internal pure returns (bool) {
105         return processProof(proof, leaf) == root;
106     }
107 
108     /**
109      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
110      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
111      * hash matches the root of the tree. When processing the proof, the pairs
112      * of leafs & pre-images are assumed to be sorted.
113      *
114      * _Available since v4.4._
115      */
116     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
117         bytes32 computedHash = leaf;
118         for (uint256 i = 0; i < proof.length; i++) {
119             bytes32 proofElement = proof[i];
120             if (computedHash <= proofElement) {
121                 // Hash(current computed hash + current element of the proof)
122                 computedHash = _efficientHash(computedHash, proofElement);
123             } else {
124                 // Hash(current element of the proof + current computed hash)
125                 computedHash = _efficientHash(proofElement, computedHash);
126             }
127         }
128         return computedHash;
129     }
130 
131     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
132         assembly {
133             mstore(0x00, a)
134             mstore(0x20, b)
135             value := keccak256(0x00, 0x40)
136         }
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Context.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157 abstract contract Context {
158     function _msgSender() internal view virtual returns (address) {
159         return msg.sender;
160     }
161 
162     function _msgData() internal view virtual returns (bytes calldata) {
163         return msg.data;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Contract module which provides a basic access control mechanism, where
177  * there is an account (an owner) that can be granted exclusive access to
178  * specific functions.
179  *
180  * By default, the owner account will be the one that deploys the contract. This
181  * can later be changed with {transferOwnership}.
182  *
183  * This module is used through inheritance. It will make available the modifier
184  * `onlyOwner`, which can be applied to your functions to restrict their use to
185  * the owner.
186  */
187 abstract contract Ownable is Context {
188     address private _owner;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     /**
193      * @dev Initializes the contract setting the deployer as the initial owner.
194      */
195     constructor() {
196         _transferOwnership(_msgSender());
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
211         _;
212     }
213 
214     /**
215      * @dev Leaves the contract without owner. It will not be possible to call
216      * `onlyOwner` functions anymore. Can only be called by the current owner.
217      *
218      * NOTE: Renouncing ownership will leave the contract without an owner,
219      * thereby removing any functionality that is only available to the owner.
220      */
221     function renounceOwnership() public virtual onlyOwner {
222         _transferOwnership(address(0));
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 // File: erc721a/contracts/IERC721A.sol
246 
247 
248 // ERC721A Contracts v4.0.0
249 // Creator: Chiru Labs
250 
251 pragma solidity ^0.8.4;
252 
253 /**
254  * @dev Interface of an ERC721A compliant contract.
255  */
256 interface IERC721A {
257     /**
258      * The caller must own the token or be an approved operator.
259      */
260     error ApprovalCallerNotOwnerNorApproved();
261 
262     /**
263      * The token does not exist.
264      */
265     error ApprovalQueryForNonexistentToken();
266 
267     /**
268      * The caller cannot approve to their own address.
269      */
270     error ApproveToCaller();
271 
272     /**
273      * The caller cannot approve to the current owner.
274      */
275     error ApprovalToCurrentOwner();
276 
277     /**
278      * Cannot query the balance for the zero address.
279      */
280     error BalanceQueryForZeroAddress();
281 
282     /**
283      * Cannot mint to the zero address.
284      */
285     error MintToZeroAddress();
286 
287     /**
288      * The quantity of tokens minted must be more than zero.
289      */
290     error MintZeroQuantity();
291 
292     /**
293      * The token does not exist.
294      */
295     error OwnerQueryForNonexistentToken();
296 
297     /**
298      * The caller must own the token or be an approved operator.
299      */
300     error TransferCallerNotOwnerNorApproved();
301 
302     /**
303      * The token must be owned by `from`.
304      */
305     error TransferFromIncorrectOwner();
306 
307     /**
308      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
309      */
310     error TransferToNonERC721ReceiverImplementer();
311 
312     /**
313      * Cannot transfer to the zero address.
314      */
315     error TransferToZeroAddress();
316 
317     /**
318      * The token does not exist.
319      */
320     error URIQueryForNonexistentToken();
321 
322     struct TokenOwnership {
323         // The address of the owner.
324         address addr;
325         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
326         uint64 startTimestamp;
327         // Whether the token has been burned.
328         bool burned;
329     }
330 
331     /**
332      * @dev Returns the total amount of tokens stored by the contract.
333      *
334      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
335      */
336     function totalSupply() external view returns (uint256);
337 
338     // ==============================
339     //            IERC165
340     // ==============================
341 
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 
352     // ==============================
353     //            IERC721
354     // ==============================
355 
356     /**
357      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
363      */
364     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
368      */
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of tokens in ``owner``'s account.
373      */
374     function balanceOf(address owner) external view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function ownerOf(uint256 tokenId) external view returns (address owner);
384 
385     /**
386      * @dev Safely transfers `tokenId` token from `from` to `to`.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must exist and be owned by `from`.
393      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395      *
396      * Emits a {Transfer} event.
397      */
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId,
402         bytes calldata data
403     ) external;
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Approve or remove `operator` as an operator for the caller.
462      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
463      *
464      * Requirements:
465      *
466      * - The `operator` cannot be the caller.
467      *
468      * Emits an {ApprovalForAll} event.
469      */
470     function setApprovalForAll(address operator, bool _approved) external;
471 
472     /**
473      * @dev Returns the account approved for `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function getApproved(uint256 tokenId) external view returns (address operator);
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 
488     // ==============================
489     //        IERC721Metadata
490     // ==============================
491 
492     /**
493      * @dev Returns the token collection name.
494      */
495     function name() external view returns (string memory);
496 
497     /**
498      * @dev Returns the token collection symbol.
499      */
500     function symbol() external view returns (string memory);
501 
502     /**
503      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
504      */
505     function tokenURI(uint256 tokenId) external view returns (string memory);
506 }
507 
508 // File: erc721a/contracts/ERC721A.sol
509 
510 
511 // ERC721A Contracts v4.0.0
512 // Creator: Chiru Labs
513 
514 pragma solidity ^0.8.4;
515 
516 
517 /**
518  * @dev ERC721 token receiver interface.
519  */
520 interface ERC721A__IERC721Receiver {
521     function onERC721Received(
522         address operator,
523         address from,
524         uint256 tokenId,
525         bytes calldata data
526     ) external returns (bytes4);
527 }
528 
529 /**
530  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
531  * the Metadata extension. Built to optimize for lower gas during batch mints.
532  *
533  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
534  *
535  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
536  *
537  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
538  */
539 contract ERC721A is IERC721A {
540     // Mask of an entry in packed address data.
541     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
542 
543     // The bit position of `numberMinted` in packed address data.
544     uint256 private constant BITPOS_NUMBER_MINTED = 64;
545 
546     // The bit position of `numberBurned` in packed address data.
547     uint256 private constant BITPOS_NUMBER_BURNED = 128;
548 
549     // The bit position of `aux` in packed address data.
550     uint256 private constant BITPOS_AUX = 192;
551 
552     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
553     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
554 
555     // The bit position of `startTimestamp` in packed ownership.
556     uint256 private constant BITPOS_START_TIMESTAMP = 160;
557 
558     // The bit mask of the `burned` bit in packed ownership.
559     uint256 private constant BITMASK_BURNED = 1 << 224;
560     
561     // The bit position of the `nextInitialized` bit in packed ownership.
562     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
563 
564     // The bit mask of the `nextInitialized` bit in packed ownership.
565     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
566 
567     // The tokenId of the next token to be minted.
568     uint256 private _currentIndex;
569 
570     // The number of tokens burned.
571     uint256 private _burnCounter;
572 
573     // Token name
574     string private _name;
575 
576     // Token symbol
577     string private _symbol;
578 
579     // Mapping from token ID to ownership details
580     // An empty struct value does not necessarily mean the token is unowned.
581     // See `_packedOwnershipOf` implementation for details.
582     //
583     // Bits Layout:
584     // - [0..159]   `addr`
585     // - [160..223] `startTimestamp`
586     // - [224]      `burned`
587     // - [225]      `nextInitialized`
588     mapping(uint256 => uint256) private _packedOwnerships;
589 
590     // Mapping owner address to address data.
591     //
592     // Bits Layout:
593     // - [0..63]    `balance`
594     // - [64..127]  `numberMinted`
595     // - [128..191] `numberBurned`
596     // - [192..255] `aux`
597     mapping(address => uint256) private _packedAddressData;
598 
599     // Mapping from token ID to approved address.
600     mapping(uint256 => address) private _tokenApprovals;
601 
602     // Mapping from owner to operator approvals
603     mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605     constructor(string memory name_, string memory symbol_) {
606         _name = name_;
607         _symbol = symbol_;
608         _currentIndex = _startTokenId();
609     }
610 
611     /**
612      * @dev Returns the starting token ID. 
613      * To change the starting token ID, please override this function.
614      */
615     function _startTokenId() internal view virtual returns (uint256) {
616         return 0;
617     }
618 
619     /**
620      * @dev Returns the next token ID to be minted.
621      */
622     function _nextTokenId() internal view returns (uint256) {
623         return _currentIndex;
624     }
625 
626     /**
627      * @dev Returns the total number of tokens in existence.
628      * Burned tokens will reduce the count. 
629      * To get the total number of tokens minted, please see `_totalMinted`.
630      */
631     function totalSupply() public view override returns (uint256) {
632         // Counter underflow is impossible as _burnCounter cannot be incremented
633         // more than `_currentIndex - _startTokenId()` times.
634         unchecked {
635             return _currentIndex - _burnCounter - _startTokenId();
636         }
637     }
638 
639     /**
640      * @dev Returns the total amount of tokens minted in the contract.
641      */
642     function _totalMinted() internal view returns (uint256) {
643         // Counter underflow is impossible as _currentIndex does not decrement,
644         // and it is initialized to `_startTokenId()`
645         unchecked {
646             return _currentIndex - _startTokenId();
647         }
648     }
649 
650     /**
651      * @dev Returns the total number of tokens burned.
652      */
653     function _totalBurned() internal view returns (uint256) {
654         return _burnCounter;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661         // The interface IDs are constants representing the first 4 bytes of the XOR of
662         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
663         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
664         return
665             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
666             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
667             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
668     }
669 
670     /**
671      * @dev See {IERC721-balanceOf}.
672      */
673     function balanceOf(address owner) public view override returns (uint256) {
674         if (owner == address(0)) revert BalanceQueryForZeroAddress();
675         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
676     }
677 
678     /**
679      * Returns the number of tokens minted by `owner`.
680      */
681     function _numberMinted(address owner) internal view returns (uint256) {
682         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
683     }
684 
685     /**
686      * Returns the number of tokens burned by or on behalf of `owner`.
687      */
688     function _numberBurned(address owner) internal view returns (uint256) {
689         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
694      */
695     function _getAux(address owner) internal view returns (uint64) {
696         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
697     }
698 
699     /**
700      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
701      * If there are multiple variables, please pack them into a uint64.
702      */
703     function _setAux(address owner, uint64 aux) internal {
704         uint256 packed = _packedAddressData[owner];
705         uint256 auxCasted;
706         assembly { // Cast aux without masking.
707             auxCasted := aux
708         }
709         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
710         _packedAddressData[owner] = packed;
711     }
712 
713     /**
714      * Returns the packed ownership data of `tokenId`.
715      */
716     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
717         uint256 curr = tokenId;
718 
719         unchecked {
720             if (_startTokenId() <= curr)
721                 if (curr < _currentIndex) {
722                     uint256 packed = _packedOwnerships[curr];
723                     // If not burned.
724                     if (packed & BITMASK_BURNED == 0) {
725                         // Invariant:
726                         // There will always be an ownership that has an address and is not burned
727                         // before an ownership that does not have an address and is not burned.
728                         // Hence, curr will not underflow.
729                         //
730                         // We can directly compare the packed value.
731                         // If the address is zero, packed is zero.
732                         while (packed == 0) {
733                             packed = _packedOwnerships[--curr];
734                         }
735                         return packed;
736                     }
737                 }
738         }
739         revert OwnerQueryForNonexistentToken();
740     }
741 
742     /**
743      * Returns the unpacked `TokenOwnership` struct from `packed`.
744      */
745     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
746         ownership.addr = address(uint160(packed));
747         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
748         ownership.burned = packed & BITMASK_BURNED != 0;
749     }
750 
751     /**
752      * Returns the unpacked `TokenOwnership` struct at `index`.
753      */
754     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
755         return _unpackedOwnership(_packedOwnerships[index]);
756     }
757 
758     /**
759      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
760      */
761     function _initializeOwnershipAt(uint256 index) internal {
762         if (_packedOwnerships[index] == 0) {
763             _packedOwnerships[index] = _packedOwnershipOf(index);
764         }
765     }
766 
767     /**
768      * Gas spent here starts off proportional to the maximum mint batch size.
769      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
770      */
771     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
772         return _unpackedOwnership(_packedOwnershipOf(tokenId));
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view override returns (address) {
779         return address(uint160(_packedOwnershipOf(tokenId)));
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return '';
813     }
814 
815     /**
816      * @dev Casts the address to uint256 without masking.
817      */
818     function _addressToUint256(address value) private pure returns (uint256 result) {
819         assembly {
820             result := value
821         }
822     }
823 
824     /**
825      * @dev Casts the boolean to uint256 without branching.
826      */
827     function _boolToUint256(bool value) private pure returns (uint256 result) {
828         assembly {
829             result := value
830         }
831     }
832 
833     /**
834      * @dev See {IERC721-approve}.
835      */
836     function approve(address to, uint256 tokenId) public override {
837         address owner = address(uint160(_packedOwnershipOf(tokenId)));
838         if (to == owner) revert ApprovalToCurrentOwner();
839 
840         if (_msgSenderERC721A() != owner)
841             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
842                 revert ApprovalCallerNotOwnerNorApproved();
843             }
844 
845         _tokenApprovals[tokenId] = to;
846         emit Approval(owner, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view override returns (address) {
853         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
863 
864         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
865         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         _transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-safeTransferFrom}.
888      */
889     function safeTransferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         safeTransferFrom(from, to, tokenId, '');
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) public virtual override {
906         _transfer(from, to, tokenId);
907         if (to.code.length != 0)
908             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
909                 revert TransferToNonERC721ReceiverImplementer();
910             }
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      */
920     function _exists(uint256 tokenId) internal view returns (bool) {
921         return
922             _startTokenId() <= tokenId &&
923             tokenId < _currentIndex && // If within bounds,
924             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
925     }
926 
927     /**
928      * @dev Equivalent to `_safeMint(to, quantity, '')`.
929      */
930     function _safeMint(address to, uint256 quantity) internal {
931         _safeMint(to, quantity, '');
932     }
933 
934     /**
935      * @dev Safely mints `quantity` tokens and transfers them to `to`.
936      *
937      * Requirements:
938      *
939      * - If `to` refers to a smart contract, it must implement
940      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeMint(
946         address to,
947         uint256 quantity,
948         bytes memory _data
949     ) internal {
950         uint256 startTokenId = _currentIndex;
951         if (to == address(0)) revert MintToZeroAddress();
952         if (quantity == 0) revert MintZeroQuantity();
953 
954         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
955 
956         // Overflows are incredibly unrealistic.
957         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
958         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
959         unchecked {
960             // Updates:
961             // - `balance += quantity`.
962             // - `numberMinted += quantity`.
963             //
964             // We can directly add to the balance and number minted.
965             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
966 
967             // Updates:
968             // - `address` to the owner.
969             // - `startTimestamp` to the timestamp of minting.
970             // - `burned` to `false`.
971             // - `nextInitialized` to `quantity == 1`.
972             _packedOwnerships[startTokenId] =
973                 _addressToUint256(to) |
974                 (block.timestamp << BITPOS_START_TIMESTAMP) |
975                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
976 
977             uint256 updatedIndex = startTokenId;
978             uint256 end = updatedIndex + quantity;
979 
980             if (to.code.length != 0) {
981                 do {
982                     emit Transfer(address(0), to, updatedIndex);
983                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
984                         revert TransferToNonERC721ReceiverImplementer();
985                     }
986                 } while (updatedIndex < end);
987                 // Reentrancy protection
988                 if (_currentIndex != startTokenId) revert();
989             } else {
990                 do {
991                     emit Transfer(address(0), to, updatedIndex++);
992                 } while (updatedIndex < end);
993             }
994             _currentIndex = updatedIndex;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _mint(address to, uint256 quantity) internal {
1010         uint256 startTokenId = _currentIndex;
1011         if (to == address(0)) revert MintToZeroAddress();
1012         if (quantity == 0) revert MintZeroQuantity();
1013 
1014         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1015 
1016         // Overflows are incredibly unrealistic.
1017         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1018         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1019         unchecked {
1020             // Updates:
1021             // - `balance += quantity`.
1022             // - `numberMinted += quantity`.
1023             //
1024             // We can directly add to the balance and number minted.
1025             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1026 
1027             // Updates:
1028             // - `address` to the owner.
1029             // - `startTimestamp` to the timestamp of minting.
1030             // - `burned` to `false`.
1031             // - `nextInitialized` to `quantity == 1`.
1032             _packedOwnerships[startTokenId] =
1033                 _addressToUint256(to) |
1034                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1035                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1036 
1037             uint256 updatedIndex = startTokenId;
1038             uint256 end = updatedIndex + quantity;
1039 
1040             do {
1041                 emit Transfer(address(0), to, updatedIndex++);
1042             } while (updatedIndex < end);
1043 
1044             _currentIndex = updatedIndex;
1045         }
1046         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1047     }
1048 
1049     /**
1050      * @dev Transfers `tokenId` from `from` to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) private {
1064         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1065 
1066         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1067 
1068         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1069             isApprovedForAll(from, _msgSenderERC721A()) ||
1070             getApproved(tokenId) == _msgSenderERC721A());
1071 
1072         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1073         if (to == address(0)) revert TransferToZeroAddress();
1074 
1075         _beforeTokenTransfers(from, to, tokenId, 1);
1076 
1077         // Clear approvals from the previous owner.
1078         delete _tokenApprovals[tokenId];
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1083         unchecked {
1084             // We can directly increment and decrement the balances.
1085             --_packedAddressData[from]; // Updates: `balance -= 1`.
1086             ++_packedAddressData[to]; // Updates: `balance += 1`.
1087 
1088             // Updates:
1089             // - `address` to the next owner.
1090             // - `startTimestamp` to the timestamp of transfering.
1091             // - `burned` to `false`.
1092             // - `nextInitialized` to `true`.
1093             _packedOwnerships[tokenId] =
1094                 _addressToUint256(to) |
1095                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1096                 BITMASK_NEXT_INITIALIZED;
1097 
1098             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1099             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1100                 uint256 nextTokenId = tokenId + 1;
1101                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1102                 if (_packedOwnerships[nextTokenId] == 0) {
1103                     // If the next slot is within bounds.
1104                     if (nextTokenId != _currentIndex) {
1105                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1106                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1107                     }
1108                 }
1109             }
1110         }
1111 
1112         emit Transfer(from, to, tokenId);
1113         _afterTokenTransfers(from, to, tokenId, 1);
1114     }
1115 
1116     /**
1117      * @dev Equivalent to `_burn(tokenId, false)`.
1118      */
1119     function _burn(uint256 tokenId) internal virtual {
1120         _burn(tokenId, false);
1121     }
1122 
1123     /**
1124      * @dev Destroys `tokenId`.
1125      * The approval is cleared when the token is burned.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must exist.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1134         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1135 
1136         address from = address(uint160(prevOwnershipPacked));
1137 
1138         if (approvalCheck) {
1139             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1140                 isApprovedForAll(from, _msgSenderERC721A()) ||
1141                 getApproved(tokenId) == _msgSenderERC721A());
1142 
1143             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1144         }
1145 
1146         _beforeTokenTransfers(from, address(0), tokenId, 1);
1147 
1148         // Clear approvals from the previous owner.
1149         delete _tokenApprovals[tokenId];
1150 
1151         // Underflow of the sender's balance is impossible because we check for
1152         // ownership above and the recipient's balance can't realistically overflow.
1153         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1154         unchecked {
1155             // Updates:
1156             // - `balance -= 1`.
1157             // - `numberBurned += 1`.
1158             //
1159             // We can directly decrement the balance, and increment the number burned.
1160             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1161             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1162 
1163             // Updates:
1164             // - `address` to the last owner.
1165             // - `startTimestamp` to the timestamp of burning.
1166             // - `burned` to `true`.
1167             // - `nextInitialized` to `true`.
1168             _packedOwnerships[tokenId] =
1169                 _addressToUint256(from) |
1170                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1171                 BITMASK_BURNED | 
1172                 BITMASK_NEXT_INITIALIZED;
1173 
1174             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1175             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1176                 uint256 nextTokenId = tokenId + 1;
1177                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1178                 if (_packedOwnerships[nextTokenId] == 0) {
1179                     // If the next slot is within bounds.
1180                     if (nextTokenId != _currentIndex) {
1181                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1182                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1183                     }
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, address(0), tokenId);
1189         _afterTokenTransfers(from, address(0), tokenId, 1);
1190 
1191         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1192         unchecked {
1193             _burnCounter++;
1194         }
1195     }
1196 
1197     /**
1198      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1199      *
1200      * @param from address representing the previous owner of the given token ID
1201      * @param to target address that will receive the tokens
1202      * @param tokenId uint256 ID of the token to be transferred
1203      * @param _data bytes optional data to send along with the call
1204      * @return bool whether the call correctly returned the expected magic value
1205      */
1206     function _checkContractOnERC721Received(
1207         address from,
1208         address to,
1209         uint256 tokenId,
1210         bytes memory _data
1211     ) private returns (bool) {
1212         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1213             bytes4 retval
1214         ) {
1215             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1216         } catch (bytes memory reason) {
1217             if (reason.length == 0) {
1218                 revert TransferToNonERC721ReceiverImplementer();
1219             } else {
1220                 assembly {
1221                     revert(add(32, reason), mload(reason))
1222                 }
1223             }
1224         }
1225     }
1226 
1227     /**
1228      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1229      * And also called before burning one token.
1230      *
1231      * startTokenId - the first token id to be transferred
1232      * quantity - the amount to be transferred
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` will be minted for `to`.
1239      * - When `to` is zero, `tokenId` will be burned by `from`.
1240      * - `from` and `to` are never both zero.
1241      */
1242     function _beforeTokenTransfers(
1243         address from,
1244         address to,
1245         uint256 startTokenId,
1246         uint256 quantity
1247     ) internal virtual {}
1248 
1249     /**
1250      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1251      * minting.
1252      * And also called after one token has been burned.
1253      *
1254      * startTokenId - the first token id to be transferred
1255      * quantity - the amount to be transferred
1256      *
1257      * Calling conditions:
1258      *
1259      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1260      * transferred to `to`.
1261      * - When `from` is zero, `tokenId` has been minted for `to`.
1262      * - When `to` is zero, `tokenId` has been burned by `from`.
1263      * - `from` and `to` are never both zero.
1264      */
1265     function _afterTokenTransfers(
1266         address from,
1267         address to,
1268         uint256 startTokenId,
1269         uint256 quantity
1270     ) internal virtual {}
1271 
1272     /**
1273      * @dev Returns the message sender (defaults to `msg.sender`).
1274      *
1275      * If you are writing GSN compatible contracts, you need to override this function.
1276      */
1277     function _msgSenderERC721A() internal view virtual returns (address) {
1278         return msg.sender;
1279     }
1280 
1281     /**
1282      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1283      */
1284     function _toString(uint256 value) internal pure returns (string memory ptr) {
1285         assembly {
1286             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1287             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1288             // We will need 1 32-byte word to store the length, 
1289             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1290             ptr := add(mload(0x40), 128)
1291             // Update the free memory pointer to allocate.
1292             mstore(0x40, ptr)
1293 
1294             // Cache the end of the memory to calculate the length later.
1295             let end := ptr
1296 
1297             // We write the string from the rightmost digit to the leftmost digit.
1298             // The following is essentially a do-while loop that also handles the zero case.
1299             // Costs a bit more than early returning for the zero case,
1300             // but cheaper in terms of deployment and overall runtime costs.
1301             for { 
1302                 // Initialize and perform the first pass without check.
1303                 let temp := value
1304                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1305                 ptr := sub(ptr, 1)
1306                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1307                 mstore8(ptr, add(48, mod(temp, 10)))
1308                 temp := div(temp, 10)
1309             } temp { 
1310                 // Keep dividing `temp` until zero.
1311                 temp := div(temp, 10)
1312             } { // Body of the for loop.
1313                 ptr := sub(ptr, 1)
1314                 mstore8(ptr, add(48, mod(temp, 10)))
1315             }
1316             
1317             let length := sub(end, ptr)
1318             // Move the pointer 32 bytes leftwards to make room for the length.
1319             ptr := sub(ptr, 32)
1320             // Store the length.
1321             mstore(ptr, length)
1322         }
1323     }
1324 }
1325 
1326 // File: contracts/projectino.sol
1327 
1328 
1329 
1330 pragma solidity 0.8.14;
1331 
1332 contract ProjectINO is ERC721A, Ownable {
1333   enum SaleConfig {
1334     PAUSED,
1335     INOLIST,
1336     FINAL
1337   }
1338 
1339   using Strings for uint256;
1340   string private baseURI;
1341   string public baseExtension =".json";
1342   string public unRevealedURI;
1343   bool public revealed = false;
1344 
1345   /*///////////////////////////////////////////////////////////////
1346                         SET SALE PAUSED
1347     //////////////////////////////////////////////////////////////*/
1348 
1349   SaleConfig public saleConfig = SaleConfig.PAUSED;
1350 
1351   /*///////////////////////////////////////////////////////////////
1352                         PROJECT INFO
1353     //////////////////////////////////////////////////////////////*/
1354 
1355   uint256 public constant INO_SUPPLY = 7999;
1356   uint256 private constant RESERVED_INO = 280;
1357   uint256 public constant INO_LIMIT = 1;
1358 
1359   /*///////////////////////////////////////////////////////////////
1360                         TRACKING
1361     //////////////////////////////////////////////////////////////*/
1362 
1363   bytes32 public merkleRoot;
1364 
1365   mapping(address => bool) public inoListPurchased;
1366 
1367    address private immutable withdrawalAddress;
1368 
1369   constructor (
1370       address _withdrawalAddress,
1371       string memory _RBaseURI,
1372       string memory _unRevealedUri
1373   ) ERC721A ("Project INO", "INO") {
1374           setBaseURI(_RBaseURI);
1375           setUnRevealedUri(_unRevealedUri);
1376           withdrawalAddress = _withdrawalAddress;
1377           _mint(tx.origin, RESERVED_INO);
1378       }
1379 
1380    /*///////////////////////////////////////////////////////////////
1381                         MerkleRoots & Sale Functions
1382     //////////////////////////////////////////////////////////////*/
1383 
1384   function setSaleConfig(SaleConfig _status) external onlyOwner {
1385       saleConfig = _status;
1386   }
1387 
1388   function setMerkleRoots(bytes32 _merkleRoot) external onlyOwner {
1389     merkleRoot = _merkleRoot;
1390   }
1391 
1392   modifier callerIsUser() {
1393     require(tx.origin == msg.sender, "The caller is another contract");
1394     _;
1395   }
1396 
1397   /*///////////////////////////////////////////////////////////////
1398                         MINT FUNCTIONS
1399     //////////////////////////////////////////////////////////////*/
1400 
1401   function inoListMint(uint256 _amount, bytes32[] memory _proof) external payable callerIsUser {
1402       require(
1403           saleConfig == SaleConfig.INOLIST,
1404            "DEAR SPECIAL ONE, ARRIVAL ON PLANET IS NOT ALLOWED. TRY AGAIN SOON.");
1405       require(
1406           MerkleProof.verify(_proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))),
1407           "You are not on the Ino List."
1408           );
1409       require(
1410         _amount <= INO_LIMIT,
1411          "QUANTITY SURPASSES PER-TXN LIMIT");
1412       require(
1413           !inoListPurchased[msg.sender],
1414            "INO LIST HAS BEEN USED, TRY AGAIN ON PUBLIC.");
1415       inoListPurchased[msg.sender] = true;
1416       require(
1417           totalSupply() + _amount <= INO_SUPPLY,
1418            "MAX CAP OF INO EXCEEDED");
1419       _mint(msg.sender, _amount);
1420   }
1421 
1422   function finalMint(uint256 _amount) external payable callerIsUser {
1423       require(
1424           saleConfig == SaleConfig.FINAL,
1425            "ENTRY OF PLANET IS NOT ALLOWED. PLEASE HOLD.");
1426       require(
1427           _amount <= INO_LIMIT,
1428            "QUANTITY SURPASSES PER-TXN LIMIT");
1429       require(
1430           totalSupply() + _amount <= INO_SUPPLY,
1431            "MAX CAP OF INO EXCEEDED");
1432       _mint(msg.sender, _amount);
1433   }
1434   
1435 
1436   /*///////////////////////////////////////////////////////////////
1437                         METADATA URI
1438     //////////////////////////////////////////////////////////////*/
1439     
1440     function _baseURI() internal view virtual override
1441     returns (string memory)
1442   {
1443     return baseURI;
1444   }
1445 
1446 
1447   function reveal() public onlyOwner() {
1448       revealed = true;
1449 	  }
1450 	  
1451 	  function tokenURI(uint256 tokenId)
1452     public
1453     view
1454     virtual
1455     override
1456     returns (string memory)
1457   {
1458     require(
1459       _exists(tokenId),
1460       "ERC721Metadata: URI query for nonexistent token"
1461     );
1462     
1463     if(revealed == false) {
1464         return unRevealedURI;
1465     }
1466 
1467     string memory currentBaseURI = _baseURI();
1468     return bytes(currentBaseURI).length > 0
1469         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1470         : "";
1471   }
1472 
1473 	function setUnRevealedUri(string memory _unRevealedUri) public onlyOwner {
1474     unRevealedURI = _unRevealedUri;
1475   }
1476 
1477     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1478 	baseURI = _newBaseURI;
1479 	}
1480 
1481 
1482   /*///////////////////////////////////////////////////////////////
1483                         TRACKING NUMBER MINTED
1484     //////////////////////////////////////////////////////////////*/
1485 
1486     function numberMinted(address _owner) public view returns (uint256) {
1487     return _numberMinted(_owner);
1488   }
1489 
1490     function getOwnershipData(uint256 _tokenId) external view returns (TokenOwnership memory) {
1491     return _ownershipOf(_tokenId);
1492   }
1493 
1494   /*///////////////////////////////////////////////////////////////
1495                         WITHDRAW FUNDS
1496     //////////////////////////////////////////////////////////////*/
1497     
1498     function withdrawFunds() external onlyOwner {
1499         payable(withdrawalAddress).transfer(address(this).balance);
1500     }
1501 }