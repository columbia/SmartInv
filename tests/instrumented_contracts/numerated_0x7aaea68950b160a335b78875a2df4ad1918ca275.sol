1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
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
108 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
109 
110 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 // CAUTION
115 // This version of SafeMath should only be used with Solidity 0.8 or later,
116 // because it relies on the compiler's built in overflow checks.
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations.
120  *
121  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
122  * now has built in overflow checking.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             uint256 c = a + b;
133             if (c < a) return (false, 0);
134             return (true, c);
135         }
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
140      *
141      * _Available since v3.4._
142      */
143     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         unchecked {
145             if (b > a) return (false, 0);
146             return (true, a - b);
147         }
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         unchecked {
157             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158             // benefit is lost if 'b' is also tested.
159             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160             if (a == 0) return (true, 0);
161             uint256 c = a * b;
162             if (c / a != b) return (false, 0);
163             return (true, c);
164         }
165     }
166 
167     /**
168      * @dev Returns the division of two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         unchecked {
174             if (b == 0) return (false, 0);
175             return (true, a / b);
176         }
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
181      *
182      * _Available since v3.4._
183      */
184     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
185         unchecked {
186             if (b == 0) return (false, 0);
187             return (true, a % b);
188         }
189     }
190 
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         return a + b;
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, reverting on
207      * overflow (when the result is negative).
208      *
209      * Counterpart to Solidity's `-` operator.
210      *
211      * Requirements:
212      *
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         return a - b;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a * b;
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers, reverting on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator.
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a / b;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * reverting when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a % b;
261     }
262 
263     /**
264      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
265      * overflow (when the result is negative).
266      *
267      * CAUTION: This function is deprecated because it requires allocating memory for the error
268      * message unnecessarily. For custom revert reasons use {trySub}.
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         unchecked {
282             require(b <= a, errorMessage);
283             return a - b;
284         }
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(
300         uint256 a,
301         uint256 b,
302         string memory errorMessage
303     ) internal pure returns (uint256) {
304         unchecked {
305             require(b > 0, errorMessage);
306             return a / b;
307         }
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * reverting with custom message when dividing by zero.
313      *
314      * CAUTION: This function is deprecated because it requires allocating memory for the error
315      * message unnecessarily. For custom revert reasons use {tryMod}.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a % b;
333         }
334     }
335 }
336 
337 
338 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev String operations.
346  */
347 library Strings {
348     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
349 
350     /**
351      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
352      */
353     function toString(uint256 value) internal pure returns (string memory) {
354         // Inspired by OraclizeAPI's implementation - MIT licence
355         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
356 
357         if (value == 0) {
358             return "0";
359         }
360         uint256 temp = value;
361         uint256 digits;
362         while (temp != 0) {
363             digits++;
364             temp /= 10;
365         }
366         bytes memory buffer = new bytes(digits);
367         while (value != 0) {
368             digits -= 1;
369             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
370             value /= 10;
371         }
372         return string(buffer);
373     }
374 
375     /**
376      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
377      */
378     function toHexString(uint256 value) internal pure returns (string memory) {
379         if (value == 0) {
380             return "0x00";
381         }
382         uint256 temp = value;
383         uint256 length = 0;
384         while (temp != 0) {
385             length++;
386             temp >>= 8;
387         }
388         return toHexString(value, length);
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
393      */
394     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
395         bytes memory buffer = new bytes(2 * length + 2);
396         buffer[0] = "0";
397         buffer[1] = "x";
398         for (uint256 i = 2 * length + 1; i > 1; --i) {
399             buffer[i] = _HEX_SYMBOLS[value & 0xf];
400             value >>= 4;
401         }
402         require(value == 0, "Strings: hex length insufficient");
403         return string(buffer);
404     }
405 }
406 
407 
408 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Interface of the ERC165 standard, as defined in the
416  * https://eips.ethereum.org/EIPS/eip-165[EIP].
417  *
418  * Implementers can declare support of contract interfaces, which can then be
419  * queried by others ({ERC165Checker}).
420  *
421  * For an implementation, see {ERC165}.
422  */
423 interface IERC165 {
424     /**
425      * @dev Returns true if this contract implements the interface defined by
426      * `interfaceId`. See the corresponding
427      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
428      * to learn more about how these ids are created.
429      *
430      * This function call must use less than 30 000 gas.
431      */
432     function supportsInterface(bytes4 interfaceId) external view returns (bool);
433 }
434 
435 
436 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
437 
438 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Required interface of an ERC721 compliant contract.
444  */
445 interface IERC721 is IERC165 {
446     /**
447      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
448      */
449     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
453      */
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
458      */
459     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
460 
461     /**
462      * @dev Returns the number of tokens in ``owner``'s account.
463      */
464     function balanceOf(address owner) external view returns (uint256 balance);
465 
466     /**
467      * @dev Returns the owner of the `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function ownerOf(uint256 tokenId) external view returns (address owner);
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes calldata data
493     ) external;
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Approve or remove `operator` as an operator for the caller.
552      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
553      *
554      * Requirements:
555      *
556      * - The `operator` cannot be the caller.
557      *
558      * Emits an {ApprovalForAll} event.
559      */
560     function setApprovalForAll(address operator, bool _approved) external;
561 
562     /**
563      * @dev Returns the account approved for `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function getApproved(uint256 tokenId) external view returns (address operator);
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 }
578 
579 
580 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
581 
582 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @title ERC721 token receiver interface
588  * @dev Interface for any contract that wants to support safeTransfers
589  * from ERC721 asset contracts.
590  */
591 interface IERC721Receiver {
592     /**
593      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
594      * by `operator` from `from`, this function is called.
595      *
596      * It must return its Solidity selector to confirm the token transfer.
597      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
598      *
599      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
600      */
601     function onERC721Received(
602         address operator,
603         address from,
604         uint256 tokenId,
605         bytes calldata data
606     ) external returns (bytes4);
607 }
608 
609 
610 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Implementation of the {IERC165} interface.
618  *
619  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
620  * for the additional interface id that will be supported. For example:
621  *
622  * ```solidity
623  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
624  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
625  * }
626  * ```
627  *
628  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
629  */
630 abstract contract ERC165 is IERC165 {
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
635         return interfaceId == type(IERC165).interfaceId;
636     }
637 }
638 
639 
640 // File erc721b/contracts/ERC721B.sol@v0.2.1
641 
642 
643 pragma solidity ^0.8.0;
644 
645 
646 
647 error InvalidCall();
648 error BalanceQueryZeroAddress();
649 error NonExistentToken();
650 error ApprovalToCurrentOwner();
651 error ApprovalOwnerIsOperator();
652 error NotERC721Receiver();
653 error ERC721ReceiverNotReceived();
654 
655 /**
656  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] 
657  * Non-Fungible Token Standard, including the Metadata extension and 
658  * token Auto-ID generation.
659  *
660  * You must provide `name()` `symbol()` and `tokenURI(uint256 tokenId)`
661  * to conform with IERC721Metadata
662  */
663 abstract contract ERC721B is Context, ERC165, IERC721 {
664 
665   // ============ Storage ============
666 
667   // The last token id minted
668   uint256 private _lastTokenId;
669   // Mapping from token ID to owner address
670   mapping(uint256 => address) internal _owners;
671   // Mapping owner address to token count
672   mapping(address => uint256) internal _balances;
673 
674   // Mapping from token ID to approved address
675   mapping(uint256 => address) private _tokenApprovals;
676   // Mapping from owner to operator approvals
677   mapping(address => mapping(address => bool)) private _operatorApprovals;
678 
679   // ============ Read Methods ============
680 
681   /**
682    * @dev See {IERC721-balanceOf}.
683    */
684   function balanceOf(address owner) 
685     public view virtual override returns(uint256) 
686   {
687     if (owner == address(0)) revert BalanceQueryZeroAddress();
688     return _balances[owner];
689   }
690 
691   /**
692    * @dev Shows the overall amount of tokens generated in the contract
693    */
694   function totalSupply() public view virtual returns(uint256) {
695     return _lastTokenId;
696   }
697 
698   /**
699    * @dev See {IERC721-ownerOf}.
700    */
701   function ownerOf(uint256 tokenId) 
702     public view virtual override returns(address) 
703   {
704     unchecked {
705       //this is the situation when _owners normalized
706       uint256 id = tokenId;
707       if (_owners[id] != address(0)) {
708         return _owners[id];
709       }
710       //this is the situation when _owners is not normalized
711       if (id > 0 && id <= _lastTokenId) {
712         //there will never be a case where token 1 is address(0)
713         while(true) {
714           id--;
715           if (id == 0) {
716             break;
717           } else if (_owners[id] != address(0)) {
718             return _owners[id];
719           }
720         }
721       }
722     }
723 
724     revert NonExistentToken();
725   }
726 
727   /**
728    * @dev See {IERC165-supportsInterface}.
729    */
730   function supportsInterface(bytes4 interfaceId) 
731     public view virtual override(ERC165, IERC165) returns(bool) 
732   {
733     return interfaceId == type(IERC721).interfaceId
734       || super.supportsInterface(interfaceId);
735   }
736 
737   // ============ Approval Methods ============
738 
739   /**
740    * @dev See {IERC721-approve}.
741    */
742   function approve(address to, uint256 tokenId) public virtual override {
743     address owner = ERC721B.ownerOf(tokenId);
744     if (to == owner) revert ApprovalToCurrentOwner();
745 
746     address sender = _msgSender();
747     if (sender != owner && !isApprovedForAll(owner, sender)) 
748       revert ApprovalToCurrentOwner();
749 
750     _approve(to, tokenId, owner);
751   }
752 
753   /**
754    * @dev See {IERC721-getApproved}.
755    */
756   function getApproved(uint256 tokenId) 
757     public view virtual override returns(address) 
758   {
759     if (!_exists(tokenId)) revert NonExistentToken();
760     return _tokenApprovals[tokenId];
761   }
762 
763   /**
764    * @dev See {IERC721-isApprovedForAll}.
765    */
766   function isApprovedForAll(address owner, address operator) 
767     public view virtual override returns (bool) 
768   {
769     return _operatorApprovals[owner][operator];
770   }
771 
772   /**
773    * @dev See {IERC721-setApprovalForAll}.
774    */
775   function setApprovalForAll(address operator, bool approved) 
776     public virtual override 
777   {
778     _setApprovalForAll(_msgSender(), operator, approved);
779   }
780 
781   /**
782    * @dev Approve `to` to operate on `tokenId`
783    *
784    * Emits a {Approval} event.
785    */
786   function _approve(address to, uint256 tokenId, address owner) 
787     internal virtual 
788   {
789     _tokenApprovals[tokenId] = to;
790     emit Approval(owner, to, tokenId);
791   }
792 
793   /**
794    * @dev transfers token considering approvals
795    */
796   function _approveTransfer(
797     address spender, 
798     address from, 
799     address to, 
800     uint256 tokenId
801   ) internal virtual {
802     if (!_isApprovedOrOwner(spender, tokenId, from)) 
803       revert InvalidCall();
804 
805     _transfer(from, to, tokenId);
806   }
807 
808   /**
809    * @dev Safely transfers token considering approvals
810    */
811   function _approveSafeTransfer(
812     address from,
813     address to,
814     uint256 tokenId,
815     bytes memory _data
816   ) internal virtual {
817     _approveTransfer(_msgSender(), from, to, tokenId);
818     //see: @openzep/utils/Address.sol
819     if (to.code.length > 0
820       && !_checkOnERC721Received(from, to, tokenId, _data)
821     ) revert ERC721ReceiverNotReceived();
822   }
823 
824   /**
825    * @dev Returns whether `spender` is allowed to manage `tokenId`.
826    *
827    * Requirements:
828    *
829    * - `tokenId` must exist.
830    */
831   function _isApprovedOrOwner(
832     address spender, 
833     uint256 tokenId, 
834     address owner
835   ) internal view virtual returns(bool) {
836     return spender == owner 
837       || getApproved(tokenId) == spender 
838       || isApprovedForAll(owner, spender);
839   }
840 
841   /**
842    * @dev Approve `operator` to operate on all of `owner` tokens
843    *
844    * Emits a {ApprovalForAll} event.
845    */
846   function _setApprovalForAll(
847     address owner,
848     address operator,
849     bool approved
850   ) internal virtual {
851     if (owner == operator) revert ApprovalOwnerIsOperator();
852     _operatorApprovals[owner][operator] = approved;
853     emit ApprovalForAll(owner, operator, approved);
854   }
855 
856   // ============ Mint Methods ============
857 
858   /**
859    * @dev Mints `tokenId` and transfers it to `to`.
860    *
861    * WARNING: Usage of this method is discouraged, use {_safeMint} 
862    * whenever possible
863    *
864    * Requirements:
865    *
866    * - `tokenId` must not exist.
867    * - `to` cannot be the zero address.
868    *
869    * Emits a {Transfer} event.
870    */
871   function _mint(
872     address to,
873     uint256 amount,
874     bytes memory _data,
875     bool safeCheck
876   ) private {
877     if(amount == 0 || to == address(0)) revert InvalidCall();
878     uint256 startTokenId = _lastTokenId + 1;
879     
880     _beforeTokenTransfers(address(0), to, startTokenId, amount);
881     
882     unchecked {
883       _lastTokenId += amount;
884       _balances[to] += amount;
885       _owners[startTokenId] = to;
886 
887       _afterTokenTransfers(address(0), to, startTokenId, amount);
888 
889       uint256 updatedIndex = startTokenId;
890       uint256 endIndex = updatedIndex + amount;
891       //if do safe check and,
892       //check if contract one time (instead of loop)
893       //see: @openzep/utils/Address.sol
894       if (safeCheck && to.code.length > 0) {
895         //loop emit transfer and received check
896         do {
897           emit Transfer(address(0), to, updatedIndex);
898           if (!_checkOnERC721Received(address(0), to, updatedIndex++, _data))
899             revert ERC721ReceiverNotReceived();
900         } while (updatedIndex != endIndex);
901         return;
902       }
903 
904       do {
905         emit Transfer(address(0), to, updatedIndex++);
906       } while (updatedIndex != endIndex);
907     }
908   }
909 
910   /**
911    * @dev Safely mints `tokenId` and transfers it to `to`.
912    *
913    * Requirements:
914    *
915    * - `tokenId` must not exist.
916    * - If `to` refers to a smart contract, it must implement 
917    *   {IERC721Receiver-onERC721Received}, which is called upon a 
918    *   safe transfer.
919    *
920    * Emits a {Transfer} event.
921    */
922   function _safeMint(address to, uint256 amount) internal virtual {
923     _safeMint(to, amount, "");
924   }
925 
926   /**
927    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], 
928    * with an additional `data` parameter which is forwarded in 
929    * {IERC721Receiver-onERC721Received} to contract recipients.
930    */
931   function _safeMint(
932     address to,
933     uint256 amount,
934     bytes memory _data
935   ) internal virtual {
936     _mint(to, amount, _data, true);
937   }
938 
939   // ============ Transfer Methods ============
940 
941   /**
942    * @dev See {IERC721-transferFrom}.
943    */
944   function transferFrom(
945     address from,
946     address to,
947     uint256 tokenId
948   ) public virtual override {
949     _approveTransfer(_msgSender(), from, to, tokenId);
950   }
951 
952   /**
953    * @dev See {IERC721-safeTransferFrom}.
954    */
955   function safeTransferFrom(
956     address from,
957     address to,
958     uint256 tokenId
959   ) public virtual override {
960     safeTransferFrom(from, to, tokenId, "");
961   }
962 
963   /**
964    * @dev See {IERC721-safeTransferFrom}.
965    */
966   function safeTransferFrom(
967     address from,
968     address to,
969     uint256 tokenId,
970     bytes memory _data
971   ) public virtual override {
972     _approveSafeTransfer(from, to, tokenId, _data);
973   }
974 
975   /**
976    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} 
977    * on a target address. The call is not executed if the target address 
978    * is not a contract.
979    */
980   function _checkOnERC721Received(
981     address from,
982     address to,
983     uint256 tokenId,
984     bytes memory _data
985   ) private returns (bool) {
986     try IERC721Receiver(to).onERC721Received(
987       _msgSender(), from, tokenId, _data
988     ) returns (bytes4 retval) {
989       return retval == IERC721Receiver.onERC721Received.selector;
990     } catch (bytes memory reason) {
991       if (reason.length == 0) {
992         revert NotERC721Receiver();
993       } else {
994         assembly {
995           revert(add(32, reason), mload(reason))
996         }
997       }
998     }
999   }
1000 
1001   /**
1002    * @dev Returns whether `tokenId` exists.
1003    *
1004    * Tokens can be managed by their owner or approved accounts via 
1005    * {approve} or {setApprovalForAll}.
1006    *
1007    * Tokens start existing when they are minted (`_mint`),
1008    * and stop existing when they are burned (`_burn`).
1009    */
1010   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1011     return tokenId > 0 && tokenId <= _lastTokenId;
1012   }
1013 
1014   /**
1015    * @dev Safely transfers `tokenId` token from `from` to `to`, checking 
1016    * first that contract recipients are aware of the ERC721 protocol to 
1017    * prevent tokens from being forever locked.
1018    *
1019    * `_data` is additional data, it has no specified format and it is 
1020    * sent in call to `to`.
1021    *
1022    * This internal function is equivalent to {safeTransferFrom}, and can 
1023    * be used to e.g.
1024    * implement alternative mechanisms to perform token transfer, such as 
1025    * signature-based.
1026    *
1027    * Requirements:
1028    *
1029    * - `from` cannot be the zero address.
1030    * - `to` cannot be the zero address.
1031    * - `tokenId` token must exist and be owned by `from`.
1032    * - If `to` refers to a smart contract, it must implement 
1033    *   {IERC721Receiver-onERC721Received}, which is called upon a 
1034    *   safe transfer.
1035    *
1036    * Emits a {Transfer} event.
1037    */
1038   function _safeTransfer(
1039     address from,
1040     address to,
1041     uint256 tokenId,
1042     bytes memory _data
1043   ) internal virtual {
1044     _transfer(from, to, tokenId);
1045     //see: @openzep/utils/Address.sol
1046     if (to.code.length > 0
1047       && !_checkOnERC721Received(from, to, tokenId, _data)
1048     ) revert ERC721ReceiverNotReceived();
1049   }
1050 
1051   /**
1052    * @dev Transfers `tokenId` from `from` to `to`. As opposed to 
1053    * {transferFrom}, this imposes no restrictions on msg.sender.
1054    *
1055    * Requirements:
1056    *
1057    * - `to` cannot be the zero address.
1058    * - `tokenId` token must be owned by `from`.
1059    *
1060    * Emits a {Transfer} event.
1061    */
1062   function _transfer(address from, address to, uint256 tokenId) private {
1063     //if transfer to null or not the owner
1064     if (to == address(0) || from != ERC721B.ownerOf(tokenId)) 
1065       revert InvalidCall();
1066 
1067     _beforeTokenTransfers(from, to, tokenId, 1);
1068     
1069     // Clear approvals from the previous owner
1070     _approve(address(0), tokenId, from);
1071 
1072     unchecked {
1073       //this is the situation when _owners are normalized
1074       _balances[to] += 1;
1075       _balances[from] -= 1;
1076       _owners[tokenId] = to;
1077       //this is the situation when _owners are not normalized
1078       uint256 nextTokenId = tokenId + 1;
1079       if (nextTokenId <= _lastTokenId && _owners[nextTokenId] == address(0)) {
1080         _owners[nextTokenId] = from;
1081       }
1082     }
1083 
1084     _afterTokenTransfers(from, to, tokenId, 1);
1085     emit Transfer(from, to, tokenId);
1086   }
1087 
1088   // ============ TODO Methods ============
1089 
1090   /**
1091    * @dev Hook that is called before a set of serially-ordered token ids 
1092    * are about to be transferred. This includes minting.
1093    *
1094    * startTokenId - the first token id to be transferred
1095    * amount - the amount to be transferred
1096    *
1097    * Calling conditions:
1098    *
1099    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` 
1100    *   will be transferred to `to`.
1101    * - When `from` is zero, `tokenId` will be minted for `to`.
1102    */
1103   function _beforeTokenTransfers(
1104     address from,
1105     address to,
1106     uint256 startTokenId,
1107     uint256 amount
1108   ) internal virtual {}
1109 
1110   /**
1111    * @dev Hook that is called after a set of serially-ordered token ids 
1112    * have been transferred. This includes minting.
1113    *
1114    * startTokenId - the first token id to be transferred
1115    * amount - the amount to be transferred
1116    *
1117    * Calling conditions:
1118    *
1119    * - when `from` and `to` are both non-zero.
1120    * - `from` and `to` are never both zero.
1121    */
1122   function _afterTokenTransfers(
1123     address from,
1124     address to,
1125     uint256 startTokenId,
1126     uint256 amount
1127   ) internal virtual {}
1128 }
1129 
1130 
1131 // File erc721b/contracts/extensions/ERC721BBurnable.sol@v0.2.1
1132 
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 
1137 /**
1138  * @title ERC721B Burnable Token
1139  * @dev ERC721B Token that can be irreversibly burned (destroyed).
1140  */
1141 abstract contract ERC721BBurnable is Context, ERC721B {
1142 
1143   // ============ Storage ============
1144 
1145   //mapping of token id to burned?
1146   mapping(uint256 => bool) private _burned;
1147   //count of how many burned
1148   uint256 private _totalBurned;
1149 
1150   // ============ Read Methods ============
1151 
1152   /**
1153    * @dev See {IERC721-ownerOf}.
1154    */
1155   function ownerOf(uint256 tokenId) 
1156     public view virtual override returns(address) 
1157   {
1158     if (_burned[tokenId]) revert NonExistentToken();
1159     return super.ownerOf(tokenId);
1160   }
1161 
1162   /**
1163    * @dev Shows the overall amount of tokens generated in the contract
1164    */
1165   function totalSupply() public virtual view override returns(uint256) {
1166     return super.totalSupply() - _totalBurned;
1167   }
1168 
1169   // ============ Write Methods ============
1170 
1171   /**
1172    * @dev Burns `tokenId`. See {ERC721B-_burn}.
1173    *
1174    * Requirements:
1175    *
1176    * - The caller must own `tokenId` or be an approved operator.
1177    */
1178   function burn(uint256 tokenId) public virtual {
1179     address owner = ERC721B.ownerOf(tokenId);
1180     if (!_isApprovedOrOwner(_msgSender(), tokenId, owner)) 
1181       revert InvalidCall();
1182 
1183     _beforeTokenTransfers(owner, address(0), tokenId, 1);
1184     
1185     // Clear approvals
1186     _approve(address(0), tokenId, owner);
1187 
1188     unchecked {
1189       //this is the situation when _owners are normalized
1190       _balances[owner] -= 1;
1191       _burned[tokenId] = true;
1192       _owners[tokenId] = address(0);
1193       _totalBurned++;
1194 
1195       //this is the situation when _owners are not normalized
1196       uint256 nextTokenId = tokenId + 1;
1197       if (nextTokenId <= totalSupply() && _owners[nextTokenId] == address(0)) {
1198         _owners[nextTokenId] = owner;
1199       }
1200     }
1201 
1202     _afterTokenTransfers(owner, address(0), tokenId, 1);
1203 
1204     emit Transfer(owner, address(0), tokenId);
1205   }
1206 
1207   // ============ Internal Methods ============
1208 
1209   /**
1210    * @dev Returns whether `tokenId` exists.
1211    *
1212    * Tokens can be managed by their owner or approved accounts via 
1213    * {approve} or {setApprovalForAll}.
1214    *
1215    * Tokens start existing when they are minted (`_mint`),
1216    * and stop existing when they are burned (`_burn`).
1217    */
1218   function _exists(uint256 tokenId) 
1219     internal view virtual override returns(bool) 
1220   {
1221     return !_burned[tokenId] && super._exists(tokenId);
1222   }
1223 }
1224 
1225 
1226 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.6.0
1227 
1228 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 /**
1233  * @dev External interface of AccessControl declared to support ERC165 detection.
1234  */
1235 interface IAccessControl {
1236     /**
1237      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1238      *
1239      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1240      * {RoleAdminChanged} not being emitted signaling this.
1241      *
1242      * _Available since v3.1._
1243      */
1244     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1245 
1246     /**
1247      * @dev Emitted when `account` is granted `role`.
1248      *
1249      * `sender` is the account that originated the contract call, an admin role
1250      * bearer except when using {AccessControl-_setupRole}.
1251      */
1252     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1253 
1254     /**
1255      * @dev Emitted when `account` is revoked `role`.
1256      *
1257      * `sender` is the account that originated the contract call:
1258      *   - if using `revokeRole`, it is the admin role bearer
1259      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1260      */
1261     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1262 
1263     /**
1264      * @dev Returns `true` if `account` has been granted `role`.
1265      */
1266     function hasRole(bytes32 role, address account) external view returns (bool);
1267 
1268     /**
1269      * @dev Returns the admin role that controls `role`. See {grantRole} and
1270      * {revokeRole}.
1271      *
1272      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1273      */
1274     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1275 
1276     /**
1277      * @dev Grants `role` to `account`.
1278      *
1279      * If `account` had not been already granted `role`, emits a {RoleGranted}
1280      * event.
1281      *
1282      * Requirements:
1283      *
1284      * - the caller must have ``role``'s admin role.
1285      */
1286     function grantRole(bytes32 role, address account) external;
1287 
1288     /**
1289      * @dev Revokes `role` from `account`.
1290      *
1291      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1292      *
1293      * Requirements:
1294      *
1295      * - the caller must have ``role``'s admin role.
1296      */
1297     function revokeRole(bytes32 role, address account) external;
1298 
1299     /**
1300      * @dev Revokes `role` from the calling account.
1301      *
1302      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1303      * purpose is to provide a mechanism for accounts to lose their privileges
1304      * if they are compromised (such as when a trusted device is misplaced).
1305      *
1306      * If the calling account had been granted `role`, emits a {RoleRevoked}
1307      * event.
1308      *
1309      * Requirements:
1310      *
1311      * - the caller must be `account`.
1312      */
1313     function renounceRole(bytes32 role, address account) external;
1314 }
1315 
1316 
1317 // File @openzeppelin/contracts/access/AccessControl.sol@v4.6.0
1318 
1319 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 
1325 
1326 /**
1327  * @dev Contract module that allows children to implement role-based access
1328  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1329  * members except through off-chain means by accessing the contract event logs. Some
1330  * applications may benefit from on-chain enumerability, for those cases see
1331  * {AccessControlEnumerable}.
1332  *
1333  * Roles are referred to by their `bytes32` identifier. These should be exposed
1334  * in the external API and be unique. The best way to achieve this is by
1335  * using `public constant` hash digests:
1336  *
1337  * ```
1338  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1339  * ```
1340  *
1341  * Roles can be used to represent a set of permissions. To restrict access to a
1342  * function call, use {hasRole}:
1343  *
1344  * ```
1345  * function foo() public {
1346  *     require(hasRole(MY_ROLE, msg.sender));
1347  *     ...
1348  * }
1349  * ```
1350  *
1351  * Roles can be granted and revoked dynamically via the {grantRole} and
1352  * {revokeRole} functions. Each role has an associated admin role, and only
1353  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1354  *
1355  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1356  * that only accounts with this role will be able to grant or revoke other
1357  * roles. More complex role relationships can be created by using
1358  * {_setRoleAdmin}.
1359  *
1360  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1361  * grant and revoke this role. Extra precautions should be taken to secure
1362  * accounts that have been granted it.
1363  */
1364 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1365     struct RoleData {
1366         mapping(address => bool) members;
1367         bytes32 adminRole;
1368     }
1369 
1370     mapping(bytes32 => RoleData) private _roles;
1371 
1372     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1373 
1374     /**
1375      * @dev Modifier that checks that an account has a specific role. Reverts
1376      * with a standardized message including the required role.
1377      *
1378      * The format of the revert reason is given by the following regular expression:
1379      *
1380      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1381      *
1382      * _Available since v4.1._
1383      */
1384     modifier onlyRole(bytes32 role) {
1385         _checkRole(role);
1386         _;
1387     }
1388 
1389     /**
1390      * @dev See {IERC165-supportsInterface}.
1391      */
1392     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1393         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1394     }
1395 
1396     /**
1397      * @dev Returns `true` if `account` has been granted `role`.
1398      */
1399     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1400         return _roles[role].members[account];
1401     }
1402 
1403     /**
1404      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1405      * Overriding this function changes the behavior of the {onlyRole} modifier.
1406      *
1407      * Format of the revert message is described in {_checkRole}.
1408      *
1409      * _Available since v4.6._
1410      */
1411     function _checkRole(bytes32 role) internal view virtual {
1412         _checkRole(role, _msgSender());
1413     }
1414 
1415     /**
1416      * @dev Revert with a standard message if `account` is missing `role`.
1417      *
1418      * The format of the revert reason is given by the following regular expression:
1419      *
1420      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1421      */
1422     function _checkRole(bytes32 role, address account) internal view virtual {
1423         if (!hasRole(role, account)) {
1424             revert(
1425                 string(
1426                     abi.encodePacked(
1427                         "AccessControl: account ",
1428                         Strings.toHexString(uint160(account), 20),
1429                         " is missing role ",
1430                         Strings.toHexString(uint256(role), 32)
1431                     )
1432                 )
1433             );
1434         }
1435     }
1436 
1437     /**
1438      * @dev Returns the admin role that controls `role`. See {grantRole} and
1439      * {revokeRole}.
1440      *
1441      * To change a role's admin, use {_setRoleAdmin}.
1442      */
1443     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1444         return _roles[role].adminRole;
1445     }
1446 
1447     /**
1448      * @dev Grants `role` to `account`.
1449      *
1450      * If `account` had not been already granted `role`, emits a {RoleGranted}
1451      * event.
1452      *
1453      * Requirements:
1454      *
1455      * - the caller must have ``role``'s admin role.
1456      */
1457     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1458         _grantRole(role, account);
1459     }
1460 
1461     /**
1462      * @dev Revokes `role` from `account`.
1463      *
1464      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1465      *
1466      * Requirements:
1467      *
1468      * - the caller must have ``role``'s admin role.
1469      */
1470     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1471         _revokeRole(role, account);
1472     }
1473 
1474     /**
1475      * @dev Revokes `role` from the calling account.
1476      *
1477      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1478      * purpose is to provide a mechanism for accounts to lose their privileges
1479      * if they are compromised (such as when a trusted device is misplaced).
1480      *
1481      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1482      * event.
1483      *
1484      * Requirements:
1485      *
1486      * - the caller must be `account`.
1487      */
1488     function renounceRole(bytes32 role, address account) public virtual override {
1489         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1490 
1491         _revokeRole(role, account);
1492     }
1493 
1494     /**
1495      * @dev Grants `role` to `account`.
1496      *
1497      * If `account` had not been already granted `role`, emits a {RoleGranted}
1498      * event. Note that unlike {grantRole}, this function doesn't perform any
1499      * checks on the calling account.
1500      *
1501      * [WARNING]
1502      * ====
1503      * This function should only be called from the constructor when setting
1504      * up the initial roles for the system.
1505      *
1506      * Using this function in any other way is effectively circumventing the admin
1507      * system imposed by {AccessControl}.
1508      * ====
1509      *
1510      * NOTE: This function is deprecated in favor of {_grantRole}.
1511      */
1512     function _setupRole(bytes32 role, address account) internal virtual {
1513         _grantRole(role, account);
1514     }
1515 
1516     /**
1517      * @dev Sets `adminRole` as ``role``'s admin role.
1518      *
1519      * Emits a {RoleAdminChanged} event.
1520      */
1521     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1522         bytes32 previousAdminRole = getRoleAdmin(role);
1523         _roles[role].adminRole = adminRole;
1524         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1525     }
1526 
1527     /**
1528      * @dev Grants `role` to `account`.
1529      *
1530      * Internal function without access restriction.
1531      */
1532     function _grantRole(bytes32 role, address account) internal virtual {
1533         if (!hasRole(role, account)) {
1534             _roles[role].members[account] = true;
1535             emit RoleGranted(role, account, _msgSender());
1536         }
1537     }
1538 
1539     /**
1540      * @dev Revokes `role` from `account`.
1541      *
1542      * Internal function without access restriction.
1543      */
1544     function _revokeRole(bytes32 role, address account) internal virtual {
1545         if (hasRole(role, account)) {
1546             _roles[role].members[account] = false;
1547             emit RoleRevoked(role, account, _msgSender());
1548         }
1549     }
1550 }
1551 
1552 
1553 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
1554 
1555 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1556 
1557 pragma solidity ^0.8.1;
1558 
1559 /**
1560  * @dev Collection of functions related to the address type
1561  */
1562 library Address {
1563     /**
1564      * @dev Returns true if `account` is a contract.
1565      *
1566      * [IMPORTANT]
1567      * ====
1568      * It is unsafe to assume that an address for which this function returns
1569      * false is an externally-owned account (EOA) and not a contract.
1570      *
1571      * Among others, `isContract` will return false for the following
1572      * types of addresses:
1573      *
1574      *  - an externally-owned account
1575      *  - a contract in construction
1576      *  - an address where a contract will be created
1577      *  - an address where a contract lived, but was destroyed
1578      * ====
1579      *
1580      * [IMPORTANT]
1581      * ====
1582      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1583      *
1584      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1585      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1586      * constructor.
1587      * ====
1588      */
1589     function isContract(address account) internal view returns (bool) {
1590         // This method relies on extcodesize/address.code.length, which returns 0
1591         // for contracts in construction, since the code is only stored at the end
1592         // of the constructor execution.
1593 
1594         return account.code.length > 0;
1595     }
1596 
1597     /**
1598      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1599      * `recipient`, forwarding all available gas and reverting on errors.
1600      *
1601      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1602      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1603      * imposed by `transfer`, making them unable to receive funds via
1604      * `transfer`. {sendValue} removes this limitation.
1605      *
1606      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1607      *
1608      * IMPORTANT: because control is transferred to `recipient`, care must be
1609      * taken to not create reentrancy vulnerabilities. Consider using
1610      * {ReentrancyGuard} or the
1611      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1612      */
1613     function sendValue(address payable recipient, uint256 amount) internal {
1614         require(address(this).balance >= amount, "Address: insufficient balance");
1615 
1616         (bool success, ) = recipient.call{value: amount}("");
1617         require(success, "Address: unable to send value, recipient may have reverted");
1618     }
1619 
1620     /**
1621      * @dev Performs a Solidity function call using a low level `call`. A
1622      * plain `call` is an unsafe replacement for a function call: use this
1623      * function instead.
1624      *
1625      * If `target` reverts with a revert reason, it is bubbled up by this
1626      * function (like regular Solidity function calls).
1627      *
1628      * Returns the raw returned data. To convert to the expected return value,
1629      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1630      *
1631      * Requirements:
1632      *
1633      * - `target` must be a contract.
1634      * - calling `target` with `data` must not revert.
1635      *
1636      * _Available since v3.1._
1637      */
1638     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1639         return functionCall(target, data, "Address: low-level call failed");
1640     }
1641 
1642     /**
1643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1644      * `errorMessage` as a fallback revert reason when `target` reverts.
1645      *
1646      * _Available since v3.1._
1647      */
1648     function functionCall(
1649         address target,
1650         bytes memory data,
1651         string memory errorMessage
1652     ) internal returns (bytes memory) {
1653         return functionCallWithValue(target, data, 0, errorMessage);
1654     }
1655 
1656     /**
1657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1658      * but also transferring `value` wei to `target`.
1659      *
1660      * Requirements:
1661      *
1662      * - the calling contract must have an ETH balance of at least `value`.
1663      * - the called Solidity function must be `payable`.
1664      *
1665      * _Available since v3.1._
1666      */
1667     function functionCallWithValue(
1668         address target,
1669         bytes memory data,
1670         uint256 value
1671     ) internal returns (bytes memory) {
1672         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1673     }
1674 
1675     /**
1676      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1677      * with `errorMessage` as a fallback revert reason when `target` reverts.
1678      *
1679      * _Available since v3.1._
1680      */
1681     function functionCallWithValue(
1682         address target,
1683         bytes memory data,
1684         uint256 value,
1685         string memory errorMessage
1686     ) internal returns (bytes memory) {
1687         require(address(this).balance >= value, "Address: insufficient balance for call");
1688         require(isContract(target), "Address: call to non-contract");
1689 
1690         (bool success, bytes memory returndata) = target.call{value: value}(data);
1691         return verifyCallResult(success, returndata, errorMessage);
1692     }
1693 
1694     /**
1695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1696      * but performing a static call.
1697      *
1698      * _Available since v3.3._
1699      */
1700     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1701         return functionStaticCall(target, data, "Address: low-level static call failed");
1702     }
1703 
1704     /**
1705      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1706      * but performing a static call.
1707      *
1708      * _Available since v3.3._
1709      */
1710     function functionStaticCall(
1711         address target,
1712         bytes memory data,
1713         string memory errorMessage
1714     ) internal view returns (bytes memory) {
1715         require(isContract(target), "Address: static call to non-contract");
1716 
1717         (bool success, bytes memory returndata) = target.staticcall(data);
1718         return verifyCallResult(success, returndata, errorMessage);
1719     }
1720 
1721     /**
1722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1723      * but performing a delegate call.
1724      *
1725      * _Available since v3.4._
1726      */
1727     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1728         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1729     }
1730 
1731     /**
1732      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1733      * but performing a delegate call.
1734      *
1735      * _Available since v3.4._
1736      */
1737     function functionDelegateCall(
1738         address target,
1739         bytes memory data,
1740         string memory errorMessage
1741     ) internal returns (bytes memory) {
1742         require(isContract(target), "Address: delegate call to non-contract");
1743 
1744         (bool success, bytes memory returndata) = target.delegatecall(data);
1745         return verifyCallResult(success, returndata, errorMessage);
1746     }
1747 
1748     /**
1749      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1750      * revert reason using the provided one.
1751      *
1752      * _Available since v4.3._
1753      */
1754     function verifyCallResult(
1755         bool success,
1756         bytes memory returndata,
1757         string memory errorMessage
1758     ) internal pure returns (bytes memory) {
1759         if (success) {
1760             return returndata;
1761         } else {
1762             // Look for revert reason and bubble it up if present
1763             if (returndata.length > 0) {
1764                 // The easiest way to bubble the revert reason is using memory via assembly
1765 
1766                 assembly {
1767                     let returndata_size := mload(returndata)
1768                     revert(add(32, returndata), returndata_size)
1769                 }
1770             } else {
1771                 revert(errorMessage);
1772             }
1773         }
1774     }
1775 }
1776 
1777 
1778 // File contracts/lib/PaymentSplitter/PaymentSplitterConnector.sol
1779 
1780 pragma solidity ^0.8.4;
1781 
1782 
1783 error NotSplitterAdmin();
1784 error NotDefaultAdmin();
1785 error IncorrectAdmin();
1786 
1787 contract PaymentSplitterConnector is AccessControl {
1788 
1789     address public PAYMENT_SPLITTER_ADDRESS;
1790     address public PAYMENT_DEFAULT_ADMIN;
1791     address public SPLITTER_ADMIN;
1792     bytes32 private constant SPLITTER_ADMIN_ROLE = keccak256("SPLITTER_ADMIN");
1793 
1794     constructor(address admin, address splitterAddress) {
1795         _setupRole(DEFAULT_ADMIN_ROLE, admin);
1796         _setupRole(SPLITTER_ADMIN_ROLE, admin);
1797         
1798         SPLITTER_ADMIN = admin;
1799         PAYMENT_DEFAULT_ADMIN = admin;
1800         PAYMENT_SPLITTER_ADDRESS = splitterAddress;
1801     }
1802 
1803     modifier onlySplitterAdmin {
1804         if (!hasRole(SPLITTER_ADMIN_ROLE, msg.sender)) {
1805             revert NotSplitterAdmin();
1806         }
1807         _;
1808     }
1809 
1810     modifier onlyDefaultAdmin {
1811         if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
1812             revert NotDefaultAdmin();
1813         }
1814         _;
1815     }
1816 
1817     function setSplitterAddress(address _splitterAddress) public onlySplitterAdmin {
1818         PAYMENT_SPLITTER_ADDRESS = _splitterAddress;
1819     }
1820 
1821     function withdraw() public onlySplitterAdmin{
1822         address payable recipient = payable(PAYMENT_SPLITTER_ADDRESS);
1823         uint256 balance = address(this).balance;
1824         
1825         Address.sendValue(recipient, balance);
1826     }
1827 
1828     function transferSplitterAdminRole(address admin) public onlyDefaultAdmin{
1829         if (SPLITTER_ADMIN == admin) {
1830             revert IncorrectAdmin();
1831         }
1832 
1833         grantRole(SPLITTER_ADMIN_ROLE, admin);
1834         revokeRole(SPLITTER_ADMIN_ROLE, SPLITTER_ADMIN);
1835         SPLITTER_ADMIN = admin;
1836     }
1837 
1838     function transferDefaultAdminRole(address admin) public onlyDefaultAdmin{
1839         if (PAYMENT_DEFAULT_ADMIN == admin) {
1840             revert IncorrectAdmin();
1841         }
1842 
1843         grantRole(DEFAULT_ADMIN_ROLE, admin);
1844         revokeRole(DEFAULT_ADMIN_ROLE, PAYMENT_DEFAULT_ADMIN);
1845         PAYMENT_DEFAULT_ADMIN = admin;
1846     }
1847 }
1848 
1849 
1850 // File contracts/PunkdApes.sol
1851 
1852 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1853 
1854 pragma solidity ^0.8.4;
1855 
1856 
1857 
1858 error ArrayLengthsNotEqual();
1859 error BatchLimitExceeded();
1860 error InvalidToken();
1861 error PaymentNotEnough();
1862 error RateNotSet();
1863 error TotalSupplyLimitExceeded();
1864 error WalletLimitExceeded();
1865 
1866 contract PunkdApes is ERC721BBurnable, Ownable, PaymentSplitterConnector {
1867     using Strings for uint256;
1868     using SafeMath for uint256;
1869 
1870     string public name;
1871     string public symbol;
1872 
1873     uint public constant TOTAL_SUPPLY_LIMIT = 10000;
1874     uint public constant WALLET_LIMIT = 69;
1875     uint public constant BATCH_LIMIT = 20;
1876     uint public purchaseRate = 0.0069 ether;
1877 
1878     string public baseURI = "";
1879     string public baseExtension = ".json";
1880 
1881     mapping(address => uint) public wallet;
1882 
1883     constructor(address admin, address splitterAddress) 
1884         PaymentSplitterConnector(admin, splitterAddress)
1885     {
1886         name = "PUNKD APES";
1887         symbol = "GETPUNKD";
1888     }
1889 
1890     function setPurchaseRate(uint256 _rate) public onlyOwner {
1891         purchaseRate = _rate;
1892     }
1893 
1894     function mint(uint256 _quantity) public payable {
1895         uint walletQty = wallet[msg.sender] + _quantity;
1896         uint256 totalSupply = totalSupply() + _quantity;
1897         uint256 requiredPaymentAmout = purchaseRate * _quantity;
1898         uint256 payment = msg.value;
1899 
1900         if (purchaseRate == 0) revert RateNotSet();
1901         if (payment < requiredPaymentAmout) revert PaymentNotEnough();
1902 
1903         if (totalSupply > TOTAL_SUPPLY_LIMIT)
1904             revert TotalSupplyLimitExceeded();
1905 
1906         if (_quantity > WALLET_LIMIT || walletQty > WALLET_LIMIT)
1907             revert WalletLimitExceeded();
1908 
1909         _safeMint(msg.sender, _quantity, "");
1910         wallet[msg.sender] = walletQty;
1911     }
1912 
1913     function getWallet(address a) public view returns(uint) {
1914         return wallet[a];
1915     }
1916 
1917     function batchAirdrop(address[] calldata _recipients, uint[] calldata _amounts) public onlyOwner {
1918         if (_recipients.length > BATCH_LIMIT)
1919             revert BatchLimitExceeded();
1920 
1921         if (_recipients.length != _amounts.length)
1922             revert ArrayLengthsNotEqual();
1923 
1924         uint256 totalSupply = totalSupply();
1925 
1926         for (uint i = 0; i < _recipients.length; ++i) {
1927             address recipient = _recipients[i];
1928             uint256 amount = _amounts[i];
1929 
1930             totalSupply += amount;
1931 
1932             if (totalSupply > TOTAL_SUPPLY_LIMIT)
1933             revert TotalSupplyLimitExceeded();
1934 
1935             _safeMint(recipient, amount, "");
1936         }
1937     }
1938 
1939     // payment splitter connector override method
1940     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721B, AccessControl) returns (bool) {
1941         return super.supportsInterface(interfaceId);
1942     }
1943 
1944     // token URI
1945     function tokenURI(uint _tokenId) public view returns (string memory) {
1946         if (_tokenId < 0)
1947             revert InvalidToken();
1948             
1949         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _tokenId.toString(), baseExtension)) : baseURI;
1950     }
1951 
1952     function setBaseURI(string calldata _baseURI) public onlyOwner{
1953         baseURI = _baseURI;
1954     }
1955 
1956     function setBaseExtension(string calldata _newBaseExtension) public onlyOwner{
1957         baseExtension = _newBaseExtension;
1958     }
1959 }