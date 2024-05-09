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
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 // CAUTION
145 // This version of SafeMath should only be used with Solidity 0.8 or later,
146 // because it relies on the compiler's built in overflow checks.
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations.
150  *
151  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
152  * now has built in overflow checking.
153  */
154 library SafeMath {
155     /**
156      * @dev Returns the addition of two unsigned integers, with an overflow flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             uint256 c = a + b;
163             if (c < a) return (false, 0);
164             return (true, c);
165         }
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
170      *
171      * _Available since v3.4._
172      */
173     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         unchecked {
175             if (b > a) return (false, 0);
176             return (true, a - b);
177         }
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
182      *
183      * _Available since v3.4._
184      */
185     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
186         unchecked {
187             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188             // benefit is lost if 'b' is also tested.
189             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190             if (a == 0) return (true, 0);
191             uint256 c = a * b;
192             if (c / a != b) return (false, 0);
193             return (true, c);
194         }
195     }
196 
197     /**
198      * @dev Returns the division of two unsigned integers, with a division by zero flag.
199      *
200      * _Available since v3.4._
201      */
202     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         unchecked {
204             if (b == 0) return (false, 0);
205             return (true, a / b);
206         }
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
211      *
212      * _Available since v3.4._
213      */
214     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         unchecked {
216             if (b == 0) return (false, 0);
217             return (true, a % b);
218         }
219     }
220 
221     /**
222      * @dev Returns the addition of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `+` operator.
226      *
227      * Requirements:
228      *
229      * - Addition cannot overflow.
230      */
231     function add(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a + b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a - b;
247     }
248 
249     /**
250      * @dev Returns the multiplication of two unsigned integers, reverting on
251      * overflow.
252      *
253      * Counterpart to Solidity's `*` operator.
254      *
255      * Requirements:
256      *
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a * b;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers, reverting on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator.
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a / b;
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * reverting when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a % b;
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
295      * overflow (when the result is negative).
296      *
297      * CAUTION: This function is deprecated because it requires allocating memory for the error
298      * message unnecessarily. For custom revert reasons use {trySub}.
299      *
300      * Counterpart to Solidity's `-` operator.
301      *
302      * Requirements:
303      *
304      * - Subtraction cannot overflow.
305      */
306     function sub(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b <= a, errorMessage);
313             return a - b;
314         }
315     }
316 
317     /**
318      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
319      * division by zero. The result is rounded towards zero.
320      *
321      * Counterpart to Solidity's `/` operator. Note: this function uses a
322      * `revert` opcode (which leaves remaining gas untouched) while Solidity
323      * uses an invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function div(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a / b;
337         }
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
342      * reverting with custom message when dividing by zero.
343      *
344      * CAUTION: This function is deprecated because it requires allocating memory for the error
345      * message unnecessarily. For custom revert reasons use {tryMod}.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(
356         uint256 a,
357         uint256 b,
358         string memory errorMessage
359     ) internal pure returns (uint256) {
360         unchecked {
361             require(b > 0, errorMessage);
362             return a % b;
363         }
364     }
365 }
366 
367 // File: @openzeppelin/contracts/utils/Context.sol
368 
369 
370 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Provides information about the current execution context, including the
376  * sender of the transaction and its data. While these are generally available
377  * via msg.sender and msg.data, they should not be accessed in such a direct
378  * manner, since when dealing with meta-transactions the account sending and
379  * paying for execution may not be the actual sender (as far as an application
380  * is concerned).
381  *
382  * This contract is only required for intermediate, library-like contracts.
383  */
384 abstract contract Context {
385     function _msgSender() internal view virtual returns (address) {
386         return msg.sender;
387     }
388 
389     function _msgData() internal view virtual returns (bytes calldata) {
390         return msg.data;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/access/Ownable.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 abstract contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor() {
423         _transferOwnership(_msgSender());
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         _transferOwnership(address(0));
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         _transferOwnership(newOwner);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Internal function without access restriction.
464      */
465     function _transferOwnership(address newOwner) internal virtual {
466         address oldOwner = _owner;
467         _owner = newOwner;
468         emit OwnershipTransferred(oldOwner, newOwner);
469     }
470 }
471 
472 // File: erc721a/contracts/IERC721A.sol
473 
474 
475 // ERC721A Contracts v4.0.0
476 // Creator: Chiru Labs
477 
478 pragma solidity ^0.8.4;
479 
480 /**
481  * @dev Interface of an ERC721A compliant contract.
482  */
483 interface IERC721A {
484     /**
485      * The caller must own the token or be an approved operator.
486      */
487     error ApprovalCallerNotOwnerNorApproved();
488 
489     /**
490      * The token does not exist.
491      */
492     error ApprovalQueryForNonexistentToken();
493 
494     /**
495      * The caller cannot approve to their own address.
496      */
497     error ApproveToCaller();
498 
499     /**
500      * The caller cannot approve to the current owner.
501      */
502     error ApprovalToCurrentOwner();
503 
504     /**
505      * Cannot query the balance for the zero address.
506      */
507     error BalanceQueryForZeroAddress();
508 
509     /**
510      * Cannot mint to the zero address.
511      */
512     error MintToZeroAddress();
513 
514     /**
515      * The quantity of tokens minted must be more than zero.
516      */
517     error MintZeroQuantity();
518 
519     /**
520      * The token does not exist.
521      */
522     error OwnerQueryForNonexistentToken();
523 
524     /**
525      * The caller must own the token or be an approved operator.
526      */
527     error TransferCallerNotOwnerNorApproved();
528 
529     /**
530      * The token must be owned by `from`.
531      */
532     error TransferFromIncorrectOwner();
533 
534     /**
535      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
536      */
537     error TransferToNonERC721ReceiverImplementer();
538 
539     /**
540      * Cannot transfer to the zero address.
541      */
542     error TransferToZeroAddress();
543 
544     /**
545      * The token does not exist.
546      */
547     error URIQueryForNonexistentToken();
548 
549     struct TokenOwnership {
550         // The address of the owner.
551         address addr;
552         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
553         uint64 startTimestamp;
554         // Whether the token has been burned.
555         bool burned;
556     }
557 
558     /**
559      * @dev Returns the total amount of tokens stored by the contract.
560      *
561      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
562      */
563     function totalSupply() external view returns (uint256);
564 
565     // ==============================
566     //            IERC165
567     // ==============================
568 
569     /**
570      * @dev Returns true if this contract implements the interface defined by
571      * `interfaceId`. See the corresponding
572      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
573      * to learn more about how these ids are created.
574      *
575      * This function call must use less than 30 000 gas.
576      */
577     function supportsInterface(bytes4 interfaceId) external view returns (bool);
578 
579     // ==============================
580     //            IERC721
581     // ==============================
582 
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
590      */
591     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
595      */
596     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
597 
598     /**
599      * @dev Returns the number of tokens in ``owner``'s account.
600      */
601     function balanceOf(address owner) external view returns (uint256 balance);
602 
603     /**
604      * @dev Returns the owner of the `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function ownerOf(uint256 tokenId) external view returns (address owner);
611 
612     /**
613      * @dev Safely transfers `tokenId` token from `from` to `to`.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external;
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
634      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Transfers `tokenId` token from `from` to `to`.
654      *
655      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must be owned by `from`.
662      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
663      *
664      * Emits a {Transfer} event.
665      */
666     function transferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) external;
671 
672     /**
673      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
674      * The approval is cleared when the token is transferred.
675      *
676      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
677      *
678      * Requirements:
679      *
680      * - The caller must own the token or be an approved operator.
681      * - `tokenId` must exist.
682      *
683      * Emits an {Approval} event.
684      */
685     function approve(address to, uint256 tokenId) external;
686 
687     /**
688      * @dev Approve or remove `operator` as an operator for the caller.
689      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
690      *
691      * Requirements:
692      *
693      * - The `operator` cannot be the caller.
694      *
695      * Emits an {ApprovalForAll} event.
696      */
697     function setApprovalForAll(address operator, bool _approved) external;
698 
699     /**
700      * @dev Returns the account approved for `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function getApproved(uint256 tokenId) external view returns (address operator);
707 
708     /**
709      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
710      *
711      * See {setApprovalForAll}
712      */
713     function isApprovedForAll(address owner, address operator) external view returns (bool);
714 
715     // ==============================
716     //        IERC721Metadata
717     // ==============================
718 
719     /**
720      * @dev Returns the token collection name.
721      */
722     function name() external view returns (string memory);
723 
724     /**
725      * @dev Returns the token collection symbol.
726      */
727     function symbol() external view returns (string memory);
728 
729     /**
730      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
731      */
732     function tokenURI(uint256 tokenId) external view returns (string memory);
733 }
734 
735 // File: erc721a/contracts/ERC721A.sol
736 
737 
738 // ERC721A Contracts v4.0.0
739 // Creator: Chiru Labs
740 
741 pragma solidity ^0.8.4;
742 
743 
744 /**
745  * @dev ERC721 token receiver interface.
746  */
747 interface ERC721A__IERC721Receiver {
748     function onERC721Received(
749         address operator,
750         address from,
751         uint256 tokenId,
752         bytes calldata data
753     ) external returns (bytes4);
754 }
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
761  *
762  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
763  *
764  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
765  */
766 contract ERC721A is IERC721A {
767     // Mask of an entry in packed address data.
768     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
769 
770     // The bit position of `numberMinted` in packed address data.
771     uint256 private constant BITPOS_NUMBER_MINTED = 64;
772 
773     // The bit position of `numberBurned` in packed address data.
774     uint256 private constant BITPOS_NUMBER_BURNED = 128;
775 
776     // The bit position of `aux` in packed address data.
777     uint256 private constant BITPOS_AUX = 192;
778 
779     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
780     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
781 
782     // The bit position of `startTimestamp` in packed ownership.
783     uint256 private constant BITPOS_START_TIMESTAMP = 160;
784 
785     // The bit mask of the `burned` bit in packed ownership.
786     uint256 private constant BITMASK_BURNED = 1 << 224;
787     
788     // The bit position of the `nextInitialized` bit in packed ownership.
789     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
790 
791     // The bit mask of the `nextInitialized` bit in packed ownership.
792     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
793 
794     // The tokenId of the next token to be minted.
795     uint256 private _currentIndex;
796 
797     // The number of tokens burned.
798     uint256 private _burnCounter;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned.
808     // See `_packedOwnershipOf` implementation for details.
809     //
810     // Bits Layout:
811     // - [0..159]   `addr`
812     // - [160..223] `startTimestamp`
813     // - [224]      `burned`
814     // - [225]      `nextInitialized`
815     mapping(uint256 => uint256) private _packedOwnerships;
816 
817     // Mapping owner address to address data.
818     //
819     // Bits Layout:
820     // - [0..63]    `balance`
821     // - [64..127]  `numberMinted`
822     // - [128..191] `numberBurned`
823     // - [192..255] `aux`
824     mapping(address => uint256) private _packedAddressData;
825 
826     // Mapping from token ID to approved address.
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835         _currentIndex = _startTokenId();
836     }
837 
838     /**
839      * @dev Returns the starting token ID. 
840      * To change the starting token ID, please override this function.
841      */
842     function _startTokenId() internal view virtual returns (uint256) {
843         return 0;
844     }
845 
846     /**
847      * @dev Returns the next token ID to be minted.
848      */
849     function _nextTokenId() internal view returns (uint256) {
850         return _currentIndex;
851     }
852 
853     /**
854      * @dev Returns the total number of tokens in existence.
855      * Burned tokens will reduce the count. 
856      * To get the total number of tokens minted, please see `_totalMinted`.
857      */
858     function totalSupply() public view override returns (uint256) {
859         // Counter underflow is impossible as _burnCounter cannot be incremented
860         // more than `_currentIndex - _startTokenId()` times.
861         unchecked {
862             return _currentIndex - _burnCounter - _startTokenId();
863         }
864     }
865 
866     /**
867      * @dev Returns the total amount of tokens minted in the contract.
868      */
869     function _totalMinted() internal view returns (uint256) {
870         // Counter underflow is impossible as _currentIndex does not decrement,
871         // and it is initialized to `_startTokenId()`
872         unchecked {
873             return _currentIndex - _startTokenId();
874         }
875     }
876 
877     /**
878      * @dev Returns the total number of tokens burned.
879      */
880     function _totalBurned() internal view returns (uint256) {
881         return _burnCounter;
882     }
883 
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
888         // The interface IDs are constants representing the first 4 bytes of the XOR of
889         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
890         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
891         return
892             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
893             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
894             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view override returns (uint256) {
901         if (owner == address(0)) revert BalanceQueryForZeroAddress();
902         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
903     }
904 
905     /**
906      * Returns the number of tokens minted by `owner`.
907      */
908     function _numberMinted(address owner) internal view returns (uint256) {
909         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
910     }
911 
912     /**
913      * Returns the number of tokens burned by or on behalf of `owner`.
914      */
915     function _numberBurned(address owner) internal view returns (uint256) {
916         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
917     }
918 
919     /**
920      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
921      */
922     function _getAux(address owner) internal view returns (uint64) {
923         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
924     }
925 
926     /**
927      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
928      * If there are multiple variables, please pack them into a uint64.
929      */
930     function _setAux(address owner, uint64 aux) internal {
931         uint256 packed = _packedAddressData[owner];
932         uint256 auxCasted;
933         assembly { // Cast aux without masking.
934             auxCasted := aux
935         }
936         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
937         _packedAddressData[owner] = packed;
938     }
939 
940     /**
941      * Returns the packed ownership data of `tokenId`.
942      */
943     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
944         uint256 curr = tokenId;
945 
946         unchecked {
947             if (_startTokenId() <= curr)
948                 if (curr < _currentIndex) {
949                     uint256 packed = _packedOwnerships[curr];
950                     // If not burned.
951                     if (packed & BITMASK_BURNED == 0) {
952                         // Invariant:
953                         // There will always be an ownership that has an address and is not burned
954                         // before an ownership that does not have an address and is not burned.
955                         // Hence, curr will not underflow.
956                         //
957                         // We can directly compare the packed value.
958                         // If the address is zero, packed is zero.
959                         while (packed == 0) {
960                             packed = _packedOwnerships[--curr];
961                         }
962                         return packed;
963                     }
964                 }
965         }
966         revert OwnerQueryForNonexistentToken();
967     }
968 
969     /**
970      * Returns the unpacked `TokenOwnership` struct from `packed`.
971      */
972     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
973         ownership.addr = address(uint160(packed));
974         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
975         ownership.burned = packed & BITMASK_BURNED != 0;
976     }
977 
978     /**
979      * Returns the unpacked `TokenOwnership` struct at `index`.
980      */
981     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
982         return _unpackedOwnership(_packedOwnerships[index]);
983     }
984 
985     /**
986      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
987      */
988     function _initializeOwnershipAt(uint256 index) internal {
989         if (_packedOwnerships[index] == 0) {
990             _packedOwnerships[index] = _packedOwnershipOf(index);
991         }
992     }
993 
994     /**
995      * Gas spent here starts off proportional to the maximum mint batch size.
996      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
997      */
998     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
999         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-ownerOf}.
1004      */
1005     function ownerOf(uint256 tokenId) public view override returns (address) {
1006         return address(uint160(_packedOwnershipOf(tokenId)));
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Metadata-name}.
1011      */
1012     function name() public view virtual override returns (string memory) {
1013         return _name;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Metadata-symbol}.
1018      */
1019     function symbol() public view virtual override returns (string memory) {
1020         return _symbol;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Metadata-tokenURI}.
1025      */
1026     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1027         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1028 
1029         string memory baseURI = _baseURI();
1030         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1031     }
1032 
1033     /**
1034      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1035      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1036      * by default, can be overriden in child contracts.
1037      */
1038     function _baseURI() internal view virtual returns (string memory) {
1039         return '';
1040     }
1041 
1042     /**
1043      * @dev Casts the address to uint256 without masking.
1044      */
1045     function _addressToUint256(address value) private pure returns (uint256 result) {
1046         assembly {
1047             result := value
1048         }
1049     }
1050 
1051     /**
1052      * @dev Casts the boolean to uint256 without branching.
1053      */
1054     function _boolToUint256(bool value) private pure returns (uint256 result) {
1055         assembly {
1056             result := value
1057         }
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-approve}.
1062      */
1063     function approve(address to, uint256 tokenId) public override {
1064         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1065         if (to == owner) revert ApprovalToCurrentOwner();
1066 
1067         if (_msgSenderERC721A() != owner)
1068             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1069                 revert ApprovalCallerNotOwnerNorApproved();
1070             }
1071 
1072         _tokenApprovals[tokenId] = to;
1073         emit Approval(owner, to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-getApproved}.
1078      */
1079     function getApproved(uint256 tokenId) public view override returns (address) {
1080         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1081 
1082         return _tokenApprovals[tokenId];
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-setApprovalForAll}.
1087      */
1088     function setApprovalForAll(address operator, bool approved) public virtual override {
1089         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1090 
1091         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1092         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-isApprovedForAll}.
1097      */
1098     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1099         return _operatorApprovals[owner][operator];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-transferFrom}.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public virtual override {
1110         _transfer(from, to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) public virtual override {
1121         safeTransferFrom(from, to, tokenId, '');
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) public virtual override {
1133         _transfer(from, to, tokenId);
1134         if (to.code.length != 0)
1135             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1136                 revert TransferToNonERC721ReceiverImplementer();
1137             }
1138     }
1139 
1140     /**
1141      * @dev Returns whether `tokenId` exists.
1142      *
1143      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1144      *
1145      * Tokens start existing when they are minted (`_mint`),
1146      */
1147     function _exists(uint256 tokenId) internal view returns (bool) {
1148         return
1149             _startTokenId() <= tokenId &&
1150             tokenId < _currentIndex && // If within bounds,
1151             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1152     }
1153 
1154     /**
1155      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1156      */
1157     function _safeMint(address to, uint256 quantity) internal {
1158         _safeMint(to, quantity, '');
1159     }
1160 
1161     /**
1162      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - If `to` refers to a smart contract, it must implement
1167      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _safeMint(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data
1176     ) internal {
1177         uint256 startTokenId = _currentIndex;
1178         if (to == address(0)) revert MintToZeroAddress();
1179         if (quantity == 0) revert MintZeroQuantity();
1180 
1181         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1182 
1183         // Overflows are incredibly unrealistic.
1184         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1185         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1186         unchecked {
1187             // Updates:
1188             // - `balance += quantity`.
1189             // - `numberMinted += quantity`.
1190             //
1191             // We can directly add to the balance and number minted.
1192             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1193 
1194             // Updates:
1195             // - `address` to the owner.
1196             // - `startTimestamp` to the timestamp of minting.
1197             // - `burned` to `false`.
1198             // - `nextInitialized` to `quantity == 1`.
1199             _packedOwnerships[startTokenId] =
1200                 _addressToUint256(to) |
1201                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1202                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1203 
1204             uint256 updatedIndex = startTokenId;
1205             uint256 end = updatedIndex + quantity;
1206 
1207             if (to.code.length != 0) {
1208                 do {
1209                     emit Transfer(address(0), to, updatedIndex);
1210                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1211                         revert TransferToNonERC721ReceiverImplementer();
1212                     }
1213                 } while (updatedIndex < end);
1214                 // Reentrancy protection
1215                 if (_currentIndex != startTokenId) revert();
1216             } else {
1217                 do {
1218                     emit Transfer(address(0), to, updatedIndex++);
1219                 } while (updatedIndex < end);
1220             }
1221             _currentIndex = updatedIndex;
1222         }
1223         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1224     }
1225 
1226     /**
1227      * @dev Mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _mint(address to, uint256 quantity) internal {
1237         uint256 startTokenId = _currentIndex;
1238         if (to == address(0)) revert MintToZeroAddress();
1239         if (quantity == 0) revert MintZeroQuantity();
1240 
1241         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1242 
1243         // Overflows are incredibly unrealistic.
1244         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1245         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1246         unchecked {
1247             // Updates:
1248             // - `balance += quantity`.
1249             // - `numberMinted += quantity`.
1250             //
1251             // We can directly add to the balance and number minted.
1252             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1253 
1254             // Updates:
1255             // - `address` to the owner.
1256             // - `startTimestamp` to the timestamp of minting.
1257             // - `burned` to `false`.
1258             // - `nextInitialized` to `quantity == 1`.
1259             _packedOwnerships[startTokenId] =
1260                 _addressToUint256(to) |
1261                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1262                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1263 
1264             uint256 updatedIndex = startTokenId;
1265             uint256 end = updatedIndex + quantity;
1266 
1267             do {
1268                 emit Transfer(address(0), to, updatedIndex++);
1269             } while (updatedIndex < end);
1270 
1271             _currentIndex = updatedIndex;
1272         }
1273         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1274     }
1275 
1276     /**
1277      * @dev Transfers `tokenId` from `from` to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - `to` cannot be the zero address.
1282      * - `tokenId` token must be owned by `from`.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _transfer(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) private {
1291         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1292 
1293         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1294 
1295         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1296             isApprovedForAll(from, _msgSenderERC721A()) ||
1297             getApproved(tokenId) == _msgSenderERC721A());
1298 
1299         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1300         if (to == address(0)) revert TransferToZeroAddress();
1301 
1302         _beforeTokenTransfers(from, to, tokenId, 1);
1303 
1304         // Clear approvals from the previous owner.
1305         delete _tokenApprovals[tokenId];
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1310         unchecked {
1311             // We can directly increment and decrement the balances.
1312             --_packedAddressData[from]; // Updates: `balance -= 1`.
1313             ++_packedAddressData[to]; // Updates: `balance += 1`.
1314 
1315             // Updates:
1316             // - `address` to the next owner.
1317             // - `startTimestamp` to the timestamp of transfering.
1318             // - `burned` to `false`.
1319             // - `nextInitialized` to `true`.
1320             _packedOwnerships[tokenId] =
1321                 _addressToUint256(to) |
1322                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1323                 BITMASK_NEXT_INITIALIZED;
1324 
1325             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1326             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1327                 uint256 nextTokenId = tokenId + 1;
1328                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1329                 if (_packedOwnerships[nextTokenId] == 0) {
1330                     // If the next slot is within bounds.
1331                     if (nextTokenId != _currentIndex) {
1332                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1333                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1334                     }
1335                 }
1336             }
1337         }
1338 
1339         emit Transfer(from, to, tokenId);
1340         _afterTokenTransfers(from, to, tokenId, 1);
1341     }
1342 
1343     /**
1344      * @dev Equivalent to `_burn(tokenId, false)`.
1345      */
1346     function _burn(uint256 tokenId) internal virtual {
1347         _burn(tokenId, false);
1348     }
1349 
1350     /**
1351      * @dev Destroys `tokenId`.
1352      * The approval is cleared when the token is burned.
1353      *
1354      * Requirements:
1355      *
1356      * - `tokenId` must exist.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1361         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1362 
1363         address from = address(uint160(prevOwnershipPacked));
1364 
1365         if (approvalCheck) {
1366             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1367                 isApprovedForAll(from, _msgSenderERC721A()) ||
1368                 getApproved(tokenId) == _msgSenderERC721A());
1369 
1370             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1371         }
1372 
1373         _beforeTokenTransfers(from, address(0), tokenId, 1);
1374 
1375         // Clear approvals from the previous owner.
1376         delete _tokenApprovals[tokenId];
1377 
1378         // Underflow of the sender's balance is impossible because we check for
1379         // ownership above and the recipient's balance can't realistically overflow.
1380         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1381         unchecked {
1382             // Updates:
1383             // - `balance -= 1`.
1384             // - `numberBurned += 1`.
1385             //
1386             // We can directly decrement the balance, and increment the number burned.
1387             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1388             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1389 
1390             // Updates:
1391             // - `address` to the last owner.
1392             // - `startTimestamp` to the timestamp of burning.
1393             // - `burned` to `true`.
1394             // - `nextInitialized` to `true`.
1395             _packedOwnerships[tokenId] =
1396                 _addressToUint256(from) |
1397                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1398                 BITMASK_BURNED | 
1399                 BITMASK_NEXT_INITIALIZED;
1400 
1401             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1402             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1403                 uint256 nextTokenId = tokenId + 1;
1404                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1405                 if (_packedOwnerships[nextTokenId] == 0) {
1406                     // If the next slot is within bounds.
1407                     if (nextTokenId != _currentIndex) {
1408                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1409                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1410                     }
1411                 }
1412             }
1413         }
1414 
1415         emit Transfer(from, address(0), tokenId);
1416         _afterTokenTransfers(from, address(0), tokenId, 1);
1417 
1418         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1419         unchecked {
1420             _burnCounter++;
1421         }
1422     }
1423 
1424     /**
1425      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1426      *
1427      * @param from address representing the previous owner of the given token ID
1428      * @param to target address that will receive the tokens
1429      * @param tokenId uint256 ID of the token to be transferred
1430      * @param _data bytes optional data to send along with the call
1431      * @return bool whether the call correctly returned the expected magic value
1432      */
1433     function _checkContractOnERC721Received(
1434         address from,
1435         address to,
1436         uint256 tokenId,
1437         bytes memory _data
1438     ) private returns (bool) {
1439         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1440             bytes4 retval
1441         ) {
1442             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1443         } catch (bytes memory reason) {
1444             if (reason.length == 0) {
1445                 revert TransferToNonERC721ReceiverImplementer();
1446             } else {
1447                 assembly {
1448                     revert(add(32, reason), mload(reason))
1449                 }
1450             }
1451         }
1452     }
1453 
1454     /**
1455      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1456      * And also called before burning one token.
1457      *
1458      * startTokenId - the first token id to be transferred
1459      * quantity - the amount to be transferred
1460      *
1461      * Calling conditions:
1462      *
1463      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1464      * transferred to `to`.
1465      * - When `from` is zero, `tokenId` will be minted for `to`.
1466      * - When `to` is zero, `tokenId` will be burned by `from`.
1467      * - `from` and `to` are never both zero.
1468      */
1469     function _beforeTokenTransfers(
1470         address from,
1471         address to,
1472         uint256 startTokenId,
1473         uint256 quantity
1474     ) internal virtual {}
1475 
1476     /**
1477      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1478      * minting.
1479      * And also called after one token has been burned.
1480      *
1481      * startTokenId - the first token id to be transferred
1482      * quantity - the amount to be transferred
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` has been minted for `to`.
1489      * - When `to` is zero, `tokenId` has been burned by `from`.
1490      * - `from` and `to` are never both zero.
1491      */
1492     function _afterTokenTransfers(
1493         address from,
1494         address to,
1495         uint256 startTokenId,
1496         uint256 quantity
1497     ) internal virtual {}
1498 
1499     /**
1500      * @dev Returns the message sender (defaults to `msg.sender`).
1501      *
1502      * If you are writing GSN compatible contracts, you need to override this function.
1503      */
1504     function _msgSenderERC721A() internal view virtual returns (address) {
1505         return msg.sender;
1506     }
1507 
1508     /**
1509      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1510      */
1511     function _toString(uint256 value) internal pure returns (string memory ptr) {
1512         assembly {
1513             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1514             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1515             // We will need 1 32-byte word to store the length, 
1516             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1517             ptr := add(mload(0x40), 128)
1518             // Update the free memory pointer to allocate.
1519             mstore(0x40, ptr)
1520 
1521             // Cache the end of the memory to calculate the length later.
1522             let end := ptr
1523 
1524             // We write the string from the rightmost digit to the leftmost digit.
1525             // The following is essentially a do-while loop that also handles the zero case.
1526             // Costs a bit more than early returning for the zero case,
1527             // but cheaper in terms of deployment and overall runtime costs.
1528             for { 
1529                 // Initialize and perform the first pass without check.
1530                 let temp := value
1531                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1532                 ptr := sub(ptr, 1)
1533                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1534                 mstore8(ptr, add(48, mod(temp, 10)))
1535                 temp := div(temp, 10)
1536             } temp { 
1537                 // Keep dividing `temp` until zero.
1538                 temp := div(temp, 10)
1539             } { // Body of the for loop.
1540                 ptr := sub(ptr, 1)
1541                 mstore8(ptr, add(48, mod(temp, 10)))
1542             }
1543             
1544             let length := sub(end, ptr)
1545             // Move the pointer 32 bytes leftwards to make room for the length.
1546             ptr := sub(ptr, 32)
1547             // Store the length.
1548             mstore(ptr, length)
1549         }
1550     }
1551 }
1552 
1553 // File: contracts/YummiGummi.sol
1554 
1555 // @@@@@@@@@@@@@@@@@###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###@@@@@@@@@@@@@@@@
1556 // @@@@@@@@@@#####,,,,,,,#####@@@@@@@@@@@@@@@@@@@@@@@@@@@#####,,,,,,,#####@@@@@@@@@
1557 // @@@@@@@###*,,,,,,,**,,,...####@@@@@@@@@@@@@@@@@@@@@####,..,,,**,,,,,,,(###@@@@@@
1558 // @@@@@###***,**(((((((((**,. ###@@@@@@@@@@@@@@@@@@@###,. **(((((((((**,***###@@@@
1559 // @@@@###****((((((((((((((*,,,##########(((##########,,,*((((((((((((((****###@@@
1560 // @@@###,,,*(((((((((((((((*******************************/((((((((((((((** ,###@@
1561 // @@@###,,./((((((((((((/************************************((((((((((((/*,,###@@
1562 // @@@@##,,.*((((((((((*****************************************((((((((((*..,##@@@
1563 // @@@@%##,..,*(((((***,,*************************************,,***(((((**..,##@@@@
1564 // @@@@@@###, ..*****,,,,*************************************,,,,,****.. ,###@@@@@
1565 // @@@@@@@@###,,***,,,,,***************************************,,,,,,**,,###@@@@@@@
1566 // @@@@@@@@@@###*,,,,,,*****/((,,,,,****************#(,,,, *****,,,,,,*###@@@@@@@@@
1567 // @@@@@@@@@##**,,,..,******###(((((****************##(((((******,,,,,,,*##@@@@@@@@
1568 // @@@@@@@@##/*,,,...,********/###*********,*********/###********,...,,,*###@@@@@@@
1569 // @@@@@@@@##*,,,.....,***************#((,,,,,,,,***************,,....,,,*##@@@@@@@
1570 // @@@@@@@###*,,,..    .,*************/##((((((#**************,,.   ..,,,*###@@@@@@
1571 // @@@@@@@@##*,,,...     ,*****************##****************,.     ..,,,*##@@@@@@@
1572 // @@@@@@@@##(,,,,..... ..,***********#****#(***#***********,.    ....,,,###@@@@@@@
1573 // @@@@@@@@@##*,,,,,...  ,,,***********#########************,. .....,,,,*##@@@@@@@@
1574 // @@@@@@@@@@###*,,,,,,...  *******************************,.....,,,,,*###@@@@@@@@@
1575 // @@@@@@@@@@@&###**,,,,,,,,,,****************************.  .,,,,,**###@@@@@@@@@@@
1576 // @@@@@@@@@@@@@@######**,,,,,,,***********************,,,,,,,**#####%@@@@@@@@@@@@@
1577 // @@@@@@@@@@@####/**(((#(((((((((####################(((((((##((((*(####@@@@@@@@@@
1578 // @@@@@@@####********(((((((((((((((((((((((((((((((((((((((((((/*******####@@@@@@
1579 // @@@@@###***,,,,,,***(((((((((((((((((*******(((((((((((((((((***,,,,,,***###@@@@
1580 // @@@###**,,,,  ..,,,****((((((((((((***********(((((((((((((***,,,..,,,,,,**###@@
1581 // @@##***,,,,,  ....,,,*****###(((((/***,,.   **((((((###(****,,   ...,,,,,,***##@
1582 // @##**,. ,,,,,......   ,,,***###(((***,,,,,  ***(((###***,,,........,,,,,,,,,**##
1583 // ###**, ,,,,,,,......     ,,**###((***,,,,,,,***((###**,,,.........,,,,,,,,,,**##
1584 // ###**,,,,,,,,,,,........,,,***##(((**,,,,,,,***((##***,,,.     ,,,,,,,,,,,,,**##
1585 // ###(***,,,,,,,,,,,,,,,,,,,,***##(((**,,,,,,,***((##***,,,,,,,,,,,,,,,,  .,****##
1586 // @##((*****,,,,,,,,,,,,*,,,****##((***,  ,,,,***((##****,,,,,,,,,,,,,.,,******(##
1587 // @@##(((*************,,,*****(##(((***,  ,,,,****((##((****,,,**************((##@
1588 // @@@###((((/*************((((##(((***,  ,,,,,,****((##((((/*************((((###@@
1589 // @@@@@@####((((((((((((((####(((****,  ,,,,,,,,***((((####((((((((((((((####@@@@@
1590 // @@@@@@@@@@#############((((((*****,, ,,,,,,,,,,*****((((((#############@@@@@@@@@
1591 // @@@@@@@###((((*******((((((*******,  .,,,,,,,,,*******((((((********(((###@@@@@@
1592 // @@@@@@##(***,,,,,,,,,,,****((******,,,,,,,,,,,*****/((/***,,,,,,,,,,,***###@@@@@
1593 // @@@@%##**,,..........     .***(((/***,,,,,,,***(((((**,,     ........,,,**##@@@@
1594 // @@@@##(*,,,,   .,,......     ***((((**,,,,,***((((**,,   . ..........,,,,**##@@@
1595 // @@@###(*,,,,.....,,,.........,**(##((**,,,***(##(**,,,.............,,,,,,**###@@
1596 // @@@@##(*,,,,,,,,,,,,,,,.....,,,*(##((**,,,**((##/**,,.,,,,,,,,,,,,,,,,,,,*(##@@@
1597 // @@@@%##(*,*,,,,,,,,,,,,,,,...,**##((((((*/(((((##**,,,,,,,,,,,,,,,,, ,*,*(##@@@@
1598 // @@@@@@##((******,,,,,,,,,,,,**###(((((((((((((((###**,,,,,,,,,,,,*******(##@@@@@
1599 // @@@@@@@###((***********,***(###((###############((###(***,***********(####@@@@@@
1600 // @@@@@@@@@@######((((((###########@@@@@@@@@@@@@@@###########((((((######@@@@@@@@@
1601 
1602 
1603 pragma solidity ^0.8.7;
1604 
1605 
1606 
1607 
1608 
1609 
1610 contract YummiGummiContract is ERC721A, Ownable, ReentrancyGuard {
1611     using SafeMath for uint256;
1612     using Strings for uint256;
1613 
1614     uint256 public constant maxTokens = 4888;
1615     uint256 public maxMintPerTx = 10;
1616     uint256 public maxMintAmountPerWallet = 10;
1617 
1618     bool public isRevealed = false;
1619     bool public isPaused = true;
1620 
1621     string public baseURI = "";
1622     string public prerevealBaseURI = "ipfs://bafybeiegnxn7p45gbexxxo7w2wurvzhmi5bzmj7hdtzagn6ggytnahn7iy/";
1623     string public uriSuffix = ".json";
1624 
1625     mapping(address => uint256) private mintedWallets;
1626 
1627     constructor() ERC721A("Yummi Gummi", "GUMMI") {}
1628 
1629     // SETTERS
1630     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1631         baseURI = _newBaseURI;
1632     }
1633 
1634     function setPrerevealBaseURI(string memory _newBaseURI) external onlyOwner {
1635         prerevealBaseURI = _newBaseURI;
1636     }
1637 
1638     function setUriSuffix(string memory _uriSuffix) external onlyOwner {
1639         uriSuffix = _uriSuffix;
1640     }
1641 
1642     function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) external onlyOwner {
1643         maxMintAmountPerWallet = _maxMintAmountPerWallet;
1644     }
1645 
1646     function setMaxMintPerTx(uint256 _maxMintPerTx) external onlyOwner {
1647         maxMintPerTx = _maxMintPerTx;
1648     }
1649 
1650     // TOGGLE
1651     function togglePaused() external onlyOwner {
1652         isPaused = !isPaused;
1653     }
1654 
1655     function toggleReveal() external onlyOwner {
1656         isRevealed = !isRevealed;
1657     }
1658 
1659     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1660         require(
1661             _exists(_tokenId),
1662             "ERC721Metadata: URI query for nonexistent token"
1663         );
1664 
1665         if (isRevealed) {
1666             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(_tokenId), uriSuffix)) : '';
1667         } else {
1668             return string(
1669                 abi.encodePacked(prerevealBaseURI, _tokenId.toString(), uriSuffix)
1670             );
1671         }
1672     }
1673 
1674     function mint(uint256 _tokens) external payable {
1675         require(_tokens > 0, "Must mint at least one token");
1676         require(!isPaused, "The contract is paused!");
1677         require(_tokens <= maxMintPerTx, "Cannot purchase this many tokens in a transaction");
1678         require(totalSupply() + _tokens <= maxTokens, "Minting would exceed max supply");
1679         require(mintedWallets[_msgSender()] + _tokens <= maxMintAmountPerWallet, "Cannot purchase this many tokens, you will/have exceeded max allowed tokens");
1680 
1681         mintedWallets[_msgSender()] = mintedWallets[_msgSender()] + _tokens;
1682 
1683         _safeMint(_msgSender(), _tokens);
1684     }
1685 
1686     function ownerMint(address _owner, uint256 _tokens) external onlyOwner {
1687 	    require(totalSupply() + _tokens <= maxTokens, "Minting would exceed max supply");
1688         require(_tokens > 0, "Must mint at least one token");
1689         _safeMint(_owner, _tokens);
1690     }
1691 
1692     function withdraw() external onlyOwner nonReentrant {
1693         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1694         require(success, "Transfer failed.");
1695     }
1696 }