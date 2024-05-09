1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * The caller cannot approve to their own address.
21      */
22     error ApproveToCaller();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // =============================================================
274     //                           IERC2309
275     // =============================================================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
279      * (inclusive) is transferred from `from` to `to`, as defined in the
280      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
281      *
282      * See {_mintERC2309} for more details.
283      */
284     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
285 }
286 
287 library Base64 {
288     /**
289      * @dev Base64 Encoding/Decoding Table
290      */
291     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
292 
293     /**
294      * @dev Converts a `bytes` to its Bytes64 `string` representation.
295      */
296     function encode(bytes memory data) internal pure returns (string memory) {
297         /**
298          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
299          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
300          */
301         if (data.length == 0) return "";
302 
303         // Loads the table into memory
304         string memory table = _TABLE;
305 
306         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
307         // and split into 4 numbers of 6 bits.
308         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
309         // - `data.length + 2`  -> Round up
310         // - `/ 3`              -> Number of 3-bytes chunks
311         // - `4 *`              -> 4 characters for each chunk
312         string memory result = new string(4 * ((data.length + 2) / 3));
313 
314         /// @solidity memory-safe-assembly
315         assembly {
316             // Prepare the lookup table (skip the first "length" byte)
317             let tablePtr := add(table, 1)
318 
319             // Prepare result pointer, jump over length
320             let resultPtr := add(result, 32)
321 
322             // Run over the input, 3 bytes at a time
323             for {
324                 let dataPtr := data
325                 let endPtr := add(data, mload(data))
326             } lt(dataPtr, endPtr) {
327 
328             } {
329                 // Advance 3 bytes
330                 dataPtr := add(dataPtr, 3)
331                 let input := mload(dataPtr)
332 
333                 // To write each character, shift the 3 bytes (18 bits) chunk
334                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
335                 // and apply logical AND with 0x3F which is the number of
336                 // the previous character in the ASCII table prior to the Base64 Table
337                 // The result is then added to the table to get the character to write,
338                 // and finally write it in the result pointer but with a left shift
339                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
340 
341                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
342                 resultPtr := add(resultPtr, 1) // Advance
343 
344                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
345                 resultPtr := add(resultPtr, 1) // Advance
346 
347                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
348                 resultPtr := add(resultPtr, 1) // Advance
349 
350                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
351                 resultPtr := add(resultPtr, 1) // Advance
352             }
353 
354             // When data `bytes` is not exactly 3 bytes long
355             // it is padded with `=` characters at the end
356             switch mod(mload(data), 3)
357             case 1 {
358                 mstore8(sub(resultPtr, 1), 0x3d)
359                 mstore8(sub(resultPtr, 2), 0x3d)
360             }
361             case 2 {
362                 mstore8(sub(resultPtr, 1), 0x3d)
363             }
364         }
365 
366         return result;
367     }
368 }
369 
370 contract MergeBlob is IERC721A { 
371 
372     address private _owner;
373     modifier onlyOwner() { 
374         require(_owner==msg.sender, "No!"); 
375         _; 
376     }
377 
378     uint256 public constant MAX_PER_WALLET = 10;
379     uint256 public constant COST = 0 ether;
380     uint256 public MAX_SUPPLY = 3333;
381     uint256 public MAX_FREE_PER_WALLET = 2;
382     mapping(uint256 => uint256) grown;
383 
384 
385     constructor() {
386         _owner = msg.sender;
387     }
388 
389     function freeMint() external{
390         uint256 amount = MAX_FREE_PER_WALLET;
391         address _caller = _msgSenderERC721A();
392 
393         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
394         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
395 
396         _mint(_caller, amount);
397     }
398 
399 
400     // Mask of an entry in packed address data.
401     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
402 
403     // The bit position of `numberMinted` in packed address data.
404     uint256 private constant BITPOS_NUMBER_MINTED = 64;
405 
406     // The bit position of `numberBurned` in packed address data.
407     uint256 private constant BITPOS_NUMBER_BURNED = 128;
408 
409     // The bit position of `aux` in packed address data.
410     uint256 private constant BITPOS_AUX = 192;
411 
412     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
413     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
414 
415     // The bit position of `startTimestamp` in packed ownership.
416     uint256 private constant BITPOS_START_TIMESTAMP = 160;
417 
418     // The bit mask of the `burned` bit in packed ownership.
419     uint256 private constant BITMASK_BURNED = 1 << 224;
420 
421     // The bit position of the `nextInitialized` bit in packed ownership.
422     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
423 
424     // The bit mask of the `nextInitialized` bit in packed ownership.
425     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
426 
427     // The tokenId of the next token to be minted.
428     uint256 private _currentIndex = 0;
429 
430     // The number of tokens burned.
431     // uint256 private _burnCounter;
432 
433 
434     // Mapping from token ID to ownership details
435     // An empty struct value does not necessarily mean the token is unowned.
436     // See `_packedOwnershipOf` implementation for details.
437     //
438     // Bits Layout:
439     // - [0..159] `addr`
440     // - [160..223] `startTimestamp`
441     // - [224] `burned`
442     // - [225] `nextInitialized`
443     mapping(uint256 => uint256) private _packedOwnerships;
444 
445     // Mapping owner address to address data.
446     //
447     // Bits Layout:
448     // - [0..63] `balance`
449     // - [64..127] `numberMinted`
450     // - [128..191] `numberBurned`
451     // - [192..255] `aux`
452     mapping(address => uint256) private _packedAddressData;
453 
454     // Mapping from token ID to approved address.
455     mapping(uint256 => address) private _tokenApprovals;
456 
457     // Mapping from owner to operator approvals
458     mapping(address => mapping(address => bool)) private _operatorApprovals;
459 
460 
461    
462 
463     /**
464      * @dev Returns the starting token ID. 
465      * To change the starting token ID, please override this function.
466      */
467     function _startTokenId() internal view virtual returns (uint256) {
468         return 0;
469     }
470 
471     /**
472      * @dev Returns the next token ID to be minted.
473      */
474     function _nextTokenId() internal view returns (uint256) {
475         return _currentIndex;
476     }
477 
478     /**
479      * @dev Returns the total number of tokens in existence.
480      * Burned tokens will reduce the count. 
481      * To get the total number of tokens minted, please see `_totalMinted`.
482      */
483     function totalSupply() public view override returns (uint256) {
484         // Counter underflow is impossible as _burnCounter cannot be incremented
485         // more than `_currentIndex - _startTokenId()` times.
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total amount of tokens minted in the contract.
493      */
494     function _totalMinted() internal view returns (uint256) {
495         // Counter underflow is impossible as _currentIndex does not decrement,
496         // and it is initialized to `_startTokenId()`
497         unchecked {
498             return _currentIndex - _startTokenId();
499         }
500     }
501 
502 
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         // The interface IDs are constants representing the first 4 bytes of the XOR of
508         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
509         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
510         return
511             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
512             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
513             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
514     }
515 
516     /**
517      * @dev See {IERC721-balanceOf}.
518      */
519     function balanceOf(address owner) public view override returns (uint256) {
520         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
521         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the number of tokens minted by `owner`.
526      */
527     function _numberMinted(address owner) internal view returns (uint256) {
528         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
529     }
530 
531 
532 
533     /**
534      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
535      */
536     function _getAux(address owner) internal view returns (uint64) {
537         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
538     }
539 
540     /**
541      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
542      * If there are multiple variables, please pack them into a uint64.
543      */
544     function _setAux(address owner, uint64 aux) internal {
545         uint256 packed = _packedAddressData[owner];
546         uint256 auxCasted;
547         assembly { // Cast aux without masking.
548             auxCasted := aux
549         }
550         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
551         _packedAddressData[owner] = packed;
552     }
553 
554     /**
555      * Returns the packed ownership data of `tokenId`.
556      */
557     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
558         uint256 curr = tokenId;
559 
560         unchecked {
561             if (_startTokenId() <= curr)
562                 if (curr < _currentIndex) {
563                     uint256 packed = _packedOwnerships[curr];
564                     // If not burned.
565                     if (packed & BITMASK_BURNED == 0) {
566                         // Invariant:
567                         // There will always be an ownership that has an address and is not burned
568                         // before an ownership that does not have an address and is not burned.
569                         // Hence, curr will not underflow.
570                         //
571                         // We can directly compare the packed value.
572                         // If the address is zero, packed is zero.
573                         while (packed == 0) {
574                             packed = _packedOwnerships[--curr];
575                         }
576                         return packed;
577                     }
578                 }
579         }
580         revert OwnerQueryForNonexistentToken();
581     }
582 
583     /**
584      * Returns the unpacked `TokenOwnership` struct from `packed`.
585      */
586     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
587         ownership.addr = address(uint160(packed));
588         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
589         ownership.burned = packed & BITMASK_BURNED != 0;
590     }
591 
592     /**
593      * Returns the unpacked `TokenOwnership` struct at `index`.
594      */
595     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
596         return _unpackedOwnership(_packedOwnerships[index]);
597     }
598 
599     /**
600      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
601      */
602     function _initializeOwnershipAt(uint256 index) internal {
603         if (_packedOwnerships[index] == 0) {
604             _packedOwnerships[index] = _packedOwnershipOf(index);
605         }
606     }
607 
608     /**
609      * Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
611      */
612     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnershipOf(tokenId));
614     }
615 
616     /**
617      * @dev See {IERC721-ownerOf}.
618      */
619     function ownerOf(uint256 tokenId) public view override returns (address) {
620         return address(uint160(_packedOwnershipOf(tokenId)));
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-name}.
625      */
626     function name() public view virtual override returns (string memory) {
627         return 'Merge Blobs';
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-symbol}.
632      */
633     function symbol() public view virtual override returns (string memory) {
634         return 'MEBLO';
635     }
636 
637 
638     function render(uint256 _tokenId) internal view returns (string memory) {
639 		
640         uint256 growth = grown[_tokenId];
641 		string memory size = _toString(100 + growth*10);
642 
643         return string.concat(
644 			'<svg xmlns="http://www.w3.org/2000/svg" id="x" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1000 1000">',
645 			'<rect fill="#000000" width="1000" height="1000"/>',
646 			'<circle cx="500" cy="500" r="',size,'" fill="#FF0000"  />',
647 			'</svg>',
648 			''
649         );
650     }
651 
652     function tokenURI(uint256 _tokenId)
653         public
654         view
655         override
656         returns (string memory)
657     {
658         require(_exists(_tokenId), "token does not exists");
659 
660         string memory svg = string(abi.encodePacked(render(_tokenId)));
661         string memory json = Base64.encode(
662             abi.encodePacked(
663 				'{"name": "Merge Blobs #',_toString(_tokenId),'"',
664 				',"description":"Merge some Blobs"',
665                 ',"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '"}'
666             )
667         );
668 
669         return string(abi.encodePacked("data:application/json;base64,", json));
670     }
671 
672     function contractURI() public view returns (string memory) {
673         return 'ipfs://Qmbc2ZyoEnYDVZjXcxqN3PLQvghxgdRvEwybyFBqvGkY7E';
674     }
675 
676     /**
677      * @dev Casts the address to uint256 without masking.
678      */
679     function _addressToUint256(address value) private pure returns (uint256 result) {
680         assembly {
681             result := value
682         }
683     }
684 
685     /**
686      * @dev Casts the boolean to uint256 without branching.
687      */
688     function _boolToUint256(bool value) private pure returns (uint256 result) {
689         assembly {
690             result := value
691         }
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public override {
698         address owner = address(uint160(_packedOwnershipOf(tokenId)));
699         if (to == owner) revert();
700 
701         if (_msgSenderERC721A() != owner)
702             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
703                 revert ApprovalCallerNotOwnerNorApproved();
704             }
705 
706         _tokenApprovals[tokenId] = to;
707         emit Approval(owner, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view override returns (address) {
714         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
724 
725         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
726         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740             address from,
741             address to,
742             uint256 tokenId
743             ) public virtual override {
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751             address from,
752             address to,
753             uint256 tokenId
754             ) public virtual override {
755         safeTransferFrom(from, to, tokenId, '');
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762             address from,
763             address to,
764             uint256 tokenId,
765             bytes memory _data
766             ) public virtual override {
767         _transfer(from, to, tokenId);
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      */
777     function _exists(uint256 tokenId) internal view returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex;
781     }
782 
783     /**
784      * @dev Mints `quantity` tokens and transfers them to `to`.
785      *
786      * Requirements:
787      *
788      * - `to` cannot be the zero address.
789      * - `quantity` must be greater than 0.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _mint(address to, uint256 quantity) internal {
794         uint256 startTokenId = _currentIndex;
795         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
796         if (quantity == 0) revert MintZeroQuantity();
797 
798 
799         // Overflows are incredibly unrealistic.
800         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
801         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
802         unchecked {
803             // Updates:
804             // - `balance += quantity`.
805             // - `numberMinted += quantity`.
806             //
807             // We can directly add to the balance and number minted.
808             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
809 
810             // Updates:
811             // - `address` to the owner.
812             // - `startTimestamp` to the timestamp of minting.
813             // - `burned` to `false`.
814             // - `nextInitialized` to `quantity == 1`.
815             _packedOwnerships[startTokenId] =
816                 _addressToUint256(to) |
817                 (block.timestamp << BITPOS_START_TIMESTAMP) |
818                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
819 
820             uint256 updatedIndex = startTokenId;
821             uint256 end = updatedIndex + quantity;
822 
823             do {
824                 emit Transfer(address(0), to, updatedIndex++);
825             } while (updatedIndex < end);
826 
827             _currentIndex = updatedIndex;
828         }
829         _afterTokenTransfers(address(0), to, startTokenId, quantity);
830     }
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      *
840      * Emits a {Transfer} event.
841      */
842 
843      
844     function _transfer(
845             address from,
846             address to,
847             uint256 tokenId
848             ) private {
849 
850         uint256 growth = balanceOf(to);
851         grown[tokenId] += growth;
852 
853         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
854 
855         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
856 
857         address approvedAddress = _tokenApprovals[tokenId];
858 
859         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
860                 isApprovedForAll(from, _msgSenderERC721A()) ||
861                 approvedAddress == _msgSenderERC721A());
862 
863         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
864 
865         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
866 
867 
868         // Clear approvals from the previous owner.
869         if (_addressToUint256(approvedAddress) != 0) {
870             delete _tokenApprovals[tokenId];
871         }
872 
873         // Underflow of the sender's balance is impossible because we check for
874         // ownership above and the recipient's balance can't realistically overflow.
875         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
876         unchecked {
877             // We can directly increment and decrement the balances.
878             --_packedAddressData[from]; // Updates: `balance -= 1`.
879             ++_packedAddressData[to]; // Updates: `balance += 1`.
880 
881             // Updates:
882             // - `address` to the next owner.
883             // - `startTimestamp` to the timestamp of transfering.
884             // - `burned` to `false`.
885             // - `nextInitialized` to `true`.
886             _packedOwnerships[tokenId] =
887                 _addressToUint256(to) |
888                 (block.timestamp << BITPOS_START_TIMESTAMP) |
889                 BITMASK_NEXT_INITIALIZED;
890 
891             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
892             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
893                 uint256 nextTokenId = tokenId + 1;
894                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
895                 if (_packedOwnerships[nextTokenId] == 0) {
896                     // If the next slot is within bounds.
897                     if (nextTokenId != _currentIndex) {
898                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
899                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
900                     }
901                 }
902             }
903         }
904 
905         emit Transfer(from, to, tokenId);
906         _afterTokenTransfers(from, to, tokenId, 1);
907     }
908 
909 
910 
911 
912     /**
913      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
914      * minting.
915      * And also called after one token has been burned.
916      *
917      * startTokenId - the first token id to be transferred
918      * quantity - the amount to be transferred
919      *
920      * Calling conditions:
921      *
922      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
923      * transferred to `to`.
924      * - When `from` is zero, `tokenId` has been minted for `to`.
925      * - When `to` is zero, `tokenId` has been burned by `from`.
926      * - `from` and `to` are never both zero.
927      */
928     function _afterTokenTransfers(
929             address from,
930             address to,
931             uint256 startTokenId,
932             uint256 quantity
933             ) internal virtual {}
934 
935     /**
936      * @dev Returns the message sender (defaults to `msg.sender`).
937      *
938      * If you are writing GSN compatible contracts, you need to override this function.
939      */
940     function _msgSenderERC721A() internal view virtual returns (address) {
941         return msg.sender;
942     }
943 
944     /**
945      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
946      */
947     function _toString(uint256 value) internal pure returns (string memory ptr) {
948         assembly {
949             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
950             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
951             // We will need 1 32-byte word to store the length, 
952             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
953             ptr := add(mload(0x40), 128)
954 
955          // Update the free memory pointer to allocate.
956          mstore(0x40, ptr)
957 
958          // Cache the end of the memory to calculate the length later.
959          let end := ptr
960 
961          // We write the string from the rightmost digit to the leftmost digit.
962          // The following is essentially a do-while loop that also handles the zero case.
963          // Costs a bit more than early returning for the zero case,
964          // but cheaper in terms of deployment and overall runtime costs.
965          for { 
966              // Initialize and perform the first pass without check.
967              let temp := value
968                  // Move the pointer 1 byte leftwards to point to an empty character slot.
969                  ptr := sub(ptr, 1)
970                  // Write the character to the pointer. 48 is the ASCII index of '0'.
971                  mstore8(ptr, add(48, mod(temp, 10)))
972                  temp := div(temp, 10)
973          } temp { 
974              // Keep dividing `temp` until zero.
975         temp := div(temp, 10)
976          } { 
977              // Body of the for loop.
978         ptr := sub(ptr, 1)
979          mstore8(ptr, add(48, mod(temp, 10)))
980          }
981 
982      let length := sub(end, ptr)
983          // Move the pointer 32 bytes leftwards to make room for the length.
984          ptr := sub(ptr, 32)
985          // Store the length.
986          mstore(ptr, length)
987         }
988     }
989 }