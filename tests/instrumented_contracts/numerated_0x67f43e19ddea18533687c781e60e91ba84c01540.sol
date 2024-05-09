1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 /**
5  * @dev These functions deal with verification of Merkle Trees proofs.
6  *
7  * The proofs can be generated using the JavaScript library
8  * https://github.com/miguelmota/merkletreejs[merkletreejs].
9  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
10  *
11  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
12  *
13  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
14  * hashing, or use a hash function other than keccak256 for hashing leaves.
15  * This is because the concatenation of a sorted pair of internal nodes in
16  * the merkle tree could be reinterpreted as a leaf value.
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
34      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
241 
242 
243 // ERC721A Contracts v4.1.0
244 // Creator: Chiru Labs
245 
246 pragma solidity ^0.8.4;
247 
248 /**
249  * @dev Interface of an ERC721A compliant contract.
250  */
251 interface IERC721A {
252     /**
253      * The caller must own the token or be an approved operator.
254      */
255     error ApprovalCallerNotOwnerNorApproved();
256 
257     /**
258      * The token does not exist.
259      */
260     error ApprovalQueryForNonexistentToken();
261 
262     /**
263      * The caller cannot approve to their own address.
264      */
265     error ApproveToCaller();
266 
267     /**
268      * Cannot query the balance for the zero address.
269      */
270     error BalanceQueryForZeroAddress();
271 
272     /**
273      * Cannot mint to the zero address.
274      */
275     error MintToZeroAddress();
276 
277     /**
278      * The quantity of tokens minted must be more than zero.
279      */
280     error MintZeroQuantity();
281 
282     /**
283      * The token does not exist.
284      */
285     error OwnerQueryForNonexistentToken();
286 
287     /**
288      * The caller must own the token or be an approved operator.
289      */
290     error TransferCallerNotOwnerNorApproved();
291 
292     /**
293      * The token must be owned by `from`.
294      */
295     error TransferFromIncorrectOwner();
296 
297     /**
298      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
299      */
300     error TransferToNonERC721ReceiverImplementer();
301 
302     /**
303      * Cannot transfer to the zero address.
304      */
305     error TransferToZeroAddress();
306 
307     /**
308      * The token does not exist.
309      */
310     error URIQueryForNonexistentToken();
311 
312     /**
313      * The `quantity` minted with ERC2309 exceeds the safety limit.
314      */
315     error MintERC2309QuantityExceedsLimit();
316 
317     /**
318      * The `extraData` cannot be set on an unintialized ownership slot.
319      */
320     error OwnershipNotInitializedForExtraData();
321 
322     struct TokenOwnership {
323         // The address of the owner.
324         address addr;
325         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
326         uint64 startTimestamp;
327         // Whether the token has been burned.
328         bool burned;
329         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
330         uint24 extraData;
331     }
332 
333     /**
334      * @dev Returns the total amount of tokens stored by the contract.
335      *
336      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     // ==============================
341     //            IERC165
342     // ==============================
343 
344     /**
345      * @dev Returns true if this contract implements the interface defined by
346      * `interfaceId`. See the corresponding
347      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
348      * to learn more about how these ids are created.
349      *
350      * This function call must use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) external view returns (bool);
353 
354     // ==============================
355     //            IERC721
356     // ==============================
357 
358     /**
359      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
365      */
366     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
370      */
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of tokens in ``owner``'s account.
375      */
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     /**
388      * @dev Safely transfers `tokenId` token from `from` to `to`.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `tokenId` token must exist and be owned by `from`.
395      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
396      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
397      *
398      * Emits a {Transfer} event.
399      */
400     function safeTransferFrom(
401         address from,
402         address to,
403         uint256 tokenId,
404         bytes calldata data
405     ) external;
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
409      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must exist and be owned by `from`.
416      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
418      *
419      * Emits a {Transfer} event.
420      */
421     function safeTransferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Transfers `tokenId` token from `from` to `to`.
429      *
430      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
449      * The approval is cleared when the token is transferred.
450      *
451      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
452      *
453      * Requirements:
454      *
455      * - The caller must own the token or be an approved operator.
456      * - `tokenId` must exist.
457      *
458      * Emits an {Approval} event.
459      */
460     function approve(address to, uint256 tokenId) external;
461 
462     /**
463      * @dev Approve or remove `operator` as an operator for the caller.
464      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
465      *
466      * Requirements:
467      *
468      * - The `operator` cannot be the caller.
469      *
470      * Emits an {ApprovalForAll} event.
471      */
472     function setApprovalForAll(address operator, bool _approved) external;
473 
474     /**
475      * @dev Returns the account approved for `tokenId` token.
476      *
477      * Requirements:
478      *
479      * - `tokenId` must exist.
480      */
481     function getApproved(uint256 tokenId) external view returns (address operator);
482 
483     /**
484      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
485      *
486      * See {setApprovalForAll}
487      */
488     function isApprovedForAll(address owner, address operator) external view returns (bool);
489 
490     // ==============================
491     //        IERC721Metadata
492     // ==============================
493 
494     /**
495      * @dev Returns the token collection name.
496      */
497     function name() external view returns (string memory);
498 
499     /**
500      * @dev Returns the token collection symbol.
501      */
502     function symbol() external view returns (string memory);
503 
504     /**
505      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
506      */
507     function tokenURI(uint256 tokenId) external view returns (string memory);
508 
509     // ==============================
510     //            IERC2309
511     // ==============================
512 
513     /**
514      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
515      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
516      */
517     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
518 }
519 
520 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
521 
522 
523 // ERC721A Contracts v4.1.0
524 // Creator: Chiru Labs
525 
526 pragma solidity ^0.8.4;
527 
528 
529 /**
530  * @dev ERC721 token receiver interface.
531  */
532 interface ERC721A__IERC721Receiver {
533     function onERC721Received(
534         address operator,
535         address from,
536         uint256 tokenId,
537         bytes calldata data
538     ) external returns (bytes4);
539 }
540 
541 /**
542  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
543  * including the Metadata extension. Built to optimize for lower gas during batch mints.
544  *
545  * Assumes serials are sequentially minted starting at `_startTokenId()`
546  * (defaults to 0, e.g. 0, 1, 2, 3..).
547  *
548  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
549  *
550  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
551  */
552 contract ERC721A is IERC721A {
553     // Mask of an entry in packed address data.
554     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
555 
556     // The bit position of `numberMinted` in packed address data.
557     uint256 private constant BITPOS_NUMBER_MINTED = 64;
558 
559     // The bit position of `numberBurned` in packed address data.
560     uint256 private constant BITPOS_NUMBER_BURNED = 128;
561 
562     // The bit position of `aux` in packed address data.
563     uint256 private constant BITPOS_AUX = 192;
564 
565     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
566     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
567 
568     // The bit position of `startTimestamp` in packed ownership.
569     uint256 private constant BITPOS_START_TIMESTAMP = 160;
570 
571     // The bit mask of the `burned` bit in packed ownership.
572     uint256 private constant BITMASK_BURNED = 1 << 224;
573 
574     // The bit position of the `nextInitialized` bit in packed ownership.
575     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
576 
577     // The bit mask of the `nextInitialized` bit in packed ownership.
578     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
579 
580     // The bit position of `extraData` in packed ownership.
581     uint256 private constant BITPOS_EXTRA_DATA = 232;
582 
583     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
584     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
585 
586     // The mask of the lower 160 bits for addresses.
587     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
588 
589     // The maximum `quantity` that can be minted with `_mintERC2309`.
590     // This limit is to prevent overflows on the address data entries.
591     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
592     // is required to cause an overflow, which is unrealistic.
593     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
594 
595     // The tokenId of the next token to be minted.
596     uint256 private _currentIndex;
597 
598     // The number of tokens burned.
599     uint256 private _burnCounter;
600 
601     // Token name
602     string private _name;
603 
604     // Token symbol
605     string private _symbol;
606 
607     // Mapping from token ID to ownership details
608     // An empty struct value does not necessarily mean the token is unowned.
609     // See `_packedOwnershipOf` implementation for details.
610     //
611     // Bits Layout:
612     // - [0..159]   `addr`
613     // - [160..223] `startTimestamp`
614     // - [224]      `burned`
615     // - [225]      `nextInitialized`
616     // - [232..255] `extraData`
617     mapping(uint256 => uint256) private _packedOwnerships;
618 
619     // Mapping owner address to address data.
620     //
621     // Bits Layout:
622     // - [0..63]    `balance`
623     // - [64..127]  `numberMinted`
624     // - [128..191] `numberBurned`
625     // - [192..255] `aux`
626     mapping(address => uint256) private _packedAddressData;
627 
628     // Mapping from token ID to approved address.
629     mapping(uint256 => address) private _tokenApprovals;
630 
631     // Mapping from owner to operator approvals
632     mapping(address => mapping(address => bool)) private _operatorApprovals;
633 
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637         _currentIndex = _startTokenId();
638     }
639 
640     /**
641      * @dev Returns the starting token ID.
642      * To change the starting token ID, please override this function.
643      */
644     function _startTokenId() internal view virtual returns (uint256) {
645         return 0;
646     }
647 
648     /**
649      * @dev Returns the next token ID to be minted.
650      */
651     function _nextTokenId() internal view returns (uint256) {
652         return _currentIndex;
653     }
654 
655     /**
656      * @dev Returns the total number of tokens in existence.
657      * Burned tokens will reduce the count.
658      * To get the total number of tokens minted, please see `_totalMinted`.
659      */
660     function totalSupply() public view override returns (uint256) {
661         // Counter underflow is impossible as _burnCounter cannot be incremented
662         // more than `_currentIndex - _startTokenId()` times.
663         unchecked {
664             return _currentIndex - _burnCounter - _startTokenId();
665         }
666     }
667 
668     /**
669      * @dev Returns the total amount of tokens minted in the contract.
670      */
671     function _totalMinted() internal view returns (uint256) {
672         // Counter underflow is impossible as _currentIndex does not decrement,
673         // and it is initialized to `_startTokenId()`
674         unchecked {
675             return _currentIndex - _startTokenId();
676         }
677     }
678 
679     /**
680      * @dev Returns the total number of tokens burned.
681      */
682     function _totalBurned() internal view returns (uint256) {
683         return _burnCounter;
684     }
685 
686     /**
687      * @dev See {IERC165-supportsInterface}.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         // The interface IDs are constants representing the first 4 bytes of the XOR of
691         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
692         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
693         return
694             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
695             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
696             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
697     }
698 
699     /**
700      * @dev See {IERC721-balanceOf}.
701      */
702     function balanceOf(address owner) public view override returns (uint256) {
703         if (owner == address(0)) revert BalanceQueryForZeroAddress();
704         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
705     }
706 
707     /**
708      * Returns the number of tokens minted by `owner`.
709      */
710     function _numberMinted(address owner) internal view returns (uint256) {
711         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
712     }
713 
714     /**
715      * Returns the number of tokens burned by or on behalf of `owner`.
716      */
717     function _numberBurned(address owner) internal view returns (uint256) {
718         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
719     }
720 
721     /**
722      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
723      */
724     function _getAux(address owner) internal view returns (uint64) {
725         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
726     }
727 
728     /**
729      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
730      * If there are multiple variables, please pack them into a uint64.
731      */
732     function _setAux(address owner, uint64 aux) internal {
733         uint256 packed = _packedAddressData[owner];
734         uint256 auxCasted;
735         // Cast `aux` with assembly to avoid redundant masking.
736         assembly {
737             auxCasted := aux
738         }
739         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
740         _packedAddressData[owner] = packed;
741     }
742 
743     /**
744      * Returns the packed ownership data of `tokenId`.
745      */
746     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
747         uint256 curr = tokenId;
748 
749         unchecked {
750             if (_startTokenId() <= curr)
751                 if (curr < _currentIndex) {
752                     uint256 packed = _packedOwnerships[curr];
753                     // If not burned.
754                     if (packed & BITMASK_BURNED == 0) {
755                         // Invariant:
756                         // There will always be an ownership that has an address and is not burned
757                         // before an ownership that does not have an address and is not burned.
758                         // Hence, curr will not underflow.
759                         //
760                         // We can directly compare the packed value.
761                         // If the address is zero, packed is zero.
762                         while (packed == 0) {
763                             packed = _packedOwnerships[--curr];
764                         }
765                         return packed;
766                     }
767                 }
768         }
769         revert OwnerQueryForNonexistentToken();
770     }
771 
772     /**
773      * Returns the unpacked `TokenOwnership` struct from `packed`.
774      */
775     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
776         ownership.addr = address(uint160(packed));
777         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
778         ownership.burned = packed & BITMASK_BURNED != 0;
779         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
780     }
781 
782     /**
783      * Returns the unpacked `TokenOwnership` struct at `index`.
784      */
785     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
786         return _unpackedOwnership(_packedOwnerships[index]);
787     }
788 
789     /**
790      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
791      */
792     function _initializeOwnershipAt(uint256 index) internal {
793         if (_packedOwnerships[index] == 0) {
794             _packedOwnerships[index] = _packedOwnershipOf(index);
795         }
796     }
797 
798     /**
799      * Gas spent here starts off proportional to the maximum mint batch size.
800      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
801      */
802     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
803         return _unpackedOwnership(_packedOwnershipOf(tokenId));
804     }
805 
806     /**
807      * @dev Packs ownership data into a single uint256.
808      */
809     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
810         assembly {
811             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
812             owner := and(owner, BITMASK_ADDRESS)
813             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
814             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
815         }
816     }
817 
818     /**
819      * @dev See {IERC721-ownerOf}.
820      */
821     function ownerOf(uint256 tokenId) public view override returns (address) {
822         return address(uint160(_packedOwnershipOf(tokenId)));
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-name}.
827      */
828     function name() public view virtual override returns (string memory) {
829         return _name;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-symbol}.
834      */
835     function symbol() public view virtual override returns (string memory) {
836         return _symbol;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-tokenURI}.
841      */
842     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
843         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
844 
845         string memory baseURI = _baseURI();
846         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
847     }
848 
849     /**
850      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
851      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
852      * by default, it can be overridden in child contracts.
853      */
854     function _baseURI() internal view virtual returns (string memory) {
855         return '';
856     }
857 
858     /**
859      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
860      */
861     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
862         // For branchless setting of the `nextInitialized` flag.
863         assembly {
864             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
865             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
866         }
867     }
868 
869     /**
870      * @dev See {IERC721-approve}.
871      */
872     function approve(address to, uint256 tokenId) public override {
873         address owner = ownerOf(tokenId);
874 
875         if (_msgSenderERC721A() != owner)
876             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
877                 revert ApprovalCallerNotOwnerNorApproved();
878             }
879 
880         _tokenApprovals[tokenId] = to;
881         emit Approval(owner, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-getApproved}.
886      */
887     function getApproved(uint256 tokenId) public view override returns (address) {
888         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved) public virtual override {
897         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
898 
899         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
900         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
901     }
902 
903     /**
904      * @dev See {IERC721-isApprovedForAll}.
905      */
906     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
907         return _operatorApprovals[owner][operator];
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public virtual override {
918         safeTransferFrom(from, to, tokenId, '');
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public virtual override {
930         transferFrom(from, to, tokenId);
931         if (to.code.length != 0)
932             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
933                 revert TransferToNonERC721ReceiverImplementer();
934             }
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      */
944     function _exists(uint256 tokenId) internal view returns (bool) {
945         return
946             _startTokenId() <= tokenId &&
947             tokenId < _currentIndex && // If within bounds,
948             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
949     }
950 
951     /**
952      * @dev Equivalent to `_safeMint(to, quantity, '')`.
953      */
954     function _safeMint(address to, uint256 quantity) internal {
955         _safeMint(to, quantity, '');
956     }
957 
958     /**
959      * @dev Safely mints `quantity` tokens and transfers them to `to`.
960      *
961      * Requirements:
962      *
963      * - If `to` refers to a smart contract, it must implement
964      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
965      * - `quantity` must be greater than 0.
966      *
967      * See {_mint}.
968      *
969      * Emits a {Transfer} event for each mint.
970      */
971     function _safeMint(
972         address to,
973         uint256 quantity,
974         bytes memory _data
975     ) internal {
976         _mint(to, quantity);
977 
978         unchecked {
979             if (to.code.length != 0) {
980                 uint256 end = _currentIndex;
981                 uint256 index = end - quantity;
982                 do {
983                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
984                         revert TransferToNonERC721ReceiverImplementer();
985                     }
986                 } while (index < end);
987                 // Reentrancy protection.
988                 if (_currentIndex != end) revert();
989             }
990         }
991     }
992 
993     /**
994      * @dev Mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event for each mint.
1002      */
1003     function _mint(address to, uint256 quantity) internal {
1004         uint256 startTokenId = _currentIndex;
1005         if (to == address(0)) revert MintToZeroAddress();
1006         if (quantity == 0) revert MintZeroQuantity();
1007 
1008         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010         // Overflows are incredibly unrealistic.
1011         // `balance` and `numberMinted` have a maximum limit of 2**64.
1012         // `tokenId` has a maximum limit of 2**256.
1013         unchecked {
1014             // Updates:
1015             // - `balance += quantity`.
1016             // - `numberMinted += quantity`.
1017             //
1018             // We can directly add to the `balance` and `numberMinted`.
1019             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1020 
1021             // Updates:
1022             // - `address` to the owner.
1023             // - `startTimestamp` to the timestamp of minting.
1024             // - `burned` to `false`.
1025             // - `nextInitialized` to `quantity == 1`.
1026             _packedOwnerships[startTokenId] = _packOwnershipData(
1027                 to,
1028                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1029             );
1030 
1031             uint256 tokenId = startTokenId;
1032             uint256 end = startTokenId + quantity;
1033             do {
1034                 emit Transfer(address(0), to, tokenId++);
1035             } while (tokenId < end);
1036 
1037             _currentIndex = end;
1038         }
1039         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1040     }
1041 
1042     /**
1043      * @dev Mints `quantity` tokens and transfers them to `to`.
1044      *
1045      * This function is intended for efficient minting only during contract creation.
1046      *
1047      * It emits only one {ConsecutiveTransfer} as defined in
1048      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1049      * instead of a sequence of {Transfer} event(s).
1050      *
1051      * Calling this function outside of contract creation WILL make your contract
1052      * non-compliant with the ERC721 standard.
1053      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1054      * {ConsecutiveTransfer} event is only permissible during contract creation.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {ConsecutiveTransfer} event.
1062      */
1063     function _mintERC2309(address to, uint256 quantity) internal {
1064         uint256 startTokenId = _currentIndex;
1065         if (to == address(0)) revert MintToZeroAddress();
1066         if (quantity == 0) revert MintZeroQuantity();
1067         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1068 
1069         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1070 
1071         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1072         unchecked {
1073             // Updates:
1074             // - `balance += quantity`.
1075             // - `numberMinted += quantity`.
1076             //
1077             // We can directly add to the `balance` and `numberMinted`.
1078             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1079 
1080             // Updates:
1081             // - `address` to the owner.
1082             // - `startTimestamp` to the timestamp of minting.
1083             // - `burned` to `false`.
1084             // - `nextInitialized` to `quantity == 1`.
1085             _packedOwnerships[startTokenId] = _packOwnershipData(
1086                 to,
1087                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1088             );
1089 
1090             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1091 
1092             _currentIndex = startTokenId + quantity;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1099      */
1100     function _getApprovedAddress(uint256 tokenId)
1101         private
1102         view
1103         returns (uint256 approvedAddressSlot, address approvedAddress)
1104     {
1105         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1106         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1107         assembly {
1108             // Compute the slot.
1109             mstore(0x00, tokenId)
1110             mstore(0x20, tokenApprovalsPtr.slot)
1111             approvedAddressSlot := keccak256(0x00, 0x40)
1112             // Load the slot's value from storage.
1113             approvedAddress := sload(approvedAddressSlot)
1114         }
1115     }
1116 
1117     /**
1118      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1119      */
1120     function _isOwnerOrApproved(
1121         address approvedAddress,
1122         address from,
1123         address msgSender
1124     ) private pure returns (bool result) {
1125         assembly {
1126             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1127             from := and(from, BITMASK_ADDRESS)
1128             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1129             msgSender := and(msgSender, BITMASK_ADDRESS)
1130             // `msgSender == from || msgSender == approvedAddress`.
1131             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1132         }
1133     }
1134 
1135     /**
1136      * @dev Transfers `tokenId` from `from` to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must be owned by `from`.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function transferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) public virtual override {
1150         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1151 
1152         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1153 
1154         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1155 
1156         // The nested ifs save around 20+ gas over a compound boolean condition.
1157         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1158             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1159 
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner.
1165         assembly {
1166             if approvedAddress {
1167                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1168                 sstore(approvedAddressSlot, 0)
1169             }
1170         }
1171 
1172         // Underflow of the sender's balance is impossible because we check for
1173         // ownership above and the recipient's balance can't realistically overflow.
1174         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1175         unchecked {
1176             // We can directly increment and decrement the balances.
1177             --_packedAddressData[from]; // Updates: `balance -= 1`.
1178             ++_packedAddressData[to]; // Updates: `balance += 1`.
1179 
1180             // Updates:
1181             // - `address` to the next owner.
1182             // - `startTimestamp` to the timestamp of transfering.
1183             // - `burned` to `false`.
1184             // - `nextInitialized` to `true`.
1185             _packedOwnerships[tokenId] = _packOwnershipData(
1186                 to,
1187                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1188             );
1189 
1190             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1191             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1192                 uint256 nextTokenId = tokenId + 1;
1193                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1194                 if (_packedOwnerships[nextTokenId] == 0) {
1195                     // If the next slot is within bounds.
1196                     if (nextTokenId != _currentIndex) {
1197                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1198                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1199                     }
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      * @dev Equivalent to `_burn(tokenId, false)`.
1210      */
1211     function _burn(uint256 tokenId) internal virtual {
1212         _burn(tokenId, false);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1226         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1227 
1228         address from = address(uint160(prevOwnershipPacked));
1229 
1230         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1231 
1232         if (approvalCheck) {
1233             // The nested ifs save around 20+ gas over a compound boolean condition.
1234             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1235                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1236         }
1237 
1238         _beforeTokenTransfers(from, address(0), tokenId, 1);
1239 
1240         // Clear approvals from the previous owner.
1241         assembly {
1242             if approvedAddress {
1243                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1244                 sstore(approvedAddressSlot, 0)
1245             }
1246         }
1247 
1248         // Underflow of the sender's balance is impossible because we check for
1249         // ownership above and the recipient's balance can't realistically overflow.
1250         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1251         unchecked {
1252             // Updates:
1253             // - `balance -= 1`.
1254             // - `numberBurned += 1`.
1255             //
1256             // We can directly decrement the balance, and increment the number burned.
1257             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1258             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1259 
1260             // Updates:
1261             // - `address` to the last owner.
1262             // - `startTimestamp` to the timestamp of burning.
1263             // - `burned` to `true`.
1264             // - `nextInitialized` to `true`.
1265             _packedOwnerships[tokenId] = _packOwnershipData(
1266                 from,
1267                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1268             );
1269 
1270             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1271             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1272                 uint256 nextTokenId = tokenId + 1;
1273                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1274                 if (_packedOwnerships[nextTokenId] == 0) {
1275                     // If the next slot is within bounds.
1276                     if (nextTokenId != _currentIndex) {
1277                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1278                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1279                     }
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(from, address(0), tokenId);
1285         _afterTokenTransfers(from, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1295      *
1296      * @param from address representing the previous owner of the given token ID
1297      * @param to target address that will receive the tokens
1298      * @param tokenId uint256 ID of the token to be transferred
1299      * @param _data bytes optional data to send along with the call
1300      * @return bool whether the call correctly returned the expected magic value
1301      */
1302     function _checkContractOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1309             bytes4 retval
1310         ) {
1311             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1312         } catch (bytes memory reason) {
1313             if (reason.length == 0) {
1314                 revert TransferToNonERC721ReceiverImplementer();
1315             } else {
1316                 assembly {
1317                     revert(add(32, reason), mload(reason))
1318                 }
1319             }
1320         }
1321     }
1322 
1323     /**
1324      * @dev Directly sets the extra data for the ownership data `index`.
1325      */
1326     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1327         uint256 packed = _packedOwnerships[index];
1328         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1329         uint256 extraDataCasted;
1330         // Cast `extraData` with assembly to avoid redundant masking.
1331         assembly {
1332             extraDataCasted := extraData
1333         }
1334         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1335         _packedOwnerships[index] = packed;
1336     }
1337 
1338     /**
1339      * @dev Returns the next extra data for the packed ownership data.
1340      * The returned result is shifted into position.
1341      */
1342     function _nextExtraData(
1343         address from,
1344         address to,
1345         uint256 prevOwnershipPacked
1346     ) private view returns (uint256) {
1347         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1348         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1349     }
1350 
1351     /**
1352      * @dev Called during each token transfer to set the 24bit `extraData` field.
1353      * Intended to be overridden by the cosumer contract.
1354      *
1355      * `previousExtraData` - the value of `extraData` before transfer.
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, `tokenId` will be burned by `from`.
1363      * - `from` and `to` are never both zero.
1364      */
1365     function _extraData(
1366         address from,
1367         address to,
1368         uint24 previousExtraData
1369     ) internal view virtual returns (uint24) {}
1370 
1371     /**
1372      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1373      * This includes minting.
1374      * And also called before burning one token.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` will be minted for `to`.
1384      * - When `to` is zero, `tokenId` will be burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _beforeTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 
1394     /**
1395      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1396      * This includes minting.
1397      * And also called after one token has been burned.
1398      *
1399      * startTokenId - the first token id to be transferred
1400      * quantity - the amount to be transferred
1401      *
1402      * Calling conditions:
1403      *
1404      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1405      * transferred to `to`.
1406      * - When `from` is zero, `tokenId` has been minted for `to`.
1407      * - When `to` is zero, `tokenId` has been burned by `from`.
1408      * - `from` and `to` are never both zero.
1409      */
1410     function _afterTokenTransfers(
1411         address from,
1412         address to,
1413         uint256 startTokenId,
1414         uint256 quantity
1415     ) internal virtual {}
1416 
1417     /**
1418      * @dev Returns the message sender (defaults to `msg.sender`).
1419      *
1420      * If you are writing GSN compatible contracts, you need to override this function.
1421      */
1422     function _msgSenderERC721A() internal view virtual returns (address) {
1423         return msg.sender;
1424     }
1425 
1426     /**
1427      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1428      */
1429     function _toString(uint256 value) internal pure returns (string memory ptr) {
1430         assembly {
1431             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1432             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1433             // We will need 1 32-byte word to store the length,
1434             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1435             ptr := add(mload(0x40), 128)
1436             // Update the free memory pointer to allocate.
1437             mstore(0x40, ptr)
1438 
1439             // Cache the end of the memory to calculate the length later.
1440             let end := ptr
1441 
1442             // We write the string from the rightmost digit to the leftmost digit.
1443             // The following is essentially a do-while loop that also handles the zero case.
1444             // Costs a bit more than early returning for the zero case,
1445             // but cheaper in terms of deployment and overall runtime costs.
1446             for {
1447                 // Initialize and perform the first pass without check.
1448                 let temp := value
1449                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1450                 ptr := sub(ptr, 1)
1451                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1452                 mstore8(ptr, add(48, mod(temp, 10)))
1453                 temp := div(temp, 10)
1454             } temp {
1455                 // Keep dividing `temp` until zero.
1456                 temp := div(temp, 10)
1457             } {
1458                 // Body of the for loop.
1459                 ptr := sub(ptr, 1)
1460                 mstore8(ptr, add(48, mod(temp, 10)))
1461             }
1462 
1463             let length := sub(end, ptr)
1464             // Move the pointer 32 bytes leftwards to make room for the length.
1465             ptr := sub(ptr, 32)
1466             // Store the length.
1467             mstore(ptr, length)
1468         }
1469     }
1470 }
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 contract WaverPass is ERC721A, Ownable {
1475 
1476     using Strings for uint256;
1477 
1478     bool public paused = false;
1479 
1480     uint256 public mintPrice = 0.062 ether;
1481     uint256 public preMintPrice = 0.062 ether;
1482 
1483     uint256 public presaleMaxNFTPerWallet = 2;
1484     uint256 public publicSaleMaxNFTPerWallet = 2;
1485 
1486     uint256 constant public supply = 1000;
1487     uint256 constant public teamSupply = 10;
1488 
1489     bool teamMinted;
1490 
1491     bool public isPublicSale;
1492 
1493     string private baseURI = "ipfs://QmYnBXMbRMmS2JxrcbM1zLjD92AcByz8BGTbCsoZAN8fkE/waver.json";
1494 
1495     address public teamWallet = 0x1C12aeA4bc03469ce2D10227F6E6e63099F42424;
1496 
1497     bytes32 public merkleRoot;
1498 
1499     constructor() ERC721A ("WaverPass NFT", "WAVE") {
1500 
1501         merkleRoot = 0x2b8c94049a68db45583a17f4d683fe87516e5fa95a6f1e466ac0eb28bc92ab26;
1502     }
1503 
1504     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1505 
1506         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1507 
1508         return baseURI;
1509     }
1510 
1511     function teamMint() onlyOwner external {
1512 
1513         require(totalSupply() + teamSupply <= supply, "You can't mint more then the total supply");
1514         require(!teamMinted, "Team has already minted");
1515 
1516         teamMinted = true;
1517 
1518         _safeMint(teamWallet, teamSupply);
1519     }
1520 
1521     function preMint(uint256 quantity, bytes32[] memory proof) external payable {
1522 
1523         require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1524         require(!isPublicSale, "You cannot mint after presale");
1525 
1526         if(msg.sender != owner()) {
1527 
1528             require(!paused, "Contract paused");
1529 
1530             require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "You are not on the whitelist for this mint");
1531             require(quantity + balanceOf(msg.sender) <= presaleMaxNFTPerWallet, string(abi.encodePacked("You can only mint ", presaleMaxNFTPerWallet.toString(), " NFTs at Presale")));
1532 
1533             require(msg.value >= preMintPrice * quantity, "Insufficient funds");
1534         }
1535         
1536         _safeMint(msg.sender, quantity);
1537     }
1538 
1539     function mint(uint256 quantity) external payable {
1540 
1541         require(totalSupply() + quantity <= supply, "You can't mint more then the total supply");
1542         require(isPublicSale, "You cannot mint until public sale has started");
1543 
1544         if(msg.sender != owner()) {
1545 
1546             require(!paused, "Contract paused");
1547 
1548             require(quantity + balanceOf(msg.sender) <= publicSaleMaxNFTPerWallet, string(abi.encodePacked("You can only mint ", publicSaleMaxNFTPerWallet.toString(), " NFTs at Public Sale")));
1549             require(msg.value >= mintPrice * quantity, "Insufficient funds");
1550         }
1551         
1552         _safeMint(msg.sender, quantity);
1553     }
1554 
1555     function getBaseURI() public onlyOwner view returns (string memory) { return baseURI; }
1556 
1557     function getMintPrice() public view returns (uint256) {
1558 
1559         if(!isPublicSale) {
1560 
1561             return preMintPrice;
1562         }
1563 
1564         return mintPrice;
1565     }
1566 
1567     function _baseURI() internal view override returns (string memory) { return baseURI; }
1568 
1569     function setBaseURI(string memory baseURI_) external onlyOwner { baseURI = baseURI_; }
1570 
1571     function setMintPrice (uint256 _newPrice) external onlyOwner { mintPrice = _newPrice; }
1572 
1573     function setPublicMint() external onlyOwner { isPublicSale = true; }
1574 
1575     function setPaused (bool _pausedState) external onlyOwner { paused = _pausedState; }
1576 
1577     function setPublicSaleMaxNFTPerWallet(uint256 max_) external onlyOwner { publicSaleMaxNFTPerWallet = max_; }
1578 
1579     function setTeamWallet(address teamWallet_) external onlyOwner { teamWallet = teamWallet_; }
1580 
1581     function numberMinted(address owner) public view returns (uint256) { return _numberMinted(owner); }
1582 
1583     function totalMinted() public view returns (uint256) { return _totalMinted(); }
1584 
1585     function exists(uint256 tokenId) public view returns (bool) { return _exists(tokenId); }
1586 
1587     function setMerkleProof(bytes32 _merkleRoot) external onlyOwner { merkleRoot = _merkleRoot; }
1588 
1589     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) { return MerkleProof.verify(proof, merkleRoot, leaf); }
1590 
1591     function withdraw() public payable onlyOwner {
1592         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1593         require(os);
1594     }
1595 }