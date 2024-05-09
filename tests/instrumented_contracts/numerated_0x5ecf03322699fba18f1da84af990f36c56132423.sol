1 // File: erc721a/contracts/IERC721A.sol
2     
3     
4     // ERC721A Contracts v4.2.3
5     // Creator: Chiru Labs
6     
7     pragma solidity ^0.8.4;
8     
9     /**
10      * @dev Interface of ERC721A.
11      */
12     interface IERC721A {
13         /**
14          * The caller must own the token or be an approved operator.
15          */
16         error ApprovalCallerNotOwnerNorApproved();
17     
18         /**
19          * The token does not exist.
20          */
21         error ApprovalQueryForNonexistentToken();
22     
23         /**
24          * Cannot query the balance for the zero address.
25          */
26         error BalanceQueryForZeroAddress();
27     
28         /**
29          * Cannot mint to the zero address.
30          */
31         error MintToZeroAddress();
32     
33         /**
34          * The quantity of tokens minted must be more than zero.
35          */
36         error MintZeroQuantity();
37     
38         /**
39          * The token does not exist.
40          */
41         error OwnerQueryForNonexistentToken();
42     
43         /**
44          * The caller must own the token or be an approved operator.
45          */
46         error TransferCallerNotOwnerNorApproved();
47     
48         /**
49          * The token must be owned by 'from'.
50          */
51         error TransferFromIncorrectOwner();
52     
53         /**
54          * Cannot safely transfer to a contract that does not implement the
55          * ERC721Receiver interface.
56          */
57         error TransferToNonERC721ReceiverImplementer();
58     
59         /**
60          * Cannot transfer to the zero address.
61          */
62         error TransferToZeroAddress();
63     
64         /**
65          * The token does not exist.
66          */
67         error URIQueryForNonexistentToken();
68     
69         /**
70          * The 'quantity' minted with ERC2309 exceeds the safety limit.
71          */
72         error MintERC2309QuantityExceedsLimit();
73     
74         /**
75          * The 'extraData' cannot be set on an unintialized ownership slot.
76          */
77         error OwnershipNotInitializedForExtraData();
78     
79         // =============================================================
80         //                            STRUCTS
81         // =============================================================
82     
83         struct TokenOwnership {
84             // The address of the owner.
85             address addr;
86             // Stores the start time of ownership with minimal overhead for tokenomics.
87             uint64 startTimestamp;
88             // Whether the token has been burned.
89             bool burned;
90             // Arbitrary data similar to 'startTimestamp' that can be set via {_extraData}.
91             uint24 extraData;
92         }
93     
94         // =============================================================
95         //                         TOKEN COUNTERS
96         // =============================================================
97     
98         /**
99          * @dev Returns the total number of tokens in existence.
100          * Burned tokens will reduce the count.
101          * To get the total number of tokens minted, please see {_totalMinted}.
102          */
103         function totalSupply() external view returns (uint256);
104     
105         // =============================================================
106         //                            IERC165
107         // =============================================================
108     
109         /**
110          * @dev Returns true if this contract implements the interface defined by
111          * 'interfaceId'. See the corresponding
112          * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
113          * to learn more about how these ids are created.
114          *
115          * This function call must use less than 30000 gas.
116          */
117         function supportsInterface(bytes4 interfaceId) external view returns (bool);
118     
119         // =============================================================
120         //                            IERC721
121         // =============================================================
122     
123         /**
124          * @dev Emitted when 'tokenId' token is transferred from 'from' to 'to'.
125          */
126         event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127     
128         /**
129          * @dev Emitted when 'owner' enables 'approved' to manage the 'tokenId' token.
130          */
131         event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132     
133         /**
134          * @dev Emitted when 'owner' enables or disables
135          * ('approved') 'operator' to manage all of its assets.
136          */
137         event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138     
139         /**
140          * @dev Returns the number of tokens in 'owner''s account.
141          */
142         function balanceOf(address owner) external view returns (uint256 balance);
143     
144         /**
145          * @dev Returns the owner of the 'tokenId' token.
146          *
147          * Requirements:
148          *
149          * - 'tokenId' must exist.
150          */
151         function ownerOf(uint256 tokenId) external view returns (address owner);
152     
153         /**
154          * @dev Safely transfers 'tokenId' token from 'from' to 'to',
155          * checking first that contract recipients are aware of the ERC721 protocol
156          * to prevent tokens from being forever locked.
157          *
158          * Requirements:
159          *
160          * - 'from' cannot be the zero address.
161          * - 'to' cannot be the zero address.
162          * - 'tokenId' token must exist and be owned by 'from'.
163          * - If the caller is not 'from', it must be have been allowed to move
164          * this token by either {approve} or {setApprovalForAll}.
165          * - If 'to' refers to a smart contract, it must implement
166          * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167          *
168          * Emits a {Transfer} event.
169          */
170         function safeTransferFrom(
171             address from,
172             address to,
173             uint256 tokenId,
174             bytes calldata data
175         ) external payable;
176     
177         /**
178          * @dev Equivalent to 'safeTransferFrom(from, to, tokenId, '')'.
179          */
180         function safeTransferFrom(
181             address from,
182             address to,
183             uint256 tokenId
184         ) external payable;
185     
186         /**
187          * @dev Transfers 'tokenId' from 'from' to 'to'.
188          *
189          * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
190          * whenever possible.
191          *
192          * Requirements:
193          *
194          * - 'from' cannot be the zero address.
195          * - 'to' cannot be the zero address.
196          * - 'tokenId' token must be owned by 'from'.
197          * - If the caller is not 'from', it must be approved to move this token
198          * by either {approve} or {setApprovalForAll}.
199          *
200          * Emits a {Transfer} event.
201          */
202         function transferFrom(
203             address from,
204             address to,
205             uint256 tokenId
206         ) external payable;
207     
208         /**
209          * @dev Gives permission to 'to' to transfer 'tokenId' token to another account.
210          * The approval is cleared when the token is transferred.
211          *
212          * Only a single account can be approved at a time, so approving the
213          * zero address clears previous approvals.
214          *
215          * Requirements:
216          *
217          * - The caller must own the token or be an approved operator.
218          * - 'tokenId' must exist.
219          *
220          * Emits an {Approval} event.
221          */
222         function approve(address to, uint256 tokenId) external payable;
223     
224         /**
225          * @dev Approve or remove 'operator' as an operator for the caller.
226          * Operators can call {transferFrom} or {safeTransferFrom}
227          * for any token owned by the caller.
228          *
229          * Requirements:
230          *
231          * - The 'operator' cannot be the caller.
232          *
233          * Emits an {ApprovalForAll} event.
234          */
235         function setApprovalForAll(address operator, bool _approved) external;
236     
237         /**
238          * @dev Returns the account approved for 'tokenId' token.
239          *
240          * Requirements:
241          *
242          * - 'tokenId' must exist.
243          */
244         function getApproved(uint256 tokenId) external view returns (address operator);
245     
246         /**
247          * @dev Returns if the 'operator' is allowed to manage all of the assets of 'owner'.
248          *
249          * See {setApprovalForAll}.
250          */
251         function isApprovedForAll(address owner, address operator) external view returns (bool);
252     
253         // =============================================================
254         //                        IERC721Metadata
255         // =============================================================
256     
257         /**
258          * @dev Returns the token collection name.
259          */
260         function name() external view returns (string memory);
261     
262         /**
263          * @dev Returns the token collection symbol.
264          */
265         function symbol() external view returns (string memory);
266     
267         /**
268          * @dev Returns the Uniform Resource Identifier (URI) for 'tokenId' token.
269          */
270         function tokenURI(uint256 tokenId) external view returns (string memory);
271     
272         // =============================================================
273         //                           IERC2309
274         // =============================================================
275     
276         /**
277          * @dev Emitted when tokens in 'fromTokenId' to 'toTokenId'
278          * (inclusive) is transferred from 'from' to 'to', as defined in the
279          * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
280          *
281          * See {_mintERC2309} for more details.
282          */
283         event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
284     }
285     
286     // File: erc721a/contracts/ERC721A.sol
287     
288     
289     // ERC721A Contracts v4.2.3
290     // Creator: Chiru Labs
291     
292     pragma solidity ^0.8.4;
293     
294     
295     /**
296      * @dev Interface of ERC721 token receiver.
297      */
298     interface ERC721A__IERC721Receiver {
299         function onERC721Received(
300             address operator,
301             address from,
302             uint256 tokenId,
303             bytes calldata data
304         ) external returns (bytes4);
305     }
306     
307     /**
308      * @title ERC721A
309      *
310      * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
311      * Non-Fungible Token Standard, including the Metadata extension.
312      * Optimized for lower gas during batch mints.
313      *
314      * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
315      * starting from '_startTokenId()'.
316      *
317      * Assumptions:
318      *
319      * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
320      * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
321      */
322     contract ERC721A is IERC721A {
323         // Bypass for a '--via-ir' bug (https://github.com/chiru-labs/ERC721A/pull/364).
324         struct TokenApprovalRef {
325             address value;
326         }
327     
328         // =============================================================
329         //                           CONSTANTS
330         // =============================================================
331     
332         // Mask of an entry in packed address data.
333         uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
334     
335         // The bit position of 'numberMinted' in packed address data.
336         uint256 private constant _BITPOS_NUMBER_MINTED = 64;
337     
338         // The bit position of 'numberBurned' in packed address data.
339         uint256 private constant _BITPOS_NUMBER_BURNED = 128;
340     
341         // The bit position of 'aux' in packed address data.
342         uint256 private constant _BITPOS_AUX = 192;
343     
344         // Mask of all 256 bits in packed address data except the 64 bits for 'aux'.
345         uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
346     
347         // The bit position of 'startTimestamp' in packed ownership.
348         uint256 private constant _BITPOS_START_TIMESTAMP = 160;
349     
350         // The bit mask of the 'burned' bit in packed ownership.
351         uint256 private constant _BITMASK_BURNED = 1 << 224;
352     
353         // The bit position of the 'nextInitialized' bit in packed ownership.
354         uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
355     
356         // The bit mask of the 'nextInitialized' bit in packed ownership.
357         uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
358     
359         // The bit position of 'extraData' in packed ownership.
360         uint256 private constant _BITPOS_EXTRA_DATA = 232;
361     
362         // Mask of all 256 bits in a packed ownership except the 24 bits for 'extraData'.
363         uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
364     
365         // The mask of the lower 160 bits for addresses.
366         uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
367     
368         // The maximum 'quantity' that can be minted with {_mintERC2309}.
369         // This limit is to prevent overflows on the address data entries.
370         // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
371         // is required to cause an overflow, which is unrealistic.
372         uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
373     
374         // The 'Transfer' event signature is given by:
375         // 'keccak256(bytes("Transfer(address,address,uint256)"))'.
376         bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
377             0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
378     
379         // =============================================================
380         //                            STORAGE
381         // =============================================================
382     
383         // The next token ID to be minted.
384         uint256 private _currentIndex;
385     
386         // The number of tokens burned.
387         uint256 private _burnCounter;
388     
389         // Token name
390         string private _name;
391     
392         // Token symbol
393         string private _symbol;
394     
395         // Mapping from token ID to ownership details
396         // An empty struct value does not necessarily mean the token is unowned.
397         // See {_packedOwnershipOf} implementation for details.
398         //
399         // Bits Layout:
400         // - [0..159]   'addr'
401         // - [160..223] 'startTimestamp'
402         // - [224]      'burned'
403         // - [225]      'nextInitialized'
404         // - [232..255] 'extraData'
405         mapping(uint256 => uint256) private _packedOwnerships;
406     
407         // Mapping owner address to address data.
408         //
409         // Bits Layout:
410         // - [0..63]    'balance'
411         // - [64..127]  'numberMinted'
412         // - [128..191] 'numberBurned'
413         // - [192..255] 'aux'
414         mapping(address => uint256) private _packedAddressData;
415     
416         // Mapping from token ID to approved address.
417         mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
418     
419         // Mapping from owner to operator approvals
420         mapping(address => mapping(address => bool)) private _operatorApprovals;
421     
422         // =============================================================
423         //                          CONSTRUCTOR
424         // =============================================================
425     
426         constructor(string memory name_, string memory symbol_) {
427             _name = name_;
428             _symbol = symbol_;
429             _currentIndex = _startTokenId();
430         }
431     
432         // =============================================================
433         //                   TOKEN COUNTING OPERATIONS
434         // =============================================================
435     
436         /**
437          * @dev Returns the starting token ID.
438          * To change the starting token ID, please override this function.
439          */
440         function _startTokenId() internal view virtual returns (uint256) {
441             return 0;
442         }
443     
444         /**
445          * @dev Returns the next token ID to be minted.
446          */
447         function _nextTokenId() internal view virtual returns (uint256) {
448             return _currentIndex;
449         }
450     
451         /**
452          * @dev Returns the total number of tokens in existence.
453          * Burned tokens will reduce the count.
454          * To get the total number of tokens minted, please see {_totalMinted}.
455          */
456         function totalSupply() public view virtual override returns (uint256) {
457             // Counter underflow is impossible as _burnCounter cannot be incremented
458             // more than '_currentIndex - _startTokenId()' times.
459             unchecked {
460                 return _currentIndex - _burnCounter - _startTokenId();
461             }
462         }
463     
464         /**
465          * @dev Returns the total amount of tokens minted in the contract.
466          */
467         function _totalMinted() internal view virtual returns (uint256) {
468             // Counter underflow is impossible as '_currentIndex' does not decrement,
469             // and it is initialized to '_startTokenId()'.
470             unchecked {
471                 return _currentIndex - _startTokenId();
472             }
473         }
474     
475         /**
476          * @dev Returns the total number of tokens burned.
477          */
478         function _totalBurned() internal view virtual returns (uint256) {
479             return _burnCounter;
480         }
481     
482         // =============================================================
483         //                    ADDRESS DATA OPERATIONS
484         // =============================================================
485     
486         /**
487          * @dev Returns the number of tokens in 'owner''s account.
488          */
489         function balanceOf(address owner) public view virtual override returns (uint256) {
490             if (owner == address(0)) revert BalanceQueryForZeroAddress();
491             return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
492         }
493     
494         /**
495          * Returns the number of tokens minted by 'owner'.
496          */
497         function _numberMinted(address owner) internal view returns (uint256) {
498             return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
499         }
500     
501         /**
502          * Returns the number of tokens burned by or on behalf of 'owner'.
503          */
504         function _numberBurned(address owner) internal view returns (uint256) {
505             return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
506         }
507     
508         /**
509          * Returns the auxiliary data for 'owner'. (e.g. number of whitelist mint slots used).
510          */
511         function _getAux(address owner) internal view returns (uint64) {
512             return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
513         }
514     
515         /**
516          * Sets the auxiliary data for 'owner'. (e.g. number of whitelist mint slots used).
517          * If there are multiple variables, please pack them into a uint64.
518          */
519         function _setAux(address owner, uint64 aux) internal virtual {
520             uint256 packed = _packedAddressData[owner];
521             uint256 auxCasted;
522             // Cast 'aux' with assembly to avoid redundant masking.
523             assembly {
524                 auxCasted := aux
525             }
526             packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
527             _packedAddressData[owner] = packed;
528         }
529     
530         // =============================================================
531         //                            IERC165
532         // =============================================================
533     
534         /**
535          * @dev Returns true if this contract implements the interface defined by
536          * 'interfaceId'. See the corresponding
537          * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
538          * to learn more about how these ids are created.
539          *
540          * This function call must use less than 30000 gas.
541          */
542         function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543             // The interface IDs are constants representing the first 4 bytes
544             // of the XOR of all function selectors in the interface.
545             // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
546             // (e.g. 'bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)')
547             return
548                 interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
549                 interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
550                 interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
551         }
552     
553         // =============================================================
554         //                        IERC721Metadata
555         // =============================================================
556     
557         /**
558          * @dev Returns the token collection name.
559          */
560         function name() public view virtual override returns (string memory) {
561             return _name;
562         }
563     
564         /**
565          * @dev Returns the token collection symbol.
566          */
567         function symbol() public view virtual override returns (string memory) {
568             return _symbol;
569         }
570     
571         /**
572          * @dev Returns the Uniform Resource Identifier (URI) for 'tokenId' token.
573          */
574         function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
575             if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
576     
577             string memory baseURI = _baseURI();
578             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
579         }
580     
581         /**
582          * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
583          * token will be the concatenation of the 'baseURI' and the 'tokenId'. Empty
584          * by default, it can be overridden in child contracts.
585          */
586         function _baseURI() internal view virtual returns (string memory) {
587             return '';
588         }
589     
590         // =============================================================
591         //                     OWNERSHIPS OPERATIONS
592         // =============================================================
593     
594         /**
595          * @dev Returns the owner of the 'tokenId' token.
596          *
597          * Requirements:
598          *
599          * - 'tokenId' must exist.
600          */
601         function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602             return address(uint160(_packedOwnershipOf(tokenId)));
603         }
604     
605         /**
606          * @dev Gas spent here starts off proportional to the maximum mint batch size.
607          * It gradually moves to O(1) as tokens get transferred around over time.
608          */
609         function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
610             return _unpackedOwnership(_packedOwnershipOf(tokenId));
611         }
612     
613         /**
614          * @dev Returns the unpacked 'TokenOwnership' struct at 'index'.
615          */
616         function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
617             return _unpackedOwnership(_packedOwnerships[index]);
618         }
619     
620         /**
621          * @dev Initializes the ownership slot minted at 'index' for efficiency purposes.
622          */
623         function _initializeOwnershipAt(uint256 index) internal virtual {
624             if (_packedOwnerships[index] == 0) {
625                 _packedOwnerships[index] = _packedOwnershipOf(index);
626             }
627         }
628     
629         /**
630          * Returns the packed ownership data of 'tokenId'.
631          */
632         function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
633             uint256 curr = tokenId;
634     
635             unchecked {
636                 if (_startTokenId() <= curr)
637                     if (curr < _currentIndex) {
638                         uint256 packed = _packedOwnerships[curr];
639                         // If not burned.
640                         if (packed & _BITMASK_BURNED == 0) {
641                             // Invariant:
642                             // There will always be an initialized ownership slot
643                             // (i.e. 'ownership.addr != address(0) && ownership.burned == false')
644                             // before an unintialized ownership slot
645                             // (i.e. 'ownership.addr == address(0) && ownership.burned == false')
646                             // Hence, 'curr' will not underflow.
647                             //
648                             // We can directly compare the packed value.
649                             // If the address is zero, packed will be zero.
650                             while (packed == 0) {
651                                 packed = _packedOwnerships[--curr];
652                             }
653                             return packed;
654                         }
655                     }
656             }
657             revert OwnerQueryForNonexistentToken();
658         }
659     
660         /**
661          * @dev Returns the unpacked 'TokenOwnership' struct from 'packed'.
662          */
663         function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
664             ownership.addr = address(uint160(packed));
665             ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
666             ownership.burned = packed & _BITMASK_BURNED != 0;
667             ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
668         }
669     
670         /**
671          * @dev Packs ownership data into a single uint256.
672          */
673         function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
674             assembly {
675                 // Mask 'owner' to the lower 160 bits, in case the upper bits somehow aren't clean.
676                 owner := and(owner, _BITMASK_ADDRESS)
677                 // 'owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags'.
678                 result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
679             }
680         }
681     
682         /**
683          * @dev Returns the 'nextInitialized' flag set if 'quantity' equals 1.
684          */
685         function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
686             // For branchless setting of the 'nextInitialized' flag.
687             assembly {
688                 // '(quantity == 1) << _BITPOS_NEXT_INITIALIZED'.
689                 result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
690             }
691         }
692     
693         // =============================================================
694         //                      APPROVAL OPERATIONS
695         // =============================================================
696     
697         /**
698          * @dev Gives permission to 'to' to transfer 'tokenId' token to another account.
699          * The approval is cleared when the token is transferred.
700          *
701          * Only a single account can be approved at a time, so approving the
702          * zero address clears previous approvals.
703          *
704          * Requirements:
705          *
706          * - The caller must own the token or be an approved operator.
707          * - 'tokenId' must exist.
708          *
709          * Emits an {Approval} event.
710          */
711         function approve(address to, uint256 tokenId) public payable virtual override {
712             address owner = ownerOf(tokenId);
713     
714             if (_msgSenderERC721A() != owner)
715                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
716                     revert ApprovalCallerNotOwnerNorApproved();
717                 }
718     
719             _tokenApprovals[tokenId].value = to;
720             emit Approval(owner, to, tokenId);
721         }
722     
723         /**
724          * @dev Returns the account approved for 'tokenId' token.
725          *
726          * Requirements:
727          *
728          * - 'tokenId' must exist.
729          */
730         function getApproved(uint256 tokenId) public view virtual override returns (address) {
731             if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
732     
733             return _tokenApprovals[tokenId].value;
734         }
735     
736         /**
737          * @dev Approve or remove 'operator' as an operator for the caller.
738          * Operators can call {transferFrom} or {safeTransferFrom}
739          * for any token owned by the caller.
740          *
741          * Requirements:
742          *
743          * - The 'operator' cannot be the caller.
744          *
745          * Emits an {ApprovalForAll} event.
746          */
747         function setApprovalForAll(address operator, bool approved) public virtual override {
748             _operatorApprovals[_msgSenderERC721A()][operator] = approved;
749             emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
750         }
751     
752         /**
753          * @dev Returns if the 'operator' is allowed to manage all of the assets of 'owner'.
754          *
755          * See {setApprovalForAll}.
756          */
757         function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
758             return _operatorApprovals[owner][operator];
759         }
760     
761         /**
762          * @dev Returns whether 'tokenId' exists.
763          *
764          * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765          *
766          * Tokens start existing when they are minted. See {_mint}.
767          */
768         function _exists(uint256 tokenId) internal view virtual returns (bool) {
769             return
770                 _startTokenId() <= tokenId &&
771                 tokenId < _currentIndex && // If within bounds,
772                 _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
773         }
774     
775         /**
776          * @dev Returns whether 'msgSender' is equal to 'approvedAddress' or 'owner'.
777          */
778         function _isSenderApprovedOrOwner(
779             address approvedAddress,
780             address owner,
781             address msgSender
782         ) private pure returns (bool result) {
783             assembly {
784                 // Mask 'owner' to the lower 160 bits, in case the upper bits somehow aren't clean.
785                 owner := and(owner, _BITMASK_ADDRESS)
786                 // Mask 'msgSender' to the lower 160 bits, in case the upper bits somehow aren't clean.
787                 msgSender := and(msgSender, _BITMASK_ADDRESS)
788                 // 'msgSender == owner || msgSender == approvedAddress'.
789                 result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
790             }
791         }
792     
793         /**
794          * @dev Returns the storage slot and value for the approved address of 'tokenId'.
795          */
796         function _getApprovedSlotAndAddress(uint256 tokenId)
797             private
798             view
799             returns (uint256 approvedAddressSlot, address approvedAddress)
800         {
801             TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
802             // The following is equivalent to 'approvedAddress = _tokenApprovals[tokenId].value'.
803             assembly {
804                 approvedAddressSlot := tokenApproval.slot
805                 approvedAddress := sload(approvedAddressSlot)
806             }
807         }
808     
809         // =============================================================
810         //                      TRANSFER OPERATIONS
811         // =============================================================
812     
813         /**
814          * @dev Transfers 'tokenId' from 'from' to 'to'.
815          *
816          * Requirements:
817          *
818          * - 'from' cannot be the zero address.
819          * - 'to' cannot be the zero address.
820          * - 'tokenId' token must be owned by 'from'.
821          * - If the caller is not 'from', it must be approved to move this token
822          * by either {approve} or {setApprovalForAll}.
823          *
824          * Emits a {Transfer} event.
825          */
826         function transferFrom(
827             address from,
828             address to,
829             uint256 tokenId
830         ) public payable virtual override {
831             uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
832     
833             if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
834     
835             (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
836     
837             // The nested ifs save around 20+ gas over a compound boolean condition.
838             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
839                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
840     
841             if (to == address(0)) revert TransferToZeroAddress();
842     
843             _beforeTokenTransfers(from, to, tokenId, 1);
844     
845             // Clear approvals from the previous owner.
846             assembly {
847                 if approvedAddress {
848                     // This is equivalent to 'delete _tokenApprovals[tokenId]'.
849                     sstore(approvedAddressSlot, 0)
850                 }
851             }
852     
853             // Underflow of the sender's balance is impossible because we check for
854             // ownership above and the recipient's balance can't realistically overflow.
855             // Counter overflow is incredibly unrealistic as 'tokenId' would have to be 2**256.
856             unchecked {
857                 // We can directly increment and decrement the balances.
858                 --_packedAddressData[from]; // Updates: 'balance -= 1'.
859                 ++_packedAddressData[to]; // Updates: 'balance += 1'.
860     
861                 // Updates:
862                 // - 'address' to the next owner.
863                 // - 'startTimestamp' to the timestamp of transfering.
864                 // - 'burned' to 'false'.
865                 // - 'nextInitialized' to 'true'.
866                 _packedOwnerships[tokenId] = _packOwnershipData(
867                     to,
868                     _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
869                 );
870     
871                 // If the next slot may not have been initialized (i.e. 'nextInitialized == false') .
872                 if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
873                     uint256 nextTokenId = tokenId + 1;
874                     // If the next slot's address is zero and not burned (i.e. packed value is zero).
875                     if (_packedOwnerships[nextTokenId] == 0) {
876                         // If the next slot is within bounds.
877                         if (nextTokenId != _currentIndex) {
878                             // Initialize the next slot to maintain correctness for 'ownerOf(tokenId + 1)'.
879                             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
880                         }
881                     }
882                 }
883             }
884     
885             emit Transfer(from, to, tokenId);
886             _afterTokenTransfers(from, to, tokenId, 1);
887         }
888     
889         /**
890          * @dev Equivalent to 'safeTransferFrom(from, to, tokenId, '')'.
891          */
892         function safeTransferFrom(
893             address from,
894             address to,
895             uint256 tokenId
896         ) public payable virtual override {
897             safeTransferFrom(from, to, tokenId, '');
898         }
899     
900         /**
901          * @dev Safely transfers 'tokenId' token from 'from' to 'to'.
902          *
903          * Requirements:
904          *
905          * - 'from' cannot be the zero address.
906          * - 'to' cannot be the zero address.
907          * - 'tokenId' token must exist and be owned by 'from'.
908          * - If the caller is not 'from', it must be approved to move this token
909          * by either {approve} or {setApprovalForAll}.
910          * - If 'to' refers to a smart contract, it must implement
911          * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912          *
913          * Emits a {Transfer} event.
914          */
915         function safeTransferFrom(
916             address from,
917             address to,
918             uint256 tokenId,
919             bytes memory _data
920         ) public payable virtual override {
921             transferFrom(from, to, tokenId);
922             if (to.code.length != 0)
923                 if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
924                     revert TransferToNonERC721ReceiverImplementer();
925                 }
926         }
927     
928         /**
929          * @dev Hook that is called before a set of serially-ordered token IDs
930          * are about to be transferred. This includes minting.
931          * And also called before burning one token.
932          *
933          * 'startTokenId' - the first token ID to be transferred.
934          * 'quantity' - the amount to be transferred.
935          *
936          * Calling conditions:
937          *
938          * - When 'from' and 'to' are both non-zero, 'from''s 'tokenId' will be
939          * transferred to 'to'.
940          * - When 'from' is zero, 'tokenId' will be minted for 'to'.
941          * - When 'to' is zero, 'tokenId' will be burned by 'from'.
942          * - 'from' and 'to' are never both zero.
943          */
944         function _beforeTokenTransfers(
945             address from,
946             address to,
947             uint256 startTokenId,
948             uint256 quantity
949         ) internal virtual {}
950     
951         /**
952          * @dev Hook that is called after a set of serially-ordered token IDs
953          * have been transferred. This includes minting.
954          * And also called after one token has been burned.
955          *
956          * 'startTokenId' - the first token ID to be transferred.
957          * 'quantity' - the amount to be transferred.
958          *
959          * Calling conditions:
960          *
961          * - When 'from' and 'to' are both non-zero, 'from''s 'tokenId' has been
962          * transferred to 'to'.
963          * - When 'from' is zero, 'tokenId' has been minted for 'to'.
964          * - When 'to' is zero, 'tokenId' has been burned by 'from'.
965          * - 'from' and 'to' are never both zero.
966          */
967         function _afterTokenTransfers(
968             address from,
969             address to,
970             uint256 startTokenId,
971             uint256 quantity
972         ) internal virtual {}
973     
974         /**
975          * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
976          *
977          * 'from' - Previous owner of the given token ID.
978          * 'to' - Target address that will receive the token.
979          * 'tokenId' - Token ID to be transferred.
980          * '_data' - Optional data to send along with the call.
981          *
982          * Returns whether the call correctly returned the expected magic value.
983          */
984         function _checkContractOnERC721Received(
985             address from,
986             address to,
987             uint256 tokenId,
988             bytes memory _data
989         ) private returns (bool) {
990             try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
991                 bytes4 retval
992             ) {
993                 return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
994             } catch (bytes memory reason) {
995                 if (reason.length == 0) {
996                     revert TransferToNonERC721ReceiverImplementer();
997                 } else {
998                     assembly {
999                         revert(add(32, reason), mload(reason))
1000                     }
1001                 }
1002             }
1003         }
1004     
1005         // =============================================================
1006         //                        MINT OPERATIONS
1007         // =============================================================
1008     
1009         /**
1010          * @dev Mints 'quantity' tokens and transfers them to 'to'.
1011          *
1012          * Requirements:
1013          *
1014          * - 'to' cannot be the zero address.
1015          * - 'quantity' must be greater than 0.
1016          *
1017          * Emits a {Transfer} event for each mint.
1018          */
1019         function _mint(address to, uint256 quantity) internal virtual {
1020             uint256 startTokenId = _currentIndex;
1021             if (quantity == 0) revert MintZeroQuantity();
1022     
1023             _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1024     
1025             // Overflows are incredibly unrealistic.
1026             // 'balance' and 'numberMinted' have a maximum limit of 2**64.
1027             // 'tokenId' has a maximum limit of 2**256.
1028             unchecked {
1029                 // Updates:
1030                 // - 'balance += quantity'.
1031                 // - 'numberMinted += quantity'.
1032                 //
1033                 // We can directly add to the 'balance' and 'numberMinted'.
1034                 _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1035     
1036                 // Updates:
1037                 // - 'address' to the owner.
1038                 // - 'startTimestamp' to the timestamp of minting.
1039                 // - 'burned' to 'false'.
1040                 // - 'nextInitialized' to 'quantity == 1'.
1041                 _packedOwnerships[startTokenId] = _packOwnershipData(
1042                     to,
1043                     _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1044                 );
1045     
1046                 uint256 toMasked;
1047                 uint256 end = startTokenId + quantity;
1048     
1049                 // Use assembly to loop and emit the 'Transfer' event for gas savings.
1050                 // The duplicated 'log4' removes an extra check and reduces stack juggling.
1051                 // The assembly, together with the surrounding Solidity code, have been
1052                 // delicately arranged to nudge the compiler into producing optimized opcodes.
1053                 assembly {
1054                     // Mask 'to' to the lower 160 bits, in case the upper bits somehow aren't clean.
1055                     toMasked := and(to, _BITMASK_ADDRESS)
1056                     // Emit the 'Transfer' event.
1057                     log4(
1058                         0, // Start of data (0, since no data).
1059                         0, // End of data (0, since no data).
1060                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1061                         0, // 'address(0)'.
1062                         toMasked, // 'to'.
1063                         startTokenId // 'tokenId'.
1064                     )
1065     
1066                     // The 'iszero(eq(,))' check ensures that large values of 'quantity'
1067                     // that overflows uint256 will make the loop run out of gas.
1068                     // The compiler will optimize the 'iszero' away for performance.
1069                     for {
1070                         let tokenId := add(startTokenId, 1)
1071                     } iszero(eq(tokenId, end)) {
1072                         tokenId := add(tokenId, 1)
1073                     } {
1074                         // Emit the 'Transfer' event. Similar to above.
1075                         log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1076                     }
1077                 }
1078                 if (toMasked == 0) revert MintToZeroAddress();
1079     
1080                 _currentIndex = end;
1081             }
1082             _afterTokenTransfers(address(0), to, startTokenId, quantity);
1083         }
1084     
1085         /**
1086          * @dev Mints 'quantity' tokens and transfers them to 'to'.
1087          *
1088          * This function is intended for efficient minting only during contract creation.
1089          *
1090          * It emits only one {ConsecutiveTransfer} as defined in
1091          * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1092          * instead of a sequence of {Transfer} event(s).
1093          *
1094          * Calling this function outside of contract creation WILL make your contract
1095          * non-compliant with the ERC721 standard.
1096          * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1097          * {ConsecutiveTransfer} event is only permissible during contract creation.
1098          *
1099          * Requirements:
1100          *
1101          * - 'to' cannot be the zero address.
1102          * - 'quantity' must be greater than 0.
1103          *
1104          * Emits a {ConsecutiveTransfer} event.
1105          */
1106         function _mintERC2309(address to, uint256 quantity) internal virtual {
1107             uint256 startTokenId = _currentIndex;
1108             if (to == address(0)) revert MintToZeroAddress();
1109             if (quantity == 0) revert MintZeroQuantity();
1110             if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1111     
1112             _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1113     
1114             // Overflows are unrealistic due to the above check for 'quantity' to be below the limit.
1115             unchecked {
1116                 // Updates:
1117                 // - 'balance += quantity'.
1118                 // - 'numberMinted += quantity'.
1119                 //
1120                 // We can directly add to the 'balance' and 'numberMinted'.
1121                 _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1122     
1123                 // Updates:
1124                 // - 'address' to the owner.
1125                 // - 'startTimestamp' to the timestamp of minting.
1126                 // - 'burned' to 'false'.
1127                 // - 'nextInitialized' to 'quantity == 1'.
1128                 _packedOwnerships[startTokenId] = _packOwnershipData(
1129                     to,
1130                     _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1131                 );
1132     
1133                 emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1134     
1135                 _currentIndex = startTokenId + quantity;
1136             }
1137             _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138         }
1139     
1140         /**
1141          * @dev Safely mints 'quantity' tokens and transfers them to 'to'.
1142          *
1143          * Requirements:
1144          *
1145          * - If 'to' refers to a smart contract, it must implement
1146          * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1147          * - 'quantity' must be greater than 0.
1148          *
1149          * See {_mint}.
1150          *
1151          * Emits a {Transfer} event for each mint.
1152          */
1153         function _safeMint(
1154             address to,
1155             uint256 quantity,
1156             bytes memory _data
1157         ) internal virtual {
1158             _mint(to, quantity);
1159     
1160             unchecked {
1161                 if (to.code.length != 0) {
1162                     uint256 end = _currentIndex;
1163                     uint256 index = end - quantity;
1164                     do {
1165                         if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1166                             revert TransferToNonERC721ReceiverImplementer();
1167                         }
1168                     } while (index < end);
1169                     // Reentrancy protection.
1170                     if (_currentIndex != end) revert();
1171                 }
1172             }
1173         }
1174     
1175         /**
1176          * @dev Equivalent to '_safeMint(to, quantity, '')'.
1177          */
1178         function _safeMint(address to, uint256 quantity) internal virtual {
1179             _safeMint(to, quantity, '');
1180         }
1181     
1182         // =============================================================
1183         //                        BURN OPERATIONS
1184         // =============================================================
1185     
1186         /**
1187          * @dev Equivalent to '_burn(tokenId, false)'.
1188          */
1189         function _burn(uint256 tokenId) internal virtual {
1190             _burn(tokenId, false);
1191         }
1192     
1193         /**
1194          * @dev Destroys 'tokenId'.
1195          * The approval is cleared when the token is burned.
1196          *
1197          * Requirements:
1198          *
1199          * - 'tokenId' must exist.
1200          *
1201          * Emits a {Transfer} event.
1202          */
1203         function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1204             uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1205     
1206             address from = address(uint160(prevOwnershipPacked));
1207     
1208             (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1209     
1210             if (approvalCheck) {
1211                 // The nested ifs save around 20+ gas over a compound boolean condition.
1212                 if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1213                     if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1214             }
1215     
1216             _beforeTokenTransfers(from, address(0), tokenId, 1);
1217     
1218             // Clear approvals from the previous owner.
1219             assembly {
1220                 if approvedAddress {
1221                     // This is equivalent to 'delete _tokenApprovals[tokenId]'.
1222                     sstore(approvedAddressSlot, 0)
1223                 }
1224             }
1225     
1226             // Underflow of the sender's balance is impossible because we check for
1227             // ownership above and the recipient's balance can't realistically overflow.
1228             // Counter overflow is incredibly unrealistic as 'tokenId' would have to be 2**256.
1229             unchecked {
1230                 // Updates:
1231                 // - 'balance -= 1'.
1232                 // - 'numberBurned += 1'.
1233                 //
1234                 // We can directly decrement the balance, and increment the number burned.
1235                 // This is equivalent to 'packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;'.
1236                 _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1237     
1238                 // Updates:
1239                 // - 'address' to the last owner.
1240                 // - 'startTimestamp' to the timestamp of burning.
1241                 // - 'burned' to 'true'.
1242                 // - 'nextInitialized' to 'true'.
1243                 _packedOwnerships[tokenId] = _packOwnershipData(
1244                     from,
1245                     (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1246                 );
1247     
1248                 // If the next slot may not have been initialized (i.e. 'nextInitialized == false') .
1249                 if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1250                     uint256 nextTokenId = tokenId + 1;
1251                     // If the next slot's address is zero and not burned (i.e. packed value is zero).
1252                     if (_packedOwnerships[nextTokenId] == 0) {
1253                         // If the next slot is within bounds.
1254                         if (nextTokenId != _currentIndex) {
1255                             // Initialize the next slot to maintain correctness for 'ownerOf(tokenId + 1)'.
1256                             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1257                         }
1258                     }
1259                 }
1260             }
1261     
1262             emit Transfer(from, address(0), tokenId);
1263             _afterTokenTransfers(from, address(0), tokenId, 1);
1264     
1265             // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1266             unchecked {
1267                 _burnCounter++;
1268             }
1269         }
1270     
1271         // =============================================================
1272         //                     EXTRA DATA OPERATIONS
1273         // =============================================================
1274     
1275         /**
1276          * @dev Directly sets the extra data for the ownership data 'index'.
1277          */
1278         function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1279             uint256 packed = _packedOwnerships[index];
1280             if (packed == 0) revert OwnershipNotInitializedForExtraData();
1281             uint256 extraDataCasted;
1282             // Cast 'extraData' with assembly to avoid redundant masking.
1283             assembly {
1284                 extraDataCasted := extraData
1285             }
1286             packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1287             _packedOwnerships[index] = packed;
1288         }
1289     
1290         /**
1291          * @dev Called during each token transfer to set the 24bit 'extraData' field.
1292          * Intended to be overridden by the cosumer contract.
1293          *
1294          * 'previousExtraData' - the value of 'extraData' before transfer.
1295          *
1296          * Calling conditions:
1297          *
1298          * - When 'from' and 'to' are both non-zero, 'from''s 'tokenId' will be
1299          * transferred to 'to'.
1300          * - When 'from' is zero, 'tokenId' will be minted for 'to'.
1301          * - When 'to' is zero, 'tokenId' will be burned by 'from'.
1302          * - 'from' and 'to' are never both zero.
1303          */
1304         function _extraData(
1305             address from,
1306             address to,
1307             uint24 previousExtraData
1308         ) internal view virtual returns (uint24) {}
1309     
1310         /**
1311          * @dev Returns the next extra data for the packed ownership data.
1312          * The returned result is shifted into position.
1313          */
1314         function _nextExtraData(
1315             address from,
1316             address to,
1317             uint256 prevOwnershipPacked
1318         ) private view returns (uint256) {
1319             uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1320             return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1321         }
1322     
1323         // =============================================================
1324         //                       OTHER OPERATIONS
1325         // =============================================================
1326     
1327         /**
1328          * @dev Returns the message sender (defaults to 'msg.sender').
1329          *
1330          * If you are writing GSN compatible contracts, you need to override this function.
1331          */
1332         function _msgSenderERC721A() internal view virtual returns (address) {
1333             return msg.sender;
1334         }
1335     
1336         /**
1337          * @dev Converts a uint256 to its ASCII string decimal representation.
1338          */
1339         function _toString(uint256 value) internal pure virtual returns (string memory str) {
1340             assembly {
1341                 // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1342                 // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1343                 // We will need 1 word for the trailing zeros padding, 1 word for the length,
1344                 // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1345                 let m := add(mload(0x40), 0xa0)
1346                 // Update the free memory pointer to allocate.
1347                 mstore(0x40, m)
1348                 // Assign the 'str' to the end.
1349                 str := sub(m, 0x20)
1350                 // Zeroize the slot after the string.
1351                 mstore(str, 0)
1352     
1353                 // Cache the end of the memory to calculate the length later.
1354                 let end := str
1355     
1356                 // We write the string from rightmost digit to leftmost digit.
1357                 // The following is essentially a do-while loop that also handles the zero case.
1358                 // prettier-ignore
1359                 for { let temp := value } 1 {} {
1360                     str := sub(str, 1)
1361                     // Write the character to the pointer.
1362                     // The ASCII index of the '0' character is 48.
1363                     mstore8(str, add(48, mod(temp, 10)))
1364                     // Keep dividing 'temp' until zero.
1365                     temp := div(temp, 10)
1366                     // prettier-ignore
1367                     if iszero(temp) { break }
1368                 }
1369     
1370                 let length := sub(end, str)
1371                 // Move the pointer 32 bytes leftwards to make room for the length.
1372                 str := sub(str, 0x20)
1373                 // Store the length.
1374                 mstore(str, length)
1375             }
1376         }
1377     }
1378     
1379     // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1380     
1381     
1382     // ERC721A Contracts v4.2.3
1383     // Creator: Chiru Labs
1384     
1385     pragma solidity ^0.8.4;
1386     
1387     
1388     /**
1389      * @dev Interface of ERC721AQueryable.
1390      */
1391     interface IERC721AQueryable is IERC721A {
1392         /**
1393          * Invalid query range ('start' >= 'stop').
1394          */
1395         error InvalidQueryRange();
1396     
1397         /**
1398          * @dev Returns the 'TokenOwnership' struct at 'tokenId' without reverting.
1399          *
1400          * If the 'tokenId' is out of bounds:
1401          *
1402          * - 'addr = address(0)'
1403          * - 'startTimestamp = 0'
1404          * - 'burned = false'
1405          * - 'extraData = 0'
1406          *
1407          * If the 'tokenId' is burned:
1408          *
1409          * - 'addr = <Address of owner before token was burned>'
1410          * - 'startTimestamp = <Timestamp when token was burned>'
1411          * - 'burned = true'
1412          * - 'extraData = <Extra data when token was burned>'
1413          *
1414          * Otherwise:
1415          *
1416          * - 'addr = <Address of owner>'
1417          * - 'startTimestamp = <Timestamp of start of ownership>'
1418          * - 'burned = false'
1419          * - 'extraData = <Extra data at start of ownership>'
1420          */
1421         function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1422     
1423         /**
1424          * @dev Returns an array of 'TokenOwnership' structs at 'tokenIds' in order.
1425          * See {ERC721AQueryable-explicitOwnershipOf}
1426          */
1427         function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1428     
1429         /**
1430          * @dev Returns an array of token IDs owned by 'owner',
1431          * in the range ['start', 'stop')
1432          * (i.e. 'start <= tokenId < stop').
1433          *
1434          * This function allows for tokens to be queried if the collection
1435          * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1436          *
1437          * Requirements:
1438          *
1439          * - 'start < stop'
1440          */
1441         function tokensOfOwnerIn(
1442             address owner,
1443             uint256 start,
1444             uint256 stop
1445         ) external view returns (uint256[] memory);
1446     
1447         /**
1448          * @dev Returns an array of token IDs owned by 'owner'.
1449          *
1450          * This function scans the ownership mapping and is O('totalSupply') in complexity.
1451          * It is meant to be called off-chain.
1452          *
1453          * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1454          * multiple smaller scans if the collection is large enough to cause
1455          * an out-of-gas error (10K collections should be fine).
1456          */
1457         function tokensOfOwner(address owner) external view returns (uint256[] memory);
1458     }
1459     
1460     // File: contracts/IERC721L.sol
1461     
1462     pragma solidity ^0.8.4;
1463     
1464     
1465     interface IERC721L is IERC721AQueryable {
1466         error CannotIncreaseMaxMintableSupply();
1467         error CannotUpdatePermanentBaseURI();
1468         error GlobalWalletLimitOverflow();
1469         error InsufficientStageTimeGap();
1470         error InvalidProof();
1471         error InvalidStage();
1472         error InvalidStageArgsLength();
1473         error InvalidStartAndEndTimestamp();
1474         error NoSupplyLeft();
1475         error NotEnoughValue();
1476         error StageSupplyExceeded();
1477         error TimestampExpired();
1478         error WalletGlobalLimitExceeded();
1479         error WalletStageLimitExceeded();
1480         error WithdrawFailed();
1481     
1482         struct MintStageInfo {
1483             uint80 cost;
1484             uint32 walletLimit; // 0 for unlimited
1485             bytes32 merkleRoot; // 0x0 for no presale enforced
1486             uint24 maxStageSupply; // 0 for unlimited
1487             uint64 startTimeUnixSeconds;
1488             uint64 endTimeUnixSeconds;
1489         }
1490     
1491         event UpdateStage(
1492             uint256 stage,
1493             uint80 cost,
1494             uint32 walletLimit,
1495             bytes32 merkleRoot,
1496             uint24 maxStageSupply,
1497             uint64 startTimeUnixSeconds,
1498             uint64 endTimeUnixSeconds
1499         );
1500     
1501     
1502         event SetMaxMintableSupply(uint256 maxMintableSupply);
1503         event SetGlobalWalletLimit(uint256 globalWalletLimit);
1504         event SetActiveStage(uint256 activeStage);
1505         event SetBaseURI(string baseURI);
1506         event PermanentBaseURI(string baseURI);
1507         event Withdraw(uint256 value);
1508     
1509     
1510         function getNumberStages() external view returns (uint256);
1511     
1512         function getGlobalWalletLimit() external view returns (uint256);
1513     
1514         function getMaxMintableSupply() external view returns (uint256);
1515     
1516         function totalMintedByAddress(address a) external view returns (uint256);
1517     
1518         function getTokenURISuffix() external view returns (string memory);
1519     
1520         function getStageInfo(uint256 index)
1521             external
1522             view
1523             returns (
1524                 MintStageInfo memory,
1525                 uint32,
1526                 uint256
1527             );
1528     
1529         function getActiveStageFromTimestamp(uint64 timestamp)
1530             external
1531             view
1532             returns (uint256);
1533     
1534     }
1535     // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1536     
1537     
1538     // ERC721A Contracts v4.2.3
1539     // Creator: Chiru Labs
1540     
1541     pragma solidity ^0.8.4;
1542     
1543     
1544     
1545     /**
1546      * @title ERC721AQueryable.
1547      *
1548      * @dev ERC721A subclass with convenience query functions.
1549      */
1550     abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1551         /**
1552          * @dev Returns the 'TokenOwnership' struct at 'tokenId' without reverting.
1553          *
1554          * If the 'tokenId' is out of bounds:
1555          *
1556          * - 'addr = address(0)'
1557          * - 'startTimestamp = 0'
1558          * - 'burned = false'
1559          * - 'extraData = 0'
1560          *
1561          * If the 'tokenId' is burned:
1562          *
1563          * - 'addr = <Address of owner before token was burned>'
1564          * - 'startTimestamp = <Timestamp when token was burned>'
1565          * - 'burned = true'
1566          * - 'extraData = <Extra data when token was burned>'
1567          *
1568          * Otherwise:
1569          *
1570          * - 'addr = <Address of owner>'
1571          * - 'startTimestamp = <Timestamp of start of ownership>'
1572          * - 'burned = false'
1573          * - 'extraData = <Extra data at start of ownership>'
1574          */
1575         function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1576             TokenOwnership memory ownership;
1577             if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1578                 return ownership;
1579             }
1580             ownership = _ownershipAt(tokenId);
1581             if (ownership.burned) {
1582                 return ownership;
1583             }
1584             return _ownershipOf(tokenId);
1585         }
1586     
1587         /**
1588          * @dev Returns an array of 'TokenOwnership' structs at 'tokenIds' in order.
1589          * See {ERC721AQueryable-explicitOwnershipOf}
1590          */
1591         function explicitOwnershipsOf(uint256[] calldata tokenIds)
1592             external
1593             view
1594             virtual
1595             override
1596             returns (TokenOwnership[] memory)
1597         {
1598             unchecked {
1599                 uint256 tokenIdsLength = tokenIds.length;
1600                 TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1601                 for (uint256 i; i != tokenIdsLength; ++i) {
1602                     ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1603                 }
1604                 return ownerships;
1605             }
1606         }
1607     
1608         /**
1609          * @dev Returns an array of token IDs owned by 'owner',
1610          * in the range ['start', 'stop')
1611          * (i.e. 'start <= tokenId < stop').
1612          *
1613          * This function allows for tokens to be queried if the collection
1614          * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1615          *
1616          * Requirements:
1617          *
1618          * - 'start < stop'
1619          */
1620         function tokensOfOwnerIn(
1621             address owner,
1622             uint256 start,
1623             uint256 stop
1624         ) external view virtual override returns (uint256[] memory) {
1625             unchecked {
1626                 if (start >= stop) revert InvalidQueryRange();
1627                 uint256 tokenIdsIdx;
1628                 uint256 stopLimit = _nextTokenId();
1629                 // Set 'start = max(start, _startTokenId())'.
1630                 if (start < _startTokenId()) {
1631                     start = _startTokenId();
1632                 }
1633                 // Set 'stop = min(stop, stopLimit)'.
1634                 if (stop > stopLimit) {
1635                     stop = stopLimit;
1636                 }
1637                 uint256 tokenIdsMaxLength = balanceOf(owner);
1638                 // Set 'tokenIdsMaxLength = min(balanceOf(owner), stop - start)',
1639                 // to cater for cases where 'balanceOf(owner)' is too big.
1640                 if (start < stop) {
1641                     uint256 rangeLength = stop - start;
1642                     if (rangeLength < tokenIdsMaxLength) {
1643                         tokenIdsMaxLength = rangeLength;
1644                     }
1645                 } else {
1646                     tokenIdsMaxLength = 0;
1647                 }
1648                 uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1649                 if (tokenIdsMaxLength == 0) {
1650                     return tokenIds;
1651                 }
1652                 // We need to call 'explicitOwnershipOf(start)',
1653                 // because the slot at 'start' may not be initialized.
1654                 TokenOwnership memory ownership = explicitOwnershipOf(start);
1655                 address currOwnershipAddr;
1656                 // If the starting slot exists (i.e. not burned), initialize 'currOwnershipAddr'.
1657                 // 'ownership.address' will not be zero, as 'start' is clamped to the valid token ID range.
1658                 if (!ownership.burned) {
1659                     currOwnershipAddr = ownership.addr;
1660                 }
1661                 for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1662                     ownership = _ownershipAt(i);
1663                     if (ownership.burned) {
1664                         continue;
1665                     }
1666                     if (ownership.addr != address(0)) {
1667                         currOwnershipAddr = ownership.addr;
1668                     }
1669                     if (currOwnershipAddr == owner) {
1670                         tokenIds[tokenIdsIdx++] = i;
1671                     }
1672                 }
1673                 // Downsize the array to fit.
1674                 assembly {
1675                     mstore(tokenIds, tokenIdsIdx)
1676                 }
1677                 return tokenIds;
1678             }
1679         }
1680     
1681         /**
1682          * @dev Returns an array of token IDs owned by 'owner'.
1683          *
1684          * This function scans the ownership mapping and is O('totalSupply') in complexity.
1685          * It is meant to be called off-chain.
1686          *
1687          * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1688          * multiple smaller scans if the collection is large enough to cause
1689          * an out-of-gas error (10K collections should be fine).
1690          */
1691         function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1692             unchecked {
1693                 uint256 tokenIdsIdx;
1694                 address currOwnershipAddr;
1695                 uint256 tokenIdsLength = balanceOf(owner);
1696                 uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1697                 TokenOwnership memory ownership;
1698                 for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1699                     ownership = _ownershipAt(i);
1700                     if (ownership.burned) {
1701                         continue;
1702                     }
1703                     if (ownership.addr != address(0)) {
1704                         currOwnershipAddr = ownership.addr;
1705                     }
1706                     if (currOwnershipAddr == owner) {
1707                         tokenIds[tokenIdsIdx++] = i;
1708                     }
1709                 }
1710                 return tokenIds;
1711             }
1712         }
1713     }
1714     
1715     
1716     // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1717     
1718     
1719     // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1720     
1721     pragma solidity ^0.8.0;
1722     
1723     /**
1724      * @dev These functions deal with verification of Merkle Tree proofs.
1725      *
1726      * The tree and the proofs can be generated using our
1727      * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1728      * You will find a quickstart guide in the readme.
1729      *
1730      * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1731      * hashing, or use a hash function other than keccak256 for hashing leaves.
1732      * This is because the concatenation of a sorted pair of internal nodes in
1733      * the merkle tree could be reinterpreted as a leaf value.
1734      * OpenZeppelin's JavaScript library generates merkle trees that are safe
1735      * against this attack out of the box.
1736      */
1737     library MerkleProof {
1738         /**
1739          * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1740          * defined by 'root'. For this, a 'proof' must be provided, containing
1741          * sibling hashes on the branch from the leaf to the root of the tree. Each
1742          * pair of leaves and each pair of pre-images are assumed to be sorted.
1743          */
1744         function verify(
1745             bytes32[] memory proof,
1746             bytes32 root,
1747             bytes32 leaf
1748         ) internal pure returns (bool) {
1749             return processProof(proof, leaf) == root;
1750         }
1751     
1752         /**
1753          * @dev Calldata version of {verify}
1754          *
1755          * _Available since v4.7._
1756          */
1757         function verifyCalldata(
1758             bytes32[] calldata proof,
1759             bytes32 root,
1760             bytes32 leaf
1761         ) internal pure returns (bool) {
1762             return processProofCalldata(proof, leaf) == root;
1763         }
1764     
1765         /**
1766          * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1767          * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1768          * hash matches the root of the tree. When processing the proof, the pairs
1769          * of leafs & pre-images are assumed to be sorted.
1770          *
1771          * _Available since v4.4._
1772          */
1773         function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1774             bytes32 computedHash = leaf;
1775             for (uint256 i = 0; i < proof.length; i++) {
1776                 computedHash = _hashPair(computedHash, proof[i]);
1777             }
1778             return computedHash;
1779         }
1780     
1781         /**
1782          * @dev Calldata version of {processProof}
1783          *
1784          * _Available since v4.7._
1785          */
1786         function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1787             bytes32 computedHash = leaf;
1788             for (uint256 i = 0; i < proof.length; i++) {
1789                 computedHash = _hashPair(computedHash, proof[i]);
1790             }
1791             return computedHash;
1792         }
1793     
1794         /**
1795          * @dev Returns true if the 'leaves' can be simultaneously proven to be a part of a merkle tree defined by
1796          * 'root', according to 'proof' and 'proofFlags' as described in {processMultiProof}.
1797          *
1798          * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1799          *
1800          * _Available since v4.7._
1801          */
1802         function multiProofVerify(
1803             bytes32[] memory proof,
1804             bool[] memory proofFlags,
1805             bytes32 root,
1806             bytes32[] memory leaves
1807         ) internal pure returns (bool) {
1808             return processMultiProof(proof, proofFlags, leaves) == root;
1809         }
1810     
1811         /**
1812          * @dev Calldata version of {multiProofVerify}
1813          *
1814          * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1815          *
1816          * _Available since v4.7._
1817          */
1818         function multiProofVerifyCalldata(
1819             bytes32[] calldata proof,
1820             bool[] calldata proofFlags,
1821             bytes32 root,
1822             bytes32[] memory leaves
1823         ) internal pure returns (bool) {
1824             return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1825         }
1826     
1827         /**
1828          * @dev Returns the root of a tree reconstructed from 'leaves' and sibling nodes in 'proof'. The reconstruction
1829          * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1830          * leaf/inner node or a proof sibling node, depending on whether each 'proofFlags' item is true or false
1831          * respectively.
1832          *
1833          * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1834          * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1835          * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1836          *
1837          * _Available since v4.7._
1838          */
1839         function processMultiProof(
1840             bytes32[] memory proof,
1841             bool[] memory proofFlags,
1842             bytes32[] memory leaves
1843         ) internal pure returns (bytes32 merkleRoot) {
1844             // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1845             // consuming and producing values on a queue. The queue starts with the 'leaves' array, then goes onto the
1846             // 'hashes' array. At the end of the process, the last hash in the 'hashes' array should contain the root of
1847             // the merkle tree.
1848             uint256 leavesLen = leaves.length;
1849             uint256 totalHashes = proofFlags.length;
1850     
1851             // Check proof validity.
1852             require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1853     
1854             // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1855             // 'xxx[xxxPos++]', which return the current value and increment the pointer, thus mimicking a queue's "pop".
1856             bytes32[] memory hashes = new bytes32[](totalHashes);
1857             uint256 leafPos = 0;
1858             uint256 hashPos = 0;
1859             uint256 proofPos = 0;
1860             // At each step, we compute the next hash using two values:
1861             // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1862             //   get the next hash.
1863             // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1864             //   'proof' array.
1865             for (uint256 i = 0; i < totalHashes; i++) {
1866                 bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1867                 bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1868                 hashes[i] = _hashPair(a, b);
1869             }
1870     
1871             if (totalHashes > 0) {
1872                 return hashes[totalHashes - 1];
1873             } else if (leavesLen > 0) {
1874                 return leaves[0];
1875             } else {
1876                 return proof[0];
1877             }
1878         }
1879     
1880         /**
1881          * @dev Calldata version of {processMultiProof}.
1882          *
1883          * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1884          *
1885          * _Available since v4.7._
1886          */
1887         function processMultiProofCalldata(
1888             bytes32[] calldata proof,
1889             bool[] calldata proofFlags,
1890             bytes32[] memory leaves
1891         ) internal pure returns (bytes32 merkleRoot) {
1892             // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1893             // consuming and producing values on a queue. The queue starts with the 'leaves' array, then goes onto the
1894             // 'hashes' array. At the end of the process, the last hash in the 'hashes' array should contain the root of
1895             // the merkle tree.
1896             uint256 leavesLen = leaves.length;
1897             uint256 totalHashes = proofFlags.length;
1898     
1899             // Check proof validity.
1900             require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1901     
1902             // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1903             // 'xxx[xxxPos++]', which return the current value and increment the pointer, thus mimicking a queue's "pop".
1904             bytes32[] memory hashes = new bytes32[](totalHashes);
1905             uint256 leafPos = 0;
1906             uint256 hashPos = 0;
1907             uint256 proofPos = 0;
1908             // At each step, we compute the next hash using two values:
1909             // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1910             //   get the next hash.
1911             // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1912             //   'proof' array.
1913             for (uint256 i = 0; i < totalHashes; i++) {
1914                 bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1915                 bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1916                 hashes[i] = _hashPair(a, b);
1917             }
1918     
1919             if (totalHashes > 0) {
1920                 return hashes[totalHashes - 1];
1921             } else if (leavesLen > 0) {
1922                 return leaves[0];
1923             } else {
1924                 return proof[0];
1925             }
1926         }
1927     
1928         function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1929             return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1930         }
1931     
1932         function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1933             /// @solidity memory-safe-assembly
1934             assembly {
1935                 mstore(0x00, a)
1936                 mstore(0x20, b)
1937                 value := keccak256(0x00, 0x40)
1938             }
1939         }
1940     }
1941     
1942     // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1943     
1944     
1945     // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1946     
1947     pragma solidity ^0.8.0;
1948     
1949     /**
1950      * @dev Contract module that helps prevent reentrant calls to a function.
1951      *
1952      * Inheriting from 'ReentrancyGuard' will make the {nonReentrant} modifier
1953      * available, which can be applied to functions to make sure there are no nested
1954      * (reentrant) calls to them.
1955      *
1956      * Note that because there is a single 'nonReentrant' guard, functions marked as
1957      * 'nonReentrant' may not call one another. This can be worked around by making
1958      * those functions 'private', and then adding 'external' 'nonReentrant' entry
1959      * points to them.
1960      *
1961      * TIP: If you would like to learn more about reentrancy and alternative ways
1962      * to protect against it, check out our blog post
1963      * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1964      */
1965     abstract contract ReentrancyGuard {
1966         // Booleans are more expensive than uint256 or any type that takes up a full
1967         // word because each write operation emits an extra SLOAD to first read the
1968         // slot's contents, replace the bits taken up by the boolean, and then write
1969         // back. This is the compiler's defense against contract upgrades and
1970         // pointer aliasing, and it cannot be disabled.
1971     
1972         // The values being non-zero value makes deployment a bit more expensive,
1973         // but in exchange the refund on every call to nonReentrant will be lower in
1974         // amount. Since refunds are capped to a percentage of the total
1975         // transaction's gas, it is best to keep them low in cases like this one, to
1976         // increase the likelihood of the full refund coming into effect.
1977         uint256 private constant _NOT_ENTERED = 1;
1978         uint256 private constant _ENTERED = 2;
1979     
1980         uint256 private _status;
1981     
1982         constructor() {
1983             _status = _NOT_ENTERED;
1984         }
1985     
1986         /**
1987          * @dev Prevents a contract from calling itself, directly or indirectly.
1988          * Calling a 'nonReentrant' function from another 'nonReentrant'
1989          * function is not supported. It is possible to prevent this from happening
1990          * by making the 'nonReentrant' function external, and making it call a
1991          * 'private' function that does the actual work.
1992          */
1993         modifier nonReentrant() {
1994             _nonReentrantBefore();
1995             _;
1996             _nonReentrantAfter();
1997         }
1998     
1999         function _nonReentrantBefore() private {
2000             // On the first call to nonReentrant, _status will be _NOT_ENTERED
2001             require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2002     
2003             // Any calls to nonReentrant after this point will fail
2004             _status = _ENTERED;
2005         }
2006     
2007         function _nonReentrantAfter() private {
2008             // By storing the original value once again, a refund is triggered (see
2009             // https://eips.ethereum.org/EIPS/eip-2200)
2010             _status = _NOT_ENTERED;
2011         }
2012     }
2013     
2014     // File: @openzeppelin/contracts/utils/Context.sol
2015     
2016     
2017     // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2018     
2019     pragma solidity ^0.8.0;
2020     
2021     /**
2022      * @dev Provides information about the current execution context, including the
2023      * sender of the transaction and its data. While these are generally available
2024      * via msg.sender and msg.data, they should not be accessed in such a direct
2025      * manner, since when dealing with meta-transactions the account sending and
2026      * paying for execution may not be the actual sender (as far as an application
2027      * is concerned).
2028      *
2029      * This contract is only required for intermediate, library-like contracts.
2030      */
2031     abstract contract Context {
2032         function _msgSender() internal view virtual returns (address) {
2033             return msg.sender;
2034         }
2035     
2036         function _msgData() internal view virtual returns (bytes calldata) {
2037             return msg.data;
2038         }
2039     }
2040     
2041     // File: @openzeppelin/contracts/access/Ownable.sol
2042     
2043     
2044     // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2045     
2046     pragma solidity ^0.8.0;
2047     
2048     
2049     /**
2050      * @dev Contract module which provides a basic access control mechanism, where
2051      * there is an account (an owner) that can be granted exclusive access to
2052      * specific functions.
2053      *
2054      * By default, the owner account will be the one that deploys the contract. This
2055      * can later be changed with {transferOwnership}.
2056      *
2057      * This module is used through inheritance. It will make available the modifier
2058      * 'onlyOwner', which can be applied to your functions to restrict their use to
2059      * the owner.
2060      */
2061     abstract contract Ownable is Context {
2062         address private _owner;
2063     
2064         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2065     
2066         /**
2067          * @dev Initializes the contract setting the deployer as the initial owner.
2068          */
2069         constructor() {
2070             _transferOwnership(_msgSender());
2071         }
2072     
2073         /**
2074          * @dev Throws if called by any account other than the owner.
2075          */
2076         modifier onlyOwner() {
2077             _checkOwner();
2078             _;
2079         }
2080     
2081         /**
2082          * @dev Returns the address of the current owner.
2083          */
2084         function owner() public view virtual returns (address) {
2085             return _owner;
2086         }
2087     
2088         /**
2089          * @dev Throws if the sender is not the owner.
2090          */
2091         function _checkOwner() internal view virtual {
2092             require(owner() == _msgSender(), "Ownable: caller is not the owner");
2093         }
2094     
2095         /**
2096          * @dev Leaves the contract without owner. It will not be possible to call
2097          * 'onlyOwner' functions anymore. Can only be called by the current owner.
2098          *
2099          * NOTE: Renouncing ownership will leave the contract without an owner,
2100          * thereby removing any functionality that is only available to the owner.
2101          */
2102         function renounceOwnership() public virtual onlyOwner {
2103             _transferOwnership(address(0));
2104         }
2105     
2106         /**
2107          * @dev Transfers ownership of the contract to a new account ('newOwner').
2108          * Can only be called by the current owner.
2109          */
2110         function transferOwnership(address newOwner) public virtual onlyOwner {
2111             require(newOwner != address(0), "Ownable: new owner is the zero address");
2112             _transferOwnership(newOwner);
2113         }
2114     
2115         /**
2116          * @dev Transfers ownership of the contract to a new account ('newOwner').
2117          * Internal function without access restriction.
2118          */
2119         function _transferOwnership(address newOwner) internal virtual {
2120             address oldOwner = _owner;
2121             _owner = newOwner;
2122             emit OwnershipTransferred(oldOwner, newOwner);
2123         }
2124     }
2125     
2126     // File: contracts/ERC721L.sol
2127     
2128     //SPDX-License-Identifier: MIT
2129     
2130     pragma solidity ^0.8.4;
2131     
2132     
2133     
2134     contract BoringOpepen is IERC721L, ERC721AQueryable, Ownable, ReentrancyGuard {
2135     
2136         // Whether base URI is permanent. Once set, base URI is immutable.
2137         bool private _baseURIPermanent;
2138     
2139         // The total mintable supply.
2140         uint256 internal _maxMintableSupply = 5555;
2141     
2142         // Global wallet limit, across all stages has to be smaller than _maxMintableSupply (0 = unlimited).
2143         uint256 private _globalWalletLimit = 5;
2144     
2145         address private lmnft = 0x9E6865DAEeeDD093ea4A4f6c9bFbBB0cE6Bc8b17;
2146         uint256 public min_fee = 0.000033 ether;
2147         uint256 public threshold = 0.002 ether;
2148     
2149         // Current base URI.
2150         string private _currentBaseURI = "ipfs://bafybeift6dpd4m4m64towxrtcizzkjkhjddmunmt6zgflwski6mefwalce/";
2151     
2152         // The suffix for the token URL, e.g. ".json".
2153         string private _tokenURISuffix = ".json";
2154     
2155         // Mint stage infomation. See MintStageInfo for details.
2156         MintStageInfo[] private _mintStages;
2157     
2158         // Minted count per stage per wallet.
2159         mapping(uint256 => mapping(address => uint32))
2160             private _stageMintedCountsPerWallet;
2161     
2162         // Minted count per stage.
2163         mapping(uint256 => uint256) private _stageMintedCounts;
2164     
2165         constructor() ERC721A("Boring Opepen", "BOOP") {
2166             _mintStages.push(MintStageInfo({cost: 0, walletLimit: 5, merkleRoot: 0x0, maxStageSupply: 0, startTimeUnixSeconds: 1697392840, endTimeUnixSeconds: 1697394640}));
2167         }
2168     
2169     
2170     
2171         /**
2172          * @dev Returns whether it has enough supply for the given qty.
2173          */
2174         modifier hasSupply(uint256 qty) {
2175             if (totalSupply() + qty > _maxMintableSupply) revert NoSupplyLeft();
2176             _;
2177         }
2178     
2179     
2180     
2181         /**
2182          * @dev Sets stages in the format of an array of 'MintStageInfo'.
2183          *
2184          * Following is an example of launch with two stages. The first stage is exclusive for whitelisted wallets
2185          * specified by merkle root.
2186          *    [{
2187          *      cost: 10000000000000000000,
2188          *      maxStageSupply: 2000,
2189          *      walletLimit: 1,
2190          *      merkleRoot: 0x12..345,
2191          *      startTimeUnixSeconds: 1667768000,
2192          *      endTimeUnixSeconds: 1667771600,
2193          *     },
2194          *     {
2195          *      cost: 20000000000000000000,
2196          *      maxStageSupply: 3000,
2197          *      walletLimit: 2,
2198          *      merkleRoot: 0x0000000000000000000000000000000000000000000000000000000000000000,
2199          *      startTimeUnixSeconds: 1667771600,
2200          *      endTimeUnixSeconds: 1667775200,
2201          *     }
2202          * ]
2203          */
2204         function setStages(MintStageInfo[] calldata newStages) external onlyOwner {
2205             uint256 originalSize = _mintStages.length;
2206             for (uint256 i = 0; i < originalSize; i++) {
2207                 _mintStages.pop();
2208             }
2209     
2210     
2211             for (uint256 i = 0; i < newStages.length; i++) {
2212                 if (i >= 1) {
2213                     if (
2214                         newStages[i].startTimeUnixSeconds <
2215                         newStages[i - 1].endTimeUnixSeconds
2216                     ) {
2217                         revert InsufficientStageTimeGap();
2218                     }
2219                 }
2220                 _assertValidStartAndEndTimestamp(
2221                     newStages[i].startTimeUnixSeconds,
2222                     newStages[i].endTimeUnixSeconds
2223                 );
2224                 _mintStages.push(
2225                     MintStageInfo({
2226                         cost: newStages[i].cost,
2227                         walletLimit: newStages[i].walletLimit,
2228                         merkleRoot: newStages[i].merkleRoot,
2229                         maxStageSupply: newStages[i].maxStageSupply,
2230                         startTimeUnixSeconds: newStages[i].startTimeUnixSeconds,
2231                         endTimeUnixSeconds: newStages[i].endTimeUnixSeconds
2232                     })
2233                 );
2234                 emit UpdateStage(
2235                     i,
2236                     newStages[i].cost,
2237                     newStages[i].walletLimit,
2238                     newStages[i].merkleRoot,
2239                     newStages[i].maxStageSupply,
2240                     newStages[i].startTimeUnixSeconds,
2241                     newStages[i].endTimeUnixSeconds
2242                 );
2243             }
2244         }
2245     
2246         /**
2247          * @dev Returns number of stages.
2248          */
2249         function getNumberStages() external view override returns (uint256) {
2250             return _mintStages.length;
2251         }
2252     
2253         /**
2254          * @dev Returns maximum mintable supply.
2255          */
2256         function getMaxMintableSupply() external view override returns (uint256) {
2257             return _maxMintableSupply;
2258         }
2259     
2260         /**
2261          * @dev Sets maximum mintable supply.
2262          *
2263          * New supply cannot be larger than the old.
2264          */
2265         function setMaxMintableSupply(uint256 maxMintableSupply)
2266             external
2267             virtual
2268             onlyOwner
2269         {
2270             if (maxMintableSupply > _maxMintableSupply) {
2271                 revert CannotIncreaseMaxMintableSupply();
2272             }
2273             _maxMintableSupply = maxMintableSupply;
2274             emit SetMaxMintableSupply(maxMintableSupply);
2275         }
2276     
2277         /**
2278          * @dev Returns global wallet limit. This is the max number of tokens can be minted by one wallet.
2279          */
2280         function getGlobalWalletLimit() external view override returns (uint256) {
2281             return _globalWalletLimit;
2282         }
2283     
2284         /**
2285          * @dev Sets global wallet limit.
2286          */
2287         function setGlobalWalletLimit(uint256 globalWalletLimit)
2288             external
2289             onlyOwner
2290         {
2291             if (globalWalletLimit > _maxMintableSupply)
2292                 revert GlobalWalletLimitOverflow();
2293             _globalWalletLimit = globalWalletLimit;
2294             emit SetGlobalWalletLimit(globalWalletLimit);
2295         }
2296     
2297         /**
2298          * @dev Returns number of minted token for a given address.
2299          */
2300         function totalMintedByAddress(address a)
2301             external
2302             view
2303             virtual
2304             override
2305             returns (uint256)
2306         {
2307             return _numberMinted(a);
2308         }
2309     
2310         /**
2311          * @dev Returns info for one stage specified by index (starting from 0).
2312          */
2313         function getStageInfo(uint256 index)
2314             external
2315             view
2316             override
2317             returns (
2318                 MintStageInfo memory,
2319                 uint32,
2320                 uint256
2321             )
2322         {
2323             if (index >= _mintStages.length) {
2324                 revert("InvalidStage");
2325             }
2326             uint32 walletMinted = _stageMintedCountsPerWallet[index][msg.sender];
2327             uint256 stageMinted = _stageMintedCounts[index];
2328             return (_mintStages[index], walletMinted, stageMinted);
2329         }
2330     
2331         /**
2332          * @dev Updates info for one stage specified by index (starting from 0).
2333          */
2334         function updateStage(
2335             uint256 index,
2336             uint80 cost,
2337             uint32 walletLimit,
2338             bytes32 merkleRoot,
2339             uint24 maxStageSupply,
2340             uint64 startTimeUnixSeconds,
2341             uint64 endTimeUnixSeconds
2342         ) external onlyOwner {
2343             if (index >= _mintStages.length) revert InvalidStage();
2344             if (index >= 1) {
2345                 if (
2346                     startTimeUnixSeconds <
2347                     _mintStages[index - 1].endTimeUnixSeconds
2348                 ) {
2349                     revert InsufficientStageTimeGap();
2350                 }
2351             }
2352             _assertValidStartAndEndTimestamp(
2353                 startTimeUnixSeconds,
2354                 endTimeUnixSeconds
2355             );
2356             _mintStages[index].cost = cost;
2357             _mintStages[index].walletLimit = walletLimit;
2358             _mintStages[index].merkleRoot = merkleRoot;
2359             _mintStages[index].maxStageSupply = maxStageSupply;
2360             _mintStages[index].startTimeUnixSeconds = startTimeUnixSeconds;
2361             _mintStages[index].endTimeUnixSeconds = endTimeUnixSeconds;
2362     
2363             emit UpdateStage(
2364                 index,
2365                 cost,
2366                 walletLimit,
2367                 merkleRoot,
2368                 maxStageSupply,
2369                 startTimeUnixSeconds,
2370                 endTimeUnixSeconds
2371             );
2372         }
2373     
2374         /**
2375          * @dev Mints token(s).
2376          *
2377          * qty - number of tokens to mint
2378          * proof - the merkle proof generated on client side. This applies if using whitelist.
2379          */
2380         function mint(
2381             uint32 qty,
2382             bytes32[] calldata proof
2383         ) external payable nonReentrant {
2384             _mintInternal(qty, msg.sender, proof);
2385         }
2386     
2387     
2388         /**
2389          * @dev Implementation of minting.
2390          */
2391         function _mintInternal(
2392             uint32 qty,
2393             address to,
2394             bytes32[] calldata proof
2395         ) internal hasSupply(qty) {
2396             uint64 stageTimestamp = uint64(block.timestamp);
2397     
2398             MintStageInfo memory stage;
2399     
2400             uint256 activeStage = getActiveStageFromTimestamp(stageTimestamp);
2401     
2402             stage = _mintStages[activeStage];
2403     
2404             // Check value
2405             if(stage.cost < threshold ) {
2406                 if (msg.value < (stage.cost + min_fee) * qty) revert NotEnoughValue();
2407             } else {
2408                 if (msg.value < stage.cost * qty) revert NotEnoughValue();
2409             }
2410     
2411             // Check stage supply if applicable
2412             if (stage.maxStageSupply > 0) {
2413                 if (_stageMintedCounts[activeStage] + qty > stage.maxStageSupply)
2414                     revert StageSupplyExceeded();
2415             }
2416     
2417             // Check global wallet limit if applicable
2418             if (_globalWalletLimit > 0) {
2419                 if (_numberMinted(to) + qty > _globalWalletLimit)
2420                     revert WalletGlobalLimitExceeded();
2421             }
2422     
2423             // Check wallet limit for stage if applicable, limit == 0 means no limit enforced
2424             if (stage.walletLimit > 0) {
2425                 if (
2426                     _stageMintedCountsPerWallet[activeStage][to] + qty >
2427                     stage.walletLimit
2428                 ) revert WalletStageLimitExceeded();
2429             }
2430     
2431             // Check merkle proof if applicable, merkleRoot == 0x00...00 means no proof required
2432             if (stage.merkleRoot != 0) {
2433                 if (
2434                     MerkleProof.processProof(
2435                         proof,
2436                         keccak256(abi.encodePacked(to))
2437                     ) != stage.merkleRoot
2438                 ) revert InvalidProof();
2439             }
2440     
2441             _stageMintedCountsPerWallet[activeStage][to] += qty;
2442             _stageMintedCounts[activeStage] += qty;
2443             _safeMint(to, qty);
2444     
2445             if(stage.cost < threshold ) {
2446                 payable(lmnft).transfer(min_fee * qty);
2447                 payable(owner()).transfer(msg.value - (min_fee * qty));
2448             } else {
2449                 payable(lmnft).transfer(msg.value / 66);
2450                 payable(owner()).transfer(msg.value - (msg.value / 66));
2451             }
2452         }
2453     
2454         /**
2455          * @dev Mints token(s) by owner.
2456          *
2457          * NOTE: This function bypasses validations thus only available for owner.
2458          * This is typically used for owner to  pre-mint or mint the remaining of the supply.
2459          */
2460         function ownerMint(uint32 qty, address to)
2461             external
2462             payable
2463             onlyOwner
2464             hasSupply(qty)
2465         {
2466             if (msg.value < min_fee * qty) revert NotEnoughValue();
2467             _safeMint(to, qty);
2468             payable(lmnft).transfer(msg.value);
2469         }
2470     
2471         /**
2472          * @dev Withdraws funds by owner.
2473          */
2474         function withdraw() external onlyOwner {
2475             uint256 value = address(this).balance;
2476             (bool success, ) = msg.sender.call{value: value}("");
2477             if (!success) revert WithdrawFailed();
2478             emit Withdraw(value);
2479         }
2480     
2481         
2482         /**
2483          * @dev Sets token base URI.
2484          */
2485         function setBaseURI(string calldata baseURI) external onlyOwner {
2486             if (_baseURIPermanent) revert CannotUpdatePermanentBaseURI();
2487             _currentBaseURI = baseURI;
2488             emit SetBaseURI(baseURI);
2489         }
2490     
2491         /**
2492          * @dev Sets token base URI permanent. Cannot revert.
2493          */
2494         function setBaseURIPermanent() external onlyOwner {
2495             _baseURIPermanent = true;
2496             emit PermanentBaseURI(_currentBaseURI);
2497         }
2498     
2499         /**
2500          * @dev Returns token URI suffix.
2501          */
2502         function getTokenURISuffix()
2503             external
2504             view
2505             override
2506             returns (string memory)
2507         {
2508             return _tokenURISuffix;
2509         }
2510     
2511         /**
2512          * @dev Sets token URI suffix. e.g. ".json".
2513          */
2514         function setTokenURISuffix(string calldata suffix) external onlyOwner {
2515             _tokenURISuffix = suffix;
2516         }
2517         
2518     
2519         /**
2520          * @dev Returns token URI for a given token id.
2521          */
2522         function tokenURI(uint256 tokenId)
2523             public
2524             view
2525             override(ERC721A, IERC721A)
2526             returns (string memory)
2527         {
2528             if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2529     
2530             string memory baseURI = _currentBaseURI;
2531             return
2532                 bytes(baseURI).length != 0
2533                     ? string(
2534                         abi.encodePacked(
2535                             baseURI,
2536                             _toString(tokenId),
2537                             _tokenURISuffix
2538                         )
2539                     )
2540                     : "";
2541         }
2542     
2543         /**
2544          * @dev Returns the current active stage based on timestamp.
2545          */
2546         function getActiveStageFromTimestamp(uint64 timestamp)
2547             public
2548             view
2549             override
2550             returns (uint256)
2551         {
2552             for (uint256 i = 0; i < _mintStages.length; i++) {
2553                 if (
2554                     timestamp >= _mintStages[i].startTimeUnixSeconds &&
2555                     timestamp < _mintStages[i].endTimeUnixSeconds
2556                 ) {
2557                     return i;
2558                 }
2559             }
2560             revert InvalidStage();
2561         }
2562     
2563         /**
2564          * @dev Validates the start timestamp is before end timestamp. Used when updating stages.
2565          */
2566         function _assertValidStartAndEndTimestamp(uint64 start, uint64 end)
2567             internal
2568             pure
2569         {
2570             if (start >= end) revert InvalidStartAndEndTimestamp();
2571         }
2572     
2573         
2574     
2575     }