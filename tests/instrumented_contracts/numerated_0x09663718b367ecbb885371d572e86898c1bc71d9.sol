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
27 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 interface IERC721 is IERC165 {
60     /**
61      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
67      */
68     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
72      */
73     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
74 
75     /**
76      * @dev Returns the number of tokens in ``owner``s account.
77      */
78     function balanceOf(address owner) external view returns (uint256 balance);
79 
80     /**
81      * @dev Returns the owner of the `tokenId` token.
82      *
83      * Requirements:
84      *
85      * - `tokenId` must exist.
86      */
87     function ownerOf(uint256 tokenId) external view returns (address owner);
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
131      * The approval is cleared when the token is transferred.
132      *
133      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
134      *
135      * Requirements:
136      *
137      * - The caller must own the token or be an approved operator.
138      * - `tokenId` must exist.
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address to, uint256 tokenId) external;
143 
144     /**
145      * @dev Returns the account approved for `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function getApproved(uint256 tokenId) external view returns (address operator);
152 
153     /**
154      * @dev Approve or remove `operator` as an operator for the caller.
155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
156      *
157      * Requirements:
158      *
159      * - The `operator` cannot be the caller.
160      *
161      * Emits an {ApprovalForAll} event.
162      */
163     function setApprovalForAll(address operator, bool _approved) external;
164 
165     /**
166      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
167      *
168      * See {setApprovalForAll}
169      */
170     function isApprovedForAll(address owner, address operator) external view returns (bool);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 }
192 
193 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202     /**
203      * @dev Returns the token collection name.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the token collection symbol.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
214      */
215     function tokenURI(uint256 tokenId) external view returns (string memory);
216 }
217 
218 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Enumerable is IERC721 {
227     /**
228      * @dev Returns the total amount of tokens stored by the contract.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
234      * Use along with {balanceOf} to enumerate all of ``owner``s tokens.
235      */
236     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
237 
238     /**
239      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
240      * Use along with {totalSupply} to enumerate all tokens.
241      */
242     function tokenByIndex(uint256 index) external view returns (uint256);
243 }
244 
245 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by `operator` from `from`, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Implementation of the {IERC165} interface.
278  *
279  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
280  * for the additional interface id that will be supported. For example:
281  *
282  * ```solidity
283  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
285  * }
286  * ```
287  *
288  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
289  */
290 abstract contract ERC165 is IERC165 {
291     /**
292      * @dev See {IERC165-supportsInterface}.
293      */
294     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
295         return interfaceId == type(IERC165).interfaceId;
296     }
297 }
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 // CAUTION
304 // This version of SafeMath should only be used with Solidity 0.8 or later,
305 // because it relies on the compilers built in overflow checks.
306 
307 /**
308  * @dev Wrappers over Soliditys arithmetic operations.
309  *
310  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
311  * now has built in overflow checking.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, with an overflow flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         unchecked {
321             uint256 c = a + b;
322             if (c < a) return (false, 0);
323             return (true, c);
324         }
325     }
326 
327     /**
328      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
329      *
330      * _Available since v3.4._
331      */
332     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
333         unchecked {
334             if (b > a) return (false, 0);
335             return (true, a - b);
336         }
337     }
338 
339     /**
340      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
341      *
342      * _Available since v3.4._
343      */
344     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
345         unchecked {
346             // Gas optimization: this is cheaper than requiring a not being zero, but the
347             // benefit is lost if b is also tested.
348             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
349             if (a == 0) return (true, 0);
350             uint256 c = a * b;
351             if (c / a != b) return (false, 0);
352             return (true, c);
353         }
354     }
355 
356     /**
357      * @dev Returns the division of two unsigned integers, with a division by zero flag.
358      *
359      * _Available since v3.4._
360      */
361     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         unchecked {
363             if (b == 0) return (false, 0);
364             return (true, a / b);
365         }
366     }
367 
368     /**
369      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
370      *
371      * _Available since v3.4._
372      */
373     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
374         unchecked {
375             if (b == 0) return (false, 0);
376             return (true, a % b);
377         }
378     }
379 
380     /**
381      * @dev Returns the addition of two unsigned integers, reverting on
382      * overflow.
383      *
384      * Counterpart to Soliditys `+` operator.
385      *
386      * Requirements:
387      *
388      * - Addition cannot overflow.
389      */
390     function add(uint256 a, uint256 b) internal pure returns (uint256) {
391         return a + b;
392     }
393 
394     /**
395      * @dev Returns the subtraction of two unsigned integers, reverting on
396      * overflow (when the result is negative).
397      *
398      * Counterpart to Soliditys `-` operator.
399      *
400      * Requirements:
401      *
402      * - Subtraction cannot overflow.
403      */
404     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
405         return a - b;
406     }
407 
408     /**
409      * @dev Returns the multiplication of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Soliditys `*` operator.
413      *
414      * Requirements:
415      *
416      * - Multiplication cannot overflow.
417      */
418     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
419         return a * b;
420     }
421 
422     /**
423      * @dev Returns the integer division of two unsigned integers, reverting on
424      * division by zero. The result is rounded towards zero.
425      *
426      * Counterpart to Soliditys `/` operator.
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function div(uint256 a, uint256 b) internal pure returns (uint256) {
433         return a / b;
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
438      * reverting when dividing by zero.
439      *
440      * Counterpart to Soliditys `%` operator. This function uses a `revert`
441      * opcode (which leaves remaining gas untouched) while Solidity uses an
442      * invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
449         return a % b;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
454      * overflow (when the result is negative).
455      *
456      * CAUTION: This function is deprecated because it requires allocating memory for the error
457      * message unnecessarily. For custom revert reasons use {trySub}.
458      *
459      * Counterpart to Soliditys `-` operator.
460      *
461      * Requirements:
462      *
463      * - Subtraction cannot overflow.
464      */
465     function sub(
466         uint256 a,
467         uint256 b,
468         string memory errorMessage
469     ) internal pure returns (uint256) {
470         unchecked {
471             require(b <= a, errorMessage);
472             return a - b;
473         }
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
478      * division by zero. The result is rounded towards zero.
479      *
480      * Counterpart to Soliditys `/` operator. Note: this function uses a
481      * `revert` opcode (which leaves remaining gas untouched) while Solidity
482      * uses an invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function div(
489         uint256 a,
490         uint256 b,
491         string memory errorMessage
492     ) internal pure returns (uint256) {
493         unchecked {
494             require(b > 0, errorMessage);
495             return a / b;
496         }
497     }
498 
499     /**
500      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
501      * reverting with custom message when dividing by zero.
502      *
503      * CAUTION: This function is deprecated because it requires allocating memory for the error
504      * message unnecessarily. For custom revert reasons use {tryMod}.
505      *
506      * Counterpart to Soliditys `%` operator. This function uses a `revert`
507      * opcode (which leaves remaining gas untouched) while Solidity uses an
508      * invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      *
512      * - The divisor cannot be zero.
513      */
514     function mod(
515         uint256 a,
516         uint256 b,
517         string memory errorMessage
518     ) internal pure returns (uint256) {
519         unchecked {
520             require(b > 0, errorMessage);
521             return a % b;
522         }
523     }
524 }
525 
526 pragma solidity ^0.8.6;
527 
528 library Address {
529     function isContract(address account) internal view returns (bool) {
530         uint size;
531         assembly {
532             size := extcodesize(account)
533         }
534         return size > 0;
535     }
536 }
537 
538 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
550      */
551     function toString(uint256 value) internal pure returns (string memory) {
552         // Inspired by OraclizeAPIs implementation - MIT licence
553         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
554 
555         if (value == 0) {
556             return "0";
557         }
558         uint256 temp = value;
559         uint256 digits;
560         while (temp != 0) {
561             digits++;
562             temp /= 10;
563         }
564         bytes memory buffer = new bytes(digits);
565         while (value != 0) {
566             digits -= 1;
567             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
568             value /= 10;
569         }
570         return string(buffer);
571     }
572 
573     /**
574      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
575      */
576     function toHexString(uint256 value) internal pure returns (string memory) {
577         if (value == 0) {
578             return "0x00";
579         }
580         uint256 temp = value;
581         uint256 length = 0;
582         while (temp != 0) {
583             length++;
584             temp >>= 8;
585         }
586         return toHexString(value, length);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
591      */
592     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
593         bytes memory buffer = new bytes(2 * length + 2);
594         buffer[0] = "0";
595         buffer[1] = "x";
596         for (uint256 i = 2 * length + 1; i > 1; --i) {
597             buffer[i] = _HEX_SYMBOLS[value & 0xf];
598             value >>= 4;
599         }
600         require(value == 0, "Strings: hex length insufficient");
601         return string(buffer);
602     }
603 }
604 
605 pragma solidity ^0.8.7;
606 
607 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
608     using Address for address;
609     using Strings for uint256;
610     
611     string private _name;
612     string private _symbol;
613 
614     // Mapping from token ID to owner address
615     address[] internal _owners;
616 
617     mapping(uint256 => address) private _tokenApprovals;
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     /**
621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
622      */
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId)
632         public
633         view
634         virtual
635         override(ERC165, IERC165)
636         returns (bool)
637     {
638         return
639             interfaceId == type(IERC721).interfaceId ||
640             interfaceId == type(IERC721Metadata).interfaceId ||
641             super.supportsInterface(interfaceId);
642     }
643 
644     /**
645      * @dev See {IERC721-balanceOf}.
646      */
647     function balanceOf(address owner) 
648         public 
649         view 
650         virtual 
651         override 
652         returns (uint) 
653     {
654         require(owner != address(0), "ERC721: balance query for the zero address");
655 
656         uint count;
657         for( uint i; i < _owners.length; ++i ){
658           if( owner == _owners[i] )
659             ++count;
660         }
661         return count;
662     }
663 
664     /**
665      * @dev See {IERC721-ownerOf}.
666      */
667     function ownerOf(uint256 tokenId)
668         public
669         view
670         virtual
671         override
672         returns (address)
673     {
674         address owner = _owners[tokenId];
675         require(
676             owner != address(0),
677             "ERC721: owner query for nonexistent token"
678         );
679         return owner;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-name}.
684      */
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688 
689     /**
690      * @dev See {IERC721Metadata-symbol}.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public virtual override {
700         address owner = ERC721.ownerOf(tokenId);
701         require(to != owner, "ERC721: approval to current owner");
702 
703         require(
704             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
705             "ERC721: approve caller is not owner nor approved for all"
706         );
707 
708         _approve(to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId)
715         public
716         view
717         virtual
718         override
719         returns (address)
720     {
721         require(
722             _exists(tokenId),
723             "ERC721: approved query for nonexistent token"
724         );
725 
726         return _tokenApprovals[tokenId];
727     }
728 
729     /**
730      * @dev See {IERC721-setApprovalForAll}.
731      */
732     function setApprovalForAll(address operator, bool approved)
733         public
734         virtual
735         override
736     {
737         require(operator != _msgSender(), "ERC721: approve to caller");
738 
739         _operatorApprovals[_msgSender()][operator] = approved;
740         emit ApprovalForAll(_msgSender(), operator, approved);
741     }
742 
743     /**
744      * @dev See {IERC721-isApprovedForAll}.
745      */
746     function isApprovedForAll(address owner, address operator)
747         public
748         view
749         virtual
750         override
751         returns (bool)
752     {
753         return _operatorApprovals[owner][operator];
754     }
755 
756     /**
757      * @dev See {IERC721-transferFrom}.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) public virtual override {
764         //solhint-disable-next-line max-line-length
765         require(
766             _isApprovedOrOwner(_msgSender(), tokenId),
767             "ERC721: transfer caller is not owner nor approved"
768         );
769 
770         _transfer(from, to, tokenId);
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public virtual override {
781         safeTransferFrom(from, to, tokenId, "");
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) public virtual override {
793         require(
794             _isApprovedOrOwner(_msgSender(), tokenId),
795             "ERC721: transfer caller is not owner nor approved"
796         );
797         _safeTransfer(from, to, tokenId, _data);
798     }
799 
800     /**
801      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
802      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
803      *
804      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
805      *
806      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
807      * implement alternative mechanisms to perform token transfer, such as signature-based.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeTransfer(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes memory _data
823     ) internal virtual {
824         _transfer(from, to, tokenId);
825         require(
826             _checkOnERC721Received(from, to, tokenId, _data),
827             "ERC721: transfer to non ERC721Receiver implementer"
828         );
829     }
830 
831     /**
832      * @dev Returns whether `tokenId` exists.
833      *
834      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
835      *
836      * Tokens start existing when they are minted (`_mint`),
837      * and stop existing when they are burned (`_burn`).
838      */
839     function _exists(uint256 tokenId) internal view virtual returns (bool) {
840         return tokenId < _owners.length && _owners[tokenId] != address(0);
841     }
842 
843     /**
844      * @dev Returns whether `spender` is allowed to manage `tokenId`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function _isApprovedOrOwner(address spender, uint256 tokenId)
851         internal
852         view
853         virtual
854         returns (bool)
855     {
856         require(
857             _exists(tokenId),
858             "ERC721: operator query for nonexistent token"
859         );
860         address owner = ERC721.ownerOf(tokenId);
861         return (spender == owner ||
862             getApproved(tokenId) == spender ||
863             isApprovedForAll(owner, spender));
864     }
865 
866     /**
867      * @dev Safely mints `tokenId` and transfers it to `to`.
868      *
869      * Requirements:
870      *
871      * - `tokenId` must not exist.
872      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeMint(address to, uint256 tokenId) internal virtual {
877         _safeMint(to, tokenId, "");
878     }
879 
880     /**
881      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
882      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
883      */
884     function _safeMint(
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) internal virtual {
889         _mint(to, tokenId);
890         require(
891             _checkOnERC721Received(address(0), to, tokenId, _data),
892             "ERC721: transfer to non ERC721Receiver implementer"
893         );
894     }
895 
896     /**
897      * @dev Mints `tokenId` and transfers it to `to`.
898      *
899      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
900      *
901      * Requirements:
902      *
903      * - `tokenId` must not exist.
904      * - `to` cannot be the zero address.
905      *
906      * Emits a {Transfer} event.
907      */
908     function _mint(address to, uint256 tokenId) internal virtual {
909         require(to != address(0), "ERC721: mint to the zero address");
910         require(!_exists(tokenId), "ERC721: token already minted");
911 
912         _beforeTokenTransfer(address(0), to, tokenId);
913         _owners.push(to);
914 
915         emit Transfer(address(0), to, tokenId);
916     }
917 
918     /**
919      * @dev Destroys `tokenId`.
920      * The approval is cleared when the token is burned.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _burn(uint256 tokenId) internal virtual {
929         address owner = ERC721.ownerOf(tokenId);
930 
931         _beforeTokenTransfer(owner, address(0), tokenId);
932 
933         // Clear approvals
934         _approve(address(0), tokenId);
935         _owners[tokenId] = address(0);
936 
937         emit Transfer(owner, address(0), tokenId);
938     }
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
943      *
944      * Requirements:
945      *
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must be owned by `from`.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _transfer(
952         address from,
953         address to,
954         uint256 tokenId
955     ) internal virtual {
956         require(
957             ERC721.ownerOf(tokenId) == from,
958             "ERC721: transfer of token that is not own"
959         );
960         require(to != address(0), "ERC721: transfer to the zero address");
961 
962         _beforeTokenTransfer(from, to, tokenId);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId);
966         _owners[tokenId] = to;
967 
968         emit Transfer(from, to, tokenId);
969     }
970 
971     /**
972      * @dev Approve `to` to operate on `tokenId`
973      *
974      * Emits a {Approval} event.
975      */
976     function _approve(address to, uint256 tokenId) internal virtual {
977         _tokenApprovals[tokenId] = to;
978         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
979     }
980 
981     /**
982      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
983      * The call is not executed if the target address is not a contract.
984      *
985      * @param from address representing the previous owner of the given token ID
986      * @param to target address that will receive the tokens
987      * @param tokenId uint256 ID of the token to be transferred
988      * @param _data bytes optional data to send along with the call
989      * @return bool whether the call correctly returned the expected magic value
990      */
991     function _checkOnERC721Received(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) private returns (bool) {
997         if (to.isContract()) {
998             try
999                 IERC721Receiver(to).onERC721Received(
1000                     _msgSender(),
1001                     from,
1002                     tokenId,
1003                     _data
1004                 )
1005             returns (bytes4 retval) {
1006                 return retval == IERC721Receiver.onERC721Received.selector;
1007             } catch (bytes memory reason) {
1008                 if (reason.length == 0) {
1009                     revert(
1010                         "ERC721: transfer to non ERC721Receiver implementer"
1011                     );
1012                 } else {
1013                     assembly {
1014                         revert(add(32, reason), mload(reason))
1015                     }
1016                 }
1017             }
1018         } else {
1019             return true;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Hook that is called before any token transfer. This includes minting
1025      * and burning.
1026      *
1027      * Calling conditions:
1028      *
1029      * - When `from` and `to` are both non-zero, ``from``s `tokenId` will be
1030      * transferred to `to`.
1031      * - When `from` is zero, `tokenId` will be minted for `to`.
1032      * - When `to` is zero, ``from``s `tokenId` will be burned.
1033      * - `from` and `to` are never both zero.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _beforeTokenTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual {}
1042 }
1043 
1044 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 /**
1049  * @title ERC721 Burnable Token
1050  * @dev ERC721 Token that can be burned (destroyed).
1051  */
1052 abstract contract ERC721Burnable is Context, ERC721 {
1053     /**
1054      * @dev Burns `tokenId`. See {ERC721-_burn}.
1055      *
1056      * Requirements:
1057      *
1058      * - The caller must own `tokenId` or be an approved operator.
1059      */
1060     function burn(uint256 tokenId) public virtual {
1061         //solhint-disable-next-line max-line-length
1062         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1063         _burn(tokenId);
1064     }
1065 }
1066 
1067 pragma solidity ^0.8.7;
1068 
1069 /**
1070  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1071  * enumerability of all the token ids in the contract as well as all token ids owned by each
1072  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
1073  */
1074 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable, ERC721Burnable {
1075     /**
1076      * @dev See {IERC165-supportsInterface}.
1077      */
1078     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1079         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Enumerable-totalSupply}.
1084      */
1085     function totalSupply() public view virtual override returns (uint256) {
1086         return _owners.length;
1087     }
1088 
1089     /**
1090      * @dev See {IERC721Enumerable-tokenByIndex}.
1091      */
1092     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1093         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1094         return index;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1099      */
1100     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1101         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1102 
1103         uint count;
1104         for(uint i; i < _owners.length; i++){
1105             if(owner == _owners[i]){
1106                 if(count == index) return i;
1107                 else count++;
1108             }
1109         }
1110 
1111         revert("ERC721Enumerable: owner index out of bounds");
1112     }
1113 }
1114 
1115 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @dev Contract module which provides a basic access control mechanism, where
1121  * there is an account (an owner) that can be granted exclusive access to
1122  * specific functions.
1123  *
1124  * By default, the owner account will be the one that deploys the contract. This
1125  * can later be changed with {transferOwnership}.
1126  *
1127  * This module is used through inheritance. It will make available the modifier
1128  * `onlyOwner`, which can be applied to your functions to restrict their use to
1129  * the owner.
1130  */
1131 abstract contract Ownable is Context {
1132     address private _owner;
1133 
1134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1135 
1136     /**
1137      * @dev Initializes the contract setting the deployer as the initial owner.
1138      */
1139     constructor() {
1140         _transferOwnership(_msgSender());
1141     }
1142 
1143     /**
1144      * @dev Returns the address of the current owner.
1145      */
1146     function owner() public view virtual returns (address) {
1147         return _owner;
1148     }
1149 
1150     /**
1151      * @dev Throws if called by any account other than the owner.
1152      */
1153     modifier onlyOwner() {
1154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1155         _;
1156     }
1157 
1158     /**
1159      * @dev Leaves the contract without owner. It will not be possible to call
1160      * `onlyOwner` functions anymore. Can only be called by the current owner.
1161      *
1162      * NOTE: Renouncing ownership will leave the contract without an owner,
1163      * thereby removing any functionality that is only available to the owner.
1164      */
1165     function renounceOwnership() public virtual onlyOwner {
1166         _transferOwnership(address(0));
1167     }
1168 
1169     /**
1170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1171      * Can only be called by the current owner.
1172      */
1173     function transferOwnership(address newOwner) public virtual onlyOwner {
1174         require(newOwner != address(0), "Ownable: new owner is the zero address");
1175         _transferOwnership(newOwner);
1176     }
1177 
1178     /**
1179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1180      * Internal function without access restriction.
1181      */
1182     function _transferOwnership(address newOwner) internal virtual {
1183         address oldOwner = _owner;
1184         _owner = newOwner;
1185         emit OwnershipTransferred(oldOwner, newOwner);
1186     }
1187 }
1188 
1189 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @dev These functions deal with verification of Merkle Trees proofs.
1195  *
1196  * The proofs can be generated using the JavaScript library
1197  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1198  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1199  *
1200  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1201  */
1202 library MerkleProof {
1203     /**
1204      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1205      * defined by `root`. For this, a `proof` must be provided, containing
1206      * sibling hashes on the branch from the leaf to the root of the tree. Each
1207      * pair of leaves and each pair of pre-images are assumed to be sorted.
1208      */
1209     function verify(
1210         bytes32[] memory proof,
1211         bytes32 root,
1212         bytes32 leaf
1213     ) internal pure returns (bool) {
1214         return processProof(proof, leaf) == root;
1215     }
1216 
1217     /**
1218      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1219      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1220      * hash matches the root of the tree. When processing the proof, the pairs
1221      * of leafs & pre-images are assumed to be sorted.
1222      *
1223      * _Available since v4.4._
1224      */
1225     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1226         bytes32 computedHash = leaf;
1227         for (uint256 i = 0; i < proof.length; i++) {
1228             bytes32 proofElement = proof[i];
1229             if (computedHash <= proofElement) {
1230                 // Hash(current computed hash + current element of the proof)
1231                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1232             } else {
1233                 // Hash(current element of the proof + current computed hash)
1234                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1235             }
1236         }
1237         return computedHash;
1238     }
1239 }
1240 
1241 pragma solidity ^0.8.11;
1242 pragma abicoder v2;
1243 
1244 contract LuminalCredit is ERC721Enumerable, Ownable {
1245   using SafeMath    for uint256;
1246   using MerkleProof for bytes32[];
1247 
1248   mapping(address => uint256) private allowance;
1249   bytes32 public allowlistMerkleRoot;
1250   bool public preSaleIsActive = false;
1251   string public baseURI;
1252   mapping(address => bool) public projectProxy;
1253 
1254   uint256 public constant MAX_CREDITS = 500;
1255   
1256   constructor() ERC721("Luminal Credit", "LUMICREDIT") {
1257     setBaseURI("https://mint.luminalgenesis.xyz/api/metadata/");
1258     setRoot(0x57210f9254703b1ccfbf77a2bb8118bdf680f3340d03ebd0ab4b76118b8dc367);
1259   }
1260 
1261   function withdraw() external onlyOwner {
1262     uint256 balance = address(this).balance;
1263     require(balance > 0, "Your balance is zero");
1264     (bool ownerSuccess, ) = payable(msg.sender).call{value: balance}("");
1265     require(ownerSuccess, "Failed to send to Owner.");
1266   }
1267   
1268   function flipProxyState(address proxyAddress) external onlyOwner {
1269     projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1270   }
1271 
1272   function setBaseURI(string memory _baseURI) public onlyOwner {
1273     baseURI = _baseURI;
1274   }
1275 
1276   function flipPreSaleState() external onlyOwner {
1277     preSaleIsActive = !preSaleIsActive;
1278   }
1279   
1280   function setRoot(bytes32 root) public onlyOwner {
1281     allowlistMerkleRoot = root;
1282   }
1283 
1284   function mint(uint256 numberOfTokens, uint256 allowed, bytes32[] memory proof) external payable {
1285     require(msg.sender == tx.origin, "No smart contracts allowed.");
1286     require(preSaleIsActive, "Pre-sale not started or has ended");
1287     require(
1288       _verify(_leaf(msg.sender, allowed), proof),
1289       "Your address is not whitelisted"
1290     );
1291     require(allowance[msg.sender] + numberOfTokens <= allowed, "Exceeds wallet allowance");
1292 
1293     allowance[msg.sender] += numberOfTokens;
1294     for (uint i; i < numberOfTokens; i++) {
1295       _mint(msg.sender, totalSupply());
1296     }
1297   }
1298 
1299   function airdrop(address _to, uint256 _numberOfTokens) external onlyOwner {
1300     uint256 supply = totalSupply();
1301     require(supply + _numberOfTokens <= MAX_CREDITS, "Purchase would exceed max supply");
1302     for (uint256 i; i < _numberOfTokens; i++) {
1303       _safeMint(_to, supply + i);
1304     }
1305   }
1306 
1307   function _leaf(address account, uint256 allowed) internal pure returns (bytes32) {
1308     return keccak256(abi.encodePacked(account, allowed));
1309   }
1310 
1311   function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1312     return MerkleProof.verify(proof, allowlistMerkleRoot, leaf);
1313   }
1314 
1315   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1316     require(_exists(_tokenId), "Token does not exist");
1317     return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1318   }
1319 
1320   function isApprovedForAll(address _localOwner, address operator) public view override returns (bool) {
1321     if (projectProxy[operator]) return true;
1322     return super.isApprovedForAll(_localOwner, operator);
1323   }
1324 }