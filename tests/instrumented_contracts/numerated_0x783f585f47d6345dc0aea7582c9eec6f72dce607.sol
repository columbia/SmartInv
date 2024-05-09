1 //SPDX-License-Identifier: MIT
2 
3 /*
4     ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5     ⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6     ⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
7     ⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀
8     ⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀
9     ⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀
10     ⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀
11     ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
12     ⠈⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀
13     ⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣠⣤⡶⠀
14     ⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠛⠋⠀⢀⣿⣿⡇⠀
15     ⠀⠀⠀⠀⠀⠻⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣏⣁⠀⠀⢠⣿⣿⣿⣿⣿⣇⡀
16     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢉⣼⣿⣿⣿⣿⣿⣿⣿⣾⣿⡏⠁⢹⣿⣿⣿⣷
17     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⢠⣼⣿⣿⣿⣿
18     ⠀⠀⠀⠀⠀⠀⢀⣤⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣿⣿⡿
19     ⠀⠀⠀⠀⣀⣤⣾⣿⠟⢹⣿⣿⣿⣿⣿⣿⣿⣿⣷⣁⠈⢻⣿⣎⣉⠉⠉⠀
20     ⠀⠀⢰⣾⣿⣿⢿⣿⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⣿⣿⣿⣿⣦⣄
21     ⠀⠀⢾⣿⡏⠀⠸⠿⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠈⠻⢿⣿⣿⣷
22     ⠀⠀⠈⠿⠇⠀⠀⠀⠀⠈⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣄⠀⠀⠙⠿⠇
23     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀
24     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⠿⢋⣿⣿⣿⣿⣿⣧⠀⠀⠀
25     ⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⣶⣤⣾⣿⣿⣿⠇⠀⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀
26     ⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠘⢿⣿⡿⠿⠟⠋⠀⠀⠀
27 
28                                                                                                                       
29  _ _ _ _____    __    _____ _____ _____    _ _ _ _____    __    _____ _____ _____    _ _ _ _____    __    _____ _____ 
30 | | | |   __|  |  |  |     |  |  |   __|  | | | |   __|  |  |  |     |  |  |   __|  | | | |   __|  |  |  |     |   __|
31 | | | |   __|  |  |__|-   -|  |  |   __|  | | | |   __|  |  |__|  |  |  |  |   __|  | | | |   __|  |  |__|-   -|   __|
32 |_____|_____|  |_____|_____|\___/|_____|  |_____|_____|  |_____|_____|\___/|_____|  |_____|_____|  |_____|_____|_____|
33                                                                                                                       
34 */
35 
36 // File: @openzeppelin/contracts/utils/Context.sol
37 
38 
39 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Provides information about the current execution context, including the
45  * sender of the transaction and its data. While these are generally available
46  * via msg.sender and msg.data, they should not be accessed in such a direct
47  * manner, since when dealing with meta-transactions the account sending and
48  * paying for execution may not be the actual sender (as far as an application
49  * is concerned).
50  *
51  * This contract is only required for intermediate, library-like contracts.
52  */
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         return msg.data;
60     }
61 }
62 
63 // File: @openzeppelin/contracts/access/Ownable.sol
64 
65 
66 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _transferOwnership(_msgSender());
93     }
94 
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     modifier onlyOwner() {
99         _checkOwner();
100         _;
101     }
102 
103     /**
104      * @dev Returns the address of the current owner.
105      */
106     function owner() public view virtual returns (address) {
107         return _owner;
108     }
109 
110     /**
111      * @dev Throws if the sender is not the owner.
112      */
113     function _checkOwner() internal view virtual {
114         require(owner() == _msgSender(), "Ownable: caller is not the owner");
115     }
116 
117     /**
118      * @dev Leaves the contract without owner. It will not be possible to call
119      * `onlyOwner` functions. Can only be called by the current owner.
120      *
121      * NOTE: Renouncing ownership will leave the contract without an owner,
122      * thereby disabling any functionality that is only available to the owner.
123      */
124     function renounceOwnership() public virtual onlyOwner {
125         _transferOwnership(address(0));
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      * Can only be called by the current owner.
131      */
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         _transferOwnership(newOwner);
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Internal function without access restriction.
140      */
141     function _transferOwnership(address newOwner) internal virtual {
142         address oldOwner = _owner;
143         _owner = newOwner;
144         emit OwnershipTransferred(oldOwner, newOwner);
145     }
146 }
147 
148 // File: erc721a/contracts/IERC721A.sol
149 
150 
151 // ERC721A Contracts v4.2.3
152 // Creator: Chiru Labs
153 
154 pragma solidity ^0.8.4;
155 
156 /**
157  * @dev Interface of ERC721A.
158  */
159 interface IERC721A {
160     /**
161      * The caller must own the token or be an approved operator.
162      */
163     error ApprovalCallerNotOwnerNorApproved();
164 
165     /**
166      * The token does not exist.
167      */
168     error ApprovalQueryForNonexistentToken();
169 
170     /**
171      * Cannot query the balance for the zero address.
172      */
173     error BalanceQueryForZeroAddress();
174 
175     /**
176      * Cannot mint to the zero address.
177      */
178     error MintToZeroAddress();
179 
180     /**
181      * The quantity of tokens minted must be more than zero.
182      */
183     error MintZeroQuantity();
184 
185     /**
186      * The token does not exist.
187      */
188     error OwnerQueryForNonexistentToken();
189 
190     /**
191      * The caller must own the token or be an approved operator.
192      */
193     error TransferCallerNotOwnerNorApproved();
194 
195     /**
196      * The token must be owned by `from`.
197      */
198     error TransferFromIncorrectOwner();
199 
200     /**
201      * Cannot safely transfer to a contract that does not implement the
202      * ERC721Receiver interface.
203      */
204     error TransferToNonERC721ReceiverImplementer();
205 
206     /**
207      * Cannot transfer to the zero address.
208      */
209     error TransferToZeroAddress();
210 
211     /**
212      * The token does not exist.
213      */
214     error URIQueryForNonexistentToken();
215 
216     /**
217      * The `quantity` minted with ERC2309 exceeds the safety limit.
218      */
219     error MintERC2309QuantityExceedsLimit();
220 
221     /**
222      * The `extraData` cannot be set on an unintialized ownership slot.
223      */
224     error OwnershipNotInitializedForExtraData();
225 
226     // =============================================================
227     //                            STRUCTS
228     // =============================================================
229 
230     struct TokenOwnership {
231         // The address of the owner.
232         address addr;
233         // Stores the start time of ownership with minimal overhead for tokenomics.
234         uint64 startTimestamp;
235         // Whether the token has been burned.
236         bool burned;
237         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
238         uint24 extraData;
239     }
240 
241     // =============================================================
242     //                         TOKEN COUNTERS
243     // =============================================================
244 
245     /**
246      * @dev Returns the total number of tokens in existence.
247      * Burned tokens will reduce the count.
248      * To get the total number of tokens minted, please see {_totalMinted}.
249      */
250     function totalSupply() external view returns (uint256);
251 
252     // =============================================================
253     //                            IERC165
254     // =============================================================
255 
256     /**
257      * @dev Returns true if this contract implements the interface defined by
258      * `interfaceId`. See the corresponding
259      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
260      * to learn more about how these ids are created.
261      *
262      * This function call must use less than 30000 gas.
263      */
264     function supportsInterface(bytes4 interfaceId) external view returns (bool);
265 
266     // =============================================================
267     //                            IERC721
268     // =============================================================
269 
270     /**
271      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
272      */
273     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
274 
275     /**
276      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
277      */
278     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
279 
280     /**
281      * @dev Emitted when `owner` enables or disables
282      * (`approved`) `operator` to manage all of its assets.
283      */
284     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
285 
286     /**
287      * @dev Returns the number of tokens in `owner`'s account.
288      */
289     function balanceOf(address owner) external view returns (uint256 balance);
290 
291     /**
292      * @dev Returns the owner of the `tokenId` token.
293      *
294      * Requirements:
295      *
296      * - `tokenId` must exist.
297      */
298     function ownerOf(uint256 tokenId) external view returns (address owner);
299 
300     /**
301      * @dev Safely transfers `tokenId` token from `from` to `to`,
302      * checking first that contract recipients are aware of the ERC721 protocol
303      * to prevent tokens from being forever locked.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must exist and be owned by `from`.
310      * - If the caller is not `from`, it must be have been allowed to move
311      * this token by either {approve} or {setApprovalForAll}.
312      * - If `to` refers to a smart contract, it must implement
313      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
314      *
315      * Emits a {Transfer} event.
316      */
317     function safeTransferFrom(
318         address from,
319         address to,
320         uint256 tokenId,
321         bytes calldata data
322     ) external payable;
323 
324     /**
325      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
326      */
327     function safeTransferFrom(
328         address from,
329         address to,
330         uint256 tokenId
331     ) external payable;
332 
333     /**
334      * @dev Transfers `tokenId` from `from` to `to`.
335      *
336      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
337      * whenever possible.
338      *
339      * Requirements:
340      *
341      * - `from` cannot be the zero address.
342      * - `to` cannot be the zero address.
343      * - `tokenId` token must be owned by `from`.
344      * - If the caller is not `from`, it must be approved to move this token
345      * by either {approve} or {setApprovalForAll}.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transferFrom(
350         address from,
351         address to,
352         uint256 tokenId
353     ) external payable;
354 
355     /**
356      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
357      * The approval is cleared when the token is transferred.
358      *
359      * Only a single account can be approved at a time, so approving the
360      * zero address clears previous approvals.
361      *
362      * Requirements:
363      *
364      * - The caller must own the token or be an approved operator.
365      * - `tokenId` must exist.
366      *
367      * Emits an {Approval} event.
368      */
369     function approve(address to, uint256 tokenId) external payable;
370 
371     /**
372      * @dev Approve or remove `operator` as an operator for the caller.
373      * Operators can call {transferFrom} or {safeTransferFrom}
374      * for any token owned by the caller.
375      *
376      * Requirements:
377      *
378      * - The `operator` cannot be the caller.
379      *
380      * Emits an {ApprovalForAll} event.
381      */
382     function setApprovalForAll(address operator, bool _approved) external;
383 
384     /**
385      * @dev Returns the account approved for `tokenId` token.
386      *
387      * Requirements:
388      *
389      * - `tokenId` must exist.
390      */
391     function getApproved(uint256 tokenId) external view returns (address operator);
392 
393     /**
394      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
395      *
396      * See {setApprovalForAll}.
397      */
398     function isApprovedForAll(address owner, address operator) external view returns (bool);
399 
400     // =============================================================
401     //                        IERC721Metadata
402     // =============================================================
403 
404     /**
405      * @dev Returns the token collection name.
406      */
407     function name() external view returns (string memory);
408 
409     /**
410      * @dev Returns the token collection symbol.
411      */
412     function symbol() external view returns (string memory);
413 
414     /**
415      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
416      */
417     function tokenURI(uint256 tokenId) external view returns (string memory);
418 
419     // =============================================================
420     //                           IERC2309
421     // =============================================================
422 
423     /**
424      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
425      * (inclusive) is transferred from `from` to `to`, as defined in the
426      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
427      *
428      * See {_mintERC2309} for more details.
429      */
430     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
431 }
432 
433 // File: erc721a/contracts/ERC721A.sol
434 
435 
436 // ERC721A Contracts v4.2.3
437 // Creator: Chiru Labs
438 
439 pragma solidity ^0.8.4;
440 
441 
442 /**
443  * @dev Interface of ERC721 token receiver.
444  */
445 interface ERC721A__IERC721Receiver {
446     function onERC721Received(
447         address operator,
448         address from,
449         uint256 tokenId,
450         bytes calldata data
451     ) external returns (bytes4);
452 }
453 
454 /**
455  * @title ERC721A
456  *
457  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
458  * Non-Fungible Token Standard, including the Metadata extension.
459  * Optimized for lower gas during batch mints.
460  *
461  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
462  * starting from `_startTokenId()`.
463  *
464  * Assumptions:
465  *
466  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
467  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
468  */
469 contract ERC721A is IERC721A {
470     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
471     struct TokenApprovalRef {
472         address value;
473     }
474 
475     // =============================================================
476     //                           CONSTANTS
477     // =============================================================
478 
479     // Mask of an entry in packed address data.
480     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
481 
482     // The bit position of `numberMinted` in packed address data.
483     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
484 
485     // The bit position of `numberBurned` in packed address data.
486     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
487 
488     // The bit position of `aux` in packed address data.
489     uint256 private constant _BITPOS_AUX = 192;
490 
491     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
492     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
493 
494     // The bit position of `startTimestamp` in packed ownership.
495     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
496 
497     // The bit mask of the `burned` bit in packed ownership.
498     uint256 private constant _BITMASK_BURNED = 1 << 224;
499 
500     // The bit position of the `nextInitialized` bit in packed ownership.
501     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
502 
503     // The bit mask of the `nextInitialized` bit in packed ownership.
504     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
505 
506     // The bit position of `extraData` in packed ownership.
507     uint256 private constant _BITPOS_EXTRA_DATA = 232;
508 
509     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
510     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
511 
512     // The mask of the lower 160 bits for addresses.
513     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
514 
515     // The maximum `quantity` that can be minted with {_mintERC2309}.
516     // This limit is to prevent overflows on the address data entries.
517     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
518     // is required to cause an overflow, which is unrealistic.
519     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
520 
521     // The `Transfer` event signature is given by:
522     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
523     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
524         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
525 
526     // =============================================================
527     //                            STORAGE
528     // =============================================================
529 
530     // The next token ID to be minted.
531     uint256 private _currentIndex;
532 
533     // The number of tokens burned.
534     uint256 private _burnCounter;
535 
536     // Token name
537     string private _name;
538 
539     // Token symbol
540     string private _symbol;
541 
542     // Mapping from token ID to ownership details
543     // An empty struct value does not necessarily mean the token is unowned.
544     // See {_packedOwnershipOf} implementation for details.
545     //
546     // Bits Layout:
547     // - [0..159]   `addr`
548     // - [160..223] `startTimestamp`
549     // - [224]      `burned`
550     // - [225]      `nextInitialized`
551     // - [232..255] `extraData`
552     mapping(uint256 => uint256) private _packedOwnerships;
553 
554     // Mapping owner address to address data.
555     //
556     // Bits Layout:
557     // - [0..63]    `balance`
558     // - [64..127]  `numberMinted`
559     // - [128..191] `numberBurned`
560     // - [192..255] `aux`
561     mapping(address => uint256) private _packedAddressData;
562 
563     // Mapping from token ID to approved address.
564     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
565 
566     // Mapping from owner to operator approvals
567     mapping(address => mapping(address => bool)) private _operatorApprovals;
568 
569     // =============================================================
570     //                          CONSTRUCTOR
571     // =============================================================
572 
573     constructor(string memory name_, string memory symbol_) {
574         _name = name_;
575         _symbol = symbol_;
576         _currentIndex = _startTokenId();
577     }
578 
579     // =============================================================
580     //                   TOKEN COUNTING OPERATIONS
581     // =============================================================
582 
583     /**
584      * @dev Returns the starting token ID.
585      * To change the starting token ID, please override this function.
586      */
587     function _startTokenId() internal view virtual returns (uint256) {
588         return 0;
589     }
590 
591     /**
592      * @dev Returns the next token ID to be minted.
593      */
594     function _nextTokenId() internal view virtual returns (uint256) {
595         return _currentIndex;
596     }
597 
598     /**
599      * @dev Returns the total number of tokens in existence.
600      * Burned tokens will reduce the count.
601      * To get the total number of tokens minted, please see {_totalMinted}.
602      */
603     function totalSupply() public view virtual override returns (uint256) {
604         // Counter underflow is impossible as _burnCounter cannot be incremented
605         // more than `_currentIndex - _startTokenId()` times.
606         unchecked {
607             return _currentIndex - _burnCounter - _startTokenId();
608         }
609     }
610 
611     /**
612      * @dev Returns the total amount of tokens minted in the contract.
613      */
614     function _totalMinted() internal view virtual returns (uint256) {
615         // Counter underflow is impossible as `_currentIndex` does not decrement,
616         // and it is initialized to `_startTokenId()`.
617         unchecked {
618             return _currentIndex - _startTokenId();
619         }
620     }
621 
622     /**
623      * @dev Returns the total number of tokens burned.
624      */
625     function _totalBurned() internal view virtual returns (uint256) {
626         return _burnCounter;
627     }
628 
629     // =============================================================
630     //                    ADDRESS DATA OPERATIONS
631     // =============================================================
632 
633     /**
634      * @dev Returns the number of tokens in `owner`'s account.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         if (owner == address(0)) revert BalanceQueryForZeroAddress();
638         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
639     }
640 
641     /**
642      * Returns the number of tokens minted by `owner`.
643      */
644     function _numberMinted(address owner) internal view returns (uint256) {
645         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
646     }
647 
648     /**
649      * Returns the number of tokens burned by or on behalf of `owner`.
650      */
651     function _numberBurned(address owner) internal view returns (uint256) {
652         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
653     }
654 
655     /**
656      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
657      */
658     function _getAux(address owner) internal view returns (uint64) {
659         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
660     }
661 
662     /**
663      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
664      * If there are multiple variables, please pack them into a uint64.
665      */
666     function _setAux(address owner, uint64 aux) internal virtual {
667         uint256 packed = _packedAddressData[owner];
668         uint256 auxCasted;
669         // Cast `aux` with assembly to avoid redundant masking.
670         assembly {
671             auxCasted := aux
672         }
673         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
674         _packedAddressData[owner] = packed;
675     }
676 
677     // =============================================================
678     //                            IERC165
679     // =============================================================
680 
681     /**
682      * @dev Returns true if this contract implements the interface defined by
683      * `interfaceId`. See the corresponding
684      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
685      * to learn more about how these ids are created.
686      *
687      * This function call must use less than 30000 gas.
688      */
689     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690         // The interface IDs are constants representing the first 4 bytes
691         // of the XOR of all function selectors in the interface.
692         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
693         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
694         return
695             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
696             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
697             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
698     }
699 
700     // =============================================================
701     //                        IERC721Metadata
702     // =============================================================
703 
704     /**
705      * @dev Returns the token collection name.
706      */
707     function name() public view virtual override returns (string memory) {
708         return _name;
709     }
710 
711     /**
712      * @dev Returns the token collection symbol.
713      */
714     function symbol() public view virtual override returns (string memory) {
715         return _symbol;
716     }
717 
718     /**
719      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
720      */
721     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
722         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
723 
724         string memory baseURI = _baseURI();
725         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
726     }
727 
728     /**
729      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
730      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
731      * by default, it can be overridden in child contracts.
732      */
733     function _baseURI() internal view virtual returns (string memory) {
734         return '';
735     }
736 
737     // =============================================================
738     //                     OWNERSHIPS OPERATIONS
739     // =============================================================
740 
741     /**
742      * @dev Returns the owner of the `tokenId` token.
743      *
744      * Requirements:
745      *
746      * - `tokenId` must exist.
747      */
748     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
749         return address(uint160(_packedOwnershipOf(tokenId)));
750     }
751 
752     /**
753      * @dev Gas spent here starts off proportional to the maximum mint batch size.
754      * It gradually moves to O(1) as tokens get transferred around over time.
755      */
756     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
757         return _unpackedOwnership(_packedOwnershipOf(tokenId));
758     }
759 
760     /**
761      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
762      */
763     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
764         return _unpackedOwnership(_packedOwnerships[index]);
765     }
766 
767     /**
768      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
769      */
770     function _initializeOwnershipAt(uint256 index) internal virtual {
771         if (_packedOwnerships[index] == 0) {
772             _packedOwnerships[index] = _packedOwnershipOf(index);
773         }
774     }
775 
776     /**
777      * Returns the packed ownership data of `tokenId`.
778      */
779     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
780         uint256 curr = tokenId;
781 
782         unchecked {
783             if (_startTokenId() <= curr)
784                 if (curr < _currentIndex) {
785                     uint256 packed = _packedOwnerships[curr];
786                     // If not burned.
787                     if (packed & _BITMASK_BURNED == 0) {
788                         // Invariant:
789                         // There will always be an initialized ownership slot
790                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
791                         // before an unintialized ownership slot
792                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
793                         // Hence, `curr` will not underflow.
794                         //
795                         // We can directly compare the packed value.
796                         // If the address is zero, packed will be zero.
797                         while (packed == 0) {
798                             packed = _packedOwnerships[--curr];
799                         }
800                         return packed;
801                     }
802                 }
803         }
804         revert OwnerQueryForNonexistentToken();
805     }
806 
807     /**
808      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
809      */
810     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
811         ownership.addr = address(uint160(packed));
812         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
813         ownership.burned = packed & _BITMASK_BURNED != 0;
814         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
815     }
816 
817     /**
818      * @dev Packs ownership data into a single uint256.
819      */
820     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
821         assembly {
822             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
823             owner := and(owner, _BITMASK_ADDRESS)
824             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
825             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
826         }
827     }
828 
829     /**
830      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
831      */
832     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
833         // For branchless setting of the `nextInitialized` flag.
834         assembly {
835             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
836             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
837         }
838     }
839 
840     // =============================================================
841     //                      APPROVAL OPERATIONS
842     // =============================================================
843 
844     /**
845      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
846      * The approval is cleared when the token is transferred.
847      *
848      * Only a single account can be approved at a time, so approving the
849      * zero address clears previous approvals.
850      *
851      * Requirements:
852      *
853      * - The caller must own the token or be an approved operator.
854      * - `tokenId` must exist.
855      *
856      * Emits an {Approval} event.
857      */
858     function approve(address to, uint256 tokenId) public payable virtual override {
859         address owner = ownerOf(tokenId);
860 
861         if (_msgSenderERC721A() != owner)
862             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
863                 revert ApprovalCallerNotOwnerNorApproved();
864             }
865 
866         _tokenApprovals[tokenId].value = to;
867         emit Approval(owner, to, tokenId);
868     }
869 
870     /**
871      * @dev Returns the account approved for `tokenId` token.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      */
877     function getApproved(uint256 tokenId) public view virtual override returns (address) {
878         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
879 
880         return _tokenApprovals[tokenId].value;
881     }
882 
883     /**
884      * @dev Approve or remove `operator` as an operator for the caller.
885      * Operators can call {transferFrom} or {safeTransferFrom}
886      * for any token owned by the caller.
887      *
888      * Requirements:
889      *
890      * - The `operator` cannot be the caller.
891      *
892      * Emits an {ApprovalForAll} event.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
896         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
897     }
898 
899     /**
900      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
901      *
902      * See {setApprovalForAll}.
903      */
904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
905         return _operatorApprovals[owner][operator];
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted. See {_mint}.
914      */
915     function _exists(uint256 tokenId) internal view virtual returns (bool) {
916         return
917             _startTokenId() <= tokenId &&
918             tokenId < _currentIndex && // If within bounds,
919             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
920     }
921 
922     /**
923      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
924      */
925     function _isSenderApprovedOrOwner(
926         address approvedAddress,
927         address owner,
928         address msgSender
929     ) private pure returns (bool result) {
930         assembly {
931             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
932             owner := and(owner, _BITMASK_ADDRESS)
933             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
934             msgSender := and(msgSender, _BITMASK_ADDRESS)
935             // `msgSender == owner || msgSender == approvedAddress`.
936             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
937         }
938     }
939 
940     /**
941      * @dev Returns the storage slot and value for the approved address of `tokenId`.
942      */
943     function _getApprovedSlotAndAddress(uint256 tokenId)
944         private
945         view
946         returns (uint256 approvedAddressSlot, address approvedAddress)
947     {
948         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
949         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
950         assembly {
951             approvedAddressSlot := tokenApproval.slot
952             approvedAddress := sload(approvedAddressSlot)
953         }
954     }
955 
956     // =============================================================
957     //                      TRANSFER OPERATIONS
958     // =============================================================
959 
960     /**
961      * @dev Transfers `tokenId` from `from` to `to`.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must be owned by `from`.
968      * - If the caller is not `from`, it must be approved to move this token
969      * by either {approve} or {setApprovalForAll}.
970      *
971      * Emits a {Transfer} event.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public payable virtual override {
978         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
979 
980         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
981 
982         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
983 
984         // The nested ifs save around 20+ gas over a compound boolean condition.
985         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
986             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
987 
988         if (to == address(0)) revert TransferToZeroAddress();
989 
990         _beforeTokenTransfers(from, to, tokenId, 1);
991 
992         // Clear approvals from the previous owner.
993         assembly {
994             if approvedAddress {
995                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
996                 sstore(approvedAddressSlot, 0)
997             }
998         }
999 
1000         // Underflow of the sender's balance is impossible because we check for
1001         // ownership above and the recipient's balance can't realistically overflow.
1002         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1003         unchecked {
1004             // We can directly increment and decrement the balances.
1005             --_packedAddressData[from]; // Updates: `balance -= 1`.
1006             ++_packedAddressData[to]; // Updates: `balance += 1`.
1007 
1008             // Updates:
1009             // - `address` to the next owner.
1010             // - `startTimestamp` to the timestamp of transfering.
1011             // - `burned` to `false`.
1012             // - `nextInitialized` to `true`.
1013             _packedOwnerships[tokenId] = _packOwnershipData(
1014                 to,
1015                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1016             );
1017 
1018             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1019             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1020                 uint256 nextTokenId = tokenId + 1;
1021                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1022                 if (_packedOwnerships[nextTokenId] == 0) {
1023                     // If the next slot is within bounds.
1024                     if (nextTokenId != _currentIndex) {
1025                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1026                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1027                     }
1028                 }
1029             }
1030         }
1031 
1032         emit Transfer(from, to, tokenId);
1033         _afterTokenTransfers(from, to, tokenId, 1);
1034     }
1035 
1036     /**
1037      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public payable virtual override {
1044         safeTransferFrom(from, to, tokenId, '');
1045     }
1046 
1047     /**
1048      * @dev Safely transfers `tokenId` token from `from` to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `from` cannot be the zero address.
1053      * - `to` cannot be the zero address.
1054      * - `tokenId` token must exist and be owned by `from`.
1055      * - If the caller is not `from`, it must be approved to move this token
1056      * by either {approve} or {setApprovalForAll}.
1057      * - If `to` refers to a smart contract, it must implement
1058      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) public payable virtual override {
1068         transferFrom(from, to, tokenId);
1069         if (to.code.length != 0)
1070             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1071                 revert TransferToNonERC721ReceiverImplementer();
1072             }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before a set of serially-ordered token IDs
1077      * are about to be transferred. This includes minting.
1078      * And also called before burning one token.
1079      *
1080      * `startTokenId` - the first token ID to be transferred.
1081      * `quantity` - the amount to be transferred.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, `tokenId` will be burned by `from`.
1089      * - `from` and `to` are never both zero.
1090      */
1091     function _beforeTokenTransfers(
1092         address from,
1093         address to,
1094         uint256 startTokenId,
1095         uint256 quantity
1096     ) internal virtual {}
1097 
1098     /**
1099      * @dev Hook that is called after a set of serially-ordered token IDs
1100      * have been transferred. This includes minting.
1101      * And also called after one token has been burned.
1102      *
1103      * `startTokenId` - the first token ID to be transferred.
1104      * `quantity` - the amount to be transferred.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` has been minted for `to`.
1111      * - When `to` is zero, `tokenId` has been burned by `from`.
1112      * - `from` and `to` are never both zero.
1113      */
1114     function _afterTokenTransfers(
1115         address from,
1116         address to,
1117         uint256 startTokenId,
1118         uint256 quantity
1119     ) internal virtual {}
1120 
1121     /**
1122      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1123      *
1124      * `from` - Previous owner of the given token ID.
1125      * `to` - Target address that will receive the token.
1126      * `tokenId` - Token ID to be transferred.
1127      * `_data` - Optional data to send along with the call.
1128      *
1129      * Returns whether the call correctly returned the expected magic value.
1130      */
1131     function _checkContractOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) private returns (bool) {
1137         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1138             bytes4 retval
1139         ) {
1140             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1141         } catch (bytes memory reason) {
1142             if (reason.length == 0) {
1143                 revert TransferToNonERC721ReceiverImplementer();
1144             } else {
1145                 assembly {
1146                     revert(add(32, reason), mload(reason))
1147                 }
1148             }
1149         }
1150     }
1151 
1152     // =============================================================
1153     //                        MINT OPERATIONS
1154     // =============================================================
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
1166     function _mint(address to, uint256 quantity) internal virtual {
1167         uint256 startTokenId = _currentIndex;
1168         if (quantity == 0) revert MintZeroQuantity();
1169 
1170         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1171 
1172         // Overflows are incredibly unrealistic.
1173         // `balance` and `numberMinted` have a maximum limit of 2**64.
1174         // `tokenId` has a maximum limit of 2**256.
1175         unchecked {
1176             // Updates:
1177             // - `balance += quantity`.
1178             // - `numberMinted += quantity`.
1179             //
1180             // We can directly add to the `balance` and `numberMinted`.
1181             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1182 
1183             // Updates:
1184             // - `address` to the owner.
1185             // - `startTimestamp` to the timestamp of minting.
1186             // - `burned` to `false`.
1187             // - `nextInitialized` to `quantity == 1`.
1188             _packedOwnerships[startTokenId] = _packOwnershipData(
1189                 to,
1190                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1191             );
1192 
1193             uint256 toMasked;
1194             uint256 end = startTokenId + quantity;
1195 
1196             // Use assembly to loop and emit the `Transfer` event for gas savings.
1197             // The duplicated `log4` removes an extra check and reduces stack juggling.
1198             // The assembly, together with the surrounding Solidity code, have been
1199             // delicately arranged to nudge the compiler into producing optimized opcodes.
1200             assembly {
1201                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1202                 toMasked := and(to, _BITMASK_ADDRESS)
1203                 // Emit the `Transfer` event.
1204                 log4(
1205                     0, // Start of data (0, since no data).
1206                     0, // End of data (0, since no data).
1207                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1208                     0, // `address(0)`.
1209                     toMasked, // `to`.
1210                     startTokenId // `tokenId`.
1211                 )
1212 
1213                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1214                 // that overflows uint256 will make the loop run out of gas.
1215                 // The compiler will optimize the `iszero` away for performance.
1216                 for {
1217                     let tokenId := add(startTokenId, 1)
1218                 } iszero(eq(tokenId, end)) {
1219                     tokenId := add(tokenId, 1)
1220                 } {
1221                     // Emit the `Transfer` event. Similar to above.
1222                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1223                 }
1224             }
1225             if (toMasked == 0) revert MintToZeroAddress();
1226 
1227             _currentIndex = end;
1228         }
1229         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1230     }
1231 
1232     /**
1233      * @dev Mints `quantity` tokens and transfers them to `to`.
1234      *
1235      * This function is intended for efficient minting only during contract creation.
1236      *
1237      * It emits only one {ConsecutiveTransfer} as defined in
1238      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1239      * instead of a sequence of {Transfer} event(s).
1240      *
1241      * Calling this function outside of contract creation WILL make your contract
1242      * non-compliant with the ERC721 standard.
1243      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1244      * {ConsecutiveTransfer} event is only permissible during contract creation.
1245      *
1246      * Requirements:
1247      *
1248      * - `to` cannot be the zero address.
1249      * - `quantity` must be greater than 0.
1250      *
1251      * Emits a {ConsecutiveTransfer} event.
1252      */
1253     function _mintERC2309(address to, uint256 quantity) internal virtual {
1254         uint256 startTokenId = _currentIndex;
1255         if (to == address(0)) revert MintToZeroAddress();
1256         if (quantity == 0) revert MintZeroQuantity();
1257         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1258 
1259         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1260 
1261         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1262         unchecked {
1263             // Updates:
1264             // - `balance += quantity`.
1265             // - `numberMinted += quantity`.
1266             //
1267             // We can directly add to the `balance` and `numberMinted`.
1268             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1269 
1270             // Updates:
1271             // - `address` to the owner.
1272             // - `startTimestamp` to the timestamp of minting.
1273             // - `burned` to `false`.
1274             // - `nextInitialized` to `quantity == 1`.
1275             _packedOwnerships[startTokenId] = _packOwnershipData(
1276                 to,
1277                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1278             );
1279 
1280             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1281 
1282             _currentIndex = startTokenId + quantity;
1283         }
1284         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1285     }
1286 
1287     /**
1288      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * Requirements:
1291      *
1292      * - If `to` refers to a smart contract, it must implement
1293      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1294      * - `quantity` must be greater than 0.
1295      *
1296      * See {_mint}.
1297      *
1298      * Emits a {Transfer} event for each mint.
1299      */
1300     function _safeMint(
1301         address to,
1302         uint256 quantity,
1303         bytes memory _data
1304     ) internal virtual {
1305         _mint(to, quantity);
1306 
1307         unchecked {
1308             if (to.code.length != 0) {
1309                 uint256 end = _currentIndex;
1310                 uint256 index = end - quantity;
1311                 do {
1312                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1313                         revert TransferToNonERC721ReceiverImplementer();
1314                     }
1315                 } while (index < end);
1316                 // Reentrancy protection.
1317                 if (_currentIndex != end) revert();
1318             }
1319         }
1320     }
1321 
1322     /**
1323      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1324      */
1325     function _safeMint(address to, uint256 quantity) internal virtual {
1326         _safeMint(to, quantity, '');
1327     }
1328 
1329     // =============================================================
1330     //                        BURN OPERATIONS
1331     // =============================================================
1332 
1333     /**
1334      * @dev Equivalent to `_burn(tokenId, false)`.
1335      */
1336     function _burn(uint256 tokenId) internal virtual {
1337         _burn(tokenId, false);
1338     }
1339 
1340     /**
1341      * @dev Destroys `tokenId`.
1342      * The approval is cleared when the token is burned.
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must exist.
1347      *
1348      * Emits a {Transfer} event.
1349      */
1350     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1351         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1352 
1353         address from = address(uint160(prevOwnershipPacked));
1354 
1355         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1356 
1357         if (approvalCheck) {
1358             // The nested ifs save around 20+ gas over a compound boolean condition.
1359             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1360                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1361         }
1362 
1363         _beforeTokenTransfers(from, address(0), tokenId, 1);
1364 
1365         // Clear approvals from the previous owner.
1366         assembly {
1367             if approvedAddress {
1368                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1369                 sstore(approvedAddressSlot, 0)
1370             }
1371         }
1372 
1373         // Underflow of the sender's balance is impossible because we check for
1374         // ownership above and the recipient's balance can't realistically overflow.
1375         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1376         unchecked {
1377             // Updates:
1378             // - `balance -= 1`.
1379             // - `numberBurned += 1`.
1380             //
1381             // We can directly decrement the balance, and increment the number burned.
1382             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1383             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1384 
1385             // Updates:
1386             // - `address` to the last owner.
1387             // - `startTimestamp` to the timestamp of burning.
1388             // - `burned` to `true`.
1389             // - `nextInitialized` to `true`.
1390             _packedOwnerships[tokenId] = _packOwnershipData(
1391                 from,
1392                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1393             );
1394 
1395             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1396             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1397                 uint256 nextTokenId = tokenId + 1;
1398                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1399                 if (_packedOwnerships[nextTokenId] == 0) {
1400                     // If the next slot is within bounds.
1401                     if (nextTokenId != _currentIndex) {
1402                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1403                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1404                     }
1405                 }
1406             }
1407         }
1408 
1409         emit Transfer(from, address(0), tokenId);
1410         _afterTokenTransfers(from, address(0), tokenId, 1);
1411 
1412         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1413         unchecked {
1414             _burnCounter++;
1415         }
1416     }
1417 
1418     // =============================================================
1419     //                     EXTRA DATA OPERATIONS
1420     // =============================================================
1421 
1422     /**
1423      * @dev Directly sets the extra data for the ownership data `index`.
1424      */
1425     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1426         uint256 packed = _packedOwnerships[index];
1427         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1428         uint256 extraDataCasted;
1429         // Cast `extraData` with assembly to avoid redundant masking.
1430         assembly {
1431             extraDataCasted := extraData
1432         }
1433         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1434         _packedOwnerships[index] = packed;
1435     }
1436 
1437     /**
1438      * @dev Called during each token transfer to set the 24bit `extraData` field.
1439      * Intended to be overridden by the cosumer contract.
1440      *
1441      * `previousExtraData` - the value of `extraData` before transfer.
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      * - When `to` is zero, `tokenId` will be burned by `from`.
1449      * - `from` and `to` are never both zero.
1450      */
1451     function _extraData(
1452         address from,
1453         address to,
1454         uint24 previousExtraData
1455     ) internal view virtual returns (uint24) {}
1456 
1457     /**
1458      * @dev Returns the next extra data for the packed ownership data.
1459      * The returned result is shifted into position.
1460      */
1461     function _nextExtraData(
1462         address from,
1463         address to,
1464         uint256 prevOwnershipPacked
1465     ) private view returns (uint256) {
1466         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1467         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1468     }
1469 
1470     // =============================================================
1471     //                       OTHER OPERATIONS
1472     // =============================================================
1473 
1474     /**
1475      * @dev Returns the message sender (defaults to `msg.sender`).
1476      *
1477      * If you are writing GSN compatible contracts, you need to override this function.
1478      */
1479     function _msgSenderERC721A() internal view virtual returns (address) {
1480         return msg.sender;
1481     }
1482 
1483     /**
1484      * @dev Converts a uint256 to its ASCII string decimal representation.
1485      */
1486     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1487         assembly {
1488             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1489             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1490             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1491             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1492             let m := add(mload(0x40), 0xa0)
1493             // Update the free memory pointer to allocate.
1494             mstore(0x40, m)
1495             // Assign the `str` to the end.
1496             str := sub(m, 0x20)
1497             // Zeroize the slot after the string.
1498             mstore(str, 0)
1499 
1500             // Cache the end of the memory to calculate the length later.
1501             let end := str
1502 
1503             // We write the string from rightmost digit to leftmost digit.
1504             // The following is essentially a do-while loop that also handles the zero case.
1505             // prettier-ignore
1506             for { let temp := value } 1 {} {
1507                 str := sub(str, 1)
1508                 // Write the character to the pointer.
1509                 // The ASCII index of the '0' character is 48.
1510                 mstore8(str, add(48, mod(temp, 10)))
1511                 // Keep dividing `temp` until zero.
1512                 temp := div(temp, 10)
1513                 // prettier-ignore
1514                 if iszero(temp) { break }
1515             }
1516 
1517             let length := sub(end, str)
1518             // Move the pointer 32 bytes leftwards to make room for the length.
1519             str := sub(str, 0x20)
1520             // Store the length.
1521             mstore(str, length)
1522         }
1523     }
1524 }
1525 
1526 // File: contracts/SmurfCats.sol
1527 
1528 
1529 pragma solidity ^0.8.20;
1530 
1531 
1532 contract SmurfCats is ERC721A, Ownable {
1533     uint256 public maxSupply = 3000;
1534     uint256 public cost = .001 ether;
1535     uint256 public maxPerTx = 5;
1536     uint256 public maxFree = 1;
1537     string public baseURI;
1538     bool public sale;
1539     mapping(address => uint256) public _mintCounter;
1540 
1541     error SaleNotStarted();
1542     error MaxSupplyExceeded();
1543     error MaxPerTxExceeded();
1544     error WrongPrice();
1545 
1546     constructor(string memory _initMetadataURI)
1547         payable
1548         ERC721A("Smurf Cats", "SC")
1549     {
1550         baseURI = _initMetadataURI;
1551     }
1552 
1553     function mint(uint256 _amount) external payable {
1554         if (!sale) revert SaleNotStarted();
1555 
1556         uint256 _cost = (msg.value == 0 &&
1557             (_mintCounter[msg.sender] + _amount <= maxFree))
1558             ? 0
1559             : cost;
1560 
1561         if (_amount > maxPerTx) revert MaxPerTxExceeded();
1562         if (msg.value < _cost * _amount) revert WrongPrice();
1563         if (totalSupply() + _amount > maxSupply) revert MaxSupplyExceeded();
1564 
1565         if (_cost == 0) {
1566             _mintCounter[msg.sender] += _amount;
1567         }
1568 
1569         _safeMint(msg.sender, _amount);
1570     }
1571 
1572     function reserveMint(address _to, uint256 _amount) external onlyOwner {
1573         _mint(_to, _amount);
1574     }
1575 
1576     function tokenURI(uint256 tokenId)
1577         public
1578         view
1579         virtual
1580         override
1581         returns (string memory)
1582     {
1583         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1584         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1585     }
1586 
1587     function _startTokenId() internal pure override returns (uint256) {
1588         return 1;
1589     }
1590 
1591     function _baseURI() internal view virtual override returns (string memory) {
1592         return baseURI;
1593     }
1594 
1595     function setBaseURI(string calldata _newMetadataURI) external onlyOwner {
1596         baseURI = _newMetadataURI;
1597     }
1598 
1599     function setCost(uint256 _cost) external onlyOwner {
1600         cost = _cost;
1601     }
1602 
1603     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1604         maxSupply = _maxSupply;
1605     }
1606 
1607     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
1608         maxPerTx = _maxPerTx;
1609     }
1610 
1611     function setMaxFree(uint256 _maxFree) external onlyOwner {
1612         maxFree = _maxFree;
1613     }
1614 
1615     function toggleSale() external onlyOwner {
1616         sale = !sale;
1617     }
1618 
1619     function withdraw() external onlyOwner {
1620         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1621         require(success, "Transfer failed");
1622     }
1623 }