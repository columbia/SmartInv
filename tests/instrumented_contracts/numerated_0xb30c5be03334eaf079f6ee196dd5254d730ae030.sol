1 // SPDX-License-Identifier: MIT
2 
3 /*                                                                    
4                                                                                 
5                                      ,%%&@@                                     
6                                     &&&@@@&&@                                   
7                @%%%&               @&&&@@@@&&                %%&&               
8            /@&&&&&&&&&             &&%@@@@@@&#            .&%%%&&&&&            
9           @&&&&&&&@&&&&           (%%&@@@@@&&&            &&%%%&&&&&&@          
10           @@&&&&&&&&&&&&(         &%@&@@@@@&&&           @&&%%&&&&&@@@          
11            @@@&&&&&&&&&&&&       %&&@&&&&&&&&&&         %%&&&&&&&@@@@           
12             @@@@&&&&&&&&&&&&  %&%&&&&&&&&&&&&&&@&&&    %@&&@&&&@@@@             
13              @&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&@%&&&&&&&&@&&@              
14             &&%&&&&&&%%&&&&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&@            
15            &@@&&&&&&&%&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&           
16           &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&@          
17             &&&&&&&&@&&&@&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@          
18             %&&&&&&&&&&&&&&&&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&           
19            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&@          
20           @&&&&&&&&&&&&&&@&&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&          
21           %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&         
22           &&&&&&&&@&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@        
23          &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&        
24          &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&       
25          &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       
26          &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       
27          &&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&@&&&&&&&&&&&&&&&&&&&&&       
28          &&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       
29          &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&      
30          &&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&@&&&&%                                                                                             
31                                                                                                                                                        
32 */
33 
34 // File: @openzeppelin/contracts/utils/Context.sol
35 
36 
37 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 
62 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
63 
64 
65 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74     uint8 private constant _ADDRESS_LENGTH = 20;
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
78      */
79     function toString(uint256 value) internal pure returns (string memory) {
80         // Inspired by OraclizeAPI's implementation - MIT licence
81         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
82 
83         if (value == 0) {
84             return "0";
85         }
86         uint256 temp = value;
87         uint256 digits;
88         while (temp != 0) {
89             digits++;
90             temp /= 10;
91         }
92         bytes memory buffer = new bytes(digits);
93         while (value != 0) {
94             digits -= 1;
95             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
96             value /= 10;
97         }
98         return string(buffer);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
103      */
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
119      */
120     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
121         bytes memory buffer = new bytes(2 * length + 2);
122         buffer[0] = "0";
123         buffer[1] = "x";
124         for (uint256 i = 2 * length + 1; i > 1; --i) {
125             buffer[i] = _HEX_SYMBOLS[value & 0xf];
126             value >>= 4;
127         }
128         require(value == 0, "Strings: hex length insufficient");
129         return string(buffer);
130     }
131 
132     /**
133      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
134      */
135     function toHexString(address addr) internal pure returns (string memory) {
136         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
137     }
138 }
139 
140 // File: @openzeppelin/contracts/access/Ownable.sol
141 
142 
143 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Contract module which provides a basic access control mechanism, where
150  * there is an account (an owner) that can be granted exclusive access to
151  * specific functions.
152  *
153  * By default, the owner account will be the one that deploys the contract. This
154  * can later be changed with {transferOwnership}.
155  *
156  * This module is used through inheritance. It will make available the modifier
157  * `onlyOwner`, which can be applied to your functions to restrict their use to
158  * the owner.
159  */
160 abstract contract Ownable is Context {
161     address private _owner;
162 
163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165     /**
166      * @dev Initializes the contract setting the deployer as the initial owner.
167      */
168     constructor() {
169         _transferOwnership(_msgSender());
170     }
171 
172     /**
173      * @dev Throws if called by any account other than the owner.
174      */
175     modifier onlyOwner() {
176         _checkOwner();
177         _;
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view virtual returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if the sender is not the owner.
189      */
190     function _checkOwner() internal view virtual {
191         require(owner() == _msgSender(), "Ownable: caller is not the owner");
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public virtual onlyOwner {
202         _transferOwnership(address(0));
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Internal function without access restriction.
217      */
218     function _transferOwnership(address newOwner) internal virtual {
219         address oldOwner = _owner;
220         _owner = newOwner;
221         emit OwnershipTransferred(oldOwner, newOwner);
222     }
223 }
224 
225 // File: erc721a/contracts/IERC721A.sol
226 
227 
228 // ERC721A Contracts v4.2.2
229 // Creator: Chiru Labs
230 
231 pragma solidity ^0.8.4;
232 
233 /**
234  * @dev Interface of ERC721A.
235  */
236 interface IERC721A {
237     /**
238      * The caller must own the token or be an approved operator.
239      */
240     error ApprovalCallerNotOwnerNorApproved();
241 
242     /**
243      * The token does not exist.
244      */
245     error ApprovalQueryForNonexistentToken();
246 
247     /**
248      * The caller cannot approve to their own address.
249      */
250     error ApproveToCaller();
251 
252     /**
253      * Cannot query the balance for the zero address.
254      */
255     error BalanceQueryForZeroAddress();
256 
257     /**
258      * Cannot mint to the zero address.
259      */
260     error MintToZeroAddress();
261 
262     /**
263      * The quantity of tokens minted must be more than zero.
264      */
265     error MintZeroQuantity();
266 
267     /**
268      * The token does not exist.
269      */
270     error OwnerQueryForNonexistentToken();
271 
272     /**
273      * The caller must own the token or be an approved operator.
274      */
275     error TransferCallerNotOwnerNorApproved();
276 
277     /**
278      * The token must be owned by `from`.
279      */
280     error TransferFromIncorrectOwner();
281 
282     /**
283      * Cannot safely transfer to a contract that does not implement the
284      * ERC721Receiver interface.
285      */
286     error TransferToNonERC721ReceiverImplementer();
287 
288     /**
289      * Cannot transfer to the zero address.
290      */
291     error TransferToZeroAddress();
292 
293     /**
294      * The token does not exist.
295      */
296     error URIQueryForNonexistentToken();
297 
298     /**
299      * The `quantity` minted with ERC2309 exceeds the safety limit.
300      */
301     error MintERC2309QuantityExceedsLimit();
302 
303     /**
304      * The `extraData` cannot be set on an unintialized ownership slot.
305      */
306     error OwnershipNotInitializedForExtraData();
307 
308     // =============================================================
309     //                            STRUCTS
310     // =============================================================
311 
312     struct TokenOwnership {
313         // The address of the owner.
314         address addr;
315         // Stores the start time of ownership with minimal overhead for tokenomics.
316         uint64 startTimestamp;
317         // Whether the token has been burned.
318         bool burned;
319         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
320         uint24 extraData;
321     }
322 
323     // =============================================================
324     //                         TOKEN COUNTERS
325     // =============================================================
326 
327     /**
328      * @dev Returns the total number of tokens in existence.
329      * Burned tokens will reduce the count.
330      * To get the total number of tokens minted, please see {_totalMinted}.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     // =============================================================
335     //                            IERC165
336     // =============================================================
337 
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 
348     // =============================================================
349     //                            IERC721
350     // =============================================================
351 
352     /**
353      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
354      */
355     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
359      */
360     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
361 
362     /**
363      * @dev Emitted when `owner` enables or disables
364      * (`approved`) `operator` to manage all of its assets.
365      */
366     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
367 
368     /**
369      * @dev Returns the number of tokens in `owner`'s account.
370      */
371     function balanceOf(address owner) external view returns (uint256 balance);
372 
373     /**
374      * @dev Returns the owner of the `tokenId` token.
375      *
376      * Requirements:
377      *
378      * - `tokenId` must exist.
379      */
380     function ownerOf(uint256 tokenId) external view returns (address owner);
381 
382     /**
383      * @dev Safely transfers `tokenId` token from `from` to `to`,
384      * checking first that contract recipients are aware of the ERC721 protocol
385      * to prevent tokens from being forever locked.
386      *
387      * Requirements:
388      *
389      * - `from` cannot be the zero address.
390      * - `to` cannot be the zero address.
391      * - `tokenId` token must exist and be owned by `from`.
392      * - If the caller is not `from`, it must be have been allowed to move
393      * this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement
395      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
396      *
397      * Emits a {Transfer} event.
398      */
399     function safeTransferFrom(
400         address from,
401         address to,
402         uint256 tokenId,
403         bytes calldata data
404     ) external;
405 
406     /**
407      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
408      */
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId
413     ) external;
414 
415     /**
416      * @dev Transfers `tokenId` from `from` to `to`.
417      *
418      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
419      * whenever possible.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must be owned by `from`.
426      * - If the caller is not `from`, it must be approved to move this token
427      * by either {approve} or {setApprovalForAll}.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) external;
436 
437     /**
438      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
439      * The approval is cleared when the token is transferred.
440      *
441      * Only a single account can be approved at a time, so approving the
442      * zero address clears previous approvals.
443      *
444      * Requirements:
445      *
446      * - The caller must own the token or be an approved operator.
447      * - `tokenId` must exist.
448      *
449      * Emits an {Approval} event.
450      */
451     function approve(address to, uint256 tokenId) external;
452 
453     /**
454      * @dev Approve or remove `operator` as an operator for the caller.
455      * Operators can call {transferFrom} or {safeTransferFrom}
456      * for any token owned by the caller.
457      *
458      * Requirements:
459      *
460      * - The `operator` cannot be the caller.
461      *
462      * Emits an {ApprovalForAll} event.
463      */
464     function setApprovalForAll(address operator, bool _approved) external;
465 
466     /**
467      * @dev Returns the account approved for `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function getApproved(uint256 tokenId) external view returns (address operator);
474 
475     /**
476      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
477      *
478      * See {setApprovalForAll}.
479      */
480     function isApprovedForAll(address owner, address operator) external view returns (bool);
481 
482     // =============================================================
483     //                        IERC721Metadata
484     // =============================================================
485 
486     /**
487      * @dev Returns the token collection name.
488      */
489     function name() external view returns (string memory);
490 
491     /**
492      * @dev Returns the token collection symbol.
493      */
494     function symbol() external view returns (string memory);
495 
496     /**
497      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
498      */
499     function tokenURI(uint256 tokenId) external view returns (string memory);
500 
501     // =============================================================
502     //                           IERC2309
503     // =============================================================
504 
505     /**
506      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
507      * (inclusive) is transferred from `from` to `to`, as defined in the
508      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
509      *
510      * See {_mintERC2309} for more details.
511      */
512     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
513 }
514 // File: erc721a/contracts/ERC721A.sol
515 
516 
517 // ERC721A Contracts v4.2.2
518 // Creator: Chiru Labs
519 
520 pragma solidity ^0.8.4;
521 
522 
523 /**
524  * @dev Interface of ERC721 token receiver.
525  */
526 interface ERC721A__IERC721Receiver {
527     function onERC721Received(
528         address operator,
529         address from,
530         uint256 tokenId,
531         bytes calldata data
532     ) external returns (bytes4);
533 }
534 
535 /**
536  * @title ERC721A
537  *
538  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
539  * Non-Fungible Token Standard, including the Metadata extension.
540  * Optimized for lower gas during batch mints.
541  *
542  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
543  * starting from `_startTokenId()`.
544  *
545  * Assumptions:
546  *
547  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
548  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
549  */
550 contract ERC721A is IERC721A {
551     // Reference type for token approval.
552     struct TokenApprovalRef {
553         address value;
554     }
555 
556     // =============================================================
557     //                           CONSTANTS
558     // =============================================================
559 
560     // Mask of an entry in packed address data.
561     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
562 
563     // The bit position of `numberMinted` in packed address data.
564     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
565 
566     // The bit position of `numberBurned` in packed address data.
567     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
568 
569     // The bit position of `aux` in packed address data.
570     uint256 private constant _BITPOS_AUX = 192;
571 
572     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
573     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
574 
575     // The bit position of `startTimestamp` in packed ownership.
576     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
577 
578     // The bit mask of the `burned` bit in packed ownership.
579     uint256 private constant _BITMASK_BURNED = 1 << 224;
580 
581     // The bit position of the `nextInitialized` bit in packed ownership.
582     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
583 
584     // The bit mask of the `nextInitialized` bit in packed ownership.
585     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
586 
587     // The bit position of `extraData` in packed ownership.
588     uint256 private constant _BITPOS_EXTRA_DATA = 232;
589 
590     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
591     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
592 
593     // The mask of the lower 160 bits for addresses.
594     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
595 
596     // The maximum `quantity` that can be minted with {_mintERC2309}.
597     // This limit is to prevent overflows on the address data entries.
598     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
599     // is required to cause an overflow, which is unrealistic.
600     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
601 
602     // The `Transfer` event signature is given by:
603     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
604     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
605         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
606 
607     // =============================================================
608     //                            STORAGE
609     // =============================================================
610 
611     // The next token ID to be minted.
612     uint256 private _currentIndex;
613 
614     // The number of tokens burned.
615     uint256 private _burnCounter;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622 
623     // Mapping from token ID to ownership details
624     // An empty struct value does not necessarily mean the token is unowned.
625     // See {_packedOwnershipOf} implementation for details.
626     //
627     // Bits Layout:
628     // - [0..159]   `addr`
629     // - [160..223] `startTimestamp`
630     // - [224]      `burned`
631     // - [225]      `nextInitialized`
632     // - [232..255] `extraData`
633     mapping(uint256 => uint256) private _packedOwnerships;
634 
635     // Mapping owner address to address data.
636     //
637     // Bits Layout:
638     // - [0..63]    `balance`
639     // - [64..127]  `numberMinted`
640     // - [128..191] `numberBurned`
641     // - [192..255] `aux`
642     mapping(address => uint256) private _packedAddressData;
643 
644     // Mapping from token ID to approved address.
645     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
646 
647     // Mapping from owner to operator approvals
648     mapping(address => mapping(address => bool)) private _operatorApprovals;
649 
650     // =============================================================
651     //                          CONSTRUCTOR
652     // =============================================================
653 
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657         _currentIndex = _startTokenId();
658     }
659 
660     // =============================================================
661     //                   TOKEN COUNTING OPERATIONS
662     // =============================================================
663 
664     /**
665      * @dev Returns the starting token ID.
666      * To change the starting token ID, please override this function.
667      */
668     function _startTokenId() internal view virtual returns (uint256) {
669         return 0;
670     }
671 
672     /**
673      * @dev Returns the next token ID to be minted.
674      */
675     function _nextTokenId() internal view virtual returns (uint256) {
676         return _currentIndex;
677     }
678 
679     /**
680      * @dev Returns the total number of tokens in existence.
681      * Burned tokens will reduce the count.
682      * To get the total number of tokens minted, please see {_totalMinted}.
683      */
684     function totalSupply() public view virtual override returns (uint256) {
685         // Counter underflow is impossible as _burnCounter cannot be incremented
686         // more than `_currentIndex - _startTokenId()` times.
687         unchecked {
688             return _currentIndex - _burnCounter - _startTokenId();
689         }
690     }
691 
692     /**
693      * @dev Returns the total amount of tokens minted in the contract.
694      */
695     function _totalMinted() internal view virtual returns (uint256) {
696         // Counter underflow is impossible as `_currentIndex` does not decrement,
697         // and it is initialized to `_startTokenId()`.
698         unchecked {
699             return _currentIndex - _startTokenId();
700         }
701     }
702 
703     /**
704      * @dev Returns the total number of tokens burned.
705      */
706     function _totalBurned() internal view virtual returns (uint256) {
707         return _burnCounter;
708     }
709 
710     // =============================================================
711     //                    ADDRESS DATA OPERATIONS
712     // =============================================================
713 
714     /**
715      * @dev Returns the number of tokens in `owner`'s account.
716      */
717     function balanceOf(address owner) public view virtual override returns (uint256) {
718         if (owner == address(0)) revert BalanceQueryForZeroAddress();
719         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
720     }
721 
722     /**
723      * Returns the number of tokens minted by `owner`.
724      */
725     function _numberMinted(address owner) internal view returns (uint256) {
726         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
727     }
728 
729     /**
730      * Returns the number of tokens burned by or on behalf of `owner`.
731      */
732     function _numberBurned(address owner) internal view returns (uint256) {
733         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
734     }
735 
736     /**
737      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
738      */
739     function _getAux(address owner) internal view returns (uint64) {
740         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
741     }
742 
743     /**
744      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
745      * If there are multiple variables, please pack them into a uint64.
746      */
747     function _setAux(address owner, uint64 aux) internal virtual {
748         uint256 packed = _packedAddressData[owner];
749         uint256 auxCasted;
750         // Cast `aux` with assembly to avoid redundant masking.
751         assembly {
752             auxCasted := aux
753         }
754         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
755         _packedAddressData[owner] = packed;
756     }
757 
758     // =============================================================
759     //                            IERC165
760     // =============================================================
761 
762     /**
763      * @dev Returns true if this contract implements the interface defined by
764      * `interfaceId`. See the corresponding
765      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
766      * to learn more about how these ids are created.
767      *
768      * This function call must use less than 30000 gas.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
771         // The interface IDs are constants representing the first 4 bytes
772         // of the XOR of all function selectors in the interface.
773         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
774         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
775         return
776             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
777             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
778             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
779     }
780 
781     // =============================================================
782     //                        IERC721Metadata
783     // =============================================================
784 
785     /**
786      * @dev Returns the token collection name.
787      */
788     function name() public view virtual override returns (string memory) {
789         return _name;
790     }
791 
792     /**
793      * @dev Returns the token collection symbol.
794      */
795     function symbol() public view virtual override returns (string memory) {
796         return _symbol;
797     }
798 
799     /**
800      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
801      */
802     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
803         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
804 
805         string memory baseURI = _baseURI();
806         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
807     }
808 
809     /**
810      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
811      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
812      * by default, it can be overridden in child contracts.
813      */
814     function _baseURI() internal view virtual returns (string memory) {
815         return '';
816     }
817 
818     // =============================================================
819     //                     OWNERSHIPS OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Returns the owner of the `tokenId` token.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
830         return address(uint160(_packedOwnershipOf(tokenId)));
831     }
832 
833     /**
834      * @dev Gas spent here starts off proportional to the maximum mint batch size.
835      * It gradually moves to O(1) as tokens get transferred around over time.
836      */
837     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
838         return _unpackedOwnership(_packedOwnershipOf(tokenId));
839     }
840 
841     /**
842      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
843      */
844     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
845         return _unpackedOwnership(_packedOwnerships[index]);
846     }
847 
848     /**
849      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
850      */
851     function _initializeOwnershipAt(uint256 index) internal virtual {
852         if (_packedOwnerships[index] == 0) {
853             _packedOwnerships[index] = _packedOwnershipOf(index);
854         }
855     }
856 
857     /**
858      * Returns the packed ownership data of `tokenId`.
859      */
860     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
861         uint256 curr = tokenId;
862 
863         unchecked {
864             if (_startTokenId() <= curr)
865                 if (curr < _currentIndex) {
866                     uint256 packed = _packedOwnerships[curr];
867                     // If not burned.
868                     if (packed & _BITMASK_BURNED == 0) {
869                         // Invariant:
870                         // There will always be an initialized ownership slot
871                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
872                         // before an unintialized ownership slot
873                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
874                         // Hence, `curr` will not underflow.
875                         //
876                         // We can directly compare the packed value.
877                         // If the address is zero, packed will be zero.
878                         while (packed == 0) {
879                             packed = _packedOwnerships[--curr];
880                         }
881                         return packed;
882                     }
883                 }
884         }
885         revert OwnerQueryForNonexistentToken();
886     }
887 
888     /**
889      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
890      */
891     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
892         ownership.addr = address(uint160(packed));
893         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
894         ownership.burned = packed & _BITMASK_BURNED != 0;
895         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
896     }
897 
898     /**
899      * @dev Packs ownership data into a single uint256.
900      */
901     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
902         assembly {
903             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
904             owner := and(owner, _BITMASK_ADDRESS)
905             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
906             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
907         }
908     }
909 
910     /**
911      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
912      */
913     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
914         // For branchless setting of the `nextInitialized` flag.
915         assembly {
916             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
917             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
918         }
919     }
920 
921     // =============================================================
922     //                      APPROVAL OPERATIONS
923     // =============================================================
924 
925     /**
926      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
927      * The approval is cleared when the token is transferred.
928      *
929      * Only a single account can be approved at a time, so approving the
930      * zero address clears previous approvals.
931      *
932      * Requirements:
933      *
934      * - The caller must own the token or be an approved operator.
935      * - `tokenId` must exist.
936      *
937      * Emits an {Approval} event.
938      */
939     function approve(address to, uint256 tokenId) public virtual override {
940         address owner = ownerOf(tokenId);
941 
942         if (_msgSenderERC721A() != owner)
943             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
944                 revert ApprovalCallerNotOwnerNorApproved();
945             }
946 
947         _tokenApprovals[tokenId].value = to;
948         emit Approval(owner, to, tokenId);
949     }
950 
951     /**
952      * @dev Returns the account approved for `tokenId` token.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function getApproved(uint256 tokenId) public view virtual override returns (address) {
959         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
960 
961         return _tokenApprovals[tokenId].value;
962     }
963 
964     /**
965      * @dev Approve or remove `operator` as an operator for the caller.
966      * Operators can call {transferFrom} or {safeTransferFrom}
967      * for any token owned by the caller.
968      *
969      * Requirements:
970      *
971      * - The `operator` cannot be the caller.
972      *
973      * Emits an {ApprovalForAll} event.
974      */
975     function setApprovalForAll(address operator, bool approved) public virtual override {
976         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
977 
978         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
979         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
980     }
981 
982     /**
983      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
984      *
985      * See {setApprovalForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev Returns whether `tokenId` exists.
993      *
994      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
995      *
996      * Tokens start existing when they are minted. See {_mint}.
997      */
998     function _exists(uint256 tokenId) internal view virtual returns (bool) {
999         return
1000             _startTokenId() <= tokenId &&
1001             tokenId < _currentIndex && // If within bounds,
1002             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1003     }
1004 
1005     /**
1006      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1007      */
1008     function _isSenderApprovedOrOwner(
1009         address approvedAddress,
1010         address owner,
1011         address msgSender
1012     ) private pure returns (bool result) {
1013         assembly {
1014             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1015             owner := and(owner, _BITMASK_ADDRESS)
1016             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1017             msgSender := and(msgSender, _BITMASK_ADDRESS)
1018             // `msgSender == owner || msgSender == approvedAddress`.
1019             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1025      */
1026     function _getApprovedSlotAndAddress(uint256 tokenId)
1027         private
1028         view
1029         returns (uint256 approvedAddressSlot, address approvedAddress)
1030     {
1031         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1032         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1033         assembly {
1034             approvedAddressSlot := tokenApproval.slot
1035             approvedAddress := sload(approvedAddressSlot)
1036         }
1037     }
1038 
1039     // =============================================================
1040     //                      TRANSFER OPERATIONS
1041     // =============================================================
1042 
1043     /**
1044      * @dev Transfers `tokenId` from `from` to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      * - If the caller is not `from`, it must be approved to move this token
1052      * by either {approve} or {setApprovalForAll}.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1062 
1063         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1064 
1065         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1066 
1067         // The nested ifs save around 20+ gas over a compound boolean condition.
1068         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1069             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1070 
1071         if (to == address(0)) revert TransferToZeroAddress();
1072 
1073         _beforeTokenTransfers(from, to, tokenId, 1);
1074 
1075         // Clear approvals from the previous owner.
1076         assembly {
1077             if approvedAddress {
1078                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1079                 sstore(approvedAddressSlot, 0)
1080             }
1081         }
1082 
1083         // Underflow of the sender's balance is impossible because we check for
1084         // ownership above and the recipient's balance can't realistically overflow.
1085         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1086         unchecked {
1087             // We can directly increment and decrement the balances.
1088             --_packedAddressData[from]; // Updates: `balance -= 1`.
1089             ++_packedAddressData[to]; // Updates: `balance += 1`.
1090 
1091             // Updates:
1092             // - `address` to the next owner.
1093             // - `startTimestamp` to the timestamp of transfering.
1094             // - `burned` to `false`.
1095             // - `nextInitialized` to `true`.
1096             _packedOwnerships[tokenId] = _packOwnershipData(
1097                 to,
1098                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1099             );
1100 
1101             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1102             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1103                 uint256 nextTokenId = tokenId + 1;
1104                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1105                 if (_packedOwnerships[nextTokenId] == 0) {
1106                     // If the next slot is within bounds.
1107                     if (nextTokenId != _currentIndex) {
1108                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1109                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1110                     }
1111                 }
1112             }
1113         }
1114 
1115         emit Transfer(from, to, tokenId);
1116         _afterTokenTransfers(from, to, tokenId, 1);
1117     }
1118 
1119     /**
1120      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1121      */
1122     function safeTransferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) public virtual override {
1127         safeTransferFrom(from, to, tokenId, '');
1128     }
1129 
1130     /**
1131      * @dev Safely transfers `tokenId` token from `from` to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must exist and be owned by `from`.
1138      * - If the caller is not `from`, it must be approved to move this token
1139      * by either {approve} or {setApprovalForAll}.
1140      * - If `to` refers to a smart contract, it must implement
1141      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function safeTransferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) public virtual override {
1151         transferFrom(from, to, tokenId);
1152         if (to.code.length != 0)
1153             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1154                 revert TransferToNonERC721ReceiverImplementer();
1155             }
1156     }
1157 
1158     /**
1159      * @dev Hook that is called before a set of serially-ordered token IDs
1160      * are about to be transferred. This includes minting.
1161      * And also called before burning one token.
1162      *
1163      * `startTokenId` - the first token ID to be transferred.
1164      * `quantity` - the amount to be transferred.
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, `tokenId` will be burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _beforeTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     /**
1182      * @dev Hook that is called after a set of serially-ordered token IDs
1183      * have been transferred. This includes minting.
1184      * And also called after one token has been burned.
1185      *
1186      * `startTokenId` - the first token ID to be transferred.
1187      * `quantity` - the amount to be transferred.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` has been minted for `to`.
1194      * - When `to` is zero, `tokenId` has been burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _afterTokenTransfers(
1198         address from,
1199         address to,
1200         uint256 startTokenId,
1201         uint256 quantity
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1206      *
1207      * `from` - Previous owner of the given token ID.
1208      * `to` - Target address that will receive the token.
1209      * `tokenId` - Token ID to be transferred.
1210      * `_data` - Optional data to send along with the call.
1211      *
1212      * Returns whether the call correctly returned the expected magic value.
1213      */
1214     function _checkContractOnERC721Received(
1215         address from,
1216         address to,
1217         uint256 tokenId,
1218         bytes memory _data
1219     ) private returns (bool) {
1220         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1221             bytes4 retval
1222         ) {
1223             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1224         } catch (bytes memory reason) {
1225             if (reason.length == 0) {
1226                 revert TransferToNonERC721ReceiverImplementer();
1227             } else {
1228                 assembly {
1229                     revert(add(32, reason), mload(reason))
1230                 }
1231             }
1232         }
1233     }
1234 
1235     // =============================================================
1236     //                        MINT OPERATIONS
1237     // =============================================================
1238 
1239     /**
1240      * @dev Mints `quantity` tokens and transfers them to `to`.
1241      *
1242      * Requirements:
1243      *
1244      * - `to` cannot be the zero address.
1245      * - `quantity` must be greater than 0.
1246      *
1247      * Emits a {Transfer} event for each mint.
1248      */
1249     function _mint(address to, uint256 quantity) internal virtual {
1250         uint256 startTokenId = _currentIndex;
1251         if (quantity == 0) revert MintZeroQuantity();
1252 
1253         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1254 
1255         // Overflows are incredibly unrealistic.
1256         // `balance` and `numberMinted` have a maximum limit of 2**64.
1257         // `tokenId` has a maximum limit of 2**256.
1258         unchecked {
1259             // Updates:
1260             // - `balance += quantity`.
1261             // - `numberMinted += quantity`.
1262             //
1263             // We can directly add to the `balance` and `numberMinted`.
1264             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1265 
1266             // Updates:
1267             // - `address` to the owner.
1268             // - `startTimestamp` to the timestamp of minting.
1269             // - `burned` to `false`.
1270             // - `nextInitialized` to `quantity == 1`.
1271             _packedOwnerships[startTokenId] = _packOwnershipData(
1272                 to,
1273                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1274             );
1275 
1276             uint256 toMasked;
1277             uint256 end = startTokenId + quantity;
1278 
1279             // Use assembly to loop and emit the `Transfer` event for gas savings.
1280             assembly {
1281                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1282                 toMasked := and(to, _BITMASK_ADDRESS)
1283                 // Emit the `Transfer` event.
1284                 log4(
1285                     0, // Start of data (0, since no data).
1286                     0, // End of data (0, since no data).
1287                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1288                     0, // `address(0)`.
1289                     toMasked, // `to`.
1290                     startTokenId // `tokenId`.
1291                 )
1292 
1293                 for {
1294                     let tokenId := add(startTokenId, 1)
1295                 } iszero(eq(tokenId, end)) {
1296                     tokenId := add(tokenId, 1)
1297                 } {
1298                     // Emit the `Transfer` event. Similar to above.
1299                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1300                 }
1301             }
1302             if (toMasked == 0) revert MintToZeroAddress();
1303 
1304             _currentIndex = end;
1305         }
1306         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1307     }
1308 
1309     /**
1310      * @dev Mints `quantity` tokens and transfers them to `to`.
1311      *
1312      * This function is intended for efficient minting only during contract creation.
1313      *
1314      * It emits only one {ConsecutiveTransfer} as defined in
1315      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1316      * instead of a sequence of {Transfer} event(s).
1317      *
1318      * Calling this function outside of contract creation WILL make your contract
1319      * non-compliant with the ERC721 standard.
1320      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1321      * {ConsecutiveTransfer} event is only permissible during contract creation.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `quantity` must be greater than 0.
1327      *
1328      * Emits a {ConsecutiveTransfer} event.
1329      */
1330     function _mintERC2309(address to, uint256 quantity) internal virtual {
1331         uint256 startTokenId = _currentIndex;
1332         if (to == address(0)) revert MintToZeroAddress();
1333         if (quantity == 0) revert MintZeroQuantity();
1334         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1335 
1336         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1337 
1338         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1339         unchecked {
1340             // Updates:
1341             // - `balance += quantity`.
1342             // - `numberMinted += quantity`.
1343             //
1344             // We can directly add to the `balance` and `numberMinted`.
1345             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1346 
1347             // Updates:
1348             // - `address` to the owner.
1349             // - `startTimestamp` to the timestamp of minting.
1350             // - `burned` to `false`.
1351             // - `nextInitialized` to `quantity == 1`.
1352             _packedOwnerships[startTokenId] = _packOwnershipData(
1353                 to,
1354                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1355             );
1356 
1357             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1358 
1359             _currentIndex = startTokenId + quantity;
1360         }
1361         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1362     }
1363 
1364     /**
1365      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1366      *
1367      * Requirements:
1368      *
1369      * - If `to` refers to a smart contract, it must implement
1370      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1371      * - `quantity` must be greater than 0.
1372      *
1373      * See {_mint}.
1374      *
1375      * Emits a {Transfer} event for each mint.
1376      */
1377     function _safeMint(
1378         address to,
1379         uint256 quantity,
1380         bytes memory _data
1381     ) internal virtual {
1382         _mint(to, quantity);
1383 
1384         unchecked {
1385             if (to.code.length != 0) {
1386                 uint256 end = _currentIndex;
1387                 uint256 index = end - quantity;
1388                 do {
1389                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1390                         revert TransferToNonERC721ReceiverImplementer();
1391                     }
1392                 } while (index < end);
1393                 // Reentrancy protection.
1394                 if (_currentIndex != end) revert();
1395             }
1396         }
1397     }
1398 
1399     /**
1400      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1401      */
1402     function _safeMint(address to, uint256 quantity) internal virtual {
1403         _safeMint(to, quantity, '');
1404     }
1405 
1406     // =============================================================
1407     //                        BURN OPERATIONS
1408     // =============================================================
1409 
1410     /**
1411      * @dev Equivalent to `_burn(tokenId, false)`.
1412      */
1413     function _burn(uint256 tokenId) internal virtual {
1414         _burn(tokenId, false);
1415     }
1416 
1417     /**
1418      * @dev Destroys `tokenId`.
1419      * The approval is cleared when the token is burned.
1420      *
1421      * Requirements:
1422      *
1423      * - `tokenId` must exist.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1428         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1429 
1430         address from = address(uint160(prevOwnershipPacked));
1431 
1432         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1433 
1434         if (approvalCheck) {
1435             // The nested ifs save around 20+ gas over a compound boolean condition.
1436             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1437                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1438         }
1439 
1440         _beforeTokenTransfers(from, address(0), tokenId, 1);
1441 
1442         // Clear approvals from the previous owner.
1443         assembly {
1444             if approvedAddress {
1445                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1446                 sstore(approvedAddressSlot, 0)
1447             }
1448         }
1449 
1450         // Underflow of the sender's balance is impossible because we check for
1451         // ownership above and the recipient's balance can't realistically overflow.
1452         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1453         unchecked {
1454             // Updates:
1455             // - `balance -= 1`.
1456             // - `numberBurned += 1`.
1457             //
1458             // We can directly decrement the balance, and increment the number burned.
1459             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1460             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1461 
1462             // Updates:
1463             // - `address` to the last owner.
1464             // - `startTimestamp` to the timestamp of burning.
1465             // - `burned` to `true`.
1466             // - `nextInitialized` to `true`.
1467             _packedOwnerships[tokenId] = _packOwnershipData(
1468                 from,
1469                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1470             );
1471 
1472             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1473             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1474                 uint256 nextTokenId = tokenId + 1;
1475                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1476                 if (_packedOwnerships[nextTokenId] == 0) {
1477                     // If the next slot is within bounds.
1478                     if (nextTokenId != _currentIndex) {
1479                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1480                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1481                     }
1482                 }
1483             }
1484         }
1485 
1486         emit Transfer(from, address(0), tokenId);
1487         _afterTokenTransfers(from, address(0), tokenId, 1);
1488 
1489         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1490         unchecked {
1491             _burnCounter++;
1492         }
1493     }
1494 
1495     // =============================================================
1496     //                     EXTRA DATA OPERATIONS
1497     // =============================================================
1498 
1499     /**
1500      * @dev Directly sets the extra data for the ownership data `index`.
1501      */
1502     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1503         uint256 packed = _packedOwnerships[index];
1504         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1505         uint256 extraDataCasted;
1506         // Cast `extraData` with assembly to avoid redundant masking.
1507         assembly {
1508             extraDataCasted := extraData
1509         }
1510         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1511         _packedOwnerships[index] = packed;
1512     }
1513 
1514     /**
1515      * @dev Called during each token transfer to set the 24bit `extraData` field.
1516      * Intended to be overridden by the cosumer contract.
1517      *
1518      * `previousExtraData` - the value of `extraData` before transfer.
1519      *
1520      * Calling conditions:
1521      *
1522      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1523      * transferred to `to`.
1524      * - When `from` is zero, `tokenId` will be minted for `to`.
1525      * - When `to` is zero, `tokenId` will be burned by `from`.
1526      * - `from` and `to` are never both zero.
1527      */
1528     function _extraData(
1529         address from,
1530         address to,
1531         uint24 previousExtraData
1532     ) internal view virtual returns (uint24) {}
1533 
1534     /**
1535      * @dev Returns the next extra data for the packed ownership data.
1536      * The returned result is shifted into position.
1537      */
1538     function _nextExtraData(
1539         address from,
1540         address to,
1541         uint256 prevOwnershipPacked
1542     ) private view returns (uint256) {
1543         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1544         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1545     }
1546 
1547     // =============================================================
1548     //                       OTHER OPERATIONS
1549     // =============================================================
1550 
1551     /**
1552      * @dev Returns the message sender (defaults to `msg.sender`).
1553      *
1554      * If you are writing GSN compatible contracts, you need to override this function.
1555      */
1556     function _msgSenderERC721A() internal view virtual returns (address) {
1557         return msg.sender;
1558     }
1559 
1560     /**
1561      * @dev Converts a uint256 to its ASCII string decimal representation.
1562      */
1563     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1564         assembly {
1565             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1566             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1567             // We will need 1 32-byte word to store the length,
1568             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1569             str := add(mload(0x40), 0x80)
1570             // Update the free memory pointer to allocate.
1571             mstore(0x40, str)
1572 
1573             // Cache the end of the memory to calculate the length later.
1574             let end := str
1575 
1576             // We write the string from rightmost digit to leftmost digit.
1577             // The following is essentially a do-while loop that also handles the zero case.
1578             // prettier-ignore
1579             for { let temp := value } 1 {} {
1580                 str := sub(str, 1)
1581                 // Write the character to the pointer.
1582                 // The ASCII index of the '0' character is 48.
1583                 mstore8(str, add(48, mod(temp, 10)))
1584                 // Keep dividing `temp` until zero.
1585                 temp := div(temp, 10)
1586                 // prettier-ignore
1587                 if iszero(temp) { break }
1588             }
1589 
1590             let length := sub(end, str)
1591             // Move the pointer 32 bytes leftwards to make room for the length.
1592             str := sub(str, 0x20)
1593             // Store the length.
1594             mstore(str, length)
1595         }
1596     }
1597 }
1598 
1599 // File: contracts/undergroundCult.sol
1600 
1601 pragma solidity ^0.8.4;
1602 
1603 contract UndergroundCult is ERC721A, Ownable {
1604 
1605     using Strings for uint256;
1606 
1607     string public baseURI = "ipfs://bafybeicmqnpws4kczxcinobzevqzz7e5bu5bmidbkp7pcuy56gpyspyulu/json/";
1608 
1609     uint256 public price = 0.00666 ether;
1610     uint256 public maxPerTx = 6;
1611     uint256 public maxSupply = 6666;
1612 
1613     uint256 public maxFreePerWallet = 1;
1614     uint256 public totalFreeMinted = 0;
1615     uint256 public maxFreeSupply = 6000;
1616 
1617     mapping(address => uint256) public _mintedFreeAmount;
1618 
1619     constructor() ERC721A("Underground Cult", "UGC") {}
1620 
1621     function mint(uint256 _amount) external payable {
1622 
1623         require(msg.value >= _amount * price, "Incorrect amount of ETH.");
1624         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1625         require(tx.origin == msg.sender, "Only humans please.");
1626         require(_amount <= maxPerTx, "You may only mint a max of 10 per transaction");
1627 
1628         _mint(msg.sender, _amount);
1629     }
1630 
1631     function mintFree(uint256 _amount) external payable {
1632         require(_mintedFreeAmount[msg.sender] + _amount <= maxFreePerWallet, "You have minted the max free amount allowed per wallet.");
1633 		require(totalFreeMinted + _amount <= maxFreeSupply, "Cannot exceed Free supply." );
1634         require(totalSupply() + _amount <= maxSupply, "Sold out.");
1635 
1636         _mintedFreeAmount[msg.sender]++;
1637         totalFreeMinted++;
1638         _safeMint(msg.sender, _amount);
1639 	}
1640 
1641     function tokenURI(uint256 tokenId)
1642         public view virtual override returns (string memory) {
1643         require(
1644             _exists(tokenId),
1645             "ERC721Metadata: URI query for nonexistent token"
1646         );
1647         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1648     }
1649 
1650     function setBaseURI(string calldata baseURI_) external onlyOwner {
1651         baseURI = baseURI_;
1652     }
1653 
1654     function setPrice(uint256 _price) external onlyOwner {
1655         price = _price;
1656     }
1657 
1658     function setMaxPerTx(uint256 _amount) external onlyOwner {
1659         maxPerTx = _amount;
1660     }
1661 
1662     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1663         require(_newMaxFreeSupply <= maxSupply);
1664         maxFreeSupply = _newMaxFreeSupply;
1665     }
1666 
1667     function _startTokenId() internal pure override returns (uint256) {
1668         return 1;
1669     }
1670 
1671     function withdraw() external onlyOwner {
1672         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1673         require(success, "Transfer failed.");
1674     }
1675 
1676 }