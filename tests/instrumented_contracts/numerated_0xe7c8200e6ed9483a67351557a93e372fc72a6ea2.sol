1 //   __       __  ______  __    __  ______   ______    ______    ______   _______   ________ 
2 //  /  \     /  |/      |/  \  /  |/      | /      \  /      \  /      \ /       \ /        |
3 //  $$  \   /$$ |$$$$$$/ $$  \ $$ |$$$$$$/ /$$$$$$  |/$$$$$$  |/$$$$$$  |$$$$$$$  |$$$$$$$$/ 
4 //  $$$  \ /$$$ |  $$ |  $$$  \$$ |  $$ |  $$ \__$$/ $$ |  $$/ $$ |__$$ |$$ |__$$ |$$ |__    
5 //  $$$$  /$$$$ |  $$ |  $$$$  $$ |  $$ |  $$      \ $$ |      $$    $$ |$$    $$/ $$    |   
6 //  $$ $$ $$/$$ |  $$ |  $$ $$ $$ |  $$ |   $$$$$$  |$$ |   __ $$$$$$$$ |$$$$$$$/  $$$$$/    
7 //  $$ |$$$/ $$ | _$$ |_ $$ |$$$$ | _$$ |_ /  \__$$ |$$ \__/  |$$ |  $$ |$$ |      $$ |_____ 
8 //  $$ | $/  $$ |/ $$   |$$ | $$$ |/ $$   |$$    $$/ $$    $$/ $$ |  $$ |$$ |      $$       |
9 //  $$/      $$/ $$$$$$/ $$/   $$/ $$$$$$/  $$$$$$/   $$$$$$/  $$/   $$/ $$/       $$$$$$$$/ 
10 //                                                                                           
11 //                                                                                           
12 //
13 
14 
15 //    ____    __  __     ____                           _          _ __                              
16 //   / / /   / / / /__  / / /___     ____ _____ _____ _(_)___     (_) /______   ____ ___  ___        
17 //  / / /   / /_/ / _ \/ / / __ \   / __ `/ __ `/ __ `/ / __ \   / / __/ ___/  / __ `__ \/ _ \       
18 //  \ \ \  / __  /  __/ / / /_/ /  / /_/ / /_/ / /_/ / / / / /  / / /_(__  )  / / / / / /  __/       
19 //   \_\_\/_/ /_/\___/_/_/\____/   \__,_/\__, /\__,_/_/_/ /_/  /_/\__/____/  /_/ /_/ /_/\___(_)      
20 //                                      /____/                                                    
21 
22 
23 
24 // File: @openzeppelin/contracts/utils/Strings.sol
25 
26 
27 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36     uint8 private constant _ADDRESS_LENGTH = 20;
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
40      */
41     function toString(uint256 value) internal pure returns (string memory) {
42         // Inspired by OraclizeAPI's implementation - MIT licence
43         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
44 
45         if (value == 0) {
46             return "0";
47         }
48         uint256 temp = value;
49         uint256 digits;
50         while (temp != 0) {
51             digits++;
52             temp /= 10;
53         }
54         bytes memory buffer = new bytes(digits);
55         while (value != 0) {
56             digits -= 1;
57             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
58             value /= 10;
59         }
60         return string(buffer);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
65      */
66     function toHexString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0x00";
69         }
70         uint256 temp = value;
71         uint256 length = 0;
72         while (temp != 0) {
73             length++;
74             temp >>= 8;
75         }
76         return toHexString(value, length);
77     }
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
81      */
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
96      */
97     function toHexString(address addr) internal pure returns (string memory) {
98         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Context.sol
103 
104 
105 //     ______                                               __              __  __    _              _     __    ____   ___ 
106 //    / ____/___ _____     __  ______  __  __   _________  / /   _____     / /_/ /_  (_)____   _____(_)___/ /___/ / /__/__ \
107 //   / /   / __ `/ __ \   / / / / __ \/ / / /  / ___/ __ \/ / | / / _ \   / __/ __ \/ / ___/  / ___/ / __  / __  / / _ \/ _/
108 //  / /___/ /_/ / / / /  / /_/ / /_/ / /_/ /  (__  ) /_/ / /| |/ /  __/  / /_/ / / / (__  )  / /  / / /_/ / /_/ / /  __/_/  
109 //  \____/\__,_/_/ /_/   \__, /\____/\__,_/  /____/\____/_/ |___/\___/   \__/_/ /_/_/____/  /_/  /_/\__,_/\__,_/_/\___(_)   
110 //                      /____/                                                                                             
111 
112 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         return msg.data;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/access/Ownable.sol
137 
138 
139 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 
144 /**
145  * @dev Contract module which provides a basic access control mechanism, where
146  * there is an account (an owner) that can be granted exclusive access to
147  * specific functions.
148  *
149  * By default, the owner account will be the one that deploys the contract. This
150  * can later be changed with {transferOwnership}.
151  *
152  * This module is used through inheritance. It will make available the modifier
153  * `onlyOwner`, which can be applied to your functions to restrict their use to
154  * the owner.
155  */
156 abstract contract Ownable is Context {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     /**
162      * @dev Initializes the contract setting the deployer as the initial owner.
163      */
164     constructor() {
165         _transferOwnership(_msgSender());
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         _checkOwner();
173         _;
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if the sender is not the owner.
185      */
186     function _checkOwner() internal view virtual {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188     }
189 
190     /**
191      * @dev Leaves the contract without owner. It will not be possible to call
192      * `onlyOwner` functions anymore. Can only be called by the current owner.
193      *
194      * NOTE: Renouncing ownership will leave the contract without an owner,
195      * thereby removing any functionality that is only available to the owner.
196      */
197     function renounceOwnership() public virtual onlyOwner {
198         _transferOwnership(address(0));
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public virtual onlyOwner {
206         require(newOwner != address(0), "Ownable: new owner is the zero address");
207         _transferOwnership(newOwner);
208     }
209 
210     /**
211      * @dev Transfers ownership of the contract to a new account (`newOwner`).
212      * Internal function without access restriction.
213      */
214     function _transferOwnership(address newOwner) internal virtual {
215         address oldOwner = _owner;
216         _owner = newOwner;
217         emit OwnershipTransferred(oldOwner, newOwner);
218     }
219 }
220 
221 // File: erc721a/contracts/IERC721A.sol
222 
223 
224 
225 // ERC721A Contracts v4.1.0
226 // Creator: Chiru Labs
227 
228 pragma solidity ^0.8.4;
229 
230 /**
231  * @dev Interface of an ERC721A compliant contract.
232  */
233 interface IERC721A {
234     /**
235      * The caller must own the token or be an approved operator.
236      */
237     error ApprovalCallerNotOwnerNorApproved();
238 
239     /**
240      * The token does not exist.
241      */
242     error ApprovalQueryForNonexistentToken();
243 
244     /**
245      * The caller cannot approve to their own address.
246      */
247     error ApproveToCaller();
248 
249     /**
250      * Cannot query the balance for the zero address.
251      */
252     error BalanceQueryForZeroAddress();
253 
254     /**
255      * Cannot mint to the zero address.
256      */
257     error MintToZeroAddress();
258 
259     /**
260      * The quantity of tokens minted must be more than zero.
261      */
262     error MintZeroQuantity();
263 
264     /**
265      * The token does not exist.
266      */
267     error OwnerQueryForNonexistentToken();
268 
269     /**
270      * The caller must own the token or be an approved operator.
271      */
272     error TransferCallerNotOwnerNorApproved();
273 
274     /**
275      * The token must be owned by `from`.
276      */
277     error TransferFromIncorrectOwner();
278 
279     /**
280      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
281      */
282     error TransferToNonERC721ReceiverImplementer();
283 
284     /**
285      * Cannot transfer to the zero address.
286      */
287     error TransferToZeroAddress();
288 
289     /**
290      * The token does not exist.
291      */
292     error URIQueryForNonexistentToken();
293 
294     /**
295      * The `quantity` minted with ERC2309 exceeds the safety limit.
296      */
297     error MintERC2309QuantityExceedsLimit();
298 
299     /**
300      * The `extraData` cannot be set on an unintialized ownership slot.
301      */
302     error OwnershipNotInitializedForExtraData();
303 
304     struct TokenOwnership {
305         // The address of the owner.
306         address addr;
307         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
308         uint64 startTimestamp;
309         // Whether the token has been burned.
310         bool burned;
311         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
312         uint24 extraData;
313     }
314 
315     /**
316      * @dev Returns the total amount of tokens stored by the contract.
317      *
318      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
319      */
320     function totalSupply() external view returns (uint256);
321 
322     // ==============================
323     //            IERC165
324     // ==============================
325 
326     /**
327      * @dev Returns true if this contract implements the interface defined by
328      * `interfaceId`. See the corresponding
329      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
330      * to learn more about how these ids are created.
331      *
332      * This function call must use less than 30 000 gas.
333      */
334     function supportsInterface(bytes4 interfaceId) external view returns (bool);
335 
336     // ==============================
337     //            IERC721
338     // ==============================
339 
340     /**
341      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
344 
345     /**
346      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
347      */
348     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
352      */
353     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
354 
355     /**
356      * @dev Returns the number of tokens in ``owner``'s account.
357      */
358     function balanceOf(address owner) external view returns (uint256 balance);
359 
360     /**
361      * @dev Returns the owner of the `tokenId` token.
362      *
363      * Requirements:
364      *
365      * - `tokenId` must exist.
366      */
367     function ownerOf(uint256 tokenId) external view returns (address owner);
368 
369     /**
370      * @dev Safely transfers `tokenId` token from `from` to `to`.
371      *
372      * Requirements:
373      *
374      * - `from` cannot be the zero address.
375      * - `to` cannot be the zero address.
376      * - `tokenId` token must exist and be owned by `from`.
377      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
379      *
380      * Emits a {Transfer} event.
381      */
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId,
386         bytes calldata data
387     ) external;
388 
389     /**
390      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
391      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
392      *
393      * Requirements:
394      *
395      * - `from` cannot be the zero address.
396      * - `to` cannot be the zero address.
397      * - `tokenId` token must exist and be owned by `from`.
398      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
400      *
401      * Emits a {Transfer} event.
402      */
403     function safeTransferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409     /**
410      * @dev Transfers `tokenId` token from `from` to `to`.
411      *
412      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429     /**
430      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
431      * The approval is cleared when the token is transferred.
432      *
433      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
434      *
435      * Requirements:
436      *
437      * - The caller must own the token or be an approved operator.
438      * - `tokenId` must exist.
439      *
440      * Emits an {Approval} event.
441      */
442     function approve(address to, uint256 tokenId) external;
443 
444     /**
445      * @dev Approve or remove `operator` as an operator for the caller.
446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
447      *
448      * Requirements:
449      *
450      * - The `operator` cannot be the caller.
451      *
452      * Emits an {ApprovalForAll} event.
453      */
454     function setApprovalForAll(address operator, bool _approved) external;
455 
456     /**
457      * @dev Returns the account approved for `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function getApproved(uint256 tokenId) external view returns (address operator);
464 
465     /**
466      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
467      *
468      * See {setApprovalForAll}
469      */
470     function isApprovedForAll(address owner, address operator) external view returns (bool);
471 
472     // ==============================
473     //        IERC721Metadata
474     // ==============================
475 
476     /**
477      * @dev Returns the token collection name.
478      */
479     function name() external view returns (string memory);
480 
481     /**
482      * @dev Returns the token collection symbol.
483      */
484     function symbol() external view returns (string memory);
485 
486     /**
487      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
488      */
489     function tokenURI(uint256 tokenId) external view returns (string memory);
490 
491     // ==============================
492     //            IERC2309
493     // ==============================
494 
495     /**
496      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
497      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
498      */
499     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
500 }
501 
502 // File: erc721a/contracts/ERC721A.sol
503 
504 //      _______           __   __  __                            __           _                         ____   __  __                                  __   
505 //     / ____(_)___  ____/ /  / /_/ /_  ___     ____  ___  _  __/ /_   ____  (_)__  ________     ____  / __/  / /_/ /_  ___     ____  __  __________  / /__ 
506 //    / /_  / / __ \/ __  /  / __/ __ \/ _ \   / __ \/ _ \| |/_/ __/  / __ \/ / _ \/ ___/ _ \   / __ \/ /_   / __/ __ \/ _ \   / __ \/ / / /_  /_  / / / _ \
507 //   / __/ / / / / / /_/ /  / /_/ / / /  __/  / / / /  __/>  </ /_   / /_/ / /  __/ /__/  __/  / /_/ / __/  / /_/ / / /  __/  / /_/ / /_/ / / /_/ /_/ /  __/
508 //  /_/   /_/_/ /_/\__,_/   \__/_/ /_/\___/  /_/ /_/\___/_/|_|\__/  / .___/_/\___/\___/\___/   \____/_/     \__/_/ /_/\___/  / .___/\__,_/ /___/___/_/\___/ 
509 //                                                                 /_/                                                      /_/                            
510 
511 
512 // ERC721A Contracts v4.1.0
513 // Creator: Chiru Labs
514 
515 pragma solidity ^0.8.4;
516 
517 
518 /**
519  * @dev ERC721 token receiver interface.
520  */
521 interface ERC721A__IERC721Receiver {
522     function onERC721Received(
523         address operator,
524         address from,
525         uint256 tokenId,
526         bytes calldata data
527     ) external returns (bytes4);
528 }
529 
530 /**
531  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
532  * including the Metadata extension. Built to optimize for lower gas during batch mints.
533  *
534  * Assumes serials are sequentially minted starting at `_startTokenId()`
535  * (defaults to 0, e.g. 0, 1, 2, 3..).
536  *
537  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
538  *
539  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
540  */
541 contract ERC721A is IERC721A {
542     // Mask of an entry in packed address data.
543     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
544 
545     // The bit position of `numberMinted` in packed address data.
546     uint256 private constant BITPOS_NUMBER_MINTED = 64;
547 
548     // The bit position of `numberBurned` in packed address data.
549     uint256 private constant BITPOS_NUMBER_BURNED = 128;
550 
551     // The bit position of `aux` in packed address data.
552     uint256 private constant BITPOS_AUX = 192;
553 
554     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
555     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
556 
557     // The bit position of `startTimestamp` in packed ownership.
558     uint256 private constant BITPOS_START_TIMESTAMP = 160;
559 
560     // The bit mask of the `burned` bit in packed ownership.
561     uint256 private constant BITMASK_BURNED = 1 << 224;
562 
563     // The bit position of the `nextInitialized` bit in packed ownership.
564     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
565 
566     // The bit mask of the `nextInitialized` bit in packed ownership.
567     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
568 
569     // The bit position of `extraData` in packed ownership.
570     uint256 private constant BITPOS_EXTRA_DATA = 232;
571 
572     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
573     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
574 
575     // The mask of the lower 160 bits for addresses.
576     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
577 
578     // The maximum `quantity` that can be minted with `_mintERC2309`.
579     // This limit is to prevent overflows on the address data entries.
580     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
581     // is required to cause an overflow, which is unrealistic.
582     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
583 
584     // The tokenId of the next token to be minted.
585     uint256 private _currentIndex;
586 
587     // The number of tokens burned.
588     uint256 private _burnCounter;
589 
590     // Token name
591     string private _name;
592 
593     // Token symbol
594     string private _symbol;
595 
596     // Mapping from token ID to ownership details
597     // An empty struct value does not necessarily mean the token is unowned.
598     // See `_packedOwnershipOf` implementation for details.
599     //
600     // Bits Layout:
601     // - [0..159]   `addr`
602     // - [160..223] `startTimestamp`
603     // - [224]      `burned`
604     // - [225]      `nextInitialized`
605     // - [232..255] `extraData`
606     mapping(uint256 => uint256) private _packedOwnerships;
607 
608     // Mapping owner address to address data.
609     //
610     // Bits Layout:
611     // - [0..63]    `balance`
612     // - [64..127]  `numberMinted`
613     // - [128..191] `numberBurned`
614     // - [192..255] `aux`
615     mapping(address => uint256) private _packedAddressData;
616 
617     // Mapping from token ID to approved address.
618     mapping(uint256 => address) private _tokenApprovals;
619 
620     // Mapping from owner to operator approvals
621     mapping(address => mapping(address => bool)) private _operatorApprovals;
622 
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626         _currentIndex = _startTokenId();
627     }
628 
629     /**
630      * @dev Returns the starting token ID.
631      * To change the starting token ID, please override this function.
632      */
633     function _startTokenId() internal view virtual returns (uint256) {
634         return 0;
635     }
636 
637     /**
638      * @dev Returns the next token ID to be minted.
639      */
640     function _nextTokenId() internal view returns (uint256) {
641         return _currentIndex;
642     }
643 
644     /**
645      * @dev Returns the total number of tokens in existence.
646      * Burned tokens will reduce the count.
647      * To get the total number of tokens minted, please see `_totalMinted`.
648      */
649     function totalSupply() public view override returns (uint256) {
650         // Counter underflow is impossible as _burnCounter cannot be incremented
651         // more than `_currentIndex - _startTokenId()` times.
652         unchecked {
653             return _currentIndex - _burnCounter - _startTokenId();
654         }
655     }
656 
657     /**
658      * @dev Returns the total amount of tokens minted in the contract.
659      */
660     function _totalMinted() internal view returns (uint256) {
661         // Counter underflow is impossible as _currentIndex does not decrement,
662         // and it is initialized to `_startTokenId()`
663         unchecked {
664             return _currentIndex - _startTokenId();
665         }
666     }
667 
668     /**
669      * @dev Returns the total number of tokens burned.
670      */
671     function _totalBurned() internal view returns (uint256) {
672         return _burnCounter;
673     }
674 
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
679         // The interface IDs are constants representing the first 4 bytes of the XOR of
680         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
681         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
682         return
683             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
684             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
685             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view override returns (uint256) {
692         if (owner == address(0)) revert BalanceQueryForZeroAddress();
693         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
694     }
695 
696     /**
697      * Returns the number of tokens minted by `owner`.
698      */
699     function _numberMinted(address owner) internal view returns (uint256) {
700         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the number of tokens burned by or on behalf of `owner`.
705      */
706     function _numberBurned(address owner) internal view returns (uint256) {
707         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710     /**
711      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
712      */
713     function _getAux(address owner) internal view returns (uint64) {
714         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
715     }
716 
717     /**
718      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
719      * If there are multiple variables, please pack them into a uint64.
720      */
721     function _setAux(address owner, uint64 aux) internal {
722         uint256 packed = _packedAddressData[owner];
723         uint256 auxCasted;
724         // Cast `aux` with assembly to avoid redundant masking.
725         assembly {
726             auxCasted := aux
727         }
728         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
729         _packedAddressData[owner] = packed;
730     }
731 
732     /**
733      * Returns the packed ownership data of `tokenId`.
734      */
735     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
736         uint256 curr = tokenId;
737 
738         unchecked {
739             if (_startTokenId() <= curr)
740                 if (curr < _currentIndex) {
741                     uint256 packed = _packedOwnerships[curr];
742                     // If not burned.
743                     if (packed & BITMASK_BURNED == 0) {
744                         // Invariant:
745                         // There will always be an ownership that has an address and is not burned
746                         // before an ownership that does not have an address and is not burned.
747                         // Hence, curr will not underflow.
748                         //
749                         // We can directly compare the packed value.
750                         // If the address is zero, packed is zero.
751                         while (packed == 0) {
752                             packed = _packedOwnerships[--curr];
753                         }
754                         return packed;
755                     }
756                 }
757         }
758         revert OwnerQueryForNonexistentToken();
759     }
760 
761     /**
762      * Returns the unpacked `TokenOwnership` struct from `packed`.
763      */
764     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
765         ownership.addr = address(uint160(packed));
766         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
767         ownership.burned = packed & BITMASK_BURNED != 0;
768         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
769     }
770 
771     /**
772      * Returns the unpacked `TokenOwnership` struct at `index`.
773      */
774     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
775         return _unpackedOwnership(_packedOwnerships[index]);
776     }
777 
778     /**
779      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
780      */
781     function _initializeOwnershipAt(uint256 index) internal {
782         if (_packedOwnerships[index] == 0) {
783             _packedOwnerships[index] = _packedOwnershipOf(index);
784         }
785     }
786 
787     /**
788      * Gas spent here starts off proportional to the maximum mint batch size.
789      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
790      */
791     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
792         return _unpackedOwnership(_packedOwnershipOf(tokenId));
793     }
794 
795     /**
796      * @dev Packs ownership data into a single uint256.
797      */
798     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, BITMASK_ADDRESS)
802             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
803             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
804         }
805     }
806 
807     /**
808      * @dev See {IERC721-ownerOf}.
809      */
810     function ownerOf(uint256 tokenId) public view override returns (address) {
811         return address(uint160(_packedOwnershipOf(tokenId)));
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-name}.
816      */
817     function name() public view virtual override returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-symbol}.
823      */
824     function symbol() public view virtual override returns (string memory) {
825         return _symbol;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-tokenURI}.
830      */
831     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
832         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
833 
834         string memory baseURI = _baseURI();
835         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, it can be overridden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return '';
845     }
846 
847     /**
848      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
849      */
850     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
851         // For branchless setting of the `nextInitialized` flag.
852         assembly {
853             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
854             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
855         }
856     }
857 
858     /**
859      * @dev See {IERC721-approve}.
860      */
861     function approve(address to, uint256 tokenId) public override {
862         address owner = ownerOf(tokenId);
863 
864         if (_msgSenderERC721A() != owner)
865             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
866                 revert ApprovalCallerNotOwnerNorApproved();
867             }
868 
869         _tokenApprovals[tokenId] = to;
870         emit Approval(owner, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-getApproved}.
875      */
876     function getApproved(uint256 tokenId) public view override returns (address) {
877         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     /**
883      * @dev See {IERC721-setApprovalForAll}.
884      */
885     function setApprovalForAll(address operator, bool approved) public virtual override {
886         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
887 
888         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
889         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public virtual override {
919         transferFrom(from, to, tokenId);
920         if (to.code.length != 0)
921             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
922                 revert TransferToNonERC721ReceiverImplementer();
923             }
924     }
925 
926     /**
927      * @dev Returns whether `tokenId` exists.
928      *
929      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
930      *
931      * Tokens start existing when they are minted (`_mint`),
932      */
933     function _exists(uint256 tokenId) internal view returns (bool) {
934         return
935             _startTokenId() <= tokenId &&
936             tokenId < _currentIndex && // If within bounds,
937             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
938     }
939 
940     /**
941      * @dev Equivalent to `_safeMint(to, quantity, '')`.
942      */
943     function _safeMint(address to, uint256 quantity) internal {
944         _safeMint(to, quantity, '');
945     }
946 
947     /**
948      * @dev Safely mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - If `to` refers to a smart contract, it must implement
953      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
954      * - `quantity` must be greater than 0.
955      *
956      * See {_mint}.
957      *
958      * Emits a {Transfer} event for each mint.
959      */
960     function _safeMint(
961         address to,
962         uint256 quantity,
963         bytes memory _data
964     ) internal {
965         _mint(to, quantity);
966 
967         unchecked {
968             if (to.code.length != 0) {
969                 uint256 end = _currentIndex;
970                 uint256 index = end - quantity;
971                 do {
972                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
973                         revert TransferToNonERC721ReceiverImplementer();
974                     }
975                 } while (index < end);
976                 // Reentrancy protection.
977                 if (_currentIndex != end) revert();
978             }
979         }
980     }
981 
982     /**
983      * @dev Mints `quantity` tokens and transfers them to `to`.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `quantity` must be greater than 0.
989      *
990      * Emits a {Transfer} event for each mint.
991      */
992     function _mint(address to, uint256 quantity) internal {
993         uint256 startTokenId = _currentIndex;
994         if (to == address(0)) revert MintToZeroAddress();
995         if (quantity == 0) revert MintZeroQuantity();
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         // Overflows are incredibly unrealistic.
1000         // `balance` and `numberMinted` have a maximum limit of 2**64.
1001         // `tokenId` has a maximum limit of 2**256.
1002         unchecked {
1003             // Updates:
1004             // - `balance += quantity`.
1005             // - `numberMinted += quantity`.
1006             //
1007             // We can directly add to the `balance` and `numberMinted`.
1008             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1009 
1010             // Updates:
1011             // - `address` to the owner.
1012             // - `startTimestamp` to the timestamp of minting.
1013             // - `burned` to `false`.
1014             // - `nextInitialized` to `quantity == 1`.
1015             _packedOwnerships[startTokenId] = _packOwnershipData(
1016                 to,
1017                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1018             );
1019 
1020             uint256 tokenId = startTokenId;
1021             uint256 end = startTokenId + quantity;
1022             do {
1023                 emit Transfer(address(0), to, tokenId++);
1024             } while (tokenId < end);
1025 
1026             _currentIndex = end;
1027         }
1028         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1029     }
1030 
1031      /**
1032      * @dev Mints `quantity` tokens and transfers them to `to`.
1033      *
1034      * This function is intended for efficient minting only during contract creation.
1035      *
1036      * It emits only one {ConsecutiveTransfer} as defined in
1037      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1038      * instead of a sequence of {Transfer} event(s).
1039      *
1040      * Calling this function outside of contract creation WILL make your contract
1041      * non-compliant with the ERC721 standard.
1042      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1043      * {ConsecutiveTransfer} event is only permissible during contract creation.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `quantity` must be greater than 0.
1049      *
1050      * Emits a {ConsecutiveTransfer} event.
1051      */
1052     function _mintERC2309(address to, uint256 quantity) internal {
1053         uint256 startTokenId = _currentIndex;
1054         if (to == address(0)) revert MintToZeroAddress();
1055         if (quantity == 0) revert MintZeroQuantity();
1056         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1057 
1058         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1059 
1060         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1061         unchecked {
1062             // Updates:
1063             // - `balance += quantity`.
1064             // - `numberMinted += quantity`.
1065             //
1066             // We can directly add to the `balance` and `numberMinted`.
1067             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1068 
1069             // Updates:
1070             // - `address` to the owner.
1071             // - `startTimestamp` to the timestamp of minting.
1072             // - `burned` to `false`.
1073             // - `nextInitialized` to `quantity == 1`.
1074             _packedOwnerships[startTokenId] = _packOwnershipData(
1075                 to,
1076                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1077             );
1078 
1079             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1080 
1081             _currentIndex = startTokenId + quantity;
1082         }
1083         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1084     }
1085 
1086     /**
1087      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1088      */
1089     function _getApprovedAddress(uint256 tokenId)
1090         private
1091         view
1092         returns (uint256 approvedAddressSlot, address approvedAddress)
1093     {
1094         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1095         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1096         assembly {
1097             // Compute the slot.
1098             mstore(0x00, tokenId)
1099             mstore(0x20, tokenApprovalsPtr.slot)
1100             approvedAddressSlot := keccak256(0x00, 0x40)
1101             // Load the slot's value from storage.
1102             approvedAddress := sload(approvedAddressSlot)
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1108      */
1109     function _isOwnerOrApproved(
1110         address approvedAddress,
1111         address from,
1112         address msgSender
1113     ) private pure returns (bool result) {
1114         assembly {
1115             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1116             from := and(from, BITMASK_ADDRESS)
1117             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1118             msgSender := and(msgSender, BITMASK_ADDRESS)
1119             // `msgSender == from || msgSender == approvedAddress`.
1120             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1121         }
1122     }
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function transferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) public virtual override {
1139         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1140 
1141         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1142 
1143         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1144 
1145         // The nested ifs save around 20+ gas over a compound boolean condition.
1146         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1147             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1148 
1149         if (to == address(0)) revert TransferToZeroAddress();
1150 
1151         _beforeTokenTransfers(from, to, tokenId, 1);
1152 
1153         // Clear approvals from the previous owner.
1154         assembly {
1155             if approvedAddress {
1156                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1157                 sstore(approvedAddressSlot, 0)
1158             }
1159         }
1160 
1161         // Underflow of the sender's balance is impossible because we check for
1162         // ownership above and the recipient's balance can't realistically overflow.
1163         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1164         unchecked {
1165             // We can directly increment and decrement the balances.
1166             --_packedAddressData[from]; // Updates: `balance -= 1`.
1167             ++_packedAddressData[to]; // Updates: `balance += 1`.
1168 
1169             // Updates:
1170             // - `address` to the next owner.
1171             // - `startTimestamp` to the timestamp of transfering.
1172             // - `burned` to `false`.
1173             // - `nextInitialized` to `true`.
1174             _packedOwnerships[tokenId] = _packOwnershipData(
1175                 to,
1176                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1177             );
1178 
1179             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1180             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1181                 uint256 nextTokenId = tokenId + 1;
1182                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1183                 if (_packedOwnerships[nextTokenId] == 0) {
1184                     // If the next slot is within bounds.
1185                     if (nextTokenId != _currentIndex) {
1186                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1187                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1188                     }
1189                 }
1190             }
1191         }
1192 
1193         emit Transfer(from, to, tokenId);
1194         _afterTokenTransfers(from, to, tokenId, 1);
1195     }
1196 
1197     /**
1198      * @dev Equivalent to `_burn(tokenId, false)`.
1199      */
1200     function _burn(uint256 tokenId) internal virtual {
1201         _burn(tokenId, false);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1215         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1216 
1217         address from = address(uint160(prevOwnershipPacked));
1218 
1219         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1220 
1221         if (approvalCheck) {
1222             // The nested ifs save around 20+ gas over a compound boolean condition.
1223             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1224                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1225         }
1226 
1227         _beforeTokenTransfers(from, address(0), tokenId, 1);
1228 
1229         // Clear approvals from the previous owner.
1230         assembly {
1231             if approvedAddress {
1232                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1233                 sstore(approvedAddressSlot, 0)
1234             }
1235         }
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1240         unchecked {
1241             // Updates:
1242             // - `balance -= 1`.
1243             // - `numberBurned += 1`.
1244             //
1245             // We can directly decrement the balance, and increment the number burned.
1246             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1247             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1248 
1249             // Updates:
1250             // - `address` to the last owner.
1251             // - `startTimestamp` to the timestamp of burning.
1252             // - `burned` to `true`.
1253             // - `nextInitialized` to `true`.
1254             _packedOwnerships[tokenId] = _packOwnershipData(
1255                 from,
1256                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1257             );
1258 
1259             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1260             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1261                 uint256 nextTokenId = tokenId + 1;
1262                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1263                 if (_packedOwnerships[nextTokenId] == 0) {
1264                     // If the next slot is within bounds.
1265                     if (nextTokenId != _currentIndex) {
1266                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1267                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1268                     }
1269                 }
1270             }
1271         }
1272 
1273         emit Transfer(from, address(0), tokenId);
1274         _afterTokenTransfers(from, address(0), tokenId, 1);
1275 
1276         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1277         unchecked {
1278             _burnCounter++;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1284      *
1285      * @param from address representing the previous owner of the given token ID
1286      * @param to target address that will receive the tokens
1287      * @param tokenId uint256 ID of the token to be transferred
1288      * @param _data bytes optional data to send along with the call
1289      * @return bool whether the call correctly returned the expected magic value
1290      */
1291     function _checkContractOnERC721Received(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) private returns (bool) {
1297         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1298             bytes4 retval
1299         ) {
1300             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1301         } catch (bytes memory reason) {
1302             if (reason.length == 0) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             } else {
1305                 assembly {
1306                     revert(add(32, reason), mload(reason))
1307                 }
1308             }
1309         }
1310     }
1311 
1312     /**
1313      * @dev Directly sets the extra data for the ownership data `index`.
1314      */
1315     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1316         uint256 packed = _packedOwnerships[index];
1317         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1318         uint256 extraDataCasted;
1319         // Cast `extraData` with assembly to avoid redundant masking.
1320         assembly {
1321             extraDataCasted := extraData
1322         }
1323         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1324         _packedOwnerships[index] = packed;
1325     }
1326 
1327     /**
1328      * @dev Returns the next extra data for the packed ownership data.
1329      * The returned result is shifted into position.
1330      */
1331     function _nextExtraData(
1332         address from,
1333         address to,
1334         uint256 prevOwnershipPacked
1335     ) private view returns (uint256) {
1336         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1337         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1338     }
1339 
1340     /**
1341      * @dev Called during each token transfer to set the 24bit `extraData` field.
1342      * Intended to be overridden by the cosumer contract.
1343      *
1344      * `previousExtraData` - the value of `extraData` before transfer.
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` will be minted for `to`.
1351      * - When `to` is zero, `tokenId` will be burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _extraData(
1355         address from,
1356         address to,
1357         uint24 previousExtraData
1358     ) internal view virtual returns (uint24) {}
1359 
1360     /**
1361      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1362      * This includes minting.
1363      * And also called before burning one token.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` will be minted for `to`.
1373      * - When `to` is zero, `tokenId` will be burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _beforeTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 
1383     /**
1384      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1385      * This includes minting.
1386      * And also called after one token has been burned.
1387      *
1388      * startTokenId - the first token id to be transferred
1389      * quantity - the amount to be transferred
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` has been minted for `to`.
1396      * - When `to` is zero, `tokenId` has been burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _afterTokenTransfers(
1400         address from,
1401         address to,
1402         uint256 startTokenId,
1403         uint256 quantity
1404     ) internal virtual {}
1405 
1406     /**
1407      * @dev Returns the message sender (defaults to `msg.sender`).
1408      *
1409      * If you are writing GSN compatible contracts, you need to override this function.
1410      */
1411     function _msgSenderERC721A() internal view virtual returns (address) {
1412         return msg.sender;
1413     }
1414 
1415     /**
1416      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1417      */
1418     function _toString(uint256 value) internal pure returns (string memory ptr) {
1419         assembly {
1420             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1421             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1422             // We will need 1 32-byte word to store the length,
1423             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1424             ptr := add(mload(0x40), 128)
1425             // Update the free memory pointer to allocate.
1426             mstore(0x40, ptr)
1427 
1428             // Cache the end of the memory to calculate the length later.
1429             let end := ptr
1430 
1431             // We write the string from the rightmost digit to the leftmost digit.
1432             // The following is essentially a do-while loop that also handles the zero case.
1433             // Costs a bit more than early returning for the zero case,
1434             // but cheaper in terms of deployment and overall runtime costs.
1435             for {
1436                 // Initialize and perform the first pass without check.
1437                 let temp := value
1438                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1439                 ptr := sub(ptr, 1)
1440                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1441                 mstore8(ptr, add(48, mod(temp, 10)))
1442                 temp := div(temp, 10)
1443             } temp {
1444                 // Keep dividing `temp` until zero.
1445                 temp := div(temp, 10)
1446             } {
1447                 // Body of the for loop.
1448                 ptr := sub(ptr, 1)
1449                 mstore8(ptr, add(48, mod(temp, 10)))
1450             }
1451 
1452             let length := sub(end, ptr)
1453             // Move the pointer 32 bytes leftwards to make room for the length.
1454             ptr := sub(ptr, 32)
1455             // Store the length.
1456             mstore(ptr, length)
1457         }
1458     }
1459 }
1460 
1461 // File: contracts/miniscape.sol
1462 
1463 //   __       __  ______  __    __  ______   ______    ______    ______   _______   ________ 
1464 //  /  \     /  |/      |/  \  /  |/      | /      \  /      \  /      \ /       \ /        |
1465 //  $$  \   /$$ |$$$$$$/ $$  \ $$ |$$$$$$/ /$$$$$$  |/$$$$$$  |/$$$$$$  |$$$$$$$  |$$$$$$$$/ 
1466 //  $$$  \ /$$$ |  $$ |  $$$  \$$ |  $$ |  $$ \__$$/ $$ |  $$/ $$ |__$$ |$$ |__$$ |$$ |__    
1467 //  $$$$  /$$$$ |  $$ |  $$$$  $$ |  $$ |  $$      \ $$ |      $$    $$ |$$    $$/ $$    |   
1468 //  $$ $$ $$/$$ |  $$ |  $$ $$ $$ |  $$ |   $$$$$$  |$$ |   __ $$$$$$$$ |$$$$$$$/  $$$$$/    
1469 //  $$ |$$$/ $$ | _$$ |_ $$ |$$$$ | _$$ |_ /  \__$$ |$$ \__/  |$$ |  $$ |$$ |      $$ |_____ 
1470 //  $$ | $/  $$ |/ $$   |$$ | $$$ |/ $$   |$$    $$/ $$    $$/ $$ |  $$ |$$ |      $$       |
1471 //  $$/      $$/ $$$$$$/ $$/   $$/ $$$$$$/  $$$$$$/   $$$$$$/  $$/   $$/ $$/       $$$$$$$$/ 
1472 //                                                                                           
1473 //                                                                                           
1474 // 
1475 
1476 //  __  __               __                                                                  __         ____               
1477 //  \ \/ /___  __  __   / /_  ____ __   _____     ________  ___  ____     ____ ___  ___     / /_  ___  / __/___  ________  
1478 //   \  / __ \/ / / /  / __ \/ __ `/ | / / _ \   / ___/ _ \/ _ \/ __ \   / __ `__ \/ _ \   / __ \/ _ \/ /_/ __ \/ ___/ _ \ 
1479 //   / / /_/ / /_/ /  / / / / /_/ /| |/ /  __/  (__  )  __/  __/ / / /  / / / / / /  __/  / /_/ /  __/ __/ /_/ / /  /  __/ 
1480 //  /_/\____/\__,_/  /_/ /_/\__,_/ |___/\___/  /____/\___/\___/_/ /_/  /_/ /_/ /_/\___/  /_.___/\___/_/  \____/_/   \___(_)
1481 //                                                                                                                         
1482 
1483 
1484 //SPDX-License-Identifier: MIT
1485 pragma solidity ^0.8.4;
1486 
1487 
1488 
1489 
1490 
1491 
1492 contract Miniscape is Ownable, ERC721A {
1493     uint256 constant public MAX_SUPPLY = 4000;
1494     
1495 
1496     uint256 public publicPrice = 0.002 ether;
1497 
1498     uint256 constant public PUBLIC_MINT_LIMIT_TXN = 2;
1499     uint256 constant public PUBLIC_MINT_LIMIT = 4;
1500 
1501 
1502     string public revealedURI;
1503     
1504     string public hiddenURI = "ipfs://QmYAsXzZXu3gj7CiSb6dsmoXHqdRJoG724hRuXNHi9YrWW/hidden.json";
1505 
1506     
1507 
1508     bool public paused = false;
1509     bool public revealed = false;
1510 
1511     bool public freeSale = false;
1512     bool public publicSale = false;
1513 
1514     
1515     address constant internal DEV_ADDRESS = 0x0dbE1001105653245d97AeB5216e20A2951b0879;
1516     
1517 
1518     mapping(address => bool) public userMintedFree;
1519     mapping(address => uint256) public numUserMints;
1520 
1521     constructor(string memory _name, string memory _symbol, string memory _baseURI, string memory _hiddenMetadataUri) ERC721A("Miniscape", "MINI") { }
1522 
1523     
1524     function _startTokenId() internal view virtual override returns (uint256) {
1525         return 1;
1526     }
1527 
1528     function refundOverpay(uint256 price) private {
1529         if (msg.value > price) {
1530             (bool succ, ) = payable(msg.sender).call{
1531                 value: (msg.value - price)
1532             }("");
1533             require(succ, "Transfer failed");
1534         }
1535         else if (msg.value < price) {
1536             revert("Not enough ETH sent");
1537         }
1538     }
1539 
1540     function freeMint(uint256 quantity) external payable mintCompliance(quantity) {
1541         require(freeSale, "Free sale inactive");
1542         require(msg.value == 0, "This phase is free");
1543         require(quantity == 2, "Only 2 free");
1544 
1545         uint256 newSupply = totalSupply() + quantity;
1546         
1547         require(newSupply <= 1000, "Not enough free supply");
1548 
1549         require(!userMintedFree[msg.sender], "User max free limit");
1550         
1551         userMintedFree[msg.sender] = true;
1552 
1553         if(newSupply == 1000) {
1554             freeSale = false;
1555             publicSale = true;
1556         }
1557 
1558         _safeMint(msg.sender, quantity);
1559     }
1560 
1561     function publicMint(uint256 quantity) external payable mintCompliance(quantity) {
1562         require(publicSale, "Public sale inactive");
1563         require(quantity <= PUBLIC_MINT_LIMIT_TXN, "Quantity too high");
1564 
1565         uint256 price = publicPrice;
1566         uint256 currMints = numUserMints[msg.sender];
1567                 
1568         require(currMints + quantity <= PUBLIC_MINT_LIMIT, "User max mint limit");
1569         
1570         refundOverpay(price * quantity);
1571 
1572         numUserMints[msg.sender] = (currMints + quantity);
1573 
1574         _safeMint(msg.sender, quantity);
1575     }
1576 
1577 
1578     function walletOfOwner(address _owner) public view returns (uint256[] memory)
1579     {
1580         uint256 ownerTokenCount = balanceOf(_owner);
1581         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1582         uint256 currentTokenId = 1;
1583         uint256 ownedTokenIndex = 0;
1584 
1585         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1586             address currentTokenOwner = ownerOf(currentTokenId);
1587 
1588             if (currentTokenOwner == _owner) {
1589                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1590 
1591                 ownedTokenIndex++;
1592             }
1593 
1594         currentTokenId++;
1595         }
1596 
1597         return ownedTokenIds;
1598     }
1599 
1600     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1601         
1602         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1603         
1604         if (revealed) {
1605             return string(abi.encodePacked(revealedURI, Strings.toString(_tokenId), ".json"));
1606         }
1607         else {
1608             return hiddenURI;
1609         }
1610     }
1611 
1612     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1613         publicPrice = _publicPrice;
1614     }
1615 
1616     function setBaseURI(string memory _baseUri) public onlyOwner {
1617         revealedURI = _baseUri;
1618     }
1619 
1620     
1621     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1622         hiddenURI = _hiddenMetadataUri;
1623     }
1624 
1625     function revealCollection(bool _revealed, string memory _baseUri) public onlyOwner {
1626         revealed = _revealed;
1627         revealedURI = _baseUri;
1628     }
1629 
1630     function setPaused(bool _state) public onlyOwner {
1631         paused = _state;
1632     }
1633 
1634     function setRevealed(bool _state) public onlyOwner {
1635         revealed = _state;
1636     }
1637 
1638     function setPublicEnabled(bool _state) public onlyOwner {
1639         publicSale = _state;
1640         freeSale = !_state;
1641     }
1642     function setFreeEnabled(bool _state) public onlyOwner {
1643         freeSale = _state;
1644         publicSale = !_state;
1645     }
1646 
1647     
1648 
1649     function withdraw() external payable onlyOwner {
1650         
1651         uint256 currBalance = address(this).balance;
1652 
1653         (bool succ, ) = payable(DEV_ADDRESS).call{
1654             value: (currBalance * 10000) / 10000
1655         }("0x0dbE1001105653245d97AeB5216e20A2951b0879");
1656         require(succ, "Dev transfer failed");
1657     }
1658 
1659     function mintToUser(uint256 quantity, address receiver) public onlyOwner mintCompliance(quantity) {
1660         _safeMint(receiver, quantity);
1661     }
1662 
1663    
1664 
1665     modifier mintCompliance(uint256 quantity) {
1666         require(!paused, "Contract is paused");
1667         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough mints left");
1668         require(tx.origin == msg.sender, "No contract minting");
1669         _;
1670     }
1671 }