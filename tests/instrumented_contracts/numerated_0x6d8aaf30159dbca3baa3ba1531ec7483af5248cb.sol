1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
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
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Counters.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title Counters
183  * @author Matt Condon (@shrugs)
184  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
185  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
186  *
187  * Include with `using Counters for Counters.Counter;`
188  */
189 library Counters {
190     struct Counter {
191         // This variable should never be directly accessed by users of the library: interactions must be restricted to
192         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
193         // this feature: see https://github.com/ethereum/solidity/issues/4637
194         uint256 _value; // default: 0
195     }
196 
197     function current(Counter storage counter) internal view returns (uint256) {
198         return counter._value;
199     }
200 
201     function increment(Counter storage counter) internal {
202         unchecked {
203             counter._value += 1;
204         }
205     }
206 
207     function decrement(Counter storage counter) internal {
208         uint256 value = counter._value;
209         require(value > 0, "Counter: decrement overflow");
210         unchecked {
211             counter._value = value - 1;
212         }
213     }
214 
215     function reset(Counter storage counter) internal {
216         counter._value = 0;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Strings.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
235      */
236     function toString(uint256 value) internal pure returns (string memory) {
237         // Inspired by OraclizeAPI's implementation - MIT licence
238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
239 
240         if (value == 0) {
241             return "0";
242         }
243         uint256 temp = value;
244         uint256 digits;
245         while (temp != 0) {
246             digits++;
247             temp /= 10;
248         }
249         bytes memory buffer = new bytes(digits);
250         while (value != 0) {
251             digits -= 1;
252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
253             value /= 10;
254         }
255         return string(buffer);
256     }
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
260      */
261     function toHexString(uint256 value) internal pure returns (string memory) {
262         if (value == 0) {
263             return "0x00";
264         }
265         uint256 temp = value;
266         uint256 length = 0;
267         while (temp != 0) {
268             length++;
269             temp >>= 8;
270         }
271         return toHexString(value, length);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
276      */
277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
278         bytes memory buffer = new bytes(2 * length + 2);
279         buffer[0] = "0";
280         buffer[1] = "x";
281         for (uint256 i = 2 * length + 1; i > 1; --i) {
282             buffer[i] = _HEX_SYMBOLS[value & 0xf];
283             value >>= 4;
284         }
285         require(value == 0, "Strings: hex length insufficient");
286         return string(buffer);
287     }
288 }
289 
290 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
291 
292 
293 // ERC721A Contracts v4.0.0
294 // Creator: Chiru Labs
295 
296 pragma solidity ^0.8.4;
297 
298 /**
299  * @dev Interface of an ERC721A compliant contract.
300  */
301 interface IERC721A {
302     /**
303      * The caller must own the token or be an approved operator.
304      */
305     error ApprovalCallerNotOwnerNorApproved();
306 
307     /**
308      * The token does not exist.
309      */
310     error ApprovalQueryForNonexistentToken();
311 
312     /**
313      * The caller cannot approve to their own address.
314      */
315     error ApproveToCaller();
316 
317     /**
318      * The caller cannot approve to the current owner.
319      */
320     error ApprovalToCurrentOwner();
321 
322     /**
323      * Cannot query the balance for the zero address.
324      */
325     error BalanceQueryForZeroAddress();
326 
327     /**
328      * Cannot mint to the zero address.
329      */
330     error MintToZeroAddress();
331 
332     /**
333      * The quantity of tokens minted must be more than zero.
334      */
335     error MintZeroQuantity();
336 
337     /**
338      * The token does not exist.
339      */
340     error OwnerQueryForNonexistentToken();
341 
342     /**
343      * The caller must own the token or be an approved operator.
344      */
345     error TransferCallerNotOwnerNorApproved();
346 
347     /**
348      * The token must be owned by `from`.
349      */
350     error TransferFromIncorrectOwner();
351 
352     /**
353      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
354      */
355     error TransferToNonERC721ReceiverImplementer();
356 
357     /**
358      * Cannot transfer to the zero address.
359      */
360     error TransferToZeroAddress();
361 
362     /**
363      * The token does not exist.
364      */
365     error URIQueryForNonexistentToken();
366 
367     struct TokenOwnership {
368         // The address of the owner.
369         address addr;
370         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
371         uint64 startTimestamp;
372         // Whether the token has been burned.
373         bool burned;
374     }
375 
376     /**
377      * @dev Returns the total amount of tokens stored by the contract.
378      *
379      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     // ==============================
384     //            IERC165
385     // ==============================
386 
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30 000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 
397     // ==============================
398     //            IERC721
399     // ==============================
400 
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Transfers `tokenId` token from `from` to `to`.
472      *
473      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
495      *
496      * Requirements:
497      *
498      * - The caller must own the token or be an approved operator.
499      * - `tokenId` must exist.
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address to, uint256 tokenId) external;
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
528      *
529      * See {setApprovalForAll}
530      */
531     function isApprovedForAll(address owner, address operator) external view returns (bool);
532 
533     // ==============================
534     //        IERC721Metadata
535     // ==============================
536 
537     /**
538      * @dev Returns the token collection name.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the token collection symbol.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
549      */
550     function tokenURI(uint256 tokenId) external view returns (string memory);
551 }
552 
553 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
554 
555 
556 // ERC721A Contracts v4.0.0
557 // Creator: Chiru Labs
558 
559 pragma solidity ^0.8.4;
560 
561 
562 /**
563  * @dev ERC721 token receiver interface.
564  */
565 interface ERC721A__IERC721Receiver {
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 /**
575  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
576  * the Metadata extension. Built to optimize for lower gas during batch mints.
577  *
578  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
579  *
580  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
581  *
582  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
583  */
584 contract ERC721A is IERC721A {
585     // Mask of an entry in packed address data.
586     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
587 
588     // The bit position of `numberMinted` in packed address data.
589     uint256 private constant BITPOS_NUMBER_MINTED = 64;
590 
591     // The bit position of `numberBurned` in packed address data.
592     uint256 private constant BITPOS_NUMBER_BURNED = 128;
593 
594     // The bit position of `aux` in packed address data.
595     uint256 private constant BITPOS_AUX = 192;
596 
597     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
598     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
599 
600     // The bit position of `startTimestamp` in packed ownership.
601     uint256 private constant BITPOS_START_TIMESTAMP = 160;
602 
603     // The bit mask of the `burned` bit in packed ownership.
604     uint256 private constant BITMASK_BURNED = 1 << 224;
605 
606     // The bit position of the `nextInitialized` bit in packed ownership.
607     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
608 
609     // The bit mask of the `nextInitialized` bit in packed ownership.
610     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
611 
612     // The tokenId of the next token to be minted.
613     uint256 private _currentIndex;
614 
615     // The number of tokens burned.
616     uint256 private _burnCounter;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to ownership details
625     // An empty struct value does not necessarily mean the token is unowned.
626     // See `_packedOwnershipOf` implementation for details.
627     //
628     // Bits Layout:
629     // - [0..159]   `addr`
630     // - [160..223] `startTimestamp`
631     // - [224]      `burned`
632     // - [225]      `nextInitialized`
633     mapping(uint256 => uint256) private _packedOwnerships;
634 
635     // Mapping owner address to address data.
636     //
637     // Bits Layout:
638     // - [0..63]    `balance`
639     // - [64..127]  `numberMinted`
640     // - [128..191] `numberBurned`
641     // - [192..255] `aux`
642     mapping(address => uint256) private _packedAddressData;
643 
644     // Mapping from token ID to approved address.
645     mapping(uint256 => address) private _tokenApprovals;
646 
647     // Mapping from owner to operator approvals
648     mapping(address => mapping(address => bool)) private _operatorApprovals;
649 
650     constructor(string memory name_, string memory symbol_) {
651         _name = name_;
652         _symbol = symbol_;
653         _currentIndex = _startTokenId();
654     }
655 
656     /**
657      * @dev Returns the starting token ID.
658      * To change the starting token ID, please override this function.
659      */
660     function _startTokenId() internal view virtual returns (uint256) {
661         return 0;
662     }
663 
664     /**
665      * @dev Returns the next token ID to be minted.
666      */
667     function _nextTokenId() internal view returns (uint256) {
668         return _currentIndex;
669     }
670 
671     /**
672      * @dev Returns the total number of tokens in existence.
673      * Burned tokens will reduce the count.
674      * To get the total number of tokens minted, please see `_totalMinted`.
675      */
676     function totalSupply() public view override returns (uint256) {
677         // Counter underflow is impossible as _burnCounter cannot be incremented
678         // more than `_currentIndex - _startTokenId()` times.
679         unchecked {
680             return _currentIndex - _burnCounter - _startTokenId();
681         }
682     }
683 
684     /**
685      * @dev Returns the total amount of tokens minted in the contract.
686      */
687     function _totalMinted() internal view returns (uint256) {
688         // Counter underflow is impossible as _currentIndex does not decrement,
689         // and it is initialized to `_startTokenId()`
690         unchecked {
691             return _currentIndex - _startTokenId();
692         }
693     }
694 
695     /**
696      * @dev Returns the total number of tokens burned.
697      */
698     function _totalBurned() internal view returns (uint256) {
699         return _burnCounter;
700     }
701 
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706         // The interface IDs are constants representing the first 4 bytes of the XOR of
707         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
708         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
709         return
710             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
711             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
712             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
713     }
714 
715     /**
716      * @dev See {IERC721-balanceOf}.
717      */
718     function balanceOf(address owner) public view override returns (uint256) {
719         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
720         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
721     }
722 
723     /**
724      * Returns the number of tokens minted by `owner`.
725      */
726     function _numberMinted(address owner) internal view returns (uint256) {
727         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
728     }
729 
730     /**
731      * Returns the number of tokens burned by or on behalf of `owner`.
732      */
733     function _numberBurned(address owner) internal view returns (uint256) {
734         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
735     }
736 
737     /**
738      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
739      */
740     function _getAux(address owner) internal view returns (uint64) {
741         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
742     }
743 
744     /**
745      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
746      * If there are multiple variables, please pack them into a uint64.
747      */
748     function _setAux(address owner, uint64 aux) internal {
749         uint256 packed = _packedAddressData[owner];
750         uint256 auxCasted;
751         assembly { // Cast aux without masking.
752             auxCasted := aux
753         }
754         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
755         _packedAddressData[owner] = packed;
756     }
757 
758     /**
759      * Returns the packed ownership data of `tokenId`.
760      */
761     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
762         uint256 curr = tokenId;
763 
764         unchecked {
765             if (_startTokenId() <= curr)
766                 if (curr < _currentIndex) {
767                     uint256 packed = _packedOwnerships[curr];
768                     // If not burned.
769                     if (packed & BITMASK_BURNED == 0) {
770                         // Invariant:
771                         // There will always be an ownership that has an address and is not burned
772                         // before an ownership that does not have an address and is not burned.
773                         // Hence, curr will not underflow.
774                         //
775                         // We can directly compare the packed value.
776                         // If the address is zero, packed is zero.
777                         while (packed == 0) {
778                             packed = _packedOwnerships[--curr];
779                         }
780                         return packed;
781                     }
782                 }
783         }
784         revert OwnerQueryForNonexistentToken();
785     }
786 
787     /**
788      * Returns the unpacked `TokenOwnership` struct from `packed`.
789      */
790     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
791         ownership.addr = address(uint160(packed));
792         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
793         ownership.burned = packed & BITMASK_BURNED != 0;
794     }
795 
796     /**
797      * Returns the unpacked `TokenOwnership` struct at `index`.
798      */
799     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
800         return _unpackedOwnership(_packedOwnerships[index]);
801     }
802 
803     /**
804      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
805      */
806     function _initializeOwnershipAt(uint256 index) internal {
807         if (_packedOwnerships[index] == 0) {
808             _packedOwnerships[index] = _packedOwnershipOf(index);
809         }
810     }
811 
812     /**
813      * Gas spent here starts off proportional to the maximum mint batch size.
814      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
815      */
816     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
817         return _unpackedOwnership(_packedOwnershipOf(tokenId));
818     }
819 
820     /**
821      * @dev See {IERC721-ownerOf}.
822      */
823     function ownerOf(uint256 tokenId) public view override returns (address) {
824         return address(uint160(_packedOwnershipOf(tokenId)));
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-name}.
829      */
830     function name() public view virtual override returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-symbol}.
836      */
837     function symbol() public view virtual override returns (string memory) {
838         return _symbol;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-tokenURI}.
843      */
844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
845         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
846 
847         string memory baseURI = _baseURI();
848         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return '';
858     }
859 
860     /**
861      * @dev Casts the address to uint256 without masking.
862      */
863     function _addressToUint256(address value) private pure returns (uint256 result) {
864         assembly {
865             result := value
866         }
867     }
868 
869     /**
870      * @dev Casts the boolean to uint256 without branching.
871      */
872     function _boolToUint256(bool value) private pure returns (uint256 result) {
873         assembly {
874             result := value
875         }
876     }
877 
878     /**
879      * @dev See {IERC721-approve}.
880      */
881     function approve(address to, uint256 tokenId) public override {
882         address owner = address(uint160(_packedOwnershipOf(tokenId)));
883         if (to == owner) revert ApprovalToCurrentOwner();
884 
885         if (_msgSenderERC721A() != owner)
886             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
887                 revert ApprovalCallerNotOwnerNorApproved();
888             }
889 
890         _tokenApprovals[tokenId] = to;
891         emit Approval(owner, to, tokenId);
892     }
893 
894     /**
895      * @dev See {IERC721-getApproved}.
896      */
897     function getApproved(uint256 tokenId) public view override returns (address) {
898         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
899 
900         return _tokenApprovals[tokenId];
901     }
902 
903     /**
904      * @dev See {IERC721-setApprovalForAll}.
905      */
906     function setApprovalForAll(address operator, bool approved) public virtual override {
907         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
908 
909         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
910         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC721-isApprovedForAll}.
915      */
916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         _transfer(from, to, tokenId);
929     }
930 
931     /**
932      * @dev See {IERC721-safeTransferFrom}.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId
938     ) public virtual override {
939         safeTransferFrom(from, to, tokenId, '');
940     }
941 
942     /**
943      * @dev See {IERC721-safeTransferFrom}.
944      */
945     function safeTransferFrom(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) public virtual override {
951         _transfer(from, to, tokenId);
952         if (to.code.length != 0)
953             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
954                 revert TransferToNonERC721ReceiverImplementer();
955             }
956     }
957 
958     /**
959      * @dev Returns whether `tokenId` exists.
960      *
961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
962      *
963      * Tokens start existing when they are minted (`_mint`),
964      */
965     function _exists(uint256 tokenId) internal view returns (bool) {
966         return
967             _startTokenId() <= tokenId &&
968             tokenId < _currentIndex && // If within bounds,
969             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
970     }
971 
972     /**
973      * @dev Equivalent to `_safeMint(to, quantity, '')`.
974      */
975     function _safeMint(address to, uint256 quantity) internal {
976         _safeMint(to, quantity, '');
977     }
978 
979     /**
980      * @dev Safely mints `quantity` tokens and transfers them to `to`.
981      *
982      * Requirements:
983      *
984      * - If `to` refers to a smart contract, it must implement
985      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
986      * - `quantity` must be greater than 0.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(
991         address to,
992         uint256 quantity,
993         bytes memory _data
994     ) internal {
995         uint256 startTokenId = _currentIndex;
996         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
997         if (quantity == 0) revert MintZeroQuantity();
998 
999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1000 
1001         // Overflows are incredibly unrealistic.
1002         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1003         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1004         unchecked {
1005             // Updates:
1006             // - `balance += quantity`.
1007             // - `numberMinted += quantity`.
1008             //
1009             // We can directly add to the balance and number minted.
1010             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1011 
1012             // Updates:
1013             // - `address` to the owner.
1014             // - `startTimestamp` to the timestamp of minting.
1015             // - `burned` to `false`.
1016             // - `nextInitialized` to `quantity == 1`.
1017             _packedOwnerships[startTokenId] =
1018                 _addressToUint256(to) |
1019                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1020                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1021 
1022             uint256 updatedIndex = startTokenId;
1023             uint256 end = updatedIndex + quantity;
1024 
1025             if (to.code.length != 0) {
1026                 do {
1027                     emit Transfer(address(0), to, updatedIndex);
1028                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1029                         revert TransferToNonERC721ReceiverImplementer();
1030                     }
1031                 } while (updatedIndex < end);
1032                 // Reentrancy protection
1033                 if (_currentIndex != startTokenId) revert();
1034             } else {
1035                 do {
1036                     emit Transfer(address(0), to, updatedIndex++);
1037                 } while (updatedIndex < end);
1038             }
1039             _currentIndex = updatedIndex;
1040         }
1041         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1042     }
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function _mint(address to, uint256 quantity) internal {
1055         uint256 startTokenId = _currentIndex;
1056         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1057         if (quantity == 0) revert MintZeroQuantity();
1058 
1059         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1060 
1061         // Overflows are incredibly unrealistic.
1062         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1063         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1064         unchecked {
1065             // Updates:
1066             // - `balance += quantity`.
1067             // - `numberMinted += quantity`.
1068             //
1069             // We can directly add to the balance and number minted.
1070             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1071 
1072             // Updates:
1073             // - `address` to the owner.
1074             // - `startTimestamp` to the timestamp of minting.
1075             // - `burned` to `false`.
1076             // - `nextInitialized` to `quantity == 1`.
1077             _packedOwnerships[startTokenId] =
1078                 _addressToUint256(to) |
1079                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1080                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1081 
1082             uint256 updatedIndex = startTokenId;
1083             uint256 end = updatedIndex + quantity;
1084 
1085             do {
1086                 emit Transfer(address(0), to, updatedIndex++);
1087             } while (updatedIndex < end);
1088 
1089             _currentIndex = updatedIndex;
1090         }
1091         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092     }
1093 
1094     /**
1095      * @dev Transfers `tokenId` from `from` to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `tokenId` token must be owned by `from`.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _transfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) private {
1109         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1110 
1111         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1112 
1113         address approvedAddress = _tokenApprovals[tokenId];
1114 
1115         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1116             isApprovedForAll(from, _msgSenderERC721A()) ||
1117             approvedAddress == _msgSenderERC721A());
1118 
1119         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1120         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1121 
1122         _beforeTokenTransfers(from, to, tokenId, 1);
1123 
1124         // Clear approvals from the previous owner.
1125         if (_addressToUint256(approvedAddress) != 0) {
1126             delete _tokenApprovals[tokenId];
1127         }
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1132         unchecked {
1133             // We can directly increment and decrement the balances.
1134             --_packedAddressData[from]; // Updates: `balance -= 1`.
1135             ++_packedAddressData[to]; // Updates: `balance += 1`.
1136 
1137             // Updates:
1138             // - `address` to the next owner.
1139             // - `startTimestamp` to the timestamp of transfering.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `true`.
1142             _packedOwnerships[tokenId] =
1143                 _addressToUint256(to) |
1144                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1145                 BITMASK_NEXT_INITIALIZED;
1146 
1147             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1148             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1149                 uint256 nextTokenId = tokenId + 1;
1150                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1151                 if (_packedOwnerships[nextTokenId] == 0) {
1152                     // If the next slot is within bounds.
1153                     if (nextTokenId != _currentIndex) {
1154                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1155                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1156                     }
1157                 }
1158             }
1159         }
1160 
1161         emit Transfer(from, to, tokenId);
1162         _afterTokenTransfers(from, to, tokenId, 1);
1163     }
1164 
1165     /**
1166      * @dev Equivalent to `_burn(tokenId, false)`.
1167      */
1168     function _burn(uint256 tokenId) internal virtual {
1169         _burn(tokenId, false);
1170     }
1171 
1172     /**
1173      * @dev Destroys `tokenId`.
1174      * The approval is cleared when the token is burned.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1183         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1184 
1185         address from = address(uint160(prevOwnershipPacked));
1186         address approvedAddress = _tokenApprovals[tokenId];
1187 
1188         if (approvalCheck) {
1189             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1190                 isApprovedForAll(from, _msgSenderERC721A()) ||
1191                 approvedAddress == _msgSenderERC721A());
1192 
1193             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1194         }
1195 
1196         _beforeTokenTransfers(from, address(0), tokenId, 1);
1197 
1198         // Clear approvals from the previous owner.
1199         if (_addressToUint256(approvedAddress) != 0) {
1200             delete _tokenApprovals[tokenId];
1201         }
1202 
1203         // Underflow of the sender's balance is impossible because we check for
1204         // ownership above and the recipient's balance can't realistically overflow.
1205         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1206         unchecked {
1207             // Updates:
1208             // - `balance -= 1`.
1209             // - `numberBurned += 1`.
1210             //
1211             // We can directly decrement the balance, and increment the number burned.
1212             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1213             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1214 
1215             // Updates:
1216             // - `address` to the last owner.
1217             // - `startTimestamp` to the timestamp of burning.
1218             // - `burned` to `true`.
1219             // - `nextInitialized` to `true`.
1220             _packedOwnerships[tokenId] =
1221                 _addressToUint256(from) |
1222                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1223                 BITMASK_BURNED |
1224                 BITMASK_NEXT_INITIALIZED;
1225 
1226             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1227             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1228                 uint256 nextTokenId = tokenId + 1;
1229                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1230                 if (_packedOwnerships[nextTokenId] == 0) {
1231                     // If the next slot is within bounds.
1232                     if (nextTokenId != _currentIndex) {
1233                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1234                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1235                     }
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, address(0), tokenId);
1241         _afterTokenTransfers(from, address(0), tokenId, 1);
1242 
1243         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1244         unchecked {
1245             _burnCounter++;
1246         }
1247     }
1248 
1249     /**
1250      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1251      *
1252      * @param from address representing the previous owner of the given token ID
1253      * @param to target address that will receive the tokens
1254      * @param tokenId uint256 ID of the token to be transferred
1255      * @param _data bytes optional data to send along with the call
1256      * @return bool whether the call correctly returned the expected magic value
1257      */
1258     function _checkContractOnERC721Received(
1259         address from,
1260         address to,
1261         uint256 tokenId,
1262         bytes memory _data
1263     ) private returns (bool) {
1264         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1265             bytes4 retval
1266         ) {
1267             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1268         } catch (bytes memory reason) {
1269             if (reason.length == 0) {
1270                 revert TransferToNonERC721ReceiverImplementer();
1271             } else {
1272                 assembly {
1273                     revert(add(32, reason), mload(reason))
1274                 }
1275             }
1276         }
1277     }
1278 
1279     /**
1280      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1281      * And also called before burning one token.
1282      *
1283      * startTokenId - the first token id to be transferred
1284      * quantity - the amount to be transferred
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, `tokenId` will be burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _beforeTokenTransfers(
1295         address from,
1296         address to,
1297         uint256 startTokenId,
1298         uint256 quantity
1299     ) internal virtual {}
1300 
1301     /**
1302      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1303      * minting.
1304      * And also called after one token has been burned.
1305      *
1306      * startTokenId - the first token id to be transferred
1307      * quantity - the amount to be transferred
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` has been minted for `to`.
1314      * - When `to` is zero, `tokenId` has been burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _afterTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 
1324     /**
1325      * @dev Returns the message sender (defaults to `msg.sender`).
1326      *
1327      * If you are writing GSN compatible contracts, you need to override this function.
1328      */
1329     function _msgSenderERC721A() internal view virtual returns (address) {
1330         return msg.sender;
1331     }
1332 
1333     /**
1334      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1335      */
1336     function _toString(uint256 value) internal pure returns (string memory ptr) {
1337         assembly {
1338             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1339             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1340             // We will need 1 32-byte word to store the length,
1341             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1342             ptr := add(mload(0x40), 128)
1343             // Update the free memory pointer to allocate.
1344             mstore(0x40, ptr)
1345 
1346             // Cache the end of the memory to calculate the length later.
1347             let end := ptr
1348 
1349             // We write the string from the rightmost digit to the leftmost digit.
1350             // The following is essentially a do-while loop that also handles the zero case.
1351             // Costs a bit more than early returning for the zero case,
1352             // but cheaper in terms of deployment and overall runtime costs.
1353             for {
1354                 // Initialize and perform the first pass without check.
1355                 let temp := value
1356                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1357                 ptr := sub(ptr, 1)
1358                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1359                 mstore8(ptr, add(48, mod(temp, 10)))
1360                 temp := div(temp, 10)
1361             } temp {
1362                 // Keep dividing `temp` until zero.
1363                 temp := div(temp, 10)
1364             } { // Body of the for loop.
1365                 ptr := sub(ptr, 1)
1366                 mstore8(ptr, add(48, mod(temp, 10)))
1367             }
1368 
1369             let length := sub(end, ptr)
1370             // Move the pointer 32 bytes leftwards to make room for the length.
1371             ptr := sub(ptr, 32)
1372             // Store the length.
1373             mstore(ptr, length)
1374         }
1375     }
1376 }
1377 
1378 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1379 
1380 
1381 // ERC721A Contracts v4.0.0
1382 // Creator: Chiru Labs
1383 
1384 pragma solidity ^0.8.4;
1385 
1386 
1387 /**
1388  * @dev Interface of an ERC721AQueryable compliant contract.
1389  */
1390 interface IERC721AQueryable is IERC721A {
1391     /**
1392      * Invalid query range (`start` >= `stop`).
1393      */
1394     error InvalidQueryRange();
1395 
1396     /**
1397      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1398      *
1399      * If the `tokenId` is out of bounds:
1400      *   - `addr` = `address(0)`
1401      *   - `startTimestamp` = `0`
1402      *   - `burned` = `false`
1403      *
1404      * If the `tokenId` is burned:
1405      *   - `addr` = `<Address of owner before token was burned>`
1406      *   - `startTimestamp` = `<Timestamp when token was burned>`
1407      *   - `burned = `true`
1408      *
1409      * Otherwise:
1410      *   - `addr` = `<Address of owner>`
1411      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1412      *   - `burned = `false`
1413      */
1414     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1415 
1416     /**
1417      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1418      * See {ERC721AQueryable-explicitOwnershipOf}
1419      */
1420     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1421 
1422     /**
1423      * @dev Returns an array of token IDs owned by `owner`,
1424      * in the range [`start`, `stop`)
1425      * (i.e. `start <= tokenId < stop`).
1426      *
1427      * This function allows for tokens to be queried if the collection
1428      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1429      *
1430      * Requirements:
1431      *
1432      * - `start` < `stop`
1433      */
1434     function tokensOfOwnerIn(
1435         address owner,
1436         uint256 start,
1437         uint256 stop
1438     ) external view returns (uint256[] memory);
1439 
1440     /**
1441      * @dev Returns an array of token IDs owned by `owner`.
1442      *
1443      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1444      * It is meant to be called off-chain.
1445      *
1446      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1447      * multiple smaller scans if the collection is large enough to cause
1448      * an out-of-gas error (10K pfp collections should be fine).
1449      */
1450     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1451 }
1452 
1453 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1454 
1455 
1456 // ERC721A Contracts v4.0.0
1457 // Creator: Chiru Labs
1458 
1459 pragma solidity ^0.8.4;
1460 
1461 
1462 
1463 /**
1464  * @title ERC721A Queryable
1465  * @dev ERC721A subclass with convenience query functions.
1466  */
1467 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1468     /**
1469      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1470      *
1471      * If the `tokenId` is out of bounds:
1472      *   - `addr` = `address(0)`
1473      *   - `startTimestamp` = `0`
1474      *   - `burned` = `false`
1475      *
1476      * If the `tokenId` is burned:
1477      *   - `addr` = `<Address of owner before token was burned>`
1478      *   - `startTimestamp` = `<Timestamp when token was burned>`
1479      *   - `burned = `true`
1480      *
1481      * Otherwise:
1482      *   - `addr` = `<Address of owner>`
1483      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1484      *   - `burned = `false`
1485      */
1486     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1487         TokenOwnership memory ownership;
1488         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1489             return ownership;
1490         }
1491         ownership = _ownershipAt(tokenId);
1492         if (ownership.burned) {
1493             return ownership;
1494         }
1495         return _ownershipOf(tokenId);
1496     }
1497 
1498     /**
1499      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1500      * See {ERC721AQueryable-explicitOwnershipOf}
1501      */
1502     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1503         unchecked {
1504             uint256 tokenIdsLength = tokenIds.length;
1505             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1506             for (uint256 i; i != tokenIdsLength; ++i) {
1507                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1508             }
1509             return ownerships;
1510         }
1511     }
1512 
1513     /**
1514      * @dev Returns an array of token IDs owned by `owner`,
1515      * in the range [`start`, `stop`)
1516      * (i.e. `start <= tokenId < stop`).
1517      *
1518      * This function allows for tokens to be queried if the collection
1519      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1520      *
1521      * Requirements:
1522      *
1523      * - `start` < `stop`
1524      */
1525     function tokensOfOwnerIn(
1526         address owner,
1527         uint256 start,
1528         uint256 stop
1529     ) external view override returns (uint256[] memory) {
1530         unchecked {
1531             if (start >= stop) revert InvalidQueryRange();
1532             uint256 tokenIdsIdx;
1533             uint256 stopLimit = _nextTokenId();
1534             // Set `start = max(start, _startTokenId())`.
1535             if (start < _startTokenId()) {
1536                 start = _startTokenId();
1537             }
1538             // Set `stop = min(stop, stopLimit)`.
1539             if (stop > stopLimit) {
1540                 stop = stopLimit;
1541             }
1542             uint256 tokenIdsMaxLength = balanceOf(owner);
1543             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1544             // to cater for cases where `balanceOf(owner)` is too big.
1545             if (start < stop) {
1546                 uint256 rangeLength = stop - start;
1547                 if (rangeLength < tokenIdsMaxLength) {
1548                     tokenIdsMaxLength = rangeLength;
1549                 }
1550             } else {
1551                 tokenIdsMaxLength = 0;
1552             }
1553             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1554             if (tokenIdsMaxLength == 0) {
1555                 return tokenIds;
1556             }
1557             // We need to call `explicitOwnershipOf(start)`,
1558             // because the slot at `start` may not be initialized.
1559             TokenOwnership memory ownership = explicitOwnershipOf(start);
1560             address currOwnershipAddr;
1561             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1562             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1563             if (!ownership.burned) {
1564                 currOwnershipAddr = ownership.addr;
1565             }
1566             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1567                 ownership = _ownershipAt(i);
1568                 if (ownership.burned) {
1569                     continue;
1570                 }
1571                 if (ownership.addr != address(0)) {
1572                     currOwnershipAddr = ownership.addr;
1573                 }
1574                 if (currOwnershipAddr == owner) {
1575                     tokenIds[tokenIdsIdx++] = i;
1576                 }
1577             }
1578             // Downsize the array to fit.
1579             assembly {
1580                 mstore(tokenIds, tokenIdsIdx)
1581             }
1582             return tokenIds;
1583         }
1584     }
1585 
1586     /**
1587      * @dev Returns an array of token IDs owned by `owner`.
1588      *
1589      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1590      * It is meant to be called off-chain.
1591      *
1592      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1593      * multiple smaller scans if the collection is large enough to cause
1594      * an out-of-gas error (10K pfp collections should be fine).
1595      */
1596     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1597         unchecked {
1598             uint256 tokenIdsIdx;
1599             address currOwnershipAddr;
1600             uint256 tokenIdsLength = balanceOf(owner);
1601             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1602             TokenOwnership memory ownership;
1603             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1604                 ownership = _ownershipAt(i);
1605                 if (ownership.burned) {
1606                     continue;
1607                 }
1608                 if (ownership.addr != address(0)) {
1609                     currOwnershipAddr = ownership.addr;
1610                 }
1611                 if (currOwnershipAddr == owner) {
1612                     tokenIds[tokenIdsIdx++] = i;
1613                 }
1614             }
1615             return tokenIds;
1616         }
1617     }
1618 }
1619 
1620 // File: contracts/NFT.sol
1621 
1622 
1623 pragma solidity 0.8.14;
1624 
1625 
1626 
1627 
1628 
1629 
1630 contract SupremeMinter is ERC721AQueryable, Ownable {
1631   using Strings for uint256;
1632   using Counters for Counters.Counter;
1633 
1634   Counters.Counter private supply;
1635 
1636   string public uriPrefix = "METADATA";
1637   string public uriSuffix = ".json";
1638   string public _contractURI = "";
1639   string public hiddenMetadataUri;
1640 
1641   uint256 public baseCost = 0.03 ether;
1642   uint256 public cost = baseCost;
1643 
1644   uint256 public maxSupply = 8889;
1645   uint256 public maxMintAmountPerTx = 11; //10
1646 
1647   bool public paused = true;
1648   bool public revealed = false;
1649   bool public whitelistPhase = true;
1650   
1651   uint256 public walletLimit = 0;
1652 
1653   uint256 public maxWalletLimitWL = 3; //2
1654   uint256 public maxWalletLimitPL = 11; //10
1655 
1656   uint256 public freeMintLimit = 2222; // When do we switch from Free to Paid: 2222
1657 
1658   mapping (address => uint256) public alreadyMinted;
1659 
1660 // MERKEL TREE STUFF
1661   bytes32 public merkleRoot = 0x29d49e683bd7a8fbb6cd36773fb395d3ce290f2725a55ca497ad4378e9d62f3f;
1662   
1663   constructor() ERC721A("Supreme Bones X", "SBX") {
1664     _startTokenId();
1665     setHiddenMetadataUri("https://www.supremebonesx.io/hiddenMeta.json");
1666     setContractURI("https://www.supremesbonesx.io/sbxcontract.json");
1667   }
1668 
1669   function _startTokenId()
1670         internal
1671         pure
1672         override
1673         returns(uint256)
1674     {
1675         return 1;
1676     }
1677 
1678   modifier mintCompliance (uint256 _mintAmount) {
1679 
1680     require(!paused, "Minting is PAUSED!");
1681     require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx, "Invalid mint amount!");
1682     require(msg.sender == tx.origin, "No Bots!");
1683     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
1684     
1685     if (totalSupply() < freeMintLimit) //2222
1686     { walletLimit = maxWalletLimitWL; }
1687     else
1688     { walletLimit = maxWalletLimitPL; }
1689 
1690     if (totalSupply() < freeMintLimit && totalSupply() + _mintAmount > freeMintLimit)
1691     {
1692       uint256 overflow = totalSupply() + _mintAmount - freeMintLimit;
1693       cost = baseCost * overflow;
1694     }
1695     else if (totalSupply() + _mintAmount > freeMintLimit)
1696     {
1697       cost = baseCost * _mintAmount;
1698     }
1699     else if (totalSupply() + _mintAmount <= freeMintLimit)
1700     {
1701       cost = 0;
1702     }
1703 
1704     require(msg.value >= cost, "Insufficient funds!");
1705     require(alreadyMinted[msg.sender] + _mintAmount < walletLimit, "Max Mints Per Wallet Reached!");
1706 
1707     _;
1708   }
1709 
1710   function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner
1711   {
1712     merkleRoot = newMerkleRoot;
1713   }
1714 
1715   function getAlreadyMinted(address a) public view returns (uint256)
1716   {
1717     return alreadyMinted[a];
1718   }
1719 
1720   function getWhitelistState() public view returns (bool)
1721   {
1722     return whitelistPhase;
1723   }
1724 
1725   function getFreeMint() public view returns (uint256)
1726   {
1727     return freeMintLimit;
1728   }
1729 
1730   function getMaxWalletLimitWL() public view returns (uint256)
1731   {
1732     return maxWalletLimitWL;
1733   }
1734 
1735   function getMaxWalletLimitPL() public view returns (uint256)
1736   {
1737     return maxWalletLimitPL;
1738   }
1739 
1740   function getPausedState() public view returns (bool)
1741   {
1742     return paused;
1743   }
1744 
1745   function getTotalSupply() public view returns (uint256)
1746   {
1747     return totalSupply();
1748   }
1749 
1750   function whitelistMint(bytes32[] calldata _merkleProof, uint256 _mintAmount) external mintCompliance(_mintAmount) payable
1751   {
1752     if (whitelistPhase)
1753     {
1754       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1755 
1756       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not on the Whitelist");
1757       require(keccak256(abi.encodePacked(msg.sender)) == leaf, "Naughty Naughty!");
1758 
1759       alreadyMinted[msg.sender] += _mintAmount;
1760       _safeMint(msg.sender, _mintAmount);
1761     }
1762     else if (!whitelistPhase)
1763     {
1764       alreadyMinted[msg.sender] += _mintAmount;
1765       _safeMint(msg.sender, _mintAmount);
1766     }
1767   }
1768 
1769   function publicMint(uint256 _mintAmount) external mintCompliance(_mintAmount) payable
1770   {
1771     require(!whitelistPhase, "Still in Whitelist Sale!");
1772 
1773     alreadyMinted[msg.sender] += _mintAmount;
1774     _safeMint(msg.sender, _mintAmount);
1775   }
1776   
1777   function mintForAddress(uint256 _mintAmount, address _receiver) public payable onlyOwner {
1778     require(totalSupply() + _mintAmount < maxSupply, "Max supply exceeded!");
1779     _safeMint(_receiver, _mintAmount);
1780   }
1781 
1782   function mintForAddressMultiple(address[] calldata addresses, uint256[] calldata amount) public onlyOwner
1783   {
1784     for (uint256 i; i < addresses.length; i++)
1785     {
1786       require(totalSupply() + amount[i] < maxSupply, "Max supply exceeded!");
1787       _safeMint(addresses[i], amount[i]);
1788     }
1789   }
1790 
1791   function walletOfOwner(address _owner)
1792     public
1793     view
1794     returns (uint256[] memory)
1795   {
1796     uint256 ownerTokenCount = balanceOf(_owner);
1797     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1798     uint256 currentTokenId = 1;
1799     uint256 ownedTokenIndex = 0;
1800 
1801     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1802       address currentTokenOwner = ownerOf(currentTokenId);
1803 
1804       if (currentTokenOwner == _owner) {
1805         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1806 
1807         ownedTokenIndex++;
1808       }
1809 
1810       currentTokenId++;
1811     }
1812 
1813     return ownedTokenIds;
1814   }
1815 
1816   function tokenURI(uint256 _tokenId)
1817     public
1818     view
1819     virtual
1820     override (ERC721A, IERC721A)
1821     returns (string memory)
1822   {
1823     require(
1824       _exists(_tokenId),
1825       "ERC721Metadata: URI query for nonexistent token"
1826     );
1827 
1828     if (revealed == false) {
1829       return hiddenMetadataUri;
1830     }
1831 
1832     string memory currentBaseURI = _baseURI();
1833     return bytes(currentBaseURI).length > 0
1834         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId), uriSuffix))
1835         : "";
1836   }
1837 
1838   function contractURI() 
1839   public 
1840   view 
1841   returns (string memory) 
1842   {
1843         return bytes(_contractURI).length > 0
1844           ? string(abi.encodePacked(_contractURI))
1845           : "";
1846   }
1847 
1848   function setRevealed(bool _state) public onlyOwner {
1849     revealed = _state;
1850   }
1851 
1852   function setCost(uint256 _cost) public onlyOwner {
1853     cost = _cost;
1854   }
1855 
1856   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1857     maxMintAmountPerTx = _maxMintAmountPerTx;
1858   }
1859 
1860   function setFreeMintLimit(uint256 _freeMintLimit) public onlyOwner {
1861     freeMintLimit = _freeMintLimit;
1862   }
1863 
1864   function setMaxWalletLimitWL(uint256 _maxWalletLimitWL) public onlyOwner {
1865     maxWalletLimitWL = _maxWalletLimitWL;
1866   }
1867 
1868   function setMaxWalletLimitPL(uint256 _maxWalletLimitPL) public onlyOwner {
1869     maxWalletLimitPL = _maxWalletLimitPL;
1870   }
1871 
1872   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1873     hiddenMetadataUri = _hiddenMetadataUri;
1874   }
1875 
1876   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1877     uriPrefix = _uriPrefix;
1878   }
1879 
1880   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1881     uriSuffix = _uriSuffix;
1882   }
1883 
1884   function setContractURI(string memory newContractURI) public onlyOwner {
1885     _contractURI = newContractURI;
1886   }
1887 
1888   function setPaused(bool _state) public onlyOwner {
1889     paused = _state;
1890   }
1891 
1892   function setWhitelistPhase(bool _state) public onlyOwner {
1893     whitelistPhase = _state;
1894   }
1895 
1896   function withdraw() public onlyOwner {
1897     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1898     require(os);
1899   }
1900 
1901   function _baseURI() internal view virtual override returns (string memory) {
1902     return uriPrefix;
1903   }
1904 
1905 }