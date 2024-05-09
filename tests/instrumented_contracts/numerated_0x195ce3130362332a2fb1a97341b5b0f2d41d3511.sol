1 // SPDX-License-Identifier: MIT
2 
3 /*◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺
4 ◹◺                                                                                                  ◹◺
5 ◹◺    ....:::::..                                                                                   ◹◺
6 ◹◺                                       ..::.::::::.......::..                                     ◹◺
7 ◹◺                                    .::.::-=:..:.............::-:.                                ◹◺
8 ◹◺                                  ::.:-----.....::.............-:.:.                              ◹◺
9 ◹◺                                .:.:----=-.:::......:.:..:::....-:..:.                            ◹◺
10 ◹◺                               ..:-----=:...:.+%=....:...........=-...:.                          ◹◺
11 ◹◺                        .         =-----......=#=.............::.--=-:..:                         ◹◺
12 ◹◺                        .-:::::::.=-----....:::::...........==::.-----:.::                        ◹◺
13 ◹◺                        .:::::::::------:..................:#%=..-------:::                       ◹◺
14 ◹◺                      .:::--::::::-----:::........-+++-....::::.:=------=::                       ◹◺
15 ◹◺                     .:...:::...-=------....:.....:===:.....::..=--------=.:                      ◹◺
16 ◹◺                    :.......: :..=------=:..::...........::....------------:.                     ◹◺
17 ◹◺                    :.......: ...-::.:.:==--..........:......:==------------:                     ◹◺
18 ◹◺                    :.....:.: .:.-......:---=--::......:..::-------=----%%%#=:                    ◹◺
19 ◹◺                     :....:.....--:......----------:::::--:------..:---#@@@@*:                    ◹◺
20 ◹◺                      :.........----:....:::-------------------:......=@@@@+=:.                   ◹◺
21 ◹◺                       ....:....-----::......::------------::.......::=+#@*-=::                   ◹◺
22 ◹◺                            ...----:::::::::::...::::.:::........::::::::---=.:                   ◹◺
23 ◹◺                               :=--...::..-.-::::..-......-....:-::::::::-.:-:.                   ◹◺
24 ◹◺                                :-:..:-::.-::::-::-=:.:-::-:..:::::::::::-...:.                   ◹◺
25 ◹◺                                .:....:...:.::.....::.:::.:.::-:::::::::-......:                  ◹◺
26 ◹◺                                .::::--:::-::::::.::-.....:.--:::::::::-:.......:                 ◹◺
27 ◹◺                                :.:.-:--::-:-:--::---:::---:-::::::::::-..........                ◹◺
28 ◹◺                                :.:::-:::::::.::::::-:-::::-::::::::::=.........:.                ◹◺
29 ◹◺                               .:...:.:.:...:.....:-:.....:::::::::::: .:......:.                 ◹◺
30 ◹◺                               :...........................::::::::-.    ......                   ◹◺
31 ◹◺                               -::..........................:::--::                               ◹◺
32 ◹◺                              .:.::::::::::.....................:                                 ◹◺
33 ◹◺                              :...........::::::::::::::::::::::-                                 ◹◺
34 ◹◺                              :..................................:                                ◹◺
35 ◹◺                             :...................................:                                ◹◺
36 ◹◺                            :..::::..............................:.                               ◹◺
37 ◹◺                              ::...:::::::::::..-:::::::::::::::...                               ◹◺
38 ◹◺                               +*+++++*+******   +*=+=--=-::-+=                                   ◹◺
39 ◹◺                               *@@@@@@@@@@@@@%   @@@@@@@@@@@@@+                                   ◹◺
40 ◹◺                               %@@@@@@@@@@@@@@  =@@@@@@@@@@@@@-                                   ◹◺
41 ◹◺                             .#@@@@@@@@@@@@@@@. =@@@@@@@@@@@@@.                                   ◹◺
42 ◹◺                            =%@@@@@@@@@@@@@@@@# =@@@@@@@@@@@@@.                                   ◹◺
43 ◹◺                          =%@@@@@@@@@@@@@@@@@@@ =@@@@@@@@@@@@@#                                   ◹◺
44 ◹◺                       .=%@@@@@@@@@@@@@@@@@@@@- -@@@@@@@@@@@@@@+                                  ◹◺
45 ◹◺                      =@@@@@@@@@@@@@@@@%#@@@@:  .@@@@@@@@@@@@@@@                                  ◹◺
46 ◹◺                      +%@@@@@@%##*++=:  .**++    -@@@@@@@@@@@@@@.                                 ◹◺
47 ◹◺                                                   :=+*#@@@@%#*-                                  ◹◺
48 ◹◺                                                                                                  ◹◺
49 ◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺◹◺*/
50 
51 // File: @openzeppelin/contracts/utils/Context.sol
52 
53 
54 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/access/Ownable.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Contract module which provides a basic access control mechanism, where
88  * there is an account (an owner) that can be granted exclusive access to
89  * specific functions.
90  *
91  * By default, the owner account will be the one that deploys the contract. This
92  * can later be changed with {transferOwnership}.
93  *
94  * This module is used through inheritance. It will make available the modifier
95  * `onlyOwner`, which can be applied to your functions to restrict their use to
96  * the owner.
97  */
98 abstract contract Ownable is Context {
99     address private _owner;
100 
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     /**
104      * @dev Initializes the contract setting the deployer as the initial owner.
105      */
106     constructor() {
107         _transferOwnership(_msgSender());
108     }
109 
110     /**
111      * @dev Throws if called by any account other than the owner.
112      */
113     modifier onlyOwner() {
114         _checkOwner();
115         _;
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     /**
126      * @dev Throws if the sender is not the owner.
127      */
128     function _checkOwner() internal view virtual {
129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions. Can only be called by the current owner.
135      *
136      * NOTE: Renouncing ownership will leave the contract without an owner,
137      * thereby disabling any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public virtual onlyOwner {
140         _transferOwnership(address(0));
141     }
142 
143     /**
144      * @dev Transfers ownership of the contract to a new account (`newOwner`).
145      * Can only be called by the current owner.
146      */
147     function transferOwnership(address newOwner) public virtual onlyOwner {
148         require(newOwner != address(0), "Ownable: new owner is the zero address");
149         _transferOwnership(newOwner);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Internal function without access restriction.
155      */
156     function _transferOwnership(address newOwner) internal virtual {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 // File: erc721a/contracts/IERC721A.sol
164 
165 
166 // ERC721A Contracts v4.2.3
167 // Creator: Chiru Labs
168 
169 pragma solidity ^0.8.4;
170 
171 /**
172  * @dev Interface of ERC721A.
173  */
174 interface IERC721A {
175     /**
176      * The caller must own the token or be an approved operator.
177      */
178     error ApprovalCallerNotOwnerNorApproved();
179 
180     /**
181      * The token does not exist.
182      */
183     error ApprovalQueryForNonexistentToken();
184 
185     /**
186      * Cannot query the balance for the zero address.
187      */
188     error BalanceQueryForZeroAddress();
189 
190     /**
191      * Cannot mint to the zero address.
192      */
193     error MintToZeroAddress();
194 
195     /**
196      * The quantity of tokens minted must be more than zero.
197      */
198     error MintZeroQuantity();
199 
200     /**
201      * The token does not exist.
202      */
203     error OwnerQueryForNonexistentToken();
204 
205     /**
206      * The caller must own the token or be an approved operator.
207      */
208     error TransferCallerNotOwnerNorApproved();
209 
210     /**
211      * The token must be owned by `from`.
212      */
213     error TransferFromIncorrectOwner();
214 
215     /**
216      * Cannot safely transfer to a contract that does not implement the
217      * ERC721Receiver interface.
218      */
219     error TransferToNonERC721ReceiverImplementer();
220 
221     /**
222      * Cannot transfer to the zero address.
223      */
224     error TransferToZeroAddress();
225 
226     /**
227      * The token does not exist.
228      */
229     error URIQueryForNonexistentToken();
230 
231     /**
232      * The `quantity` minted with ERC2309 exceeds the safety limit.
233      */
234     error MintERC2309QuantityExceedsLimit();
235 
236     /**
237      * The `extraData` cannot be set on an unintialized ownership slot.
238      */
239     error OwnershipNotInitializedForExtraData();
240 
241     // =============================================================
242     //                            STRUCTS
243     // =============================================================
244 
245     struct TokenOwnership {
246         // The address of the owner.
247         address addr;
248         // Stores the start time of ownership with minimal overhead for tokenomics.
249         uint64 startTimestamp;
250         // Whether the token has been burned.
251         bool burned;
252         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
253         uint24 extraData;
254     }
255 
256     // =============================================================
257     //                         TOKEN COUNTERS
258     // =============================================================
259 
260     /**
261      * @dev Returns the total number of tokens in existence.
262      * Burned tokens will reduce the count.
263      * To get the total number of tokens minted, please see {_totalMinted}.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     // =============================================================
268     //                            IERC165
269     // =============================================================
270 
271     /**
272      * @dev Returns true if this contract implements the interface defined by
273      * `interfaceId`. See the corresponding
274      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
275      * to learn more about how these ids are created.
276      *
277      * This function call must use less than 30000 gas.
278      */
279     function supportsInterface(bytes4 interfaceId) external view returns (bool);
280 
281     // =============================================================
282     //                            IERC721
283     // =============================================================
284 
285     /**
286      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
289 
290     /**
291      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
292      */
293     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
294 
295     /**
296      * @dev Emitted when `owner` enables or disables
297      * (`approved`) `operator` to manage all of its assets.
298      */
299     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
300 
301     /**
302      * @dev Returns the number of tokens in `owner`'s account.
303      */
304     function balanceOf(address owner) external view returns (uint256 balance);
305 
306     /**
307      * @dev Returns the owner of the `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function ownerOf(uint256 tokenId) external view returns (address owner);
314 
315     /**
316      * @dev Safely transfers `tokenId` token from `from` to `to`,
317      * checking first that contract recipients are aware of the ERC721 protocol
318      * to prevent tokens from being forever locked.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must exist and be owned by `from`.
325      * - If the caller is not `from`, it must be have been allowed to move
326      * this token by either {approve} or {setApprovalForAll}.
327      * - If `to` refers to a smart contract, it must implement
328      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId,
336         bytes calldata data
337     ) external payable;
338 
339     /**
340      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external payable;
347 
348     /**
349      * @dev Transfers `tokenId` from `from` to `to`.
350      *
351      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
352      * whenever possible.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `tokenId` token must be owned by `from`.
359      * - If the caller is not `from`, it must be approved to move this token
360      * by either {approve} or {setApprovalForAll}.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transferFrom(
365         address from,
366         address to,
367         uint256 tokenId
368     ) external payable;
369 
370     /**
371      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
372      * The approval is cleared when the token is transferred.
373      *
374      * Only a single account can be approved at a time, so approving the
375      * zero address clears previous approvals.
376      *
377      * Requirements:
378      *
379      * - The caller must own the token or be an approved operator.
380      * - `tokenId` must exist.
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address to, uint256 tokenId) external payable;
385 
386     /**
387      * @dev Approve or remove `operator` as an operator for the caller.
388      * Operators can call {transferFrom} or {safeTransferFrom}
389      * for any token owned by the caller.
390      *
391      * Requirements:
392      *
393      * - The `operator` cannot be the caller.
394      *
395      * Emits an {ApprovalForAll} event.
396      */
397     function setApprovalForAll(address operator, bool _approved) external;
398 
399     /**
400      * @dev Returns the account approved for `tokenId` token.
401      *
402      * Requirements:
403      *
404      * - `tokenId` must exist.
405      */
406     function getApproved(uint256 tokenId) external view returns (address operator);
407 
408     /**
409      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
410      *
411      * See {setApprovalForAll}.
412      */
413     function isApprovedForAll(address owner, address operator) external view returns (bool);
414 
415     // =============================================================
416     //                        IERC721Metadata
417     // =============================================================
418 
419     /**
420      * @dev Returns the token collection name.
421      */
422     function name() external view returns (string memory);
423 
424     /**
425      * @dev Returns the token collection symbol.
426      */
427     function symbol() external view returns (string memory);
428 
429     /**
430      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
431      */
432     function tokenURI(uint256 tokenId) external view returns (string memory);
433 
434     // =============================================================
435     //                           IERC2309
436     // =============================================================
437 
438     /**
439      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
440      * (inclusive) is transferred from `from` to `to`, as defined in the
441      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
442      *
443      * See {_mintERC2309} for more details.
444      */
445     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
446 }
447 
448 // File: erc721a/contracts/ERC721A.sol
449 
450 
451 // ERC721A Contracts v4.2.3
452 // Creator: Chiru Labs
453 
454 pragma solidity ^0.8.4;
455 
456 
457 /**
458  * @dev Interface of ERC721 token receiver.
459  */
460 interface ERC721A__IERC721Receiver {
461     function onERC721Received(
462         address operator,
463         address from,
464         uint256 tokenId,
465         bytes calldata data
466     ) external returns (bytes4);
467 }
468 
469 /**
470  * @title ERC721A
471  *
472  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
473  * Non-Fungible Token Standard, including the Metadata extension.
474  * Optimized for lower gas during batch mints.
475  *
476  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
477  * starting from `_startTokenId()`.
478  *
479  * Assumptions:
480  *
481  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
482  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
483  */
484 contract ERC721A is IERC721A {
485     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
486     struct TokenApprovalRef {
487         address value;
488     }
489 
490     // =============================================================
491     //                           CONSTANTS
492     // =============================================================
493 
494     // Mask of an entry in packed address data.
495     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
496 
497     // The bit position of `numberMinted` in packed address data.
498     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
499 
500     // The bit position of `numberBurned` in packed address data.
501     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
502 
503     // The bit position of `aux` in packed address data.
504     uint256 private constant _BITPOS_AUX = 192;
505 
506     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
507     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
508 
509     // The bit position of `startTimestamp` in packed ownership.
510     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
511 
512     // The bit mask of the `burned` bit in packed ownership.
513     uint256 private constant _BITMASK_BURNED = 1 << 224;
514 
515     // The bit position of the `nextInitialized` bit in packed ownership.
516     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
517 
518     // The bit mask of the `nextInitialized` bit in packed ownership.
519     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
520 
521     // The bit position of `extraData` in packed ownership.
522     uint256 private constant _BITPOS_EXTRA_DATA = 232;
523 
524     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
525     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
526 
527     // The mask of the lower 160 bits for addresses.
528     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
529 
530     // The maximum `quantity` that can be minted with {_mintERC2309}.
531     // This limit is to prevent overflows on the address data entries.
532     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
533     // is required to cause an overflow, which is unrealistic.
534     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
535 
536     // The `Transfer` event signature is given by:
537     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
538     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
539         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
540 
541     // =============================================================
542     //                            STORAGE
543     // =============================================================
544 
545     // The next token ID to be minted.
546     uint256 private _currentIndex;
547 
548     // The number of tokens burned.
549     uint256 private _burnCounter;
550 
551     // Token name
552     string private _name;
553 
554     // Token symbol
555     string private _symbol;
556 
557     // Mapping from token ID to ownership details
558     // An empty struct value does not necessarily mean the token is unowned.
559     // See {_packedOwnershipOf} implementation for details.
560     //
561     // Bits Layout:
562     // - [0..159]   `addr`
563     // - [160..223] `startTimestamp`
564     // - [224]      `burned`
565     // - [225]      `nextInitialized`
566     // - [232..255] `extraData`
567     mapping(uint256 => uint256) private _packedOwnerships;
568 
569     // Mapping owner address to address data.
570     //
571     // Bits Layout:
572     // - [0..63]    `balance`
573     // - [64..127]  `numberMinted`
574     // - [128..191] `numberBurned`
575     // - [192..255] `aux`
576     mapping(address => uint256) private _packedAddressData;
577 
578     // Mapping from token ID to approved address.
579     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
580 
581     // Mapping from owner to operator approvals
582     mapping(address => mapping(address => bool)) private _operatorApprovals;
583 
584     // =============================================================
585     //                          CONSTRUCTOR
586     // =============================================================
587 
588     constructor(string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591         _currentIndex = _startTokenId();
592     }
593 
594     // =============================================================
595     //                   TOKEN COUNTING OPERATIONS
596     // =============================================================
597 
598     /**
599      * @dev Returns the starting token ID.
600      * To change the starting token ID, please override this function.
601      */
602     function _startTokenId() internal view virtual returns (uint256) {
603         return 0;
604     }
605 
606     /**
607      * @dev Returns the next token ID to be minted.
608      */
609     function _nextTokenId() internal view virtual returns (uint256) {
610         return _currentIndex;
611     }
612 
613     /**
614      * @dev Returns the total number of tokens in existence.
615      * Burned tokens will reduce the count.
616      * To get the total number of tokens minted, please see {_totalMinted}.
617      */
618     function totalSupply() public view virtual override returns (uint256) {
619         // Counter underflow is impossible as _burnCounter cannot be incremented
620         // more than `_currentIndex - _startTokenId()` times.
621         unchecked {
622             return _currentIndex - _burnCounter - _startTokenId();
623         }
624     }
625 
626     /**
627      * @dev Returns the total amount of tokens minted in the contract.
628      */
629     function _totalMinted() internal view virtual returns (uint256) {
630         // Counter underflow is impossible as `_currentIndex` does not decrement,
631         // and it is initialized to `_startTokenId()`.
632         unchecked {
633             return _currentIndex - _startTokenId();
634         }
635     }
636 
637     /**
638      * @dev Returns the total number of tokens burned.
639      */
640     function _totalBurned() internal view virtual returns (uint256) {
641         return _burnCounter;
642     }
643 
644     // =============================================================
645     //                    ADDRESS DATA OPERATIONS
646     // =============================================================
647 
648     /**
649      * @dev Returns the number of tokens in `owner`'s account.
650      */
651     function balanceOf(address owner) public view virtual override returns (uint256) {
652         if (owner == address(0)) revert BalanceQueryForZeroAddress();
653         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
654     }
655 
656     /**
657      * Returns the number of tokens minted by `owner`.
658      */
659     function _numberMinted(address owner) internal view returns (uint256) {
660         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
661     }
662 
663     /**
664      * Returns the number of tokens burned by or on behalf of `owner`.
665      */
666     function _numberBurned(address owner) internal view returns (uint256) {
667         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
668     }
669 
670     /**
671      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
672      */
673     function _getAux(address owner) internal view returns (uint64) {
674         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
675     }
676 
677     /**
678      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
679      * If there are multiple variables, please pack them into a uint64.
680      */
681     function _setAux(address owner, uint64 aux) internal virtual {
682         uint256 packed = _packedAddressData[owner];
683         uint256 auxCasted;
684         // Cast `aux` with assembly to avoid redundant masking.
685         assembly {
686             auxCasted := aux
687         }
688         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
689         _packedAddressData[owner] = packed;
690     }
691 
692     // =============================================================
693     //                            IERC165
694     // =============================================================
695 
696     /**
697      * @dev Returns true if this contract implements the interface defined by
698      * `interfaceId`. See the corresponding
699      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
700      * to learn more about how these ids are created.
701      *
702      * This function call must use less than 30000 gas.
703      */
704     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
705         // The interface IDs are constants representing the first 4 bytes
706         // of the XOR of all function selectors in the interface.
707         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
708         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
709         return
710             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
711             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
712             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
713     }
714 
715     // =============================================================
716     //                        IERC721Metadata
717     // =============================================================
718 
719     /**
720      * @dev Returns the token collection name.
721      */
722     function name() public view virtual override returns (string memory) {
723         return _name;
724     }
725 
726     /**
727      * @dev Returns the token collection symbol.
728      */
729     function symbol() public view virtual override returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
735      */
736     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
737         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
738 
739         string memory baseURI = _baseURI();
740         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
741     }
742 
743     /**
744      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
745      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
746      * by default, it can be overridden in child contracts.
747      */
748     function _baseURI() internal view virtual returns (string memory) {
749         return '';
750     }
751 
752     // =============================================================
753     //                     OWNERSHIPS OPERATIONS
754     // =============================================================
755 
756     /**
757      * @dev Returns the owner of the `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
764         return address(uint160(_packedOwnershipOf(tokenId)));
765     }
766 
767     /**
768      * @dev Gas spent here starts off proportional to the maximum mint batch size.
769      * It gradually moves to O(1) as tokens get transferred around over time.
770      */
771     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
772         return _unpackedOwnership(_packedOwnershipOf(tokenId));
773     }
774 
775     /**
776      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
777      */
778     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
779         return _unpackedOwnership(_packedOwnerships[index]);
780     }
781 
782     /**
783      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
784      */
785     function _initializeOwnershipAt(uint256 index) internal virtual {
786         if (_packedOwnerships[index] == 0) {
787             _packedOwnerships[index] = _packedOwnershipOf(index);
788         }
789     }
790 
791     /**
792      * Returns the packed ownership data of `tokenId`.
793      */
794     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
795         uint256 curr = tokenId;
796 
797         unchecked {
798             if (_startTokenId() <= curr)
799                 if (curr < _currentIndex) {
800                     uint256 packed = _packedOwnerships[curr];
801                     // If not burned.
802                     if (packed & _BITMASK_BURNED == 0) {
803                         // Invariant:
804                         // There will always be an initialized ownership slot
805                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
806                         // before an unintialized ownership slot
807                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
808                         // Hence, `curr` will not underflow.
809                         //
810                         // We can directly compare the packed value.
811                         // If the address is zero, packed will be zero.
812                         while (packed == 0) {
813                             packed = _packedOwnerships[--curr];
814                         }
815                         return packed;
816                     }
817                 }
818         }
819         revert OwnerQueryForNonexistentToken();
820     }
821 
822     /**
823      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
824      */
825     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
826         ownership.addr = address(uint160(packed));
827         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
828         ownership.burned = packed & _BITMASK_BURNED != 0;
829         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
830     }
831 
832     /**
833      * @dev Packs ownership data into a single uint256.
834      */
835     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
836         assembly {
837             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
838             owner := and(owner, _BITMASK_ADDRESS)
839             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
840             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
841         }
842     }
843 
844     /**
845      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
846      */
847     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
848         // For branchless setting of the `nextInitialized` flag.
849         assembly {
850             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
851             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
852         }
853     }
854 
855     // =============================================================
856     //                      APPROVAL OPERATIONS
857     // =============================================================
858 
859     /**
860      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
861      * The approval is cleared when the token is transferred.
862      *
863      * Only a single account can be approved at a time, so approving the
864      * zero address clears previous approvals.
865      *
866      * Requirements:
867      *
868      * - The caller must own the token or be an approved operator.
869      * - `tokenId` must exist.
870      *
871      * Emits an {Approval} event.
872      */
873     function approve(address to, uint256 tokenId) public payable virtual override {
874         address owner = ownerOf(tokenId);
875 
876         if (_msgSenderERC721A() != owner)
877             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
878                 revert ApprovalCallerNotOwnerNorApproved();
879             }
880 
881         _tokenApprovals[tokenId].value = to;
882         emit Approval(owner, to, tokenId);
883     }
884 
885     /**
886      * @dev Returns the account approved for `tokenId` token.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      */
892     function getApproved(uint256 tokenId) public view virtual override returns (address) {
893         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
894 
895         return _tokenApprovals[tokenId].value;
896     }
897 
898     /**
899      * @dev Approve or remove `operator` as an operator for the caller.
900      * Operators can call {transferFrom} or {safeTransferFrom}
901      * for any token owned by the caller.
902      *
903      * Requirements:
904      *
905      * - The `operator` cannot be the caller.
906      *
907      * Emits an {ApprovalForAll} event.
908      */
909     function setApprovalForAll(address operator, bool approved) public virtual override {
910         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
911         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
912     }
913 
914     /**
915      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
916      *
917      * See {setApprovalForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev Returns whether `tokenId` exists.
925      *
926      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
927      *
928      * Tokens start existing when they are minted. See {_mint}.
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return
932             _startTokenId() <= tokenId &&
933             tokenId < _currentIndex && // If within bounds,
934             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
935     }
936 
937     /**
938      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
939      */
940     function _isSenderApprovedOrOwner(
941         address approvedAddress,
942         address owner,
943         address msgSender
944     ) private pure returns (bool result) {
945         assembly {
946             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
947             owner := and(owner, _BITMASK_ADDRESS)
948             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
949             msgSender := and(msgSender, _BITMASK_ADDRESS)
950             // `msgSender == owner || msgSender == approvedAddress`.
951             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
952         }
953     }
954 
955     /**
956      * @dev Returns the storage slot and value for the approved address of `tokenId`.
957      */
958     function _getApprovedSlotAndAddress(uint256 tokenId)
959         private
960         view
961         returns (uint256 approvedAddressSlot, address approvedAddress)
962     {
963         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
964         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
965         assembly {
966             approvedAddressSlot := tokenApproval.slot
967             approvedAddress := sload(approvedAddressSlot)
968         }
969     }
970 
971     // =============================================================
972     //                      TRANSFER OPERATIONS
973     // =============================================================
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      * - If the caller is not `from`, it must be approved to move this token
984      * by either {approve} or {setApprovalForAll}.
985      *
986      * Emits a {Transfer} event.
987      */
988     function transferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) public payable virtual override {
993         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
994 
995         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
996 
997         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
998 
999         // The nested ifs save around 20+ gas over a compound boolean condition.
1000         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1001             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1002 
1003         if (to == address(0)) revert TransferToZeroAddress();
1004 
1005         _beforeTokenTransfers(from, to, tokenId, 1);
1006 
1007         // Clear approvals from the previous owner.
1008         assembly {
1009             if approvedAddress {
1010                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1011                 sstore(approvedAddressSlot, 0)
1012             }
1013         }
1014 
1015         // Underflow of the sender's balance is impossible because we check for
1016         // ownership above and the recipient's balance can't realistically overflow.
1017         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1018         unchecked {
1019             // We can directly increment and decrement the balances.
1020             --_packedAddressData[from]; // Updates: `balance -= 1`.
1021             ++_packedAddressData[to]; // Updates: `balance += 1`.
1022 
1023             // Updates:
1024             // - `address` to the next owner.
1025             // - `startTimestamp` to the timestamp of transfering.
1026             // - `burned` to `false`.
1027             // - `nextInitialized` to `true`.
1028             _packedOwnerships[tokenId] = _packOwnershipData(
1029                 to,
1030                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1031             );
1032 
1033             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1034             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1035                 uint256 nextTokenId = tokenId + 1;
1036                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1037                 if (_packedOwnerships[nextTokenId] == 0) {
1038                     // If the next slot is within bounds.
1039                     if (nextTokenId != _currentIndex) {
1040                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1041                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1042                     }
1043                 }
1044             }
1045         }
1046 
1047         emit Transfer(from, to, tokenId);
1048         _afterTokenTransfers(from, to, tokenId, 1);
1049     }
1050 
1051     /**
1052      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public payable virtual override {
1059         safeTransferFrom(from, to, tokenId, '');
1060     }
1061 
1062     /**
1063      * @dev Safely transfers `tokenId` token from `from` to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must exist and be owned by `from`.
1070      * - If the caller is not `from`, it must be approved to move this token
1071      * by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement
1073      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes memory _data
1082     ) public payable virtual override {
1083         transferFrom(from, to, tokenId);
1084         if (to.code.length != 0)
1085             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1086                 revert TransferToNonERC721ReceiverImplementer();
1087             }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before a set of serially-ordered token IDs
1092      * are about to be transferred. This includes minting.
1093      * And also called before burning one token.
1094      *
1095      * `startTokenId` - the first token ID to be transferred.
1096      * `quantity` - the amount to be transferred.
1097      *
1098      * Calling conditions:
1099      *
1100      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1101      * transferred to `to`.
1102      * - When `from` is zero, `tokenId` will be minted for `to`.
1103      * - When `to` is zero, `tokenId` will be burned by `from`.
1104      * - `from` and `to` are never both zero.
1105      */
1106     function _beforeTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 
1113     /**
1114      * @dev Hook that is called after a set of serially-ordered token IDs
1115      * have been transferred. This includes minting.
1116      * And also called after one token has been burned.
1117      *
1118      * `startTokenId` - the first token ID to be transferred.
1119      * `quantity` - the amount to be transferred.
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` has been minted for `to`.
1126      * - When `to` is zero, `tokenId` has been burned by `from`.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _afterTokenTransfers(
1130         address from,
1131         address to,
1132         uint256 startTokenId,
1133         uint256 quantity
1134     ) internal virtual {}
1135 
1136     /**
1137      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1138      *
1139      * `from` - Previous owner of the given token ID.
1140      * `to` - Target address that will receive the token.
1141      * `tokenId` - Token ID to be transferred.
1142      * `_data` - Optional data to send along with the call.
1143      *
1144      * Returns whether the call correctly returned the expected magic value.
1145      */
1146     function _checkContractOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1153             bytes4 retval
1154         ) {
1155             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1156         } catch (bytes memory reason) {
1157             if (reason.length == 0) {
1158                 revert TransferToNonERC721ReceiverImplementer();
1159             } else {
1160                 assembly {
1161                     revert(add(32, reason), mload(reason))
1162                 }
1163             }
1164         }
1165     }
1166 
1167     // =============================================================
1168     //                        MINT OPERATIONS
1169     // =============================================================
1170 
1171     /**
1172      * @dev Mints `quantity` tokens and transfers them to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `quantity` must be greater than 0.
1178      *
1179      * Emits a {Transfer} event for each mint.
1180      */
1181     function _mint(address to, uint256 quantity) internal virtual {
1182         uint256 startTokenId = _currentIndex;
1183         if (quantity == 0) revert MintZeroQuantity();
1184 
1185         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1186 
1187         // Overflows are incredibly unrealistic.
1188         // `balance` and `numberMinted` have a maximum limit of 2**64.
1189         // `tokenId` has a maximum limit of 2**256.
1190         unchecked {
1191             // Updates:
1192             // - `balance += quantity`.
1193             // - `numberMinted += quantity`.
1194             //
1195             // We can directly add to the `balance` and `numberMinted`.
1196             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1197 
1198             // Updates:
1199             // - `address` to the owner.
1200             // - `startTimestamp` to the timestamp of minting.
1201             // - `burned` to `false`.
1202             // - `nextInitialized` to `quantity == 1`.
1203             _packedOwnerships[startTokenId] = _packOwnershipData(
1204                 to,
1205                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1206             );
1207 
1208             uint256 toMasked;
1209             uint256 end = startTokenId + quantity;
1210 
1211             // Use assembly to loop and emit the `Transfer` event for gas savings.
1212             // The duplicated `log4` removes an extra check and reduces stack juggling.
1213             // The assembly, together with the surrounding Solidity code, have been
1214             // delicately arranged to nudge the compiler into producing optimized opcodes.
1215             assembly {
1216                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1217                 toMasked := and(to, _BITMASK_ADDRESS)
1218                 // Emit the `Transfer` event.
1219                 log4(
1220                     0, // Start of data (0, since no data).
1221                     0, // End of data (0, since no data).
1222                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1223                     0, // `address(0)`.
1224                     toMasked, // `to`.
1225                     startTokenId // `tokenId`.
1226                 )
1227 
1228                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1229                 // that overflows uint256 will make the loop run out of gas.
1230                 // The compiler will optimize the `iszero` away for performance.
1231                 for {
1232                     let tokenId := add(startTokenId, 1)
1233                 } iszero(eq(tokenId, end)) {
1234                     tokenId := add(tokenId, 1)
1235                 } {
1236                     // Emit the `Transfer` event. Similar to above.
1237                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1238                 }
1239             }
1240             if (toMasked == 0) revert MintToZeroAddress();
1241 
1242             _currentIndex = end;
1243         }
1244         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1245     }
1246 
1247     /**
1248      * @dev Mints `quantity` tokens and transfers them to `to`.
1249      *
1250      * This function is intended for efficient minting only during contract creation.
1251      *
1252      * It emits only one {ConsecutiveTransfer} as defined in
1253      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1254      * instead of a sequence of {Transfer} event(s).
1255      *
1256      * Calling this function outside of contract creation WILL make your contract
1257      * non-compliant with the ERC721 standard.
1258      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1259      * {ConsecutiveTransfer} event is only permissible during contract creation.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `quantity` must be greater than 0.
1265      *
1266      * Emits a {ConsecutiveTransfer} event.
1267      */
1268     function _mintERC2309(address to, uint256 quantity) internal virtual {
1269         uint256 startTokenId = _currentIndex;
1270         if (to == address(0)) revert MintToZeroAddress();
1271         if (quantity == 0) revert MintZeroQuantity();
1272         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1273 
1274         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1275 
1276         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1277         unchecked {
1278             // Updates:
1279             // - `balance += quantity`.
1280             // - `numberMinted += quantity`.
1281             //
1282             // We can directly add to the `balance` and `numberMinted`.
1283             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1284 
1285             // Updates:
1286             // - `address` to the owner.
1287             // - `startTimestamp` to the timestamp of minting.
1288             // - `burned` to `false`.
1289             // - `nextInitialized` to `quantity == 1`.
1290             _packedOwnerships[startTokenId] = _packOwnershipData(
1291                 to,
1292                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1293             );
1294 
1295             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1296 
1297             _currentIndex = startTokenId + quantity;
1298         }
1299         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1300     }
1301 
1302     /**
1303      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - If `to` refers to a smart contract, it must implement
1308      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1309      * - `quantity` must be greater than 0.
1310      *
1311      * See {_mint}.
1312      *
1313      * Emits a {Transfer} event for each mint.
1314      */
1315     function _safeMint(
1316         address to,
1317         uint256 quantity,
1318         bytes memory _data
1319     ) internal virtual {
1320         _mint(to, quantity);
1321 
1322         unchecked {
1323             if (to.code.length != 0) {
1324                 uint256 end = _currentIndex;
1325                 uint256 index = end - quantity;
1326                 do {
1327                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1328                         revert TransferToNonERC721ReceiverImplementer();
1329                     }
1330                 } while (index < end);
1331                 // Reentrancy protection.
1332                 if (_currentIndex != end) revert();
1333             }
1334         }
1335     }
1336 
1337     /**
1338      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1339      */
1340     function _safeMint(address to, uint256 quantity) internal virtual {
1341         _safeMint(to, quantity, '');
1342     }
1343 
1344     // =============================================================
1345     //                        BURN OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Equivalent to `_burn(tokenId, false)`.
1350      */
1351     function _burn(uint256 tokenId) internal virtual {
1352         _burn(tokenId, false);
1353     }
1354 
1355     /**
1356      * @dev Destroys `tokenId`.
1357      * The approval is cleared when the token is burned.
1358      *
1359      * Requirements:
1360      *
1361      * - `tokenId` must exist.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1366         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1367 
1368         address from = address(uint160(prevOwnershipPacked));
1369 
1370         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1371 
1372         if (approvalCheck) {
1373             // The nested ifs save around 20+ gas over a compound boolean condition.
1374             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1375                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1376         }
1377 
1378         _beforeTokenTransfers(from, address(0), tokenId, 1);
1379 
1380         // Clear approvals from the previous owner.
1381         assembly {
1382             if approvedAddress {
1383                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1384                 sstore(approvedAddressSlot, 0)
1385             }
1386         }
1387 
1388         // Underflow of the sender's balance is impossible because we check for
1389         // ownership above and the recipient's balance can't realistically overflow.
1390         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1391         unchecked {
1392             // Updates:
1393             // - `balance -= 1`.
1394             // - `numberBurned += 1`.
1395             //
1396             // We can directly decrement the balance, and increment the number burned.
1397             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1398             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1399 
1400             // Updates:
1401             // - `address` to the last owner.
1402             // - `startTimestamp` to the timestamp of burning.
1403             // - `burned` to `true`.
1404             // - `nextInitialized` to `true`.
1405             _packedOwnerships[tokenId] = _packOwnershipData(
1406                 from,
1407                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1408             );
1409 
1410             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1411             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1412                 uint256 nextTokenId = tokenId + 1;
1413                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1414                 if (_packedOwnerships[nextTokenId] == 0) {
1415                     // If the next slot is within bounds.
1416                     if (nextTokenId != _currentIndex) {
1417                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1418                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1419                     }
1420                 }
1421             }
1422         }
1423 
1424         emit Transfer(from, address(0), tokenId);
1425         _afterTokenTransfers(from, address(0), tokenId, 1);
1426 
1427         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1428         unchecked {
1429             _burnCounter++;
1430         }
1431     }
1432 
1433     // =============================================================
1434     //                     EXTRA DATA OPERATIONS
1435     // =============================================================
1436 
1437     /**
1438      * @dev Directly sets the extra data for the ownership data `index`.
1439      */
1440     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1441         uint256 packed = _packedOwnerships[index];
1442         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1443         uint256 extraDataCasted;
1444         // Cast `extraData` with assembly to avoid redundant masking.
1445         assembly {
1446             extraDataCasted := extraData
1447         }
1448         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1449         _packedOwnerships[index] = packed;
1450     }
1451 
1452     /**
1453      * @dev Called during each token transfer to set the 24bit `extraData` field.
1454      * Intended to be overridden by the cosumer contract.
1455      *
1456      * `previousExtraData` - the value of `extraData` before transfer.
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` will be minted for `to`.
1463      * - When `to` is zero, `tokenId` will be burned by `from`.
1464      * - `from` and `to` are never both zero.
1465      */
1466     function _extraData(
1467         address from,
1468         address to,
1469         uint24 previousExtraData
1470     ) internal view virtual returns (uint24) {}
1471 
1472     /**
1473      * @dev Returns the next extra data for the packed ownership data.
1474      * The returned result is shifted into position.
1475      */
1476     function _nextExtraData(
1477         address from,
1478         address to,
1479         uint256 prevOwnershipPacked
1480     ) private view returns (uint256) {
1481         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1482         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1483     }
1484 
1485     // =============================================================
1486     //                       OTHER OPERATIONS
1487     // =============================================================
1488 
1489     /**
1490      * @dev Returns the message sender (defaults to `msg.sender`).
1491      *
1492      * If you are writing GSN compatible contracts, you need to override this function.
1493      */
1494     function _msgSenderERC721A() internal view virtual returns (address) {
1495         return msg.sender;
1496     }
1497 
1498     /**
1499      * @dev Converts a uint256 to its ASCII string decimal representation.
1500      */
1501     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1502         assembly {
1503             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1504             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1505             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1506             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1507             let m := add(mload(0x40), 0xa0)
1508             // Update the free memory pointer to allocate.
1509             mstore(0x40, m)
1510             // Assign the `str` to the end.
1511             str := sub(m, 0x20)
1512             // Zeroize the slot after the string.
1513             mstore(str, 0)
1514 
1515             // Cache the end of the memory to calculate the length later.
1516             let end := str
1517 
1518             // We write the string from rightmost digit to leftmost digit.
1519             // The following is essentially a do-while loop that also handles the zero case.
1520             // prettier-ignore
1521             for { let temp := value } 1 {} {
1522                 str := sub(str, 1)
1523                 // Write the character to the pointer.
1524                 // The ASCII index of the '0' character is 48.
1525                 mstore8(str, add(48, mod(temp, 10)))
1526                 // Keep dividing `temp` until zero.
1527                 temp := div(temp, 10)
1528                 // prettier-ignore
1529                 if iszero(temp) { break }
1530             }
1531 
1532             let length := sub(end, str)
1533             // Move the pointer 32 bytes leftwards to make room for the length.
1534             str := sub(str, 0x20)
1535             // Store the length.
1536             mstore(str, length)
1537         }
1538     }
1539 }
1540 
1541 // File: contracts/ChickenBrothko.sol
1542 
1543 pragma solidity ^0.8.9;
1544 
1545 contract ChickenBrothko is ERC721A, Ownable {
1546     uint256 public maxSupply = 666;
1547     uint256 public mintPrice = .002 ether;
1548     uint256 public maxPerTx = 5;
1549     string public baseURI;
1550     bool public mintOpen;
1551 
1552     error SaleNotStarted();
1553     error MaxSupplyExceeded();
1554     error MaxPerTxExceeded();
1555     error WrongPrice();
1556 
1557     constructor(string memory _initMetadataURI) payable ERC721A("ChickenBrothko", "CBRTHK") {
1558         baseURI = _initMetadataURI;
1559     }
1560 
1561     function mint(uint256 _amount) external payable {
1562         if (!mintOpen) revert SaleNotStarted();
1563         if (_totalMinted() + _amount > maxSupply) revert MaxSupplyExceeded();
1564         if (_amount > maxPerTx) revert MaxPerTxExceeded();
1565         if (msg.value < mintPrice * _amount) revert WrongPrice();
1566 
1567         _mint(msg.sender, _amount);
1568     }
1569 
1570     function airdrop(address _receiver, uint256 _amount) external onlyOwner {
1571         _mint(_receiver, _amount);
1572     }
1573 
1574     function tokenURI(uint256 tokenId)
1575         public
1576         view
1577         virtual
1578         override
1579         returns (string memory)
1580     {
1581         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1582         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1583     }
1584 
1585     function _startTokenId() internal pure override returns (uint256) {
1586         return 1;
1587     }
1588 
1589     function _baseURI() internal view virtual override returns (string memory) {
1590         return baseURI;
1591     }
1592 
1593     function setBaseURI(string calldata _newMetadataURI) external onlyOwner {
1594         baseURI = _newMetadataURI;
1595     }
1596 
1597     function setPrice(uint256 _mintPrice) external onlyOwner {
1598         mintPrice = _mintPrice;
1599     }
1600 
1601     function setSupply(uint256 _maxSupply) external onlyOwner {
1602         maxSupply = _maxSupply;
1603     }
1604 
1605     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
1606         maxPerTx = _maxPerTx;
1607     }
1608 
1609     function setMintOpen() external onlyOwner {
1610         mintOpen = !mintOpen;
1611     }
1612 
1613     function withdraw() external onlyOwner {
1614         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1615         require(success, "Transfer failed");
1616     }
1617 }