1 //   _                             _                     _         
2 //  | |                           | |                   | |        
3 //  | |     __ _ _ ____   ____ _  | |     __ _ _ __ ___ | |__  ___ 
4 //  | |    / _` | '__\ \ / / _` | | |    / _` | '_ ` _ \| '_ \/ __|
5 //  | |___| (_| | |   \ V / (_| | | |___| (_| | | | | | | |_) \__ \
6 //  |______\__,_|_|    \_/ \__,_| |______\__,_|_| |_| |_|_.__/|___/
7                                                                 
8 // https://larvalambs.com/
9 // Larva Lambs Smart Contract                                                              
10 
11 // IERC165.sol
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 // ERC165.sol
38 
39 
40 pragma solidity ^0.8.0;
41 
42 
43 /**
44  * @dev Implementation of the {IERC165} interface.
45  *
46  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
47  * for the additional interface id that will be supported. For example:
48  *
49  * ```solidity
50  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
51  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
52  * }
53  * ```
54  *
55  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
56  */
57 abstract contract ERC165 is IERC165 {
58     /**
59      * @dev See {IERC165-supportsInterface}.
60      */
61     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
62         return interfaceId == type(IERC165).interfaceId;
63     }
64 }
65 
66 // IERC721.sol
67 
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Required interface of an ERC721 compliant contract.
73  */
74 interface IERC721 is IERC165 {
75     /**
76      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
82      */
83     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
84 
85     /**
86      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
87      */
88     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
89 
90     /**
91      * @dev Returns the number of tokens in ``owner``'s account.
92      */
93     function balanceOf(address owner) external view returns (uint256 balance);
94 
95     /**
96      * @dev Returns the owner of the `tokenId` token.
97      *
98      * Requirements:
99      *
100      * - `tokenId` must exist.
101      */
102     function ownerOf(uint256 tokenId) external view returns (address owner);
103 
104     /**
105      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
106      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must exist and be owned by `from`.
113      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
115      *
116      * Emits a {Transfer} event.
117      */
118     function safeTransferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Transfers `tokenId` token from `from` to `to`.
126      *
127      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
128      *
129      * Requirements:
130      *
131      * - `from` cannot be the zero address.
132      * - `to` cannot be the zero address.
133      * - `tokenId` token must be owned by `from`.
134      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address from,
140         address to,
141         uint256 tokenId
142     ) external;
143 
144     /**
145      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
146      * The approval is cleared when the token is transferred.
147      *
148      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
149      *
150      * Requirements:
151      *
152      * - The caller must own the token or be an approved operator.
153      * - `tokenId` must exist.
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address to, uint256 tokenId) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179 
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator) external view returns (bool);
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId,
204         bytes calldata data
205     ) external;
206 }
207 
208 
209 // IERC721Metadata.sol
210 
211 
212 pragma solidity ^0.8.0;
213 
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 // IERC721Receiver.sol
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  * from ERC721 asset contracts.
245  */
246 interface IERC721Receiver {
247     /**
248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
249      * by `operator` from `from`, this function is called.
250      *
251      * It must return its Solidity selector to confirm the token transfer.
252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
253      *
254      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
255      */
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 
265 
266 // IERC721Enumerable.sol
267 
268 
269 pragma solidity ^0.8.0;
270 
271 
272 /**
273  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
274  * @dev See https://eips.ethereum.org/EIPS/eip-721
275  */
276 interface IERC721Enumerable is IERC721 {
277     /**
278      * @dev Returns the total amount of tokens stored by the contract.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
284      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
285      */
286     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
287 
288     /**
289      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
290      * Use along with {totalSupply} to enumerate all tokens.
291      */
292     function tokenByIndex(uint256 index) external view returns (uint256);
293 }
294 
295 
296 // Context.sol
297 
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes calldata) {
317         return msg.data;
318     }
319 }
320 
321 // ERC721S.sol
322 
323 pragma solidity ^0.8.10;
324 
325 
326 abstract contract ERC721S is Context, ERC165, IERC721, IERC721Metadata {
327     using Address for address;
328     string private _name;
329     string private _symbol;
330     address[] internal _owners;
331     mapping(uint256 => address) private _tokenApprovals;
332     mapping(address => mapping(address => bool)) private _operatorApprovals;     
333     constructor(string memory name_, string memory symbol_) {
334         _name = name_;
335         _symbol = symbol_;
336     }     
337     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
338         return
339             interfaceId == type(IERC721).interfaceId ||
340             interfaceId == type(IERC721Metadata).interfaceId ||
341             super.supportsInterface(interfaceId);
342     }
343     function balanceOf(address owner) public view virtual override returns (uint256) {
344         require(owner != address(0), "ERC721: balance query for the zero address");
345         uint count = 0;
346         uint length = _owners.length;
347         for( uint i = 0; i < length; ++i ){
348           if( owner == _owners[i] ){
349             ++count;
350           }
351         }
352         delete length;
353         return count;
354     }
355     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
356         address owner = _owners[tokenId];
357         require(owner != address(0), "ERC721: owner query for nonexistent token");
358         return owner;
359     }
360     function name() public view virtual override returns (string memory) {
361         return _name;
362     }
363     function symbol() public view virtual override returns (string memory) {
364         return _symbol;
365     }
366     function approve(address to, uint256 tokenId) public virtual override {
367         address owner = ERC721S.ownerOf(tokenId);
368         require(to != owner, "ERC721: approval to current owner");
369 
370         require(
371             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
372             "ERC721: approve caller is not owner nor approved for all"
373         );
374 
375         _approve(to, tokenId);
376     }
377     function getApproved(uint256 tokenId) public view virtual override returns (address) {
378         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
379 
380         return _tokenApprovals[tokenId];
381     }
382     function setApprovalForAll(address operator, bool approved) public virtual override {
383         require(operator != _msgSender(), "ERC721: approve to caller");
384 
385         _operatorApprovals[_msgSender()][operator] = approved;
386         emit ApprovalForAll(_msgSender(), operator, approved);
387     }
388     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
389         return _operatorApprovals[owner][operator];
390     }
391     function transferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) public virtual override {
396         //solhint-disable-next-line max-line-length
397         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
398 
399         _transfer(from, to, tokenId);
400     }
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) public virtual override {
406         safeTransferFrom(from, to, tokenId, "");
407     }
408     function safeTransferFrom(
409         address from,
410         address to,
411         uint256 tokenId,
412         bytes memory _data
413     ) public virtual override {
414         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
415         _safeTransfer(from, to, tokenId, _data);
416     }     
417     function _safeTransfer(
418         address from,
419         address to,
420         uint256 tokenId,
421         bytes memory _data
422     ) internal virtual {
423         _transfer(from, to, tokenId);
424         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
425     }
426 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
427         return tokenId < _owners.length && _owners[tokenId] != address(0);
428     }
429 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
430         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
431         address owner = ERC721S.ownerOf(tokenId);
432         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
433     }
434 	function _safeMint(address to, uint256 tokenId) internal virtual {
435         _safeMint(to, tokenId, "");
436     }
437 	function _safeMint(
438         address to,
439         uint256 tokenId,
440         bytes memory _data
441     ) internal virtual {
442         _mint(to, tokenId);
443         require(
444             _checkOnERC721Received(address(0), to, tokenId, _data),
445             "ERC721: transfer to non ERC721Receiver implementer"
446         );
447     }
448 	function _mint(address to, uint256 tokenId) internal virtual {
449         require(to != address(0), "ERC721: mint to the zero address");
450         require(!_exists(tokenId), "ERC721: token already minted");
451 
452         _beforeTokenTransfer(address(0), to, tokenId);
453         _owners.push(to);
454 
455         emit Transfer(address(0), to, tokenId);
456     }
457 	function _burn(uint256 tokenId) internal virtual {
458         address owner = ERC721S.ownerOf(tokenId);
459 
460         _beforeTokenTransfer(owner, address(0), tokenId);
461 
462         // Clear approvals
463         _approve(address(0), tokenId);
464         _owners[tokenId] = address(0);
465 
466         emit Transfer(owner, address(0), tokenId);
467     }
468 	function _transfer(
469         address from,
470         address to,
471         uint256 tokenId
472     ) internal virtual {
473         require(ERC721S.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
474         require(to != address(0), "ERC721: transfer to the zero address");
475 
476         _beforeTokenTransfer(from, to, tokenId);
477 
478         // Clear approvals from the previous owner
479         _approve(address(0), tokenId);
480         _owners[tokenId] = to;
481 
482         emit Transfer(from, to, tokenId);
483     }
484 	function _approve(address to, uint256 tokenId) internal virtual {
485         _tokenApprovals[tokenId] = to;
486         emit Approval(ERC721S.ownerOf(tokenId), to, tokenId);
487     }
488 	function _checkOnERC721Received(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes memory _data
493     ) private returns (bool) {
494         if (to.isContract()) {
495             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
496                 return retval == IERC721Receiver.onERC721Received.selector;
497             } catch (bytes memory reason) {
498                 if (reason.length == 0) {
499                     revert("ERC721: transfer to non ERC721Receiver implementer");
500                 } else {
501                     assembly {
502                         revert(add(32, reason), mload(reason))
503                     }
504                 }
505             }
506         } else {
507             return true;
508         }
509     }
510 	function _beforeTokenTransfer(
511         address from,
512         address to,
513         uint256 tokenId
514     ) internal virtual {}
515 }
516 
517 // SafeMath.sol
518 
519 
520 pragma solidity ^0.8.0;
521 
522 // CAUTION
523 // This version of SafeMath should only be used with Solidity 0.8 or later,
524 // because it relies on the compiler's built in overflow checks.
525 
526 /**
527  * @dev Wrappers over Solidity's arithmetic operations.
528  *
529  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
530  * now has built in overflow checking.
531  */
532 library SafeMath {
533     /**
534      * @dev Returns the addition of two unsigned integers, with an overflow flag.
535      *
536      * _Available since v3.4._
537      */
538     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             uint256 c = a + b;
541             if (c < a) return (false, 0);
542             return (true, c);
543         }
544     }
545 
546     /**
547      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
548      *
549      * _Available since v3.4._
550      */
551     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
552         unchecked {
553             if (b > a) return (false, 0);
554             return (true, a - b);
555         }
556     }
557 
558     /**
559      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
560      *
561      * _Available since v3.4._
562      */
563     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
564         unchecked {
565             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
566             // benefit is lost if 'b' is also tested.
567             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
568             if (a == 0) return (true, 0);
569             uint256 c = a * b;
570             if (c / a != b) return (false, 0);
571             return (true, c);
572         }
573     }
574 
575     /**
576      * @dev Returns the division of two unsigned integers, with a division by zero flag.
577      *
578      * _Available since v3.4._
579      */
580     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             if (b == 0) return (false, 0);
583             return (true, a / b);
584         }
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
589      *
590      * _Available since v3.4._
591      */
592     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             if (b == 0) return (false, 0);
595             return (true, a % b);
596         }
597     }
598 
599     /**
600      * @dev Returns the addition of two unsigned integers, reverting on
601      * overflow.
602      *
603      * Counterpart to Solidity's `+` operator.
604      *
605      * Requirements:
606      *
607      * - Addition cannot overflow.
608      */
609     function add(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a + b;
611     }
612 
613     /**
614      * @dev Returns the subtraction of two unsigned integers, reverting on
615      * overflow (when the result is negative).
616      *
617      * Counterpart to Solidity's `-` operator.
618      *
619      * Requirements:
620      *
621      * - Subtraction cannot overflow.
622      */
623     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a - b;
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, reverting on
629      * overflow.
630      *
631      * Counterpart to Solidity's `*` operator.
632      *
633      * Requirements:
634      *
635      * - Multiplication cannot overflow.
636      */
637     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a * b;
639     }
640 
641     /**
642      * @dev Returns the integer division of two unsigned integers, reverting on
643      * division by zero. The result is rounded towards zero.
644      *
645      * Counterpart to Solidity's `/` operator.
646      *
647      * Requirements:
648      *
649      * - The divisor cannot be zero.
650      */
651     function div(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a / b;
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
657      * reverting when dividing by zero.
658      *
659      * Counterpart to Solidity's `%` operator. This function uses a `revert`
660      * opcode (which leaves remaining gas untouched) while Solidity uses an
661      * invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
668         return a % b;
669     }
670 
671     /**
672      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
673      * overflow (when the result is negative).
674      *
675      * CAUTION: This function is deprecated because it requires allocating memory for the error
676      * message unnecessarily. For custom revert reasons use {trySub}.
677      *
678      * Counterpart to Solidity's `-` operator.
679      *
680      * Requirements:
681      *
682      * - Subtraction cannot overflow.
683      */
684     function sub(
685         uint256 a,
686         uint256 b,
687         string memory errorMessage
688     ) internal pure returns (uint256) {
689         unchecked {
690             require(b <= a, errorMessage);
691             return a - b;
692         }
693     }
694 
695     /**
696      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
697      * division by zero. The result is rounded towards zero.
698      *
699      * Counterpart to Solidity's `/` operator. Note: this function uses a
700      * `revert` opcode (which leaves remaining gas untouched) while Solidity
701      * uses an invalid opcode to revert (consuming all remaining gas).
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function div(
708         uint256 a,
709         uint256 b,
710         string memory errorMessage
711     ) internal pure returns (uint256) {
712         unchecked {
713             require(b > 0, errorMessage);
714             return a / b;
715         }
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * reverting with custom message when dividing by zero.
721      *
722      * CAUTION: This function is deprecated because it requires allocating memory for the error
723      * message unnecessarily. For custom revert reasons use {tryMod}.
724      *
725      * Counterpart to Solidity's `%` operator. This function uses a `revert`
726      * opcode (which leaves remaining gas untouched) while Solidity uses an
727      * invalid opcode to revert (consuming all remaining gas).
728      *
729      * Requirements:
730      *
731      * - The divisor cannot be zero.
732      */
733     function mod(
734         uint256 a,
735         uint256 b,
736         string memory errorMessage
737     ) internal pure returns (uint256) {
738         unchecked {
739             require(b > 0, errorMessage);
740             return a % b;
741         }
742     }
743 }
744 
745 // Address.sol
746 
747 
748 pragma solidity ^0.8.0;
749 
750 /**
751  * @dev Collection of functions related to the address type
752  */
753 library Address {
754     /**
755      * @dev Returns true if `account` is a contract.
756      *
757      * [IMPORTANT]
758      * ====
759      * It is unsafe to assume that an address for which this function returns
760      * false is an externally-owned account (EOA) and not a contract.
761      *
762      * Among others, `isContract` will return false for the following
763      * types of addresses:
764      *
765      *  - an externally-owned account
766      *  - a contract in construction
767      *  - an address where a contract will be created
768      *  - an address where a contract lived, but was destroyed
769      * ====
770      */
771     function isContract(address account) internal view returns (bool) {
772         // This method relies on extcodesize, which returns 0 for contracts in
773         // construction, since the code is only stored at the end of the
774         // constructor execution.
775 
776         uint256 size;
777         assembly {
778             size := extcodesize(account)
779         }
780         return size > 0;
781     }
782 
783     /**
784      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
785      * `recipient`, forwarding all available gas and reverting on errors.
786      *
787      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
788      * of certain opcodes, possibly making contracts go over the 2300 gas limit
789      * imposed by `transfer`, making them unable to receive funds via
790      * `transfer`. {sendValue} removes this limitation.
791      *
792      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
793      *
794      * IMPORTANT: because control is transferred to `recipient`, care must be
795      * taken to not create reentrancy vulnerabilities. Consider using
796      * {ReentrancyGuard} or the
797      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
798      */
799     function sendValue(address payable recipient, uint256 amount) internal {
800         require(address(this).balance >= amount, "Address: insufficient balance");
801 
802         (bool success, ) = recipient.call{value: amount}("");
803         require(success, "Address: unable to send value, recipient may have reverted");
804     }
805 
806     /**
807      * @dev Performs a Solidity function call using a low level `call`. A
808      * plain `call` is an unsafe replacement for a function call: use this
809      * function instead.
810      *
811      * If `target` reverts with a revert reason, it is bubbled up by this
812      * function (like regular Solidity function calls).
813      *
814      * Returns the raw returned data. To convert to the expected return value,
815      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
816      *
817      * Requirements:
818      *
819      * - `target` must be a contract.
820      * - calling `target` with `data` must not revert.
821      *
822      * _Available since v3.1._
823      */
824     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
825         return functionCall(target, data, "Address: low-level call failed");
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
830      * `errorMessage` as a fallback revert reason when `target` reverts.
831      *
832      * _Available since v3.1._
833      */
834     function functionCall(
835         address target,
836         bytes memory data,
837         string memory errorMessage
838     ) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, 0, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but also transferring `value` wei to `target`.
845      *
846      * Requirements:
847      *
848      * - the calling contract must have an ETH balance of at least `value`.
849      * - the called Solidity function must be `payable`.
850      *
851      * _Available since v3.1._
852      */
853     function functionCallWithValue(
854         address target,
855         bytes memory data,
856         uint256 value
857     ) internal returns (bytes memory) {
858         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
863      * with `errorMessage` as a fallback revert reason when `target` reverts.
864      *
865      * _Available since v3.1._
866      */
867     function functionCallWithValue(
868         address target,
869         bytes memory data,
870         uint256 value,
871         string memory errorMessage
872     ) internal returns (bytes memory) {
873         require(address(this).balance >= value, "Address: insufficient balance for call");
874         require(isContract(target), "Address: call to non-contract");
875 
876         (bool success, bytes memory returndata) = target.call{value: value}(data);
877         return verifyCallResult(success, returndata, errorMessage);
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
882      * but performing a static call.
883      *
884      * _Available since v3.3._
885      */
886     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
887         return functionStaticCall(target, data, "Address: low-level static call failed");
888     }
889 
890     /**
891      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
892      * but performing a static call.
893      *
894      * _Available since v3.3._
895      */
896     function functionStaticCall(
897         address target,
898         bytes memory data,
899         string memory errorMessage
900     ) internal view returns (bytes memory) {
901         require(isContract(target), "Address: static call to non-contract");
902 
903         (bool success, bytes memory returndata) = target.staticcall(data);
904         return verifyCallResult(success, returndata, errorMessage);
905     }
906 
907     /**
908      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
909      * but performing a delegate call.
910      *
911      * _Available since v3.4._
912      */
913     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
914         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
915     }
916 
917     /**
918      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
919      * but performing a delegate call.
920      *
921      * _Available since v3.4._
922      */
923     function functionDelegateCall(
924         address target,
925         bytes memory data,
926         string memory errorMessage
927     ) internal returns (bytes memory) {
928         require(isContract(target), "Address: delegate call to non-contract");
929 
930         (bool success, bytes memory returndata) = target.delegatecall(data);
931         return verifyCallResult(success, returndata, errorMessage);
932     }
933 
934     /**
935      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
936      * revert reason using the provided one.
937      *
938      * _Available since v4.3._
939      */
940     function verifyCallResult(
941         bool success,
942         bytes memory returndata,
943         string memory errorMessage
944     ) internal pure returns (bytes memory) {
945         if (success) {
946             return returndata;
947         } else {
948             // Look for revert reason and bubble it up if present
949             if (returndata.length > 0) {
950                 // The easiest way to bubble the revert reason is using memory via assembly
951 
952                 assembly {
953                     let returndata_size := mload(returndata)
954                     revert(add(32, returndata), returndata_size)
955                 }
956             } else {
957                 revert(errorMessage);
958             }
959         }
960     }
961 }
962 
963 
964 
965 // ERC721Enum.sol
966 
967 pragma solidity ^0.8.10;
968 
969 abstract contract ERC721Enum is ERC721S, IERC721Enumerable {
970     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721S) returns (bool) {
971         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
972     }
973     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
974         require(index < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
975         uint count;
976         for( uint i; i < _owners.length; ++i ){
977             if( owner == _owners[i] ){
978                 if( count == index )
979                     return i;
980                 else
981                     ++count;
982             }
983         }
984         require(false, "ERC721Enum: owner ioob");
985     }
986     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
987         require(0 < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
988         uint256 tokenCount = balanceOf(owner);
989         uint256[] memory tokenIds = new uint256[](tokenCount);
990         for (uint256 i = 0; i < tokenCount; i++) {
991             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
992         }
993         return tokenIds;
994     }
995     function totalSupply() public view virtual override returns (uint256) {
996         return _owners.length;
997     }
998     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
999         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
1000         return index;
1001     }
1002 }
1003 
1004 // ReentrancyGuard.sol
1005 
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 /**
1010  * @dev Contract module that helps prevent reentrant calls to a function.
1011  *
1012  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1013  * available, which can be applied to functions to make sure there are no nested
1014  * (reentrant) calls to them.
1015  *
1016  * Note that because there is a single `nonReentrant` guard, functions marked as
1017  * `nonReentrant` may not call one another. This can be worked around by making
1018  * those functions `private`, and then adding `external` `nonReentrant` entry
1019  * points to them.
1020  *
1021  * TIP: If you would like to learn more about reentrancy and alternative ways
1022  * to protect against it, check out our blog post
1023  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1024  */
1025 abstract contract ReentrancyGuard {
1026     // Booleans are more expensive than uint256 or any type that takes up a full
1027     // word because each write operation emits an extra SLOAD to first read the
1028     // slot's contents, replace the bits taken up by the boolean, and then write
1029     // back. This is the compiler's defense against contract upgrades and
1030     // pointer aliasing, and it cannot be disabled.
1031 
1032     // The values being non-zero value makes deployment a bit more expensive,
1033     // but in exchange the refund on every call to nonReentrant will be lower in
1034     // amount. Since refunds are capped to a percentage of the total
1035     // transaction's gas, it is best to keep them low in cases like this one, to
1036     // increase the likelihood of the full refund coming into effect.
1037     uint256 private constant _NOT_ENTERED = 1;
1038     uint256 private constant _ENTERED = 2;
1039 
1040     uint256 private _status;
1041 
1042     constructor() {
1043         _status = _NOT_ENTERED;
1044     }
1045 
1046     /**
1047      * @dev Prevents a contract from calling itself, directly or indirectly.
1048      * Calling a `nonReentrant` function from another `nonReentrant`
1049      * function is not supported. It is possible to prevent this from happening
1050      * by making the `nonReentrant` function external, and make it call a
1051      * `private` function that does the actual work.
1052      */
1053     modifier nonReentrant() {
1054         // On the first call to nonReentrant, _notEntered will be true
1055         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1056 
1057         // Any calls to nonReentrant after this point will fail
1058         _status = _ENTERED;
1059 
1060         _;
1061 
1062         // By storing the original value once again, a refund is triggered (see
1063         // https://eips.ethereum.org/EIPS/eip-2200)
1064         _status = _NOT_ENTERED;
1065     }
1066 }
1067 
1068 // PaymentSplitter.sol
1069 
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 /**
1075  * @title PaymentSplitter
1076  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1077  * that the Ether will be split in this way, since it is handled transparently by the contract.
1078  *
1079  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1080  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1081  * an amount proportional to the percentage of total shares they were assigned.
1082  *
1083  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1084  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1085  * function.
1086  */
1087 contract PaymentSplitter is Context {
1088     event PayeeAdded(address account, uint256 shares);
1089     event PaymentReleased(address to, uint256 amount);
1090     event PaymentReceived(address from, uint256 amount);
1091 
1092     uint256 private _totalShares;
1093     uint256 private _totalReleased;
1094 
1095     mapping(address => uint256) private _shares;
1096     mapping(address => uint256) private _released;
1097     address[] private _payees;
1098 
1099     /**
1100      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1101      * the matching position in the `shares` array.
1102      *
1103      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1104      * duplicates in `payees`.
1105      */
1106     constructor(address[] memory payees, uint256[] memory shares_) payable {
1107         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1108         require(payees.length > 0, "PaymentSplitter: no payees");
1109 
1110         for (uint256 i = 0; i < payees.length; i++) {
1111             _addPayee(payees[i], shares_[i]);
1112         }
1113     }
1114 
1115     /**
1116      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1117      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1118      * reliability of the events, and not the actual splitting of Ether.
1119      *
1120      * To learn more about this see the Solidity documentation for
1121      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1122      * functions].
1123      */
1124     receive() external payable virtual {
1125         emit PaymentReceived(_msgSender(), msg.value);
1126     }
1127 
1128     /**
1129      * @dev Getter for the total shares held by payees.
1130      */
1131     function totalShares() public view returns (uint256) {
1132         return _totalShares;
1133     }
1134 
1135     /**
1136      * @dev Getter for the total amount of Ether already released.
1137      */
1138     function totalReleased() public view returns (uint256) {
1139         return _totalReleased;
1140     }
1141 
1142     /**
1143      * @dev Getter for the amount of shares held by an account.
1144      */
1145     function shares(address account) public view returns (uint256) {
1146         return _shares[account];
1147     }
1148 
1149     /**
1150      * @dev Getter for the amount of Ether already released to a payee.
1151      */
1152     function released(address account) public view returns (uint256) {
1153         return _released[account];
1154     }
1155 
1156     /**
1157      * @dev Getter for the address of the payee number `index`.
1158      */
1159     function payee(uint256 index) public view returns (address) {
1160         return _payees[index];
1161     }
1162 
1163     /**
1164      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1165      * total shares and their previous withdrawals.
1166      */
1167     function release(address payable account) public virtual {
1168         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1169 
1170         uint256 totalReceived = address(this).balance + _totalReleased;
1171         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1172 
1173         require(payment != 0, "PaymentSplitter: account is not due payment");
1174 
1175         _released[account] = _released[account] + payment;
1176         _totalReleased = _totalReleased + payment;
1177 
1178         Address.sendValue(account, payment);
1179         emit PaymentReleased(account, payment);
1180     }
1181 
1182     /**
1183      * @dev Add a new payee to the contract.
1184      * @param account The address of the payee to add.
1185      * @param shares_ The number of shares owned by the payee.
1186      */
1187     function _addPayee(address account, uint256 shares_) private {
1188         require(account != address(0), "PaymentSplitter: account is the zero address");
1189         require(shares_ > 0, "PaymentSplitter: shares are 0");
1190         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1191 
1192         _payees.push(account);
1193         _shares[account] = shares_;
1194         _totalShares = _totalShares + shares_;
1195         emit PayeeAdded(account, shares_);
1196     }
1197 }
1198 
1199 
1200 // Strings.sol
1201 
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 /**
1206  * @dev String operations.
1207  */
1208 library Strings {
1209     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1210 
1211     /**
1212      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1213      */
1214     function toString(uint256 value) internal pure returns (string memory) {
1215         // Inspired by OraclizeAPI's implementation - MIT licence
1216         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1217 
1218         if (value == 0) {
1219             return "0";
1220         }
1221         uint256 temp = value;
1222         uint256 digits;
1223         while (temp != 0) {
1224             digits++;
1225             temp /= 10;
1226         }
1227         bytes memory buffer = new bytes(digits);
1228         while (value != 0) {
1229             digits -= 1;
1230             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1231             value /= 10;
1232         }
1233         return string(buffer);
1234     }
1235 
1236     /**
1237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1238      */
1239     function toHexString(uint256 value) internal pure returns (string memory) {
1240         if (value == 0) {
1241             return "0x00";
1242         }
1243         uint256 temp = value;
1244         uint256 length = 0;
1245         while (temp != 0) {
1246             length++;
1247             temp >>= 8;
1248         }
1249         return toHexString(value, length);
1250     }
1251 
1252     /**
1253      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1254      */
1255     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1256         bytes memory buffer = new bytes(2 * length + 2);
1257         buffer[0] = "0";
1258         buffer[1] = "x";
1259         for (uint256 i = 2 * length + 1; i > 1; --i) {
1260             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1261             value >>= 4;
1262         }
1263         require(value == 0, "Strings: hex length insufficient");
1264         return string(buffer);
1265     }
1266 }
1267 
1268 // Ownable.sol
1269 
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 /**
1275  * @dev Contract module which provides a basic access control mechanism, where
1276  * there is an account (an owner) that can be granted exclusive access to
1277  * specific functions.
1278  *
1279  * By default, the owner account will be the one that deploys the contract. This
1280  * can later be changed with {transferOwnership}.
1281  *
1282  * This module is used through inheritance. It will make available the modifier
1283  * `onlyOwner`, which can be applied to your functions to restrict their use to
1284  * the owner.
1285  */
1286 abstract contract Ownable is Context {
1287     address private _owner;
1288 
1289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1290 
1291     /**
1292      * @dev Initializes the contract setting the deployer as the initial owner.
1293      */
1294     constructor() {
1295         _setOwner(_msgSender());
1296     }
1297 
1298     /**
1299      * @dev Returns the address of the current owner.
1300      */
1301     function owner() public view virtual returns (address) {
1302         return _owner;
1303     }
1304 
1305     /**
1306      * @dev Throws if called by any account other than the owner.
1307      */
1308     modifier onlyOwner() {
1309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1310         _;
1311     }
1312 
1313     /**
1314      * @dev Leaves the contract without owner. It will not be possible to call
1315      * `onlyOwner` functions anymore. Can only be called by the current owner.
1316      *
1317      * NOTE: Renouncing ownership will leave the contract without an owner,
1318      * thereby removing any functionality that is only available to the owner.
1319      */
1320     function renounceOwnership() public virtual onlyOwner {
1321         _setOwner(address(0));
1322     }
1323 
1324     /**
1325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1326      * Can only be called by the current owner.
1327      */
1328     function transferOwnership(address newOwner) public virtual onlyOwner {
1329         require(newOwner != address(0), "Ownable: new owner is the zero address");
1330         _setOwner(newOwner);
1331     }
1332 
1333     function _setOwner(address newOwner) private {
1334         address oldOwner = _owner;
1335         _owner = newOwner;
1336         emit OwnershipTransferred(oldOwner, newOwner);
1337     }
1338 }
1339 
1340 //  Pausable.sol
1341 pragma solidity ^0.8.0;
1342 
1343 
1344 /**
1345  * @dev Contract module which allows children to implement an emergency stop
1346  * mechanism that can be triggered by an authorized account.
1347  *
1348  * This module is used through inheritance. It will make available the
1349  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1350  * the functions of your contract. Note that they will not be pausable by
1351  * simply including this module, only once the modifiers are put in place.
1352  */
1353 abstract contract Pausable is Context,Ownable {
1354     /**
1355      * @dev Emitted when the pause is triggered by `account`.
1356      */
1357     event Paused(address account);
1358 
1359     /**
1360      * @dev Emitted when the pause is lifted by `account`.
1361      */
1362     event Unpaused(address account);
1363 
1364     bool private _paused;
1365 
1366     /**
1367      * @dev Initializes the contract in unpaused state.
1368      */
1369     constructor() {
1370         _paused = true;
1371     }
1372 
1373     /**
1374      * @dev Returns true if the contract is paused, and false otherwise.
1375      */
1376     function paused() public view virtual returns (bool) {
1377         return _paused;
1378     }
1379 
1380     /**
1381      * @dev Modifier to make a function callable only when the contract is not paused.
1382      *
1383      * Requirements:
1384      *
1385      * - The contract must not be paused.
1386      */
1387     modifier whenNotPaused() {
1388         require(!paused(), "Pausable: paused");
1389         _;
1390     }
1391 
1392     /**
1393      * @dev Modifier to make a function callable only when the contract is paused.
1394      *
1395      * Requirements:
1396      *
1397      * - The contract must be paused.
1398      */
1399     modifier whenPaused() {
1400         require(paused(), "Pausable: not paused");
1401         _;
1402     }
1403 
1404     /**
1405      * @dev Triggers stopped state.
1406      *
1407      * Requirements:
1408      *
1409      * - The contract must not be paused.
1410      */
1411     function _pause() public virtual onlyOwner whenNotPaused {
1412         _paused = true;
1413         emit Paused(_msgSender());
1414     }
1415 
1416     /**
1417      * @dev Returns to normal state.
1418      *
1419      * Requirements:
1420      *
1421      * - The contract must be paused.
1422      */
1423      
1424     function _unpause() public virtual onlyOwner whenPaused {
1425         _paused = false;
1426         emit Unpaused(_msgSender());
1427     }
1428 }
1429 
1430 // LarvaLambs.sol
1431 
1432 pragma solidity ^0.8.10;
1433 
1434 
1435 contract LarvaLambs is ERC721Enum, Ownable, Pausable, ReentrancyGuard {
1436 
1437 	using Strings for uint256;
1438 	string public baseURI;
1439      string public baseExtension = ".json";
1440 	uint256 public cost = 0.01 ether;
1441 	uint256 public maxSupply = 10005;
1442     uint256 public maxFree = 1000;  
1443     uint256 public nftPerAddressLimit = 9;
1444 	bool public status = false;
1445     bool public revealed = false;
1446     string public notRevealedUri;
1447     mapping(address => uint256) public addressMintedBalance;
1448 
1449 		
1450 	constructor() ERC721S("Larva Lambs", "LarvaLambs"){
1451 	    setBaseURI("");
1452 	}
1453 
1454 	function _baseURI() internal view virtual returns (string memory) {
1455 	    return baseURI;
1456 	}
1457 
1458 	function mint(uint256 _mintAmount) public payable nonReentrant{
1459 		uint256 s = totalSupply();
1460         require(!paused());
1461 		require(_mintAmount > 0, "Cant mint 0" );
1462 		require(_mintAmount <= 20, "Cant mint more then maxmint" );
1463 		require(s + _mintAmount <= maxSupply, "Cant go over supply" );
1464 		require(msg.value >= cost * _mintAmount);
1465 		for (uint256 i = 0; i < _mintAmount; ++i) {
1466 			_safeMint(msg.sender, s + i, "");
1467 		}
1468 		delete s;
1469 	}
1470 
1471     	function mintfree(uint256 _mintAmount) public payable nonReentrant{
1472 		uint256 s = totalSupply();
1473         require(!paused());
1474         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1475         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1476 		require(_mintAmount > 0, "Cant mint 0" );
1477 		require(_mintAmount <= 3, "Cant mint more then maxmint" );
1478 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1479 		for (uint256 i = 0; i < _mintAmount; ++i) {
1480             addressMintedBalance[msg.sender]++;
1481 			_safeMint(msg.sender, s + i, "");
1482 		}
1483 		delete s;
1484 	}
1485 
1486 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1487 		require(quantity.length == recipient.length, "Provide quantities and recipients" );
1488 		uint totalQuantity = 0;
1489 		uint256 s = totalSupply();
1490 		for(uint i = 0; i < quantity.length; ++i){
1491 			totalQuantity += quantity[i];
1492 		}
1493 		require( s + totalQuantity <= maxSupply, "Too many" );
1494         require(!paused());
1495 		delete totalQuantity;
1496 		for(uint i = 0; i < recipient.length; ++i){
1497 			for(uint j = 0; j < quantity[i]; ++j){
1498 			_safeMint( recipient[i], s++, "" );
1499 			}
1500 		}
1501 		delete s;	
1502 	}
1503 
1504 	
1505 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1506 	    require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1507         
1508         if(revealed == false) {
1509             return notRevealedUri;
1510         }
1511 	    string memory currentBaseURI = _baseURI();
1512 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1513 	}
1514 
1515     //only owner
1516     function reveal() public onlyOwner {
1517         revealed = true;
1518     }
1519     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1520         nftPerAddressLimit = _limit;
1521     }
1522 
1523 	function setCost(uint256 _newCost) public onlyOwner {
1524 	    cost = _newCost;
1525 	}
1526 
1527 	function setmaxFree(uint256 _newMaxFree) public onlyOwner {
1528 	    maxFree = _newMaxFree;
1529 	}
1530     	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1531 	    maxSupply = _newMaxSupply;
1532 	}
1533 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1534 	    baseURI = _newBaseURI;
1535 	}
1536     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1537         baseExtension = _newBaseExtension;
1538     }
1539 
1540     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1541         notRevealedUri = _notRevealedURI;
1542     }
1543     
1544 	function setSaleStatus(bool _status) public onlyOwner {
1545 	    status = _status;
1546 	}
1547 	function withdraw() public payable onlyOwner {
1548 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1549 	require(success);
1550 	}
1551     
1552 }