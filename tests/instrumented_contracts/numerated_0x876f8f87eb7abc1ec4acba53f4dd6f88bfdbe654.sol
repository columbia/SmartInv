1 // File: eip712/ContextMixin.sol
2 
3 
4 pragma solidity ^0.8.7;
5 /**
6  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
7  */
8 abstract contract ContextMixin {
9     function msgSender()
10         internal
11         view
12         returns (address payable sender)
13     {
14         if (msg.sender == address(this)) {
15             bytes memory array = msg.data;
16             uint256 index = msg.data.length;
17             assembly {
18                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
19                 sender := and(
20                     mload(add(array, index)),
21                     0xffffffffffffffffffffffffffffffffffffffff
22                 )
23             }
24         } else {
25             sender = payable(msg.sender);
26         }
27         return sender;
28     }
29 }
30 // File: eip712/Initializable.sol
31 
32 
33 pragma solidity ^0.8.7;
34 /**
35  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/Initializable.sol
36  */
37 contract Initializable {
38     bool inited = false;
39 
40     modifier initializer() {
41         require(!inited, "already inited");
42         _;
43         inited = true;
44     }
45 }
46 // File: eip712/EIP712Base.sol
47 
48 
49 pragma solidity ^0.8.7;
50 
51 
52 /**
53  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/EIP712Base.sol
54  */
55 contract EIP712Base is Initializable {
56     struct EIP712Domain {
57         string name;
58         string version;
59         address verifyingContract;
60         bytes32 salt;
61     }
62 
63     string public constant ERC712_VERSION = "1";
64 
65     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
66         keccak256(
67             bytes(
68                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
69             )
70         );
71     bytes32 internal domainSeperator;
72 
73     // supposed to be called once while initializing.
74     // one of the contractsa that inherits this contract follows proxy pattern
75     // so it is not possible to do this in a constructor
76     function _initializeEIP712(string memory name) internal initializer {
77         _setDomainSeperator(name);
78     }
79 
80     function _setDomainSeperator(string memory name) internal {
81         domainSeperator = keccak256(
82             abi.encode(
83                 EIP712_DOMAIN_TYPEHASH,
84                 keccak256(bytes(name)),
85                 keccak256(bytes(ERC712_VERSION)),
86                 address(this),
87                 bytes32(getChainId())
88             )
89         );
90     }
91 
92     function getDomainSeperator() public view returns (bytes32) {
93         return domainSeperator;
94     }
95 
96     function getChainId() public view returns (uint256) {
97         uint256 id;
98         assembly {
99             id := chainid()
100         }
101         return id;
102     }
103 
104     /**
105      * Accept message hash and returns hash message in EIP712 compatible form
106      * So that it can be used to recover signer from signature signed using EIP712 formatted data
107      * https://eips.ethereum.org/EIPS/eip-712
108      * "\\x19" makes the encoding deterministic
109      * "\\x01" is the version byte to make it compatible to EIP-191
110      */
111     function toTypedMessageHash(bytes32 messageHash)
112         internal
113         view
114         returns (bytes32)
115     {
116         return
117             keccak256(
118                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
119             );
120     }
121 }
122 
123 // File: erc721a/contracts/IERC721A.sol
124 
125 
126 // ERC721A Contracts v4.0.0
127 // Creator: Chiru Labs
128 
129 pragma solidity ^0.8.4;
130 
131 /**
132  * @dev Interface of an ERC721A compliant contract.
133  */
134 interface IERC721A {
135     /**
136      * The caller must own the token or be an approved operator.
137      */
138     error ApprovalCallerNotOwnerNorApproved();
139 
140     /**
141      * The token does not exist.
142      */
143     error ApprovalQueryForNonexistentToken();
144 
145     /**
146      * The caller cannot approve to their own address.
147      */
148     error ApproveToCaller();
149 
150     /**
151      * The caller cannot approve to the current owner.
152      */
153     error ApprovalToCurrentOwner();
154 
155     /**
156      * Cannot query the balance for the zero address.
157      */
158     error BalanceQueryForZeroAddress();
159 
160     /**
161      * Cannot mint to the zero address.
162      */
163     error MintToZeroAddress();
164 
165     /**
166      * The quantity of tokens minted must be more than zero.
167      */
168     error MintZeroQuantity();
169 
170     /**
171      * The token does not exist.
172      */
173     error OwnerQueryForNonexistentToken();
174 
175     /**
176      * The caller must own the token or be an approved operator.
177      */
178     error TransferCallerNotOwnerNorApproved();
179 
180     /**
181      * The token must be owned by `from`.
182      */
183     error TransferFromIncorrectOwner();
184 
185     /**
186      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
187      */
188     error TransferToNonERC721ReceiverImplementer();
189 
190     /**
191      * Cannot transfer to the zero address.
192      */
193     error TransferToZeroAddress();
194 
195     /**
196      * The token does not exist.
197      */
198     error URIQueryForNonexistentToken();
199 
200     struct TokenOwnership {
201         // The address of the owner.
202         address addr;
203         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
204         uint64 startTimestamp;
205         // Whether the token has been burned.
206         bool burned;
207     }
208 
209     /**
210      * @dev Returns the total amount of tokens stored by the contract.
211      *
212      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     // ==============================
217     //            IERC165
218     // ==============================
219 
220     /**
221      * @dev Returns true if this contract implements the interface defined by
222      * `interfaceId`. See the corresponding
223      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
224      * to learn more about how these ids are created.
225      *
226      * This function call must use less than 30 000 gas.
227      */
228     function supportsInterface(bytes4 interfaceId) external view returns (bool);
229 
230     // ==============================
231     //            IERC721
232     // ==============================
233 
234     /**
235      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
241      */
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243 
244     /**
245      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
248 
249     /**
250      * @dev Returns the number of tokens in ``owner``'s account.
251      */
252     function balanceOf(address owner) external view returns (uint256 balance);
253 
254     /**
255      * @dev Returns the owner of the `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function ownerOf(uint256 tokenId) external view returns (address owner);
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
273      *
274      * Emits a {Transfer} event.
275      */
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId,
280         bytes calldata data
281     ) external;
282 
283     /**
284      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
285      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Transfers `tokenId` token from `from` to `to`.
305      *
306      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
307      *
308      * Requirements:
309      *
310      * - `from` cannot be the zero address.
311      * - `to` cannot be the zero address.
312      * - `tokenId` token must be owned by `from`.
313      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transferFrom(
318         address from,
319         address to,
320         uint256 tokenId
321     ) external;
322 
323     /**
324      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
325      * The approval is cleared when the token is transferred.
326      *
327      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
328      *
329      * Requirements:
330      *
331      * - The caller must own the token or be an approved operator.
332      * - `tokenId` must exist.
333      *
334      * Emits an {Approval} event.
335      */
336     function approve(address to, uint256 tokenId) external;
337 
338     /**
339      * @dev Approve or remove `operator` as an operator for the caller.
340      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
341      *
342      * Requirements:
343      *
344      * - The `operator` cannot be the caller.
345      *
346      * Emits an {ApprovalForAll} event.
347      */
348     function setApprovalForAll(address operator, bool _approved) external;
349 
350     /**
351      * @dev Returns the account approved for `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359     /**
360      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
361      *
362      * See {setApprovalForAll}
363      */
364     function isApprovedForAll(address owner, address operator) external view returns (bool);
365 
366     // ==============================
367     //        IERC721Metadata
368     // ==============================
369 
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 }
385 
386 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
387 
388 
389 // ERC721A Contracts v4.0.0
390 // Creator: Chiru Labs
391 
392 pragma solidity ^0.8.4;
393 
394 
395 /**
396  * @dev Interface of an ERC721AQueryable compliant contract.
397  */
398 interface IERC721AQueryable is IERC721A {
399     /**
400      * Invalid query range (`start` >= `stop`).
401      */
402     error InvalidQueryRange();
403 
404     /**
405      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
406      *
407      * If the `tokenId` is out of bounds:
408      *   - `addr` = `address(0)`
409      *   - `startTimestamp` = `0`
410      *   - `burned` = `false`
411      *
412      * If the `tokenId` is burned:
413      *   - `addr` = `<Address of owner before token was burned>`
414      *   - `startTimestamp` = `<Timestamp when token was burned>`
415      *   - `burned = `true`
416      *
417      * Otherwise:
418      *   - `addr` = `<Address of owner>`
419      *   - `startTimestamp` = `<Timestamp of start of ownership>`
420      *   - `burned = `false`
421      */
422     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
423 
424     /**
425      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
426      * See {ERC721AQueryable-explicitOwnershipOf}
427      */
428     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
429 
430     /**
431      * @dev Returns an array of token IDs owned by `owner`,
432      * in the range [`start`, `stop`)
433      * (i.e. `start <= tokenId < stop`).
434      *
435      * This function allows for tokens to be queried if the collection
436      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
437      *
438      * Requirements:
439      *
440      * - `start` < `stop`
441      */
442     function tokensOfOwnerIn(
443         address owner,
444         uint256 start,
445         uint256 stop
446     ) external view returns (uint256[] memory);
447 
448     /**
449      * @dev Returns an array of token IDs owned by `owner`.
450      *
451      * This function scans the ownership mapping and is O(totalSupply) in complexity.
452      * It is meant to be called off-chain.
453      *
454      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
455      * multiple smaller scans if the collection is large enough to cause
456      * an out-of-gas error (10K pfp collections should be fine).
457      */
458     function tokensOfOwner(address owner) external view returns (uint256[] memory);
459 }
460 
461 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
462 
463 
464 // ERC721A Contracts v4.0.0
465 // Creator: Chiru Labs
466 
467 pragma solidity ^0.8.4;
468 
469 
470 /**
471  * @dev Interface of an ERC721ABurnable compliant contract.
472  */
473 interface IERC721ABurnable is IERC721A {
474     /**
475      * @dev Burns `tokenId`. See {ERC721A-_burn}.
476      *
477      * Requirements:
478      *
479      * - The caller must own `tokenId` or be an approved operator.
480      */
481     function burn(uint256 tokenId) external;
482 }
483 
484 // File: erc721a/contracts/ERC721A.sol
485 
486 
487 // ERC721A Contracts v4.0.0
488 // Creator: Chiru Labs
489 
490 pragma solidity ^0.8.4;
491 
492 
493 /**
494  * @dev ERC721 token receiver interface.
495  */
496 interface ERC721A__IERC721Receiver {
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 /**
506  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
507  * the Metadata extension. Built to optimize for lower gas during batch mints.
508  *
509  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
510  *
511  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
512  *
513  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
514  */
515 contract ERC721A is IERC721A {
516     // Mask of an entry in packed address data.
517     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
518 
519     // The bit position of `numberMinted` in packed address data.
520     uint256 private constant BITPOS_NUMBER_MINTED = 64;
521 
522     // The bit position of `numberBurned` in packed address data.
523     uint256 private constant BITPOS_NUMBER_BURNED = 128;
524 
525     // The bit position of `aux` in packed address data.
526     uint256 private constant BITPOS_AUX = 192;
527 
528     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
529     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
530 
531     // The bit position of `startTimestamp` in packed ownership.
532     uint256 private constant BITPOS_START_TIMESTAMP = 160;
533 
534     // The bit mask of the `burned` bit in packed ownership.
535     uint256 private constant BITMASK_BURNED = 1 << 224;
536     
537     // The bit position of the `nextInitialized` bit in packed ownership.
538     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
539 
540     // The bit mask of the `nextInitialized` bit in packed ownership.
541     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
542 
543     // The tokenId of the next token to be minted.
544     uint256 private _currentIndex;
545 
546     // The number of tokens burned.
547     uint256 private _burnCounter;
548 
549     // Token name
550     string private _name;
551 
552     // Token symbol
553     string private _symbol;
554 
555     // Mapping from token ID to ownership details
556     // An empty struct value does not necessarily mean the token is unowned.
557     // See `_packedOwnershipOf` implementation for details.
558     //
559     // Bits Layout:
560     // - [0..159]   `addr`
561     // - [160..223] `startTimestamp`
562     // - [224]      `burned`
563     // - [225]      `nextInitialized`
564     mapping(uint256 => uint256) private _packedOwnerships;
565 
566     // Mapping owner address to address data.
567     //
568     // Bits Layout:
569     // - [0..63]    `balance`
570     // - [64..127]  `numberMinted`
571     // - [128..191] `numberBurned`
572     // - [192..255] `aux`
573     mapping(address => uint256) private _packedAddressData;
574 
575     // Mapping from token ID to approved address.
576     mapping(uint256 => address) private _tokenApprovals;
577 
578     // Mapping from owner to operator approvals
579     mapping(address => mapping(address => bool)) private _operatorApprovals;
580 
581     constructor(string memory name_, string memory symbol_) {
582         _name = name_;
583         _symbol = symbol_;
584         _currentIndex = _startTokenId();
585     }
586 
587     /**
588      * @dev Returns the starting token ID. 
589      * To change the starting token ID, please override this function.
590      */
591     function _startTokenId() internal view virtual returns (uint256) {
592         return 0;
593     }
594 
595     /**
596      * @dev Returns the next token ID to be minted.
597      */
598     function _nextTokenId() internal view returns (uint256) {
599         return _currentIndex;
600     }
601 
602     /**
603      * @dev Returns the total number of tokens in existence.
604      * Burned tokens will reduce the count. 
605      * To get the total number of tokens minted, please see `_totalMinted`.
606      */
607     function totalSupply() public view override returns (uint256) {
608         // Counter underflow is impossible as _burnCounter cannot be incremented
609         // more than `_currentIndex - _startTokenId()` times.
610         unchecked {
611             return _currentIndex - _burnCounter - _startTokenId();
612         }
613     }
614 
615     /**
616      * @dev Returns the total amount of tokens minted in the contract.
617      */
618     function _totalMinted() internal view returns (uint256) {
619         // Counter underflow is impossible as _currentIndex does not decrement,
620         // and it is initialized to `_startTokenId()`
621         unchecked {
622             return _currentIndex - _startTokenId();
623         }
624     }
625 
626     /**
627      * @dev Returns the total number of tokens burned.
628      */
629     function _totalBurned() internal view returns (uint256) {
630         return _burnCounter;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
637         // The interface IDs are constants representing the first 4 bytes of the XOR of
638         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
639         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
640         return
641             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
642             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
643             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
644     }
645 
646     /**
647      * @dev See {IERC721-balanceOf}.
648      */
649     function balanceOf(address owner) public view override returns (uint256) {
650         if (owner == address(0)) revert BalanceQueryForZeroAddress();
651         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
652     }
653 
654     /**
655      * Returns the number of tokens minted by `owner`.
656      */
657     function _numberMinted(address owner) internal view returns (uint256) {
658         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
659     }
660 
661     /**
662      * Returns the number of tokens burned by or on behalf of `owner`.
663      */
664     function _numberBurned(address owner) internal view returns (uint256) {
665         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
666     }
667 
668     /**
669      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
670      */
671     function _getAux(address owner) internal view returns (uint64) {
672         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
673     }
674 
675     /**
676      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
677      * If there are multiple variables, please pack them into a uint64.
678      */
679     function _setAux(address owner, uint64 aux) internal {
680         uint256 packed = _packedAddressData[owner];
681         uint256 auxCasted;
682         assembly { // Cast aux without masking.
683             auxCasted := aux
684         }
685         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
686         _packedAddressData[owner] = packed;
687     }
688 
689     /**
690      * Returns the packed ownership data of `tokenId`.
691      */
692     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
693         uint256 curr = tokenId;
694 
695         unchecked {
696             if (_startTokenId() <= curr)
697                 if (curr < _currentIndex) {
698                     uint256 packed = _packedOwnerships[curr];
699                     // If not burned.
700                     if (packed & BITMASK_BURNED == 0) {
701                         // Invariant:
702                         // There will always be an ownership that has an address and is not burned
703                         // before an ownership that does not have an address and is not burned.
704                         // Hence, curr will not underflow.
705                         //
706                         // We can directly compare the packed value.
707                         // If the address is zero, packed is zero.
708                         while (packed == 0) {
709                             packed = _packedOwnerships[--curr];
710                         }
711                         return packed;
712                     }
713                 }
714         }
715         revert OwnerQueryForNonexistentToken();
716     }
717 
718     /**
719      * Returns the unpacked `TokenOwnership` struct from `packed`.
720      */
721     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
722         ownership.addr = address(uint160(packed));
723         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
724         ownership.burned = packed & BITMASK_BURNED != 0;
725     }
726 
727     /**
728      * Returns the unpacked `TokenOwnership` struct at `index`.
729      */
730     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
731         return _unpackedOwnership(_packedOwnerships[index]);
732     }
733 
734     /**
735      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
736      */
737     function _initializeOwnershipAt(uint256 index) internal {
738         if (_packedOwnerships[index] == 0) {
739             _packedOwnerships[index] = _packedOwnershipOf(index);
740         }
741     }
742 
743     /**
744      * Gas spent here starts off proportional to the maximum mint batch size.
745      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
746      */
747     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
748         return _unpackedOwnership(_packedOwnershipOf(tokenId));
749     }
750 
751     /**
752      * @dev See {IERC721-ownerOf}.
753      */
754     function ownerOf(uint256 tokenId) public view override returns (address) {
755         return address(uint160(_packedOwnershipOf(tokenId)));
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-name}.
760      */
761     function name() public view virtual override returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-symbol}.
767      */
768     function symbol() public view virtual override returns (string memory) {
769         return _symbol;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-tokenURI}.
774      */
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
777 
778         string memory baseURI = _baseURI();
779         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785      * by default, can be overriden in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return '';
789     }
790 
791     /**
792      * @dev Casts the address to uint256 without masking.
793      */
794     function _addressToUint256(address value) private pure returns (uint256 result) {
795         assembly {
796             result := value
797         }
798     }
799 
800     /**
801      * @dev Casts the boolean to uint256 without branching.
802      */
803     function _boolToUint256(bool value) private pure returns (uint256 result) {
804         assembly {
805             result := value
806         }
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public override {
813         address owner = address(uint160(_packedOwnershipOf(tokenId)));
814         if (to == owner) revert ApprovalToCurrentOwner();
815 
816         if (_msgSenderERC721A() != owner)
817             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
818                 revert ApprovalCallerNotOwnerNorApproved();
819             }
820 
821         _tokenApprovals[tokenId] = to;
822         emit Approval(owner, to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-getApproved}.
827      */
828     function getApproved(uint256 tokenId) public view override returns (address) {
829         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
830 
831         return _tokenApprovals[tokenId];
832     }
833 
834     /**
835      * @dev See {IERC721-setApprovalForAll}.
836      */
837     function setApprovalForAll(address operator, bool approved) public virtual override {
838         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
839 
840         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
841         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
842     }
843 
844     /**
845      * @dev See {IERC721-isApprovedForAll}.
846      */
847     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
848         return _operatorApprovals[owner][operator];
849     }
850 
851     /**
852      * @dev See {IERC721-transferFrom}.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, '');
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         _transfer(from, to, tokenId);
883         if (to.code.length != 0)
884             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
885                 revert TransferToNonERC721ReceiverImplementer();
886             }
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      */
896     function _exists(uint256 tokenId) internal view returns (bool) {
897         return
898             _startTokenId() <= tokenId &&
899             tokenId < _currentIndex && // If within bounds,
900             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
901     }
902 
903     /**
904      * @dev Equivalent to `_safeMint(to, quantity, '')`.
905      */
906     function _safeMint(address to, uint256 quantity) internal {
907         _safeMint(to, quantity, '');
908     }
909 
910     /**
911      * @dev Safely mints `quantity` tokens and transfers them to `to`.
912      *
913      * Requirements:
914      *
915      * - If `to` refers to a smart contract, it must implement
916      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
917      * - `quantity` must be greater than 0.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeMint(
922         address to,
923         uint256 quantity,
924         bytes memory _data
925     ) internal {
926         uint256 startTokenId = _currentIndex;
927         if (to == address(0)) revert MintToZeroAddress();
928         if (quantity == 0) revert MintZeroQuantity();
929 
930         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
931 
932         // Overflows are incredibly unrealistic.
933         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
934         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
935         unchecked {
936             // Updates:
937             // - `balance += quantity`.
938             // - `numberMinted += quantity`.
939             //
940             // We can directly add to the balance and number minted.
941             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
942 
943             // Updates:
944             // - `address` to the owner.
945             // - `startTimestamp` to the timestamp of minting.
946             // - `burned` to `false`.
947             // - `nextInitialized` to `quantity == 1`.
948             _packedOwnerships[startTokenId] =
949                 _addressToUint256(to) |
950                 (block.timestamp << BITPOS_START_TIMESTAMP) |
951                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
952 
953             uint256 updatedIndex = startTokenId;
954             uint256 end = updatedIndex + quantity;
955 
956             if (to.code.length != 0) {
957                 do {
958                     emit Transfer(address(0), to, updatedIndex);
959                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
960                         revert TransferToNonERC721ReceiverImplementer();
961                     }
962                 } while (updatedIndex < end);
963                 // Reentrancy protection
964                 if (_currentIndex != startTokenId) revert();
965             } else {
966                 do {
967                     emit Transfer(address(0), to, updatedIndex++);
968                 } while (updatedIndex < end);
969             }
970             _currentIndex = updatedIndex;
971         }
972         _afterTokenTransfers(address(0), to, startTokenId, quantity);
973     }
974 
975     /**
976      * @dev Mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `quantity` must be greater than 0.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _mint(address to, uint256 quantity) internal {
986         uint256 startTokenId = _currentIndex;
987         if (to == address(0)) revert MintToZeroAddress();
988         if (quantity == 0) revert MintZeroQuantity();
989 
990         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
991 
992         // Overflows are incredibly unrealistic.
993         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
994         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
995         unchecked {
996             // Updates:
997             // - `balance += quantity`.
998             // - `numberMinted += quantity`.
999             //
1000             // We can directly add to the balance and number minted.
1001             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1002 
1003             // Updates:
1004             // - `address` to the owner.
1005             // - `startTimestamp` to the timestamp of minting.
1006             // - `burned` to `false`.
1007             // - `nextInitialized` to `quantity == 1`.
1008             _packedOwnerships[startTokenId] =
1009                 _addressToUint256(to) |
1010                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1011                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1012 
1013             uint256 updatedIndex = startTokenId;
1014             uint256 end = updatedIndex + quantity;
1015 
1016             do {
1017                 emit Transfer(address(0), to, updatedIndex++);
1018             } while (updatedIndex < end);
1019 
1020             _currentIndex = updatedIndex;
1021         }
1022         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) private {
1040         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1041 
1042         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1043 
1044         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1045             isApprovedForAll(from, _msgSenderERC721A()) ||
1046             getApproved(tokenId) == _msgSenderERC721A());
1047 
1048         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1049         if (to == address(0)) revert TransferToZeroAddress();
1050 
1051         _beforeTokenTransfers(from, to, tokenId, 1);
1052 
1053         // Clear approvals from the previous owner.
1054         delete _tokenApprovals[tokenId];
1055 
1056         // Underflow of the sender's balance is impossible because we check for
1057         // ownership above and the recipient's balance can't realistically overflow.
1058         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1059         unchecked {
1060             // We can directly increment and decrement the balances.
1061             --_packedAddressData[from]; // Updates: `balance -= 1`.
1062             ++_packedAddressData[to]; // Updates: `balance += 1`.
1063 
1064             // Updates:
1065             // - `address` to the next owner.
1066             // - `startTimestamp` to the timestamp of transfering.
1067             // - `burned` to `false`.
1068             // - `nextInitialized` to `true`.
1069             _packedOwnerships[tokenId] =
1070                 _addressToUint256(to) |
1071                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1072                 BITMASK_NEXT_INITIALIZED;
1073 
1074             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1075             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1076                 uint256 nextTokenId = tokenId + 1;
1077                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1078                 if (_packedOwnerships[nextTokenId] == 0) {
1079                     // If the next slot is within bounds.
1080                     if (nextTokenId != _currentIndex) {
1081                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1082                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1083                     }
1084                 }
1085             }
1086         }
1087 
1088         emit Transfer(from, to, tokenId);
1089         _afterTokenTransfers(from, to, tokenId, 1);
1090     }
1091 
1092     /**
1093      * @dev Equivalent to `_burn(tokenId, false)`.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         _burn(tokenId, false);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1110         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1111 
1112         address from = address(uint160(prevOwnershipPacked));
1113 
1114         if (approvalCheck) {
1115             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1116                 isApprovedForAll(from, _msgSenderERC721A()) ||
1117                 getApproved(tokenId) == _msgSenderERC721A());
1118 
1119             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1120         }
1121 
1122         _beforeTokenTransfers(from, address(0), tokenId, 1);
1123 
1124         // Clear approvals from the previous owner.
1125         delete _tokenApprovals[tokenId];
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1130         unchecked {
1131             // Updates:
1132             // - `balance -= 1`.
1133             // - `numberBurned += 1`.
1134             //
1135             // We can directly decrement the balance, and increment the number burned.
1136             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1137             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1138 
1139             // Updates:
1140             // - `address` to the last owner.
1141             // - `startTimestamp` to the timestamp of burning.
1142             // - `burned` to `true`.
1143             // - `nextInitialized` to `true`.
1144             _packedOwnerships[tokenId] =
1145                 _addressToUint256(from) |
1146                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1147                 BITMASK_BURNED | 
1148                 BITMASK_NEXT_INITIALIZED;
1149 
1150             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1151             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1152                 uint256 nextTokenId = tokenId + 1;
1153                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1154                 if (_packedOwnerships[nextTokenId] == 0) {
1155                     // If the next slot is within bounds.
1156                     if (nextTokenId != _currentIndex) {
1157                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1158                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1159                     }
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, address(0), tokenId);
1165         _afterTokenTransfers(from, address(0), tokenId, 1);
1166 
1167         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1168         unchecked {
1169             _burnCounter++;
1170         }
1171     }
1172 
1173     /**
1174      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1175      *
1176      * @param from address representing the previous owner of the given token ID
1177      * @param to target address that will receive the tokens
1178      * @param tokenId uint256 ID of the token to be transferred
1179      * @param _data bytes optional data to send along with the call
1180      * @return bool whether the call correctly returned the expected magic value
1181      */
1182     function _checkContractOnERC721Received(
1183         address from,
1184         address to,
1185         uint256 tokenId,
1186         bytes memory _data
1187     ) private returns (bool) {
1188         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1189             bytes4 retval
1190         ) {
1191             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1192         } catch (bytes memory reason) {
1193             if (reason.length == 0) {
1194                 revert TransferToNonERC721ReceiverImplementer();
1195             } else {
1196                 assembly {
1197                     revert(add(32, reason), mload(reason))
1198                 }
1199             }
1200         }
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1205      * And also called before burning one token.
1206      *
1207      * startTokenId - the first token id to be transferred
1208      * quantity - the amount to be transferred
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, `tokenId` will be burned by `from`.
1216      * - `from` and `to` are never both zero.
1217      */
1218     function _beforeTokenTransfers(
1219         address from,
1220         address to,
1221         uint256 startTokenId,
1222         uint256 quantity
1223     ) internal virtual {}
1224 
1225     /**
1226      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1227      * minting.
1228      * And also called after one token has been burned.
1229      *
1230      * startTokenId - the first token id to be transferred
1231      * quantity - the amount to be transferred
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` has been minted for `to`.
1238      * - When `to` is zero, `tokenId` has been burned by `from`.
1239      * - `from` and `to` are never both zero.
1240      */
1241     function _afterTokenTransfers(
1242         address from,
1243         address to,
1244         uint256 startTokenId,
1245         uint256 quantity
1246     ) internal virtual {}
1247 
1248     /**
1249      * @dev Returns the message sender (defaults to `msg.sender`).
1250      *
1251      * If you are writing GSN compatible contracts, you need to override this function.
1252      */
1253     function _msgSenderERC721A() internal view virtual returns (address) {
1254         return msg.sender;
1255     }
1256 
1257     /**
1258      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1259      */
1260     function _toString(uint256 value) internal pure returns (string memory ptr) {
1261         assembly {
1262             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1263             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1264             // We will need 1 32-byte word to store the length, 
1265             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1266             ptr := add(mload(0x40), 128)
1267             // Update the free memory pointer to allocate.
1268             mstore(0x40, ptr)
1269 
1270             // Cache the end of the memory to calculate the length later.
1271             let end := ptr
1272 
1273             // We write the string from the rightmost digit to the leftmost digit.
1274             // The following is essentially a do-while loop that also handles the zero case.
1275             // Costs a bit more than early returning for the zero case,
1276             // but cheaper in terms of deployment and overall runtime costs.
1277             for { 
1278                 // Initialize and perform the first pass without check.
1279                 let temp := value
1280                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1281                 ptr := sub(ptr, 1)
1282                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1283                 mstore8(ptr, add(48, mod(temp, 10)))
1284                 temp := div(temp, 10)
1285             } temp { 
1286                 // Keep dividing `temp` until zero.
1287                 temp := div(temp, 10)
1288             } { // Body of the for loop.
1289                 ptr := sub(ptr, 1)
1290                 mstore8(ptr, add(48, mod(temp, 10)))
1291             }
1292             
1293             let length := sub(end, ptr)
1294             // Move the pointer 32 bytes leftwards to make room for the length.
1295             ptr := sub(ptr, 32)
1296             // Store the length.
1297             mstore(ptr, length)
1298         }
1299     }
1300 }
1301 
1302 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1303 
1304 
1305 // ERC721A Contracts v4.0.0
1306 // Creator: Chiru Labs
1307 
1308 pragma solidity ^0.8.4;
1309 
1310 
1311 
1312 /**
1313  * @title ERC721A Queryable
1314  * @dev ERC721A subclass with convenience query functions.
1315  */
1316 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1317     /**
1318      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1319      *
1320      * If the `tokenId` is out of bounds:
1321      *   - `addr` = `address(0)`
1322      *   - `startTimestamp` = `0`
1323      *   - `burned` = `false`
1324      *
1325      * If the `tokenId` is burned:
1326      *   - `addr` = `<Address of owner before token was burned>`
1327      *   - `startTimestamp` = `<Timestamp when token was burned>`
1328      *   - `burned = `true`
1329      *
1330      * Otherwise:
1331      *   - `addr` = `<Address of owner>`
1332      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1333      *   - `burned = `false`
1334      */
1335     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1336         TokenOwnership memory ownership;
1337         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1338             return ownership;
1339         }
1340         ownership = _ownershipAt(tokenId);
1341         if (ownership.burned) {
1342             return ownership;
1343         }
1344         return _ownershipOf(tokenId);
1345     }
1346 
1347     /**
1348      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1349      * See {ERC721AQueryable-explicitOwnershipOf}
1350      */
1351     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1352         unchecked {
1353             uint256 tokenIdsLength = tokenIds.length;
1354             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1355             for (uint256 i; i != tokenIdsLength; ++i) {
1356                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1357             }
1358             return ownerships;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Returns an array of token IDs owned by `owner`,
1364      * in the range [`start`, `stop`)
1365      * (i.e. `start <= tokenId < stop`).
1366      *
1367      * This function allows for tokens to be queried if the collection
1368      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1369      *
1370      * Requirements:
1371      *
1372      * - `start` < `stop`
1373      */
1374     function tokensOfOwnerIn(
1375         address owner,
1376         uint256 start,
1377         uint256 stop
1378     ) external view override returns (uint256[] memory) {
1379         unchecked {
1380             if (start >= stop) revert InvalidQueryRange();
1381             uint256 tokenIdsIdx;
1382             uint256 stopLimit = _nextTokenId();
1383             // Set `start = max(start, _startTokenId())`.
1384             if (start < _startTokenId()) {
1385                 start = _startTokenId();
1386             }
1387             // Set `stop = min(stop, stopLimit)`.
1388             if (stop > stopLimit) {
1389                 stop = stopLimit;
1390             }
1391             uint256 tokenIdsMaxLength = balanceOf(owner);
1392             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1393             // to cater for cases where `balanceOf(owner)` is too big.
1394             if (start < stop) {
1395                 uint256 rangeLength = stop - start;
1396                 if (rangeLength < tokenIdsMaxLength) {
1397                     tokenIdsMaxLength = rangeLength;
1398                 }
1399             } else {
1400                 tokenIdsMaxLength = 0;
1401             }
1402             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1403             if (tokenIdsMaxLength == 0) {
1404                 return tokenIds;
1405             }
1406             // We need to call `explicitOwnershipOf(start)`,
1407             // because the slot at `start` may not be initialized.
1408             TokenOwnership memory ownership = explicitOwnershipOf(start);
1409             address currOwnershipAddr;
1410             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1411             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1412             if (!ownership.burned) {
1413                 currOwnershipAddr = ownership.addr;
1414             }
1415             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1416                 ownership = _ownershipAt(i);
1417                 if (ownership.burned) {
1418                     continue;
1419                 }
1420                 if (ownership.addr != address(0)) {
1421                     currOwnershipAddr = ownership.addr;
1422                 }
1423                 if (currOwnershipAddr == owner) {
1424                     tokenIds[tokenIdsIdx++] = i;
1425                 }
1426             }
1427             // Downsize the array to fit.
1428             assembly {
1429                 mstore(tokenIds, tokenIdsIdx)
1430             }
1431             return tokenIds;
1432         }
1433     }
1434 
1435     /**
1436      * @dev Returns an array of token IDs owned by `owner`.
1437      *
1438      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1439      * It is meant to be called off-chain.
1440      *
1441      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1442      * multiple smaller scans if the collection is large enough to cause
1443      * an out-of-gas error (10K pfp collections should be fine).
1444      */
1445     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1446         unchecked {
1447             uint256 tokenIdsIdx;
1448             address currOwnershipAddr;
1449             uint256 tokenIdsLength = balanceOf(owner);
1450             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1451             TokenOwnership memory ownership;
1452             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1453                 ownership = _ownershipAt(i);
1454                 if (ownership.burned) {
1455                     continue;
1456                 }
1457                 if (ownership.addr != address(0)) {
1458                     currOwnershipAddr = ownership.addr;
1459                 }
1460                 if (currOwnershipAddr == owner) {
1461                     tokenIds[tokenIdsIdx++] = i;
1462                 }
1463             }
1464             return tokenIds;
1465         }
1466     }
1467 }
1468 
1469 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1470 
1471 
1472 // ERC721A Contracts v4.0.0
1473 // Creator: Chiru Labs
1474 
1475 pragma solidity ^0.8.4;
1476 
1477 
1478 
1479 /**
1480  * @title ERC721A Burnable Token
1481  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1482  */
1483 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1484     /**
1485      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1486      *
1487      * Requirements:
1488      *
1489      * - The caller must own `tokenId` or be an approved operator.
1490      */
1491     function burn(uint256 tokenId) public virtual override {
1492         _burn(tokenId, true);
1493     }
1494 }
1495 
1496 // File: @openzeppelin/contracts/utils/Address.sol
1497 
1498 
1499 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1500 
1501 pragma solidity ^0.8.1;
1502 
1503 /**
1504  * @dev Collection of functions related to the address type
1505  */
1506 library Address {
1507     /**
1508      * @dev Returns true if `account` is a contract.
1509      *
1510      * [IMPORTANT]
1511      * ====
1512      * It is unsafe to assume that an address for which this function returns
1513      * false is an externally-owned account (EOA) and not a contract.
1514      *
1515      * Among others, `isContract` will return false for the following
1516      * types of addresses:
1517      *
1518      *  - an externally-owned account
1519      *  - a contract in construction
1520      *  - an address where a contract will be created
1521      *  - an address where a contract lived, but was destroyed
1522      * ====
1523      *
1524      * [IMPORTANT]
1525      * ====
1526      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1527      *
1528      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1529      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1530      * constructor.
1531      * ====
1532      */
1533     function isContract(address account) internal view returns (bool) {
1534         // This method relies on extcodesize/address.code.length, which returns 0
1535         // for contracts in construction, since the code is only stored at the end
1536         // of the constructor execution.
1537 
1538         return account.code.length > 0;
1539     }
1540 
1541     /**
1542      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1543      * `recipient`, forwarding all available gas and reverting on errors.
1544      *
1545      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1546      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1547      * imposed by `transfer`, making them unable to receive funds via
1548      * `transfer`. {sendValue} removes this limitation.
1549      *
1550      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1551      *
1552      * IMPORTANT: because control is transferred to `recipient`, care must be
1553      * taken to not create reentrancy vulnerabilities. Consider using
1554      * {ReentrancyGuard} or the
1555      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1556      */
1557     function sendValue(address payable recipient, uint256 amount) internal {
1558         require(address(this).balance >= amount, "Address: insufficient balance");
1559 
1560         (bool success, ) = recipient.call{value: amount}("");
1561         require(success, "Address: unable to send value, recipient may have reverted");
1562     }
1563 
1564     /**
1565      * @dev Performs a Solidity function call using a low level `call`. A
1566      * plain `call` is an unsafe replacement for a function call: use this
1567      * function instead.
1568      *
1569      * If `target` reverts with a revert reason, it is bubbled up by this
1570      * function (like regular Solidity function calls).
1571      *
1572      * Returns the raw returned data. To convert to the expected return value,
1573      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1574      *
1575      * Requirements:
1576      *
1577      * - `target` must be a contract.
1578      * - calling `target` with `data` must not revert.
1579      *
1580      * _Available since v3.1._
1581      */
1582     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1583         return functionCall(target, data, "Address: low-level call failed");
1584     }
1585 
1586     /**
1587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1588      * `errorMessage` as a fallback revert reason when `target` reverts.
1589      *
1590      * _Available since v3.1._
1591      */
1592     function functionCall(
1593         address target,
1594         bytes memory data,
1595         string memory errorMessage
1596     ) internal returns (bytes memory) {
1597         return functionCallWithValue(target, data, 0, errorMessage);
1598     }
1599 
1600     /**
1601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1602      * but also transferring `value` wei to `target`.
1603      *
1604      * Requirements:
1605      *
1606      * - the calling contract must have an ETH balance of at least `value`.
1607      * - the called Solidity function must be `payable`.
1608      *
1609      * _Available since v3.1._
1610      */
1611     function functionCallWithValue(
1612         address target,
1613         bytes memory data,
1614         uint256 value
1615     ) internal returns (bytes memory) {
1616         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1617     }
1618 
1619     /**
1620      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1621      * with `errorMessage` as a fallback revert reason when `target` reverts.
1622      *
1623      * _Available since v3.1._
1624      */
1625     function functionCallWithValue(
1626         address target,
1627         bytes memory data,
1628         uint256 value,
1629         string memory errorMessage
1630     ) internal returns (bytes memory) {
1631         require(address(this).balance >= value, "Address: insufficient balance for call");
1632         require(isContract(target), "Address: call to non-contract");
1633 
1634         (bool success, bytes memory returndata) = target.call{value: value}(data);
1635         return verifyCallResult(success, returndata, errorMessage);
1636     }
1637 
1638     /**
1639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1640      * but performing a static call.
1641      *
1642      * _Available since v3.3._
1643      */
1644     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1645         return functionStaticCall(target, data, "Address: low-level static call failed");
1646     }
1647 
1648     /**
1649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1650      * but performing a static call.
1651      *
1652      * _Available since v3.3._
1653      */
1654     function functionStaticCall(
1655         address target,
1656         bytes memory data,
1657         string memory errorMessage
1658     ) internal view returns (bytes memory) {
1659         require(isContract(target), "Address: static call to non-contract");
1660 
1661         (bool success, bytes memory returndata) = target.staticcall(data);
1662         return verifyCallResult(success, returndata, errorMessage);
1663     }
1664 
1665     /**
1666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1667      * but performing a delegate call.
1668      *
1669      * _Available since v3.4._
1670      */
1671     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1672         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1673     }
1674 
1675     /**
1676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1677      * but performing a delegate call.
1678      *
1679      * _Available since v3.4._
1680      */
1681     function functionDelegateCall(
1682         address target,
1683         bytes memory data,
1684         string memory errorMessage
1685     ) internal returns (bytes memory) {
1686         require(isContract(target), "Address: delegate call to non-contract");
1687 
1688         (bool success, bytes memory returndata) = target.delegatecall(data);
1689         return verifyCallResult(success, returndata, errorMessage);
1690     }
1691 
1692     /**
1693      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1694      * revert reason using the provided one.
1695      *
1696      * _Available since v4.3._
1697      */
1698     function verifyCallResult(
1699         bool success,
1700         bytes memory returndata,
1701         string memory errorMessage
1702     ) internal pure returns (bytes memory) {
1703         if (success) {
1704             return returndata;
1705         } else {
1706             // Look for revert reason and bubble it up if present
1707             if (returndata.length > 0) {
1708                 // The easiest way to bubble the revert reason is using memory via assembly
1709 
1710                 assembly {
1711                     let returndata_size := mload(returndata)
1712                     revert(add(32, returndata), returndata_size)
1713                 }
1714             } else {
1715                 revert(errorMessage);
1716             }
1717         }
1718     }
1719 }
1720 
1721 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1722 
1723 
1724 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1725 
1726 pragma solidity ^0.8.0;
1727 
1728 /**
1729  * @title ERC721 token receiver interface
1730  * @dev Interface for any contract that wants to support safeTransfers
1731  * from ERC721 asset contracts.
1732  */
1733 interface IERC721Receiver {
1734     /**
1735      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1736      * by `operator` from `from`, this function is called.
1737      *
1738      * It must return its Solidity selector to confirm the token transfer.
1739      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1740      *
1741      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1742      */
1743     function onERC721Received(
1744         address operator,
1745         address from,
1746         uint256 tokenId,
1747         bytes calldata data
1748     ) external returns (bytes4);
1749 }
1750 
1751 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1752 
1753 
1754 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1755 
1756 pragma solidity ^0.8.0;
1757 
1758 /**
1759  * @dev Interface of the ERC165 standard, as defined in the
1760  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1761  *
1762  * Implementers can declare support of contract interfaces, which can then be
1763  * queried by others ({ERC165Checker}).
1764  *
1765  * For an implementation, see {ERC165}.
1766  */
1767 interface IERC165 {
1768     /**
1769      * @dev Returns true if this contract implements the interface defined by
1770      * `interfaceId`. See the corresponding
1771      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1772      * to learn more about how these ids are created.
1773      *
1774      * This function call must use less than 30 000 gas.
1775      */
1776     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1777 }
1778 
1779 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1780 
1781 
1782 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1783 
1784 pragma solidity ^0.8.0;
1785 
1786 
1787 /**
1788  * @dev Required interface of an ERC721 compliant contract.
1789  */
1790 interface IERC721 is IERC165 {
1791     /**
1792      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1793      */
1794     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1795 
1796     /**
1797      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1798      */
1799     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1800 
1801     /**
1802      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1803      */
1804     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1805 
1806     /**
1807      * @dev Returns the number of tokens in ``owner``'s account.
1808      */
1809     function balanceOf(address owner) external view returns (uint256 balance);
1810 
1811     /**
1812      * @dev Returns the owner of the `tokenId` token.
1813      *
1814      * Requirements:
1815      *
1816      * - `tokenId` must exist.
1817      */
1818     function ownerOf(uint256 tokenId) external view returns (address owner);
1819 
1820     /**
1821      * @dev Safely transfers `tokenId` token from `from` to `to`.
1822      *
1823      * Requirements:
1824      *
1825      * - `from` cannot be the zero address.
1826      * - `to` cannot be the zero address.
1827      * - `tokenId` token must exist and be owned by `from`.
1828      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1829      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1830      *
1831      * Emits a {Transfer} event.
1832      */
1833     function safeTransferFrom(
1834         address from,
1835         address to,
1836         uint256 tokenId,
1837         bytes calldata data
1838     ) external;
1839 
1840     /**
1841      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1842      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1843      *
1844      * Requirements:
1845      *
1846      * - `from` cannot be the zero address.
1847      * - `to` cannot be the zero address.
1848      * - `tokenId` token must exist and be owned by `from`.
1849      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1851      *
1852      * Emits a {Transfer} event.
1853      */
1854     function safeTransferFrom(
1855         address from,
1856         address to,
1857         uint256 tokenId
1858     ) external;
1859 
1860     /**
1861      * @dev Transfers `tokenId` token from `from` to `to`.
1862      *
1863      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1864      *
1865      * Requirements:
1866      *
1867      * - `from` cannot be the zero address.
1868      * - `to` cannot be the zero address.
1869      * - `tokenId` token must be owned by `from`.
1870      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1871      *
1872      * Emits a {Transfer} event.
1873      */
1874     function transferFrom(
1875         address from,
1876         address to,
1877         uint256 tokenId
1878     ) external;
1879 
1880     /**
1881      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1882      * The approval is cleared when the token is transferred.
1883      *
1884      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1885      *
1886      * Requirements:
1887      *
1888      * - The caller must own the token or be an approved operator.
1889      * - `tokenId` must exist.
1890      *
1891      * Emits an {Approval} event.
1892      */
1893     function approve(address to, uint256 tokenId) external;
1894 
1895     /**
1896      * @dev Approve or remove `operator` as an operator for the caller.
1897      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1898      *
1899      * Requirements:
1900      *
1901      * - The `operator` cannot be the caller.
1902      *
1903      * Emits an {ApprovalForAll} event.
1904      */
1905     function setApprovalForAll(address operator, bool _approved) external;
1906 
1907     /**
1908      * @dev Returns the account approved for `tokenId` token.
1909      *
1910      * Requirements:
1911      *
1912      * - `tokenId` must exist.
1913      */
1914     function getApproved(uint256 tokenId) external view returns (address operator);
1915 
1916     /**
1917      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1918      *
1919      * See {setApprovalForAll}
1920      */
1921     function isApprovedForAll(address owner, address operator) external view returns (bool);
1922 }
1923 
1924 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1925 
1926 
1927 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1928 
1929 pragma solidity ^0.8.0;
1930 
1931 
1932 /**
1933  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1934  * @dev See https://eips.ethereum.org/EIPS/eip-721
1935  */
1936 interface IERC721Metadata is IERC721 {
1937     /**
1938      * @dev Returns the token collection name.
1939      */
1940     function name() external view returns (string memory);
1941 
1942     /**
1943      * @dev Returns the token collection symbol.
1944      */
1945     function symbol() external view returns (string memory);
1946 
1947     /**
1948      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1949      */
1950     function tokenURI(uint256 tokenId) external view returns (string memory);
1951 }
1952 
1953 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1954 
1955 
1956 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1957 
1958 pragma solidity ^0.8.0;
1959 
1960 
1961 /**
1962  * @dev Implementation of the {IERC165} interface.
1963  *
1964  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1965  * for the additional interface id that will be supported. For example:
1966  *
1967  * ```solidity
1968  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1969  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1970  * }
1971  * ```
1972  *
1973  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1974  */
1975 abstract contract ERC165 is IERC165 {
1976     /**
1977      * @dev See {IERC165-supportsInterface}.
1978      */
1979     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1980         return interfaceId == type(IERC165).interfaceId;
1981     }
1982 }
1983 
1984 // File: @openzeppelin/contracts/access/IAccessControl.sol
1985 
1986 
1987 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1988 
1989 pragma solidity ^0.8.0;
1990 
1991 /**
1992  * @dev External interface of AccessControl declared to support ERC165 detection.
1993  */
1994 interface IAccessControl {
1995     /**
1996      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1997      *
1998      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1999      * {RoleAdminChanged} not being emitted signaling this.
2000      *
2001      * _Available since v3.1._
2002      */
2003     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2004 
2005     /**
2006      * @dev Emitted when `account` is granted `role`.
2007      *
2008      * `sender` is the account that originated the contract call, an admin role
2009      * bearer except when using {AccessControl-_setupRole}.
2010      */
2011     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2012 
2013     /**
2014      * @dev Emitted when `account` is revoked `role`.
2015      *
2016      * `sender` is the account that originated the contract call:
2017      *   - if using `revokeRole`, it is the admin role bearer
2018      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2019      */
2020     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2021 
2022     /**
2023      * @dev Returns `true` if `account` has been granted `role`.
2024      */
2025     function hasRole(bytes32 role, address account) external view returns (bool);
2026 
2027     /**
2028      * @dev Returns the admin role that controls `role`. See {grantRole} and
2029      * {revokeRole}.
2030      *
2031      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2032      */
2033     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2034 
2035     /**
2036      * @dev Grants `role` to `account`.
2037      *
2038      * If `account` had not been already granted `role`, emits a {RoleGranted}
2039      * event.
2040      *
2041      * Requirements:
2042      *
2043      * - the caller must have ``role``'s admin role.
2044      */
2045     function grantRole(bytes32 role, address account) external;
2046 
2047     /**
2048      * @dev Revokes `role` from `account`.
2049      *
2050      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2051      *
2052      * Requirements:
2053      *
2054      * - the caller must have ``role``'s admin role.
2055      */
2056     function revokeRole(bytes32 role, address account) external;
2057 
2058     /**
2059      * @dev Revokes `role` from the calling account.
2060      *
2061      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2062      * purpose is to provide a mechanism for accounts to lose their privileges
2063      * if they are compromised (such as when a trusted device is misplaced).
2064      *
2065      * If the calling account had been granted `role`, emits a {RoleRevoked}
2066      * event.
2067      *
2068      * Requirements:
2069      *
2070      * - the caller must be `account`.
2071      */
2072     function renounceRole(bytes32 role, address account) external;
2073 }
2074 
2075 // File: @openzeppelin/contracts/utils/Counters.sol
2076 
2077 
2078 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
2079 
2080 pragma solidity ^0.8.0;
2081 
2082 /**
2083  * @title Counters
2084  * @author Matt Condon (@shrugs)
2085  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
2086  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
2087  *
2088  * Include with `using Counters for Counters.Counter;`
2089  */
2090 library Counters {
2091     struct Counter {
2092         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2093         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2094         // this feature: see https://github.com/ethereum/solidity/issues/4637
2095         uint256 _value; // default: 0
2096     }
2097 
2098     function current(Counter storage counter) internal view returns (uint256) {
2099         return counter._value;
2100     }
2101 
2102     function increment(Counter storage counter) internal {
2103         unchecked {
2104             counter._value += 1;
2105         }
2106     }
2107 
2108     function decrement(Counter storage counter) internal {
2109         uint256 value = counter._value;
2110         require(value > 0, "Counter: decrement overflow");
2111         unchecked {
2112             counter._value = value - 1;
2113         }
2114     }
2115 
2116     function reset(Counter storage counter) internal {
2117         counter._value = 0;
2118     }
2119 }
2120 
2121 // File: @openzeppelin/contracts/utils/Context.sol
2122 
2123 
2124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2125 
2126 pragma solidity ^0.8.0;
2127 
2128 /**
2129  * @dev Provides information about the current execution context, including the
2130  * sender of the transaction and its data. While these are generally available
2131  * via msg.sender and msg.data, they should not be accessed in such a direct
2132  * manner, since when dealing with meta-transactions the account sending and
2133  * paying for execution may not be the actual sender (as far as an application
2134  * is concerned).
2135  *
2136  * This contract is only required for intermediate, library-like contracts.
2137  */
2138 abstract contract Context {
2139     function _msgSender() internal view virtual returns (address) {
2140         return msg.sender;
2141     }
2142 
2143     function _msgData() internal view virtual returns (bytes calldata) {
2144         return msg.data;
2145     }
2146 }
2147 
2148 // File: @openzeppelin/contracts/security/Pausable.sol
2149 
2150 
2151 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2152 
2153 pragma solidity ^0.8.0;
2154 
2155 
2156 /**
2157  * @dev Contract module which allows children to implement an emergency stop
2158  * mechanism that can be triggered by an authorized account.
2159  *
2160  * This module is used through inheritance. It will make available the
2161  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2162  * the functions of your contract. Note that they will not be pausable by
2163  * simply including this module, only once the modifiers are put in place.
2164  */
2165 abstract contract Pausable is Context {
2166     /**
2167      * @dev Emitted when the pause is triggered by `account`.
2168      */
2169     event Paused(address account);
2170 
2171     /**
2172      * @dev Emitted when the pause is lifted by `account`.
2173      */
2174     event Unpaused(address account);
2175 
2176     bool private _paused;
2177 
2178     /**
2179      * @dev Initializes the contract in unpaused state.
2180      */
2181     constructor() {
2182         _paused = false;
2183     }
2184 
2185     /**
2186      * @dev Returns true if the contract is paused, and false otherwise.
2187      */
2188     function paused() public view virtual returns (bool) {
2189         return _paused;
2190     }
2191 
2192     /**
2193      * @dev Modifier to make a function callable only when the contract is not paused.
2194      *
2195      * Requirements:
2196      *
2197      * - The contract must not be paused.
2198      */
2199     modifier whenNotPaused() {
2200         require(!paused(), "Pausable: paused");
2201         _;
2202     }
2203 
2204     /**
2205      * @dev Modifier to make a function callable only when the contract is paused.
2206      *
2207      * Requirements:
2208      *
2209      * - The contract must be paused.
2210      */
2211     modifier whenPaused() {
2212         require(paused(), "Pausable: not paused");
2213         _;
2214     }
2215 
2216     /**
2217      * @dev Triggers stopped state.
2218      *
2219      * Requirements:
2220      *
2221      * - The contract must not be paused.
2222      */
2223     function _pause() internal virtual whenNotPaused {
2224         _paused = true;
2225         emit Paused(_msgSender());
2226     }
2227 
2228     /**
2229      * @dev Returns to normal state.
2230      *
2231      * Requirements:
2232      *
2233      * - The contract must be paused.
2234      */
2235     function _unpause() internal virtual whenPaused {
2236         _paused = false;
2237         emit Unpaused(_msgSender());
2238     }
2239 }
2240 
2241 // File: nft/ERC721APausable.sol
2242 
2243 
2244 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2245 
2246 pragma solidity ^0.8.0;
2247 
2248 
2249 
2250 /**
2251  * @dev ERC721 token with pausable token transfers, minting and burning.
2252  *
2253  * Useful for scenarios such as preventing trades until the end of an evaluation
2254  * period, or having an emergency switch for freezing all token transfers in the
2255  * event of a large bug.
2256  */
2257 abstract contract ERC721APausable is ERC721A, Pausable {
2258     /**
2259      * @dev See {ERC721A-_beforeTokenTransfers}.
2260      *
2261      * Requirements:
2262      *
2263      * - the contract must not be paused.
2264      */
2265     function _beforeTokenTransfers(
2266         address from,
2267         address to,
2268         uint256 startTokenId,
2269         uint256 quantity
2270     ) internal virtual override(ERC721A) {
2271         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2272         require(!paused(), "ERC721APausable: token transfer while paused");
2273     }
2274 }
2275 
2276 // File: @openzeppelin/contracts/access/Ownable.sol
2277 
2278 
2279 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2280 
2281 pragma solidity ^0.8.0;
2282 
2283 
2284 /**
2285  * @dev Contract module which provides a basic access control mechanism, where
2286  * there is an account (an owner) that can be granted exclusive access to
2287  * specific functions.
2288  *
2289  * By default, the owner account will be the one that deploys the contract. This
2290  * can later be changed with {transferOwnership}.
2291  *
2292  * This module is used through inheritance. It will make available the modifier
2293  * `onlyOwner`, which can be applied to your functions to restrict their use to
2294  * the owner.
2295  */
2296 abstract contract Ownable is Context {
2297     address private _owner;
2298 
2299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2300 
2301     /**
2302      * @dev Initializes the contract setting the deployer as the initial owner.
2303      */
2304     constructor() {
2305         _transferOwnership(_msgSender());
2306     }
2307 
2308     /**
2309      * @dev Returns the address of the current owner.
2310      */
2311     function owner() public view virtual returns (address) {
2312         return _owner;
2313     }
2314 
2315     /**
2316      * @dev Throws if called by any account other than the owner.
2317      */
2318     modifier onlyOwner() {
2319         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2320         _;
2321     }
2322 
2323     /**
2324      * @dev Leaves the contract without owner. It will not be possible to call
2325      * `onlyOwner` functions anymore. Can only be called by the current owner.
2326      *
2327      * NOTE: Renouncing ownership will leave the contract without an owner,
2328      * thereby removing any functionality that is only available to the owner.
2329      */
2330     function renounceOwnership() public virtual onlyOwner {
2331         _transferOwnership(address(0));
2332     }
2333 
2334     /**
2335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2336      * Can only be called by the current owner.
2337      */
2338     function transferOwnership(address newOwner) public virtual onlyOwner {
2339         require(newOwner != address(0), "Ownable: new owner is the zero address");
2340         _transferOwnership(newOwner);
2341     }
2342 
2343     /**
2344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2345      * Internal function without access restriction.
2346      */
2347     function _transferOwnership(address newOwner) internal virtual {
2348         address oldOwner = _owner;
2349         _owner = newOwner;
2350         emit OwnershipTransferred(oldOwner, newOwner);
2351     }
2352 }
2353 
2354 // File: @openzeppelin/contracts/utils/Strings.sol
2355 
2356 
2357 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2358 
2359 pragma solidity ^0.8.0;
2360 
2361 /**
2362  * @dev String operations.
2363  */
2364 library Strings {
2365     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2366 
2367     /**
2368      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2369      */
2370     function toString(uint256 value) internal pure returns (string memory) {
2371         // Inspired by OraclizeAPI's implementation - MIT licence
2372         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2373 
2374         if (value == 0) {
2375             return "0";
2376         }
2377         uint256 temp = value;
2378         uint256 digits;
2379         while (temp != 0) {
2380             digits++;
2381             temp /= 10;
2382         }
2383         bytes memory buffer = new bytes(digits);
2384         while (value != 0) {
2385             digits -= 1;
2386             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2387             value /= 10;
2388         }
2389         return string(buffer);
2390     }
2391 
2392     /**
2393      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2394      */
2395     function toHexString(uint256 value) internal pure returns (string memory) {
2396         if (value == 0) {
2397             return "0x00";
2398         }
2399         uint256 temp = value;
2400         uint256 length = 0;
2401         while (temp != 0) {
2402             length++;
2403             temp >>= 8;
2404         }
2405         return toHexString(value, length);
2406     }
2407 
2408     /**
2409      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2410      */
2411     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2412         bytes memory buffer = new bytes(2 * length + 2);
2413         buffer[0] = "0";
2414         buffer[1] = "x";
2415         for (uint256 i = 2 * length + 1; i > 1; --i) {
2416             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2417             value >>= 4;
2418         }
2419         require(value == 0, "Strings: hex length insufficient");
2420         return string(buffer);
2421     }
2422 }
2423 
2424 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2425 
2426 
2427 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2428 
2429 pragma solidity ^0.8.0;
2430 
2431 
2432 
2433 
2434 
2435 
2436 
2437 
2438 /**
2439  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2440  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2441  * {ERC721Enumerable}.
2442  */
2443 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2444     using Address for address;
2445     using Strings for uint256;
2446 
2447     // Token name
2448     string private _name;
2449 
2450     // Token symbol
2451     string private _symbol;
2452 
2453     // Mapping from token ID to owner address
2454     mapping(uint256 => address) private _owners;
2455 
2456     // Mapping owner address to token count
2457     mapping(address => uint256) private _balances;
2458 
2459     // Mapping from token ID to approved address
2460     mapping(uint256 => address) private _tokenApprovals;
2461 
2462     // Mapping from owner to operator approvals
2463     mapping(address => mapping(address => bool)) private _operatorApprovals;
2464 
2465     /**
2466      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2467      */
2468     constructor(string memory name_, string memory symbol_) {
2469         _name = name_;
2470         _symbol = symbol_;
2471     }
2472 
2473     /**
2474      * @dev See {IERC165-supportsInterface}.
2475      */
2476     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2477         return
2478             interfaceId == type(IERC721).interfaceId ||
2479             interfaceId == type(IERC721Metadata).interfaceId ||
2480             super.supportsInterface(interfaceId);
2481     }
2482 
2483     /**
2484      * @dev See {IERC721-balanceOf}.
2485      */
2486     function balanceOf(address owner) public view virtual override returns (uint256) {
2487         require(owner != address(0), "ERC721: balance query for the zero address");
2488         return _balances[owner];
2489     }
2490 
2491     /**
2492      * @dev See {IERC721-ownerOf}.
2493      */
2494     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2495         address owner = _owners[tokenId];
2496         require(owner != address(0), "ERC721: owner query for nonexistent token");
2497         return owner;
2498     }
2499 
2500     /**
2501      * @dev See {IERC721Metadata-name}.
2502      */
2503     function name() public view virtual override returns (string memory) {
2504         return _name;
2505     }
2506 
2507     /**
2508      * @dev See {IERC721Metadata-symbol}.
2509      */
2510     function symbol() public view virtual override returns (string memory) {
2511         return _symbol;
2512     }
2513 
2514     /**
2515      * @dev See {IERC721Metadata-tokenURI}.
2516      */
2517     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2518         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2519 
2520         string memory baseURI = _baseURI();
2521         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2522     }
2523 
2524     /**
2525      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2526      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2527      * by default, can be overridden in child contracts.
2528      */
2529     function _baseURI() internal view virtual returns (string memory) {
2530         return "";
2531     }
2532 
2533     /**
2534      * @dev See {IERC721-approve}.
2535      */
2536     function approve(address to, uint256 tokenId) public virtual override {
2537         address owner = ERC721.ownerOf(tokenId);
2538         require(to != owner, "ERC721: approval to current owner");
2539 
2540         require(
2541             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2542             "ERC721: approve caller is not owner nor approved for all"
2543         );
2544 
2545         _approve(to, tokenId);
2546     }
2547 
2548     /**
2549      * @dev See {IERC721-getApproved}.
2550      */
2551     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2552         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2553 
2554         return _tokenApprovals[tokenId];
2555     }
2556 
2557     /**
2558      * @dev See {IERC721-setApprovalForAll}.
2559      */
2560     function setApprovalForAll(address operator, bool approved) public virtual override {
2561         _setApprovalForAll(_msgSender(), operator, approved);
2562     }
2563 
2564     /**
2565      * @dev See {IERC721-isApprovedForAll}.
2566      */
2567     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2568         return _operatorApprovals[owner][operator];
2569     }
2570 
2571     /**
2572      * @dev See {IERC721-transferFrom}.
2573      */
2574     function transferFrom(
2575         address from,
2576         address to,
2577         uint256 tokenId
2578     ) public virtual override {
2579         //solhint-disable-next-line max-line-length
2580         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2581 
2582         _transfer(from, to, tokenId);
2583     }
2584 
2585     /**
2586      * @dev See {IERC721-safeTransferFrom}.
2587      */
2588     function safeTransferFrom(
2589         address from,
2590         address to,
2591         uint256 tokenId
2592     ) public virtual override {
2593         safeTransferFrom(from, to, tokenId, "");
2594     }
2595 
2596     /**
2597      * @dev See {IERC721-safeTransferFrom}.
2598      */
2599     function safeTransferFrom(
2600         address from,
2601         address to,
2602         uint256 tokenId,
2603         bytes memory _data
2604     ) public virtual override {
2605         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2606         _safeTransfer(from, to, tokenId, _data);
2607     }
2608 
2609     /**
2610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2612      *
2613      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2614      *
2615      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2616      * implement alternative mechanisms to perform token transfer, such as signature-based.
2617      *
2618      * Requirements:
2619      *
2620      * - `from` cannot be the zero address.
2621      * - `to` cannot be the zero address.
2622      * - `tokenId` token must exist and be owned by `from`.
2623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2624      *
2625      * Emits a {Transfer} event.
2626      */
2627     function _safeTransfer(
2628         address from,
2629         address to,
2630         uint256 tokenId,
2631         bytes memory _data
2632     ) internal virtual {
2633         _transfer(from, to, tokenId);
2634         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2635     }
2636 
2637     /**
2638      * @dev Returns whether `tokenId` exists.
2639      *
2640      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2641      *
2642      * Tokens start existing when they are minted (`_mint`),
2643      * and stop existing when they are burned (`_burn`).
2644      */
2645     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2646         return _owners[tokenId] != address(0);
2647     }
2648 
2649     /**
2650      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2651      *
2652      * Requirements:
2653      *
2654      * - `tokenId` must exist.
2655      */
2656     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2657         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2658         address owner = ERC721.ownerOf(tokenId);
2659         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2660     }
2661 
2662     /**
2663      * @dev Safely mints `tokenId` and transfers it to `to`.
2664      *
2665      * Requirements:
2666      *
2667      * - `tokenId` must not exist.
2668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2669      *
2670      * Emits a {Transfer} event.
2671      */
2672     function _safeMint(address to, uint256 tokenId) internal virtual {
2673         _safeMint(to, tokenId, "");
2674     }
2675 
2676     /**
2677      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2678      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2679      */
2680     function _safeMint(
2681         address to,
2682         uint256 tokenId,
2683         bytes memory _data
2684     ) internal virtual {
2685         _mint(to, tokenId);
2686         require(
2687             _checkOnERC721Received(address(0), to, tokenId, _data),
2688             "ERC721: transfer to non ERC721Receiver implementer"
2689         );
2690     }
2691 
2692     /**
2693      * @dev Mints `tokenId` and transfers it to `to`.
2694      *
2695      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2696      *
2697      * Requirements:
2698      *
2699      * - `tokenId` must not exist.
2700      * - `to` cannot be the zero address.
2701      *
2702      * Emits a {Transfer} event.
2703      */
2704     function _mint(address to, uint256 tokenId) internal virtual {
2705         require(to != address(0), "ERC721: mint to the zero address");
2706         require(!_exists(tokenId), "ERC721: token already minted");
2707 
2708         _beforeTokenTransfer(address(0), to, tokenId);
2709 
2710         _balances[to] += 1;
2711         _owners[tokenId] = to;
2712 
2713         emit Transfer(address(0), to, tokenId);
2714 
2715         _afterTokenTransfer(address(0), to, tokenId);
2716     }
2717 
2718     /**
2719      * @dev Destroys `tokenId`.
2720      * The approval is cleared when the token is burned.
2721      *
2722      * Requirements:
2723      *
2724      * - `tokenId` must exist.
2725      *
2726      * Emits a {Transfer} event.
2727      */
2728     function _burn(uint256 tokenId) internal virtual {
2729         address owner = ERC721.ownerOf(tokenId);
2730 
2731         _beforeTokenTransfer(owner, address(0), tokenId);
2732 
2733         // Clear approvals
2734         _approve(address(0), tokenId);
2735 
2736         _balances[owner] -= 1;
2737         delete _owners[tokenId];
2738 
2739         emit Transfer(owner, address(0), tokenId);
2740 
2741         _afterTokenTransfer(owner, address(0), tokenId);
2742     }
2743 
2744     /**
2745      * @dev Transfers `tokenId` from `from` to `to`.
2746      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2747      *
2748      * Requirements:
2749      *
2750      * - `to` cannot be the zero address.
2751      * - `tokenId` token must be owned by `from`.
2752      *
2753      * Emits a {Transfer} event.
2754      */
2755     function _transfer(
2756         address from,
2757         address to,
2758         uint256 tokenId
2759     ) internal virtual {
2760         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2761         require(to != address(0), "ERC721: transfer to the zero address");
2762 
2763         _beforeTokenTransfer(from, to, tokenId);
2764 
2765         // Clear approvals from the previous owner
2766         _approve(address(0), tokenId);
2767 
2768         _balances[from] -= 1;
2769         _balances[to] += 1;
2770         _owners[tokenId] = to;
2771 
2772         emit Transfer(from, to, tokenId);
2773 
2774         _afterTokenTransfer(from, to, tokenId);
2775     }
2776 
2777     /**
2778      * @dev Approve `to` to operate on `tokenId`
2779      *
2780      * Emits a {Approval} event.
2781      */
2782     function _approve(address to, uint256 tokenId) internal virtual {
2783         _tokenApprovals[tokenId] = to;
2784         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2785     }
2786 
2787     /**
2788      * @dev Approve `operator` to operate on all of `owner` tokens
2789      *
2790      * Emits a {ApprovalForAll} event.
2791      */
2792     function _setApprovalForAll(
2793         address owner,
2794         address operator,
2795         bool approved
2796     ) internal virtual {
2797         require(owner != operator, "ERC721: approve to caller");
2798         _operatorApprovals[owner][operator] = approved;
2799         emit ApprovalForAll(owner, operator, approved);
2800     }
2801 
2802     /**
2803      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2804      * The call is not executed if the target address is not a contract.
2805      *
2806      * @param from address representing the previous owner of the given token ID
2807      * @param to target address that will receive the tokens
2808      * @param tokenId uint256 ID of the token to be transferred
2809      * @param _data bytes optional data to send along with the call
2810      * @return bool whether the call correctly returned the expected magic value
2811      */
2812     function _checkOnERC721Received(
2813         address from,
2814         address to,
2815         uint256 tokenId,
2816         bytes memory _data
2817     ) private returns (bool) {
2818         if (to.isContract()) {
2819             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2820                 return retval == IERC721Receiver.onERC721Received.selector;
2821             } catch (bytes memory reason) {
2822                 if (reason.length == 0) {
2823                     revert("ERC721: transfer to non ERC721Receiver implementer");
2824                 } else {
2825                     assembly {
2826                         revert(add(32, reason), mload(reason))
2827                     }
2828                 }
2829             }
2830         } else {
2831             return true;
2832         }
2833     }
2834 
2835     /**
2836      * @dev Hook that is called before any token transfer. This includes minting
2837      * and burning.
2838      *
2839      * Calling conditions:
2840      *
2841      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2842      * transferred to `to`.
2843      * - When `from` is zero, `tokenId` will be minted for `to`.
2844      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2845      * - `from` and `to` are never both zero.
2846      *
2847      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2848      */
2849     function _beforeTokenTransfer(
2850         address from,
2851         address to,
2852         uint256 tokenId
2853     ) internal virtual {}
2854 
2855     /**
2856      * @dev Hook that is called after any transfer of tokens. This includes
2857      * minting and burning.
2858      *
2859      * Calling conditions:
2860      *
2861      * - when `from` and `to` are both non-zero.
2862      * - `from` and `to` are never both zero.
2863      *
2864      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2865      */
2866     function _afterTokenTransfer(
2867         address from,
2868         address to,
2869         uint256 tokenId
2870     ) internal virtual {}
2871 }
2872 
2873 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2874 
2875 
2876 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2877 
2878 pragma solidity ^0.8.0;
2879 
2880 
2881 
2882 /**
2883  * @dev ERC721 token with pausable token transfers, minting and burning.
2884  *
2885  * Useful for scenarios such as preventing trades until the end of an evaluation
2886  * period, or having an emergency switch for freezing all token transfers in the
2887  * event of a large bug.
2888  */
2889 abstract contract ERC721Pausable is ERC721, Pausable {
2890     /**
2891      * @dev See {ERC721-_beforeTokenTransfer}.
2892      *
2893      * Requirements:
2894      *
2895      * - the contract must not be paused.
2896      */
2897     function _beforeTokenTransfer(
2898         address from,
2899         address to,
2900         uint256 tokenId
2901     ) internal virtual override {
2902         super._beforeTokenTransfer(from, to, tokenId);
2903 
2904         require(!paused(), "ERC721Pausable: token transfer while paused");
2905     }
2906 }
2907 
2908 // File: @openzeppelin/contracts/access/AccessControl.sol
2909 
2910 
2911 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
2912 
2913 pragma solidity ^0.8.0;
2914 
2915 
2916 
2917 
2918 
2919 /**
2920  * @dev Contract module that allows children to implement role-based access
2921  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2922  * members except through off-chain means by accessing the contract event logs. Some
2923  * applications may benefit from on-chain enumerability, for those cases see
2924  * {AccessControlEnumerable}.
2925  *
2926  * Roles are referred to by their `bytes32` identifier. These should be exposed
2927  * in the external API and be unique. The best way to achieve this is by
2928  * using `public constant` hash digests:
2929  *
2930  * ```
2931  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2932  * ```
2933  *
2934  * Roles can be used to represent a set of permissions. To restrict access to a
2935  * function call, use {hasRole}:
2936  *
2937  * ```
2938  * function foo() public {
2939  *     require(hasRole(MY_ROLE, msg.sender));
2940  *     ...
2941  * }
2942  * ```
2943  *
2944  * Roles can be granted and revoked dynamically via the {grantRole} and
2945  * {revokeRole} functions. Each role has an associated admin role, and only
2946  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2947  *
2948  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2949  * that only accounts with this role will be able to grant or revoke other
2950  * roles. More complex role relationships can be created by using
2951  * {_setRoleAdmin}.
2952  *
2953  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2954  * grant and revoke this role. Extra precautions should be taken to secure
2955  * accounts that have been granted it.
2956  */
2957 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2958     struct RoleData {
2959         mapping(address => bool) members;
2960         bytes32 adminRole;
2961     }
2962 
2963     mapping(bytes32 => RoleData) private _roles;
2964 
2965     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2966 
2967     /**
2968      * @dev Modifier that checks that an account has a specific role. Reverts
2969      * with a standardized message including the required role.
2970      *
2971      * The format of the revert reason is given by the following regular expression:
2972      *
2973      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2974      *
2975      * _Available since v4.1._
2976      */
2977     modifier onlyRole(bytes32 role) {
2978         _checkRole(role);
2979         _;
2980     }
2981 
2982     /**
2983      * @dev See {IERC165-supportsInterface}.
2984      */
2985     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2986         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2987     }
2988 
2989     /**
2990      * @dev Returns `true` if `account` has been granted `role`.
2991      */
2992     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2993         return _roles[role].members[account];
2994     }
2995 
2996     /**
2997      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2998      * Overriding this function changes the behavior of the {onlyRole} modifier.
2999      *
3000      * Format of the revert message is described in {_checkRole}.
3001      *
3002      * _Available since v4.6._
3003      */
3004     function _checkRole(bytes32 role) internal view virtual {
3005         _checkRole(role, _msgSender());
3006     }
3007 
3008     /**
3009      * @dev Revert with a standard message if `account` is missing `role`.
3010      *
3011      * The format of the revert reason is given by the following regular expression:
3012      *
3013      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3014      */
3015     function _checkRole(bytes32 role, address account) internal view virtual {
3016         if (!hasRole(role, account)) {
3017             revert(
3018                 string(
3019                     abi.encodePacked(
3020                         "AccessControl: account ",
3021                         Strings.toHexString(uint160(account), 20),
3022                         " is missing role ",
3023                         Strings.toHexString(uint256(role), 32)
3024                     )
3025                 )
3026             );
3027         }
3028     }
3029 
3030     /**
3031      * @dev Returns the admin role that controls `role`. See {grantRole} and
3032      * {revokeRole}.
3033      *
3034      * To change a role's admin, use {_setRoleAdmin}.
3035      */
3036     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
3037         return _roles[role].adminRole;
3038     }
3039 
3040     /**
3041      * @dev Grants `role` to `account`.
3042      *
3043      * If `account` had not been already granted `role`, emits a {RoleGranted}
3044      * event.
3045      *
3046      * Requirements:
3047      *
3048      * - the caller must have ``role``'s admin role.
3049      */
3050     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3051         _grantRole(role, account);
3052     }
3053 
3054     /**
3055      * @dev Revokes `role` from `account`.
3056      *
3057      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3058      *
3059      * Requirements:
3060      *
3061      * - the caller must have ``role``'s admin role.
3062      */
3063     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3064         _revokeRole(role, account);
3065     }
3066 
3067     /**
3068      * @dev Revokes `role` from the calling account.
3069      *
3070      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3071      * purpose is to provide a mechanism for accounts to lose their privileges
3072      * if they are compromised (such as when a trusted device is misplaced).
3073      *
3074      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3075      * event.
3076      *
3077      * Requirements:
3078      *
3079      * - the caller must be `account`.
3080      */
3081     function renounceRole(bytes32 role, address account) public virtual override {
3082         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3083 
3084         _revokeRole(role, account);
3085     }
3086 
3087     /**
3088      * @dev Grants `role` to `account`.
3089      *
3090      * If `account` had not been already granted `role`, emits a {RoleGranted}
3091      * event. Note that unlike {grantRole}, this function doesn't perform any
3092      * checks on the calling account.
3093      *
3094      * [WARNING]
3095      * ====
3096      * This function should only be called from the constructor when setting
3097      * up the initial roles for the system.
3098      *
3099      * Using this function in any other way is effectively circumventing the admin
3100      * system imposed by {AccessControl}.
3101      * ====
3102      *
3103      * NOTE: This function is deprecated in favor of {_grantRole}.
3104      */
3105     function _setupRole(bytes32 role, address account) internal virtual {
3106         _grantRole(role, account);
3107     }
3108 
3109     /**
3110      * @dev Sets `adminRole` as ``role``'s admin role.
3111      *
3112      * Emits a {RoleAdminChanged} event.
3113      */
3114     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3115         bytes32 previousAdminRole = getRoleAdmin(role);
3116         _roles[role].adminRole = adminRole;
3117         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3118     }
3119 
3120     /**
3121      * @dev Grants `role` to `account`.
3122      *
3123      * Internal function without access restriction.
3124      */
3125     function _grantRole(bytes32 role, address account) internal virtual {
3126         if (!hasRole(role, account)) {
3127             _roles[role].members[account] = true;
3128             emit RoleGranted(role, account, _msgSender());
3129         }
3130     }
3131 
3132     /**
3133      * @dev Revokes `role` from `account`.
3134      *
3135      * Internal function without access restriction.
3136      */
3137     function _revokeRole(bytes32 role, address account) internal virtual {
3138         if (hasRole(role, account)) {
3139             _roles[role].members[account] = false;
3140             emit RoleRevoked(role, account, _msgSender());
3141         }
3142     }
3143 }
3144 
3145 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
3146 
3147 
3148 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
3149 
3150 pragma solidity ^0.8.0;
3151 
3152 
3153 /**
3154  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
3155  *
3156  * These functions can be used to verify that a message was signed by the holder
3157  * of the private keys of a given address.
3158  */
3159 library ECDSA {
3160     enum RecoverError {
3161         NoError,
3162         InvalidSignature,
3163         InvalidSignatureLength,
3164         InvalidSignatureS,
3165         InvalidSignatureV
3166     }
3167 
3168     function _throwError(RecoverError error) private pure {
3169         if (error == RecoverError.NoError) {
3170             return; // no error: do nothing
3171         } else if (error == RecoverError.InvalidSignature) {
3172             revert("ECDSA: invalid signature");
3173         } else if (error == RecoverError.InvalidSignatureLength) {
3174             revert("ECDSA: invalid signature length");
3175         } else if (error == RecoverError.InvalidSignatureS) {
3176             revert("ECDSA: invalid signature 's' value");
3177         } else if (error == RecoverError.InvalidSignatureV) {
3178             revert("ECDSA: invalid signature 'v' value");
3179         }
3180     }
3181 
3182     /**
3183      * @dev Returns the address that signed a hashed message (`hash`) with
3184      * `signature` or error string. This address can then be used for verification purposes.
3185      *
3186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
3187      * this function rejects them by requiring the `s` value to be in the lower
3188      * half order, and the `v` value to be either 27 or 28.
3189      *
3190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
3191      * verification to be secure: it is possible to craft signatures that
3192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
3193      * this is by receiving a hash of the original message (which may otherwise
3194      * be too long), and then calling {toEthSignedMessageHash} on it.
3195      *
3196      * Documentation for signature generation:
3197      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
3198      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
3199      *
3200      * _Available since v4.3._
3201      */
3202     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
3203         // Check the signature length
3204         // - case 65: r,s,v signature (standard)
3205         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
3206         if (signature.length == 65) {
3207             bytes32 r;
3208             bytes32 s;
3209             uint8 v;
3210             // ecrecover takes the signature parameters, and the only way to get them
3211             // currently is to use assembly.
3212             assembly {
3213                 r := mload(add(signature, 0x20))
3214                 s := mload(add(signature, 0x40))
3215                 v := byte(0, mload(add(signature, 0x60)))
3216             }
3217             return tryRecover(hash, v, r, s);
3218         } else if (signature.length == 64) {
3219             bytes32 r;
3220             bytes32 vs;
3221             // ecrecover takes the signature parameters, and the only way to get them
3222             // currently is to use assembly.
3223             assembly {
3224                 r := mload(add(signature, 0x20))
3225                 vs := mload(add(signature, 0x40))
3226             }
3227             return tryRecover(hash, r, vs);
3228         } else {
3229             return (address(0), RecoverError.InvalidSignatureLength);
3230         }
3231     }
3232 
3233     /**
3234      * @dev Returns the address that signed a hashed message (`hash`) with
3235      * `signature`. This address can then be used for verification purposes.
3236      *
3237      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
3238      * this function rejects them by requiring the `s` value to be in the lower
3239      * half order, and the `v` value to be either 27 or 28.
3240      *
3241      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
3242      * verification to be secure: it is possible to craft signatures that
3243      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
3244      * this is by receiving a hash of the original message (which may otherwise
3245      * be too long), and then calling {toEthSignedMessageHash} on it.
3246      */
3247     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
3248         (address recovered, RecoverError error) = tryRecover(hash, signature);
3249         _throwError(error);
3250         return recovered;
3251     }
3252 
3253     /**
3254      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
3255      *
3256      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
3257      *
3258      * _Available since v4.3._
3259      */
3260     function tryRecover(
3261         bytes32 hash,
3262         bytes32 r,
3263         bytes32 vs
3264     ) internal pure returns (address, RecoverError) {
3265         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
3266         uint8 v = uint8((uint256(vs) >> 255) + 27);
3267         return tryRecover(hash, v, r, s);
3268     }
3269 
3270     /**
3271      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
3272      *
3273      * _Available since v4.2._
3274      */
3275     function recover(
3276         bytes32 hash,
3277         bytes32 r,
3278         bytes32 vs
3279     ) internal pure returns (address) {
3280         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
3281         _throwError(error);
3282         return recovered;
3283     }
3284 
3285     /**
3286      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
3287      * `r` and `s` signature fields separately.
3288      *
3289      * _Available since v4.3._
3290      */
3291     function tryRecover(
3292         bytes32 hash,
3293         uint8 v,
3294         bytes32 r,
3295         bytes32 s
3296     ) internal pure returns (address, RecoverError) {
3297         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
3298         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
3299         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
3300         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
3301         //
3302         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
3303         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
3304         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
3305         // these malleable signatures as well.
3306         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
3307             return (address(0), RecoverError.InvalidSignatureS);
3308         }
3309         if (v != 27 && v != 28) {
3310             return (address(0), RecoverError.InvalidSignatureV);
3311         }
3312 
3313         // If the signature is valid (and not malleable), return the signer address
3314         address signer = ecrecover(hash, v, r, s);
3315         if (signer == address(0)) {
3316             return (address(0), RecoverError.InvalidSignature);
3317         }
3318 
3319         return (signer, RecoverError.NoError);
3320     }
3321 
3322     /**
3323      * @dev Overload of {ECDSA-recover} that receives the `v`,
3324      * `r` and `s` signature fields separately.
3325      */
3326     function recover(
3327         bytes32 hash,
3328         uint8 v,
3329         bytes32 r,
3330         bytes32 s
3331     ) internal pure returns (address) {
3332         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
3333         _throwError(error);
3334         return recovered;
3335     }
3336 
3337     /**
3338      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
3339      * produces hash corresponding to the one signed with the
3340      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3341      * JSON-RPC method as part of EIP-191.
3342      *
3343      * See {recover}.
3344      */
3345     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
3346         // 32 is the length in bytes of hash,
3347         // enforced by the type signature above
3348         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
3349     }
3350 
3351     /**
3352      * @dev Returns an Ethereum Signed Message, created from `s`. This
3353      * produces hash corresponding to the one signed with the
3354      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
3355      * JSON-RPC method as part of EIP-191.
3356      *
3357      * See {recover}.
3358      */
3359     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
3360         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
3361     }
3362 
3363     /**
3364      * @dev Returns an Ethereum Signed Typed Data, created from a
3365      * `domainSeparator` and a `structHash`. This produces hash corresponding
3366      * to the one signed with the
3367      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
3368      * JSON-RPC method as part of EIP-712.
3369      *
3370      * See {recover}.
3371      */
3372     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
3373         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
3374     }
3375 }
3376 
3377 // File: eip712/Signer.sol
3378 
3379 //SPDX-License-Identifier: Unlicense
3380 pragma solidity ^0.8.7;
3381 
3382 
3383 
3384 contract Signer is Ownable {
3385     using ECDSA for bytes32;
3386 
3387     // The key used to sign whitelist signatures.
3388     // We will check to ensure that the key that signed the signature
3389     // is this one that we expect.
3390     address signingKey = address(0);
3391 
3392     // Domain Separator is the EIP-712 defined structure that defines what contract
3393     // and chain these signatures can be used for.  This ensures people can't take
3394     // a signature used to mint on one contract and use it for another, or a signature
3395     // from testnet to replay on mainnet.
3396     // It has to be created in the constructor so we can dynamically grab the chainId.
3397     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#definition-of-domainseparator
3398     bytes32 public DOMAIN_SEPARATOR;
3399 
3400     // The typehash for the data type specified in the structured data
3401     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#rationale-for-typehash
3402     // This should match whats in the client side whitelist signing code
3403     // https://github.com/msfeldstein/EIP712-whitelisting/blob/main/test/signWhitelist.ts#L22
3404     bytes32 public constant GIFT_TYPEHASH = keccak256("Gift(address wallet)");
3405 
3406     constructor(string memory name) {
3407         // This should match whats in the client side whitelist signing code
3408         // https://github.com/msfeldstein/EIP712-whitelisting/blob/main/test/signWhitelist.ts#L12
3409         DOMAIN_SEPARATOR = keccak256(
3410             abi.encode(
3411                 keccak256(
3412                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
3413                 ),
3414                 // This should match the domain you set in your client side signing.
3415                 keccak256(bytes(name)),
3416                 keccak256(bytes("1")),
3417                 block.chainid,
3418                 address(this)
3419             )
3420         );
3421     }
3422 
3423     function setSigningKey(address newSigningKey) public onlyOwner {
3424         signingKey = newSigningKey;
3425     }
3426 
3427     modifier requiresSignature(bytes calldata signature) {
3428         require(signingKey != address(0), "Signing not enabled");
3429         address recoveredAddress = recoverSigner(
3430             msg.sender,
3431             GIFT_TYPEHASH,
3432             signature
3433         );
3434         require(recoveredAddress == signingKey, "Invalid Signature");
3435         _;
3436     }
3437 
3438     function restorable(address sender, bytes calldata signature)
3439         public
3440         view
3441         returns (bool)
3442     {
3443         return signingKey == recoverSigner(sender, GIFT_TYPEHASH, signature);
3444     }
3445 
3446     function recoverSigner(
3447         address sender,
3448         bytes32 typehash,
3449         bytes calldata signature
3450     ) internal view returns (address) {
3451         // Verify EIP-712 signature by recreating the data structure
3452         // that we signed on the client side, and then using that to recover
3453         // the address that signed the signature for this data.
3454         bytes32 digest = keccak256(
3455             abi.encodePacked(
3456                 "\x19\x01",
3457                 DOMAIN_SEPARATOR,
3458                 keccak256(abi.encode(typehash, sender))
3459             )
3460         );
3461         // Use the recover method to see what address was used to create
3462         // the signature on this data.
3463         // Note that if the digest doesn't exactly match what was signed we'll
3464         // get a random recovered address.
3465         return digest.recover(signature);
3466     }
3467 }
3468 
3469 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3470 
3471 
3472 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
3473 
3474 pragma solidity ^0.8.0;
3475 
3476 // CAUTION
3477 // This version of SafeMath should only be used with Solidity 0.8 or later,
3478 // because it relies on the compiler's built in overflow checks.
3479 
3480 /**
3481  * @dev Wrappers over Solidity's arithmetic operations.
3482  *
3483  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
3484  * now has built in overflow checking.
3485  */
3486 library SafeMath {
3487     /**
3488      * @dev Returns the addition of two unsigned integers, with an overflow flag.
3489      *
3490      * _Available since v3.4._
3491      */
3492     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3493         unchecked {
3494             uint256 c = a + b;
3495             if (c < a) return (false, 0);
3496             return (true, c);
3497         }
3498     }
3499 
3500     /**
3501      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
3502      *
3503      * _Available since v3.4._
3504      */
3505     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3506         unchecked {
3507             if (b > a) return (false, 0);
3508             return (true, a - b);
3509         }
3510     }
3511 
3512     /**
3513      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
3514      *
3515      * _Available since v3.4._
3516      */
3517     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3518         unchecked {
3519             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
3520             // benefit is lost if 'b' is also tested.
3521             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
3522             if (a == 0) return (true, 0);
3523             uint256 c = a * b;
3524             if (c / a != b) return (false, 0);
3525             return (true, c);
3526         }
3527     }
3528 
3529     /**
3530      * @dev Returns the division of two unsigned integers, with a division by zero flag.
3531      *
3532      * _Available since v3.4._
3533      */
3534     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3535         unchecked {
3536             if (b == 0) return (false, 0);
3537             return (true, a / b);
3538         }
3539     }
3540 
3541     /**
3542      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
3543      *
3544      * _Available since v3.4._
3545      */
3546     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
3547         unchecked {
3548             if (b == 0) return (false, 0);
3549             return (true, a % b);
3550         }
3551     }
3552 
3553     /**
3554      * @dev Returns the addition of two unsigned integers, reverting on
3555      * overflow.
3556      *
3557      * Counterpart to Solidity's `+` operator.
3558      *
3559      * Requirements:
3560      *
3561      * - Addition cannot overflow.
3562      */
3563     function add(uint256 a, uint256 b) internal pure returns (uint256) {
3564         return a + b;
3565     }
3566 
3567     /**
3568      * @dev Returns the subtraction of two unsigned integers, reverting on
3569      * overflow (when the result is negative).
3570      *
3571      * Counterpart to Solidity's `-` operator.
3572      *
3573      * Requirements:
3574      *
3575      * - Subtraction cannot overflow.
3576      */
3577     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
3578         return a - b;
3579     }
3580 
3581     /**
3582      * @dev Returns the multiplication of two unsigned integers, reverting on
3583      * overflow.
3584      *
3585      * Counterpart to Solidity's `*` operator.
3586      *
3587      * Requirements:
3588      *
3589      * - Multiplication cannot overflow.
3590      */
3591     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
3592         return a * b;
3593     }
3594 
3595     /**
3596      * @dev Returns the integer division of two unsigned integers, reverting on
3597      * division by zero. The result is rounded towards zero.
3598      *
3599      * Counterpart to Solidity's `/` operator.
3600      *
3601      * Requirements:
3602      *
3603      * - The divisor cannot be zero.
3604      */
3605     function div(uint256 a, uint256 b) internal pure returns (uint256) {
3606         return a / b;
3607     }
3608 
3609     /**
3610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3611      * reverting when dividing by zero.
3612      *
3613      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3614      * opcode (which leaves remaining gas untouched) while Solidity uses an
3615      * invalid opcode to revert (consuming all remaining gas).
3616      *
3617      * Requirements:
3618      *
3619      * - The divisor cannot be zero.
3620      */
3621     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
3622         return a % b;
3623     }
3624 
3625     /**
3626      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
3627      * overflow (when the result is negative).
3628      *
3629      * CAUTION: This function is deprecated because it requires allocating memory for the error
3630      * message unnecessarily. For custom revert reasons use {trySub}.
3631      *
3632      * Counterpart to Solidity's `-` operator.
3633      *
3634      * Requirements:
3635      *
3636      * - Subtraction cannot overflow.
3637      */
3638     function sub(
3639         uint256 a,
3640         uint256 b,
3641         string memory errorMessage
3642     ) internal pure returns (uint256) {
3643         unchecked {
3644             require(b <= a, errorMessage);
3645             return a - b;
3646         }
3647     }
3648 
3649     /**
3650      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
3651      * division by zero. The result is rounded towards zero.
3652      *
3653      * Counterpart to Solidity's `/` operator. Note: this function uses a
3654      * `revert` opcode (which leaves remaining gas untouched) while Solidity
3655      * uses an invalid opcode to revert (consuming all remaining gas).
3656      *
3657      * Requirements:
3658      *
3659      * - The divisor cannot be zero.
3660      */
3661     function div(
3662         uint256 a,
3663         uint256 b,
3664         string memory errorMessage
3665     ) internal pure returns (uint256) {
3666         unchecked {
3667             require(b > 0, errorMessage);
3668             return a / b;
3669         }
3670     }
3671 
3672     /**
3673      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
3674      * reverting with custom message when dividing by zero.
3675      *
3676      * CAUTION: This function is deprecated because it requires allocating memory for the error
3677      * message unnecessarily. For custom revert reasons use {tryMod}.
3678      *
3679      * Counterpart to Solidity's `%` operator. This function uses a `revert`
3680      * opcode (which leaves remaining gas untouched) while Solidity uses an
3681      * invalid opcode to revert (consuming all remaining gas).
3682      *
3683      * Requirements:
3684      *
3685      * - The divisor cannot be zero.
3686      */
3687     function mod(
3688         uint256 a,
3689         uint256 b,
3690         string memory errorMessage
3691     ) internal pure returns (uint256) {
3692         unchecked {
3693             require(b > 0, errorMessage);
3694             return a % b;
3695         }
3696     }
3697 }
3698 
3699 // File: eip712/NativeMetaTransaction.sol
3700 
3701 
3702 
3703 pragma solidity ^0.8.0;
3704 
3705 
3706 
3707 contract NativeMetaTransaction is EIP712Base {
3708     using SafeMath for uint256;
3709     bytes32 private constant META_TRANSACTION_TYPEHASH =
3710         keccak256(
3711             bytes(
3712                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
3713             )
3714         );
3715     event MetaTransactionExecuted(
3716         address userAddress,
3717         address payable relayerAddress,
3718         bytes functionSignature
3719     );
3720     mapping(address => uint256) nonces;
3721 
3722     /*
3723      * Meta transaction structure.
3724      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
3725      * He should call the desired function directly in that case.
3726      */
3727     struct MetaTransaction {
3728         uint256 nonce;
3729         address from;
3730         bytes functionSignature;
3731     }
3732 
3733     function executeMetaTransaction(
3734         address userAddress,
3735         bytes memory functionSignature,
3736         bytes32 sigR,
3737         bytes32 sigS,
3738         uint8 sigV
3739     ) public payable returns (bytes memory) {
3740         MetaTransaction memory metaTx = MetaTransaction({
3741             nonce: nonces[userAddress],
3742             from: userAddress,
3743             functionSignature: functionSignature
3744         });
3745 
3746         require(
3747             verify(userAddress, metaTx, sigR, sigS, sigV),
3748             "Signer and signature do not match"
3749         );
3750 
3751         // increase nonce for user (to avoid re-use)
3752         nonces[userAddress] = nonces[userAddress].add(1);
3753 
3754         emit MetaTransactionExecuted(
3755             userAddress,
3756             payable(msg.sender),
3757             functionSignature
3758         );
3759 
3760         // Append userAddress and relayer address at the end to extract it from calling context
3761         (bool success, bytes memory returnData) = address(this).call(
3762             abi.encodePacked(functionSignature, userAddress)
3763         );
3764         require(success, "Function call not successful");
3765 
3766         return returnData;
3767     }
3768 
3769     function executeMetaTransactionWithExternalNonce(
3770         address userAddress,
3771         bytes memory functionSignature,
3772         bytes32 sigR,
3773         bytes32 sigS,
3774         uint8 sigV,
3775         uint256 userNonce
3776     ) public payable returns (bytes memory) {
3777         MetaTransaction memory metaTx = MetaTransaction({
3778             nonce: userNonce,
3779             from: userAddress,
3780             functionSignature: functionSignature
3781         });
3782 
3783         require(
3784             verify(userAddress, metaTx, sigR, sigS, sigV),
3785             "Signer and signature do not match"
3786         );
3787         require(userNonce == nonces[userAddress]);
3788         // increase nonce for user (to avoid re-use)
3789         nonces[userAddress] = userNonce.add(1);
3790 
3791         emit MetaTransactionExecuted(
3792             userAddress,
3793             payable(msg.sender),
3794             functionSignature
3795         );
3796 
3797         // Append userAddress and relayer address at the end to extract it from calling context
3798         (bool success, bytes memory returnData) = address(this).call(
3799             abi.encodePacked(functionSignature, userAddress)
3800         );
3801         require(success, string(returnData));
3802 
3803         return returnData;
3804     }
3805 
3806     function hashMetaTransaction(MetaTransaction memory metaTx)
3807         internal
3808         pure
3809         returns (bytes32)
3810     {
3811         return
3812             keccak256(
3813                 abi.encode(
3814                     META_TRANSACTION_TYPEHASH,
3815                     metaTx.nonce,
3816                     metaTx.from,
3817                     keccak256(metaTx.functionSignature)
3818                 )
3819             );
3820     }
3821 
3822     function getNonce(address user) public view returns (uint256 nonce) {
3823         nonce = nonces[user];
3824     }
3825 
3826     function verify(
3827         address signer,
3828         MetaTransaction memory metaTx,
3829         bytes32 sigR,
3830         bytes32 sigS,
3831         uint8 sigV
3832     ) internal view returns (bool) {
3833         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
3834         return
3835             signer ==
3836             ecrecover(
3837                 toTypedMessageHash(hashMetaTransaction(metaTx)),
3838                 sigV,
3839                 sigR,
3840                 sigS
3841             );
3842     }
3843 }
3844 
3845 // File: nft/NFTERC721A.sol
3846 
3847 
3848 pragma solidity ^0.8.7;
3849 
3850 
3851 
3852 
3853 
3854 
3855 
3856 
3857 
3858 
3859 
3860 contract NFTERC721A is
3861     ERC721A,
3862     ERC721ABurnable,
3863     ERC721AQueryable,
3864     ERC721APausable,
3865     AccessControl,
3866     Ownable,
3867     ContextMixin,
3868     NativeMetaTransaction
3869 {
3870     // Create a new role identifier for the minter role
3871     bytes32 public constant MINER_ROLE = keccak256("MINER_ROLE");
3872     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
3873     // using Counters for Counters.Counter;
3874     // Counters.Counter private currentTokenId;
3875     /// @dev Base token URI used as a prefix by tokenURI().
3876     string private baseTokenURI;
3877     string private collectionURI;
3878 
3879     // uint256 public constant TOTAL_SUPPLY = 10800;
3880 
3881     constructor() ERC721A("SONNY-BOOT", "HM-SON-BOOT") {
3882         _initializeEIP712("SONNY-BOOT");
3883         baseTokenURI = "https://cdn.nftstar.com/hm-son-boot/metadata/";
3884         collectionURI = "https://cdn.nftstar.com/hm-son-boot/meta-son-heung-min.json";
3885         // Grant the contract deployer the default admin role: it will be able to grant and revoke any roles
3886         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
3887         _setupRole(MINER_ROLE, _msgSender());
3888         _setupRole(PAUSER_ROLE, _msgSender());
3889     }
3890 
3891     // function totalSupply() public view returns (uint256) {
3892     //     return TOTAL_SUPPLY;
3893     // }
3894 
3895     // function remaining() public view returns (uint256) {
3896     //     return TOTAL_SUPPLY - _totalMinted();
3897     // }
3898 
3899     function mintTo(address to) public onlyRole(MINER_ROLE) {
3900         _mint(to, 1);
3901     }
3902 
3903     function mint(address to, uint256 quantity) public onlyRole(MINER_ROLE) {
3904         _safeMint(to, quantity);
3905     }
3906 
3907     /**
3908      * tokensOfOwner
3909      */
3910     // function ownerTokens(address owner) public view returns (uint256[] memory) {
3911     //     return tokensOfOwner(owner);
3912     // }
3913 
3914     /**
3915      * @dev Pauses all token transfers.
3916      *
3917      * See {ERC721Pausable} and {Pausable-_pause}.
3918      *
3919      * Requirements:
3920      *
3921      * - the caller must have the `PAUSER_ROLE`.
3922      */
3923     function pause() public virtual {
3924         require(
3925             hasRole(PAUSER_ROLE, _msgSender()),
3926             "NFT: must have pauser role to pause"
3927         );
3928         _pause();
3929     }
3930 
3931     /**
3932      * @dev Unpauses all token transfers.
3933      *
3934      * See {ERC721Pausable} and {Pausable-_unpause}.
3935      *
3936      * Requirements:
3937      *
3938      * - the caller must have the `PAUSER_ROLE`.
3939      */
3940     function unpause() public virtual {
3941         require(
3942             hasRole(PAUSER_ROLE, _msgSender()),
3943             "NFT: must have pauser role to unpause"
3944         );
3945         _unpause();
3946     }
3947 
3948     function current() public view returns (uint256) {
3949         return _totalMinted();
3950     }
3951 
3952     function _startTokenId() internal pure override returns (uint256) {
3953         return 1;
3954     }
3955 
3956     function contractURI() public view returns (string memory) {
3957         return collectionURI;
3958     }
3959 
3960     function setContractURI(string memory _contractURI) public onlyOwner {
3961         collectionURI = _contractURI;
3962     }
3963 
3964     /// @dev Returns an URI for a given token ID
3965     function _baseURI() internal view virtual override returns (string memory) {
3966         return baseTokenURI;
3967     }
3968 
3969     /// @dev Sets the base token URI prefix.
3970     function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
3971         baseTokenURI = _baseTokenURI;
3972     }
3973 
3974     function transferRoleAdmin(address newDefaultAdmin)
3975         external
3976         onlyRole(DEFAULT_ADMIN_ROLE)
3977     {
3978         _setupRole(DEFAULT_ADMIN_ROLE, newDefaultAdmin);
3979     }
3980 
3981     /**
3982      * @dev See {IERC165-supportsInterface}.
3983      */
3984     function supportsInterface(bytes4 interfaceId)
3985         public
3986         view
3987         virtual
3988         override(AccessControl, ERC721A)
3989         returns (bool)
3990     {
3991         return
3992             super.supportsInterface(interfaceId) ||
3993             ERC721A.supportsInterface(interfaceId);
3994     }
3995 
3996     function _beforeTokenTransfers(
3997         address from,
3998         address to,
3999         uint256 startTokenId,
4000         uint256 quantity
4001     ) internal virtual override(ERC721A, ERC721APausable) {
4002         super._beforeTokenTransfers(from, to, startTokenId, quantity);
4003     }
4004 
4005     function _msgSender()
4006         internal
4007         view
4008         virtual
4009         override
4010         returns (address sender)
4011     {
4012         return ContextMixin.msgSender();
4013     }
4014 
4015     function _msgSenderERC721A()
4016         internal
4017         view
4018         virtual
4019         override
4020         returns (address sender)
4021     {
4022         return ContextMixin.msgSender();
4023     }
4024 }
4025 
4026 // File: Crowdsale.sol
4027 
4028 
4029 pragma solidity ^0.8.7;
4030 
4031 
4032 
4033 
4034 contract Crowdsale is Signer {
4035     using SafeMath for uint256;
4036 
4037     NFTERC721A public token;
4038     bool public opening; // crowdsale opening status
4039     uint256 public TOTAL_SUPPLY = 777;
4040 
4041     mapping(address => bool) free;
4042 
4043     event FreeMintingStarted(bool opening);
4044 
4045     constructor() Signer("SONNY-BOOT") {}
4046 
4047     function mint(bytes calldata signature)
4048         external
4049         requiresSignature(signature)
4050     {
4051         require(opening, "Free mining has not yet begun");
4052         address miner = msg.sender;
4053         require(!free[miner], "Already mined");
4054         require(token.current() < TOTAL_SUPPLY, "Exceeded maximum supply");
4055         free[miner] = true;
4056         token.mint(miner, 1);
4057     }
4058 
4059     function mined(address _account) public view returns (bool) {
4060         return free[_account];
4061     }
4062 
4063     function setNft(address _nft) external onlyOwner {
4064         require(_nft != address(0), "Invalid address");
4065         token = NFTERC721A(_nft);
4066     }
4067 
4068     function setTotalSupply(uint256 _totalSupply) external onlyOwner {
4069         if (_totalSupply <= 0) {
4070             revert();
4071         }
4072         TOTAL_SUPPLY = _totalSupply;
4073     }
4074 
4075     function setOpening(bool _opening) external onlyOwner {
4076         opening = _opening;
4077         emit FreeMintingStarted(opening);
4078     }
4079 
4080     function remaining() external view returns (uint256) {
4081         return TOTAL_SUPPLY - token.current();
4082     }
4083 }