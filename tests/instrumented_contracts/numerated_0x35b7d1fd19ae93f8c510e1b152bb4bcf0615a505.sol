1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5 
6       /$$$$$$   /$$$$$$  /$$      /$$
7      /$$__  $$ /$$__  $$| $$$    /$$$
8     |__/  \ $$| $$  \__/| $$$$  /$$$$
9        /$$$$$/| $$ /$$$$| $$ $$/$$ $$
10       |___  $$| $$|_  $$| $$  $$$| $$
11      /$$  \ $$| $$  \ $$| $$\  $ | $$
12     |  $$$$$$/|  $$$$$$/| $$ \/  | $$
13     \______/  \______/ |__/     |__/
14 
15 
16     ** Website
17        https://3gm.dev/
18 
19     ** Twitter
20        https://twitter.com/3gmdev
21 
22 **/
23 
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
26 
27 
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34     uint8 private constant _ADDRESS_LENGTH = 20;
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
38      */
39     function toString(uint256 value) internal pure returns (string memory) {
40         // Inspired by OraclizeAPI's implementation - MIT licence
41         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
42 
43         if (value == 0) {
44             return "0";
45         }
46         uint256 temp = value;
47         uint256 digits;
48         while (temp != 0) {
49             digits++;
50             temp /= 10;
51         }
52         bytes memory buffer = new bytes(digits);
53         while (value != 0) {
54             digits -= 1;
55             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
56             value /= 10;
57         }
58         return string(buffer);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
63      */
64     function toHexString(uint256 value) internal pure returns (string memory) {
65         if (value == 0) {
66             return "0x00";
67         }
68         uint256 temp = value;
69         uint256 length = 0;
70         while (temp != 0) {
71             length++;
72             temp >>= 8;
73         }
74         return toHexString(value, length);
75     }
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
79      */
80     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
81         bytes memory buffer = new bytes(2 * length + 2);
82         buffer[0] = "0";
83         buffer[1] = "x";
84         for (uint256 i = 2 * length + 1; i > 1; --i) {
85             buffer[i] = _HEX_SYMBOLS[value & 0xf];
86             value >>= 4;
87         }
88         require(value == 0, "Strings: hex length insufficient");
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
94      */
95     function toHexString(address addr) internal pure returns (string memory) {
96         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
97     }
98 }
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
107 
108 
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 
131 /**
132  * @dev Contract module which provides a basic access control mechanism, where
133  * there is an account (an owner) that can be granted exclusive access to
134  * specific functions.
135  *
136  * By default, the owner account will be the one that deploys the contract. This
137  * can later be changed with {transferOwnership}.
138  *
139  * This module is used through inheritance. It will make available the modifier
140  * `onlyOwner`, which can be applied to your functions to restrict their use to
141  * the owner.
142  */
143 abstract contract Ownable is Context {
144     address private _owner;
145 
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     /**
149      * @dev Initializes the contract setting the deployer as the initial owner.
150      */
151     constructor() {
152         _transferOwnership(_msgSender());
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * NOTE: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public virtual onlyOwner {
178         _transferOwnership(address(0));
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         _transferOwnership(newOwner);
188     }
189 
190     /**
191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
192      * Internal function without access restriction.
193      */
194     function _transferOwnership(address newOwner) internal virtual {
195         address oldOwner = _owner;
196         _owner = newOwner;
197         emit OwnershipTransferred(oldOwner, newOwner);
198     }
199 }
200 
201 
202 // ERC721A Contracts v4.1.0
203 // Creator: Chiru Labs
204 
205 
206 
207 
208 // ERC721A Contracts v4.1.0
209 // Creator: Chiru Labs
210 
211 
212 
213 /**
214  * @dev Interface of an ERC721A compliant contract.
215  */
216 interface IERC721A {
217     /**
218      * The caller must own the token or be an approved operator.
219      */
220     error ApprovalCallerNotOwnerNorApproved();
221 
222     /**
223      * The token does not exist.
224      */
225     error ApprovalQueryForNonexistentToken();
226 
227     /**
228      * The caller cannot approve to their own address.
229      */
230     error ApproveToCaller();
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
263      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
264      */
265     error TransferToNonERC721ReceiverImplementer();
266 
267     /**
268      * Cannot transfer to the zero address.
269      */
270     error TransferToZeroAddress();
271 
272     /**
273      * The token does not exist.
274      */
275     error URIQueryForNonexistentToken();
276 
277     /**
278      * The `quantity` minted with ERC2309 exceeds the safety limit.
279      */
280     error MintERC2309QuantityExceedsLimit();
281 
282     /**
283      * The `extraData` cannot be set on an unintialized ownership slot.
284      */
285     error OwnershipNotInitializedForExtraData();
286 
287     struct TokenOwnership {
288         // The address of the owner.
289         address addr;
290         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
291         uint64 startTimestamp;
292         // Whether the token has been burned.
293         bool burned;
294         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
295         uint24 extraData;
296     }
297 
298     /**
299      * @dev Returns the total amount of tokens stored by the contract.
300      *
301      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
302      */
303     function totalSupply() external view returns (uint256);
304 
305     // ==============================
306     //            IERC165
307     // ==============================
308 
309     /**
310      * @dev Returns true if this contract implements the interface defined by
311      * `interfaceId`. See the corresponding
312      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
313      * to learn more about how these ids are created.
314      *
315      * This function call must use less than 30 000 gas.
316      */
317     function supportsInterface(bytes4 interfaceId) external view returns (bool);
318 
319     // ==============================
320     //            IERC721
321     // ==============================
322 
323     /**
324      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
327 
328     /**
329      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
330      */
331     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
332 
333     /**
334      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
335      */
336     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
337 
338     /**
339      * @dev Returns the number of tokens in ``owner``'s account.
340      */
341     function balanceOf(address owner) external view returns (uint256 balance);
342 
343     /**
344      * @dev Returns the owner of the `tokenId` token.
345      *
346      * Requirements:
347      *
348      * - `tokenId` must exist.
349      */
350     function ownerOf(uint256 tokenId) external view returns (address owner);
351 
352     /**
353      * @dev Safely transfers `tokenId` token from `from` to `to`.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId,
369         bytes calldata data
370     ) external;
371 
372     /**
373      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must exist and be owned by `from`.
381      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers `tokenId` token from `from` to `to`.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
396      *
397      * Requirements:
398      *
399      * - `from` cannot be the zero address.
400      * - `to` cannot be the zero address.
401      * - `tokenId` token must be owned by `from`.
402      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 tokenId
410     ) external;
411 
412     /**
413      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - `tokenId` must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Approve or remove `operator` as an operator for the caller.
429      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
430      *
431      * Requirements:
432      *
433      * - The `operator` cannot be the caller.
434      *
435      * Emits an {ApprovalForAll} event.
436      */
437     function setApprovalForAll(address operator, bool _approved) external;
438 
439     /**
440      * @dev Returns the account approved for `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function getApproved(uint256 tokenId) external view returns (address operator);
447 
448     /**
449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     // ==============================
456     //        IERC721Metadata
457     // ==============================
458 
459     /**
460      * @dev Returns the token collection name.
461      */
462     function name() external view returns (string memory);
463 
464     /**
465      * @dev Returns the token collection symbol.
466      */
467     function symbol() external view returns (string memory);
468 
469     /**
470      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
471      */
472     function tokenURI(uint256 tokenId) external view returns (string memory);
473 
474     // ==============================
475     //            IERC2309
476     // ==============================
477 
478     /**
479      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
480      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
481      */
482     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
483 }
484 
485 
486 /**
487  * @dev ERC721 token receiver interface.
488  */
489 interface ERC721A__IERC721Receiver {
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 /**
499  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
500  * including the Metadata extension. Built to optimize for lower gas during batch mints.
501  *
502  * Assumes serials are sequentially minted starting at `_startTokenId()`
503  * (defaults to 0, e.g. 0, 1, 2, 3..).
504  *
505  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
506  *
507  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
508  */
509 contract ERC721A is IERC721A {
510     // Mask of an entry in packed address data.
511     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
512 
513     // The bit position of `numberMinted` in packed address data.
514     uint256 private constant BITPOS_NUMBER_MINTED = 64;
515 
516     // The bit position of `numberBurned` in packed address data.
517     uint256 private constant BITPOS_NUMBER_BURNED = 128;
518 
519     // The bit position of `aux` in packed address data.
520     uint256 private constant BITPOS_AUX = 192;
521 
522     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
523     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
524 
525     // The bit position of `startTimestamp` in packed ownership.
526     uint256 private constant BITPOS_START_TIMESTAMP = 160;
527 
528     // The bit mask of the `burned` bit in packed ownership.
529     uint256 private constant BITMASK_BURNED = 1 << 224;
530 
531     // The bit position of the `nextInitialized` bit in packed ownership.
532     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
533 
534     // The bit mask of the `nextInitialized` bit in packed ownership.
535     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
536 
537     // The bit position of `extraData` in packed ownership.
538     uint256 private constant BITPOS_EXTRA_DATA = 232;
539 
540     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
541     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
542 
543     // The mask of the lower 160 bits for addresses.
544     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
545 
546     // The maximum `quantity` that can be minted with `_mintERC2309`.
547     // This limit is to prevent overflows on the address data entries.
548     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
549     // is required to cause an overflow, which is unrealistic.
550     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
551 
552     // The tokenId of the next token to be minted.
553     uint256 private _currentIndex;
554 
555     // The number of tokens burned.
556     uint256 private _burnCounter;
557 
558     // Token name
559     string private _name;
560 
561     // Token symbol
562     string private _symbol;
563 
564     // Mapping from token ID to ownership details
565     // An empty struct value does not necessarily mean the token is unowned.
566     // See `_packedOwnershipOf` implementation for details.
567     //
568     // Bits Layout:
569     // - [0..159]   `addr`
570     // - [160..223] `startTimestamp`
571     // - [224]      `burned`
572     // - [225]      `nextInitialized`
573     // - [232..255] `extraData`
574     mapping(uint256 => uint256) private _packedOwnerships;
575 
576     // Mapping owner address to address data.
577     //
578     // Bits Layout:
579     // - [0..63]    `balance`
580     // - [64..127]  `numberMinted`
581     // - [128..191] `numberBurned`
582     // - [192..255] `aux`
583     mapping(address => uint256) private _packedAddressData;
584 
585     // Mapping from token ID to approved address.
586     mapping(uint256 => address) private _tokenApprovals;
587 
588     // Mapping from owner to operator approvals
589     mapping(address => mapping(address => bool)) private _operatorApprovals;
590 
591     constructor(string memory name_, string memory symbol_) {
592         _name = name_;
593         _symbol = symbol_;
594         _currentIndex = _startTokenId();
595     }
596 
597     /**
598      * @dev Returns the starting token ID.
599      * To change the starting token ID, please override this function.
600      */
601     function _startTokenId() internal view virtual returns (uint256) {
602         return 0;
603     }
604 
605     /**
606      * @dev Returns the next token ID to be minted.
607      */
608     function _nextTokenId() internal view returns (uint256) {
609         return _currentIndex;
610     }
611 
612     /**
613      * @dev Returns the total number of tokens in existence.
614      * Burned tokens will reduce the count.
615      * To get the total number of tokens minted, please see `_totalMinted`.
616      */
617     function totalSupply() public view override returns (uint256) {
618         // Counter underflow is impossible as _burnCounter cannot be incremented
619         // more than `_currentIndex - _startTokenId()` times.
620         unchecked {
621             return _currentIndex - _burnCounter - _startTokenId();
622         }
623     }
624 
625     /**
626      * @dev Returns the total amount of tokens minted in the contract.
627      */
628     function _totalMinted() internal view returns (uint256) {
629         // Counter underflow is impossible as _currentIndex does not decrement,
630         // and it is initialized to `_startTokenId()`
631         unchecked {
632             return _currentIndex - _startTokenId();
633         }
634     }
635 
636     /**
637      * @dev Returns the total number of tokens burned.
638      */
639     function _totalBurned() internal view returns (uint256) {
640         return _burnCounter;
641     }
642 
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647         // The interface IDs are constants representing the first 4 bytes of the XOR of
648         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
649         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
650         return
651             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
652             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
653             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
654     }
655 
656     /**
657      * @dev See {IERC721-balanceOf}.
658      */
659     function balanceOf(address owner) public view override returns (uint256) {
660         if (owner == address(0)) revert BalanceQueryForZeroAddress();
661         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
662     }
663 
664     /**
665      * Returns the number of tokens minted by `owner`.
666      */
667     function _numberMinted(address owner) internal view returns (uint256) {
668         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
669     }
670 
671     /**
672      * Returns the number of tokens burned by or on behalf of `owner`.
673      */
674     function _numberBurned(address owner) internal view returns (uint256) {
675         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
676     }
677 
678     /**
679      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
680      */
681     function _getAux(address owner) internal view returns (uint64) {
682         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
683     }
684 
685     /**
686      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
687      * If there are multiple variables, please pack them into a uint64.
688      */
689     function _setAux(address owner, uint64 aux) internal {
690         uint256 packed = _packedAddressData[owner];
691         uint256 auxCasted;
692         // Cast `aux` with assembly to avoid redundant masking.
693         assembly {
694             auxCasted := aux
695         }
696         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
697         _packedAddressData[owner] = packed;
698     }
699 
700     /**
701      * Returns the packed ownership data of `tokenId`.
702      */
703     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
704         uint256 curr = tokenId;
705 
706         unchecked {
707             if (_startTokenId() <= curr)
708                 if (curr < _currentIndex) {
709                     uint256 packed = _packedOwnerships[curr];
710                     // If not burned.
711                     if (packed & BITMASK_BURNED == 0) {
712                         // Invariant:
713                         // There will always be an ownership that has an address and is not burned
714                         // before an ownership that does not have an address and is not burned.
715                         // Hence, curr will not underflow.
716                         //
717                         // We can directly compare the packed value.
718                         // If the address is zero, packed is zero.
719                         while (packed == 0) {
720                             packed = _packedOwnerships[--curr];
721                         }
722                         return packed;
723                     }
724                 }
725         }
726         revert OwnerQueryForNonexistentToken();
727     }
728 
729     /**
730      * Returns the unpacked `TokenOwnership` struct from `packed`.
731      */
732     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
733         ownership.addr = address(uint160(packed));
734         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
735         ownership.burned = packed & BITMASK_BURNED != 0;
736         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
737     }
738 
739     /**
740      * Returns the unpacked `TokenOwnership` struct at `index`.
741      */
742     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
743         return _unpackedOwnership(_packedOwnerships[index]);
744     }
745 
746     /**
747      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
748      */
749     function _initializeOwnershipAt(uint256 index) internal {
750         if (_packedOwnerships[index] == 0) {
751             _packedOwnerships[index] = _packedOwnershipOf(index);
752         }
753     }
754 
755     /**
756      * Gas spent here starts off proportional to the maximum mint batch size.
757      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
758      */
759     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
760         return _unpackedOwnership(_packedOwnershipOf(tokenId));
761     }
762 
763     /**
764      * @dev Packs ownership data into a single uint256.
765      */
766     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
767         assembly {
768             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
769             owner := and(owner, BITMASK_ADDRESS)
770             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
771             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
772         }
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view override returns (address) {
779         return address(uint160(_packedOwnershipOf(tokenId)));
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, it can be overridden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return '';
813     }
814 
815     /**
816      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
817      */
818     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
819         // For branchless setting of the `nextInitialized` flag.
820         assembly {
821             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
822             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
823         }
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public override {
830         address owner = ownerOf(tokenId);
831 
832         if (_msgSenderERC721A() != owner)
833             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
834                 revert ApprovalCallerNotOwnerNorApproved();
835             }
836 
837         _tokenApprovals[tokenId] = to;
838         emit Approval(owner, to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view override returns (address) {
845         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
855 
856         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
857         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         safeTransferFrom(from, to, tokenId, '');
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public virtual override {
887         transferFrom(from, to, tokenId);
888         if (to.code.length != 0)
889             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
890                 revert TransferToNonERC721ReceiverImplementer();
891             }
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      */
901     function _exists(uint256 tokenId) internal view returns (bool) {
902         return
903             _startTokenId() <= tokenId &&
904             tokenId < _currentIndex && // If within bounds,
905             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
906     }
907 
908     /**
909      * @dev Equivalent to `_safeMint(to, quantity, '')`.
910      */
911     function _safeMint(address to, uint256 quantity) internal {
912         _safeMint(to, quantity, '');
913     }
914 
915     /**
916      * @dev Safely mints `quantity` tokens and transfers them to `to`.
917      *
918      * Requirements:
919      *
920      * - If `to` refers to a smart contract, it must implement
921      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
922      * - `quantity` must be greater than 0.
923      *
924      * See {_mint}.
925      *
926      * Emits a {Transfer} event for each mint.
927      */
928     function _safeMint(
929         address to,
930         uint256 quantity,
931         bytes memory _data
932     ) internal {
933         _mint(to, quantity);
934 
935         unchecked {
936             if (to.code.length != 0) {
937                 uint256 end = _currentIndex;
938                 uint256 index = end - quantity;
939                 do {
940                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
941                         revert TransferToNonERC721ReceiverImplementer();
942                     }
943                 } while (index < end);
944                 // Reentrancy protection.
945                 if (_currentIndex != end) revert();
946             }
947         }
948     }
949 
950     /**
951      * @dev Mints `quantity` tokens and transfers them to `to`.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {Transfer} event for each mint.
959      */
960     function _mint(address to, uint256 quantity) internal {
961         uint256 startTokenId = _currentIndex;
962         if (to == address(0)) revert MintToZeroAddress();
963         if (quantity == 0) revert MintZeroQuantity();
964 
965         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
966 
967         // Overflows are incredibly unrealistic.
968         // `balance` and `numberMinted` have a maximum limit of 2**64.
969         // `tokenId` has a maximum limit of 2**256.
970         unchecked {
971             // Updates:
972             // - `balance += quantity`.
973             // - `numberMinted += quantity`.
974             //
975             // We can directly add to the `balance` and `numberMinted`.
976             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
977 
978             // Updates:
979             // - `address` to the owner.
980             // - `startTimestamp` to the timestamp of minting.
981             // - `burned` to `false`.
982             // - `nextInitialized` to `quantity == 1`.
983             _packedOwnerships[startTokenId] = _packOwnershipData(
984                 to,
985                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
986             );
987 
988             uint256 tokenId = startTokenId;
989             uint256 end = startTokenId + quantity;
990             do {
991                 emit Transfer(address(0), to, tokenId++);
992             } while (tokenId < end);
993 
994             _currentIndex = end;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * This function is intended for efficient minting only during contract creation.
1003      *
1004      * It emits only one {ConsecutiveTransfer} as defined in
1005      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1006      * instead of a sequence of {Transfer} event(s).
1007      *
1008      * Calling this function outside of contract creation WILL make your contract
1009      * non-compliant with the ERC721 standard.
1010      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1011      * {ConsecutiveTransfer} event is only permissible during contract creation.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {ConsecutiveTransfer} event.
1019      */
1020     function _mintERC2309(address to, uint256 quantity) internal {
1021         uint256 startTokenId = _currentIndex;
1022         if (to == address(0)) revert MintToZeroAddress();
1023         if (quantity == 0) revert MintZeroQuantity();
1024         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1029         unchecked {
1030             // Updates:
1031             // - `balance += quantity`.
1032             // - `numberMinted += quantity`.
1033             //
1034             // We can directly add to the `balance` and `numberMinted`.
1035             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1036 
1037             // Updates:
1038             // - `address` to the owner.
1039             // - `startTimestamp` to the timestamp of minting.
1040             // - `burned` to `false`.
1041             // - `nextInitialized` to `quantity == 1`.
1042             _packedOwnerships[startTokenId] = _packOwnershipData(
1043                 to,
1044                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1045             );
1046 
1047             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1048 
1049             _currentIndex = startTokenId + quantity;
1050         }
1051         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1052     }
1053 
1054     /**
1055      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1056      */
1057     function _getApprovedAddress(uint256 tokenId)
1058         private
1059         view
1060         returns (uint256 approvedAddressSlot, address approvedAddress)
1061     {
1062         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1063         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1064         assembly {
1065             // Compute the slot.
1066             mstore(0x00, tokenId)
1067             mstore(0x20, tokenApprovalsPtr.slot)
1068             approvedAddressSlot := keccak256(0x00, 0x40)
1069             // Load the slot's value from storage.
1070             approvedAddress := sload(approvedAddressSlot)
1071         }
1072     }
1073 
1074     /**
1075      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1076      */
1077     function _isOwnerOrApproved(
1078         address approvedAddress,
1079         address from,
1080         address msgSender
1081     ) private pure returns (bool result) {
1082         assembly {
1083             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1084             from := and(from, BITMASK_ADDRESS)
1085             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1086             msgSender := and(msgSender, BITMASK_ADDRESS)
1087             // `msgSender == from || msgSender == approvedAddress`.
1088             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1089         }
1090     }
1091 
1092     /**
1093      * @dev Transfers `tokenId` from `from` to `to`.
1094      *
1095      * Requirements:
1096      *
1097      * - `to` cannot be the zero address.
1098      * - `tokenId` token must be owned by `from`.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1108 
1109         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1110 
1111         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1112 
1113         // The nested ifs save around 20+ gas over a compound boolean condition.
1114         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1115             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1116 
1117         if (to == address(0)) revert TransferToZeroAddress();
1118 
1119         _beforeTokenTransfers(from, to, tokenId, 1);
1120 
1121         // Clear approvals from the previous owner.
1122         assembly {
1123             if approvedAddress {
1124                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1125                 sstore(approvedAddressSlot, 0)
1126             }
1127         }
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1132         unchecked {
1133             // We can directly increment and decrement the balances.
1134             --_packedAddressData[from]; // Updates: `balance -= 1`.
1135             ++_packedAddressData[to]; // Updates: `balance += 1`.
1136 
1137             // Updates:
1138             // - `address` to the next owner.
1139             // - `startTimestamp` to the timestamp of transfering.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `true`.
1142             _packedOwnerships[tokenId] = _packOwnershipData(
1143                 to,
1144                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1145             );
1146 
1147             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1148             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1149                 uint256 nextTokenId = tokenId + 1;
1150                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1151                 if (_packedOwnerships[nextTokenId] == 0) {
1152                     // If the next slot is within bounds.
1153                     if (nextTokenId != _currentIndex) {
1154                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1155                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1156                     }
1157                 }
1158             }
1159         }
1160 
1161         emit Transfer(from, to, tokenId);
1162         _afterTokenTransfers(from, to, tokenId, 1);
1163     }
1164 
1165     /**
1166      * @dev Equivalent to `_burn(tokenId, false)`.
1167      */
1168     function _burn(uint256 tokenId) internal virtual {
1169         _burn(tokenId, false);
1170     }
1171 
1172     /**
1173      * @dev Destroys `tokenId`.
1174      * The approval is cleared when the token is burned.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1183         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1184 
1185         address from = address(uint160(prevOwnershipPacked));
1186 
1187         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1188 
1189         if (approvalCheck) {
1190             // The nested ifs save around 20+ gas over a compound boolean condition.
1191             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1192                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1193         }
1194 
1195         _beforeTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Clear approvals from the previous owner.
1198         assembly {
1199             if approvedAddress {
1200                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1201                 sstore(approvedAddressSlot, 0)
1202             }
1203         }
1204 
1205         // Underflow of the sender's balance is impossible because we check for
1206         // ownership above and the recipient's balance can't realistically overflow.
1207         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1208         unchecked {
1209             // Updates:
1210             // - `balance -= 1`.
1211             // - `numberBurned += 1`.
1212             //
1213             // We can directly decrement the balance, and increment the number burned.
1214             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1215             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1216 
1217             // Updates:
1218             // - `address` to the last owner.
1219             // - `startTimestamp` to the timestamp of burning.
1220             // - `burned` to `true`.
1221             // - `nextInitialized` to `true`.
1222             _packedOwnerships[tokenId] = _packOwnershipData(
1223                 from,
1224                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1225             );
1226 
1227             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1228             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1229                 uint256 nextTokenId = tokenId + 1;
1230                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1231                 if (_packedOwnerships[nextTokenId] == 0) {
1232                     // If the next slot is within bounds.
1233                     if (nextTokenId != _currentIndex) {
1234                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1235                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1236                     }
1237                 }
1238             }
1239         }
1240 
1241         emit Transfer(from, address(0), tokenId);
1242         _afterTokenTransfers(from, address(0), tokenId, 1);
1243 
1244         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1245         unchecked {
1246             _burnCounter++;
1247         }
1248     }
1249 
1250     /**
1251      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1252      *
1253      * @param from address representing the previous owner of the given token ID
1254      * @param to target address that will receive the tokens
1255      * @param tokenId uint256 ID of the token to be transferred
1256      * @param _data bytes optional data to send along with the call
1257      * @return bool whether the call correctly returned the expected magic value
1258      */
1259     function _checkContractOnERC721Received(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) private returns (bool) {
1265         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1266             bytes4 retval
1267         ) {
1268             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1269         } catch (bytes memory reason) {
1270             if (reason.length == 0) {
1271                 revert TransferToNonERC721ReceiverImplementer();
1272             } else {
1273                 assembly {
1274                     revert(add(32, reason), mload(reason))
1275                 }
1276             }
1277         }
1278     }
1279 
1280     /**
1281      * @dev Directly sets the extra data for the ownership data `index`.
1282      */
1283     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1284         uint256 packed = _packedOwnerships[index];
1285         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1286         uint256 extraDataCasted;
1287         // Cast `extraData` with assembly to avoid redundant masking.
1288         assembly {
1289             extraDataCasted := extraData
1290         }
1291         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1292         _packedOwnerships[index] = packed;
1293     }
1294 
1295     /**
1296      * @dev Returns the next extra data for the packed ownership data.
1297      * The returned result is shifted into position.
1298      */
1299     function _nextExtraData(
1300         address from,
1301         address to,
1302         uint256 prevOwnershipPacked
1303     ) private view returns (uint256) {
1304         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1305         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1306     }
1307 
1308     /**
1309      * @dev Called during each token transfer to set the 24bit `extraData` field.
1310      * Intended to be overridden by the cosumer contract.
1311      *
1312      * `previousExtraData` - the value of `extraData` before transfer.
1313      *
1314      * Calling conditions:
1315      *
1316      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1317      * transferred to `to`.
1318      * - When `from` is zero, `tokenId` will be minted for `to`.
1319      * - When `to` is zero, `tokenId` will be burned by `from`.
1320      * - `from` and `to` are never both zero.
1321      */
1322     function _extraData(
1323         address from,
1324         address to,
1325         uint24 previousExtraData
1326     ) internal view virtual returns (uint24) {}
1327 
1328     /**
1329      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1330      * This includes minting.
1331      * And also called before burning one token.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, `tokenId` will be burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _beforeTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 
1351     /**
1352      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1353      * This includes minting.
1354      * And also called after one token has been burned.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` has been minted for `to`.
1364      * - When `to` is zero, `tokenId` has been burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _afterTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Returns the message sender (defaults to `msg.sender`).
1376      *
1377      * If you are writing GSN compatible contracts, you need to override this function.
1378      */
1379     function _msgSenderERC721A() internal view virtual returns (address) {
1380         return msg.sender;
1381     }
1382 
1383     /**
1384      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1385      */
1386     function _toString(uint256 value) internal pure returns (string memory ptr) {
1387         assembly {
1388             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1389             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1390             // We will need 1 32-byte word to store the length,
1391             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1392             ptr := add(mload(0x40), 128)
1393             // Update the free memory pointer to allocate.
1394             mstore(0x40, ptr)
1395 
1396             // Cache the end of the memory to calculate the length later.
1397             let end := ptr
1398 
1399             // We write the string from the rightmost digit to the leftmost digit.
1400             // The following is essentially a do-while loop that also handles the zero case.
1401             // Costs a bit more than early returning for the zero case,
1402             // but cheaper in terms of deployment and overall runtime costs.
1403             for {
1404                 // Initialize and perform the first pass without check.
1405                 let temp := value
1406                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1407                 ptr := sub(ptr, 1)
1408                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1409                 mstore8(ptr, add(48, mod(temp, 10)))
1410                 temp := div(temp, 10)
1411             } temp {
1412                 // Keep dividing `temp` until zero.
1413                 temp := div(temp, 10)
1414             } {
1415                 // Body of the for loop.
1416                 ptr := sub(ptr, 1)
1417                 mstore8(ptr, add(48, mod(temp, 10)))
1418             }
1419 
1420             let length := sub(end, ptr)
1421             // Move the pointer 32 bytes leftwards to make room for the length.
1422             ptr := sub(ptr, 32)
1423             // Store the length.
1424             mstore(ptr, length)
1425         }
1426     }
1427 }
1428 
1429 
1430 contract ThreeGMAIPFP is ERC721A, Ownable {
1431 
1432     string public baseURI = "ipfs://QmPezNm2TY145vbMA3W3yB9wdqacEmydzLUEhestQyTUCP/";
1433     string public contractURI = "ipfs://QmYY2VkrWHdHvDgu8Y2R3X4TkiXhwJSSUxnMaKKwZoYG26";
1434     uint256 constant public MAX_SUPPLY = 5000;
1435 
1436     uint256 public txLimit = 5;
1437     uint256 public walletLimit = 10;
1438     uint256 public price = 0.01 ether;
1439 
1440     bool public publicPaused = true;
1441 
1442     mapping(address => uint256) public walletMint;
1443 
1444     constructor() ERC721A("3GMAIPFP", "3GMAIPFP") {}
1445 
1446     function mint(uint256 _amountToMint) external payable {
1447         require(!publicPaused, "Public paused");
1448         require(MAX_SUPPLY >= totalSupply() + _amountToMint, "Exceeds max supply");
1449         require(_amountToMint > 0, "Not 0 mints");
1450         require(_amountToMint <= txLimit, "Tx limit");
1451         require(_amountToMint * price == msg.value, "Invalid funds provided");
1452 
1453         address _caller = _msgSender();
1454         require(tx.origin == _caller, "No contracts");
1455         require(walletMint[_caller] + _amountToMint <= walletLimit, "Not allow to mint more");
1456 
1457         unchecked { walletMint[_caller] += _amountToMint; }
1458         _safeMint(_caller, _amountToMint);
1459     }
1460 
1461     function _startTokenId() internal override view virtual returns (uint256) {
1462         return 1;
1463     }
1464 
1465     function minted(address _owner) public view returns (uint256) {
1466         return _numberMinted(_owner);
1467     }
1468 
1469     function withdraw() external onlyOwner {
1470         uint256 balance = address(this).balance;
1471         (bool success, ) = _msgSender().call{value: balance}("");
1472         require(success, "Failed to send");
1473     }
1474 
1475     function teamMint(address _to, uint256 _amount) external onlyOwner {
1476         _safeMint(_to, _amount);
1477     }
1478 
1479     function orderedMint(address[] calldata _to, uint256[] calldata _amount) external onlyOwner {
1480         require(_to.length == _amount.length, "DL");
1481 
1482         for (uint256 i; i < _to.length; i++) {
1483             _safeMint(_to[i], _amount[i]);
1484         }
1485     }
1486 
1487     function togglePublic() external onlyOwner {
1488         publicPaused = !publicPaused;
1489     }
1490 
1491     function setPrice(uint256 _price) external onlyOwner {
1492         price = _price;
1493     }
1494 
1495     function setTxLimit(uint256 _limit) external onlyOwner {
1496         txLimit = _limit;
1497     }
1498 
1499     function setWalletLimit(uint256 _limit) external onlyOwner {
1500         walletLimit = _limit;
1501     }
1502 
1503     function setBaseURI(string memory baseURI_) external onlyOwner {
1504         baseURI = baseURI_;
1505     }
1506 
1507     function setContractURI(string memory _contractURI) external onlyOwner {
1508         contractURI = _contractURI;
1509     }
1510 
1511     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1512         require(_exists(_tokenId), "Token does not exist.");
1513         return bytes(baseURI).length > 0 ? string(
1514             abi.encodePacked(
1515               baseURI,
1516               Strings.toString(_tokenId),
1517               ".json"
1518             )
1519         ) : "";
1520     }
1521 }