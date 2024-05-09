1 // Sources flattened with hardhat v2.10.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 
233 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes calldata) {
255         return msg.data;
256     }
257 }
258 
259 
260 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
261 
262 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Contract module which provides a basic access control mechanism, where
268  * there is an account (an owner) that can be granted exclusive access to
269  * specific functions.
270  *
271  * By default, the owner account will be the one that deploys the contract. This
272  * can later be changed with {transferOwnership}.
273  *
274  * This module is used through inheritance. It will make available the modifier
275  * `onlyOwner`, which can be applied to your functions to restrict their use to
276  * the owner.
277  */
278 abstract contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor() {
287         _transferOwnership(_msgSender());
288     }
289 
290     /**
291      * @dev Returns the address of the current owner.
292      */
293     function owner() public view virtual returns (address) {
294         return _owner;
295     }
296 
297     /**
298      * @dev Throws if called by any account other than the owner.
299      */
300     modifier onlyOwner() {
301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
302         _;
303     }
304 
305     /**
306      * @dev Leaves the contract without owner. It will not be possible to call
307      * `onlyOwner` functions anymore. Can only be called by the current owner.
308      *
309      * NOTE: Renouncing ownership will leave the contract without an owner,
310      * thereby removing any functionality that is only available to the owner.
311      */
312     function renounceOwnership() public virtual onlyOwner {
313         _transferOwnership(address(0));
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Can only be called by the current owner.
319      */
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         _transferOwnership(newOwner);
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      * Internal function without access restriction.
328      */
329     function _transferOwnership(address newOwner) internal virtual {
330         address oldOwner = _owner;
331         _owner = newOwner;
332         emit OwnershipTransferred(oldOwner, newOwner);
333     }
334 }
335 
336 
337 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
338 
339 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev These functions deal with verification of Merkle Trees proofs.
345  *
346  * The proofs can be generated using the JavaScript library
347  * https://github.com/miguelmota/merkletreejs[merkletreejs].
348  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
349  *
350  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
351  *
352  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
353  * hashing, or use a hash function other than keccak256 for hashing leaves.
354  * This is because the concatenation of a sorted pair of internal nodes in
355  * the merkle tree could be reinterpreted as a leaf value.
356  */
357 library MerkleProof {
358     /**
359      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
360      * defined by `root`. For this, a `proof` must be provided, containing
361      * sibling hashes on the branch from the leaf to the root of the tree. Each
362      * pair of leaves and each pair of pre-images are assumed to be sorted.
363      */
364     function verify(
365         bytes32[] memory proof,
366         bytes32 root,
367         bytes32 leaf
368     ) internal pure returns (bool) {
369         return processProof(proof, leaf) == root;
370     }
371 
372     /**
373      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
374      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
375      * hash matches the root of the tree. When processing the proof, the pairs
376      * of leafs & pre-images are assumed to be sorted.
377      *
378      * _Available since v4.4._
379      */
380     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
381         bytes32 computedHash = leaf;
382         for (uint256 i = 0; i < proof.length; i++) {
383             bytes32 proofElement = proof[i];
384             if (computedHash <= proofElement) {
385                 // Hash(current computed hash + current element of the proof)
386                 computedHash = _efficientHash(computedHash, proofElement);
387             } else {
388                 // Hash(current element of the proof + current computed hash)
389                 computedHash = _efficientHash(proofElement, computedHash);
390             }
391         }
392         return computedHash;
393     }
394 
395     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
396         assembly {
397             mstore(0x00, a)
398             mstore(0x20, b)
399             value := keccak256(0x00, 0x40)
400         }
401     }
402 }
403 
404 
405 // File contracts/IERC721A.sol
406 
407 // ERC721A Contracts v4.1.0
408 // Creator: Chiru Labs
409 
410 pragma solidity ^0.8.4;
411 
412 /**
413  * @dev Interface of an ERC721A compliant contract.
414  */
415 interface IERC721A {
416     /**
417      * The caller must own the token or be an approved operator.
418      */
419     error ApprovalCallerNotOwnerNorApproved();
420 
421     /**
422      * The token does not exist.
423      */
424     error ApprovalQueryForNonexistentToken();
425 
426     /**
427      * The caller cannot approve to their own address.
428      */
429     error ApproveToCaller();
430 
431     /**
432      * Cannot query the balance for the zero address.
433      */
434     error BalanceQueryForZeroAddress();
435 
436     /**
437      * Cannot mint to the zero address.
438      */
439     error MintToZeroAddress();
440 
441     /**
442      * The quantity of tokens minted must be more than zero.
443      */
444     error MintZeroQuantity();
445 
446     /**
447      * The token does not exist.
448      */
449     error OwnerQueryForNonexistentToken();
450 
451     /**
452      * The caller must own the token or be an approved operator.
453      */
454     error TransferCallerNotOwnerNorApproved();
455 
456     /**
457      * The token must be owned by `from`.
458      */
459     error TransferFromIncorrectOwner();
460 
461     /**
462      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
463      */
464     error TransferToNonERC721ReceiverImplementer();
465 
466     /**
467      * Cannot transfer to the zero address.
468      */
469     error TransferToZeroAddress();
470 
471     /**
472      * The token does not exist.
473      */
474     error URIQueryForNonexistentToken();
475 
476     /**
477      * The `quantity` minted with ERC2309 exceeds the safety limit.
478      */
479     error MintERC2309QuantityExceedsLimit();
480 
481     /**
482      * The `extraData` cannot be set on an unintialized ownership slot.
483      */
484     error OwnershipNotInitializedForExtraData();
485 
486     struct TokenOwnership {
487         // The address of the owner.
488         address addr;
489         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
490         uint64 startTimestamp;
491         // Whether the token has been burned.
492         bool burned;
493         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
494         uint24 extraData;
495     }
496 
497     /**
498      * @dev Returns the total amount of tokens stored by the contract.
499      *
500      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
501      */
502     function totalSupply() external view returns (uint256);
503 
504     // ==============================
505     //            IERC165
506     // ==============================
507 
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30 000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 
518     // ==============================
519     //            IERC721
520     // ==============================
521 
522     /**
523      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
529      */
530     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in ``owner``'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external;
570 
571     /**
572      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
573      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Transfers `tokenId` token from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must be owned by `from`.
601      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) external;
610 
611     /**
612      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
613      * The approval is cleared when the token is transferred.
614      *
615      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
616      *
617      * Requirements:
618      *
619      * - The caller must own the token or be an approved operator.
620      * - `tokenId` must exist.
621      *
622      * Emits an {Approval} event.
623      */
624     function approve(address to, uint256 tokenId) external;
625 
626     /**
627      * @dev Approve or remove `operator` as an operator for the caller.
628      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
629      *
630      * Requirements:
631      *
632      * - The `operator` cannot be the caller.
633      *
634      * Emits an {ApprovalForAll} event.
635      */
636     function setApprovalForAll(address operator, bool _approved) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
649      *
650      * See {setApprovalForAll}
651      */
652     function isApprovedForAll(address owner, address operator) external view returns (bool);
653 
654     // ==============================
655     //        IERC721Metadata
656     // ==============================
657 
658     /**
659      * @dev Returns the token collection name.
660      */
661     function name() external view returns (string memory);
662 
663     /**
664      * @dev Returns the token collection symbol.
665      */
666     function symbol() external view returns (string memory);
667 
668     /**
669      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
670      */
671     function tokenURI(uint256 tokenId) external view returns (string memory);
672 
673     // ==============================
674     //            IERC2309
675     // ==============================
676 
677     /**
678      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
679      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
680      */
681     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
682 }
683 
684 
685 // File contracts/ERC721A.sol
686 
687 // ERC721A Contracts v4.1.0
688 // Creator: Chiru Labs
689 
690 pragma solidity ^0.8.4;
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
1635 
1636 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
1637 
1638 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1639 
1640 pragma solidity ^0.8.0;
1641 
1642 /**
1643  * @dev Interface of the ERC20 standard as defined in the EIP.
1644  */
1645 interface IERC20 {
1646     /**
1647      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1648      * another (`to`).
1649      *
1650      * Note that `value` may be zero.
1651      */
1652     event Transfer(address indexed from, address indexed to, uint256 value);
1653 
1654     /**
1655      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1656      * a call to {approve}. `value` is the new allowance.
1657      */
1658     event Approval(address indexed owner, address indexed spender, uint256 value);
1659 
1660     /**
1661      * @dev Returns the amount of tokens in existence.
1662      */
1663     function totalSupply() external view returns (uint256);
1664 
1665     /**
1666      * @dev Returns the amount of tokens owned by `account`.
1667      */
1668     function balanceOf(address account) external view returns (uint256);
1669 
1670     /**
1671      * @dev Moves `amount` tokens from the caller's account to `to`.
1672      *
1673      * Returns a boolean value indicating whether the operation succeeded.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function transfer(address to, uint256 amount) external returns (bool);
1678 
1679     /**
1680      * @dev Returns the remaining number of tokens that `spender` will be
1681      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1682      * zero by default.
1683      *
1684      * This value changes when {approve} or {transferFrom} are called.
1685      */
1686     function allowance(address owner, address spender) external view returns (uint256);
1687 
1688     /**
1689      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1690      *
1691      * Returns a boolean value indicating whether the operation succeeded.
1692      *
1693      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1694      * that someone may use both the old and the new allowance by unfortunate
1695      * transaction ordering. One possible solution to mitigate this race
1696      * condition is to first reduce the spender's allowance to 0 and set the
1697      * desired value afterwards:
1698      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1699      *
1700      * Emits an {Approval} event.
1701      */
1702     function approve(address spender, uint256 amount) external returns (bool);
1703 
1704     /**
1705      * @dev Moves `amount` tokens from `from` to `to` using the
1706      * allowance mechanism. `amount` is then deducted from the caller's
1707      * allowance.
1708      *
1709      * Returns a boolean value indicating whether the operation succeeded.
1710      *
1711      * Emits a {Transfer} event.
1712      */
1713     function transferFrom(
1714         address from,
1715         address to,
1716         uint256 amount
1717     ) external returns (bool);
1718 }
1719 
1720 
1721 // File contracts/nft.sol
1722 
1723 pragma solidity ^0.8.4;
1724 
1725 
1726 
1727 
1728 
1729 contract ERC721WithMerkleWhitelist is ERC721A,Ownable{
1730     using SafeMath for uint;
1731     uint public _whitelistStart;
1732     uint public _whitelistEnd;
1733     uint public _whitelistPrice;
1734 
1735     uint public _fixedPriceStart;
1736     uint public _fixedPriceEnd;
1737     uint public _fixedPricePrice;
1738 
1739     uint public _mintLimit;
1740     uint public _whitelistLimit;
1741     uint public _whitelistMinted;
1742     bytes32 public _merkleRootHash;
1743     uint public _fixedPriceLimit;
1744 
1745     uint public _incrementID;
1746     string public URI_PREFIX;
1747 
1748     address public _receiver;
1749 
1750     mapping(address => uint) public _fixedPriceAlreadyMint;
1751     mapping(address => uint) public _whitelistAlreadyMint;
1752     event  MintNFT(address to,uint256 tokenId,uint256 price,uint256 time);
1753     constructor()ERC721A("METAVERSUS_NFT","METAVERSUS_NFT"){
1754         _incrementID = 1;
1755         _mintLimit = 10000;
1756         _whitelistLimit = 6003;
1757         _fixedPriceLimit = 20;
1758         _receiver = 0xea928385de968c227Bc0cdB01b0aF2E510d9042b;
1759     }
1760 
1761     function batchMint(address to,uint amount)public onlyOwner{
1762         _mint(to,amount);
1763     }
1764 
1765     function setIncrement(uint newID)public onlyOwner{
1766         _incrementID = newID;
1767     }
1768     
1769     function setReceiver(address newReceiver)public onlyOwner{
1770         _receiver = newReceiver;
1771     }
1772 
1773     function setLimit(uint white,uint fix)public onlyOwner{
1774         _whitelistLimit = white;
1775         _mintLimit = fix;
1776     }
1777     
1778     function amountLeft()public view returns(uint){
1779         if(block.timestamp < _fixedPriceStart){
1780             return _whitelistLimit.sub(_incrementID).add(1);
1781         }
1782         return _mintLimit.sub(_incrementID).add(1);
1783     }
1784 
1785     function setWhitelistMerkleRootHash(bytes32 merkleRootHash)public onlyOwner{
1786         _merkleRootHash = merkleRootHash;
1787     }
1788 
1789     function setWhitelist(uint start,uint end,uint price)public onlyOwner{
1790         _whitelistStart = start;
1791         _whitelistEnd = end;
1792         _whitelistPrice = price;
1793     }
1794 
1795     function setFixedPrice(uint start,uint end,uint price,uint limit)public onlyOwner{
1796         _fixedPriceStart = start;
1797         _fixedPriceEnd = end;
1798         _fixedPricePrice = price;
1799         _fixedPriceLimit = limit;
1800     }
1801 
1802     function incrementMint(address to,uint limit)internal{
1803         _mint(to,_incrementID);
1804 
1805         _incrementID=_incrementID.add(1);
1806         require(_incrementID<=limit,"EXCEED MINT LIMIT");
1807     }
1808 
1809     function Mint(uint64 whitelistLimit,bytes32[] calldata merkleProof,uint64 mintAmount)public payable{
1810         require(mintAmount > 0,"CANNOT MINT ZERO");
1811         
1812         require(_incrementID.add(mintAmount) <= _mintLimit , "EXCEED MINT LIMIT");//todo move
1813 
1814         require(_whitelistStart !=0,"UNINITIALIZE");
1815         require(block.timestamp > _whitelistStart,"WAIT FOR WHITELIST MINT LAUNCH");
1816         if(block.timestamp<=_whitelistEnd){
1817             whitelistMint(whitelistLimit,merkleProof,mintAmount);
1818             return;
1819         }
1820 
1821         require(_fixedPriceStart!=0,"UNINITIALIZE");
1822         require(block.timestamp > _fixedPriceStart,"WAIT FOR FIXED PRICE MINT LAUNCH");
1823         if(block.timestamp<=_fixedPriceEnd){
1824             fixedPriceMint(mintAmount);
1825             return;
1826         }
1827 
1828         revert("MINT ALREADY END");
1829     }
1830 
1831     function whitelistMint(uint64 whitelistLimit,bytes32[] calldata merkleProof,uint64 mintAmount)internal{
1832         require(MerkleProof.verify(merkleProof, _merkleRootHash, keccak256(abi.encodePacked(msg.sender,whitelistLimit))) , "INVALID WHITELIST");
1833         uint afterMintAmount = _whitelistAlreadyMint[msg.sender].add(mintAmount);
1834         require(afterMintAmount <= whitelistLimit , "EXCEEED WHITELIST MINT LIMIT");
1835 
1836         require(msg.value == _whitelistPrice.mul(mintAmount),"VALUE INSUFFICIENT" );
1837 
1838         
1839         _incrementID=_incrementID.add(mintAmount);
1840         require(_incrementID<=_whitelistLimit,"EXCEED MINT LIMIT");
1841         for(uint index=0;index<mintAmount;index++){
1842             emit MintNFT(msg.sender,_nextTokenId()+index,msg.value.div(mintAmount),block.timestamp);
1843         }
1844         _mint(msg.sender,mintAmount);
1845         
1846 
1847         payable(_receiver).transfer(_whitelistPrice.mul(mintAmount));
1848 
1849         _whitelistAlreadyMint[msg.sender] = afterMintAmount;
1850     }
1851 
1852     function fixedPriceMint(uint64 mintAmount)internal{
1853         uint afterMintAmount = _fixedPriceAlreadyMint[msg.sender].add(mintAmount);
1854         require(afterMintAmount <= _fixedPriceLimit , "EXCEEED FIXED PRICE MINT LIMIT");
1855 
1856         require(msg.value == _fixedPricePrice.mul(mintAmount),"VALUE INSUFFICIENT" );
1857 
1858         _incrementID=_incrementID.add(mintAmount);
1859         require(_incrementID<=_mintLimit,"EXCEED MINT LIMIT");
1860         for(uint index=0;index<mintAmount;index++){
1861             emit MintNFT(msg.sender,_nextTokenId()+index,msg.value.div(mintAmount),block.timestamp);
1862         }
1863         _mint(msg.sender,mintAmount);
1864         
1865         payable(_receiver).transfer(_fixedPricePrice.mul(mintAmount));
1866         _fixedPriceAlreadyMint[msg.sender] = afterMintAmount;
1867     }
1868 
1869     function  withdraw(address to,uint amount)public onlyOwner{
1870         payable(to).transfer(amount);
1871     }
1872 
1873     function setPrefix(string memory prefix)public onlyOwner{
1874         URI_PREFIX = prefix;
1875     }
1876 
1877     function _baseURI() internal view override returns (string memory) {
1878         return URI_PREFIX;
1879     }
1880 
1881     function _startTokenId() internal view override returns (uint256) {
1882         return 1;
1883     }
1884 }