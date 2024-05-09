1 // File: @openzeppelin/contracts/utils/Math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev These functions deal with verification of Merkle Trees proofs.
240  *
241  * The proofs can be generated using the JavaScript library
242  * https://github.com/miguelmota/merkletreejs[merkletreejs].
243  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
244  *
245  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
246  */
247 library MerkleProof {
248     /**
249      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
250      * defined by `root`. For this, a `proof` must be provided, containing
251      * sibling hashes on the branch from the leaf to the root of the tree. Each
252      * pair of leaves and each pair of pre-images are assumed to be sorted.
253      */
254     function verify(
255         bytes32[] memory proof,
256         bytes32 root,
257         bytes32 leaf
258     ) internal pure returns (bool) {
259         return processProof(proof, leaf) == root;
260     }
261 
262     /**
263      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
264      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
265      * hash matches the root of the tree. When processing the proof, the pairs
266      * of leafs & pre-images are assumed to be sorted.
267      *
268      * _Available since v4.4._
269      */
270     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
271         bytes32 computedHash = leaf;
272         for (uint256 i = 0; i < proof.length; i++) {
273             bytes32 proofElement = proof[i];
274             if (computedHash <= proofElement) {
275                 // Hash(current computed hash + current element of the proof)
276                 computedHash = _efficientHash(computedHash, proofElement);
277             } else {
278                 // Hash(current element of the proof + current computed hash)
279                 computedHash = _efficientHash(proofElement, computedHash);
280             }
281         }
282         return computedHash;
283     }
284 
285     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
286         assembly {
287             mstore(0x00, a)
288             mstore(0x20, b)
289             value := keccak256(0x00, 0x40)
290         }
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Context.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _transferOwnership(_msgSender());
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     /**
369      * @dev Leaves the contract without owner. It will not be possible to call
370      * `onlyOwner` functions anymore. Can only be called by the current owner.
371      *
372      * NOTE: Renouncing ownership will leave the contract without an owner,
373      * thereby removing any functionality that is only available to the owner.
374      */
375     function renounceOwnership() public virtual onlyOwner {
376         _transferOwnership(address(0));
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public virtual onlyOwner {
384         require(newOwner != address(0), "Ownable: new owner is the zero address");
385         _transferOwnership(newOwner);
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Internal function without access restriction.
391      */
392     function _transferOwnership(address newOwner) internal virtual {
393         address oldOwner = _owner;
394         _owner = newOwner;
395         emit OwnershipTransferred(oldOwner, newOwner);
396     }
397 }
398 
399 // File: erc721a/contracts/IERC721A.sol
400 
401 
402 // ERC721A Contracts v4.1.0
403 // Creator: Chiru Labs
404 
405 pragma solidity ^0.8.4;
406 
407 /**
408  * @dev Interface of an ERC721A compliant contract.
409  */
410 interface IERC721A {
411     /**
412      * The caller must own the token or be an approved operator.
413      */
414     error ApprovalCallerNotOwnerNorApproved();
415 
416     /**
417      * The token does not exist.
418      */
419     error ApprovalQueryForNonexistentToken();
420 
421     /**
422      * The caller cannot approve to their own address.
423      */
424     error ApproveToCaller();
425 
426     /**
427      * Cannot query the balance for the zero address.
428      */
429     error BalanceQueryForZeroAddress();
430 
431     /**
432      * Cannot mint to the zero address.
433      */
434     error MintToZeroAddress();
435 
436     /**
437      * The quantity of tokens minted must be more than zero.
438      */
439     error MintZeroQuantity();
440 
441     /**
442      * The token does not exist.
443      */
444     error OwnerQueryForNonexistentToken();
445 
446     /**
447      * The caller must own the token or be an approved operator.
448      */
449     error TransferCallerNotOwnerNorApproved();
450 
451     /**
452      * The token must be owned by `from`.
453      */
454     error TransferFromIncorrectOwner();
455 
456     /**
457      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
458      */
459     error TransferToNonERC721ReceiverImplementer();
460 
461     /**
462      * Cannot transfer to the zero address.
463      */
464     error TransferToZeroAddress();
465 
466     /**
467      * The token does not exist.
468      */
469     error URIQueryForNonexistentToken();
470 
471     /**
472      * The `quantity` minted with ERC2309 exceeds the safety limit.
473      */
474     error MintERC2309QuantityExceedsLimit();
475 
476     /**
477      * The `extraData` cannot be set on an unintialized ownership slot.
478      */
479     error OwnershipNotInitializedForExtraData();
480 
481     struct TokenOwnership {
482         // The address of the owner.
483         address addr;
484         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
485         uint64 startTimestamp;
486         // Whether the token has been burned.
487         bool burned;
488         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
489         uint24 extraData;
490     }
491 
492     /**
493      * @dev Returns the total amount of tokens stored by the contract.
494      *
495      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
496      */
497     function totalSupply() external view returns (uint256);
498 
499     // ==============================
500     //            IERC165
501     // ==============================
502 
503     /**
504      * @dev Returns true if this contract implements the interface defined by
505      * `interfaceId`. See the corresponding
506      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
507      * to learn more about how these ids are created.
508      *
509      * This function call must use less than 30 000 gas.
510      */
511     function supportsInterface(bytes4 interfaceId) external view returns (bool);
512 
513     // ==============================
514     //            IERC721
515     // ==============================
516 
517     /**
518      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
524      */
525     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
529      */
530     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
531 
532     /**
533      * @dev Returns the number of tokens in ``owner``'s account.
534      */
535     function balanceOf(address owner) external view returns (uint256 balance);
536 
537     /**
538      * @dev Returns the owner of the `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function ownerOf(uint256 tokenId) external view returns (address owner);
545 
546     /**
547      * @dev Safely transfers `tokenId` token from `from` to `to`.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes calldata data
564     ) external;
565 
566     /**
567      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
568      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must exist and be owned by `from`.
575      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
576      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
577      *
578      * Emits a {Transfer} event.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId
584     ) external;
585 
586     /**
587      * @dev Transfers `tokenId` token from `from` to `to`.
588      *
589      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
590      *
591      * Requirements:
592      *
593      * - `from` cannot be the zero address.
594      * - `to` cannot be the zero address.
595      * - `tokenId` token must be owned by `from`.
596      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
611      *
612      * Requirements:
613      *
614      * - The caller must own the token or be an approved operator.
615      * - `tokenId` must exist.
616      *
617      * Emits an {Approval} event.
618      */
619     function approve(address to, uint256 tokenId) external;
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns the account approved for `tokenId` token.
635      *
636      * Requirements:
637      *
638      * - `tokenId` must exist.
639      */
640     function getApproved(uint256 tokenId) external view returns (address operator);
641 
642     /**
643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
644      *
645      * See {setApprovalForAll}
646      */
647     function isApprovedForAll(address owner, address operator) external view returns (bool);
648 
649     // ==============================
650     //        IERC721Metadata
651     // ==============================
652 
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 
668     // ==============================
669     //            IERC2309
670     // ==============================
671 
672     /**
673      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
674      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
675      */
676     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
677 }
678 
679 // File: erc721a/contracts/ERC721A.sol
680 
681 
682 // ERC721A Contracts v4.1.0
683 // Creator: Chiru Labs
684 
685 pragma solidity ^0.8.4;
686 
687 
688 /**
689  * @dev ERC721 token receiver interface.
690  */
691 interface ERC721A__IERC721Receiver {
692     function onERC721Received(
693         address operator,
694         address from,
695         uint256 tokenId,
696         bytes calldata data
697     ) external returns (bytes4);
698 }
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
702  * including the Metadata extension. Built to optimize for lower gas during batch mints.
703  *
704  * Assumes serials are sequentially minted starting at `_startTokenId()`
705  * (defaults to 0, e.g. 0, 1, 2, 3..).
706  *
707  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
708  *
709  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
710  */
711 contract ERC721A is IERC721A {
712     // Mask of an entry in packed address data.
713     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
714 
715     // The bit position of `numberMinted` in packed address data.
716     uint256 private constant BITPOS_NUMBER_MINTED = 64;
717 
718     // The bit position of `numberBurned` in packed address data.
719     uint256 private constant BITPOS_NUMBER_BURNED = 128;
720 
721     // The bit position of `aux` in packed address data.
722     uint256 private constant BITPOS_AUX = 192;
723 
724     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
725     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
726 
727     // The bit position of `startTimestamp` in packed ownership.
728     uint256 private constant BITPOS_START_TIMESTAMP = 160;
729 
730     // The bit mask of the `burned` bit in packed ownership.
731     uint256 private constant BITMASK_BURNED = 1 << 224;
732 
733     // The bit position of the `nextInitialized` bit in packed ownership.
734     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
735 
736     // The bit mask of the `nextInitialized` bit in packed ownership.
737     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
738 
739     // The bit position of `extraData` in packed ownership.
740     uint256 private constant BITPOS_EXTRA_DATA = 232;
741 
742     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
743     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
744 
745     // The mask of the lower 160 bits for addresses.
746     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
747 
748     // The maximum `quantity` that can be minted with `_mintERC2309`.
749     // This limit is to prevent overflows on the address data entries.
750     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
751     // is required to cause an overflow, which is unrealistic.
752     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
753 
754     // The tokenId of the next token to be minted.
755     uint256 private _currentIndex;
756 
757     // The number of tokens burned.
758     uint256 private _burnCounter;
759 
760     // Token name
761     string private _name;
762 
763     // Token symbol
764     string private _symbol;
765 
766     // Mapping from token ID to ownership details
767     // An empty struct value does not necessarily mean the token is unowned.
768     // See `_packedOwnershipOf` implementation for details.
769     //
770     // Bits Layout:
771     // - [0..159]   `addr`
772     // - [160..223] `startTimestamp`
773     // - [224]      `burned`
774     // - [225]      `nextInitialized`
775     // - [232..255] `extraData`
776     mapping(uint256 => uint256) private _packedOwnerships;
777 
778     // Mapping owner address to address data.
779     //
780     // Bits Layout:
781     // - [0..63]    `balance`
782     // - [64..127]  `numberMinted`
783     // - [128..191] `numberBurned`
784     // - [192..255] `aux`
785     mapping(address => uint256) private _packedAddressData;
786 
787     // Mapping from token ID to approved address.
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796         _currentIndex = _startTokenId();
797     }
798 
799     /**
800      * @dev Returns the starting token ID.
801      * To change the starting token ID, please override this function.
802      */
803     function _startTokenId() internal view virtual returns (uint256) {
804         return 0;
805     }
806 
807     /**
808      * @dev Returns the next token ID to be minted.
809      */
810     function _nextTokenId() internal view returns (uint256) {
811         return _currentIndex;
812     }
813 
814     /**
815      * @dev Returns the total number of tokens in existence.
816      * Burned tokens will reduce the count.
817      * To get the total number of tokens minted, please see `_totalMinted`.
818      */
819     function totalSupply() public view override returns (uint256) {
820         // Counter underflow is impossible as _burnCounter cannot be incremented
821         // more than `_currentIndex - _startTokenId()` times.
822         unchecked {
823             return _currentIndex - _burnCounter - _startTokenId();
824         }
825     }
826 
827     /**
828      * @dev Returns the total amount of tokens minted in the contract.
829      */
830     function _totalMinted() internal view returns (uint256) {
831         // Counter underflow is impossible as _currentIndex does not decrement,
832         // and it is initialized to `_startTokenId()`
833         unchecked {
834             return _currentIndex - _startTokenId();
835         }
836     }
837 
838     /**
839      * @dev Returns the total number of tokens burned.
840      */
841     function _totalBurned() internal view returns (uint256) {
842         return _burnCounter;
843     }
844 
845     /**
846      * @dev See {IERC165-supportsInterface}.
847      */
848     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
849         // The interface IDs are constants representing the first 4 bytes of the XOR of
850         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
851         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
852         return
853             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
854             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
855             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
856     }
857 
858     /**
859      * @dev See {IERC721-balanceOf}.
860      */
861     function balanceOf(address owner) public view override returns (uint256) {
862         if (owner == address(0)) revert BalanceQueryForZeroAddress();
863         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
864     }
865 
866     /**
867      * Returns the number of tokens minted by `owner`.
868      */
869     function _numberMinted(address owner) internal view returns (uint256) {
870         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
871     }
872 
873     /**
874      * Returns the number of tokens burned by or on behalf of `owner`.
875      */
876     function _numberBurned(address owner) internal view returns (uint256) {
877         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
878     }
879 
880     /**
881      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
882      */
883     function _getAux(address owner) internal view returns (uint64) {
884         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
885     }
886 
887     /**
888      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
889      * If there are multiple variables, please pack them into a uint64.
890      */
891     function _setAux(address owner, uint64 aux) internal {
892         uint256 packed = _packedAddressData[owner];
893         uint256 auxCasted;
894         // Cast `aux` with assembly to avoid redundant masking.
895         assembly {
896             auxCasted := aux
897         }
898         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
899         _packedAddressData[owner] = packed;
900     }
901 
902     /**
903      * Returns the packed ownership data of `tokenId`.
904      */
905     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr)
910                 if (curr < _currentIndex) {
911                     uint256 packed = _packedOwnerships[curr];
912                     // If not burned.
913                     if (packed & BITMASK_BURNED == 0) {
914                         // Invariant:
915                         // There will always be an ownership that has an address and is not burned
916                         // before an ownership that does not have an address and is not burned.
917                         // Hence, curr will not underflow.
918                         //
919                         // We can directly compare the packed value.
920                         // If the address is zero, packed is zero.
921                         while (packed == 0) {
922                             packed = _packedOwnerships[--curr];
923                         }
924                         return packed;
925                     }
926                 }
927         }
928         revert OwnerQueryForNonexistentToken();
929     }
930 
931     /**
932      * Returns the unpacked `TokenOwnership` struct from `packed`.
933      */
934     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
935         ownership.addr = address(uint160(packed));
936         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
937         ownership.burned = packed & BITMASK_BURNED != 0;
938         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
939     }
940 
941     /**
942      * Returns the unpacked `TokenOwnership` struct at `index`.
943      */
944     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
945         return _unpackedOwnership(_packedOwnerships[index]);
946     }
947 
948     /**
949      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
950      */
951     function _initializeOwnershipAt(uint256 index) internal {
952         if (_packedOwnerships[index] == 0) {
953             _packedOwnerships[index] = _packedOwnershipOf(index);
954         }
955     }
956 
957     /**
958      * Gas spent here starts off proportional to the maximum mint batch size.
959      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
960      */
961     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
962         return _unpackedOwnership(_packedOwnershipOf(tokenId));
963     }
964 
965     /**
966      * @dev Packs ownership data into a single uint256.
967      */
968     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
969         assembly {
970             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
971             owner := and(owner, BITMASK_ADDRESS)
972             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
973             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
974         }
975     }
976 
977     /**
978      * @dev See {IERC721-ownerOf}.
979      */
980     function ownerOf(uint256 tokenId) public view override returns (address) {
981         return address(uint160(_packedOwnershipOf(tokenId)));
982     }
983 
984     /**
985      * @dev See {IERC721Metadata-name}.
986      */
987     function name() public view virtual override returns (string memory) {
988         return _name;
989     }
990 
991     /**
992      * @dev See {IERC721Metadata-symbol}.
993      */
994     function symbol() public view virtual override returns (string memory) {
995         return _symbol;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-tokenURI}.
1000      */
1001     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1002         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1003 
1004         string memory baseURI = _baseURI();
1005         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1006     }
1007 
1008     /**
1009      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1010      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1011      * by default, it can be overridden in child contracts.
1012      */
1013     function _baseURI() internal view virtual returns (string memory) {
1014         return '';
1015     }
1016 
1017     /**
1018      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1019      */
1020     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1021         // For branchless setting of the `nextInitialized` flag.
1022         assembly {
1023             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1024             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1025         }
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-approve}.
1030      */
1031     function approve(address to, uint256 tokenId) public override {
1032         address owner = ownerOf(tokenId);
1033 
1034         if (_msgSenderERC721A() != owner)
1035             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1036                 revert ApprovalCallerNotOwnerNorApproved();
1037             }
1038 
1039         _tokenApprovals[tokenId] = to;
1040         emit Approval(owner, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-getApproved}.
1045      */
1046     function getApproved(uint256 tokenId) public view override returns (address) {
1047         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1048 
1049         return _tokenApprovals[tokenId];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-setApprovalForAll}.
1054      */
1055     function setApprovalForAll(address operator, bool approved) public virtual override {
1056         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1057 
1058         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1059         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-isApprovedForAll}.
1064      */
1065     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1066         return _operatorApprovals[owner][operator];
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-safeTransferFrom}.
1071      */
1072     function safeTransferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) public virtual override {
1077         safeTransferFrom(from, to, tokenId, '');
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) public virtual override {
1089         transferFrom(from, to, tokenId);
1090         if (to.code.length != 0)
1091             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1092                 revert TransferToNonERC721ReceiverImplementer();
1093             }
1094     }
1095 
1096     /**
1097      * @dev Returns whether `tokenId` exists.
1098      *
1099      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1100      *
1101      * Tokens start existing when they are minted (`_mint`),
1102      */
1103     function _exists(uint256 tokenId) internal view returns (bool) {
1104         return
1105             _startTokenId() <= tokenId &&
1106             tokenId < _currentIndex && // If within bounds,
1107             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1108     }
1109 
1110     /**
1111      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1112      */
1113     function _safeMint(address to, uint256 quantity) internal {
1114         _safeMint(to, quantity, '');
1115     }
1116 
1117     /**
1118      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1119      *
1120      * Requirements:
1121      *
1122      * - If `to` refers to a smart contract, it must implement
1123      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * See {_mint}.
1127      *
1128      * Emits a {Transfer} event for each mint.
1129      */
1130     function _safeMint(
1131         address to,
1132         uint256 quantity,
1133         bytes memory _data
1134     ) internal {
1135         _mint(to, quantity);
1136 
1137         unchecked {
1138             if (to.code.length != 0) {
1139                 uint256 end = _currentIndex;
1140                 uint256 index = end - quantity;
1141                 do {
1142                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1143                         revert TransferToNonERC721ReceiverImplementer();
1144                     }
1145                 } while (index < end);
1146                 // Reentrancy protection.
1147                 if (_currentIndex != end) revert();
1148             }
1149         }
1150     }
1151 
1152     /**
1153      * @dev Mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `quantity` must be greater than 0.
1159      *
1160      * Emits a {Transfer} event for each mint.
1161      */
1162     function _mint(address to, uint256 quantity) internal {
1163         uint256 startTokenId = _currentIndex;
1164         if (to == address(0)) revert MintToZeroAddress();
1165         if (quantity == 0) revert MintZeroQuantity();
1166 
1167         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1168 
1169         // Overflows are incredibly unrealistic.
1170         // `balance` and `numberMinted` have a maximum limit of 2**64.
1171         // `tokenId` has a maximum limit of 2**256.
1172         unchecked {
1173             // Updates:
1174             // - `balance += quantity`.
1175             // - `numberMinted += quantity`.
1176             //
1177             // We can directly add to the `balance` and `numberMinted`.
1178             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1179 
1180             // Updates:
1181             // - `address` to the owner.
1182             // - `startTimestamp` to the timestamp of minting.
1183             // - `burned` to `false`.
1184             // - `nextInitialized` to `quantity == 1`.
1185             _packedOwnerships[startTokenId] = _packOwnershipData(
1186                 to,
1187                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1188             );
1189 
1190             uint256 tokenId = startTokenId;
1191             uint256 end = startTokenId + quantity;
1192             do {
1193                 emit Transfer(address(0), to, tokenId++);
1194             } while (tokenId < end);
1195 
1196             _currentIndex = end;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     /**
1202      * @dev Mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * This function is intended for efficient minting only during contract creation.
1205      *
1206      * It emits only one {ConsecutiveTransfer} as defined in
1207      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1208      * instead of a sequence of {Transfer} event(s).
1209      *
1210      * Calling this function outside of contract creation WILL make your contract
1211      * non-compliant with the ERC721 standard.
1212      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1213      * {ConsecutiveTransfer} event is only permissible during contract creation.
1214      *
1215      * Requirements:
1216      *
1217      * - `to` cannot be the zero address.
1218      * - `quantity` must be greater than 0.
1219      *
1220      * Emits a {ConsecutiveTransfer} event.
1221      */
1222     function _mintERC2309(address to, uint256 quantity) internal {
1223         uint256 startTokenId = _currentIndex;
1224         if (to == address(0)) revert MintToZeroAddress();
1225         if (quantity == 0) revert MintZeroQuantity();
1226         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1227 
1228         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1229 
1230         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1231         unchecked {
1232             // Updates:
1233             // - `balance += quantity`.
1234             // - `numberMinted += quantity`.
1235             //
1236             // We can directly add to the `balance` and `numberMinted`.
1237             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1238 
1239             // Updates:
1240             // - `address` to the owner.
1241             // - `startTimestamp` to the timestamp of minting.
1242             // - `burned` to `false`.
1243             // - `nextInitialized` to `quantity == 1`.
1244             _packedOwnerships[startTokenId] = _packOwnershipData(
1245                 to,
1246                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1247             );
1248 
1249             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1250 
1251             _currentIndex = startTokenId + quantity;
1252         }
1253         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1254     }
1255 
1256     /**
1257      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1258      */
1259     function _getApprovedAddress(uint256 tokenId)
1260         private
1261         view
1262         returns (uint256 approvedAddressSlot, address approvedAddress)
1263     {
1264         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1265         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1266         assembly {
1267             // Compute the slot.
1268             mstore(0x00, tokenId)
1269             mstore(0x20, tokenApprovalsPtr.slot)
1270             approvedAddressSlot := keccak256(0x00, 0x40)
1271             // Load the slot's value from storage.
1272             approvedAddress := sload(approvedAddressSlot)
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1278      */
1279     function _isOwnerOrApproved(
1280         address approvedAddress,
1281         address from,
1282         address msgSender
1283     ) private pure returns (bool result) {
1284         assembly {
1285             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1286             from := and(from, BITMASK_ADDRESS)
1287             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1288             msgSender := and(msgSender, BITMASK_ADDRESS)
1289             // `msgSender == from || msgSender == approvedAddress`.
1290             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1291         }
1292     }
1293 
1294     /**
1295      * @dev Transfers `tokenId` from `from` to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `tokenId` token must be owned by `from`.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function transferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) public virtual override {
1309         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1310 
1311         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1312 
1313         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1314 
1315         // The nested ifs save around 20+ gas over a compound boolean condition.
1316         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1317             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1318 
1319         if (to == address(0)) revert TransferToZeroAddress();
1320 
1321         _beforeTokenTransfers(from, to, tokenId, 1);
1322 
1323         // Clear approvals from the previous owner.
1324         assembly {
1325             if approvedAddress {
1326                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1327                 sstore(approvedAddressSlot, 0)
1328             }
1329         }
1330 
1331         // Underflow of the sender's balance is impossible because we check for
1332         // ownership above and the recipient's balance can't realistically overflow.
1333         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1334         unchecked {
1335             // We can directly increment and decrement the balances.
1336             --_packedAddressData[from]; // Updates: `balance -= 1`.
1337             ++_packedAddressData[to]; // Updates: `balance += 1`.
1338 
1339             // Updates:
1340             // - `address` to the next owner.
1341             // - `startTimestamp` to the timestamp of transfering.
1342             // - `burned` to `false`.
1343             // - `nextInitialized` to `true`.
1344             _packedOwnerships[tokenId] = _packOwnershipData(
1345                 to,
1346                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1347             );
1348 
1349             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1350             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1351                 uint256 nextTokenId = tokenId + 1;
1352                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1353                 if (_packedOwnerships[nextTokenId] == 0) {
1354                     // If the next slot is within bounds.
1355                     if (nextTokenId != _currentIndex) {
1356                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1357                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1358                     }
1359                 }
1360             }
1361         }
1362 
1363         emit Transfer(from, to, tokenId);
1364         _afterTokenTransfers(from, to, tokenId, 1);
1365     }
1366 
1367     /**
1368      * @dev Equivalent to `_burn(tokenId, false)`.
1369      */
1370     function _burn(uint256 tokenId) internal virtual {
1371         _burn(tokenId, false);
1372     }
1373 
1374     /**
1375      * @dev Destroys `tokenId`.
1376      * The approval is cleared when the token is burned.
1377      *
1378      * Requirements:
1379      *
1380      * - `tokenId` must exist.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1385         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1386 
1387         address from = address(uint160(prevOwnershipPacked));
1388 
1389         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1390 
1391         if (approvalCheck) {
1392             // The nested ifs save around 20+ gas over a compound boolean condition.
1393             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1394                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1395         }
1396 
1397         _beforeTokenTransfers(from, address(0), tokenId, 1);
1398 
1399         // Clear approvals from the previous owner.
1400         assembly {
1401             if approvedAddress {
1402                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1403                 sstore(approvedAddressSlot, 0)
1404             }
1405         }
1406 
1407         // Underflow of the sender's balance is impossible because we check for
1408         // ownership above and the recipient's balance can't realistically overflow.
1409         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1410         unchecked {
1411             // Updates:
1412             // - `balance -= 1`.
1413             // - `numberBurned += 1`.
1414             //
1415             // We can directly decrement the balance, and increment the number burned.
1416             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1417             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1418 
1419             // Updates:
1420             // - `address` to the last owner.
1421             // - `startTimestamp` to the timestamp of burning.
1422             // - `burned` to `true`.
1423             // - `nextInitialized` to `true`.
1424             _packedOwnerships[tokenId] = _packOwnershipData(
1425                 from,
1426                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1427             );
1428 
1429             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1430             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1431                 uint256 nextTokenId = tokenId + 1;
1432                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1433                 if (_packedOwnerships[nextTokenId] == 0) {
1434                     // If the next slot is within bounds.
1435                     if (nextTokenId != _currentIndex) {
1436                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1437                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1438                     }
1439                 }
1440             }
1441         }
1442 
1443         emit Transfer(from, address(0), tokenId);
1444         _afterTokenTransfers(from, address(0), tokenId, 1);
1445 
1446         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1447         unchecked {
1448             _burnCounter++;
1449         }
1450     }
1451 
1452     /**
1453      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1454      *
1455      * @param from address representing the previous owner of the given token ID
1456      * @param to target address that will receive the tokens
1457      * @param tokenId uint256 ID of the token to be transferred
1458      * @param _data bytes optional data to send along with the call
1459      * @return bool whether the call correctly returned the expected magic value
1460      */
1461     function _checkContractOnERC721Received(
1462         address from,
1463         address to,
1464         uint256 tokenId,
1465         bytes memory _data
1466     ) private returns (bool) {
1467         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1468             bytes4 retval
1469         ) {
1470             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1471         } catch (bytes memory reason) {
1472             if (reason.length == 0) {
1473                 revert TransferToNonERC721ReceiverImplementer();
1474             } else {
1475                 assembly {
1476                     revert(add(32, reason), mload(reason))
1477                 }
1478             }
1479         }
1480     }
1481 
1482     /**
1483      * @dev Directly sets the extra data for the ownership data `index`.
1484      */
1485     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1486         uint256 packed = _packedOwnerships[index];
1487         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1488         uint256 extraDataCasted;
1489         // Cast `extraData` with assembly to avoid redundant masking.
1490         assembly {
1491             extraDataCasted := extraData
1492         }
1493         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1494         _packedOwnerships[index] = packed;
1495     }
1496 
1497     /**
1498      * @dev Returns the next extra data for the packed ownership data.
1499      * The returned result is shifted into position.
1500      */
1501     function _nextExtraData(
1502         address from,
1503         address to,
1504         uint256 prevOwnershipPacked
1505     ) private view returns (uint256) {
1506         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1507         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1508     }
1509 
1510     /**
1511      * @dev Called during each token transfer to set the 24bit `extraData` field.
1512      * Intended to be overridden by the cosumer contract.
1513      *
1514      * `previousExtraData` - the value of `extraData` before transfer.
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` will be minted for `to`.
1521      * - When `to` is zero, `tokenId` will be burned by `from`.
1522      * - `from` and `to` are never both zero.
1523      */
1524     function _extraData(
1525         address from,
1526         address to,
1527         uint24 previousExtraData
1528     ) internal view virtual returns (uint24) {}
1529 
1530     /**
1531      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1532      * This includes minting.
1533      * And also called before burning one token.
1534      *
1535      * startTokenId - the first token id to be transferred
1536      * quantity - the amount to be transferred
1537      *
1538      * Calling conditions:
1539      *
1540      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1541      * transferred to `to`.
1542      * - When `from` is zero, `tokenId` will be minted for `to`.
1543      * - When `to` is zero, `tokenId` will be burned by `from`.
1544      * - `from` and `to` are never both zero.
1545      */
1546     function _beforeTokenTransfers(
1547         address from,
1548         address to,
1549         uint256 startTokenId,
1550         uint256 quantity
1551     ) internal virtual {}
1552 
1553     /**
1554      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1555      * This includes minting.
1556      * And also called after one token has been burned.
1557      *
1558      * startTokenId - the first token id to be transferred
1559      * quantity - the amount to be transferred
1560      *
1561      * Calling conditions:
1562      *
1563      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1564      * transferred to `to`.
1565      * - When `from` is zero, `tokenId` has been minted for `to`.
1566      * - When `to` is zero, `tokenId` has been burned by `from`.
1567      * - `from` and `to` are never both zero.
1568      */
1569     function _afterTokenTransfers(
1570         address from,
1571         address to,
1572         uint256 startTokenId,
1573         uint256 quantity
1574     ) internal virtual {}
1575 
1576     /**
1577      * @dev Returns the message sender (defaults to `msg.sender`).
1578      *
1579      * If you are writing GSN compatible contracts, you need to override this function.
1580      */
1581     function _msgSenderERC721A() internal view virtual returns (address) {
1582         return msg.sender;
1583     }
1584 
1585     /**
1586      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1587      */
1588     function _toString(uint256 value) internal pure returns (string memory ptr) {
1589         assembly {
1590             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1591             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1592             // We will need 1 32-byte word to store the length,
1593             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1594             ptr := add(mload(0x40), 128)
1595             // Update the free memory pointer to allocate.
1596             mstore(0x40, ptr)
1597 
1598             // Cache the end of the memory to calculate the length later.
1599             let end := ptr
1600 
1601             // We write the string from the rightmost digit to the leftmost digit.
1602             // The following is essentially a do-while loop that also handles the zero case.
1603             // Costs a bit more than early returning for the zero case,
1604             // but cheaper in terms of deployment and overall runtime costs.
1605             for {
1606                 // Initialize and perform the first pass without check.
1607                 let temp := value
1608                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1609                 ptr := sub(ptr, 1)
1610                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1611                 mstore8(ptr, add(48, mod(temp, 10)))
1612                 temp := div(temp, 10)
1613             } temp {
1614                 // Keep dividing `temp` until zero.
1615                 temp := div(temp, 10)
1616             } {
1617                 // Body of the for loop.
1618                 ptr := sub(ptr, 1)
1619                 mstore8(ptr, add(48, mod(temp, 10)))
1620             }
1621 
1622             let length := sub(end, ptr)
1623             // Move the pointer 32 bytes leftwards to make room for the length.
1624             ptr := sub(ptr, 32)
1625             // Store the length.
1626             mstore(ptr, length)
1627         }
1628     }
1629 }
1630 
1631 // File: AlphaQueen.sol
1632 
1633 
1634 // creator : Jason Siauw
1635 // contact : jasonsiauw90712223@gmail.com
1636 
1637 pragma solidity ^0.8.4;
1638 
1639 
1640 
1641 
1642 
1643 contract AlphaQueen is ERC721A, Ownable {
1644     using SafeMath for uint256;
1645     address private wallet1;
1646     address private wallet2;
1647     address private wallet3;
1648     address private wallet4;
1649     address private wallet5;
1650     string public baseURI;
1651     uint256 public maxSupply;
1652     bytes32 public merkleRoot;
1653     bool public allowPreMint; 
1654     bool public allowPublicMint; 
1655     uint256 public price;
1656     mapping( address => uint256 ) public totalBuy;
1657 
1658     constructor(
1659         address wallet1_,
1660         address wallet2_,
1661         address wallet3_,
1662         address wallet4_,
1663         address wallet5_,
1664         bytes32 merkleRoot_,
1665         string memory baseURI_
1666     ) ERC721A("AlphaQueen", "AQ") {
1667         wallet1 = wallet1_ ;
1668         wallet2 = wallet2_ ;
1669         wallet3 = wallet3_ ;
1670         wallet4 = wallet4_ ;
1671         wallet5 = wallet5_ ;
1672         merkleRoot = merkleRoot_;
1673         maxSupply = 3000;
1674         price = 0.019 ether;
1675 
1676         baseURI = baseURI_;
1677         allowPreMint = false ;
1678         allowPublicMint = false ;
1679     }
1680 
1681     function leaf(
1682         address _account
1683     ) internal pure returns (bytes32) {
1684         return keccak256(abi.encodePacked(_account));
1685     }
1686 
1687     function isWhitelist(
1688         address adr,
1689         bytes32[] calldata proof,
1690         bytes32 root
1691     ) internal pure returns (bool) {
1692         return MerkleProof.verify(proof, root, leaf(adr));
1693     }
1694 
1695     function beTheFirstQueen(
1696         uint256 quantity,
1697         bytes32[] calldata proof
1698     ) external payable {
1699         require( isWhitelist(msg.sender, proof, merkleRoot), "AlphaQueen: not permission to whitelist mint" );
1700         require( allowPreMint, "AlphaQueen: not allow to mint now" );
1701         require( quantity > 0, "AlphaQueen: quantity must be bigger then 0" );
1702         require( quantity < 3, "AlphaQueen: quantity must be smaller then 3" );
1703         require( totalSupply() + quantity <= maxSupply, "AlphaQueen: out of max supply" );
1704         require( totalBuy[msg.sender] + quantity < 3, "AlphaQueen: out of balance" );
1705 
1706         if ( totalBuy[msg.sender] == 0 ) {
1707             if ( quantity == 2 ) {
1708                 require( msg.value >= price , "AlphaQueen: not enough ether" );
1709             }
1710         }
1711         else if ( totalBuy[msg.sender] == 1 ) {
1712             require( msg.value >= price , "AlphaQueen: not enough ether" );
1713         }
1714 
1715         totalBuy[msg.sender] = totalBuy[msg.sender] + quantity ;
1716         _safeMint(msg.sender, quantity);
1717     }
1718 
1719     function beTheQueen(
1720         uint256 quantity
1721     ) external payable {
1722         require( allowPublicMint, "AlphaQueen: not allow to mint now" );
1723         require( quantity > 0, "AlphaQueen: quantity must be bigger then 0" );
1724         require( quantity < 3, "AlphaQueen: quantity must be smaller then 3" );
1725         require( totalSupply() + quantity <= maxSupply, "AlphaQueen: out of max supply" );
1726         require( totalBuy[msg.sender] + quantity < 3, "AlphaQueen: out of balance" );
1727 
1728         if ( totalBuy[msg.sender] == 0 ) {
1729             if ( quantity == 2 ) {
1730                 require( msg.value >= price , "AlphaQueen: not enough ether" );
1731             }
1732         }
1733         else if ( totalBuy[msg.sender] == 1 ) {
1734             require( msg.value >= price , "AlphaQueen: not enough ether" );
1735         }
1736         totalBuy[msg.sender] = totalBuy[msg.sender] + quantity ;
1737         _safeMint(msg.sender, quantity);
1738     }
1739 
1740     function airdrop(
1741         address to,
1742         uint256 quantity
1743     ) external onlyOwner {
1744         require( totalSupply() < maxSupply, "AlphaQueen: out of max supply" );
1745         _safeMint(to, quantity);
1746     }
1747 
1748     function beTheDevQueen(
1749         uint256 quantity
1750     ) external onlyOwner {
1751         require( totalSupply() < maxSupply, "AlphaQueen: out of max supply" );
1752         _safeMint(msg.sender, quantity);
1753     }
1754 
1755     function flipAllowPreMint() public onlyOwner {
1756         allowPreMint = !allowPreMint;
1757     }
1758 
1759     function flipAllowPublicMint() public onlyOwner {
1760         allowPublicMint = !allowPublicMint;
1761     }
1762 
1763     function setMerkleRoot(
1764         bytes32 newMerkleRoot
1765     ) public onlyOwner {
1766         merkleRoot = newMerkleRoot;
1767     }
1768 
1769     function setPrice(
1770         uint256 newPrice
1771     ) external onlyOwner {
1772         price = newPrice ;
1773     }
1774 
1775     function setTokenURI(
1776         string memory newBaseURI
1777     ) external onlyOwner {
1778         baseURI = newBaseURI;
1779     }
1780 
1781     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1782         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1783 
1784         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
1785     }
1786 
1787     function withdraw() public onlyOwner {
1788         require(address(this).balance > 0, "AlphaQueen: insufficient balance");
1789         uint256 payment1 = address(this).balance.div(100).mul(85);
1790         uint256 payment2 = address(this).balance.div(1000).mul(95);
1791         uint256 payment3 = address(this).balance.div(1000).mul(15);
1792         uint256 payment4 = address(this).balance.div(1000).mul(25);
1793         uint256 payment5 = address(this).balance.div(1000).mul(15);
1794         payable(wallet1).transfer(payment1);
1795         payable(wallet2).transfer(payment2);
1796         payable(wallet3).transfer(payment3);
1797         payable(wallet4).transfer(payment4);
1798         payable(wallet5).transfer(payment5);
1799     }
1800 }