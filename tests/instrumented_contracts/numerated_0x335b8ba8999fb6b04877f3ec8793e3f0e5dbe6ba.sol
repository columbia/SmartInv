1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
109 
110 
111 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Emitted when `value` tokens are moved from one account (`from`) to
121      * another (`to`).
122      *
123      * Note that `value` may be zero.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     /**
128      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
129      * a call to {approve}. `value` is the new allowance.
130      */
131     event Approval(address indexed owner, address indexed spender, uint256 value);
132 
133     /**
134      * @dev Returns the amount of tokens in existence.
135      */
136     function totalSupply() external view returns (uint256);
137 
138     /**
139      * @dev Returns the amount of tokens owned by `account`.
140      */
141     function balanceOf(address account) external view returns (uint256);
142 
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `to`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address to, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     /**
162      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * IMPORTANT: Beware that changing an allowance with this method brings the risk
167      * that someone may use both the old and the new allowance by unfortunate
168      * transaction ordering. One possible solution to mitigate this race
169      * condition is to first reduce the spender's allowance to 0 and set the
170      * desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      *
173      * Emits an {Approval} event.
174      */
175     function approve(address spender, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Moves `amount` tokens from `from` to `to` using the
179      * allowance mechanism. `amount` is then deducted from the caller's
180      * allowance.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 amount
190     ) external returns (bool);
191 }
192 
193 
194 // File @openzeppelin/contracts/interfaces/IERC20.sol@v4.6.0
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Interface of the ERC165 standard, as defined in the
211  * https://eips.ethereum.org/EIPS/eip-165[EIP].
212  *
213  * Implementers can declare support of contract interfaces, which can then be
214  * queried by others ({ERC165Checker}).
215  *
216  * For an implementation, see {ERC165}.
217  */
218 interface IERC165 {
219     /**
220      * @dev Returns true if this contract implements the interface defined by
221      * `interfaceId`. See the corresponding
222      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
223      * to learn more about how these ids are created.
224      *
225      * This function call must use less than 30 000 gas.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 }
229 
230 
231 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
232 
233 
234 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Interface for the NFT Royalty Standard.
240  *
241  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
242  * support for royalty payments across all NFT marketplaces and ecosystem participants.
243  *
244  * _Available since v4.5._
245  */
246 interface IERC2981 is IERC165 {
247     /**
248      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
249      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
250      */
251     function royaltyInfo(uint256 tokenId, uint256 salePrice)
252         external
253         view
254         returns (address receiver, uint256 royaltyAmount);
255 }
256 
257 
258 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
259 
260 
261 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Required interface of an ERC721 compliant contract.
267  */
268 interface IERC721 is IERC165 {
269     /**
270      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
273 
274     /**
275      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
276      */
277     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
278 
279     /**
280      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
281      */
282     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
283 
284     /**
285      * @dev Returns the number of tokens in ``owner``'s account.
286      */
287     function balanceOf(address owner) external view returns (uint256 balance);
288 
289     /**
290      * @dev Returns the owner of the `tokenId` token.
291      *
292      * Requirements:
293      *
294      * - `tokenId` must exist.
295      */
296     function ownerOf(uint256 tokenId) external view returns (address owner);
297 
298     /**
299      * @dev Safely transfers `tokenId` token from `from` to `to`.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId,
315         bytes calldata data
316     ) external;
317 
318     /**
319      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
320      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId
336     ) external;
337 
338     /**
339      * @dev Transfers `tokenId` token from `from` to `to`.
340      *
341      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must be owned by `from`.
348      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transferFrom(
353         address from,
354         address to,
355         uint256 tokenId
356     ) external;
357 
358     /**
359      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
360      * The approval is cleared when the token is transferred.
361      *
362      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
363      *
364      * Requirements:
365      *
366      * - The caller must own the token or be an approved operator.
367      * - `tokenId` must exist.
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address to, uint256 tokenId) external;
372 
373     /**
374      * @dev Approve or remove `operator` as an operator for the caller.
375      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
376      *
377      * Requirements:
378      *
379      * - The `operator` cannot be the caller.
380      *
381      * Emits an {ApprovalForAll} event.
382      */
383     function setApprovalForAll(address operator, bool _approved) external;
384 
385     /**
386      * @dev Returns the account approved for `tokenId` token.
387      *
388      * Requirements:
389      *
390      * - `tokenId` must exist.
391      */
392     function getApproved(uint256 tokenId) external view returns (address operator);
393 
394     /**
395      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
396      *
397      * See {setApprovalForAll}
398      */
399     function isApprovedForAll(address owner, address operator) external view returns (bool);
400 }
401 
402 
403 // File @openzeppelin/contracts/interfaces/IERC721.sol@v4.6.0
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 // File erc721a/contracts/IERC721A.sol@v4.0.0
412 
413 
414 // ERC721A Contracts v4.0.0
415 // Creator: Chiru Labs
416 
417 pragma solidity ^0.8.4;
418 
419 /**
420  * @dev Interface of an ERC721A compliant contract.
421  */
422 interface IERC721A {
423     /**
424      * The caller must own the token or be an approved operator.
425      */
426     error ApprovalCallerNotOwnerNorApproved();
427 
428     /**
429      * The token does not exist.
430      */
431     error ApprovalQueryForNonexistentToken();
432 
433     /**
434      * The caller cannot approve to their own address.
435      */
436     error ApproveToCaller();
437 
438     /**
439      * The caller cannot approve to the current owner.
440      */
441     error ApprovalToCurrentOwner();
442 
443     /**
444      * Cannot query the balance for the zero address.
445      */
446     error BalanceQueryForZeroAddress();
447 
448     /**
449      * Cannot mint to the zero address.
450      */
451     error MintToZeroAddress();
452 
453     /**
454      * The quantity of tokens minted must be more than zero.
455      */
456     error MintZeroQuantity();
457 
458     /**
459      * The token does not exist.
460      */
461     error OwnerQueryForNonexistentToken();
462 
463     /**
464      * The caller must own the token or be an approved operator.
465      */
466     error TransferCallerNotOwnerNorApproved();
467 
468     /**
469      * The token must be owned by `from`.
470      */
471     error TransferFromIncorrectOwner();
472 
473     /**
474      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
475      */
476     error TransferToNonERC721ReceiverImplementer();
477 
478     /**
479      * Cannot transfer to the zero address.
480      */
481     error TransferToZeroAddress();
482 
483     /**
484      * The token does not exist.
485      */
486     error URIQueryForNonexistentToken();
487 
488     struct TokenOwnership {
489         // The address of the owner.
490         address addr;
491         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
492         uint64 startTimestamp;
493         // Whether the token has been burned.
494         bool burned;
495     }
496 
497     /**
498      * @dev Returns the total amount of tokens stored by the contract.
499      *
500      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
501      */
502     function totalSupply() external view returns (uint256);
503 
504     // ==============================
505     //            IERC165
506     // ==============================
507 
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30 000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 
518     // ==============================
519     //            IERC721
520     // ==============================
521 
522     /**
523      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
524      */
525     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
526 
527     /**
528      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
529      */
530     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
531 
532     /**
533      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in ``owner``'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes calldata data
569     ) external;
570 
571     /**
572      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
573      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     /**
592      * @dev Transfers `tokenId` token from `from` to `to`.
593      *
594      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must be owned by `from`.
601      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
602      *
603      * Emits a {Transfer} event.
604      */
605     function transferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) external;
610 
611     /**
612      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
613      * The approval is cleared when the token is transferred.
614      *
615      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
616      *
617      * Requirements:
618      *
619      * - The caller must own the token or be an approved operator.
620      * - `tokenId` must exist.
621      *
622      * Emits an {Approval} event.
623      */
624     function approve(address to, uint256 tokenId) external;
625 
626     /**
627      * @dev Approve or remove `operator` as an operator for the caller.
628      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
629      *
630      * Requirements:
631      *
632      * - The `operator` cannot be the caller.
633      *
634      * Emits an {ApprovalForAll} event.
635      */
636     function setApprovalForAll(address operator, bool _approved) external;
637 
638     /**
639      * @dev Returns the account approved for `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function getApproved(uint256 tokenId) external view returns (address operator);
646 
647     /**
648      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
649      *
650      * See {setApprovalForAll}
651      */
652     function isApprovedForAll(address owner, address operator) external view returns (bool);
653 
654     // ==============================
655     //        IERC721Metadata
656     // ==============================
657 
658     /**
659      * @dev Returns the token collection name.
660      */
661     function name() external view returns (string memory);
662 
663     /**
664      * @dev Returns the token collection symbol.
665      */
666     function symbol() external view returns (string memory);
667 
668     /**
669      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
670      */
671     function tokenURI(uint256 tokenId) external view returns (string memory);
672 }
673 
674 
675 // File erc721a/contracts/ERC721A.sol@v4.0.0
676 
677 
678 // ERC721A Contracts v4.0.0
679 // Creator: Chiru Labs
680 
681 pragma solidity ^0.8.4;
682 
683 /**
684  * @dev ERC721 token receiver interface.
685  */
686 interface ERC721A__IERC721Receiver {
687     function onERC721Received(
688         address operator,
689         address from,
690         uint256 tokenId,
691         bytes calldata data
692     ) external returns (bytes4);
693 }
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
697  * the Metadata extension. Built to optimize for lower gas during batch mints.
698  *
699  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
700  *
701  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
702  *
703  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
704  */
705 contract ERC721A is IERC721A {
706     // Mask of an entry in packed address data.
707     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
708 
709     // The bit position of `numberMinted` in packed address data.
710     uint256 private constant BITPOS_NUMBER_MINTED = 64;
711 
712     // The bit position of `numberBurned` in packed address data.
713     uint256 private constant BITPOS_NUMBER_BURNED = 128;
714 
715     // The bit position of `aux` in packed address data.
716     uint256 private constant BITPOS_AUX = 192;
717 
718     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
719     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
720 
721     // The bit position of `startTimestamp` in packed ownership.
722     uint256 private constant BITPOS_START_TIMESTAMP = 160;
723 
724     // The bit mask of the `burned` bit in packed ownership.
725     uint256 private constant BITMASK_BURNED = 1 << 224;
726     
727     // The bit position of the `nextInitialized` bit in packed ownership.
728     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
729 
730     // The bit mask of the `nextInitialized` bit in packed ownership.
731     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
732 
733     // The tokenId of the next token to be minted.
734     uint256 private _currentIndex;
735 
736     // The number of tokens burned.
737     uint256 private _burnCounter;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to ownership details
746     // An empty struct value does not necessarily mean the token is unowned.
747     // See `_packedOwnershipOf` implementation for details.
748     //
749     // Bits Layout:
750     // - [0..159]   `addr`
751     // - [160..223] `startTimestamp`
752     // - [224]      `burned`
753     // - [225]      `nextInitialized`
754     mapping(uint256 => uint256) private _packedOwnerships;
755 
756     // Mapping owner address to address data.
757     //
758     // Bits Layout:
759     // - [0..63]    `balance`
760     // - [64..127]  `numberMinted`
761     // - [128..191] `numberBurned`
762     // - [192..255] `aux`
763     mapping(address => uint256) private _packedAddressData;
764 
765     // Mapping from token ID to approved address.
766     mapping(uint256 => address) private _tokenApprovals;
767 
768     // Mapping from owner to operator approvals
769     mapping(address => mapping(address => bool)) private _operatorApprovals;
770 
771     constructor(string memory name_, string memory symbol_) {
772         _name = name_;
773         _symbol = symbol_;
774         _currentIndex = _startTokenId();
775     }
776 
777     /**
778      * @dev Returns the starting token ID. 
779      * To change the starting token ID, please override this function.
780      */
781     function _startTokenId() internal view virtual returns (uint256) {
782         return 0;
783     }
784 
785     /**
786      * @dev Returns the next token ID to be minted.
787      */
788     function _nextTokenId() internal view returns (uint256) {
789         return _currentIndex;
790     }
791 
792     /**
793      * @dev Returns the total number of tokens in existence.
794      * Burned tokens will reduce the count. 
795      * To get the total number of tokens minted, please see `_totalMinted`.
796      */
797     function totalSupply() public view override returns (uint256) {
798         // Counter underflow is impossible as _burnCounter cannot be incremented
799         // more than `_currentIndex - _startTokenId()` times.
800         unchecked {
801             return _currentIndex - _burnCounter - _startTokenId();
802         }
803     }
804 
805     /**
806      * @dev Returns the total amount of tokens minted in the contract.
807      */
808     function _totalMinted() internal view returns (uint256) {
809         // Counter underflow is impossible as _currentIndex does not decrement,
810         // and it is initialized to `_startTokenId()`
811         unchecked {
812             return _currentIndex - _startTokenId();
813         }
814     }
815 
816     /**
817      * @dev Returns the total number of tokens burned.
818      */
819     function _totalBurned() internal view returns (uint256) {
820         return _burnCounter;
821     }
822 
823     /**
824      * @dev See {IERC165-supportsInterface}.
825      */
826     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
827         // The interface IDs are constants representing the first 4 bytes of the XOR of
828         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
829         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
830         return
831             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
832             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
833             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
834     }
835 
836     /**
837      * @dev See {IERC721-balanceOf}.
838      */
839     function balanceOf(address owner) public view override returns (uint256) {
840         if (owner == address(0)) revert BalanceQueryForZeroAddress();
841         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
842     }
843 
844     /**
845      * Returns the number of tokens minted by `owner`.
846      */
847     function _numberMinted(address owner) internal view returns (uint256) {
848         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
849     }
850 
851     /**
852      * Returns the number of tokens burned by or on behalf of `owner`.
853      */
854     function _numberBurned(address owner) internal view returns (uint256) {
855         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
856     }
857 
858     /**
859      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
860      */
861     function _getAux(address owner) internal view returns (uint64) {
862         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
863     }
864 
865     /**
866      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      * If there are multiple variables, please pack them into a uint64.
868      */
869     function _setAux(address owner, uint64 aux) internal {
870         uint256 packed = _packedAddressData[owner];
871         uint256 auxCasted;
872         assembly { // Cast aux without masking.
873             auxCasted := aux
874         }
875         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
876         _packedAddressData[owner] = packed;
877     }
878 
879     /**
880      * Returns the packed ownership data of `tokenId`.
881      */
882     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
883         uint256 curr = tokenId;
884 
885         unchecked {
886             if (_startTokenId() <= curr)
887                 if (curr < _currentIndex) {
888                     uint256 packed = _packedOwnerships[curr];
889                     // If not burned.
890                     if (packed & BITMASK_BURNED == 0) {
891                         // Invariant:
892                         // There will always be an ownership that has an address and is not burned
893                         // before an ownership that does not have an address and is not burned.
894                         // Hence, curr will not underflow.
895                         //
896                         // We can directly compare the packed value.
897                         // If the address is zero, packed is zero.
898                         while (packed == 0) {
899                             packed = _packedOwnerships[--curr];
900                         }
901                         return packed;
902                     }
903                 }
904         }
905         revert OwnerQueryForNonexistentToken();
906     }
907 
908     /**
909      * Returns the unpacked `TokenOwnership` struct from `packed`.
910      */
911     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
912         ownership.addr = address(uint160(packed));
913         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
914         ownership.burned = packed & BITMASK_BURNED != 0;
915     }
916 
917     /**
918      * Returns the unpacked `TokenOwnership` struct at `index`.
919      */
920     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
921         return _unpackedOwnership(_packedOwnerships[index]);
922     }
923 
924     /**
925      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
926      */
927     function _initializeOwnershipAt(uint256 index) internal {
928         if (_packedOwnerships[index] == 0) {
929             _packedOwnerships[index] = _packedOwnershipOf(index);
930         }
931     }
932 
933     /**
934      * Gas spent here starts off proportional to the maximum mint batch size.
935      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
936      */
937     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
938         return _unpackedOwnership(_packedOwnershipOf(tokenId));
939     }
940 
941     /**
942      * @dev See {IERC721-ownerOf}.
943      */
944     function ownerOf(uint256 tokenId) public view override returns (address) {
945         return address(uint160(_packedOwnershipOf(tokenId)));
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-name}.
950      */
951     function name() public view virtual override returns (string memory) {
952         return _name;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-symbol}.
957      */
958     function symbol() public view virtual override returns (string memory) {
959         return _symbol;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-tokenURI}.
964      */
965     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
966         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
967 
968         string memory baseURI = _baseURI();
969         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
970     }
971 
972     /**
973      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
974      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
975      * by default, can be overriden in child contracts.
976      */
977     function _baseURI() internal view virtual returns (string memory) {
978         return '';
979     }
980 
981     /**
982      * @dev Casts the address to uint256 without masking.
983      */
984     function _addressToUint256(address value) private pure returns (uint256 result) {
985         assembly {
986             result := value
987         }
988     }
989 
990     /**
991      * @dev Casts the boolean to uint256 without branching.
992      */
993     function _boolToUint256(bool value) private pure returns (uint256 result) {
994         assembly {
995             result := value
996         }
997     }
998 
999     /**
1000      * @dev See {IERC721-approve}.
1001      */
1002     function approve(address to, uint256 tokenId) public override {
1003         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1004         if (to == owner) revert ApprovalToCurrentOwner();
1005 
1006         if (_msgSenderERC721A() != owner)
1007             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1008                 revert ApprovalCallerNotOwnerNorApproved();
1009             }
1010 
1011         _tokenApprovals[tokenId] = to;
1012         emit Approval(owner, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-getApproved}.
1017      */
1018     function getApproved(uint256 tokenId) public view override returns (address) {
1019         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1020 
1021         return _tokenApprovals[tokenId];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-setApprovalForAll}.
1026      */
1027     function setApprovalForAll(address operator, bool approved) public virtual override {
1028         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1029 
1030         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1031         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-isApprovedForAll}.
1036      */
1037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1038         return _operatorApprovals[owner][operator];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-transferFrom}.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public virtual override {
1060         safeTransferFrom(from, to, tokenId, '');
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073         if (to.code.length != 0)
1074             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             }
1077     }
1078 
1079     /**
1080      * @dev Returns whether `tokenId` exists.
1081      *
1082      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1083      *
1084      * Tokens start existing when they are minted (`_mint`),
1085      */
1086     function _exists(uint256 tokenId) internal view returns (bool) {
1087         return
1088             _startTokenId() <= tokenId &&
1089             tokenId < _currentIndex && // If within bounds,
1090             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1091     }
1092 
1093     /**
1094      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1095      */
1096     function _safeMint(address to, uint256 quantity) internal {
1097         _safeMint(to, quantity, '');
1098     }
1099 
1100     /**
1101      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - If `to` refers to a smart contract, it must implement
1106      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data
1115     ) internal {
1116         uint256 startTokenId = _currentIndex;
1117         if (to == address(0)) revert MintToZeroAddress();
1118         if (quantity == 0) revert MintZeroQuantity();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are incredibly unrealistic.
1123         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1124         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1125         unchecked {
1126             // Updates:
1127             // - `balance += quantity`.
1128             // - `numberMinted += quantity`.
1129             //
1130             // We can directly add to the balance and number minted.
1131             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1132 
1133             // Updates:
1134             // - `address` to the owner.
1135             // - `startTimestamp` to the timestamp of minting.
1136             // - `burned` to `false`.
1137             // - `nextInitialized` to `quantity == 1`.
1138             _packedOwnerships[startTokenId] =
1139                 _addressToUint256(to) |
1140                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1141                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1142 
1143             uint256 updatedIndex = startTokenId;
1144             uint256 end = updatedIndex + quantity;
1145 
1146             if (to.code.length != 0) {
1147                 do {
1148                     emit Transfer(address(0), to, updatedIndex);
1149                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1150                         revert TransferToNonERC721ReceiverImplementer();
1151                     }
1152                 } while (updatedIndex < end);
1153                 // Reentrancy protection
1154                 if (_currentIndex != startTokenId) revert();
1155             } else {
1156                 do {
1157                     emit Transfer(address(0), to, updatedIndex++);
1158                 } while (updatedIndex < end);
1159             }
1160             _currentIndex = updatedIndex;
1161         }
1162         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1163     }
1164 
1165     /**
1166      * @dev Mints `quantity` tokens and transfers them to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `to` cannot be the zero address.
1171      * - `quantity` must be greater than 0.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _mint(address to, uint256 quantity) internal {
1176         uint256 startTokenId = _currentIndex;
1177         if (to == address(0)) revert MintToZeroAddress();
1178         if (quantity == 0) revert MintZeroQuantity();
1179 
1180         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1181 
1182         // Overflows are incredibly unrealistic.
1183         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1184         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1185         unchecked {
1186             // Updates:
1187             // - `balance += quantity`.
1188             // - `numberMinted += quantity`.
1189             //
1190             // We can directly add to the balance and number minted.
1191             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1192 
1193             // Updates:
1194             // - `address` to the owner.
1195             // - `startTimestamp` to the timestamp of minting.
1196             // - `burned` to `false`.
1197             // - `nextInitialized` to `quantity == 1`.
1198             _packedOwnerships[startTokenId] =
1199                 _addressToUint256(to) |
1200                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1201                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1202 
1203             uint256 updatedIndex = startTokenId;
1204             uint256 end = updatedIndex + quantity;
1205 
1206             do {
1207                 emit Transfer(address(0), to, updatedIndex++);
1208             } while (updatedIndex < end);
1209 
1210             _currentIndex = updatedIndex;
1211         }
1212         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213     }
1214 
1215     /**
1216      * @dev Transfers `tokenId` from `from` to `to`.
1217      *
1218      * Requirements:
1219      *
1220      * - `to` cannot be the zero address.
1221      * - `tokenId` token must be owned by `from`.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _transfer(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) private {
1230         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1231 
1232         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1233 
1234         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1235             isApprovedForAll(from, _msgSenderERC721A()) ||
1236             getApproved(tokenId) == _msgSenderERC721A());
1237 
1238         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1239         if (to == address(0)) revert TransferToZeroAddress();
1240 
1241         _beforeTokenTransfers(from, to, tokenId, 1);
1242 
1243         // Clear approvals from the previous owner.
1244         delete _tokenApprovals[tokenId];
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1249         unchecked {
1250             // We can directly increment and decrement the balances.
1251             --_packedAddressData[from]; // Updates: `balance -= 1`.
1252             ++_packedAddressData[to]; // Updates: `balance += 1`.
1253 
1254             // Updates:
1255             // - `address` to the next owner.
1256             // - `startTimestamp` to the timestamp of transfering.
1257             // - `burned` to `false`.
1258             // - `nextInitialized` to `true`.
1259             _packedOwnerships[tokenId] =
1260                 _addressToUint256(to) |
1261                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1262                 BITMASK_NEXT_INITIALIZED;
1263 
1264             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1265             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1266                 uint256 nextTokenId = tokenId + 1;
1267                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1268                 if (_packedOwnerships[nextTokenId] == 0) {
1269                     // If the next slot is within bounds.
1270                     if (nextTokenId != _currentIndex) {
1271                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1272                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1273                     }
1274                 }
1275             }
1276         }
1277 
1278         emit Transfer(from, to, tokenId);
1279         _afterTokenTransfers(from, to, tokenId, 1);
1280     }
1281 
1282     /**
1283      * @dev Equivalent to `_burn(tokenId, false)`.
1284      */
1285     function _burn(uint256 tokenId) internal virtual {
1286         _burn(tokenId, false);
1287     }
1288 
1289     /**
1290      * @dev Destroys `tokenId`.
1291      * The approval is cleared when the token is burned.
1292      *
1293      * Requirements:
1294      *
1295      * - `tokenId` must exist.
1296      *
1297      * Emits a {Transfer} event.
1298      */
1299     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1300         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1301 
1302         address from = address(uint160(prevOwnershipPacked));
1303 
1304         if (approvalCheck) {
1305             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1306                 isApprovedForAll(from, _msgSenderERC721A()) ||
1307                 getApproved(tokenId) == _msgSenderERC721A());
1308 
1309             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1310         }
1311 
1312         _beforeTokenTransfers(from, address(0), tokenId, 1);
1313 
1314         // Clear approvals from the previous owner.
1315         delete _tokenApprovals[tokenId];
1316 
1317         // Underflow of the sender's balance is impossible because we check for
1318         // ownership above and the recipient's balance can't realistically overflow.
1319         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1320         unchecked {
1321             // Updates:
1322             // - `balance -= 1`.
1323             // - `numberBurned += 1`.
1324             //
1325             // We can directly decrement the balance, and increment the number burned.
1326             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1327             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1328 
1329             // Updates:
1330             // - `address` to the last owner.
1331             // - `startTimestamp` to the timestamp of burning.
1332             // - `burned` to `true`.
1333             // - `nextInitialized` to `true`.
1334             _packedOwnerships[tokenId] =
1335                 _addressToUint256(from) |
1336                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1337                 BITMASK_BURNED | 
1338                 BITMASK_NEXT_INITIALIZED;
1339 
1340             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1341             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1342                 uint256 nextTokenId = tokenId + 1;
1343                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1344                 if (_packedOwnerships[nextTokenId] == 0) {
1345                     // If the next slot is within bounds.
1346                     if (nextTokenId != _currentIndex) {
1347                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1348                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1349                     }
1350                 }
1351             }
1352         }
1353 
1354         emit Transfer(from, address(0), tokenId);
1355         _afterTokenTransfers(from, address(0), tokenId, 1);
1356 
1357         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1358         unchecked {
1359             _burnCounter++;
1360         }
1361     }
1362 
1363     /**
1364      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1365      *
1366      * @param from address representing the previous owner of the given token ID
1367      * @param to target address that will receive the tokens
1368      * @param tokenId uint256 ID of the token to be transferred
1369      * @param _data bytes optional data to send along with the call
1370      * @return bool whether the call correctly returned the expected magic value
1371      */
1372     function _checkContractOnERC721Received(
1373         address from,
1374         address to,
1375         uint256 tokenId,
1376         bytes memory _data
1377     ) private returns (bool) {
1378         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1379             bytes4 retval
1380         ) {
1381             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1382         } catch (bytes memory reason) {
1383             if (reason.length == 0) {
1384                 revert TransferToNonERC721ReceiverImplementer();
1385             } else {
1386                 assembly {
1387                     revert(add(32, reason), mload(reason))
1388                 }
1389             }
1390         }
1391     }
1392 
1393     /**
1394      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1395      * And also called before burning one token.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` will be minted for `to`.
1405      * - When `to` is zero, `tokenId` will be burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _beforeTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1417      * minting.
1418      * And also called after one token has been burned.
1419      *
1420      * startTokenId - the first token id to be transferred
1421      * quantity - the amount to be transferred
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` has been minted for `to`.
1428      * - When `to` is zero, `tokenId` has been burned by `from`.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _afterTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 
1438     /**
1439      * @dev Returns the message sender (defaults to `msg.sender`).
1440      *
1441      * If you are writing GSN compatible contracts, you need to override this function.
1442      */
1443     function _msgSenderERC721A() internal view virtual returns (address) {
1444         return msg.sender;
1445     }
1446 
1447     /**
1448      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1449      */
1450     function _toString(uint256 value) internal pure returns (string memory ptr) {
1451         assembly {
1452             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1453             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1454             // We will need 1 32-byte word to store the length, 
1455             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1456             ptr := add(mload(0x40), 128)
1457             // Update the free memory pointer to allocate.
1458             mstore(0x40, ptr)
1459 
1460             // Cache the end of the memory to calculate the length later.
1461             let end := ptr
1462 
1463             // We write the string from the rightmost digit to the leftmost digit.
1464             // The following is essentially a do-while loop that also handles the zero case.
1465             // Costs a bit more than early returning for the zero case,
1466             // but cheaper in terms of deployment and overall runtime costs.
1467             for { 
1468                 // Initialize and perform the first pass without check.
1469                 let temp := value
1470                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1471                 ptr := sub(ptr, 1)
1472                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1473                 mstore8(ptr, add(48, mod(temp, 10)))
1474                 temp := div(temp, 10)
1475             } temp { 
1476                 // Keep dividing `temp` until zero.
1477                 temp := div(temp, 10)
1478             } { // Body of the for loop.
1479                 ptr := sub(ptr, 1)
1480                 mstore8(ptr, add(48, mod(temp, 10)))
1481             }
1482             
1483             let length := sub(end, ptr)
1484             // Move the pointer 32 bytes leftwards to make room for the length.
1485             ptr := sub(ptr, 32)
1486             // Store the length.
1487             mstore(ptr, length)
1488         }
1489     }
1490 }
1491 
1492 
1493 // File erc721a/contracts/extensions/IERC721ABurnable.sol@v4.0.0
1494 
1495 
1496 // ERC721A Contracts v4.0.0
1497 // Creator: Chiru Labs
1498 
1499 pragma solidity ^0.8.4;
1500 
1501 /**
1502  * @dev Interface of an ERC721ABurnable compliant contract.
1503  */
1504 interface IERC721ABurnable is IERC721A {
1505     /**
1506      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1507      *
1508      * Requirements:
1509      *
1510      * - The caller must own `tokenId` or be an approved operator.
1511      */
1512     function burn(uint256 tokenId) external;
1513 }
1514 
1515 
1516 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v4.0.0
1517 
1518 
1519 // ERC721A Contracts v4.0.0
1520 // Creator: Chiru Labs
1521 
1522 pragma solidity ^0.8.4;
1523 
1524 
1525 /**
1526  * @title ERC721A Burnable Token
1527  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1528  */
1529 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1530     /**
1531      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1532      *
1533      * Requirements:
1534      *
1535      * - The caller must own `tokenId` or be an approved operator.
1536      */
1537     function burn(uint256 tokenId) public virtual override {
1538         _burn(tokenId, true);
1539     }
1540 }
1541 
1542 
1543 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.0.0
1544 
1545 
1546 // ERC721A Contracts v4.0.0
1547 // Creator: Chiru Labs
1548 
1549 pragma solidity ^0.8.4;
1550 
1551 /**
1552  * @dev Interface of an ERC721AQueryable compliant contract.
1553  */
1554 interface IERC721AQueryable is IERC721A {
1555     /**
1556      * Invalid query range (`start` >= `stop`).
1557      */
1558     error InvalidQueryRange();
1559 
1560     /**
1561      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1562      *
1563      * If the `tokenId` is out of bounds:
1564      *   - `addr` = `address(0)`
1565      *   - `startTimestamp` = `0`
1566      *   - `burned` = `false`
1567      *
1568      * If the `tokenId` is burned:
1569      *   - `addr` = `<Address of owner before token was burned>`
1570      *   - `startTimestamp` = `<Timestamp when token was burned>`
1571      *   - `burned = `true`
1572      *
1573      * Otherwise:
1574      *   - `addr` = `<Address of owner>`
1575      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1576      *   - `burned = `false`
1577      */
1578     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1579 
1580     /**
1581      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1582      * See {ERC721AQueryable-explicitOwnershipOf}
1583      */
1584     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1585 
1586     /**
1587      * @dev Returns an array of token IDs owned by `owner`,
1588      * in the range [`start`, `stop`)
1589      * (i.e. `start <= tokenId < stop`).
1590      *
1591      * This function allows for tokens to be queried if the collection
1592      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1593      *
1594      * Requirements:
1595      *
1596      * - `start` < `stop`
1597      */
1598     function tokensOfOwnerIn(
1599         address owner,
1600         uint256 start,
1601         uint256 stop
1602     ) external view returns (uint256[] memory);
1603 
1604     /**
1605      * @dev Returns an array of token IDs owned by `owner`.
1606      *
1607      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1608      * It is meant to be called off-chain.
1609      *
1610      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1611      * multiple smaller scans if the collection is large enough to cause
1612      * an out-of-gas error (10K pfp collections should be fine).
1613      */
1614     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1615 }
1616 
1617 
1618 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.0.0
1619 
1620 
1621 // ERC721A Contracts v4.0.0
1622 // Creator: Chiru Labs
1623 
1624 pragma solidity ^0.8.4;
1625 
1626 
1627 /**
1628  * @title ERC721A Queryable
1629  * @dev ERC721A subclass with convenience query functions.
1630  */
1631 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1632     /**
1633      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1634      *
1635      * If the `tokenId` is out of bounds:
1636      *   - `addr` = `address(0)`
1637      *   - `startTimestamp` = `0`
1638      *   - `burned` = `false`
1639      *
1640      * If the `tokenId` is burned:
1641      *   - `addr` = `<Address of owner before token was burned>`
1642      *   - `startTimestamp` = `<Timestamp when token was burned>`
1643      *   - `burned = `true`
1644      *
1645      * Otherwise:
1646      *   - `addr` = `<Address of owner>`
1647      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1648      *   - `burned = `false`
1649      */
1650     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1651         TokenOwnership memory ownership;
1652         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1653             return ownership;
1654         }
1655         ownership = _ownershipAt(tokenId);
1656         if (ownership.burned) {
1657             return ownership;
1658         }
1659         return _ownershipOf(tokenId);
1660     }
1661 
1662     /**
1663      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1664      * See {ERC721AQueryable-explicitOwnershipOf}
1665      */
1666     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1667         unchecked {
1668             uint256 tokenIdsLength = tokenIds.length;
1669             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1670             for (uint256 i; i != tokenIdsLength; ++i) {
1671                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1672             }
1673             return ownerships;
1674         }
1675     }
1676 
1677     /**
1678      * @dev Returns an array of token IDs owned by `owner`,
1679      * in the range [`start`, `stop`)
1680      * (i.e. `start <= tokenId < stop`).
1681      *
1682      * This function allows for tokens to be queried if the collection
1683      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1684      *
1685      * Requirements:
1686      *
1687      * - `start` < `stop`
1688      */
1689     function tokensOfOwnerIn(
1690         address owner,
1691         uint256 start,
1692         uint256 stop
1693     ) external view override returns (uint256[] memory) {
1694         unchecked {
1695             if (start >= stop) revert InvalidQueryRange();
1696             uint256 tokenIdsIdx;
1697             uint256 stopLimit = _nextTokenId();
1698             // Set `start = max(start, _startTokenId())`.
1699             if (start < _startTokenId()) {
1700                 start = _startTokenId();
1701             }
1702             // Set `stop = min(stop, stopLimit)`.
1703             if (stop > stopLimit) {
1704                 stop = stopLimit;
1705             }
1706             uint256 tokenIdsMaxLength = balanceOf(owner);
1707             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1708             // to cater for cases where `balanceOf(owner)` is too big.
1709             if (start < stop) {
1710                 uint256 rangeLength = stop - start;
1711                 if (rangeLength < tokenIdsMaxLength) {
1712                     tokenIdsMaxLength = rangeLength;
1713                 }
1714             } else {
1715                 tokenIdsMaxLength = 0;
1716             }
1717             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1718             if (tokenIdsMaxLength == 0) {
1719                 return tokenIds;
1720             }
1721             // We need to call `explicitOwnershipOf(start)`,
1722             // because the slot at `start` may not be initialized.
1723             TokenOwnership memory ownership = explicitOwnershipOf(start);
1724             address currOwnershipAddr;
1725             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1726             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1727             if (!ownership.burned) {
1728                 currOwnershipAddr = ownership.addr;
1729             }
1730             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1731                 ownership = _ownershipAt(i);
1732                 if (ownership.burned) {
1733                     continue;
1734                 }
1735                 if (ownership.addr != address(0)) {
1736                     currOwnershipAddr = ownership.addr;
1737                 }
1738                 if (currOwnershipAddr == owner) {
1739                     tokenIds[tokenIdsIdx++] = i;
1740                 }
1741             }
1742             // Downsize the array to fit.
1743             assembly {
1744                 mstore(tokenIds, tokenIdsIdx)
1745             }
1746             return tokenIds;
1747         }
1748     }
1749 
1750     /**
1751      * @dev Returns an array of token IDs owned by `owner`.
1752      *
1753      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1754      * It is meant to be called off-chain.
1755      *
1756      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1757      * multiple smaller scans if the collection is large enough to cause
1758      * an out-of-gas error (10K pfp collections should be fine).
1759      */
1760     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1761         unchecked {
1762             uint256 tokenIdsIdx;
1763             address currOwnershipAddr;
1764             uint256 tokenIdsLength = balanceOf(owner);
1765             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1766             TokenOwnership memory ownership;
1767             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1768                 ownership = _ownershipAt(i);
1769                 if (ownership.burned) {
1770                     continue;
1771                 }
1772                 if (ownership.addr != address(0)) {
1773                     currOwnershipAddr = ownership.addr;
1774                 }
1775                 if (currOwnershipAddr == owner) {
1776                     tokenIds[tokenIdsIdx++] = i;
1777                 }
1778             }
1779             return tokenIds;
1780         }
1781     }
1782 }
1783 
1784 
1785 // File contracts/Orcvalley.sol
1786 
1787 pragma solidity ^0.8.4;
1788 
1789 
1790 
1791 
1792 
1793 
1794 
1795 contract Orcvalley is ERC721A, ERC721ABurnable, ERC721AQueryable, IERC2981, Ownable {
1796     uint256 immutable oorc;
1797     string public orccvaalleey;
1798     IERC721 immutable goobbbliin;
1799 
1800     bool public staartin;
1801 
1802     uint256 public matte;
1803     uint256 public mattelimita;
1804 
1805     uint256 public deev = 1;
1806     uint256 immutable deevlimita;
1807 
1808     mapping(address => bool) public mainted;
1809     mapping(uint256 => bool) public mettaamorphooseed;
1810 
1811     modifier ooonlyPerrrsooonnn() {
1812         require(msg.sender == tx.origin);
1813         require(msg.sender.code.length == 0);
1814         _;
1815     }
1816 
1817     constructor(
1818         uint256 oorc_,
1819         string memory orccvaalleey_,
1820         IERC721 goobbbliin_,
1821         uint256 mattelimita_,
1822         uint256 deevlimita_
1823     ) ERC721A("orcvalley", "ORC") {
1824         oorc = oorc_;
1825         orccvaalleey = orccvaalleey_;
1826         goobbbliin = goobbbliin_;
1827         mattelimita = mattelimita_;
1828         deevlimita = deevlimita_;
1829 
1830         _mint(msg.sender, 1);
1831     }
1832 
1833     function getayourseelf() external ooonlyPerrrsooonnn {
1834         require(staartin, "nootstaartin");
1835         require(totalSupply() + 1 <= oorc, "aimfullyy");
1836         require(!mainted[msg.sender], "urorrrc");
1837         require(matte + 1 <= mattelimita, "fully");
1838 
1839         mainted[msg.sender] = true;
1840         matte += 1;
1841 
1842         _mint(msg.sender, 1);
1843     }
1844 
1845     function boornagaaaiin(uint256[] memory gobbs) external ooonlyPerrrsooonnn {
1846         require(staartin, "nootstaartin");
1847         require(totalSupply() + gobbs.length <= oorc, "aimfullyy");
1848         require(gobbs.length > 0, "empta");
1849 
1850         for (uint256 eye = 0; eye < gobbs.length; eye++) {
1851             require(goobbbliin.ownerOf(gobbs[eye]) == msg.sender, "hac");
1852             require(!mettaamorphooseed[gobbs[eye]], "dable");
1853             mettaamorphooseed[gobbs[eye]] = true;
1854         }
1855         _mint(msg.sender, gobbs.length);
1856     }
1857 
1858     function weewaantiit(address tu, uint256 quuanty) external onlyOwner {
1859         require(totalSupply() + quuanty <= oorc, "aimfullyy");
1860         require(deev + quuanty <= deevlimita, "byee");
1861 
1862         deev += quuanty;
1863         _mint(tu, quuanty);
1864     }
1865 
1866     function waatchmee(bool staartin_) external onlyOwner {
1867         staartin = staartin_;
1868     }
1869 
1870     function mettaamorphoose(string memory orccvaalleey_) external onlyOwner {
1871         orccvaalleey = orccvaalleey_;
1872     }
1873 
1874     function brreeedingg(uint256 mattelimita_) external onlyOwner {
1875         mattelimita = mattelimita_;
1876     }
1877 
1878     function graabby() external onlyOwner {
1879         payable(owner()).transfer(address(this).balance);
1880     }
1881 
1882     function taakken(IERC20 takken) external onlyOwner {
1883         require(takken.transfer(msg.sender, takken.balanceOf(address(this))));
1884     }
1885 
1886     function supportsInterface(bytes4 interfaceId)
1887         public
1888         view
1889         virtual
1890         override(ERC721A, IERC721A, IERC165)
1891         returns (bool)
1892     {
1893         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1894     }
1895 
1896     function royaltyInfo(
1897         uint256, /* takeNid */
1898         uint256 priicee
1899     ) external view override returns (address, uint256) {
1900         return (owner(), (priicee * 10) / 100);
1901     }
1902 
1903     function _baseURI() internal view override returns (string memory) {
1904         return orccvaalleey;
1905     }
1906 }