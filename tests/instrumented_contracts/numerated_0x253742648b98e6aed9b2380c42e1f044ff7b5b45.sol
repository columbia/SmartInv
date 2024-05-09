1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-15
3 */
4 // IERC165.sol
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // ERC165.sol
31 
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Implementation of the {IERC165} interface.
38  *
39  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
40  * for the additional interface id that will be supported. For example:
41  *
42  * ```solidity
43  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
45  * }
46  * ```
47  *
48  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
49  */
50 abstract contract ERC165 is IERC165 {
51     /**
52      * @dev See {IERC165-supportsInterface}.
53      */
54     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
55         return interfaceId == type(IERC165).interfaceId;
56     }
57 }
58 
59 // IERC721.sol
60 
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev Required interface of an ERC721 compliant contract.
66  */
67 interface IERC721 is IERC165 {
68     /**
69      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
75      */
76     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
77 
78     /**
79      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
80      */
81     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
82 
83     /**
84      * @dev Returns the number of tokens in ``owner``'s account.
85      */
86     function balanceOf(address owner) external view returns (uint256 balance);
87 
88     /**
89      * @dev Returns the owner of the `tokenId` token.
90      *
91      * Requirements:
92      *
93      * - `tokenId` must exist.
94      */
95     function ownerOf(uint256 tokenId) external view returns (address owner);
96 
97     /**
98      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
99      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must exist and be owned by `from`.
106      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
108      *
109      * Emits a {Transfer} event.
110      */
111     function safeTransferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Transfers `tokenId` token from `from` to `to`.
119      *
120      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must be owned by `from`.
127      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address from,
133         address to,
134         uint256 tokenId
135     ) external;
136 
137     /**
138      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
139      * The approval is cleared when the token is transferred.
140      *
141      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
142      *
143      * Requirements:
144      *
145      * - The caller must own the token or be an approved operator.
146      * - `tokenId` must exist.
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address to, uint256 tokenId) external;
151 
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160 
161     /**
162      * @dev Approve or remove `operator` as an operator for the caller.
163      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
164      *
165      * Requirements:
166      *
167      * - The `operator` cannot be the caller.
168      *
169      * Emits an {ApprovalForAll} event.
170      */
171     function setApprovalForAll(address operator, bool _approved) external;
172 
173     /**
174      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
175      *
176      * See {setApprovalForAll}
177      */
178     function isApprovedForAll(address owner, address operator) external view returns (bool);
179 
180     /**
181      * @dev Safely transfers `tokenId` token from `from` to `to`.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId,
197         bytes calldata data
198     ) external;
199 }
200 
201 
202 // IERC721Metadata.sol
203 
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228 
229 // IERC721Receiver.sol
230 
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @title ERC721 token receiver interface
236  * @dev Interface for any contract that wants to support safeTransfers
237  * from ERC721 asset contracts.
238  */
239 interface IERC721Receiver {
240     /**
241      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
242      * by `operator` from `from`, this function is called.
243      *
244      * It must return its Solidity selector to confirm the token transfer.
245      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
246      *
247      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
248      */
249     function onERC721Received(
250         address operator,
251         address from,
252         uint256 tokenId,
253         bytes calldata data
254     ) external returns (bytes4);
255 }
256 
257 
258 
259 // IERC721Enumerable.sol
260 
261 
262 pragma solidity ^0.8.0;
263 
264 
265 /**
266  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
267  * @dev See https://eips.ethereum.org/EIPS/eip-721
268  */
269 interface IERC721Enumerable is IERC721 {
270     /**
271      * @dev Returns the total amount of tokens stored by the contract.
272      */
273     function totalSupply() external view returns (uint256);
274 
275     /**
276      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
277      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
278      */
279     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
280 
281     /**
282      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
283      * Use along with {totalSupply} to enumerate all tokens.
284      */
285     function tokenByIndex(uint256 index) external view returns (uint256);
286 }
287 
288 
289 // Context.sol
290 
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Provides information about the current execution context, including the
296  * sender of the transaction and its data. While these are generally available
297  * via msg.sender and msg.data, they should not be accessed in such a direct
298  * manner, since when dealing with meta-transactions the account sending and
299  * paying for execution may not be the actual sender (as far as an application
300  * is concerned).
301  *
302  * This contract is only required for intermediate, library-like contracts.
303  */
304 abstract contract Context {
305     function _msgSender() internal view virtual returns (address) {
306         return msg.sender;
307     }
308 
309     function _msgData() internal view virtual returns (bytes calldata) {
310         return msg.data;
311     }
312 }
313 
314 // ERC721S.sol
315 
316 pragma solidity ^0.8.10;
317 
318 
319 abstract contract ERC721S is Context, ERC165, IERC721, IERC721Metadata {
320     using Address for address;
321     string private _name;
322     string private _symbol;
323     address[] internal _owners;
324     mapping(uint256 => address) private _tokenApprovals;
325     mapping(address => mapping(address => bool)) private _operatorApprovals;     
326     constructor(string memory name_, string memory symbol_) {
327         _name = name_;
328         _symbol = symbol_;
329     }     
330     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
331         return
332             interfaceId == type(IERC721).interfaceId ||
333             interfaceId == type(IERC721Metadata).interfaceId ||
334             super.supportsInterface(interfaceId);
335     }
336     function balanceOf(address owner) public view virtual override returns (uint256) {
337         require(owner != address(0), "ERC721: balance query for the zero address");
338         uint count = 0;
339         uint length = _owners.length;
340         for( uint i = 0; i < length; ++i ){
341           if( owner == _owners[i] ){
342             ++count;
343           }
344         }
345         delete length;
346         return count;
347     }
348     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
349         address owner = _owners[tokenId];
350         require(owner != address(0), "ERC721: owner query for nonexistent token");
351         return owner;
352     }
353     function name() public view virtual override returns (string memory) {
354         return _name;
355     }
356     function symbol() public view virtual override returns (string memory) {
357         return _symbol;
358     }
359     function approve(address to, uint256 tokenId) public virtual override {
360         address owner = ERC721S.ownerOf(tokenId);
361         require(to != owner, "ERC721: approval to current owner");
362 
363         require(
364             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
365             "ERC721: approve caller is not owner nor approved for all"
366         );
367 
368         _approve(to, tokenId);
369     }
370     function getApproved(uint256 tokenId) public view virtual override returns (address) {
371         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
372 
373         return _tokenApprovals[tokenId];
374     }
375     function setApprovalForAll(address operator, bool approved) public virtual override {
376         require(operator != _msgSender(), "ERC721: approve to caller");
377 
378         _operatorApprovals[_msgSender()][operator] = approved;
379         emit ApprovalForAll(_msgSender(), operator, approved);
380     }
381     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
382         return _operatorApprovals[owner][operator];
383     }
384     function transferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) public virtual override {
389         //solhint-disable-next-line max-line-length
390         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
391 
392         _transfer(from, to, tokenId);
393     }
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) public virtual override {
399         safeTransferFrom(from, to, tokenId, "");
400     }
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId,
405         bytes memory _data
406     ) public virtual override {
407         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
408         _safeTransfer(from, to, tokenId, _data);
409     }     
410     function _safeTransfer(
411         address from,
412         address to,
413         uint256 tokenId,
414         bytes memory _data
415     ) internal virtual {
416         _transfer(from, to, tokenId);
417         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
418     }
419 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
420         return tokenId < _owners.length && _owners[tokenId] != address(0);
421     }
422 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
424         address owner = ERC721S.ownerOf(tokenId);
425         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
426     }
427 	function _safeMint(address to, uint256 tokenId) internal virtual {
428         _safeMint(to, tokenId, "");
429     }
430 	function _safeMint(
431         address to,
432         uint256 tokenId,
433         bytes memory _data
434     ) internal virtual {
435         _mint(to, tokenId);
436         require(
437             _checkOnERC721Received(address(0), to, tokenId, _data),
438             "ERC721: transfer to non ERC721Receiver implementer"
439         );
440     }
441 	function _mint(address to, uint256 tokenId) internal virtual {
442         require(to != address(0), "ERC721: mint to the zero address");
443         require(!_exists(tokenId), "ERC721: token already minted");
444 
445         _beforeTokenTransfer(address(0), to, tokenId);
446         _owners.push(to);
447 
448         emit Transfer(address(0), to, tokenId);
449     }
450 	function _burn(uint256 tokenId) internal virtual {
451         address owner = ERC721S.ownerOf(tokenId);
452 
453         _beforeTokenTransfer(owner, address(0), tokenId);
454 
455         // Clear approvals
456         _approve(address(0), tokenId);
457         _owners[tokenId] = address(0);
458 
459         emit Transfer(owner, address(0), tokenId);
460     }
461 	function _transfer(
462         address from,
463         address to,
464         uint256 tokenId
465     ) internal virtual {
466         require(ERC721S.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
467         require(to != address(0), "ERC721: transfer to the zero address");
468 
469         _beforeTokenTransfer(from, to, tokenId);
470 
471         // Clear approvals from the previous owner
472         _approve(address(0), tokenId);
473         _owners[tokenId] = to;
474 
475         emit Transfer(from, to, tokenId);
476     }
477 	function _approve(address to, uint256 tokenId) internal virtual {
478         _tokenApprovals[tokenId] = to;
479         emit Approval(ERC721S.ownerOf(tokenId), to, tokenId);
480     }
481 	function _checkOnERC721Received(
482         address from,
483         address to,
484         uint256 tokenId,
485         bytes memory _data
486     ) private returns (bool) {
487         if (to.isContract()) {
488             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
489                 return retval == IERC721Receiver.onERC721Received.selector;
490             } catch (bytes memory reason) {
491                 if (reason.length == 0) {
492                     revert("ERC721: transfer to non ERC721Receiver implementer");
493                 } else {
494                     assembly {
495                         revert(add(32, reason), mload(reason))
496                     }
497                 }
498             }
499         } else {
500             return true;
501         }
502     }
503 	function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 tokenId
507     ) internal virtual {}
508 }
509 
510 // SafeMath.sol
511 
512 
513 pragma solidity ^0.8.0;
514 
515 // CAUTION
516 // This version of SafeMath should only be used with Solidity 0.8 or later,
517 // because it relies on the compiler's built in overflow checks.
518 
519 /**
520  * @dev Wrappers over Solidity's arithmetic operations.
521  *
522  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
523  * now has built in overflow checking.
524  */
525 library SafeMath {
526     /**
527      * @dev Returns the addition of two unsigned integers, with an overflow flag.
528      *
529      * _Available since v3.4._
530      */
531     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
532         unchecked {
533             uint256 c = a + b;
534             if (c < a) return (false, 0);
535             return (true, c);
536         }
537     }
538 
539     /**
540      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
541      *
542      * _Available since v3.4._
543      */
544     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
545         unchecked {
546             if (b > a) return (false, 0);
547             return (true, a - b);
548         }
549     }
550 
551     /**
552      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
553      *
554      * _Available since v3.4._
555      */
556     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
557         unchecked {
558             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
559             // benefit is lost if 'b' is also tested.
560             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
561             if (a == 0) return (true, 0);
562             uint256 c = a * b;
563             if (c / a != b) return (false, 0);
564             return (true, c);
565         }
566     }
567 
568     /**
569      * @dev Returns the division of two unsigned integers, with a division by zero flag.
570      *
571      * _Available since v3.4._
572      */
573     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574         unchecked {
575             if (b == 0) return (false, 0);
576             return (true, a / b);
577         }
578     }
579 
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
582      *
583      * _Available since v3.4._
584      */
585     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
586         unchecked {
587             if (b == 0) return (false, 0);
588             return (true, a % b);
589         }
590     }
591 
592     /**
593      * @dev Returns the addition of two unsigned integers, reverting on
594      * overflow.
595      *
596      * Counterpart to Solidity's `+` operator.
597      *
598      * Requirements:
599      *
600      * - Addition cannot overflow.
601      */
602     function add(uint256 a, uint256 b) internal pure returns (uint256) {
603         return a + b;
604     }
605 
606     /**
607      * @dev Returns the subtraction of two unsigned integers, reverting on
608      * overflow (when the result is negative).
609      *
610      * Counterpart to Solidity's `-` operator.
611      *
612      * Requirements:
613      *
614      * - Subtraction cannot overflow.
615      */
616     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a - b;
618     }
619 
620     /**
621      * @dev Returns the multiplication of two unsigned integers, reverting on
622      * overflow.
623      *
624      * Counterpart to Solidity's `*` operator.
625      *
626      * Requirements:
627      *
628      * - Multiplication cannot overflow.
629      */
630     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
631         return a * b;
632     }
633 
634     /**
635      * @dev Returns the integer division of two unsigned integers, reverting on
636      * division by zero. The result is rounded towards zero.
637      *
638      * Counterpart to Solidity's `/` operator.
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function div(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a / b;
646     }
647 
648     /**
649      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
650      * reverting when dividing by zero.
651      *
652      * Counterpart to Solidity's `%` operator. This function uses a `revert`
653      * opcode (which leaves remaining gas untouched) while Solidity uses an
654      * invalid opcode to revert (consuming all remaining gas).
655      *
656      * Requirements:
657      *
658      * - The divisor cannot be zero.
659      */
660     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a % b;
662     }
663 
664     /**
665      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
666      * overflow (when the result is negative).
667      *
668      * CAUTION: This function is deprecated because it requires allocating memory for the error
669      * message unnecessarily. For custom revert reasons use {trySub}.
670      *
671      * Counterpart to Solidity's `-` operator.
672      *
673      * Requirements:
674      *
675      * - Subtraction cannot overflow.
676      */
677     function sub(
678         uint256 a,
679         uint256 b,
680         string memory errorMessage
681     ) internal pure returns (uint256) {
682         unchecked {
683             require(b <= a, errorMessage);
684             return a - b;
685         }
686     }
687 
688     /**
689      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
690      * division by zero. The result is rounded towards zero.
691      *
692      * Counterpart to Solidity's `/` operator. Note: this function uses a
693      * `revert` opcode (which leaves remaining gas untouched) while Solidity
694      * uses an invalid opcode to revert (consuming all remaining gas).
695      *
696      * Requirements:
697      *
698      * - The divisor cannot be zero.
699      */
700     function div(
701         uint256 a,
702         uint256 b,
703         string memory errorMessage
704     ) internal pure returns (uint256) {
705         unchecked {
706             require(b > 0, errorMessage);
707             return a / b;
708         }
709     }
710 
711     /**
712      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
713      * reverting with custom message when dividing by zero.
714      *
715      * CAUTION: This function is deprecated because it requires allocating memory for the error
716      * message unnecessarily. For custom revert reasons use {tryMod}.
717      *
718      * Counterpart to Solidity's `%` operator. This function uses a `revert`
719      * opcode (which leaves remaining gas untouched) while Solidity uses an
720      * invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function mod(
727         uint256 a,
728         uint256 b,
729         string memory errorMessage
730     ) internal pure returns (uint256) {
731         unchecked {
732             require(b > 0, errorMessage);
733             return a % b;
734         }
735     }
736 }
737 
738 // Address.sol
739 
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev Collection of functions related to the address type
745  */
746 library Address {
747     /**
748      * @dev Returns true if `account` is a contract.
749      *
750      * [IMPORTANT]
751      * ====
752      * It is unsafe to assume that an address for which this function returns
753      * false is an externally-owned account (EOA) and not a contract.
754      *
755      * Among others, `isContract` will return false for the following
756      * types of addresses:
757      *
758      *  - an externally-owned account
759      *  - a contract in construction
760      *  - an address where a contract will be created
761      *  - an address where a contract lived, but was destroyed
762      * ====
763      */
764     function isContract(address account) internal view returns (bool) {
765         // This method relies on extcodesize, which returns 0 for contracts in
766         // construction, since the code is only stored at the end of the
767         // constructor execution.
768 
769         uint256 size;
770         assembly {
771             size := extcodesize(account)
772         }
773         return size > 0;
774     }
775 
776     /**
777      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
778      * `recipient`, forwarding all available gas and reverting on errors.
779      *
780      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
781      * of certain opcodes, possibly making contracts go over the 2300 gas limit
782      * imposed by `transfer`, making them unable to receive funds via
783      * `transfer`. {sendValue} removes this limitation.
784      *
785      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
786      *
787      * IMPORTANT: because control is transferred to `recipient`, care must be
788      * taken to not create reentrancy vulnerabilities. Consider using
789      * {ReentrancyGuard} or the
790      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
791      */
792     function sendValue(address payable recipient, uint256 amount) internal {
793         require(address(this).balance >= amount, "Address: insufficient balance");
794 
795         (bool success, ) = recipient.call{value: amount}("");
796         require(success, "Address: unable to send value, recipient may have reverted");
797     }
798 
799     /**
800      * @dev Performs a Solidity function call using a low level `call`. A
801      * plain `call` is an unsafe replacement for a function call: use this
802      * function instead.
803      *
804      * If `target` reverts with a revert reason, it is bubbled up by this
805      * function (like regular Solidity function calls).
806      *
807      * Returns the raw returned data. To convert to the expected return value,
808      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
809      *
810      * Requirements:
811      *
812      * - `target` must be a contract.
813      * - calling `target` with `data` must not revert.
814      *
815      * _Available since v3.1._
816      */
817     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
818         return functionCall(target, data, "Address: low-level call failed");
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
823      * `errorMessage` as a fallback revert reason when `target` reverts.
824      *
825      * _Available since v3.1._
826      */
827     function functionCall(
828         address target,
829         bytes memory data,
830         string memory errorMessage
831     ) internal returns (bytes memory) {
832         return functionCallWithValue(target, data, 0, errorMessage);
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
837      * but also transferring `value` wei to `target`.
838      *
839      * Requirements:
840      *
841      * - the calling contract must have an ETH balance of at least `value`.
842      * - the called Solidity function must be `payable`.
843      *
844      * _Available since v3.1._
845      */
846     function functionCallWithValue(
847         address target,
848         bytes memory data,
849         uint256 value
850     ) internal returns (bytes memory) {
851         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
852     }
853 
854     /**
855      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
856      * with `errorMessage` as a fallback revert reason when `target` reverts.
857      *
858      * _Available since v3.1._
859      */
860     function functionCallWithValue(
861         address target,
862         bytes memory data,
863         uint256 value,
864         string memory errorMessage
865     ) internal returns (bytes memory) {
866         require(address(this).balance >= value, "Address: insufficient balance for call");
867         require(isContract(target), "Address: call to non-contract");
868 
869         (bool success, bytes memory returndata) = target.call{value: value}(data);
870         return verifyCallResult(success, returndata, errorMessage);
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
875      * but performing a static call.
876      *
877      * _Available since v3.3._
878      */
879     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
880         return functionStaticCall(target, data, "Address: low-level static call failed");
881     }
882 
883     /**
884      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
885      * but performing a static call.
886      *
887      * _Available since v3.3._
888      */
889     function functionStaticCall(
890         address target,
891         bytes memory data,
892         string memory errorMessage
893     ) internal view returns (bytes memory) {
894         require(isContract(target), "Address: static call to non-contract");
895 
896         (bool success, bytes memory returndata) = target.staticcall(data);
897         return verifyCallResult(success, returndata, errorMessage);
898     }
899 
900     /**
901      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
902      * but performing a delegate call.
903      *
904      * _Available since v3.4._
905      */
906     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
907         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
912      * but performing a delegate call.
913      *
914      * _Available since v3.4._
915      */
916     function functionDelegateCall(
917         address target,
918         bytes memory data,
919         string memory errorMessage
920     ) internal returns (bytes memory) {
921         require(isContract(target), "Address: delegate call to non-contract");
922 
923         (bool success, bytes memory returndata) = target.delegatecall(data);
924         return verifyCallResult(success, returndata, errorMessage);
925     }
926 
927     /**
928      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
929      * revert reason using the provided one.
930      *
931      * _Available since v4.3._
932      */
933     function verifyCallResult(
934         bool success,
935         bytes memory returndata,
936         string memory errorMessage
937     ) internal pure returns (bytes memory) {
938         if (success) {
939             return returndata;
940         } else {
941             // Look for revert reason and bubble it up if present
942             if (returndata.length > 0) {
943                 // The easiest way to bubble the revert reason is using memory via assembly
944 
945                 assembly {
946                     let returndata_size := mload(returndata)
947                     revert(add(32, returndata), returndata_size)
948                 }
949             } else {
950                 revert(errorMessage);
951             }
952         }
953     }
954 }
955 
956 
957 
958 // ERC721Enum.sol
959 
960 pragma solidity ^0.8.10;
961 
962 abstract contract ERC721Enum is ERC721S, IERC721Enumerable {
963     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721S) returns (bool) {
964         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
965     }
966     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
967         require(index < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
968         uint count;
969         for( uint i; i < _owners.length; ++i ){
970             if( owner == _owners[i] ){
971                 if( count == index )
972                     return i;
973                 else
974                     ++count;
975             }
976         }
977         require(false, "ERC721Enum: owner ioob");
978     }
979     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
980         require(0 < ERC721S.balanceOf(owner), "ERC721Enum: owner ioob");
981         uint256 tokenCount = balanceOf(owner);
982         uint256[] memory tokenIds = new uint256[](tokenCount);
983         for (uint256 i = 0; i < tokenCount; i++) {
984             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
985         }
986         return tokenIds;
987     }
988     function totalSupply() public view virtual override returns (uint256) {
989         return _owners.length;
990     }
991     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
992         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
993         return index;
994     }
995 }
996 
997 // ReentrancyGuard.sol
998 
999 
1000 pragma solidity ^0.8.0;
1001 
1002 /**
1003  * @dev Contract module that helps prevent reentrant calls to a function.
1004  *
1005  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1006  * available, which can be applied to functions to make sure there are no nested
1007  * (reentrant) calls to them.
1008  *
1009  * Note that because there is a single `nonReentrant` guard, functions marked as
1010  * `nonReentrant` may not call one another. This can be worked around by making
1011  * those functions `private`, and then adding `external` `nonReentrant` entry
1012  * points to them.
1013  *
1014  * TIP: If you would like to learn more about reentrancy and alternative ways
1015  * to protect against it, check out our blog post
1016  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1017  */
1018 abstract contract ReentrancyGuard {
1019     // Booleans are more expensive than uint256 or any type that takes up a full
1020     // word because each write operation emits an extra SLOAD to first read the
1021     // slot's contents, replace the bits taken up by the boolean, and then write
1022     // back. This is the compiler's defense against contract upgrades and
1023     // pointer aliasing, and it cannot be disabled.
1024 
1025     // The values being non-zero value makes deployment a bit more expensive,
1026     // but in exchange the refund on every call to nonReentrant will be lower in
1027     // amount. Since refunds are capped to a percentage of the total
1028     // transaction's gas, it is best to keep them low in cases like this one, to
1029     // increase the likelihood of the full refund coming into effect.
1030     uint256 private constant _NOT_ENTERED = 1;
1031     uint256 private constant _ENTERED = 2;
1032 
1033     uint256 private _status;
1034 
1035     constructor() {
1036         _status = _NOT_ENTERED;
1037     }
1038 
1039     /**
1040      * @dev Prevents a contract from calling itself, directly or indirectly.
1041      * Calling a `nonReentrant` function from another `nonReentrant`
1042      * function is not supported. It is possible to prevent this from happening
1043      * by making the `nonReentrant` function external, and make it call a
1044      * `private` function that does the actual work.
1045      */
1046     modifier nonReentrant() {
1047         // On the first call to nonReentrant, _notEntered will be true
1048         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1049 
1050         // Any calls to nonReentrant after this point will fail
1051         _status = _ENTERED;
1052 
1053         _;
1054 
1055         // By storing the original value once again, a refund is triggered (see
1056         // https://eips.ethereum.org/EIPS/eip-2200)
1057         _status = _NOT_ENTERED;
1058     }
1059 }
1060 
1061 // PaymentSplitter.sol
1062 
1063 
1064 pragma solidity ^0.8.0;
1065 
1066 
1067 /**
1068  * @title PaymentSplitter
1069  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1070  * that the Ether will be split in this way, since it is handled transparently by the contract.
1071  *
1072  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1073  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1074  * an amount proportional to the percentage of total shares they were assigned.
1075  *
1076  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1077  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1078  * function.
1079  */
1080 contract PaymentSplitter is Context {
1081     event PayeeAdded(address account, uint256 shares);
1082     event PaymentReleased(address to, uint256 amount);
1083     event PaymentReceived(address from, uint256 amount);
1084 
1085     uint256 private _totalShares;
1086     uint256 private _totalReleased;
1087 
1088     mapping(address => uint256) private _shares;
1089     mapping(address => uint256) private _released;
1090     address[] private _payees;
1091 
1092     /**
1093      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1094      * the matching position in the `shares` array.
1095      *
1096      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1097      * duplicates in `payees`.
1098      */
1099     constructor(address[] memory payees, uint256[] memory shares_) payable {
1100         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1101         require(payees.length > 0, "PaymentSplitter: no payees");
1102 
1103         for (uint256 i = 0; i < payees.length; i++) {
1104             _addPayee(payees[i], shares_[i]);
1105         }
1106     }
1107 
1108     /**
1109      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1110      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1111      * reliability of the events, and not the actual splitting of Ether.
1112      *
1113      * To learn more about this see the Solidity documentation for
1114      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1115      * functions].
1116      */
1117     receive() external payable virtual {
1118         emit PaymentReceived(_msgSender(), msg.value);
1119     }
1120 
1121     /**
1122      * @dev Getter for the total shares held by payees.
1123      */
1124     function totalShares() public view returns (uint256) {
1125         return _totalShares;
1126     }
1127 
1128     /**
1129      * @dev Getter for the total amount of Ether already released.
1130      */
1131     function totalReleased() public view returns (uint256) {
1132         return _totalReleased;
1133     }
1134 
1135     /**
1136      * @dev Getter for the amount of shares held by an account.
1137      */
1138     function shares(address account) public view returns (uint256) {
1139         return _shares[account];
1140     }
1141 
1142     /**
1143      * @dev Getter for the amount of Ether already released to a payee.
1144      */
1145     function released(address account) public view returns (uint256) {
1146         return _released[account];
1147     }
1148 
1149     /**
1150      * @dev Getter for the address of the payee number `index`.
1151      */
1152     function payee(uint256 index) public view returns (address) {
1153         return _payees[index];
1154     }
1155 
1156     /**
1157      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1158      * total shares and their previous withdrawals.
1159      */
1160     function release(address payable account) public virtual {
1161         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1162 
1163         uint256 totalReceived = address(this).balance + _totalReleased;
1164         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1165 
1166         require(payment != 0, "PaymentSplitter: account is not due payment");
1167 
1168         _released[account] = _released[account] + payment;
1169         _totalReleased = _totalReleased + payment;
1170 
1171         Address.sendValue(account, payment);
1172         emit PaymentReleased(account, payment);
1173     }
1174 
1175     /**
1176      * @dev Add a new payee to the contract.
1177      * @param account The address of the payee to add.
1178      * @param shares_ The number of shares owned by the payee.
1179      */
1180     function _addPayee(address account, uint256 shares_) private {
1181         require(account != address(0), "PaymentSplitter: account is the zero address");
1182         require(shares_ > 0, "PaymentSplitter: shares are 0");
1183         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1184 
1185         _payees.push(account);
1186         _shares[account] = shares_;
1187         _totalShares = _totalShares + shares_;
1188         emit PayeeAdded(account, shares_);
1189     }
1190 }
1191 
1192 //  Pausable.sol
1193 
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 /**
1199  * @dev Contract module which allows children to implement an emergency stop
1200  * mechanism that can be triggered by an authorized account.
1201  *
1202  * This module is used through inheritance. It will make available the
1203  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1204  * the functions of your contract. Note that they will not be pausable by
1205  * simply including this module, only once the modifiers are put in place.
1206  */
1207 abstract contract Pausable is Context {
1208     /**
1209      * @dev Emitted when the pause is triggered by `account`.
1210      */
1211     event Paused(address account);
1212 
1213     /**
1214      * @dev Emitted when the pause is lifted by `account`.
1215      */
1216     event Unpaused(address account);
1217 
1218     bool private _paused;
1219 
1220     /**
1221      * @dev Initializes the contract in unpaused state.
1222      */
1223     constructor() {
1224         _paused = false;
1225     }
1226 
1227     /**
1228      * @dev Returns true if the contract is paused, and false otherwise.
1229      */
1230     function paused() public view virtual returns (bool) {
1231         return _paused;
1232     }
1233 
1234     /**
1235      * @dev Modifier to make a function callable only when the contract is not paused.
1236      *
1237      * Requirements:
1238      *
1239      * - The contract must not be paused.
1240      */
1241     modifier whenNotPaused() {
1242         require(!paused(), "Pausable: paused");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Modifier to make a function callable only when the contract is paused.
1248      *
1249      * Requirements:
1250      *
1251      * - The contract must be paused.
1252      */
1253     modifier whenPaused() {
1254         require(paused(), "Pausable: not paused");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Triggers stopped state.
1260      *
1261      * Requirements:
1262      *
1263      * - The contract must not be paused.
1264      */
1265     function _pause() internal virtual whenNotPaused {
1266         _paused = true;
1267         emit Paused(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns to normal state.
1272      *
1273      * Requirements:
1274      *
1275      * - The contract must be paused.
1276      */
1277     function _unpause() internal virtual whenPaused {
1278         _paused = false;
1279         emit Unpaused(_msgSender());
1280     }
1281 }
1282 
1283 // Strings.sol
1284 
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev String operations.
1290  */
1291 library Strings {
1292     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1293 
1294     /**
1295      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1296      */
1297     function toString(uint256 value) internal pure returns (string memory) {
1298         // Inspired by OraclizeAPI's implementation - MIT licence
1299         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1300 
1301         if (value == 0) {
1302             return "0";
1303         }
1304         uint256 temp = value;
1305         uint256 digits;
1306         while (temp != 0) {
1307             digits++;
1308             temp /= 10;
1309         }
1310         bytes memory buffer = new bytes(digits);
1311         while (value != 0) {
1312             digits -= 1;
1313             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1314             value /= 10;
1315         }
1316         return string(buffer);
1317     }
1318 
1319     /**
1320      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1321      */
1322     function toHexString(uint256 value) internal pure returns (string memory) {
1323         if (value == 0) {
1324             return "0x00";
1325         }
1326         uint256 temp = value;
1327         uint256 length = 0;
1328         while (temp != 0) {
1329             length++;
1330             temp >>= 8;
1331         }
1332         return toHexString(value, length);
1333     }
1334 
1335     /**
1336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1337      */
1338     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1339         bytes memory buffer = new bytes(2 * length + 2);
1340         buffer[0] = "0";
1341         buffer[1] = "x";
1342         for (uint256 i = 2 * length + 1; i > 1; --i) {
1343             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1344             value >>= 4;
1345         }
1346         require(value == 0, "Strings: hex length insufficient");
1347         return string(buffer);
1348     }
1349 }
1350 
1351 // Ownable.sol
1352 
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 
1357 /**
1358  * @dev Contract module which provides a basic access control mechanism, where
1359  * there is an account (an owner) that can be granted exclusive access to
1360  * specific functions.
1361  *
1362  * By default, the owner account will be the one that deploys the contract. This
1363  * can later be changed with {transferOwnership}.
1364  *
1365  * This module is used through inheritance. It will make available the modifier
1366  * `onlyOwner`, which can be applied to your functions to restrict their use to
1367  * the owner.
1368  */
1369 abstract contract Ownable is Context {
1370     address private _owner;
1371 
1372     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1373 
1374     /**
1375      * @dev Initializes the contract setting the deployer as the initial owner.
1376      */
1377     constructor() {
1378         _setOwner(_msgSender());
1379     }
1380 
1381     /**
1382      * @dev Returns the address of the current owner.
1383      */
1384     function owner() public view virtual returns (address) {
1385         return _owner;
1386     }
1387 
1388     /**
1389      * @dev Throws if called by any account other than the owner.
1390      */
1391     modifier onlyOwner() {
1392         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1393         _;
1394     }
1395 
1396     /**
1397      * @dev Leaves the contract without owner. It will not be possible to call
1398      * `onlyOwner` functions anymore. Can only be called by the current owner.
1399      *
1400      * NOTE: Renouncing ownership will leave the contract without an owner,
1401      * thereby removing any functionality that is only available to the owner.
1402      */
1403     function renounceOwnership() public virtual onlyOwner {
1404         _setOwner(address(0));
1405     }
1406 
1407     /**
1408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1409      * Can only be called by the current owner.
1410      */
1411     function transferOwnership(address newOwner) public virtual onlyOwner {
1412         require(newOwner != address(0), "Ownable: new owner is the zero address");
1413         _setOwner(newOwner);
1414     }
1415 
1416     function _setOwner(address newOwner) private {
1417         address oldOwner = _owner;
1418         _owner = newOwner;
1419         emit OwnershipTransferred(oldOwner, newOwner);
1420     }
1421 }
1422 
1423 // Doods.sol
1424 
1425 pragma solidity ^0.8.10;
1426 
1427 
1428 contract WomenDoods is ERC721Enum, Ownable, Pausable,  ReentrancyGuard {
1429 
1430 	using Strings for uint256;
1431 	string public baseURI;
1432 	uint256 public cost = 0.008 ether;
1433 	uint256 public maxSupply = 7000;
1434     uint256 public maxFree = 1000;  
1435     uint256 public nftPerAddressLimit = 20;
1436 	bool public status = true;
1437     mapping(address => uint256) public addressMintedBalance;
1438 
1439 		
1440 	constructor() ERC721S("Women Doods", "WDoods"){
1441 	    setBaseURI("");
1442 	}
1443 
1444 	function _baseURI() internal view virtual returns (string memory) {
1445 	    return baseURI;
1446 	}
1447 
1448 	function mint(uint256 _mintAmount) public payable nonReentrant{
1449 		uint256 s = totalSupply();
1450 		require(_mintAmount > 0, "Cant mint 0" );
1451 		require(_mintAmount <= 20, "Cant mint more then maxmint" );
1452 		require(s + _mintAmount <= maxSupply, "Cant go over supply" );
1453 		require(msg.value >= cost * _mintAmount);
1454 		for (uint256 i = 0; i < _mintAmount; ++i) {
1455 			_safeMint(msg.sender, s + i, "");
1456 		}
1457 		delete s;
1458 	}
1459 
1460     	function mintfree(uint256 _mintAmount) public payable nonReentrant{
1461 		uint256 s = totalSupply();
1462         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1463         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1464 		require(_mintAmount > 0, "Cant mint 0" );
1465 		require(_mintAmount <= 10, "Cant mint more then maxmint" );
1466 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1467 		for (uint256 i = 0; i < _mintAmount; ++i) {
1468             addressMintedBalance[msg.sender]++;
1469 			_safeMint(msg.sender, s + i, "");
1470 		}
1471 		delete s;
1472 	}
1473 
1474 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1475 		require(quantity.length == recipient.length, "Provide quantities and recipients" );
1476 		uint totalQuantity = 0;
1477 		uint256 s = totalSupply();
1478 		for(uint i = 0; i < quantity.length; ++i){
1479 			totalQuantity += quantity[i];
1480 		}
1481 		require( s + totalQuantity <= maxSupply, "Too many" );
1482 		delete totalQuantity;
1483 		for(uint i = 0; i < recipient.length; ++i){
1484 			for(uint j = 0; j < quantity[i]; ++j){
1485 			_safeMint( recipient[i], s++, "" );
1486 			}
1487 		}
1488 		delete s;	
1489 	}
1490 	
1491 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1492 	    require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1493 	    string memory currentBaseURI = _baseURI();
1494 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
1495 	}
1496 
1497 
1498       function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1499     nftPerAddressLimit = _limit;
1500   }
1501 
1502 	function setCost(uint256 _newCost) public onlyOwner {
1503 	    cost = _newCost;
1504 	}
1505 
1506 	function setmaxFree(uint256 _newMaxFree) public onlyOwner {
1507 	    maxFree = _newMaxFree;
1508 	}
1509     	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1510 	    maxSupply = _newMaxSupply;
1511 	}
1512 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1513 	    baseURI = _newBaseURI;
1514 	}
1515 	function setSaleStatus(bool _status) public onlyOwner {
1516 	    status = _status;
1517 	}
1518 	function withdraw() public payable onlyOwner {
1519 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1520 	require(success);
1521 	}
1522     
1523 }