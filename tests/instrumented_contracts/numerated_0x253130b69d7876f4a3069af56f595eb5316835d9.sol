1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.6;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         uint size;
8         assembly {
9             size := extcodesize(account)
10         }
11         return size > 0;
12     }
13 }
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
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
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @title ERC721 token receiver interface
93  * @dev Interface for any contract that wants to support safeTransfers
94  * from ERC721 asset contracts.
95  */
96 interface IERC721Receiver {
97     /**
98      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
99      * by `operator` from `from`, this function is called.
100      *
101      * It must return its Solidity selector to confirm the token transfer.
102      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
103      *
104      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
105      */
106     function onERC721Received(
107         address operator,
108         address from,
109         uint256 tokenId,
110         bytes calldata data
111     ) external returns (bytes4);
112 }
113 
114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Interface of the ERC165 standard, as defined in the
123  * https://eips.ethereum.org/EIPS/eip-165[EIP].
124  *
125  * Implementers can declare support of contract interfaces, which can then be
126  * queried by others ({ERC165Checker}).
127  *
128  * For an implementation, see {ERC165}.
129  */
130 interface IERC165 {
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 }
141 
142 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
146 
147 pragma solidity ^0.8.0;
148 
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
168     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
169         return interfaceId == type(IERC165).interfaceId;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Required interface of an ERC721 compliant contract.
183  */
184 interface IERC721 is IERC165 {
185     /**
186      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
189 
190     /**
191      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
192      */
193     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
197      */
198     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
199 
200     /**
201      * @dev Returns the number of tokens in ``owner``'s account.
202      */
203     function balanceOf(address owner) external view returns (uint256 balance);
204 
205     /**
206      * @dev Returns the owner of the `tokenId` token.
207      *
208      * Requirements:
209      *
210      * - `tokenId` must exist.
211      */
212     function ownerOf(uint256 tokenId) external view returns (address owner);
213 
214     /**
215      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
216      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
217      *
218      * Requirements:
219      *
220      * - `from` cannot be the zero address.
221      * - `to` cannot be the zero address.
222      * - `tokenId` token must exist and be owned by `from`.
223      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
225      *
226      * Emits a {Transfer} event.
227      */
228     function safeTransferFrom(
229         address from,
230         address to,
231         uint256 tokenId
232     ) external;
233 
234     /**
235      * @dev Transfers `tokenId` token from `from` to `to`.
236      *
237      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must be owned by `from`.
244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
256      * The approval is cleared when the token is transferred.
257      *
258      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
259      *
260      * Requirements:
261      *
262      * - The caller must own the token or be an approved operator.
263      * - `tokenId` must exist.
264      *
265      * Emits an {Approval} event.
266      */
267     function approve(address to, uint256 tokenId) external;
268 
269     /**
270      * @dev Returns the account approved for `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function getApproved(uint256 tokenId) external view returns (address operator);
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
281      *
282      * Requirements:
283      *
284      * - The `operator` cannot be the caller.
285      *
286      * Emits an {ApprovalForAll} event.
287      */
288     function setApprovalForAll(address operator, bool _approved) external;
289 
290     /**
291      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
292      *
293      * See {setApprovalForAll}
294      */
295     function isApprovedForAll(address owner, address operator) external view returns (bool);
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must exist and be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId,
314         bytes calldata data
315     ) external;
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
328  * @dev See https://eips.ethereum.org/EIPS/eip-721
329  */
330 interface IERC721Enumerable is IERC721 {
331     /**
332      * @dev Returns the total amount of tokens stored by the contract.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
338      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
339      */
340     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
341 
342     /**
343      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
344      * Use along with {totalSupply} to enumerate all tokens.
345      */
346     function tokenByIndex(uint256 index) external view returns (uint256);
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
359  * @dev See https://eips.ethereum.org/EIPS/eip-721
360  */
361 interface IERC721Metadata is IERC721 {
362     /**
363      * @dev Returns the token collection name.
364      */
365     function name() external view returns (string memory);
366 
367     /**
368      * @dev Returns the token collection symbol.
369      */
370     function symbol() external view returns (string memory);
371 
372     /**
373      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
374      */
375     function tokenURI(uint256 tokenId) external view returns (string memory);
376 }
377 
378 // File: @openzeppelin/contracts/utils/Context.sol
379 
380 
381 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Provides information about the current execution context, including the
387  * sender of the transaction and its data. While these are generally available
388  * via msg.sender and msg.data, they should not be accessed in such a direct
389  * manner, since when dealing with meta-transactions the account sending and
390  * paying for execution may not be the actual sender (as far as an application
391  * is concerned).
392  *
393  * This contract is only required for intermediate, library-like contracts.
394  */
395 abstract contract Context {
396     function _msgSender() internal view virtual returns (address) {
397         return msg.sender;
398     }
399 
400     function _msgData() internal view virtual returns (bytes calldata) {
401         return msg.data;
402     }
403 }
404 
405 pragma solidity ^0.8.7;
406 
407 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
408     using Address for address;
409     using Strings for uint256;
410     
411     string private _name;
412     string private _symbol;
413 
414     // Mapping from token ID to owner address
415     address[] internal _owners;
416 
417     mapping(uint256 => address) private _tokenApprovals;
418     mapping(address => mapping(address => bool)) private _operatorApprovals;
419 
420     /**
421      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
422      */
423     constructor(string memory name_, string memory symbol_) {
424         _name = name_;
425         _symbol = symbol_;
426     }
427 
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId)
432         public
433         view
434         virtual
435         override(ERC165, IERC165)
436         returns (bool)
437     {
438         return
439             interfaceId == type(IERC721).interfaceId ||
440             interfaceId == type(IERC721Metadata).interfaceId ||
441             super.supportsInterface(interfaceId);
442     }
443 
444     /**
445      * @dev See {IERC721-balanceOf}.
446      */
447     function balanceOf(address owner) 
448         public 
449         view 
450         virtual 
451         override 
452         returns (uint) 
453     {
454         require(owner != address(0), "ERC721: balance query for the zero address");
455 
456         uint count;
457         for( uint i; i < _owners.length; ++i ){
458           if( owner == _owners[i] )
459             ++count;
460         }
461         return count;
462     }
463 
464     /**
465      * @dev See {IERC721-ownerOf}.
466      */
467     function ownerOf(uint256 tokenId)
468         public
469         view
470         virtual
471         override
472         returns (address)
473     {
474         address owner = _owners[tokenId];
475         require(
476             owner != address(0),
477             "ERC721: owner query for nonexistent token"
478         );
479         return owner;
480     }
481 
482     /**
483      * @dev See {IERC721Metadata-name}.
484      */
485     function name() public view virtual override returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev See {IERC721Metadata-symbol}.
491      */
492     function symbol() public view virtual override returns (string memory) {
493         return _symbol;
494     }
495 
496     /**
497      * @dev See {IERC721-approve}.
498      */
499     function approve(address to, uint256 tokenId) public virtual override {
500         address owner = ERC721.ownerOf(tokenId);
501         require(to != owner, "ERC721: approval to current owner");
502 
503         require(
504             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
505             "ERC721: approve caller is not owner nor approved for all"
506         );
507 
508         _approve(to, tokenId);
509     }
510 
511     /**
512      * @dev See {IERC721-getApproved}.
513      */
514     function getApproved(uint256 tokenId)
515         public
516         view
517         virtual
518         override
519         returns (address)
520     {
521         require(
522             _exists(tokenId),
523             "ERC721: approved query for nonexistent token"
524         );
525 
526         return _tokenApprovals[tokenId];
527     }
528 
529     /**
530      * @dev See {IERC721-setApprovalForAll}.
531      */
532     function setApprovalForAll(address operator, bool approved)
533         public
534         virtual
535         override
536     {
537         require(operator != _msgSender(), "ERC721: approve to caller");
538 
539         _operatorApprovals[_msgSender()][operator] = approved;
540         emit ApprovalForAll(_msgSender(), operator, approved);
541     }
542 
543     /**
544      * @dev See {IERC721-isApprovedForAll}.
545      */
546     function isApprovedForAll(address owner, address operator)
547         public
548         view
549         virtual
550         override
551         returns (bool)
552     {
553         return _operatorApprovals[owner][operator];
554     }
555 
556     /**
557      * @dev See {IERC721-transferFrom}.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) public virtual override {
564         //solhint-disable-next-line max-line-length
565         require(
566             _isApprovedOrOwner(_msgSender(), tokenId),
567             "ERC721: transfer caller is not owner nor approved"
568         );
569 
570         _transfer(from, to, tokenId);
571     }
572 
573     /**
574      * @dev See {IERC721-safeTransferFrom}.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId
580     ) public virtual override {
581         safeTransferFrom(from, to, tokenId, "");
582     }
583 
584     /**
585      * @dev See {IERC721-safeTransferFrom}.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId,
591         bytes memory _data
592     ) public virtual override {
593         require(
594             _isApprovedOrOwner(_msgSender(), tokenId),
595             "ERC721: transfer caller is not owner nor approved"
596         );
597         _safeTransfer(from, to, tokenId, _data);
598     }
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
605      *
606      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
607      * implement alternative mechanisms to perform token transfer, such as signature-based.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function _safeTransfer(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes memory _data
623     ) internal virtual {
624         _transfer(from, to, tokenId);
625         require(
626             _checkOnERC721Received(from, to, tokenId, _data),
627             "ERC721: transfer to non ERC721Receiver implementer"
628         );
629     }
630 
631     /**
632      * @dev Returns whether `tokenId` exists.
633      *
634      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
635      *
636      * Tokens start existing when they are minted (`_mint`),
637      * and stop existing when they are burned (`_burn`).
638      */
639     function _exists(uint256 tokenId) internal view virtual returns (bool) {
640         return tokenId < _owners.length && _owners[tokenId] != address(0);
641     }
642 
643     /**
644      * @dev Returns whether `spender` is allowed to manage `tokenId`.
645      *
646      * Requirements:
647      *
648      * - `tokenId` must exist.
649      */
650     function _isApprovedOrOwner(address spender, uint256 tokenId)
651         internal
652         view
653         virtual
654         returns (bool)
655     {
656         require(
657             _exists(tokenId),
658             "ERC721: operator query for nonexistent token"
659         );
660         address owner = ERC721.ownerOf(tokenId);
661         return (spender == owner ||
662             getApproved(tokenId) == spender ||
663             isApprovedForAll(owner, spender));
664     }
665 
666     /**
667      * @dev Safely mints `tokenId` and transfers it to `to`.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must not exist.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function _safeMint(address to, uint256 tokenId) internal virtual {
677         _safeMint(to, tokenId, "");
678     }
679 
680     /**
681      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
682      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
683      */
684     function _safeMint(
685         address to,
686         uint256 tokenId,
687         bytes memory _data
688     ) internal virtual {
689         _mint(to, tokenId);
690         require(
691             _checkOnERC721Received(address(0), to, tokenId, _data),
692             "ERC721: transfer to non ERC721Receiver implementer"
693         );
694     }
695 
696     /**
697      * @dev Mints `tokenId` and transfers it to `to`.
698      *
699      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
700      *
701      * Requirements:
702      *
703      * - `tokenId` must not exist.
704      * - `to` cannot be the zero address.
705      *
706      * Emits a {Transfer} event.
707      */
708     function _mint(address to, uint256 tokenId) internal virtual {
709         require(to != address(0), "ERC721: mint to the zero address");
710         require(!_exists(tokenId), "ERC721: token already minted");
711 
712         _beforeTokenTransfer(address(0), to, tokenId);
713         _owners.push(to);
714 
715         emit Transfer(address(0), to, tokenId);
716     }
717 
718     /**
719      * @dev Destroys `tokenId`.
720      * The approval is cleared when the token is burned.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _burn(uint256 tokenId) internal virtual {
729         address owner = ERC721.ownerOf(tokenId);
730 
731         _beforeTokenTransfer(owner, address(0), tokenId);
732 
733         // Clear approvals
734         _approve(address(0), tokenId);
735         _owners[tokenId] = address(0);
736 
737         emit Transfer(owner, address(0), tokenId);
738     }
739 
740     /**
741      * @dev Transfers `tokenId` from `from` to `to`.
742      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
743      *
744      * Requirements:
745      *
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must be owned by `from`.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _transfer(
752         address from,
753         address to,
754         uint256 tokenId
755     ) internal virtual {
756         require(
757             ERC721.ownerOf(tokenId) == from,
758             "ERC721: transfer of token that is not own"
759         );
760         require(to != address(0), "ERC721: transfer to the zero address");
761 
762         _beforeTokenTransfer(from, to, tokenId);
763 
764         // Clear approvals from the previous owner
765         _approve(address(0), tokenId);
766         _owners[tokenId] = to;
767 
768         emit Transfer(from, to, tokenId);
769     }
770 
771     /**
772      * @dev Approve `to` to operate on `tokenId`
773      *
774      * Emits a {Approval} event.
775      */
776     function _approve(address to, uint256 tokenId) internal virtual {
777         _tokenApprovals[tokenId] = to;
778         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
779     }
780 
781     /**
782      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
783      * The call is not executed if the target address is not a contract.
784      *
785      * @param from address representing the previous owner of the given token ID
786      * @param to target address that will receive the tokens
787      * @param tokenId uint256 ID of the token to be transferred
788      * @param _data bytes optional data to send along with the call
789      * @return bool whether the call correctly returned the expected magic value
790      */
791     function _checkOnERC721Received(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) private returns (bool) {
797         if (to.isContract()) {
798             try
799                 IERC721Receiver(to).onERC721Received(
800                     _msgSender(),
801                     from,
802                     tokenId,
803                     _data
804                 )
805             returns (bytes4 retval) {
806                 return retval == IERC721Receiver.onERC721Received.selector;
807             } catch (bytes memory reason) {
808                 if (reason.length == 0) {
809                     revert(
810                         "ERC721: transfer to non ERC721Receiver implementer"
811                     );
812                 } else {
813                     assembly {
814                         revert(add(32, reason), mload(reason))
815                     }
816                 }
817             }
818         } else {
819             return true;
820         }
821     }
822 
823     /**
824      * @dev Hook that is called before any token transfer. This includes minting
825      * and burning.
826      *
827      * Calling conditions:
828      *
829      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
830      * transferred to `to`.
831      * - When `from` is zero, `tokenId` will be minted for `to`.
832      * - When `to` is zero, ``from``'s `tokenId` will be burned.
833      * - `from` and `to` are never both zero.
834      *
835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
836      */
837     function _beforeTokenTransfer(
838         address from,
839         address to,
840         uint256 tokenId
841     ) internal virtual {}
842 }
843 
844 pragma solidity ^0.8.7;
845 
846 /**
847  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
848  * enumerability of all the token ids in the contract as well as all token ids owned by each
849  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
850  */
851 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
852     /**
853      * @dev See {IERC165-supportsInterface}.
854      */
855     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
856         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721Enumerable-totalSupply}.
861      */
862     function totalSupply() public view virtual override returns (uint256) {
863         return _owners.length;
864     }
865 
866     /**
867      * @dev See {IERC721Enumerable-tokenByIndex}.
868      */
869     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
870         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
871         return index;
872     }
873 
874     /**
875      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
876      */
877     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
878         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
879 
880         uint count;
881         for(uint i; i < _owners.length; i++){
882             if(owner == _owners[i]){
883                 if(count == index) return i;
884                 else count++;
885             }
886         }
887 
888         revert("ERC721Enumerable: owner index out of bounds");
889     }
890 }
891 // File: @openzeppelin/contracts/access/Ownable.sol
892 
893 
894 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @dev Contract module which provides a basic access control mechanism, where
901  * there is an account (an owner) that can be granted exclusive access to
902  * specific functions.
903  *
904  * By default, the owner account will be the one that deploys the contract. This
905  * can later be changed with {transferOwnership}.
906  *
907  * This module is used through inheritance. It will make available the modifier
908  * `onlyOwner`, which can be applied to your functions to restrict their use to
909  * the owner.
910  */
911 abstract contract Ownable is Context {
912     address private _owner;
913 
914     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
915 
916     /**
917      * @dev Initializes the contract setting the deployer as the initial owner.
918      */
919     constructor() {
920         _transferOwnership(_msgSender());
921     }
922 
923     /**
924      * @dev Returns the address of the current owner.
925      */
926     function owner() public view virtual returns (address) {
927         return _owner;
928     }
929 
930     /**
931      * @dev Throws if called by any account other than the owner.
932      */
933     modifier onlyOwner() {
934         require(owner() == _msgSender(), "Ownable: caller is not the owner");
935         _;
936     }
937 
938     /**
939      * @dev Leaves the contract without owner. It will not be possible to call
940      * `onlyOwner` functions anymore. Can only be called by the current owner.
941      *
942      * NOTE: Renouncing ownership will leave the contract without an owner,
943      * thereby removing any functionality that is only available to the owner.
944      */
945     function renounceOwnership() public virtual onlyOwner {
946         _transferOwnership(address(0));
947     }
948 
949     /**
950      * @dev Transfers ownership of the contract to a new account (`newOwner`).
951      * Can only be called by the current owner.
952      */
953     function transferOwnership(address newOwner) public virtual onlyOwner {
954         require(newOwner != address(0), "Ownable: new owner is the zero address");
955         _transferOwnership(newOwner);
956     }
957 
958     /**
959      * @dev Transfers ownership of the contract to a new account (`newOwner`).
960      * Internal function without access restriction.
961      */
962     function _transferOwnership(address newOwner) internal virtual {
963         address oldOwner = _owner;
964         _owner = newOwner;
965         emit OwnershipTransferred(oldOwner, newOwner);
966     }
967 }
968 
969 pragma solidity ^0.8.7;
970 
971 /**
972  * Hiya
973  * This smart contract we have taken every measure possible to
974  * keep the costs of gas managable every step along the way.
975  * 
976  * In this contract we've used several different methods to keep costs down.
977  * If you came here worried because gas is so low or you don't have to pay that pesky
978  * OpenSea approval fee; rejoice! 
979 
980  * Contract by: _granto
981  * Based on the work of solidity geniuses: nftchance & masonnft & squeebo_nft
982  
983    
984        ____
985            !
986      !     !
987      !      `-  _ _    _ 
988      |              ```  !
989 _____!                   !
990 \,      Made in Texas     \
991   l    _                  ;
992    \ _/  \.              /
993            \           .’ 
994             .       ./’
995              `.    ,
996                \   ;
997                  ``’
998  
999  */
1000 
1001 
1002 
1003 contract aayc is ERC721Enumerable, Ownable {
1004     string public baseURI;
1005 
1006     address public proxyRegistryAddress;
1007     address public treasuryAccount;
1008 
1009     uint256 public MAX_SUPPLY = 10000;
1010 
1011     uint256 public MAX_PER_TX = 10;
1012     uint256 public constant RESERVES = 0;
1013     uint256 public priceInWei = 0 ether;
1014     bool    public publicSaleActive = false;
1015 
1016     mapping(address => bool) public projectProxy;
1017     mapping(address => uint256) public addressToMinted;
1018 
1019     // baseURI: metadata endpoint for this collection
1020     // treasuryAccount: address the funds should be widthdrawn to
1021     constructor(string memory _baseURI, address _treasuryAccount)
1022         ERC721("ASCII Apepe", "AAYC")
1023     {
1024         baseURI = _baseURI;
1025         treasuryAccount = _treasuryAccount;
1026         // Opensea proxy registry address: this preapproves Opensea for transactions, saving users gas fees
1027         proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1028     }
1029 
1030     function setBaseURI(string memory _baseURI) public onlyOwner {
1031         baseURI = _baseURI;
1032     }
1033 
1034     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1035         MAX_SUPPLY = _maxSupply;
1036     }
1037 
1038     function setPriceInWei(uint256 _priceInWei) public onlyOwner {
1039         priceInWei = _priceInWei;
1040     }
1041 
1042     function setTxnMax(uint256 _txnMax) public onlyOwner {
1043         MAX_PER_TX = _txnMax;
1044     }
1045 
1046     function tokenURI(uint256 _tokenId)
1047         public
1048         view
1049         override
1050         returns (string memory)
1051     {
1052         require(_exists(_tokenId), "Token does not exist.");
1053         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1054     }
1055 
1056     function setProxyRegistryAddress(address _proxyRegistryAddress)
1057         external
1058         onlyOwner
1059     {
1060         proxyRegistryAddress = _proxyRegistryAddress;
1061     }
1062 
1063     function flipProxyState(address proxyAddress) public onlyOwner {
1064         projectProxy[proxyAddress] = !projectProxy[proxyAddress];
1065     }
1066 
1067     function togglePublicSaleActive() external onlyOwner {
1068         publicSaleActive = !publicSaleActive;
1069     }
1070 
1071     function collectReserves() external onlyOwner {
1072         require(_owners.length == 0, "Reserves already taken.");
1073         for (uint256 i; i < RESERVES; i++) _mint(_msgSender(), i);
1074     }
1075 
1076     function mint(uint256 count) public payable {
1077         uint256 totalSupply = _owners.length;
1078         require(publicSaleActive, "Public sale is not active.");
1079         require(totalSupply + count < MAX_SUPPLY + 1, "Excedes max supply.");
1080         require(count < MAX_PER_TX + 1, "Exceeds max per transaction.");
1081         require(count * priceInWei == msg.value, "Invalid funds provided.");
1082 
1083         for (uint256 i; i < count; i++) {
1084             _mint(_msgSender(), totalSupply + i);
1085         }
1086     }
1087 
1088     function burn(uint256 tokenId) public {
1089         require(
1090             _isApprovedOrOwner(_msgSender(), tokenId),
1091             "Not approved to burn."
1092         );
1093         _burn(tokenId);
1094     }
1095 
1096     function withdraw() public {
1097         (bool success, ) = treasuryAccount.call{value: address(this).balance}(
1098             ""
1099         );
1100         require(success, "Failed to send to treasury.");
1101     }
1102 
1103     function walletOfOwner(address _owner)
1104         public
1105         view
1106         returns (uint256[] memory)
1107     {
1108         uint256 tokenCount = balanceOf(_owner);
1109         if (tokenCount == 0) return new uint256[](0);
1110 
1111         uint256[] memory tokensId = new uint256[](tokenCount);
1112         for (uint256 i; i < tokenCount; i++) {
1113             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1114         }
1115         return tokensId;
1116     }
1117 
1118     function batchTransferFrom(
1119         address _from,
1120         address _to,
1121         uint256[] memory _tokenIds
1122     ) public {
1123         for (uint256 i = 0; i < _tokenIds.length; i++) {
1124             transferFrom(_from, _to, _tokenIds[i]);
1125         }
1126     }
1127 
1128     function batchSafeTransferFrom(
1129         address _from,
1130         address _to,
1131         uint256[] memory _tokenIds,
1132         bytes memory data_
1133     ) public {
1134         for (uint256 i = 0; i < _tokenIds.length; i++) {
1135             safeTransferFrom(_from, _to, _tokenIds[i], data_);
1136         }
1137     }
1138 
1139     function isOwnerOf(address account, uint256[] calldata _tokenIds)
1140         external
1141         view
1142         returns (bool)
1143     {
1144         for (uint256 i; i < _tokenIds.length; ++i) {
1145             if (_owners[_tokenIds[i]] != account) return false;
1146         }
1147 
1148         return true;
1149     }
1150 
1151     function isApprovedForAll(address _owner, address operator)
1152         public
1153         view
1154         override
1155         returns (bool)
1156     {
1157         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(
1158             proxyRegistryAddress
1159         );
1160         if (
1161             address(proxyRegistry.proxies(_owner)) == operator ||
1162             projectProxy[operator]
1163         ) return true;
1164         return super.isApprovedForAll(_owner, operator);
1165     }
1166 
1167     function _mint(address to, uint256 tokenId) internal virtual override {
1168         _owners.push(to);
1169         emit Transfer(address(0), to, tokenId);
1170     }
1171 }
1172 
1173 contract OwnableDelegateProxy {}
1174 
1175 contract OpenSeaProxyRegistry {
1176     mapping(address => OwnableDelegateProxy) public proxies;
1177 }