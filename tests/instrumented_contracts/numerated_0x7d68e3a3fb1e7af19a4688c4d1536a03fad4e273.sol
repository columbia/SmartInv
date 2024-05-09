1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Base64.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Base64.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides a set of functions to operate with Base64 strings.
80  *
81  * _Available since v4.5._
82  */
83 library Base64 {
84     /**
85      * @dev Base64 Encoding/Decoding Table
86      */
87     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
88 
89     /**
90      * @dev Converts a `bytes` to its Bytes64 `string` representation.
91      */
92     function encode(bytes memory data) internal pure returns (string memory) {
93         /**
94          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
95          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
96          */
97         if (data.length == 0) return "";
98 
99         // Loads the table into memory
100         string memory table = _TABLE;
101 
102         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
103         // and split into 4 numbers of 6 bits.
104         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
105         // - `data.length + 2`  -> Round up
106         // - `/ 3`              -> Number of 3-bytes chunks
107         // - `4 *`              -> 4 characters for each chunk
108         string memory result = new string(4 * ((data.length + 2) / 3));
109 
110         assembly {
111             // Prepare the lookup table (skip the first "length" byte)
112             let tablePtr := add(table, 1)
113 
114             // Prepare result pointer, jump over length
115             let resultPtr := add(result, 32)
116 
117             // Run over the input, 3 bytes at a time
118             for {
119                 let dataPtr := data
120                 let endPtr := add(data, mload(data))
121             } lt(dataPtr, endPtr) {
122 
123             } {
124                 // Advance 3 bytes
125                 dataPtr := add(dataPtr, 3)
126                 let input := mload(dataPtr)
127 
128                 // To write each character, shift the 3 bytes (18 bits) chunk
129                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
130                 // and apply logical AND with 0x3F which is the number of
131                 // the previous character in the ASCII table prior to the Base64 Table
132                 // The result is then added to the table to get the character to write,
133                 // and finally write it in the result pointer but with a left shift
134                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
135 
136                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
137                 resultPtr := add(resultPtr, 1) // Advance
138 
139                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
140                 resultPtr := add(resultPtr, 1) // Advance
141 
142                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
143                 resultPtr := add(resultPtr, 1) // Advance
144 
145                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
146                 resultPtr := add(resultPtr, 1) // Advance
147             }
148 
149             // When data `bytes` is not exactly 3 bytes long
150             // it is padded with `=` characters at the end
151             switch mod(mload(data), 3)
152             case 1 {
153                 mstore8(sub(resultPtr, 1), 0x3d)
154                 mstore8(sub(resultPtr, 2), 0x3d)
155             }
156             case 2 {
157                 mstore8(sub(resultPtr, 1), 0x3d)
158             }
159         }
160 
161         return result;
162     }
163 }
164 
165 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
166 
167 
168 // ERC721A Contracts v4.2.3
169 // Creator: Chiru Labs
170 
171 pragma solidity ^0.8.4;
172 
173 /**
174  * @dev Interface of ERC721A.
175  */
176 interface IERC721A {
177     /**
178      * The caller must own the token or be an approved operator.
179      */
180     error ApprovalCallerNotOwnerNorApproved();
181 
182     /**
183      * The token does not exist.
184      */
185     error ApprovalQueryForNonexistentToken();
186 
187     /**
188      * Cannot query the balance for the zero address.
189      */
190     error BalanceQueryForZeroAddress();
191 
192     /**
193      * Cannot mint to the zero address.
194      */
195     error MintToZeroAddress();
196 
197     /**
198      * The quantity of tokens minted must be more than zero.
199      */
200     error MintZeroQuantity();
201 
202     /**
203      * The token does not exist.
204      */
205     error OwnerQueryForNonexistentToken();
206 
207     /**
208      * The caller must own the token or be an approved operator.
209      */
210     error TransferCallerNotOwnerNorApproved();
211 
212     /**
213      * The token must be owned by `from`.
214      */
215     error TransferFromIncorrectOwner();
216 
217     /**
218      * Cannot safely transfer to a contract that does not implement the
219      * ERC721Receiver interface.
220      */
221     error TransferToNonERC721ReceiverImplementer();
222 
223     /**
224      * Cannot transfer to the zero address.
225      */
226     error TransferToZeroAddress();
227 
228     /**
229      * The token does not exist.
230      */
231     error URIQueryForNonexistentToken();
232 
233     /**
234      * The `quantity` minted with ERC2309 exceeds the safety limit.
235      */
236     error MintERC2309QuantityExceedsLimit();
237 
238     /**
239      * The `extraData` cannot be set on an unintialized ownership slot.
240      */
241     error OwnershipNotInitializedForExtraData();
242 
243     // =============================================================
244     //                            STRUCTS
245     // =============================================================
246 
247     struct TokenOwnership {
248         // The address of the owner.
249         address addr;
250         // Stores the start time of ownership with minimal overhead for tokenomics.
251         uint64 startTimestamp;
252         // Whether the token has been burned.
253         bool burned;
254         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
255         uint24 extraData;
256     }
257 
258     // =============================================================
259     //                         TOKEN COUNTERS
260     // =============================================================
261 
262     /**
263      * @dev Returns the total number of tokens in existence.
264      * Burned tokens will reduce the count.
265      * To get the total number of tokens minted, please see {_totalMinted}.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     // =============================================================
270     //                            IERC165
271     // =============================================================
272 
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 
283     // =============================================================
284     //                            IERC721
285     // =============================================================
286 
287     /**
288      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
289      */
290     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
291 
292     /**
293      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
294      */
295     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
296 
297     /**
298      * @dev Emitted when `owner` enables or disables
299      * (`approved`) `operator` to manage all of its assets.
300      */
301     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
302 
303     /**
304      * @dev Returns the number of tokens in `owner`'s account.
305      */
306     function balanceOf(address owner) external view returns (uint256 balance);
307 
308     /**
309      * @dev Returns the owner of the `tokenId` token.
310      *
311      * Requirements:
312      *
313      * - `tokenId` must exist.
314      */
315     function ownerOf(uint256 tokenId) external view returns (address owner);
316 
317     /**
318      * @dev Safely transfers `tokenId` token from `from` to `to`,
319      * checking first that contract recipients are aware of the ERC721 protocol
320      * to prevent tokens from being forever locked.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be have been allowed to move
328      * this token by either {approve} or {setApprovalForAll}.
329      * - If `to` refers to a smart contract, it must implement
330      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
331      *
332      * Emits a {Transfer} event.
333      */
334     function safeTransferFrom(
335         address from,
336         address to,
337         uint256 tokenId,
338         bytes calldata data
339     ) external payable;
340 
341     /**
342      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
343      */
344     function safeTransferFrom(
345         address from,
346         address to,
347         uint256 tokenId
348     ) external payable;
349 
350     /**
351      * @dev Transfers `tokenId` from `from` to `to`.
352      *
353      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
354      * whenever possible.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `tokenId` token must be owned by `from`.
361      * - If the caller is not `from`, it must be approved to move this token
362      * by either {approve} or {setApprovalForAll}.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transferFrom(
367         address from,
368         address to,
369         uint256 tokenId
370     ) external payable;
371 
372     /**
373      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
374      * The approval is cleared when the token is transferred.
375      *
376      * Only a single account can be approved at a time, so approving the
377      * zero address clears previous approvals.
378      *
379      * Requirements:
380      *
381      * - The caller must own the token or be an approved operator.
382      * - `tokenId` must exist.
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address to, uint256 tokenId) external payable;
387 
388     /**
389      * @dev Approve or remove `operator` as an operator for the caller.
390      * Operators can call {transferFrom} or {safeTransferFrom}
391      * for any token owned by the caller.
392      *
393      * Requirements:
394      *
395      * - The `operator` cannot be the caller.
396      *
397      * Emits an {ApprovalForAll} event.
398      */
399     function setApprovalForAll(address operator, bool _approved) external;
400 
401     /**
402      * @dev Returns the account approved for `tokenId` token.
403      *
404      * Requirements:
405      *
406      * - `tokenId` must exist.
407      */
408     function getApproved(uint256 tokenId) external view returns (address operator);
409 
410     /**
411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
412      *
413      * See {setApprovalForAll}.
414      */
415     function isApprovedForAll(address owner, address operator) external view returns (bool);
416 
417     // =============================================================
418     //                        IERC721Metadata
419     // =============================================================
420 
421     /**
422      * @dev Returns the token collection name.
423      */
424     function name() external view returns (string memory);
425 
426     /**
427      * @dev Returns the token collection symbol.
428      */
429     function symbol() external view returns (string memory);
430 
431     /**
432      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
433      */
434     function tokenURI(uint256 tokenId) external view returns (string memory);
435 
436     // =============================================================
437     //                           IERC2309
438     // =============================================================
439 
440     /**
441      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
442      * (inclusive) is transferred from `from` to `to`, as defined in the
443      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
444      *
445      * See {_mintERC2309} for more details.
446      */
447     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
448 }
449 
450 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
451 
452 
453 // ERC721A Contracts v4.2.3
454 // Creator: Chiru Labs
455 
456 pragma solidity ^0.8.4;
457 
458 
459 /**
460  * @dev Interface of ERC721 token receiver.
461  */
462 interface ERC721A__IERC721Receiver {
463     function onERC721Received(
464         address operator,
465         address from,
466         uint256 tokenId,
467         bytes calldata data
468     ) external returns (bytes4);
469 }
470 
471 /**
472  * @title ERC721A
473  *
474  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
475  * Non-Fungible Token Standard, including the Metadata extension.
476  * Optimized for lower gas during batch mints.
477  *
478  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
479  * starting from `_startTokenId()`.
480  *
481  * Assumptions:
482  *
483  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
484  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
485  */
486 contract ERC721A is IERC721A {
487     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
488     struct TokenApprovalRef {
489         address value;
490     }
491 
492     // =============================================================
493     //                           CONSTANTS
494     // =============================================================
495 
496     // Mask of an entry in packed address data.
497     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
498 
499     // The bit position of `numberMinted` in packed address data.
500     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
501 
502     // The bit position of `numberBurned` in packed address data.
503     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
504 
505     // The bit position of `aux` in packed address data.
506     uint256 private constant _BITPOS_AUX = 192;
507 
508     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
509     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
510 
511     // The bit position of `startTimestamp` in packed ownership.
512     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
513 
514     // The bit mask of the `burned` bit in packed ownership.
515     uint256 private constant _BITMASK_BURNED = 1 << 224;
516 
517     // The bit position of the `nextInitialized` bit in packed ownership.
518     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
519 
520     // The bit mask of the `nextInitialized` bit in packed ownership.
521     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
522 
523     // The bit position of `extraData` in packed ownership.
524     uint256 private constant _BITPOS_EXTRA_DATA = 232;
525 
526     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
527     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
528 
529     // The mask of the lower 160 bits for addresses.
530     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
531 
532     // The maximum `quantity` that can be minted with {_mintERC2309}.
533     // This limit is to prevent overflows on the address data entries.
534     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
535     // is required to cause an overflow, which is unrealistic.
536     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
537 
538     // The `Transfer` event signature is given by:
539     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
540     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
541         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
542 
543     // =============================================================
544     //                            STORAGE
545     // =============================================================
546 
547     // The next token ID to be minted.
548     uint256 private _currentIndex;
549 
550     // The number of tokens burned.
551     uint256 private _burnCounter;
552 
553     // Token name
554     string private _name;
555 
556     // Token symbol
557     string private _symbol;
558 
559     // Mapping from token ID to ownership details
560     // An empty struct value does not necessarily mean the token is unowned.
561     // See {_packedOwnershipOf} implementation for details.
562     //
563     // Bits Layout:
564     // - [0..159]   `addr`
565     // - [160..223] `startTimestamp`
566     // - [224]      `burned`
567     // - [225]      `nextInitialized`
568     // - [232..255] `extraData`
569     mapping(uint256 => uint256) private _packedOwnerships;
570 
571     // Mapping owner address to address data.
572     //
573     // Bits Layout:
574     // - [0..63]    `balance`
575     // - [64..127]  `numberMinted`
576     // - [128..191] `numberBurned`
577     // - [192..255] `aux`
578     mapping(address => uint256) private _packedAddressData;
579 
580     // Mapping from token ID to approved address.
581     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
582 
583     // Mapping from owner to operator approvals
584     mapping(address => mapping(address => bool)) private _operatorApprovals;
585 
586     // =============================================================
587     //                          CONSTRUCTOR
588     // =============================================================
589 
590     constructor(string memory name_, string memory symbol_) {
591         _name = name_;
592         _symbol = symbol_;
593         _currentIndex = _startTokenId();
594     }
595 
596     // =============================================================
597     //                   TOKEN COUNTING OPERATIONS
598     // =============================================================
599 
600     /**
601      * @dev Returns the starting token ID.
602      * To change the starting token ID, please override this function.
603      */
604     function _startTokenId() internal view virtual returns (uint256) {
605         return 0;
606     }
607 
608     /**
609      * @dev Returns the next token ID to be minted.
610      */
611     function _nextTokenId() internal view virtual returns (uint256) {
612         return _currentIndex;
613     }
614 
615     /**
616      * @dev Returns the total number of tokens in existence.
617      * Burned tokens will reduce the count.
618      * To get the total number of tokens minted, please see {_totalMinted}.
619      */
620     function totalSupply() public view virtual override returns (uint256) {
621         // Counter underflow is impossible as _burnCounter cannot be incremented
622         // more than `_currentIndex - _startTokenId()` times.
623         unchecked {
624             return _currentIndex - _burnCounter - _startTokenId();
625         }
626     }
627 
628     /**
629      * @dev Returns the total amount of tokens minted in the contract.
630      */
631     function _totalMinted() internal view virtual returns (uint256) {
632         // Counter underflow is impossible as `_currentIndex` does not decrement,
633         // and it is initialized to `_startTokenId()`.
634         unchecked {
635             return _currentIndex - _startTokenId();
636         }
637     }
638 
639     /**
640      * @dev Returns the total number of tokens burned.
641      */
642     function _totalBurned() internal view virtual returns (uint256) {
643         return _burnCounter;
644     }
645 
646     // =============================================================
647     //                    ADDRESS DATA OPERATIONS
648     // =============================================================
649 
650     /**
651      * @dev Returns the number of tokens in `owner`'s account.
652      */
653     function balanceOf(address owner) public view virtual override returns (uint256) {
654         if (owner == address(0)) revert BalanceQueryForZeroAddress();
655         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
656     }
657 
658     /**
659      * Returns the number of tokens minted by `owner`.
660      */
661     function _numberMinted(address owner) internal view returns (uint256) {
662         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
663     }
664 
665     /**
666      * Returns the number of tokens burned by or on behalf of `owner`.
667      */
668     function _numberBurned(address owner) internal view returns (uint256) {
669         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
670     }
671 
672     /**
673      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
674      */
675     function _getAux(address owner) internal view returns (uint64) {
676         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
677     }
678 
679     /**
680      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
681      * If there are multiple variables, please pack them into a uint64.
682      */
683     function _setAux(address owner, uint64 aux) internal virtual {
684         uint256 packed = _packedAddressData[owner];
685         uint256 auxCasted;
686         // Cast `aux` with assembly to avoid redundant masking.
687         assembly {
688             auxCasted := aux
689         }
690         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
691         _packedAddressData[owner] = packed;
692     }
693 
694     // =============================================================
695     //                            IERC165
696     // =============================================================
697 
698     /**
699      * @dev Returns true if this contract implements the interface defined by
700      * `interfaceId`. See the corresponding
701      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
702      * to learn more about how these ids are created.
703      *
704      * This function call must use less than 30000 gas.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         // The interface IDs are constants representing the first 4 bytes
708         // of the XOR of all function selectors in the interface.
709         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
710         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
711         return
712             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
713             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
714             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
715     }
716 
717     // =============================================================
718     //                        IERC721Metadata
719     // =============================================================
720 
721     /**
722      * @dev Returns the token collection name.
723      */
724     function name() public view virtual override returns (string memory) {
725         return _name;
726     }
727 
728     /**
729      * @dev Returns the token collection symbol.
730      */
731     function symbol() public view virtual override returns (string memory) {
732         return _symbol;
733     }
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
739         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
740 
741         string memory baseURI = _baseURI();
742         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
743     }
744 
745     /**
746      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
747      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
748      * by default, it can be overridden in child contracts.
749      */
750     function _baseURI() internal view virtual returns (string memory) {
751         return '';
752     }
753 
754     // =============================================================
755     //                     OWNERSHIPS OPERATIONS
756     // =============================================================
757 
758     /**
759      * @dev Returns the owner of the `tokenId` token.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
766         return address(uint160(_packedOwnershipOf(tokenId)));
767     }
768 
769     /**
770      * @dev Gas spent here starts off proportional to the maximum mint batch size.
771      * It gradually moves to O(1) as tokens get transferred around over time.
772      */
773     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
774         return _unpackedOwnership(_packedOwnershipOf(tokenId));
775     }
776 
777     /**
778      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
779      */
780     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
781         return _unpackedOwnership(_packedOwnerships[index]);
782     }
783 
784     /**
785      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
786      */
787     function _initializeOwnershipAt(uint256 index) internal virtual {
788         if (_packedOwnerships[index] == 0) {
789             _packedOwnerships[index] = _packedOwnershipOf(index);
790         }
791     }
792 
793     /**
794      * Returns the packed ownership data of `tokenId`.
795      */
796     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
797         uint256 curr = tokenId;
798 
799         unchecked {
800             if (_startTokenId() <= curr)
801                 if (curr < _currentIndex) {
802                     uint256 packed = _packedOwnerships[curr];
803                     // If not burned.
804                     if (packed & _BITMASK_BURNED == 0) {
805                         // Invariant:
806                         // There will always be an initialized ownership slot
807                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
808                         // before an unintialized ownership slot
809                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
810                         // Hence, `curr` will not underflow.
811                         //
812                         // We can directly compare the packed value.
813                         // If the address is zero, packed will be zero.
814                         while (packed == 0) {
815                             packed = _packedOwnerships[--curr];
816                         }
817                         return packed;
818                     }
819                 }
820         }
821         revert OwnerQueryForNonexistentToken();
822     }
823 
824     /**
825      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
826      */
827     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
828         ownership.addr = address(uint160(packed));
829         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
830         ownership.burned = packed & _BITMASK_BURNED != 0;
831         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
832     }
833 
834     /**
835      * @dev Packs ownership data into a single uint256.
836      */
837     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
838         assembly {
839             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
840             owner := and(owner, _BITMASK_ADDRESS)
841             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
842             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
843         }
844     }
845 
846     /**
847      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
848      */
849     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
850         // For branchless setting of the `nextInitialized` flag.
851         assembly {
852             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
853             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
854         }
855     }
856 
857     // =============================================================
858     //                      APPROVAL OPERATIONS
859     // =============================================================
860 
861     /**
862      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
863      * The approval is cleared when the token is transferred.
864      *
865      * Only a single account can be approved at a time, so approving the
866      * zero address clears previous approvals.
867      *
868      * Requirements:
869      *
870      * - The caller must own the token or be an approved operator.
871      * - `tokenId` must exist.
872      *
873      * Emits an {Approval} event.
874      */
875     function approve(address to, uint256 tokenId) public payable virtual override {
876         address owner = ownerOf(tokenId);
877 
878         if (_msgSenderERC721A() != owner)
879             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
880                 revert ApprovalCallerNotOwnerNorApproved();
881             }
882 
883         _tokenApprovals[tokenId].value = to;
884         emit Approval(owner, to, tokenId);
885     }
886 
887     /**
888      * @dev Returns the account approved for `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function getApproved(uint256 tokenId) public view virtual override returns (address) {
895         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
896 
897         return _tokenApprovals[tokenId].value;
898     }
899 
900     /**
901      * @dev Approve or remove `operator` as an operator for the caller.
902      * Operators can call {transferFrom} or {safeTransferFrom}
903      * for any token owned by the caller.
904      *
905      * Requirements:
906      *
907      * - The `operator` cannot be the caller.
908      *
909      * Emits an {ApprovalForAll} event.
910      */
911     function setApprovalForAll(address operator, bool approved) public virtual override {
912         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
913         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
914     }
915 
916     /**
917      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
918      *
919      * See {setApprovalForAll}.
920      */
921     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[owner][operator];
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted. See {_mint}.
931      */
932     function _exists(uint256 tokenId) internal view virtual returns (bool) {
933         return
934             _startTokenId() <= tokenId &&
935             tokenId < _currentIndex && // If within bounds,
936             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
937     }
938 
939     /**
940      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
941      */
942     function _isSenderApprovedOrOwner(
943         address approvedAddress,
944         address owner,
945         address msgSender
946     ) private pure returns (bool result) {
947         assembly {
948             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
949             owner := and(owner, _BITMASK_ADDRESS)
950             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
951             msgSender := and(msgSender, _BITMASK_ADDRESS)
952             // `msgSender == owner || msgSender == approvedAddress`.
953             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
954         }
955     }
956 
957     /**
958      * @dev Returns the storage slot and value for the approved address of `tokenId`.
959      */
960     function _getApprovedSlotAndAddress(uint256 tokenId)
961         private
962         view
963         returns (uint256 approvedAddressSlot, address approvedAddress)
964     {
965         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
966         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
967         assembly {
968             approvedAddressSlot := tokenApproval.slot
969             approvedAddress := sload(approvedAddressSlot)
970         }
971     }
972 
973     // =============================================================
974     //                      TRANSFER OPERATIONS
975     // =============================================================
976 
977     /**
978      * @dev Transfers `tokenId` from `from` to `to`.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      * - If the caller is not `from`, it must be approved to move this token
986      * by either {approve} or {setApprovalForAll}.
987      *
988      * Emits a {Transfer} event.
989      */
990     function transferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) public payable virtual override {
995         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
996 
997         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
998 
999         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1000 
1001         // The nested ifs save around 20+ gas over a compound boolean condition.
1002         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1003             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1004 
1005         if (to == address(0)) revert TransferToZeroAddress();
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         assembly {
1011             if approvedAddress {
1012                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1013                 sstore(approvedAddressSlot, 0)
1014             }
1015         }
1016 
1017         // Underflow of the sender's balance is impossible because we check for
1018         // ownership above and the recipient's balance can't realistically overflow.
1019         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1020         unchecked {
1021             // We can directly increment and decrement the balances.
1022             --_packedAddressData[from]; // Updates: `balance -= 1`.
1023             ++_packedAddressData[to]; // Updates: `balance += 1`.
1024 
1025             // Updates:
1026             // - `address` to the next owner.
1027             // - `startTimestamp` to the timestamp of transfering.
1028             // - `burned` to `false`.
1029             // - `nextInitialized` to `true`.
1030             _packedOwnerships[tokenId] = _packOwnershipData(
1031                 to,
1032                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1033             );
1034 
1035             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1036             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1037                 uint256 nextTokenId = tokenId + 1;
1038                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1039                 if (_packedOwnerships[nextTokenId] == 0) {
1040                     // If the next slot is within bounds.
1041                     if (nextTokenId != _currentIndex) {
1042                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1043                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1044                     }
1045                 }
1046             }
1047         }
1048 
1049         emit Transfer(from, to, tokenId);
1050         _afterTokenTransfers(from, to, tokenId, 1);
1051     }
1052 
1053     /**
1054      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public payable virtual override {
1061         safeTransferFrom(from, to, tokenId, '');
1062     }
1063 
1064     /**
1065      * @dev Safely transfers `tokenId` token from `from` to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must exist and be owned by `from`.
1072      * - If the caller is not `from`, it must be approved to move this token
1073      * by either {approve} or {setApprovalForAll}.
1074      * - If `to` refers to a smart contract, it must implement
1075      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) public payable virtual override {
1085         transferFrom(from, to, tokenId);
1086         if (to.code.length != 0)
1087             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1088                 revert TransferToNonERC721ReceiverImplementer();
1089             }
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before a set of serially-ordered token IDs
1094      * are about to be transferred. This includes minting.
1095      * And also called before burning one token.
1096      *
1097      * `startTokenId` - the first token ID to be transferred.
1098      * `quantity` - the amount to be transferred.
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` will be minted for `to`.
1105      * - When `to` is zero, `tokenId` will be burned by `from`.
1106      * - `from` and `to` are never both zero.
1107      */
1108     function _beforeTokenTransfers(
1109         address from,
1110         address to,
1111         uint256 startTokenId,
1112         uint256 quantity
1113     ) internal virtual {}
1114 
1115     /**
1116      * @dev Hook that is called after a set of serially-ordered token IDs
1117      * have been transferred. This includes minting.
1118      * And also called after one token has been burned.
1119      *
1120      * `startTokenId` - the first token ID to be transferred.
1121      * `quantity` - the amount to be transferred.
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` has been minted for `to`.
1128      * - When `to` is zero, `tokenId` has been burned by `from`.
1129      * - `from` and `to` are never both zero.
1130      */
1131     function _afterTokenTransfers(
1132         address from,
1133         address to,
1134         uint256 startTokenId,
1135         uint256 quantity
1136     ) internal virtual {}
1137 
1138     /**
1139      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1140      *
1141      * `from` - Previous owner of the given token ID.
1142      * `to` - Target address that will receive the token.
1143      * `tokenId` - Token ID to be transferred.
1144      * `_data` - Optional data to send along with the call.
1145      *
1146      * Returns whether the call correctly returned the expected magic value.
1147      */
1148     function _checkContractOnERC721Received(
1149         address from,
1150         address to,
1151         uint256 tokenId,
1152         bytes memory _data
1153     ) private returns (bool) {
1154         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1155             bytes4 retval
1156         ) {
1157             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1158         } catch (bytes memory reason) {
1159             if (reason.length == 0) {
1160                 revert TransferToNonERC721ReceiverImplementer();
1161             } else {
1162                 assembly {
1163                     revert(add(32, reason), mload(reason))
1164                 }
1165             }
1166         }
1167     }
1168 
1169     // =============================================================
1170     //                        MINT OPERATIONS
1171     // =============================================================
1172 
1173     /**
1174      * @dev Mints `quantity` tokens and transfers them to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `quantity` must be greater than 0.
1180      *
1181      * Emits a {Transfer} event for each mint.
1182      */
1183     function _mint(address to, uint256 quantity) internal virtual {
1184         uint256 startTokenId = _currentIndex;
1185         if (quantity == 0) revert MintZeroQuantity();
1186 
1187         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1188 
1189         // Overflows are incredibly unrealistic.
1190         // `balance` and `numberMinted` have a maximum limit of 2**64.
1191         // `tokenId` has a maximum limit of 2**256.
1192         unchecked {
1193             // Updates:
1194             // - `balance += quantity`.
1195             // - `numberMinted += quantity`.
1196             //
1197             // We can directly add to the `balance` and `numberMinted`.
1198             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1199 
1200             // Updates:
1201             // - `address` to the owner.
1202             // - `startTimestamp` to the timestamp of minting.
1203             // - `burned` to `false`.
1204             // - `nextInitialized` to `quantity == 1`.
1205             _packedOwnerships[startTokenId] = _packOwnershipData(
1206                 to,
1207                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1208             );
1209 
1210             uint256 toMasked;
1211             uint256 end = startTokenId + quantity;
1212 
1213             // Use assembly to loop and emit the `Transfer` event for gas savings.
1214             // The duplicated `log4` removes an extra check and reduces stack juggling.
1215             // The assembly, together with the surrounding Solidity code, have been
1216             // delicately arranged to nudge the compiler into producing optimized opcodes.
1217             assembly {
1218                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1219                 toMasked := and(to, _BITMASK_ADDRESS)
1220                 // Emit the `Transfer` event.
1221                 log4(
1222                     0, // Start of data (0, since no data).
1223                     0, // End of data (0, since no data).
1224                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1225                     0, // `address(0)`.
1226                     toMasked, // `to`.
1227                     startTokenId // `tokenId`.
1228                 )
1229 
1230                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1231                 // that overflows uint256 will make the loop run out of gas.
1232                 // The compiler will optimize the `iszero` away for performance.
1233                 for {
1234                     let tokenId := add(startTokenId, 1)
1235                 } iszero(eq(tokenId, end)) {
1236                     tokenId := add(tokenId, 1)
1237                 } {
1238                     // Emit the `Transfer` event. Similar to above.
1239                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1240                 }
1241             }
1242             if (toMasked == 0) revert MintToZeroAddress();
1243 
1244             _currentIndex = end;
1245         }
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * This function is intended for efficient minting only during contract creation.
1253      *
1254      * It emits only one {ConsecutiveTransfer} as defined in
1255      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1256      * instead of a sequence of {Transfer} event(s).
1257      *
1258      * Calling this function outside of contract creation WILL make your contract
1259      * non-compliant with the ERC721 standard.
1260      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1261      * {ConsecutiveTransfer} event is only permissible during contract creation.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `quantity` must be greater than 0.
1267      *
1268      * Emits a {ConsecutiveTransfer} event.
1269      */
1270     function _mintERC2309(address to, uint256 quantity) internal virtual {
1271         uint256 startTokenId = _currentIndex;
1272         if (to == address(0)) revert MintToZeroAddress();
1273         if (quantity == 0) revert MintZeroQuantity();
1274         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1275 
1276         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1277 
1278         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1279         unchecked {
1280             // Updates:
1281             // - `balance += quantity`.
1282             // - `numberMinted += quantity`.
1283             //
1284             // We can directly add to the `balance` and `numberMinted`.
1285             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1286 
1287             // Updates:
1288             // - `address` to the owner.
1289             // - `startTimestamp` to the timestamp of minting.
1290             // - `burned` to `false`.
1291             // - `nextInitialized` to `quantity == 1`.
1292             _packedOwnerships[startTokenId] = _packOwnershipData(
1293                 to,
1294                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1295             );
1296 
1297             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1298 
1299             _currentIndex = startTokenId + quantity;
1300         }
1301         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1302     }
1303 
1304     /**
1305      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1306      *
1307      * Requirements:
1308      *
1309      * - If `to` refers to a smart contract, it must implement
1310      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1311      * - `quantity` must be greater than 0.
1312      *
1313      * See {_mint}.
1314      *
1315      * Emits a {Transfer} event for each mint.
1316      */
1317     function _safeMint(
1318         address to,
1319         uint256 quantity,
1320         bytes memory _data
1321     ) internal virtual {
1322         _mint(to, quantity);
1323 
1324         unchecked {
1325             if (to.code.length != 0) {
1326                 uint256 end = _currentIndex;
1327                 uint256 index = end - quantity;
1328                 do {
1329                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1330                         revert TransferToNonERC721ReceiverImplementer();
1331                     }
1332                 } while (index < end);
1333                 // Reentrancy protection.
1334                 if (_currentIndex != end) revert();
1335             }
1336         }
1337     }
1338 
1339     /**
1340      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1341      */
1342     function _safeMint(address to, uint256 quantity) internal virtual {
1343         _safeMint(to, quantity, '');
1344     }
1345 
1346     // =============================================================
1347     //                        BURN OPERATIONS
1348     // =============================================================
1349 
1350     /**
1351      * @dev Equivalent to `_burn(tokenId, false)`.
1352      */
1353     function _burn(uint256 tokenId) internal virtual {
1354         _burn(tokenId, false);
1355     }
1356 
1357     /**
1358      * @dev Destroys `tokenId`.
1359      * The approval is cleared when the token is burned.
1360      *
1361      * Requirements:
1362      *
1363      * - `tokenId` must exist.
1364      *
1365      * Emits a {Transfer} event.
1366      */
1367     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1368         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1369 
1370         address from = address(uint160(prevOwnershipPacked));
1371 
1372         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1373 
1374         if (approvalCheck) {
1375             // The nested ifs save around 20+ gas over a compound boolean condition.
1376             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1377                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1378         }
1379 
1380         _beforeTokenTransfers(from, address(0), tokenId, 1);
1381 
1382         // Clear approvals from the previous owner.
1383         assembly {
1384             if approvedAddress {
1385                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1386                 sstore(approvedAddressSlot, 0)
1387             }
1388         }
1389 
1390         // Underflow of the sender's balance is impossible because we check for
1391         // ownership above and the recipient's balance can't realistically overflow.
1392         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1393         unchecked {
1394             // Updates:
1395             // - `balance -= 1`.
1396             // - `numberBurned += 1`.
1397             //
1398             // We can directly decrement the balance, and increment the number burned.
1399             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1400             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1401 
1402             // Updates:
1403             // - `address` to the last owner.
1404             // - `startTimestamp` to the timestamp of burning.
1405             // - `burned` to `true`.
1406             // - `nextInitialized` to `true`.
1407             _packedOwnerships[tokenId] = _packOwnershipData(
1408                 from,
1409                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1410             );
1411 
1412             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1413             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1414                 uint256 nextTokenId = tokenId + 1;
1415                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1416                 if (_packedOwnerships[nextTokenId] == 0) {
1417                     // If the next slot is within bounds.
1418                     if (nextTokenId != _currentIndex) {
1419                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1420                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1421                     }
1422                 }
1423             }
1424         }
1425 
1426         emit Transfer(from, address(0), tokenId);
1427         _afterTokenTransfers(from, address(0), tokenId, 1);
1428 
1429         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1430         unchecked {
1431             _burnCounter++;
1432         }
1433     }
1434 
1435     // =============================================================
1436     //                     EXTRA DATA OPERATIONS
1437     // =============================================================
1438 
1439     /**
1440      * @dev Directly sets the extra data for the ownership data `index`.
1441      */
1442     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1443         uint256 packed = _packedOwnerships[index];
1444         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1445         uint256 extraDataCasted;
1446         // Cast `extraData` with assembly to avoid redundant masking.
1447         assembly {
1448             extraDataCasted := extraData
1449         }
1450         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1451         _packedOwnerships[index] = packed;
1452     }
1453 
1454     /**
1455      * @dev Called during each token transfer to set the 24bit `extraData` field.
1456      * Intended to be overridden by the cosumer contract.
1457      *
1458      * `previousExtraData` - the value of `extraData` before transfer.
1459      *
1460      * Calling conditions:
1461      *
1462      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1463      * transferred to `to`.
1464      * - When `from` is zero, `tokenId` will be minted for `to`.
1465      * - When `to` is zero, `tokenId` will be burned by `from`.
1466      * - `from` and `to` are never both zero.
1467      */
1468     function _extraData(
1469         address from,
1470         address to,
1471         uint24 previousExtraData
1472     ) internal view virtual returns (uint24) {}
1473 
1474     /**
1475      * @dev Returns the next extra data for the packed ownership data.
1476      * The returned result is shifted into position.
1477      */
1478     function _nextExtraData(
1479         address from,
1480         address to,
1481         uint256 prevOwnershipPacked
1482     ) private view returns (uint256) {
1483         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1484         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1485     }
1486 
1487     // =============================================================
1488     //                       OTHER OPERATIONS
1489     // =============================================================
1490 
1491     /**
1492      * @dev Returns the message sender (defaults to `msg.sender`).
1493      *
1494      * If you are writing GSN compatible contracts, you need to override this function.
1495      */
1496     function _msgSenderERC721A() internal view virtual returns (address) {
1497         return msg.sender;
1498     }
1499 
1500     /**
1501      * @dev Converts a uint256 to its ASCII string decimal representation.
1502      */
1503     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1504         assembly {
1505             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1506             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1507             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1508             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1509             let m := add(mload(0x40), 0xa0)
1510             // Update the free memory pointer to allocate.
1511             mstore(0x40, m)
1512             // Assign the `str` to the end.
1513             str := sub(m, 0x20)
1514             // Zeroize the slot after the string.
1515             mstore(str, 0)
1516 
1517             // Cache the end of the memory to calculate the length later.
1518             let end := str
1519 
1520             // We write the string from rightmost digit to leftmost digit.
1521             // The following is essentially a do-while loop that also handles the zero case.
1522             // prettier-ignore
1523             for { let temp := value } 1 {} {
1524                 str := sub(str, 1)
1525                 // Write the character to the pointer.
1526                 // The ASCII index of the '0' character is 48.
1527                 mstore8(str, add(48, mod(temp, 10)))
1528                 // Keep dividing `temp` until zero.
1529                 temp := div(temp, 10)
1530                 // prettier-ignore
1531                 if iszero(temp) { break }
1532             }
1533 
1534             let length := sub(end, str)
1535             // Move the pointer 32 bytes leftwards to make room for the length.
1536             str := sub(str, 0x20)
1537             // Store the length.
1538             mstore(str, length)
1539         }
1540     }
1541 }
1542 
1543 // File: contracts/_69ars.sol
1544 
1545 
1546 
1547 pragma solidity >=0.8.13;
1548 
1549 
1550 
1551 
1552 contract _69ars is ERC721A
1553 {    
1554     uint public constant CONTENT_SIDE = 69;
1555     uint public constant CONTENT_PADDING = 2;
1556     uint public constant CONTENT_COLOR_BYTES = 2;
1557     uint public constant CONTENT_SIZE = (CONTENT_SIDE+CONTENT_PADDING) * CONTENT_SIDE * CONTENT_COLOR_BYTES;
1558     
1559     uint public constant COLLECION_SIZE = 6969;
1560     uint public constant MAX_PEX_MINT = 10;
1561 
1562     struct Attribute
1563     {
1564         string trait;
1565         string value;
1566     }
1567 
1568     constructor() ERC721A("69ars", "69AR")
1569     {                
1570         _mint(msg.sender, 9);
1571     }       
1572 
1573     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
1574         return 1;
1575     }
1576 
1577     function mint(uint256 quantity) public 
1578     {                
1579         require(quantity <= MAX_PEX_MINT, "Can't exceed max per mint");
1580         require(totalSupply() + quantity <= COLLECION_SIZE, "Can't exceed the collection size");
1581 
1582         _mint(msg.sender, quantity);
1583     }
1584 
1585     function tokenURI(uint token) public pure override(ERC721A) returns(string memory encoded_metadata)
1586     {
1587         encoded_metadata = string(abi.encodePacked("data:application/json;base64,", metadataJson(token)));
1588     }
1589 
1590     function metadataJson(uint token) public pure returns(string memory metadata)
1591     {
1592         string memory image;
1593         Attribute[] memory attributes;
1594         uint acount;
1595         (image, attributes, acount) = getImage(token);
1596 
1597         string[] memory entries = new string[](acount);
1598 
1599         for (uint i = 0; i < entries.length; ++i)
1600         {                        
1601             entries[i] = string(abi.encodePacked("{\"trait_type\":\"",attributes[i].trait,"\",\"value\":\"",attributes[i].value,"\"}"));            
1602         }
1603 
1604         string memory attributesJson = "[";
1605         for (uint i = 0; i < entries.length; ++i)
1606         {
1607             if (i == 0)
1608             {
1609                 attributesJson = string(abi.encodePacked(attributesJson,entries[i]));
1610             }
1611             else 
1612             {
1613                 attributesJson = string(abi.encodePacked(attributesJson,",",entries[i]));
1614             }
1615         }
1616         attributesJson = string(abi.encodePacked(attributesJson,"]"));
1617 
1618         metadata = Base64.encode(
1619             abi.encodePacked(
1620                 "{\"image\": \"", image, "\", \"name\":\"69AR #", Strings.toString(token) ,"\", \"description\":\"Fully onchain 69ars in raster(BMP) format.\",\"attributes\":",attributesJson,"}"));
1621     }
1622 
1623     function getImage(uint token) public pure returns(string memory image, Attribute[] memory attributes, uint acount)
1624     {        
1625         bytes memory header = hex""
1626         hex"424D"
1627         hex"7c260000" 
1628         hex"00000000"
1629         hex"36000000"
1630 
1631         hex"28000000"
1632         hex"45000000"
1633         hex"45000000"
1634         hex"0100"
1635         hex"1000"
1636         hex"00000000"
1637         hex"00000000"
1638         hex"00000000"
1639         hex"00000000"
1640         hex"00000000"
1641         hex"00000000"
1642         hex""; 
1643 
1644         bytes memory imageBytes;                
1645         (imageBytes, attributes, acount) = getContentBytes(token);
1646         image = string(abi.encodePacked("data:image/bmp;base64,", Base64.encode(abi.encodePacked(header, imageBytes))));
1647     }
1648 
1649     function getContentBytes(uint token) public pure returns(bytes memory content, Attribute[] memory attributes, uint acount)
1650     {                
1651         attributes = new Attribute[](10);        
1652         acount = 3;
1653         content = new bytes(CONTENT_SIZE);
1654     
1655         uint seed = uint(keccak256(abi.encodePacked(token)));
1656 
1657         seed = drawMainAttributes(content, seed, attributes);
1658         seed = seed >> 1;        
1659         if (seed & 1 > 0) 
1660         {            
1661             bytes1 rc1;
1662             bytes1 rc2;        
1663             string memory earring;
1664             (rc1, rc2, earring) = getEarringColor(seed);
1665             attributes[acount++] = Attribute({trait: "earring", value: earring});
1666             drawEarring(content, rc1, rc2);
1667         }             
1668     }
1669 
1670     function drawMainAttributes(bytes memory content, uint seed, Attribute[] memory attributes) private pure returns (uint newSeed)
1671     {
1672         bytes1 bc1;
1673         bytes1 bc2;             
1674         string memory background;   
1675         (bc1,bc2,background) = getBackgroundColor(seed);         
1676         drawSolidBackground(content, bc1, bc2);  
1677         attributes[0] = Attribute({trait: "background", value: background});
1678 
1679         seed = seed >> 1;
1680 
1681         bytes1 fc1;
1682         bytes1 fc2;
1683         bytes1 oc1;
1684         bytes1 oc2;
1685         string memory fur;        
1686         (fc1, fc2, oc1, oc2, fur) = getFurColor(seed);
1687         drawBearFill(content, fc1, fc2);      
1688         drawBearOutline(content, oc1, oc2);
1689         attributes[1] = Attribute({trait: "fur", value: fur});
1690 
1691         seed = seed >> 1;
1692 
1693         bytes1 ec1;
1694         bytes1 ec2;  
1695         string memory eyes;      
1696         (ec1, ec2, eyes) = getEyeColor(seed);
1697         drawEyes(content, ec1, ec2);
1698         attributes[2] = Attribute({trait: "eyes", value: eyes});
1699 
1700         return seed;
1701     }
1702 
1703     function drawSolidBackground(bytes memory content, bytes1 c1, bytes1 c2) private pure
1704     {
1705         for (uint i = 0; i < CONTENT_SIZE / 2; ++i)
1706         {
1707             content[2*i] = c2;
1708             content[2*i+1] = c1;
1709         }
1710     }      
1711 
1712     function drawBearFill(bytes memory content, bytes1 c1, bytes1 c2) private pure
1713     {        
1714         for (uint8 y = 7; y < 48; ++y)
1715         {
1716             drawHorizontal(content, 14, y, 43, c1, c2);
1717         }
1718         
1719         for (uint8 y = 48; y < 60; ++y)
1720         {
1721             drawHorizontal(content, 26, y, 19, c1, c2);
1722         }
1723                 
1724         for (uint8 y = 60; y < 63; ++y)
1725         {
1726             drawHorizontal(content, 26, y, 4, c1, c2);
1727             drawHorizontal(content, 41, y, 4, c1, c2);
1728         }        
1729         
1730         for (uint8 y = 48; y < 54; ++y)
1731         {
1732             drawHorizontal(content, 45, y, 4, c1, c2);
1733         }        
1734     }
1735 
1736     function drawBearOutline(bytes memory content, bytes1 c1, bytes1 c2) private pure
1737     {                
1738         drawHorizontal(content, 13, 6, 45, c1, c2);        
1739         drawHorizontal(content, 13, 47, 45, c1, c2);                
1740         drawVertical(content, 13, 7, 40, c1, c2);                  
1741         drawVertical(content, 57, 7, 40, c1, c2);                  
1742         drawVertical(content, 20, 7, 27, c1, c2);                  
1743         drawVertical(content, 50, 7, 27, c1, c2);                  
1744         drawVertical(content, 25, 7, 5, c1, c2);                  
1745         drawVertical(content, 35, 7, 5, c1, c2);                  
1746         drawVertical(content, 45, 7, 5, c1, c2);                  
1747         drawHorizontal(content, 25, 12, 21, c1, c2);        
1748         drawVertical(content, 25, 48, 16, c1, c2);           
1749         drawVertical(content, 49, 48, 6, c1, c2);           
1750         drawHorizontal(content, 40, 54, 10, c1, c2);         
1751         drawVertical(content, 45, 55, 9, c1, c2);           
1752         drawHorizontal(content, 26, 63, 4, c1, c2);         
1753         drawHorizontal(content, 41, 63, 4, c1, c2);         
1754         drawVertical(content, 30, 60, 4, c1, c2);           
1755         drawVertical(content, 40, 60, 4, c1, c2);           
1756         drawHorizontal(content, 31, 60, 9, c1, c2); 
1757                 
1758         drawHorizontal(content, 47, 52, 2, c1, c2); 
1759         drawHorizontal(content, 47, 53, 2, c1, c2);         
1760         drawHorizontal(content, 47, 49, 2, c1, c2); 
1761         
1762         drawPointAtXY(content, 15, 7, c1, c2);
1763         drawPointAtXY(content, 18, 7, c1, c2);
1764         drawPointAtXY(content, 28, 7, c1, c2);
1765         drawPointAtXY(content, 32, 7, c1, c2);
1766         drawPointAtXY(content, 38, 7, c1, c2);
1767         drawPointAtXY(content, 42, 7, c1, c2);
1768         drawPointAtXY(content, 52, 7, c1, c2);
1769         drawPointAtXY(content, 55, 7, c1, c2);
1770     }
1771 
1772     function drawEyes(bytes memory content, bytes1 c1, bytes1 c2) private pure 
1773     {        
1774         drawHorizontal(content, 34, 56, 2, c1, c2);         
1775         drawHorizontal(content, 34, 57, 2, c1, c2);         
1776         drawHorizontal(content, 39, 56, 2, c1, c2);         
1777         drawHorizontal(content, 39, 57, 2, c1, c2); 
1778     }
1779 
1780     function drawEarring(bytes memory content, bytes1 c1, bytes1 c2) private pure 
1781     {        
1782         drawHorizontal(content, 27, 62, 2, c1, c2);         
1783         drawHorizontal(content, 27, 63, 2, c1, c2);                 
1784     }
1785 
1786     function getBackgroundColor(uint seed) private pure returns(bytes1 c1, bytes1 c2, string memory name)
1787     {
1788         uint8 chance = uint8(seed & 127);
1789 
1790         if (chance <  1) return (0x7f, 0x40, "gold");
1791         if (chance <  5) return (0x76, 0xd6, "pink");
1792         if (chance < 10) return (0x4e, 0xfc, "blue");
1793         if (chance < 25) return (0x5e, 0xfc, "violet");
1794         if (chance < 35) return (0x63, 0x55, "green");
1795         if (chance < 51) return (0x63, 0x3b, "gray");
1796 
1797         return (0x7f, 0xff, "white");        
1798     }
1799 
1800     function getFurColor(uint seed) private pure returns(bytes1 fc1, bytes1 fc2, bytes1 oc1, bytes1 oc2, string memory name)
1801     {
1802         uint8 chance = uint8(seed & 127);
1803 
1804         if (chance <  1) return (0x5f, 0x7f, 0x00, 0x00, "ice");
1805         if (chance <  5) return (0x7a, 0xca, 0x00, 0x00, "orange");
1806         if (chance < 10) return (0x4f, 0xed, 0x00, 0x00, "green");        
1807         if (chance < 20) return (0x7f, 0xff, 0x00, 0x00, "white");        
1808         if (chance < 35) return (0x5a, 0x5f, 0x00, 0x00, "violet");
1809         if (chance < 51) return (0x04, 0x21, 0x30, 0xa0, "black");
1810 
1811         return (0x30, 0xa0, 0x0, 0x0, "brown");
1812     }
1813 
1814     function getEyeColor(uint seed) private pure returns(bytes1 c1, bytes1 c2, string memory name)
1815     {
1816         uint8 chance = uint8(seed & 127);
1817 
1818         if (chance <  1) return (0x7c, 0x00, "red");                
1819         if (chance < 10) return (0x00, 0x1f, "blue");
1820         if (chance < 25) return (0x03, 0xe0, "green");
1821     
1822         return (0x0, 0x0, "black");
1823     }
1824 
1825     function getEarringColor(uint seed) private pure returns(bytes1 c1, bytes1 c2, string memory name)
1826     {
1827         uint8 chance = uint8(seed & 127);
1828         
1829         if (chance < 10) return (0x7f, 0x40, "gold");
1830         if (chance < 30) return (0x7c, 0x00, "ruby");
1831         if (chance < 60) return (0x03, 0xe0, "emerald");
1832 
1833         return (0x63, 0x3b, "silver");
1834     }
1835 
1836     function drawHorizontal(bytes memory content, uint8 x, uint8 y, uint8 length, bytes1 c1, bytes1 c2) private pure 
1837     {
1838         uint flat = centricToFlat(x, y);
1839         for (uint i = 0; i < length; ++i)
1840         {
1841             content[flat + (2*i)] = c2;
1842             content[flat + (2*i + 1)] = c1;
1843         }    
1844     }
1845 
1846     function drawVertical(bytes memory content, uint8 x, uint8 y, uint8 length, bytes1 c1, bytes1 c2) private pure
1847     {        
1848         for (uint i = 0; i < length; ++i)
1849         {
1850             uint flat = centricToFlat(x, y+i);
1851             content[flat] = c2;
1852             content[flat+1] = c1;
1853         }
1854     }
1855 
1856     function drawPointAtXY(bytes memory content, uint8 x, uint8 y, bytes1 c1, bytes1 c2) private pure
1857     {        
1858         uint flat = centricToFlat(x, y);        
1859         drawPointAtFlat(content, flat, c1, c2);
1860     }
1861 
1862     function drawPointAtFlat(bytes memory content, uint flat, bytes1 c1, bytes1 c2) private pure
1863     {        
1864         content[flat] = c2;
1865         content[flat + 1] = c1;
1866     }
1867 
1868     function centricToFlat(uint x, uint y) public pure returns(uint flat) 
1869     {
1870         flat = (CONTENT_SIDE * y + x) * 2 + y * CONTENT_PADDING;
1871     }            
1872 }