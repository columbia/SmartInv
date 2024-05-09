1 // SPDX-License-Identifier: MIT
2 // File: repos/smart-contracts/rtp/contracts/Address.sol
3 
4 pragma solidity ^0.8.6;
5 
6 library Address {
7     function isContract(address account) internal view returns (bool) {
8         uint256 size;
9         assembly {
10             size := extcodesize(account)
11         }
12         return size > 0;
13     }
14 }
15 // File: @openzeppelin/contracts/utils/Strings.sol
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length)
72         internal
73         pure
74         returns (string memory)
75     {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @title ERC721 token receiver interface
96  * @dev Interface for any contract that wants to support safeTransfers
97  * from ERC721 asset contracts.
98  */
99 interface IERC721Receiver {
100     /**
101      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
102      * by `operator` from `from`, this function is called.
103      *
104      * It must return its Solidity selector to confirm the token transfer.
105      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
106      *
107      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
108      */
109     function onERC721Received(
110         address operator,
111         address from,
112         uint256 tokenId,
113         bytes calldata data
114     ) external returns (bytes4);
115 }
116 
117 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Implementation of the {IERC165} interface.
152  *
153  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
154  * for the additional interface id that will be supported. For example:
155  *
156  * ```solidity
157  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
158  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
159  * }
160  * ```
161  *
162  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
163  */
164 abstract contract ERC165 is IERC165 {
165     /**
166      * @dev See {IERC165-supportsInterface}.
167      */
168     function supportsInterface(bytes4 interfaceId)
169         public
170         view
171         virtual
172         override
173         returns (bool)
174     {
175         return interfaceId == type(IERC165).interfaceId;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Required interface of an ERC721 compliant contract.
187  */
188 interface IERC721 is IERC165 {
189     /**
190      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
191      */
192     event Transfer(
193         address indexed from,
194         address indexed to,
195         uint256 indexed tokenId
196     );
197 
198     /**
199      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
200      */
201     event Approval(
202         address indexed owner,
203         address indexed approved,
204         uint256 indexed tokenId
205     );
206 
207     /**
208      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
209      */
210     event ApprovalForAll(
211         address indexed owner,
212         address indexed operator,
213         bool approved
214     );
215 
216     /**
217      * @dev Returns the number of tokens in ``owner``'s account.
218      */
219     function balanceOf(address owner) external view returns (uint256 balance);
220 
221     /**
222      * @dev Returns the owner of the `tokenId` token.
223      *
224      * Requirements:
225      *
226      * - `tokenId` must exist.
227      */
228     function ownerOf(uint256 tokenId) external view returns (address owner);
229 
230     /**
231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Transfers `tokenId` token from `from` to `to`.
252      *
253      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must be owned by `from`.
260      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external;
269 
270     /**
271      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
272      * The approval is cleared when the token is transferred.
273      *
274      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
275      *
276      * Requirements:
277      *
278      * - The caller must own the token or be an approved operator.
279      * - `tokenId` must exist.
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address to, uint256 tokenId) external;
284 
285     /**
286      * @dev Returns the account approved for `tokenId` token.
287      *
288      * Requirements:
289      *
290      * - `tokenId` must exist.
291      */
292     function getApproved(uint256 tokenId)
293         external
294         view
295         returns (address operator);
296 
297     /**
298      * @dev Approve or remove `operator` as an operator for the caller.
299      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
311      *
312      * See {setApprovalForAll}
313      */
314     function isApprovedForAll(address owner, address operator)
315         external
316         view
317         returns (bool);
318 
319     /**
320      * @dev Safely transfers `tokenId` token from `from` to `to`.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must exist and be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
329      *
330      * Emits a {Transfer} event.
331      */
332     function safeTransferFrom(
333         address from,
334         address to,
335         uint256 tokenId,
336         bytes calldata data
337     ) external;
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
341 
342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
348  * @dev See https://eips.ethereum.org/EIPS/eip-721
349  */
350 interface IERC721Enumerable is IERC721 {
351     /**
352      * @dev Returns the total amount of tokens stored by the contract.
353      */
354     function totalSupply() external view returns (uint256);
355 
356     /**
357      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
358      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
359      */
360     function tokenOfOwnerByIndex(address owner, uint256 index)
361         external
362         view
363         returns (uint256 tokenId);
364 
365     /**
366      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
367      * Use along with {totalSupply} to enumerate all tokens.
368      */
369     function tokenByIndex(uint256 index) external view returns (uint256);
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
380  * @dev See https://eips.ethereum.org/EIPS/eip-721
381  */
382 interface IERC721Metadata is IERC721 {
383     /**
384      * @dev Returns the token collection name.
385      */
386     function name() external view returns (string memory);
387 
388     /**
389      * @dev Returns the token collection symbol.
390      */
391     function symbol() external view returns (string memory);
392 
393     /**
394      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
395      */
396     function tokenURI(uint256 tokenId) external view returns (string memory);
397 }
398 
399 // File: @openzeppelin/contracts/utils/Context.sol
400 
401 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev Provides information about the current execution context, including the
407  * sender of the transaction and its data. While these are generally available
408  * via msg.sender and msg.data, they should not be accessed in such a direct
409  * manner, since when dealing with meta-transactions the account sending and
410  * paying for execution may not be the actual sender (as far as an application
411  * is concerned).
412  *
413  * This contract is only required for intermediate, library-like contracts.
414  */
415 abstract contract Context {
416     function _msgSender() internal view virtual returns (address) {
417         return msg.sender;
418     }
419 
420     function _msgData() internal view virtual returns (bytes calldata) {
421         return msg.data;
422     }
423 }
424 
425 // File: repos/smart-contracts/rtp/contracts/ERC721.sol
426 
427 pragma solidity ^0.8.7;
428 
429 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
430     using Address for address;
431     using Strings for uint256;
432 
433     string private _name;
434     string private _symbol;
435 
436     // Mapping from token ID to owner address
437     address[] internal _owners;
438 
439     mapping(uint256 => address) private _tokenApprovals;
440     mapping(address => mapping(address => bool)) private _operatorApprovals;
441 
442     /**
443      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
444      */
445     constructor(string memory name_, string memory symbol_) {
446         _name = name_;
447         _symbol = symbol_;
448     }
449 
450     /**
451      * @dev See {IERC165-supportsInterface}.
452      */
453     function supportsInterface(bytes4 interfaceId)
454         public
455         view
456         virtual
457         override(ERC165, IERC165)
458         returns (bool)
459     {
460         return
461             interfaceId == type(IERC721).interfaceId ||
462             interfaceId == type(IERC721Metadata).interfaceId ||
463             super.supportsInterface(interfaceId);
464     }
465 
466     /**
467      * @dev See {IERC721-balanceOf}.
468      */
469     function balanceOf(address owner)
470         public
471         view
472         virtual
473         override
474         returns (uint256)
475     {
476         require(
477             owner != address(0),
478             "ERC721: balance query for the zero address"
479         );
480 
481         uint256 count;
482         for (uint256 i; i < _owners.length; ++i) {
483             if (owner == _owners[i]) ++count;
484         }
485         return count;
486     }
487 
488     /**
489      * @dev See {IERC721-ownerOf}.
490      */
491     function ownerOf(uint256 tokenId)
492         public
493         view
494         virtual
495         override
496         returns (address)
497     {
498         address owner = _owners[tokenId];
499         require(
500             owner != address(0),
501             "ERC721: owner query for nonexistent token"
502         );
503         return owner;
504     }
505 
506     /**
507      * @dev See {IERC721Metadata-name}.
508      */
509     function name() public view virtual override returns (string memory) {
510         return _name;
511     }
512 
513     /**
514      * @dev See {IERC721Metadata-symbol}.
515      */
516     function symbol() public view virtual override returns (string memory) {
517         return _symbol;
518     }
519 
520     /**
521      * @dev See {IERC721-approve}.
522      */
523     function approve(address to, uint256 tokenId) public virtual override {
524         address owner = ERC721.ownerOf(tokenId);
525         require(to != owner, "ERC721: approval to current owner");
526 
527         require(
528             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
529             "ERC721: approve caller is not owner nor approved for all"
530         );
531 
532         _approve(to, tokenId);
533     }
534 
535     /**
536      * @dev See {IERC721-getApproved}.
537      */
538     function getApproved(uint256 tokenId)
539         public
540         view
541         virtual
542         override
543         returns (address)
544     {
545         require(
546             _exists(tokenId),
547             "ERC721: approved query for nonexistent token"
548         );
549 
550         return _tokenApprovals[tokenId];
551     }
552 
553     /**
554      * @dev See {IERC721-setApprovalForAll}.
555      */
556     function setApprovalForAll(address operator, bool approved)
557         public
558         virtual
559         override
560     {
561         require(operator != _msgSender(), "ERC721: approve to caller");
562 
563         _operatorApprovals[_msgSender()][operator] = approved;
564         emit ApprovalForAll(_msgSender(), operator, approved);
565     }
566 
567     /**
568      * @dev See {IERC721-isApprovedForAll}.
569      */
570     function isApprovedForAll(address owner, address operator)
571         public
572         view
573         virtual
574         override
575         returns (bool)
576     {
577         return _operatorApprovals[owner][operator];
578     }
579 
580     /**
581      * @dev See {IERC721-transferFrom}.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) public virtual override {
588         //solhint-disable-next-line max-line-length
589         require(
590             _isApprovedOrOwner(_msgSender(), tokenId),
591             "ERC721: transfer caller is not owner nor approved"
592         );
593 
594         _transfer(from, to, tokenId);
595     }
596 
597     /**
598      * @dev See {IERC721-safeTransferFrom}.
599      */
600     function safeTransferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) public virtual override {
605         safeTransferFrom(from, to, tokenId, "");
606     }
607 
608     /**
609      * @dev See {IERC721-safeTransferFrom}.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes memory _data
616     ) public virtual override {
617         require(
618             _isApprovedOrOwner(_msgSender(), tokenId),
619             "ERC721: transfer caller is not owner nor approved"
620         );
621         _safeTransfer(from, to, tokenId, _data);
622     }
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
626      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
627      *
628      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
629      *
630      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
631      * implement alternative mechanisms to perform token transfer, such as signature-based.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function _safeTransfer(
643         address from,
644         address to,
645         uint256 tokenId,
646         bytes memory _data
647     ) internal virtual {
648         _transfer(from, to, tokenId);
649         require(
650             _checkOnERC721Received(from, to, tokenId, _data),
651             "ERC721: transfer to non ERC721Receiver implementer"
652         );
653     }
654 
655     /**
656      * @dev Returns whether `tokenId` exists.
657      *
658      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
659      *
660      * Tokens start existing when they are minted (`_mint`),
661      * and stop existing when they are burned (`_burn`).
662      */
663     function _exists(uint256 tokenId) internal view virtual returns (bool) {
664         return tokenId < _owners.length && _owners[tokenId] != address(0);
665     }
666 
667     /**
668      * @dev Returns whether `spender` is allowed to manage `tokenId`.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function _isApprovedOrOwner(address spender, uint256 tokenId)
675         internal
676         view
677         virtual
678         returns (bool)
679     {
680         require(
681             _exists(tokenId),
682             "ERC721: operator query for nonexistent token"
683         );
684         address owner = ERC721.ownerOf(tokenId);
685         return (spender == owner ||
686             getApproved(tokenId) == spender ||
687             isApprovedForAll(owner, spender));
688     }
689 
690     /**
691      * @dev Safely mints `tokenId` and transfers it to `to`.
692      *
693      * Requirements:
694      *
695      * - `tokenId` must not exist.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function _safeMint(address to, uint256 tokenId) internal virtual {
701         _safeMint(to, tokenId, "");
702     }
703 
704     /**
705      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
706      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
707      */
708     function _safeMint(
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) internal virtual {
713         _mint(to, tokenId);
714         require(
715             _checkOnERC721Received(address(0), to, tokenId, _data),
716             "ERC721: transfer to non ERC721Receiver implementer"
717         );
718     }
719 
720     /**
721      * @dev Mints `tokenId` and transfers it to `to`.
722      *
723      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
724      *
725      * Requirements:
726      *
727      * - `tokenId` must not exist.
728      * - `to` cannot be the zero address.
729      *
730      * Emits a {Transfer} event.
731      */
732     function _mint(address to, uint256 tokenId) internal virtual {
733         require(to != address(0), "ERC721: mint to the zero address");
734         require(!_exists(tokenId), "ERC721: token already minted");
735 
736         _beforeTokenTransfer(address(0), to, tokenId);
737         _owners.push(to);
738 
739         emit Transfer(address(0), to, tokenId);
740     }
741 
742     /**
743      * @dev Destroys `tokenId`.
744      * The approval is cleared when the token is burned.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _burn(uint256 tokenId) internal virtual {
753         address owner = ERC721.ownerOf(tokenId);
754 
755         _beforeTokenTransfer(owner, address(0), tokenId);
756 
757         // Clear approvals
758         _approve(address(0), tokenId);
759         _owners[tokenId] = address(0);
760 
761         emit Transfer(owner, address(0), tokenId);
762     }
763 
764     /**
765      * @dev Transfers `tokenId` from `from` to `to`.
766      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must be owned by `from`.
772      *
773      * Emits a {Transfer} event.
774      */
775     function _transfer(
776         address from,
777         address to,
778         uint256 tokenId
779     ) internal virtual {
780         require(
781             ERC721.ownerOf(tokenId) == from,
782             "ERC721: transfer of token that is not own"
783         );
784         require(to != address(0), "ERC721: transfer to the zero address");
785 
786         _beforeTokenTransfer(from, to, tokenId);
787 
788         // Clear approvals from the previous owner
789         _approve(address(0), tokenId);
790         _owners[tokenId] = to;
791 
792         emit Transfer(from, to, tokenId);
793     }
794 
795     /**
796      * @dev Approve `to` to operate on `tokenId`
797      *
798      * Emits a {Approval} event.
799      */
800     function _approve(address to, uint256 tokenId) internal virtual {
801         _tokenApprovals[tokenId] = to;
802         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
803     }
804 
805     /**
806      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
807      * The call is not executed if the target address is not a contract.
808      *
809      * @param from address representing the previous owner of the given token ID
810      * @param to target address that will receive the tokens
811      * @param tokenId uint256 ID of the token to be transferred
812      * @param _data bytes optional data to send along with the call
813      * @return bool whether the call correctly returned the expected magic value
814      */
815     function _checkOnERC721Received(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) private returns (bool) {
821         if (to.isContract()) {
822             try
823                 IERC721Receiver(to).onERC721Received(
824                     _msgSender(),
825                     from,
826                     tokenId,
827                     _data
828                 )
829             returns (bytes4 retval) {
830                 return retval == IERC721Receiver.onERC721Received.selector;
831             } catch (bytes memory reason) {
832                 if (reason.length == 0) {
833                     revert(
834                         "ERC721: transfer to non ERC721Receiver implementer"
835                     );
836                 } else {
837                     assembly {
838                         revert(add(32, reason), mload(reason))
839                     }
840                 }
841             }
842         } else {
843             return true;
844         }
845     }
846 
847     /**
848      * @dev Hook that is called before any token transfer. This includes minting
849      * and burning.
850      *
851      * Calling conditions:
852      *
853      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
854      * transferred to `to`.
855      * - When `from` is zero, `tokenId` will be minted for `to`.
856      * - When `to` is zero, ``from``'s `tokenId` will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(
862         address from,
863         address to,
864         uint256 tokenId
865     ) internal virtual {}
866 }
867 // File: repos/smart-contracts/rtp/contracts/ERC721Enumerable.sol
868 
869 pragma solidity ^0.8.7;
870 
871 /**
872  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
873  * enumerability of all the token ids in the contract as well as all token ids owned by each
874  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
875  */
876 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
877     /**
878      * @dev See {IERC165-supportsInterface}.
879      */
880     function supportsInterface(bytes4 interfaceId)
881         public
882         view
883         virtual
884         override(IERC165, ERC721)
885         returns (bool)
886     {
887         return
888             interfaceId == type(IERC721Enumerable).interfaceId ||
889             super.supportsInterface(interfaceId);
890     }
891 
892     /**
893      * @dev See {IERC721Enumerable-totalSupply}.
894      */
895     function totalSupply() public view virtual override returns (uint256) {
896         return _owners.length;
897     }
898 
899     /**
900      * @dev See {IERC721Enumerable-tokenByIndex}.
901      */
902     function tokenByIndex(uint256 index)
903         public
904         view
905         virtual
906         override
907         returns (uint256)
908     {
909         require(
910             index < _owners.length,
911             "ERC721Enumerable: global index out of bounds"
912         );
913         return index;
914     }
915 
916     /**
917      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
918      */
919     function tokenOfOwnerByIndex(address owner, uint256 index)
920         public
921         view
922         virtual
923         override
924         returns (uint256 tokenId)
925     {
926         require(
927             index < balanceOf(owner),
928             "ERC721Enumerable: owner index out of bounds"
929         );
930 
931         uint256 count;
932         for (uint256 i; i < _owners.length; i++) {
933             if (owner == _owners[i]) {
934                 if (count == index) return i;
935                 else count++;
936             }
937         }
938 
939         revert("ERC721Enumerable: owner index out of bounds");
940     }
941 }
942 // File: @openzeppelin/contracts/access/Ownable.sol
943 
944 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 /**
949  * @dev Contract module which provides a basic access control mechanism, where
950  * there is an account (an owner) that can be granted exclusive access to
951  * specific functions.
952  *
953  * By default, the owner account will be the one that deploys the contract. This
954  * can later be changed with {transferOwnership}.
955  *
956  * This module is used through inheritance. It will make available the modifier
957  * `onlyOwner`, which can be applied to your functions to restrict their use to
958  * the owner.
959  */
960 abstract contract Ownable is Context {
961     address private _owner;
962 
963     event OwnershipTransferred(
964         address indexed previousOwner,
965         address indexed newOwner
966     );
967 
968     /**
969      * @dev Initializes the contract setting the deployer as the initial owner.
970      */
971     constructor() {
972         _transferOwnership(_msgSender());
973     }
974 
975     /**
976      * @dev Returns the address of the current owner.
977      */
978     function owner() public view virtual returns (address) {
979         return _owner;
980     }
981 
982     /**
983      * @dev Throws if called by any account other than the owner.
984      */
985     modifier onlyOwner() {
986         require(owner() == _msgSender(), "Ownable: caller is not the owner");
987         _;
988     }
989 
990     /**
991      * @dev Leaves the contract without owner. It will not be possible to call
992      * `onlyOwner` functions anymore. Can only be called by the current owner.
993      *
994      * NOTE: Renouncing ownership will leave the contract without an owner,
995      * thereby removing any functionality that is only available to the owner.
996      */
997     function renounceOwnership() public virtual onlyOwner {
998         _transferOwnership(address(0));
999     }
1000 
1001     /**
1002      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1003      * Can only be called by the current owner.
1004      */
1005     function transferOwnership(address newOwner) public virtual onlyOwner {
1006         require(
1007             newOwner != address(0),
1008             "Ownable: new owner is the zero address"
1009         );
1010         _transferOwnership(newOwner);
1011     }
1012 
1013     /**
1014      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1015      * Internal function without access restriction.
1016      */
1017     function _transferOwnership(address newOwner) internal virtual {
1018         address oldOwner = _owner;
1019         _owner = newOwner;
1020         emit OwnershipTransferred(oldOwner, newOwner);
1021     }
1022 }
1023 
1024 // File: repos/smart-contracts/rtp/contracts/rtp.sol
1025 
1026 pragma solidity ^0.8.7;
1027 
1028 /**
1029  * Hiya
1030  * This smart contract we have taken every measure possible to
1031  * keep the costs of gas managable every step along the way.
1032  *
1033  * In this contract we've used several different methods to keep costs down.
1034  * If you came here worried because gas is so low or you don't have to pay that pesky
1035  * OpenSea approval fee; rejoice!
1036 
1037  * Contract by: _granto for SmeistyCo
1038  * Based on the work of solidity geniuses: nftchance & masonnft & squeebo_nft
1039 
1040        ____
1041            !
1042      !     !
1043      !      `-  _ _    _
1044      |              ```  !
1045 _____!                   !
1046 \,      Made in Texas     \
1047   l    _                  ;
1048    \ _/  \.              /
1049            \           .’
1050             .       ./’
1051              `.    ,
1052                \   ;
1053                  ``’
1054 
1055  */
1056 
1057 contract coldAF is ERC721Enumerable, Ownable {
1058     string public baseURI;
1059 
1060     address public proxyRegistryAddress;
1061     address public treasuryAccount;
1062 
1063     uint256 public MAX_SUPPLY = 1200;
1064 
1065     uint256 public constant MAX_PER_TX = 2;
1066     uint256 public constant RESERVES = 24;
1067     uint256 public priceInWei = 0.000 ether;
1068     bool public publicSaleActive = false;
1069 
1070     mapping(address => bool) public projectProxy;
1071     mapping(address => uint256) public addressToMinted;
1072 
1073     constructor(string memory _baseURI, address _treasuryAccount)
1074         ERC721("It's Cold AF", "ColdAF")
1075     {
1076         baseURI = _baseURI;
1077         proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1078         treasuryAccount = _treasuryAccount;
1079     }
1080 
1081     function setBaseURI(string memory _baseURI) public onlyOwner {
1082         baseURI = _baseURI;
1083     }
1084 
1085     function tokenURI(uint256 _tokenId)
1086         public
1087         view
1088         override
1089         returns (string memory)
1090     {
1091         require(_exists(_tokenId), "Token does not exist.");
1092         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1093     }
1094 
1095     function setProxyRegistryAddress(address _proxyRegistryAddress)
1096         external
1097         onlyOwner
1098     {
1099         proxyRegistryAddress = _proxyRegistryAddress;
1100     }
1101 
1102     function flipProxyState(address proxyAddress) public onlyOwner {
1103         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1104     }
1105 
1106     function unlockXMore(uint256 x) public onlyOwner {
1107         MAX_SUPPLY = MAX_SUPPLY + x;
1108     }
1109 
1110     function setPriceInWei(uint256 _priceInWei) public onlyOwner {
1111         priceInWei = _priceInWei;
1112     }
1113 
1114     function togglePublicSaleActive() external onlyOwner {
1115         publicSaleActive = !publicSaleActive;
1116     }
1117 
1118     function collectReserves() external onlyOwner {
1119         require(_owners.length == 0, "Reserves already taken.");
1120         for (uint256 i; i < RESERVES; i++) _mint(_msgSender(), i);
1121     }
1122 
1123     function mint(uint256 count) public payable {
1124         uint256 totalSupply = _owners.length;
1125         require(publicSaleActive, "Public sale is not active.");
1126         require(totalSupply + count < MAX_SUPPLY + 1, "Excedes max supply.");
1127         require(count < MAX_PER_TX + 1, "Exceeds max per transaction.");
1128         require(count * priceInWei == msg.value, "Invalid funds provided.");
1129 
1130         for (uint256 i; i < count; i++) {
1131             _mint(_msgSender(), totalSupply + i);
1132         }
1133     }
1134 
1135     function burn(uint256 tokenId) public {
1136         require(
1137             _isApprovedOrOwner(_msgSender(), tokenId),
1138             "Not approved to burn."
1139         );
1140         _burn(tokenId);
1141     }
1142 
1143     function withdraw() public {
1144         (bool success, ) = treasuryAccount.call{value: address(this).balance}(
1145             ""
1146         );
1147         require(success, "Failed to send to treasury.");
1148     }
1149 
1150     function walletOfOwner(address _owner)
1151         public
1152         view
1153         returns (uint256[] memory)
1154     {
1155         uint256 tokenCount = balanceOf(_owner);
1156         if (tokenCount == 0) return new uint256[](0);
1157 
1158         uint256[] memory tokensId = new uint256[](tokenCount);
1159         for (uint256 i; i < tokenCount; i++) {
1160             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1161         }
1162         return tokensId;
1163     }
1164 
1165     function batchTransferFrom(
1166         address _from,
1167         address _to,
1168         uint256[] memory _tokenIds
1169     ) public {
1170         for (uint256 i = 0; i < _tokenIds.length; i++) {
1171             transferFrom(_from, _to, _tokenIds[i]);
1172         }
1173     }
1174 
1175     function batchSafeTransferFrom(
1176         address _from,
1177         address _to,
1178         uint256[] memory _tokenIds,
1179         bytes memory data_
1180     ) public {
1181         for (uint256 i = 0; i < _tokenIds.length; i++) {
1182             safeTransferFrom(_from, _to, _tokenIds[i], data_);
1183         }
1184     }
1185 
1186     function isOwnerOf(address account, uint256[] calldata _tokenIds)
1187         external
1188         view
1189         returns (bool)
1190     {
1191         for (uint256 i; i < _tokenIds.length; ++i) {
1192             if (_owners[_tokenIds[i]] != account) return false;
1193         }
1194 
1195         return true;
1196     }
1197 
1198     function isApprovedForAll(address _owner, address operator)
1199         public
1200         view
1201         override
1202         returns (bool)
1203     {
1204         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(
1205             proxyRegistryAddress
1206         );
1207         if (
1208             address(proxyRegistry.proxies(_owner)) == operator ||
1209             projectProxy[operator]
1210         ) return true;
1211         return super.isApprovedForAll(_owner, operator);
1212     }
1213 
1214     function _mint(address to, uint256 tokenId) internal virtual override {
1215         _owners.push(to);
1216         emit Transfer(address(0), to, tokenId);
1217     }
1218 }
1219 
1220 contract OwnableDelegateProxy {}
1221 
1222 contract OpenSeaProxyRegistry {
1223     mapping(address => OwnableDelegateProxy) public proxies;
1224 }