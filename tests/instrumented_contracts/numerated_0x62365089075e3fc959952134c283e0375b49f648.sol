1 // IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // ERC165.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Implementation of the {IERC165} interface.
35  *
36  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
37  * for the additional interface id that will be supported. For example:
38  *
39  * ```solidity
40  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
41  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
42  * }
43  * ```
44  *
45  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
46  */
47 abstract contract ERC165 is IERC165 {
48     /**
49      * @dev See {IERC165-supportsInterface}.
50      */
51     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
52         return interfaceId == type(IERC165).interfaceId;
53     }
54 }
55 
56 // IERC721.sol
57 
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 interface IERC721 is IERC165 {
65     /**
66      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
72      */
73     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
77      */
78     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
79 
80     /**
81      * @dev Returns the number of tokens in ``owner``'s account.
82      */
83     function balanceOf(address owner) external view returns (uint256 balance);
84 
85     /**
86      * @dev Returns the owner of the `tokenId` token.
87      *
88      * Requirements:
89      *
90      * - `tokenId` must exist.
91      */
92     function ownerOf(uint256 tokenId) external view returns (address owner);
93 
94     /**
95      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
96      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must exist and be owned by `from`.
103      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
105      *
106      * Emits a {Transfer} event.
107      */
108     function safeTransferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(
129         address from,
130         address to,
131         uint256 tokenId
132     ) external;
133 
134     /**
135      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
136      * The approval is cleared when the token is transferred.
137      *
138      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
139      *
140      * Requirements:
141      *
142      * - The caller must own the token or be an approved operator.
143      * - `tokenId` must exist.
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address to, uint256 tokenId) external;
148 
149     /**
150      * @dev Returns the account approved for `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function getApproved(uint256 tokenId) external view returns (address operator);
157 
158     /**
159      * @dev Approve or remove `operator` as an operator for the caller.
160      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
161      *
162      * Requirements:
163      *
164      * - The `operator` cannot be the caller.
165      *
166      * Emits an {ApprovalForAll} event.
167      */
168     function setApprovalForAll(address operator, bool _approved) external;
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external;
196 }
197 
198 
199 // IERC721Metadata.sol
200 
201 
202 pragma solidity ^0.8.0;
203 
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210     /**
211      * @dev Returns the token collection name.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the token collection symbol.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222      */
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 // IERC721Receiver.sol
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @title ERC721 token receiver interface
233  * @dev Interface for any contract that wants to support safeTransfers
234  * from ERC721 asset contracts.
235  */
236 interface IERC721Receiver {
237     /**
238      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
239      * by `operator` from `from`, this function is called.
240      *
241      * It must return its Solidity selector to confirm the token transfer.
242      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
243      *
244      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
245      */
246     function onERC721Received(
247         address operator,
248         address from,
249         uint256 tokenId,
250         bytes calldata data
251     ) external returns (bytes4);
252 }
253 
254 
255 
256 // IERC721Enumerable.sol
257 
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
264  * @dev See https://eips.ethereum.org/EIPS/eip-721
265  */
266 interface IERC721Enumerable is IERC721 {
267     /**
268      * @dev Returns the total amount of tokens stored by the contract.
269      */
270     function totalSupply() external view returns (uint256);
271 
272     /**
273      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
274      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
275      */
276     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
277 
278     /**
279      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
280      * Use along with {totalSupply} to enumerate all tokens.
281      */
282     function tokenByIndex(uint256 index) external view returns (uint256);
283 }
284 
285 
286 // Context.sol
287 
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Provides information about the current execution context, including the
293  * sender of the transaction and its data. While these are generally available
294  * via msg.sender and msg.data, they should not be accessed in such a direct
295  * manner, since when dealing with meta-transactions the account sending and
296  * paying for execution may not be the actual sender (as far as an application
297  * is concerned).
298  *
299  * This contract is only required for intermediate, library-like contracts.
300  */
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes calldata) {
307         return msg.data;
308     }
309 }
310 
311 // ERC721S.sol
312 
313 pragma solidity ^0.8.10;
314 
315 
316 abstract contract ERC721S is Context, ERC165, IERC721, IERC721Metadata {
317     using Address for address;
318     string private _name;
319     string private _symbol;
320     address[] internal _owners;
321     mapping(uint256 => address) private _tokenApprovals;
322     mapping(address => mapping(address => bool)) private _operatorApprovals;     
323     constructor(string memory name_, string memory symbol_) {
324         _name = name_;
325         _symbol = symbol_;
326     }     
327     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
328         return
329             interfaceId == type(IERC721).interfaceId ||
330             interfaceId == type(IERC721Metadata).interfaceId ||
331             super.supportsInterface(interfaceId);
332     }
333     function balanceOf(address owner) public view virtual override returns (uint256) {
334         require(owner != address(0), "ERC721: balance query for the zero address");
335         uint count = 0;
336         uint length = _owners.length;
337         for( uint i = 0; i < length; ++i ){
338           if( owner == _owners[i] ){
339             ++count;
340           }
341         }
342         delete length;
343         return count;
344     }
345     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
346         address owner = _owners[tokenId];
347         require(owner != address(0), "ERC721: owner query for nonexistent token");
348         return owner;
349     }
350     function name() public view virtual override returns (string memory) {
351         return _name;
352     }
353     function symbol() public view virtual override returns (string memory) {
354         return _symbol;
355     }
356     function approve(address to, uint256 tokenId) public virtual override {
357         address owner = ERC721S.ownerOf(tokenId);
358         require(to != owner, "ERC721: approval to current owner");
359 
360         require(
361             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
362             "ERC721: approve caller is not owner nor approved for all"
363         );
364 
365         _approve(to, tokenId);
366     }
367     function getApproved(uint256 tokenId) public view virtual override returns (address) {
368         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
369 
370         return _tokenApprovals[tokenId];
371     }
372     function setApprovalForAll(address operator, bool approved) public virtual override {
373         require(operator != _msgSender(), "ERC721: approve to caller");
374 
375         _operatorApprovals[_msgSender()][operator] = approved;
376         emit ApprovalForAll(_msgSender(), operator, approved);
377     }
378     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
379         return _operatorApprovals[owner][operator];
380     }
381     function transferFrom(
382         address from,
383         address to,
384         uint256 tokenId
385     ) public virtual override {
386         //solhint-disable-next-line max-line-length
387         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
388 
389         _transfer(from, to, tokenId);
390     }
391     function safeTransferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) public virtual override {
396         safeTransferFrom(from, to, tokenId, "");
397     }
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId,
402         bytes memory _data
403     ) public virtual override {
404         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
405         _safeTransfer(from, to, tokenId, _data);
406     }     
407     function _safeTransfer(
408         address from,
409         address to,
410         uint256 tokenId,
411         bytes memory _data
412     ) internal virtual {
413         _transfer(from, to, tokenId);
414         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
415     }
416 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
417         return tokenId < _owners.length && _owners[tokenId] != address(0);
418     }
419 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
420         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
421         address owner = ERC721S.ownerOf(tokenId);
422         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
423     }
424 	function _safeMint(address to, uint256 tokenId) internal virtual {
425         _safeMint(to, tokenId, "");
426     }
427 	function _safeMint(
428         address to,
429         uint256 tokenId,
430         bytes memory _data
431     ) internal virtual {
432         _mint(to, tokenId);
433         require(
434             _checkOnERC721Received(address(0), to, tokenId, _data),
435             "ERC721: transfer to non ERC721Receiver implementer"
436         );
437     }
438 	function _mint(address to, uint256 tokenId) internal virtual {
439         require(to != address(0), "ERC721: mint to the zero address");
440         require(!_exists(tokenId), "ERC721: token already minted");
441 
442         _beforeTokenTransfer(address(0), to, tokenId);
443         _owners.push(to);
444 
445         emit Transfer(address(0), to, tokenId);
446     }
447 	function _burn(uint256 tokenId) internal virtual {
448         address owner = ERC721S.ownerOf(tokenId);
449 
450         _beforeTokenTransfer(owner, address(0), tokenId);
451 
452         // Clear approvals
453         _approve(address(0), tokenId);
454         _owners[tokenId] = address(0);
455 
456         emit Transfer(owner, address(0), tokenId);
457     }
458 	function _transfer(
459         address from,
460         address to,
461         uint256 tokenId
462     ) internal virtual {
463         require(ERC721S.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
464         require(to != address(0), "ERC721: transfer to the zero address");
465 
466         _beforeTokenTransfer(from, to, tokenId);
467 
468         // Clear approvals from the previous owner
469         _approve(address(0), tokenId);
470         _owners[tokenId] = to;
471 
472         emit Transfer(from, to, tokenId);
473     }
474 	function _approve(address to, uint256 tokenId) internal virtual {
475         _tokenApprovals[tokenId] = to;
476         emit Approval(ERC721S.ownerOf(tokenId), to, tokenId);
477     }
478 	function _checkOnERC721Received(
479         address from,
480         address to,
481         uint256 tokenId,
482         bytes memory _data
483     ) private returns (bool) {
484         if (to.isContract()) {
485             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
486                 return retval == IERC721Receiver.onERC721Received.selector;
487             } catch (bytes memory reason) {
488                 if (reason.length == 0) {
489                     revert("ERC721: transfer to non ERC721Receiver implementer");
490                 } else {
491                     assembly {
492                         revert(add(32, reason), mload(reason))
493                     }
494                 }
495             }
496         } else {
497             return true;
498         }
499     }
500 	function _beforeTokenTransfer(
501         address from,
502         address to,
503         uint256 tokenId
504     ) internal virtual {}
505 }
506 
507 // SafeMath.sol
508 
509 
510 pragma solidity ^0.8.0;
511 
512 // CAUTION
513 // This version of SafeMath should only be used with Solidity 0.8 or later,
514 // because it relies on the compiler's built in overflow checks.
515 
516 /**
517  * @dev Wrappers over Solidity's arithmetic operations.
518  *
519  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
520  * now has built in overflow checking.
521  */
522 library SafeMath {
523     /**
524      * @dev Returns the addition of two unsigned integers, with an overflow flag.
525      *
526      * _Available since v3.4._
527      */
528     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
529         unchecked {
530             uint256 c = a + b;
531             if (c < a) return (false, 0);
532             return (true, c);
533         }
534     }
535 
536     /**
537      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
538      *
539      * _Available since v3.4._
540      */
541     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
542         unchecked {
543             if (b > a) return (false, 0);
544             return (true, a - b);
545         }
546     }
547 
548     /**
549      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
550      *
551      * _Available since v3.4._
552      */
553     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
554         unchecked {
555             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
556             // benefit is lost if 'b' is also tested.
557             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
558             if (a == 0) return (true, 0);
559             uint256 c = a * b;
560             if (c / a != b) return (false, 0);
561             return (true, c);
562         }
563     }
564 
565     /**
566      * @dev Returns the division of two unsigned integers, with a division by zero flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             if (b == 0) return (false, 0);
573             return (true, a / b);
574         }
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
579      *
580      * _Available since v3.4._
581      */
582     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
583         unchecked {
584             if (b == 0) return (false, 0);
585             return (true, a % b);
586         }
587     }
588 
589     /**
590      * @dev Returns the addition of two unsigned integers, reverting on
591      * overflow.
592      *
593      * Counterpart to Solidity's `+` operator.
594      *
595      * Requirements:
596      *
597      * - Addition cannot overflow.
598      */
599     function add(uint256 a, uint256 b) internal pure returns (uint256) {
600         return a + b;
601     }
602 
603     /**
604      * @dev Returns the subtraction of two unsigned integers, reverting on
605      * overflow (when the result is negative).
606      *
607      * Counterpart to Solidity's `-` operator.
608      *
609      * Requirements:
610      *
611      * - Subtraction cannot overflow.
612      */
613     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
614         return a - b;
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, reverting on
619      * overflow.
620      *
621      * Counterpart to Solidity's `*` operator.
622      *
623      * Requirements:
624      *
625      * - Multiplication cannot overflow.
626      */
627     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a * b;
629     }
630 
631     /**
632      * @dev Returns the integer division of two unsigned integers, reverting on
633      * division by zero. The result is rounded towards zero.
634      *
635      * Counterpart to Solidity's `/` operator.
636      *
637      * Requirements:
638      *
639      * - The divisor cannot be zero.
640      */
641     function div(uint256 a, uint256 b) internal pure returns (uint256) {
642         return a / b;
643     }
644 
645     /**
646      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
647      * reverting when dividing by zero.
648      *
649      * Counterpart to Solidity's `%` operator. This function uses a `revert`
650      * opcode (which leaves remaining gas untouched) while Solidity uses an
651      * invalid opcode to revert (consuming all remaining gas).
652      *
653      * Requirements:
654      *
655      * - The divisor cannot be zero.
656      */
657     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
658         return a % b;
659     }
660 
661     /**
662      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
663      * overflow (when the result is negative).
664      *
665      * CAUTION: This function is deprecated because it requires allocating memory for the error
666      * message unnecessarily. For custom revert reasons use {trySub}.
667      *
668      * Counterpart to Solidity's `-` operator.
669      *
670      * Requirements:
671      *
672      * - Subtraction cannot overflow.
673      */
674     function sub(
675         uint256 a,
676         uint256 b,
677         string memory errorMessage
678     ) internal pure returns (uint256) {
679         unchecked {
680             require(b <= a, errorMessage);
681             return a - b;
682         }
683     }
684 
685     /**
686      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
687      * division by zero. The result is rounded towards zero.
688      *
689      * Counterpart to Solidity's `/` operator. Note: this function uses a
690      * `revert` opcode (which leaves remaining gas untouched) while Solidity
691      * uses an invalid opcode to revert (consuming all remaining gas).
692      *
693      * Requirements:
694      *
695      * - The divisor cannot be zero.
696      */
697     function div(
698         uint256 a,
699         uint256 b,
700         string memory errorMessage
701     ) internal pure returns (uint256) {
702         unchecked {
703             require(b > 0, errorMessage);
704             return a / b;
705         }
706     }
707 
708     /**
709      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
710      * reverting with custom message when dividing by zero.
711      *
712      * CAUTION: This function is deprecated because it requires allocating memory for the error
713      * message unnecessarily. For custom revert reasons use {tryMod}.
714      *
715      * Counterpart to Solidity's `%` operator. This function uses a `revert`
716      * opcode (which leaves remaining gas untouched) while Solidity uses an
717      * invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function mod(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b > 0, errorMessage);
730             return a % b;
731         }
732     }
733 }
734 
735 // Address.sol
736 
737 
738 pragma solidity ^0.8.0;
739 
740 /**
741  * @dev Collection of functions related to the address type
742  */
743 library Address {
744     /**
745      * @dev Returns true if `account` is a contract.
746      *
747      * [IMPORTANT]
748      * ====
749      * It is unsafe to assume that an address for which this function returns
750      * false is an externally-owned account (EOA) and not a contract.
751      *
752      * Among others, `isContract` will return false for the following
753      * types of addresses:
754      *
755      *  - an externally-owned account
756      *  - a contract in construction
757      *  - an address where a contract will be created
758      *  - an address where a contract lived, but was destroyed
759      * ====
760      */
761     function isContract(address account) internal view returns (bool) {
762         // This method relies on extcodesize, which returns 0 for contracts in
763         // construction, since the code is only stored at the end of the
764         // constructor execution.
765 
766         uint256 size;
767         assembly {
768             size := extcodesize(account)
769         }
770         return size > 0;
771     }
772 
773     /**
774      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
775      * `recipient`, forwarding all available gas and reverting on errors.
776      *
777      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
778      * of certain opcodes, possibly making contracts go over the 2300 gas limit
779      * imposed by `transfer`, making them unable to receive funds via
780      * `transfer`. {sendValue} removes this limitation.
781      *
782      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
783      *
784      * IMPORTANT: because control is transferred to `recipient`, care must be
785      * taken to not create reentrancy vulnerabilities. Consider using
786      * {ReentrancyGuard} or the
787      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
788      */
789     function sendValue(address payable recipient, uint256 amount) internal {
790         require(address(this).balance >= amount, "Address: insufficient balance");
791 
792         (bool success, ) = recipient.call{value: amount}("");
793         require(success, "Address: unable to send value, recipient may have reverted");
794     }
795 
796     /**
797      * @dev Performs a Solidity function call using a low level `call`. A
798      * plain `call` is an unsafe replacement for a function call: use this
799      * function instead.
800      *
801      * If `target` reverts with a revert reason, it is bubbled up by this
802      * function (like regular Solidity function calls).
803      *
804      * Returns the raw returned data. To convert to the expected return value,
805      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
806      *
807      * Requirements:
808      *
809      * - `target` must be a contract.
810      * - calling `target` with `data` must not revert.
811      *
812      * _Available since v3.1._
813      */
814     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
815         return functionCall(target, data, "Address: low-level call failed");
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
820      * `errorMessage` as a fallback revert reason when `target` reverts.
821      *
822      * _Available since v3.1._
823      */
824     function functionCall(
825         address target,
826         bytes memory data,
827         string memory errorMessage
828     ) internal returns (bytes memory) {
829         return functionCallWithValue(target, data, 0, errorMessage);
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
834      * but also transferring `value` wei to `target`.
835      *
836      * Requirements:
837      *
838      * - the calling contract must have an ETH balance of at least `value`.
839      * - the called Solidity function must be `payable`.
840      *
841      * _Available since v3.1._
842      */
843     function functionCallWithValue(
844         address target,
845         bytes memory data,
846         uint256 value
847     ) internal returns (bytes memory) {
848         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
853      * with `errorMessage` as a fallback revert reason when `target` reverts.
854      *
855      * _Available since v3.1._
856      */
857     function functionCallWithValue(
858         address target,
859         bytes memory data,
860         uint256 value,
861         string memory errorMessage
862     ) internal returns (bytes memory) {
863         require(address(this).balance >= value, "Address: insufficient balance for call");
864         require(isContract(target), "Address: call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.call{value: value}(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     /**
871      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
872      * but performing a static call.
873      *
874      * _Available since v3.3._
875      */
876     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
877         return functionStaticCall(target, data, "Address: low-level static call failed");
878     }
879 
880     /**
881      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
882      * but performing a static call.
883      *
884      * _Available since v3.3._
885      */
886     function functionStaticCall(
887         address target,
888         bytes memory data,
889         string memory errorMessage
890     ) internal view returns (bytes memory) {
891         require(isContract(target), "Address: static call to non-contract");
892 
893         (bool success, bytes memory returndata) = target.staticcall(data);
894         return verifyCallResult(success, returndata, errorMessage);
895     }
896 
897     /**
898      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
899      * but performing a delegate call.
900      *
901      * _Available since v3.4._
902      */
903     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
904         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
905     }
906 
907     /**
908      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
909      * but performing a delegate call.
910      *
911      * _Available since v3.4._
912      */
913     function functionDelegateCall(
914         address target,
915         bytes memory data,
916         string memory errorMessage
917     ) internal returns (bytes memory) {
918         require(isContract(target), "Address: delegate call to non-contract");
919 
920         (bool success, bytes memory returndata) = target.delegatecall(data);
921         return verifyCallResult(success, returndata, errorMessage);
922     }
923 
924     /**
925      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
926      * revert reason using the provided one.
927      *
928      * _Available since v4.3._
929      */
930     function verifyCallResult(
931         bool success,
932         bytes memory returndata,
933         string memory errorMessage
934     ) internal pure returns (bytes memory) {
935         if (success) {
936             return returndata;
937         } else {
938             // Look for revert reason and bubble it up if present
939             if (returndata.length > 0) {
940                 // The easiest way to bubble the revert reason is using memory via assembly
941 
942                 assembly {
943                     let returndata_size := mload(returndata)
944                     revert(add(32, returndata), returndata_size)
945                 }
946             } else {
947                 revert(errorMessage);
948             }
949         }
950     }
951 }
952 
953 
954 
955 // ERC721Enum.sol
956 
957 pragma solidity ^0.8.10;
958 
959 abstract contract ERC721Enum is ERC721S, IERC721Enumerable {
960     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721S) returns (bool) {
961         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
962     }
963     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
964         require(index < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
965         uint count;
966         for( uint i; i < _owners.length; ++i ){
967             if( owner == _owners[i] ){
968                 if( count == index )
969                     return i;
970                 else
971                     ++count;
972             }
973         }
974         require(false, "ERC721Enum: owner ioob");
975     }
976     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
977         require(0 < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
978         uint256 tokenCount = balanceOf(owner);
979         uint256[] memory tokenIds = new uint256[](tokenCount);
980         for (uint256 i = 0; i < tokenCount; i++) {
981             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
982         }
983         return tokenIds;
984     }
985     function totalSupply() public view virtual override returns (uint256) {
986         return _owners.length;
987     }
988     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
989         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
990         return index;
991     }
992 }
993 
994 // ReentrancyGuard.sol
995 
996 
997 pragma solidity ^0.8.0;
998 
999 /**
1000  * @dev Contract module that helps prevent reentrant calls to a function.
1001  *
1002  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1003  * available, which can be applied to functions to make sure there are no nested
1004  * (reentrant) calls to them.
1005  *
1006  * Note that because there is a single `nonReentrant` guard, functions marked as
1007  * `nonReentrant` may not call one another. This can be worked around by making
1008  * those functions `private`, and then adding `external` `nonReentrant` entry
1009  * points to them.
1010  *
1011  * TIP: If you would like to learn more about reentrancy and alternative ways
1012  * to protect against it, check out our blog post
1013  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1014  */
1015 abstract contract ReentrancyGuard {
1016     // Booleans are more expensive than uint256 or any type that takes up a full
1017     // word because each write operation emits an extra SLOAD to first read the
1018     // slot's contents, replace the bits taken up by the boolean, and then write
1019     // back. This is the compiler's defense against contract upgrades and
1020     // pointer aliasing, and it cannot be disabled.
1021 
1022     // The values being non-zero value makes deployment a bit more expensive,
1023     // but in exchange the refund on every call to nonReentrant will be lower in
1024     // amount. Since refunds are capped to a percentage of the total
1025     // transaction's gas, it is best to keep them low in cases like this one, to
1026     // increase the likelihood of the full refund coming into effect.
1027     uint256 private constant _NOT_ENTERED = 1;
1028     uint256 private constant _ENTERED = 2;
1029 
1030     uint256 private _status;
1031 
1032     constructor() {
1033         _status = _NOT_ENTERED;
1034     }
1035 
1036     /**
1037      * @dev Prevents a contract from calling itself, directly or indirectly.
1038      * Calling a `nonReentrant` function from another `nonReentrant`
1039      * function is not supported. It is possible to prevent this from happening
1040      * by making the `nonReentrant` function external, and make it call a
1041      * `private` function that does the actual work.
1042      */
1043     modifier nonReentrant() {
1044         // On the first call to nonReentrant, _notEntered will be true
1045         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1046 
1047         // Any calls to nonReentrant after this point will fail
1048         _status = _ENTERED;
1049 
1050         _;
1051 
1052         // By storing the original value once again, a refund is triggered (see
1053         // https://eips.ethereum.org/EIPS/eip-2200)
1054         _status = _NOT_ENTERED;
1055     }
1056 }
1057 
1058 // PaymentSplitter.sol
1059 
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 
1064 /**
1065  * @title PaymentSplitter
1066  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1067  * that the Ether will be split in this way, since it is handled transparently by the contract.
1068  *
1069  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1070  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1071  * an amount proportional to the percentage of total shares they were assigned.
1072  *
1073  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1074  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1075  * function.
1076  */
1077 contract PaymentSplitter is Context {
1078     event PayeeAdded(address account, uint256 shares);
1079     event PaymentReleased(address to, uint256 amount);
1080     event PaymentReceived(address from, uint256 amount);
1081 
1082     uint256 private _totalShares;
1083     uint256 private _totalReleased;
1084 
1085     mapping(address => uint256) private _shares;
1086     mapping(address => uint256) private _released;
1087     address[] private _payees;
1088 
1089     /**
1090      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1091      * the matching position in the `shares` array.
1092      *
1093      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1094      * duplicates in `payees`.
1095      */
1096     constructor(address[] memory payees, uint256[] memory shares_) payable {
1097         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1098         require(payees.length > 0, "PaymentSplitter: no payees");
1099 
1100         for (uint256 i = 0; i < payees.length; i++) {
1101             _addPayee(payees[i], shares_[i]);
1102         }
1103     }
1104 
1105     /**
1106      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1107      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1108      * reliability of the events, and not the actual splitting of Ether.
1109      *
1110      * To learn more about this see the Solidity documentation for
1111      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1112      * functions].
1113      */
1114     receive() external payable virtual {
1115         emit PaymentReceived(_msgSender(), msg.value);
1116     }
1117 
1118     /**
1119      * @dev Getter for the total shares held by payees.
1120      */
1121     function totalShares() public view returns (uint256) {
1122         return _totalShares;
1123     }
1124 
1125     /**
1126      * @dev Getter for the total amount of Ether already released.
1127      */
1128     function totalReleased() public view returns (uint256) {
1129         return _totalReleased;
1130     }
1131 
1132     /**
1133      * @dev Getter for the amount of shares held by an account.
1134      */
1135     function shares(address account) public view returns (uint256) {
1136         return _shares[account];
1137     }
1138 
1139     /**
1140      * @dev Getter for the amount of Ether already released to a payee.
1141      */
1142     function released(address account) public view returns (uint256) {
1143         return _released[account];
1144     }
1145 
1146     /**
1147      * @dev Getter for the address of the payee number `index`.
1148      */
1149     function payee(uint256 index) public view returns (address) {
1150         return _payees[index];
1151     }
1152 
1153     /**
1154      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1155      * total shares and their previous withdrawals.
1156      */
1157     function release(address payable account) public virtual {
1158         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1159 
1160         uint256 totalReceived = address(this).balance + _totalReleased;
1161         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1162 
1163         require(payment != 0, "PaymentSplitter: account is not due payment");
1164 
1165         _released[account] = _released[account] + payment;
1166         _totalReleased = _totalReleased + payment;
1167 
1168         Address.sendValue(account, payment);
1169         emit PaymentReleased(account, payment);
1170     }
1171 
1172     /**
1173      * @dev Add a new payee to the contract.
1174      * @param account The address of the payee to add.
1175      * @param shares_ The number of shares owned by the payee.
1176      */
1177     function _addPayee(address account, uint256 shares_) private {
1178         require(account != address(0), "PaymentSplitter: account is the zero address");
1179         require(shares_ > 0, "PaymentSplitter: shares are 0");
1180         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1181 
1182         _payees.push(account);
1183         _shares[account] = shares_;
1184         _totalShares = _totalShares + shares_;
1185         emit PayeeAdded(account, shares_);
1186     }
1187 }
1188 
1189 //  Pausable.sol
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @dev Contract module which allows children to implement an emergency stop
1197  * mechanism that can be triggered by an authorized account.
1198  *
1199  * This module is used through inheritance. It will make available the
1200  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1201  * the functions of your contract. Note that they will not be pausable by
1202  * simply including this module, only once the modifiers are put in place.
1203  */
1204 abstract contract Pausable is Context {
1205     /**
1206      * @dev Emitted when the pause is triggered by `account`.
1207      */
1208     event Paused(address account);
1209 
1210     /**
1211      * @dev Emitted when the pause is lifted by `account`.
1212      */
1213     event Unpaused(address account);
1214 
1215     bool private _paused;
1216 
1217     /**
1218      * @dev Initializes the contract in unpaused state.
1219      */
1220     constructor() {
1221         _paused = false;
1222     }
1223 
1224     /**
1225      * @dev Returns true if the contract is paused, and false otherwise.
1226      */
1227     function paused() public view virtual returns (bool) {
1228         return _paused;
1229     }
1230 
1231     /**
1232      * @dev Modifier to make a function callable only when the contract is not paused.
1233      *
1234      * Requirements:
1235      *
1236      * - The contract must not be paused.
1237      */
1238     modifier whenNotPaused() {
1239         require(!paused(), "Pausable: paused");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Modifier to make a function callable only when the contract is paused.
1245      *
1246      * Requirements:
1247      *
1248      * - The contract must be paused.
1249      */
1250     modifier whenPaused() {
1251         require(paused(), "Pausable: not paused");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Triggers stopped state.
1257      *
1258      * Requirements:
1259      *
1260      * - The contract must not be paused.
1261      */
1262     function _pause() internal virtual whenNotPaused {
1263         _paused = true;
1264         emit Paused(_msgSender());
1265     }
1266 
1267     /**
1268      * @dev Returns to normal state.
1269      *
1270      * Requirements:
1271      *
1272      * - The contract must be paused.
1273      */
1274     function _unpause() internal virtual whenPaused {
1275         _paused = false;
1276         emit Unpaused(_msgSender());
1277     }
1278 }
1279 
1280 // Strings.sol
1281 
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 /**
1286  * @dev String operations.
1287  */
1288 library Strings {
1289     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1290 
1291     /**
1292      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1293      */
1294     function toString(uint256 value) internal pure returns (string memory) {
1295         // Inspired by OraclizeAPI's implementation - MIT licence
1296         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1297 
1298         if (value == 0) {
1299             return "0";
1300         }
1301         uint256 temp = value;
1302         uint256 digits;
1303         while (temp != 0) {
1304             digits++;
1305             temp /= 10;
1306         }
1307         bytes memory buffer = new bytes(digits);
1308         while (value != 0) {
1309             digits -= 1;
1310             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1311             value /= 10;
1312         }
1313         return string(buffer);
1314     }
1315 
1316     /**
1317      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1318      */
1319     function toHexString(uint256 value) internal pure returns (string memory) {
1320         if (value == 0) {
1321             return "0x00";
1322         }
1323         uint256 temp = value;
1324         uint256 length = 0;
1325         while (temp != 0) {
1326             length++;
1327             temp >>= 8;
1328         }
1329         return toHexString(value, length);
1330     }
1331 
1332     /**
1333      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1334      */
1335     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1336         bytes memory buffer = new bytes(2 * length + 2);
1337         buffer[0] = "0";
1338         buffer[1] = "x";
1339         for (uint256 i = 2 * length + 1; i > 1; --i) {
1340             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1341             value >>= 4;
1342         }
1343         require(value == 0, "Strings: hex length insufficient");
1344         return string(buffer);
1345     }
1346 }
1347 
1348 // Ownable.sol
1349 
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 /**
1355  * @dev Contract module which provides a basic access control mechanism, where
1356  * there is an account (an owner) that can be granted exclusive access to
1357  * specific functions.
1358  *
1359  * By default, the owner account will be the one that deploys the contract. This
1360  * can later be changed with {transferOwnership}.
1361  *
1362  * This module is used through inheritance. It will make available the modifier
1363  * `onlyOwner`, which can be applied to your functions to restrict their use to
1364  * the owner.
1365  */
1366 abstract contract Ownable is Context {
1367     address private _owner;
1368 
1369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1370 
1371     /**
1372      * @dev Initializes the contract setting the deployer as the initial owner.
1373      */
1374     constructor() {
1375         _setOwner(_msgSender());
1376     }
1377 
1378     /**
1379      * @dev Returns the address of the current owner.
1380      */
1381     function owner() public view virtual returns (address) {
1382         return _owner;
1383     }
1384 
1385     /**
1386      * @dev Throws if called by any account other than the owner.
1387      */
1388     modifier onlyOwner() {
1389         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1390         _;
1391     }
1392 
1393     /**
1394      * @dev Leaves the contract without owner. It will not be possible to call
1395      * `onlyOwner` functions anymore. Can only be called by the current owner.
1396      *
1397      * NOTE: Renouncing ownership will leave the contract without an owner,
1398      * thereby removing any functionality that is only available to the owner.
1399      */
1400     function renounceOwnership() public virtual onlyOwner {
1401         _setOwner(address(0));
1402     }
1403 
1404     /**
1405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1406      * Can only be called by the current owner.
1407      */
1408     function transferOwnership(address newOwner) public virtual onlyOwner {
1409         require(newOwner != address(0), "Ownable: new owner is the zero address");
1410         _setOwner(newOwner);
1411     }
1412 
1413     function _setOwner(address newOwner) private {
1414         address oldOwner = _owner;
1415         _owner = newOwner;
1416         emit OwnershipTransferred(oldOwner, newOwner);
1417     }
1418 }
1419 
1420 // EtherPirates.sol
1421 
1422 pragma solidity ^0.8.10;
1423 
1424 
1425 contract EtherPirates is ERC721Enum, Ownable, Pausable,  ReentrancyGuard {
1426 
1427 	using Strings for uint256;
1428 	string public baseURI;
1429 	uint256 public cost = 0.03 ether;
1430 	uint256 public maxSupply = 4444;
1431     uint256 public maxFree = 1000;  
1432     uint256 public nftPerAddressLimit = 9;
1433 	bool public status = false;
1434     mapping(address => uint256) public addressMintedBalance;
1435 
1436 		
1437 	constructor() ERC721S("Ether Pirates", "EP"){
1438 	    setBaseURI("");
1439 	}
1440 
1441 	function _baseURI() internal view virtual returns (string memory) {
1442 	    return baseURI;
1443 	}
1444 
1445 	function mint(uint256 _mintAmount) public payable nonReentrant{
1446 		uint256 s = totalSupply();
1447 		require(_mintAmount > 0, "Cant mint 0" );
1448 		require(_mintAmount <= 20, "Cant mint more then maxmint" );
1449 		require(s + _mintAmount <= maxSupply, "Cant go over supply" );
1450 		require(msg.value >= cost * _mintAmount);
1451 		for (uint256 i = 0; i < _mintAmount; ++i) {
1452 			_safeMint(msg.sender, s + i, "");
1453 		}
1454 		delete s;
1455 	}
1456 
1457     	function mintfree(uint256 _mintAmount) public payable nonReentrant{
1458 		uint256 s = totalSupply();
1459         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1460         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1461 		require(_mintAmount > 0, "Cant mint 0" );
1462 		require(_mintAmount <= 3, "Cant mint more than max mint" );
1463 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1464 		for (uint256 i = 0; i < _mintAmount; ++i) {
1465             addressMintedBalance[msg.sender]++;
1466 			_safeMint(msg.sender, s + i, "");
1467 		}
1468 		delete s;
1469 	}
1470 
1471 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1472 		require(quantity.length == recipient.length, "Provide quantities and recipients" );
1473 		uint totalQuantity = 0;
1474 		uint256 s = totalSupply();
1475 		for(uint i = 0; i < quantity.length; ++i){
1476 			totalQuantity += quantity[i];
1477 		}
1478 		require( s + totalQuantity <= maxSupply, "Too many" );
1479 		delete totalQuantity;
1480 		for(uint i = 0; i < recipient.length; ++i){
1481 			for(uint j = 0; j < quantity[i]; ++j){
1482 			_safeMint( recipient[i], s++, "" );
1483 			}
1484 		}
1485 		delete s;	
1486 	}
1487 	
1488 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1489 	    require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1490 	    string memory currentBaseURI = _baseURI();
1491 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
1492 	}
1493 
1494 
1495       function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1496     nftPerAddressLimit = _limit;
1497   }
1498 
1499 	function setCost(uint256 _newCost) public onlyOwner {
1500 	    cost = _newCost;
1501 	}
1502 
1503 	function setmaxFree(uint256 _newMaxFree) public onlyOwner {
1504 	    maxFree = _newMaxFree;
1505 	}
1506     	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1507 	    maxSupply = _newMaxSupply;
1508 	}
1509 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1510 	    baseURI = _newBaseURI;
1511 	}
1512 	function setSaleStatus(bool _status) public onlyOwner {
1513 	    status = _status;
1514 	}
1515 	function withdraw() public payable onlyOwner {
1516 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1517 	require(success);
1518 	}
1519     
1520 }