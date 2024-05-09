1 /*
2 **Muhlady is a post-modern collection of 6,666 hand-made NFTs. 
3 **Drawing inspiration from MiladyMaker in the overall design, 
4 **each Muhlady NFT features a distinct neochibi-inspired character with its own design, look and overall rarity. 
5 **The collection boasts intricate details and vibrant colors that give it a trendy aesthetic for internet users.
6 
7 ****Socials****
8 ****Twitter: https://twitter.com/muhladymaker
9 ****Discord: discord.gg/muhlady
10 
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGP555PGB&@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&P?~:.        :~?P&@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@&#GP5YYYY5PGB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G!.                 .7G@@@@@@@@@@
14 @@@@@@@@@@@@B57^:            .^7YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#!                       !#@@@@@@@@
15 @@@@@@@@@#J^                      ^?B@@@@@@@@@@@@@@@@@@@@@@@@@@@B.                         .G@@@@@@@
16 @@@@@@@#7.                           ~G@@@@@@@@@@@@@@@@@@@@@@@@#:                           .B@@@@@@
17 @@@@@@5.                               7&@@@@@@@@@@@@@@@@@@@@@@G.JJJ?7!!~^^::...             !@@@@@@
18 @@@@@Y                                . 7@@@@@@@@@@@@@@@@@@@@@@#:&@@@@@@@@@@&&##BB!!GP5YJ??7!7@@@@@@
19 @@@@B                      .:^~!7JYPGBB.~@@@@@@@@@@@@@@@@@@@@@@&^Y@@@@@@@@@@@@@@@#^&@@@@@@@@@@@@@@@@
20 @@@@J            :^!7?Y5PG##&@@@@@@@@@# ?@@@@@@@@@@@@@@@@@@@@@@P: 5@@@@@@B75P?Y&&~P@@@@@@@@@@@@@@@@@
21 @@@@? .:^~!?J5P5~G@@@@@@@@@@@@@@@@@@@@Y G@@@@@@@@@@@@@@@@@@@@@@@Y. :?P#&@#JP~  !^ #@@@@@@@@@@@@@@@@@
22 @@@@#B#&@@@@@@@@#75@@@@@@@@@@@@@@@G5G&: J&@@@@@@@@@@@@@@@@@@@@@@@BY7:..:^~!!~..:^P@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@J~P@@@@@@@@@&~~5   :.7&@@@@@@@@@@@@@@@@@@@@@@@@@@@B#GGGJPYPBB&@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@&&J^~YB&@@@@@@BGG7  :P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@&&PY:7!?7~!!~!~JJP#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@@@&@B&GP&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 */
29 
30 
31 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 // CAUTION
39 // This version of SafeMath should only be used with Solidity 0.8 or later,
40 // because it relies on the compiler's built in overflow checks.
41 
42 /**
43  * @dev Wrappers over Solidity's arithmetic operations.
44  *
45  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
46  * now has built in overflow checking.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             uint256 c = a + b;
57             if (c < a) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
64      *
65      * _Available since v3.4._
66      */
67     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b > a) return (false, 0);
70             return (true, a - b);
71         }
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82             // benefit is lost if 'b' is also tested.
83             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84             if (a == 0) return (true, 0);
85             uint256 c = a * b;
86             if (c / a != b) return (false, 0);
87             return (true, c);
88         }
89     }
90 
91     /**
92      * @dev Returns the division of two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             if (b == 0) return (false, 0);
99             return (true, a / b);
100         }
101     }
102 
103     /**
104      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
105      *
106      * _Available since v3.4._
107      */
108     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             if (b == 0) return (false, 0);
111             return (true, a % b);
112         }
113     }
114 
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a + b;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a - b;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a * b;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers, reverting on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator.
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a / b;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * reverting when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a % b;
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
189      * overflow (when the result is negative).
190      *
191      * CAUTION: This function is deprecated because it requires allocating memory for the error
192      * message unnecessarily. For custom revert reasons use {trySub}.
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(
201         uint256 a,
202         uint256 b,
203         string memory errorMessage
204     ) internal pure returns (uint256) {
205         unchecked {
206             require(b <= a, errorMessage);
207             return a - b;
208         }
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a / b;
231         }
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting with custom message when dividing by zero.
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {tryMod}.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         unchecked {
255             require(b > 0, errorMessage);
256             return a % b;
257         }
258     }
259 }
260 
261 // File: erc721a/contracts/IERC721A.sol
262 
263 
264 // ERC721A Contracts v4.2.3
265 // Creator: Chiru Labs
266 
267 pragma solidity ^0.8.4;
268 
269 /**
270  * @dev Interface of ERC721A.
271  */
272 interface IERC721A {
273     /**
274      * The caller must own the token or be an approved operator.
275      */
276     error ApprovalCallerNotOwnerNorApproved();
277 
278     /**
279      * The token does not exist.
280      */
281     error ApprovalQueryForNonexistentToken();
282 
283     /**
284      * Cannot query the balance for the zero address.
285      */
286     error BalanceQueryForZeroAddress();
287 
288     /**
289      * Cannot mint to the zero address.
290      */
291     error MintToZeroAddress();
292 
293     /**
294      * The quantity of tokens minted must be more than zero.
295      */
296     error MintZeroQuantity();
297 
298     /**
299      * The token does not exist.
300      */
301     error OwnerQueryForNonexistentToken();
302 
303     /**
304      * The caller must own the token or be an approved operator.
305      */
306     error TransferCallerNotOwnerNorApproved();
307 
308     /**
309      * The token must be owned by `from`.
310      */
311     error TransferFromIncorrectOwner();
312 
313     /**
314      * Cannot safely transfer to a contract that does not implement the
315      * ERC721Receiver interface.
316      */
317     error TransferToNonERC721ReceiverImplementer();
318 
319     /**
320      * Cannot transfer to the zero address.
321      */
322     error TransferToZeroAddress();
323 
324     /**
325      * The token does not exist.
326      */
327     error URIQueryForNonexistentToken();
328 
329     /**
330      * The `quantity` minted with ERC2309 exceeds the safety limit.
331      */
332     error MintERC2309QuantityExceedsLimit();
333 
334     /**
335      * The `extraData` cannot be set on an unintialized ownership slot.
336      */
337     error OwnershipNotInitializedForExtraData();
338 
339     // =============================================================
340     //                            STRUCTS
341     // =============================================================
342 
343     struct TokenOwnership {
344         // The address of the owner.
345         address addr;
346         // Stores the start time of ownership with minimal overhead for tokenomics.
347         uint64 startTimestamp;
348         // Whether the token has been burned.
349         bool burned;
350         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
351         uint24 extraData;
352     }
353 
354     // =============================================================
355     //                         TOKEN COUNTERS
356     // =============================================================
357 
358     /**
359      * @dev Returns the total number of tokens in existence.
360      * Burned tokens will reduce the count.
361      * To get the total number of tokens minted, please see {_totalMinted}.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     // =============================================================
366     //                            IERC165
367     // =============================================================
368 
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 
379     // =============================================================
380     //                            IERC721
381     // =============================================================
382 
383     /**
384      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
390      */
391     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables or disables
395      * (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in `owner`'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`,
415      * checking first that contract recipients are aware of the ERC721 protocol
416      * to prevent tokens from being forever locked.
417      *
418      * Requirements:
419      *
420      * - `from` cannot be the zero address.
421      * - `to` cannot be the zero address.
422      * - `tokenId` token must exist and be owned by `from`.
423      * - If the caller is not `from`, it must be have been allowed to move
424      * this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement
426      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes calldata data
435     ) external payable;
436 
437     /**
438      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external payable;
445 
446     /**
447      * @dev Transfers `tokenId` from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
450      * whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token
458      * by either {approve} or {setApprovalForAll}.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external payable;
467 
468     /**
469      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
470      * The approval is cleared when the token is transferred.
471      *
472      * Only a single account can be approved at a time, so approving the
473      * zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external payable;
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom}
487      * for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns the account approved for `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function getApproved(uint256 tokenId) external view returns (address operator);
505 
506     /**
507      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
508      *
509      * See {setApprovalForAll}.
510      */
511     function isApprovedForAll(address owner, address operator) external view returns (bool);
512 
513     // =============================================================
514     //                        IERC721Metadata
515     // =============================================================
516 
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 
532     // =============================================================
533     //                           IERC2309
534     // =============================================================
535 
536     /**
537      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
538      * (inclusive) is transferred from `from` to `to`, as defined in the
539      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
540      *
541      * See {_mintERC2309} for more details.
542      */
543     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
544 }
545 
546 // File: erc721a/contracts/ERC721A.sol
547 
548 
549 // ERC721A Contracts v4.2.3
550 // Creator: Chiru Labs
551 
552 pragma solidity ^0.8.4;
553 
554 
555 /**
556  * @dev Interface of ERC721 token receiver.
557  */
558 interface ERC721A__IERC721Receiver {
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 /**
568  * @title ERC721A
569  *
570  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
571  * Non-Fungible Token Standard, including the Metadata extension.
572  * Optimized for lower gas during batch mints.
573  *
574  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
575  * starting from `_startTokenId()`.
576  *
577  * Assumptions:
578  *
579  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
580  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
581  */
582 contract ERC721A is IERC721A {
583     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
584     struct TokenApprovalRef {
585         address value;
586     }
587 
588     // =============================================================
589     //                           CONSTANTS
590     // =============================================================
591 
592     // Mask of an entry in packed address data.
593     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
594 
595     // The bit position of `numberMinted` in packed address data.
596     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
597 
598     // The bit position of `numberBurned` in packed address data.
599     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
600 
601     // The bit position of `aux` in packed address data.
602     uint256 private constant _BITPOS_AUX = 192;
603 
604     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
605     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
606 
607     // The bit position of `startTimestamp` in packed ownership.
608     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
609 
610     // The bit mask of the `burned` bit in packed ownership.
611     uint256 private constant _BITMASK_BURNED = 1 << 224;
612 
613     // The bit position of the `nextInitialized` bit in packed ownership.
614     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
615 
616     // The bit mask of the `nextInitialized` bit in packed ownership.
617     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
618 
619     // The bit position of `extraData` in packed ownership.
620     uint256 private constant _BITPOS_EXTRA_DATA = 232;
621 
622     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
623     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
624 
625     // The mask of the lower 160 bits for addresses.
626     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
627 
628     // The maximum `quantity` that can be minted with {_mintERC2309}.
629     // This limit is to prevent overflows on the address data entries.
630     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
631     // is required to cause an overflow, which is unrealistic.
632     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
633 
634     // The `Transfer` event signature is given by:
635     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
636     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
637         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
638 
639     // =============================================================
640     //                            STORAGE
641     // =============================================================
642 
643     // The next token ID to be minted.
644     uint256 private _currentIndex;
645 
646     // The number of tokens burned.
647     uint256 private _burnCounter;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to ownership details
656     // An empty struct value does not necessarily mean the token is unowned.
657     // See {_packedOwnershipOf} implementation for details.
658     //
659     // Bits Layout:
660     // - [0..159]   `addr`
661     // - [160..223] `startTimestamp`
662     // - [224]      `burned`
663     // - [225]      `nextInitialized`
664     // - [232..255] `extraData`
665     mapping(uint256 => uint256) private _packedOwnerships;
666 
667     // Mapping owner address to address data.
668     //
669     // Bits Layout:
670     // - [0..63]    `balance`
671     // - [64..127]  `numberMinted`
672     // - [128..191] `numberBurned`
673     // - [192..255] `aux`
674     mapping(address => uint256) private _packedAddressData;
675 
676     // Mapping from token ID to approved address.
677     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     // =============================================================
683     //                          CONSTRUCTOR
684     // =============================================================
685 
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689         _currentIndex = _startTokenId();
690     }
691 
692     // =============================================================
693     //                   TOKEN COUNTING OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Returns the starting token ID.
698      * To change the starting token ID, please override this function.
699      */
700     function _startTokenId() internal view virtual returns (uint256) {
701         return 0;
702     }
703 
704     /**
705      * @dev Returns the next token ID to be minted.
706      */
707     function _nextTokenId() internal view virtual returns (uint256) {
708         return _currentIndex;
709     }
710 
711     /**
712      * @dev Returns the total number of tokens in existence.
713      * Burned tokens will reduce the count.
714      * To get the total number of tokens minted, please see {_totalMinted}.
715      */
716     function totalSupply() public view virtual override returns (uint256) {
717         // Counter underflow is impossible as _burnCounter cannot be incremented
718         // more than `_currentIndex - _startTokenId()` times.
719         unchecked {
720             return _currentIndex - _burnCounter - _startTokenId();
721         }
722     }
723 
724     /**
725      * @dev Returns the total amount of tokens minted in the contract.
726      */
727     function _totalMinted() internal view virtual returns (uint256) {
728         // Counter underflow is impossible as `_currentIndex` does not decrement,
729         // and it is initialized to `_startTokenId()`.
730         unchecked {
731             return _currentIndex - _startTokenId();
732         }
733     }
734 
735     /**
736      * @dev Returns the total number of tokens burned.
737      */
738     function _totalBurned() internal view virtual returns (uint256) {
739         return _burnCounter;
740     }
741 
742     // =============================================================
743     //                    ADDRESS DATA OPERATIONS
744     // =============================================================
745 
746     /**
747      * @dev Returns the number of tokens in `owner`'s account.
748      */
749     function balanceOf(address owner) public view virtual override returns (uint256) {
750         if (owner == address(0)) revert BalanceQueryForZeroAddress();
751         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
752     }
753 
754     /**
755      * Returns the number of tokens minted by `owner`.
756      */
757     function _numberMinted(address owner) internal view returns (uint256) {
758         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
759     }
760 
761     /**
762      * Returns the number of tokens burned by or on behalf of `owner`.
763      */
764     function _numberBurned(address owner) internal view returns (uint256) {
765         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
766     }
767 
768     /**
769      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
770      */
771     function _getAux(address owner) internal view returns (uint64) {
772         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
773     }
774 
775     /**
776      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
777      * If there are multiple variables, please pack them into a uint64.
778      */
779     function _setAux(address owner, uint64 aux) internal virtual {
780         uint256 packed = _packedAddressData[owner];
781         uint256 auxCasted;
782         // Cast `aux` with assembly to avoid redundant masking.
783         assembly {
784             auxCasted := aux
785         }
786         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
787         _packedAddressData[owner] = packed;
788     }
789 
790     // =============================================================
791     //                            IERC165
792     // =============================================================
793 
794     /**
795      * @dev Returns true if this contract implements the interface defined by
796      * `interfaceId`. See the corresponding
797      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
798      * to learn more about how these ids are created.
799      *
800      * This function call must use less than 30000 gas.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
803         // The interface IDs are constants representing the first 4 bytes
804         // of the XOR of all function selectors in the interface.
805         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
806         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
807         return
808             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
809             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
810             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
811     }
812 
813     // =============================================================
814     //                        IERC721Metadata
815     // =============================================================
816 
817     /**
818      * @dev Returns the token collection name.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev Returns the token collection symbol.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
833      */
834     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
835         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
836 
837         string memory baseURI = _baseURI();
838         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
839     }
840 
841     /**
842      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844      * by default, it can be overridden in child contracts.
845      */
846     function _baseURI() internal view virtual returns (string memory) {
847         return '';
848     }
849 
850     // =============================================================
851     //                     OWNERSHIPS OPERATIONS
852     // =============================================================
853 
854     /**
855      * @dev Returns the owner of the `tokenId` token.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      */
861     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
862         return address(uint160(_packedOwnershipOf(tokenId)));
863     }
864 
865     /**
866      * @dev Gas spent here starts off proportional to the maximum mint batch size.
867      * It gradually moves to O(1) as tokens get transferred around over time.
868      */
869     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
870         return _unpackedOwnership(_packedOwnershipOf(tokenId));
871     }
872 
873     /**
874      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
875      */
876     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
877         return _unpackedOwnership(_packedOwnerships[index]);
878     }
879 
880     /**
881      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
882      */
883     function _initializeOwnershipAt(uint256 index) internal virtual {
884         if (_packedOwnerships[index] == 0) {
885             _packedOwnerships[index] = _packedOwnershipOf(index);
886         }
887     }
888 
889     /**
890      * Returns the packed ownership data of `tokenId`.
891      */
892     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
893         uint256 curr = tokenId;
894 
895         unchecked {
896             if (_startTokenId() <= curr)
897                 if (curr < _currentIndex) {
898                     uint256 packed = _packedOwnerships[curr];
899                     // If not burned.
900                     if (packed & _BITMASK_BURNED == 0) {
901                         // Invariant:
902                         // There will always be an initialized ownership slot
903                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
904                         // before an unintialized ownership slot
905                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
906                         // Hence, `curr` will not underflow.
907                         //
908                         // We can directly compare the packed value.
909                         // If the address is zero, packed will be zero.
910                         while (packed == 0) {
911                             packed = _packedOwnerships[--curr];
912                         }
913                         return packed;
914                     }
915                 }
916         }
917         revert OwnerQueryForNonexistentToken();
918     }
919 
920     /**
921      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
922      */
923     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
924         ownership.addr = address(uint160(packed));
925         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
926         ownership.burned = packed & _BITMASK_BURNED != 0;
927         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
928     }
929 
930     /**
931      * @dev Packs ownership data into a single uint256.
932      */
933     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
934         assembly {
935             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
936             owner := and(owner, _BITMASK_ADDRESS)
937             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
938             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
939         }
940     }
941 
942     /**
943      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
944      */
945     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
946         // For branchless setting of the `nextInitialized` flag.
947         assembly {
948             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
949             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
950         }
951     }
952 
953     // =============================================================
954     //                      APPROVAL OPERATIONS
955     // =============================================================
956 
957     /**
958      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
959      * The approval is cleared when the token is transferred.
960      *
961      * Only a single account can be approved at a time, so approving the
962      * zero address clears previous approvals.
963      *
964      * Requirements:
965      *
966      * - The caller must own the token or be an approved operator.
967      * - `tokenId` must exist.
968      *
969      * Emits an {Approval} event.
970      */
971     function approve(address to, uint256 tokenId) public payable virtual override {
972         address owner = ownerOf(tokenId);
973 
974         if (_msgSenderERC721A() != owner)
975             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
976                 revert ApprovalCallerNotOwnerNorApproved();
977             }
978 
979         _tokenApprovals[tokenId].value = to;
980         emit Approval(owner, to, tokenId);
981     }
982 
983     /**
984      * @dev Returns the account approved for `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function getApproved(uint256 tokenId) public view virtual override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId].value;
994     }
995 
996     /**
997      * @dev Approve or remove `operator` as an operator for the caller.
998      * Operators can call {transferFrom} or {safeTransferFrom}
999      * for any token owned by the caller.
1000      *
1001      * Requirements:
1002      *
1003      * - The `operator` cannot be the caller.
1004      *
1005      * Emits an {ApprovalForAll} event.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1009         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1010     }
1011 
1012     /**
1013      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1014      *
1015      * See {setApprovalForAll}.
1016      */
1017     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1018         return _operatorApprovals[owner][operator];
1019     }
1020 
1021     /**
1022      * @dev Returns whether `tokenId` exists.
1023      *
1024      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025      *
1026      * Tokens start existing when they are minted. See {_mint}.
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return
1030             _startTokenId() <= tokenId &&
1031             tokenId < _currentIndex && // If within bounds,
1032             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1033     }
1034 
1035     /**
1036      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1037      */
1038     function _isSenderApprovedOrOwner(
1039         address approvedAddress,
1040         address owner,
1041         address msgSender
1042     ) private pure returns (bool result) {
1043         assembly {
1044             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1045             owner := and(owner, _BITMASK_ADDRESS)
1046             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1047             msgSender := and(msgSender, _BITMASK_ADDRESS)
1048             // `msgSender == owner || msgSender == approvedAddress`.
1049             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1055      */
1056     function _getApprovedSlotAndAddress(uint256 tokenId)
1057         private
1058         view
1059         returns (uint256 approvedAddressSlot, address approvedAddress)
1060     {
1061         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1062         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1063         assembly {
1064             approvedAddressSlot := tokenApproval.slot
1065             approvedAddress := sload(approvedAddressSlot)
1066         }
1067     }
1068 
1069     // =============================================================
1070     //                      TRANSFER OPERATIONS
1071     // =============================================================
1072 
1073     /**
1074      * @dev Transfers `tokenId` from `from` to `to`.
1075      *
1076      * Requirements:
1077      *
1078      * - `from` cannot be the zero address.
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      * - If the caller is not `from`, it must be approved to move this token
1082      * by either {approve} or {setApprovalForAll}.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function transferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public payable virtual override {
1091         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1092 
1093         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1094 
1095         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1096 
1097         // The nested ifs save around 20+ gas over a compound boolean condition.
1098         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1099             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1100 
1101         if (to == address(0)) revert TransferToZeroAddress();
1102 
1103         _beforeTokenTransfers(from, to, tokenId, 1);
1104 
1105         // Clear approvals from the previous owner.
1106         assembly {
1107             if approvedAddress {
1108                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1109                 sstore(approvedAddressSlot, 0)
1110             }
1111         }
1112 
1113         // Underflow of the sender's balance is impossible because we check for
1114         // ownership above and the recipient's balance can't realistically overflow.
1115         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1116         unchecked {
1117             // We can directly increment and decrement the balances.
1118             --_packedAddressData[from]; // Updates: `balance -= 1`.
1119             ++_packedAddressData[to]; // Updates: `balance += 1`.
1120 
1121             // Updates:
1122             // - `address` to the next owner.
1123             // - `startTimestamp` to the timestamp of transfering.
1124             // - `burned` to `false`.
1125             // - `nextInitialized` to `true`.
1126             _packedOwnerships[tokenId] = _packOwnershipData(
1127                 to,
1128                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1129             );
1130 
1131             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1132             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1133                 uint256 nextTokenId = tokenId + 1;
1134                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1135                 if (_packedOwnerships[nextTokenId] == 0) {
1136                     // If the next slot is within bounds.
1137                     if (nextTokenId != _currentIndex) {
1138                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1139                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1140                     }
1141                 }
1142             }
1143         }
1144 
1145         emit Transfer(from, to, tokenId);
1146         _afterTokenTransfers(from, to, tokenId, 1);
1147     }
1148 
1149     /**
1150      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1151      */
1152     function safeTransferFrom(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) public payable virtual override {
1157         safeTransferFrom(from, to, tokenId, '');
1158     }
1159 
1160     /**
1161      * @dev Safely transfers `tokenId` token from `from` to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - `from` cannot be the zero address.
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must exist and be owned by `from`.
1168      * - If the caller is not `from`, it must be approved to move this token
1169      * by either {approve} or {setApprovalForAll}.
1170      * - If `to` refers to a smart contract, it must implement
1171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function safeTransferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) public payable virtual override {
1181         transferFrom(from, to, tokenId);
1182         if (to.code.length != 0)
1183             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1184                 revert TransferToNonERC721ReceiverImplementer();
1185             }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before a set of serially-ordered token IDs
1190      * are about to be transferred. This includes minting.
1191      * And also called before burning one token.
1192      *
1193      * `startTokenId` - the first token ID to be transferred.
1194      * `quantity` - the amount to be transferred.
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, `tokenId` will be burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _beforeTokenTransfers(
1205         address from,
1206         address to,
1207         uint256 startTokenId,
1208         uint256 quantity
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after a set of serially-ordered token IDs
1213      * have been transferred. This includes minting.
1214      * And also called after one token has been burned.
1215      *
1216      * `startTokenId` - the first token ID to be transferred.
1217      * `quantity` - the amount to be transferred.
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` has been minted for `to`.
1224      * - When `to` is zero, `tokenId` has been burned by `from`.
1225      * - `from` and `to` are never both zero.
1226      */
1227     function _afterTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 
1234     /**
1235      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1236      *
1237      * `from` - Previous owner of the given token ID.
1238      * `to` - Target address that will receive the token.
1239      * `tokenId` - Token ID to be transferred.
1240      * `_data` - Optional data to send along with the call.
1241      *
1242      * Returns whether the call correctly returned the expected magic value.
1243      */
1244     function _checkContractOnERC721Received(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) private returns (bool) {
1250         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1251             bytes4 retval
1252         ) {
1253             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1254         } catch (bytes memory reason) {
1255             if (reason.length == 0) {
1256                 revert TransferToNonERC721ReceiverImplementer();
1257             } else {
1258                 assembly {
1259                     revert(add(32, reason), mload(reason))
1260                 }
1261             }
1262         }
1263     }
1264 
1265     // =============================================================
1266     //                        MINT OPERATIONS
1267     // =============================================================
1268 
1269     /**
1270      * @dev Mints `quantity` tokens and transfers them to `to`.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `quantity` must be greater than 0.
1276      *
1277      * Emits a {Transfer} event for each mint.
1278      */
1279     function _mint(address to, uint256 quantity) internal virtual {
1280         uint256 startTokenId = _currentIndex;
1281         if (quantity == 0) revert MintZeroQuantity();
1282 
1283         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1284 
1285         // Overflows are incredibly unrealistic.
1286         // `balance` and `numberMinted` have a maximum limit of 2**64.
1287         // `tokenId` has a maximum limit of 2**256.
1288         unchecked {
1289             // Updates:
1290             // - `balance += quantity`.
1291             // - `numberMinted += quantity`.
1292             //
1293             // We can directly add to the `balance` and `numberMinted`.
1294             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1295 
1296             // Updates:
1297             // - `address` to the owner.
1298             // - `startTimestamp` to the timestamp of minting.
1299             // - `burned` to `false`.
1300             // - `nextInitialized` to `quantity == 1`.
1301             _packedOwnerships[startTokenId] = _packOwnershipData(
1302                 to,
1303                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1304             );
1305 
1306             uint256 toMasked;
1307             uint256 end = startTokenId + quantity;
1308 
1309             // Use assembly to loop and emit the `Transfer` event for gas savings.
1310             // The duplicated `log4` removes an extra check and reduces stack juggling.
1311             // The assembly, together with the surrounding Solidity code, have been
1312             // delicately arranged to nudge the compiler into producing optimized opcodes.
1313             assembly {
1314                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1315                 toMasked := and(to, _BITMASK_ADDRESS)
1316                 // Emit the `Transfer` event.
1317                 log4(
1318                     0, // Start of data (0, since no data).
1319                     0, // End of data (0, since no data).
1320                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1321                     0, // `address(0)`.
1322                     toMasked, // `to`.
1323                     startTokenId // `tokenId`.
1324                 )
1325 
1326                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1327                 // that overflows uint256 will make the loop run out of gas.
1328                 // The compiler will optimize the `iszero` away for performance.
1329                 for {
1330                     let tokenId := add(startTokenId, 1)
1331                 } iszero(eq(tokenId, end)) {
1332                     tokenId := add(tokenId, 1)
1333                 } {
1334                     // Emit the `Transfer` event. Similar to above.
1335                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1336                 }
1337             }
1338             if (toMasked == 0) revert MintToZeroAddress();
1339 
1340             _currentIndex = end;
1341         }
1342         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1343     }
1344 
1345     /**
1346      * @dev Mints `quantity` tokens and transfers them to `to`.
1347      *
1348      * This function is intended for efficient minting only during contract creation.
1349      *
1350      * It emits only one {ConsecutiveTransfer} as defined in
1351      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1352      * instead of a sequence of {Transfer} event(s).
1353      *
1354      * Calling this function outside of contract creation WILL make your contract
1355      * non-compliant with the ERC721 standard.
1356      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1357      * {ConsecutiveTransfer} event is only permissible during contract creation.
1358      *
1359      * Requirements:
1360      *
1361      * - `to` cannot be the zero address.
1362      * - `quantity` must be greater than 0.
1363      *
1364      * Emits a {ConsecutiveTransfer} event.
1365      */
1366     function _mintERC2309(address to, uint256 quantity) internal virtual {
1367         uint256 startTokenId = _currentIndex;
1368         if (to == address(0)) revert MintToZeroAddress();
1369         if (quantity == 0) revert MintZeroQuantity();
1370         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1371 
1372         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1373 
1374         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1375         unchecked {
1376             // Updates:
1377             // - `balance += quantity`.
1378             // - `numberMinted += quantity`.
1379             //
1380             // We can directly add to the `balance` and `numberMinted`.
1381             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1382 
1383             // Updates:
1384             // - `address` to the owner.
1385             // - `startTimestamp` to the timestamp of minting.
1386             // - `burned` to `false`.
1387             // - `nextInitialized` to `quantity == 1`.
1388             _packedOwnerships[startTokenId] = _packOwnershipData(
1389                 to,
1390                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1391             );
1392 
1393             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1394 
1395             _currentIndex = startTokenId + quantity;
1396         }
1397         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1398     }
1399 
1400     /**
1401      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - If `to` refers to a smart contract, it must implement
1406      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1407      * - `quantity` must be greater than 0.
1408      *
1409      * See {_mint}.
1410      *
1411      * Emits a {Transfer} event for each mint.
1412      */
1413     function _safeMint(
1414         address to,
1415         uint256 quantity,
1416         bytes memory _data
1417     ) internal virtual {
1418         _mint(to, quantity);
1419 
1420         unchecked {
1421             if (to.code.length != 0) {
1422                 uint256 end = _currentIndex;
1423                 uint256 index = end - quantity;
1424                 do {
1425                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1426                         revert TransferToNonERC721ReceiverImplementer();
1427                     }
1428                 } while (index < end);
1429                 // Reentrancy protection.
1430                 if (_currentIndex != end) revert();
1431             }
1432         }
1433     }
1434 
1435     /**
1436      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1437      */
1438     function _safeMint(address to, uint256 quantity) internal virtual {
1439         _safeMint(to, quantity, '');
1440     }
1441 
1442     // =============================================================
1443     //                        BURN OPERATIONS
1444     // =============================================================
1445 
1446     /**
1447      * @dev Equivalent to `_burn(tokenId, false)`.
1448      */
1449     function _burn(uint256 tokenId) internal virtual {
1450         _burn(tokenId, false);
1451     }
1452 
1453     /**
1454      * @dev Destroys `tokenId`.
1455      * The approval is cleared when the token is burned.
1456      *
1457      * Requirements:
1458      *
1459      * - `tokenId` must exist.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1464         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1465 
1466         address from = address(uint160(prevOwnershipPacked));
1467 
1468         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1469 
1470         if (approvalCheck) {
1471             // The nested ifs save around 20+ gas over a compound boolean condition.
1472             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1473                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1474         }
1475 
1476         _beforeTokenTransfers(from, address(0), tokenId, 1);
1477 
1478         // Clear approvals from the previous owner.
1479         assembly {
1480             if approvedAddress {
1481                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1482                 sstore(approvedAddressSlot, 0)
1483             }
1484         }
1485 
1486         // Underflow of the sender's balance is impossible because we check for
1487         // ownership above and the recipient's balance can't realistically overflow.
1488         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1489         unchecked {
1490             // Updates:
1491             // - `balance -= 1`.
1492             // - `numberBurned += 1`.
1493             //
1494             // We can directly decrement the balance, and increment the number burned.
1495             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1496             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1497 
1498             // Updates:
1499             // - `address` to the last owner.
1500             // - `startTimestamp` to the timestamp of burning.
1501             // - `burned` to `true`.
1502             // - `nextInitialized` to `true`.
1503             _packedOwnerships[tokenId] = _packOwnershipData(
1504                 from,
1505                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1506             );
1507 
1508             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1509             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1510                 uint256 nextTokenId = tokenId + 1;
1511                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1512                 if (_packedOwnerships[nextTokenId] == 0) {
1513                     // If the next slot is within bounds.
1514                     if (nextTokenId != _currentIndex) {
1515                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1516                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1517                     }
1518                 }
1519             }
1520         }
1521 
1522         emit Transfer(from, address(0), tokenId);
1523         _afterTokenTransfers(from, address(0), tokenId, 1);
1524 
1525         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1526         unchecked {
1527             _burnCounter++;
1528         }
1529     }
1530 
1531     // =============================================================
1532     //                     EXTRA DATA OPERATIONS
1533     // =============================================================
1534 
1535     /**
1536      * @dev Directly sets the extra data for the ownership data `index`.
1537      */
1538     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1539         uint256 packed = _packedOwnerships[index];
1540         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1541         uint256 extraDataCasted;
1542         // Cast `extraData` with assembly to avoid redundant masking.
1543         assembly {
1544             extraDataCasted := extraData
1545         }
1546         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1547         _packedOwnerships[index] = packed;
1548     }
1549 
1550     /**
1551      * @dev Called during each token transfer to set the 24bit `extraData` field.
1552      * Intended to be overridden by the cosumer contract.
1553      *
1554      * `previousExtraData` - the value of `extraData` before transfer.
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` will be minted for `to`.
1561      * - When `to` is zero, `tokenId` will be burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _extraData(
1565         address from,
1566         address to,
1567         uint24 previousExtraData
1568     ) internal view virtual returns (uint24) {}
1569 
1570     /**
1571      * @dev Returns the next extra data for the packed ownership data.
1572      * The returned result is shifted into position.
1573      */
1574     function _nextExtraData(
1575         address from,
1576         address to,
1577         uint256 prevOwnershipPacked
1578     ) private view returns (uint256) {
1579         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1580         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1581     }
1582 
1583     // =============================================================
1584     //                       OTHER OPERATIONS
1585     // =============================================================
1586 
1587     /**
1588      * @dev Returns the message sender (defaults to `msg.sender`).
1589      *
1590      * If you are writing GSN compatible contracts, you need to override this function.
1591      */
1592     function _msgSenderERC721A() internal view virtual returns (address) {
1593         return msg.sender;
1594     }
1595 
1596     /**
1597      * @dev Converts a uint256 to its ASCII string decimal representation.
1598      */
1599     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1600         assembly {
1601             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1602             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1603             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1604             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1605             let m := add(mload(0x40), 0xa0)
1606             // Update the free memory pointer to allocate.
1607             mstore(0x40, m)
1608             // Assign the `str` to the end.
1609             str := sub(m, 0x20)
1610             // Zeroize the slot after the string.
1611             mstore(str, 0)
1612 
1613             // Cache the end of the memory to calculate the length later.
1614             let end := str
1615 
1616             // We write the string from rightmost digit to leftmost digit.
1617             // The following is essentially a do-while loop that also handles the zero case.
1618             // prettier-ignore
1619             for { let temp := value } 1 {} {
1620                 str := sub(str, 1)
1621                 // Write the character to the pointer.
1622                 // The ASCII index of the '0' character is 48.
1623                 mstore8(str, add(48, mod(temp, 10)))
1624                 // Keep dividing `temp` until zero.
1625                 temp := div(temp, 10)
1626                 // prettier-ignore
1627                 if iszero(temp) { break }
1628             }
1629 
1630             let length := sub(end, str)
1631             // Move the pointer 32 bytes leftwards to make room for the length.
1632             str := sub(str, 0x20)
1633             // Store the length.
1634             mstore(str, length)
1635         }
1636     }
1637 }
1638 
1639 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1640 
1641 
1642 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1643 
1644 pragma solidity ^0.8.0;
1645 
1646 /**
1647  * @dev These functions deal with verification of Merkle Tree proofs.
1648  *
1649  * The tree and the proofs can be generated using our
1650  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1651  * You will find a quickstart guide in the readme.
1652  *
1653  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1654  * hashing, or use a hash function other than keccak256 for hashing leaves.
1655  * This is because the concatenation of a sorted pair of internal nodes in
1656  * the merkle tree could be reinterpreted as a leaf value.
1657  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1658  * against this attack out of the box.
1659  */
1660 library MerkleProof {
1661     /**
1662      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1663      * defined by `root`. For this, a `proof` must be provided, containing
1664      * sibling hashes on the branch from the leaf to the root of the tree. Each
1665      * pair of leaves and each pair of pre-images are assumed to be sorted.
1666      */
1667     function verify(
1668         bytes32[] memory proof,
1669         bytes32 root,
1670         bytes32 leaf
1671     ) internal pure returns (bool) {
1672         return processProof(proof, leaf) == root;
1673     }
1674 
1675     /**
1676      * @dev Calldata version of {verify}
1677      *
1678      * _Available since v4.7._
1679      */
1680     function verifyCalldata(
1681         bytes32[] calldata proof,
1682         bytes32 root,
1683         bytes32 leaf
1684     ) internal pure returns (bool) {
1685         return processProofCalldata(proof, leaf) == root;
1686     }
1687 
1688     /**
1689      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1690      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1691      * hash matches the root of the tree. When processing the proof, the pairs
1692      * of leafs & pre-images are assumed to be sorted.
1693      *
1694      * _Available since v4.4._
1695      */
1696     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1697         bytes32 computedHash = leaf;
1698         for (uint256 i = 0; i < proof.length; i++) {
1699             computedHash = _hashPair(computedHash, proof[i]);
1700         }
1701         return computedHash;
1702     }
1703 
1704     /**
1705      * @dev Calldata version of {processProof}
1706      *
1707      * _Available since v4.7._
1708      */
1709     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1710         bytes32 computedHash = leaf;
1711         for (uint256 i = 0; i < proof.length; i++) {
1712             computedHash = _hashPair(computedHash, proof[i]);
1713         }
1714         return computedHash;
1715     }
1716 
1717     /**
1718      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1719      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1720      *
1721      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1722      *
1723      * _Available since v4.7._
1724      */
1725     function multiProofVerify(
1726         bytes32[] memory proof,
1727         bool[] memory proofFlags,
1728         bytes32 root,
1729         bytes32[] memory leaves
1730     ) internal pure returns (bool) {
1731         return processMultiProof(proof, proofFlags, leaves) == root;
1732     }
1733 
1734     /**
1735      * @dev Calldata version of {multiProofVerify}
1736      *
1737      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1738      *
1739      * _Available since v4.7._
1740      */
1741     function multiProofVerifyCalldata(
1742         bytes32[] calldata proof,
1743         bool[] calldata proofFlags,
1744         bytes32 root,
1745         bytes32[] memory leaves
1746     ) internal pure returns (bool) {
1747         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1748     }
1749 
1750     /**
1751      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1752      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1753      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1754      * respectively.
1755      *
1756      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1757      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1758      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1759      *
1760      * _Available since v4.7._
1761      */
1762     function processMultiProof(
1763         bytes32[] memory proof,
1764         bool[] memory proofFlags,
1765         bytes32[] memory leaves
1766     ) internal pure returns (bytes32 merkleRoot) {
1767         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1768         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1769         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1770         // the merkle tree.
1771         uint256 leavesLen = leaves.length;
1772         uint256 totalHashes = proofFlags.length;
1773 
1774         // Check proof validity.
1775         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1776 
1777         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1778         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1779         bytes32[] memory hashes = new bytes32[](totalHashes);
1780         uint256 leafPos = 0;
1781         uint256 hashPos = 0;
1782         uint256 proofPos = 0;
1783         // At each step, we compute the next hash using two values:
1784         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1785         //   get the next hash.
1786         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1787         //   `proof` array.
1788         for (uint256 i = 0; i < totalHashes; i++) {
1789             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1790             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1791             hashes[i] = _hashPair(a, b);
1792         }
1793 
1794         if (totalHashes > 0) {
1795             return hashes[totalHashes - 1];
1796         } else if (leavesLen > 0) {
1797             return leaves[0];
1798         } else {
1799             return proof[0];
1800         }
1801     }
1802 
1803     /**
1804      * @dev Calldata version of {processMultiProof}.
1805      *
1806      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1807      *
1808      * _Available since v4.7._
1809      */
1810     function processMultiProofCalldata(
1811         bytes32[] calldata proof,
1812         bool[] calldata proofFlags,
1813         bytes32[] memory leaves
1814     ) internal pure returns (bytes32 merkleRoot) {
1815         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1816         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1817         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1818         // the merkle tree.
1819         uint256 leavesLen = leaves.length;
1820         uint256 totalHashes = proofFlags.length;
1821 
1822         // Check proof validity.
1823         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1824 
1825         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1826         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1827         bytes32[] memory hashes = new bytes32[](totalHashes);
1828         uint256 leafPos = 0;
1829         uint256 hashPos = 0;
1830         uint256 proofPos = 0;
1831         // At each step, we compute the next hash using two values:
1832         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1833         //   get the next hash.
1834         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1835         //   `proof` array.
1836         for (uint256 i = 0; i < totalHashes; i++) {
1837             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1838             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1839             hashes[i] = _hashPair(a, b);
1840         }
1841 
1842         if (totalHashes > 0) {
1843             return hashes[totalHashes - 1];
1844         } else if (leavesLen > 0) {
1845             return leaves[0];
1846         } else {
1847             return proof[0];
1848         }
1849     }
1850 
1851     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1852         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1853     }
1854 
1855     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1856         /// @solidity memory-safe-assembly
1857         assembly {
1858             mstore(0x00, a)
1859             mstore(0x20, b)
1860             value := keccak256(0x00, 0x40)
1861         }
1862     }
1863 }
1864 
1865 // File: @openzeppelin/contracts/utils/math/Math.sol
1866 
1867 
1868 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 /**
1873  * @dev Standard math utilities missing in the Solidity language.
1874  */
1875 library Math {
1876     enum Rounding {
1877         Down, // Toward negative infinity
1878         Up, // Toward infinity
1879         Zero // Toward zero
1880     }
1881 
1882     /**
1883      * @dev Returns the largest of two numbers.
1884      */
1885     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1886         return a > b ? a : b;
1887     }
1888 
1889     /**
1890      * @dev Returns the smallest of two numbers.
1891      */
1892     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1893         return a < b ? a : b;
1894     }
1895 
1896     /**
1897      * @dev Returns the average of two numbers. The result is rounded towards
1898      * zero.
1899      */
1900     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1901         // (a + b) / 2 can overflow.
1902         return (a & b) + (a ^ b) / 2;
1903     }
1904 
1905     /**
1906      * @dev Returns the ceiling of the division of two numbers.
1907      *
1908      * This differs from standard division with `/` in that it rounds up instead
1909      * of rounding down.
1910      */
1911     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1912         // (a + b - 1) / b can overflow on addition, so we distribute.
1913         return a == 0 ? 0 : (a - 1) / b + 1;
1914     }
1915 
1916     /**
1917      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1918      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1919      * with further edits by Uniswap Labs also under MIT license.
1920      */
1921     function mulDiv(
1922         uint256 x,
1923         uint256 y,
1924         uint256 denominator
1925     ) internal pure returns (uint256 result) {
1926         unchecked {
1927             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1928             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1929             // variables such that product = prod1 * 2^256 + prod0.
1930             uint256 prod0; // Least significant 256 bits of the product
1931             uint256 prod1; // Most significant 256 bits of the product
1932             assembly {
1933                 let mm := mulmod(x, y, not(0))
1934                 prod0 := mul(x, y)
1935                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1936             }
1937 
1938             // Handle non-overflow cases, 256 by 256 division.
1939             if (prod1 == 0) {
1940                 return prod0 / denominator;
1941             }
1942 
1943             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1944             require(denominator > prod1);
1945 
1946             ///////////////////////////////////////////////
1947             // 512 by 256 division.
1948             ///////////////////////////////////////////////
1949 
1950             // Make division exact by subtracting the remainder from [prod1 prod0].
1951             uint256 remainder;
1952             assembly {
1953                 // Compute remainder using mulmod.
1954                 remainder := mulmod(x, y, denominator)
1955 
1956                 // Subtract 256 bit number from 512 bit number.
1957                 prod1 := sub(prod1, gt(remainder, prod0))
1958                 prod0 := sub(prod0, remainder)
1959             }
1960 
1961             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1962             // See https://cs.stackexchange.com/q/138556/92363.
1963 
1964             // Does not overflow because the denominator cannot be zero at this stage in the function.
1965             uint256 twos = denominator & (~denominator + 1);
1966             assembly {
1967                 // Divide denominator by twos.
1968                 denominator := div(denominator, twos)
1969 
1970                 // Divide [prod1 prod0] by twos.
1971                 prod0 := div(prod0, twos)
1972 
1973                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1974                 twos := add(div(sub(0, twos), twos), 1)
1975             }
1976 
1977             // Shift in bits from prod1 into prod0.
1978             prod0 |= prod1 * twos;
1979 
1980             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1981             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1982             // four bits. That is, denominator * inv = 1 mod 2^4.
1983             uint256 inverse = (3 * denominator) ^ 2;
1984 
1985             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1986             // in modular arithmetic, doubling the correct bits in each step.
1987             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1988             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1989             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1990             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1991             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1992             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1993 
1994             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1995             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1996             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1997             // is no longer required.
1998             result = prod0 * inverse;
1999             return result;
2000         }
2001     }
2002 
2003     /**
2004      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2005      */
2006     function mulDiv(
2007         uint256 x,
2008         uint256 y,
2009         uint256 denominator,
2010         Rounding rounding
2011     ) internal pure returns (uint256) {
2012         uint256 result = mulDiv(x, y, denominator);
2013         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2014             result += 1;
2015         }
2016         return result;
2017     }
2018 
2019     /**
2020      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2021      *
2022      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2023      */
2024     function sqrt(uint256 a) internal pure returns (uint256) {
2025         if (a == 0) {
2026             return 0;
2027         }
2028 
2029         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2030         //
2031         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2032         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2033         //
2034         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2035         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2036         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2037         //
2038         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2039         uint256 result = 1 << (log2(a) >> 1);
2040 
2041         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2042         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2043         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2044         // into the expected uint128 result.
2045         unchecked {
2046             result = (result + a / result) >> 1;
2047             result = (result + a / result) >> 1;
2048             result = (result + a / result) >> 1;
2049             result = (result + a / result) >> 1;
2050             result = (result + a / result) >> 1;
2051             result = (result + a / result) >> 1;
2052             result = (result + a / result) >> 1;
2053             return min(result, a / result);
2054         }
2055     }
2056 
2057     /**
2058      * @notice Calculates sqrt(a), following the selected rounding direction.
2059      */
2060     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2061         unchecked {
2062             uint256 result = sqrt(a);
2063             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2064         }
2065     }
2066 
2067     /**
2068      * @dev Return the log in base 2, rounded down, of a positive value.
2069      * Returns 0 if given 0.
2070      */
2071     function log2(uint256 value) internal pure returns (uint256) {
2072         uint256 result = 0;
2073         unchecked {
2074             if (value >> 128 > 0) {
2075                 value >>= 128;
2076                 result += 128;
2077             }
2078             if (value >> 64 > 0) {
2079                 value >>= 64;
2080                 result += 64;
2081             }
2082             if (value >> 32 > 0) {
2083                 value >>= 32;
2084                 result += 32;
2085             }
2086             if (value >> 16 > 0) {
2087                 value >>= 16;
2088                 result += 16;
2089             }
2090             if (value >> 8 > 0) {
2091                 value >>= 8;
2092                 result += 8;
2093             }
2094             if (value >> 4 > 0) {
2095                 value >>= 4;
2096                 result += 4;
2097             }
2098             if (value >> 2 > 0) {
2099                 value >>= 2;
2100                 result += 2;
2101             }
2102             if (value >> 1 > 0) {
2103                 result += 1;
2104             }
2105         }
2106         return result;
2107     }
2108 
2109     /**
2110      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2111      * Returns 0 if given 0.
2112      */
2113     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2114         unchecked {
2115             uint256 result = log2(value);
2116             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2117         }
2118     }
2119 
2120     /**
2121      * @dev Return the log in base 10, rounded down, of a positive value.
2122      * Returns 0 if given 0.
2123      */
2124     function log10(uint256 value) internal pure returns (uint256) {
2125         uint256 result = 0;
2126         unchecked {
2127             if (value >= 10**64) {
2128                 value /= 10**64;
2129                 result += 64;
2130             }
2131             if (value >= 10**32) {
2132                 value /= 10**32;
2133                 result += 32;
2134             }
2135             if (value >= 10**16) {
2136                 value /= 10**16;
2137                 result += 16;
2138             }
2139             if (value >= 10**8) {
2140                 value /= 10**8;
2141                 result += 8;
2142             }
2143             if (value >= 10**4) {
2144                 value /= 10**4;
2145                 result += 4;
2146             }
2147             if (value >= 10**2) {
2148                 value /= 10**2;
2149                 result += 2;
2150             }
2151             if (value >= 10**1) {
2152                 result += 1;
2153             }
2154         }
2155         return result;
2156     }
2157 
2158     /**
2159      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2160      * Returns 0 if given 0.
2161      */
2162     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2163         unchecked {
2164             uint256 result = log10(value);
2165             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2166         }
2167     }
2168 
2169     /**
2170      * @dev Return the log in base 256, rounded down, of a positive value.
2171      * Returns 0 if given 0.
2172      *
2173      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2174      */
2175     function log256(uint256 value) internal pure returns (uint256) {
2176         uint256 result = 0;
2177         unchecked {
2178             if (value >> 128 > 0) {
2179                 value >>= 128;
2180                 result += 16;
2181             }
2182             if (value >> 64 > 0) {
2183                 value >>= 64;
2184                 result += 8;
2185             }
2186             if (value >> 32 > 0) {
2187                 value >>= 32;
2188                 result += 4;
2189             }
2190             if (value >> 16 > 0) {
2191                 value >>= 16;
2192                 result += 2;
2193             }
2194             if (value >> 8 > 0) {
2195                 result += 1;
2196             }
2197         }
2198         return result;
2199     }
2200 
2201     /**
2202      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2203      * Returns 0 if given 0.
2204      */
2205     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2206         unchecked {
2207             uint256 result = log256(value);
2208             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2209         }
2210     }
2211 }
2212 
2213 // File: @openzeppelin/contracts/utils/Strings.sol
2214 
2215 
2216 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2217 
2218 pragma solidity ^0.8.0;
2219 
2220 
2221 /**
2222  * @dev String operations.
2223  */
2224 library Strings {
2225     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2226     uint8 private constant _ADDRESS_LENGTH = 20;
2227 
2228     /**
2229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2230      */
2231     function toString(uint256 value) internal pure returns (string memory) {
2232         unchecked {
2233             uint256 length = Math.log10(value) + 1;
2234             string memory buffer = new string(length);
2235             uint256 ptr;
2236             /// @solidity memory-safe-assembly
2237             assembly {
2238                 ptr := add(buffer, add(32, length))
2239             }
2240             while (true) {
2241                 ptr--;
2242                 /// @solidity memory-safe-assembly
2243                 assembly {
2244                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2245                 }
2246                 value /= 10;
2247                 if (value == 0) break;
2248             }
2249             return buffer;
2250         }
2251     }
2252 
2253     /**
2254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2255      */
2256     function toHexString(uint256 value) internal pure returns (string memory) {
2257         unchecked {
2258             return toHexString(value, Math.log256(value) + 1);
2259         }
2260     }
2261 
2262     /**
2263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2264      */
2265     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2266         bytes memory buffer = new bytes(2 * length + 2);
2267         buffer[0] = "0";
2268         buffer[1] = "x";
2269         for (uint256 i = 2 * length + 1; i > 1; --i) {
2270             buffer[i] = _SYMBOLS[value & 0xf];
2271             value >>= 4;
2272         }
2273         require(value == 0, "Strings: hex length insufficient");
2274         return string(buffer);
2275     }
2276 
2277     /**
2278      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2279      */
2280     function toHexString(address addr) internal pure returns (string memory) {
2281         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2282     }
2283 }
2284 
2285 // File: @openzeppelin/contracts/utils/Context.sol
2286 
2287 
2288 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2289 
2290 pragma solidity ^0.8.0;
2291 
2292 /**
2293  * @dev Provides information about the current execution context, including the
2294  * sender of the transaction and its data. While these are generally available
2295  * via msg.sender and msg.data, they should not be accessed in such a direct
2296  * manner, since when dealing with meta-transactions the account sending and
2297  * paying for execution may not be the actual sender (as far as an application
2298  * is concerned).
2299  *
2300  * This contract is only required for intermediate, library-like contracts.
2301  */
2302 abstract contract Context {
2303     function _msgSender() internal view virtual returns (address) {
2304         return msg.sender;
2305     }
2306 
2307     function _msgData() internal view virtual returns (bytes calldata) {
2308         return msg.data;
2309     }
2310 }
2311 
2312 // File: @openzeppelin/contracts/access/Ownable.sol
2313 
2314 
2315 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2316 
2317 pragma solidity ^0.8.0;
2318 
2319 
2320 /**
2321  * @dev Contract module which provides a basic access control mechanism, where
2322  * there is an account (an owner) that can be granted exclusive access to
2323  * specific functions.
2324  *
2325  * By default, the owner account will be the one that deploys the contract. This
2326  * can later be changed with {transferOwnership}.
2327  *
2328  * This module is used through inheritance. It will make available the modifier
2329  * `onlyOwner`, which can be applied to your functions to restrict their use to
2330  * the owner.
2331  */
2332 abstract contract Ownable is Context {
2333     address private _owner;
2334 
2335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2336 
2337     /**
2338      * @dev Initializes the contract setting the deployer as the initial owner.
2339      */
2340     constructor() {
2341         _transferOwnership(_msgSender());
2342     }
2343 
2344     /**
2345      * @dev Throws if called by any account other than the owner.
2346      */
2347     modifier onlyOwner() {
2348         _checkOwner();
2349         _;
2350     }
2351 
2352     /**
2353      * @dev Returns the address of the current owner.
2354      */
2355     function owner() public view virtual returns (address) {
2356         return _owner;
2357     }
2358 
2359     /**
2360      * @dev Throws if the sender is not the owner.
2361      */
2362     function _checkOwner() internal view virtual {
2363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2364     }
2365 
2366     /**
2367      * @dev Leaves the contract without owner. It will not be possible to call
2368      * `onlyOwner` functions anymore. Can only be called by the current owner.
2369      *
2370      * NOTE: Renouncing ownership will leave the contract without an owner,
2371      * thereby removing any functionality that is only available to the owner.
2372      */
2373     function renounceOwnership() public virtual onlyOwner {
2374         _transferOwnership(address(0));
2375     }
2376 
2377     /**
2378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2379      * Can only be called by the current owner.
2380      */
2381     function transferOwnership(address newOwner) public virtual onlyOwner {
2382         require(newOwner != address(0), "Ownable: new owner is the zero address");
2383         _transferOwnership(newOwner);
2384     }
2385 
2386     /**
2387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2388      * Internal function without access restriction.
2389      */
2390     function _transferOwnership(address newOwner) internal virtual {
2391         address oldOwner = _owner;
2392         _owner = newOwner;
2393         emit OwnershipTransferred(oldOwner, newOwner);
2394     }
2395 }
2396 
2397 // File: @openzeppelin/contracts/utils/Address.sol
2398 
2399 
2400 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2401 
2402 pragma solidity ^0.8.1;
2403 
2404 /**
2405  * @dev Collection of functions related to the address type
2406  */
2407 library Address {
2408     /**
2409      * @dev Returns true if `account` is a contract.
2410      *
2411      * [IMPORTANT]
2412      * ====
2413      * It is unsafe to assume that an address for which this function returns
2414      * false is an externally-owned account (EOA) and not a contract.
2415      *
2416      * Among others, `isContract` will return false for the following
2417      * types of addresses:
2418      *
2419      *  - an externally-owned account
2420      *  - a contract in construction
2421      *  - an address where a contract will be created
2422      *  - an address where a contract lived, but was destroyed
2423      * ====
2424      *
2425      * [IMPORTANT]
2426      * ====
2427      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2428      *
2429      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2430      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2431      * constructor.
2432      * ====
2433      */
2434     function isContract(address account) internal view returns (bool) {
2435         // This method relies on extcodesize/address.code.length, which returns 0
2436         // for contracts in construction, since the code is only stored at the end
2437         // of the constructor execution.
2438 
2439         return account.code.length > 0;
2440     }
2441 
2442     /**
2443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2444      * `recipient`, forwarding all available gas and reverting on errors.
2445      *
2446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2448      * imposed by `transfer`, making them unable to receive funds via
2449      * `transfer`. {sendValue} removes this limitation.
2450      *
2451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2452      *
2453      * IMPORTANT: because control is transferred to `recipient`, care must be
2454      * taken to not create reentrancy vulnerabilities. Consider using
2455      * {ReentrancyGuard} or the
2456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2457      */
2458     function sendValue(address payable recipient, uint256 amount) internal {
2459         require(address(this).balance >= amount, "Address: insufficient balance");
2460 
2461         (bool success, ) = recipient.call{value: amount}("");
2462         require(success, "Address: unable to send value, recipient may have reverted");
2463     }
2464 
2465     /**
2466      * @dev Performs a Solidity function call using a low level `call`. A
2467      * plain `call` is an unsafe replacement for a function call: use this
2468      * function instead.
2469      *
2470      * If `target` reverts with a revert reason, it is bubbled up by this
2471      * function (like regular Solidity function calls).
2472      *
2473      * Returns the raw returned data. To convert to the expected return value,
2474      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2475      *
2476      * Requirements:
2477      *
2478      * - `target` must be a contract.
2479      * - calling `target` with `data` must not revert.
2480      *
2481      * _Available since v3.1._
2482      */
2483     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2484         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2485     }
2486 
2487     /**
2488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2489      * `errorMessage` as a fallback revert reason when `target` reverts.
2490      *
2491      * _Available since v3.1._
2492      */
2493     function functionCall(
2494         address target,
2495         bytes memory data,
2496         string memory errorMessage
2497     ) internal returns (bytes memory) {
2498         return functionCallWithValue(target, data, 0, errorMessage);
2499     }
2500 
2501     /**
2502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2503      * but also transferring `value` wei to `target`.
2504      *
2505      * Requirements:
2506      *
2507      * - the calling contract must have an ETH balance of at least `value`.
2508      * - the called Solidity function must be `payable`.
2509      *
2510      * _Available since v3.1._
2511      */
2512     function functionCallWithValue(
2513         address target,
2514         bytes memory data,
2515         uint256 value
2516     ) internal returns (bytes memory) {
2517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2518     }
2519 
2520     /**
2521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2522      * with `errorMessage` as a fallback revert reason when `target` reverts.
2523      *
2524      * _Available since v3.1._
2525      */
2526     function functionCallWithValue(
2527         address target,
2528         bytes memory data,
2529         uint256 value,
2530         string memory errorMessage
2531     ) internal returns (bytes memory) {
2532         require(address(this).balance >= value, "Address: insufficient balance for call");
2533         (bool success, bytes memory returndata) = target.call{value: value}(data);
2534         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2535     }
2536 
2537     /**
2538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2539      * but performing a static call.
2540      *
2541      * _Available since v3.3._
2542      */
2543     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2544         return functionStaticCall(target, data, "Address: low-level static call failed");
2545     }
2546 
2547     /**
2548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2549      * but performing a static call.
2550      *
2551      * _Available since v3.3._
2552      */
2553     function functionStaticCall(
2554         address target,
2555         bytes memory data,
2556         string memory errorMessage
2557     ) internal view returns (bytes memory) {
2558         (bool success, bytes memory returndata) = target.staticcall(data);
2559         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2560     }
2561 
2562     /**
2563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2564      * but performing a delegate call.
2565      *
2566      * _Available since v3.4._
2567      */
2568     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2569         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2570     }
2571 
2572     /**
2573      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2574      * but performing a delegate call.
2575      *
2576      * _Available since v3.4._
2577      */
2578     function functionDelegateCall(
2579         address target,
2580         bytes memory data,
2581         string memory errorMessage
2582     ) internal returns (bytes memory) {
2583         (bool success, bytes memory returndata) = target.delegatecall(data);
2584         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2585     }
2586 
2587     /**
2588      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2589      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2590      *
2591      * _Available since v4.8._
2592      */
2593     function verifyCallResultFromTarget(
2594         address target,
2595         bool success,
2596         bytes memory returndata,
2597         string memory errorMessage
2598     ) internal view returns (bytes memory) {
2599         if (success) {
2600             if (returndata.length == 0) {
2601                 // only check isContract if the call was successful and the return data is empty
2602                 // otherwise we already know that it was a contract
2603                 require(isContract(target), "Address: call to non-contract");
2604             }
2605             return returndata;
2606         } else {
2607             _revert(returndata, errorMessage);
2608         }
2609     }
2610 
2611     /**
2612      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2613      * revert reason or using the provided one.
2614      *
2615      * _Available since v4.3._
2616      */
2617     function verifyCallResult(
2618         bool success,
2619         bytes memory returndata,
2620         string memory errorMessage
2621     ) internal pure returns (bytes memory) {
2622         if (success) {
2623             return returndata;
2624         } else {
2625             _revert(returndata, errorMessage);
2626         }
2627     }
2628 
2629     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2630         // Look for revert reason and bubble it up if present
2631         if (returndata.length > 0) {
2632             // The easiest way to bubble the revert reason is using memory via assembly
2633             /// @solidity memory-safe-assembly
2634             assembly {
2635                 let returndata_size := mload(returndata)
2636                 revert(add(32, returndata), returndata_size)
2637             }
2638         } else {
2639             revert(errorMessage);
2640         }
2641     }
2642 }
2643 
2644 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2645 
2646 
2647 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2648 
2649 pragma solidity ^0.8.0;
2650 
2651 /**
2652  * @title ERC721 token receiver interface
2653  * @dev Interface for any contract that wants to support safeTransfers
2654  * from ERC721 asset contracts.
2655  */
2656 interface IERC721Receiver {
2657     /**
2658      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2659      * by `operator` from `from`, this function is called.
2660      *
2661      * It must return its Solidity selector to confirm the token transfer.
2662      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2663      *
2664      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2665      */
2666     function onERC721Received(
2667         address operator,
2668         address from,
2669         uint256 tokenId,
2670         bytes calldata data
2671     ) external returns (bytes4);
2672 }
2673 
2674 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2675 
2676 
2677 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2678 
2679 pragma solidity ^0.8.0;
2680 
2681 /**
2682  * @dev Interface of the ERC165 standard, as defined in the
2683  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2684  *
2685  * Implementers can declare support of contract interfaces, which can then be
2686  * queried by others ({ERC165Checker}).
2687  *
2688  * For an implementation, see {ERC165}.
2689  */
2690 interface IERC165 {
2691     /**
2692      * @dev Returns true if this contract implements the interface defined by
2693      * `interfaceId`. See the corresponding
2694      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2695      * to learn more about how these ids are created.
2696      *
2697      * This function call must use less than 30 000 gas.
2698      */
2699     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2700 }
2701 
2702 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2703 
2704 
2705 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2706 
2707 pragma solidity ^0.8.0;
2708 
2709 
2710 /**
2711  * @dev Implementation of the {IERC165} interface.
2712  *
2713  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2714  * for the additional interface id that will be supported. For example:
2715  *
2716  * ```solidity
2717  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2718  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2719  * }
2720  * ```
2721  *
2722  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2723  */
2724 abstract contract ERC165 is IERC165 {
2725     /**
2726      * @dev See {IERC165-supportsInterface}.
2727      */
2728     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2729         return interfaceId == type(IERC165).interfaceId;
2730     }
2731 }
2732 
2733 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2734 
2735 
2736 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2737 
2738 pragma solidity ^0.8.0;
2739 
2740 
2741 /**
2742  * @dev Required interface of an ERC721 compliant contract.
2743  */
2744 interface IERC721 is IERC165 {
2745     /**
2746      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2747      */
2748     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2749 
2750     /**
2751      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2752      */
2753     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2754 
2755     /**
2756      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2757      */
2758     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2759 
2760     /**
2761      * @dev Returns the number of tokens in ``owner``'s account.
2762      */
2763     function balanceOf(address owner) external view returns (uint256 balance);
2764 
2765     /**
2766      * @dev Returns the owner of the `tokenId` token.
2767      *
2768      * Requirements:
2769      *
2770      * - `tokenId` must exist.
2771      */
2772     function ownerOf(uint256 tokenId) external view returns (address owner);
2773 
2774     /**
2775      * @dev Safely transfers `tokenId` token from `from` to `to`.
2776      *
2777      * Requirements:
2778      *
2779      * - `from` cannot be the zero address.
2780      * - `to` cannot be the zero address.
2781      * - `tokenId` token must exist and be owned by `from`.
2782      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2784      *
2785      * Emits a {Transfer} event.
2786      */
2787     function safeTransferFrom(
2788         address from,
2789         address to,
2790         uint256 tokenId,
2791         bytes calldata data
2792     ) external;
2793 
2794     /**
2795      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2796      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2797      *
2798      * Requirements:
2799      *
2800      * - `from` cannot be the zero address.
2801      * - `to` cannot be the zero address.
2802      * - `tokenId` token must exist and be owned by `from`.
2803      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2805      *
2806      * Emits a {Transfer} event.
2807      */
2808     function safeTransferFrom(
2809         address from,
2810         address to,
2811         uint256 tokenId
2812     ) external;
2813 
2814     /**
2815      * @dev Transfers `tokenId` token from `from` to `to`.
2816      *
2817      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2818      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2819      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2820      *
2821      * Requirements:
2822      *
2823      * - `from` cannot be the zero address.
2824      * - `to` cannot be the zero address.
2825      * - `tokenId` token must be owned by `from`.
2826      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2827      *
2828      * Emits a {Transfer} event.
2829      */
2830     function transferFrom(
2831         address from,
2832         address to,
2833         uint256 tokenId
2834     ) external;
2835 
2836     /**
2837      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2838      * The approval is cleared when the token is transferred.
2839      *
2840      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2841      *
2842      * Requirements:
2843      *
2844      * - The caller must own the token or be an approved operator.
2845      * - `tokenId` must exist.
2846      *
2847      * Emits an {Approval} event.
2848      */
2849     function approve(address to, uint256 tokenId) external;
2850 
2851     /**
2852      * @dev Approve or remove `operator` as an operator for the caller.
2853      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2854      *
2855      * Requirements:
2856      *
2857      * - The `operator` cannot be the caller.
2858      *
2859      * Emits an {ApprovalForAll} event.
2860      */
2861     function setApprovalForAll(address operator, bool _approved) external;
2862 
2863     /**
2864      * @dev Returns the account approved for `tokenId` token.
2865      *
2866      * Requirements:
2867      *
2868      * - `tokenId` must exist.
2869      */
2870     function getApproved(uint256 tokenId) external view returns (address operator);
2871 
2872     /**
2873      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2874      *
2875      * See {setApprovalForAll}
2876      */
2877     function isApprovedForAll(address owner, address operator) external view returns (bool);
2878 }
2879 
2880 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
2881 
2882 
2883 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
2884 
2885 pragma solidity ^0.8.0;
2886 
2887 
2888 /**
2889  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2890  * @dev See https://eips.ethereum.org/EIPS/eip-721
2891  */
2892 interface IERC721Enumerable is IERC721 {
2893     /**
2894      * @dev Returns the total amount of tokens stored by the contract.
2895      */
2896     function totalSupply() external view returns (uint256);
2897 
2898     /**
2899      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2900      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2901      */
2902     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
2903 
2904     /**
2905      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2906      * Use along with {totalSupply} to enumerate all tokens.
2907      */
2908     function tokenByIndex(uint256 index) external view returns (uint256);
2909 }
2910 
2911 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2912 
2913 
2914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2915 
2916 pragma solidity ^0.8.0;
2917 
2918 
2919 /**
2920  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2921  * @dev See https://eips.ethereum.org/EIPS/eip-721
2922  */
2923 interface IERC721Metadata is IERC721 {
2924     /**
2925      * @dev Returns the token collection name.
2926      */
2927     function name() external view returns (string memory);
2928 
2929     /**
2930      * @dev Returns the token collection symbol.
2931      */
2932     function symbol() external view returns (string memory);
2933 
2934     /**
2935      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2936      */
2937     function tokenURI(uint256 tokenId) external view returns (string memory);
2938 }
2939 
2940 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2941 
2942 
2943 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
2944 
2945 pragma solidity ^0.8.0;
2946 
2947 
2948 
2949 
2950 
2951 
2952 
2953 
2954 /**
2955  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2956  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2957  * {ERC721Enumerable}.
2958  */
2959 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2960     using Address for address;
2961     using Strings for uint256;
2962 
2963     // Token name
2964     string private _name;
2965 
2966     // Token symbol
2967     string private _symbol;
2968 
2969     // Mapping from token ID to owner address
2970     mapping(uint256 => address) private _owners;
2971 
2972     // Mapping owner address to token count
2973     mapping(address => uint256) private _balances;
2974 
2975     // Mapping from token ID to approved address
2976     mapping(uint256 => address) private _tokenApprovals;
2977 
2978     // Mapping from owner to operator approvals
2979     mapping(address => mapping(address => bool)) private _operatorApprovals;
2980 
2981     /**
2982      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2983      */
2984     constructor(string memory name_, string memory symbol_) {
2985         _name = name_;
2986         _symbol = symbol_;
2987     }
2988 
2989     /**
2990      * @dev See {IERC165-supportsInterface}.
2991      */
2992     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2993         return
2994             interfaceId == type(IERC721).interfaceId ||
2995             interfaceId == type(IERC721Metadata).interfaceId ||
2996             super.supportsInterface(interfaceId);
2997     }
2998 
2999     /**
3000      * @dev See {IERC721-balanceOf}.
3001      */
3002     function balanceOf(address owner) public view virtual override returns (uint256) {
3003         require(owner != address(0), "ERC721: address zero is not a valid owner");
3004         return _balances[owner];
3005     }
3006 
3007     /**
3008      * @dev See {IERC721-ownerOf}.
3009      */
3010     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3011         address owner = _ownerOf(tokenId);
3012         require(owner != address(0), "ERC721: invalid token ID");
3013         return owner;
3014     }
3015 
3016     /**
3017      * @dev See {IERC721Metadata-name}.
3018      */
3019     function name() public view virtual override returns (string memory) {
3020         return _name;
3021     }
3022 
3023     /**
3024      * @dev See {IERC721Metadata-symbol}.
3025      */
3026     function symbol() public view virtual override returns (string memory) {
3027         return _symbol;
3028     }
3029 
3030     /**
3031      * @dev See {IERC721Metadata-tokenURI}.
3032      */
3033     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3034         _requireMinted(tokenId);
3035 
3036         string memory baseURI = _baseURI();
3037         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3038     }
3039 
3040     /**
3041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3043      * by default, can be overridden in child contracts.
3044      */
3045     function _baseURI() internal view virtual returns (string memory) {
3046         return "";
3047     }
3048 
3049     /**
3050      * @dev See {IERC721-approve}.
3051      */
3052     function approve(address to, uint256 tokenId) public virtual override {
3053         address owner = ERC721.ownerOf(tokenId);
3054         require(to != owner, "ERC721: approval to current owner");
3055 
3056         require(
3057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3058             "ERC721: approve caller is not token owner or approved for all"
3059         );
3060 
3061         _approve(to, tokenId);
3062     }
3063 
3064     /**
3065      * @dev See {IERC721-getApproved}.
3066      */
3067     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3068         _requireMinted(tokenId);
3069 
3070         return _tokenApprovals[tokenId];
3071     }
3072 
3073     /**
3074      * @dev See {IERC721-setApprovalForAll}.
3075      */
3076     function setApprovalForAll(address operator, bool approved) public virtual override {
3077         _setApprovalForAll(_msgSender(), operator, approved);
3078     }
3079 
3080     /**
3081      * @dev See {IERC721-isApprovedForAll}.
3082      */
3083     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3084         return _operatorApprovals[owner][operator];
3085     }
3086 
3087     /**
3088      * @dev See {IERC721-transferFrom}.
3089      */
3090     function transferFrom(
3091         address from,
3092         address to,
3093         uint256 tokenId
3094     ) public virtual override {
3095         //solhint-disable-next-line max-line-length
3096         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3097 
3098         _transfer(from, to, tokenId);
3099     }
3100 
3101     /**
3102      * @dev See {IERC721-safeTransferFrom}.
3103      */
3104     function safeTransferFrom(
3105         address from,
3106         address to,
3107         uint256 tokenId
3108     ) public virtual override {
3109         safeTransferFrom(from, to, tokenId, "");
3110     }
3111 
3112     /**
3113      * @dev See {IERC721-safeTransferFrom}.
3114      */
3115     function safeTransferFrom(
3116         address from,
3117         address to,
3118         uint256 tokenId,
3119         bytes memory data
3120     ) public virtual override {
3121         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3122         _safeTransfer(from, to, tokenId, data);
3123     }
3124 
3125     /**
3126      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3127      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3128      *
3129      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3130      *
3131      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3132      * implement alternative mechanisms to perform token transfer, such as signature-based.
3133      *
3134      * Requirements:
3135      *
3136      * - `from` cannot be the zero address.
3137      * - `to` cannot be the zero address.
3138      * - `tokenId` token must exist and be owned by `from`.
3139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3140      *
3141      * Emits a {Transfer} event.
3142      */
3143     function _safeTransfer(
3144         address from,
3145         address to,
3146         uint256 tokenId,
3147         bytes memory data
3148     ) internal virtual {
3149         _transfer(from, to, tokenId);
3150         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3151     }
3152 
3153     /**
3154      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3155      */
3156     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3157         return _owners[tokenId];
3158     }
3159 
3160     /**
3161      * @dev Returns whether `tokenId` exists.
3162      *
3163      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3164      *
3165      * Tokens start existing when they are minted (`_mint`),
3166      * and stop existing when they are burned (`_burn`).
3167      */
3168     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3169         return _ownerOf(tokenId) != address(0);
3170     }
3171 
3172     /**
3173      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3174      *
3175      * Requirements:
3176      *
3177      * - `tokenId` must exist.
3178      */
3179     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3180         address owner = ERC721.ownerOf(tokenId);
3181         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3182     }
3183 
3184     /**
3185      * @dev Safely mints `tokenId` and transfers it to `to`.
3186      *
3187      * Requirements:
3188      *
3189      * - `tokenId` must not exist.
3190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3191      *
3192      * Emits a {Transfer} event.
3193      */
3194     function _safeMint(address to, uint256 tokenId) internal virtual {
3195         _safeMint(to, tokenId, "");
3196     }
3197 
3198     /**
3199      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3200      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3201      */
3202     function _safeMint(
3203         address to,
3204         uint256 tokenId,
3205         bytes memory data
3206     ) internal virtual {
3207         _mint(to, tokenId);
3208         require(
3209             _checkOnERC721Received(address(0), to, tokenId, data),
3210             "ERC721: transfer to non ERC721Receiver implementer"
3211         );
3212     }
3213 
3214     /**
3215      * @dev Mints `tokenId` and transfers it to `to`.
3216      *
3217      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3218      *
3219      * Requirements:
3220      *
3221      * - `tokenId` must not exist.
3222      * - `to` cannot be the zero address.
3223      *
3224      * Emits a {Transfer} event.
3225      */
3226     function _mint(address to, uint256 tokenId) internal virtual {
3227         require(to != address(0), "ERC721: mint to the zero address");
3228         require(!_exists(tokenId), "ERC721: token already minted");
3229 
3230         _beforeTokenTransfer(address(0), to, tokenId, 1);
3231 
3232         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3233         require(!_exists(tokenId), "ERC721: token already minted");
3234 
3235         unchecked {
3236             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3237             // Given that tokens are minted one by one, it is impossible in practice that
3238             // this ever happens. Might change if we allow batch minting.
3239             // The ERC fails to describe this case.
3240             _balances[to] += 1;
3241         }
3242 
3243         _owners[tokenId] = to;
3244 
3245         emit Transfer(address(0), to, tokenId);
3246 
3247         _afterTokenTransfer(address(0), to, tokenId, 1);
3248     }
3249 
3250     /**
3251      * @dev Destroys `tokenId`.
3252      * The approval is cleared when the token is burned.
3253      * This is an internal function that does not check if the sender is authorized to operate on the token.
3254      *
3255      * Requirements:
3256      *
3257      * - `tokenId` must exist.
3258      *
3259      * Emits a {Transfer} event.
3260      */
3261     function _burn(uint256 tokenId) internal virtual {
3262         address owner = ERC721.ownerOf(tokenId);
3263 
3264         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3265 
3266         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3267         owner = ERC721.ownerOf(tokenId);
3268 
3269         // Clear approvals
3270         delete _tokenApprovals[tokenId];
3271 
3272         unchecked {
3273             // Cannot overflow, as that would require more tokens to be burned/transferred
3274             // out than the owner initially received through minting and transferring in.
3275             _balances[owner] -= 1;
3276         }
3277         delete _owners[tokenId];
3278 
3279         emit Transfer(owner, address(0), tokenId);
3280 
3281         _afterTokenTransfer(owner, address(0), tokenId, 1);
3282     }
3283 
3284     /**
3285      * @dev Transfers `tokenId` from `from` to `to`.
3286      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3287      *
3288      * Requirements:
3289      *
3290      * - `to` cannot be the zero address.
3291      * - `tokenId` token must be owned by `from`.
3292      *
3293      * Emits a {Transfer} event.
3294      */
3295     function _transfer(
3296         address from,
3297         address to,
3298         uint256 tokenId
3299     ) internal virtual {
3300         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3301         require(to != address(0), "ERC721: transfer to the zero address");
3302 
3303         _beforeTokenTransfer(from, to, tokenId, 1);
3304 
3305         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3306         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3307 
3308         // Clear approvals from the previous owner
3309         delete _tokenApprovals[tokenId];
3310 
3311         unchecked {
3312             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3313             // `from`'s balance is the number of token held, which is at least one before the current
3314             // transfer.
3315             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3316             // all 2**256 token ids to be minted, which in practice is impossible.
3317             _balances[from] -= 1;
3318             _balances[to] += 1;
3319         }
3320         _owners[tokenId] = to;
3321 
3322         emit Transfer(from, to, tokenId);
3323 
3324         _afterTokenTransfer(from, to, tokenId, 1);
3325     }
3326 
3327     /**
3328      * @dev Approve `to` to operate on `tokenId`
3329      *
3330      * Emits an {Approval} event.
3331      */
3332     function _approve(address to, uint256 tokenId) internal virtual {
3333         _tokenApprovals[tokenId] = to;
3334         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3335     }
3336 
3337     /**
3338      * @dev Approve `operator` to operate on all of `owner` tokens
3339      *
3340      * Emits an {ApprovalForAll} event.
3341      */
3342     function _setApprovalForAll(
3343         address owner,
3344         address operator,
3345         bool approved
3346     ) internal virtual {
3347         require(owner != operator, "ERC721: approve to caller");
3348         _operatorApprovals[owner][operator] = approved;
3349         emit ApprovalForAll(owner, operator, approved);
3350     }
3351 
3352     /**
3353      * @dev Reverts if the `tokenId` has not been minted yet.
3354      */
3355     function _requireMinted(uint256 tokenId) internal view virtual {
3356         require(_exists(tokenId), "ERC721: invalid token ID");
3357     }
3358 
3359     /**
3360      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3361      * The call is not executed if the target address is not a contract.
3362      *
3363      * @param from address representing the previous owner of the given token ID
3364      * @param to target address that will receive the tokens
3365      * @param tokenId uint256 ID of the token to be transferred
3366      * @param data bytes optional data to send along with the call
3367      * @return bool whether the call correctly returned the expected magic value
3368      */
3369     function _checkOnERC721Received(
3370         address from,
3371         address to,
3372         uint256 tokenId,
3373         bytes memory data
3374     ) private returns (bool) {
3375         if (to.isContract()) {
3376             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3377                 return retval == IERC721Receiver.onERC721Received.selector;
3378             } catch (bytes memory reason) {
3379                 if (reason.length == 0) {
3380                     revert("ERC721: transfer to non ERC721Receiver implementer");
3381                 } else {
3382                     /// @solidity memory-safe-assembly
3383                     assembly {
3384                         revert(add(32, reason), mload(reason))
3385                     }
3386                 }
3387             }
3388         } else {
3389             return true;
3390         }
3391     }
3392 
3393     /**
3394      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3395      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3396      *
3397      * Calling conditions:
3398      *
3399      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3400      * - When `from` is zero, the tokens will be minted for `to`.
3401      * - When `to` is zero, ``from``'s tokens will be burned.
3402      * - `from` and `to` are never both zero.
3403      * - `batchSize` is non-zero.
3404      *
3405      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3406      */
3407     function _beforeTokenTransfer(
3408         address from,
3409         address to,
3410         uint256 firstTokenId,
3411         uint256 batchSize
3412     ) internal virtual {}
3413 
3414     /**
3415      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3416      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3417      *
3418      * Calling conditions:
3419      *
3420      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3421      * - When `from` is zero, the tokens were minted for `to`.
3422      * - When `to` is zero, ``from``'s tokens were burned.
3423      * - `from` and `to` are never both zero.
3424      * - `batchSize` is non-zero.
3425      *
3426      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3427      */
3428     function _afterTokenTransfer(
3429         address from,
3430         address to,
3431         uint256 firstTokenId,
3432         uint256 batchSize
3433     ) internal virtual {}
3434 
3435     /**
3436      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
3437      *
3438      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
3439      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
3440      * that `ownerOf(tokenId)` is `a`.
3441      */
3442     // solhint-disable-next-line func-name-mixedcase
3443     function __unsafe_increaseBalance(address account, uint256 amount) internal {
3444         _balances[account] += amount;
3445     }
3446 }
3447 
3448 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
3449 
3450 
3451 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
3452 
3453 pragma solidity ^0.8.0;
3454 
3455 
3456 
3457 /**
3458  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3459  * enumerability of all the token ids in the contract as well as all token ids owned by each
3460  * account.
3461  */
3462 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3463     // Mapping from owner to list of owned token IDs
3464     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3465 
3466     // Mapping from token ID to index of the owner tokens list
3467     mapping(uint256 => uint256) private _ownedTokensIndex;
3468 
3469     // Array with all token ids, used for enumeration
3470     uint256[] private _allTokens;
3471 
3472     // Mapping from token id to position in the allTokens array
3473     mapping(uint256 => uint256) private _allTokensIndex;
3474 
3475     /**
3476      * @dev See {IERC165-supportsInterface}.
3477      */
3478     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3479         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3480     }
3481 
3482     /**
3483      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3484      */
3485     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3486         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3487         return _ownedTokens[owner][index];
3488     }
3489 
3490     /**
3491      * @dev See {IERC721Enumerable-totalSupply}.
3492      */
3493     function totalSupply() public view virtual override returns (uint256) {
3494         return _allTokens.length;
3495     }
3496 
3497     /**
3498      * @dev See {IERC721Enumerable-tokenByIndex}.
3499      */
3500     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3501         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3502         return _allTokens[index];
3503     }
3504 
3505     /**
3506      * @dev See {ERC721-_beforeTokenTransfer}.
3507      */
3508     function _beforeTokenTransfer(
3509         address from,
3510         address to,
3511         uint256 firstTokenId,
3512         uint256 batchSize
3513     ) internal virtual override {
3514         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
3515 
3516         if (batchSize > 1) {
3517             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
3518             revert("ERC721Enumerable: consecutive transfers not supported");
3519         }
3520 
3521         uint256 tokenId = firstTokenId;
3522 
3523         if (from == address(0)) {
3524             _addTokenToAllTokensEnumeration(tokenId);
3525         } else if (from != to) {
3526             _removeTokenFromOwnerEnumeration(from, tokenId);
3527         }
3528         if (to == address(0)) {
3529             _removeTokenFromAllTokensEnumeration(tokenId);
3530         } else if (to != from) {
3531             _addTokenToOwnerEnumeration(to, tokenId);
3532         }
3533     }
3534 
3535     /**
3536      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3537      * @param to address representing the new owner of the given token ID
3538      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3539      */
3540     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3541         uint256 length = ERC721.balanceOf(to);
3542         _ownedTokens[to][length] = tokenId;
3543         _ownedTokensIndex[tokenId] = length;
3544     }
3545 
3546     /**
3547      * @dev Private function to add a token to this extension's token tracking data structures.
3548      * @param tokenId uint256 ID of the token to be added to the tokens list
3549      */
3550     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3551         _allTokensIndex[tokenId] = _allTokens.length;
3552         _allTokens.push(tokenId);
3553     }
3554 
3555     /**
3556      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3557      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3558      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3559      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3560      * @param from address representing the previous owner of the given token ID
3561      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3562      */
3563     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3564         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3565         // then delete the last slot (swap and pop).
3566 
3567         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3568         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3569 
3570         // When the token to delete is the last token, the swap operation is unnecessary
3571         if (tokenIndex != lastTokenIndex) {
3572             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3573 
3574             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3575             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3576         }
3577 
3578         // This also deletes the contents at the last position of the array
3579         delete _ownedTokensIndex[tokenId];
3580         delete _ownedTokens[from][lastTokenIndex];
3581     }
3582 
3583     /**
3584      * @dev Private function to remove a token from this extension's token tracking data structures.
3585      * This has O(1) time complexity, but alters the order of the _allTokens array.
3586      * @param tokenId uint256 ID of the token to be removed from the tokens list
3587      */
3588     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3589         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3590         // then delete the last slot (swap and pop).
3591 
3592         uint256 lastTokenIndex = _allTokens.length - 1;
3593         uint256 tokenIndex = _allTokensIndex[tokenId];
3594 
3595         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3596         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3597         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3598         uint256 lastTokenId = _allTokens[lastTokenIndex];
3599 
3600         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3601         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3602 
3603         // This also deletes the contents at the last position of the array
3604         delete _allTokensIndex[tokenId];
3605         _allTokens.pop();
3606     }
3607 }
3608 
3609 // File: contracts/Mulady.sol
3610 
3611 
3612 pragma solidity ^0.8.17;
3613 
3614 
3615 
3616 
3617 
3618 
3619 
3620 /**
3621  * @title MUHLADY contract
3622  * @dev Implementation of the MUHLADY ERC721A smart contract.
3623  */
3624 contract MUHLADY is ERC721A, Ownable {
3625     using Strings for uint256;
3626     using SafeMath for uint256;
3627     address public constant MILADY_MAKER =
3628         0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
3629     address public constant REMILIO =
3630         0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
3631     address public constant RADBRO = 0xE83C9F09B0992e4a34fAf125ed4FEdD3407c4a23;
3632     address public constant SCHIZO = 0xBfE47D6D4090940D1c7a0066B63d23875E3e2Ac5;
3633 
3634     uint256 public constant MAX_SUPPLY = 6666;
3635     uint256 public constant RESERVED_SUPPLY = 1000;
3636     uint256 private _reservedClaimed;
3637     uint256 public mintPrice = 10000000000000000; // 0.02 ETH
3638 
3639     address payable public ARTIST1 =
3640         payable(0x04023220C3FEF7Aa1a8859Fa26F049aA5Cf0AFa4); // Replace with wallet address
3641     address payable public ARTIST2 =
3642         payable(0x81a2716e594d8eE6F5dDBDDA344Ed45d38894f3c); // Replace with wallet address
3643     address payable public DEV =
3644         payable(0xc5De42B455e44B17bac949BeAAB967DD08dd96a1); // Replace with wallet address
3645 
3646     bytes32 public merkleRoot;
3647     bool public mintStatus;
3648 
3649     mapping(address => bool) public claimed;
3650     mapping(address => mapping(uint256 => bool)) public usedTokenId;
3651 
3652     string public baseUri;
3653 
3654     /**
3655      * @dev Constructor function for MULADY contract
3656      * @param _merkleRoot The Merkle root for the airdrop
3657      */
3658     constructor(bytes32 _merkleRoot) ERC721A("MUHLADY", "MUH") {
3659         merkleRoot = _merkleRoot;
3660         _mint(msg.sender, 50);
3661     }
3662 
3663     /**
3664      * @dev Modifier to check if minting is active
3665      */
3666     modifier mintActive() {
3667         require(mintStatus, "Mint coming soon");
3668         _;
3669     }
3670 
3671     /**
3672      * @dev Function to claim a whitelisted MULADY token
3673      * @param merkleProof The Merkle proof for the airdrop
3674      */
3675     function basedNiggaMint(bytes32[] calldata merkleProof) public mintActive {
3676         require(_totalMinted() + 1 <= MAX_SUPPLY, "Minting exceeds max supply");
3677         require(
3678             _reservedClaimed <= RESERVED_SUPPLY,
3679             "All reserved tokens claimed"
3680         );
3681         // Verify the merkle proof
3682         bytes32 node = toBytes32(msg.sender);
3683         require(
3684             MerkleProof.verify(merkleProof, merkleRoot, node) ||
3685                 (ERC721(MILADY_MAKER).balanceOf(msg.sender) >= 1) ||
3686                 (ERC721(REMILIO).balanceOf(msg.sender) >= 1) ||
3687                 (ERC721(RADBRO).balanceOf(msg.sender) >= 1) ||
3688                 (ERC721(SCHIZO).balanceOf(msg.sender) >= 1),
3689             "Invalid WL Spot"
3690         );
3691         // Make sure the user hasn't claimed their reserved token already
3692         require(!claimed[msg.sender], "Already claimed");
3693         claimed[msg.sender] = true;
3694 
3695         _reservedClaimed++;
3696         _mint(msg.sender, 1);
3697     }
3698 
3699     /**
3700      * @dev Function to mint MULADY tokens
3701      * @param quantity The number of tokens to mint
3702      */
3703     function mint(uint256 quantity) public payable mintActive {
3704         require(
3705             _totalMinted() + quantity <= MAX_SUPPLY,
3706             "Minting exceeds max supply"
3707         );
3708         require(mintPrice * quantity <= msg.value, "Not enough ETH sent");
3709 
3710         uint256 totalAmount = msg.value;
3711 
3712         // Distribute ETH to wallets
3713         uint256 artist1Amount = (totalAmount / 100) * 40;
3714         uint256 artist2Amount = (totalAmount / 100) * 40;
3715         uint256 devAmount = (totalAmount / 100) * 10;
3716 
3717         ARTIST1.transfer(artist1Amount);
3718         ARTIST2.transfer(artist2Amount);
3719         DEV.transfer(devAmount);
3720         _mint(msg.sender, quantity);
3721     }
3722 
3723     /**
3724      * @dev Function to withdraw contract balance
3725      */
3726     function withdraw() public onlyOwner {
3727         uint256 balance = address(this).balance;
3728         payable(msg.sender).transfer(balance);
3729     }
3730 
3731     /**
3732      * @dev Function to set the minting status of the contract
3733      * @param _newStatus The new minting status
3734      */
3735     function setMintStatus(bool _newStatus) public onlyOwner {
3736         mintStatus = _newStatus;
3737     }
3738 
3739     /**
3740      * @dev Sets the mint price for tokens.
3741      * @param _newMintPrice The new mint price in wei.
3742      */
3743     function setMintPrice(uint256 _newMintPrice) public onlyOwner {
3744         mintPrice = _newMintPrice;
3745     }
3746 
3747     /**
3748      * @dev Function to set the Merkle root for the airdrop
3749      * @param _merkleRoot The new Merkle root
3750      */
3751     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
3752         merkleRoot = _merkleRoot;
3753     }
3754 
3755     function setBaseUri(string memory _uri) public onlyOwner {
3756         baseUri = _uri;
3757     }
3758 
3759     /**
3760      * @dev Internal function to convert an address to bytes32
3761      * @param addr The address to convert
3762      */
3763     function toBytes32(address addr) internal pure returns (bytes32) {
3764         return bytes32(uint256(uint160(addr)));
3765     }
3766 
3767     /**
3768      * @dev Internal function to get the starting token ID for the contract
3769      */
3770     function _startTokenId() internal view override returns (uint256) {
3771         return 1;
3772     }
3773 
3774     /**
3775      * @dev Returns the base URI for the token metadata.
3776      * @return The base URI for the token metadata.
3777      */
3778     function _baseURI() internal view override returns (string memory) {
3779         return baseUri;
3780     }
3781 
3782     /**
3783      * @dev Returns the URI for a specific token.
3784      * @param tokenId The ID of the token to get the URI for.
3785      * @return The URI of the token with the given ID.
3786      */
3787     function tokenURI(uint256 tokenId)
3788         public
3789         view
3790         virtual
3791         override
3792         returns (string memory)
3793     {
3794         require(
3795             _exists(tokenId),
3796             "ERC721Metadata: URI query for nonexistent token"
3797         );
3798 
3799         string memory base = _baseURI();
3800         return
3801             bytes(base).length > 0
3802                 ? string(abi.encodePacked(base, tokenId.toString(), ".json"))
3803                 : "";
3804     }
3805 }