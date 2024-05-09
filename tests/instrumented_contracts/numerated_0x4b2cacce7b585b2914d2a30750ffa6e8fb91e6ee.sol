1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ....................................................................................................
5 .........................................,++++++++++++++,...........................................
6 ........................................,*##############?,..........................................
7 ........................................*#???????*******S?,.........................................
8 .......................................*S????????********S?,........................................
9 ....................................,*?#%%%?%%%%%%%%%%%%??#%*,......................................
10 ....................................,@#%S%%S%%S%SS%SS%SS%S%#@:......................................
11 ....................................,#S%#S%#%S#%S#%S#%#S%#S%@:......................................
12 ....................................,@######################@:......................................
13 ....................................,*?@#####S#SS###SS####@%?,......................................
14 .....................................*?S%%%%%?S%?????%SSS%S?,.......................................
15 ...................................,?##%%*S?;;;*%?++%*;;;%SS%,......................................
16 ...................................,#SS%+?%:,?+,*S?%?,...:%S@:......................................
17 ...................................,#SS%?S*:S@#+,*S*,.....?S@:......................................
18 ...................................,#SS%%S*+#*@%.;S+.?SSS+?S@:......................................
19 ...................................,#SS%%S?,+SS::%%%;;;;;:?S@:......................................
20 ...................................,#SSS%%%+,;,;*;;;*;...+%#+,......................................
21 ....................................;#SS%%S%???%#*:+%%???%S@:.......................................
22 .....................................;#SS%%SSSS#@%:?SSSSSS#+,.......................................
23 ......................................;@@SSSSS##S%+%#SSSS#;.........................................
24 .....................................,##S@@@@@@#S%%#@@@@@+,.........................................
25 .....................................:@@SSSSSSS##S##SSSSSS:.........................................
26 ....................................,#SS@#SSSSSS#@##SSSS@*,.........................................
27 ....................................;#S%S@@#SSS##S#@S##@##+,........................................
28 ...................................,#SS%%S#@#S#@S%S##@@#S%@:........................................
29 ...................................,#SSSS%%S##@S%?%S##SSSS#+,.......................................
30 ...................................,#SSSSS%%%S@S?;?SS%SSSSS@:.......................................
31 ...................................,#SSSSSS%S##SS%SSSSSSSSS@:.......................................
32 ...................................,?SSSSSS%#@%S%?%SSSSSSS%@;.......................................
33 ....................................,@SSSS%S#@SS?+?SSSSSSSS@;.......................................
34 ....................................,?#SSSSS##SSS%%SSSS%SS#%:.......................................
35 .....................................,@SSSS#@SSS%+?SSSSSSS@:........................................
36 .....................................,?#SSS#@SSS%*%SSSSSSS@;........................................
37 ......................................,?#SS##SSSSSSSSSSSS#?,........................................
38 ........................................;:;;:;;::;;::;:::;,.........................................
39 
40 */
41 
42 // File: @openzeppelin/contracts/utils/Strings.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
57      */
58     function toString(uint256 value) internal pure returns (string memory) {
59         // Inspired by OraclizeAPI's implementation - MIT licence
60         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
61 
62         if (value == 0) {
63             return "0";
64         }
65         uint256 temp = value;
66         uint256 digits;
67         while (temp != 0) {
68             digits++;
69             temp /= 10;
70         }
71         bytes memory buffer = new bytes(digits);
72         while (value != 0) {
73             digits -= 1;
74             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
75             value /= 10;
76         }
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
82      */
83     function toHexString(uint256 value) internal pure returns (string memory) {
84         if (value == 0) {
85             return "0x00";
86         }
87         uint256 temp = value;
88         uint256 length = 0;
89         while (temp != 0) {
90             length++;
91             temp >>= 8;
92         }
93         return toHexString(value, length);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
98      */
99     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Contract module that helps prevent reentrant calls to a function.
121  *
122  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
123  * available, which can be applied to functions to make sure there are no nested
124  * (reentrant) calls to them.
125  *
126  * Note that because there is a single `nonReentrant` guard, functions marked as
127  * `nonReentrant` may not call one another. This can be worked around by making
128  * those functions `private`, and then adding `external` `nonReentrant` entry
129  * points to them.
130  *
131  * TIP: If you would like to learn more about reentrancy and alternative ways
132  * to protect against it, check out our blog post
133  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
134  */
135 abstract contract ReentrancyGuard {
136     // Booleans are more expensive than uint256 or any type that takes up a full
137     // word because each write operation emits an extra SLOAD to first read the
138     // slot's contents, replace the bits taken up by the boolean, and then write
139     // back. This is the compiler's defense against contract upgrades and
140     // pointer aliasing, and it cannot be disabled.
141 
142     // The values being non-zero value makes deployment a bit more expensive,
143     // but in exchange the refund on every call to nonReentrant will be lower in
144     // amount. Since refunds are capped to a percentage of the total
145     // transaction's gas, it is best to keep them low in cases like this one, to
146     // increase the likelihood of the full refund coming into effect.
147     uint256 private constant _NOT_ENTERED = 1;
148     uint256 private constant _ENTERED = 2;
149 
150     uint256 private _status;
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         // On the first call to nonReentrant, _notEntered will be true
165         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
166 
167         // Any calls to nonReentrant after this point will fail
168         _status = _ENTERED;
169 
170         _;
171 
172         // By storing the original value once again, a refund is triggered (see
173         // https://eips.ethereum.org/EIPS/eip-2200)
174         _status = _NOT_ENTERED;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Context.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Provides information about the current execution context, including the
187  * sender of the transaction and its data. While these are generally available
188  * via msg.sender and msg.data, they should not be accessed in such a direct
189  * manner, since when dealing with meta-transactions the account sending and
190  * paying for execution may not be the actual sender (as far as an application
191  * is concerned).
192  *
193  * This contract is only required for intermediate, library-like contracts.
194  */
195 abstract contract Context {
196     function _msgSender() internal view virtual returns (address) {
197         return msg.sender;
198     }
199 
200     function _msgData() internal view virtual returns (bytes calldata) {
201         return msg.data;
202     }
203 }
204 
205 // File: @openzeppelin/contracts/access/Ownable.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @dev Contract module which provides a basic access control mechanism, where
215  * there is an account (an owner) that can be granted exclusive access to
216  * specific functions.
217  *
218  * By default, the owner account will be the one that deploys the contract. This
219  * can later be changed with {transferOwnership}.
220  *
221  * This module is used through inheritance. It will make available the modifier
222  * `onlyOwner`, which can be applied to your functions to restrict their use to
223  * the owner.
224  */
225 abstract contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev Initializes the contract setting the deployer as the initial owner.
232      */
233     constructor() {
234         _transferOwnership(_msgSender());
235     }
236 
237     /**
238      * @dev Returns the address of the current owner.
239      */
240     function owner() public view virtual returns (address) {
241         return _owner;
242     }
243 
244     /**
245      * @dev Throws if called by any account other than the owner.
246      */
247     modifier onlyOwner() {
248         require(owner() == _msgSender(), "Ownable: caller is not the owner");
249         _;
250     }
251 
252     /**
253      * @dev Leaves the contract without owner. It will not be possible to call
254      * `onlyOwner` functions anymore. Can only be called by the current owner.
255      *
256      * NOTE: Renouncing ownership will leave the contract without an owner,
257      * thereby removing any functionality that is only available to the owner.
258      */
259     function renounceOwnership() public virtual onlyOwner {
260         _transferOwnership(address(0));
261     }
262 
263     /**
264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
265      * Can only be called by the current owner.
266      */
267     function transferOwnership(address newOwner) public virtual onlyOwner {
268         require(newOwner != address(0), "Ownable: new owner is the zero address");
269         _transferOwnership(newOwner);
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      * Internal function without access restriction.
275      */
276     function _transferOwnership(address newOwner) internal virtual {
277         address oldOwner = _owner;
278         _owner = newOwner;
279         emit OwnershipTransferred(oldOwner, newOwner);
280     }
281 }
282 
283 // File: erc721a/contracts/IERC721A.sol
284 
285 
286 // ERC721A Contracts v4.0.0
287 // Creator: Chiru Labs
288 
289 pragma solidity ^0.8.4;
290 
291 /**
292  * @dev Interface of an ERC721A compliant contract.
293  */
294 interface IERC721A {
295     /**
296      * The caller must own the token or be an approved operator.
297      */
298     error ApprovalCallerNotOwnerNorApproved();
299 
300     /**
301      * The token does not exist.
302      */
303     error ApprovalQueryForNonexistentToken();
304 
305     /**
306      * The caller cannot approve to their own address.
307      */
308     error ApproveToCaller();
309 
310     /**
311      * The caller cannot approve to the current owner.
312      */
313     error ApprovalToCurrentOwner();
314 
315     /**
316      * Cannot query the balance for the zero address.
317      */
318     error BalanceQueryForZeroAddress();
319 
320     /**
321      * Cannot mint to the zero address.
322      */
323     error MintToZeroAddress();
324 
325     /**
326      * The quantity of tokens minted must be more than zero.
327      */
328     error MintZeroQuantity();
329 
330     /**
331      * The token does not exist.
332      */
333     error OwnerQueryForNonexistentToken();
334 
335     /**
336      * The caller must own the token or be an approved operator.
337      */
338     error TransferCallerNotOwnerNorApproved();
339 
340     /**
341      * The token must be owned by `from`.
342      */
343     error TransferFromIncorrectOwner();
344 
345     /**
346      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
347      */
348     error TransferToNonERC721ReceiverImplementer();
349 
350     /**
351      * Cannot transfer to the zero address.
352      */
353     error TransferToZeroAddress();
354 
355     /**
356      * The token does not exist.
357      */
358     error URIQueryForNonexistentToken();
359 
360     struct TokenOwnership {
361         // The address of the owner.
362         address addr;
363         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
364         uint64 startTimestamp;
365         // Whether the token has been burned.
366         bool burned;
367     }
368 
369     /**
370      * @dev Returns the total amount of tokens stored by the contract.
371      *
372      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     // ==============================
377     //            IERC165
378     // ==============================
379 
380     /**
381      * @dev Returns true if this contract implements the interface defined by
382      * `interfaceId`. See the corresponding
383      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
384      * to learn more about how these ids are created.
385      *
386      * This function call must use less than 30 000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool);
389 
390     // ==============================
391     //            IERC721
392     // ==============================
393 
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId,
440         bytes calldata data
441     ) external;
442 
443     /**
444      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
445      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `tokenId` token must exist and be owned by `from`.
452      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
454      *
455      * Emits a {Transfer} event.
456      */
457     function safeTransferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Transfers `tokenId` token from `from` to `to`.
465      *
466      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      *
475      * Emits a {Transfer} event.
476      */
477     function transferFrom(
478         address from,
479         address to,
480         uint256 tokenId
481     ) external;
482 
483     /**
484      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
485      * The approval is cleared when the token is transferred.
486      *
487      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
488      *
489      * Requirements:
490      *
491      * - The caller must own the token or be an approved operator.
492      * - `tokenId` must exist.
493      *
494      * Emits an {Approval} event.
495      */
496     function approve(address to, uint256 tokenId) external;
497 
498     /**
499      * @dev Approve or remove `operator` as an operator for the caller.
500      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
501      *
502      * Requirements:
503      *
504      * - The `operator` cannot be the caller.
505      *
506      * Emits an {ApprovalForAll} event.
507      */
508     function setApprovalForAll(address operator, bool _approved) external;
509 
510     /**
511      * @dev Returns the account approved for `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function getApproved(uint256 tokenId) external view returns (address operator);
518 
519     /**
520      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
521      *
522      * See {setApprovalForAll}
523      */
524     function isApprovedForAll(address owner, address operator) external view returns (bool);
525 
526     // ==============================
527     //        IERC721Metadata
528     // ==============================
529 
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 
546 // File: erc721a/contracts/ERC721A.sol
547 
548 
549 // ERC721A Contracts v4.0.0
550 // Creator: Chiru Labs
551 
552 pragma solidity ^0.8.4;
553 
554 
555 /**
556  * @dev ERC721 token receiver interface.
557  */
558 interface ERC721A__IERC721Receiver {
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
569  * the Metadata extension. Built to optimize for lower gas during batch mints.
570  *
571  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
572  *
573  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
574  *
575  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
576  */
577 contract ERC721A is IERC721A {
578     // Mask of an entry in packed address data.
579     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
580 
581     // The bit position of `numberMinted` in packed address data.
582     uint256 private constant BITPOS_NUMBER_MINTED = 64;
583 
584     // The bit position of `numberBurned` in packed address data.
585     uint256 private constant BITPOS_NUMBER_BURNED = 128;
586 
587     // The bit position of `aux` in packed address data.
588     uint256 private constant BITPOS_AUX = 192;
589 
590     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
591     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
592 
593     // The bit position of `startTimestamp` in packed ownership.
594     uint256 private constant BITPOS_START_TIMESTAMP = 160;
595 
596     // The bit mask of the `burned` bit in packed ownership.
597     uint256 private constant BITMASK_BURNED = 1 << 224;
598     
599     // The bit position of the `nextInitialized` bit in packed ownership.
600     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
601 
602     // The bit mask of the `nextInitialized` bit in packed ownership.
603     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
604 
605     // The tokenId of the next token to be minted.
606     uint256 private _currentIndex;
607 
608     // The number of tokens burned.
609     uint256 private _burnCounter;
610 
611     // Token name
612     string private _name;
613 
614     // Token symbol
615     string private _symbol;
616 
617     // Mapping from token ID to ownership details
618     // An empty struct value does not necessarily mean the token is unowned.
619     // See `_packedOwnershipOf` implementation for details.
620     //
621     // Bits Layout:
622     // - [0..159]   `addr`
623     // - [160..223] `startTimestamp`
624     // - [224]      `burned`
625     // - [225]      `nextInitialized`
626     mapping(uint256 => uint256) private _packedOwnerships;
627 
628     // Mapping owner address to address data.
629     //
630     // Bits Layout:
631     // - [0..63]    `balance`
632     // - [64..127]  `numberMinted`
633     // - [128..191] `numberBurned`
634     // - [192..255] `aux`
635     mapping(address => uint256) private _packedAddressData;
636 
637     // Mapping from token ID to approved address.
638     mapping(uint256 => address) private _tokenApprovals;
639 
640     // Mapping from owner to operator approvals
641     mapping(address => mapping(address => bool)) private _operatorApprovals;
642 
643     constructor(string memory name_, string memory symbol_) {
644         _name = name_;
645         _symbol = symbol_;
646         _currentIndex = _startTokenId();
647     }
648 
649     /**
650      * @dev Returns the starting token ID. 
651      * To change the starting token ID, please override this function.
652      */
653     function _startTokenId() internal view virtual returns (uint256) {
654         return 0;
655     }
656 
657     /**
658      * @dev Returns the next token ID to be minted.
659      */
660     function _nextTokenId() internal view returns (uint256) {
661         return _currentIndex;
662     }
663 
664     /**
665      * @dev Returns the total number of tokens in existence.
666      * Burned tokens will reduce the count. 
667      * To get the total number of tokens minted, please see `_totalMinted`.
668      */
669     function totalSupply() public view override returns (uint256) {
670         // Counter underflow is impossible as _burnCounter cannot be incremented
671         // more than `_currentIndex - _startTokenId()` times.
672         unchecked {
673             return _currentIndex - _burnCounter - _startTokenId();
674         }
675     }
676 
677     /**
678      * @dev Returns the total amount of tokens minted in the contract.
679      */
680     function _totalMinted() internal view returns (uint256) {
681         // Counter underflow is impossible as _currentIndex does not decrement,
682         // and it is initialized to `_startTokenId()`
683         unchecked {
684             return _currentIndex - _startTokenId();
685         }
686     }
687 
688     /**
689      * @dev Returns the total number of tokens burned.
690      */
691     function _totalBurned() internal view returns (uint256) {
692         return _burnCounter;
693     }
694 
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         // The interface IDs are constants representing the first 4 bytes of the XOR of
700         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
701         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
702         return
703             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
704             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
705             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner) public view override returns (uint256) {
712         if (owner == address(0)) revert BalanceQueryForZeroAddress();
713         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
714     }
715 
716     /**
717      * Returns the number of tokens minted by `owner`.
718      */
719     function _numberMinted(address owner) internal view returns (uint256) {
720         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
721     }
722 
723     /**
724      * Returns the number of tokens burned by or on behalf of `owner`.
725      */
726     function _numberBurned(address owner) internal view returns (uint256) {
727         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
728     }
729 
730     /**
731      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
732      */
733     function _getAux(address owner) internal view returns (uint64) {
734         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
735     }
736 
737     /**
738      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
739      * If there are multiple variables, please pack them into a uint64.
740      */
741     function _setAux(address owner, uint64 aux) internal {
742         uint256 packed = _packedAddressData[owner];
743         uint256 auxCasted;
744         assembly { // Cast aux without masking.
745             auxCasted := aux
746         }
747         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
748         _packedAddressData[owner] = packed;
749     }
750 
751     /**
752      * Returns the packed ownership data of `tokenId`.
753      */
754     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
755         uint256 curr = tokenId;
756 
757         unchecked {
758             if (_startTokenId() <= curr)
759                 if (curr < _currentIndex) {
760                     uint256 packed = _packedOwnerships[curr];
761                     // If not burned.
762                     if (packed & BITMASK_BURNED == 0) {
763                         // Invariant:
764                         // There will always be an ownership that has an address and is not burned
765                         // before an ownership that does not have an address and is not burned.
766                         // Hence, curr will not underflow.
767                         //
768                         // We can directly compare the packed value.
769                         // If the address is zero, packed is zero.
770                         while (packed == 0) {
771                             packed = _packedOwnerships[--curr];
772                         }
773                         return packed;
774                     }
775                 }
776         }
777         revert OwnerQueryForNonexistentToken();
778     }
779 
780     /**
781      * Returns the unpacked `TokenOwnership` struct from `packed`.
782      */
783     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
784         ownership.addr = address(uint160(packed));
785         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
786         ownership.burned = packed & BITMASK_BURNED != 0;
787     }
788 
789     /**
790      * Returns the unpacked `TokenOwnership` struct at `index`.
791      */
792     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
793         return _unpackedOwnership(_packedOwnerships[index]);
794     }
795 
796     /**
797      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
798      */
799     function _initializeOwnershipAt(uint256 index) internal {
800         if (_packedOwnerships[index] == 0) {
801             _packedOwnerships[index] = _packedOwnershipOf(index);
802         }
803     }
804 
805     /**
806      * Gas spent here starts off proportional to the maximum mint batch size.
807      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
808      */
809     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
810         return _unpackedOwnership(_packedOwnershipOf(tokenId));
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view override returns (address) {
817         return address(uint160(_packedOwnershipOf(tokenId)));
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-name}.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-symbol}.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-tokenURI}.
836      */
837     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
838         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
839 
840         string memory baseURI = _baseURI();
841         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
842     }
843 
844     /**
845      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
846      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
847      * by default, can be overriden in child contracts.
848      */
849     function _baseURI() internal view virtual returns (string memory) {
850         return '';
851     }
852 
853     /**
854      * @dev Casts the address to uint256 without masking.
855      */
856     function _addressToUint256(address value) private pure returns (uint256 result) {
857         assembly {
858             result := value
859         }
860     }
861 
862     /**
863      * @dev Casts the boolean to uint256 without branching.
864      */
865     function _boolToUint256(bool value) private pure returns (uint256 result) {
866         assembly {
867             result := value
868         }
869     }
870 
871     /**
872      * @dev See {IERC721-approve}.
873      */
874     function approve(address to, uint256 tokenId) public override {
875         address owner = address(uint160(_packedOwnershipOf(tokenId)));
876         if (to == owner) revert ApprovalToCurrentOwner();
877 
878         if (_msgSenderERC721A() != owner)
879             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
880                 revert ApprovalCallerNotOwnerNorApproved();
881             }
882 
883         _tokenApprovals[tokenId] = to;
884         emit Approval(owner, to, tokenId);
885     }
886 
887     /**
888      * @dev See {IERC721-getApproved}.
889      */
890     function getApproved(uint256 tokenId) public view override returns (address) {
891         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
892 
893         return _tokenApprovals[tokenId];
894     }
895 
896     /**
897      * @dev See {IERC721-setApprovalForAll}.
898      */
899     function setApprovalForAll(address operator, bool approved) public virtual override {
900         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
901 
902         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
903         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
904     }
905 
906     /**
907      * @dev See {IERC721-isApprovedForAll}.
908      */
909     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
910         return _operatorApprovals[owner][operator];
911     }
912 
913     /**
914      * @dev See {IERC721-transferFrom}.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         _transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         safeTransferFrom(from, to, tokenId, '');
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public virtual override {
944         _transfer(from, to, tokenId);
945         if (to.code.length != 0)
946             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
947                 revert TransferToNonERC721ReceiverImplementer();
948             }
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      */
958     function _exists(uint256 tokenId) internal view returns (bool) {
959         return
960             _startTokenId() <= tokenId &&
961             tokenId < _currentIndex && // If within bounds,
962             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
963     }
964 
965     /**
966      * @dev Equivalent to `_safeMint(to, quantity, '')`.
967      */
968     function _safeMint(address to, uint256 quantity) internal {
969         _safeMint(to, quantity, '');
970     }
971 
972     /**
973      * @dev Safely mints `quantity` tokens and transfers them to `to`.
974      *
975      * Requirements:
976      *
977      * - If `to` refers to a smart contract, it must implement
978      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
979      * - `quantity` must be greater than 0.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeMint(
984         address to,
985         uint256 quantity,
986         bytes memory _data
987     ) internal {
988         uint256 startTokenId = _currentIndex;
989         if (to == address(0)) revert MintToZeroAddress();
990         if (quantity == 0) revert MintZeroQuantity();
991 
992         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
993 
994         // Overflows are incredibly unrealistic.
995         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
996         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
997         unchecked {
998             // Updates:
999             // - `balance += quantity`.
1000             // - `numberMinted += quantity`.
1001             //
1002             // We can directly add to the balance and number minted.
1003             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1004 
1005             // Updates:
1006             // - `address` to the owner.
1007             // - `startTimestamp` to the timestamp of minting.
1008             // - `burned` to `false`.
1009             // - `nextInitialized` to `quantity == 1`.
1010             _packedOwnerships[startTokenId] =
1011                 _addressToUint256(to) |
1012                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1013                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1014 
1015             uint256 updatedIndex = startTokenId;
1016             uint256 end = updatedIndex + quantity;
1017 
1018             if (to.code.length != 0) {
1019                 do {
1020                     emit Transfer(address(0), to, updatedIndex);
1021                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1022                         revert TransferToNonERC721ReceiverImplementer();
1023                     }
1024                 } while (updatedIndex < end);
1025                 // Reentrancy protection
1026                 if (_currentIndex != startTokenId) revert();
1027             } else {
1028                 do {
1029                     emit Transfer(address(0), to, updatedIndex++);
1030                 } while (updatedIndex < end);
1031             }
1032             _currentIndex = updatedIndex;
1033         }
1034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1035     }
1036 
1037     /**
1038      * @dev Mints `quantity` tokens and transfers them to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `quantity` must be greater than 0.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _mint(address to, uint256 quantity) internal {
1048         uint256 startTokenId = _currentIndex;
1049         if (to == address(0)) revert MintToZeroAddress();
1050         if (quantity == 0) revert MintZeroQuantity();
1051 
1052         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1053 
1054         // Overflows are incredibly unrealistic.
1055         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1056         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1057         unchecked {
1058             // Updates:
1059             // - `balance += quantity`.
1060             // - `numberMinted += quantity`.
1061             //
1062             // We can directly add to the balance and number minted.
1063             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1064 
1065             // Updates:
1066             // - `address` to the owner.
1067             // - `startTimestamp` to the timestamp of minting.
1068             // - `burned` to `false`.
1069             // - `nextInitialized` to `quantity == 1`.
1070             _packedOwnerships[startTokenId] =
1071                 _addressToUint256(to) |
1072                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1073                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1074 
1075             uint256 updatedIndex = startTokenId;
1076             uint256 end = updatedIndex + quantity;
1077 
1078             do {
1079                 emit Transfer(address(0), to, updatedIndex++);
1080             } while (updatedIndex < end);
1081 
1082             _currentIndex = updatedIndex;
1083         }
1084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1085     }
1086 
1087     /**
1088      * @dev Transfers `tokenId` from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `tokenId` token must be owned by `from`.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _transfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) private {
1102         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1103 
1104         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1105 
1106         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1107             isApprovedForAll(from, _msgSenderERC721A()) ||
1108             getApproved(tokenId) == _msgSenderERC721A());
1109 
1110         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1111         if (to == address(0)) revert TransferToZeroAddress();
1112 
1113         _beforeTokenTransfers(from, to, tokenId, 1);
1114 
1115         // Clear approvals from the previous owner.
1116         delete _tokenApprovals[tokenId];
1117 
1118         // Underflow of the sender's balance is impossible because we check for
1119         // ownership above and the recipient's balance can't realistically overflow.
1120         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1121         unchecked {
1122             // We can directly increment and decrement the balances.
1123             --_packedAddressData[from]; // Updates: `balance -= 1`.
1124             ++_packedAddressData[to]; // Updates: `balance += 1`.
1125 
1126             // Updates:
1127             // - `address` to the next owner.
1128             // - `startTimestamp` to the timestamp of transfering.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `true`.
1131             _packedOwnerships[tokenId] =
1132                 _addressToUint256(to) |
1133                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1134                 BITMASK_NEXT_INITIALIZED;
1135 
1136             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1137             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1138                 uint256 nextTokenId = tokenId + 1;
1139                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1140                 if (_packedOwnerships[nextTokenId] == 0) {
1141                     // If the next slot is within bounds.
1142                     if (nextTokenId != _currentIndex) {
1143                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1144                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1145                     }
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev Equivalent to `_burn(tokenId, false)`.
1156      */
1157     function _burn(uint256 tokenId) internal virtual {
1158         _burn(tokenId, false);
1159     }
1160 
1161     /**
1162      * @dev Destroys `tokenId`.
1163      * The approval is cleared when the token is burned.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must exist.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1172         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1173 
1174         address from = address(uint160(prevOwnershipPacked));
1175 
1176         if (approvalCheck) {
1177             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1178                 isApprovedForAll(from, _msgSenderERC721A()) ||
1179                 getApproved(tokenId) == _msgSenderERC721A());
1180 
1181             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1182         }
1183 
1184         _beforeTokenTransfers(from, address(0), tokenId, 1);
1185 
1186         // Clear approvals from the previous owner.
1187         delete _tokenApprovals[tokenId];
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1192         unchecked {
1193             // Updates:
1194             // - `balance -= 1`.
1195             // - `numberBurned += 1`.
1196             //
1197             // We can directly decrement the balance, and increment the number burned.
1198             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1199             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1200 
1201             // Updates:
1202             // - `address` to the last owner.
1203             // - `startTimestamp` to the timestamp of burning.
1204             // - `burned` to `true`.
1205             // - `nextInitialized` to `true`.
1206             _packedOwnerships[tokenId] =
1207                 _addressToUint256(from) |
1208                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1209                 BITMASK_BURNED | 
1210                 BITMASK_NEXT_INITIALIZED;
1211 
1212             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1213             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1214                 uint256 nextTokenId = tokenId + 1;
1215                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1216                 if (_packedOwnerships[nextTokenId] == 0) {
1217                     // If the next slot is within bounds.
1218                     if (nextTokenId != _currentIndex) {
1219                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1220                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1221                     }
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, address(0), tokenId);
1227         _afterTokenTransfers(from, address(0), tokenId, 1);
1228 
1229         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1230         unchecked {
1231             _burnCounter++;
1232         }
1233     }
1234 
1235     /**
1236      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1237      *
1238      * @param from address representing the previous owner of the given token ID
1239      * @param to target address that will receive the tokens
1240      * @param tokenId uint256 ID of the token to be transferred
1241      * @param _data bytes optional data to send along with the call
1242      * @return bool whether the call correctly returned the expected magic value
1243      */
1244     function _checkContractOnERC721Received(
1245         address from,
1246         address to,
1247         uint256 tokenId,
1248         bytes memory _data
1249     ) private returns (bool) {
1250         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1251             bytes4 retval
1252         ) {
1253             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1254         } catch (bytes memory reason) {
1255             if (reason.length == 0) {
1256                 revert TransferToNonERC721ReceiverImplementer();
1257             } else {
1258                 assembly {
1259                     revert(add(32, reason), mload(reason))
1260                 }
1261             }
1262         }
1263     }
1264 
1265     /**
1266      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1267      * And also called before burning one token.
1268      *
1269      * startTokenId - the first token id to be transferred
1270      * quantity - the amount to be transferred
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, `tokenId` will be burned by `from`.
1278      * - `from` and `to` are never both zero.
1279      */
1280     function _beforeTokenTransfers(
1281         address from,
1282         address to,
1283         uint256 startTokenId,
1284         uint256 quantity
1285     ) internal virtual {}
1286 
1287     /**
1288      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1289      * minting.
1290      * And also called after one token has been burned.
1291      *
1292      * startTokenId - the first token id to be transferred
1293      * quantity - the amount to be transferred
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` has been minted for `to`.
1300      * - When `to` is zero, `tokenId` has been burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _afterTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 
1310     /**
1311      * @dev Returns the message sender (defaults to `msg.sender`).
1312      *
1313      * If you are writing GSN compatible contracts, you need to override this function.
1314      */
1315     function _msgSenderERC721A() internal view virtual returns (address) {
1316         return msg.sender;
1317     }
1318 
1319     /**
1320      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1321      */
1322     function _toString(uint256 value) internal pure returns (string memory ptr) {
1323         assembly {
1324             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1325             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1326             // We will need 1 32-byte word to store the length, 
1327             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1328             ptr := add(mload(0x40), 128)
1329             // Update the free memory pointer to allocate.
1330             mstore(0x40, ptr)
1331 
1332             // Cache the end of the memory to calculate the length later.
1333             let end := ptr
1334 
1335             // We write the string from the rightmost digit to the leftmost digit.
1336             // The following is essentially a do-while loop that also handles the zero case.
1337             // Costs a bit more than early returning for the zero case,
1338             // but cheaper in terms of deployment and overall runtime costs.
1339             for { 
1340                 // Initialize and perform the first pass without check.
1341                 let temp := value
1342                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1343                 ptr := sub(ptr, 1)
1344                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1345                 mstore8(ptr, add(48, mod(temp, 10)))
1346                 temp := div(temp, 10)
1347             } temp { 
1348                 // Keep dividing `temp` until zero.
1349                 temp := div(temp, 10)
1350             } { // Body of the for loop.
1351                 ptr := sub(ptr, 1)
1352                 mstore8(ptr, add(48, mod(temp, 10)))
1353             }
1354             
1355             let length := sub(end, ptr)
1356             // Move the pointer 32 bytes leftwards to make room for the length.
1357             ptr := sub(ptr, 32)
1358             // Store the length.
1359             mstore(ptr, length)
1360         }
1361     }
1362 }
1363 
1364 // File: contracts/escapeTheAgenda.sol
1365 
1366 pragma solidity >=0.8.9 <0.9.0;
1367 
1368 contract MoonOwlz is ERC721A, Ownable, ReentrancyGuard {
1369   using Strings for uint256;
1370 
1371   string public baseURI = "";
1372   string public hiddenURI = "";
1373   uint256 public maxOwlz = 10000;
1374   uint256 public MAX_PER_TXN = 10;
1375   uint256 public publicSaleCost = 0 ether;
1376   bool public paused = true;
1377   bool public isPublicSaleActive = true;
1378   bool public isRevealed = false;
1379   uint256 constant EXTRA_MINT_PRICE = 0.0069 ether;
1380 
1381 
1382   mapping(address => uint256) public _freeMintedCount;
1383 
1384   
1385   constructor() ERC721A("MoonOwlz", "MOWL") {
1386   }
1387 
1388     
1389 
1390    function getMintCost(uint256 _numberOfTokens, address searchAddress) public view virtual returns (uint256){
1391        
1392     uint256 payForCount = _numberOfTokens;
1393     uint256 freeMintCount = _freeMintedCount[searchAddress];
1394 
1395     if (freeMintCount < 1) {
1396       if (_numberOfTokens > 1) {
1397         payForCount = _numberOfTokens - 1;
1398       } else {
1399         payForCount = 0;
1400       }
1401     }
1402 
1403     return payForCount * EXTRA_MINT_PRICE;
1404    }
1405 
1406   function mintNFT(uint256 _numberOfTokens)
1407     external
1408     payable
1409     nonReentrant
1410     {
1411      require(!paused, "Sale is paused");
1412      require(isPublicSaleActive, "Public sale is not open");
1413      require(totalSupply() + _numberOfTokens <= maxOwlz, "Not enough Owlz for mint");
1414      require(_numberOfTokens > 0 , "Invalid mint amount!");
1415      require( _numberOfTokens <= MAX_PER_TXN,"Max Owlz per TXN should not exceed");
1416 
1417      uint256 payForCount = _numberOfTokens;
1418      uint256 freeMintCount = _freeMintedCount[msg.sender];
1419 
1420      if (freeMintCount < 1) {
1421       if (_numberOfTokens > 1) {
1422         payForCount = _numberOfTokens - 1;
1423       } else {
1424         payForCount = 0;
1425       }
1426 
1427       _freeMintedCount[msg.sender] = 1;
1428     }
1429 
1430     require(msg.value >= payForCount * EXTRA_MINT_PRICE, "ETH value sent is not correct");
1431       _safeMint(msg.sender, _numberOfTokens); 
1432     }
1433 
1434     function getNftPrice() public view returns (uint256){
1435      return publicSaleCost;
1436     }
1437 
1438    
1439   // Owner quota for the team and giveaways
1440   function ownerMint(uint256 numberOfTokens, address _receiver)
1441     public
1442     nonReentrant
1443     onlyOwner
1444     {
1445       require(totalSupply() + numberOfTokens <= maxOwlz, "Not enough Owlz for mint");
1446       require(numberOfTokens > 0 , "Invalid mint amount!");
1447       _safeMint(_receiver, numberOfTokens);
1448     }
1449 
1450 
1451   function setBaseURI(string memory _baseURI) external onlyOwner {
1452     baseURI = _baseURI;
1453   }
1454 
1455   function setHiddenURI(string memory _hiddenURI) external onlyOwner {
1456     hiddenURI = _hiddenURI;
1457   }
1458 
1459   function setPaused(bool _state) external onlyOwner {
1460     paused = _state;
1461   }
1462 
1463   function setRevealed(bool _state) external onlyOwner {
1464     isRevealed = _state;
1465   }
1466 
1467   function openPublicSale(bool _state) external onlyOwner {
1468     isPublicSaleActive = _state;
1469   }
1470 
1471 
1472   function _startTokenId() internal view virtual override returns (uint256) {
1473     return 1;
1474   }
1475 
1476   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1477     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1478 
1479    if(isRevealed==false)
1480     return hiddenURI;
1481 
1482     return
1483       string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1484   }
1485 
1486   function setPublicSaleCost(uint256 _cost) external onlyOwner {
1487     publicSaleCost = _cost;
1488   }
1489 
1490 
1491   function withdraw() public onlyOwner {    
1492     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1493     require(os);    
1494   }
1495 }