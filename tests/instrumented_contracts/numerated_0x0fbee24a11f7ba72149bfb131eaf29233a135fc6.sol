1 // File: contracts/IMeta.sol
2 
3 
4 /*
5 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
6 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
7 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&--&------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
8 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&-----------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
9 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&-----------------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
10 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&--------------------------&&&&&&&&&&&&&&&&&&&&&&&&&
11 (&&&&&&&&&&&&&&&&&&&&&&&&&--------------------------------&&&&&&&&&&&&&&&&&&&&&&
12 (&&&&&&&&&&&&&&&&&&&&&&&-------------------------------------------&&&&&&&&&&&&&
13 (&&&&&&&&&&&&&&&&&&&&&-----------------------------------------------&&&&&&&&&&&
14 (&&&&&&&&&&&&&&&-----------------------------------------------------&&&&&&&&&&&
15 (&&&&&&&&&&&&--------------------------------------------------------&&&&&&&&&&&
16 (&&&&&&&&&&&&&&-----------------------------------------------------&&&&&&&&&&&&
17 (&&&&&&&&&&&&&&&&------------------------------------------------&&&&&&&&&&&&&&&
18 (&&&&&&&&&&&&&&&&-------------------------------------------------&&&&&&&&&&&&&&
19 (&&&&&&&&&&&&&&&&&------------------------------------------------&&&&&&&&&&&&&&
20 (%%%%%%%%%%%%%%%%%------------------------------------------------%%%%%%%%%%%%%%
21 (%%%%%%%%%%%%%%%%%%%---------------------------------------------%%%%%%%%%%%%%%%
22 (%%%%%%%%%%%%%%%%%%%%-------------------------------------------%%%%%%%%%%%%%%%%
23 (%%%%%%%%%%%%%%%%%%%%%%---------------------------------------%%%%%%%%%%%%%%%%%%
24 (%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------%%%%%%%%%%%%%%%%%%%%%%
25 (%%%%%%%%%%%%-----%%%%%%%%%%%%%%%-----------------------%%%%%%%%%%%%%%%%%%%%%%%%
26 (%%%%%%%----------------%%%%%%%%-------------------------%%%%%%%%%%%%%%%%%%%%%%%
27 (%%%%&------%%%%%%%--------%%%%--------------------------%%%%%%%%%%%%%%%%%%%%%%%
28 (%%%-----&%%%%%%%%%%%%%-----%%---------------------------%%%%%%%%%%%%%%%%%%%%%%%
29 /%%%-----%%%%%%%%%%%%%%%%---------------------------------%%%%%%%%%%%%%%%%%%%%%%
30 /%%%-----%%---%%%%%%%%%%%%--------------------------------%%%%%%%%%%%%%%%%%%%%%%
31 /%%%%----------%%%%%%%%%%%--------------------------------%%%%%%%%%%%%%%%%%%%%%%
32 /%%%%%%%------%%%%%%%%%%%---------------------------------%%%%%%%%%%%%%%%%%%%%%%
33 /%%%%%%%%%%%%%%%%%%%%%%%%----------------------------------%%%%%%%%%%%%%%%%%%%%%
34 /%%%%%%%%%%%%%%%%%%%%%% @creator: BapezNFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
35 /%%%%%%%%%%%%%%%%%%%%% @author: debugger, twitter.com/debuggerguy %%%%%%%%%%%%%%
36 */
37 pragma solidity ^0.8.0;
38 
39 interface IMeta 
40 {
41     function getMetadata(uint256 tokenId) external view returns (string memory);
42 }
43 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
44 
45 
46 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev These functions deal with verification of Merkle Trees proofs.
52  *
53  * The proofs can be generated using the JavaScript library
54  * https://github.com/miguelmota/merkletreejs[merkletreejs].
55  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
56  *
57  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
58  *
59  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
60  * hashing, or use a hash function other than keccak256 for hashing leaves.
61  * This is because the concatenation of a sorted pair of internal nodes in
62  * the merkle tree could be reinterpreted as a leaf value.
63  */
64 library MerkleProof {
65     /**
66      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
67      * defined by `root`. For this, a `proof` must be provided, containing
68      * sibling hashes on the branch from the leaf to the root of the tree. Each
69      * pair of leaves and each pair of pre-images are assumed to be sorted.
70      */
71     function verify(
72         bytes32[] memory proof,
73         bytes32 root,
74         bytes32 leaf
75     ) internal pure returns (bool) {
76         return processProof(proof, leaf) == root;
77     }
78 
79     /**
80      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
81      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
82      * hash matches the root of the tree. When processing the proof, the pairs
83      * of leafs & pre-images are assumed to be sorted.
84      *
85      * _Available since v4.4._
86      */
87     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
88         bytes32 computedHash = leaf;
89         for (uint256 i = 0; i < proof.length; i++) {
90             bytes32 proofElement = proof[i];
91             if (computedHash <= proofElement) {
92                 // Hash(current computed hash + current element of the proof)
93                 computedHash = _efficientHash(computedHash, proofElement);
94             } else {
95                 // Hash(current element of the proof + current computed hash)
96                 computedHash = _efficientHash(proofElement, computedHash);
97             }
98         }
99         return computedHash;
100     }
101 
102     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
103         assembly {
104             mstore(0x00, a)
105             mstore(0x20, b)
106             value := keccak256(0x00, 0x40)
107         }
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Context.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/security/Pausable.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 
146 /**
147  * @dev Contract module which allows children to implement an emergency stop
148  * mechanism that can be triggered by an authorized account.
149  *
150  * This module is used through inheritance. It will make available the
151  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
152  * the functions of your contract. Note that they will not be pausable by
153  * simply including this module, only once the modifiers are put in place.
154  */
155 abstract contract Pausable is Context {
156     /**
157      * @dev Emitted when the pause is triggered by `account`.
158      */
159     event Paused(address account);
160 
161     /**
162      * @dev Emitted when the pause is lifted by `account`.
163      */
164     event Unpaused(address account);
165 
166     bool private _paused;
167 
168     /**
169      * @dev Initializes the contract in unpaused state.
170      */
171     constructor() {
172         _paused = false;
173     }
174 
175     /**
176      * @dev Returns true if the contract is paused, and false otherwise.
177      */
178     function paused() public view virtual returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is not paused.
184      *
185      * Requirements:
186      *
187      * - The contract must not be paused.
188      */
189     modifier whenNotPaused() {
190         require(!paused(), "Pausable: paused");
191         _;
192     }
193 
194     /**
195      * @dev Modifier to make a function callable only when the contract is paused.
196      *
197      * Requirements:
198      *
199      * - The contract must be paused.
200      */
201     modifier whenPaused() {
202         require(paused(), "Pausable: not paused");
203         _;
204     }
205 
206     /**
207      * @dev Triggers stopped state.
208      *
209      * Requirements:
210      *
211      * - The contract must not be paused.
212      */
213     function _pause() internal virtual whenNotPaused {
214         _paused = true;
215         emit Paused(_msgSender());
216     }
217 
218     /**
219      * @dev Returns to normal state.
220      *
221      * Requirements:
222      *
223      * - The contract must be paused.
224      */
225     function _unpause() internal virtual whenPaused {
226         _paused = false;
227         emit Unpaused(_msgSender());
228     }
229 }
230 
231 // File: @openzeppelin/contracts/access/Ownable.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * By default, the owner account will be the one that deploys the contract. This
245  * can later be changed with {transferOwnership}.
246  *
247  * This module is used through inheritance. It will make available the modifier
248  * `onlyOwner`, which can be applied to your functions to restrict their use to
249  * the owner.
250  */
251 abstract contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor() {
260         _transferOwnership(_msgSender());
261     }
262 
263     /**
264      * @dev Returns the address of the current owner.
265      */
266     function owner() public view virtual returns (address) {
267         return _owner;
268     }
269 
270     /**
271      * @dev Throws if called by any account other than the owner.
272      */
273     modifier onlyOwner() {
274         require(owner() == _msgSender(), "Ownable: caller is not the owner");
275         _;
276     }
277 
278     /**
279      * @dev Leaves the contract without owner. It will not be possible to call
280      * `onlyOwner` functions anymore. Can only be called by the current owner.
281      *
282      * NOTE: Renouncing ownership will leave the contract without an owner,
283      * thereby removing any functionality that is only available to the owner.
284      */
285     function renounceOwnership() public virtual onlyOwner {
286         _transferOwnership(address(0));
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Can only be called by the current owner.
292      */
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0), "Ownable: new owner is the zero address");
295         _transferOwnership(newOwner);
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      * Internal function without access restriction.
301      */
302     function _transferOwnership(address newOwner) internal virtual {
303         address oldOwner = _owner;
304         _owner = newOwner;
305         emit OwnershipTransferred(oldOwner, newOwner);
306     }
307 }
308 
309 // File: erc721a/contracts/IERC721A.sol
310 
311 
312 // ERC721A Contracts v4.0.0
313 // Creator: Chiru Labs
314 
315 pragma solidity ^0.8.4;
316 
317 /**
318  * @dev Interface of an ERC721A compliant contract.
319  */
320 interface IERC721A {
321     /**
322      * The caller must own the token or be an approved operator.
323      */
324     error ApprovalCallerNotOwnerNorApproved();
325 
326     /**
327      * The token does not exist.
328      */
329     error ApprovalQueryForNonexistentToken();
330 
331     /**
332      * The caller cannot approve to their own address.
333      */
334     error ApproveToCaller();
335 
336     /**
337      * The caller cannot approve to the current owner.
338      */
339     error ApprovalToCurrentOwner();
340 
341     /**
342      * Cannot query the balance for the zero address.
343      */
344     error BalanceQueryForZeroAddress();
345 
346     /**
347      * Cannot mint to the zero address.
348      */
349     error MintToZeroAddress();
350 
351     /**
352      * The quantity of tokens minted must be more than zero.
353      */
354     error MintZeroQuantity();
355 
356     /**
357      * The token does not exist.
358      */
359     error OwnerQueryForNonexistentToken();
360 
361     /**
362      * The caller must own the token or be an approved operator.
363      */
364     error TransferCallerNotOwnerNorApproved();
365 
366     /**
367      * The token must be owned by `from`.
368      */
369     error TransferFromIncorrectOwner();
370 
371     /**
372      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
373      */
374     error TransferToNonERC721ReceiverImplementer();
375 
376     /**
377      * Cannot transfer to the zero address.
378      */
379     error TransferToZeroAddress();
380 
381     /**
382      * The token does not exist.
383      */
384     error URIQueryForNonexistentToken();
385 
386     struct TokenOwnership {
387         // The address of the owner.
388         address addr;
389         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
390         uint64 startTimestamp;
391         // Whether the token has been burned.
392         bool burned;
393     }
394 
395     /**
396      * @dev Returns the total amount of tokens stored by the contract.
397      *
398      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
399      */
400     function totalSupply() external view returns (uint256);
401 
402     // ==============================
403     //            IERC165
404     // ==============================
405 
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 
416     // ==============================
417     //            IERC721
418     // ==============================
419 
420     /**
421      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
424 
425     /**
426      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
427      */
428     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
432      */
433     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
434 
435     /**
436      * @dev Returns the number of tokens in ``owner``'s account.
437      */
438     function balanceOf(address owner) external view returns (uint256 balance);
439 
440     /**
441      * @dev Returns the owner of the `tokenId` token.
442      *
443      * Requirements:
444      *
445      * - `tokenId` must exist.
446      */
447     function ownerOf(uint256 tokenId) external view returns (address owner);
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId,
466         bytes calldata data
467     ) external;
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
471      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must exist and be owned by `from`.
478      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId
487     ) external;
488 
489     /**
490      * @dev Transfers `tokenId` token from `from` to `to`.
491      *
492      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must be owned by `from`.
499      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
500      *
501      * Emits a {Transfer} event.
502      */
503     function transferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
511      * The approval is cleared when the token is transferred.
512      *
513      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
514      *
515      * Requirements:
516      *
517      * - The caller must own the token or be an approved operator.
518      * - `tokenId` must exist.
519      *
520      * Emits an {Approval} event.
521      */
522     function approve(address to, uint256 tokenId) external;
523 
524     /**
525      * @dev Approve or remove `operator` as an operator for the caller.
526      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
527      *
528      * Requirements:
529      *
530      * - The `operator` cannot be the caller.
531      *
532      * Emits an {ApprovalForAll} event.
533      */
534     function setApprovalForAll(address operator, bool _approved) external;
535 
536     /**
537      * @dev Returns the account approved for `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function getApproved(uint256 tokenId) external view returns (address operator);
544 
545     /**
546      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
547      *
548      * See {setApprovalForAll}
549      */
550     function isApprovedForAll(address owner, address operator) external view returns (bool);
551 
552     // ==============================
553     //        IERC721Metadata
554     // ==============================
555 
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() external view returns (string memory);
560 
561     /**
562      * @dev Returns the token collection symbol.
563      */
564     function symbol() external view returns (string memory);
565 
566     /**
567      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
568      */
569     function tokenURI(uint256 tokenId) external view returns (string memory);
570 }
571 
572 // File: erc721a/contracts/ERC721A.sol
573 
574 
575 // ERC721A Contracts v4.0.0
576 // Creator: Chiru Labs
577 
578 pragma solidity ^0.8.4;
579 
580 
581 /**
582  * @dev ERC721 token receiver interface.
583  */
584 interface ERC721A__IERC721Receiver {
585     function onERC721Received(
586         address operator,
587         address from,
588         uint256 tokenId,
589         bytes calldata data
590     ) external returns (bytes4);
591 }
592 
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension. Built to optimize for lower gas during batch mints.
596  *
597  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
598  *
599  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
600  *
601  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
602  */
603 contract ERC721A is IERC721A {
604     // Mask of an entry in packed address data.
605     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
606 
607     // The bit position of `numberMinted` in packed address data.
608     uint256 private constant BITPOS_NUMBER_MINTED = 64;
609 
610     // The bit position of `numberBurned` in packed address data.
611     uint256 private constant BITPOS_NUMBER_BURNED = 128;
612 
613     // The bit position of `aux` in packed address data.
614     uint256 private constant BITPOS_AUX = 192;
615 
616     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
617     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
618 
619     // The bit position of `startTimestamp` in packed ownership.
620     uint256 private constant BITPOS_START_TIMESTAMP = 160;
621 
622     // The bit mask of the `burned` bit in packed ownership.
623     uint256 private constant BITMASK_BURNED = 1 << 224;
624     
625     // The bit position of the `nextInitialized` bit in packed ownership.
626     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
627 
628     // The bit mask of the `nextInitialized` bit in packed ownership.
629     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
630 
631     // The tokenId of the next token to be minted.
632     uint256 private _currentIndex;
633 
634     // The number of tokens burned.
635     uint256 private _burnCounter;
636 
637     // Token name
638     string private _name;
639 
640     // Token symbol
641     string private _symbol;
642 
643     // Mapping from token ID to ownership details
644     // An empty struct value does not necessarily mean the token is unowned.
645     // See `_packedOwnershipOf` implementation for details.
646     //
647     // Bits Layout:
648     // - [0..159]   `addr`
649     // - [160..223] `startTimestamp`
650     // - [224]      `burned`
651     // - [225]      `nextInitialized`
652     mapping(uint256 => uint256) private _packedOwnerships;
653 
654     // Mapping owner address to address data.
655     //
656     // Bits Layout:
657     // - [0..63]    `balance`
658     // - [64..127]  `numberMinted`
659     // - [128..191] `numberBurned`
660     // - [192..255] `aux`
661     mapping(address => uint256) private _packedAddressData;
662 
663     // Mapping from token ID to approved address.
664     mapping(uint256 => address) private _tokenApprovals;
665 
666     // Mapping from owner to operator approvals
667     mapping(address => mapping(address => bool)) private _operatorApprovals;
668 
669     constructor(string memory name_, string memory symbol_) {
670         _name = name_;
671         _symbol = symbol_;
672         _currentIndex = _startTokenId();
673     }
674 
675     /**
676      * @dev Returns the starting token ID. 
677      * To change the starting token ID, please override this function.
678      */
679     function _startTokenId() internal view virtual returns (uint256) {
680         return 0;
681     }
682 
683     /**
684      * @dev Returns the next token ID to be minted.
685      */
686     function _nextTokenId() internal view returns (uint256) {
687         return _currentIndex;
688     }
689 
690     /**
691      * @dev Returns the total number of tokens in existence.
692      * Burned tokens will reduce the count. 
693      * To get the total number of tokens minted, please see `_totalMinted`.
694      */
695     function totalSupply() public view override returns (uint256) {
696         // Counter underflow is impossible as _burnCounter cannot be incremented
697         // more than `_currentIndex - _startTokenId()` times.
698         unchecked {
699             return _currentIndex - _burnCounter - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev Returns the total amount of tokens minted in the contract.
705      */
706     function _totalMinted() internal view returns (uint256) {
707         // Counter underflow is impossible as _currentIndex does not decrement,
708         // and it is initialized to `_startTokenId()`
709         unchecked {
710             return _currentIndex - _startTokenId();
711         }
712     }
713 
714     /**
715      * @dev Returns the total number of tokens burned.
716      */
717     function _totalBurned() internal view returns (uint256) {
718         return _burnCounter;
719     }
720 
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725         // The interface IDs are constants representing the first 4 bytes of the XOR of
726         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
727         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
728         return
729             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
730             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
731             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
732     }
733 
734     /**
735      * @dev See {IERC721-balanceOf}.
736      */
737     function balanceOf(address owner) public view override returns (uint256) {
738         if (owner == address(0)) revert BalanceQueryForZeroAddress();
739         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
740     }
741 
742     /**
743      * Returns the number of tokens minted by `owner`.
744      */
745     function _numberMinted(address owner) internal view returns (uint256) {
746         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
747     }
748 
749     /**
750      * Returns the number of tokens burned by or on behalf of `owner`.
751      */
752     function _numberBurned(address owner) internal view returns (uint256) {
753         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
754     }
755 
756     /**
757      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
758      */
759     function _getAux(address owner) internal view returns (uint64) {
760         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
761     }
762 
763     /**
764      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
765      * If there are multiple variables, please pack them into a uint64.
766      */
767     function _setAux(address owner, uint64 aux) internal {
768         uint256 packed = _packedAddressData[owner];
769         uint256 auxCasted;
770         assembly { // Cast aux without masking.
771             auxCasted := aux
772         }
773         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
774         _packedAddressData[owner] = packed;
775     }
776 
777     /**
778      * Returns the packed ownership data of `tokenId`.
779      */
780     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
781         uint256 curr = tokenId;
782 
783         unchecked {
784             if (_startTokenId() <= curr)
785                 if (curr < _currentIndex) {
786                     uint256 packed = _packedOwnerships[curr];
787                     // If not burned.
788                     if (packed & BITMASK_BURNED == 0) {
789                         // Invariant:
790                         // There will always be an ownership that has an address and is not burned
791                         // before an ownership that does not have an address and is not burned.
792                         // Hence, curr will not underflow.
793                         //
794                         // We can directly compare the packed value.
795                         // If the address is zero, packed is zero.
796                         while (packed == 0) {
797                             packed = _packedOwnerships[--curr];
798                         }
799                         return packed;
800                     }
801                 }
802         }
803         revert OwnerQueryForNonexistentToken();
804     }
805 
806     /**
807      * Returns the unpacked `TokenOwnership` struct from `packed`.
808      */
809     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
810         ownership.addr = address(uint160(packed));
811         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
812         ownership.burned = packed & BITMASK_BURNED != 0;
813     }
814 
815     /**
816      * Returns the unpacked `TokenOwnership` struct at `index`.
817      */
818     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
819         return _unpackedOwnership(_packedOwnerships[index]);
820     }
821 
822     /**
823      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
824      */
825     function _initializeOwnershipAt(uint256 index) internal {
826         if (_packedOwnerships[index] == 0) {
827             _packedOwnerships[index] = _packedOwnershipOf(index);
828         }
829     }
830 
831     /**
832      * Gas spent here starts off proportional to the maximum mint batch size.
833      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
834      */
835     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
836         return _unpackedOwnership(_packedOwnershipOf(tokenId));
837     }
838 
839     /**
840      * @dev See {IERC721-ownerOf}.
841      */
842     function ownerOf(uint256 tokenId) public view override returns (address) {
843         return address(uint160(_packedOwnershipOf(tokenId)));
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-name}.
848      */
849     function name() public view virtual override returns (string memory) {
850         return _name;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-symbol}.
855      */
856     function symbol() public view virtual override returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-tokenURI}.
862      */
863     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
864         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
865 
866         string memory baseURI = _baseURI();
867         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
868     }
869 
870     /**
871      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
872      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
873      * by default, can be overriden in child contracts.
874      */
875     function _baseURI() internal view virtual returns (string memory) {
876         return '';
877     }
878 
879     /**
880      * @dev Casts the address to uint256 without masking.
881      */
882     function _addressToUint256(address value) private pure returns (uint256 result) {
883         assembly {
884             result := value
885         }
886     }
887 
888     /**
889      * @dev Casts the boolean to uint256 without branching.
890      */
891     function _boolToUint256(bool value) private pure returns (uint256 result) {
892         assembly {
893             result := value
894         }
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public override {
901         address owner = address(uint160(_packedOwnershipOf(tokenId)));
902         if (to == owner) revert ApprovalToCurrentOwner();
903 
904         if (_msgSenderERC721A() != owner)
905             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
906                 revert ApprovalCallerNotOwnerNorApproved();
907             }
908 
909         _tokenApprovals[tokenId] = to;
910         emit Approval(owner, to, tokenId);
911     }
912 
913     /**
914      * @dev See {IERC721-getApproved}.
915      */
916     function getApproved(uint256 tokenId) public view override returns (address) {
917         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
918 
919         return _tokenApprovals[tokenId];
920     }
921 
922     /**
923      * @dev See {IERC721-setApprovalForAll}.
924      */
925     function setApprovalForAll(address operator, bool approved) public virtual override {
926         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
927 
928         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
929         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
936         return _operatorApprovals[owner][operator];
937     }
938 
939     /**
940      * @dev See {IERC721-transferFrom}.
941      */
942     function transferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         _transfer(from, to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         safeTransferFrom(from, to, tokenId, '');
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) public virtual override {
970         _transfer(from, to, tokenId);
971         if (to.code.length != 0)
972             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
973                 revert TransferToNonERC721ReceiverImplementer();
974             }
975     }
976 
977     /**
978      * @dev Returns whether `tokenId` exists.
979      *
980      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981      *
982      * Tokens start existing when they are minted (`_mint`),
983      */
984     function _exists(uint256 tokenId) internal view returns (bool) {
985         return
986             _startTokenId() <= tokenId &&
987             tokenId < _currentIndex && // If within bounds,
988             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
989     }
990 
991     /**
992      * @dev Equivalent to `_safeMint(to, quantity, '')`.
993      */
994     function _safeMint(address to, uint256 quantity) internal {
995         _safeMint(to, quantity, '');
996     }
997 
998     /**
999      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - If `to` refers to a smart contract, it must implement
1004      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeMint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data
1013     ) internal {
1014         uint256 startTokenId = _currentIndex;
1015         if (to == address(0)) revert MintToZeroAddress();
1016         if (quantity == 0) revert MintZeroQuantity();
1017 
1018         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1019 
1020         // Overflows are incredibly unrealistic.
1021         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1022         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1023         unchecked {
1024             // Updates:
1025             // - `balance += quantity`.
1026             // - `numberMinted += quantity`.
1027             //
1028             // We can directly add to the balance and number minted.
1029             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1030 
1031             // Updates:
1032             // - `address` to the owner.
1033             // - `startTimestamp` to the timestamp of minting.
1034             // - `burned` to `false`.
1035             // - `nextInitialized` to `quantity == 1`.
1036             _packedOwnerships[startTokenId] =
1037                 _addressToUint256(to) |
1038                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1039                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1040 
1041             uint256 updatedIndex = startTokenId;
1042             uint256 end = updatedIndex + quantity;
1043 
1044             if (to.code.length != 0) {
1045                 do {
1046                     emit Transfer(address(0), to, updatedIndex);
1047                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1048                         revert TransferToNonERC721ReceiverImplementer();
1049                     }
1050                 } while (updatedIndex < end);
1051                 // Reentrancy protection
1052                 if (_currentIndex != startTokenId) revert();
1053             } else {
1054                 do {
1055                     emit Transfer(address(0), to, updatedIndex++);
1056                 } while (updatedIndex < end);
1057             }
1058             _currentIndex = updatedIndex;
1059         }
1060         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1061     }
1062 
1063     /**
1064      * @dev Mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 quantity) internal {
1074         uint256 startTokenId = _currentIndex;
1075         if (to == address(0)) revert MintToZeroAddress();
1076         if (quantity == 0) revert MintZeroQuantity();
1077 
1078         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1079 
1080         // Overflows are incredibly unrealistic.
1081         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1082         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1083         unchecked {
1084             // Updates:
1085             // - `balance += quantity`.
1086             // - `numberMinted += quantity`.
1087             //
1088             // We can directly add to the balance and number minted.
1089             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1090 
1091             // Updates:
1092             // - `address` to the owner.
1093             // - `startTimestamp` to the timestamp of minting.
1094             // - `burned` to `false`.
1095             // - `nextInitialized` to `quantity == 1`.
1096             _packedOwnerships[startTokenId] =
1097                 _addressToUint256(to) |
1098                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1099                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1100 
1101             uint256 updatedIndex = startTokenId;
1102             uint256 end = updatedIndex + quantity;
1103 
1104             do {
1105                 emit Transfer(address(0), to, updatedIndex++);
1106             } while (updatedIndex < end);
1107 
1108             _currentIndex = updatedIndex;
1109         }
1110         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1111     }
1112 
1113     /**
1114      * @dev Transfers `tokenId` from `from` to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must be owned by `from`.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _transfer(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) private {
1128         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1129 
1130         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1131 
1132         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1133             isApprovedForAll(from, _msgSenderERC721A()) ||
1134             getApproved(tokenId) == _msgSenderERC721A());
1135 
1136         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1137         if (to == address(0)) revert TransferToZeroAddress();
1138 
1139         _beforeTokenTransfers(from, to, tokenId, 1);
1140 
1141         // Clear approvals from the previous owner.
1142         delete _tokenApprovals[tokenId];
1143 
1144         // Underflow of the sender's balance is impossible because we check for
1145         // ownership above and the recipient's balance can't realistically overflow.
1146         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1147         unchecked {
1148             // We can directly increment and decrement the balances.
1149             --_packedAddressData[from]; // Updates: `balance -= 1`.
1150             ++_packedAddressData[to]; // Updates: `balance += 1`.
1151 
1152             // Updates:
1153             // - `address` to the next owner.
1154             // - `startTimestamp` to the timestamp of transfering.
1155             // - `burned` to `false`.
1156             // - `nextInitialized` to `true`.
1157             _packedOwnerships[tokenId] =
1158                 _addressToUint256(to) |
1159                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1160                 BITMASK_NEXT_INITIALIZED;
1161 
1162             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1163             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1164                 uint256 nextTokenId = tokenId + 1;
1165                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1166                 if (_packedOwnerships[nextTokenId] == 0) {
1167                     // If the next slot is within bounds.
1168                     if (nextTokenId != _currentIndex) {
1169                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1170                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1171                     }
1172                 }
1173             }
1174         }
1175 
1176         emit Transfer(from, to, tokenId);
1177         _afterTokenTransfers(from, to, tokenId, 1);
1178     }
1179 
1180     /**
1181      * @dev Equivalent to `_burn(tokenId, false)`.
1182      */
1183     function _burn(uint256 tokenId) internal virtual {
1184         _burn(tokenId, false);
1185     }
1186 
1187     /**
1188      * @dev Destroys `tokenId`.
1189      * The approval is cleared when the token is burned.
1190      *
1191      * Requirements:
1192      *
1193      * - `tokenId` must exist.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1198         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1199 
1200         address from = address(uint160(prevOwnershipPacked));
1201 
1202         if (approvalCheck) {
1203             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1204                 isApprovedForAll(from, _msgSenderERC721A()) ||
1205                 getApproved(tokenId) == _msgSenderERC721A());
1206 
1207             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1208         }
1209 
1210         _beforeTokenTransfers(from, address(0), tokenId, 1);
1211 
1212         // Clear approvals from the previous owner.
1213         delete _tokenApprovals[tokenId];
1214 
1215         // Underflow of the sender's balance is impossible because we check for
1216         // ownership above and the recipient's balance can't realistically overflow.
1217         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1218         unchecked {
1219             // Updates:
1220             // - `balance -= 1`.
1221             // - `numberBurned += 1`.
1222             //
1223             // We can directly decrement the balance, and increment the number burned.
1224             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1225             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1226 
1227             // Updates:
1228             // - `address` to the last owner.
1229             // - `startTimestamp` to the timestamp of burning.
1230             // - `burned` to `true`.
1231             // - `nextInitialized` to `true`.
1232             _packedOwnerships[tokenId] =
1233                 _addressToUint256(from) |
1234                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1235                 BITMASK_BURNED | 
1236                 BITMASK_NEXT_INITIALIZED;
1237 
1238             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1239             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1240                 uint256 nextTokenId = tokenId + 1;
1241                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1242                 if (_packedOwnerships[nextTokenId] == 0) {
1243                     // If the next slot is within bounds.
1244                     if (nextTokenId != _currentIndex) {
1245                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1246                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1247                     }
1248                 }
1249             }
1250         }
1251 
1252         emit Transfer(from, address(0), tokenId);
1253         _afterTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1256         unchecked {
1257             _burnCounter++;
1258         }
1259     }
1260 
1261     /**
1262      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1263      *
1264      * @param from address representing the previous owner of the given token ID
1265      * @param to target address that will receive the tokens
1266      * @param tokenId uint256 ID of the token to be transferred
1267      * @param _data bytes optional data to send along with the call
1268      * @return bool whether the call correctly returned the expected magic value
1269      */
1270     function _checkContractOnERC721Received(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) private returns (bool) {
1276         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1277             bytes4 retval
1278         ) {
1279             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1280         } catch (bytes memory reason) {
1281             if (reason.length == 0) {
1282                 revert TransferToNonERC721ReceiverImplementer();
1283             } else {
1284                 assembly {
1285                     revert(add(32, reason), mload(reason))
1286                 }
1287             }
1288         }
1289     }
1290 
1291     /**
1292      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1293      * And also called before burning one token.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, `tokenId` will be burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _beforeTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 
1313     /**
1314      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1315      * minting.
1316      * And also called after one token has been burned.
1317      *
1318      * startTokenId - the first token id to be transferred
1319      * quantity - the amount to be transferred
1320      *
1321      * Calling conditions:
1322      *
1323      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1324      * transferred to `to`.
1325      * - When `from` is zero, `tokenId` has been minted for `to`.
1326      * - When `to` is zero, `tokenId` has been burned by `from`.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _afterTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 
1336     /**
1337      * @dev Returns the message sender (defaults to `msg.sender`).
1338      *
1339      * If you are writing GSN compatible contracts, you need to override this function.
1340      */
1341     function _msgSenderERC721A() internal view virtual returns (address) {
1342         return msg.sender;
1343     }
1344 
1345     /**
1346      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1347      */
1348     function _toString(uint256 value) internal pure returns (string memory ptr) {
1349         assembly {
1350             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1351             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1352             // We will need 1 32-byte word to store the length, 
1353             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1354             ptr := add(mload(0x40), 128)
1355             // Update the free memory pointer to allocate.
1356             mstore(0x40, ptr)
1357 
1358             // Cache the end of the memory to calculate the length later.
1359             let end := ptr
1360 
1361             // We write the string from the rightmost digit to the leftmost digit.
1362             // The following is essentially a do-while loop that also handles the zero case.
1363             // Costs a bit more than early returning for the zero case,
1364             // but cheaper in terms of deployment and overall runtime costs.
1365             for { 
1366                 // Initialize and perform the first pass without check.
1367                 let temp := value
1368                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1369                 ptr := sub(ptr, 1)
1370                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1371                 mstore8(ptr, add(48, mod(temp, 10)))
1372                 temp := div(temp, 10)
1373             } temp { 
1374                 // Keep dividing `temp` until zero.
1375                 temp := div(temp, 10)
1376             } { // Body of the for loop.
1377                 ptr := sub(ptr, 1)
1378                 mstore8(ptr, add(48, mod(temp, 10)))
1379             }
1380             
1381             let length := sub(end, ptr)
1382             // Move the pointer 32 bytes leftwards to make room for the length.
1383             ptr := sub(ptr, 32)
1384             // Store the length.
1385             mstore(ptr, length)
1386         }
1387     }
1388 }
1389 
1390 // File: contracts/BapezJungle.sol
1391 
1392 //SPDX-License-Identifier: MIT
1393 /*
1394 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1395 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1396 #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&--&------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1397 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&-----------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1398 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&-----------------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
1399 (&&&&&&&&&&&&&&&&&&&&&&&&&&&&--------------------------&&&&&&&&&&&&&&&&&&&&&&&&&
1400 (&&&&&&&&&&&&&&&&&&&&&&&&&--------------------------------&&&&&&&&&&&&&&&&&&&&&&
1401 (&&&&&&&&&&&&&&&&&&&&&&&-------------------------------------------&&&&&&&&&&&&&
1402 (&&&&&&&&&&&&&&&&&&&&&-----------------------------------------------&&&&&&&&&&&
1403 (&&&&&&&&&&&&&&&-----------------------------------------------------&&&&&&&&&&&
1404 (&&&&&&&&&&&&--------------------------------------------------------&&&&&&&&&&&
1405 (&&&&&&&&&&&&&&-----------------------------------------------------&&&&&&&&&&&&
1406 (&&&&&&&&&&&&&&&&------------------------------------------------&&&&&&&&&&&&&&&
1407 (&&&&&&&&&&&&&&&&-------------------------------------------------&&&&&&&&&&&&&&
1408 (&&&&&&&&&&&&&&&&&------------------------------------------------&&&&&&&&&&&&&&
1409 (%%%%%%%%%%%%%%%%%------------------------------------------------%%%%%%%%%%%%%%
1410 (%%%%%%%%%%%%%%%%%%%---------------------------------------------%%%%%%%%%%%%%%%
1411 (%%%%%%%%%%%%%%%%%%%%-------------------------------------------%%%%%%%%%%%%%%%%
1412 (%%%%%%%%%%%%%%%%%%%%%%---------------------------------------%%%%%%%%%%%%%%%%%%
1413 (%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------%%%%%%%%%%%%%%%%%%%%%%
1414 (%%%%%%%%%%%%-----%%%%%%%%%%%%%%%-----------------------%%%%%%%%%%%%%%%%%%%%%%%%
1415 (%%%%%%%----------------%%%%%%%%-------------------------%%%%%%%%%%%%%%%%%%%%%%%
1416 (%%%%&------%%%%%%%--------%%%%--------------------------%%%%%%%%%%%%%%%%%%%%%%%
1417 (%%%-----&%%%%%%%%%%%%%-----%%---------------------------%%%%%%%%%%%%%%%%%%%%%%%
1418 /%%%-----%%%%%%%%%%%%%%%%---------------------------------%%%%%%%%%%%%%%%%%%%%%%
1419 /%%%-----%%---%%%%%%%%%%%%--------------------------------%%%%%%%%%%%%%%%%%%%%%%
1420 /%%%%----------%%%%%%%%%%%--------------------------------%%%%%%%%%%%%%%%%%%%%%%
1421 /%%%%%%%------%%%%%%%%%%%---------------------------------%%%%%%%%%%%%%%%%%%%%%%
1422 /%%%%%%%%%%%%%%%%%%%%%%%%----------------------------------%%%%%%%%%%%%%%%%%%%%%
1423 /%%%%%%%%%%%%%%%%%%%%%% @creator: BapezNFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
1424 /%%%%%%%%%%%%%%%%%%%%% @author: debugger, twitter.com/debuggerguy %%%%%%%%%%%%%%
1425 */
1426 
1427 
1428 pragma solidity ^0.8.0; 
1429 
1430 
1431 
1432 
1433 
1434 
1435 contract BapezJungle is ERC721A, Ownable, Pausable 
1436 {
1437        
1438     uint256 public bapezFreeLimit = 1 ;
1439     uint256 public bapezBFFLimit = 2 ;
1440     uint256 public bapezFreeColSize = 3055 ;
1441 
1442     uint256 public mintPrice = 0.0055 ether;
1443     uint256 public totalColSize = 5555;
1444     uint256 public publicLimit = 5;
1445 
1446     bytes32 public bapezFreeWLMerkleRoot = 0x70dac3333f0e4fb2c7c858abae1bd930c10e8acc325e8914328f144b0c02356e;
1447 
1448     string private _baseTokenURI;
1449     
1450     bool public freeSaleActive;
1451 
1452 
1453     mapping(address => uint256) public publicMintList;
1454     mapping(address => uint256) public freeMintList;
1455 
1456     address public mdProvider;
1457 
1458     constructor
1459     ( 
1460        string memory _name,
1461        string memory _symbol,
1462        address _mdProvider
1463     ) ERC721A(_name, _symbol) 
1464     {
1465         mdProvider = _mdProvider;
1466     }
1467 
1468     modifier callerIsUser() 
1469     {
1470         require(tx.origin == msg.sender, "Caller is contract");
1471         _;
1472     }
1473 
1474     modifier onlyBapezFreeSaleActive() {
1475         require(freeSaleActive, "BapezFree-Sale is not active");
1476         _;
1477     }
1478 
1479     function setMdProvider(address _mdProvider) external onlyOwner {
1480         mdProvider = _mdProvider;
1481     }
1482 
1483     function tokenURI(uint256 _tokenId)
1484         public
1485         view
1486         virtual
1487         override
1488         returns (string memory)
1489     {
1490         require(_exists(_tokenId), "Token not existed");
1491         require( mdProvider != address(0),
1492             "Invalid metadata provider address"
1493         );
1494 
1495         return IMeta(mdProvider).getMetadata(_tokenId);
1496     }
1497     
1498     function _startTokenId() internal pure override returns (uint256) {
1499         return 1;
1500     }
1501 
1502     function bapezFreeMint(uint256 quantity)
1503         external
1504         payable
1505         onlyBapezFreeSaleActive
1506         callerIsUser 
1507     {
1508          require( freeMintList[msg.sender] + quantity <= bapezFreeLimit,
1509                  "Mint Limit Exceeded"
1510          );
1511         require(totalSupply() + quantity <= bapezFreeColSize , "EXCEED_COL_SIZE");        
1512 
1513         freeMintList[msg.sender] += quantity;
1514         _safeMint(msg.sender, quantity);
1515     }
1516 
1517     function bapezBFFMint(bytes32[] calldata _merkleProof, uint256 quantity)
1518         external
1519         payable
1520         onlyBapezFreeSaleActive
1521         callerIsUser 
1522     {
1523         require( freeMintList[msg.sender] + quantity <= bapezBFFLimit,
1524                  "Mint Limit Exceeded"
1525         );
1526         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1527         require(
1528              MerkleProof.verify(_merkleProof, bapezFreeWLMerkleRoot, leaf),
1529              "Merkle proof invalid"
1530          );
1531         require(totalSupply() + quantity <= bapezFreeColSize , "EXCEED_COL_SIZE");        
1532 
1533         freeMintList[msg.sender] += quantity;
1534         _safeMint(msg.sender, quantity);
1535     }
1536 
1537     function publicMint(uint256 quantity)
1538         external
1539         payable
1540         callerIsUser    
1541     {
1542         require(totalSupply() >= bapezFreeColSize, "Free mint has not finished yet");
1543         require(publicMintList[msg.sender] + quantity <= publicLimit, "Up to 5 mints allowed");
1544         require(msg.value >= mintPrice * quantity, "Insufficient funds");
1545         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1546 
1547         publicMintList[msg.sender] += quantity;
1548         _safeMint(msg.sender, quantity);
1549         
1550     }
1551     
1552     function ownerMint(uint256 quantity)
1553         external
1554         payable
1555         onlyOwner
1556     {
1557         require(quantity > 0, "Invalid quantity");
1558         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1559 
1560         _safeMint(msg.sender, quantity);
1561     }
1562 
1563     function holderMint(address ogBapez,uint256 quantity)
1564         external
1565         payable
1566         onlyOwner
1567     {
1568         require(quantity > 0, "Invalid quantity");
1569         require(totalSupply() + quantity <= totalColSize, "EXCEED_COL_SIZE");
1570 
1571         _safeMint(ogBapez, quantity);
1572     }
1573 
1574     function togglefreeSale() 
1575         external 
1576         onlyOwner 
1577     {
1578         freeSaleActive = !freeSaleActive;
1579     }
1580 
1581     function setBapezFreeWLMerkleRoot(bytes32 _bapezFreeWLMerkleRoot)
1582         external
1583         onlyOwner
1584     {
1585         bapezFreeWLMerkleRoot = _bapezFreeWLMerkleRoot;
1586     }
1587 
1588     function pause() external onlyOwner {
1589         _pause();
1590     }
1591 
1592     function unpause() external onlyOwner {
1593         _unpause();
1594     }
1595     
1596     //stop transfer on pause
1597     function _beforeTokenTransfers(
1598         address from,
1599         address to,
1600         uint256 tokenId,
1601         uint256 quantity
1602     ) internal override(ERC721A) whenNotPaused 
1603     {
1604         
1605         super._beforeTokenTransfers(from, to, tokenId, quantity);
1606     }
1607 
1608     function withdraw() 
1609         external 
1610         onlyOwner 
1611     {
1612         uint256 totalBalance = address(this).balance;
1613 
1614         address COMMUNITY_WALLET = 0x9f79De05F4f5f6520665402c633613DD2477CFfB;
1615         address FOUNDER = 0xf6a8B433B79334f9937bd1C57bD058a37Dc3Edf8;
1616         address ARTIST = 0xD55779fA12Ed38445CE5111C527b450AFE4DF32D;
1617         address TECH_LEAD = 0x18226CFfdA30ed33FD6CCD6A8CB9F6794Df48f63;
1618         address MARKETING_MANAGER = 0x4a5003Fa3491c8be0D44B26e3123caB569193B88;
1619         address MODERATORS = 0x4FC7E224d84735462189f7bFacf06A15FAf8B7C3;
1620         address COMMUNICATIONS_MANAGER = 0x09E480E968F7e90e0Dd0bf2F6910A73134c969e2;
1621         
1622         payable(COMMUNITY_WALLET).transfer(
1623              ((totalBalance * 2500) / 10000)
1624         );
1625         payable(FOUNDER).transfer(
1626              ((totalBalance * 1500) / 10000)
1627         );
1628         payable(ARTIST).transfer(
1629              ((totalBalance * 1600) / 10000)
1630         );
1631         payable(TECH_LEAD).transfer(
1632              ((totalBalance * 1700) / 10000)
1633         );
1634          payable(MARKETING_MANAGER).transfer(
1635               ((totalBalance * 1500) / 10000)
1636          );
1637         payable(MODERATORS).transfer(
1638              ((totalBalance * 300) / 10000)
1639         );
1640         payable(COMMUNICATIONS_MANAGER).transfer(
1641              ((totalBalance * 900) / 10000)
1642         );
1643     }
1644 
1645     //@dev
1646     //this can be used only for reduction.
1647     function reduceSupply(uint256 _burnAmount) 
1648         external 
1649         onlyOwner 
1650     {
1651         require(_burnAmount > 0 ,"Just for reduction");
1652         require(totalSupply() < totalColSize ,"Too late" );
1653         require(totalColSize - _burnAmount >= totalSupply() ,"Insufficient amount" );
1654         totalColSize -= _burnAmount;
1655     }
1656 
1657     //this can be used only for reduction during public-sale.
1658     function changeMintPrice(uint256 _mintPrice) 
1659         external 
1660         onlyOwner 
1661     {
1662         require(_mintPrice >= 0 ,"Invalid price");
1663         require(_mintPrice < mintPrice ,"Just for reduction");
1664         mintPrice = _mintPrice;
1665     }
1666     
1667     function changePublicMintLimit(uint256 _newLimit) 
1668         external 
1669         onlyOwner 
1670     {
1671         require(_newLimit > 0 ,"Invalid value");
1672         publicLimit = _newLimit;
1673     }
1674 
1675 }