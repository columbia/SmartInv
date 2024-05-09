1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/utils/Context.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.3/contracts/access/Ownable.sol
257 
258 
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _setOwner(_msgSender());
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         _setOwner(address(0));
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         _setOwner(newOwner);
320     }
321 
322     function _setOwner(address newOwner) private {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: contracts/IERC721A.sol
330 
331 
332 // ERC721A Contracts v4.2.2
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 /**
338  * @dev Interface of ERC721A.
339  */
340 interface IERC721A {
341     /**
342      * The caller must own the token or be an approved operator.
343      */
344     error ApprovalCallerNotOwnerNorApproved();
345 
346     /**
347      * The token does not exist.
348      */
349     error ApprovalQueryForNonexistentToken();
350 
351     /**
352      * Cannot query the balance for the zero address.
353      */
354     error BalanceQueryForZeroAddress();
355 
356     /**
357      * Cannot mint to the zero address.
358      */
359     error MintToZeroAddress();
360 
361     /**
362      * The quantity of tokens minted must be more than zero.
363      */
364     error MintZeroQuantity();
365 
366     /**
367      * The token does not exist.
368      */
369     error OwnerQueryForNonexistentToken();
370 
371     /**
372      * The caller must own the token or be an approved operator.
373      */
374     error TransferCallerNotOwnerNorApproved();
375 
376     /**
377      * The token must be owned by `from`.
378      */
379     error TransferFromIncorrectOwner();
380 
381     /**
382      * Cannot safely transfer to a contract that does not implement the
383      * ERC721Receiver interface.
384      */
385     error TransferToNonERC721ReceiverImplementer();
386 
387     /**
388      * Cannot transfer to the zero address.
389      */
390     error TransferToZeroAddress();
391 
392     /**
393      * The token does not exist.
394      */
395     error URIQueryForNonexistentToken();
396 
397     /**
398      * The `quantity` minted with ERC2309 exceeds the safety limit.
399      */
400     error MintERC2309QuantityExceedsLimit();
401 
402     /**
403      * The `extraData` cannot be set on an unintialized ownership slot.
404      */
405     error OwnershipNotInitializedForExtraData();
406 
407     // =============================================================
408     //                            STRUCTS
409     // =============================================================
410 
411     struct TokenOwnership {
412         // The address of the owner.
413         address addr;
414         // Stores the start time of ownership with minimal overhead for tokenomics.
415         uint64 startTimestamp;
416         // Whether the token has been burned.
417         bool burned;
418         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
419         uint24 extraData;
420     }
421 
422     // =============================================================
423     //                         TOKEN COUNTERS
424     // =============================================================
425 
426     /**
427      * @dev Returns the total number of tokens in existence.
428      * Burned tokens will reduce the count.
429      * To get the total number of tokens minted, please see {_totalMinted}.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     // =============================================================
434     //                            IERC165
435     // =============================================================
436 
437     /**
438      * @dev Returns true if this contract implements the interface defined by
439      * `interfaceId`. See the corresponding
440      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
441      * to learn more about how these ids are created.
442      *
443      * This function call must use less than 30000 gas.
444      */
445     function supportsInterface(bytes4 interfaceId) external view returns (bool);
446 
447     // =============================================================
448     //                            IERC721
449     // =============================================================
450 
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables
463      * (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in `owner`'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`,
483      * checking first that contract recipients are aware of the ERC721 protocol
484      * to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move
492      * this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement
494      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes calldata data
503     ) external payable;
504 
505     /**
506      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
507      */
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external payable;
513 
514     /**
515      * @dev Transfers `tokenId` from `from` to `to`.
516      *
517      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
518      * whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token
526      * by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external payable;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the
541      * zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external payable;
551 
552     /**
553      * @dev Approve or remove `operator` as an operator for the caller.
554      * Operators can call {transferFrom} or {safeTransferFrom}
555      * for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns the account approved for `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function getApproved(uint256 tokenId) external view returns (address operator);
573 
574     /**
575      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
576      *
577      * See {setApprovalForAll}.
578      */
579     function isApprovedForAll(address owner, address operator) external view returns (bool);
580 
581     // =============================================================
582     //                        IERC721Metadata
583     // =============================================================
584 
585     /**
586      * @dev Returns the token collection name.
587      */
588     function name() external view returns (string memory);
589 
590     /**
591      * @dev Returns the token collection symbol.
592      */
593     function symbol() external view returns (string memory);
594 
595     /**
596      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
597      */
598     function tokenURI(uint256 tokenId) external view returns (string memory);
599 
600     // =============================================================
601     //                           IERC2309
602     // =============================================================
603 
604     /**
605      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
606      * (inclusive) is transferred from `from` to `to`, as defined in the
607      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
608      *
609      * See {_mintERC2309} for more details.
610      */
611     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
612 }
613 // File: contracts/ERC721A.sol
614 
615 
616 // ERC721A Contracts v4.2.2
617 // Creator: Chiru Labs
618 
619 pragma solidity ^0.8.4;
620 
621 
622 /**
623  * @dev Interface of ERC721 token receiver.
624  */
625 interface ERC721A__IERC721Receiver {
626     function onERC721Received(
627         address operator,
628         address from,
629         uint256 tokenId,
630         bytes calldata data
631     ) external returns (bytes4);
632 }
633 
634 /**
635  * @title ERC721A
636  *
637  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
638  * Non-Fungible Token Standard, including the Metadata extension.
639  * Optimized for lower gas during batch mints.
640  *
641  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
642  * starting from `_startTokenId()`.
643  *
644  * Assumptions:
645  *
646  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
647  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
648  */
649 contract ERC721A is IERC721A {
650     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
651     struct TokenApprovalRef {
652         address value;
653     }
654 
655     // =============================================================
656     //                           CONSTANTS
657     // =============================================================
658 
659     // Mask of an entry in packed address data.
660     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
661 
662     // The bit position of `numberMinted` in packed address data.
663     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
664 
665     // The bit position of `numberBurned` in packed address data.
666     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
667 
668     // The bit position of `aux` in packed address data.
669     uint256 private constant _BITPOS_AUX = 192;
670 
671     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
672     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
673 
674     // The bit position of `startTimestamp` in packed ownership.
675     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
676 
677     // The bit mask of the `burned` bit in packed ownership.
678     uint256 private constant _BITMASK_BURNED = 1 << 224;
679 
680     // The bit position of the `nextInitialized` bit in packed ownership.
681     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
682 
683     // The bit mask of the `nextInitialized` bit in packed ownership.
684     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
685 
686     // The bit position of `extraData` in packed ownership.
687     uint256 private constant _BITPOS_EXTRA_DATA = 232;
688 
689     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
690     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
691 
692     // The mask of the lower 160 bits for addresses.
693     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
694 
695     // The maximum `quantity` that can be minted with {_mintERC2309}.
696     // This limit is to prevent overflows on the address data entries.
697     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
698     // is required to cause an overflow, which is unrealistic.
699     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
700 
701     // The `Transfer` event signature is given by:
702     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
703     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
704         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
705 
706     // =============================================================
707     //                            STORAGE
708     // =============================================================
709 
710     // The next token ID to be minted.
711     uint256 private _currentIndex;
712 
713     // The number of tokens burned.
714     uint256 private _burnCounter;
715 
716     // Token name
717     string private _name;
718 
719     // Token symbol
720     string private _symbol;
721 
722     // Mapping from token ID to ownership details
723     // An empty struct value does not necessarily mean the token is unowned.
724     // See {_packedOwnershipOf} implementation for details.
725     //
726     // Bits Layout:
727     // - [0..159]   `addr`
728     // - [160..223] `startTimestamp`
729     // - [224]      `burned`
730     // - [225]      `nextInitialized`
731     // - [232..255] `extraData`
732     mapping(uint256 => uint256) private _packedOwnerships;
733 
734     // Mapping owner address to address data.
735     //
736     // Bits Layout:
737     // - [0..63]    `balance`
738     // - [64..127]  `numberMinted`
739     // - [128..191] `numberBurned`
740     // - [192..255] `aux`
741     mapping(address => uint256) private _packedAddressData;
742 
743     // Mapping from token ID to approved address.
744     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
745 
746     // Mapping from owner to operator approvals
747     mapping(address => mapping(address => bool)) private _operatorApprovals;
748 
749     // =============================================================
750     //                          CONSTRUCTOR
751     // =============================================================
752 
753     constructor(string memory name_, string memory symbol_) {
754         _name = name_;
755         _symbol = symbol_;
756         _currentIndex = _startTokenId();
757     }
758 
759     // =============================================================
760     //                   TOKEN COUNTING OPERATIONS
761     // =============================================================
762 
763     /**
764      * @dev Returns the starting token ID.
765      * To change the starting token ID, please override this function.
766      */
767     function _startTokenId() internal view virtual returns (uint256) {
768         return 1;
769     }
770 
771     /**
772      * @dev Returns the next token ID to be minted.
773      */
774     function _nextTokenId() internal view virtual returns (uint256) {
775         return _currentIndex;
776     }
777 
778     /**
779      * @dev Returns the total number of tokens in existence.
780      * Burned tokens will reduce the count.
781      * To get the total number of tokens minted, please see {_totalMinted}.
782      */
783     function totalSupply() public view virtual override returns (uint256) {
784         // Counter underflow is impossible as _burnCounter cannot be incremented
785         // more than `_currentIndex - _startTokenId()` times.
786         unchecked {
787             return _currentIndex - _burnCounter - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev Returns the total amount of tokens minted in the contract.
793      */
794     function _totalMinted() internal view virtual returns (uint256) {
795         // Counter underflow is impossible as `_currentIndex` does not decrement,
796         // and it is initialized to `_startTokenId()`.
797         unchecked {
798             return _currentIndex - _startTokenId();
799         }
800     }
801 
802     /**
803      * @dev Returns the total number of tokens burned.
804      */
805     function _totalBurned() internal view virtual returns (uint256) {
806         return _burnCounter;
807     }
808 
809     // =============================================================
810     //                    ADDRESS DATA OPERATIONS
811     // =============================================================
812 
813     /**
814      * @dev Returns the number of tokens in `owner`'s account.
815      */
816     function balanceOf(address owner) public view virtual override returns (uint256) {
817         if (owner == address(0)) revert BalanceQueryForZeroAddress();
818         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
819     }
820 
821     /**
822      * Returns the number of tokens minted by `owner`.
823      */
824     function _numberMinted(address owner) internal view returns (uint256) {
825         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
826     }
827 
828     /**
829      * Returns the number of tokens burned by or on behalf of `owner`.
830      */
831     function _numberBurned(address owner) internal view returns (uint256) {
832         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
833     }
834 
835     /**
836      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
837      */
838     function _getAux(address owner) internal view returns (uint64) {
839         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
840     }
841 
842     /**
843      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
844      * If there are multiple variables, please pack them into a uint64.
845      */
846     function _setAux(address owner, uint64 aux) internal virtual {
847         uint256 packed = _packedAddressData[owner];
848         uint256 auxCasted;
849         // Cast `aux` with assembly to avoid redundant masking.
850         assembly {
851             auxCasted := aux
852         }
853         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
854         _packedAddressData[owner] = packed;
855     }
856 
857     // =============================================================
858     //                            IERC165
859     // =============================================================
860 
861     /**
862      * @dev Returns true if this contract implements the interface defined by
863      * `interfaceId`. See the corresponding
864      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
865      * to learn more about how these ids are created.
866      *
867      * This function call must use less than 30000 gas.
868      */
869     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
870         // The interface IDs are constants representing the first 4 bytes
871         // of the XOR of all function selectors in the interface.
872         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
873         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
874         return
875             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
876             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
877             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
878     }
879 
880     // =============================================================
881     //                        IERC721Metadata
882     // =============================================================
883 
884     /**
885      * @dev Returns the token collection name.
886      */
887     function name() public view virtual override returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev Returns the token collection symbol.
893      */
894     function symbol() public view virtual override returns (string memory) {
895         return _symbol;
896     }
897 
898     /**
899      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
900      */
901     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
902         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
903 
904         string memory baseURI = _baseURI();
905         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
906     }
907 
908     /**
909      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
910      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
911      * by default, it can be overridden in child contracts.
912      */
913     function _baseURI() internal view virtual returns (string memory) {
914         return '';
915     }
916 
917     // =============================================================
918     //                     OWNERSHIPS OPERATIONS
919     // =============================================================
920 
921     /**
922      * @dev Returns the owner of the `tokenId` token.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
929         return address(uint160(_packedOwnershipOf(tokenId)));
930     }
931 
932     /**
933      * @dev Gas spent here starts off proportional to the maximum mint batch size.
934      * It gradually moves to O(1) as tokens get transferred around over time.
935      */
936     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
937         return _unpackedOwnership(_packedOwnershipOf(tokenId));
938     }
939 
940     /**
941      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
942      */
943     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
944         return _unpackedOwnership(_packedOwnerships[index]);
945     }
946 
947     /**
948      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
949      */
950     function _initializeOwnershipAt(uint256 index) internal virtual {
951         if (_packedOwnerships[index] == 0) {
952             _packedOwnerships[index] = _packedOwnershipOf(index);
953         }
954     }
955 
956     /**
957      * Returns the packed ownership data of `tokenId`.
958      */
959     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
960         uint256 curr = tokenId;
961 
962         unchecked {
963             if (_startTokenId() <= curr)
964                 if (curr < _currentIndex) {
965                     uint256 packed = _packedOwnerships[curr];
966                     // If not burned.
967                     if (packed & _BITMASK_BURNED == 0) {
968                         // Invariant:
969                         // There will always be an initialized ownership slot
970                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
971                         // before an unintialized ownership slot
972                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
973                         // Hence, `curr` will not underflow.
974                         //
975                         // We can directly compare the packed value.
976                         // If the address is zero, packed will be zero.
977                         while (packed == 0) {
978                             packed = _packedOwnerships[--curr];
979                         }
980                         return packed;
981                     }
982                 }
983         }
984         revert OwnerQueryForNonexistentToken();
985     }
986 
987     /**
988      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
989      */
990     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
991         ownership.addr = address(uint160(packed));
992         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
993         ownership.burned = packed & _BITMASK_BURNED != 0;
994         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
995     }
996 
997     /**
998      * @dev Packs ownership data into a single uint256.
999      */
1000     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1001         assembly {
1002             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1003             owner := and(owner, _BITMASK_ADDRESS)
1004             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1005             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1006         }
1007     }
1008 
1009     /**
1010      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1011      */
1012     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1013         // For branchless setting of the `nextInitialized` flag.
1014         assembly {
1015             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1016             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1017         }
1018     }
1019 
1020     // =============================================================
1021     //                      APPROVAL OPERATIONS
1022     // =============================================================
1023 
1024     /**
1025      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1026      * The approval is cleared when the token is transferred.
1027      *
1028      * Only a single account can be approved at a time, so approving the
1029      * zero address clears previous approvals.
1030      *
1031      * Requirements:
1032      *
1033      * - The caller must own the token or be an approved operator.
1034      * - `tokenId` must exist.
1035      *
1036      * Emits an {Approval} event.
1037      */
1038     function approve(address to, uint256 tokenId) public payable virtual override {
1039         address owner = ownerOf(tokenId);
1040 
1041         if (_msgSenderERC721A() != owner)
1042             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1043                 revert ApprovalCallerNotOwnerNorApproved();
1044             }
1045 
1046         _tokenApprovals[tokenId].value = to;
1047         emit Approval(owner, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Returns the account approved for `tokenId` token.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must exist.
1056      */
1057     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1058         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1059 
1060         return _tokenApprovals[tokenId].value;
1061     }
1062 
1063     /**
1064      * @dev Approve or remove `operator` as an operator for the caller.
1065      * Operators can call {transferFrom} or {safeTransferFrom}
1066      * for any token owned by the caller.
1067      *
1068      * Requirements:
1069      *
1070      * - The `operator` cannot be the caller.
1071      *
1072      * Emits an {ApprovalForAll} event.
1073      */
1074     function setApprovalForAll(address operator, bool approved) public virtual override {
1075         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1076         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1077     }
1078 
1079     /**
1080      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1081      *
1082      * See {setApprovalForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev Returns whether `tokenId` exists.
1090      *
1091      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1092      *
1093      * Tokens start existing when they are minted. See {_mint}.
1094      */
1095     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1096         return
1097             _startTokenId() <= tokenId &&
1098             tokenId < _currentIndex && // If within bounds,
1099             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1100     }
1101 
1102     /**
1103      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1104      */
1105     function _isSenderApprovedOrOwner(
1106         address approvedAddress,
1107         address owner,
1108         address msgSender
1109     ) private pure returns (bool result) {
1110         assembly {
1111             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1112             owner := and(owner, _BITMASK_ADDRESS)
1113             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1114             msgSender := and(msgSender, _BITMASK_ADDRESS)
1115             // `msgSender == owner || msgSender == approvedAddress`.
1116             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1122      */
1123     function _getApprovedSlotAndAddress(uint256 tokenId)
1124         private
1125         view
1126         returns (uint256 approvedAddressSlot, address approvedAddress)
1127     {
1128         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1129         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1130         assembly {
1131             approvedAddressSlot := tokenApproval.slot
1132             approvedAddress := sload(approvedAddressSlot)
1133         }
1134     }
1135 
1136     // =============================================================
1137     //                      TRANSFER OPERATIONS
1138     // =============================================================
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `from` cannot be the zero address.
1146      * - `to` cannot be the zero address.
1147      * - `tokenId` token must be owned by `from`.
1148      * - If the caller is not `from`, it must be approved to move this token
1149      * by either {approve} or {setApprovalForAll}.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function transferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) public payable virtual override {
1158         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1159 
1160         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1161 
1162         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1163 
1164         // The nested ifs save around 20+ gas over a compound boolean condition.
1165         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1166             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1167 
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner.
1173         assembly {
1174             if approvedAddress {
1175                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1176                 sstore(approvedAddressSlot, 0)
1177             }
1178         }
1179 
1180         // Underflow of the sender's balance is impossible because we check for
1181         // ownership above and the recipient's balance can't realistically overflow.
1182         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1183         unchecked {
1184             // We can directly increment and decrement the balances.
1185             --_packedAddressData[from]; // Updates: `balance -= 1`.
1186             ++_packedAddressData[to]; // Updates: `balance += 1`.
1187 
1188             // Updates:
1189             // - `address` to the next owner.
1190             // - `startTimestamp` to the timestamp of transfering.
1191             // - `burned` to `false`.
1192             // - `nextInitialized` to `true`.
1193             _packedOwnerships[tokenId] = _packOwnershipData(
1194                 to,
1195                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1196             );
1197 
1198             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1199             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1200                 uint256 nextTokenId = tokenId + 1;
1201                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1202                 if (_packedOwnerships[nextTokenId] == 0) {
1203                     // If the next slot is within bounds.
1204                     if (nextTokenId != _currentIndex) {
1205                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1206                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1207                     }
1208                 }
1209             }
1210         }
1211 
1212         emit Transfer(from, to, tokenId);
1213         _afterTokenTransfers(from, to, tokenId, 1);
1214     }
1215 
1216     /**
1217      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) public payable virtual override {
1224         safeTransferFrom(from, to, tokenId, '');
1225     }
1226 
1227     /**
1228      * @dev Safely transfers `tokenId` token from `from` to `to`.
1229      *
1230      * Requirements:
1231      *
1232      * - `from` cannot be the zero address.
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must exist and be owned by `from`.
1235      * - If the caller is not `from`, it must be approved to move this token
1236      * by either {approve} or {setApprovalForAll}.
1237      * - If `to` refers to a smart contract, it must implement
1238      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId,
1246         bytes memory _data
1247     ) public payable virtual override {
1248         transferFrom(from, to, tokenId);
1249         if (to.code.length != 0)
1250             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1251                 revert TransferToNonERC721ReceiverImplementer();
1252             }
1253     }
1254 
1255     /**
1256      * @dev Hook that is called before a set of serially-ordered token IDs
1257      * are about to be transferred. This includes minting.
1258      * And also called before burning one token.
1259      *
1260      * `startTokenId` - the first token ID to be transferred.
1261      * `quantity` - the amount to be transferred.
1262      *
1263      * Calling conditions:
1264      *
1265      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1266      * transferred to `to`.
1267      * - When `from` is zero, `tokenId` will be minted for `to`.
1268      * - When `to` is zero, `tokenId` will be burned by `from`.
1269      * - `from` and `to` are never both zero.
1270      */
1271     function _beforeTokenTransfers(
1272         address from,
1273         address to,
1274         uint256 startTokenId,
1275         uint256 quantity
1276     ) internal virtual {}
1277 
1278     /**
1279      * @dev Hook that is called after a set of serially-ordered token IDs
1280      * have been transferred. This includes minting.
1281      * And also called after one token has been burned.
1282      *
1283      * `startTokenId` - the first token ID to be transferred.
1284      * `quantity` - the amount to be transferred.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` has been minted for `to`.
1291      * - When `to` is zero, `tokenId` has been burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _afterTokenTransfers(
1295         address from,
1296         address to,
1297         uint256 startTokenId,
1298         uint256 quantity
1299     ) internal virtual {}
1300 
1301     /**
1302      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1303      *
1304      * `from` - Previous owner of the given token ID.
1305      * `to` - Target address that will receive the token.
1306      * `tokenId` - Token ID to be transferred.
1307      * `_data` - Optional data to send along with the call.
1308      *
1309      * Returns whether the call correctly returned the expected magic value.
1310      */
1311     function _checkContractOnERC721Received(
1312         address from,
1313         address to,
1314         uint256 tokenId,
1315         bytes memory _data
1316     ) private returns (bool) {
1317         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1318             bytes4 retval
1319         ) {
1320             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1321         } catch (bytes memory reason) {
1322             if (reason.length == 0) {
1323                 revert TransferToNonERC721ReceiverImplementer();
1324             } else {
1325                 assembly {
1326                     revert(add(32, reason), mload(reason))
1327                 }
1328             }
1329         }
1330     }
1331 
1332     // =============================================================
1333     //                        MINT OPERATIONS
1334     // =============================================================
1335 
1336     /**
1337      * @dev Mints `quantity` tokens and transfers them to `to`.
1338      *
1339      * Requirements:
1340      *
1341      * - `to` cannot be the zero address.
1342      * - `quantity` must be greater than 0.
1343      *
1344      * Emits a {Transfer} event for each mint.
1345      */
1346     function _mint(address to, uint256 quantity) internal virtual {
1347         uint256 startTokenId = _currentIndex;
1348         if (quantity == 0) revert MintZeroQuantity();
1349 
1350         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1351 
1352         // Overflows are incredibly unrealistic.
1353         // `balance` and `numberMinted` have a maximum limit of 2**64.
1354         // `tokenId` has a maximum limit of 2**256.
1355         unchecked {
1356             // Updates:
1357             // - `balance += quantity`.
1358             // - `numberMinted += quantity`.
1359             //
1360             // We can directly add to the `balance` and `numberMinted`.
1361             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1362 
1363             // Updates:
1364             // - `address` to the owner.
1365             // - `startTimestamp` to the timestamp of minting.
1366             // - `burned` to `false`.
1367             // - `nextInitialized` to `quantity == 1`.
1368             _packedOwnerships[startTokenId] = _packOwnershipData(
1369                 to,
1370                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1371             );
1372 
1373             uint256 toMasked;
1374             uint256 end = startTokenId + quantity;
1375 
1376             // Use assembly to loop and emit the `Transfer` event for gas savings.
1377             // The duplicated `log4` removes an extra check and reduces stack juggling.
1378             // The assembly, together with the surrounding Solidity code, have been
1379             // delicately arranged to nudge the compiler into producing optimized opcodes.
1380             assembly {
1381                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1382                 toMasked := and(to, _BITMASK_ADDRESS)
1383                 // Emit the `Transfer` event.
1384                 log4(
1385                     0, // Start of data (0, since no data).
1386                     0, // End of data (0, since no data).
1387                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1388                     0, // `address(0)`.
1389                     toMasked, // `to`.
1390                     startTokenId // `tokenId`.
1391                 )
1392 
1393                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1394                 // that overflows uint256 will make the loop run out of gas.
1395                 // The compiler will optimize the `iszero` away for performance.
1396                 for {
1397                     let tokenId := add(startTokenId, 1)
1398                 } iszero(eq(tokenId, end)) {
1399                     tokenId := add(tokenId, 1)
1400                 } {
1401                     // Emit the `Transfer` event. Similar to above.
1402                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1403                 }
1404             }
1405             if (toMasked == 0) revert MintToZeroAddress();
1406 
1407             _currentIndex = end;
1408         }
1409         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1410     }
1411 
1412     /**
1413      * @dev Mints `quantity` tokens and transfers them to `to`.
1414      *
1415      * This function is intended for efficient minting only during contract creation.
1416      *
1417      * It emits only one {ConsecutiveTransfer} as defined in
1418      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1419      * instead of a sequence of {Transfer} event(s).
1420      *
1421      * Calling this function outside of contract creation WILL make your contract
1422      * non-compliant with the ERC721 standard.
1423      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1424      * {ConsecutiveTransfer} event is only permissible during contract creation.
1425      *
1426      * Requirements:
1427      *
1428      * - `to` cannot be the zero address.
1429      * - `quantity` must be greater than 0.
1430      *
1431      * Emits a {ConsecutiveTransfer} event.
1432      */
1433     function _mintERC2309(address to, uint256 quantity) internal virtual {
1434         uint256 startTokenId = _currentIndex;
1435         if (to == address(0)) revert MintToZeroAddress();
1436         if (quantity == 0) revert MintZeroQuantity();
1437         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1438 
1439         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1440 
1441         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1442         unchecked {
1443             // Updates:
1444             // - `balance += quantity`.
1445             // - `numberMinted += quantity`.
1446             //
1447             // We can directly add to the `balance` and `numberMinted`.
1448             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1449 
1450             // Updates:
1451             // - `address` to the owner.
1452             // - `startTimestamp` to the timestamp of minting.
1453             // - `burned` to `false`.
1454             // - `nextInitialized` to `quantity == 1`.
1455             _packedOwnerships[startTokenId] = _packOwnershipData(
1456                 to,
1457                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1458             );
1459 
1460             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1461 
1462             _currentIndex = startTokenId + quantity;
1463         }
1464         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1465     }
1466 
1467     /**
1468      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1469      *
1470      * Requirements:
1471      *
1472      * - If `to` refers to a smart contract, it must implement
1473      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1474      * - `quantity` must be greater than 0.
1475      *
1476      * See {_mint}.
1477      *
1478      * Emits a {Transfer} event for each mint.
1479      */
1480     function _safeMint(
1481         address to,
1482         uint256 quantity,
1483         bytes memory _data
1484     ) internal virtual {
1485         _mint(to, quantity);
1486 
1487         unchecked {
1488             if (to.code.length != 0) {
1489                 uint256 end = _currentIndex;
1490                 uint256 index = end - quantity;
1491                 do {
1492                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1493                         revert TransferToNonERC721ReceiverImplementer();
1494                     }
1495                 } while (index < end);
1496                 // Reentrancy protection.
1497                 if (_currentIndex != end) revert();
1498             }
1499         }
1500     }
1501 
1502     /**
1503      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1504      */
1505     function _safeMint(address to, uint256 quantity) internal virtual {
1506         _safeMint(to, quantity, '');
1507     }
1508 
1509     // =============================================================
1510     //                        BURN OPERATIONS
1511     // =============================================================
1512 
1513     /**
1514      * @dev Equivalent to `_burn(tokenId, false)`.
1515      */
1516     function _burn(uint256 tokenId) internal virtual {
1517         _burn(tokenId, false);
1518     }
1519 
1520     /**
1521      * @dev Destroys `tokenId`.
1522      * The approval is cleared when the token is burned.
1523      *
1524      * Requirements:
1525      *
1526      * - `tokenId` must exist.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1531         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1532 
1533         address from = address(uint160(prevOwnershipPacked));
1534 
1535         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1536 
1537         if (approvalCheck) {
1538             // The nested ifs save around 20+ gas over a compound boolean condition.
1539             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1540                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1541         }
1542 
1543         _beforeTokenTransfers(from, address(0), tokenId, 1);
1544 
1545         // Clear approvals from the previous owner.
1546         assembly {
1547             if approvedAddress {
1548                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1549                 sstore(approvedAddressSlot, 0)
1550             }
1551         }
1552 
1553         // Underflow of the sender's balance is impossible because we check for
1554         // ownership above and the recipient's balance can't realistically overflow.
1555         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1556         unchecked {
1557             // Updates:
1558             // - `balance -= 1`.
1559             // - `numberBurned += 1`.
1560             //
1561             // We can directly decrement the balance, and increment the number burned.
1562             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1563             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1564 
1565             // Updates:
1566             // - `address` to the last owner.
1567             // - `startTimestamp` to the timestamp of burning.
1568             // - `burned` to `true`.
1569             // - `nextInitialized` to `true`.
1570             _packedOwnerships[tokenId] = _packOwnershipData(
1571                 from,
1572                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1573             );
1574 
1575             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1576             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1577                 uint256 nextTokenId = tokenId + 1;
1578                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1579                 if (_packedOwnerships[nextTokenId] == 0) {
1580                     // If the next slot is within bounds.
1581                     if (nextTokenId != _currentIndex) {
1582                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1583                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1584                     }
1585                 }
1586             }
1587         }
1588 
1589         emit Transfer(from, address(0), tokenId);
1590         _afterTokenTransfers(from, address(0), tokenId, 1);
1591 
1592         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1593         unchecked {
1594             _burnCounter++;
1595         }
1596     }
1597 
1598     // =============================================================
1599     //                     EXTRA DATA OPERATIONS
1600     // =============================================================
1601 
1602     /**
1603      * @dev Directly sets the extra data for the ownership data `index`.
1604      */
1605     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1606         uint256 packed = _packedOwnerships[index];
1607         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1608         uint256 extraDataCasted;
1609         // Cast `extraData` with assembly to avoid redundant masking.
1610         assembly {
1611             extraDataCasted := extraData
1612         }
1613         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1614         _packedOwnerships[index] = packed;
1615     }
1616 
1617     /**
1618      * @dev Called during each token transfer to set the 24bit `extraData` field.
1619      * Intended to be overridden by the cosumer contract.
1620      *
1621      * `previousExtraData` - the value of `extraData` before transfer.
1622      *
1623      * Calling conditions:
1624      *
1625      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1626      * transferred to `to`.
1627      * - When `from` is zero, `tokenId` will be minted for `to`.
1628      * - When `to` is zero, `tokenId` will be burned by `from`.
1629      * - `from` and `to` are never both zero.
1630      */
1631     function _extraData(
1632         address from,
1633         address to,
1634         uint24 previousExtraData
1635     ) internal view virtual returns (uint24) {}
1636 
1637     /**
1638      * @dev Returns the next extra data for the packed ownership data.
1639      * The returned result is shifted into position.
1640      */
1641     function _nextExtraData(
1642         address from,
1643         address to,
1644         uint256 prevOwnershipPacked
1645     ) private view returns (uint256) {
1646         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1647         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1648     }
1649 
1650     // =============================================================
1651     //                       OTHER OPERATIONS
1652     // =============================================================
1653 
1654     /**
1655      * @dev Returns the message sender (defaults to `msg.sender`).
1656      *
1657      * If you are writing GSN compatible contracts, you need to override this function.
1658      */
1659     function _msgSenderERC721A() internal view virtual returns (address) {
1660         return msg.sender;
1661     }
1662 
1663     /**
1664      * @dev Converts a uint256 to its ASCII string decimal representation.
1665      */
1666     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1667         assembly {
1668             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1669             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1670             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1671             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1672             let m := add(mload(0x40), 0xa0)
1673             // Update the free memory pointer to allocate.
1674             mstore(0x40, m)
1675             // Assign the `str` to the end.
1676             str := sub(m, 0x20)
1677             // Zeroize the slot after the string.
1678             mstore(str, 0)
1679 
1680             // Cache the end of the memory to calculate the length later.
1681             let end := str
1682 
1683             // We write the string from rightmost digit to leftmost digit.
1684             // The following is essentially a do-while loop that also handles the zero case.
1685             // prettier-ignore
1686             for { let temp := value } 1 {} {
1687                 str := sub(str, 1)
1688                 // Write the character to the pointer.
1689                 // The ASCII index of the '0' character is 48.
1690                 mstore8(str, add(48, mod(temp, 10)))
1691                 // Keep dividing `temp` until zero.
1692                 temp := div(temp, 10)
1693                 // prettier-ignore
1694                 if iszero(temp) { break }
1695             }
1696 
1697             let length := sub(end, str)
1698             // Move the pointer 32 bytes leftwards to make room for the length.
1699             str := sub(str, 0x20)
1700             // Store the length.
1701             mstore(str, length)
1702         }
1703     }
1704 }
1705 // File: contracts/GaGAPunks.sol
1706 
1707 
1708 
1709 
1710 
1711 pragma solidity ^0.8.7;
1712 
1713 contract GaGaPunks is ERC721A, Ownable{
1714     using SafeMath for uint256;
1715 
1716     uint public maxPerTransactionForFreeMint = 5;
1717     uint public maxPerTransaction = 20;
1718     uint public supplyLimit = 20000;
1719     uint public freeSupply = 2000;
1720     bool public publicSaleActive = false;
1721     string public baseURI;
1722     uint256 public tokenPrice = .049 ether;
1723 
1724   constructor(string memory name, string memory symbol, string memory baseURIinput)
1725     ERC721A(name, symbol)
1726   {
1727       baseURI = baseURIinput;
1728   }
1729 
1730   function _baseURI() internal view override returns (string memory) {
1731     return baseURI;
1732   }
1733 
1734   function setBaseURI(string calldata newBaseUri) external onlyOwner {
1735     baseURI = newBaseUri;
1736   }
1737 
1738   function togglePublicSaleActive() external onlyOwner {
1739     publicSaleActive = !publicSaleActive;
1740   }
1741   
1742   function mint(uint256 _quantity) external payable{
1743       if(totalSupply() < freeSupply){
1744           require(_quantity <= maxPerTransactionForFreeMint, "Over max per transaction! Free mint is limited to 5 tokens per transaction.");
1745       }
1746       else{
1747           require(_quantity <= maxPerTransaction, "Over max per transaction! Limit is 20 per transaction.");
1748       }
1749 
1750       require(publicSaleActive == true, "Not Yet Active.");
1751       require((totalSupply() + _quantity) <= supplyLimit, "Supply reached");
1752       uint256 salePrice = totalSupply() >= freeSupply ? tokenPrice : 0;
1753       require(msg.value >= (salePrice * _quantity), "Insufficient funds");
1754       _safeMint(msg.sender, _quantity);
1755   }
1756 
1757   function withdraw() public onlyOwner {
1758         uint256 balance = address(this).balance;
1759         payable(msg.sender).transfer(balance);
1760     }
1761 }