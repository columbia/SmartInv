1 // File: Cryptotz_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: erc721a/contracts/IERC721A.sol
180 
181 
182 // ERC721A Contracts v4.0.0
183 // Creator: Chiru Labs
184 
185 pragma solidity ^0.8.4;
186 
187 /**
188  * @dev Interface of an ERC721A compliant contract.
189  */
190 interface IERC721A {
191     /**
192      * The caller must own the token or be an approved operator.
193      */
194     error ApprovalCallerNotOwnerNorApproved();
195 
196     /**
197      * The token does not exist.
198      */
199     error ApprovalQueryForNonexistentToken();
200 
201     /**
202      * The caller cannot approve to their own address.
203      */
204     error ApproveToCaller();
205 
206     /**
207      * The caller cannot approve to the current owner.
208      */
209     error ApprovalToCurrentOwner();
210 
211     /**
212      * Cannot query the balance for the zero address.
213      */
214     error BalanceQueryForZeroAddress();
215 
216     /**
217      * Cannot mint to the zero address.
218      */
219     error MintToZeroAddress();
220 
221     /**
222      * The quantity of tokens minted must be more than zero.
223      */
224     error MintZeroQuantity();
225 
226     /**
227      * The token does not exist.
228      */
229     error OwnerQueryForNonexistentToken();
230 
231     /**
232      * The caller must own the token or be an approved operator.
233      */
234     error TransferCallerNotOwnerNorApproved();
235 
236     /**
237      * The token must be owned by `from`.
238      */
239     error TransferFromIncorrectOwner();
240 
241     /**
242      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
243      */
244     error TransferToNonERC721ReceiverImplementer();
245 
246     /**
247      * Cannot transfer to the zero address.
248      */
249     error TransferToZeroAddress();
250 
251     /**
252      * The token does not exist.
253      */
254     error URIQueryForNonexistentToken();
255 
256     struct TokenOwnership {
257         // The address of the owner.
258         address addr;
259         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
260         uint64 startTimestamp;
261         // Whether the token has been burned.
262         bool burned;
263     }
264 
265     /**
266      * @dev Returns the total amount of tokens stored by the contract.
267      *
268      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
269      */
270     function totalSupply() external view returns (uint256);
271 
272     // ==============================
273     //            IERC165
274     // ==============================
275 
276     /**
277      * @dev Returns true if this contract implements the interface defined by
278      * `interfaceId`. See the corresponding
279      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
280      * to learn more about how these ids are created.
281      *
282      * This function call must use less than 30 000 gas.
283      */
284     function supportsInterface(bytes4 interfaceId) external view returns (bool);
285 
286     // ==============================
287     //            IERC721
288     // ==============================
289 
290     /**
291      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
292      */
293     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
294 
295     /**
296      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
297      */
298     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
299 
300     /**
301      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
302      */
303     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
304 
305     /**
306      * @dev Returns the number of tokens in ``owner``'s account.
307      */
308     function balanceOf(address owner) external view returns (uint256 balance);
309 
310     /**
311      * @dev Returns the owner of the `tokenId` token.
312      *
313      * Requirements:
314      *
315      * - `tokenId` must exist.
316      */
317     function ownerOf(uint256 tokenId) external view returns (address owner);
318 
319     /**
320      * @dev Safely transfers `tokenId` token from `from` to `to`.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId,
336         bytes calldata data
337     ) external;
338 
339     /**
340      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
341      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must exist and be owned by `from`.
348      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
350      *
351      * Emits a {Transfer} event.
352      */
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId
357     ) external;
358 
359     /**
360      * @dev Transfers `tokenId` token from `from` to `to`.
361      *
362      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `tokenId` token must be owned by `from`.
369      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transferFrom(
374         address from,
375         address to,
376         uint256 tokenId
377     ) external;
378 
379     /**
380      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
381      * The approval is cleared when the token is transferred.
382      *
383      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
384      *
385      * Requirements:
386      *
387      * - The caller must own the token or be an approved operator.
388      * - `tokenId` must exist.
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address to, uint256 tokenId) external;
393 
394     /**
395      * @dev Approve or remove `operator` as an operator for the caller.
396      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
397      *
398      * Requirements:
399      *
400      * - The `operator` cannot be the caller.
401      *
402      * Emits an {ApprovalForAll} event.
403      */
404     function setApprovalForAll(address operator, bool _approved) external;
405 
406     /**
407      * @dev Returns the account approved for `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function getApproved(uint256 tokenId) external view returns (address operator);
414 
415     /**
416      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
417      *
418      * See {setApprovalForAll}
419      */
420     function isApprovedForAll(address owner, address operator) external view returns (bool);
421 
422     // ==============================
423     //        IERC721Metadata
424     // ==============================
425 
426     /**
427      * @dev Returns the token collection name.
428      */
429     function name() external view returns (string memory);
430 
431     /**
432      * @dev Returns the token collection symbol.
433      */
434     function symbol() external view returns (string memory);
435 
436     /**
437      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
438      */
439     function tokenURI(uint256 tokenId) external view returns (string memory);
440 }
441 
442 // File: erc721a/contracts/ERC721A.sol
443 
444 
445 // ERC721A Contracts v4.0.0
446 // Creator: Chiru Labs
447 
448 pragma solidity ^0.8.4;
449 
450 
451 /**
452  * @dev ERC721 token receiver interface.
453  */
454 interface ERC721A__IERC721Receiver {
455     function onERC721Received(
456         address operator,
457         address from,
458         uint256 tokenId,
459         bytes calldata data
460     ) external returns (bytes4);
461 }
462 
463 /**
464  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
465  * the Metadata extension. Built to optimize for lower gas during batch mints.
466  *
467  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
468  *
469  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
470  *
471  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
472  */
473 contract ERC721A is IERC721A {
474     // Mask of an entry in packed address data.
475     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
476 
477     // The bit position of `numberMinted` in packed address data.
478     uint256 private constant BITPOS_NUMBER_MINTED = 64;
479 
480     // The bit position of `numberBurned` in packed address data.
481     uint256 private constant BITPOS_NUMBER_BURNED = 128;
482 
483     // The bit position of `aux` in packed address data.
484     uint256 private constant BITPOS_AUX = 192;
485 
486     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
487     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
488 
489     // The bit position of `startTimestamp` in packed ownership.
490     uint256 private constant BITPOS_START_TIMESTAMP = 160;
491 
492     // The bit mask of the `burned` bit in packed ownership.
493     uint256 private constant BITMASK_BURNED = 1 << 224;
494     
495     // The bit position of the `nextInitialized` bit in packed ownership.
496     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
497 
498     // The bit mask of the `nextInitialized` bit in packed ownership.
499     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
500 
501     // The tokenId of the next token to be minted.
502     uint256 private _currentIndex;
503 
504     // The number of tokens burned.
505     uint256 private _burnCounter;
506 
507     // Token name
508     string private _name;
509 
510     // Token symbol
511     string private _symbol;
512 
513     // Mapping from token ID to ownership details
514     // An empty struct value does not necessarily mean the token is unowned.
515     // See `_packedOwnershipOf` implementation for details.
516     //
517     // Bits Layout:
518     // - [0..159]   `addr`
519     // - [160..223] `startTimestamp`
520     // - [224]      `burned`
521     // - [225]      `nextInitialized`
522     mapping(uint256 => uint256) private _packedOwnerships;
523 
524     // Mapping owner address to address data.
525     //
526     // Bits Layout:
527     // - [0..63]    `balance`
528     // - [64..127]  `numberMinted`
529     // - [128..191] `numberBurned`
530     // - [192..255] `aux`
531     mapping(address => uint256) private _packedAddressData;
532 
533     // Mapping from token ID to approved address.
534     mapping(uint256 => address) private _tokenApprovals;
535 
536     // Mapping from owner to operator approvals
537     mapping(address => mapping(address => bool)) private _operatorApprovals;
538 
539     constructor(string memory name_, string memory symbol_) {
540         _name = name_;
541         _symbol = symbol_;
542         _currentIndex = _startTokenId();
543     }
544 
545     /**
546      * @dev Returns the starting token ID. 
547      * To change the starting token ID, please override this function.
548      */
549     function _startTokenId() internal view virtual returns (uint256) {
550         return 0;
551     }
552 
553     /**
554      * @dev Returns the next token ID to be minted.
555      */
556     function _nextTokenId() internal view returns (uint256) {
557         return _currentIndex;
558     }
559 
560     /**
561      * @dev Returns the total number of tokens in existence.
562      * Burned tokens will reduce the count. 
563      * To get the total number of tokens minted, please see `_totalMinted`.
564      */
565     function totalSupply() public view override returns (uint256) {
566         // Counter underflow is impossible as _burnCounter cannot be incremented
567         // more than `_currentIndex - _startTokenId()` times.
568         unchecked {
569             return _currentIndex - _burnCounter - _startTokenId();
570         }
571     }
572 
573     /**
574      * @dev Returns the total amount of tokens minted in the contract.
575      */
576     function _totalMinted() internal view returns (uint256) {
577         // Counter underflow is impossible as _currentIndex does not decrement,
578         // and it is initialized to `_startTokenId()`
579         unchecked {
580             return _currentIndex - _startTokenId();
581         }
582     }
583 
584     /**
585      * @dev Returns the total number of tokens burned.
586      */
587     function _totalBurned() internal view returns (uint256) {
588         return _burnCounter;
589     }
590 
591     /**
592      * @dev See {IERC165-supportsInterface}.
593      */
594     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595         // The interface IDs are constants representing the first 4 bytes of the XOR of
596         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
597         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
598         return
599             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
600             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
601             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
602     }
603 
604     /**
605      * @dev See {IERC721-balanceOf}.
606      */
607     function balanceOf(address owner) public view override returns (uint256) {
608         if (owner == address(0)) revert BalanceQueryForZeroAddress();
609         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     /**
613      * Returns the number of tokens minted by `owner`.
614      */
615     function _numberMinted(address owner) internal view returns (uint256) {
616         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the number of tokens burned by or on behalf of `owner`.
621      */
622     function _numberBurned(address owner) internal view returns (uint256) {
623         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
624     }
625 
626     /**
627      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
628      */
629     function _getAux(address owner) internal view returns (uint64) {
630         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
631     }
632 
633     /**
634      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
635      * If there are multiple variables, please pack them into a uint64.
636      */
637     function _setAux(address owner, uint64 aux) internal {
638         uint256 packed = _packedAddressData[owner];
639         uint256 auxCasted;
640         assembly { // Cast aux without masking.
641             auxCasted := aux
642         }
643         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
644         _packedAddressData[owner] = packed;
645     }
646 
647     /**
648      * Returns the packed ownership data of `tokenId`.
649      */
650     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
651         uint256 curr = tokenId;
652 
653         unchecked {
654             if (_startTokenId() <= curr)
655                 if (curr < _currentIndex) {
656                     uint256 packed = _packedOwnerships[curr];
657                     // If not burned.
658                     if (packed & BITMASK_BURNED == 0) {
659                         // Invariant:
660                         // There will always be an ownership that has an address and is not burned
661                         // before an ownership that does not have an address and is not burned.
662                         // Hence, curr will not underflow.
663                         //
664                         // We can directly compare the packed value.
665                         // If the address is zero, packed is zero.
666                         while (packed == 0) {
667                             packed = _packedOwnerships[--curr];
668                         }
669                         return packed;
670                     }
671                 }
672         }
673         revert OwnerQueryForNonexistentToken();
674     }
675 
676     /**
677      * Returns the unpacked `TokenOwnership` struct from `packed`.
678      */
679     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
680         ownership.addr = address(uint160(packed));
681         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
682         ownership.burned = packed & BITMASK_BURNED != 0;
683     }
684 
685     /**
686      * Returns the unpacked `TokenOwnership` struct at `index`.
687      */
688     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
689         return _unpackedOwnership(_packedOwnerships[index]);
690     }
691 
692     /**
693      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
694      */
695     function _initializeOwnershipAt(uint256 index) internal {
696         if (_packedOwnerships[index] == 0) {
697             _packedOwnerships[index] = _packedOwnershipOf(index);
698         }
699     }
700 
701     /**
702      * Gas spent here starts off proportional to the maximum mint batch size.
703      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
704      */
705     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
706         return _unpackedOwnership(_packedOwnershipOf(tokenId));
707     }
708 
709     /**
710      * @dev See {IERC721-ownerOf}.
711      */
712     function ownerOf(uint256 tokenId) public view override returns (address) {
713         return address(uint160(_packedOwnershipOf(tokenId)));
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-name}.
718      */
719     function name() public view virtual override returns (string memory) {
720         return _name;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-symbol}.
725      */
726     function symbol() public view virtual override returns (string memory) {
727         return _symbol;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-tokenURI}.
732      */
733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
734         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
735 
736         string memory baseURI = _baseURI();
737         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
738     }
739 
740     /**
741      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
742      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
743      * by default, can be overriden in child contracts.
744      */
745     function _baseURI() internal view virtual returns (string memory) {
746         return '';
747     }
748 
749     /**
750      * @dev Casts the address to uint256 without masking.
751      */
752     function _addressToUint256(address value) private pure returns (uint256 result) {
753         assembly {
754             result := value
755         }
756     }
757 
758     /**
759      * @dev Casts the boolean to uint256 without branching.
760      */
761     function _boolToUint256(bool value) private pure returns (uint256 result) {
762         assembly {
763             result := value
764         }
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public override {
771         address owner = address(uint160(_packedOwnershipOf(tokenId)));
772         if (to == owner) revert ApprovalToCurrentOwner();
773 
774         if (_msgSenderERC721A() != owner)
775             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
776                 revert ApprovalCallerNotOwnerNorApproved();
777             }
778 
779         _tokenApprovals[tokenId] = to;
780         emit Approval(owner, to, tokenId);
781     }
782 
783     /**
784      * @dev See {IERC721-getApproved}.
785      */
786     function getApproved(uint256 tokenId) public view override returns (address) {
787         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved) public virtual override {
796         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
797 
798         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
799         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
800     }
801 
802     /**
803      * @dev See {IERC721-isApprovedForAll}.
804      */
805     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
806         return _operatorApprovals[owner][operator];
807     }
808 
809     /**
810      * @dev See {IERC721-transferFrom}.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) public virtual override {
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, '');
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         _transfer(from, to, tokenId);
841         if (to.code.length != 0)
842             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
843                 revert TransferToNonERC721ReceiverImplementer();
844             }
845     }
846 
847     /**
848      * @dev Returns whether `tokenId` exists.
849      *
850      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
851      *
852      * Tokens start existing when they are minted (`_mint`),
853      */
854     function _exists(uint256 tokenId) internal view returns (bool) {
855         return
856             _startTokenId() <= tokenId &&
857             tokenId < _currentIndex && // If within bounds,
858             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
859     }
860 
861     /**
862      * @dev Equivalent to `_safeMint(to, quantity, '')`.
863      */
864     function _safeMint(address to, uint256 quantity) internal {
865         _safeMint(to, quantity, '');
866     }
867 
868     /**
869      * @dev Safely mints `quantity` tokens and transfers them to `to`.
870      *
871      * Requirements:
872      *
873      * - If `to` refers to a smart contract, it must implement
874      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
875      * - `quantity` must be greater than 0.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _safeMint(
880         address to,
881         uint256 quantity,
882         bytes memory _data
883     ) internal {
884         uint256 startTokenId = _currentIndex;
885         if (to == address(0)) revert MintToZeroAddress();
886         if (quantity == 0) revert MintZeroQuantity();
887 
888         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
889 
890         // Overflows are incredibly unrealistic.
891         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
892         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
893         unchecked {
894             // Updates:
895             // - `balance += quantity`.
896             // - `numberMinted += quantity`.
897             //
898             // We can directly add to the balance and number minted.
899             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
900 
901             // Updates:
902             // - `address` to the owner.
903             // - `startTimestamp` to the timestamp of minting.
904             // - `burned` to `false`.
905             // - `nextInitialized` to `quantity == 1`.
906             _packedOwnerships[startTokenId] =
907                 _addressToUint256(to) |
908                 (block.timestamp << BITPOS_START_TIMESTAMP) |
909                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
910 
911             uint256 updatedIndex = startTokenId;
912             uint256 end = updatedIndex + quantity;
913 
914             if (to.code.length != 0) {
915                 do {
916                     emit Transfer(address(0), to, updatedIndex);
917                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
918                         revert TransferToNonERC721ReceiverImplementer();
919                     }
920                 } while (updatedIndex < end);
921                 // Reentrancy protection
922                 if (_currentIndex != startTokenId) revert();
923             } else {
924                 do {
925                     emit Transfer(address(0), to, updatedIndex++);
926                 } while (updatedIndex < end);
927             }
928             _currentIndex = updatedIndex;
929         }
930         _afterTokenTransfers(address(0), to, startTokenId, quantity);
931     }
932 
933     /**
934      * @dev Mints `quantity` tokens and transfers them to `to`.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - `quantity` must be greater than 0.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _mint(address to, uint256 quantity) internal {
944         uint256 startTokenId = _currentIndex;
945         if (to == address(0)) revert MintToZeroAddress();
946         if (quantity == 0) revert MintZeroQuantity();
947 
948         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
949 
950         // Overflows are incredibly unrealistic.
951         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
952         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
953         unchecked {
954             // Updates:
955             // - `balance += quantity`.
956             // - `numberMinted += quantity`.
957             //
958             // We can directly add to the balance and number minted.
959             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
960 
961             // Updates:
962             // - `address` to the owner.
963             // - `startTimestamp` to the timestamp of minting.
964             // - `burned` to `false`.
965             // - `nextInitialized` to `quantity == 1`.
966             _packedOwnerships[startTokenId] =
967                 _addressToUint256(to) |
968                 (block.timestamp << BITPOS_START_TIMESTAMP) |
969                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
970 
971             uint256 updatedIndex = startTokenId;
972             uint256 end = updatedIndex + quantity;
973 
974             do {
975                 emit Transfer(address(0), to, updatedIndex++);
976             } while (updatedIndex < end);
977 
978             _currentIndex = updatedIndex;
979         }
980         _afterTokenTransfers(address(0), to, startTokenId, quantity);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) private {
998         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
999 
1000         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1001 
1002         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1003             isApprovedForAll(from, _msgSenderERC721A()) ||
1004             getApproved(tokenId) == _msgSenderERC721A());
1005 
1006         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         if (to == address(0)) revert TransferToZeroAddress();
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner.
1012         delete _tokenApprovals[tokenId];
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             // We can directly increment and decrement the balances.
1019             --_packedAddressData[from]; // Updates: `balance -= 1`.
1020             ++_packedAddressData[to]; // Updates: `balance += 1`.
1021 
1022             // Updates:
1023             // - `address` to the next owner.
1024             // - `startTimestamp` to the timestamp of transfering.
1025             // - `burned` to `false`.
1026             // - `nextInitialized` to `true`.
1027             _packedOwnerships[tokenId] =
1028                 _addressToUint256(to) |
1029                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1030                 BITMASK_NEXT_INITIALIZED;
1031 
1032             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1033             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1034                 uint256 nextTokenId = tokenId + 1;
1035                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1036                 if (_packedOwnerships[nextTokenId] == 0) {
1037                     // If the next slot is within bounds.
1038                     if (nextTokenId != _currentIndex) {
1039                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1040                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1041                     }
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047         _afterTokenTransfers(from, to, tokenId, 1);
1048     }
1049 
1050     /**
1051      * @dev Equivalent to `_burn(tokenId, false)`.
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         _burn(tokenId, false);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1068         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1069 
1070         address from = address(uint160(prevOwnershipPacked));
1071 
1072         if (approvalCheck) {
1073             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1074                 isApprovedForAll(from, _msgSenderERC721A()) ||
1075                 getApproved(tokenId) == _msgSenderERC721A());
1076 
1077             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         }
1079 
1080         _beforeTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         // Clear approvals from the previous owner.
1083         delete _tokenApprovals[tokenId];
1084 
1085         // Underflow of the sender's balance is impossible because we check for
1086         // ownership above and the recipient's balance can't realistically overflow.
1087         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1088         unchecked {
1089             // Updates:
1090             // - `balance -= 1`.
1091             // - `numberBurned += 1`.
1092             //
1093             // We can directly decrement the balance, and increment the number burned.
1094             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1095             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1096 
1097             // Updates:
1098             // - `address` to the last owner.
1099             // - `startTimestamp` to the timestamp of burning.
1100             // - `burned` to `true`.
1101             // - `nextInitialized` to `true`.
1102             _packedOwnerships[tokenId] =
1103                 _addressToUint256(from) |
1104                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1105                 BITMASK_BURNED | 
1106                 BITMASK_NEXT_INITIALIZED;
1107 
1108             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1109             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1110                 uint256 nextTokenId = tokenId + 1;
1111                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1112                 if (_packedOwnerships[nextTokenId] == 0) {
1113                     // If the next slot is within bounds.
1114                     if (nextTokenId != _currentIndex) {
1115                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1116                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1117                     }
1118                 }
1119             }
1120         }
1121 
1122         emit Transfer(from, address(0), tokenId);
1123         _afterTokenTransfers(from, address(0), tokenId, 1);
1124 
1125         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1126         unchecked {
1127             _burnCounter++;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkContractOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1147             bytes4 retval
1148         ) {
1149             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1150         } catch (bytes memory reason) {
1151             if (reason.length == 0) {
1152                 revert TransferToNonERC721ReceiverImplementer();
1153             } else {
1154                 assembly {
1155                     revert(add(32, reason), mload(reason))
1156                 }
1157             }
1158         }
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1163      * And also called before burning one token.
1164      *
1165      * startTokenId - the first token id to be transferred
1166      * quantity - the amount to be transferred
1167      *
1168      * Calling conditions:
1169      *
1170      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1171      * transferred to `to`.
1172      * - When `from` is zero, `tokenId` will be minted for `to`.
1173      * - When `to` is zero, `tokenId` will be burned by `from`.
1174      * - `from` and `to` are never both zero.
1175      */
1176     function _beforeTokenTransfers(
1177         address from,
1178         address to,
1179         uint256 startTokenId,
1180         uint256 quantity
1181     ) internal virtual {}
1182 
1183     /**
1184      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1185      * minting.
1186      * And also called after one token has been burned.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` has been minted for `to`.
1196      * - When `to` is zero, `tokenId` has been burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _afterTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Returns the message sender (defaults to `msg.sender`).
1208      *
1209      * If you are writing GSN compatible contracts, you need to override this function.
1210      */
1211     function _msgSenderERC721A() internal view virtual returns (address) {
1212         return msg.sender;
1213     }
1214 
1215     /**
1216      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1217      */
1218     function _toString(uint256 value) internal pure returns (string memory ptr) {
1219         assembly {
1220             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1221             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1222             // We will need 1 32-byte word to store the length, 
1223             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1224             ptr := add(mload(0x40), 128)
1225             // Update the free memory pointer to allocate.
1226             mstore(0x40, ptr)
1227 
1228             // Cache the end of the memory to calculate the length later.
1229             let end := ptr
1230 
1231             // We write the string from the rightmost digit to the leftmost digit.
1232             // The following is essentially a do-while loop that also handles the zero case.
1233             // Costs a bit more than early returning for the zero case,
1234             // but cheaper in terms of deployment and overall runtime costs.
1235             for { 
1236                 // Initialize and perform the first pass without check.
1237                 let temp := value
1238                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1239                 ptr := sub(ptr, 1)
1240                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1241                 mstore8(ptr, add(48, mod(temp, 10)))
1242                 temp := div(temp, 10)
1243             } temp { 
1244                 // Keep dividing `temp` until zero.
1245                 temp := div(temp, 10)
1246             } { // Body of the for loop.
1247                 ptr := sub(ptr, 1)
1248                 mstore8(ptr, add(48, mod(temp, 10)))
1249             }
1250             
1251             let length := sub(end, ptr)
1252             // Move the pointer 32 bytes leftwards to make room for the length.
1253             ptr := sub(ptr, 32)
1254             // Store the length.
1255             mstore(ptr, length)
1256         }
1257     }
1258 }
1259 
1260 // File: contracts/Cryptotz.sol
1261 
1262 //SPDX-License-Identifier: MIT
1263 pragma solidity ^0.8.4;
1264 
1265 
1266 
1267 
1268 
1269 
1270 contract Cryptotz is Ownable, ERC721A {
1271     uint256 constant public MAX_SUPPLY = 4200;
1272     
1273 
1274     uint256 public publicPrice = 0.005 ether;
1275 
1276     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 5;
1277     uint256 constant public PUBLIC_MINT_LIMIT = 15;
1278 
1279     uint256 public TOTAL_SUPPLY_TEAM;
1280 
1281     string public revealedURI;
1282     
1283     string public hiddenURI;
1284 
1285     bool public paused = false;
1286     bool public revealed = false;
1287 
1288     bool public freeSale = true;
1289     bool public publicSale = false;
1290 
1291     
1292     address constant internal DEV_ADDRESS = 0x2E6802F84a530f60B0B4299E4A658b90C37e8E6c;
1293     
1294     
1295 
1296     mapping(address => bool) public userMintedFree;
1297     mapping(address => uint256) public numUserMints;
1298 
1299     constructor(string memory name, string memory _symbol, string memory _initbaseuri, string memory _hiddenMetadataUri) ERC721A("Cryptotz", "CRTZ") { }
1300 
1301     
1302 
1303     // This function is if you want to override the first Token ID# for ERC721A
1304     // Note: Fun fact - by overloading this method you save a small amount of gas for minting (technically just the first mint)
1305     function _startTokenId() internal view virtual override returns (uint256) {
1306         return 1;
1307     }
1308 
1309     function refundOverpay(uint256 price) private {
1310         if (msg.value > price) {
1311             (bool succ, ) = payable(msg.sender).call{
1312                 value: (msg.value - price)
1313             }("");
1314             require(succ, "Transfer failed");
1315         }
1316         else if (msg.value < price) {
1317             revert("Not enough ETH sent");
1318         }
1319     }
1320 
1321     
1322     
1323     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1324         require(freeSale, "Free sale inactive");
1325         require(msg.value == 0, "This phase is free");
1326         require(quantity == 3, "Only 3 free");
1327 
1328         uint256 newSupply = totalSupply() + quantity;
1329         
1330         require(newSupply <= 1500, "Not enough free supply");
1331 
1332         require(!userMintedFree[msg.sender], "User max free limit");
1333         
1334         userMintedFree[msg.sender] = true;
1335 
1336         if(newSupply == 1500) {
1337             freeSale = false;
1338             publicSale = true;
1339         }
1340 
1341         _safeMint(msg.sender, quantity);
1342     }
1343 
1344     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1345         require(publicSale, "Public sale inactive");
1346         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1347 
1348         uint256 price = publicPrice;
1349         uint256 currMints = numUserMints[msg.sender];
1350                 
1351         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1352         
1353         refundOverpay(price * quantity);
1354 
1355         numUserMints[msg.sender] = (currMints + quantity);
1356 
1357         _safeMint(msg.sender, quantity);
1358     }
1359 
1360    
1361 
1362     // Note: walletOfOwner is only really necessary for enumerability when staking/using on websites etc.
1363         // That said, it's a public view so we can keep it in.
1364         // This could also be optimized if someone REALLY wanted, but it's just a public view.
1365         // Check the pinned tweets of 0xInuarashi for more ideas on this method!
1366         // For now, this is just the version that existed in v1.
1367     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1368     {
1369         uint256 ownerTokenCount = balanceOf(_owner);
1370         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1371         uint256 currentTokenId = 1;
1372         uint256 ownedTokenIndex = 0;
1373 
1374         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1375             address currentTokenOwner = ownerOf(currentTokenId);
1376 
1377             if (currentTokenOwner == _owner) {
1378                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1379 
1380                 ownedTokenIndex++;
1381             }
1382 
1383         currentTokenId++;
1384         }
1385 
1386         return ownedTokenIds;
1387     }
1388 
1389     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1390         // Note: You don't REALLY need this require statement since nothing should be querying for non-existing tokens after reveal.
1391             // That said, it's a public view method so gas efficiency shouldn't come into play.
1392         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1393         
1394         if (revealed) {
1395             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1396         }
1397         else {
1398             return hiddenURI;
1399         }
1400     }
1401 
1402     // https://docs.opensea.io/docs/contract-level-metadata
1403     // https://ethereum.stackexchange.com/questions/110924/how-to-properly-implement-a-contracturi-for-on-chain-nfts
1404     
1405 
1406 
1407 
1408     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1409         publicPrice = _publicPrice;
1410     }
1411 
1412     function setBaseURI(string memory _baseUri) public onlyOwner {
1413         revealedURI = _baseUri;
1414     }
1415 
1416     // Note: This method can be hidden/removed if this is a constant.
1417     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1418         hiddenURI = _hiddenMetadataUri;
1419     }
1420 
1421     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1422         revealed = _revealed;
1423         revealedURI = _baseUri;
1424     }
1425 
1426     
1427 
1428     // Note: Another option is to inherit Pausable without implementing the logic yourself.
1429        
1430     function setPaused(bool _state) public onlyOwner {
1431         paused = _state;
1432     }
1433 
1434     function setRevealed(bool _state) public onlyOwner {
1435         revealed = _state;
1436     }
1437 
1438     function setPublicEnabled(bool _state) public onlyOwner {
1439         publicSale = _state;
1440         freeSale = !_state;
1441     }
1442     function setFreeEnabled(bool _state) public onlyOwner {
1443         freeSale = _state;
1444         publicSale = !_state;
1445     }
1446 
1447     function withdraw() external payable onlyOwner {
1448         // Get the current funds to calculate initial percentages
1449         uint256 currBalance = address(this).balance;
1450 
1451         (bool succ, ) = payable(DEV_ADDRESS).call{
1452             value: (currBalance * 10000) / 10000
1453         }("0x2E6802F84a530f60B0B4299E4A658b90C37e8E6c");
1454         require(succ, "Dev transfer failed");
1455     }
1456 
1457     // Owner-only mint functionality to "Airdrop" mints to specific users
1458         // Note: These will likely end up hidden on OpenSea
1459     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1460         _safeMint(receiver, quantity);
1461     }
1462 
1463    
1464 
1465     modifier mintCompliance(uint256 quantity) {
1466         require(!paused, "Contract is paused");
1467         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1468         require(tx.origin == msg.sender, "No contract minting");
1469         _;
1470     }
1471 }