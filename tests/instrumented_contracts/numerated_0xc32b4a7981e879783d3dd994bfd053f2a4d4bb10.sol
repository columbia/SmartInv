1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev These functions deal with verification of Merkle Trees proofs.
80  *
81  * The proofs can be generated using the JavaScript library
82  * https://github.com/miguelmota/merkletreejs[merkletreejs].
83  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
84  *
85  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
86  *
87  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
88  * hashing, or use a hash function other than keccak256 for hashing leaves.
89  * This is because the concatenation of a sorted pair of internal nodes in
90  * the merkle tree could be reinterpreted as a leaf value.
91  */
92 library MerkleProof {
93     /**
94      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
95      * defined by `root`. For this, a `proof` must be provided, containing
96      * sibling hashes on the branch from the leaf to the root of the tree. Each
97      * pair of leaves and each pair of pre-images are assumed to be sorted.
98      */
99     function verify(
100         bytes32[] memory proof,
101         bytes32 root,
102         bytes32 leaf
103     ) internal pure returns (bool) {
104         return processProof(proof, leaf) == root;
105     }
106 
107     /**
108      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
109      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
110      * hash matches the root of the tree. When processing the proof, the pairs
111      * of leafs & pre-images are assumed to be sorted.
112      *
113      * _Available since v4.4._
114      */
115     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
116         bytes32 computedHash = leaf;
117         for (uint256 i = 0; i < proof.length; i++) {
118             bytes32 proofElement = proof[i];
119             if (computedHash <= proofElement) {
120                 // Hash(current computed hash + current element of the proof)
121                 computedHash = _efficientHash(computedHash, proofElement);
122             } else {
123                 // Hash(current element of the proof + current computed hash)
124                 computedHash = _efficientHash(proofElement, computedHash);
125             }
126         }
127         return computedHash;
128     }
129 
130     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
131         assembly {
132             mstore(0x00, a)
133             mstore(0x20, b)
134             value := keccak256(0x00, 0x40)
135         }
136     }
137 }
138 
139 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Contract module that helps prevent reentrant calls to a function.
148  *
149  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
150  * available, which can be applied to functions to make sure there are no nested
151  * (reentrant) calls to them.
152  *
153  * Note that because there is a single `nonReentrant` guard, functions marked as
154  * `nonReentrant` may not call one another. This can be worked around by making
155  * those functions `private`, and then adding `external` `nonReentrant` entry
156  * points to them.
157  *
158  * TIP: If you would like to learn more about reentrancy and alternative ways
159  * to protect against it, check out our blog post
160  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
161  */
162 abstract contract ReentrancyGuard {
163     // Booleans are more expensive than uint256 or any type that takes up a full
164     // word because each write operation emits an extra SLOAD to first read the
165     // slot's contents, replace the bits taken up by the boolean, and then write
166     // back. This is the compiler's defense against contract upgrades and
167     // pointer aliasing, and it cannot be disabled.
168 
169     // The values being non-zero value makes deployment a bit more expensive,
170     // but in exchange the refund on every call to nonReentrant will be lower in
171     // amount. Since refunds are capped to a percentage of the total
172     // transaction's gas, it is best to keep them low in cases like this one, to
173     // increase the likelihood of the full refund coming into effect.
174     uint256 private constant _NOT_ENTERED = 1;
175     uint256 private constant _ENTERED = 2;
176 
177     uint256 private _status;
178 
179     constructor() {
180         _status = _NOT_ENTERED;
181     }
182 
183     /**
184      * @dev Prevents a contract from calling itself, directly or indirectly.
185      * Calling a `nonReentrant` function from another `nonReentrant`
186      * function is not supported. It is possible to prevent this from happening
187      * by making the `nonReentrant` function external, and making it call a
188      * `private` function that does the actual work.
189      */
190     modifier nonReentrant() {
191         // On the first call to nonReentrant, _notEntered will be true
192         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
193 
194         // Any calls to nonReentrant after this point will fail
195         _status = _ENTERED;
196 
197         _;
198 
199         // By storing the original value once again, a refund is triggered (see
200         // https://eips.ethereum.org/EIPS/eip-2200)
201         _status = _NOT_ENTERED;
202     }
203 }
204 
205 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev String operations.
214  */
215 library StringsUpgradeable {
216     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
220      */
221     function toString(uint256 value) internal pure returns (string memory) {
222         // Inspired by OraclizeAPI's implementation - MIT licence
223         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
224 
225         if (value == 0) {
226             return "0";
227         }
228         uint256 temp = value;
229         uint256 digits;
230         while (temp != 0) {
231             digits++;
232             temp /= 10;
233         }
234         bytes memory buffer = new bytes(digits);
235         while (value != 0) {
236             digits -= 1;
237             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
238             value /= 10;
239         }
240         return string(buffer);
241     }
242 
243     /**
244      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
245      */
246     function toHexString(uint256 value) internal pure returns (string memory) {
247         if (value == 0) {
248             return "0x00";
249         }
250         uint256 temp = value;
251         uint256 length = 0;
252         while (temp != 0) {
253             length++;
254             temp >>= 8;
255         }
256         return toHexString(value, length);
257     }
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
261      */
262     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
263         bytes memory buffer = new bytes(2 * length + 2);
264         buffer[0] = "0";
265         buffer[1] = "x";
266         for (uint256 i = 2 * length + 1; i > 1; --i) {
267             buffer[i] = _HEX_SYMBOLS[value & 0xf];
268             value >>= 4;
269         }
270         require(value == 0, "Strings: hex length insufficient");
271         return string(buffer);
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Context.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Provides information about the current execution context, including the
284  * sender of the transaction and its data. While these are generally available
285  * via msg.sender and msg.data, they should not be accessed in such a direct
286  * manner, since when dealing with meta-transactions the account sending and
287  * paying for execution may not be the actual sender (as far as an application
288  * is concerned).
289  *
290  * This contract is only required for intermediate, library-like contracts.
291  */
292 abstract contract Context {
293     function _msgSender() internal view virtual returns (address) {
294         return msg.sender;
295     }
296 
297     function _msgData() internal view virtual returns (bytes calldata) {
298         return msg.data;
299     }
300 }
301 
302 // File: @openzeppelin/contracts/access/Ownable.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Contract module which provides a basic access control mechanism, where
312  * there is an account (an owner) that can be granted exclusive access to
313  * specific functions.
314  *
315  * By default, the owner account will be the one that deploys the contract. This
316  * can later be changed with {transferOwnership}.
317  *
318  * This module is used through inheritance. It will make available the modifier
319  * `onlyOwner`, which can be applied to your functions to restrict their use to
320  * the owner.
321  */
322 abstract contract Ownable is Context {
323     address private _owner;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     /**
328      * @dev Initializes the contract setting the deployer as the initial owner.
329      */
330     constructor() {
331         _transferOwnership(_msgSender());
332     }
333 
334     /**
335      * @dev Returns the address of the current owner.
336      */
337     function owner() public view virtual returns (address) {
338         return _owner;
339     }
340 
341     /**
342      * @dev Throws if called by any account other than the owner.
343      */
344     modifier onlyOwner() {
345         require(owner() == _msgSender(), "Ownable: caller is not the owner");
346         _;
347     }
348 
349     /**
350      * @dev Leaves the contract without owner. It will not be possible to call
351      * `onlyOwner` functions anymore. Can only be called by the current owner.
352      *
353      * NOTE: Renouncing ownership will leave the contract without an owner,
354      * thereby removing any functionality that is only available to the owner.
355      */
356     function renounceOwnership() public virtual onlyOwner {
357         _transferOwnership(address(0));
358     }
359 
360     /**
361      * @dev Transfers ownership of the contract to a new account (`newOwner`).
362      * Can only be called by the current owner.
363      */
364     function transferOwnership(address newOwner) public virtual onlyOwner {
365         require(newOwner != address(0), "Ownable: new owner is the zero address");
366         _transferOwnership(newOwner);
367     }
368 
369     /**
370      * @dev Transfers ownership of the contract to a new account (`newOwner`).
371      * Internal function without access restriction.
372      */
373     function _transferOwnership(address newOwner) internal virtual {
374         address oldOwner = _owner;
375         _owner = newOwner;
376         emit OwnershipTransferred(oldOwner, newOwner);
377     }
378 }
379 
380 // File: erc721a/contracts/IERC721A.sol
381 
382 
383 // ERC721A Contracts v4.1.0
384 // Creator: Chiru Labs
385 
386 pragma solidity ^0.8.4;
387 
388 /**
389  * @dev Interface of an ERC721A compliant contract.
390  */
391 interface IERC721A {
392     /**
393      * The caller must own the token or be an approved operator.
394      */
395     error ApprovalCallerNotOwnerNorApproved();
396 
397     /**
398      * The token does not exist.
399      */
400     error ApprovalQueryForNonexistentToken();
401 
402     /**
403      * The caller cannot approve to their own address.
404      */
405     error ApproveToCaller();
406 
407     /**
408      * Cannot query the balance for the zero address.
409      */
410     error BalanceQueryForZeroAddress();
411 
412     /**
413      * Cannot mint to the zero address.
414      */
415     error MintToZeroAddress();
416 
417     /**
418      * The quantity of tokens minted must be more than zero.
419      */
420     error MintZeroQuantity();
421 
422     /**
423      * The token does not exist.
424      */
425     error OwnerQueryForNonexistentToken();
426 
427     /**
428      * The caller must own the token or be an approved operator.
429      */
430     error TransferCallerNotOwnerNorApproved();
431 
432     /**
433      * The token must be owned by `from`.
434      */
435     error TransferFromIncorrectOwner();
436 
437     /**
438      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
439      */
440     error TransferToNonERC721ReceiverImplementer();
441 
442     /**
443      * Cannot transfer to the zero address.
444      */
445     error TransferToZeroAddress();
446 
447     /**
448      * The token does not exist.
449      */
450     error URIQueryForNonexistentToken();
451 
452     /**
453      * The `quantity` minted with ERC2309 exceeds the safety limit.
454      */
455     error MintERC2309QuantityExceedsLimit();
456 
457     /**
458      * The `extraData` cannot be set on an unintialized ownership slot.
459      */
460     error OwnershipNotInitializedForExtraData();
461 
462     struct TokenOwnership {
463         // The address of the owner.
464         address addr;
465         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
466         uint64 startTimestamp;
467         // Whether the token has been burned.
468         bool burned;
469         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
470         uint24 extraData;
471     }
472 
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      *
476      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     // ==============================
481     //            IERC165
482     // ==============================
483 
484     /**
485      * @dev Returns true if this contract implements the interface defined by
486      * `interfaceId`. See the corresponding
487      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
488      * to learn more about how these ids are created.
489      *
490      * This function call must use less than 30 000 gas.
491      */
492     function supportsInterface(bytes4 interfaceId) external view returns (bool);
493 
494     // ==============================
495     //            IERC721
496     // ==============================
497 
498     /**
499      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
505      */
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     /**
509      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
510      */
511     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
512 
513     /**
514      * @dev Returns the number of tokens in ``owner``'s account.
515      */
516     function balanceOf(address owner) external view returns (uint256 balance);
517 
518     /**
519      * @dev Returns the owner of the `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function ownerOf(uint256 tokenId) external view returns (address owner);
526 
527     /**
528      * @dev Safely transfers `tokenId` token from `from` to `to`.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId,
544         bytes calldata data
545     ) external;
546 
547     /**
548      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
549      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must exist and be owned by `from`.
556      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
557      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
558      *
559      * Emits a {Transfer} event.
560      */
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId
565     ) external;
566 
567     /**
568      * @dev Transfers `tokenId` token from `from` to `to`.
569      *
570      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must be owned by `from`.
577      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
578      *
579      * Emits a {Transfer} event.
580      */
581     function transferFrom(
582         address from,
583         address to,
584         uint256 tokenId
585     ) external;
586 
587     /**
588      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
589      * The approval is cleared when the token is transferred.
590      *
591      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
592      *
593      * Requirements:
594      *
595      * - The caller must own the token or be an approved operator.
596      * - `tokenId` must exist.
597      *
598      * Emits an {Approval} event.
599      */
600     function approve(address to, uint256 tokenId) external;
601 
602     /**
603      * @dev Approve or remove `operator` as an operator for the caller.
604      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
605      *
606      * Requirements:
607      *
608      * - The `operator` cannot be the caller.
609      *
610      * Emits an {ApprovalForAll} event.
611      */
612     function setApprovalForAll(address operator, bool _approved) external;
613 
614     /**
615      * @dev Returns the account approved for `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function getApproved(uint256 tokenId) external view returns (address operator);
622 
623     /**
624      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
625      *
626      * See {setApprovalForAll}
627      */
628     function isApprovedForAll(address owner, address operator) external view returns (bool);
629 
630     // ==============================
631     //        IERC721Metadata
632     // ==============================
633 
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() external view returns (string memory);
638 
639     /**
640      * @dev Returns the token collection symbol.
641      */
642     function symbol() external view returns (string memory);
643 
644     /**
645      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
646      */
647     function tokenURI(uint256 tokenId) external view returns (string memory);
648 
649     // ==============================
650     //            IERC2309
651     // ==============================
652 
653     /**
654      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
655      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
656      */
657     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
658 }
659 
660 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
661 
662 
663 // ERC721A Contracts v4.1.0
664 // Creator: Chiru Labs
665 
666 pragma solidity ^0.8.4;
667 
668 
669 /**
670  * @dev Interface of an ERC721ABurnable compliant contract.
671  */
672 interface IERC721ABurnable is IERC721A {
673     /**
674      * @dev Burns `tokenId`. See {ERC721A-_burn}.
675      *
676      * Requirements:
677      *
678      * - The caller must own `tokenId` or be an approved operator.
679      */
680     function burn(uint256 tokenId) external;
681 }
682 
683 // File: erc721a/contracts/ERC721A.sol
684 
685 
686 // ERC721A Contracts v4.1.0
687 // Creator: Chiru Labs
688 
689 pragma solidity ^0.8.4;
690 
691 
692 /**
693  * @dev ERC721 token receiver interface.
694  */
695 interface ERC721A__IERC721Receiver {
696     function onERC721Received(
697         address operator,
698         address from,
699         uint256 tokenId,
700         bytes calldata data
701     ) external returns (bytes4);
702 }
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
706  * including the Metadata extension. Built to optimize for lower gas during batch mints.
707  *
708  * Assumes serials are sequentially minted starting at `_startTokenId()`
709  * (defaults to 0, e.g. 0, 1, 2, 3..).
710  *
711  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
712  *
713  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
714  */
715 contract ERC721A is IERC721A {
716     // Mask of an entry in packed address data.
717     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
718 
719     // The bit position of `numberMinted` in packed address data.
720     uint256 private constant BITPOS_NUMBER_MINTED = 64;
721 
722     // The bit position of `numberBurned` in packed address data.
723     uint256 private constant BITPOS_NUMBER_BURNED = 128;
724 
725     // The bit position of `aux` in packed address data.
726     uint256 private constant BITPOS_AUX = 192;
727 
728     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
729     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
730 
731     // The bit position of `startTimestamp` in packed ownership.
732     uint256 private constant BITPOS_START_TIMESTAMP = 160;
733 
734     // The bit mask of the `burned` bit in packed ownership.
735     uint256 private constant BITMASK_BURNED = 1 << 224;
736 
737     // The bit position of the `nextInitialized` bit in packed ownership.
738     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
739 
740     // The bit mask of the `nextInitialized` bit in packed ownership.
741     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
742 
743     // The bit position of `extraData` in packed ownership.
744     uint256 private constant BITPOS_EXTRA_DATA = 232;
745 
746     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
747     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
748 
749     // The mask of the lower 160 bits for addresses.
750     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
751 
752     // The maximum `quantity` that can be minted with `_mintERC2309`.
753     // This limit is to prevent overflows on the address data entries.
754     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
755     // is required to cause an overflow, which is unrealistic.
756     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
757 
758     // The tokenId of the next token to be minted.
759     uint256 private _currentIndex;
760 
761     // The number of tokens burned.
762     uint256 private _burnCounter;
763 
764     // Token name
765     string private _name;
766 
767     // Token symbol
768     string private _symbol;
769 
770     // Mapping from token ID to ownership details
771     // An empty struct value does not necessarily mean the token is unowned.
772     // See `_packedOwnershipOf` implementation for details.
773     //
774     // Bits Layout:
775     // - [0..159]   `addr`
776     // - [160..223] `startTimestamp`
777     // - [224]      `burned`
778     // - [225]      `nextInitialized`
779     // - [232..255] `extraData`
780     mapping(uint256 => uint256) private _packedOwnerships;
781 
782     // Mapping owner address to address data.
783     //
784     // Bits Layout:
785     // - [0..63]    `balance`
786     // - [64..127]  `numberMinted`
787     // - [128..191] `numberBurned`
788     // - [192..255] `aux`
789     mapping(address => uint256) private _packedAddressData;
790 
791     // Mapping from token ID to approved address.
792     mapping(uint256 => address) private _tokenApprovals;
793 
794     // Mapping from owner to operator approvals
795     mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797     constructor(string memory name_, string memory symbol_) {
798         _name = name_;
799         _symbol = symbol_;
800         _currentIndex = _startTokenId();
801     }
802 
803     /**
804      * @dev Returns the starting token ID.
805      * To change the starting token ID, please override this function.
806      */
807     function _startTokenId() internal view virtual returns (uint256) {
808         return 0;
809     }
810 
811     /**
812      * @dev Returns the next token ID to be minted.
813      */
814     function _nextTokenId() internal view returns (uint256) {
815         return _currentIndex;
816     }
817 
818     /**
819      * @dev Returns the total number of tokens in existence.
820      * Burned tokens will reduce the count.
821      * To get the total number of tokens minted, please see `_totalMinted`.
822      */
823     function totalSupply() public view override returns (uint256) {
824         // Counter underflow is impossible as _burnCounter cannot be incremented
825         // more than `_currentIndex - _startTokenId()` times.
826         unchecked {
827             return _currentIndex - _burnCounter - _startTokenId();
828         }
829     }
830 
831     /**
832      * @dev Returns the total amount of tokens minted in the contract.
833      */
834     function _totalMinted() internal view returns (uint256) {
835         // Counter underflow is impossible as _currentIndex does not decrement,
836         // and it is initialized to `_startTokenId()`
837         unchecked {
838             return _currentIndex - _startTokenId();
839         }
840     }
841 
842     /**
843      * @dev Returns the total number of tokens burned.
844      */
845     function _totalBurned() internal view returns (uint256) {
846         return _burnCounter;
847     }
848 
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
853         // The interface IDs are constants representing the first 4 bytes of the XOR of
854         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
855         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
856         return
857             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
858             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
859             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
860     }
861 
862     /**
863      * @dev See {IERC721-balanceOf}.
864      */
865     function balanceOf(address owner) public view override returns (uint256) {
866         if (owner == address(0)) revert BalanceQueryForZeroAddress();
867         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
868     }
869 
870     /**
871      * Returns the number of tokens minted by `owner`.
872      */
873     function _numberMinted(address owner) internal view returns (uint256) {
874         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
875     }
876 
877     /**
878      * Returns the number of tokens burned by or on behalf of `owner`.
879      */
880     function _numberBurned(address owner) internal view returns (uint256) {
881         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
882     }
883 
884     /**
885      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
886      */
887     function _getAux(address owner) internal view returns (uint64) {
888         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
889     }
890 
891     /**
892      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
893      * If there are multiple variables, please pack them into a uint64.
894      */
895     function _setAux(address owner, uint64 aux) internal {
896         uint256 packed = _packedAddressData[owner];
897         uint256 auxCasted;
898         // Cast `aux` with assembly to avoid redundant masking.
899         assembly {
900             auxCasted := aux
901         }
902         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
903         _packedAddressData[owner] = packed;
904     }
905 
906     /**
907      * Returns the packed ownership data of `tokenId`.
908      */
909     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
910         uint256 curr = tokenId;
911 
912         unchecked {
913             if (_startTokenId() <= curr)
914                 if (curr < _currentIndex) {
915                     uint256 packed = _packedOwnerships[curr];
916                     // If not burned.
917                     if (packed & BITMASK_BURNED == 0) {
918                         // Invariant:
919                         // There will always be an ownership that has an address and is not burned
920                         // before an ownership that does not have an address and is not burned.
921                         // Hence, curr will not underflow.
922                         //
923                         // We can directly compare the packed value.
924                         // If the address is zero, packed is zero.
925                         while (packed == 0) {
926                             packed = _packedOwnerships[--curr];
927                         }
928                         return packed;
929                     }
930                 }
931         }
932         revert OwnerQueryForNonexistentToken();
933     }
934 
935     /**
936      * Returns the unpacked `TokenOwnership` struct from `packed`.
937      */
938     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
939         ownership.addr = address(uint160(packed));
940         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
941         ownership.burned = packed & BITMASK_BURNED != 0;
942         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
943     }
944 
945     /**
946      * Returns the unpacked `TokenOwnership` struct at `index`.
947      */
948     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
949         return _unpackedOwnership(_packedOwnerships[index]);
950     }
951 
952     /**
953      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
954      */
955     function _initializeOwnershipAt(uint256 index) internal {
956         if (_packedOwnerships[index] == 0) {
957             _packedOwnerships[index] = _packedOwnershipOf(index);
958         }
959     }
960 
961     /**
962      * Gas spent here starts off proportional to the maximum mint batch size.
963      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
964      */
965     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
966         return _unpackedOwnership(_packedOwnershipOf(tokenId));
967     }
968 
969     /**
970      * @dev Packs ownership data into a single uint256.
971      */
972     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
973         assembly {
974             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
975             owner := and(owner, BITMASK_ADDRESS)
976             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
977             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
978         }
979     }
980 
981     /**
982      * @dev See {IERC721-ownerOf}.
983      */
984     function ownerOf(uint256 tokenId) public view override returns (address) {
985         return address(uint160(_packedOwnershipOf(tokenId)));
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-name}.
990      */
991     function name() public view virtual override returns (string memory) {
992         return _name;
993     }
994 
995     /**
996      * @dev See {IERC721Metadata-symbol}.
997      */
998     function symbol() public view virtual override returns (string memory) {
999         return _symbol;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-tokenURI}.
1004      */
1005     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1006         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1007 
1008         string memory baseURI = _baseURI();
1009         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1010     }
1011 
1012     /**
1013      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1014      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1015      * by default, it can be overridden in child contracts.
1016      */
1017     function _baseURI() internal view virtual returns (string memory) {
1018         return '';
1019     }
1020 
1021     /**
1022      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1023      */
1024     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1025         // For branchless setting of the `nextInitialized` flag.
1026         assembly {
1027             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1028             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1029         }
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-approve}.
1034      */
1035     function approve(address to, uint256 tokenId) public override {
1036         address owner = ownerOf(tokenId);
1037 
1038         if (_msgSenderERC721A() != owner)
1039             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1040                 revert ApprovalCallerNotOwnerNorApproved();
1041             }
1042 
1043         _tokenApprovals[tokenId] = to;
1044         emit Approval(owner, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-getApproved}.
1049      */
1050     function getApproved(uint256 tokenId) public view override returns (address) {
1051         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1052 
1053         return _tokenApprovals[tokenId];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-setApprovalForAll}.
1058      */
1059     function setApprovalForAll(address operator, bool approved) public virtual override {
1060         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1061 
1062         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1063         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-isApprovedForAll}.
1068      */
1069     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1070         return _operatorApprovals[owner][operator];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         safeTransferFrom(from, to, tokenId, '');
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-safeTransferFrom}.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) public virtual override {
1093         transferFrom(from, to, tokenId);
1094         if (to.code.length != 0)
1095             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1096                 revert TransferToNonERC721ReceiverImplementer();
1097             }
1098     }
1099 
1100     /**
1101      * @dev Returns whether `tokenId` exists.
1102      *
1103      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1104      *
1105      * Tokens start existing when they are minted (`_mint`),
1106      */
1107     function _exists(uint256 tokenId) internal view returns (bool) {
1108         return
1109             _startTokenId() <= tokenId &&
1110             tokenId < _currentIndex && // If within bounds,
1111             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1112     }
1113 
1114     /**
1115      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1116      */
1117     function _safeMint(address to, uint256 quantity) internal {
1118         _safeMint(to, quantity, '');
1119     }
1120 
1121     /**
1122      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - If `to` refers to a smart contract, it must implement
1127      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * See {_mint}.
1131      *
1132      * Emits a {Transfer} event for each mint.
1133      */
1134     function _safeMint(
1135         address to,
1136         uint256 quantity,
1137         bytes memory _data
1138     ) internal {
1139         _mint(to, quantity);
1140 
1141         unchecked {
1142             if (to.code.length != 0) {
1143                 uint256 end = _currentIndex;
1144                 uint256 index = end - quantity;
1145                 do {
1146                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1147                         revert TransferToNonERC721ReceiverImplementer();
1148                     }
1149                 } while (index < end);
1150                 // Reentrancy protection.
1151                 if (_currentIndex != end) revert();
1152             }
1153         }
1154     }
1155 
1156     /**
1157      * @dev Mints `quantity` tokens and transfers them to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `to` cannot be the zero address.
1162      * - `quantity` must be greater than 0.
1163      *
1164      * Emits a {Transfer} event for each mint.
1165      */
1166     function _mint(address to, uint256 quantity) internal {
1167         uint256 startTokenId = _currentIndex;
1168         if (to == address(0)) revert MintToZeroAddress();
1169         if (quantity == 0) revert MintZeroQuantity();
1170 
1171         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1172 
1173         // Overflows are incredibly unrealistic.
1174         // `balance` and `numberMinted` have a maximum limit of 2**64.
1175         // `tokenId` has a maximum limit of 2**256.
1176         unchecked {
1177             // Updates:
1178             // - `balance += quantity`.
1179             // - `numberMinted += quantity`.
1180             //
1181             // We can directly add to the `balance` and `numberMinted`.
1182             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1183 
1184             // Updates:
1185             // - `address` to the owner.
1186             // - `startTimestamp` to the timestamp of minting.
1187             // - `burned` to `false`.
1188             // - `nextInitialized` to `quantity == 1`.
1189             _packedOwnerships[startTokenId] = _packOwnershipData(
1190                 to,
1191                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1192             );
1193 
1194             uint256 tokenId = startTokenId;
1195             uint256 end = startTokenId + quantity;
1196             do {
1197                 emit Transfer(address(0), to, tokenId++);
1198             } while (tokenId < end);
1199 
1200             _currentIndex = end;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * This function is intended for efficient minting only during contract creation.
1209      *
1210      * It emits only one {ConsecutiveTransfer} as defined in
1211      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1212      * instead of a sequence of {Transfer} event(s).
1213      *
1214      * Calling this function outside of contract creation WILL make your contract
1215      * non-compliant with the ERC721 standard.
1216      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1217      * {ConsecutiveTransfer} event is only permissible during contract creation.
1218      *
1219      * Requirements:
1220      *
1221      * - `to` cannot be the zero address.
1222      * - `quantity` must be greater than 0.
1223      *
1224      * Emits a {ConsecutiveTransfer} event.
1225      */
1226     function _mintERC2309(address to, uint256 quantity) internal {
1227         uint256 startTokenId = _currentIndex;
1228         if (to == address(0)) revert MintToZeroAddress();
1229         if (quantity == 0) revert MintZeroQuantity();
1230         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1231 
1232         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1235         unchecked {
1236             // Updates:
1237             // - `balance += quantity`.
1238             // - `numberMinted += quantity`.
1239             //
1240             // We can directly add to the `balance` and `numberMinted`.
1241             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1242 
1243             // Updates:
1244             // - `address` to the owner.
1245             // - `startTimestamp` to the timestamp of minting.
1246             // - `burned` to `false`.
1247             // - `nextInitialized` to `quantity == 1`.
1248             _packedOwnerships[startTokenId] = _packOwnershipData(
1249                 to,
1250                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1251             );
1252 
1253             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1254 
1255             _currentIndex = startTokenId + quantity;
1256         }
1257         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1258     }
1259 
1260     /**
1261      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1262      */
1263     function _getApprovedAddress(uint256 tokenId)
1264         private
1265         view
1266         returns (uint256 approvedAddressSlot, address approvedAddress)
1267     {
1268         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1269         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1270         assembly {
1271             // Compute the slot.
1272             mstore(0x00, tokenId)
1273             mstore(0x20, tokenApprovalsPtr.slot)
1274             approvedAddressSlot := keccak256(0x00, 0x40)
1275             // Load the slot's value from storage.
1276             approvedAddress := sload(approvedAddressSlot)
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1282      */
1283     function _isOwnerOrApproved(
1284         address approvedAddress,
1285         address from,
1286         address msgSender
1287     ) private pure returns (bool result) {
1288         assembly {
1289             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1290             from := and(from, BITMASK_ADDRESS)
1291             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1292             msgSender := and(msgSender, BITMASK_ADDRESS)
1293             // `msgSender == from || msgSender == approvedAddress`.
1294             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1295         }
1296     }
1297 
1298     /**
1299      * @dev Transfers `tokenId` from `from` to `to`.
1300      *
1301      * Requirements:
1302      *
1303      * - `to` cannot be the zero address.
1304      * - `tokenId` token must be owned by `from`.
1305      *
1306      * Emits a {Transfer} event.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public virtual override {
1313         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1314 
1315         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1316 
1317         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1318 
1319         // The nested ifs save around 20+ gas over a compound boolean condition.
1320         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1321             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1322 
1323         if (to == address(0)) revert TransferToZeroAddress();
1324 
1325         _beforeTokenTransfers(from, to, tokenId, 1);
1326 
1327         // Clear approvals from the previous owner.
1328         assembly {
1329             if approvedAddress {
1330                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1331                 sstore(approvedAddressSlot, 0)
1332             }
1333         }
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1338         unchecked {
1339             // We can directly increment and decrement the balances.
1340             --_packedAddressData[from]; // Updates: `balance -= 1`.
1341             ++_packedAddressData[to]; // Updates: `balance += 1`.
1342 
1343             // Updates:
1344             // - `address` to the next owner.
1345             // - `startTimestamp` to the timestamp of transfering.
1346             // - `burned` to `false`.
1347             // - `nextInitialized` to `true`.
1348             _packedOwnerships[tokenId] = _packOwnershipData(
1349                 to,
1350                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1351             );
1352 
1353             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1354             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1355                 uint256 nextTokenId = tokenId + 1;
1356                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1357                 if (_packedOwnerships[nextTokenId] == 0) {
1358                     // If the next slot is within bounds.
1359                     if (nextTokenId != _currentIndex) {
1360                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1361                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1362                     }
1363                 }
1364             }
1365         }
1366 
1367         emit Transfer(from, to, tokenId);
1368         _afterTokenTransfers(from, to, tokenId, 1);
1369     }
1370 
1371     /**
1372      * @dev Equivalent to `_burn(tokenId, false)`.
1373      */
1374     function _burn(uint256 tokenId) internal virtual {
1375         _burn(tokenId, false);
1376     }
1377 
1378     /**
1379      * @dev Destroys `tokenId`.
1380      * The approval is cleared when the token is burned.
1381      *
1382      * Requirements:
1383      *
1384      * - `tokenId` must exist.
1385      *
1386      * Emits a {Transfer} event.
1387      */
1388     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1389         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1390 
1391         address from = address(uint160(prevOwnershipPacked));
1392 
1393         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1394 
1395         if (approvalCheck) {
1396             // The nested ifs save around 20+ gas over a compound boolean condition.
1397             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1398                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1399         }
1400 
1401         _beforeTokenTransfers(from, address(0), tokenId, 1);
1402 
1403         // Clear approvals from the previous owner.
1404         assembly {
1405             if approvedAddress {
1406                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1407                 sstore(approvedAddressSlot, 0)
1408             }
1409         }
1410 
1411         // Underflow of the sender's balance is impossible because we check for
1412         // ownership above and the recipient's balance can't realistically overflow.
1413         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1414         unchecked {
1415             // Updates:
1416             // - `balance -= 1`.
1417             // - `numberBurned += 1`.
1418             //
1419             // We can directly decrement the balance, and increment the number burned.
1420             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1421             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1422 
1423             // Updates:
1424             // - `address` to the last owner.
1425             // - `startTimestamp` to the timestamp of burning.
1426             // - `burned` to `true`.
1427             // - `nextInitialized` to `true`.
1428             _packedOwnerships[tokenId] = _packOwnershipData(
1429                 from,
1430                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1431             );
1432 
1433             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1434             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1435                 uint256 nextTokenId = tokenId + 1;
1436                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1437                 if (_packedOwnerships[nextTokenId] == 0) {
1438                     // If the next slot is within bounds.
1439                     if (nextTokenId != _currentIndex) {
1440                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1441                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1442                     }
1443                 }
1444             }
1445         }
1446 
1447         emit Transfer(from, address(0), tokenId);
1448         _afterTokenTransfers(from, address(0), tokenId, 1);
1449 
1450         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1451         unchecked {
1452             _burnCounter++;
1453         }
1454     }
1455 
1456     /**
1457      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1458      *
1459      * @param from address representing the previous owner of the given token ID
1460      * @param to target address that will receive the tokens
1461      * @param tokenId uint256 ID of the token to be transferred
1462      * @param _data bytes optional data to send along with the call
1463      * @return bool whether the call correctly returned the expected magic value
1464      */
1465     function _checkContractOnERC721Received(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory _data
1470     ) private returns (bool) {
1471         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1472             bytes4 retval
1473         ) {
1474             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1475         } catch (bytes memory reason) {
1476             if (reason.length == 0) {
1477                 revert TransferToNonERC721ReceiverImplementer();
1478             } else {
1479                 assembly {
1480                     revert(add(32, reason), mload(reason))
1481                 }
1482             }
1483         }
1484     }
1485 
1486     /**
1487      * @dev Directly sets the extra data for the ownership data `index`.
1488      */
1489     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1490         uint256 packed = _packedOwnerships[index];
1491         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1492         uint256 extraDataCasted;
1493         // Cast `extraData` with assembly to avoid redundant masking.
1494         assembly {
1495             extraDataCasted := extraData
1496         }
1497         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1498         _packedOwnerships[index] = packed;
1499     }
1500 
1501     /**
1502      * @dev Returns the next extra data for the packed ownership data.
1503      * The returned result is shifted into position.
1504      */
1505     function _nextExtraData(
1506         address from,
1507         address to,
1508         uint256 prevOwnershipPacked
1509     ) private view returns (uint256) {
1510         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1511         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1512     }
1513 
1514     /**
1515      * @dev Called during each token transfer to set the 24bit `extraData` field.
1516      * Intended to be overridden by the cosumer contract.
1517      *
1518      * `previousExtraData` - the value of `extraData` before transfer.
1519      *
1520      * Calling conditions:
1521      *
1522      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1523      * transferred to `to`.
1524      * - When `from` is zero, `tokenId` will be minted for `to`.
1525      * - When `to` is zero, `tokenId` will be burned by `from`.
1526      * - `from` and `to` are never both zero.
1527      */
1528     function _extraData(
1529         address from,
1530         address to,
1531         uint24 previousExtraData
1532     ) internal view virtual returns (uint24) {}
1533 
1534     /**
1535      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1536      * This includes minting.
1537      * And also called before burning one token.
1538      *
1539      * startTokenId - the first token id to be transferred
1540      * quantity - the amount to be transferred
1541      *
1542      * Calling conditions:
1543      *
1544      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1545      * transferred to `to`.
1546      * - When `from` is zero, `tokenId` will be minted for `to`.
1547      * - When `to` is zero, `tokenId` will be burned by `from`.
1548      * - `from` and `to` are never both zero.
1549      */
1550     function _beforeTokenTransfers(
1551         address from,
1552         address to,
1553         uint256 startTokenId,
1554         uint256 quantity
1555     ) internal virtual {}
1556 
1557     /**
1558      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1559      * This includes minting.
1560      * And also called after one token has been burned.
1561      *
1562      * startTokenId - the first token id to be transferred
1563      * quantity - the amount to be transferred
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1568      * transferred to `to`.
1569      * - When `from` is zero, `tokenId` has been minted for `to`.
1570      * - When `to` is zero, `tokenId` has been burned by `from`.
1571      * - `from` and `to` are never both zero.
1572      */
1573     function _afterTokenTransfers(
1574         address from,
1575         address to,
1576         uint256 startTokenId,
1577         uint256 quantity
1578     ) internal virtual {}
1579 
1580     /**
1581      * @dev Returns the message sender (defaults to `msg.sender`).
1582      *
1583      * If you are writing GSN compatible contracts, you need to override this function.
1584      */
1585     function _msgSenderERC721A() internal view virtual returns (address) {
1586         return msg.sender;
1587     }
1588 
1589     /**
1590      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1591      */
1592     function _toString(uint256 value) internal pure returns (string memory ptr) {
1593         assembly {
1594             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1595             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1596             // We will need 1 32-byte word to store the length,
1597             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1598             ptr := add(mload(0x40), 128)
1599             // Update the free memory pointer to allocate.
1600             mstore(0x40, ptr)
1601 
1602             // Cache the end of the memory to calculate the length later.
1603             let end := ptr
1604 
1605             // We write the string from the rightmost digit to the leftmost digit.
1606             // The following is essentially a do-while loop that also handles the zero case.
1607             // Costs a bit more than early returning for the zero case,
1608             // but cheaper in terms of deployment and overall runtime costs.
1609             for {
1610                 // Initialize and perform the first pass without check.
1611                 let temp := value
1612                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1613                 ptr := sub(ptr, 1)
1614                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1615                 mstore8(ptr, add(48, mod(temp, 10)))
1616                 temp := div(temp, 10)
1617             } temp {
1618                 // Keep dividing `temp` until zero.
1619                 temp := div(temp, 10)
1620             } {
1621                 // Body of the for loop.
1622                 ptr := sub(ptr, 1)
1623                 mstore8(ptr, add(48, mod(temp, 10)))
1624             }
1625 
1626             let length := sub(end, ptr)
1627             // Move the pointer 32 bytes leftwards to make room for the length.
1628             ptr := sub(ptr, 32)
1629             // Store the length.
1630             mstore(ptr, length)
1631         }
1632     }
1633 }
1634 
1635 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1636 
1637 
1638 // ERC721A Contracts v4.1.0
1639 // Creator: Chiru Labs
1640 
1641 pragma solidity ^0.8.4;
1642 
1643 
1644 
1645 /**
1646  * @title ERC721A Burnable Token
1647  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1648  */
1649 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1650     /**
1651      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1652      *
1653      * Requirements:
1654      *
1655      * - The caller must own `tokenId` or be an approved operator.
1656      */
1657     function burn(uint256 tokenId) public virtual override {
1658         _burn(tokenId, true);
1659     }
1660 }
1661 
1662 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1663 
1664 
1665 // ERC721A Contracts v4.1.0
1666 // Creator: Chiru Labs
1667 
1668 pragma solidity ^0.8.4;
1669 
1670 
1671 /**
1672  * @dev Interface of an ERC721AQueryable compliant contract.
1673  */
1674 interface IERC721AQueryable is IERC721A {
1675     /**
1676      * Invalid query range (`start` >= `stop`).
1677      */
1678     error InvalidQueryRange();
1679 
1680     /**
1681      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1682      *
1683      * If the `tokenId` is out of bounds:
1684      *   - `addr` = `address(0)`
1685      *   - `startTimestamp` = `0`
1686      *   - `burned` = `false`
1687      *
1688      * If the `tokenId` is burned:
1689      *   - `addr` = `<Address of owner before token was burned>`
1690      *   - `startTimestamp` = `<Timestamp when token was burned>`
1691      *   - `burned = `true`
1692      *
1693      * Otherwise:
1694      *   - `addr` = `<Address of owner>`
1695      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1696      *   - `burned = `false`
1697      */
1698     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1699 
1700     /**
1701      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1702      * See {ERC721AQueryable-explicitOwnershipOf}
1703      */
1704     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1705 
1706     /**
1707      * @dev Returns an array of token IDs owned by `owner`,
1708      * in the range [`start`, `stop`)
1709      * (i.e. `start <= tokenId < stop`).
1710      *
1711      * This function allows for tokens to be queried if the collection
1712      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1713      *
1714      * Requirements:
1715      *
1716      * - `start` < `stop`
1717      */
1718     function tokensOfOwnerIn(
1719         address owner,
1720         uint256 start,
1721         uint256 stop
1722     ) external view returns (uint256[] memory);
1723 
1724     /**
1725      * @dev Returns an array of token IDs owned by `owner`.
1726      *
1727      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1728      * It is meant to be called off-chain.
1729      *
1730      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1731      * multiple smaller scans if the collection is large enough to cause
1732      * an out-of-gas error (10K pfp collections should be fine).
1733      */
1734     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1735 }
1736 
1737 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1738 
1739 
1740 // ERC721A Contracts v4.1.0
1741 // Creator: Chiru Labs
1742 
1743 pragma solidity ^0.8.4;
1744 
1745 
1746 
1747 /**
1748  * @title ERC721A Queryable
1749  * @dev ERC721A subclass with convenience query functions.
1750  */
1751 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1752     /**
1753      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1754      *
1755      * If the `tokenId` is out of bounds:
1756      *   - `addr` = `address(0)`
1757      *   - `startTimestamp` = `0`
1758      *   - `burned` = `false`
1759      *   - `extraData` = `0`
1760      *
1761      * If the `tokenId` is burned:
1762      *   - `addr` = `<Address of owner before token was burned>`
1763      *   - `startTimestamp` = `<Timestamp when token was burned>`
1764      *   - `burned = `true`
1765      *   - `extraData` = `<Extra data when token was burned>`
1766      *
1767      * Otherwise:
1768      *   - `addr` = `<Address of owner>`
1769      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1770      *   - `burned = `false`
1771      *   - `extraData` = `<Extra data at start of ownership>`
1772      */
1773     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1774         TokenOwnership memory ownership;
1775         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1776             return ownership;
1777         }
1778         ownership = _ownershipAt(tokenId);
1779         if (ownership.burned) {
1780             return ownership;
1781         }
1782         return _ownershipOf(tokenId);
1783     }
1784 
1785     /**
1786      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1787      * See {ERC721AQueryable-explicitOwnershipOf}
1788      */
1789     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1790         unchecked {
1791             uint256 tokenIdsLength = tokenIds.length;
1792             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1793             for (uint256 i; i != tokenIdsLength; ++i) {
1794                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1795             }
1796             return ownerships;
1797         }
1798     }
1799 
1800     /**
1801      * @dev Returns an array of token IDs owned by `owner`,
1802      * in the range [`start`, `stop`)
1803      * (i.e. `start <= tokenId < stop`).
1804      *
1805      * This function allows for tokens to be queried if the collection
1806      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1807      *
1808      * Requirements:
1809      *
1810      * - `start` < `stop`
1811      */
1812     function tokensOfOwnerIn(
1813         address owner,
1814         uint256 start,
1815         uint256 stop
1816     ) external view override returns (uint256[] memory) {
1817         unchecked {
1818             if (start >= stop) revert InvalidQueryRange();
1819             uint256 tokenIdsIdx;
1820             uint256 stopLimit = _nextTokenId();
1821             // Set `start = max(start, _startTokenId())`.
1822             if (start < _startTokenId()) {
1823                 start = _startTokenId();
1824             }
1825             // Set `stop = min(stop, stopLimit)`.
1826             if (stop > stopLimit) {
1827                 stop = stopLimit;
1828             }
1829             uint256 tokenIdsMaxLength = balanceOf(owner);
1830             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1831             // to cater for cases where `balanceOf(owner)` is too big.
1832             if (start < stop) {
1833                 uint256 rangeLength = stop - start;
1834                 if (rangeLength < tokenIdsMaxLength) {
1835                     tokenIdsMaxLength = rangeLength;
1836                 }
1837             } else {
1838                 tokenIdsMaxLength = 0;
1839             }
1840             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1841             if (tokenIdsMaxLength == 0) {
1842                 return tokenIds;
1843             }
1844             // We need to call `explicitOwnershipOf(start)`,
1845             // because the slot at `start` may not be initialized.
1846             TokenOwnership memory ownership = explicitOwnershipOf(start);
1847             address currOwnershipAddr;
1848             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1849             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1850             if (!ownership.burned) {
1851                 currOwnershipAddr = ownership.addr;
1852             }
1853             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1854                 ownership = _ownershipAt(i);
1855                 if (ownership.burned) {
1856                     continue;
1857                 }
1858                 if (ownership.addr != address(0)) {
1859                     currOwnershipAddr = ownership.addr;
1860                 }
1861                 if (currOwnershipAddr == owner) {
1862                     tokenIds[tokenIdsIdx++] = i;
1863                 }
1864             }
1865             // Downsize the array to fit.
1866             assembly {
1867                 mstore(tokenIds, tokenIdsIdx)
1868             }
1869             return tokenIds;
1870         }
1871     }
1872 
1873     /**
1874      * @dev Returns an array of token IDs owned by `owner`.
1875      *
1876      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1877      * It is meant to be called off-chain.
1878      *
1879      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1880      * multiple smaller scans if the collection is large enough to cause
1881      * an out-of-gas error (10K pfp collections should be fine).
1882      */
1883     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1884         unchecked {
1885             uint256 tokenIdsIdx;
1886             address currOwnershipAddr;
1887             uint256 tokenIdsLength = balanceOf(owner);
1888             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1889             TokenOwnership memory ownership;
1890             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1891                 ownership = _ownershipAt(i);
1892                 if (ownership.burned) {
1893                     continue;
1894                 }
1895                 if (ownership.addr != address(0)) {
1896                     currOwnershipAddr = ownership.addr;
1897                 }
1898                 if (currOwnershipAddr == owner) {
1899                     tokenIds[tokenIdsIdx++] = i;
1900                 }
1901             }
1902             return tokenIds;
1903         }
1904     }
1905 }
1906 
1907 // File: contracts/SmartContract.sol
1908 
1909 
1910 pragma solidity ^0.8.15;
1911 
1912 
1913 
1914 
1915 
1916 
1917 
1918 
1919 contract SmartContract is ERC721AQueryable, ERC721ABurnable, ReentrancyGuard, Ownable {
1920 
1921     using StringsUpgradeable for uint256;
1922 
1923     // IPFS Information
1924     string public baseURI;
1925     string public baseExtension = ".json";
1926     string notRevealedUri;
1927 
1928     // Collection and Pricing Information
1929     uint256 public MAX_SUPPLY = 10000;
1930     uint256 public MINT_PRICE = 0.03 ether;
1931 
1932     // MINT LIMIT
1933     uint256 public MAX_MINT_PER_TRANSAC = 69;
1934 
1935     // Mint Logistics
1936     bool public paused = true;
1937     bool public revealed = false;
1938     bool public isPublicMint = false;
1939 
1940     // Claim & Merkle Proof
1941     bool public claimActive = true;
1942     bytes32 public merkleRoot;
1943     mapping(address => uint256) public addressClaimedBalance;
1944 
1945     // Internal
1946     function _baseURI() internal view override returns (string memory) {
1947         return baseURI;
1948     }
1949     function _startTokenId() internal pure override returns (uint256) {
1950         return 1;
1951     }
1952 
1953     // Team addresses
1954     address t1 = 0x25661f02D686714DC5ba63B7915774654e8E5538;
1955     address t2 = 0x3C087276127c0BaB17c00aDEdeC1145E34788403;
1956     address t3 = 0x6231a4342936bBD143Ae01587FbB8cd7eedE63E8;
1957     address t4 = 0x4104fbE93BCacfc4EF5683CF49ab07e5fE9E78ef; 
1958     address t5 = 0xE3248FF92B4B071d72Aeb0910Ae8588D68019A3e;
1959     address t6 = 0x610BE2Ba080A0f69E5787C826B7734274fcdb0f3;
1960     address t7 = 0xa8D0Dd2070d2874E0B185e2d42c5a6Cfa6971C26;
1961     address t8 = 0x9F38376129e766ee0A9Ba903f9A8D7425F6b8013;
1962     address t9 = 0x24d697a82b9ad433296c7B203a31846DAfae5079;
1963     address t10 = 0xDaCe8A59B8733e932957AC4A3101c80B87414BD0;
1964     address t11 = 0xeAb0798749b2Cd4B3E188Aa7fE37A410E554689F;
1965 
1966     address tGenesis = 0x8fd50896b8a7aE31B80EC47bc76Cf4bF2caC8FEc;
1967     address tSYI = 0x185E04b79ebBD224b71F4c09c07fdC8DdB441FF5;
1968 
1969     constructor(string memory _initBaseURI, string memory _initNotRevealedUri) ERC721A ("ProjectAtmosSYI", "AtmosSYI") {
1970 
1971         setBaseURI(_initBaseURI);
1972         setNotRevealedURI(_initNotRevealedUri);
1973 
1974         // Team get spam ===========;
1975         _safeMint(t1, 20);
1976         _safeMint(t2, 20);
1977         _safeMint(t3, 20);
1978         _safeMint(t4, 20);
1979         _safeMint(t5, 20);
1980         _safeMint(t6, 20);
1981         _safeMint(t7, 20);
1982         _safeMint(t8, 20);
1983         _safeMint(t9, 20);
1984         _safeMint(t10, 20);
1985         _safeMint(t11, 20);
1986 
1987         // Treasury get spam;
1988         _safeMint(tGenesis, 500);
1989         _safeMint(tSYI, 500);
1990 
1991         // Giveaway winners
1992         _safeMint(0x9CDF195f8B46eCBD64fb53757376382A6531b6cc, 1);
1993         _safeMint(0xc8bA45b6a65cad4438896c17732D168F9FA5De72, 1);
1994         _safeMint(0x7e9dC2B0049ff858E4f052a856fAfb0d64175CA3, 1);
1995         _safeMint(0x1769e601ee4B1Ff83154CFedc245472c0367aCa3, 1);
1996         _safeMint(0xa1650e384Af56848bC16c805897977539dD34588, 1);
1997         _safeMint(0x2b3403A9286037518aE698ea472fC641aE330689, 1);
1998         _safeMint(0x7d6e13E804FFeAF208A39C9507bbba0d37c397D3, 1);
1999         _safeMint(0x30F457BB9aFB8bEAd5a8fd8Eb29261302D5305a1, 1);
2000         _safeMint(0x2100D73a21e62631C62599e5C6C0d2AcE577c257, 1);
2001         _safeMint(0x6522e7e8797412a838F9452c8e3730BE439d4f8D, 1);
2002         _safeMint(0x39f7CCb1EA6838379c80f60e9a67880e96A0ab22, 1);
2003         _safeMint(0x37f41ad48b9a573bc7C72A778D4B689a0503e8CE, 1);
2004         _safeMint(0x2d5f3b8428a29117500E04248A2d8e27CBD1eEEB, 1);
2005     }
2006 
2007     // Claim Function ====================================================================
2008     function claim(bytes32[] memory merkleProof, bytes32 leaf, uint256 amount) external payable{
2009 
2010         if (msg.sender != owner()){
2011             require(!paused, "The contract is paused.");
2012             require(claimActive, "Claim is not open.");
2013             require(addressClaimedBalance[msg.sender] == 0, "Account already claimed.");
2014 
2015             // Merkle tree verification
2016             require(keccak256(abi.encodePacked(msg.sender, amount)) == leaf, "Credential is not clean.");
2017             require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Invalid Merkle Proof user is not in ATMOS snapshot.");
2018 
2019         }
2020 
2021         // Increment address record
2022         addressClaimedBalance[msg.sender] += amount;
2023         _safeMint(msg.sender, amount);
2024     }
2025 
2026     function isClaimQualified(bytes32[] memory merkleProof, bytes32 leaf, uint256 amount, address addr) public view returns (bool){
2027         if (keccak256(abi.encodePacked(addr, amount)) != leaf){
2028             return false;
2029         }
2030         if (!MerkleProof.verify(merkleProof, merkleRoot, leaf)){
2031             return false;
2032         }
2033         return true;
2034     }
2035 
2036     function isClaimed(address addr) public view returns(bool){
2037         if(addressClaimedBalance[addr] == 0){
2038             return false;
2039         }
2040         return true;
2041     }
2042 
2043     function claimBalance(address addr) public view returns(uint256){
2044         return addressClaimedBalance[addr];
2045     }
2046 
2047     
2048     // Mint Function ====================================================================
2049     function publicMint (uint256 quantity) external payable{
2050 
2051         require(isPublicMint, "Public mint is not open.");
2052         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left.");
2053 
2054         if (msg.sender != owner()){
2055             require(!paused, "The contract is paused.");
2056             require(quantity <= MAX_MINT_PER_TRANSAC, "Exceed max mint amount per transaction.");
2057             require(msg.value >= (MINT_PRICE * quantity), "Insufficient funds sent");
2058         }
2059 
2060         // Increment address record
2061         _safeMint(msg.sender, quantity);
2062     }
2063 
2064     // ==================================================================================
2065     // Token retrieve
2066     function tokenURI(uint256 tokenId) override(ERC721A, IERC721A) public view virtual returns(string memory){
2067         require(_exists(tokenId), "ERC721AMetadata: URI query for nonexistent token");
2068         if (!revealed){
2069             return string(abi.encodePacked(notRevealedUri, tokenId.toString(), baseExtension));
2070         }
2071         return string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension));
2072     }
2073 
2074     // Getters and Setters
2075     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2076         baseURI = _newBaseURI;
2077     }
2078     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2079         baseExtension = _newBaseExtension;
2080     }
2081     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2082         notRevealedUri = _notRevealedURI;
2083     }
2084     function setPaused(bool _bool) public onlyOwner{
2085         paused = _bool;
2086     }
2087     function setIsPublicMint(bool _bool) public onlyOwner{
2088         isPublicMint = _bool;
2089     }
2090     function setRevealed(bool _bool) public onlyOwner{
2091         revealed = _bool;
2092     }
2093     function setClaimActive(bool _bool) public onlyOwner{
2094         claimActive = _bool;
2095     }
2096     function setMintPrice(uint256 _newMintPrice) public onlyOwner{
2097         MINT_PRICE = _newMintPrice;
2098     }
2099     function setMaxMintPerTransac(uint256 limit) public onlyOwner{
2100         MAX_MINT_PER_TRANSAC = limit;
2101     }
2102     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2103         merkleRoot = _merkleRoot;
2104     }
2105     function getAddressClaimedBalance(address _userAddr) public view returns (uint256){
2106         return addressClaimedBalance[_userAddr];
2107     }
2108 
2109     // Withdraw
2110     function withdraw() external payable onlyOwner {
2111         (bool hs, ) = payable(tSYI).call{value: address(this).balance}("");
2112         if (!hs){
2113             payable(owner()).transfer(address(this).balance);
2114         }
2115     }
2116 
2117 }