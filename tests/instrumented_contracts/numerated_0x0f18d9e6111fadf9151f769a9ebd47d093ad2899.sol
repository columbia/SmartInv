1 // SPDX-License-Identifier: MIT
2 // Pepe Ape Yacht Club Portal Contract
3 
4 pragma solidity ^0.8.0;
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36 }
37 
38 // File: @openzeppelin/contracts/utils/Context.sol
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/access/Ownable.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @title ERC721 token receiver interface
152  * @dev Interface for any contract that wants to support safeTransfers
153  * from ERC721 asset contracts.
154  */
155 interface IERC721Receiver {
156     /**
157      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
158      * by `operator` from `from`, this function is called.
159      *
160      * It must return its Solidity selector to confirm the token transfer.
161      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
162      *
163      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
164      */
165     function onERC721Received(
166         address operator,
167         address from,
168         uint256 tokenId,
169         bytes calldata data
170     ) external returns (bytes4);
171 }
172 
173 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC165 standard, as defined in the
182  * https://eips.ethereum.org/EIPS/eip-165[EIP].
183  *
184  * Implementers can declare support of contract interfaces, which can then be
185  * queried by others ({ERC165Checker}).
186  *
187  * For an implementation, see {ERC165}.
188  */
189 interface IERC165 {
190     /**
191      * @dev Returns true if this contract implements the interface defined by
192      * `interfaceId`. See the corresponding
193      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
194      * to learn more about how these ids are created.
195      *
196      * This function call must use less than 30 000 gas.
197      */
198     function supportsInterface(bytes4 interfaceId) external view returns (bool);
199 }
200 
201 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Implementation of the {IERC165} interface.
211  *
212  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
213  * for the additional interface id that will be supported. For example:
214  *
215  * ```solidity
216  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
218  * }
219  * ```
220  *
221  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
222  */
223 abstract contract ERC165 is IERC165 {
224     /**
225      * @dev See {IERC165-supportsInterface}.
226      */
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Required interface of an ERC721 compliant contract.
242  */
243 interface IERC721 is IERC165 {
244     /**
245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
251      */
252     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
256      */
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
258 
259     /**
260      * @dev Returns the number of tokens in ``owner``'s account.
261      */
262     function balanceOf(address owner) external view returns (uint256 balance);
263 
264     /**
265      * @dev Returns the owner of the `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
275      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Transfers `tokenId` token from `from` to `to`.
295      *
296      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
297      *
298      * Requirements:
299      *
300      * - `from` cannot be the zero address.
301      * - `to` cannot be the zero address.
302      * - `tokenId` token must be owned by `from`.
303      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external;
312 
313     /**
314      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
315      * The approval is cleared when the token is transferred.
316      *
317      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
318      *
319      * Requirements:
320      *
321      * - The caller must own the token or be an approved operator.
322      * - `tokenId` must exist.
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address to, uint256 tokenId) external;
327 
328     /**
329      * @dev Returns the account approved for `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function getApproved(uint256 tokenId) external view returns (address operator);
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
351      *
352      * See {setApprovalForAll}
353      */
354     function isApprovedForAll(address owner, address operator) external view returns (bool);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 
385 /**
386  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
387  * @dev See https://eips.ethereum.org/EIPS/eip-721
388  */
389 interface IERC721Enumerable is IERC721 {
390     /**
391      * @dev Returns the total amount of tokens stored by the contract.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
397      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
398      */
399     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
400 
401     /**
402      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
403      * Use along with {totalSupply} to enumerate all tokens.
404      */
405     function tokenByIndex(uint256 index) external view returns (uint256);
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
418  * @dev See https://eips.ethereum.org/EIPS/eip-721
419  */
420 interface IERC721Metadata is IERC721 {
421     /**
422      * @dev Returns the token collection name.
423      */
424     function name() external view returns (string memory);
425 
426     /**
427      * @dev Returns the token collection symbol.
428      */
429     function symbol() external view returns (string memory);
430 
431     /**
432      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
433      */
434     function tokenURI(uint256 tokenId) external view returns (string memory);
435 }
436 
437 // File: ERC2000000.sol
438 
439 
440 
441 pragma solidity ^0.8.7;
442 
443 
444 
445 
446 
447 
448 
449 
450 
451 
452 library Address {
453     function isContract(address account) internal view returns (bool) {
454         uint size;
455         assembly {
456             size := extcodesize(account)
457         }
458         return size > 0;
459     }
460 }
461 
462 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
463     using Address for address;
464     using Strings for uint256;
465     
466     string private _name;
467     string private _symbol;
468 
469     // Mapping from token ID to owner address
470     address[] internal _owners;
471 
472     mapping(uint256 => address) private _tokenApprovals;
473     mapping(address => mapping(address => bool)) private _operatorApprovals;
474 
475     /**
476      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
477      */
478     constructor(string memory name_, string memory symbol_) {
479         _name = name_;
480         _symbol = symbol_;
481     }
482 
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId)
487         public
488         view
489         virtual
490         override(ERC165, IERC165)
491         returns (bool)
492     {
493         return
494             interfaceId == type(IERC721).interfaceId ||
495             interfaceId == type(IERC721Metadata).interfaceId ||
496             super.supportsInterface(interfaceId);
497     }
498 
499     /**
500      * @dev See {IERC721-balanceOf}.
501      */
502     function balanceOf(address owner) 
503         public 
504         view 
505         virtual 
506         override 
507         returns (uint) 
508     {
509         require(owner != address(0), "ERC721: balance query for the zero address");
510 
511         uint count;
512         uint length= _owners.length;
513         for( uint i; i < length; ++i ){
514           if( owner == _owners[i] )
515             ++count;
516         }
517         delete length;
518         return count;
519     }
520 
521     /**
522      * @dev See {IERC721-ownerOf}.
523      */
524     function ownerOf(uint256 tokenId)
525         public
526         view
527         virtual
528         override
529         returns (address)
530     {
531         address owner = _owners[tokenId];
532         require(
533             owner != address(0),
534             "ERC721: owner query for nonexistent token"
535         );
536         return owner;
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-name}.
541      */
542     function name() public view virtual override returns (string memory) {
543         return _name;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-symbol}.
548      */
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev See {IERC721-approve}.
555      */
556     function approve(address to, uint256 tokenId) public virtual override {
557         address owner = ERC721.ownerOf(tokenId);
558         require(to != owner, "ERC721: approval to current owner");
559 
560         require(
561             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
562             "ERC721: approve caller is not owner nor approved for all"
563         );
564 
565         _approve(to, tokenId);
566     }
567 
568     /**
569      * @dev See {IERC721-getApproved}.
570      */
571     function getApproved(uint256 tokenId)
572         public
573         view
574         virtual
575         override
576         returns (address)
577     {
578         require(
579             _exists(tokenId),
580             "ERC721: approved query for nonexistent token"
581         );
582 
583         return _tokenApprovals[tokenId];
584     }
585 
586     /**
587      * @dev See {IERC721-setApprovalForAll}.
588      */
589     function setApprovalForAll(address operator, bool approved)
590         public
591         virtual
592         override
593     {
594         require(operator != _msgSender(), "ERC721: approve to caller");
595 
596         _operatorApprovals[_msgSender()][operator] = approved;
597         emit ApprovalForAll(_msgSender(), operator, approved);
598     }
599 
600     /**
601      * @dev See {IERC721-isApprovedForAll}.
602      */
603     function isApprovedForAll(address owner, address operator)
604         public
605         view
606         virtual
607         override
608         returns (bool)
609     {
610         return _operatorApprovals[owner][operator];
611     }
612 
613     /**
614      * @dev See {IERC721-transferFrom}.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) public virtual override {
621         //solhint-disable-next-line max-line-length
622         require(
623             _isApprovedOrOwner(_msgSender(), tokenId),
624             "ERC721: transfer caller is not owner nor approved"
625         );
626 
627         _transfer(from, to, tokenId);
628     }
629 
630     /**
631      * @dev See {IERC721-safeTransferFrom}.
632      */
633     function safeTransferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) public virtual override {
638         safeTransferFrom(from, to, tokenId, "");
639     }
640 
641     /**
642      * @dev See {IERC721-safeTransferFrom}.
643      */
644     function safeTransferFrom(
645         address from,
646         address to,
647         uint256 tokenId,
648         bytes memory _data
649     ) public virtual override {
650         require(
651             _isApprovedOrOwner(_msgSender(), tokenId),
652             "ERC721: transfer caller is not owner nor approved"
653         );
654         _safeTransfer(from, to, tokenId, _data);
655     }
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
660      *
661      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
662      *
663      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
664      * implement alternative mechanisms to perform token transfer, such as signature-based.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function _safeTransfer(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes memory _data
680     ) internal virtual {
681         _transfer(from, to, tokenId);
682         require(
683             _checkOnERC721Received(from, to, tokenId, _data),
684             "ERC721: transfer to non ERC721Receiver implementer"
685         );
686     }
687 
688     /**
689      * @dev Returns whether `tokenId` exists.
690      *
691      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
692      *
693      * Tokens start existing when they are minted (`_mint`),
694      * and stop existing when they are burned (`_burn`).
695      */
696     function _exists(uint256 tokenId) internal view virtual returns (bool) {
697         return tokenId < _owners.length && _owners[tokenId] != address(0);
698     }
699 
700     /**
701      * @dev Returns whether `spender` is allowed to manage `tokenId`.
702      *
703      * Requirements:
704      *
705      * - `tokenId` must exist.
706      */
707     function _isApprovedOrOwner(address spender, uint256 tokenId)
708         internal
709         view
710         virtual
711         returns (bool)
712     {
713         require(
714             _exists(tokenId),
715             "ERC721: operator query for nonexistent token"
716         );
717         address owner = ERC721.ownerOf(tokenId);
718         return (spender == owner ||
719             getApproved(tokenId) == spender ||
720             isApprovedForAll(owner, spender));
721     }
722 
723     /**
724      * @dev Safely mints `tokenId` and transfers it to `to`.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must not exist.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function _safeMint(address to, uint256 tokenId) internal virtual {
734         _safeMint(to, tokenId, "");
735     }
736 
737     /**
738      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
739      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
740      */
741     function _safeMint(
742         address to,
743         uint256 tokenId,
744         bytes memory _data
745     ) internal virtual {
746         _mint(to, tokenId);
747         require(
748             _checkOnERC721Received(address(0), to, tokenId, _data),
749             "ERC721: transfer to non ERC721Receiver implementer"
750         );
751     }
752 
753     /**
754      * @dev Mints `tokenId` and transfers it to `to`.
755      *
756      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
757      *
758      * Requirements:
759      *
760      * - `tokenId` must not exist.
761      * - `to` cannot be the zero address.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _mint(address to, uint256 tokenId) internal virtual {
766         require(to != address(0), "ERC721: mint to the zero address");
767         require(!_exists(tokenId), "ERC721: token already minted");
768 
769       
770         _owners.push(to);
771 
772         emit Transfer(address(0), to, tokenId);
773     }
774 
775     /**
776      * @dev Destroys `tokenId`.
777      * The approval is cleared when the token is burned.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _burn(uint256 tokenId) internal virtual {
786         address owner = ERC721.ownerOf(tokenId);
787 
788         _beforeTokenTransfer(owner, address(0), tokenId);
789 
790         // Clear approvals
791         _approve(address(0), tokenId);
792         _owners[tokenId] = address(0);
793 
794         emit Transfer(owner, address(0), tokenId);
795     }
796 
797     /**
798      * @dev Transfers `tokenId` from `from` to `to`.
799      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
800      *
801      * Requirements:
802      *
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must be owned by `from`.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _transfer(
809         address from,
810         address to,
811         uint256 tokenId
812     ) internal virtual {
813         require(
814             ERC721.ownerOf(tokenId) == from,
815             "ERC721: transfer of token that is not own"
816         );
817         require(to != address(0), "ERC721: transfer to the zero address");
818 
819         _beforeTokenTransfer(from, to, tokenId);
820 
821         // Clear approvals from the previous owner
822         _approve(address(0), tokenId);
823         _owners[tokenId] = to;
824 
825         emit Transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev Approve `to` to operate on `tokenId`
830      *
831      * Emits a {Approval} event.
832      */
833     function _approve(address to, uint256 tokenId) internal virtual {
834         _tokenApprovals[tokenId] = to;
835         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
836     }
837 
838     /**
839      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
840      * The call is not executed if the target address is not a contract.
841      *
842      * @param from address representing the previous owner of the given token ID
843      * @param to target address that will receive the tokens
844      * @param tokenId uint256 ID of the token to be transferred
845      * @param _data bytes optional data to send along with the call
846      * @return bool whether the call correctly returned the expected magic value
847      */
848     function _checkOnERC721Received(
849         address from,
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) private returns (bool) {
854         if (to.isContract()) {
855             try
856                 IERC721Receiver(to).onERC721Received(
857                     _msgSender(),
858                     from,
859                     tokenId,
860                     _data
861                 )
862             returns (bytes4 retval) {
863                 return retval == IERC721Receiver.onERC721Received.selector;
864             } catch (bytes memory reason) {
865                 if (reason.length == 0) {
866                     revert(
867                         "ERC721: transfer to non ERC721Receiver implementer"
868                     );
869                 } else {
870                     assembly {
871                         revert(add(32, reason), mload(reason))
872                     }
873                 }
874             }
875         } else {
876             return true;
877         }
878     }
879 
880     /**
881      * @dev Hook that is called before any token transfer. This includes minting
882      * and burning.
883      *
884      * Calling conditions:
885      *
886      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
887      * transferred to `to`.
888      * - When `from` is zero, `tokenId` will be minted for `to`.
889      * - When `to` is zero, ``from``'s `tokenId` will be burned.
890      * - `from` and `to` are never both zero.
891      *
892      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
893      */
894     function _beforeTokenTransfer(
895         address from,
896         address to,
897         uint256 tokenId
898     ) internal virtual {}
899 }
900 
901 
902 pragma solidity ^0.8.7;
903 
904 
905 /**
906  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
907  * enumerability of all the token ids in the contract as well as all token ids owned by each
908  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
909  */
910 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
911     /**
912      * @dev See {IERC165-supportsInterface}.
913      */
914     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
915         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
916     }
917 
918     /**
919      * @dev See {IERC721Enumerable-totalSupply}.
920      */
921     function totalSupply() public view virtual override returns (uint256) {
922         return _owners.length;
923     }
924 
925     /**
926      * @dev See {IERC721Enumerable-tokenByIndex}.
927      */
928     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
929         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
930         return index;
931     }
932 
933     /**
934      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
935      */
936     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
937         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
938 
939         uint count;
940         for(uint i; i < _owners.length; i++){
941             if(owner == _owners[i]){
942                 if(count == index) return i;
943                 else count++;
944             }
945         }
946 
947         revert("ERC721Enumerable: owner index out of bounds");
948     }
949 }
950     pragma solidity ^0.8.7;
951 
952     interface IMain {
953    
954 function transferFrom( address from,   address to, uint256 tokenId) external;
955 function ownerOf( uint _tokenid) external view returns (address);
956 }
957 
958     contract PAYCDegenHours  is ERC721Enumerable,  Ownable {
959     using Strings for uint256;
960 
961 
962   string private uriPrefix = "ipfs://Qmae138hdMAu2DKmwxmkkVnw66oHQC9W6Cc7dAUer8C5yE/";
963   string private uriSuffix = ".json";
964 
965   uint16 public constant maxSupply = 7777;
966   
967 
968   
969   mapping (uint => uint) public mappingOldtoNewTokens;
970   mapping (uint => uint) public mappingNewtoOldTokens;
971    mapping (uint => address) public lastOwner;
972 
973   address public mainAddress = 0x2D0D57D004F82e9f4471CaA8b9f8B1965a814154; 
974   IMain Main = IMain(mainAddress);
975 
976   constructor() ERC721("PAYC Degen Hours", "PAYC Degen Hours") {
977     
978   }
979   
980 	function setMainAddress(address contractAddr) external onlyOwner {
981 		mainAddress = contractAddr;
982         Main= IMain(mainAddress);
983 	}  
984  
985 
986   function mint( uint tokenNumber) external  {
987 
988  require(Main.ownerOf(tokenNumber) == msg.sender, "Not the owner");
989    uint16 totalSupply = uint16(_owners.length);
990     require(totalSupply + 1 <= maxSupply, "Exceeds max supply.");
991      Main.transferFrom( msg.sender, address(this),tokenNumber);
992     _mint(msg.sender, totalSupply);
993   
994     mappingNewtoOldTokens[totalSupply] = tokenNumber;
995     mappingOldtoNewTokens[tokenNumber] = totalSupply; 
996  
997   }
998 
999   function _beforeTokenTransfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual override  {
1004         uint token = tokenId;
1005         require (from == address(this) || to ==  address(this) , "Transfer not Allowed");
1006         delete token;
1007     }
1008   
1009   function _isApprovedOrOwner(address spender, uint256 tokenId)
1010         internal
1011         view
1012         virtual
1013         override 
1014         returns (bool)
1015     {
1016           if ( lastOwner[tokenId] == msg.sender) return true;
1017         return super._isApprovedOrOwner(spender, tokenId);
1018 
1019     }
1020     
1021   
1022   function ExchangeOldForNew( uint tokenNumber ) external  {
1023 
1024  require(Main.ownerOf(tokenNumber) == msg.sender, "Not the owner");
1025  
1026   uint _token = mappingOldtoNewTokens[tokenNumber] ;
1027 
1028   transferFrom( address(this), msg.sender,_token);
1029   Main.transferFrom(msg.sender, address(this),tokenNumber);
1030   
1031   }
1032 
1033    function ExchangeNewForOld( uint tokenNumber) external  {
1034 
1035  require(ownerOf(tokenNumber) == msg.sender, "Not the owner");
1036 
1037   uint _token = mappingNewtoOldTokens[tokenNumber] ;
1038 
1039   Main.transferFrom( address(this), msg.sender,_token);
1040   transferFrom( msg.sender, address(this),tokenNumber);
1041   lastOwner[tokenNumber] = msg.sender;
1042   
1043 
1044     
1045   }
1046   
1047 
1048   function checkIfNFTExist(uint256 _tokenId)
1049     public
1050     view
1051    returns (bool)
1052    {
1053     bool exist =   _exists(_tokenId);
1054     return exist;
1055    }
1056 
1057 
1058    
1059   function tokenURI(uint256 _tokenId)
1060     public
1061     view
1062     virtual
1063     override
1064     returns (string memory)
1065   {
1066     require(
1067       _exists(_tokenId),
1068       "ERC721Metadata: URI query for nonexistent token"
1069     );
1070   
1071 
1072     _tokenId = mappingNewtoOldTokens[_tokenId];
1073 
1074     string memory currentBaseURI = _baseURI();
1075     return bytes(currentBaseURI).length > 0
1076         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1077         : "";
1078   }
1079 
1080 
1081   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1082     uriPrefix = _uriPrefix;
1083   }
1084 
1085 
1086  
1087  
1088 
1089   
1090    function _mint(address to, uint256 tokenId) internal virtual override {
1091         _owners.push(to);
1092         emit Transfer(address(0), to, tokenId);
1093     }
1094 
1095   function _baseURI() internal view  returns (string memory) {
1096     return uriPrefix;
1097   }
1098 }