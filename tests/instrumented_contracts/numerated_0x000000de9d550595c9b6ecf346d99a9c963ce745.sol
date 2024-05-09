1 /*
2   ______                 _____            _ _        _ 
3  |  ____|               / ____|          (_) |      | |
4  | |____   _______  __ | |     __ _ _ __  _| |_ __ _| |
5  |  __\ \ / / _ \ \/ / | |    / _` | '_ \| | __/ _` | |
6  | |___\ V / (_) >  <  | |___| (_| | |_) | | || (_| | |
7  |______\_/ \___/_/\_\  \_____\__,_| .__/|_|\__\__,_|_|
8                                    | |                 
9                                    |_|                 
10 
11 twitter: https://twitter.com/evoxcapital
12 twitter: https://twitter.com/evox_dev
13 website: https://www.evox.capital/
14 discord: https://discord.com/invite/evoxcapital
15 instagram: https://www.instagram.com/evoxcapital_tr/
16 youtube: https://www.youtube.com/channel/UCPQUhz6-0DTzZPQwlvy7umw/featured
17  */
18 
19 
20 // File: @openzeppelin/contracts/utils/Strings.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32     uint8 private constant _ADDRESS_LENGTH = 20;
33 
34     /**
35      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
36      */
37     function toString(uint256 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
61      */
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
77      */
78     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
79         bytes memory buffer = new bytes(2 * length + 2);
80         buffer[0] = "0";
81         buffer[1] = "x";
82         for (uint256 i = 2 * length + 1; i > 1; --i) {
83             buffer[i] = _HEX_SYMBOLS[value & 0xf];
84             value >>= 4;
85         }
86         require(value == 0, "Strings: hex length insufficient");
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
92      */
93     function toHexString(address addr) internal pure returns (string memory) {
94         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Context.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 // File: @openzeppelin/contracts/access/Ownable.sol
126 
127 
128 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 
133 /**
134  * @dev Contract module which provides a basic access control mechanism, where
135  * there is an account (an owner) that can be granted exclusive access to
136  * specific functions.
137  *
138  * By default, the owner account will be the one that deploys the contract. This
139  * can later be changed with {transferOwnership}.
140  *
141  * This module is used through inheritance. It will make available the modifier
142  * `onlyOwner`, which can be applied to your functions to restrict their use to
143  * the owner.
144  */
145 abstract contract Ownable is Context {
146     address private _owner;
147 
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     /**
151      * @dev Initializes the contract setting the deployer as the initial owner.
152      */
153     constructor() {
154         _transferOwnership(_msgSender());
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         _checkOwner();
162         _;
163     }
164 
165     /**
166      * @dev Returns the address of the current owner.
167      */
168     function owner() public view virtual returns (address) {
169         return _owner;
170     }
171 
172     /**
173      * @dev Throws if the sender is not the owner.
174      */
175     function _checkOwner() internal view virtual {
176         require(owner() == _msgSender(), "Ownable: caller is not the owner");
177     }
178 
179     /**
180      * @dev Leaves the contract without owner. It will not be possible to call
181      * `onlyOwner` functions anymore. Can only be called by the current owner.
182      *
183      * NOTE: Renouncing ownership will leave the contract without an owner,
184      * thereby removing any functionality that is only available to the owner.
185      */
186     function renounceOwnership() public virtual onlyOwner {
187         _transferOwnership(address(0));
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Can only be called by the current owner.
193      */
194     function transferOwnership(address newOwner) public virtual onlyOwner {
195         require(newOwner != address(0), "Ownable: new owner is the zero address");
196         _transferOwnership(newOwner);
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Internal function without access restriction.
202      */
203     function _transferOwnership(address newOwner) internal virtual {
204         address oldOwner = _owner;
205         _owner = newOwner;
206         emit OwnershipTransferred(oldOwner, newOwner);
207     }
208 }
209 
210 // File: erc721a/contracts/IERC721A.sol
211 
212 
213 // ERC721A Contracts v4.2.3
214 // Creator: Chiru Labs
215 
216 pragma solidity ^0.8.4;
217 
218 /**
219  * @dev Interface of ERC721A.
220  */
221 interface IERC721A {
222     /**
223      * The caller must own the token or be an approved operator.
224      */
225     error ApprovalCallerNotOwnerNorApproved();
226 
227     /**
228      * The token does not exist.
229      */
230     error ApprovalQueryForNonexistentToken();
231 
232     /**
233      * Cannot query the balance for the zero address.
234      */
235     error BalanceQueryForZeroAddress();
236 
237     /**
238      * Cannot mint to the zero address.
239      */
240     error MintToZeroAddress();
241 
242     /**
243      * The quantity of tokens minted must be more than zero.
244      */
245     error MintZeroQuantity();
246 
247     /**
248      * The token does not exist.
249      */
250     error OwnerQueryForNonexistentToken();
251 
252     /**
253      * The caller must own the token or be an approved operator.
254      */
255     error TransferCallerNotOwnerNorApproved();
256 
257     /**
258      * The token must be owned by `from`.
259      */
260     error TransferFromIncorrectOwner();
261 
262     /**
263      * Cannot safely transfer to a contract that does not implement the
264      * ERC721Receiver interface.
265      */
266     error TransferToNonERC721ReceiverImplementer();
267 
268     /**
269      * Cannot transfer to the zero address.
270      */
271     error TransferToZeroAddress();
272 
273     /**
274      * The token does not exist.
275      */
276     error URIQueryForNonexistentToken();
277 
278     /**
279      * The `quantity` minted with ERC2309 exceeds the safety limit.
280      */
281     error MintERC2309QuantityExceedsLimit();
282 
283     /**
284      * The `extraData` cannot be set on an unintialized ownership slot.
285      */
286     error OwnershipNotInitializedForExtraData();
287 
288     // =============================================================
289     //                            STRUCTS
290     // =============================================================
291 
292     struct TokenOwnership {
293         // The address of the owner.
294         address addr;
295         // Stores the start time of ownership with minimal overhead for tokenomics.
296         uint64 startTimestamp;
297         // Whether the token has been burned.
298         bool burned;
299         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
300         uint24 extraData;
301     }
302 
303     // =============================================================
304     //                         TOKEN COUNTERS
305     // =============================================================
306 
307     /**
308      * @dev Returns the total number of tokens in existence.
309      * Burned tokens will reduce the count.
310      * To get the total number of tokens minted, please see {_totalMinted}.
311      */
312     function totalSupply() external view returns (uint256);
313 
314     // =============================================================
315     //                            IERC165
316     // =============================================================
317 
318     /**
319      * @dev Returns true if this contract implements the interface defined by
320      * `interfaceId`. See the corresponding
321      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
322      * to learn more about how these ids are created.
323      *
324      * This function call must use less than 30000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId) external view returns (bool);
327 
328     // =============================================================
329     //                            IERC721
330     // =============================================================
331 
332     /**
333      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
339      */
340     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when `owner` enables or disables
344      * (`approved`) `operator` to manage all of its assets.
345      */
346     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
347 
348     /**
349      * @dev Returns the number of tokens in `owner`'s account.
350      */
351     function balanceOf(address owner) external view returns (uint256 balance);
352 
353     /**
354      * @dev Returns the owner of the `tokenId` token.
355      *
356      * Requirements:
357      *
358      * - `tokenId` must exist.
359      */
360     function ownerOf(uint256 tokenId) external view returns (address owner);
361 
362     /**
363      * @dev Safely transfers `tokenId` token from `from` to `to`,
364      * checking first that contract recipients are aware of the ERC721 protocol
365      * to prevent tokens from being forever locked.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `tokenId` token must exist and be owned by `from`.
372      * - If the caller is not `from`, it must be have been allowed to move
373      * this token by either {approve} or {setApprovalForAll}.
374      * - If `to` refers to a smart contract, it must implement
375      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
376      *
377      * Emits a {Transfer} event.
378      */
379     function safeTransferFrom(
380         address from,
381         address to,
382         uint256 tokenId,
383         bytes calldata data
384     ) external payable;
385 
386     /**
387      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external payable;
394 
395     /**
396      * @dev Transfers `tokenId` from `from` to `to`.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
399      * whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token
407      * by either {approve} or {setApprovalForAll}.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) external payable;
416 
417     /**
418      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
419      * The approval is cleared when the token is transferred.
420      *
421      * Only a single account can be approved at a time, so approving the
422      * zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external payable;
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom}
436      * for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The `operator` cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns the account approved for `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function getApproved(uint256 tokenId) external view returns (address operator);
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}.
459      */
460     function isApprovedForAll(address owner, address operator) external view returns (bool);
461 
462     // =============================================================
463     //                        IERC721Metadata
464     // =============================================================
465 
466     /**
467      * @dev Returns the token collection name.
468      */
469     function name() external view returns (string memory);
470 
471     /**
472      * @dev Returns the token collection symbol.
473      */
474     function symbol() external view returns (string memory);
475 
476     /**
477      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
478      */
479     function tokenURI(uint256 tokenId) external view returns (string memory);
480 
481     // =============================================================
482     //                           IERC2309
483     // =============================================================
484 
485     /**
486      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
487      * (inclusive) is transferred from `from` to `to`, as defined in the
488      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
489      *
490      * See {_mintERC2309} for more details.
491      */
492     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
493 }
494 
495 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
496 
497 
498 // ERC721A Contracts v4.2.3
499 // Creator: Chiru Labs
500 
501 pragma solidity ^0.8.4;
502 
503 
504 /**
505  * @dev Interface of ERC721AQueryable.
506  */
507 interface IERC721AQueryable is IERC721A {
508     /**
509      * Invalid query range (`start` >= `stop`).
510      */
511     error InvalidQueryRange();
512 
513     /**
514      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
515      *
516      * If the `tokenId` is out of bounds:
517      *
518      * - `addr = address(0)`
519      * - `startTimestamp = 0`
520      * - `burned = false`
521      * - `extraData = 0`
522      *
523      * If the `tokenId` is burned:
524      *
525      * - `addr = <Address of owner before token was burned>`
526      * - `startTimestamp = <Timestamp when token was burned>`
527      * - `burned = true`
528      * - `extraData = <Extra data when token was burned>`
529      *
530      * Otherwise:
531      *
532      * - `addr = <Address of owner>`
533      * - `startTimestamp = <Timestamp of start of ownership>`
534      * - `burned = false`
535      * - `extraData = <Extra data at start of ownership>`
536      */
537     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
538 
539     /**
540      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
541      * See {ERC721AQueryable-explicitOwnershipOf}
542      */
543     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
544 
545     /**
546      * @dev Returns an array of token IDs owned by `owner`,
547      * in the range [`start`, `stop`)
548      * (i.e. `start <= tokenId < stop`).
549      *
550      * This function allows for tokens to be queried if the collection
551      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
552      *
553      * Requirements:
554      *
555      * - `start < stop`
556      */
557     function tokensOfOwnerIn(
558         address owner,
559         uint256 start,
560         uint256 stop
561     ) external view returns (uint256[] memory);
562 
563     /**
564      * @dev Returns an array of token IDs owned by `owner`.
565      *
566      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
567      * It is meant to be called off-chain.
568      *
569      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
570      * multiple smaller scans if the collection is large enough to cause
571      * an out-of-gas error (10K collections should be fine).
572      */
573     function tokensOfOwner(address owner) external view returns (uint256[] memory);
574 }
575 
576 // File: erc721a/contracts/ERC721A.sol
577 
578 
579 // ERC721A Contracts v4.2.3
580 // Creator: Chiru Labs
581 
582 pragma solidity ^0.8.4;
583 
584 
585 /**
586  * @dev Interface of ERC721 token receiver.
587  */
588 interface ERC721A__IERC721Receiver {
589     function onERC721Received(
590         address operator,
591         address from,
592         uint256 tokenId,
593         bytes calldata data
594     ) external returns (bytes4);
595 }
596 
597 /**
598  * @title ERC721A
599  *
600  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
601  * Non-Fungible Token Standard, including the Metadata extension.
602  * Optimized for lower gas during batch mints.
603  *
604  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
605  * starting from `_startTokenId()`.
606  *
607  * Assumptions:
608  *
609  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
610  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
611  */
612 contract ERC721A is IERC721A {
613     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
614     struct TokenApprovalRef {
615         address value;
616     }
617 
618     // =============================================================
619     //                           CONSTANTS
620     // =============================================================
621 
622     // Mask of an entry in packed address data.
623     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
624 
625     // The bit position of `numberMinted` in packed address data.
626     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
627 
628     // The bit position of `numberBurned` in packed address data.
629     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
630 
631     // The bit position of `aux` in packed address data.
632     uint256 private constant _BITPOS_AUX = 192;
633 
634     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
635     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
636 
637     // The bit position of `startTimestamp` in packed ownership.
638     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
639 
640     // The bit mask of the `burned` bit in packed ownership.
641     uint256 private constant _BITMASK_BURNED = 1 << 224;
642 
643     // The bit position of the `nextInitialized` bit in packed ownership.
644     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
645 
646     // The bit mask of the `nextInitialized` bit in packed ownership.
647     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
648 
649     // The bit position of `extraData` in packed ownership.
650     uint256 private constant _BITPOS_EXTRA_DATA = 232;
651 
652     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
653     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
654 
655     // The mask of the lower 160 bits for addresses.
656     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
657 
658     // The maximum `quantity` that can be minted with {_mintERC2309}.
659     // This limit is to prevent overflows on the address data entries.
660     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
661     // is required to cause an overflow, which is unrealistic.
662     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
663 
664     // The `Transfer` event signature is given by:
665     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
666     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
667         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
668 
669     // =============================================================
670     //                            STORAGE
671     // =============================================================
672 
673     // The next token ID to be minted.
674     uint256 private _currentIndex;
675 
676     // The number of tokens burned.
677     uint256 private _burnCounter;
678 
679     // Token name
680     string private _name;
681 
682     // Token symbol
683     string private _symbol;
684 
685     // Mapping from token ID to ownership details
686     // An empty struct value does not necessarily mean the token is unowned.
687     // See {_packedOwnershipOf} implementation for details.
688     //
689     // Bits Layout:
690     // - [0..159]   `addr`
691     // - [160..223] `startTimestamp`
692     // - [224]      `burned`
693     // - [225]      `nextInitialized`
694     // - [232..255] `extraData`
695     mapping(uint256 => uint256) private _packedOwnerships;
696 
697     // Mapping owner address to address data.
698     //
699     // Bits Layout:
700     // - [0..63]    `balance`
701     // - [64..127]  `numberMinted`
702     // - [128..191] `numberBurned`
703     // - [192..255] `aux`
704     mapping(address => uint256) private _packedAddressData;
705 
706     // Mapping from token ID to approved address.
707     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
708 
709     // Mapping from owner to operator approvals
710     mapping(address => mapping(address => bool)) private _operatorApprovals;
711 
712     // =============================================================
713     //                          CONSTRUCTOR
714     // =============================================================
715 
716     constructor(string memory name_, string memory symbol_) {
717         _name = name_;
718         _symbol = symbol_;
719         _currentIndex = _startTokenId();
720     }
721 
722     // =============================================================
723     //                   TOKEN COUNTING OPERATIONS
724     // =============================================================
725 
726     /**
727      * @dev Returns the starting token ID.
728      * To change the starting token ID, please override this function.
729      */
730     function _startTokenId() internal view virtual returns (uint256) {
731         return 0;
732     }
733 
734     /**
735      * @dev Returns the next token ID to be minted.
736      */
737     function _nextTokenId() internal view virtual returns (uint256) {
738         return _currentIndex;
739     }
740 
741     /**
742      * @dev Returns the total number of tokens in existence.
743      * Burned tokens will reduce the count.
744      * To get the total number of tokens minted, please see {_totalMinted}.
745      */
746     function totalSupply() public view virtual override returns (uint256) {
747         // Counter underflow is impossible as _burnCounter cannot be incremented
748         // more than `_currentIndex - _startTokenId()` times.
749         unchecked {
750             return _currentIndex - _burnCounter - _startTokenId();
751         }
752     }
753 
754     /**
755      * @dev Returns the total amount of tokens minted in the contract.
756      */
757     function _totalMinted() internal view virtual returns (uint256) {
758         // Counter underflow is impossible as `_currentIndex` does not decrement,
759         // and it is initialized to `_startTokenId()`.
760         unchecked {
761             return _currentIndex - _startTokenId();
762         }
763     }
764 
765     /**
766      * @dev Returns the total number of tokens burned.
767      */
768     function _totalBurned() internal view virtual returns (uint256) {
769         return _burnCounter;
770     }
771 
772     // =============================================================
773     //                    ADDRESS DATA OPERATIONS
774     // =============================================================
775 
776     /**
777      * @dev Returns the number of tokens in `owner`'s account.
778      */
779     function balanceOf(address owner) public view virtual override returns (uint256) {
780         if (owner == address(0)) revert BalanceQueryForZeroAddress();
781         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
782     }
783 
784     /**
785      * Returns the number of tokens minted by `owner`.
786      */
787     function _numberMinted(address owner) internal view returns (uint256) {
788         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
789     }
790 
791     /**
792      * Returns the number of tokens burned by or on behalf of `owner`.
793      */
794     function _numberBurned(address owner) internal view returns (uint256) {
795         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
796     }
797 
798     /**
799      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
800      */
801     function _getAux(address owner) internal view returns (uint64) {
802         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
803     }
804 
805     /**
806      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
807      * If there are multiple variables, please pack them into a uint64.
808      */
809     function _setAux(address owner, uint64 aux) internal virtual {
810         uint256 packed = _packedAddressData[owner];
811         uint256 auxCasted;
812         // Cast `aux` with assembly to avoid redundant masking.
813         assembly {
814             auxCasted := aux
815         }
816         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
817         _packedAddressData[owner] = packed;
818     }
819 
820     // =============================================================
821     //                            IERC165
822     // =============================================================
823 
824     /**
825      * @dev Returns true if this contract implements the interface defined by
826      * `interfaceId`. See the corresponding
827      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
828      * to learn more about how these ids are created.
829      *
830      * This function call must use less than 30000 gas.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
833         // The interface IDs are constants representing the first 4 bytes
834         // of the XOR of all function selectors in the interface.
835         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
836         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
837         return
838             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
839             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
840             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
841     }
842 
843     // =============================================================
844     //                        IERC721Metadata
845     // =============================================================
846 
847     /**
848      * @dev Returns the token collection name.
849      */
850     function name() public view virtual override returns (string memory) {
851         return _name;
852     }
853 
854     /**
855      * @dev Returns the token collection symbol.
856      */
857     function symbol() public view virtual override returns (string memory) {
858         return _symbol;
859     }
860 
861     /**
862      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
863      */
864     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
865         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
866 
867         string memory baseURI = _baseURI();
868         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
869     }
870 
871     /**
872      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
873      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
874      * by default, it can be overridden in child contracts.
875      */
876     function _baseURI() internal view virtual returns (string memory) {
877         return '';
878     }
879 
880     // =============================================================
881     //                     OWNERSHIPS OPERATIONS
882     // =============================================================
883 
884     /**
885      * @dev Returns the owner of the `tokenId` token.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
892         return address(uint160(_packedOwnershipOf(tokenId)));
893     }
894 
895     /**
896      * @dev Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around over time.
898      */
899     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
900         return _unpackedOwnership(_packedOwnershipOf(tokenId));
901     }
902 
903     /**
904      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
905      */
906     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
907         return _unpackedOwnership(_packedOwnerships[index]);
908     }
909 
910     /**
911      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
912      */
913     function _initializeOwnershipAt(uint256 index) internal virtual {
914         if (_packedOwnerships[index] == 0) {
915             _packedOwnerships[index] = _packedOwnershipOf(index);
916         }
917     }
918 
919     /**
920      * Returns the packed ownership data of `tokenId`.
921      */
922     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr)
927                 if (curr < _currentIndex) {
928                     uint256 packed = _packedOwnerships[curr];
929                     // If not burned.
930                     if (packed & _BITMASK_BURNED == 0) {
931                         // Invariant:
932                         // There will always be an initialized ownership slot
933                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
934                         // before an unintialized ownership slot
935                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
936                         // Hence, `curr` will not underflow.
937                         //
938                         // We can directly compare the packed value.
939                         // If the address is zero, packed will be zero.
940                         while (packed == 0) {
941                             packed = _packedOwnerships[--curr];
942                         }
943                         return packed;
944                     }
945                 }
946         }
947         revert OwnerQueryForNonexistentToken();
948     }
949 
950     /**
951      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
952      */
953     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
954         ownership.addr = address(uint160(packed));
955         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
956         ownership.burned = packed & _BITMASK_BURNED != 0;
957         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
958     }
959 
960     /**
961      * @dev Packs ownership data into a single uint256.
962      */
963     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
964         assembly {
965             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
966             owner := and(owner, _BITMASK_ADDRESS)
967             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
968             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
969         }
970     }
971 
972     /**
973      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
974      */
975     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
976         // For branchless setting of the `nextInitialized` flag.
977         assembly {
978             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
979             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
980         }
981     }
982 
983     // =============================================================
984     //                      APPROVAL OPERATIONS
985     // =============================================================
986 
987     /**
988      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
989      * The approval is cleared when the token is transferred.
990      *
991      * Only a single account can be approved at a time, so approving the
992      * zero address clears previous approvals.
993      *
994      * Requirements:
995      *
996      * - The caller must own the token or be an approved operator.
997      * - `tokenId` must exist.
998      *
999      * Emits an {Approval} event.
1000      */
1001     function approve(address to, uint256 tokenId) public payable virtual override {
1002         address owner = ownerOf(tokenId);
1003 
1004         if (_msgSenderERC721A() != owner)
1005             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1006                 revert ApprovalCallerNotOwnerNorApproved();
1007             }
1008 
1009         _tokenApprovals[tokenId].value = to;
1010         emit Approval(owner, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Returns the account approved for `tokenId` token.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      */
1020     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1021         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1022 
1023         return _tokenApprovals[tokenId].value;
1024     }
1025 
1026     /**
1027      * @dev Approve or remove `operator` as an operator for the caller.
1028      * Operators can call {transferFrom} or {safeTransferFrom}
1029      * for any token owned by the caller.
1030      *
1031      * Requirements:
1032      *
1033      * - The `operator` cannot be the caller.
1034      *
1035      * Emits an {ApprovalForAll} event.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public virtual override {
1038         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1039         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1040     }
1041 
1042     /**
1043      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1044      *
1045      * See {setApprovalForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted. See {_mint}.
1057      */
1058     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1059         return
1060             _startTokenId() <= tokenId &&
1061             tokenId < _currentIndex && // If within bounds,
1062             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1063     }
1064 
1065     /**
1066      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1067      */
1068     function _isSenderApprovedOrOwner(
1069         address approvedAddress,
1070         address owner,
1071         address msgSender
1072     ) private pure returns (bool result) {
1073         assembly {
1074             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1075             owner := and(owner, _BITMASK_ADDRESS)
1076             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1077             msgSender := and(msgSender, _BITMASK_ADDRESS)
1078             // `msgSender == owner || msgSender == approvedAddress`.
1079             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1085      */
1086     function _getApprovedSlotAndAddress(uint256 tokenId)
1087         private
1088         view
1089         returns (uint256 approvedAddressSlot, address approvedAddress)
1090     {
1091         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1092         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1093         assembly {
1094             approvedAddressSlot := tokenApproval.slot
1095             approvedAddress := sload(approvedAddressSlot)
1096         }
1097     }
1098 
1099     // =============================================================
1100     //                      TRANSFER OPERATIONS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Transfers `tokenId` from `from` to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must be owned by `from`.
1111      * - If the caller is not `from`, it must be approved to move this token
1112      * by either {approve} or {setApprovalForAll}.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function transferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) public payable virtual override {
1121         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1122 
1123         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1124 
1125         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1126 
1127         // The nested ifs save around 20+ gas over a compound boolean condition.
1128         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1129             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1130 
1131         if (to == address(0)) revert TransferToZeroAddress();
1132 
1133         _beforeTokenTransfers(from, to, tokenId, 1);
1134 
1135         // Clear approvals from the previous owner.
1136         assembly {
1137             if approvedAddress {
1138                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1139                 sstore(approvedAddressSlot, 0)
1140             }
1141         }
1142 
1143         // Underflow of the sender's balance is impossible because we check for
1144         // ownership above and the recipient's balance can't realistically overflow.
1145         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1146         unchecked {
1147             // We can directly increment and decrement the balances.
1148             --_packedAddressData[from]; // Updates: `balance -= 1`.
1149             ++_packedAddressData[to]; // Updates: `balance += 1`.
1150 
1151             // Updates:
1152             // - `address` to the next owner.
1153             // - `startTimestamp` to the timestamp of transfering.
1154             // - `burned` to `false`.
1155             // - `nextInitialized` to `true`.
1156             _packedOwnerships[tokenId] = _packOwnershipData(
1157                 to,
1158                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1159             );
1160 
1161             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1162             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1163                 uint256 nextTokenId = tokenId + 1;
1164                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1165                 if (_packedOwnerships[nextTokenId] == 0) {
1166                     // If the next slot is within bounds.
1167                     if (nextTokenId != _currentIndex) {
1168                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1169                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1170                     }
1171                 }
1172             }
1173         }
1174 
1175         emit Transfer(from, to, tokenId);
1176         _afterTokenTransfers(from, to, tokenId, 1);
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1181      */
1182     function safeTransferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public payable virtual override {
1187         safeTransferFrom(from, to, tokenId, '');
1188     }
1189 
1190     /**
1191      * @dev Safely transfers `tokenId` token from `from` to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `from` cannot be the zero address.
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must exist and be owned by `from`.
1198      * - If the caller is not `from`, it must be approved to move this token
1199      * by either {approve} or {setApprovalForAll}.
1200      * - If `to` refers to a smart contract, it must implement
1201      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function safeTransferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) public payable virtual override {
1211         transferFrom(from, to, tokenId);
1212         if (to.code.length != 0)
1213             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1214                 revert TransferToNonERC721ReceiverImplementer();
1215             }
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before a set of serially-ordered token IDs
1220      * are about to be transferred. This includes minting.
1221      * And also called before burning one token.
1222      *
1223      * `startTokenId` - the first token ID to be transferred.
1224      * `quantity` - the amount to be transferred.
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, `tokenId` will be burned by `from`.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _beforeTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 
1241     /**
1242      * @dev Hook that is called after a set of serially-ordered token IDs
1243      * have been transferred. This includes minting.
1244      * And also called after one token has been burned.
1245      *
1246      * `startTokenId` - the first token ID to be transferred.
1247      * `quantity` - the amount to be transferred.
1248      *
1249      * Calling conditions:
1250      *
1251      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1252      * transferred to `to`.
1253      * - When `from` is zero, `tokenId` has been minted for `to`.
1254      * - When `to` is zero, `tokenId` has been burned by `from`.
1255      * - `from` and `to` are never both zero.
1256      */
1257     function _afterTokenTransfers(
1258         address from,
1259         address to,
1260         uint256 startTokenId,
1261         uint256 quantity
1262     ) internal virtual {}
1263 
1264     /**
1265      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1266      *
1267      * `from` - Previous owner of the given token ID.
1268      * `to` - Target address that will receive the token.
1269      * `tokenId` - Token ID to be transferred.
1270      * `_data` - Optional data to send along with the call.
1271      *
1272      * Returns whether the call correctly returned the expected magic value.
1273      */
1274     function _checkContractOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1281             bytes4 retval
1282         ) {
1283             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1284         } catch (bytes memory reason) {
1285             if (reason.length == 0) {
1286                 revert TransferToNonERC721ReceiverImplementer();
1287             } else {
1288                 assembly {
1289                     revert(add(32, reason), mload(reason))
1290                 }
1291             }
1292         }
1293     }
1294 
1295     // =============================================================
1296     //                        MINT OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Mints `quantity` tokens and transfers them to `to`.
1301      *
1302      * Requirements:
1303      *
1304      * - `to` cannot be the zero address.
1305      * - `quantity` must be greater than 0.
1306      *
1307      * Emits a {Transfer} event for each mint.
1308      */
1309     function _mint(address to, uint256 quantity) internal virtual {
1310         uint256 startTokenId = _currentIndex;
1311         if (quantity == 0) revert MintZeroQuantity();
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         // Overflows are incredibly unrealistic.
1316         // `balance` and `numberMinted` have a maximum limit of 2**64.
1317         // `tokenId` has a maximum limit of 2**256.
1318         unchecked {
1319             // Updates:
1320             // - `balance += quantity`.
1321             // - `numberMinted += quantity`.
1322             //
1323             // We can directly add to the `balance` and `numberMinted`.
1324             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1325 
1326             // Updates:
1327             // - `address` to the owner.
1328             // - `startTimestamp` to the timestamp of minting.
1329             // - `burned` to `false`.
1330             // - `nextInitialized` to `quantity == 1`.
1331             _packedOwnerships[startTokenId] = _packOwnershipData(
1332                 to,
1333                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1334             );
1335 
1336             uint256 toMasked;
1337             uint256 end = startTokenId + quantity;
1338 
1339             // Use assembly to loop and emit the `Transfer` event for gas savings.
1340             // The duplicated `log4` removes an extra check and reduces stack juggling.
1341             // The assembly, together with the surrounding Solidity code, have been
1342             // delicately arranged to nudge the compiler into producing optimized opcodes.
1343             assembly {
1344                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1345                 toMasked := and(to, _BITMASK_ADDRESS)
1346                 // Emit the `Transfer` event.
1347                 log4(
1348                     0, // Start of data (0, since no data).
1349                     0, // End of data (0, since no data).
1350                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1351                     0, // `address(0)`.
1352                     toMasked, // `to`.
1353                     startTokenId // `tokenId`.
1354                 )
1355 
1356                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1357                 // that overflows uint256 will make the loop run out of gas.
1358                 // The compiler will optimize the `iszero` away for performance.
1359                 for {
1360                     let tokenId := add(startTokenId, 1)
1361                 } iszero(eq(tokenId, end)) {
1362                     tokenId := add(tokenId, 1)
1363                 } {
1364                     // Emit the `Transfer` event. Similar to above.
1365                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1366                 }
1367             }
1368             if (toMasked == 0) revert MintToZeroAddress();
1369 
1370             _currentIndex = end;
1371         }
1372         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1373     }
1374 
1375     /**
1376      * @dev Mints `quantity` tokens and transfers them to `to`.
1377      *
1378      * This function is intended for efficient minting only during contract creation.
1379      *
1380      * It emits only one {ConsecutiveTransfer} as defined in
1381      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1382      * instead of a sequence of {Transfer} event(s).
1383      *
1384      * Calling this function outside of contract creation WILL make your contract
1385      * non-compliant with the ERC721 standard.
1386      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1387      * {ConsecutiveTransfer} event is only permissible during contract creation.
1388      *
1389      * Requirements:
1390      *
1391      * - `to` cannot be the zero address.
1392      * - `quantity` must be greater than 0.
1393      *
1394      * Emits a {ConsecutiveTransfer} event.
1395      */
1396     function _mintERC2309(address to, uint256 quantity) internal virtual {
1397         uint256 startTokenId = _currentIndex;
1398         if (to == address(0)) revert MintToZeroAddress();
1399         if (quantity == 0) revert MintZeroQuantity();
1400         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1401 
1402         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1403 
1404         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1405         unchecked {
1406             // Updates:
1407             // - `balance += quantity`.
1408             // - `numberMinted += quantity`.
1409             //
1410             // We can directly add to the `balance` and `numberMinted`.
1411             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1412 
1413             // Updates:
1414             // - `address` to the owner.
1415             // - `startTimestamp` to the timestamp of minting.
1416             // - `burned` to `false`.
1417             // - `nextInitialized` to `quantity == 1`.
1418             _packedOwnerships[startTokenId] = _packOwnershipData(
1419                 to,
1420                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1421             );
1422 
1423             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1424 
1425             _currentIndex = startTokenId + quantity;
1426         }
1427         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1428     }
1429 
1430     /**
1431      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1432      *
1433      * Requirements:
1434      *
1435      * - If `to` refers to a smart contract, it must implement
1436      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1437      * - `quantity` must be greater than 0.
1438      *
1439      * See {_mint}.
1440      *
1441      * Emits a {Transfer} event for each mint.
1442      */
1443     function _safeMint(
1444         address to,
1445         uint256 quantity,
1446         bytes memory _data
1447     ) internal virtual {
1448         _mint(to, quantity);
1449 
1450         unchecked {
1451             if (to.code.length != 0) {
1452                 uint256 end = _currentIndex;
1453                 uint256 index = end - quantity;
1454                 do {
1455                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1456                         revert TransferToNonERC721ReceiverImplementer();
1457                     }
1458                 } while (index < end);
1459                 // Reentrancy protection.
1460                 if (_currentIndex != end) revert();
1461             }
1462         }
1463     }
1464 
1465     /**
1466      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1467      */
1468     function _safeMint(address to, uint256 quantity) internal virtual {
1469         _safeMint(to, quantity, '');
1470     }
1471 
1472     // =============================================================
1473     //                        BURN OPERATIONS
1474     // =============================================================
1475 
1476     /**
1477      * @dev Equivalent to `_burn(tokenId, false)`.
1478      */
1479     function _burn(uint256 tokenId) internal virtual {
1480         _burn(tokenId, false);
1481     }
1482 
1483     /**
1484      * @dev Destroys `tokenId`.
1485      * The approval is cleared when the token is burned.
1486      *
1487      * Requirements:
1488      *
1489      * - `tokenId` must exist.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1494         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1495 
1496         address from = address(uint160(prevOwnershipPacked));
1497 
1498         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1499 
1500         if (approvalCheck) {
1501             // The nested ifs save around 20+ gas over a compound boolean condition.
1502             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1503                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1504         }
1505 
1506         _beforeTokenTransfers(from, address(0), tokenId, 1);
1507 
1508         // Clear approvals from the previous owner.
1509         assembly {
1510             if approvedAddress {
1511                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1512                 sstore(approvedAddressSlot, 0)
1513             }
1514         }
1515 
1516         // Underflow of the sender's balance is impossible because we check for
1517         // ownership above and the recipient's balance can't realistically overflow.
1518         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1519         unchecked {
1520             // Updates:
1521             // - `balance -= 1`.
1522             // - `numberBurned += 1`.
1523             //
1524             // We can directly decrement the balance, and increment the number burned.
1525             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1526             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1527 
1528             // Updates:
1529             // - `address` to the last owner.
1530             // - `startTimestamp` to the timestamp of burning.
1531             // - `burned` to `true`.
1532             // - `nextInitialized` to `true`.
1533             _packedOwnerships[tokenId] = _packOwnershipData(
1534                 from,
1535                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1536             );
1537 
1538             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1539             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1540                 uint256 nextTokenId = tokenId + 1;
1541                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1542                 if (_packedOwnerships[nextTokenId] == 0) {
1543                     // If the next slot is within bounds.
1544                     if (nextTokenId != _currentIndex) {
1545                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1546                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1547                     }
1548                 }
1549             }
1550         }
1551 
1552         emit Transfer(from, address(0), tokenId);
1553         _afterTokenTransfers(from, address(0), tokenId, 1);
1554 
1555         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1556         unchecked {
1557             _burnCounter++;
1558         }
1559     }
1560 
1561     // =============================================================
1562     //                     EXTRA DATA OPERATIONS
1563     // =============================================================
1564 
1565     /**
1566      * @dev Directly sets the extra data for the ownership data `index`.
1567      */
1568     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1569         uint256 packed = _packedOwnerships[index];
1570         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1571         uint256 extraDataCasted;
1572         // Cast `extraData` with assembly to avoid redundant masking.
1573         assembly {
1574             extraDataCasted := extraData
1575         }
1576         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1577         _packedOwnerships[index] = packed;
1578     }
1579 
1580     /**
1581      * @dev Called during each token transfer to set the 24bit `extraData` field.
1582      * Intended to be overridden by the cosumer contract.
1583      *
1584      * `previousExtraData` - the value of `extraData` before transfer.
1585      *
1586      * Calling conditions:
1587      *
1588      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1589      * transferred to `to`.
1590      * - When `from` is zero, `tokenId` will be minted for `to`.
1591      * - When `to` is zero, `tokenId` will be burned by `from`.
1592      * - `from` and `to` are never both zero.
1593      */
1594     function _extraData(
1595         address from,
1596         address to,
1597         uint24 previousExtraData
1598     ) internal view virtual returns (uint24) {}
1599 
1600     /**
1601      * @dev Returns the next extra data for the packed ownership data.
1602      * The returned result is shifted into position.
1603      */
1604     function _nextExtraData(
1605         address from,
1606         address to,
1607         uint256 prevOwnershipPacked
1608     ) private view returns (uint256) {
1609         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1610         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1611     }
1612 
1613     // =============================================================
1614     //                       OTHER OPERATIONS
1615     // =============================================================
1616 
1617     /**
1618      * @dev Returns the message sender (defaults to `msg.sender`).
1619      *
1620      * If you are writing GSN compatible contracts, you need to override this function.
1621      */
1622     function _msgSenderERC721A() internal view virtual returns (address) {
1623         return msg.sender;
1624     }
1625 
1626     /**
1627      * @dev Converts a uint256 to its ASCII string decimal representation.
1628      */
1629     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1630         assembly {
1631             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1632             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1633             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1634             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1635             let m := add(mload(0x40), 0xa0)
1636             // Update the free memory pointer to allocate.
1637             mstore(0x40, m)
1638             // Assign the `str` to the end.
1639             str := sub(m, 0x20)
1640             // Zeroize the slot after the string.
1641             mstore(str, 0)
1642 
1643             // Cache the end of the memory to calculate the length later.
1644             let end := str
1645 
1646             // We write the string from rightmost digit to leftmost digit.
1647             // The following is essentially a do-while loop that also handles the zero case.
1648             // prettier-ignore
1649             for { let temp := value } 1 {} {
1650                 str := sub(str, 1)
1651                 // Write the character to the pointer.
1652                 // The ASCII index of the '0' character is 48.
1653                 mstore8(str, add(48, mod(temp, 10)))
1654                 // Keep dividing `temp` until zero.
1655                 temp := div(temp, 10)
1656                 // prettier-ignore
1657                 if iszero(temp) { break }
1658             }
1659 
1660             let length := sub(end, str)
1661             // Move the pointer 32 bytes leftwards to make room for the length.
1662             str := sub(str, 0x20)
1663             // Store the length.
1664             mstore(str, length)
1665         }
1666     }
1667 }
1668 
1669 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1670 
1671 
1672 // ERC721A Contracts v4.2.3
1673 // Creator: Chiru Labs
1674 
1675 pragma solidity ^0.8.4;
1676 
1677 
1678 
1679 /**
1680  * @title ERC721AQueryable.
1681  *
1682  * @dev ERC721A subclass with convenience query functions.
1683  */
1684 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1685     /**
1686      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1687      *
1688      * If the `tokenId` is out of bounds:
1689      *
1690      * - `addr = address(0)`
1691      * - `startTimestamp = 0`
1692      * - `burned = false`
1693      * - `extraData = 0`
1694      *
1695      * If the `tokenId` is burned:
1696      *
1697      * - `addr = <Address of owner before token was burned>`
1698      * - `startTimestamp = <Timestamp when token was burned>`
1699      * - `burned = true`
1700      * - `extraData = <Extra data when token was burned>`
1701      *
1702      * Otherwise:
1703      *
1704      * - `addr = <Address of owner>`
1705      * - `startTimestamp = <Timestamp of start of ownership>`
1706      * - `burned = false`
1707      * - `extraData = <Extra data at start of ownership>`
1708      */
1709     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1710         TokenOwnership memory ownership;
1711         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1712             return ownership;
1713         }
1714         ownership = _ownershipAt(tokenId);
1715         if (ownership.burned) {
1716             return ownership;
1717         }
1718         return _ownershipOf(tokenId);
1719     }
1720 
1721     /**
1722      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1723      * See {ERC721AQueryable-explicitOwnershipOf}
1724      */
1725     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1726         external
1727         view
1728         virtual
1729         override
1730         returns (TokenOwnership[] memory)
1731     {
1732         unchecked {
1733             uint256 tokenIdsLength = tokenIds.length;
1734             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1735             for (uint256 i; i != tokenIdsLength; ++i) {
1736                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1737             }
1738             return ownerships;
1739         }
1740     }
1741 
1742     /**
1743      * @dev Returns an array of token IDs owned by `owner`,
1744      * in the range [`start`, `stop`)
1745      * (i.e. `start <= tokenId < stop`).
1746      *
1747      * This function allows for tokens to be queried if the collection
1748      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1749      *
1750      * Requirements:
1751      *
1752      * - `start < stop`
1753      */
1754     function tokensOfOwnerIn(
1755         address owner,
1756         uint256 start,
1757         uint256 stop
1758     ) external view virtual override returns (uint256[] memory) {
1759         unchecked {
1760             if (start >= stop) revert InvalidQueryRange();
1761             uint256 tokenIdsIdx;
1762             uint256 stopLimit = _nextTokenId();
1763             // Set `start = max(start, _startTokenId())`.
1764             if (start < _startTokenId()) {
1765                 start = _startTokenId();
1766             }
1767             // Set `stop = min(stop, stopLimit)`.
1768             if (stop > stopLimit) {
1769                 stop = stopLimit;
1770             }
1771             uint256 tokenIdsMaxLength = balanceOf(owner);
1772             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1773             // to cater for cases where `balanceOf(owner)` is too big.
1774             if (start < stop) {
1775                 uint256 rangeLength = stop - start;
1776                 if (rangeLength < tokenIdsMaxLength) {
1777                     tokenIdsMaxLength = rangeLength;
1778                 }
1779             } else {
1780                 tokenIdsMaxLength = 0;
1781             }
1782             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1783             if (tokenIdsMaxLength == 0) {
1784                 return tokenIds;
1785             }
1786             // We need to call `explicitOwnershipOf(start)`,
1787             // because the slot at `start` may not be initialized.
1788             TokenOwnership memory ownership = explicitOwnershipOf(start);
1789             address currOwnershipAddr;
1790             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1791             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1792             if (!ownership.burned) {
1793                 currOwnershipAddr = ownership.addr;
1794             }
1795             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1796                 ownership = _ownershipAt(i);
1797                 if (ownership.burned) {
1798                     continue;
1799                 }
1800                 if (ownership.addr != address(0)) {
1801                     currOwnershipAddr = ownership.addr;
1802                 }
1803                 if (currOwnershipAddr == owner) {
1804                     tokenIds[tokenIdsIdx++] = i;
1805                 }
1806             }
1807             // Downsize the array to fit.
1808             assembly {
1809                 mstore(tokenIds, tokenIdsIdx)
1810             }
1811             return tokenIds;
1812         }
1813     }
1814 
1815     /**
1816      * @dev Returns an array of token IDs owned by `owner`.
1817      *
1818      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1819      * It is meant to be called off-chain.
1820      *
1821      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1822      * multiple smaller scans if the collection is large enough to cause
1823      * an out-of-gas error (10K collections should be fine).
1824      */
1825     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1826         unchecked {
1827             uint256 tokenIdsIdx;
1828             address currOwnershipAddr;
1829             uint256 tokenIdsLength = balanceOf(owner);
1830             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1831             TokenOwnership memory ownership;
1832             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1833                 ownership = _ownershipAt(i);
1834                 if (ownership.burned) {
1835                     continue;
1836                 }
1837                 if (ownership.addr != address(0)) {
1838                     currOwnershipAddr = ownership.addr;
1839                 }
1840                 if (currOwnershipAddr == owner) {
1841                     tokenIds[tokenIdsIdx++] = i;
1842                 }
1843             }
1844             return tokenIds;
1845         }
1846     }
1847 }
1848 
1849 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
1850 
1851 
1852 // ERC721A Contracts v4.2.3
1853 // Creator: Chiru Labs
1854 
1855 pragma solidity ^0.8.4;
1856 
1857 
1858 /**
1859  * @dev Interface of ERC721ABurnable.
1860  */
1861 interface IERC721ABurnable is IERC721A {
1862     /**
1863      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1864      *
1865      * Requirements:
1866      *
1867      * - The caller must own `tokenId` or be an approved operator.
1868      */
1869     function burn(uint256 tokenId) external;
1870 }
1871 
1872 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1873 
1874 
1875 // ERC721A Contracts v4.2.3
1876 // Creator: Chiru Labs
1877 
1878 pragma solidity ^0.8.4;
1879 
1880 
1881 
1882 /**
1883  * @title ERC721ABurnable.
1884  *
1885  * @dev ERC721A token that can be irreversibly burned (destroyed).
1886  */
1887 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1888     /**
1889      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1890      *
1891      * Requirements:
1892      *
1893      * - The caller must own `tokenId` or be an approved operator.
1894      */
1895     function burn(uint256 tokenId) public virtual override {
1896         _burn(tokenId, true);
1897     }
1898 }
1899 
1900 // File: ERC721A-main/contracts/contract.sol
1901 
1902 
1903 
1904 pragma solidity ^0.8.10;
1905 
1906 
1907 
1908 
1909 
1910 
1911 contract EvoxCapital is ERC721A, Ownable, ERC721AQueryable {
1912     using Strings for uint256;
1913 
1914     uint256 public maxNFT = 10000;
1915     uint256 public mintedNFT = 0;
1916     constructor() ERC721A("Evox Capital", "Evox Capital") {
1917         transferOwnership(tx.origin);
1918     }
1919 
1920     function bridgeMint(address recipient, uint256 quantity) external onlyOwner {
1921         require(mintedNFT + quantity <= maxNFT , "EvoxCapitalErc721: Max supply");
1922         _mint(recipient, quantity);
1923         mintedNFT += quantity;
1924     }
1925     // // metadata URI
1926     string private _baseTokenURI;
1927         function tokenURI(uint256 tokenId)
1928         public
1929         view
1930         virtual
1931         override
1932         returns (string memory)
1933     {
1934         require(
1935         _exists(tokenId),
1936         "ERC721Metadata: URI query for nonexistent token"
1937         );
1938 
1939         string memory baseURI = _baseURI();
1940         return
1941         bytes(baseURI).length > 0
1942             ? string(abi.encodePacked(baseURI, tokenId.toString() , ".json"))
1943             : "";
1944     }
1945     function _baseURI() internal view virtual override returns (string memory) {
1946         return _baseTokenURI;
1947     }
1948     /*
1949         Governance
1950      */
1951     function setBaseURI(string calldata baseURI) external onlyOwner {
1952         _baseTokenURI = baseURI;
1953     }
1954 }