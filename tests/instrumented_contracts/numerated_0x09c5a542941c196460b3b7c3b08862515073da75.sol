1 // SPDX-License-Identifier: MIT
2 
3 /**
4                                                                                               
5  ..                                       ..                                         ..      .^^.   
6  ?#.                                      YG                                         5P     7GP5GY  
7  !@^                                      ?@:                                        J@.   ?&^  :&5 
8  ^@BPP5!  .!YPP7  75PPPJ:~P5Y5~        :^JG@G55~ 75PY7.~P.     :PJG!?PP! 75      ^G7JG@G557#@P5^ ~? 
9  :&#^.7@?^#P7^?@Y 5@B^^~7@G..!@???:   ?@7!!#B^^^BG~^!5#?@J  .  P@?@@5!P@~!@7  .  B&^!!&B^^.P@~.     
10  :@P   G#G@!.:5@@^!@5   :&5  ^@P^P#5^!@5   5&. ^@J   !@~P&?B#5Y@?^@J  .&#.B#JBBYP@7   P#   ?@:      
11   G5   7#~YGGGG?PG.GG    Y@P5B5:  :Y#@G    !&^  !GP55PJ ~&#?^Y#P :&?   Y&:!&#7^5#5    7&^  ^B:      
12    .    .        .  .    ~@?..      P&:     .     ::.    ..       ..    .  .           .            
13                          .&5       ?@~                                                              
14                           P#      !@7                                                               
15                           ?@^    ^@5                                                                
16                           :G~   .&#.                                                                
17                                 .7^                                                                 
18                                                                                                   
19 */
20 
21 // File: @openzeppelin/contracts/utils/Context.sol
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 
56 /**
57  * @dev Contract module which provides a basic access control mechanism, where
58  * there is an account (an owner) that can be granted exclusive access to
59  * specific functions.
60  *
61  * By default, the owner account will be the one that deploys the contract. This
62  * can later be changed with {transferOwnership}.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 // File: contracts/Strings.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev String operations.
135  */
136 library Strings {
137     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138     uint8 private constant _ADDRESS_LENGTH = 20;
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
142      */
143     function toString(uint256 value) internal pure returns (string memory) {
144         // Inspired by OraclizeAPI's implementation - MIT licence
145         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
146 
147         if (value == 0) {
148             return "0";
149         }
150         uint256 temp = value;
151         uint256 digits;
152         while (temp != 0) {
153             digits++;
154             temp /= 10;
155         }
156         bytes memory buffer = new bytes(digits);
157         while (value != 0) {
158             digits -= 1;
159             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
160             value /= 10;
161         }
162         return string(buffer);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
167      */
168     function toHexString(uint256 value) internal pure returns (string memory) {
169         if (value == 0) {
170             return "0x00";
171         }
172         uint256 temp = value;
173         uint256 length = 0;
174         while (temp != 0) {
175             length++;
176             temp >>= 8;
177         }
178         return toHexString(value, length);
179     }
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
183      */
184     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
185         bytes memory buffer = new bytes(2 * length + 2);
186         buffer[0] = "0";
187         buffer[1] = "x";
188         for (uint256 i = 2 * length + 1; i > 1; --i) {
189             buffer[i] = _HEX_SYMBOLS[value & 0xf];
190             value >>= 4;
191         }
192         require(value == 0, "Strings: hex length insufficient");
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
198      */
199     function toHexString(address addr) internal pure returns (string memory) {
200         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
201     }
202 }
203 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
204 
205 
206 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev These functions deal with verification of Merkle Trees proofs.
212  *
213  * The proofs can be generated using the JavaScript library
214  * https://github.com/miguelmota/merkletreejs[merkletreejs].
215  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
216  *
217  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
218  *
219  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
220  * hashing, or use a hash function other than keccak256 for hashing leaves.
221  * This is because the concatenation of a sorted pair of internal nodes in
222  * the merkle tree could be reinterpreted as a leaf value.
223  */
224 library MerkleProof {
225     /**
226      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
227      * defined by `root`. For this, a `proof` must be provided, containing
228      * sibling hashes on the branch from the leaf to the root of the tree. Each
229      * pair of leaves and each pair of pre-images are assumed to be sorted.
230      */
231     function verify(
232         bytes32[] memory proof,
233         bytes32 root,
234         bytes32 leaf
235     ) internal pure returns (bool) {
236         return processProof(proof, leaf) == root;
237     }
238 
239     /**
240      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
241      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
242      * hash matches the root of the tree. When processing the proof, the pairs
243      * of leafs & pre-images are assumed to be sorted.
244      *
245      * _Available since v4.4._
246      */
247     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
248         bytes32 computedHash = leaf;
249         for (uint256 i = 0; i < proof.length; i++) {
250             bytes32 proofElement = proof[i];
251             if (computedHash <= proofElement) {
252                 // Hash(current computed hash + current element of the proof)
253                 computedHash = _efficientHash(computedHash, proofElement);
254             } else {
255                 // Hash(current element of the proof + current computed hash)
256                 computedHash = _efficientHash(proofElement, computedHash);
257             }
258         }
259         return computedHash;
260     }
261 
262     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
263         assembly {
264             mstore(0x00, a)
265             mstore(0x20, b)
266             value := keccak256(0x00, 0x40)
267         }
268     }
269 }
270 
271 // File: erc721a/contracts/IERC721A.sol
272 
273 
274 // ERC721A Contracts v4.0.0
275 // Creator: Chiru Labs
276 
277 pragma solidity ^0.8.4;
278 
279 /**
280  * @dev Interface of an ERC721A compliant contract.
281  */
282 interface IERC721A {
283     /**
284      * The caller must own the token or be an approved operator.
285      */
286     error ApprovalCallerNotOwnerNorApproved();
287 
288     /**
289      * The token does not exist.
290      */
291     error ApprovalQueryForNonexistentToken();
292 
293     /**
294      * The caller cannot approve to their own address.
295      */
296     error ApproveToCaller();
297 
298     /**
299      * The caller cannot approve to the current owner.
300      */
301     error ApprovalToCurrentOwner();
302 
303     /**
304      * Cannot query the balance for the zero address.
305      */
306     error BalanceQueryForZeroAddress();
307 
308     /**
309      * Cannot mint to the zero address.
310      */
311     error MintToZeroAddress();
312 
313     /**
314      * The quantity of tokens minted must be more than zero.
315      */
316     error MintZeroQuantity();
317 
318     /**
319      * The token does not exist.
320      */
321     error OwnerQueryForNonexistentToken();
322 
323     /**
324      * The caller must own the token or be an approved operator.
325      */
326     error TransferCallerNotOwnerNorApproved();
327 
328     /**
329      * The token must be owned by `from`.
330      */
331     error TransferFromIncorrectOwner();
332 
333     /**
334      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
335      */
336     error TransferToNonERC721ReceiverImplementer();
337 
338     /**
339      * Cannot transfer to the zero address.
340      */
341     error TransferToZeroAddress();
342 
343     /**
344      * The token does not exist.
345      */
346     error URIQueryForNonexistentToken();
347 
348     struct TokenOwnership {
349         // The address of the owner.
350         address addr;
351         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
352         uint64 startTimestamp;
353         // Whether the token has been burned.
354         bool burned;
355     }
356 
357     /**
358      * @dev Returns the total amount of tokens stored by the contract.
359      *
360      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     // ==============================
365     //            IERC165
366     // ==============================
367 
368     /**
369      * @dev Returns true if this contract implements the interface defined by
370      * `interfaceId`. See the corresponding
371      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
372      * to learn more about how these ids are created.
373      *
374      * This function call must use less than 30 000 gas.
375      */
376     function supportsInterface(bytes4 interfaceId) external view returns (bool);
377 
378     // ==============================
379     //            IERC721
380     // ==============================
381 
382     /**
383      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
389      */
390     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
391 
392     /**
393      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
394      */
395     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
396 
397     /**
398      * @dev Returns the number of tokens in ``owner``'s account.
399      */
400     function balanceOf(address owner) external view returns (uint256 balance);
401 
402     /**
403      * @dev Returns the owner of the `tokenId` token.
404      *
405      * Requirements:
406      *
407      * - `tokenId` must exist.
408      */
409     function ownerOf(uint256 tokenId) external view returns (address owner);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId,
428         bytes calldata data
429     ) external;
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
433      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId
449     ) external;
450 
451     /**
452      * @dev Transfers `tokenId` token from `from` to `to`.
453      *
454      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
473      * The approval is cleared when the token is transferred.
474      *
475      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
476      *
477      * Requirements:
478      *
479      * - The caller must own the token or be an approved operator.
480      * - `tokenId` must exist.
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address to, uint256 tokenId) external;
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns the account approved for `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function getApproved(uint256 tokenId) external view returns (address operator);
506 
507     /**
508      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
509      *
510      * See {setApprovalForAll}
511      */
512     function isApprovedForAll(address owner, address operator) external view returns (bool);
513 
514     // ==============================
515     //        IERC721Metadata
516     // ==============================
517 
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 // File: erc721a/contracts/ERC721A.sol
535 
536 
537 // ERC721A Contracts v4.0.0
538 // Creator: Chiru Labs
539 
540 pragma solidity ^0.8.4;
541 
542 
543 /**
544  * @dev ERC721 token receiver interface.
545  */
546 interface ERC721A__IERC721Receiver {
547     function onERC721Received(
548         address operator,
549         address from,
550         uint256 tokenId,
551         bytes calldata data
552     ) external returns (bytes4);
553 }
554 
555 /**
556  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
557  * the Metadata extension. Built to optimize for lower gas during batch mints.
558  *
559  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
560  *
561  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
562  *
563  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
564  */
565 contract ERC721A is IERC721A {
566     // Mask of an entry in packed address data.
567     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
568 
569     // The bit position of `numberMinted` in packed address data.
570     uint256 private constant BITPOS_NUMBER_MINTED = 64;
571 
572     // The bit position of `numberBurned` in packed address data.
573     uint256 private constant BITPOS_NUMBER_BURNED = 128;
574 
575     // The bit position of `aux` in packed address data.
576     uint256 private constant BITPOS_AUX = 192;
577 
578     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
579     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
580 
581     // The bit position of `startTimestamp` in packed ownership.
582     uint256 private constant BITPOS_START_TIMESTAMP = 160;
583 
584     // The bit mask of the `burned` bit in packed ownership.
585     uint256 private constant BITMASK_BURNED = 1 << 224;
586     
587     // The bit position of the `nextInitialized` bit in packed ownership.
588     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
589 
590     // The bit mask of the `nextInitialized` bit in packed ownership.
591     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
592 
593     // The tokenId of the next token to be minted.
594     uint256 private _currentIndex;
595 
596     // The number of tokens burned.
597     uint256 private _burnCounter;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned.
607     // See `_packedOwnershipOf` implementation for details.
608     //
609     // Bits Layout:
610     // - [0..159]   `addr`
611     // - [160..223] `startTimestamp`
612     // - [224]      `burned`
613     // - [225]      `nextInitialized`
614     mapping(uint256 => uint256) private _packedOwnerships;
615 
616     // Mapping owner address to address data.
617     //
618     // Bits Layout:
619     // - [0..63]    `balance`
620     // - [64..127]  `numberMinted`
621     // - [128..191] `numberBurned`
622     // - [192..255] `aux`
623     mapping(address => uint256) private _packedAddressData;
624 
625     // Mapping from token ID to approved address.
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     constructor(string memory name_, string memory symbol_) {
632         _name = name_;
633         _symbol = symbol_;
634         _currentIndex = _startTokenId();
635     }
636 
637     /**
638      * @dev Returns the starting token ID. 
639      * To change the starting token ID, please override this function.
640      */
641     function _startTokenId() internal view virtual returns (uint256) {
642         return 0;
643     }
644 
645     /**
646      * @dev Returns the next token ID to be minted.
647      */
648     function _nextTokenId() internal view returns (uint256) {
649         return _currentIndex;
650     }
651 
652     /**
653      * @dev Returns the total number of tokens in existence.
654      * Burned tokens will reduce the count. 
655      * To get the total number of tokens minted, please see `_totalMinted`.
656      */
657     function totalSupply() public view override returns (uint256) {
658         // Counter underflow is impossible as _burnCounter cannot be incremented
659         // more than `_currentIndex - _startTokenId()` times.
660         unchecked {
661             return _currentIndex - _burnCounter - _startTokenId();
662         }
663     }
664 
665     /**
666      * @dev Returns the total amount of tokens minted in the contract.
667      */
668     function _totalMinted() internal view returns (uint256) {
669         // Counter underflow is impossible as _currentIndex does not decrement,
670         // and it is initialized to `_startTokenId()`
671         unchecked {
672             return _currentIndex - _startTokenId();
673         }
674     }
675 
676     /**
677      * @dev Returns the total number of tokens burned.
678      */
679     function _totalBurned() internal view returns (uint256) {
680         return _burnCounter;
681     }
682 
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
687         // The interface IDs are constants representing the first 4 bytes of the XOR of
688         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
689         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
690         return
691             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
692             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
693             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
694     }
695 
696     /**
697      * @dev See {IERC721-balanceOf}.
698      */
699     function balanceOf(address owner) public view override returns (uint256) {
700         if (owner == address(0)) revert BalanceQueryForZeroAddress();
701         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the number of tokens minted by `owner`.
706      */
707     function _numberMinted(address owner) internal view returns (uint256) {
708         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
709     }
710 
711     /**
712      * Returns the number of tokens burned by or on behalf of `owner`.
713      */
714     function _numberBurned(address owner) internal view returns (uint256) {
715         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     /**
719      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
720      */
721     function _getAux(address owner) internal view returns (uint64) {
722         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
723     }
724 
725     /**
726      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
727      * If there are multiple variables, please pack them into a uint64.
728      */
729     function _setAux(address owner, uint64 aux) internal {
730         uint256 packed = _packedAddressData[owner];
731         uint256 auxCasted;
732         assembly { // Cast aux without masking.
733             auxCasted := aux
734         }
735         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
736         _packedAddressData[owner] = packed;
737     }
738 
739     /**
740      * Returns the packed ownership data of `tokenId`.
741      */
742     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
743         uint256 curr = tokenId;
744 
745         unchecked {
746             if (_startTokenId() <= curr)
747                 if (curr < _currentIndex) {
748                     uint256 packed = _packedOwnerships[curr];
749                     // If not burned.
750                     if (packed & BITMASK_BURNED == 0) {
751                         // Invariant:
752                         // There will always be an ownership that has an address and is not burned
753                         // before an ownership that does not have an address and is not burned.
754                         // Hence, curr will not underflow.
755                         //
756                         // We can directly compare the packed value.
757                         // If the address is zero, packed is zero.
758                         while (packed == 0) {
759                             packed = _packedOwnerships[--curr];
760                         }
761                         return packed;
762                     }
763                 }
764         }
765         revert OwnerQueryForNonexistentToken();
766     }
767 
768     /**
769      * Returns the unpacked `TokenOwnership` struct from `packed`.
770      */
771     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
772         ownership.addr = address(uint160(packed));
773         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
774         ownership.burned = packed & BITMASK_BURNED != 0;
775     }
776 
777     /**
778      * Returns the unpacked `TokenOwnership` struct at `index`.
779      */
780     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
781         return _unpackedOwnership(_packedOwnerships[index]);
782     }
783 
784     /**
785      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
786      */
787     function _initializeOwnershipAt(uint256 index) internal {
788         if (_packedOwnerships[index] == 0) {
789             _packedOwnerships[index] = _packedOwnershipOf(index);
790         }
791     }
792 
793     /**
794      * Gas spent here starts off proportional to the maximum mint batch size.
795      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
796      */
797     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
798         return _unpackedOwnership(_packedOwnershipOf(tokenId));
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view override returns (address) {
805         return address(uint160(_packedOwnershipOf(tokenId)));
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
826         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
827 
828         string memory baseURI = _baseURI();
829         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
830     }
831 
832     /**
833      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
834      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
835      * by default, can be overriden in child contracts.
836      */
837     function _baseURI() internal view virtual returns (string memory) {
838         return '';
839     }
840 
841     /**
842      * @dev Casts the address to uint256 without masking.
843      */
844     function _addressToUint256(address value) private pure returns (uint256 result) {
845         assembly {
846             result := value
847         }
848     }
849 
850     /**
851      * @dev Casts the boolean to uint256 without branching.
852      */
853     function _boolToUint256(bool value) private pure returns (uint256 result) {
854         assembly {
855             result := value
856         }
857     }
858 
859     /**
860      * @dev See {IERC721-approve}.
861      */
862     function approve(address to, uint256 tokenId) public override {
863         address owner = address(uint160(_packedOwnershipOf(tokenId)));
864         if (to == owner) revert ApprovalToCurrentOwner();
865 
866         if (_msgSenderERC721A() != owner)
867             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
868                 revert ApprovalCallerNotOwnerNorApproved();
869             }
870 
871         _tokenApprovals[tokenId] = to;
872         emit Approval(owner, to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId) public view override returns (address) {
879         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
880 
881         return _tokenApprovals[tokenId];
882     }
883 
884     /**
885      * @dev See {IERC721-setApprovalForAll}.
886      */
887     function setApprovalForAll(address operator, bool approved) public virtual override {
888         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
889 
890         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
891         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
892     }
893 
894     /**
895      * @dev See {IERC721-isApprovedForAll}.
896      */
897     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
898         return _operatorApprovals[owner][operator];
899     }
900 
901     /**
902      * @dev See {IERC721-transferFrom}.
903      */
904     function transferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         _transfer(from, to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) public virtual override {
932         _transfer(from, to, tokenId);
933         if (to.code.length != 0)
934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
935                 revert TransferToNonERC721ReceiverImplementer();
936             }
937     }
938 
939     /**
940      * @dev Returns whether `tokenId` exists.
941      *
942      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943      *
944      * Tokens start existing when they are minted (`_mint`),
945      */
946     function _exists(uint256 tokenId) internal view returns (bool) {
947         return
948             _startTokenId() <= tokenId &&
949             tokenId < _currentIndex && // If within bounds,
950             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
951     }
952 
953     /**
954      * @dev Equivalent to `_safeMint(to, quantity, '')`.
955      */
956     function _safeMint(address to, uint256 quantity) internal {
957         _safeMint(to, quantity, '');
958     }
959 
960     /**
961      * @dev Safely mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - If `to` refers to a smart contract, it must implement
966      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
967      * - `quantity` must be greater than 0.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _safeMint(
972         address to,
973         uint256 quantity,
974         bytes memory _data
975     ) internal {
976         uint256 startTokenId = _currentIndex;
977         if (to == address(0)) revert MintToZeroAddress();
978         if (quantity == 0) revert MintZeroQuantity();
979 
980         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
981 
982         // Overflows are incredibly unrealistic.
983         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
984         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
985         unchecked {
986             // Updates:
987             // - `balance += quantity`.
988             // - `numberMinted += quantity`.
989             //
990             // We can directly add to the balance and number minted.
991             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
992 
993             // Updates:
994             // - `address` to the owner.
995             // - `startTimestamp` to the timestamp of minting.
996             // - `burned` to `false`.
997             // - `nextInitialized` to `quantity == 1`.
998             _packedOwnerships[startTokenId] =
999                 _addressToUint256(to) |
1000                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1001                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1002 
1003             uint256 updatedIndex = startTokenId;
1004             uint256 end = updatedIndex + quantity;
1005 
1006             if (to.code.length != 0) {
1007                 do {
1008                     emit Transfer(address(0), to, updatedIndex);
1009                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1010                         revert TransferToNonERC721ReceiverImplementer();
1011                     }
1012                 } while (updatedIndex < end);
1013                 // Reentrancy protection
1014                 if (_currentIndex != startTokenId) revert();
1015             } else {
1016                 do {
1017                     emit Transfer(address(0), to, updatedIndex++);
1018                 } while (updatedIndex < end);
1019             }
1020             _currentIndex = updatedIndex;
1021         }
1022         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1023     }
1024 
1025     /**
1026      * @dev Mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _mint(address to, uint256 quantity) internal {
1036         uint256 startTokenId = _currentIndex;
1037         if (to == address(0)) revert MintToZeroAddress();
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1044         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1045         unchecked {
1046             // Updates:
1047             // - `balance += quantity`.
1048             // - `numberMinted += quantity`.
1049             //
1050             // We can directly add to the balance and number minted.
1051             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1052 
1053             // Updates:
1054             // - `address` to the owner.
1055             // - `startTimestamp` to the timestamp of minting.
1056             // - `burned` to `false`.
1057             // - `nextInitialized` to `quantity == 1`.
1058             _packedOwnerships[startTokenId] =
1059                 _addressToUint256(to) |
1060                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1061                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1062 
1063             uint256 updatedIndex = startTokenId;
1064             uint256 end = updatedIndex + quantity;
1065 
1066             do {
1067                 emit Transfer(address(0), to, updatedIndex++);
1068             } while (updatedIndex < end);
1069 
1070             _currentIndex = updatedIndex;
1071         }
1072         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1073     }
1074 
1075     /**
1076      * @dev Transfers `tokenId` from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) private {
1090         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1091 
1092         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1093 
1094         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1095             isApprovedForAll(from, _msgSenderERC721A()) ||
1096             getApproved(tokenId) == _msgSenderERC721A());
1097 
1098         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1099         if (to == address(0)) revert TransferToZeroAddress();
1100 
1101         _beforeTokenTransfers(from, to, tokenId, 1);
1102 
1103         // Clear approvals from the previous owner.
1104         delete _tokenApprovals[tokenId];
1105 
1106         // Underflow of the sender's balance is impossible because we check for
1107         // ownership above and the recipient's balance can't realistically overflow.
1108         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1109         unchecked {
1110             // We can directly increment and decrement the balances.
1111             --_packedAddressData[from]; // Updates: `balance -= 1`.
1112             ++_packedAddressData[to]; // Updates: `balance += 1`.
1113 
1114             // Updates:
1115             // - `address` to the next owner.
1116             // - `startTimestamp` to the timestamp of transfering.
1117             // - `burned` to `false`.
1118             // - `nextInitialized` to `true`.
1119             _packedOwnerships[tokenId] =
1120                 _addressToUint256(to) |
1121                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1122                 BITMASK_NEXT_INITIALIZED;
1123 
1124             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1125             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1126                 uint256 nextTokenId = tokenId + 1;
1127                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1128                 if (_packedOwnerships[nextTokenId] == 0) {
1129                     // If the next slot is within bounds.
1130                     if (nextTokenId != _currentIndex) {
1131                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1132                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1133                     }
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, to, tokenId);
1139         _afterTokenTransfers(from, to, tokenId, 1);
1140     }
1141 
1142     /**
1143      * @dev Equivalent to `_burn(tokenId, false)`.
1144      */
1145     function _burn(uint256 tokenId) internal virtual {
1146         _burn(tokenId, false);
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1160         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1161 
1162         address from = address(uint160(prevOwnershipPacked));
1163 
1164         if (approvalCheck) {
1165             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1166                 isApprovedForAll(from, _msgSenderERC721A()) ||
1167                 getApproved(tokenId) == _msgSenderERC721A());
1168 
1169             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1170         }
1171 
1172         _beforeTokenTransfers(from, address(0), tokenId, 1);
1173 
1174         // Clear approvals from the previous owner.
1175         delete _tokenApprovals[tokenId];
1176 
1177         // Underflow of the sender's balance is impossible because we check for
1178         // ownership above and the recipient's balance can't realistically overflow.
1179         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1180         unchecked {
1181             // Updates:
1182             // - `balance -= 1`.
1183             // - `numberBurned += 1`.
1184             //
1185             // We can directly decrement the balance, and increment the number burned.
1186             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1187             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1188 
1189             // Updates:
1190             // - `address` to the last owner.
1191             // - `startTimestamp` to the timestamp of burning.
1192             // - `burned` to `true`.
1193             // - `nextInitialized` to `true`.
1194             _packedOwnerships[tokenId] =
1195                 _addressToUint256(from) |
1196                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1197                 BITMASK_BURNED | 
1198                 BITMASK_NEXT_INITIALIZED;
1199 
1200             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1201             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1202                 uint256 nextTokenId = tokenId + 1;
1203                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1204                 if (_packedOwnerships[nextTokenId] == 0) {
1205                     // If the next slot is within bounds.
1206                     if (nextTokenId != _currentIndex) {
1207                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1208                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1209                     }
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, address(0), tokenId);
1215         _afterTokenTransfers(from, address(0), tokenId, 1);
1216 
1217         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1218         unchecked {
1219             _burnCounter++;
1220         }
1221     }
1222 
1223     /**
1224      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1225      *
1226      * @param from address representing the previous owner of the given token ID
1227      * @param to target address that will receive the tokens
1228      * @param tokenId uint256 ID of the token to be transferred
1229      * @param _data bytes optional data to send along with the call
1230      * @return bool whether the call correctly returned the expected magic value
1231      */
1232     function _checkContractOnERC721Received(
1233         address from,
1234         address to,
1235         uint256 tokenId,
1236         bytes memory _data
1237     ) private returns (bool) {
1238         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1239             bytes4 retval
1240         ) {
1241             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1242         } catch (bytes memory reason) {
1243             if (reason.length == 0) {
1244                 revert TransferToNonERC721ReceiverImplementer();
1245             } else {
1246                 assembly {
1247                     revert(add(32, reason), mload(reason))
1248                 }
1249             }
1250         }
1251     }
1252 
1253     /**
1254      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1255      * And also called before burning one token.
1256      *
1257      * startTokenId - the first token id to be transferred
1258      * quantity - the amount to be transferred
1259      *
1260      * Calling conditions:
1261      *
1262      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1263      * transferred to `to`.
1264      * - When `from` is zero, `tokenId` will be minted for `to`.
1265      * - When `to` is zero, `tokenId` will be burned by `from`.
1266      * - `from` and `to` are never both zero.
1267      */
1268     function _beforeTokenTransfers(
1269         address from,
1270         address to,
1271         uint256 startTokenId,
1272         uint256 quantity
1273     ) internal virtual {}
1274 
1275     /**
1276      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1277      * minting.
1278      * And also called after one token has been burned.
1279      *
1280      * startTokenId - the first token id to be transferred
1281      * quantity - the amount to be transferred
1282      *
1283      * Calling conditions:
1284      *
1285      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1286      * transferred to `to`.
1287      * - When `from` is zero, `tokenId` has been minted for `to`.
1288      * - When `to` is zero, `tokenId` has been burned by `from`.
1289      * - `from` and `to` are never both zero.
1290      */
1291     function _afterTokenTransfers(
1292         address from,
1293         address to,
1294         uint256 startTokenId,
1295         uint256 quantity
1296     ) internal virtual {}
1297 
1298     /**
1299      * @dev Returns the message sender (defaults to `msg.sender`).
1300      *
1301      * If you are writing GSN compatible contracts, you need to override this function.
1302      */
1303     function _msgSenderERC721A() internal view virtual returns (address) {
1304         return msg.sender;
1305     }
1306 
1307     /**
1308      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1309      */
1310     function _toString(uint256 value) internal pure returns (string memory ptr) {
1311         assembly {
1312             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1313             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1314             // We will need 1 32-byte word to store the length, 
1315             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1316             ptr := add(mload(0x40), 128)
1317             // Update the free memory pointer to allocate.
1318             mstore(0x40, ptr)
1319 
1320             // Cache the end of the memory to calculate the length later.
1321             let end := ptr
1322 
1323             // We write the string from the rightmost digit to the leftmost digit.
1324             // The following is essentially a do-while loop that also handles the zero case.
1325             // Costs a bit more than early returning for the zero case,
1326             // but cheaper in terms of deployment and overall runtime costs.
1327             for { 
1328                 // Initialize and perform the first pass without check.
1329                 let temp := value
1330                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1331                 ptr := sub(ptr, 1)
1332                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1333                 mstore8(ptr, add(48, mod(temp, 10)))
1334                 temp := div(temp, 10)
1335             } temp { 
1336                 // Keep dividing `temp` until zero.
1337                 temp := div(temp, 10)
1338             } { // Body of the for loop.
1339                 ptr := sub(ptr, 1)
1340                 mstore8(ptr, add(48, mod(temp, 10)))
1341             }
1342             
1343             let length := sub(end, ptr)
1344             // Move the pointer 32 bytes leftwards to make room for the length.
1345             ptr := sub(ptr, 32)
1346             // Store the length.
1347             mstore(ptr, length)
1348         }
1349     }
1350 }
1351 
1352 // File: contracts/harpytownwtf.sol
1353 
1354 
1355 
1356 pragma solidity ^0.8.4;
1357 
1358 
1359 
1360 contract harpytownwtf is ERC721A, Ownable {
1361     using Strings for uint256;
1362 
1363     string public  baseTokenUri;
1364     string public  placeholderTokenUri;
1365     string public baseExtension = ".json";
1366 
1367     uint public maxSupply = 10000;
1368     uint256 public maxMintAmount = 50;
1369     bool public revealed = false;
1370     bool public onlyWhitelist = false;
1371     bool public pause = true;
1372 
1373     uint public cost = 0.005 ether;
1374     mapping(address=>bool) public hasClaimed;
1375     mapping(address=>bool) public whitelisted;
1376 
1377     constructor(string memory _baseTokenURI, string memory _placeholderURI) ERC721A("harpytownwtf", "HTWTF") {
1378         baseTokenUri = _baseTokenURI;
1379         placeholderTokenUri = _placeholderURI;
1380     }
1381 
1382     function paused(bool _val) external onlyOwner {
1383         pause = _val;
1384     }
1385 
1386     function onlyWhitelisted(bool _val) external onlyOwner{
1387         onlyWhitelist = _val;
1388     }
1389 
1390     function reveal(bool _val) external onlyOwner {
1391         revealed = _val;
1392     } 
1393     
1394     function mint(uint256 quantity) external payable{
1395         require(!pause, "contract is paused!");
1396         require(quantity != 0, "please increase quantity from zero!");
1397         require(quantity <= maxMintAmount);
1398         require(totalSupply() + quantity <= maxSupply, "exceding total supply");
1399 
1400         if (onlyWhitelist) {
1401             require(whitelisted[msg.sender], "not in whitelist");
1402              internalLogic(quantity);
1403         } else {
1404             internalLogic(quantity);
1405         }
1406     }
1407 
1408     function internalLogic(uint quantity) private {
1409         if(quantity == 1 && !hasClaimed[msg.sender]) {
1410             require(hasClaimed[msg.sender] == false, "already claimed");
1411             hasClaimed[msg.sender] = true;
1412             _mint(msg.sender, quantity);
1413         } else if (quantity == 1 && hasClaimed[msg.sender]) {
1414             require(msg.value >= cost, "not enough balance!");
1415             _mint(msg.sender, quantity);
1416         } else {
1417             if(hasClaimed[msg.sender] == false) {
1418             hasClaimed[msg.sender] = true;
1419             uint totalQToCalculate = quantity - 1;
1420             uint tCost = cost * totalQToCalculate;
1421             require(msg.value >= tCost, "not enough balance to mint!");
1422             _mint(msg.sender, quantity);
1423             } else {
1424                 require(msg.value >= cost * quantity, "insufficient balance!");
1425                  _mint(msg.sender, quantity);
1426             }       
1427         }
1428 
1429     }
1430 
1431     function tokenURI(uint256 tokenId)
1432     public
1433     view
1434     virtual
1435     override
1436     returns (string memory)
1437   {
1438     require(
1439       _exists(tokenId),
1440       "ERC721Metadata: URI query for nonexistent token"
1441     );
1442     
1443     if(revealed == false) {
1444         return placeholderTokenUri;
1445     }
1446     uint256 trueId = tokenId + 1;
1447 
1448     return bytes(baseTokenUri).length > 0
1449         ? string(abi.encodePacked(baseTokenUri, trueId.toString(), baseExtension))
1450         : "";
1451   }
1452 
1453 
1454   function setTokenUri(string memory _baseTokenUri) external onlyOwner {
1455         baseTokenUri = _baseTokenUri;
1456     }
1457     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner {
1458         placeholderTokenUri = _placeholderTokenUri;
1459     }
1460 
1461     function addWhitelisted(address[] memory accounts) external onlyOwner {
1462 
1463     for (uint256 account = 0; account < accounts.length; account++) {
1464         whitelisted[accounts[account]] = true;
1465     }
1466 }
1467     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1468     maxMintAmount = _newmaxMintAmount;
1469         }
1470 
1471     function setCost(uint256 _newCost) public onlyOwner {
1472     cost = _newCost;
1473          }
1474          
1475     function withdraw() external payable onlyOwner {
1476     (bool os, ) = payable(msg.sender).call{value: address(this).balance}("");
1477     require(os);
1478   }
1479 }