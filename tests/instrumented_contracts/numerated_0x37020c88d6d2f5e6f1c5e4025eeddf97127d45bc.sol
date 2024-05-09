1 // File: contracts/IMeta.sol
2 
3 
4 
5 //........................................................................................................
6 //.......................................SSSSSS..................OOOOOO...................................
7 //.EEEEEEEEEEE.ENNN....NNN.NNTTTTTTTTT..SSSSSSSS..SSTTTTTTTTT..OOOOOOOOO..OOOWW..WWWW...WWWWWNNNN...NNNN..
8 //.EEEEEEEEEEE.ENNNN...NNN.NNTTTTTTTTT.SSSSSSSSSS.SSTTTTTTTTT.TOOOOOOOOOO..OOWW..WWWWW..WWWWWNNNNN..NNNN..
9 //.EEEEEEEEEEE.ENNNN...NNN.NNTTTTTTTTT.SSSSSSSSSS.SSTTTTTTTTT.TOOOOOOOOOOO.OOWW..WWWWW.WWWWWWNNNNN..NNNN..
10 //.EEEE........ENNNNN..NNN.....TTTT...TSSS...SSSSS....TTTT...TTOOO....OOOO.OOWW.WWWWWW.WWWW.WNNNNNN.NNNN..
11 //.EEEEEEEEEE..ENNNNNN.NNN.....TTTT...TSSSSS..........TTTT...TTOO.....OOOO..OWWWWWWWWW.WWWW.WNNNNNN.NNNN..
12 //.EEEEEEEEEE..ENNNNNN.NNN.....TTTT....SSSSSSSSS......TTTT...TTOO......OOOO.OWWWWWWWWW.WWWW.WNNNNNNNNNNN..
13 //.EEEEEEEEEE..ENN.NNNNNNN.....TTTT....SSSSSSSSSS.....TTTT...TTOO......OOOO.OWWWWWWWWWWWWW..WNNNNNNNNNNN..
14 //.EEEEEEEEEE..ENN.NNNNNNN.....TTTT......SSSSSSSSS....TTTT...TTOO......OOOO.OWWWWWWWWWWWWW..WNNN.NNNNNNN..
15 //.EEEE........ENN..NNNNNN.....TTTT...TSSS..SSSSSS....TTTT...TTOO.....OOOO...WWWWWW.WWWWWW..WNNN.NNNNNNN..
16 //.EEEE........ENN..NNNNNN.....TTTT...TSSS....SSSS....TTTT...TTOOO....OOOO...WWWWWW.WWWWWW..WNNN..NNNNNN..
17 //.EEEEEEEEEEE.ENN...NNNNN.....TTTT...TSSSSSSSSSSS....TTTT....TOOOOOOOOOOO...WWWWW..WWWWW...WNNN...NNNNN..
18 //.EEEEEEEEEEE.ENN...NNNNN.....TTTT....SSSSSSSSSS.....TTTT.....OOOOOOOOOO.....WWWW..WWWWW...WNNN...NNNNN..
19 //.EEEEEEEEEEE.ENN....NNNN.....TTTT.....SSSSSSSSS.....TTTT.....OOOOOOOOO......WWWW..WWWWW...WNNN....NNNN..
20 //.......................................SSSSSS..................OOOOOO...................................
21 //........................................................................................................
22 //creator : @entstownwtf
23 //website : ents.town
24 
25 pragma solidity ^0.8.0;
26 
27 interface IMeta 
28 {
29     function getMetadata(uint256 tokenId) external view returns (string memory);
30 }
31 // File: @openzeppelin/contracts/utils/Strings.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev String operations.
40  */
41 library Strings {
42     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
71      */
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
87      */
88     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
89         bytes memory buffer = new bytes(2 * length + 2);
90         buffer[0] = "0";
91         buffer[1] = "x";
92         for (uint256 i = 2 * length + 1; i > 1; --i) {
93             buffer[i] = _HEX_SYMBOLS[value & 0xf];
94             value >>= 4;
95         }
96         require(value == 0, "Strings: hex length insufficient");
97         return string(buffer);
98     }
99 }
100 
101 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev These functions deal with verification of Merkle Trees proofs.
110  *
111  * The proofs can be generated using the JavaScript library
112  * https://github.com/miguelmota/merkletreejs[merkletreejs].
113  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
114  *
115  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
116  *
117  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
118  * hashing, or use a hash function other than keccak256 for hashing leaves.
119  * This is because the concatenation of a sorted pair of internal nodes in
120  * the merkle tree could be reinterpreted as a leaf value.
121  */
122 library MerkleProof {
123     /**
124      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
125      * defined by `root`. For this, a `proof` must be provided, containing
126      * sibling hashes on the branch from the leaf to the root of the tree. Each
127      * pair of leaves and each pair of pre-images are assumed to be sorted.
128      */
129     function verify(
130         bytes32[] memory proof,
131         bytes32 root,
132         bytes32 leaf
133     ) internal pure returns (bool) {
134         return processProof(proof, leaf) == root;
135     }
136 
137     /**
138      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
139      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
140      * hash matches the root of the tree. When processing the proof, the pairs
141      * of leafs & pre-images are assumed to be sorted.
142      *
143      * _Available since v4.4._
144      */
145     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
146         bytes32 computedHash = leaf;
147         for (uint256 i = 0; i < proof.length; i++) {
148             bytes32 proofElement = proof[i];
149             if (computedHash <= proofElement) {
150                 // Hash(current computed hash + current element of the proof)
151                 computedHash = _efficientHash(computedHash, proofElement);
152             } else {
153                 // Hash(current element of the proof + current computed hash)
154                 computedHash = _efficientHash(proofElement, computedHash);
155             }
156         }
157         return computedHash;
158     }
159 
160     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
161         assembly {
162             mstore(0x00, a)
163             mstore(0x20, b)
164             value := keccak256(0x00, 0x40)
165         }
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Context.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 abstract contract Context {
187     function _msgSender() internal view virtual returns (address) {
188         return msg.sender;
189     }
190 
191     function _msgData() internal view virtual returns (bytes calldata) {
192         return msg.data;
193     }
194 }
195 
196 // File: @openzeppelin/contracts/security/Pausable.sol
197 
198 
199 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @dev Contract module which allows children to implement an emergency stop
206  * mechanism that can be triggered by an authorized account.
207  *
208  * This module is used through inheritance. It will make available the
209  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
210  * the functions of your contract. Note that they will not be pausable by
211  * simply including this module, only once the modifiers are put in place.
212  */
213 abstract contract Pausable is Context {
214     /**
215      * @dev Emitted when the pause is triggered by `account`.
216      */
217     event Paused(address account);
218 
219     /**
220      * @dev Emitted when the pause is lifted by `account`.
221      */
222     event Unpaused(address account);
223 
224     bool private _paused;
225 
226     /**
227      * @dev Initializes the contract in unpaused state.
228      */
229     constructor() {
230         _paused = false;
231     }
232 
233     /**
234      * @dev Returns true if the contract is paused, and false otherwise.
235      */
236     function paused() public view virtual returns (bool) {
237         return _paused;
238     }
239 
240     /**
241      * @dev Modifier to make a function callable only when the contract is not paused.
242      *
243      * Requirements:
244      *
245      * - The contract must not be paused.
246      */
247     modifier whenNotPaused() {
248         require(!paused(), "Pausable: paused");
249         _;
250     }
251 
252     /**
253      * @dev Modifier to make a function callable only when the contract is paused.
254      *
255      * Requirements:
256      *
257      * - The contract must be paused.
258      */
259     modifier whenPaused() {
260         require(paused(), "Pausable: not paused");
261         _;
262     }
263 
264     /**
265      * @dev Triggers stopped state.
266      *
267      * Requirements:
268      *
269      * - The contract must not be paused.
270      */
271     function _pause() internal virtual whenNotPaused {
272         _paused = true;
273         emit Paused(_msgSender());
274     }
275 
276     /**
277      * @dev Returns to normal state.
278      *
279      * Requirements:
280      *
281      * - The contract must be paused.
282      */
283     function _unpause() internal virtual whenPaused {
284         _paused = false;
285         emit Unpaused(_msgSender());
286     }
287 }
288 
289 // File: @openzeppelin/contracts/access/Ownable.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 
297 /**
298  * @dev Contract module which provides a basic access control mechanism, where
299  * there is an account (an owner) that can be granted exclusive access to
300  * specific functions.
301  *
302  * By default, the owner account will be the one that deploys the contract. This
303  * can later be changed with {transferOwnership}.
304  *
305  * This module is used through inheritance. It will make available the modifier
306  * `onlyOwner`, which can be applied to your functions to restrict their use to
307  * the owner.
308  */
309 abstract contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
313 
314     /**
315      * @dev Initializes the contract setting the deployer as the initial owner.
316      */
317     constructor() {
318         _transferOwnership(_msgSender());
319     }
320 
321     /**
322      * @dev Returns the address of the current owner.
323      */
324     function owner() public view virtual returns (address) {
325         return _owner;
326     }
327 
328     /**
329      * @dev Throws if called by any account other than the owner.
330      */
331     modifier onlyOwner() {
332         require(owner() == _msgSender(), "Ownable: caller is not the owner");
333         _;
334     }
335 
336     /**
337      * @dev Leaves the contract without owner. It will not be possible to call
338      * `onlyOwner` functions anymore. Can only be called by the current owner.
339      *
340      * NOTE: Renouncing ownership will leave the contract without an owner,
341      * thereby removing any functionality that is only available to the owner.
342      */
343     function renounceOwnership() public virtual onlyOwner {
344         _transferOwnership(address(0));
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public virtual onlyOwner {
352         require(newOwner != address(0), "Ownable: new owner is the zero address");
353         _transferOwnership(newOwner);
354     }
355 
356     /**
357      * @dev Transfers ownership of the contract to a new account (`newOwner`).
358      * Internal function without access restriction.
359      */
360     function _transferOwnership(address newOwner) internal virtual {
361         address oldOwner = _owner;
362         _owner = newOwner;
363         emit OwnershipTransferred(oldOwner, newOwner);
364     }
365 }
366 
367 // File: erc721a/contracts/IERC721A.sol
368 
369 
370 // ERC721A Contracts v4.1.0
371 // Creator: Chiru Labs
372 
373 pragma solidity ^0.8.4;
374 
375 /**
376  * @dev Interface of an ERC721A compliant contract.
377  */
378 interface IERC721A {
379     /**
380      * The caller must own the token or be an approved operator.
381      */
382     error ApprovalCallerNotOwnerNorApproved();
383 
384     /**
385      * The token does not exist.
386      */
387     error ApprovalQueryForNonexistentToken();
388 
389     /**
390      * The caller cannot approve to their own address.
391      */
392     error ApproveToCaller();
393 
394     /**
395      * Cannot query the balance for the zero address.
396      */
397     error BalanceQueryForZeroAddress();
398 
399     /**
400      * Cannot mint to the zero address.
401      */
402     error MintToZeroAddress();
403 
404     /**
405      * The quantity of tokens minted must be more than zero.
406      */
407     error MintZeroQuantity();
408 
409     /**
410      * The token does not exist.
411      */
412     error OwnerQueryForNonexistentToken();
413 
414     /**
415      * The caller must own the token or be an approved operator.
416      */
417     error TransferCallerNotOwnerNorApproved();
418 
419     /**
420      * The token must be owned by `from`.
421      */
422     error TransferFromIncorrectOwner();
423 
424     /**
425      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
426      */
427     error TransferToNonERC721ReceiverImplementer();
428 
429     /**
430      * Cannot transfer to the zero address.
431      */
432     error TransferToZeroAddress();
433 
434     /**
435      * The token does not exist.
436      */
437     error URIQueryForNonexistentToken();
438 
439     /**
440      * The `quantity` minted with ERC2309 exceeds the safety limit.
441      */
442     error MintERC2309QuantityExceedsLimit();
443 
444     /**
445      * The `extraData` cannot be set on an unintialized ownership slot.
446      */
447     error OwnershipNotInitializedForExtraData();
448 
449     struct TokenOwnership {
450         // The address of the owner.
451         address addr;
452         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
453         uint64 startTimestamp;
454         // Whether the token has been burned.
455         bool burned;
456         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
457         uint24 extraData;
458     }
459 
460     /**
461      * @dev Returns the total amount of tokens stored by the contract.
462      *
463      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
464      */
465     function totalSupply() external view returns (uint256);
466 
467     // ==============================
468     //            IERC165
469     // ==============================
470 
471     /**
472      * @dev Returns true if this contract implements the interface defined by
473      * `interfaceId`. See the corresponding
474      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
475      * to learn more about how these ids are created.
476      *
477      * This function call must use less than 30 000 gas.
478      */
479     function supportsInterface(bytes4 interfaceId) external view returns (bool);
480 
481     // ==============================
482     //            IERC721
483     // ==============================
484 
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
492      */
493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in ``owner``'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
524      *
525      * Emits a {Transfer} event.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 tokenId,
531         bytes calldata data
532     ) external;
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Approve or remove `operator` as an operator for the caller.
591      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
592      *
593      * Requirements:
594      *
595      * - The `operator` cannot be the caller.
596      *
597      * Emits an {ApprovalForAll} event.
598      */
599     function setApprovalForAll(address operator, bool _approved) external;
600 
601     /**
602      * @dev Returns the account approved for `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function getApproved(uint256 tokenId) external view returns (address operator);
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     // ==============================
618     //        IERC721Metadata
619     // ==============================
620 
621     /**
622      * @dev Returns the token collection name.
623      */
624     function name() external view returns (string memory);
625 
626     /**
627      * @dev Returns the token collection symbol.
628      */
629     function symbol() external view returns (string memory);
630 
631     /**
632      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
633      */
634     function tokenURI(uint256 tokenId) external view returns (string memory);
635 
636     // ==============================
637     //            IERC2309
638     // ==============================
639 
640     /**
641      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
642      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
643      */
644     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
645 }
646 
647 // File: erc721a/contracts/ERC721A.sol
648 
649 
650 // ERC721A Contracts v4.1.0
651 // Creator: Chiru Labs
652 
653 pragma solidity ^0.8.4;
654 
655 
656 /**
657  * @dev ERC721 token receiver interface.
658  */
659 interface ERC721A__IERC721Receiver {
660     function onERC721Received(
661         address operator,
662         address from,
663         uint256 tokenId,
664         bytes calldata data
665     ) external returns (bytes4);
666 }
667 
668 /**
669  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
670  * including the Metadata extension. Built to optimize for lower gas during batch mints.
671  *
672  * Assumes serials are sequentially minted starting at `_startTokenId()`
673  * (defaults to 0, e.g. 0, 1, 2, 3..).
674  *
675  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
676  *
677  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
678  */
679 contract ERC721A is IERC721A {
680     // Mask of an entry in packed address data.
681     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
682 
683     // The bit position of `numberMinted` in packed address data.
684     uint256 private constant BITPOS_NUMBER_MINTED = 64;
685 
686     // The bit position of `numberBurned` in packed address data.
687     uint256 private constant BITPOS_NUMBER_BURNED = 128;
688 
689     // The bit position of `aux` in packed address data.
690     uint256 private constant BITPOS_AUX = 192;
691 
692     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
693     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
694 
695     // The bit position of `startTimestamp` in packed ownership.
696     uint256 private constant BITPOS_START_TIMESTAMP = 160;
697 
698     // The bit mask of the `burned` bit in packed ownership.
699     uint256 private constant BITMASK_BURNED = 1 << 224;
700 
701     // The bit position of the `nextInitialized` bit in packed ownership.
702     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
703 
704     // The bit mask of the `nextInitialized` bit in packed ownership.
705     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
706 
707     // The bit position of `extraData` in packed ownership.
708     uint256 private constant BITPOS_EXTRA_DATA = 232;
709 
710     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
711     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
712 
713     // The mask of the lower 160 bits for addresses.
714     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
715 
716     // The maximum `quantity` that can be minted with `_mintERC2309`.
717     // This limit is to prevent overflows on the address data entries.
718     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
719     // is required to cause an overflow, which is unrealistic.
720     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
721 
722     // The tokenId of the next token to be minted.
723     uint256 private _currentIndex;
724 
725     // The number of tokens burned.
726     uint256 private _burnCounter;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned.
736     // See `_packedOwnershipOf` implementation for details.
737     //
738     // Bits Layout:
739     // - [0..159]   `addr`
740     // - [160..223] `startTimestamp`
741     // - [224]      `burned`
742     // - [225]      `nextInitialized`
743     // - [232..255] `extraData`
744     mapping(uint256 => uint256) private _packedOwnerships;
745 
746     // Mapping owner address to address data.
747     //
748     // Bits Layout:
749     // - [0..63]    `balance`
750     // - [64..127]  `numberMinted`
751     // - [128..191] `numberBurned`
752     // - [192..255] `aux`
753     mapping(address => uint256) private _packedAddressData;
754 
755     // Mapping from token ID to approved address.
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
764         _currentIndex = _startTokenId();
765     }
766 
767     /**
768      * @dev Returns the starting token ID.
769      * To change the starting token ID, please override this function.
770      */
771     function _startTokenId() internal view virtual returns (uint256) {
772         return 0;
773     }
774 
775     /**
776      * @dev Returns the next token ID to be minted.
777      */
778     function _nextTokenId() internal view returns (uint256) {
779         return _currentIndex;
780     }
781 
782     /**
783      * @dev Returns the total number of tokens in existence.
784      * Burned tokens will reduce the count.
785      * To get the total number of tokens minted, please see `_totalMinted`.
786      */
787     function totalSupply() public view override returns (uint256) {
788         // Counter underflow is impossible as _burnCounter cannot be incremented
789         // more than `_currentIndex - _startTokenId()` times.
790         unchecked {
791             return _currentIndex - _burnCounter - _startTokenId();
792         }
793     }
794 
795     /**
796      * @dev Returns the total amount of tokens minted in the contract.
797      */
798     function _totalMinted() internal view returns (uint256) {
799         // Counter underflow is impossible as _currentIndex does not decrement,
800         // and it is initialized to `_startTokenId()`
801         unchecked {
802             return _currentIndex - _startTokenId();
803         }
804     }
805 
806     /**
807      * @dev Returns the total number of tokens burned.
808      */
809     function _totalBurned() internal view returns (uint256) {
810         return _burnCounter;
811     }
812 
813     /**
814      * @dev See {IERC165-supportsInterface}.
815      */
816     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
817         // The interface IDs are constants representing the first 4 bytes of the XOR of
818         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
819         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
820         return
821             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
822             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
823             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
824     }
825 
826     /**
827      * @dev See {IERC721-balanceOf}.
828      */
829     function balanceOf(address owner) public view override returns (uint256) {
830         if (owner == address(0)) revert BalanceQueryForZeroAddress();
831         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
832     }
833 
834     /**
835      * Returns the number of tokens minted by `owner`.
836      */
837     function _numberMinted(address owner) internal view returns (uint256) {
838         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
839     }
840 
841     /**
842      * Returns the number of tokens burned by or on behalf of `owner`.
843      */
844     function _numberBurned(address owner) internal view returns (uint256) {
845         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
846     }
847 
848     /**
849      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
850      */
851     function _getAux(address owner) internal view returns (uint64) {
852         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
853     }
854 
855     /**
856      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
857      * If there are multiple variables, please pack them into a uint64.
858      */
859     function _setAux(address owner, uint64 aux) internal {
860         uint256 packed = _packedAddressData[owner];
861         uint256 auxCasted;
862         // Cast `aux` with assembly to avoid redundant masking.
863         assembly {
864             auxCasted := aux
865         }
866         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
867         _packedAddressData[owner] = packed;
868     }
869 
870     /**
871      * Returns the packed ownership data of `tokenId`.
872      */
873     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
874         uint256 curr = tokenId;
875 
876         unchecked {
877             if (_startTokenId() <= curr)
878                 if (curr < _currentIndex) {
879                     uint256 packed = _packedOwnerships[curr];
880                     // If not burned.
881                     if (packed & BITMASK_BURNED == 0) {
882                         // Invariant:
883                         // There will always be an ownership that has an address and is not burned
884                         // before an ownership that does not have an address and is not burned.
885                         // Hence, curr will not underflow.
886                         //
887                         // We can directly compare the packed value.
888                         // If the address is zero, packed is zero.
889                         while (packed == 0) {
890                             packed = _packedOwnerships[--curr];
891                         }
892                         return packed;
893                     }
894                 }
895         }
896         revert OwnerQueryForNonexistentToken();
897     }
898 
899     /**
900      * Returns the unpacked `TokenOwnership` struct from `packed`.
901      */
902     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
903         ownership.addr = address(uint160(packed));
904         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
905         ownership.burned = packed & BITMASK_BURNED != 0;
906         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
907     }
908 
909     /**
910      * Returns the unpacked `TokenOwnership` struct at `index`.
911      */
912     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
913         return _unpackedOwnership(_packedOwnerships[index]);
914     }
915 
916     /**
917      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
918      */
919     function _initializeOwnershipAt(uint256 index) internal {
920         if (_packedOwnerships[index] == 0) {
921             _packedOwnerships[index] = _packedOwnershipOf(index);
922         }
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         return _unpackedOwnership(_packedOwnershipOf(tokenId));
931     }
932 
933     /**
934      * @dev Packs ownership data into a single uint256.
935      */
936     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
937         assembly {
938             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
939             owner := and(owner, BITMASK_ADDRESS)
940             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
941             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
942         }
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view override returns (address) {
949         return address(uint160(_packedOwnershipOf(tokenId)));
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-name}.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-symbol}.
961      */
962     function symbol() public view virtual override returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-tokenURI}.
968      */
969     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
970         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
971 
972         string memory baseURI = _baseURI();
973         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, it can be overridden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return '';
983     }
984 
985     /**
986      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
987      */
988     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
989         // For branchless setting of the `nextInitialized` flag.
990         assembly {
991             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
992             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
993         }
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ownerOf(tokenId);
1001 
1002         if (_msgSenderERC721A() != owner)
1003             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1004                 revert ApprovalCallerNotOwnerNorApproved();
1005             }
1006 
1007         _tokenApprovals[tokenId] = to;
1008         emit Approval(owner, to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-getApproved}.
1013      */
1014     function getApproved(uint256 tokenId) public view override returns (address) {
1015         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1016 
1017         return _tokenApprovals[tokenId];
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-setApprovalForAll}.
1022      */
1023     function setApprovalForAll(address operator, bool approved) public virtual override {
1024         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1025 
1026         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1027         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-isApprovedForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1034         return _operatorApprovals[owner][operator];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-safeTransferFrom}.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) public virtual override {
1045         safeTransferFrom(from, to, tokenId, '');
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-safeTransferFrom}.
1050      */
1051     function safeTransferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) public virtual override {
1057         transferFrom(from, to, tokenId);
1058         if (to.code.length != 0)
1059             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060                 revert TransferToNonERC721ReceiverImplementer();
1061             }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return
1073             _startTokenId() <= tokenId &&
1074             tokenId < _currentIndex && // If within bounds,
1075             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1076     }
1077 
1078     /**
1079      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1080      */
1081     function _safeMint(address to, uint256 quantity) internal {
1082         _safeMint(to, quantity, '');
1083     }
1084 
1085     /**
1086      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - If `to` refers to a smart contract, it must implement
1091      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * See {_mint}.
1095      *
1096      * Emits a {Transfer} event for each mint.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         _mint(to, quantity);
1104 
1105         unchecked {
1106             if (to.code.length != 0) {
1107                 uint256 end = _currentIndex;
1108                 uint256 index = end - quantity;
1109                 do {
1110                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1111                         revert TransferToNonERC721ReceiverImplementer();
1112                     }
1113                 } while (index < end);
1114                 // Reentrancy protection.
1115                 if (_currentIndex != end) revert();
1116             }
1117         }
1118     }
1119 
1120     /**
1121      * @dev Mints `quantity` tokens and transfers them to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `quantity` must be greater than 0.
1127      *
1128      * Emits a {Transfer} event for each mint.
1129      */
1130     function _mint(address to, uint256 quantity) internal {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // `balance` and `numberMinted` have a maximum limit of 2**64.
1139         // `tokenId` has a maximum limit of 2**256.
1140         unchecked {
1141             // Updates:
1142             // - `balance += quantity`.
1143             // - `numberMinted += quantity`.
1144             //
1145             // We can directly add to the `balance` and `numberMinted`.
1146             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1147 
1148             // Updates:
1149             // - `address` to the owner.
1150             // - `startTimestamp` to the timestamp of minting.
1151             // - `burned` to `false`.
1152             // - `nextInitialized` to `quantity == 1`.
1153             _packedOwnerships[startTokenId] = _packOwnershipData(
1154                 to,
1155                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1156             );
1157 
1158             uint256 tokenId = startTokenId;
1159             uint256 end = startTokenId + quantity;
1160             do {
1161                 emit Transfer(address(0), to, tokenId++);
1162             } while (tokenId < end);
1163 
1164             _currentIndex = end;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168 
1169     /**
1170      * @dev Mints `quantity` tokens and transfers them to `to`.
1171      *
1172      * This function is intended for efficient minting only during contract creation.
1173      *
1174      * It emits only one {ConsecutiveTransfer} as defined in
1175      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1176      * instead of a sequence of {Transfer} event(s).
1177      *
1178      * Calling this function outside of contract creation WILL make your contract
1179      * non-compliant with the ERC721 standard.
1180      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1181      * {ConsecutiveTransfer} event is only permissible during contract creation.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `quantity` must be greater than 0.
1187      *
1188      * Emits a {ConsecutiveTransfer} event.
1189      */
1190     function _mintERC2309(address to, uint256 quantity) internal {
1191         uint256 startTokenId = _currentIndex;
1192         if (to == address(0)) revert MintToZeroAddress();
1193         if (quantity == 0) revert MintZeroQuantity();
1194         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1195 
1196         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1197 
1198         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1199         unchecked {
1200             // Updates:
1201             // - `balance += quantity`.
1202             // - `numberMinted += quantity`.
1203             //
1204             // We can directly add to the `balance` and `numberMinted`.
1205             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1206 
1207             // Updates:
1208             // - `address` to the owner.
1209             // - `startTimestamp` to the timestamp of minting.
1210             // - `burned` to `false`.
1211             // - `nextInitialized` to `quantity == 1`.
1212             _packedOwnerships[startTokenId] = _packOwnershipData(
1213                 to,
1214                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1215             );
1216 
1217             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1218 
1219             _currentIndex = startTokenId + quantity;
1220         }
1221         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1222     }
1223 
1224     /**
1225      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1226      */
1227     function _getApprovedAddress(uint256 tokenId)
1228         private
1229         view
1230         returns (uint256 approvedAddressSlot, address approvedAddress)
1231     {
1232         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1233         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1234         assembly {
1235             // Compute the slot.
1236             mstore(0x00, tokenId)
1237             mstore(0x20, tokenApprovalsPtr.slot)
1238             approvedAddressSlot := keccak256(0x00, 0x40)
1239             // Load the slot's value from storage.
1240             approvedAddress := sload(approvedAddressSlot)
1241         }
1242     }
1243 
1244     /**
1245      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1246      */
1247     function _isOwnerOrApproved(
1248         address approvedAddress,
1249         address from,
1250         address msgSender
1251     ) private pure returns (bool result) {
1252         assembly {
1253             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1254             from := and(from, BITMASK_ADDRESS)
1255             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1256             msgSender := and(msgSender, BITMASK_ADDRESS)
1257             // `msgSender == from || msgSender == approvedAddress`.
1258             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1259         }
1260     }
1261 
1262     /**
1263      * @dev Transfers `tokenId` from `from` to `to`.
1264      *
1265      * Requirements:
1266      *
1267      * - `to` cannot be the zero address.
1268      * - `tokenId` token must be owned by `from`.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function transferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) public virtual override {
1277         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1278 
1279         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1280 
1281         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1282 
1283         // The nested ifs save around 20+ gas over a compound boolean condition.
1284         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1285             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1286 
1287         if (to == address(0)) revert TransferToZeroAddress();
1288 
1289         _beforeTokenTransfers(from, to, tokenId, 1);
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
1301         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1302         unchecked {
1303             // We can directly increment and decrement the balances.
1304             --_packedAddressData[from]; // Updates: `balance -= 1`.
1305             ++_packedAddressData[to]; // Updates: `balance += 1`.
1306 
1307             // Updates:
1308             // - `address` to the next owner.
1309             // - `startTimestamp` to the timestamp of transfering.
1310             // - `burned` to `false`.
1311             // - `nextInitialized` to `true`.
1312             _packedOwnerships[tokenId] = _packOwnershipData(
1313                 to,
1314                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1315             );
1316 
1317             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1318             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1319                 uint256 nextTokenId = tokenId + 1;
1320                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1321                 if (_packedOwnerships[nextTokenId] == 0) {
1322                     // If the next slot is within bounds.
1323                     if (nextTokenId != _currentIndex) {
1324                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1325                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1326                     }
1327                 }
1328             }
1329         }
1330 
1331         emit Transfer(from, to, tokenId);
1332         _afterTokenTransfers(from, to, tokenId, 1);
1333     }
1334 
1335     /**
1336      * @dev Equivalent to `_burn(tokenId, false)`.
1337      */
1338     function _burn(uint256 tokenId) internal virtual {
1339         _burn(tokenId, false);
1340     }
1341 
1342     /**
1343      * @dev Destroys `tokenId`.
1344      * The approval is cleared when the token is burned.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1353         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1354 
1355         address from = address(uint160(prevOwnershipPacked));
1356 
1357         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1358 
1359         if (approvalCheck) {
1360             // The nested ifs save around 20+ gas over a compound boolean condition.
1361             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1362                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1363         }
1364 
1365         _beforeTokenTransfers(from, address(0), tokenId, 1);
1366 
1367         // Clear approvals from the previous owner.
1368         assembly {
1369             if approvedAddress {
1370                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1371                 sstore(approvedAddressSlot, 0)
1372             }
1373         }
1374 
1375         // Underflow of the sender's balance is impossible because we check for
1376         // ownership above and the recipient's balance can't realistically overflow.
1377         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1378         unchecked {
1379             // Updates:
1380             // - `balance -= 1`.
1381             // - `numberBurned += 1`.
1382             //
1383             // We can directly decrement the balance, and increment the number burned.
1384             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1385             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1386 
1387             // Updates:
1388             // - `address` to the last owner.
1389             // - `startTimestamp` to the timestamp of burning.
1390             // - `burned` to `true`.
1391             // - `nextInitialized` to `true`.
1392             _packedOwnerships[tokenId] = _packOwnershipData(
1393                 from,
1394                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1395             );
1396 
1397             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1398             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1399                 uint256 nextTokenId = tokenId + 1;
1400                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1401                 if (_packedOwnerships[nextTokenId] == 0) {
1402                     // If the next slot is within bounds.
1403                     if (nextTokenId != _currentIndex) {
1404                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1405                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1406                     }
1407                 }
1408             }
1409         }
1410 
1411         emit Transfer(from, address(0), tokenId);
1412         _afterTokenTransfers(from, address(0), tokenId, 1);
1413 
1414         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1415         unchecked {
1416             _burnCounter++;
1417         }
1418     }
1419 
1420     /**
1421      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1422      *
1423      * @param from address representing the previous owner of the given token ID
1424      * @param to target address that will receive the tokens
1425      * @param tokenId uint256 ID of the token to be transferred
1426      * @param _data bytes optional data to send along with the call
1427      * @return bool whether the call correctly returned the expected magic value
1428      */
1429     function _checkContractOnERC721Received(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory _data
1434     ) private returns (bool) {
1435         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1436             bytes4 retval
1437         ) {
1438             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1439         } catch (bytes memory reason) {
1440             if (reason.length == 0) {
1441                 revert TransferToNonERC721ReceiverImplementer();
1442             } else {
1443                 assembly {
1444                     revert(add(32, reason), mload(reason))
1445                 }
1446             }
1447         }
1448     }
1449 
1450     /**
1451      * @dev Directly sets the extra data for the ownership data `index`.
1452      */
1453     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1454         uint256 packed = _packedOwnerships[index];
1455         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1456         uint256 extraDataCasted;
1457         // Cast `extraData` with assembly to avoid redundant masking.
1458         assembly {
1459             extraDataCasted := extraData
1460         }
1461         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1462         _packedOwnerships[index] = packed;
1463     }
1464 
1465     /**
1466      * @dev Returns the next extra data for the packed ownership data.
1467      * The returned result is shifted into position.
1468      */
1469     function _nextExtraData(
1470         address from,
1471         address to,
1472         uint256 prevOwnershipPacked
1473     ) private view returns (uint256) {
1474         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1475         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1476     }
1477 
1478     /**
1479      * @dev Called during each token transfer to set the 24bit `extraData` field.
1480      * Intended to be overridden by the cosumer contract.
1481      *
1482      * `previousExtraData` - the value of `extraData` before transfer.
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` will be minted for `to`.
1489      * - When `to` is zero, `tokenId` will be burned by `from`.
1490      * - `from` and `to` are never both zero.
1491      */
1492     function _extraData(
1493         address from,
1494         address to,
1495         uint24 previousExtraData
1496     ) internal view virtual returns (uint24) {}
1497 
1498     /**
1499      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1500      * This includes minting.
1501      * And also called before burning one token.
1502      *
1503      * startTokenId - the first token id to be transferred
1504      * quantity - the amount to be transferred
1505      *
1506      * Calling conditions:
1507      *
1508      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1509      * transferred to `to`.
1510      * - When `from` is zero, `tokenId` will be minted for `to`.
1511      * - When `to` is zero, `tokenId` will be burned by `from`.
1512      * - `from` and `to` are never both zero.
1513      */
1514     function _beforeTokenTransfers(
1515         address from,
1516         address to,
1517         uint256 startTokenId,
1518         uint256 quantity
1519     ) internal virtual {}
1520 
1521     /**
1522      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1523      * This includes minting.
1524      * And also called after one token has been burned.
1525      *
1526      * startTokenId - the first token id to be transferred
1527      * quantity - the amount to be transferred
1528      *
1529      * Calling conditions:
1530      *
1531      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1532      * transferred to `to`.
1533      * - When `from` is zero, `tokenId` has been minted for `to`.
1534      * - When `to` is zero, `tokenId` has been burned by `from`.
1535      * - `from` and `to` are never both zero.
1536      */
1537     function _afterTokenTransfers(
1538         address from,
1539         address to,
1540         uint256 startTokenId,
1541         uint256 quantity
1542     ) internal virtual {}
1543 
1544     /**
1545      * @dev Returns the message sender (defaults to `msg.sender`).
1546      *
1547      * If you are writing GSN compatible contracts, you need to override this function.
1548      */
1549     function _msgSenderERC721A() internal view virtual returns (address) {
1550         return msg.sender;
1551     }
1552 
1553     /**
1554      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1555      */
1556     function _toString(uint256 value) internal pure returns (string memory ptr) {
1557         assembly {
1558             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1559             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1560             // We will need 1 32-byte word to store the length,
1561             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1562             ptr := add(mload(0x40), 128)
1563             // Update the free memory pointer to allocate.
1564             mstore(0x40, ptr)
1565 
1566             // Cache the end of the memory to calculate the length later.
1567             let end := ptr
1568 
1569             // We write the string from the rightmost digit to the leftmost digit.
1570             // The following is essentially a do-while loop that also handles the zero case.
1571             // Costs a bit more than early returning for the zero case,
1572             // but cheaper in terms of deployment and overall runtime costs.
1573             for {
1574                 // Initialize and perform the first pass without check.
1575                 let temp := value
1576                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1577                 ptr := sub(ptr, 1)
1578                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1579                 mstore8(ptr, add(48, mod(temp, 10)))
1580                 temp := div(temp, 10)
1581             } temp {
1582                 // Keep dividing `temp` until zero.
1583                 temp := div(temp, 10)
1584             } {
1585                 // Body of the for loop.
1586                 ptr := sub(ptr, 1)
1587                 mstore8(ptr, add(48, mod(temp, 10)))
1588             }
1589 
1590             let length := sub(end, ptr)
1591             // Move the pointer 32 bytes leftwards to make room for the length.
1592             ptr := sub(ptr, 32)
1593             // Store the length.
1594             mstore(ptr, length)
1595         }
1596     }
1597 }
1598 
1599 // File: contracts/Entstown.sol
1600 
1601 //SPDX-License-Identifier: MIT
1602 
1603 //........................................................................................................
1604 //.......................................SSSSSS..................OOOOOO...................................
1605 //.EEEEEEEEEEE.ENNN....NNN.NNTTTTTTTTT..SSSSSSSS..SSTTTTTTTTT..OOOOOOOOO..OOOWW..WWWW...WWWWWNNNN...NNNN..
1606 //.EEEEEEEEEEE.ENNNN...NNN.NNTTTTTTTTT.SSSSSSSSSS.SSTTTTTTTTT.TOOOOOOOOOO..OOWW..WWWWW..WWWWWNNNNN..NNNN..
1607 //.EEEEEEEEEEE.ENNNN...NNN.NNTTTTTTTTT.SSSSSSSSSS.SSTTTTTTTTT.TOOOOOOOOOOO.OOWW..WWWWW.WWWWWWNNNNN..NNNN..
1608 //.EEEE........ENNNNN..NNN.....TTTT...TSSS...SSSSS....TTTT...TTOOO....OOOO.OOWW.WWWWWW.WWWW.WNNNNNN.NNNN..
1609 //.EEEEEEEEEE..ENNNNNN.NNN.....TTTT...TSSSSS..........TTTT...TTOO.....OOOO..OWWWWWWWWW.WWWW.WNNNNNN.NNNN..
1610 //.EEEEEEEEEE..ENNNNNN.NNN.....TTTT....SSSSSSSSS......TTTT...TTOO......OOOO.OWWWWWWWWW.WWWW.WNNNNNNNNNNN..
1611 //.EEEEEEEEEE..ENN.NNNNNNN.....TTTT....SSSSSSSSSS.....TTTT...TTOO......OOOO.OWWWWWWWWWWWWW..WNNNNNNNNNNN..
1612 //.EEEEEEEEEE..ENN.NNNNNNN.....TTTT......SSSSSSSSS....TTTT...TTOO......OOOO.OWWWWWWWWWWWWW..WNNN.NNNNNNN..
1613 //.EEEE........ENN..NNNNNN.....TTTT...TSSS..SSSSSS....TTTT...TTOO.....OOOO...WWWWWW.WWWWWW..WNNN.NNNNNNN..
1614 //.EEEE........ENN..NNNNNN.....TTTT...TSSS....SSSS....TTTT...TTOOO....OOOO...WWWWWW.WWWWWW..WNNN..NNNNNN..
1615 //.EEEEEEEEEEE.ENN...NNNNN.....TTTT...TSSSSSSSSSSS....TTTT....TOOOOOOOOOOO...WWWWW..WWWWW...WNNN...NNNNN..
1616 //.EEEEEEEEEEE.ENN...NNNNN.....TTTT....SSSSSSSSSS.....TTTT.....OOOOOOOOOO.....WWWW..WWWWW...WNNN...NNNNN..
1617 //.EEEEEEEEEEE.ENN....NNNN.....TTTT.....SSSSSSSSS.....TTTT.....OOOOOOOOO......WWWW..WWWWW...WNNN....NNNN..
1618 //.......................................SSSSSS..................OOOOOO...................................
1619 //........................................................................................................
1620 //creator : @entstownwtf
1621 //website : ents.town
1622 
1623 pragma solidity ^0.8.0; 
1624 
1625 
1626 
1627 
1628 
1629 
1630 
1631 contract Entstown is ERC721A, Ownable, Pausable 
1632 {
1633     using Strings for uint256;
1634     
1635     uint256 public totalColSize = 6969;
1636     mapping(address => uint256) public mintList;
1637     uint256 public walletMintLimit = 30;
1638     uint256 public txnMintLimit = 10;
1639     uint256 public txnWLMintLimit = 15;
1640     bytes32 public freeWLMerkleRoot = 0xbd634cf99ef3e23b5561c713826ac4b5323ce6b0f4969260dcc6b5033104a6e2;
1641     address public mdProvider;
1642     string private baseTokenURI;
1643     bool public providerBasedURI;
1644     bool public freeMintActive;
1645 
1646     constructor
1647     ( 
1648        string memory _name,
1649        string memory _symbol,
1650        string memory _baseTokenURI
1651     ) ERC721A(_name, _symbol) 
1652     {
1653         baseTokenURI = _baseTokenURI;
1654     }
1655 
1656     modifier callerIsUser() 
1657     {
1658         require(tx.origin == msg.sender, "Caller is contract");
1659         _;
1660     }
1661 
1662     modifier onlyFreeMintActive() {
1663         require(freeMintActive, "Minting is not active");
1664         _;
1665     }
1666 
1667     function setMdProvider(address _mdProvider) external onlyOwner {
1668         mdProvider = _mdProvider;
1669     }
1670 
1671     function tokenURI(uint256 _tokenId)
1672         public
1673         view
1674         virtual
1675         override
1676         returns (string memory)
1677     {
1678         require(_exists(_tokenId), "Token not existed");
1679         require( providerBasedURI ? ( mdProvider != address(0) ) : ( keccak256(abi.encodePacked(baseTokenURI)) != keccak256(abi.encodePacked("")) ),
1680             "Invalid metadata provider address"
1681         );
1682 
1683         return providerBasedURI ? IMeta(mdProvider).getMetadata(_tokenId) : string(abi.encodePacked(baseTokenURI, _tokenId.toString(),".json"));
1684     }
1685     
1686     
1687     function setBaseURI(string calldata _baseTokenURI) external onlyOwner 
1688     {
1689         baseTokenURI = _baseTokenURI;
1690     }
1691 
1692 
1693     function _startTokenId() internal pure override returns (uint256) {
1694         return 1;
1695     }
1696 
1697     function setFreeWLMerkleRoot(bytes32 _freeWLMerkleRoot)
1698         external
1699         onlyOwner
1700     {
1701         freeWLMerkleRoot = _freeWLMerkleRoot;
1702     }
1703 
1704 
1705     function wlFreeMint(bytes32[] calldata _merkleProof, uint256 quantity)
1706         external
1707         payable
1708         onlyFreeMintActive
1709         callerIsUser 
1710     {
1711         require(quantity <= txnWLMintLimit, "Up to 15 mints allowed per transaction");
1712         require(mintList[msg.sender] + quantity <= walletMintLimit, "Up to 30 mints allowed per wallet");
1713         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");   
1714 
1715         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1716         require(
1717              MerkleProof.verify(_merkleProof, freeWLMerkleRoot, leaf),
1718              "You are not whitelisted"
1719          );
1720 
1721         mintList[msg.sender] += quantity;
1722         _safeMint(msg.sender, quantity);
1723     }
1724 
1725     function freeMint(uint256 quantity)
1726         external
1727         payable
1728         onlyFreeMintActive
1729         callerIsUser    
1730     {
1731         require(quantity <= txnMintLimit, "Up to 10 mints allowed per transaction");
1732         require(mintList[msg.sender] + quantity <= walletMintLimit, "Up to 30 mints allowed per wallet");
1733         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1734 
1735         mintList[msg.sender] += quantity;
1736         _safeMint(msg.sender, quantity);
1737     }
1738     
1739     function teamMint(uint256 quantity)
1740         external
1741         payable
1742         onlyOwner
1743     {
1744         require(quantity > 0, "Invalid quantity");
1745         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1746 
1747         _safeMint(msg.sender, quantity);
1748     }
1749 
1750     function airdrop(address toAdd,uint256 quantity)
1751         external
1752         payable
1753         onlyOwner
1754     {
1755         require(quantity > 0, "Invalid quantity");
1756         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1757 
1758         _safeMint(toAdd, quantity);
1759     }
1760 
1761     function toggleProviderBasedURI() 
1762         external 
1763         onlyOwner 
1764     {
1765         providerBasedURI = !providerBasedURI;
1766     }
1767 
1768     function togglefreeMint() 
1769         external 
1770         onlyOwner 
1771     {
1772         freeMintActive = !freeMintActive;
1773     }
1774 
1775     function pause() external onlyOwner {
1776         _pause();
1777     }
1778 
1779     function unpause() external onlyOwner {
1780         _unpause();
1781     }
1782     
1783     function _beforeTokenTransfers(
1784         address from,
1785         address to,
1786         uint256 tokenId,
1787         uint256 quantity
1788     ) internal override(ERC721A) whenNotPaused 
1789     {
1790         super._beforeTokenTransfers(from, to, tokenId, quantity);
1791     }
1792 
1793     function changeSupply(uint256 _decreaseAmount) 
1794         external 
1795         onlyOwner 
1796     {
1797         require(_decreaseAmount > 0 ,"Amount must be greater than 0");
1798         require(totalSupply() < totalColSize ,"Just sold out" );
1799         require(totalColSize - _decreaseAmount >= totalSupply() ,"Insufficient amount" );
1800         totalColSize -= _decreaseAmount;
1801     }
1802 
1803     function changeMintLimitPerWallet(uint256 _newLimitPerWallet) 
1804         external 
1805         onlyOwner 
1806     {
1807         require(_newLimitPerWallet > 0 ,"Invalid value");
1808         walletMintLimit = _newLimitPerWallet;
1809     }
1810     function changeMintLimitPerTxn(uint256 _newLimitPerTxn) 
1811         external 
1812         onlyOwner 
1813     {
1814         require(_newLimitPerTxn > 0 ,"Invalid value");
1815         txnMintLimit = _newLimitPerTxn;
1816     }
1817     function changeWLMintLimitPerTxn(uint256 _newWLLimitPerTxn) 
1818         external 
1819         onlyOwner 
1820     {
1821         require(_newWLLimitPerTxn > 0 ,"Invalid value");
1822         txnWLMintLimit = _newWLLimitPerTxn;
1823     }
1824 
1825 }