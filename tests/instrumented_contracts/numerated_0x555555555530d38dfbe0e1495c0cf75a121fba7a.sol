1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP.
181  */
182 interface IERC20 {
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `to`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transfer(address to, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `from` to `to` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(
251         address from,
252         address to,
253         uint256 amount
254     ) external returns (bool);
255 }
256 
257 // File: @openzeppelin/contracts/utils/Strings.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev String operations.
266  */
267 library Strings {
268     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
272      */
273     function toString(uint256 value) internal pure returns (string memory) {
274         // Inspired by OraclizeAPI's implementation - MIT licence
275         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
276 
277         if (value == 0) {
278             return "0";
279         }
280         uint256 temp = value;
281         uint256 digits;
282         while (temp != 0) {
283             digits++;
284             temp /= 10;
285         }
286         bytes memory buffer = new bytes(digits);
287         while (value != 0) {
288             digits -= 1;
289             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
290             value /= 10;
291         }
292         return string(buffer);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
297      */
298     function toHexString(uint256 value) internal pure returns (string memory) {
299         if (value == 0) {
300             return "0x00";
301         }
302         uint256 temp = value;
303         uint256 length = 0;
304         while (temp != 0) {
305             length++;
306             temp >>= 8;
307         }
308         return toHexString(value, length);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
313      */
314     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
315         bytes memory buffer = new bytes(2 * length + 2);
316         buffer[0] = "0";
317         buffer[1] = "x";
318         for (uint256 i = 2 * length + 1; i > 1; --i) {
319             buffer[i] = _HEX_SYMBOLS[value & 0xf];
320             value >>= 4;
321         }
322         require(value == 0, "Strings: hex length insufficient");
323         return string(buffer);
324     }
325 }
326 
327 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
328 
329 
330 // ERC721A Contracts v4.0.0
331 // Creator: Chiru Labs
332 
333 pragma solidity ^0.8.4;
334 
335 /**
336  * @dev Interface of an ERC721A compliant contract.
337  */
338 interface IERC721A {
339     /**
340      * The caller must own the token or be an approved operator.
341      */
342     error ApprovalCallerNotOwnerNorApproved();
343 
344     /**
345      * The token does not exist.
346      */
347     error ApprovalQueryForNonexistentToken();
348 
349     /**
350      * The caller cannot approve to their own address.
351      */
352     error ApproveToCaller();
353 
354     /**
355      * Cannot query the balance for the zero address.
356      */
357     error BalanceQueryForZeroAddress();
358 
359     /**
360      * Cannot mint to the zero address.
361      */
362     error MintToZeroAddress();
363 
364     /**
365      * The quantity of tokens minted must be more than zero.
366      */
367     error MintZeroQuantity();
368 
369     /**
370      * The token does not exist.
371      */
372     error OwnerQueryForNonexistentToken();
373 
374     /**
375      * The caller must own the token or be an approved operator.
376      */
377     error TransferCallerNotOwnerNorApproved();
378 
379     /**
380      * The token must be owned by `from`.
381      */
382     error TransferFromIncorrectOwner();
383 
384     /**
385      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
386      */
387     error TransferToNonERC721ReceiverImplementer();
388 
389     /**
390      * Cannot transfer to the zero address.
391      */
392     error TransferToZeroAddress();
393 
394     /**
395      * The token does not exist.
396      */
397     error URIQueryForNonexistentToken();
398 
399     struct TokenOwnership {
400         // The address of the owner.
401         address addr;
402         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
403         uint64 startTimestamp;
404         // Whether the token has been burned.
405         bool burned;
406     }
407 
408     /**
409      * @dev Returns the total amount of tokens stored by the contract.
410      *
411      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
412      */
413     function totalSupply() external view returns (uint256);
414 
415     // ==============================
416     //            IERC165
417     // ==============================
418 
419     /**
420      * @dev Returns true if this contract implements the interface defined by
421      * `interfaceId`. See the corresponding
422      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
423      * to learn more about how these ids are created.
424      *
425      * This function call must use less than 30 000 gas.
426      */
427     function supportsInterface(bytes4 interfaceId) external view returns (bool);
428 
429     // ==============================
430     //            IERC721
431     // ==============================
432 
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
440      */
441     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in ``owner``'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must exist and be owned by `from`.
470      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId,
479         bytes calldata data
480     ) external;
481 
482     /**
483      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
484      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Transfers `tokenId` token from `from` to `to`.
504      *
505      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      *
514      * Emits a {Transfer} event.
515      */
516     function transferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
524      * The approval is cleared when the token is transferred.
525      *
526      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
527      *
528      * Requirements:
529      *
530      * - The caller must own the token or be an approved operator.
531      * - `tokenId` must exist.
532      *
533      * Emits an {Approval} event.
534      */
535     function approve(address to, uint256 tokenId) external;
536 
537     /**
538      * @dev Approve or remove `operator` as an operator for the caller.
539      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
540      *
541      * Requirements:
542      *
543      * - The `operator` cannot be the caller.
544      *
545      * Emits an {ApprovalForAll} event.
546      */
547     function setApprovalForAll(address operator, bool _approved) external;
548 
549     /**
550      * @dev Returns the account approved for `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function getApproved(uint256 tokenId) external view returns (address operator);
557 
558     /**
559      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
560      *
561      * See {setApprovalForAll}
562      */
563     function isApprovedForAll(address owner, address operator) external view returns (bool);
564 
565     // ==============================
566     //        IERC721Metadata
567     // ==============================
568 
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
586 
587 
588 // ERC721A Contracts v4.0.0
589 // Creator: Chiru Labs
590 
591 pragma solidity ^0.8.4;
592 
593 
594 /**
595  * @dev ERC721 token receiver interface.
596  */
597 interface ERC721A__IERC721Receiver {
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
611  *
612  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  *
614  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
615  */
616 contract ERC721A is IERC721A {
617     // Mask of an entry in packed address data.
618     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
619 
620     // The bit position of `numberMinted` in packed address data.
621     uint256 private constant BITPOS_NUMBER_MINTED = 64;
622 
623     // The bit position of `numberBurned` in packed address data.
624     uint256 private constant BITPOS_NUMBER_BURNED = 128;
625 
626     // The bit position of `aux` in packed address data.
627     uint256 private constant BITPOS_AUX = 192;
628 
629     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
630     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
631 
632     // The bit position of `startTimestamp` in packed ownership.
633     uint256 private constant BITPOS_START_TIMESTAMP = 160;
634 
635     // The bit mask of the `burned` bit in packed ownership.
636     uint256 private constant BITMASK_BURNED = 1 << 224;
637 
638     // The bit position of the `nextInitialized` bit in packed ownership.
639     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
640 
641     // The bit mask of the `nextInitialized` bit in packed ownership.
642     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
643 
644     // The tokenId of the next token to be minted.
645     uint256 private _currentIndex;
646 
647     // The number of tokens burned.
648     uint256 private _burnCounter;
649 
650     // Token name
651     string private _name;
652 
653     // Token symbol
654     string private _symbol;
655 
656     // Mapping from token ID to ownership details
657     // An empty struct value does not necessarily mean the token is unowned.
658     // See `_packedOwnershipOf` implementation for details.
659     //
660     // Bits Layout:
661     // - [0..159]   `addr`
662     // - [160..223] `startTimestamp`
663     // - [224]      `burned`
664     // - [225]      `nextInitialized`
665     mapping(uint256 => uint256) private _packedOwnerships;
666 
667     // Mapping owner address to address data.
668     //
669     // Bits Layout:
670     // - [0..63]    `balance`
671     // - [64..127]  `numberMinted`
672     // - [128..191] `numberBurned`
673     // - [192..255] `aux`
674     mapping(address => uint256) private _packedAddressData;
675 
676     // Mapping from token ID to approved address.
677     mapping(uint256 => address) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685         _currentIndex = _startTokenId();
686     }
687 
688     /**
689      * @dev Returns the starting token ID.
690      * To change the starting token ID, please override this function.
691      */
692     function _startTokenId() internal view virtual returns (uint256) {
693         return 0;
694     }
695 
696     /**
697      * @dev Returns the next token ID to be minted.
698      */
699     function _nextTokenId() internal view returns (uint256) {
700         return _currentIndex;
701     }
702 
703     /**
704      * @dev Returns the total number of tokens in existence.
705      * Burned tokens will reduce the count.
706      * To get the total number of tokens minted, please see `_totalMinted`.
707      */
708     function totalSupply() public view override returns (uint256) {
709         // Counter underflow is impossible as _burnCounter cannot be incremented
710         // more than `_currentIndex - _startTokenId()` times.
711         unchecked {
712             return _currentIndex - _burnCounter - _startTokenId();
713         }
714     }
715 
716     /**
717      * @dev Returns the total amount of tokens minted in the contract.
718      */
719     function _totalMinted() internal view returns (uint256) {
720         // Counter underflow is impossible as _currentIndex does not decrement,
721         // and it is initialized to `_startTokenId()`
722         unchecked {
723             return _currentIndex - _startTokenId();
724         }
725     }
726 
727     /**
728      * @dev Returns the total number of tokens burned.
729      */
730     function _totalBurned() internal view returns (uint256) {
731         return _burnCounter;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         // The interface IDs are constants representing the first 4 bytes of the XOR of
739         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
740         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
741         return
742             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
743             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
744             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
745     }
746 
747     /**
748      * @dev See {IERC721-balanceOf}.
749      */
750     function balanceOf(address owner) public view override returns (uint256) {
751         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
752         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
753     }
754 
755     /**
756      * Returns the number of tokens minted by `owner`.
757      */
758     function _numberMinted(address owner) internal view returns (uint256) {
759         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
760     }
761 
762     /**
763      * Returns the number of tokens burned by or on behalf of `owner`.
764      */
765     function _numberBurned(address owner) internal view returns (uint256) {
766         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
767     }
768 
769     /**
770      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
771      */
772     function _getAux(address owner) internal view returns (uint64) {
773         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
774     }
775 
776     /**
777      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
778      * If there are multiple variables, please pack them into a uint64.
779      */
780     function _setAux(address owner, uint64 aux) internal {
781         uint256 packed = _packedAddressData[owner];
782         uint256 auxCasted;
783         assembly {
784             // Cast aux without masking.
785             auxCasted := aux
786         }
787         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
788         _packedAddressData[owner] = packed;
789     }
790 
791     /**
792      * Returns the packed ownership data of `tokenId`.
793      */
794     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
795         uint256 curr = tokenId;
796 
797         unchecked {
798             if (_startTokenId() <= curr)
799                 if (curr < _currentIndex) {
800                     uint256 packed = _packedOwnerships[curr];
801                     // If not burned.
802                     if (packed & BITMASK_BURNED == 0) {
803                         // Invariant:
804                         // There will always be an ownership that has an address and is not burned
805                         // before an ownership that does not have an address and is not burned.
806                         // Hence, curr will not underflow.
807                         //
808                         // We can directly compare the packed value.
809                         // If the address is zero, packed is zero.
810                         while (packed == 0) {
811                             packed = _packedOwnerships[--curr];
812                         }
813                         return packed;
814                     }
815                 }
816         }
817         revert OwnerQueryForNonexistentToken();
818     }
819 
820     /**
821      * Returns the unpacked `TokenOwnership` struct from `packed`.
822      */
823     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
824         ownership.addr = address(uint160(packed));
825         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
826         ownership.burned = packed & BITMASK_BURNED != 0;
827     }
828 
829     /**
830      * Returns the unpacked `TokenOwnership` struct at `index`.
831      */
832     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
833         return _unpackedOwnership(_packedOwnerships[index]);
834     }
835 
836     /**
837      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
838      */
839     function _initializeOwnershipAt(uint256 index) internal {
840         if (_packedOwnerships[index] == 0) {
841             _packedOwnerships[index] = _packedOwnershipOf(index);
842         }
843     }
844 
845     /**
846      * Gas spent here starts off proportional to the maximum mint batch size.
847      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
848      */
849     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
850         return _unpackedOwnership(_packedOwnershipOf(tokenId));
851     }
852 
853     /**
854      * @dev See {IERC721-ownerOf}.
855      */
856     function ownerOf(uint256 tokenId) public view override returns (address) {
857         return address(uint160(_packedOwnershipOf(tokenId)));
858     }
859 
860     /**
861      * @dev See {IERC721Metadata-name}.
862      */
863     function name() public view virtual override returns (string memory) {
864         return _name;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-symbol}.
869      */
870     function symbol() public view virtual override returns (string memory) {
871         return _symbol;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-tokenURI}.
876      */
877     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
878         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
879 
880         string memory baseURI = _baseURI();
881         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
882     }
883 
884     /**
885      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
886      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
887      * by default, can be overriden in child contracts.
888      */
889     function _baseURI() internal view virtual returns (string memory) {
890         return '';
891     }
892 
893     /**
894      * @dev Casts the address to uint256 without masking.
895      */
896     function _addressToUint256(address value) private pure returns (uint256 result) {
897         assembly {
898             result := value
899         }
900     }
901 
902     /**
903      * @dev Casts the boolean to uint256 without branching.
904      */
905     function _boolToUint256(bool value) private pure returns (uint256 result) {
906         assembly {
907             result := value
908         }
909     }
910 
911     /**
912      * @dev See {IERC721-approve}.
913      */
914     function approve(address to, uint256 tokenId) public override {
915         address owner = address(uint160(_packedOwnershipOf(tokenId)));
916 
917         if (_msgSenderERC721A() != owner)
918             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
919                 revert ApprovalCallerNotOwnerNorApproved();
920             }
921 
922         _tokenApprovals[tokenId] = to;
923         emit Approval(owner, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-getApproved}.
928      */
929     function getApproved(uint256 tokenId) public view override returns (address) {
930         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
931 
932         return _tokenApprovals[tokenId];
933     }
934 
935     /**
936      * @dev See {IERC721-setApprovalForAll}.
937      */
938     function setApprovalForAll(address operator, bool approved) public virtual override {
939         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
940 
941         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
942         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
943     }
944 
945     /**
946      * @dev See {IERC721-isApprovedForAll}.
947      */
948     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
949         return _operatorApprovals[owner][operator];
950     }
951 
952     /**
953      * @dev See {IERC721-transferFrom}.
954      */
955     function transferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public virtual override {
960         _transfer(from, to, tokenId);
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, '');
972     }
973 
974     /**
975      * @dev See {IERC721-safeTransferFrom}.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public virtual override {
983         _transfer(from, to, tokenId);
984         if (to.code.length != 0)
985             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             }
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted (`_mint`),
996      */
997     function _exists(uint256 tokenId) internal view returns (bool) {
998         return
999             _startTokenId() <= tokenId &&
1000             tokenId < _currentIndex && // If within bounds,
1001             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1002     }
1003 
1004     /**
1005      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1006      */
1007     function _safeMint(address to, uint256 quantity) internal {
1008         _safeMint(to, quantity, '');
1009     }
1010 
1011     /**
1012      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - If `to` refers to a smart contract, it must implement
1017      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * Emits a {Transfer} event for each mint.
1021      */
1022     function _safeMint(
1023         address to,
1024         uint256 quantity,
1025         bytes memory _data
1026     ) internal {
1027         _mint(to, quantity);
1028 
1029         unchecked {
1030             if (to.code.length != 0) {
1031                 uint256 end = _currentIndex;
1032                 uint256 index = end - quantity;
1033                 do {
1034                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1035                         revert TransferToNonERC721ReceiverImplementer();
1036                     }
1037                 } while (index < end);
1038                 // Reentrancy protection.
1039                 if (_currentIndex != end) revert();
1040             }
1041         }
1042     }
1043 
1044     /**
1045      * @dev Mints `quantity` tokens and transfers them to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `to` cannot be the zero address.
1050      * - `quantity` must be greater than 0.
1051      *
1052      * Emits a {Transfer} event for each mint.
1053      */
1054     function _mint(address to, uint256 quantity) internal {
1055         uint256 startTokenId = _currentIndex;
1056         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1057         if (quantity == 0) revert MintZeroQuantity();
1058 
1059         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1060 
1061         // Overflows are incredibly unrealistic.
1062         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1063         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1064         unchecked {
1065             // Updates:
1066             // - `balance += quantity`.
1067             // - `numberMinted += quantity`.
1068             //
1069             // We can directly add to the balance and number minted.
1070             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1071 
1072             // Updates:
1073             // - `address` to the owner.
1074             // - `startTimestamp` to the timestamp of minting.
1075             // - `burned` to `false`.
1076             // - `nextInitialized` to `quantity == 1`.
1077             _packedOwnerships[startTokenId] =
1078                 _addressToUint256(to) |
1079                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1080                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1081 
1082             uint256 offset;
1083             do {
1084                 emit Transfer(address(0), to, startTokenId + offset++);
1085             } while (offset < quantity);
1086 
1087             _currentIndex = startTokenId + quantity;
1088         }
1089         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
1102     function _transfer(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) private {
1107         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1108 
1109         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1110 
1111         address approvedAddress = _tokenApprovals[tokenId];
1112 
1113         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1114             isApprovedForAll(from, _msgSenderERC721A()) ||
1115             approvedAddress == _msgSenderERC721A());
1116 
1117         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1118         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1119 
1120         _beforeTokenTransfers(from, to, tokenId, 1);
1121 
1122         // Clear approvals from the previous owner.
1123         if (_addressToUint256(approvedAddress) != 0) {
1124             delete _tokenApprovals[tokenId];
1125         }
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1130         unchecked {
1131             // We can directly increment and decrement the balances.
1132             --_packedAddressData[from]; // Updates: `balance -= 1`.
1133             ++_packedAddressData[to]; // Updates: `balance += 1`.
1134 
1135             // Updates:
1136             // - `address` to the next owner.
1137             // - `startTimestamp` to the timestamp of transfering.
1138             // - `burned` to `false`.
1139             // - `nextInitialized` to `true`.
1140             _packedOwnerships[tokenId] =
1141                 _addressToUint256(to) |
1142                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1143                 BITMASK_NEXT_INITIALIZED;
1144 
1145             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1146             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1147                 uint256 nextTokenId = tokenId + 1;
1148                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1149                 if (_packedOwnerships[nextTokenId] == 0) {
1150                     // If the next slot is within bounds.
1151                     if (nextTokenId != _currentIndex) {
1152                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1153                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1154                     }
1155                 }
1156             }
1157         }
1158 
1159         emit Transfer(from, to, tokenId);
1160         _afterTokenTransfers(from, to, tokenId, 1);
1161     }
1162 
1163     /**
1164      * @dev Equivalent to `_burn(tokenId, false)`.
1165      */
1166     function _burn(uint256 tokenId) internal virtual {
1167         _burn(tokenId, false);
1168     }
1169 
1170     /**
1171      * @dev Destroys `tokenId`.
1172      * The approval is cleared when the token is burned.
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must exist.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1181         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1182 
1183         address from = address(uint160(prevOwnershipPacked));
1184         address approvedAddress = _tokenApprovals[tokenId];
1185 
1186         if (approvalCheck) {
1187             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1188                 isApprovedForAll(from, _msgSenderERC721A()) ||
1189                 approvedAddress == _msgSenderERC721A());
1190 
1191             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1192         }
1193 
1194         _beforeTokenTransfers(from, address(0), tokenId, 1);
1195 
1196         // Clear approvals from the previous owner.
1197         if (_addressToUint256(approvedAddress) != 0) {
1198             delete _tokenApprovals[tokenId];
1199         }
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             // Updates:
1206             // - `balance -= 1`.
1207             // - `numberBurned += 1`.
1208             //
1209             // We can directly decrement the balance, and increment the number burned.
1210             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1211             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1212 
1213             // Updates:
1214             // - `address` to the last owner.
1215             // - `startTimestamp` to the timestamp of burning.
1216             // - `burned` to `true`.
1217             // - `nextInitialized` to `true`.
1218             _packedOwnerships[tokenId] =
1219                 _addressToUint256(from) |
1220                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1221                 BITMASK_BURNED |
1222                 BITMASK_NEXT_INITIALIZED;
1223 
1224             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1225             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1226                 uint256 nextTokenId = tokenId + 1;
1227                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1228                 if (_packedOwnerships[nextTokenId] == 0) {
1229                     // If the next slot is within bounds.
1230                     if (nextTokenId != _currentIndex) {
1231                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1232                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1233                     }
1234                 }
1235             }
1236         }
1237 
1238         emit Transfer(from, address(0), tokenId);
1239         _afterTokenTransfers(from, address(0), tokenId, 1);
1240 
1241         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1242         unchecked {
1243             _burnCounter++;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1249      *
1250      * @param from address representing the previous owner of the given token ID
1251      * @param to target address that will receive the tokens
1252      * @param tokenId uint256 ID of the token to be transferred
1253      * @param _data bytes optional data to send along with the call
1254      * @return bool whether the call correctly returned the expected magic value
1255      */
1256     function _checkContractOnERC721Received(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory _data
1261     ) private returns (bool) {
1262         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1263             bytes4 retval
1264         ) {
1265             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1266         } catch (bytes memory reason) {
1267             if (reason.length == 0) {
1268                 revert TransferToNonERC721ReceiverImplementer();
1269             } else {
1270                 assembly {
1271                     revert(add(32, reason), mload(reason))
1272                 }
1273             }
1274         }
1275     }
1276 
1277     /**
1278      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1279      * And also called before burning one token.
1280      *
1281      * startTokenId - the first token id to be transferred
1282      * quantity - the amount to be transferred
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, `tokenId` will be burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _beforeTokenTransfers(
1293         address from,
1294         address to,
1295         uint256 startTokenId,
1296         uint256 quantity
1297     ) internal virtual {}
1298 
1299     /**
1300      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1301      * minting.
1302      * And also called after one token has been burned.
1303      *
1304      * startTokenId - the first token id to be transferred
1305      * quantity - the amount to be transferred
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` has been minted for `to`.
1312      * - When `to` is zero, `tokenId` has been burned by `from`.
1313      * - `from` and `to` are never both zero.
1314      */
1315     function _afterTokenTransfers(
1316         address from,
1317         address to,
1318         uint256 startTokenId,
1319         uint256 quantity
1320     ) internal virtual {}
1321 
1322     /**
1323      * @dev Returns the message sender (defaults to `msg.sender`).
1324      *
1325      * If you are writing GSN compatible contracts, you need to override this function.
1326      */
1327     function _msgSenderERC721A() internal view virtual returns (address) {
1328         return msg.sender;
1329     }
1330 
1331     /**
1332      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1333      */
1334     function _toString(uint256 value) internal pure returns (string memory ptr) {
1335         assembly {
1336             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1337             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1338             // We will need 1 32-byte word to store the length,
1339             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1340             ptr := add(mload(0x40), 128)
1341             // Update the free memory pointer to allocate.
1342             mstore(0x40, ptr)
1343 
1344             // Cache the end of the memory to calculate the length later.
1345             let end := ptr
1346 
1347             // We write the string from the rightmost digit to the leftmost digit.
1348             // The following is essentially a do-while loop that also handles the zero case.
1349             // Costs a bit more than early returning for the zero case,
1350             // but cheaper in terms of deployment and overall runtime costs.
1351             for {
1352                 // Initialize and perform the first pass without check.
1353                 let temp := value
1354                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1355                 ptr := sub(ptr, 1)
1356                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1357                 mstore8(ptr, add(48, mod(temp, 10)))
1358                 temp := div(temp, 10)
1359             } temp {
1360                 // Keep dividing `temp` until zero.
1361                 temp := div(temp, 10)
1362             } {
1363                 // Body of the for loop.
1364                 ptr := sub(ptr, 1)
1365                 mstore8(ptr, add(48, mod(temp, 10)))
1366             }
1367 
1368             let length := sub(end, ptr)
1369             // Move the pointer 32 bytes leftwards to make room for the length.
1370             ptr := sub(ptr, 32)
1371             // Store the length.
1372             mstore(ptr, length)
1373         }
1374     }
1375 }
1376 
1377 // File: contracts/WRLDPrison.sol
1378 
1379 
1380 pragma solidity >= 0.7.0;
1381 
1382 
1383 
1384 
1385 
1386 
1387 /* @dev Matt was here 
1388     Welcome to prison! Enjoy your stay.
1389 */
1390 
1391 contract WRLDPrison is ERC721A, Ownable, ReentrancyGuard {
1392     using Strings for uint256;
1393     IERC20 public WRLDTokenContract;
1394 
1395     uint256 MINT_LIMIT_PER_WALLET = 5; //counts for both whitelist & public mint
1396     uint256 MINT_PRICE;
1397     uint256 MINT_LIMIT;
1398 
1399     string public baseURI;
1400     uint256 whitelistedCount = 0;
1401     mapping(address => uint256) whitelistMintCount;
1402     mapping(address => uint256) publicMintCount;
1403     mapping(address => bool) whitelistedAddresses;
1404     bool mintActive = false;
1405     bool publicMintActive = false;
1406 
1407     constructor(uint256 _mintPrice, uint256 _mintLimit, address _wrldTokenAddress) ERC721A("WRLD Prison", "PRSN") {
1408         MINT_PRICE = _mintPrice;
1409         MINT_LIMIT = _mintLimit;
1410         WRLDTokenContract = IERC20(_wrldTokenAddress);
1411     }
1412 
1413     /* Whitelist and public minting */
1414     function whitelistMint(uint256 _mintAmount) external nonReentrant {
1415         require(mintActive, "whitelist minting is not available yet.");
1416         require(whitelistedAddresses[msg.sender], "user is not whitelisted.");
1417         require(whitelistMintCount[msg.sender] + _mintAmount <= MINT_LIMIT_PER_WALLET, "max whitelist mints per wallet reached");
1418 
1419         uint256 cost = MINT_PRICE * _mintAmount;
1420         guardMint(_mintAmount);
1421         guardWRLD(cost);
1422 
1423         whitelistMintCount[msg.sender] += _mintAmount;
1424         WRLDTokenContract.transferFrom(msg.sender, address(this), cost);
1425         _safeMint(msg.sender, _mintAmount);
1426     }
1427 
1428     function publicMint(uint256 _mintAmount) external nonReentrant {
1429         require(publicMintActive, "public minting is not available yet.");
1430         require(publicMintCount[msg.sender] + _mintAmount <= MINT_LIMIT_PER_WALLET, "max public mints per wallet reached");
1431 
1432         uint256 cost = MINT_PRICE * _mintAmount;
1433         guardMint(_mintAmount);
1434         guardWRLD(cost);
1435 
1436         publicMintCount[msg.sender] += _mintAmount;
1437         WRLDTokenContract.transferFrom(msg.sender, address(this), cost);
1438         _safeMint(msg.sender, _mintAmount);
1439     }
1440 
1441     /* NFT reveal */
1442     function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1443         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1444         return string(abi.encodePacked(baseURI, _tokenId.toString()));
1445     }
1446 
1447     /* Internal functions */
1448     function guardMint(uint256 _mintAmount) internal view {
1449         require(_mintAmount > 0, "at least 1 NFT has to be minted per transaction.");
1450         require(_mintAmount <= 5, "a maximum of 5 NFTs can be minted per transaction.");
1451         require(totalSupply() + _mintAmount <= MINT_LIMIT, "minting would exceed cap.");
1452     }
1453 
1454     function guardWRLD(uint256 cost) internal view {
1455         uint256 allowance = WRLDTokenContract.allowance(msg.sender, address(this));
1456         require(allowance >= cost, "contract has to receive approval for fund spending.");
1457 
1458         uint256 wrldBalance = WRLDTokenContract.balanceOf(msg.sender);
1459         require(wrldBalance >= cost, "not enough wrld balance for the mint.");
1460     }
1461 
1462     /* Owner only functions */
1463     function setBaseURI(string calldata _baseURI) external onlyOwner {
1464         baseURI = _baseURI;
1465     }
1466 
1467     function whitelistAddresses(address[] calldata addresses) external onlyOwner {
1468         require(whitelistedCount + addresses.length <= MINT_LIMIT, "whitelisted spots count would be higher than mint limit");
1469 
1470         for (uint i = 0; i < addresses.length; i++) {
1471             whitelistedAddresses[addresses[i]] = true;
1472         }
1473         whitelistedCount += addresses.length;
1474     }
1475 
1476     function setMintStatus(bool whitelistState, bool publicState) external onlyOwner {
1477         mintActive = whitelistState;
1478         publicMintActive = publicState;
1479     }
1480     
1481     function withdrawWRLD(uint256 amount) external onlyOwner {
1482         require(WRLDTokenContract.balanceOf(address(this)) >= amount, "insufficient funds in contract");
1483         WRLDTokenContract.transfer(msg.sender, amount);
1484     }
1485 }