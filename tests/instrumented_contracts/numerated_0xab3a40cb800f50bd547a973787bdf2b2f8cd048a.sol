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
90 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
262  * @dev See https://eips.ethereum.org/EIPS/eip-721
263  */
264 interface IERC721Metadata is IERC721 {
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 
281 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
287  * @dev See https://eips.ethereum.org/EIPS/eip-721
288  */
289 interface IERC721Enumerable is IERC721 {
290     /**
291      * @dev Returns the total amount of tokens stored by the contract.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
297      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
298      */
299     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
300 
301     /**
302      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
303      * Use along with {totalSupply} to enumerate all tokens.
304      */
305     function tokenByIndex(uint256 index) external view returns (uint256);
306 }
307 
308 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Implementation of the {IERC165} interface.
341  *
342  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
343  * for the additional interface id that will be supported. For example:
344  *
345  * ```solidity
346  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
347  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
348  * }
349  * ```
350  *
351  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
352  */
353 abstract contract ERC165 is IERC165 {
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358         return interfaceId == type(IERC165).interfaceId;
359     }
360 }
361 
362 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 // CAUTION
367 // This version of SafeMath should only be used with Solidity 0.8 or later,
368 // because it relies on the compiler's built in overflow checks.
369 
370 /**
371  * @dev Wrappers over Solidity's arithmetic operations.
372  *
373  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
374  * now has built in overflow checking.
375  */
376 library SafeMath {
377     /**
378      * @dev Returns the addition of two unsigned integers, with an overflow flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         unchecked {
384             uint256 c = a + b;
385             if (c < a) return (false, 0);
386             return (true, c);
387         }
388     }
389 
390     /**
391      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         unchecked {
397             if (b > a) return (false, 0);
398             return (true, a - b);
399         }
400     }
401 
402     /**
403      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
404      *
405      * _Available since v3.4._
406      */
407     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         unchecked {
409             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
410             // benefit is lost if 'b' is also tested.
411             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
412             if (a == 0) return (true, 0);
413             uint256 c = a * b;
414             if (c / a != b) return (false, 0);
415             return (true, c);
416         }
417     }
418 
419     /**
420      * @dev Returns the division of two unsigned integers, with a division by zero flag.
421      *
422      * _Available since v3.4._
423      */
424     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
425         unchecked {
426             if (b == 0) return (false, 0);
427             return (true, a / b);
428         }
429     }
430 
431     /**
432      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
433      *
434      * _Available since v3.4._
435      */
436     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
437         unchecked {
438             if (b == 0) return (false, 0);
439             return (true, a % b);
440         }
441     }
442 
443     /**
444      * @dev Returns the addition of two unsigned integers, reverting on
445      * overflow.
446      *
447      * Counterpart to Solidity's `+` operator.
448      *
449      * Requirements:
450      *
451      * - Addition cannot overflow.
452      */
453     function add(uint256 a, uint256 b) internal pure returns (uint256) {
454         return a + b;
455     }
456 
457     /**
458      * @dev Returns the subtraction of two unsigned integers, reverting on
459      * overflow (when the result is negative).
460      *
461      * Counterpart to Solidity's `-` operator.
462      *
463      * Requirements:
464      *
465      * - Subtraction cannot overflow.
466      */
467     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
468         return a - b;
469     }
470 
471     /**
472      * @dev Returns the multiplication of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `*` operator.
476      *
477      * Requirements:
478      *
479      * - Multiplication cannot overflow.
480      */
481     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482         return a * b;
483     }
484 
485     /**
486      * @dev Returns the integer division of two unsigned integers, reverting on
487      * division by zero. The result is rounded towards zero.
488      *
489      * Counterpart to Solidity's `/` operator.
490      *
491      * Requirements:
492      *
493      * - The divisor cannot be zero.
494      */
495     function div(uint256 a, uint256 b) internal pure returns (uint256) {
496         return a / b;
497     }
498 
499     /**
500      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
501      * reverting when dividing by zero.
502      *
503      * Counterpart to Solidity's `%` operator. This function uses a `revert`
504      * opcode (which leaves remaining gas untouched) while Solidity uses an
505      * invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
512         return a % b;
513     }
514 
515     /**
516      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
517      * overflow (when the result is negative).
518      *
519      * CAUTION: This function is deprecated because it requires allocating memory for the error
520      * message unnecessarily. For custom revert reasons use {trySub}.
521      *
522      * Counterpart to Solidity's `-` operator.
523      *
524      * Requirements:
525      *
526      * - Subtraction cannot overflow.
527      */
528     function sub(
529         uint256 a,
530         uint256 b,
531         string memory errorMessage
532     ) internal pure returns (uint256) {
533         unchecked {
534             require(b <= a, errorMessage);
535             return a - b;
536         }
537     }
538 
539     /**
540      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
541      * division by zero. The result is rounded towards zero.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(
552         uint256 a,
553         uint256 b,
554         string memory errorMessage
555     ) internal pure returns (uint256) {
556         unchecked {
557             require(b > 0, errorMessage);
558             return a / b;
559         }
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * reverting with custom message when dividing by zero.
565      *
566      * CAUTION: This function is deprecated because it requires allocating memory for the error
567      * message unnecessarily. For custom revert reasons use {tryMod}.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(
578         uint256 a,
579         uint256 b,
580         string memory errorMessage
581     ) internal pure returns (uint256) {
582         unchecked {
583             require(b > 0, errorMessage);
584             return a % b;
585         }
586     }
587 }
588 
589 pragma solidity ^0.8.6;
590 
591 library Address {
592     function isContract(address account) internal view returns (bool) {
593         uint size;
594         assembly {
595             size := extcodesize(account)
596         }
597         return size > 0;
598     }
599 }
600 
601 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev String operations.
607  */
608 library Strings {
609     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
610 
611     /**
612      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
613      */
614     function toString(uint256 value) internal pure returns (string memory) {
615         // Inspired by OraclizeAPI's implementation - MIT licence
616         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
617 
618         if (value == 0) {
619             return "0";
620         }
621         uint256 temp = value;
622         uint256 digits;
623         while (temp != 0) {
624             digits++;
625             temp /= 10;
626         }
627         bytes memory buffer = new bytes(digits);
628         while (value != 0) {
629             digits -= 1;
630             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
631             value /= 10;
632         }
633         return string(buffer);
634     }
635 
636     /**
637      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
638      */
639     function toHexString(uint256 value) internal pure returns (string memory) {
640         if (value == 0) {
641             return "0x00";
642         }
643         uint256 temp = value;
644         uint256 length = 0;
645         while (temp != 0) {
646             length++;
647             temp >>= 8;
648         }
649         return toHexString(value, length);
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
654      */
655     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
656         bytes memory buffer = new bytes(2 * length + 2);
657         buffer[0] = "0";
658         buffer[1] = "x";
659         for (uint256 i = 2 * length + 1; i > 1; --i) {
660             buffer[i] = _HEX_SYMBOLS[value & 0xf];
661             value >>= 4;
662         }
663         require(value == 0, "Strings: hex length insufficient");
664         return string(buffer);
665     }
666 }
667 
668 pragma solidity ^0.8.7;
669 
670 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
671     using Address for address;
672     using Strings for uint256;
673     
674     string private _name;
675     string private _symbol;
676 
677     // Mapping from token ID to owner address
678     address[] internal _owners;
679 
680     mapping(uint256 => address) private _tokenApprovals;
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     /**
684      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
685      */
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689     }
690 
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId)
695         public
696         view
697         virtual
698         override(ERC165, IERC165)
699         returns (bool)
700     {
701         return
702             interfaceId == type(IERC721).interfaceId ||
703             interfaceId == type(IERC721Metadata).interfaceId ||
704             super.supportsInterface(interfaceId);
705     }
706 
707     /**
708      * @dev See {IERC721-balanceOf}.
709      */
710     function balanceOf(address owner) 
711         public 
712         view 
713         virtual 
714         override 
715         returns (uint) 
716     {
717         require(owner != address(0), "ERC721: balance query for the zero address");
718 
719         uint count;
720         for( uint i; i < _owners.length; ++i ){
721           if( owner == _owners[i] )
722             ++count;
723         }
724         return count;
725     }
726 
727     /**
728      * @dev See {IERC721-ownerOf}.
729      */
730     function ownerOf(uint256 tokenId)
731         public
732         view
733         virtual
734         override
735         returns (address)
736     {
737         address owner = _owners[tokenId];
738         require(
739             owner != address(0),
740             "ERC721: owner query for nonexistent token"
741         );
742         return owner;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-name}.
747      */
748     function name() public view virtual override returns (string memory) {
749         return _name;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-symbol}.
754      */
755     function symbol() public view virtual override returns (string memory) {
756         return _symbol;
757     }
758 
759     /**
760      * @dev See {IERC721-approve}.
761      */
762     function approve(address to, uint256 tokenId) public virtual override {
763         address owner = ERC721.ownerOf(tokenId);
764         require(to != owner, "ERC721: approval to current owner");
765 
766         require(
767             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
768             "ERC721: approve caller is not owner nor approved for all"
769         );
770 
771         _approve(to, tokenId);
772     }
773 
774     /**
775      * @dev See {IERC721-getApproved}.
776      */
777     function getApproved(uint256 tokenId)
778         public
779         view
780         virtual
781         override
782         returns (address)
783     {
784         require(
785             _exists(tokenId),
786             "ERC721: approved query for nonexistent token"
787         );
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved)
796         public
797         virtual
798         override
799     {
800         require(operator != _msgSender(), "ERC721: approve to caller");
801 
802         _operatorApprovals[_msgSender()][operator] = approved;
803         emit ApprovalForAll(_msgSender(), operator, approved);
804     }
805 
806     /**
807      * @dev See {IERC721-isApprovedForAll}.
808      */
809     function isApprovedForAll(address owner, address operator)
810         public
811         view
812         virtual
813         override
814         returns (bool)
815     {
816         return _operatorApprovals[owner][operator];
817     }
818 
819     /**
820      * @dev See {IERC721-transferFrom}.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         //solhint-disable-next-line max-line-length
828         require(
829             _isApprovedOrOwner(_msgSender(), tokenId),
830             "ERC721: transfer caller is not owner nor approved"
831         );
832 
833         _transfer(from, to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         safeTransferFrom(from, to, tokenId, "");
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) public virtual override {
856         require(
857             _isApprovedOrOwner(_msgSender(), tokenId),
858             "ERC721: transfer caller is not owner nor approved"
859         );
860         _safeTransfer(from, to, tokenId, _data);
861     }
862 
863     /**
864      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
865      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
866      *
867      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
868      *
869      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
870      * implement alternative mechanisms to perform token transfer, such as signature-based.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _safeTransfer(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) internal virtual {
887         _transfer(from, to, tokenId);
888         require(
889             _checkOnERC721Received(from, to, tokenId, _data),
890             "ERC721: transfer to non ERC721Receiver implementer"
891         );
892     }
893 
894     /**
895      * @dev Returns whether `tokenId` exists.
896      *
897      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
898      *
899      * Tokens start existing when they are minted (`_mint`),
900      * and stop existing when they are burned (`_burn`).
901      */
902     function _exists(uint256 tokenId) internal view virtual returns (bool) {
903         return tokenId < _owners.length && _owners[tokenId] != address(0);
904     }
905 
906     /**
907      * @dev Returns whether `spender` is allowed to manage `tokenId`.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      */
913     function _isApprovedOrOwner(address spender, uint256 tokenId)
914         internal
915         view
916         virtual
917         returns (bool)
918     {
919         require(
920             _exists(tokenId),
921             "ERC721: operator query for nonexistent token"
922         );
923         address owner = ERC721.ownerOf(tokenId);
924         return (spender == owner ||
925             getApproved(tokenId) == spender ||
926             isApprovedForAll(owner, spender));
927     }
928 
929     /**
930      * @dev Safely mints `tokenId` and transfers it to `to`.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(address to, uint256 tokenId) internal virtual {
940         _safeMint(to, tokenId, "");
941     }
942 
943     /**
944      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
945      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
946      */
947     function _safeMint(
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) internal virtual {
952         _mint(to, tokenId);
953         require(
954             _checkOnERC721Received(address(0), to, tokenId, _data),
955             "ERC721: transfer to non ERC721Receiver implementer"
956         );
957     }
958 
959     /**
960      * @dev Mints `tokenId` and transfers it to `to`.
961      *
962      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
963      *
964      * Requirements:
965      *
966      * - `tokenId` must not exist.
967      * - `to` cannot be the zero address.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _mint(address to, uint256 tokenId) internal virtual {
972         require(to != address(0), "ERC721: mint to the zero address");
973         require(!_exists(tokenId), "ERC721: token already minted");
974 
975         _beforeTokenTransfer(address(0), to, tokenId);
976         _owners.push(to);
977 
978         emit Transfer(address(0), to, tokenId);
979     }
980 
981     /**
982      * @dev Destroys `tokenId`.
983      * The approval is cleared when the token is burned.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _burn(uint256 tokenId) internal virtual {
992         address owner = ERC721.ownerOf(tokenId);
993 
994         _beforeTokenTransfer(owner, address(0), tokenId);
995 
996         // Clear approvals
997         _approve(address(0), tokenId);
998         _owners[tokenId] = address(0);
999 
1000         emit Transfer(owner, address(0), tokenId);
1001     }
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _transfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {
1019         require(
1020             ERC721.ownerOf(tokenId) == from,
1021             "ERC721: transfer of token that is not own"
1022         );
1023         require(to != address(0), "ERC721: transfer to the zero address");
1024 
1025         _beforeTokenTransfer(from, to, tokenId);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId);
1029         _owners[tokenId] = to;
1030 
1031         emit Transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Approve `to` to operate on `tokenId`
1036      *
1037      * Emits a {Approval} event.
1038      */
1039     function _approve(address to, uint256 tokenId) internal virtual {
1040         _tokenApprovals[tokenId] = to;
1041         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1046      * The call is not executed if the target address is not a contract.
1047      *
1048      * @param from address representing the previous owner of the given token ID
1049      * @param to target address that will receive the tokens
1050      * @param tokenId uint256 ID of the token to be transferred
1051      * @param _data bytes optional data to send along with the call
1052      * @return bool whether the call correctly returned the expected magic value
1053      */
1054     function _checkOnERC721Received(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) private returns (bool) {
1060         if (to.isContract()) {
1061             try
1062                 IERC721Receiver(to).onERC721Received(
1063                     _msgSender(),
1064                     from,
1065                     tokenId,
1066                     _data
1067                 )
1068             returns (bytes4 retval) {
1069                 return retval == IERC721Receiver.onERC721Received.selector;
1070             } catch (bytes memory reason) {
1071                 if (reason.length == 0) {
1072                     revert(
1073                         "ERC721: transfer to non ERC721Receiver implementer"
1074                     );
1075                 } else {
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096      * - `from` and `to` are never both zero.
1097      *
1098      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1099      */
1100     function _beforeTokenTransfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) internal virtual {}
1105 }
1106 
1107 pragma solidity ^0.8.7;
1108 
1109 /**
1110  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1111  * enumerability of all the token ids in the contract as well as all token ids owned by each
1112  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
1113  */
1114 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1115     /**
1116      * @dev See {IERC165-supportsInterface}.
1117      */
1118     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1119         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-totalSupply}.
1124      */
1125     function totalSupply() public view virtual override returns (uint256) {
1126         return _owners.length;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-tokenByIndex}.
1131      */
1132     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1133         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1134         return index;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1139      */
1140     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1141         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1142 
1143         uint count;
1144         for(uint i; i < _owners.length; i++){
1145             if(owner == _owners[i]){
1146                 if(count == index) return i;
1147                 else count++;
1148             }
1149         }
1150 
1151         revert("ERC721Enumerable: owner index out of bounds");
1152     }
1153 }
1154 
1155 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1156 
1157 pragma solidity ^0.8.0;
1158 
1159 /**
1160  * @dev Contract module which provides a basic access control mechanism, where
1161  * there is an account (an owner) that can be granted exclusive access to
1162  * specific functions.
1163  *
1164  * By default, the owner account will be the one that deploys the contract. This
1165  * can later be changed with {transferOwnership}.
1166  *
1167  * This module is used through inheritance. It will make available the modifier
1168  * `onlyOwner`, which can be applied to your functions to restrict their use to
1169  * the owner.
1170  */
1171 abstract contract Ownable is Context {
1172     address private _owner;
1173 
1174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1175 
1176     /**
1177      * @dev Initializes the contract setting the deployer as the initial owner.
1178      */
1179     constructor() {
1180         _transferOwnership(_msgSender());
1181     }
1182 
1183     /**
1184      * @dev Returns the address of the current owner.
1185      */
1186     function owner() public view virtual returns (address) {
1187         return _owner;
1188     }
1189 
1190     /**
1191      * @dev Throws if called by any account other than the owner.
1192      */
1193     modifier onlyOwner() {
1194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1195         _;
1196     }
1197 
1198     /**
1199      * @dev Leaves the contract without owner. It will not be possible to call
1200      * `onlyOwner` functions anymore. Can only be called by the current owner.
1201      *
1202      * NOTE: Renouncing ownership will leave the contract without an owner,
1203      * thereby removing any functionality that is only available to the owner.
1204      */
1205     function renounceOwnership() public virtual onlyOwner {
1206         _transferOwnership(address(0));
1207     }
1208 
1209     /**
1210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1211      * Can only be called by the current owner.
1212      */
1213     function transferOwnership(address newOwner) public virtual onlyOwner {
1214         require(newOwner != address(0), "Ownable: new owner is the zero address");
1215         _transferOwnership(newOwner);
1216     }
1217 
1218     /**
1219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1220      * Internal function without access restriction.
1221      */
1222     function _transferOwnership(address newOwner) internal virtual {
1223         address oldOwner = _owner;
1224         _owner = newOwner;
1225         emit OwnershipTransferred(oldOwner, newOwner);
1226     }
1227 }
1228 pragma solidity ^0.8.11;
1229 pragma abicoder v2;
1230 
1231 
1232 contract DegenWaifus is ERC721Enumerable, Ownable, ReentrancyGuard {
1233   using SafeMath for uint256;
1234   
1235   mapping(address => uint256) private         freeNFT;
1236   mapping(address => uint256) private         mintedTokens;
1237   bool                        public          saleIsActive = true;
1238   string                      public          final_provenance = "";
1239   address                     public          proxyRegistryAddress;
1240   mapping(address => bool)    public          projectProxy;
1241   string                      public          baseURI;
1242   string                      public constant baseUriSuffix = ".json";
1243   uint256                     public constant TOKEN_PRICE = 20000000000000000;
1244   uint256                     public constant MAX_NFT_PER_TX = 11;
1245   uint256                     public constant MAX_NFT = 4444;
1246   uint256                     public constant MAX_NFT_PER_BUYER = 11;
1247   uint256                     public constant FREE_NFT = 1111;
1248   address                     public constant DEV_ADDRESS = 0xE3cc957C3a1AC0eB137B50a855e30FED80CcD30c;
1249   address                     public constant OWNER_ADDRESS = 0xEEEE451963d5A81C9D94776C9519ABb6b6342Ad5;
1250     
1251   constructor() ERC721("DegenWaifus", "DW") {
1252     setBaseURI("ipfs://QmWbz5xr1Gf5EYNQjT5HeDm3j3DDUm2GasFRwyURiZvQxr/");
1253     proxyRegistryAddress = address(0xa5409ec958C83C3f309868babACA7c86DCB077c1);
1254   }
1255     
1256   function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1257     proxyRegistryAddress = _proxyRegistryAddress;
1258   }
1259   
1260   function flipProxyState(address proxyAddress) public onlyOwner {
1261     projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1262   }
1263 
1264   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1265     require(_exists(_tokenId), "Token does not exist.");
1266     return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), baseUriSuffix));
1267   }
1268 
1269 
1270   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1271     final_provenance = provenanceHash;
1272   }
1273 
1274   function setBaseURI(string memory _baseURI) public onlyOwner {
1275     baseURI = _baseURI;
1276   }
1277 
1278   function flipSaleState() public onlyOwner {
1279     saleIsActive = !saleIsActive;
1280   }
1281   
1282   
1283   function freeMint(uint numberOfTokens) public nonReentrant {
1284     require(saleIsActive, "Sale must be active to mint");
1285     require(freeNFT[msg.sender].add(numberOfTokens) < MAX_NFT_PER_BUYER, "Your mint would exceed the total of 10 Waifus allowed for free.");
1286     require(totalSupply().add(numberOfTokens) < FREE_NFT, "Purchase would exceed free supply");
1287     
1288     for(uint i = 0; i < numberOfTokens; i++) {
1289       _safeMint(msg.sender, totalSupply());
1290     }
1291 
1292     freeNFT[msg.sender] += numberOfTokens;
1293     mintedTokens[msg.sender] += numberOfTokens;
1294   }
1295   
1296   
1297   function mintToken(uint numberOfTokens) public payable nonReentrant {
1298     require(saleIsActive, "Sale must be active to mint");
1299     require(numberOfTokens > 0, "You must mint atleast 1 NFT.");
1300     require(numberOfTokens < MAX_NFT_PER_TX, "Only 10 NFTs mintable per transaction.");
1301     require(mintedTokens[msg.sender].add(numberOfTokens) < MAX_NFT_PER_BUYER, "Your mint would exceed the total of 10 nfts allowed for per wallet.");
1302     require(totalSupply().add(numberOfTokens) < MAX_NFT, "Purchase would exceed max supply");
1303     require(msg.value == TOKEN_PRICE.mul(numberOfTokens), "Wrong ether value");
1304     
1305     for(uint i = 0; i < numberOfTokens; i++) {
1306       _safeMint(msg.sender, totalSupply());
1307     }
1308   }
1309 
1310 
1311   function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1312     uint256 tokenCount = balanceOf(_owner);
1313     if (tokenCount == 0) {
1314       // Return an empty array
1315       return new uint256[](0);
1316     } else {
1317       uint256[] memory result = new uint256[](tokenCount);
1318       uint256 index;
1319       for (index = 0; index < tokenCount; index++) {
1320         result[index] = tokenOfOwnerByIndex(_owner, index);
1321       }
1322       return result;
1323     }
1324   }
1325 
1326   function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1327     OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1328     if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1329     return super.isApprovedForAll(_owner, operator);
1330   }
1331 
1332     function withdraw() public onlyOwner nonReentrant {
1333     require(msg.sender == owner(), "Invalid sender");
1334 
1335     (bool dev, ) = DEV_ADDRESS.call{value: address(this).balance * 10/100}("");
1336     require(dev);
1337 
1338     (bool owner, ) = OWNER_ADDRESS.call{value: address(this).balance}("");
1339     require(owner);
1340 
1341   }
1342 }
1343 
1344 contract OwnableDelegateProxy {}
1345 contract OpenSeaProxyRegistry {
1346   mapping(address => OwnableDelegateProxy) public proxies;
1347 }