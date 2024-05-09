1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 
6 // 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 // 
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 interface IERC721Receiver {
173     /**
174      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
175      * by `operator` from `from`, this function is called.
176      *
177      * It must return its Solidity selector to confirm the token transfer.
178      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
179      *
180      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
181      */
182     function onERC721Received(
183         address operator,
184         address from,
185         uint256 tokenId,
186         bytes calldata data
187     ) external returns (bytes4);
188 }
189 
190 // 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193  * @dev See https://eips.ethereum.org/EIPS/eip-721
194  */
195 interface IERC721Metadata is IERC721 {
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // 
213 /**
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 abstract contract Context {
224     function _msgSender() internal view virtual returns (address) {
225         return msg.sender;
226     }
227 
228     function _msgData() internal view virtual returns (bytes calldata) {
229         return msg.data;
230     }
231 }
232 
233 // 
234 /**
235  * @dev String operations.
236  */
237 library Strings {
238     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
239 
240     /**
241      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
242      */
243     function toString(uint256 value) internal pure returns (string memory) {
244         // Inspired by OraclizeAPI's implementation - MIT licence
245         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
246 
247         if (value == 0) {
248             return "0";
249         }
250         uint256 temp = value;
251         uint256 digits;
252         while (temp != 0) {
253             digits++;
254             temp /= 10;
255         }
256         bytes memory buffer = new bytes(digits);
257         while (value != 0) {
258             digits -= 1;
259             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
260             value /= 10;
261         }
262         return string(buffer);
263     }
264 
265     /**
266      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
267      */
268     function toHexString(uint256 value) internal pure returns (string memory) {
269         if (value == 0) {
270             return "0x00";
271         }
272         uint256 temp = value;
273         uint256 length = 0;
274         while (temp != 0) {
275             length++;
276             temp >>= 8;
277         }
278         return toHexString(value, length);
279     }
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
283      */
284     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
285         bytes memory buffer = new bytes(2 * length + 2);
286         buffer[0] = "0";
287         buffer[1] = "x";
288         for (uint256 i = 2 * length + 1; i > 1; --i) {
289             buffer[i] = _HEX_SYMBOLS[value & 0xf];
290             value >>= 4;
291         }
292         require(value == 0, "Strings: hex length insufficient");
293         return string(buffer);
294     }
295 }
296 
297 // 
298 /**
299  * @dev Implementation of the {IERC165} interface.
300  *
301  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
302  * for the additional interface id that will be supported. For example:
303  *
304  * ```solidity
305  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
307  * }
308  * ```
309  *
310  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
311  */
312 abstract contract ERC165 is IERC165 {
313     /**
314      * @dev See {IERC165-supportsInterface}.
315      */
316     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
317         return interfaceId == type(IERC165).interfaceId;
318     }
319 }
320 
321 // 
322 library Address {
323     function isContract(address account) internal view returns (bool) {
324         uint size;
325         assembly {
326             size := extcodesize(account)
327         }
328         return size > 0;
329     }
330 }
331 
332 // 
333 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
334     using Address for address;
335     using Strings for uint256;
336 
337     string private _name;
338     string private _symbol;
339 
340     // Mapping from token ID to owner address
341     address[] internal _owners;
342 
343     mapping(uint256 => address) private _tokenApprovals;
344     mapping(address => mapping(address => bool)) private _operatorApprovals;
345 
346     /**
347      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
348      */
349     constructor(string memory name_, string memory symbol_) {
350         _name = name_;
351         _symbol = symbol_;
352     }
353 
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId)
358     public
359     view
360     virtual
361     override(ERC165, IERC165)
362     returns (bool)
363     {
364         return
365         interfaceId == type(IERC721).interfaceId ||
366         interfaceId == type(IERC721Metadata).interfaceId ||
367         super.supportsInterface(interfaceId);
368     }
369 
370     /**
371      * @dev See {IERC721-balanceOf}.
372      */
373     function balanceOf(address owner)
374     public
375     view
376     virtual
377     override
378     returns (uint)
379     {
380         require(owner != address(0), "ERC721: balance query for the zero address");
381 
382         uint count;
383         for( uint i; i < _owners.length; ++i ){
384             if( owner == _owners[i] )
385                 ++count;
386         }
387         return count;
388     }
389 
390     /**
391      * @dev See {IERC721-ownerOf}.
392      */
393     function ownerOf(uint256 tokenId)
394     public
395     view
396     virtual
397     override
398     returns (address)
399     {
400         address owner = _owners[tokenId];
401         require(
402             owner != address(0),
403             "ERC721: owner query for nonexistent token"
404         );
405         return owner;
406     }
407 
408     /**
409      * @dev See {IERC721Metadata-name}.
410      */
411     function name() public view virtual override returns (string memory) {
412         return _name;
413     }
414 
415     /**
416      * @dev See {IERC721Metadata-symbol}.
417      */
418     function symbol() public view virtual override returns (string memory) {
419         return _symbol;
420     }
421 
422     /**
423      * @dev See {IERC721-approve}.
424      */
425     function approve(address to, uint256 tokenId) public virtual override {
426         address owner = ERC721.ownerOf(tokenId);
427         require(to != owner, "ERC721: approval to current owner");
428 
429         require(
430             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
431             "ERC721: approve caller is not owner nor approved for all"
432         );
433 
434         _approve(to, tokenId);
435     }
436 
437     /**
438      * @dev See {IERC721-getApproved}.
439      */
440     function getApproved(uint256 tokenId)
441     public
442     view
443     virtual
444     override
445     returns (address)
446     {
447         require(
448             _exists(tokenId),
449             "ERC721: approved query for nonexistent token"
450         );
451 
452         return _tokenApprovals[tokenId];
453     }
454 
455     /**
456      * @dev See {IERC721-setApprovalForAll}.
457      */
458     function setApprovalForAll(address operator, bool approved)
459     public
460     virtual
461     override
462     {
463         require(operator != _msgSender(), "ERC721: approve to caller");
464 
465         _operatorApprovals[_msgSender()][operator] = approved;
466         emit ApprovalForAll(_msgSender(), operator, approved);
467     }
468 
469     /**
470      * @dev See {IERC721-isApprovedForAll}.
471      */
472     function isApprovedForAll(address owner, address operator)
473     public
474     view
475     virtual
476     override
477     returns (bool)
478     {
479         return _operatorApprovals[owner][operator];
480     }
481 
482     /**
483      * @dev See {IERC721-transferFrom}.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) public virtual override {
490         //solhint-disable-next-line max-line-length
491         require(
492             _isApprovedOrOwner(_msgSender(), tokenId),
493             "ERC721: transfer caller is not owner nor approved"
494         );
495 
496         _transfer(from, to, tokenId);
497     }
498 
499     /**
500      * @dev See {IERC721-safeTransferFrom}.
501      */
502     function safeTransferFrom(
503         address from,
504         address to,
505         uint256 tokenId
506     ) public virtual override {
507         safeTransferFrom(from, to, tokenId, "");
508     }
509 
510     /**
511      * @dev See {IERC721-safeTransferFrom}.
512      */
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId,
517         bytes memory _data
518     ) public virtual override {
519         require(
520             _isApprovedOrOwner(_msgSender(), tokenId),
521             "ERC721: transfer caller is not owner nor approved"
522         );
523         _safeTransfer(from, to, tokenId, _data);
524     }
525 
526     function batchTransferFrom(address _from, address _to, uint256[] memory _tokenIds) public {
527         for (uint256 i = 0; i < _tokenIds.length; i++) {
528             transferFrom(_from, _to, _tokenIds[i]);
529         }
530     }
531 
532     function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_) public {
533         for (uint256 i = 0; i < _tokenIds.length; i++) {
534             safeTransferFrom(_from, _to, _tokenIds[i], data_);
535         }
536     }
537 
538     /**
539      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
540      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
541      *
542      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
543      *
544      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
545      * implement alternative mechanisms to perform token transfer, such as signature-based.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
553      *
554      * Emits a {Transfer} event.
555      */
556     function _safeTransfer(
557         address from,
558         address to,
559         uint256 tokenId,
560         bytes memory _data
561     ) internal virtual {
562         _transfer(from, to, tokenId);
563         require(
564             _checkOnERC721Received(from, to, tokenId, _data),
565             "ERC721: transfer to non ERC721Receiver implementer"
566         );
567     }
568 
569     /**
570      * @dev Returns whether `tokenId` exists.
571      *
572      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
573      *
574      * Tokens start existing when they are minted (`_mint`),
575      * and stop existing when they are burned (`_burn`).
576      */
577     function _exists(uint256 tokenId) internal view virtual returns (bool) {
578         return tokenId < _owners.length && _owners[tokenId] != address(0);
579     }
580 
581     /**
582      * @dev Returns whether `spender` is allowed to manage `tokenId`.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function _isApprovedOrOwner(address spender, uint256 tokenId)
589     internal
590     view
591     virtual
592     returns (bool)
593     {
594         require(
595             _exists(tokenId),
596             "ERC721: operator query for nonexistent token"
597         );
598         address owner = ERC721.ownerOf(tokenId);
599         return (spender == owner ||
600         getApproved(tokenId) == spender ||
601         isApprovedForAll(owner, spender));
602     }
603 
604     /**
605      * @dev Safely mints `tokenId` and transfers it to `to`.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must not exist.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function _safeMint(address to, uint256 tokenId) internal virtual {
615         _safeMint(to, tokenId, "");
616     }
617 
618     /**
619      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
620      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
621      */
622     function _safeMint(
623         address to,
624         uint256 tokenId,
625         bytes memory _data
626     ) internal virtual {
627         _mint(to, tokenId);
628         require(
629             _checkOnERC721Received(address(0), to, tokenId, _data),
630             "ERC721: transfer to non ERC721Receiver implementer"
631         );
632     }
633 
634     /**
635      * @dev Mints `tokenId` and transfers it to `to`.
636      *
637      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
638      *
639      * Requirements:
640      *
641      * - `tokenId` must not exist.
642      * - `to` cannot be the zero address.
643      *
644      * Emits a {Transfer} event.
645      */
646     function _mint(address to, uint256 tokenId) internal virtual {
647         require(to != address(0), "ERC721: mint to the zero address");
648         require(!_exists(tokenId), "ERC721: token already minted");
649 
650         _owners.push(to);
651 
652         emit Transfer(address(0), to, tokenId);
653     }
654 
655     /**
656      * @dev Destroys `tokenId`.
657      * The approval is cleared when the token is burned.
658      *
659      * Requirements:
660      *
661      * - `tokenId` must exist.
662      *
663      * Emits a {Transfer} event.
664      */
665     function _burn(uint256 tokenId) internal virtual {
666         address owner = ERC721.ownerOf(tokenId);
667 
668         // Clear approvals
669         _approve(address(0), tokenId);
670         _owners[tokenId] = address(0);
671 
672         emit Transfer(owner, address(0), tokenId);
673     }
674 
675     /**
676      * @dev Transfers `tokenId` from `from` to `to`.
677      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
678      *
679      * Requirements:
680      *
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must be owned by `from`.
683      *
684      * Emits a {Transfer} event.
685      */
686     function _transfer(
687         address from,
688         address to,
689         uint256 tokenId
690     ) internal virtual {
691         require(
692             ERC721.ownerOf(tokenId) == from,
693             "ERC721: transfer of token that is not own"
694         );
695         require(to != address(0), "ERC721: transfer to the zero address");
696 
697         // Clear approvals from the previous owner
698         _approve(address(0), tokenId);
699         _owners[tokenId] = to;
700 
701         emit Transfer(from, to, tokenId);
702     }
703 
704     /**
705      * @dev Approve `to` to operate on `tokenId`
706      *
707      * Emits a {Approval} event.
708      */
709     function _approve(address to, uint256 tokenId) internal virtual {
710         _tokenApprovals[tokenId] = to;
711         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
712     }
713 
714     /**
715      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
716      * The call is not executed if the target address is not a contract.
717      *
718      * @param from address representing the previous owner of the given token ID
719      * @param to target address that will receive the tokens
720      * @param tokenId uint256 ID of the token to be transferred
721      * @param _data bytes optional data to send along with the call
722      * @return bool whether the call correctly returned the expected magic value
723      */
724     function _checkOnERC721Received(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) private returns (bool) {
730         if (to.isContract()) {
731             try
732             IERC721Receiver(to).onERC721Received(
733                 _msgSender(),
734                 from,
735                 tokenId,
736                 _data
737             )
738             returns (bytes4 retval) {
739                 return retval == IERC721Receiver.onERC721Received.selector;
740             } catch (bytes memory reason) {
741                 if (reason.length == 0) {
742                     revert(
743                         "ERC721: transfer to non ERC721Receiver implementer"
744                     );
745                 } else {
746                     assembly {
747                         revert(add(32, reason), mload(reason))
748                     }
749                 }
750             }
751         } else {
752             return true;
753         }
754     }
755 }
756 
757 // 
758 /**
759  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
760  * @dev See https://eips.ethereum.org/EIPS/eip-721
761  */
762 interface IERC721Enumerable is IERC721 {
763     /**
764      * @dev Returns the total amount of tokens stored by the contract.
765      */
766     function totalSupply() external view returns (uint256);
767 
768     /**
769      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
770      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
771      */
772     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
773 
774     /**
775      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
776      * Use along with {totalSupply} to enumerate all tokens.
777      */
778     function tokenByIndex(uint256 index) external view returns (uint256);
779 }
780 
781 // 
782 /**
783  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
784  * enumerability of all the token ids in the contract as well as all token ids owned by each
785  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
786  */
787 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
788     /**
789      * @dev See {IERC165-supportsInterface}.
790      */
791     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
792         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721Enumerable-totalSupply}.
797      */
798     function totalSupply() public view virtual override returns (uint256) {
799         return _owners.length;
800     }
801 
802     /**
803      * @dev See {IERC721Enumerable-tokenByIndex}.
804      */
805     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
806         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
807         return index;
808     }
809 
810     /**
811      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
812      */
813     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
814         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
815 
816         uint count;
817         for(uint i; i < _owners.length; i++){
818             if(owner == _owners[i]){
819                 if(count == index) return i;
820                 else count++;
821             }
822         }
823 
824         revert("ERC721Enumerable: owner index out of bounds");
825     }
826 }
827 
828 // 
829 /**
830  * @dev Contract module which provides a basic access control mechanism, where
831  * there is an account (an owner) that can be granted exclusive access to
832  * specific functions.
833  *
834  * By default, the owner account will be the one that deploys the contract. This
835  * can later be changed with {transferOwnership}.
836  *
837  * This module is used through inheritance. It will make available the modifier
838  * `onlyOwner`, which can be applied to your functions to restrict their use to
839  * the owner.
840  */
841 abstract contract Ownable is Context {
842     address private _owner;
843 
844     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
845 
846     /**
847      * @dev Initializes the contract setting the deployer as the initial owner.
848      */
849     constructor() {
850         _setOwner(_msgSender());
851     }
852 
853     /**
854      * @dev Returns the address of the current owner.
855      */
856     function owner() public view virtual returns (address) {
857         return _owner;
858     }
859 
860     /**
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         require(owner() == _msgSender(), "Ownable: caller is not the owner");
865         _;
866     }
867 
868     /**
869      * @dev Leaves the contract without owner. It will not be possible to call
870      * `onlyOwner` functions anymore. Can only be called by the current owner.
871      *
872      * NOTE: Renouncing ownership will leave the contract without an owner,
873      * thereby removing any functionality that is only available to the owner.
874      */
875     function renounceOwnership() public virtual onlyOwner {
876         _setOwner(address(0));
877     }
878 
879     /**
880      * @dev Transfers ownership of the contract to a new account (`newOwner`).
881      * Can only be called by the current owner.
882      */
883     function transferOwnership(address newOwner) public virtual onlyOwner {
884         require(newOwner != address(0), "Ownable: new owner is the zero address");
885         _setOwner(newOwner);
886     }
887 
888     function _setOwner(address newOwner) private {
889         address oldOwner = _owner;
890         _owner = newOwner;
891         emit OwnershipTransferred(oldOwner, newOwner);
892     }
893 }
894 
895 // 
896 /**
897  * @dev Contract module which allows children to implement an emergency stop
898  * mechanism that can be triggered by an authorized account.
899  *
900  * This module is used through inheritance. It will make available the
901  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
902  * the functions of your contract. Note that they will not be pausable by
903  * simply including this module, only once the modifiers are put in place.
904  */
905 abstract contract Pausable is Context {
906     /**
907      * @dev Emitted when the pause is triggered by `account`.
908      */
909     event Paused(address account);
910 
911     /**
912      * @dev Emitted when the pause is lifted by `account`.
913      */
914     event Unpaused(address account);
915 
916     bool private _paused;
917 
918     /**
919      * @dev Initializes the contract in unpaused state.
920      */
921     constructor() {
922         _paused = false;
923     }
924 
925     /**
926      * @dev Returns true if the contract is paused, and false otherwise.
927      */
928     function paused() public view virtual returns (bool) {
929         return _paused;
930     }
931 
932     /**
933      * @dev Modifier to make a function callable only when the contract is not paused.
934      *
935      * Requirements:
936      *
937      * - The contract must not be paused.
938      */
939     modifier whenNotPaused() {
940         require(!paused(), "Pausable: paused");
941         _;
942     }
943 
944     /**
945      * @dev Modifier to make a function callable only when the contract is paused.
946      *
947      * Requirements:
948      *
949      * - The contract must be paused.
950      */
951     modifier whenPaused() {
952         require(paused(), "Pausable: not paused");
953         _;
954     }
955 
956     /**
957      * @dev Triggers stopped state.
958      *
959      * Requirements:
960      *
961      * - The contract must not be paused.
962      */
963     function _pause() internal virtual whenNotPaused {
964         _paused = true;
965         emit Paused(_msgSender());
966     }
967 
968     /**
969      * @dev Returns to normal state.
970      *
971      * Requirements:
972      *
973      * - The contract must be paused.
974      */
975     function _unpause() internal virtual whenPaused {
976         _paused = false;
977         emit Unpaused(_msgSender());
978     }
979 }
980 
981 // 
982 // CAUTION
983 // This version of SafeMath should only be used with Solidity 0.8 or later,
984 // because it relies on the compiler's built in overflow checks.
985 /**
986  * @dev Wrappers over Solidity's arithmetic operations.
987  *
988  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
989  * now has built in overflow checking.
990  */
991 library SafeMath {
992     /**
993      * @dev Returns the addition of two unsigned integers, with an overflow flag.
994      *
995      * _Available since v3.4._
996      */
997     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
998         unchecked {
999             uint256 c = a + b;
1000             if (c < a) return (false, 0);
1001             return (true, c);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1007      *
1008      * _Available since v3.4._
1009      */
1010     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1011         unchecked {
1012             if (b > a) return (false, 0);
1013             return (true, a - b);
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1019      *
1020      * _Available since v3.4._
1021      */
1022     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1023         unchecked {
1024             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1025             // benefit is lost if 'b' is also tested.
1026             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1027             if (a == 0) return (true, 0);
1028             uint256 c = a * b;
1029             if (c / a != b) return (false, 0);
1030             return (true, c);
1031         }
1032     }
1033 
1034     /**
1035      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1036      *
1037      * _Available since v3.4._
1038      */
1039     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1040         unchecked {
1041             if (b == 0) return (false, 0);
1042             return (true, a / b);
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1048      *
1049      * _Available since v3.4._
1050      */
1051     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1052         unchecked {
1053             if (b == 0) return (false, 0);
1054             return (true, a % b);
1055         }
1056     }
1057 
1058     /**
1059      * @dev Returns the addition of two unsigned integers, reverting on
1060      * overflow.
1061      *
1062      * Counterpart to Solidity's `+` operator.
1063      *
1064      * Requirements:
1065      *
1066      * - Addition cannot overflow.
1067      */
1068     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1069         return a + b;
1070     }
1071 
1072     /**
1073      * @dev Returns the subtraction of two unsigned integers, reverting on
1074      * overflow (when the result is negative).
1075      *
1076      * Counterpart to Solidity's `-` operator.
1077      *
1078      * Requirements:
1079      *
1080      * - Subtraction cannot overflow.
1081      */
1082     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1083         return a - b;
1084     }
1085 
1086     /**
1087      * @dev Returns the multiplication of two unsigned integers, reverting on
1088      * overflow.
1089      *
1090      * Counterpart to Solidity's `*` operator.
1091      *
1092      * Requirements:
1093      *
1094      * - Multiplication cannot overflow.
1095      */
1096     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1097         return a * b;
1098     }
1099 
1100     /**
1101      * @dev Returns the integer division of two unsigned integers, reverting on
1102      * division by zero. The result is rounded towards zero.
1103      *
1104      * Counterpart to Solidity's `/` operator.
1105      *
1106      * Requirements:
1107      *
1108      * - The divisor cannot be zero.
1109      */
1110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1111         return a / b;
1112     }
1113 
1114     /**
1115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1116      * reverting when dividing by zero.
1117      *
1118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1119      * opcode (which leaves remaining gas untouched) while Solidity uses an
1120      * invalid opcode to revert (consuming all remaining gas).
1121      *
1122      * Requirements:
1123      *
1124      * - The divisor cannot be zero.
1125      */
1126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1127         return a % b;
1128     }
1129 
1130     /**
1131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1132      * overflow (when the result is negative).
1133      *
1134      * CAUTION: This function is deprecated because it requires allocating memory for the error
1135      * message unnecessarily. For custom revert reasons use {trySub}.
1136      *
1137      * Counterpart to Solidity's `-` operator.
1138      *
1139      * Requirements:
1140      *
1141      * - Subtraction cannot overflow.
1142      */
1143     function sub(
1144         uint256 a,
1145         uint256 b,
1146         string memory errorMessage
1147     ) internal pure returns (uint256) {
1148         unchecked {
1149             require(b <= a, errorMessage);
1150             return a - b;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1156      * division by zero. The result is rounded towards zero.
1157      *
1158      * Counterpart to Solidity's `/` operator. Note: this function uses a
1159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1160      * uses an invalid opcode to revert (consuming all remaining gas).
1161      *
1162      * Requirements:
1163      *
1164      * - The divisor cannot be zero.
1165      */
1166     function div(
1167         uint256 a,
1168         uint256 b,
1169         string memory errorMessage
1170     ) internal pure returns (uint256) {
1171         unchecked {
1172             require(b > 0, errorMessage);
1173             return a / b;
1174         }
1175     }
1176 
1177     /**
1178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1179      * reverting with custom message when dividing by zero.
1180      *
1181      * CAUTION: This function is deprecated because it requires allocating memory for the error
1182      * message unnecessarily. For custom revert reasons use {tryMod}.
1183      *
1184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1185      * opcode (which leaves remaining gas untouched) while Solidity uses an
1186      * invalid opcode to revert (consuming all remaining gas).
1187      *
1188      * Requirements:
1189      *
1190      * - The divisor cannot be zero.
1191      */
1192     function mod(
1193         uint256 a,
1194         uint256 b,
1195         string memory errorMessage
1196     ) internal pure returns (uint256) {
1197         unchecked {
1198             require(b > 0, errorMessage);
1199             return a % b;
1200         }
1201     }
1202 }
1203 
1204 // 
1205 /**
1206  * @dev These functions deal with verification of Merkle Trees proofs.
1207  *
1208  * The proofs can be generated using the JavaScript library
1209  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1210  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1211  *
1212  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1213  */
1214 library MerkleProof {
1215     /**
1216      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1217      * defined by `root`. For this, a `proof` must be provided, containing
1218      * sibling hashes on the branch from the leaf to the root of the tree. Each
1219      * pair of leaves and each pair of pre-images are assumed to be sorted.
1220      */
1221     function verify(
1222         bytes32[] memory proof,
1223         bytes32 root,
1224         bytes32 leaf
1225     ) internal pure returns (bool) {
1226         bytes32 computedHash = leaf;
1227 
1228         for (uint256 i = 0; i < proof.length; i++) {
1229             bytes32 proofElement = proof[i];
1230 
1231             if (computedHash <= proofElement) {
1232                 // Hash(current computed hash + current element of the proof)
1233                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1234             } else {
1235                 // Hash(current element of the proof + current computed hash)
1236                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1237             }
1238         }
1239 
1240         // Check if the computed hash (root) is equal to the provided root
1241         return computedHash == root;
1242     }
1243 }
1244 
1245 // 
1246 contract OwnableDelegateProxy { }
1247 
1248 // 
1249 contract OpenSeaProxyRegistry {
1250     mapping(address => OwnableDelegateProxy) public proxies;
1251 }
1252 
1253 // 
1254 contract TheWanderings is ERC721Enumerable, Ownable, Pausable {
1255 
1256     using SafeMath for uint256;
1257     using MerkleProof for bytes32[];
1258 
1259     bytes32 merkleRoot;
1260     bool merkleSet = false;
1261 
1262     uint256 public constant MAX_PER_CALL = 26;
1263     uint256 public constant MAX_PER_CALL_PRESALE = 5;
1264     // max supply is 4444, 4445 is used so we can use < instead of LTE, saving a tiny bit of gas when minting
1265     uint256 public constant MAX_SUPPLY = 4445;
1266     uint256 public NFT_PRICE = 0;
1267 
1268     string public baseURI;
1269     bool public presaleOngoing;
1270 
1271     address public proxyRegistryAddress;
1272     mapping(address => bool) public projectProxy;
1273     mapping(address => uint256) public presaleMintedAmounts;
1274 
1275     constructor(address openSeaProxy) ERC721("The Wanderings NFT", "The Wanderings NFT") {
1276         proxyRegistryAddress = openSeaProxy;
1277         _pause();
1278     }
1279 
1280     receive() external payable {}
1281 
1282     function _mint(address to, uint256 tokenId) internal override virtual {
1283         _owners.push(to);
1284         emit Transfer(address(0), to, tokenId);
1285     }
1286 
1287     function mint(uint256 amount) external payable whenNotPaused {
1288         require(amount < MAX_PER_CALL,  "Amount exceeds max per tx");
1289         uint256 ogAmount = _owners.length;
1290         require(ogAmount + amount < MAX_SUPPLY, "Amount exceeds max supply");
1291 
1292         for (uint256 i = 0; i < amount; i++) {
1293             _mint(msg.sender, ogAmount + i);
1294         }
1295     }
1296 
1297     function mintPresale(uint256 amount, bytes32[] memory merkleProof) external payable whenPaused {
1298         require(presaleOngoing, "Presale hasn't started yet");
1299         uint256 ogAmount = _owners.length;
1300         require(ogAmount + amount < MAX_SUPPLY, "Amount exceeds max supply");
1301         require(presaleMintedAmounts[msg.sender] + amount < MAX_PER_CALL_PRESALE, "Amount exceeds presale max");
1302 
1303         // Verify merkleProof
1304         require(merkleProof.verify(merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid proof. Not whitelisted");
1305 
1306 
1307         for (uint256 i = 0; i < amount; i++) {
1308             _mint(msg.sender, ogAmount + i);
1309         }
1310         presaleMintedAmounts[msg.sender] += amount;
1311     }
1312 
1313     function mintOwner(uint256 amount) external onlyOwner {
1314         uint256 ogAmount = _owners.length;
1315         require(_owners.length + amount < MAX_SUPPLY, "Amount exceeds max supply");
1316 
1317         for (uint256 i = 0; i < amount; i++) {
1318             _mint(msg.sender, ogAmount + i);
1319         }
1320     }
1321 
1322     function startPresale() external onlyOwner {
1323         presaleOngoing = true;
1324     }
1325 
1326     function setBaseURI(string memory uri) external onlyOwner {
1327         baseURI = uri;
1328     }
1329 
1330     function withdraw() external onlyOwner {
1331         payable(msg.sender).transfer(address(this).balance);
1332     }
1333 
1334     function setNftPrice(uint256 _nftPrice) external onlyOwner {
1335         NFT_PRICE = _nftPrice;
1336     }
1337 
1338     function pause() external onlyOwner {
1339         _pause();
1340     }
1341 
1342     function unpause() external onlyOwner {
1343         _unpause();
1344     }
1345 
1346     // Specify a merkle root hash from the gathered k/v dictionary of addresses
1347     // https://github.com/0xKiwi/go-merkle-distributor
1348     function setMerkleRoot(bytes32 root) external onlyOwner {
1349         merkleRoot = root;
1350         merkleSet = true;
1351     }
1352 
1353     // Return bool on if merkle root hash is set
1354     function isMerkleSet() public view returns (bool) {
1355         return merkleSet;
1356     }
1357 
1358     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1359         proxyRegistryAddress = _proxyRegistryAddress;
1360     }
1361 
1362     function flipProxyState(address proxyAddress) public onlyOwner {
1363         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1364     }
1365 
1366     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1367         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1368         if (address(proxyRegistry.proxies(_owner)) == operator || projectProxy[operator]) return true;
1369         return super.isApprovedForAll(_owner, operator);
1370     }
1371 
1372     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1373         require(_exists(_tokenId), "Token does not exist.");
1374         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1375     }
1376 
1377     // Returns a list of tokens owned by address
1378     // WARNING: VIEW ONLY, DO NOT USE THIS IN A TRANSACTION UNLESS YOU CAN AFFORD TO SPEND A LAMBO IN GAS
1379     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1380         uint256 tokenCount = balanceOf(_owner);
1381         if (tokenCount == 0) return new uint256[](0);
1382 
1383         uint256[] memory tokensId = new uint256[](tokenCount);
1384         for (uint256 i; i < tokenCount; i++) {
1385             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1386         }
1387         return tokensId;
1388     }
1389 }