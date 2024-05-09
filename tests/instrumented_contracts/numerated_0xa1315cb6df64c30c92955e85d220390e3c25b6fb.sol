1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and making it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 // ERC721A Contracts v3.3.0
91 // Creator: Chiru Labs
92 
93 pragma solidity ^0.8.4;
94 
95 /**
96  * @dev Interface of an ERC721A compliant contract.
97  */
98 interface IERC721A {
99     /**
100      * The caller must own the token or be an approved operator.
101      */
102     error ApprovalCallerNotOwnerNorApproved();
103 
104     /**
105      * The token does not exist.
106      */
107     error ApprovalQueryForNonexistentToken();
108 
109     /**
110      * The caller cannot approve to their own address.
111      */
112     error ApproveToCaller();
113 
114     /**
115      * The caller cannot approve to the current owner.
116      */
117     error ApprovalToCurrentOwner();
118 
119     /**
120      * Cannot query the balance for the zero address.
121      */
122     error BalanceQueryForZeroAddress();
123 
124     /**
125      * Cannot mint to the zero address.
126      */
127     error MintToZeroAddress();
128 
129     /**
130      * The quantity of tokens minted must be more than zero.
131      */
132     error MintZeroQuantity();
133 
134     /**
135      * The token does not exist.
136      */
137     error OwnerQueryForNonexistentToken();
138 
139     /**
140      * The caller must own the token or be an approved operator.
141      */
142     error TransferCallerNotOwnerNorApproved();
143 
144     /**
145      * The token must be owned by `from`.
146      */
147     error TransferFromIncorrectOwner();
148 
149     /**
150      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
151      */
152     error TransferToNonERC721ReceiverImplementer();
153 
154     /**
155      * Cannot transfer to the zero address.
156      */
157     error TransferToZeroAddress();
158 
159     /**
160      * The token does not exist.
161      */
162     error URIQueryForNonexistentToken();
163 
164     struct TokenOwnership {
165         // The address of the owner.
166         address addr;
167         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
168         uint64 startTimestamp;
169         // Whether the token has been burned.
170         bool burned;
171     }
172 
173     /**
174      * @dev Returns the total amount of tokens stored by the contract.
175      *
176      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
177      */
178     function totalSupply() external view returns (uint256);
179 
180     // ==============================
181     //            IERC165
182     // ==============================
183 
184     /**
185      * @dev Returns true if this contract implements the interface defined by
186      * `interfaceId`. See the corresponding
187      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
188      * to learn more about how these ids are created.
189      *
190      * This function call must use less than 30 000 gas.
191      */
192     function supportsInterface(bytes4 interfaceId) external view returns (bool);
193 
194     // ==============================
195     //            IERC721
196     // ==============================
197 
198     /**
199      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
202 
203     /**
204      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
205      */
206     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
210      */
211     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
212 
213     /**
214      * @dev Returns the number of tokens in ``owner``'s account.
215      */
216     function balanceOf(address owner) external view returns (uint256 balance);
217 
218     /**
219      * @dev Returns the owner of the `tokenId` token.
220      *
221      * Requirements:
222      *
223      * - `tokenId` must exist.
224      */
225     function ownerOf(uint256 tokenId) external view returns (address owner);
226 
227     /**
228      * @dev Safely transfers `tokenId` token from `from` to `to`.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
237      *
238      * Emits a {Transfer} event.
239      */
240     function safeTransferFrom(
241         address from,
242         address to,
243         uint256 tokenId,
244         bytes calldata data
245     ) external;
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
249      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external;
266 
267     /**
268      * @dev Transfers `tokenId` token from `from` to `to`.
269      *
270      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
292      *
293      * Requirements:
294      *
295      * - The caller must own the token or be an approved operator.
296      * - `tokenId` must exist.
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address to, uint256 tokenId) external;
301 
302     /**
303      * @dev Approve or remove `operator` as an operator for the caller.
304      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
305      *
306      * Requirements:
307      *
308      * - The `operator` cannot be the caller.
309      *
310      * Emits an {ApprovalForAll} event.
311      */
312     function setApprovalForAll(address operator, bool _approved) external;
313 
314     /**
315      * @dev Returns the account approved for `tokenId` token.
316      *
317      * Requirements:
318      *
319      * - `tokenId` must exist.
320      */
321     function getApproved(uint256 tokenId) external view returns (address operator);
322 
323     /**
324      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
325      *
326      * See {setApprovalForAll}
327      */
328     function isApprovedForAll(address owner, address operator) external view returns (bool);
329 
330     // ==============================
331     //        IERC721Metadata
332     // ==============================
333 
334     /**
335      * @dev Returns the token collection name.
336      */
337     function name() external view returns (string memory);
338 
339     /**
340      * @dev Returns the token collection symbol.
341      */
342     function symbol() external view returns (string memory);
343 
344     /**
345      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
346      */
347     function tokenURI(uint256 tokenId) external view returns (string memory);
348 }
349 
350 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 // CAUTION
355 // This version of SafeMath should only be used with Solidity 0.8 or later,
356 // because it relies on the compiler's built in overflow checks.
357 
358 /**
359  * @dev Wrappers over Solidity's arithmetic operations.
360  *
361  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
362  * now has built in overflow checking.
363  */
364 library SafeMath {
365     /**
366      * @dev Returns the addition of two unsigned integers, with an overflow flag.
367      *
368      * _Available since v3.4._
369      */
370     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
371         unchecked {
372             uint256 c = a + b;
373             if (c < a) return (false, 0);
374             return (true, c);
375         }
376     }
377 
378     /**
379      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
380      *
381      * _Available since v3.4._
382      */
383     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         unchecked {
385             if (b > a) return (false, 0);
386             return (true, a - b);
387         }
388     }
389 
390     /**
391      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         unchecked {
397             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
398             // benefit is lost if 'b' is also tested.
399             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
400             if (a == 0) return (true, 0);
401             uint256 c = a * b;
402             if (c / a != b) return (false, 0);
403             return (true, c);
404         }
405     }
406 
407     /**
408      * @dev Returns the division of two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         unchecked {
414             if (b == 0) return (false, 0);
415             return (true, a / b);
416         }
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
421      *
422      * _Available since v3.4._
423      */
424     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
425         unchecked {
426             if (b == 0) return (false, 0);
427             return (true, a % b);
428         }
429     }
430 
431     /**
432      * @dev Returns the addition of two unsigned integers, reverting on
433      * overflow.
434      *
435      * Counterpart to Solidity's `+` operator.
436      *
437      * Requirements:
438      *
439      * - Addition cannot overflow.
440      */
441     function add(uint256 a, uint256 b) internal pure returns (uint256) {
442         return a + b;
443     }
444 
445     /**
446      * @dev Returns the subtraction of two unsigned integers, reverting on
447      * overflow (when the result is negative).
448      *
449      * Counterpart to Solidity's `-` operator.
450      *
451      * Requirements:
452      *
453      * - Subtraction cannot overflow.
454      */
455     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
456         return a - b;
457     }
458 
459     /**
460      * @dev Returns the multiplication of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `*` operator.
464      *
465      * Requirements:
466      *
467      * - Multiplication cannot overflow.
468      */
469     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a * b;
471     }
472 
473     /**
474      * @dev Returns the integer division of two unsigned integers, reverting on
475      * division by zero. The result is rounded towards zero.
476      *
477      * Counterpart to Solidity's `/` operator.
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         return a / b;
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
489      * reverting when dividing by zero.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
500         return a % b;
501     }
502 
503     /**
504      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
505      * overflow (when the result is negative).
506      *
507      * CAUTION: This function is deprecated because it requires allocating memory for the error
508      * message unnecessarily. For custom revert reasons use {trySub}.
509      *
510      * Counterpart to Solidity's `-` operator.
511      *
512      * Requirements:
513      *
514      * - Subtraction cannot overflow.
515      */
516     function sub(
517         uint256 a,
518         uint256 b,
519         string memory errorMessage
520     ) internal pure returns (uint256) {
521         unchecked {
522             require(b <= a, errorMessage);
523             return a - b;
524         }
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
529      * division by zero. The result is rounded towards zero.
530      *
531      * Counterpart to Solidity's `/` operator. Note: this function uses a
532      * `revert` opcode (which leaves remaining gas untouched) while Solidity
533      * uses an invalid opcode to revert (consuming all remaining gas).
534      *
535      * Requirements:
536      *
537      * - The divisor cannot be zero.
538      */
539     function div(
540         uint256 a,
541         uint256 b,
542         string memory errorMessage
543     ) internal pure returns (uint256) {
544         unchecked {
545             require(b > 0, errorMessage);
546             return a / b;
547         }
548     }
549 
550     /**
551      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
552      * reverting with custom message when dividing by zero.
553      *
554      * CAUTION: This function is deprecated because it requires allocating memory for the error
555      * message unnecessarily. For custom revert reasons use {tryMod}.
556      *
557      * Counterpart to Solidity's `%` operator. This function uses a `revert`
558      * opcode (which leaves remaining gas untouched) while Solidity uses an
559      * invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function mod(
566         uint256 a,
567         uint256 b,
568         string memory errorMessage
569     ) internal pure returns (uint256) {
570         unchecked {
571             require(b > 0, errorMessage);
572             return a % b;
573         }
574     }
575 }
576 
577 pragma solidity ^0.8.6;
578 
579 library Address {
580     function isContract(address account) internal view returns (bool) {
581         uint size;
582         assembly {
583             size := extcodesize(account)
584         }
585         return size > 0;
586     }
587 }
588 
589 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev String operations.
595  */
596 library Strings {
597     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
598 
599     /**
600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
601      */
602     function toString(uint256 value) internal pure returns (string memory) {
603         // Inspired by OraclizeAPI's implementation - MIT licence
604         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
605 
606         if (value == 0) {
607             return "0";
608         }
609         uint256 temp = value;
610         uint256 digits;
611         while (temp != 0) {
612             digits++;
613             temp /= 10;
614         }
615         bytes memory buffer = new bytes(digits);
616         while (value != 0) {
617             digits -= 1;
618             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
619             value /= 10;
620         }
621         return string(buffer);
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
626      */
627     function toHexString(uint256 value) internal pure returns (string memory) {
628         if (value == 0) {
629             return "0x00";
630         }
631         uint256 temp = value;
632         uint256 length = 0;
633         while (temp != 0) {
634             length++;
635             temp >>= 8;
636         }
637         return toHexString(value, length);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
642      */
643     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
644         bytes memory buffer = new bytes(2 * length + 2);
645         buffer[0] = "0";
646         buffer[1] = "x";
647         for (uint256 i = 2 * length + 1; i > 1; --i) {
648             buffer[i] = _HEX_SYMBOLS[value & 0xf];
649             value >>= 4;
650         }
651         require(value == 0, "Strings: hex length insufficient");
652         return string(buffer);
653     }
654 }
655 
656 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Contract module which provides a basic access control mechanism, where
662  * there is an account (an owner) that can be granted exclusive access to
663  * specific functions.
664  *
665  * By default, the owner account will be the one that deploys the contract. This
666  * can later be changed with {transferOwnership}.
667  *
668  * This module is used through inheritance. It will make available the modifier
669  * `onlyOwner`, which can be applied to your functions to restrict their use to
670  * the owner.
671  */
672 abstract contract Ownable is Context {
673     address private _owner;
674 
675     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
676 
677     /**
678      * @dev Initializes the contract setting the deployer as the initial owner.
679      */
680     constructor() {
681         _transferOwnership(_msgSender());
682     }
683 
684     /**
685      * @dev Returns the address of the current owner.
686      */
687     function owner() public view virtual returns (address) {
688         return _owner;
689     }
690 
691     /**
692      * @dev Throws if called by any account other than the owner.
693      */
694     modifier onlyOwner() {
695         require(owner() == _msgSender(), "Ownable: caller is not the owner");
696         _;
697     }
698 
699     /**
700      * @dev Leaves the contract without owner. It will not be possible to call
701      * `onlyOwner` functions anymore. Can only be called by the current owner.
702      *
703      * NOTE: Renouncing ownership will leave the contract without an owner,
704      * thereby removing any functionality that is only available to the owner.
705      */
706     function renounceOwnership() public virtual onlyOwner {
707         _transferOwnership(address(0));
708     }
709 
710     /**
711      * @dev Transfers ownership of the contract to a new account (`newOwner`).
712      * Can only be called by the current owner.
713      */
714     function transferOwnership(address newOwner) public virtual onlyOwner {
715         require(newOwner != address(0), "Ownable: new owner is the zero address");
716         _transferOwnership(newOwner);
717     }
718 
719     /**
720      * @dev Transfers ownership of the contract to a new account (`newOwner`).
721      * Internal function without access restriction.
722      */
723     function _transferOwnership(address newOwner) internal virtual {
724         address oldOwner = _owner;
725         _owner = newOwner;
726         emit OwnershipTransferred(oldOwner, newOwner);
727     }
728 }
729 
730 // ERC721A Contracts v3.3.0
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 /**
736  * @dev ERC721 token receiver interface.
737  */
738 interface ERC721A__IERC721Receiver {
739     function onERC721Received(
740         address operator,
741         address from,
742         uint256 tokenId,
743         bytes calldata data
744     ) external returns (bytes4);
745 }
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
752  *
753  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
754  *
755  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
756  */
757 contract ERC721A is IERC721A {
758     // Mask of an entry in packed address data.
759     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
760 
761     // The bit position of `numberMinted` in packed address data.
762     uint256 private constant BITPOS_NUMBER_MINTED = 64;
763 
764     // The bit position of `numberBurned` in packed address data.
765     uint256 private constant BITPOS_NUMBER_BURNED = 128;
766 
767     // The bit position of `aux` in packed address data.
768     uint256 private constant BITPOS_AUX = 192;
769 
770     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
771     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
772 
773     // The bit position of `startTimestamp` in packed ownership.
774     uint256 private constant BITPOS_START_TIMESTAMP = 160;
775 
776     // The bit mask of the `burned` bit in packed ownership.
777     uint256 private constant BITMASK_BURNED = 1 << 224;
778     
779     // The bit position of the `nextInitialized` bit in packed ownership.
780     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
781 
782     // The bit mask of the `nextInitialized` bit in packed ownership.
783     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
784 
785     // The tokenId of the next token to be minted.
786     uint256 private _currentIndex;
787 
788     // The number of tokens burned.
789     uint256 private _burnCounter;
790 
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Mapping from token ID to ownership details
798     // An empty struct value does not necessarily mean the token is unowned.
799     // See `_packedOwnershipOf` implementation for details.
800     //
801     // Bits Layout:
802     // - [0..159]   `addr`
803     // - [160..223] `startTimestamp`
804     // - [224]      `burned`
805     // - [225]      `nextInitialized`
806     mapping(uint256 => uint256) private _packedOwnerships;
807 
808     // Mapping owner address to address data.
809     //
810     // Bits Layout:
811     // - [0..63]    `balance`
812     // - [64..127]  `numberMinted`
813     // - [128..191] `numberBurned`
814     // - [192..255] `aux`
815     mapping(address => uint256) private _packedAddressData;
816 
817     // Mapping from token ID to approved address.
818     mapping(uint256 => address) private _tokenApprovals;
819 
820     // Mapping from owner to operator approvals
821     mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826         _currentIndex = _startTokenId();
827     }
828 
829     /**
830      * @dev Returns the starting token ID. 
831      * To change the starting token ID, please override this function.
832      */
833     function _startTokenId() internal view virtual returns (uint256) {
834         return 0;
835     }
836 
837     /**
838      * @dev Returns the next token ID to be minted.
839      */
840     function _nextTokenId() internal view returns (uint256) {
841         return _currentIndex;
842     }
843 
844     /**
845      * @dev Returns the total number of tokens in existence.
846      * Burned tokens will reduce the count. 
847      * To get the total number of tokens minted, please see `_totalMinted`.
848      */
849     function totalSupply() public view override returns (uint256) {
850         // Counter underflow is impossible as _burnCounter cannot be incremented
851         // more than `_currentIndex - _startTokenId()` times.
852         unchecked {
853             return _currentIndex - _burnCounter - _startTokenId();
854         }
855     }
856 
857     /**
858      * @dev Returns the total amount of tokens minted in the contract.
859      */
860     function _totalMinted() internal view returns (uint256) {
861         // Counter underflow is impossible as _currentIndex does not decrement,
862         // and it is initialized to `_startTokenId()`
863         unchecked {
864             return _currentIndex - _startTokenId();
865         }
866     }
867 
868     /**
869      * @dev Returns the total number of tokens burned.
870      */
871     function _totalBurned() internal view returns (uint256) {
872         return _burnCounter;
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879         // The interface IDs are constants representing the first 4 bytes of the XOR of
880         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
881         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
882         return
883             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
884             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
885             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
886     }
887 
888     /**
889      * @dev See {IERC721-balanceOf}.
890      */
891     function balanceOf(address owner) public view override returns (uint256) {
892         if (owner == address(0)) revert BalanceQueryForZeroAddress();
893         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
894     }
895 
896     /**
897      * Returns the number of tokens minted by `owner`.
898      */
899     function _numberMinted(address owner) internal view returns (uint256) {
900         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
901     }
902 
903     /**
904      * Returns the number of tokens burned by or on behalf of `owner`.
905      */
906     function _numberBurned(address owner) internal view returns (uint256) {
907         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
908     }
909 
910     /**
911      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
912      */
913     function _getAux(address owner) internal view returns (uint64) {
914         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
915     }
916 
917     /**
918      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
919      * If there are multiple variables, please pack them into a uint64.
920      */
921     function _setAux(address owner, uint64 aux) internal {
922         uint256 packed = _packedAddressData[owner];
923         uint256 auxCasted;
924         assembly { // Cast aux without masking.
925             auxCasted := aux
926         }
927         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
928         _packedAddressData[owner] = packed;
929     }
930 
931     /**
932      * Returns the packed ownership data of `tokenId`.
933      */
934     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
935         uint256 curr = tokenId;
936 
937         unchecked {
938             if (_startTokenId() <= curr)
939                 if (curr < _currentIndex) {
940                     uint256 packed = _packedOwnerships[curr];
941                     // If not burned.
942                     if (packed & BITMASK_BURNED == 0) {
943                         // Invariant:
944                         // There will always be an ownership that has an address and is not burned
945                         // before an ownership that does not have an address and is not burned.
946                         // Hence, curr will not underflow.
947                         //
948                         // We can directly compare the packed value.
949                         // If the address is zero, packed is zero.
950                         while (packed == 0) {
951                             packed = _packedOwnerships[--curr];
952                         }
953                         return packed;
954                     }
955                 }
956         }
957         revert OwnerQueryForNonexistentToken();
958     }
959 
960     /**
961      * Returns the unpacked `TokenOwnership` struct from `packed`.
962      */
963     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
964         ownership.addr = address(uint160(packed));
965         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
966         ownership.burned = packed & BITMASK_BURNED != 0;
967     }
968 
969     /**
970      * Returns the unpacked `TokenOwnership` struct at `index`.
971      */
972     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
973         return _unpackedOwnership(_packedOwnerships[index]);
974     }
975 
976     /**
977      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
978      */
979     function _initializeOwnershipAt(uint256 index) internal {
980         if (_packedOwnerships[index] == 0) {
981             _packedOwnerships[index] = _packedOwnershipOf(index);
982         }
983     }
984 
985     /**
986      * Gas spent here starts off proportional to the maximum mint batch size.
987      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
988      */
989     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
990         return _unpackedOwnership(_packedOwnershipOf(tokenId));
991     }
992 
993     /**
994      * @dev See {IERC721-ownerOf}.
995      */
996     function ownerOf(uint256 tokenId) public view override returns (address) {
997         return address(uint160(_packedOwnershipOf(tokenId)));
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-name}.
1002      */
1003     function name() public view virtual override returns (string memory) {
1004         return _name;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-symbol}.
1009      */
1010     function symbol() public view virtual override returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1018         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1019 
1020         string memory baseURI = _baseURI();
1021         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1022     }
1023 
1024     /**
1025      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1026      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1027      * by default, can be overriden in child contracts.
1028      */
1029     function _baseURI() internal view virtual returns (string memory) {
1030         return '';
1031     }
1032 
1033     /**
1034      * @dev Casts the address to uint256 without masking.
1035      */
1036     function _addressToUint256(address value) private pure returns (uint256 result) {
1037         assembly {
1038             result := value
1039         }
1040     }
1041 
1042     /**
1043      * @dev Casts the boolean to uint256 without branching.
1044      */
1045     function _boolToUint256(bool value) private pure returns (uint256 result) {
1046         assembly {
1047             result := value
1048         }
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-approve}.
1053      */
1054     function approve(address to, uint256 tokenId) public override {
1055         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1056         if (to == owner) revert ApprovalToCurrentOwner();
1057 
1058         if (_msgSenderERC721A() != owner)
1059             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1060                 revert ApprovalCallerNotOwnerNorApproved();
1061             }
1062 
1063         _tokenApprovals[tokenId] = to;
1064         emit Approval(owner, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-getApproved}.
1069      */
1070     function getApproved(uint256 tokenId) public view override returns (address) {
1071         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1072 
1073         return _tokenApprovals[tokenId];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-setApprovalForAll}.
1078      */
1079     function setApprovalForAll(address operator, bool approved) public virtual override {
1080         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1081 
1082         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1083         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1090         return _operatorApprovals[owner][operator];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-transferFrom}.
1095      */
1096     function transferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         _transfer(from, to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-safeTransferFrom}.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         safeTransferFrom(from, to, tokenId, '');
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-safeTransferFrom}.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) public virtual override {
1124         _transfer(from, to, tokenId);
1125         if (to.code.length != 0)
1126             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1127                 revert TransferToNonERC721ReceiverImplementer();
1128             }
1129     }
1130 
1131     /**
1132      * @dev Returns whether `tokenId` exists.
1133      *
1134      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1135      *
1136      * Tokens start existing when they are minted (`_mint`),
1137      */
1138     function _exists(uint256 tokenId) internal view returns (bool) {
1139         return
1140             _startTokenId() <= tokenId &&
1141             tokenId < _currentIndex && // If within bounds,
1142             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1143     }
1144 
1145     /**
1146      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1147      */
1148     function _safeMint(address to, uint256 quantity) internal {
1149         _safeMint(to, quantity, '');
1150     }
1151 
1152     /**
1153      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - If `to` refers to a smart contract, it must implement
1158      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1159      * - `quantity` must be greater than 0.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _safeMint(
1164         address to,
1165         uint256 quantity,
1166         bytes memory _data
1167     ) internal {
1168         uint256 startTokenId = _currentIndex;
1169         if (to == address(0)) revert MintToZeroAddress();
1170         if (quantity == 0) revert MintZeroQuantity();
1171 
1172         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1173 
1174         // Overflows are incredibly unrealistic.
1175         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1176         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1177         unchecked {
1178             // Updates:
1179             // - `balance += quantity`.
1180             // - `numberMinted += quantity`.
1181             //
1182             // We can directly add to the balance and number minted.
1183             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1184 
1185             // Updates:
1186             // - `address` to the owner.
1187             // - `startTimestamp` to the timestamp of minting.
1188             // - `burned` to `false`.
1189             // - `nextInitialized` to `quantity == 1`.
1190             _packedOwnerships[startTokenId] =
1191                 _addressToUint256(to) |
1192                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1193                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1194 
1195             uint256 updatedIndex = startTokenId;
1196             uint256 end = updatedIndex + quantity;
1197 
1198             if (to.code.length != 0) {
1199                 do {
1200                     emit Transfer(address(0), to, updatedIndex);
1201                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1202                         revert TransferToNonERC721ReceiverImplementer();
1203                     }
1204                 } while (updatedIndex < end);
1205                 // Reentrancy protection
1206                 if (_currentIndex != startTokenId) revert();
1207             } else {
1208                 do {
1209                     emit Transfer(address(0), to, updatedIndex++);
1210                 } while (updatedIndex < end);
1211             }
1212             _currentIndex = updatedIndex;
1213         }
1214         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1215     }
1216 
1217     /**
1218      * @dev Mints `quantity` tokens and transfers them to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `quantity` must be greater than 0.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _mint(address to, uint256 quantity) internal {
1228         uint256 startTokenId = _currentIndex;
1229         if (to == address(0)) revert MintToZeroAddress();
1230         if (quantity == 0) revert MintZeroQuantity();
1231 
1232         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234         // Overflows are incredibly unrealistic.
1235         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1236         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1237         unchecked {
1238             // Updates:
1239             // - `balance += quantity`.
1240             // - `numberMinted += quantity`.
1241             //
1242             // We can directly add to the balance and number minted.
1243             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1244 
1245             // Updates:
1246             // - `address` to the owner.
1247             // - `startTimestamp` to the timestamp of minting.
1248             // - `burned` to `false`.
1249             // - `nextInitialized` to `quantity == 1`.
1250             _packedOwnerships[startTokenId] =
1251                 _addressToUint256(to) |
1252                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1253                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1254 
1255             uint256 updatedIndex = startTokenId;
1256             uint256 end = updatedIndex + quantity;
1257 
1258             do {
1259                 emit Transfer(address(0), to, updatedIndex++);
1260             } while (updatedIndex < end);
1261 
1262             _currentIndex = updatedIndex;
1263         }
1264         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1265     }
1266 
1267     /**
1268      * @dev Transfers `tokenId` from `from` to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - `to` cannot be the zero address.
1273      * - `tokenId` token must be owned by `from`.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _transfer(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) private {
1282         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1283 
1284         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1285 
1286         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1287             isApprovedForAll(from, _msgSenderERC721A()) ||
1288             getApproved(tokenId) == _msgSenderERC721A());
1289 
1290         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1291         if (to == address(0)) revert TransferToZeroAddress();
1292 
1293         _beforeTokenTransfers(from, to, tokenId, 1);
1294 
1295         // Clear approvals from the previous owner.
1296         delete _tokenApprovals[tokenId];
1297 
1298         // Underflow of the sender's balance is impossible because we check for
1299         // ownership above and the recipient's balance can't realistically overflow.
1300         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1301         unchecked {
1302             // We can directly increment and decrement the balances.
1303             --_packedAddressData[from]; // Updates: `balance -= 1`.
1304             ++_packedAddressData[to]; // Updates: `balance += 1`.
1305 
1306             // Updates:
1307             // - `address` to the next owner.
1308             // - `startTimestamp` to the timestamp of transfering.
1309             // - `burned` to `false`.
1310             // - `nextInitialized` to `true`.
1311             _packedOwnerships[tokenId] =
1312                 _addressToUint256(to) |
1313                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1314                 BITMASK_NEXT_INITIALIZED;
1315 
1316             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1317             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1318                 uint256 nextTokenId = tokenId + 1;
1319                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1320                 if (_packedOwnerships[nextTokenId] == 0) {
1321                     // If the next slot is within bounds.
1322                     if (nextTokenId != _currentIndex) {
1323                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1324                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1325                     }
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(from, to, tokenId);
1331         _afterTokenTransfers(from, to, tokenId, 1);
1332     }
1333 
1334     /**
1335      * @dev Equivalent to `_burn(tokenId, false)`.
1336      */
1337     function _burn(uint256 tokenId) internal virtual {
1338         _burn(tokenId, false);
1339     }
1340 
1341     /**
1342      * @dev Destroys `tokenId`.
1343      * The approval is cleared when the token is burned.
1344      *
1345      * Requirements:
1346      *
1347      * - `tokenId` must exist.
1348      *
1349      * Emits a {Transfer} event.
1350      */
1351     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1352         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1353 
1354         address from = address(uint160(prevOwnershipPacked));
1355 
1356         if (approvalCheck) {
1357             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1358                 isApprovedForAll(from, _msgSenderERC721A()) ||
1359                 getApproved(tokenId) == _msgSenderERC721A());
1360 
1361             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1362         }
1363 
1364         _beforeTokenTransfers(from, address(0), tokenId, 1);
1365 
1366         // Clear approvals from the previous owner.
1367         delete _tokenApprovals[tokenId];
1368 
1369         // Underflow of the sender's balance is impossible because we check for
1370         // ownership above and the recipient's balance can't realistically overflow.
1371         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1372         unchecked {
1373             // Updates:
1374             // - `balance -= 1`.
1375             // - `numberBurned += 1`.
1376             //
1377             // We can directly decrement the balance, and increment the number burned.
1378             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1379             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1380 
1381             // Updates:
1382             // - `address` to the last owner.
1383             // - `startTimestamp` to the timestamp of burning.
1384             // - `burned` to `true`.
1385             // - `nextInitialized` to `true`.
1386             _packedOwnerships[tokenId] =
1387                 _addressToUint256(from) |
1388                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1389                 BITMASK_BURNED | 
1390                 BITMASK_NEXT_INITIALIZED;
1391 
1392             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1393             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1394                 uint256 nextTokenId = tokenId + 1;
1395                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1396                 if (_packedOwnerships[nextTokenId] == 0) {
1397                     // If the next slot is within bounds.
1398                     if (nextTokenId != _currentIndex) {
1399                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1400                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1401                     }
1402                 }
1403             }
1404         }
1405 
1406         emit Transfer(from, address(0), tokenId);
1407         _afterTokenTransfers(from, address(0), tokenId, 1);
1408 
1409         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1410         unchecked {
1411             _burnCounter++;
1412         }
1413     }
1414 
1415     /**
1416      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1417      *
1418      * @param from address representing the previous owner of the given token ID
1419      * @param to target address that will receive the tokens
1420      * @param tokenId uint256 ID of the token to be transferred
1421      * @param _data bytes optional data to send along with the call
1422      * @return bool whether the call correctly returned the expected magic value
1423      */
1424     function _checkContractOnERC721Received(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) private returns (bool) {
1430         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1431             bytes4 retval
1432         ) {
1433             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1434         } catch (bytes memory reason) {
1435             if (reason.length == 0) {
1436                 revert TransferToNonERC721ReceiverImplementer();
1437             } else {
1438                 assembly {
1439                     revert(add(32, reason), mload(reason))
1440                 }
1441             }
1442         }
1443     }
1444 
1445     /**
1446      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1447      * And also called before burning one token.
1448      *
1449      * startTokenId - the first token id to be transferred
1450      * quantity - the amount to be transferred
1451      *
1452      * Calling conditions:
1453      *
1454      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1455      * transferred to `to`.
1456      * - When `from` is zero, `tokenId` will be minted for `to`.
1457      * - When `to` is zero, `tokenId` will be burned by `from`.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _beforeTokenTransfers(
1461         address from,
1462         address to,
1463         uint256 startTokenId,
1464         uint256 quantity
1465     ) internal virtual {}
1466 
1467     /**
1468      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1469      * minting.
1470      * And also called after one token has been burned.
1471      *
1472      * startTokenId - the first token id to be transferred
1473      * quantity - the amount to be transferred
1474      *
1475      * Calling conditions:
1476      *
1477      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1478      * transferred to `to`.
1479      * - When `from` is zero, `tokenId` has been minted for `to`.
1480      * - When `to` is zero, `tokenId` has been burned by `from`.
1481      * - `from` and `to` are never both zero.
1482      */
1483     function _afterTokenTransfers(
1484         address from,
1485         address to,
1486         uint256 startTokenId,
1487         uint256 quantity
1488     ) internal virtual {}
1489 
1490     /**
1491      * @dev Returns the message sender (defaults to `msg.sender`).
1492      *
1493      * If you are writing GSN compatible contracts, you need to override this function.
1494      */
1495     function _msgSenderERC721A() internal view virtual returns (address) {
1496         return msg.sender;
1497     }
1498 
1499     /**
1500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1501      */
1502     function _toString(uint256 value) internal pure returns (string memory ptr) {
1503         assembly {
1504             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1505             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1506             // We will need 1 32-byte word to store the length, 
1507             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1508             ptr := add(mload(0x40), 128)
1509             // Update the free memory pointer to allocate.
1510             mstore(0x40, ptr)
1511 
1512             // Cache the end of the memory to calculate the length later.
1513             let end := ptr
1514 
1515             // We write the string from the rightmost digit to the leftmost digit.
1516             // The following is essentially a do-while loop that also handles the zero case.
1517             // Costs a bit more than early returning for the zero case,
1518             // but cheaper in terms of deployment and overall runtime costs.
1519             for { 
1520                 // Initialize and perform the first pass without check.
1521                 let temp := value
1522                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1523                 ptr := sub(ptr, 1)
1524                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1525                 mstore8(ptr, add(48, mod(temp, 10)))
1526                 temp := div(temp, 10)
1527             } temp { 
1528                 // Keep dividing `temp` until zero.
1529                 temp := div(temp, 10)
1530             } { // Body of the for loop.
1531                 ptr := sub(ptr, 1)
1532                 mstore8(ptr, add(48, mod(temp, 10)))
1533             }
1534             
1535             let length := sub(end, ptr)
1536             // Move the pointer 32 bytes leftwards to make room for the length.
1537             ptr := sub(ptr, 32)
1538             // Store the length.
1539             mstore(ptr, length)
1540         }
1541     }
1542 }
1543 
1544 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 /**
1549  * @dev These functions deal with verification of Merkle Trees proofs.
1550  *
1551  * The proofs can be generated using the JavaScript library
1552  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1553  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1554  *
1555  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1556  */
1557 library MerkleProof {
1558     /**
1559      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1560      * defined by `root`. For this, a `proof` must be provided, containing
1561      * sibling hashes on the branch from the leaf to the root of the tree. Each
1562      * pair of leaves and each pair of pre-images are assumed to be sorted.
1563      */
1564     function verify(
1565         bytes32[] memory proof,
1566         bytes32 root,
1567         bytes32 leaf
1568     ) internal pure returns (bool) {
1569         return processProof(proof, leaf) == root;
1570     }
1571 
1572     /**
1573      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1574      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1575      * hash matches the root of the tree. When processing the proof, the pairs
1576      * of leafs & pre-images are assumed to be sorted.
1577      *
1578      * _Available since v4.4._
1579      */
1580     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1581         bytes32 computedHash = leaf;
1582         for (uint256 i = 0; i < proof.length; i++) {
1583             bytes32 proofElement = proof[i];
1584             if (computedHash <= proofElement) {
1585                 // Hash(current computed hash + current element of the proof)
1586                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1587             } else {
1588                 // Hash(current element of the proof + current computed hash)
1589                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1590             }
1591         }
1592         return computedHash;
1593     }
1594 }
1595 
1596 
1597 pragma solidity ^0.8.11;
1598 pragma abicoder v2;
1599 
1600 contract CouchGuyz is ERC721A, Ownable, ReentrancyGuard {
1601   using SafeMath for uint256;
1602   
1603   using MerkleProof for bytes32[];
1604   bytes32 public whitelistMerkleRoot;
1605   bool public preSaleIsActive = false;
1606   bool public saleIsActive = false;
1607   uint256 public tokenPrice = 30000000000000000;
1608   
1609   uint public constant MAX_TOKEN_PER_TXN = 4;
1610   
1611   uint256 public constant MAX_TOKENS = 3334;
1612   
1613   address public proxyRegistryAddress;
1614   mapping(address => uint256) private allowance;
1615   string public baseURI;
1616     
1617   constructor() ERC721A("Couch Guyz", "CG") {
1618     setBaseURI("https://blam.io/api/couch-guyz/token/");
1619     proxyRegistryAddress = address(0xa5409ec958C83C3f309868babACA7c86DCB077c1);
1620   }
1621 
1622   function updateTokenPrice(uint256 newPrice) public onlyOwner {
1623     require(!saleIsActive, "Sale must be inactive to change token price");
1624     tokenPrice = newPrice;
1625   }
1626 
1627   
1628   function withdraw() public onlyOwner {
1629     uint256 balance = address(this).balance;
1630     require(balance > 0);
1631 
1632     address owner = payable(_msgSender());
1633     address payoutAddress1 = payable(0xAc01B61D659bD72b120DB7c5289BBFc020771943);
1634     uint256 payoutPayment1 = balance.mul(2).div(100);
1635     address payoutAddress2 = payable(0x8fc1F1F48cBB2e4A0f1dfeB9e6019606b307C3c4);
1636     uint256 payoutPayment2 = balance.mul(5).div(100);
1637     
1638     (bool success1, ) = payoutAddress1.call{value: payoutPayment1}("");
1639     require(success1, "Failed to send.");
1640     
1641     (bool success2, ) = payoutAddress2.call{value: payoutPayment2}("");
1642     require(success2, "Failed to send.");
1643     
1644 
1645     (bool ownerSuccess, ) = owner.call{value: address(this).balance}("");
1646     require(ownerSuccess, "Failed to send to Owner.");
1647   }
1648   
1649   function setBaseURI(string memory _baseURI) public onlyOwner {
1650     baseURI = _baseURI;
1651   }
1652 
1653   function flipSaleState() public onlyOwner {
1654     saleIsActive = !saleIsActive;
1655   }
1656   
1657   function flipPreSaleState() public onlyOwner {
1658     preSaleIsActive = !preSaleIsActive;
1659   }
1660   
1661   function whitelistMint(uint256 numberOfTokens, uint256 allowed, bytes32[] memory proof) public payable nonReentrant {
1662     require(_msgSender() == tx.origin, "No smart contracts allowed.");
1663     require(preSaleIsActive, "Pre-sale not started or has ended");
1664     require(
1665       _verify(_leaf(_msgSender(), allowed), proof),
1666       "Your address is not whitelisted"
1667     );
1668     require(allowance[_msgSender()] + numberOfTokens <= allowed, "Exceeds wallet allowance");
1669     require(msg.value == tokenPrice.mul(numberOfTokens), "Ether sent is not correct");
1670 
1671     allowance[_msgSender()] += numberOfTokens;
1672     _safeMint(_msgSender(), numberOfTokens);
1673   }
1674   
1675   function mintToken(uint numberOfTokens) public payable nonReentrant {
1676     require(saleIsActive, "Sale must be active to mint");
1677     require(numberOfTokens < MAX_TOKEN_PER_TXN, "The max mint per transaction is 3");
1678     require(totalSupply().add(numberOfTokens) < MAX_TOKENS, "Purchase would exceed max supply");
1679     require(msg.value == tokenPrice.mul(numberOfTokens), "Ether value sent is not correct");
1680     
1681     _safeMint(_msgSender(), numberOfTokens);
1682   }
1683   
1684   function _leaf(address account, uint256 count) internal pure returns (bytes32) {
1685     return keccak256(abi.encodePacked(account, count));
1686   }
1687 
1688   function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1689     return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1690   }
1691 
1692   function setRoot(bytes32 root) external onlyOwner {
1693     whitelistMerkleRoot = root;
1694   }
1695   
1696   function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1697     proxyRegistryAddress = _proxyRegistryAddress;
1698   }
1699 
1700   function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1701     OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1702     if (address(proxyRegistry.proxies(_owner)) == operator) return true;
1703 
1704     return super.isApprovedForAll(_owner, operator);
1705   }
1706 
1707   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1708     require(_exists(tokenId), "Token does not exist.");
1709     return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1710   }
1711 
1712   function airdrop(address _to, uint256 _numberOfTokens) external onlyOwner {
1713     uint256 supply = totalSupply();
1714     require(supply + _numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply");
1715     _safeMint(_to, _numberOfTokens);
1716   }
1717 }
1718 
1719 contract OwnableDelegateProxy {}
1720 contract OpenSeaProxyRegistry {
1721   mapping(address => OwnableDelegateProxy) public proxies;
1722 }
