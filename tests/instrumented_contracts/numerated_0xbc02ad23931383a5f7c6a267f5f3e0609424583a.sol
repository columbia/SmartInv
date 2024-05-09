1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5 
6       /$$$$$$   /$$$$$$  /$$      /$$
7      /$$__  $$ /$$__  $$| $$$    /$$$
8     |__/  \ $$| $$  \__/| $$$$  /$$$$
9        /$$$$$/| $$ /$$$$| $$ $$/$$ $$
10       |___  $$| $$|_  $$| $$  $$$| $$
11      /$$  \ $$| $$  \ $$| $$\  $ | $$
12     |  $$$$$$/|  $$$$$$/| $$ \/  | $$
13     \______/  \______/ |__/     |__/
14 
15 
16     ** Website
17        https://3gm.dev/
18 
19     ** Twitter
20        https://twitter.com/3gmdev
21 
22 **/
23 
24 
25 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
26 
27 
28 
29 /**
30  * @dev These functions deal with verification of Merkle Trees proofs.
31  *
32  * The proofs can be generated using the JavaScript library
33  * https://github.com/miguelmota/merkletreejs[merkletreejs].
34  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
35  *
36  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
37  *
38  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
39  * hashing, or use a hash function other than keccak256 for hashing leaves.
40  * This is because the concatenation of a sorted pair of internal nodes in
41  * the merkle tree could be reinterpreted as a leaf value.
42  */
43 library MerkleProof {
44     /**
45      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
46      * defined by `root`. For this, a `proof` must be provided, containing
47      * sibling hashes on the branch from the leaf to the root of the tree. Each
48      * pair of leaves and each pair of pre-images are assumed to be sorted.
49      */
50     function verify(
51         bytes32[] memory proof,
52         bytes32 root,
53         bytes32 leaf
54     ) internal pure returns (bool) {
55         return processProof(proof, leaf) == root;
56     }
57 
58     /**
59      * @dev Calldata version of {verify}
60      *
61      * _Available since v4.7._
62      */
63     function verifyCalldata(
64         bytes32[] calldata proof,
65         bytes32 root,
66         bytes32 leaf
67     ) internal pure returns (bool) {
68         return processProofCalldata(proof, leaf) == root;
69     }
70 
71     /**
72      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
73      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
74      * hash matches the root of the tree. When processing the proof, the pairs
75      * of leafs & pre-images are assumed to be sorted.
76      *
77      * _Available since v4.4._
78      */
79     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
80         bytes32 computedHash = leaf;
81         for (uint256 i = 0; i < proof.length; i++) {
82             computedHash = _hashPair(computedHash, proof[i]);
83         }
84         return computedHash;
85     }
86 
87     /**
88      * @dev Calldata version of {processProof}
89      *
90      * _Available since v4.7._
91      */
92     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
93         bytes32 computedHash = leaf;
94         for (uint256 i = 0; i < proof.length; i++) {
95             computedHash = _hashPair(computedHash, proof[i]);
96         }
97         return computedHash;
98     }
99 
100     /**
101      * @dev Returns true if a `leafs` can be proved to be a part of a Merkle tree
102      * defined by `root`. For this, `proofs` for each leaf must be provided, containing
103      * sibling hashes on the branch from the leaf to the root of the tree. Then
104      * 'proofFlag' designates the nodes needed for the multi proof.
105      *
106      * _Available since v4.7._
107      */
108     function multiProofVerify(
109         bytes32 root,
110         bytes32[] calldata leaves,
111         bytes32[] calldata proofs,
112         bool[] calldata proofFlag
113     ) internal pure returns (bool) {
114         return processMultiProof(leaves, proofs, proofFlag) == root;
115     }
116 
117     /**
118      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
119      * from `leaf` using the multi proof as `proofFlag`. A multi proof is
120      * valid if the final hash matches the root of the tree.
121      *
122      * _Available since v4.7._
123      */
124     function processMultiProof(
125         bytes32[] calldata leaves,
126         bytes32[] calldata proofs,
127         bool[] calldata proofFlag
128     ) internal pure returns (bytes32 merkleRoot) {
129         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
130         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
131         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
132         // the merkle tree.
133         uint256 leavesLen = leaves.length;
134         uint256 totalHashes = proofFlag.length;
135 
136         // Check proof validity.
137         require(leavesLen + proofs.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proofs` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
152             bytes32 b = proofFlag[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proofs[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             return hashes[totalHashes - 1];
158         } else if (leavesLen > 0) {
159             return leaves[0];
160         } else {
161             return proofs[0];
162         }
163     }
164 
165     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
166         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
167     }
168 
169     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
170         /// @solidity memory-safe-assembly
171         assembly {
172             mstore(0x00, a)
173             mstore(0x20, b)
174             value := keccak256(0x00, 0x40)
175         }
176     }
177 }
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
181 
182 
183 
184 /**
185  * @dev String operations.
186  */
187 library Strings {
188     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
189     uint8 private constant _ADDRESS_LENGTH = 20;
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = "0";
238         buffer[1] = "x";
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, "Strings: hex length insufficient");
244         return string(buffer);
245     }
246 
247     /**
248      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
249      */
250     function toHexString(address addr) internal pure returns (string memory) {
251         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
252     }
253 }
254 
255 
256 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
257 
258 
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
262 
263 
264 
265 /**
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 abstract contract Context {
276     function _msgSender() internal view virtual returns (address) {
277         return msg.sender;
278     }
279 
280     function _msgData() internal view virtual returns (bytes calldata) {
281         return msg.data;
282     }
283 }
284 
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 abstract contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor() {
307         _transferOwnership(_msgSender());
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view virtual returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public virtual onlyOwner {
333         _transferOwnership(address(0));
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Internal function without access restriction.
348      */
349     function _transferOwnership(address newOwner) internal virtual {
350         address oldOwner = _owner;
351         _owner = newOwner;
352         emit OwnershipTransferred(oldOwner, newOwner);
353     }
354 }
355 
356 
357 // ERC721A Contracts v4.1.0
358 // Creator: Chiru Labs
359 
360 
361 
362 
363 // ERC721A Contracts v4.1.0
364 // Creator: Chiru Labs
365 
366 
367 
368 /**
369  * @dev Interface of an ERC721A compliant contract.
370  */
371 interface IERC721A {
372     /**
373      * The caller must own the token or be an approved operator.
374      */
375     error ApprovalCallerNotOwnerNorApproved();
376 
377     /**
378      * The token does not exist.
379      */
380     error ApprovalQueryForNonexistentToken();
381 
382     /**
383      * The caller cannot approve to their own address.
384      */
385     error ApproveToCaller();
386 
387     /**
388      * Cannot query the balance for the zero address.
389      */
390     error BalanceQueryForZeroAddress();
391 
392     /**
393      * Cannot mint to the zero address.
394      */
395     error MintToZeroAddress();
396 
397     /**
398      * The quantity of tokens minted must be more than zero.
399      */
400     error MintZeroQuantity();
401 
402     /**
403      * The token does not exist.
404      */
405     error OwnerQueryForNonexistentToken();
406 
407     /**
408      * The caller must own the token or be an approved operator.
409      */
410     error TransferCallerNotOwnerNorApproved();
411 
412     /**
413      * The token must be owned by `from`.
414      */
415     error TransferFromIncorrectOwner();
416 
417     /**
418      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
419      */
420     error TransferToNonERC721ReceiverImplementer();
421 
422     /**
423      * Cannot transfer to the zero address.
424      */
425     error TransferToZeroAddress();
426 
427     /**
428      * The token does not exist.
429      */
430     error URIQueryForNonexistentToken();
431 
432     /**
433      * The `quantity` minted with ERC2309 exceeds the safety limit.
434      */
435     error MintERC2309QuantityExceedsLimit();
436 
437     /**
438      * The `extraData` cannot be set on an unintialized ownership slot.
439      */
440     error OwnershipNotInitializedForExtraData();
441 
442     struct TokenOwnership {
443         // The address of the owner.
444         address addr;
445         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
446         uint64 startTimestamp;
447         // Whether the token has been burned.
448         bool burned;
449         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
450         uint24 extraData;
451     }
452 
453     /**
454      * @dev Returns the total amount of tokens stored by the contract.
455      *
456      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
457      */
458     function totalSupply() external view returns (uint256);
459 
460     // ==============================
461     //            IERC165
462     // ==============================
463 
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 
474     // ==============================
475     //            IERC721
476     // ==============================
477 
478     /**
479      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
480      */
481     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
485      */
486     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
487 
488     /**
489      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
490      */
491     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
492 
493     /**
494      * @dev Returns the number of tokens in ``owner``'s account.
495      */
496     function balanceOf(address owner) external view returns (uint256 balance);
497 
498     /**
499      * @dev Returns the owner of the `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function ownerOf(uint256 tokenId) external view returns (address owner);
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes calldata data
525     ) external;
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
529      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Transfers `tokenId` token from `from` to `to`.
549      *
550      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
569      * The approval is cleared when the token is transferred.
570      *
571      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
572      *
573      * Requirements:
574      *
575      * - The caller must own the token or be an approved operator.
576      * - `tokenId` must exist.
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address to, uint256 tokenId) external;
581 
582     /**
583      * @dev Approve or remove `operator` as an operator for the caller.
584      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
585      *
586      * Requirements:
587      *
588      * - The `operator` cannot be the caller.
589      *
590      * Emits an {ApprovalForAll} event.
591      */
592     function setApprovalForAll(address operator, bool _approved) external;
593 
594     /**
595      * @dev Returns the account approved for `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function getApproved(uint256 tokenId) external view returns (address operator);
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator) external view returns (bool);
609 
610     // ==============================
611     //        IERC721Metadata
612     // ==============================
613 
614     /**
615      * @dev Returns the token collection name.
616      */
617     function name() external view returns (string memory);
618 
619     /**
620      * @dev Returns the token collection symbol.
621      */
622     function symbol() external view returns (string memory);
623 
624     /**
625      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
626      */
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 
629     // ==============================
630     //            IERC2309
631     // ==============================
632 
633     /**
634      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
635      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
636      */
637     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
638 }
639 
640 
641 /**
642  * @dev ERC721 token receiver interface.
643  */
644 interface ERC721A__IERC721Receiver {
645     function onERC721Received(
646         address operator,
647         address from,
648         uint256 tokenId,
649         bytes calldata data
650     ) external returns (bytes4);
651 }
652 
653 /**
654  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
655  * including the Metadata extension. Built to optimize for lower gas during batch mints.
656  *
657  * Assumes serials are sequentially minted starting at `_startTokenId()`
658  * (defaults to 0, e.g. 0, 1, 2, 3..).
659  *
660  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
661  *
662  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
663  */
664 contract ERC721A is IERC721A {
665     // Mask of an entry in packed address data.
666     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
667 
668     // The bit position of `numberMinted` in packed address data.
669     uint256 private constant BITPOS_NUMBER_MINTED = 64;
670 
671     // The bit position of `numberBurned` in packed address data.
672     uint256 private constant BITPOS_NUMBER_BURNED = 128;
673 
674     // The bit position of `aux` in packed address data.
675     uint256 private constant BITPOS_AUX = 192;
676 
677     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
678     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
679 
680     // The bit position of `startTimestamp` in packed ownership.
681     uint256 private constant BITPOS_START_TIMESTAMP = 160;
682 
683     // The bit mask of the `burned` bit in packed ownership.
684     uint256 private constant BITMASK_BURNED = 1 << 224;
685 
686     // The bit position of the `nextInitialized` bit in packed ownership.
687     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
688 
689     // The bit mask of the `nextInitialized` bit in packed ownership.
690     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
691 
692     // The bit position of `extraData` in packed ownership.
693     uint256 private constant BITPOS_EXTRA_DATA = 232;
694 
695     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
696     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
697 
698     // The mask of the lower 160 bits for addresses.
699     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
700 
701     // The maximum `quantity` that can be minted with `_mintERC2309`.
702     // This limit is to prevent overflows on the address data entries.
703     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
704     // is required to cause an overflow, which is unrealistic.
705     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
706 
707     // The tokenId of the next token to be minted.
708     uint256 private _currentIndex;
709 
710     // The number of tokens burned.
711     uint256 private _burnCounter;
712 
713     // Token name
714     string private _name;
715 
716     // Token symbol
717     string private _symbol;
718 
719     // Mapping from token ID to ownership details
720     // An empty struct value does not necessarily mean the token is unowned.
721     // See `_packedOwnershipOf` implementation for details.
722     //
723     // Bits Layout:
724     // - [0..159]   `addr`
725     // - [160..223] `startTimestamp`
726     // - [224]      `burned`
727     // - [225]      `nextInitialized`
728     // - [232..255] `extraData`
729     mapping(uint256 => uint256) private _packedOwnerships;
730 
731     // Mapping owner address to address data.
732     //
733     // Bits Layout:
734     // - [0..63]    `balance`
735     // - [64..127]  `numberMinted`
736     // - [128..191] `numberBurned`
737     // - [192..255] `aux`
738     mapping(address => uint256) private _packedAddressData;
739 
740     // Mapping from token ID to approved address.
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749         _currentIndex = _startTokenId();
750     }
751 
752     /**
753      * @dev Returns the starting token ID.
754      * To change the starting token ID, please override this function.
755      */
756     function _startTokenId() internal view virtual returns (uint256) {
757         return 0;
758     }
759 
760     /**
761      * @dev Returns the next token ID to be minted.
762      */
763     function _nextTokenId() internal view returns (uint256) {
764         return _currentIndex;
765     }
766 
767     /**
768      * @dev Returns the total number of tokens in existence.
769      * Burned tokens will reduce the count.
770      * To get the total number of tokens minted, please see `_totalMinted`.
771      */
772     function totalSupply() public view override returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than `_currentIndex - _startTokenId()` times.
775         unchecked {
776             return _currentIndex - _burnCounter - _startTokenId();
777         }
778     }
779 
780     /**
781      * @dev Returns the total amount of tokens minted in the contract.
782      */
783     function _totalMinted() internal view returns (uint256) {
784         // Counter underflow is impossible as _currentIndex does not decrement,
785         // and it is initialized to `_startTokenId()`
786         unchecked {
787             return _currentIndex - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev Returns the total number of tokens burned.
793      */
794     function _totalBurned() internal view returns (uint256) {
795         return _burnCounter;
796     }
797 
798     /**
799      * @dev See {IERC165-supportsInterface}.
800      */
801     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
802         // The interface IDs are constants representing the first 4 bytes of the XOR of
803         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
804         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
805         return
806             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
807             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
808             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view override returns (uint256) {
815         if (owner == address(0)) revert BalanceQueryForZeroAddress();
816         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
817     }
818 
819     /**
820      * Returns the number of tokens minted by `owner`.
821      */
822     function _numberMinted(address owner) internal view returns (uint256) {
823         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
824     }
825 
826     /**
827      * Returns the number of tokens burned by or on behalf of `owner`.
828      */
829     function _numberBurned(address owner) internal view returns (uint256) {
830         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
831     }
832 
833     /**
834      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
835      */
836     function _getAux(address owner) internal view returns (uint64) {
837         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
838     }
839 
840     /**
841      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
842      * If there are multiple variables, please pack them into a uint64.
843      */
844     function _setAux(address owner, uint64 aux) internal {
845         uint256 packed = _packedAddressData[owner];
846         uint256 auxCasted;
847         // Cast `aux` with assembly to avoid redundant masking.
848         assembly {
849             auxCasted := aux
850         }
851         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
852         _packedAddressData[owner] = packed;
853     }
854 
855     /**
856      * Returns the packed ownership data of `tokenId`.
857      */
858     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
859         uint256 curr = tokenId;
860 
861         unchecked {
862             //if (_startTokenId() <= curr)
863                 //if (curr < _currentIndex) {
864                     uint256 packed = _packedOwnerships[curr];
865                     // If not burned.
866                     if (packed & BITMASK_BURNED == 0) {
867                         // Invariant:
868                         // There will always be an ownership that has an address and is not burned
869                         // before an ownership that does not have an address and is not burned.
870                         // Hence, curr will not underflow.
871                         //
872                         // We can directly compare the packed value.
873                         // If the address is zero, packed is zero.
874                         while (packed == 0) {
875                             packed = _packedOwnerships[--curr];
876                         }
877                         return packed;
878                     }
879                 //}
880         }
881         revert OwnerQueryForNonexistentToken();
882     }
883 
884     /**
885      * Returns the unpacked `TokenOwnership` struct from `packed`.
886      */
887     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
888         ownership.addr = address(uint160(packed));
889         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
890         ownership.burned = packed & BITMASK_BURNED != 0;
891         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
892     }
893 
894     /**
895      * Returns the unpacked `TokenOwnership` struct at `index`.
896      */
897     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
898         return _unpackedOwnership(_packedOwnerships[index]);
899     }
900 
901     /**
902      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
903      */
904     function _initializeOwnershipAt(uint256 index) internal {
905         if (_packedOwnerships[index] == 0) {
906             _packedOwnerships[index] = _packedOwnershipOf(index);
907         }
908     }
909 
910     /**
911      * Gas spent here starts off proportional to the maximum mint batch size.
912      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
913      */
914     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
915         return _unpackedOwnership(_packedOwnershipOf(tokenId));
916     }
917 
918     /**
919      * @dev Packs ownership data into a single uint256.
920      */
921     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
922         assembly {
923             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
924             owner := and(owner, BITMASK_ADDRESS)
925             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
926             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
927         }
928     }
929 
930     /**
931      * @dev See {IERC721-ownerOf}.
932      */
933     function ownerOf(uint256 tokenId) public view override returns (address) {
934         return address(uint160(_packedOwnershipOf(tokenId)));
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
955         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
956 
957         string memory baseURI = _baseURI();
958         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
959     }
960 
961     /**
962      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964      * by default, it can be overridden in child contracts.
965      */
966     function _baseURI() internal view virtual returns (string memory) {
967         return '';
968     }
969 
970     /**
971      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
972      */
973     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
974         // For branchless setting of the `nextInitialized` flag.
975         assembly {
976             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
977             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
978         }
979     }
980 
981     /**
982      * @dev See {IERC721-approve}.
983      */
984     function approve(address to, uint256 tokenId) public override {
985         address owner = ownerOf(tokenId);
986 
987         if (_msgSenderERC721A() != owner)
988             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
989                 revert ApprovalCallerNotOwnerNorApproved();
990             }
991 
992         _tokenApprovals[tokenId] = to;
993         emit Approval(owner, to, tokenId);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public virtual override {
1009         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1012         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         safeTransferFrom(from, to, tokenId, '');
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes memory _data
1041     ) public virtual override {
1042         transferFrom(from, to, tokenId);
1043         if (to.code.length != 0)
1044             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045                 revert TransferToNonERC721ReceiverImplementer();
1046             }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         if(_packedOwnerships[tokenId] != 0){
1058             return _packedOwnerships[tokenId] & BITMASK_BURNED == 0;
1059         }
1060         return false;
1061         /* return
1062             _startTokenId() <= tokenId &&
1063             tokenId < _currentIndex && // If within bounds,
1064             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned. */
1065     }
1066 
1067     /**
1068      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1069      */
1070     function _safeMint(address to, uint256 quantity) internal {
1071         _safeMint(to, quantity, '');
1072     }
1073 
1074     /**
1075      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - If `to` refers to a smart contract, it must implement
1080      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1081      * - `quantity` must be greater than 0.
1082      *
1083      * See {_mint}.
1084      *
1085      * Emits a {Transfer} event for each mint.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data
1091     ) internal {
1092         _mint(to, quantity);
1093 
1094         unchecked {
1095             if (to.code.length != 0) {
1096                 uint256 end = _currentIndex;
1097                 uint256 index = end - quantity;
1098                 do {
1099                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1100                         revert TransferToNonERC721ReceiverImplementer();
1101                     }
1102                 } while (index < end);
1103                 // Reentrancy protection.
1104                 if (_currentIndex != end) revert();
1105             }
1106         }
1107     }
1108 
1109     /**
1110      * @dev Mints `quantity` tokens and transfers them to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {Transfer} event for each mint.
1118      */
1119     function _mint(address to, uint256 quantity) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are incredibly unrealistic.
1127         // `balance` and `numberMinted` have a maximum limit of 2**64.
1128         // `tokenId` has a maximum limit of 2**256.
1129         unchecked {
1130             // Updates:
1131             // - `balance += quantity`.
1132             // - `numberMinted += quantity`.
1133             //
1134             // We can directly add to the `balance` and `numberMinted`.
1135             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1136 
1137             // Updates:
1138             // - `address` to the owner.
1139             // - `startTimestamp` to the timestamp of minting.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `quantity == 1`.
1142             _packedOwnerships[startTokenId] = _packOwnershipData(
1143                 to,
1144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1145             );
1146 
1147             uint256 tokenId = startTokenId;
1148             uint256 end = startTokenId + quantity;
1149             do {
1150                 emit Transfer(address(0), to, tokenId++);
1151             } while (tokenId < end);
1152 
1153             _currentIndex = end;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     /**
1159      * @dev Mints `tokenIds` tokens and transfers them to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `tokenIds` must be greater than 0.
1165      *
1166      * Emits a {Transfer} event for each mint.
1167      */
1168     function _mintSpecifics(address to, uint256[] memory tokenIds) internal {
1169         uint256 quantity = tokenIds.length;
1170         if (to == address(0)) revert MintToZeroAddress();
1171         if (quantity == 0) revert MintZeroQuantity();
1172 
1173         // Updates:
1174         // - `balance += quantity`.
1175         // - `numberMinted += quantity`.
1176         //
1177         // We can directly add to the `balance` and `numberMinted`.
1178         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1179 
1180         for (uint256 i; i < tokenIds.length; i++) {
1181             // Overflows are incredibly unrealistic.
1182             // `balance` and `numberMinted` have a maximum limit of 2**64.
1183             // `tokenId` has a maximum limit of 2**256.
1184             unchecked {
1185                 _beforeTokenTransfers(address(0), to, tokenIds[i], 1);
1186                 // Updates:
1187                 // - `address` to the owner.
1188                 // - `startTimestamp` to the timestamp of minting.
1189                 // - `burned` to `false`.
1190                 // - `nextInitialized` to `quantity == 1`.
1191                 _packedOwnerships[tokenIds[i]] = _packOwnershipData(
1192                     to,
1193                     _nextInitializedFlag(1) | _nextExtraData(address(0), to, 0)
1194                 );
1195 
1196                 emit Transfer(address(0), to, tokenIds[i]);
1197                 _afterTokenTransfers(address(0), to, tokenIds[i], 1);
1198             }
1199 
1200         }
1201     }
1202 
1203     /**
1204      * @dev Mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * This function is intended for efficient minting only during contract creation.
1207      *
1208      * It emits only one {ConsecutiveTransfer} as defined in
1209      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1210      * instead of a sequence of {Transfer} event(s).
1211      *
1212      * Calling this function outside of contract creation WILL make your contract
1213      * non-compliant with the ERC721 standard.
1214      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1215      * {ConsecutiveTransfer} event is only permissible during contract creation.
1216      *
1217      * Requirements:
1218      *
1219      * - `to` cannot be the zero address.
1220      * - `quantity` must be greater than 0.
1221      *
1222      * Emits a {ConsecutiveTransfer} event.
1223      */
1224     function _mintERC2309(address to, uint256 quantity) internal {
1225         uint256 startTokenId = _currentIndex;
1226         if (to == address(0)) revert MintToZeroAddress();
1227         if (quantity == 0) revert MintZeroQuantity();
1228         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1229 
1230         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1231 
1232         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1233         unchecked {
1234             // Updates:
1235             // - `balance += quantity`.
1236             // - `numberMinted += quantity`.
1237             //
1238             // We can directly add to the `balance` and `numberMinted`.
1239             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1240 
1241             // Updates:
1242             // - `address` to the owner.
1243             // - `startTimestamp` to the timestamp of minting.
1244             // - `burned` to `false`.
1245             // - `nextInitialized` to `quantity == 1`.
1246             _packedOwnerships[startTokenId] = _packOwnershipData(
1247                 to,
1248                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1249             );
1250 
1251             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1252 
1253             _currentIndex = startTokenId + quantity;
1254         }
1255         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1256     }
1257 
1258     /**
1259      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1260      */
1261     function _getApprovedAddress(uint256 tokenId)
1262         private
1263         view
1264         returns (uint256 approvedAddressSlot, address approvedAddress)
1265     {
1266         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1267         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1268         assembly {
1269             // Compute the slot.
1270             mstore(0x00, tokenId)
1271             mstore(0x20, tokenApprovalsPtr.slot)
1272             approvedAddressSlot := keccak256(0x00, 0x40)
1273             // Load the slot's value from storage.
1274             approvedAddress := sload(approvedAddressSlot)
1275         }
1276     }
1277 
1278     /**
1279      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1280      */
1281     function _isOwnerOrApproved(
1282         address approvedAddress,
1283         address from,
1284         address msgSender
1285     ) private pure returns (bool result) {
1286         assembly {
1287             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1288             from := and(from, BITMASK_ADDRESS)
1289             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1290             msgSender := and(msgSender, BITMASK_ADDRESS)
1291             // `msgSender == from || msgSender == approvedAddress`.
1292             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1293         }
1294     }
1295 
1296     /**
1297      * @dev Transfers `tokenId` from `from` to `to`.
1298      *
1299      * Requirements:
1300      *
1301      * - `to` cannot be the zero address.
1302      * - `tokenId` token must be owned by `from`.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function transferFrom(
1307         address from,
1308         address to,
1309         uint256 tokenId
1310     ) public virtual override {
1311         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1312 
1313         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1314 
1315         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1316 
1317         // The nested ifs save around 20+ gas over a compound boolean condition.
1318         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1319             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1320 
1321         if (to == address(0)) revert TransferToZeroAddress();
1322 
1323         _beforeTokenTransfers(from, to, tokenId, 1);
1324 
1325         // Clear approvals from the previous owner.
1326         assembly {
1327             if approvedAddress {
1328                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1329                 sstore(approvedAddressSlot, 0)
1330             }
1331         }
1332 
1333         // Underflow of the sender's balance is impossible because we check for
1334         // ownership above and the recipient's balance can't realistically overflow.
1335         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1336         unchecked {
1337             // We can directly increment and decrement the balances.
1338             --_packedAddressData[from]; // Updates: `balance -= 1`.
1339             ++_packedAddressData[to]; // Updates: `balance += 1`.
1340 
1341             // Updates:
1342             // - `address` to the next owner.
1343             // - `startTimestamp` to the timestamp of transfering.
1344             // - `burned` to `false`.
1345             // - `nextInitialized` to `true`.
1346             _packedOwnerships[tokenId] = _packOwnershipData(
1347                 to,
1348                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1349             );
1350 
1351             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1352             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1353                 uint256 nextTokenId = tokenId + 1;
1354                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1355                 if (_packedOwnerships[nextTokenId] == 0) {
1356                     // If the next slot is within bounds.
1357                     if (nextTokenId != _currentIndex) {
1358                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1359                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1360                     }
1361                 }
1362             }
1363         }
1364 
1365         emit Transfer(from, to, tokenId);
1366         _afterTokenTransfers(from, to, tokenId, 1);
1367     }
1368 
1369     /**
1370      * @dev Equivalent to `_burn(tokenId, false)`.
1371      */
1372     function _burn(uint256 tokenId) internal virtual {
1373         _burn(tokenId, false);
1374     }
1375 
1376     /**
1377      * @dev Destroys `tokenId`.
1378      * The approval is cleared when the token is burned.
1379      *
1380      * Requirements:
1381      *
1382      * - `tokenId` must exist.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1387         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1388 
1389         address from = address(uint160(prevOwnershipPacked));
1390 
1391         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1392 
1393         if (approvalCheck) {
1394             // The nested ifs save around 20+ gas over a compound boolean condition.
1395             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1396                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1397         }
1398 
1399         _beforeTokenTransfers(from, address(0), tokenId, 1);
1400 
1401         // Clear approvals from the previous owner.
1402         assembly {
1403             if approvedAddress {
1404                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1405                 sstore(approvedAddressSlot, 0)
1406             }
1407         }
1408 
1409         // Underflow of the sender's balance is impossible because we check for
1410         // ownership above and the recipient's balance can't realistically overflow.
1411         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1412         unchecked {
1413             // Updates:
1414             // - `balance -= 1`.
1415             // - `numberBurned += 1`.
1416             //
1417             // We can directly decrement the balance, and increment the number burned.
1418             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1419             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1420 
1421             // Updates:
1422             // - `address` to the last owner.
1423             // - `startTimestamp` to the timestamp of burning.
1424             // - `burned` to `true`.
1425             // - `nextInitialized` to `true`.
1426             _packedOwnerships[tokenId] = _packOwnershipData(
1427                 from,
1428                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1429             );
1430 
1431             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1432             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1433                 uint256 nextTokenId = tokenId + 1;
1434                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1435                 if (_packedOwnerships[nextTokenId] == 0) {
1436                     // If the next slot is within bounds.
1437                     if (nextTokenId != _currentIndex) {
1438                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1439                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1440                     }
1441                 }
1442             }
1443         }
1444 
1445         emit Transfer(from, address(0), tokenId);
1446         _afterTokenTransfers(from, address(0), tokenId, 1);
1447 
1448         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1449         unchecked {
1450             _burnCounter++;
1451         }
1452     }
1453 
1454     /**
1455      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1456      *
1457      * @param from address representing the previous owner of the given token ID
1458      * @param to target address that will receive the tokens
1459      * @param tokenId uint256 ID of the token to be transferred
1460      * @param _data bytes optional data to send along with the call
1461      * @return bool whether the call correctly returned the expected magic value
1462      */
1463     function _checkContractOnERC721Received(
1464         address from,
1465         address to,
1466         uint256 tokenId,
1467         bytes memory _data
1468     ) private returns (bool) {
1469         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1470             bytes4 retval
1471         ) {
1472             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1473         } catch (bytes memory reason) {
1474             if (reason.length == 0) {
1475                 revert TransferToNonERC721ReceiverImplementer();
1476             } else {
1477                 assembly {
1478                     revert(add(32, reason), mload(reason))
1479                 }
1480             }
1481         }
1482     }
1483 
1484     /**
1485      * @dev Directly sets the extra data for the ownership data `index`.
1486      */
1487     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1488         uint256 packed = _packedOwnerships[index];
1489         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1490         uint256 extraDataCasted;
1491         // Cast `extraData` with assembly to avoid redundant masking.
1492         assembly {
1493             extraDataCasted := extraData
1494         }
1495         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1496         _packedOwnerships[index] = packed;
1497     }
1498 
1499     /**
1500      * @dev Returns the next extra data for the packed ownership data.
1501      * The returned result is shifted into position.
1502      */
1503     function _nextExtraData(
1504         address from,
1505         address to,
1506         uint256 prevOwnershipPacked
1507     ) private view returns (uint256) {
1508         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1509         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1510     }
1511 
1512     /**
1513      * @dev Called during each token transfer to set the 24bit `extraData` field.
1514      * Intended to be overridden by the cosumer contract.
1515      *
1516      * `previousExtraData` - the value of `extraData` before transfer.
1517      *
1518      * Calling conditions:
1519      *
1520      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1521      * transferred to `to`.
1522      * - When `from` is zero, `tokenId` will be minted for `to`.
1523      * - When `to` is zero, `tokenId` will be burned by `from`.
1524      * - `from` and `to` are never both zero.
1525      */
1526     function _extraData(
1527         address from,
1528         address to,
1529         uint24 previousExtraData
1530     ) internal view virtual returns (uint24) {}
1531 
1532     /**
1533      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1534      * This includes minting.
1535      * And also called before burning one token.
1536      *
1537      * startTokenId - the first token id to be transferred
1538      * quantity - the amount to be transferred
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` will be minted for `to`.
1545      * - When `to` is zero, `tokenId` will be burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _beforeTokenTransfers(
1549         address from,
1550         address to,
1551         uint256 startTokenId,
1552         uint256 quantity
1553     ) internal virtual {}
1554 
1555     /**
1556      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1557      * This includes minting.
1558      * And also called after one token has been burned.
1559      *
1560      * startTokenId - the first token id to be transferred
1561      * quantity - the amount to be transferred
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1566      * transferred to `to`.
1567      * - When `from` is zero, `tokenId` has been minted for `to`.
1568      * - When `to` is zero, `tokenId` has been burned by `from`.
1569      * - `from` and `to` are never both zero.
1570      */
1571     function _afterTokenTransfers(
1572         address from,
1573         address to,
1574         uint256 startTokenId,
1575         uint256 quantity
1576     ) internal virtual {}
1577 
1578     /**
1579      * @dev Returns the message sender (defaults to `msg.sender`).
1580      *
1581      * If you are writing GSN compatible contracts, you need to override this function.
1582      */
1583     function _msgSenderERC721A() internal view virtual returns (address) {
1584         return msg.sender;
1585     }
1586 
1587     /**
1588      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1589      */
1590     function _toString(uint256 value) internal pure returns (string memory ptr) {
1591         assembly {
1592             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1593             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1594             // We will need 1 32-byte word to store the length,
1595             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1596             ptr := add(mload(0x40), 128)
1597             // Update the free memory pointer to allocate.
1598             mstore(0x40, ptr)
1599 
1600             // Cache the end of the memory to calculate the length later.
1601             let end := ptr
1602 
1603             // We write the string from the rightmost digit to the leftmost digit.
1604             // The following is essentially a do-while loop that also handles the zero case.
1605             // Costs a bit more than early returning for the zero case,
1606             // but cheaper in terms of deployment and overall runtime costs.
1607             for {
1608                 // Initialize and perform the first pass without check.
1609                 let temp := value
1610                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1611                 ptr := sub(ptr, 1)
1612                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1613                 mstore8(ptr, add(48, mod(temp, 10)))
1614                 temp := div(temp, 10)
1615             } temp {
1616                 // Keep dividing `temp` until zero.
1617                 temp := div(temp, 10)
1618             } {
1619                 // Body of the for loop.
1620                 ptr := sub(ptr, 1)
1621                 mstore8(ptr, add(48, mod(temp, 10)))
1622             }
1623 
1624             let length := sub(end, ptr)
1625             // Move the pointer 32 bytes leftwards to make room for the length.
1626             ptr := sub(ptr, 32)
1627             // Store the length.
1628             mstore(ptr, length)
1629         }
1630     }
1631 }
1632 
1633 
1634 contract ThreeGMAIPFP is ERC721A, Ownable {
1635 
1636     string public baseURI = "";
1637     string public contractURI = "";
1638     uint256 constant public MAX_SUPPLY = 5000;
1639     uint256 public PUBLIC_SUPPLY = 2000;
1640     bytes32 public whitelistMerkle = 0xd6b7ab9c29363efd9448bb78e592fe0d6d77aa10a2034690bbe3a26af23007d2;
1641 
1642     uint256 public txLimit = 5;
1643     uint256 public walletLimit = 10;
1644     uint256 public price = 0.02 ether;
1645 
1646     bool public claimPaused = true;
1647     bool public whitelistPaused = true;
1648     bool public publicPaused = true;
1649 
1650     IERC721A threeGMGenesisPass = IERC721A(0xbB52d85C8dE311A031770b48dC9F91083E6D12B1);
1651 
1652     mapping(address => uint256) public claimedWhitelist;
1653     mapping(address => uint256) public walletMint;
1654 
1655     constructor() ERC721A("3GMAIPFP", "3GMAIPFP") {}
1656 
1657     function claimFromGenesis(uint256[] calldata _tokenIds) external {
1658       address _caller = _msgSender();
1659       require(!claimPaused || owner() == _caller, "Claim paused");
1660       require(tx.origin == _caller, "No contracts");
1661 
1662       for (uint256 i; i < _tokenIds.length; i++) {
1663           require(threeGMGenesisPass.ownerOf(_tokenIds[i]) == _caller, "Not owner of the token");
1664           require(!_exists(_tokenIds[i]), "Token already claimed.");
1665 
1666           uint256[] memory tokens = new uint256[](3);
1667           tokens[0] = _tokenIds[i];
1668           tokens[1] = _tokenIds[i] + 333;
1669           tokens[2] = _tokenIds[i] + 666;
1670 
1671           _mintSpecifics(_caller, tokens);
1672       }
1673     }
1674 
1675     function whitelist(uint256 _amountToMint, uint256 _maxAmount, bytes32[] calldata _merkleProof) external payable {
1676         require(!whitelistPaused, "Whitelist paused");
1677         require(MAX_SUPPLY >= totalSupply() + _amountToMint, "Exceeds max supply");
1678         require(_amountToMint > 0, "Not 0 mints");
1679 
1680         address _caller = _msgSender();
1681         require(tx.origin == _caller, "No contracts");
1682         require(claimedWhitelist[_caller] + _amountToMint <= _maxAmount, "Not allow to mint more");
1683 
1684         bytes32 leaf = keccak256(abi.encodePacked(_caller, _maxAmount));
1685         require(MerkleProof.verify(_merkleProof, whitelistMerkle, leaf), "Invalid proof");
1686 
1687         unchecked { claimedWhitelist[_caller] += _amountToMint; }
1688         _safeMint(_caller, _amountToMint);
1689     }
1690 
1691     function mint(uint256 _amountToMint) external payable {
1692         require(!publicPaused, "Public paused");
1693         require(MAX_SUPPLY >= totalSupply() + _amountToMint, "Exceeds max supply");
1694         require(PUBLIC_SUPPLY - _amountToMint >= 0, "Max public mints reached");
1695         require(_amountToMint > 0, "Not 0 mints");
1696         require(_amountToMint <= txLimit, "Tx limit");
1697         require(_amountToMint * price == msg.value, "Invalid funds provided");
1698 
1699         address _caller = _msgSender();
1700         require(tx.origin == _caller, "No contracts");
1701         require(walletMint[_caller] + _amountToMint <= walletLimit, "Not allow to mint more");
1702 
1703         unchecked {
1704           PUBLIC_SUPPLY -= _amountToMint;
1705           walletMint[_caller] += _amountToMint;
1706         }
1707         _safeMint(_caller, _amountToMint);
1708     }
1709 
1710     function _startTokenId() internal override view virtual returns (uint256) {
1711         return 1000;
1712     }
1713 
1714     function exists(uint256 _tokenId) public view returns (bool) {
1715         return _exists(_tokenId);
1716     }
1717 
1718     function minted(address _owner) public view returns (uint256) {
1719         return _numberMinted(_owner);
1720     }
1721 
1722     function withdraw() external onlyOwner {
1723         uint256 balance = address(this).balance;
1724         (bool success, ) = _msgSender().call{value: balance}("");
1725         require(success, "Failed to send");
1726     }
1727 
1728     function teamMint(address _to, uint256 _amount) external onlyOwner {
1729         _safeMint(_to, _amount);
1730     }
1731 
1732     function teamMintSpecific(address _to, uint256[] calldata _tokenIds) external onlyOwner {
1733       for (uint256 i; i < _tokenIds.length; i++) {
1734           require(!_exists(_tokenIds[i]), "Token already exist.");
1735 
1736           uint256[] memory tokens = new uint256[](3);
1737           tokens[0] = _tokenIds[i];
1738           tokens[1] = _tokenIds[i] + 333;
1739           tokens[2] = _tokenIds[i] + 666;
1740 
1741           _mintSpecifics(_to, tokens);
1742       }
1743     }
1744 
1745     function toggleClaim() external onlyOwner {
1746         claimPaused = !claimPaused;
1747     }
1748 
1749     function toggleWhitelist() external onlyOwner {
1750         whitelistPaused = !whitelistPaused;
1751     }
1752 
1753     function togglePublic() external onlyOwner {
1754         publicPaused = !publicPaused;
1755     }
1756 
1757     function setPublicSupply(uint256 _supply) external onlyOwner {
1758         PUBLIC_SUPPLY = _supply;
1759     }
1760 
1761     function setPrice(uint256 _price) external onlyOwner {
1762         price = _price;
1763     }
1764 
1765     function setTxLimit(uint256 _limit) external onlyOwner {
1766         txLimit = _limit;
1767     }
1768 
1769     function setWalletLimit(uint256 _limit) external onlyOwner {
1770         walletLimit = _limit;
1771     }
1772 
1773     function setWhitelistMerkle(bytes32 _merkle) external onlyOwner {
1774         whitelistMerkle = _merkle;
1775     }
1776 
1777     function setBaseURI(string memory baseURI_) external onlyOwner {
1778         baseURI = baseURI_;
1779     }
1780 
1781     function setContractURI(string memory _contractURI) external onlyOwner {
1782         contractURI = _contractURI;
1783     }
1784 
1785     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1786         require(_exists(_tokenId), "Token does not exist.");
1787         return bytes(baseURI).length > 0 ? string(
1788             abi.encodePacked(
1789               baseURI,
1790               Strings.toString(_tokenId),
1791               ".json"
1792             )
1793         ) : "";
1794     }
1795 }