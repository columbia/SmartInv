1 //SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
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
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.4.2
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 // CAUTION
114 // This version of SafeMath should only be used with Solidity 0.8 or later,
115 // because it relies on the compiler's built in overflow checks.
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations.
119  *
120  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
121  * now has built in overflow checking.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         unchecked {
131             uint256 c = a + b;
132             if (c < a) return (false, 0);
133             return (true, c);
134         }
135     }
136 
137     /**
138      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
139      *
140      * _Available since v3.4._
141      */
142     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         unchecked {
144             if (b > a) return (false, 0);
145             return (true, a - b);
146         }
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         unchecked {
156             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157             // benefit is lost if 'b' is also tested.
158             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159             if (a == 0) return (true, 0);
160             uint256 c = a * b;
161             if (c / a != b) return (false, 0);
162             return (true, c);
163         }
164     }
165 
166     /**
167      * @dev Returns the division of two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             if (b == 0) return (false, 0);
174             return (true, a / b);
175         }
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         unchecked {
185             if (b == 0) return (false, 0);
186             return (true, a % b);
187         }
188     }
189 
190     /**
191      * @dev Returns the addition of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `+` operator.
195      *
196      * Requirements:
197      *
198      * - Addition cannot overflow.
199      */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         return a + b;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a - b;
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `*` operator.
223      *
224      * Requirements:
225      *
226      * - Multiplication cannot overflow.
227      */
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         return a * b;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator.
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         return a / b;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * reverting when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a % b;
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
264      * overflow (when the result is negative).
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {trySub}.
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(
276         uint256 a,
277         uint256 b,
278         string memory errorMessage
279     ) internal pure returns (uint256) {
280         unchecked {
281             require(b <= a, errorMessage);
282             return a - b;
283         }
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(
299         uint256 a,
300         uint256 b,
301         string memory errorMessage
302     ) internal pure returns (uint256) {
303         unchecked {
304             require(b > 0, errorMessage);
305             return a / b;
306         }
307     }
308 
309     /**
310      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
311      * reverting with custom message when dividing by zero.
312      *
313      * CAUTION: This function is deprecated because it requires allocating memory for the error
314      * message unnecessarily. For custom revert reasons use {tryMod}.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(
325         uint256 a,
326         uint256 b,
327         string memory errorMessage
328     ) internal pure returns (uint256) {
329         unchecked {
330             require(b > 0, errorMessage);
331             return a % b;
332         }
333     }
334 }
335 
336 
337 // File erc721a/contracts/IERC721A.sol@v4.0.0
338 
339 
340 // ERC721A Contracts v4.0.0
341 // Creator: Chiru Labs
342 
343 pragma solidity ^0.8.4;
344 
345 /**
346  * @dev Interface of an ERC721A compliant contract.
347  */
348 interface IERC721A {
349     /**
350      * The caller must own the token or be an approved operator.
351      */
352     error ApprovalCallerNotOwnerNorApproved();
353 
354     /**
355      * The token does not exist.
356      */
357     error ApprovalQueryForNonexistentToken();
358 
359     /**
360      * The caller cannot approve to their own address.
361      */
362     error ApproveToCaller();
363 
364     /**
365      * The caller cannot approve to the current owner.
366      */
367     error ApprovalToCurrentOwner();
368 
369     /**
370      * Cannot query the balance for the zero address.
371      */
372     error BalanceQueryForZeroAddress();
373 
374     /**
375      * Cannot mint to the zero address.
376      */
377     error MintToZeroAddress();
378 
379     /**
380      * The quantity of tokens minted must be more than zero.
381      */
382     error MintZeroQuantity();
383 
384     /**
385      * The token does not exist.
386      */
387     error OwnerQueryForNonexistentToken();
388 
389     /**
390      * The caller must own the token or be an approved operator.
391      */
392     error TransferCallerNotOwnerNorApproved();
393 
394     /**
395      * The token must be owned by `from`.
396      */
397     error TransferFromIncorrectOwner();
398 
399     /**
400      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
401      */
402     error TransferToNonERC721ReceiverImplementer();
403 
404     /**
405      * Cannot transfer to the zero address.
406      */
407     error TransferToZeroAddress();
408 
409     /**
410      * The token does not exist.
411      */
412     error URIQueryForNonexistentToken();
413 
414     struct TokenOwnership {
415         // The address of the owner.
416         address addr;
417         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
418         uint64 startTimestamp;
419         // Whether the token has been burned.
420         bool burned;
421     }
422 
423     /**
424      * @dev Returns the total amount of tokens stored by the contract.
425      *
426      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
427      */
428     function totalSupply() external view returns (uint256);
429 
430     // ==============================
431     //            IERC165
432     // ==============================
433 
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 
444     // ==============================
445     //            IERC721
446     // ==============================
447 
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId,
494         bytes calldata data
495     ) external;
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Transfers `tokenId` token from `from` to `to`.
519      *
520      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      *
529      * Emits a {Transfer} event.
530      */
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
539      * The approval is cleared when the token is transferred.
540      *
541      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external;
551 
552     /**
553      * @dev Approve or remove `operator` as an operator for the caller.
554      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
555      *
556      * Requirements:
557      *
558      * - The `operator` cannot be the caller.
559      *
560      * Emits an {ApprovalForAll} event.
561      */
562     function setApprovalForAll(address operator, bool _approved) external;
563 
564     /**
565      * @dev Returns the account approved for `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function getApproved(uint256 tokenId) external view returns (address operator);
572 
573     /**
574      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
575      *
576      * See {setApprovalForAll}
577      */
578     function isApprovedForAll(address owner, address operator) external view returns (bool);
579 
580     // ==============================
581     //        IERC721Metadata
582     // ==============================
583 
584     /**
585      * @dev Returns the token collection name.
586      */
587     function name() external view returns (string memory);
588 
589     /**
590      * @dev Returns the token collection symbol.
591      */
592     function symbol() external view returns (string memory);
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) external view returns (string memory);
598 }
599 
600 
601 // File erc721a/contracts/ERC721A.sol@v4.0.0
602 
603 // ERC721A Contracts v4.0.0
604 // Creator: Chiru Labs
605 
606 pragma solidity ^0.8.4;
607 
608 /**
609  * @dev ERC721 token receiver interface.
610  */
611 interface ERC721A__IERC721Receiver {
612     function onERC721Received(
613         address operator,
614         address from,
615         uint256 tokenId,
616         bytes calldata data
617     ) external returns (bytes4);
618 }
619 
620 /**
621  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
622  * the Metadata extension. Built to optimize for lower gas during batch mints.
623  *
624  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
625  *
626  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
627  *
628  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
629  */
630 contract ERC721A is IERC721A {
631     // Mask of an entry in packed address data.
632     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
633 
634     // The bit position of `numberMinted` in packed address data.
635     uint256 private constant BITPOS_NUMBER_MINTED = 64;
636 
637     // The bit position of `numberBurned` in packed address data.
638     uint256 private constant BITPOS_NUMBER_BURNED = 128;
639 
640     // The bit position of `aux` in packed address data.
641     uint256 private constant BITPOS_AUX = 192;
642 
643     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
644     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
645 
646     // The bit position of `startTimestamp` in packed ownership.
647     uint256 private constant BITPOS_START_TIMESTAMP = 160;
648 
649     // The bit mask of the `burned` bit in packed ownership.
650     uint256 private constant BITMASK_BURNED = 1 << 224;
651 
652     // The bit position of the `nextInitialized` bit in packed ownership.
653     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
654 
655     // The bit mask of the `nextInitialized` bit in packed ownership.
656     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
657 
658     // The tokenId of the next token to be minted.
659     uint256 private _currentIndex;
660 
661     // The number of tokens burned.
662     uint256 private _burnCounter;
663 
664     // Token name
665     string private _name;
666 
667     // Token symbol
668     string private _symbol;
669 
670     // Mapping from token ID to ownership details
671     // An empty struct value does not necessarily mean the token is unowned.
672     // See `_packedOwnershipOf` implementation for details.
673     //
674     // Bits Layout:
675     // - [0..159]   `addr`
676     // - [160..223] `startTimestamp`
677     // - [224]      `burned`
678     // - [225]      `nextInitialized`
679     mapping(uint256 => uint256) private _packedOwnerships;
680 
681     // Mapping owner address to address data.
682     //
683     // Bits Layout:
684     // - [0..63]    `balance`
685     // - [64..127]  `numberMinted`
686     // - [128..191] `numberBurned`
687     // - [192..255] `aux`
688     mapping(address => uint256) private _packedAddressData;
689 
690     // Mapping from token ID to approved address.
691     mapping(uint256 => address) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     constructor(string memory name_, string memory symbol_) {
697         _name = name_;
698         _symbol = symbol_;
699         _currentIndex = _startTokenId();
700     }
701 
702     /**
703      * @dev Returns the starting token ID.
704      * To change the starting token ID, please override this function.
705      */
706     function _startTokenId() internal view virtual returns (uint256) {
707         return 0;
708     }
709 
710     /**
711      * @dev Returns the next token ID to be minted.
712      */
713     function _nextTokenId() internal view returns (uint256) {
714         return _currentIndex;
715     }
716 
717     /**
718      * @dev Returns the total number of tokens in existence.
719      * Burned tokens will reduce the count.
720      * To get the total number of tokens minted, please see `_totalMinted`.
721      */
722     function totalSupply() public view override returns (uint256) {
723         // Counter underflow is impossible as _burnCounter cannot be incremented
724         // more than `_currentIndex - _startTokenId()` times.
725         unchecked {
726             return _currentIndex - _burnCounter - _startTokenId();
727         }
728     }
729 
730     /**
731      * @dev Returns the total amount of tokens minted in the contract.
732      */
733     function _totalMinted() internal view returns (uint256) {
734         // Counter underflow is impossible as _currentIndex does not decrement,
735         // and it is initialized to `_startTokenId()`
736         unchecked {
737             return _currentIndex - _startTokenId();
738         }
739     }
740 
741     /**
742      * @dev Returns the total number of tokens burned.
743      */
744     function _totalBurned() internal view returns (uint256) {
745         return _burnCounter;
746     }
747 
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752         // The interface IDs are constants representing the first 4 bytes of the XOR of
753         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
754         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
755         return
756             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
757             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
758             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view override returns (uint256) {
765         if (owner == address(0)) revert BalanceQueryForZeroAddress();
766         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
767     }
768 
769     /**
770      * Returns the number of tokens minted by `owner`.
771      */
772     function _numberMinted(address owner) internal view returns (uint256) {
773         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
774     }
775 
776     /**
777      * Returns the number of tokens burned by or on behalf of `owner`.
778      */
779     function _numberBurned(address owner) internal view returns (uint256) {
780         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
781     }
782 
783     /**
784      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
785      */
786     function _getAux(address owner) internal view returns (uint64) {
787         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
788     }
789 
790     /**
791      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
792      * If there are multiple variables, please pack them into a uint64.
793      */
794     function _setAux(address owner, uint64 aux) internal {
795         uint256 packed = _packedAddressData[owner];
796         uint256 auxCasted;
797         assembly { // Cast aux without masking.
798             auxCasted := aux
799         }
800         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
801         _packedAddressData[owner] = packed;
802     }
803 
804     /**
805      * Returns the packed ownership data of `tokenId`.
806      */
807     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
808         uint256 curr = tokenId;
809 
810         unchecked {
811             if (_startTokenId() <= curr)
812                 if (curr < _currentIndex) {
813                     uint256 packed = _packedOwnerships[curr];
814                     // If not burned.
815                     if (packed & BITMASK_BURNED == 0) {
816                         // Invariant:
817                         // There will always be an ownership that has an address and is not burned
818                         // before an ownership that does not have an address and is not burned.
819                         // Hence, curr will not underflow.
820                         //
821                         // We can directly compare the packed value.
822                         // If the address is zero, packed is zero.
823                         while (packed == 0) {
824                             packed = _packedOwnerships[--curr];
825                         }
826                         return packed;
827                     }
828                 }
829         }
830         revert OwnerQueryForNonexistentToken();
831     }
832 
833     /**
834      * Returns the unpacked `TokenOwnership` struct from `packed`.
835      */
836     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
837         ownership.addr = address(uint160(packed));
838         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
839         ownership.burned = packed & BITMASK_BURNED != 0;
840     }
841 
842     /**
843      * Returns the unpacked `TokenOwnership` struct at `index`.
844      */
845     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
846         return _unpackedOwnership(_packedOwnerships[index]);
847     }
848 
849     /**
850      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
851      */
852     function _initializeOwnershipAt(uint256 index) internal {
853         if (_packedOwnerships[index] == 0) {
854             _packedOwnerships[index] = _packedOwnershipOf(index);
855         }
856     }
857 
858     /**
859      * Gas spent here starts off proportional to the maximum mint batch size.
860      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
861      */
862     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
863         return _unpackedOwnership(_packedOwnershipOf(tokenId));
864     }
865 
866     /**
867      * @dev See {IERC721-ownerOf}.
868      */
869     function ownerOf(uint256 tokenId) public view override returns (address) {
870         return address(uint160(_packedOwnershipOf(tokenId)));
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-name}.
875      */
876     function name() public view virtual override returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev See {IERC721Metadata-symbol}.
882      */
883     function symbol() public view virtual override returns (string memory) {
884         return _symbol;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-tokenURI}.
889      */
890     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
891         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
892 
893         string memory baseURI = _baseURI();
894         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, can be overriden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return '';
904     }
905 
906     /**
907      * @dev Casts the address to uint256 without masking.
908      */
909     function _addressToUint256(address value) private pure returns (uint256 result) {
910         assembly {
911             result := value
912         }
913     }
914 
915     /**
916      * @dev Casts the boolean to uint256 without branching.
917      */
918     function _boolToUint256(bool value) private pure returns (uint256 result) {
919         assembly {
920             result := value
921         }
922     }
923 
924     /**
925      * @dev See {IERC721-approve}.
926      */
927     function approve(address to, uint256 tokenId) public override {
928         address owner = address(uint160(_packedOwnershipOf(tokenId)));
929         if (to == owner) revert ApprovalToCurrentOwner();
930 
931         if (_msgSenderERC721A() != owner)
932             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
933                 revert ApprovalCallerNotOwnerNorApproved();
934             }
935 
936         _tokenApprovals[tokenId] = to;
937         emit Approval(owner, to, tokenId);
938     }
939 
940     /**
941      * @dev See {IERC721-getApproved}.
942      */
943     function getApproved(uint256 tokenId) public view override returns (address) {
944         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
945 
946         return _tokenApprovals[tokenId];
947     }
948 
949     /**
950      * @dev See {IERC721-setApprovalForAll}.
951      */
952     function setApprovalForAll(address operator, bool approved) public virtual override {
953         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
954 
955         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
956         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
957     }
958 
959     /**
960      * @dev See {IERC721-isApprovedForAll}.
961      */
962     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
963         return _operatorApprovals[owner][operator];
964     }
965 
966     /**
967      * @dev See {IERC721-transferFrom}.
968      */
969     function transferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public virtual override {
974         _transfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId
984     ) public virtual override {
985         safeTransferFrom(from, to, tokenId, '');
986     }
987 
988     /**
989      * @dev See {IERC721-safeTransferFrom}.
990      */
991     function safeTransferFrom(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) public virtual override {
997         _transfer(from, to, tokenId);
998         if (to.code.length != 0)
999             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1000                 revert TransferToNonERC721ReceiverImplementer();
1001             }
1002     }
1003 
1004     /**
1005      * @dev Returns whether `tokenId` exists.
1006      *
1007      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1008      *
1009      * Tokens start existing when they are minted (`_mint`),
1010      */
1011     function _exists(uint256 tokenId) internal view returns (bool) {
1012         return
1013             _startTokenId() <= tokenId &&
1014             tokenId < _currentIndex && // If within bounds,
1015             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1016     }
1017 
1018     /**
1019      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1020      */
1021     function _safeMint(address to, uint256 quantity) internal {
1022         _safeMint(to, quantity, '');
1023     }
1024 
1025     /**
1026      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - If `to` refers to a smart contract, it must implement
1031      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _safeMint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data
1040     ) internal {
1041         uint256 startTokenId = _currentIndex;
1042         if (to == address(0)) revert MintToZeroAddress();
1043         if (quantity == 0) revert MintZeroQuantity();
1044 
1045         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1046 
1047         // Overflows are incredibly unrealistic.
1048         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1049         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1050         unchecked {
1051             // Updates:
1052             // - `balance += quantity`.
1053             // - `numberMinted += quantity`.
1054             //
1055             // We can directly add to the balance and number minted.
1056             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1057 
1058             // Updates:
1059             // - `address` to the owner.
1060             // - `startTimestamp` to the timestamp of minting.
1061             // - `burned` to `false`.
1062             // - `nextInitialized` to `quantity == 1`.
1063             _packedOwnerships[startTokenId] =
1064                 _addressToUint256(to) |
1065                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1066                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1067 
1068             uint256 updatedIndex = startTokenId;
1069             uint256 end = updatedIndex + quantity;
1070 
1071             if (to.code.length != 0) {
1072                 do {
1073                     emit Transfer(address(0), to, updatedIndex);
1074                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1075                         revert TransferToNonERC721ReceiverImplementer();
1076                     }
1077                 } while (updatedIndex < end);
1078                 // Reentrancy protection
1079                 if (_currentIndex != startTokenId) revert();
1080             } else {
1081                 do {
1082                     emit Transfer(address(0), to, updatedIndex++);
1083                 } while (updatedIndex < end);
1084             }
1085             _currentIndex = updatedIndex;
1086         }
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _mint(address to, uint256 quantity) internal {
1101         uint256 startTokenId = _currentIndex;
1102         if (to == address(0)) revert MintToZeroAddress();
1103         if (quantity == 0) revert MintZeroQuantity();
1104 
1105         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1106 
1107         // Overflows are incredibly unrealistic.
1108         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1109         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1110         unchecked {
1111             // Updates:
1112             // - `balance += quantity`.
1113             // - `numberMinted += quantity`.
1114             //
1115             // We can directly add to the balance and number minted.
1116             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1117 
1118             // Updates:
1119             // - `address` to the owner.
1120             // - `startTimestamp` to the timestamp of minting.
1121             // - `burned` to `false`.
1122             // - `nextInitialized` to `quantity == 1`.
1123             _packedOwnerships[startTokenId] =
1124                 _addressToUint256(to) |
1125                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1126                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1127 
1128             uint256 updatedIndex = startTokenId;
1129             uint256 end = updatedIndex + quantity;
1130 
1131             do {
1132                 emit Transfer(address(0), to, updatedIndex++);
1133             } while (updatedIndex < end);
1134 
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Transfers `tokenId` from `from` to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must be owned by `from`.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _transfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) private {
1155         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1156 
1157         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1158 
1159         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1160             isApprovedForAll(from, _msgSenderERC721A()) ||
1161             getApproved(tokenId) == _msgSenderERC721A());
1162 
1163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1164         if (to == address(0)) revert TransferToZeroAddress();
1165 
1166         _beforeTokenTransfers(from, to, tokenId, 1);
1167 
1168         // Clear approvals from the previous owner.
1169         delete _tokenApprovals[tokenId];
1170 
1171         // Underflow of the sender's balance is impossible because we check for
1172         // ownership above and the recipient's balance can't realistically overflow.
1173         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1174         unchecked {
1175             // We can directly increment and decrement the balances.
1176             --_packedAddressData[from]; // Updates: `balance -= 1`.
1177             ++_packedAddressData[to]; // Updates: `balance += 1`.
1178 
1179             // Updates:
1180             // - `address` to the next owner.
1181             // - `startTimestamp` to the timestamp of transfering.
1182             // - `burned` to `false`.
1183             // - `nextInitialized` to `true`.
1184             _packedOwnerships[tokenId] =
1185                 _addressToUint256(to) |
1186                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1187                 BITMASK_NEXT_INITIALIZED;
1188 
1189             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1190             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1191                 uint256 nextTokenId = tokenId + 1;
1192                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1193                 if (_packedOwnerships[nextTokenId] == 0) {
1194                     // If the next slot is within bounds.
1195                     if (nextTokenId != _currentIndex) {
1196                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1197                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1198                     }
1199                 }
1200             }
1201         }
1202 
1203         emit Transfer(from, to, tokenId);
1204         _afterTokenTransfers(from, to, tokenId, 1);
1205     }
1206 
1207     /**
1208      * @dev Equivalent to `_burn(tokenId, false)`.
1209      */
1210     function _burn(uint256 tokenId) internal virtual {
1211         _burn(tokenId, false);
1212     }
1213 
1214     /**
1215      * @dev Destroys `tokenId`.
1216      * The approval is cleared when the token is burned.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1225         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1226 
1227         address from = address(uint160(prevOwnershipPacked));
1228 
1229         if (approvalCheck) {
1230             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1231                 isApprovedForAll(from, _msgSenderERC721A()) ||
1232                 getApproved(tokenId) == _msgSenderERC721A());
1233 
1234             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1235         }
1236 
1237         _beforeTokenTransfers(from, address(0), tokenId, 1);
1238 
1239         // Clear approvals from the previous owner.
1240         delete _tokenApprovals[tokenId];
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             // Updates:
1247             // - `balance -= 1`.
1248             // - `numberBurned += 1`.
1249             //
1250             // We can directly decrement the balance, and increment the number burned.
1251             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1252             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1253 
1254             // Updates:
1255             // - `address` to the last owner.
1256             // - `startTimestamp` to the timestamp of burning.
1257             // - `burned` to `true`.
1258             // - `nextInitialized` to `true`.
1259             _packedOwnerships[tokenId] =
1260                 _addressToUint256(from) |
1261                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1262                 BITMASK_BURNED |
1263                 BITMASK_NEXT_INITIALIZED;
1264 
1265             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1266             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1267                 uint256 nextTokenId = tokenId + 1;
1268                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1269                 if (_packedOwnerships[nextTokenId] == 0) {
1270                     // If the next slot is within bounds.
1271                     if (nextTokenId != _currentIndex) {
1272                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1273                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1274                     }
1275                 }
1276             }
1277         }
1278 
1279         emit Transfer(from, address(0), tokenId);
1280         _afterTokenTransfers(from, address(0), tokenId, 1);
1281 
1282         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1283         unchecked {
1284             _burnCounter++;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1290      *
1291      * @param from address representing the previous owner of the given token ID
1292      * @param to target address that will receive the tokens
1293      * @param tokenId uint256 ID of the token to be transferred
1294      * @param _data bytes optional data to send along with the call
1295      * @return bool whether the call correctly returned the expected magic value
1296      */
1297     function _checkContractOnERC721Received(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) private returns (bool) {
1303         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1304             bytes4 retval
1305         ) {
1306             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1307         } catch (bytes memory reason) {
1308             if (reason.length == 0) {
1309                 revert TransferToNonERC721ReceiverImplementer();
1310             } else {
1311                 assembly {
1312                     revert(add(32, reason), mload(reason))
1313                 }
1314             }
1315         }
1316     }
1317 
1318     /**
1319      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1320      * And also called before burning one token.
1321      *
1322      * startTokenId - the first token id to be transferred
1323      * quantity - the amount to be transferred
1324      *
1325      * Calling conditions:
1326      *
1327      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1328      * transferred to `to`.
1329      * - When `from` is zero, `tokenId` will be minted for `to`.
1330      * - When `to` is zero, `tokenId` will be burned by `from`.
1331      * - `from` and `to` are never both zero.
1332      */
1333     function _beforeTokenTransfers(
1334         address from,
1335         address to,
1336         uint256 startTokenId,
1337         uint256 quantity
1338     ) internal virtual {}
1339 
1340     /**
1341      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1342      * minting.
1343      * And also called after one token has been burned.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` has been minted for `to`.
1353      * - When `to` is zero, `tokenId` has been burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _afterTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 
1363     /**
1364      * @dev Returns the message sender (defaults to `msg.sender`).
1365      *
1366      * If you are writing GSN compatible contracts, you need to override this function.
1367      */
1368     function _msgSenderERC721A() internal view virtual returns (address) {
1369         return msg.sender;
1370     }
1371 
1372     /**
1373      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1374      */
1375     function _toString(uint256 value) internal pure returns (string memory ptr) {
1376         assembly {
1377             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1378             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1379             // We will need 1 32-byte word to store the length,
1380             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1381             ptr := add(mload(0x40), 128)
1382             // Update the free memory pointer to allocate.
1383             mstore(0x40, ptr)
1384 
1385             // Cache the end of the memory to calculate the length later.
1386             let end := ptr
1387 
1388             // We write the string from the rightmost digit to the leftmost digit.
1389             // The following is essentially a do-while loop that also handles the zero case.
1390             // Costs a bit more than early returning for the zero case,
1391             // but cheaper in terms of deployment and overall runtime costs.
1392             for {
1393                 // Initialize and perform the first pass without check.
1394                 let temp := value
1395                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1396                 ptr := sub(ptr, 1)
1397                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1398                 mstore8(ptr, add(48, mod(temp, 10)))
1399                 temp := div(temp, 10)
1400             } temp {
1401                 // Keep dividing `temp` until zero.
1402                 temp := div(temp, 10)
1403             } { // Body of the for loop.
1404                 ptr := sub(ptr, 1)
1405                 mstore8(ptr, add(48, mod(temp, 10)))
1406             }
1407 
1408             let length := sub(end, ptr)
1409             // Move the pointer 32 bytes leftwards to make room for the length.
1410             ptr := sub(ptr, 32)
1411             // Store the length.
1412             mstore(ptr, length)
1413         }
1414     }
1415 }
1416 
1417 // File contracts/Neighbors.sol
1418 pragma solidity ^0.8.13;
1419 contract Neighbors is ERC721A, Ownable {
1420     using SafeMath for uint256;
1421 
1422     event PermanentURI(string _value, uint256 indexed _id);
1423 
1424     bool private isWhitelistSaleActive = true;
1425     bool private isPublicSaleActive = false;
1426     uint256 private totalNeighbors = 1111;
1427 
1428     mapping(address => uint8) private _whiteList;
1429 
1430     constructor() ERC721A("Neighbors", "NBRS") {}
1431 
1432     function setWhiteList(address[] calldata addresses, uint8 mintCount) external onlyOwner {
1433         for (uint256 i = 0; i < addresses.length; i++) {
1434             _whiteList[addresses[i]] = mintCount;
1435         }
1436     }
1437 
1438     function togglePublicSale() external onlyOwner {
1439         isPublicSaleActive = !isPublicSaleActive;
1440     }
1441 
1442     function toggleWhitelistSale() external onlyOwner {
1443         isWhitelistSaleActive = !isWhitelistSaleActive;
1444     }
1445 
1446     function setTotalNeighbors(uint256 amount) external onlyOwner returns (uint256) {
1447         totalNeighbors = amount;
1448         return totalNeighbors;
1449     }
1450 
1451     function reserve(address to, uint256 quantity) external onlyOwner {
1452         uint256 ts = totalSupply();
1453         require(quantity > 0, "Quantity cannot be zero");
1454         require(ts.add(quantity) <= totalNeighbors, "Not enough supply");
1455         _safeMint(to, quantity);
1456     }
1457 
1458     function mint() external payable {
1459         uint256 ts = totalSupply();
1460         require(isWhitelistSaleActive, "Mint is not active.");
1461 
1462         uint8 quantity = 1;
1463         if (!isPublicSaleActive) {
1464             require(_whiteList[msg.sender] > 0, "Public mint is not active.");
1465             require(ts.add(_whiteList[msg.sender]) <= totalNeighbors, "Not enough supply");
1466             quantity = _whiteList[msg.sender];
1467             _whiteList[msg.sender] = 0;
1468         } else {
1469             require(ts.add(1) <= totalNeighbors, "Not enough supply");
1470         }
1471 
1472         _safeMint(msg.sender, quantity);
1473     }
1474 
1475     function lockMetaData() external onlyOwner {
1476         uint256 ts = totalSupply();
1477         for (uint256 i = 0; i < ts; i++) {
1478             uint256 tid = totalSupply() - i;
1479             emit PermanentURI(tokenURI(tid), tid);
1480         }
1481     }
1482 
1483     function withdraw() external onlyOwner {
1484         uint balance = address(this).balance;
1485         payable(msg.sender).transfer(balance);
1486     }
1487 
1488     function contractURI() public pure returns (string memory) {
1489         return "https://nbrs.io/opensea/metadata.json";
1490     }
1491 
1492     function _baseURI() internal view virtual override returns (string memory) {
1493         return "https://storage.googleapis.com/nbrs.io/neighbors/";
1494     }
1495 
1496     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1497         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1498 
1499         string memory baseURI = _baseURI();
1500         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId + 1), '.json')) : '';
1501     }
1502 }