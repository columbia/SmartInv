1 //
2 //██▓     ▒█████   ██▒   █▓▓█████     ██▓     ▒█████   ██▒   █▓▓█████   ██████    ▄▄▄█████▓ ▒█████      ██▓     ▒█████   ██▒   █▓▓█████     ██▓     ▒█████   ██▒   █▓▓█████
3 //▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀    ▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀ ▒██    ▒    ▓  ██▒ ▓▒▒██▒  ██▒   ▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀    ▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀
4 //▒██░    ▒██░  ██▒ ▓██  █▒░▒███      ▒██░    ▒██░  ██▒ ▓██  █▒░▒███   ░ ▓██▄      ▒ ▓██░ ▒░▒██░  ██▒   ▒██░    ▒██░  ██▒ ▓██  █▒░▒███      ▒██░    ▒██░  ██▒ ▓██  █▒░▒███
5 //▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄    ▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄   ▒   ██▒   ░ ▓██▓ ░ ▒██   ██░   ▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄    ▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄
6 //░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒   ░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒▒██████▒▒     ▒██▒ ░ ░ ████▓▒░   ░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒   ░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒
7 //░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░   ░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░▒ ▒▓▒ ▒ ░     ▒ ░░   ░ ▒░▒░▒░    ░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░   ░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░
8 //░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░   ░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░░ ░▒  ░ ░       ░      ░ ▒ ▒░    ░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░   ░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░
9 //░ ░   ░ ░ ░ ▒       ░░     ░        ░ ░   ░ ░ ░ ▒       ░░     ░   ░  ░  ░       ░      ░ ░ ░ ▒       ░ ░   ░ ░ ░ ▒       ░░     ░        ░ ░   ░ ░ ░ ▒       ░░     ░
10 //░  ░    ░ ░        ░     ░  ░       ░  ░    ░ ░        ░     ░  ░      ░                  ░ ░         ░  ░    ░ ░        ░     ░  ░       ░  ░    ░ ░        ░     ░  ░
11 //░                                   ░                                                                 ░                                   ░
12 //
13 
14 
15 
16 // ERC721A Contracts v4.1.0
17 // Creator: Chiru Labs
18 
19 pragma solidity ^0.8.4;
20 
21 /**
22  * @dev Interface of an ERC721A compliant contract.
23  */
24 interface IERC721A {
25     /**
26      * The caller must own the token or be an approved operator.
27      */
28     error ApprovalCallerNotOwnerNorApproved();
29 
30     /**
31      * The token does not exist.
32      */
33     error ApprovalQueryForNonexistentToken();
34 
35     /**
36      * The caller cannot approve to their own address.
37      */
38     error ApproveToCaller();
39 
40     /**
41      * Cannot query the balance for the zero address.
42      */
43     error BalanceQueryForZeroAddress();
44 
45     /**
46      * Cannot mint to the zero address.
47      */
48     error MintToZeroAddress();
49 
50     /**
51      * The quantity of tokens minted must be more than zero.
52      */
53     error MintZeroQuantity();
54 
55     /**
56      * The token does not exist.
57      */
58     error OwnerQueryForNonexistentToken();
59 
60     /**
61      * The caller must own the token or be an approved operator.
62      */
63     error TransferCallerNotOwnerNorApproved();
64 
65     /**
66      * The token must be owned by `from`.
67      */
68     error TransferFromIncorrectOwner();
69 
70     /**
71      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
72      */
73     error TransferToNonERC721ReceiverImplementer();
74 
75     /**
76      * Cannot transfer to the zero address.
77      */
78     error TransferToZeroAddress();
79 
80     /**
81      * The token does not exist.
82      */
83     error URIQueryForNonexistentToken();
84 
85     /**
86      * The `quantity` minted with ERC2309 exceeds the safety limit.
87      */
88     error MintERC2309QuantityExceedsLimit();
89 
90     /**
91      * The `extraData` cannot be set on an unintialized ownership slot.
92      */
93     error OwnershipNotInitializedForExtraData();
94 
95     struct TokenOwnership {
96         // The address of the owner.
97         address addr;
98         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
99         uint64 startTimestamp;
100         // Whether the token has been burned.
101         bool burned;
102         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
103         uint24 extraData;
104     }
105 
106     /**
107      * @dev Returns the total amount of tokens stored by the contract.
108      *
109      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     // ==============================
114     //            IERC165
115     // ==============================
116 
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 
127     // ==============================
128     //            IERC721
129     // ==============================
130 
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in ``owner``'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 
180     /**
181      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
182      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191      *
192      * Emits a {Transfer} event.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Transfers `tokenId` token from `from` to `to`.
202      *
203      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
225      *
226      * Requirements:
227      *
228      * - The caller must own the token or be an approved operator.
229      * - `tokenId` must exist.
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address to, uint256 tokenId) external;
234 
235     /**
236      * @dev Approve or remove `operator` as an operator for the caller.
237      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
238      *
239      * Requirements:
240      *
241      * - The `operator` cannot be the caller.
242      *
243      * Emits an {ApprovalForAll} event.
244      */
245     function setApprovalForAll(address operator, bool _approved) external;
246 
247     /**
248      * @dev Returns the account approved for `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function getApproved(uint256 tokenId) external view returns (address operator);
255 
256     /**
257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
258      *
259      * See {setApprovalForAll}
260      */
261     function isApprovedForAll(address owner, address operator) external view returns (bool);
262 
263     // ==============================
264     //        IERC721Metadata
265     // ==============================
266 
267     /**
268      * @dev Returns the token collection name.
269      */
270     function name() external view returns (string memory);
271 
272     /**
273      * @dev Returns the token collection symbol.
274      */
275     function symbol() external view returns (string memory);
276 
277     /**
278      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
279      */
280     function tokenURI(uint256 tokenId) external view returns (string memory);
281 
282     // ==============================
283     //            IERC2309
284     // ==============================
285 
286     /**
287      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
288      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
289      */
290     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
291 }
292 
293 
294 
295 // ERC721A Contracts v4.1.0
296 // Creator: Chiru Labs
297 
298 pragma solidity ^0.8.4;
299 
300 
301 /**
302  * @dev ERC721 token receiver interface.
303  */
304 interface ERC721A__IERC721Receiver {
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 /**
314  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
315  * including the Metadata extension. Built to optimize for lower gas during batch mints.
316  *
317  * Assumes serials are sequentially minted starting at `_startTokenId()`
318  * (defaults to 0, e.g. 0, 1, 2, 3..).
319  *
320  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
321  *
322  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
323  */
324 contract ERC721A is IERC721A {
325     // Mask of an entry in packed address data.
326     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
327 
328     // The bit position of `numberMinted` in packed address data.
329     uint256 private constant BITPOS_NUMBER_MINTED = 64;
330 
331     // The bit position of `numberBurned` in packed address data.
332     uint256 private constant BITPOS_NUMBER_BURNED = 128;
333 
334     // The bit position of `aux` in packed address data.
335     uint256 private constant BITPOS_AUX = 192;
336 
337     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
338     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
339 
340     // The bit position of `startTimestamp` in packed ownership.
341     uint256 private constant BITPOS_START_TIMESTAMP = 160;
342 
343     // The bit mask of the `burned` bit in packed ownership.
344     uint256 private constant BITMASK_BURNED = 1 << 224;
345 
346     // The bit position of the `nextInitialized` bit in packed ownership.
347     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
348 
349     // The bit mask of the `nextInitialized` bit in packed ownership.
350     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
351 
352     // The bit position of `extraData` in packed ownership.
353     uint256 private constant BITPOS_EXTRA_DATA = 232;
354 
355     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
356     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
357 
358     // The mask of the lower 160 bits for addresses.
359     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
360 
361     // The maximum `quantity` that can be minted with `_mintERC2309`.
362     // This limit is to prevent overflows on the address data entries.
363     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
364     // is required to cause an overflow, which is unrealistic.
365     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
366 
367     // The tokenId of the next token to be minted.
368     uint256 private _currentIndex;
369 
370     // The number of tokens burned.
371     uint256 private _burnCounter;
372 
373     // Token name
374     string private _name;
375 
376     // Token symbol
377     string private _symbol;
378 
379     // Mapping from token ID to ownership details
380     // An empty struct value does not necessarily mean the token is unowned.
381     // See `_packedOwnershipOf` implementation for details.
382     //
383     // Bits Layout:
384     // - [0..159]   `addr`
385     // - [160..223] `startTimestamp`
386     // - [224]      `burned`
387     // - [225]      `nextInitialized`
388     // - [232..255] `extraData`
389     mapping(uint256 => uint256) private _packedOwnerships;
390 
391     // Mapping owner address to address data.
392     //
393     // Bits Layout:
394     // - [0..63]    `balance`
395     // - [64..127]  `numberMinted`
396     // - [128..191] `numberBurned`
397     // - [192..255] `aux`
398     mapping(address => uint256) private _packedAddressData;
399 
400     // Mapping from token ID to approved address.
401     mapping(uint256 => address) private _tokenApprovals;
402 
403     // Mapping from owner to operator approvals
404     mapping(address => mapping(address => bool)) private _operatorApprovals;
405 
406     constructor(string memory name_, string memory symbol_) {
407         _name = name_;
408         _symbol = symbol_;
409         _currentIndex = _startTokenId();
410     }
411 
412     /**
413      * @dev Returns the starting token ID.
414      * To change the starting token ID, please override this function.
415      */
416     function _startTokenId() internal view virtual returns (uint256) {
417         return 0;
418     }
419 
420     /**
421      * @dev Returns the next token ID to be minted.
422      */
423     function _nextTokenId() internal view returns (uint256) {
424         return _currentIndex;
425     }
426 
427     /**
428      * @dev Returns the total number of tokens in existence.
429      * Burned tokens will reduce the count.
430      * To get the total number of tokens minted, please see `_totalMinted`.
431      */
432     function totalSupply() public view override returns (uint256) {
433         // Counter underflow is impossible as _burnCounter cannot be incremented
434         // more than `_currentIndex - _startTokenId()` times.
435         unchecked {
436             return _currentIndex - _burnCounter - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total amount of tokens minted in the contract.
442      */
443     function _totalMinted() internal view returns (uint256) {
444         // Counter underflow is impossible as _currentIndex does not decrement,
445         // and it is initialized to `_startTokenId()`
446         unchecked {
447             return _currentIndex - _startTokenId();
448         }
449     }
450 
451     /**
452      * @dev Returns the total number of tokens burned.
453      */
454     function _totalBurned() internal view returns (uint256) {
455         return _burnCounter;
456     }
457 
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462         // The interface IDs are constants representing the first 4 bytes of the XOR of
463         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
464         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
465         return
466             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
467             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
468             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
469     }
470 
471     /**
472      * @dev See {IERC721-balanceOf}.
473      */
474     function balanceOf(address owner) public view override returns (uint256) {
475         if (owner == address(0)) revert BalanceQueryForZeroAddress();
476         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
477     }
478 
479     /**
480      * Returns the number of tokens minted by `owner`.
481      */
482     function _numberMinted(address owner) internal view returns (uint256) {
483         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
484     }
485 
486     /**
487      * Returns the number of tokens burned by or on behalf of `owner`.
488      */
489     function _numberBurned(address owner) internal view returns (uint256) {
490         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
495      */
496     function _getAux(address owner) internal view returns (uint64) {
497         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
498     }
499 
500     /**
501      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
502      * If there are multiple variables, please pack them into a uint64.
503      */
504     function _setAux(address owner, uint64 aux) internal {
505         uint256 packed = _packedAddressData[owner];
506         uint256 auxCasted;
507         // Cast `aux` with assembly to avoid redundant masking.
508         assembly {
509             auxCasted := aux
510         }
511         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
512         _packedAddressData[owner] = packed;
513     }
514 
515     /**
516      * Returns the packed ownership data of `tokenId`.
517      */
518     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
519         uint256 curr = tokenId;
520 
521         unchecked {
522             if (_startTokenId() <= curr)
523                 if (curr < _currentIndex) {
524                     uint256 packed = _packedOwnerships[curr];
525                     // If not burned.
526                     if (packed & BITMASK_BURNED == 0) {
527                         // Invariant:
528                         // There will always be an ownership that has an address and is not burned
529                         // before an ownership that does not have an address and is not burned.
530                         // Hence, curr will not underflow.
531                         //
532                         // We can directly compare the packed value.
533                         // If the address is zero, packed is zero.
534                         while (packed == 0) {
535                             packed = _packedOwnerships[--curr];
536                         }
537                         return packed;
538                     }
539                 }
540         }
541         revert OwnerQueryForNonexistentToken();
542     }
543 
544     /**
545      * Returns the unpacked `TokenOwnership` struct from `packed`.
546      */
547     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
548         ownership.addr = address(uint160(packed));
549         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
550         ownership.burned = packed & BITMASK_BURNED != 0;
551         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
552     }
553 
554     /**
555      * Returns the unpacked `TokenOwnership` struct at `index`.
556      */
557     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
558         return _unpackedOwnership(_packedOwnerships[index]);
559     }
560 
561     /**
562      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
563      */
564     function _initializeOwnershipAt(uint256 index) internal {
565         if (_packedOwnerships[index] == 0) {
566             _packedOwnerships[index] = _packedOwnershipOf(index);
567         }
568     }
569 
570     /**
571      * Gas spent here starts off proportional to the maximum mint batch size.
572      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
573      */
574     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
575         return _unpackedOwnership(_packedOwnershipOf(tokenId));
576     }
577 
578     /**
579      * @dev Packs ownership data into a single uint256.
580      */
581     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
582         assembly {
583             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
584             owner := and(owner, BITMASK_ADDRESS)
585             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
586             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
587         }
588     }
589 
590     /**
591      * @dev See {IERC721-ownerOf}.
592      */
593     function ownerOf(uint256 tokenId) public view override returns (address) {
594         return address(uint160(_packedOwnershipOf(tokenId)));
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-name}.
599      */
600     function name() public view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-symbol}.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-tokenURI}.
613      */
614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
615         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
616 
617         string memory baseURI = _baseURI();
618         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
619     }
620 
621     /**
622      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
623      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
624      * by default, it can be overridden in child contracts.
625      */
626     function _baseURI() internal view virtual returns (string memory) {
627         return '';
628     }
629 
630     /**
631      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
632      */
633     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
634         // For branchless setting of the `nextInitialized` flag.
635         assembly {
636             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
637             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
638         }
639     }
640 
641     /**
642      * @dev See {IERC721-approve}.
643      */
644     function approve(address to, uint256 tokenId) public override {
645         address owner = ownerOf(tokenId);
646 
647         if (_msgSenderERC721A() != owner)
648             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
649                 revert ApprovalCallerNotOwnerNorApproved();
650             }
651 
652         _tokenApprovals[tokenId] = to;
653         emit Approval(owner, to, tokenId);
654     }
655 
656     /**
657      * @dev See {IERC721-getApproved}.
658      */
659     function getApproved(uint256 tokenId) public view override returns (address) {
660         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
661 
662         return _tokenApprovals[tokenId];
663     }
664 
665     /**
666      * @dev See {IERC721-setApprovalForAll}.
667      */
668     function setApprovalForAll(address operator, bool approved) public virtual override {
669         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
670 
671         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
672         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC721-isApprovedForAll}.
677      */
678     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
679         return _operatorApprovals[owner][operator];
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) public virtual override {
690         safeTransferFrom(from, to, tokenId, '');
691     }
692 
693     /**
694      * @dev See {IERC721-safeTransferFrom}.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes memory _data
701     ) public virtual override {
702         transferFrom(from, to, tokenId);
703         if (to.code.length != 0)
704             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
705                 revert TransferToNonERC721ReceiverImplementer();
706             }
707     }
708 
709     /**
710      * @dev Returns whether `tokenId` exists.
711      *
712      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
713      *
714      * Tokens start existing when they are minted (`_mint`),
715      */
716     function _exists(uint256 tokenId) internal view returns (bool) {
717         return
718             _startTokenId() <= tokenId &&
719             tokenId < _currentIndex && // If within bounds,
720             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
721     }
722 
723     /**
724      * @dev Equivalent to `_safeMint(to, quantity, '')`.
725      */
726     function _safeMint(address to, uint256 quantity) internal {
727         _safeMint(to, quantity, '');
728     }
729 
730     /**
731      * @dev Safely mints `quantity` tokens and transfers them to `to`.
732      *
733      * Requirements:
734      *
735      * - If `to` refers to a smart contract, it must implement
736      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
737      * - `quantity` must be greater than 0.
738      *
739      * See {_mint}.
740      *
741      * Emits a {Transfer} event for each mint.
742      */
743     function _safeMint(
744         address to,
745         uint256 quantity,
746         bytes memory _data
747     ) internal {
748         _mint(to, quantity);
749 
750         unchecked {
751             if (to.code.length != 0) {
752                 uint256 end = _currentIndex;
753                 uint256 index = end - quantity;
754                 do {
755                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
756                         revert TransferToNonERC721ReceiverImplementer();
757                     }
758                 } while (index < end);
759                 // Reentrancy protection.
760                 if (_currentIndex != end) revert();
761             }
762         }
763     }
764 
765     /**
766      * @dev Mints `quantity` tokens and transfers them to `to`.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - `quantity` must be greater than 0.
772      *
773      * Emits a {Transfer} event for each mint.
774      */
775     function _mint(address to, uint256 quantity) internal {
776         uint256 startTokenId = _currentIndex;
777         if (to == address(0)) revert MintToZeroAddress();
778         if (quantity == 0) revert MintZeroQuantity();
779 
780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
781 
782         // Overflows are incredibly unrealistic.
783         // `balance` and `numberMinted` have a maximum limit of 2**64.
784         // `tokenId` has a maximum limit of 2**256.
785         unchecked {
786             // Updates:
787             // - `balance += quantity`.
788             // - `numberMinted += quantity`.
789             //
790             // We can directly add to the `balance` and `numberMinted`.
791             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] = _packOwnershipData(
799                 to,
800                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
801             );
802 
803             uint256 tokenId = startTokenId;
804             uint256 end = startTokenId + quantity;
805             do {
806                 emit Transfer(address(0), to, tokenId++);
807             } while (tokenId < end);
808 
809             _currentIndex = end;
810         }
811         _afterTokenTransfers(address(0), to, startTokenId, quantity);
812     }
813 
814     /**
815      * @dev Mints `quantity` tokens and transfers them to `to`.
816      *
817      * This function is intended for efficient minting only during contract creation.
818      *
819      * It emits only one {ConsecutiveTransfer} as defined in
820      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
821      * instead of a sequence of {Transfer} event(s).
822      *
823      * Calling this function outside of contract creation WILL make your contract
824      * non-compliant with the ERC721 standard.
825      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
826      * {ConsecutiveTransfer} event is only permissible during contract creation.
827      *
828      * Requirements:
829      *
830      * - `to` cannot be the zero address.
831      * - `quantity` must be greater than 0.
832      *
833      * Emits a {ConsecutiveTransfer} event.
834      */
835     function _mintERC2309(address to, uint256 quantity) internal {
836         uint256 startTokenId = _currentIndex;
837         if (to == address(0)) revert MintToZeroAddress();
838         if (quantity == 0) revert MintZeroQuantity();
839         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
840 
841         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
842 
843         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
844         unchecked {
845             // Updates:
846             // - `balance += quantity`.
847             // - `numberMinted += quantity`.
848             //
849             // We can directly add to the `balance` and `numberMinted`.
850             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
851 
852             // Updates:
853             // - `address` to the owner.
854             // - `startTimestamp` to the timestamp of minting.
855             // - `burned` to `false`.
856             // - `nextInitialized` to `quantity == 1`.
857             _packedOwnerships[startTokenId] = _packOwnershipData(
858                 to,
859                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
860             );
861 
862             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
863 
864             _currentIndex = startTokenId + quantity;
865         }
866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
867     }
868 
869     /**
870      * @dev Returns the storage slot and value for the approved address of `tokenId`.
871      */
872     function _getApprovedAddress(uint256 tokenId)
873         private
874         view
875         returns (uint256 approvedAddressSlot, address approvedAddress)
876     {
877         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
878         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
879         assembly {
880             // Compute the slot.
881             mstore(0x00, tokenId)
882             mstore(0x20, tokenApprovalsPtr.slot)
883             approvedAddressSlot := keccak256(0x00, 0x40)
884             // Load the slot's value from storage.
885             approvedAddress := sload(approvedAddressSlot)
886         }
887     }
888 
889     /**
890      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
891      */
892     function _isOwnerOrApproved(
893         address approvedAddress,
894         address from,
895         address msgSender
896     ) private pure returns (bool result) {
897         assembly {
898             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
899             from := and(from, BITMASK_ADDRESS)
900             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
901             msgSender := and(msgSender, BITMASK_ADDRESS)
902             // `msgSender == from || msgSender == approvedAddress`.
903             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
904         }
905     }
906 
907     /**
908      * @dev Transfers `tokenId` from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function transferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
923 
924         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
925 
926         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
927 
928         // The nested ifs save around 20+ gas over a compound boolean condition.
929         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
930             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
931 
932         if (to == address(0)) revert TransferToZeroAddress();
933 
934         _beforeTokenTransfers(from, to, tokenId, 1);
935 
936         // Clear approvals from the previous owner.
937         assembly {
938             if approvedAddress {
939                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
940                 sstore(approvedAddressSlot, 0)
941             }
942         }
943 
944         // Underflow of the sender's balance is impossible because we check for
945         // ownership above and the recipient's balance can't realistically overflow.
946         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
947         unchecked {
948             // We can directly increment and decrement the balances.
949             --_packedAddressData[from]; // Updates: `balance -= 1`.
950             ++_packedAddressData[to]; // Updates: `balance += 1`.
951 
952             // Updates:
953             // - `address` to the next owner.
954             // - `startTimestamp` to the timestamp of transfering.
955             // - `burned` to `false`.
956             // - `nextInitialized` to `true`.
957             _packedOwnerships[tokenId] = _packOwnershipData(
958                 to,
959                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
960             );
961 
962             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
963             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
964                 uint256 nextTokenId = tokenId + 1;
965                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
966                 if (_packedOwnerships[nextTokenId] == 0) {
967                     // If the next slot is within bounds.
968                     if (nextTokenId != _currentIndex) {
969                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
970                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
971                     }
972                 }
973             }
974         }
975 
976         emit Transfer(from, to, tokenId);
977         _afterTokenTransfers(from, to, tokenId, 1);
978     }
979 
980     /**
981      * @dev Equivalent to `_burn(tokenId, false)`.
982      */
983     function _burn(uint256 tokenId) internal virtual {
984         _burn(tokenId, false);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
998         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
999 
1000         address from = address(uint160(prevOwnershipPacked));
1001 
1002         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1003 
1004         if (approvalCheck) {
1005             // The nested ifs save around 20+ gas over a compound boolean condition.
1006             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1007                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1008         }
1009 
1010         _beforeTokenTransfers(from, address(0), tokenId, 1);
1011 
1012         // Clear approvals from the previous owner.
1013         assembly {
1014             if approvedAddress {
1015                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1016                 sstore(approvedAddressSlot, 0)
1017             }
1018         }
1019 
1020         // Underflow of the sender's balance is impossible because we check for
1021         // ownership above and the recipient's balance can't realistically overflow.
1022         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1023         unchecked {
1024             // Updates:
1025             // - `balance -= 1`.
1026             // - `numberBurned += 1`.
1027             //
1028             // We can directly decrement the balance, and increment the number burned.
1029             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1030             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1031 
1032             // Updates:
1033             // - `address` to the last owner.
1034             // - `startTimestamp` to the timestamp of burning.
1035             // - `burned` to `true`.
1036             // - `nextInitialized` to `true`.
1037             _packedOwnerships[tokenId] = _packOwnershipData(
1038                 from,
1039                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1040             );
1041 
1042             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1043             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1044                 uint256 nextTokenId = tokenId + 1;
1045                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1046                 if (_packedOwnerships[nextTokenId] == 0) {
1047                     // If the next slot is within bounds.
1048                     if (nextTokenId != _currentIndex) {
1049                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1050                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1051                     }
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, address(0), tokenId);
1057         _afterTokenTransfers(from, address(0), tokenId, 1);
1058 
1059         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1060         unchecked {
1061             _burnCounter++;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1067      *
1068      * @param from address representing the previous owner of the given token ID
1069      * @param to target address that will receive the tokens
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @param _data bytes optional data to send along with the call
1072      * @return bool whether the call correctly returned the expected magic value
1073      */
1074     function _checkContractOnERC721Received(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) private returns (bool) {
1080         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1081             bytes4 retval
1082         ) {
1083             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1084         } catch (bytes memory reason) {
1085             if (reason.length == 0) {
1086                 revert TransferToNonERC721ReceiverImplementer();
1087             } else {
1088                 assembly {
1089                     revert(add(32, reason), mload(reason))
1090                 }
1091             }
1092         }
1093     }
1094 
1095     /**
1096      * @dev Directly sets the extra data for the ownership data `index`.
1097      */
1098     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1099         uint256 packed = _packedOwnerships[index];
1100         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1101         uint256 extraDataCasted;
1102         // Cast `extraData` with assembly to avoid redundant masking.
1103         assembly {
1104             extraDataCasted := extraData
1105         }
1106         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1107         _packedOwnerships[index] = packed;
1108     }
1109 
1110     /**
1111      * @dev Returns the next extra data for the packed ownership data.
1112      * The returned result is shifted into position.
1113      */
1114     function _nextExtraData(
1115         address from,
1116         address to,
1117         uint256 prevOwnershipPacked
1118     ) private view returns (uint256) {
1119         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1120         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1121     }
1122 
1123     /**
1124      * @dev Called during each token transfer to set the 24bit `extraData` field.
1125      * Intended to be overridden by the cosumer contract.
1126      *
1127      * `previousExtraData` - the value of `extraData` before transfer.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, `tokenId` will be burned by `from`.
1135      * - `from` and `to` are never both zero.
1136      */
1137     function _extraData(
1138         address from,
1139         address to,
1140         uint24 previousExtraData
1141     ) internal view virtual returns (uint24) {}
1142 
1143     /**
1144      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1145      * This includes minting.
1146      * And also called before burning one token.
1147      *
1148      * startTokenId - the first token id to be transferred
1149      * quantity - the amount to be transferred
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, `tokenId` will be burned by `from`.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _beforeTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 
1166     /**
1167      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1168      * This includes minting.
1169      * And also called after one token has been burned.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` has been minted for `to`.
1179      * - When `to` is zero, `tokenId` has been burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _afterTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Returns the message sender (defaults to `msg.sender`).
1191      *
1192      * If you are writing GSN compatible contracts, you need to override this function.
1193      */
1194     function _msgSenderERC721A() internal view virtual returns (address) {
1195         return msg.sender;
1196     }
1197 
1198     /**
1199      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1200      */
1201     function _toString(uint256 value) internal pure returns (string memory ptr) {
1202         assembly {
1203             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1204             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1205             // We will need 1 32-byte word to store the length,
1206             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1207             ptr := add(mload(0x40), 128)
1208             // Update the free memory pointer to allocate.
1209             mstore(0x40, ptr)
1210 
1211             // Cache the end of the memory to calculate the length later.
1212             let end := ptr
1213 
1214             // We write the string from the rightmost digit to the leftmost digit.
1215             // The following is essentially a do-while loop that also handles the zero case.
1216             // Costs a bit more than early returning for the zero case,
1217             // but cheaper in terms of deployment and overall runtime costs.
1218             for {
1219                 // Initialize and perform the first pass without check.
1220                 let temp := value
1221                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1222                 ptr := sub(ptr, 1)
1223                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1224                 mstore8(ptr, add(48, mod(temp, 10)))
1225                 temp := div(temp, 10)
1226             } temp {
1227                 // Keep dividing `temp` until zero.
1228                 temp := div(temp, 10)
1229             } {
1230                 // Body of the for loop.
1231                 ptr := sub(ptr, 1)
1232                 mstore8(ptr, add(48, mod(temp, 10)))
1233             }
1234 
1235             let length := sub(end, ptr)
1236             // Move the pointer 32 bytes leftwards to make room for the length.
1237             ptr := sub(ptr, 32)
1238             // Store the length.
1239             mstore(ptr, length)
1240         }
1241     }
1242 }
1243 
1244 
1245 // ERC721A Contracts v4.1.0
1246 // Creator: Chiru Labs
1247 
1248 pragma solidity ^0.8.4;
1249 
1250 
1251 /**
1252  * @dev Interface of an ERC721AQueryable compliant contract.
1253  */
1254 interface IERC721AQueryable is IERC721A {
1255     /**
1256      * Invalid query range (`start` >= `stop`).
1257      */
1258     error InvalidQueryRange();
1259 
1260     /**
1261      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1262      *
1263      * If the `tokenId` is out of bounds:
1264      *   - `addr` = `address(0)`
1265      *   - `startTimestamp` = `0`
1266      *   - `burned` = `false`
1267      *
1268      * If the `tokenId` is burned:
1269      *   - `addr` = `<Address of owner before token was burned>`
1270      *   - `startTimestamp` = `<Timestamp when token was burned>`
1271      *   - `burned = `true`
1272      *
1273      * Otherwise:
1274      *   - `addr` = `<Address of owner>`
1275      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1276      *   - `burned = `false`
1277      */
1278     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1279 
1280     /**
1281      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1282      * See {ERC721AQueryable-explicitOwnershipOf}
1283      */
1284     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1285 
1286     /**
1287      * @dev Returns an array of token IDs owned by `owner`,
1288      * in the range [`start`, `stop`)
1289      * (i.e. `start <= tokenId < stop`).
1290      *
1291      * This function allows for tokens to be queried if the collection
1292      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1293      *
1294      * Requirements:
1295      *
1296      * - `start` < `stop`
1297      */
1298     function tokensOfOwnerIn(
1299         address owner,
1300         uint256 start,
1301         uint256 stop
1302     ) external view returns (uint256[] memory);
1303 
1304     /**
1305      * @dev Returns an array of token IDs owned by `owner`.
1306      *
1307      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1308      * It is meant to be called off-chain.
1309      *
1310      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1311      * multiple smaller scans if the collection is large enough to cause
1312      * an out-of-gas error (10K pfp collections should be fine).
1313      */
1314     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1315 }
1316 
1317 
1318 // ERC721A Contracts v4.1.0
1319 // Creator: Chiru Labs
1320 
1321 pragma solidity ^0.8.4;
1322 
1323 
1324 
1325 /**
1326  * @title ERC721A Queryable
1327  * @dev ERC721A subclass with convenience query functions.
1328  */
1329 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1330     /**
1331      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1332      *
1333      * If the `tokenId` is out of bounds:
1334      *   - `addr` = `address(0)`
1335      *   - `startTimestamp` = `0`
1336      *   - `burned` = `false`
1337      *   - `extraData` = `0`
1338      *
1339      * If the `tokenId` is burned:
1340      *   - `addr` = `<Address of owner before token was burned>`
1341      *   - `startTimestamp` = `<Timestamp when token was burned>`
1342      *   - `burned = `true`
1343      *   - `extraData` = `<Extra data when token was burned>`
1344      *
1345      * Otherwise:
1346      *   - `addr` = `<Address of owner>`
1347      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1348      *   - `burned = `false`
1349      *   - `extraData` = `<Extra data at start of ownership>`
1350      */
1351     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1352         TokenOwnership memory ownership;
1353         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1354             return ownership;
1355         }
1356         ownership = _ownershipAt(tokenId);
1357         if (ownership.burned) {
1358             return ownership;
1359         }
1360         return _ownershipOf(tokenId);
1361     }
1362 
1363     /**
1364      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1365      * See {ERC721AQueryable-explicitOwnershipOf}
1366      */
1367     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1368         unchecked {
1369             uint256 tokenIdsLength = tokenIds.length;
1370             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1371             for (uint256 i; i != tokenIdsLength; ++i) {
1372                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1373             }
1374             return ownerships;
1375         }
1376     }
1377 
1378     /**
1379      * @dev Returns an array of token IDs owned by `owner`,
1380      * in the range [`start`, `stop`)
1381      * (i.e. `start <= tokenId < stop`).
1382      *
1383      * This function allows for tokens to be queried if the collection
1384      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1385      *
1386      * Requirements:
1387      *
1388      * - `start` < `stop`
1389      */
1390     function tokensOfOwnerIn(
1391         address owner,
1392         uint256 start,
1393         uint256 stop
1394     ) external view override returns (uint256[] memory) {
1395         unchecked {
1396             if (start >= stop) revert InvalidQueryRange();
1397             uint256 tokenIdsIdx;
1398             uint256 stopLimit = _nextTokenId();
1399             // Set `start = max(start, _startTokenId())`.
1400             if (start < _startTokenId()) {
1401                 start = _startTokenId();
1402             }
1403             // Set `stop = min(stop, stopLimit)`.
1404             if (stop > stopLimit) {
1405                 stop = stopLimit;
1406             }
1407             uint256 tokenIdsMaxLength = balanceOf(owner);
1408             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1409             // to cater for cases where `balanceOf(owner)` is too big.
1410             if (start < stop) {
1411                 uint256 rangeLength = stop - start;
1412                 if (rangeLength < tokenIdsMaxLength) {
1413                     tokenIdsMaxLength = rangeLength;
1414                 }
1415             } else {
1416                 tokenIdsMaxLength = 0;
1417             }
1418             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1419             if (tokenIdsMaxLength == 0) {
1420                 return tokenIds;
1421             }
1422             // We need to call `explicitOwnershipOf(start)`,
1423             // because the slot at `start` may not be initialized.
1424             TokenOwnership memory ownership = explicitOwnershipOf(start);
1425             address currOwnershipAddr;
1426             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1427             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1428             if (!ownership.burned) {
1429                 currOwnershipAddr = ownership.addr;
1430             }
1431             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1432                 ownership = _ownershipAt(i);
1433                 if (ownership.burned) {
1434                     continue;
1435                 }
1436                 if (ownership.addr != address(0)) {
1437                     currOwnershipAddr = ownership.addr;
1438                 }
1439                 if (currOwnershipAddr == owner) {
1440                     tokenIds[tokenIdsIdx++] = i;
1441                 }
1442             }
1443             // Downsize the array to fit.
1444             assembly {
1445                 mstore(tokenIds, tokenIdsIdx)
1446             }
1447             return tokenIds;
1448         }
1449     }
1450 
1451     /**
1452      * @dev Returns an array of token IDs owned by `owner`.
1453      *
1454      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1455      * It is meant to be called off-chain.
1456      *
1457      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1458      * multiple smaller scans if the collection is large enough to cause
1459      * an out-of-gas error (10K pfp collections should be fine).
1460      */
1461     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1462         unchecked {
1463             uint256 tokenIdsIdx;
1464             address currOwnershipAddr;
1465             uint256 tokenIdsLength = balanceOf(owner);
1466             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1467             TokenOwnership memory ownership;
1468             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1469                 ownership = _ownershipAt(i);
1470                 if (ownership.burned) {
1471                     continue;
1472                 }
1473                 if (ownership.addr != address(0)) {
1474                     currOwnershipAddr = ownership.addr;
1475                 }
1476                 if (currOwnershipAddr == owner) {
1477                     tokenIds[tokenIdsIdx++] = i;
1478                 }
1479             }
1480             return tokenIds;
1481         }
1482     }
1483 }
1484 
1485 
1486 
1487 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 /**
1492  * @dev Provides information about the current execution context, including the
1493  * sender of the transaction and its data. While these are generally available
1494  * via msg.sender and msg.data, they should not be accessed in such a direct
1495  * manner, since when dealing with meta-transactions the account sending and
1496  * paying for execution may not be the actual sender (as far as an application
1497  * is concerned).
1498  *
1499  * This contract is only required for intermediate, library-like contracts.
1500  */
1501 abstract contract Context {
1502     function _msgSender() internal view virtual returns (address) {
1503         return msg.sender;
1504     }
1505 
1506     function _msgData() internal view virtual returns (bytes calldata) {
1507         return msg.data;
1508     }
1509 }
1510 
1511 
1512 
1513 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 
1518 /**
1519  * @dev Contract module which provides a basic access control mechanism, where
1520  * there is an account (an owner) that can be granted exclusive access to
1521  * specific functions.
1522  *
1523  * By default, the owner account will be the one that deploys the contract. This
1524  * can later be changed with {transferOwnership}.
1525  *
1526  * This module is used through inheritance. It will make available the modifier
1527  * `onlyOwner`, which can be applied to your functions to restrict their use to
1528  * the owner.
1529  */
1530 abstract contract Ownable is Context {
1531     address private _owner;
1532 
1533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1534 
1535     /**
1536      * @dev Initializes the contract setting the deployer as the initial owner.
1537      */
1538     constructor() {
1539         _transferOwnership(_msgSender());
1540     }
1541 
1542     /**
1543      * @dev Throws if called by any account other than the owner.
1544      */
1545     modifier onlyOwner() {
1546         _checkOwner();
1547         _;
1548     }
1549 
1550     /**
1551      * @dev Returns the address of the current owner.
1552      */
1553     function owner() public view virtual returns (address) {
1554         return _owner;
1555     }
1556 
1557     /**
1558      * @dev Throws if the sender is not the owner.
1559      */
1560     function _checkOwner() internal view virtual {
1561         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1562     }
1563 
1564     /**
1565      * @dev Leaves the contract without owner. It will not be possible to call
1566      * `onlyOwner` functions anymore. Can only be called by the current owner.
1567      *
1568      * NOTE: Renouncing ownership will leave the contract without an owner,
1569      * thereby removing any functionality that is only available to the owner.
1570      */
1571     function renounceOwnership() public virtual onlyOwner {
1572         _transferOwnership(address(0));
1573     }
1574 
1575     /**
1576      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1577      * Can only be called by the current owner.
1578      */
1579     function transferOwnership(address newOwner) public virtual onlyOwner {
1580         require(newOwner != address(0), "Ownable: new owner is the zero address");
1581         _transferOwnership(newOwner);
1582     }
1583 
1584     /**
1585      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1586      * Internal function without access restriction.
1587      */
1588     function _transferOwnership(address newOwner) internal virtual {
1589         address oldOwner = _owner;
1590         _owner = newOwner;
1591         emit OwnershipTransferred(oldOwner, newOwner);
1592     }
1593 }
1594 
1595 
1596 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 /**
1601  * @dev These functions deal with verification of Merkle Tree proofs.
1602  *
1603  * The proofs can be generated using the JavaScript library
1604  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1605  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1606  *
1607  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1608  *
1609  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1610  * hashing, or use a hash function other than keccak256 for hashing leaves.
1611  * This is because the concatenation of a sorted pair of internal nodes in
1612  * the merkle tree could be reinterpreted as a leaf value.
1613  */
1614 library MerkleProof {
1615     /**
1616      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1617      * defined by `root`. For this, a `proof` must be provided, containing
1618      * sibling hashes on the branch from the leaf to the root of the tree. Each
1619      * pair of leaves and each pair of pre-images are assumed to be sorted.
1620      */
1621     function verify(
1622         bytes32[] memory proof,
1623         bytes32 root,
1624         bytes32 leaf
1625     ) internal pure returns (bool) {
1626         return processProof(proof, leaf) == root;
1627     }
1628 
1629     /**
1630      * @dev Calldata version of {verify}
1631      *
1632      * _Available since v4.7._
1633      */
1634     function verifyCalldata(
1635         bytes32[] calldata proof,
1636         bytes32 root,
1637         bytes32 leaf
1638     ) internal pure returns (bool) {
1639         return processProofCalldata(proof, leaf) == root;
1640     }
1641 
1642     /**
1643      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1644      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1645      * hash matches the root of the tree. When processing the proof, the pairs
1646      * of leafs & pre-images are assumed to be sorted.
1647      *
1648      * _Available since v4.4._
1649      */
1650     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1651         bytes32 computedHash = leaf;
1652         for (uint256 i = 0; i < proof.length; i++) {
1653             computedHash = _hashPair(computedHash, proof[i]);
1654         }
1655         return computedHash;
1656     }
1657 
1658     /**
1659      * @dev Calldata version of {processProof}
1660      *
1661      * _Available since v4.7._
1662      */
1663     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1664         bytes32 computedHash = leaf;
1665         for (uint256 i = 0; i < proof.length; i++) {
1666             computedHash = _hashPair(computedHash, proof[i]);
1667         }
1668         return computedHash;
1669     }
1670 
1671     /**
1672      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1673      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1674      *
1675      * _Available since v4.7._
1676      */
1677     function multiProofVerify(
1678         bytes32[] memory proof,
1679         bool[] memory proofFlags,
1680         bytes32 root,
1681         bytes32[] memory leaves
1682     ) internal pure returns (bool) {
1683         return processMultiProof(proof, proofFlags, leaves) == root;
1684     }
1685 
1686     /**
1687      * @dev Calldata version of {multiProofVerify}
1688      *
1689      * _Available since v4.7._
1690      */
1691     function multiProofVerifyCalldata(
1692         bytes32[] calldata proof,
1693         bool[] calldata proofFlags,
1694         bytes32 root,
1695         bytes32[] memory leaves
1696     ) internal pure returns (bool) {
1697         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1698     }
1699 
1700     /**
1701      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1702      * consuming from one or the other at each step according to the instructions given by
1703      * `proofFlags`.
1704      *
1705      * _Available since v4.7._
1706      */
1707     function processMultiProof(
1708         bytes32[] memory proof,
1709         bool[] memory proofFlags,
1710         bytes32[] memory leaves
1711     ) internal pure returns (bytes32 merkleRoot) {
1712         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1713         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1714         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1715         // the merkle tree.
1716         uint256 leavesLen = leaves.length;
1717         uint256 totalHashes = proofFlags.length;
1718 
1719         // Check proof validity.
1720         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1721 
1722         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1723         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1724         bytes32[] memory hashes = new bytes32[](totalHashes);
1725         uint256 leafPos = 0;
1726         uint256 hashPos = 0;
1727         uint256 proofPos = 0;
1728         // At each step, we compute the next hash using two values:
1729         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1730         //   get the next hash.
1731         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1732         //   `proof` array.
1733         for (uint256 i = 0; i < totalHashes; i++) {
1734             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1735             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1736             hashes[i] = _hashPair(a, b);
1737         }
1738 
1739         if (totalHashes > 0) {
1740             return hashes[totalHashes - 1];
1741         } else if (leavesLen > 0) {
1742             return leaves[0];
1743         } else {
1744             return proof[0];
1745         }
1746     }
1747 
1748     /**
1749      * @dev Calldata version of {processMultiProof}
1750      *
1751      * _Available since v4.7._
1752      */
1753     function processMultiProofCalldata(
1754         bytes32[] calldata proof,
1755         bool[] calldata proofFlags,
1756         bytes32[] memory leaves
1757     ) internal pure returns (bytes32 merkleRoot) {
1758         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1759         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1760         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1761         // the merkle tree.
1762         uint256 leavesLen = leaves.length;
1763         uint256 totalHashes = proofFlags.length;
1764 
1765         // Check proof validity.
1766         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1767 
1768         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1769         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1770         bytes32[] memory hashes = new bytes32[](totalHashes);
1771         uint256 leafPos = 0;
1772         uint256 hashPos = 0;
1773         uint256 proofPos = 0;
1774         // At each step, we compute the next hash using two values:
1775         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1776         //   get the next hash.
1777         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1778         //   `proof` array.
1779         for (uint256 i = 0; i < totalHashes; i++) {
1780             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1781             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1782             hashes[i] = _hashPair(a, b);
1783         }
1784 
1785         if (totalHashes > 0) {
1786             return hashes[totalHashes - 1];
1787         } else if (leavesLen > 0) {
1788             return leaves[0];
1789         } else {
1790             return proof[0];
1791         }
1792     }
1793 
1794     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1795         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1796     }
1797 
1798     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1799         /// @solidity memory-safe-assembly
1800         assembly {
1801             mstore(0x00, a)
1802             mstore(0x20, b)
1803             value := keccak256(0x00, 0x40)
1804         }
1805     }
1806 }
1807 
1808 
1809 
1810 pragma solidity >=0.7.0 <0.9.0;
1811 
1812 
1813 
1814 
1815 contract LoveLoves is ERC721AQueryable, Ownable {
1816     enum Status {
1817         Paused,
1818         Preminting,
1819         Started
1820     }
1821 
1822     Status public status = Status.Paused;
1823     bytes32 public root;
1824     string public baseURI;
1825     string public boxURI;
1826     uint256 public MAX_MINT_PER_ADDR = 5;
1827     uint256 public MAX_PREMINT_PER_ADDR = 2;
1828 
1829     uint256 public constant MAX_FREEMINT_PER_ADDR = 1;
1830     uint256 public constant teamSupply = 500;
1831     uint256 public freeSupply = 2500;
1832     uint256 public maxSupply = 5555;
1833     uint256 public freeMinted = 0;
1834     uint256 public price = 6900000000000000;
1835 
1836     event Minted(address minter, uint256 amount);
1837 
1838     constructor() ERC721A("love loves", "LLTLL") {}
1839 
1840     function _startTokenId() internal pure override returns (uint256) {
1841         return 1;
1842     }
1843 
1844     function _baseURI() internal view override returns (string memory) {
1845         return baseURI;
1846     }
1847 
1848     function tokenURI(uint256 tokenId)
1849         public
1850         view
1851         override
1852         returns (string memory)
1853     {
1854         return
1855             bytes(baseURI).length != 0
1856                 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
1857                 : boxURI;
1858     }
1859 
1860     function mint(uint256 quantity) external payable {
1861         require(status == Status.Started, "Not minting");
1862         require(tx.origin == msg.sender, "Contract call not allowed");
1863         require(totalSupply() + quantity <= maxSupply, "Hearts exceed");
1864         require(
1865             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1866             "Hearts exceed"
1867         );
1868         require(quantity > 0, "One heart at least");
1869         uint256 nonFreeMintQuantity = quantity;
1870         if (
1871             numberMinted(msg.sender) < MAX_FREEMINT_PER_ADDR &&
1872             freeMinted < freeSupply
1873         ) {
1874             nonFreeMintQuantity = quantity - MAX_FREEMINT_PER_ADDR;
1875             freeMinted += MAX_FREEMINT_PER_ADDR;
1876         }
1877         checkPrice(price * nonFreeMintQuantity);
1878         _safeMint(msg.sender, quantity);
1879         emit Minted(msg.sender, quantity);
1880     }
1881 
1882     function checkPrice(uint256 amount) private {
1883         require(msg.value >= amount, "Need to send more ETH");
1884     }
1885 
1886     function allowlistMint(bytes32[] memory _proof, uint256 quantity)
1887         external
1888         payable
1889     {
1890         require(status == Status.Preminting, "Not preminting");
1891         require(tx.origin == msg.sender, "Contract call not allowed");
1892         require(_verify(_leaf(msg.sender), _proof), "Not allowlisted");
1893         require(
1894             numberMinted(msg.sender) + quantity <= MAX_PREMINT_PER_ADDR,
1895             "Hearts exceed"
1896         );
1897         freeMint(quantity);
1898     }
1899 
1900     function devMint(uint256 quantity) external payable onlyOwner {
1901         require(
1902             numberMinted(msg.sender) + quantity <= teamSupply,
1903             "Hearts exceed"
1904         );
1905         require(totalSupply() + quantity <= teamSupply, "Hearts exceed");
1906         freeMint(quantity);
1907     }
1908 
1909     function freeMint(uint256 quantity) private {
1910         require(freeMinted + quantity <= freeSupply, "Free hearts exceed");
1911         _safeMint(msg.sender, quantity);
1912         freeMinted += quantity;
1913         emit Minted(msg.sender, quantity);
1914     }
1915 
1916     function numberMinted(address owner) public view returns (uint256) {
1917         return _numberMinted(owner);
1918     }
1919 
1920     function withdraw() public payable onlyOwner {
1921         payable(owner()).transfer(address(this).balance);
1922     }
1923 
1924     function setBaseURI(string calldata uri) public onlyOwner {
1925         baseURI = uri;
1926     }
1927 
1928     function setBoxURI(string calldata uri) public onlyOwner {
1929         boxURI = uri;
1930     }
1931 
1932     function setPrice(uint256 newPrice) public onlyOwner {
1933         price = newPrice;
1934     }
1935 
1936     function setAmount(uint256[] calldata amounts) public onlyOwner {
1937         MAX_MINT_PER_ADDR = amounts[0];
1938         MAX_PREMINT_PER_ADDR = amounts[1];
1939     }
1940 
1941     function decreaseMaxSupply(uint256 supply) public onlyOwner {
1942         require(
1943             supply <= maxSupply,
1944             "Max supply must be less than or equal to max supply"
1945         );
1946         maxSupply = supply;
1947     }
1948 
1949     function setFreeSupply(uint256 supply) public onlyOwner {
1950         require(
1951             supply <= maxSupply,
1952             "Free supply must be less than or equal to max supply"
1953         );
1954         freeSupply = supply;
1955     }
1956 
1957     function setStatus(Status newStatus) public onlyOwner {
1958         status = newStatus;
1959     }
1960 
1961     function setRoot(uint256 _root) public onlyOwner {
1962         root = bytes32(_root);
1963     }
1964 
1965     function _leaf(address account) internal pure returns (bytes32) {
1966         return keccak256(abi.encodePacked(account));
1967     }
1968 
1969     function _verify(bytes32 leaf, bytes32[] memory proof)
1970         internal
1971         view
1972         returns (bool)
1973     {
1974         return MerkleProof.verify(proof, root, leaf);
1975     }
1976 }