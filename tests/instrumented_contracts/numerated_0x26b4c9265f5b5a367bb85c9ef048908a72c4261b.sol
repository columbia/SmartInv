1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 pragma solidity ^0.8.6;
25 
26 library Address {
27     function isContract(address account) internal view returns (bool) {
28         uint size;
29         assembly {
30             size := extcodesize(account)
31         }
32         return size > 0;
33     }
34 }
35 
36 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 
41 /**
42  * @dev Implementation of the {IERC165} interface.
43  *
44  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
45  * for the additional interface id that will be supported. For example:
46  *
47  * ```solidity
48  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
49  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
50  * }
51  * ```
52  *
53  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
54  */
55 abstract contract ERC165 is IERC165 {
56     /**
57      * @dev See {IERC165-supportsInterface}.
58      */
59     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
60         return interfaceId == type(IERC165).interfaceId;
61     }
62 }
63 
64 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev String operations.
70  */
71 library Strings {
72     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
76      */
77     function toString(uint256 value) internal pure returns (string memory) {
78         // Inspired by OraclizeAPI's implementation - MIT licence
79         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
80 
81         if (value == 0) {
82             return "0";
83         }
84         uint256 temp = value;
85         uint256 digits;
86         while (temp != 0) {
87             digits++;
88             temp /= 10;
89         }
90         bytes memory buffer = new bytes(digits);
91         while (value != 0) {
92             digits -= 1;
93             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
94             value /= 10;
95         }
96         return string(buffer);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
101      */
102     function toHexString(uint256 value) internal pure returns (string memory) {
103         if (value == 0) {
104             return "0x00";
105         }
106         uint256 temp = value;
107         uint256 length = 0;
108         while (temp != 0) {
109             length++;
110             temp >>= 8;
111         }
112         return toHexString(value, length);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
117      */
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 }
130 
131 
132 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 
137 /**
138  * @dev Required interface of an ERC721 compliant contract.
139  */
140 interface IERC721 is IERC165 {
141     /**
142      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in ``owner``'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Returns the account approved for `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function getApproved(uint256 tokenId) external view returns (address operator);
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId,
270         bytes calldata data
271     ) external;
272 }
273 
274 
275 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
282  * @dev See https://eips.ethereum.org/EIPS/eip-721
283  */
284 interface IERC721Metadata is IERC721 {
285     /**
286      * @dev Returns the token collection name.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the token collection symbol.
292      */
293     function symbol() external view returns (string memory);
294 
295     /**
296      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
297      */
298     function tokenURI(uint256 tokenId) external view returns (string memory);
299 }
300 
301 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 
329 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
336  * @dev See https://eips.ethereum.org/EIPS/eip-721
337  */
338 interface IERC721Enumerable is IERC721 {
339     /**
340      * @dev Returns the total amount of tokens stored by the contract.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
346      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
347      */
348     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
349 
350     /**
351      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
352      * Use along with {totalSupply} to enumerate all tokens.
353      */
354     function tokenByIndex(uint256 index) external view returns (uint256);
355 }
356 
357 
358 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 
383 pragma solidity ^0.8.7;
384 
385 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
386     using Address for address;
387     using Strings for uint256;
388     
389     string private _name;
390     string private _symbol;
391 
392     // Mapping from token ID to owner address
393     address[] internal _owners;
394 
395     mapping(uint256 => address) private _tokenApprovals;
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398     /**
399      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
400      */
401     constructor(string memory name_, string memory symbol_) {
402         _name = name_;
403         _symbol = symbol_;
404     }
405 
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      */
409     function supportsInterface(bytes4 interfaceId)
410         public
411         view
412         virtual
413         override(ERC165, IERC165)
414         returns (bool)
415     {
416         return
417             interfaceId == type(IERC721).interfaceId ||
418             interfaceId == type(IERC721Metadata).interfaceId ||
419             super.supportsInterface(interfaceId);
420     }
421 
422     /**
423      * @dev See {IERC721-balanceOf}.
424      */
425     function balanceOf(address owner) 
426         public 
427         view 
428         virtual 
429         override 
430         returns (uint) 
431     {
432         require(owner != address(0), "ERC721: balance query for the zero address");
433 
434         uint count;
435         for( uint i; i < _owners.length; ++i ){
436           if( owner == _owners[i] )
437             ++count;
438         }
439         return count;
440     }
441 
442     /**
443      * @dev See {IERC721-ownerOf}.
444      */
445     function ownerOf(uint256 tokenId)
446         public
447         view
448         virtual
449         override
450         returns (address)
451     {
452         address owner = _owners[tokenId];
453         require(
454             owner != address(0),
455             "ERC721: owner query for nonexistent token"
456         );
457         return owner;
458     }
459 
460     /**
461      * @dev See {IERC721Metadata-name}.
462      */
463     function name() public view virtual override returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev See {IERC721Metadata-symbol}.
469      */
470     function symbol() public view virtual override returns (string memory) {
471         return _symbol;
472     }
473 
474     function _setNameSymbol(string memory name_, string memory symbol_) internal {
475         _name = name_;
476         _symbol = symbol_;
477     }
478 
479     /**
480      * @dev See {IERC721-approve}.
481      */
482     function approve(address to, uint256 tokenId) public virtual override {
483         address owner = ERC721.ownerOf(tokenId);
484         require(to != owner, "ERC721: approval to current owner");
485 
486         require(
487             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
488             "ERC721: approve caller is not owner nor approved for all"
489         );
490 
491         _approve(to, tokenId);
492     }
493 
494     /**
495      * @dev See {IERC721-getApproved}.
496      */
497     function getApproved(uint256 tokenId)
498         public
499         view
500         virtual
501         override
502         returns (address)
503     {
504         require(
505             _exists(tokenId),
506             "ERC721: approved query for nonexistent token"
507         );
508 
509         return _tokenApprovals[tokenId];
510     }
511 
512     /**
513      * @dev See {IERC721-setApprovalForAll}.
514      */
515     function setApprovalForAll(address operator, bool approved)
516         public
517         virtual
518         override
519     {
520         require(operator != _msgSender(), "ERC721: approve to caller");
521 
522         _operatorApprovals[_msgSender()][operator] = approved;
523         emit ApprovalForAll(_msgSender(), operator, approved);
524     }
525 
526     /**
527      * @dev See {IERC721-isApprovedForAll}.
528      */
529     function isApprovedForAll(address owner, address operator)
530         public
531         view
532         virtual
533         override
534         returns (bool)
535     {
536         return _operatorApprovals[owner][operator];
537     }
538 
539     /**
540      * @dev See {IERC721-transferFrom}.
541      */
542     function transferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) public virtual override {
547         //solhint-disable-next-line max-line-length
548         require(
549             _isApprovedOrOwner(_msgSender(), tokenId),
550             "ERC721: transfer caller is not owner nor approved"
551         );
552 
553         _transfer(from, to, tokenId);
554     }
555 
556     /**
557      * @dev See {IERC721-safeTransferFrom}.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) public virtual override {
564         safeTransferFrom(from, to, tokenId, "");
565     }
566 
567     /**
568      * @dev See {IERC721-safeTransferFrom}.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId,
574         bytes memory _data
575     ) public virtual override {
576         require(
577             _isApprovedOrOwner(_msgSender(), tokenId),
578             "ERC721: transfer caller is not owner nor approved"
579         );
580         _safeTransfer(from, to, tokenId, _data);
581     }
582 
583     /**
584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
586      *
587      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
588      *
589      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
590      * implement alternative mechanisms to perform token transfer, such as signature-based.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
598      *
599      * Emits a {Transfer} event.
600      */
601     function _safeTransfer(
602         address from,
603         address to,
604         uint256 tokenId,
605         bytes memory _data
606     ) internal virtual {
607         _transfer(from, to, tokenId);
608         require(
609             _checkOnERC721Received(from, to, tokenId, _data),
610             "ERC721: transfer to non ERC721Receiver implementer"
611         );
612     }
613 
614     /**
615      * @dev Returns whether `tokenId` exists.
616      *
617      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
618      *
619      * Tokens start existing when they are minted (`_mint`),
620      * and stop existing when they are burned (`_burn`).
621      */
622     function _exists(uint256 tokenId) internal view virtual returns (bool) {
623         return tokenId < _owners.length && _owners[tokenId] != address(0);
624     }
625 
626     /**
627      * @dev Returns whether `spender` is allowed to manage `tokenId`.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function _isApprovedOrOwner(address spender, uint256 tokenId)
634         internal
635         view
636         virtual
637         returns (bool)
638     {
639         require(
640             _exists(tokenId),
641             "ERC721: operator query for nonexistent token"
642         );
643         address owner = ERC721.ownerOf(tokenId);
644         return (spender == owner ||
645             getApproved(tokenId) == spender ||
646             isApprovedForAll(owner, spender));
647     }
648 
649     /**
650      * @dev Safely mints `tokenId` and transfers it to `to`.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must not exist.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function _safeMint(address to, uint256 tokenId) internal virtual {
660         _safeMint(to, tokenId, "");
661     }
662 
663     /**
664      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
665      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
666      */
667     function _safeMint(
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) internal virtual {
672         _mint(to, tokenId);
673         require(
674             _checkOnERC721Received(address(0), to, tokenId, _data),
675             "ERC721: transfer to non ERC721Receiver implementer"
676         );
677     }
678 
679     /**
680      * @dev Mints `tokenId` and transfers it to `to`.
681      *
682      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
683      *
684      * Requirements:
685      *
686      * - `tokenId` must not exist.
687      * - `to` cannot be the zero address.
688      *
689      * Emits a {Transfer} event.
690      */
691     function _mint(address to, uint256 tokenId) internal virtual {
692         require(to != address(0), "ERC721: mint to the zero address");
693         require(!_exists(tokenId), "ERC721: token already minted");
694 
695         _beforeTokenTransfer(address(0), to, tokenId);
696         _owners.push(to);
697 
698         emit Transfer(address(0), to, tokenId);
699     }
700 
701     /**
702      * @dev Destroys `tokenId`.
703      * The approval is cleared when the token is burned.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      *
709      * Emits a {Transfer} event.
710      */
711     function _burn(uint256 tokenId) internal virtual {
712         address owner = ERC721.ownerOf(tokenId);
713 
714         _beforeTokenTransfer(owner, address(0), tokenId);
715 
716         // Clear approvals
717         _approve(address(0), tokenId);
718         _owners[tokenId] = address(0);
719 
720         emit Transfer(owner, address(0), tokenId);
721     }
722 
723     /**
724      * @dev Transfers `tokenId` from `from` to `to`.
725      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
726      *
727      * Requirements:
728      *
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _transfer(
735         address from,
736         address to,
737         uint256 tokenId
738     ) internal virtual {
739         require(
740             ERC721.ownerOf(tokenId) == from,
741             "ERC721: transfer of token that is not own"
742         );
743         require(to != address(0), "ERC721: transfer to the zero address");
744 
745         _beforeTokenTransfer(from, to, tokenId);
746 
747         // Clear approvals from the previous owner
748         _approve(address(0), tokenId);
749         _owners[tokenId] = to;
750 
751         emit Transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev Approve `to` to operate on `tokenId`
756      *
757      * Emits a {Approval} event.
758      */
759     function _approve(address to, uint256 tokenId) internal virtual {
760         _tokenApprovals[tokenId] = to;
761         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
762     }
763 
764     /**
765      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
766      * The call is not executed if the target address is not a contract.
767      *
768      * @param from address representing the previous owner of the given token ID
769      * @param to target address that will receive the tokens
770      * @param tokenId uint256 ID of the token to be transferred
771      * @param _data bytes optional data to send along with the call
772      * @return bool whether the call correctly returned the expected magic value
773      */
774     function _checkOnERC721Received(
775         address from,
776         address to,
777         uint256 tokenId,
778         bytes memory _data
779     ) private returns (bool) {
780         if (to.isContract()) {
781             try
782                 IERC721Receiver(to).onERC721Received(
783                     _msgSender(),
784                     from,
785                     tokenId,
786                     _data
787                 )
788             returns (bytes4 retval) {
789                 return retval == IERC721Receiver.onERC721Received.selector;
790             } catch (bytes memory reason) {
791                 if (reason.length == 0) {
792                     revert(
793                         "ERC721: transfer to non ERC721Receiver implementer"
794                     );
795                 } else {
796                     assembly {
797                         revert(add(32, reason), mload(reason))
798                     }
799                 }
800             }
801         } else {
802             return true;
803         }
804     }
805 
806     /**
807      * @dev Hook that is called before any token transfer. This includes minting
808      * and burning.
809      *
810      * Calling conditions:
811      *
812      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
813      * transferred to `to`.
814      * - When `from` is zero, `tokenId` will be minted for `to`.
815      * - When `to` is zero, ``from``'s `tokenId` will be burned.
816      * - `from` and `to` are never both zero.
817      *
818      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
819      */
820     function _beforeTokenTransfer(
821         address from,
822         address to,
823         uint256 tokenId
824     ) internal virtual {}
825 }
826 
827 
828 pragma solidity ^0.8.7;
829 
830 /**
831  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
832  * enumerability of all the token ids in the contract as well as all token ids owned by each
833  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
834  */
835 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
840         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-totalSupply}.
845      */
846     function totalSupply() public view virtual override returns (uint256) {
847         return _owners.length;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenByIndex}.
852      */
853     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
854         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
855         return index;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
860      */
861     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
862         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
863 
864         uint count;
865         for(uint i; i < _owners.length; i++){
866             if(owner == _owners[i]){
867                 if(count == index) return i;
868                 else count++;
869             }
870         }
871 
872         revert("ERC721Enumerable: owner index out of bounds");
873     }
874 }
875 
876 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 
881 /**
882  * @dev Contract module which provides a basic access control mechanism, where
883  * there is an account (an owner) that can be granted exclusive access to
884  * specific functions.
885  *
886  * By default, the owner account will be the one that deploys the contract. This
887  * can later be changed with {transferOwnership}.
888  *
889  * This module is used through inheritance. It will make available the modifier
890  * `onlyOwner`, which can be applied to your functions to restrict their use to
891  * the owner.
892  */
893 abstract contract Ownable is Context {
894     address private _owner;
895 
896     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
897 
898     /**
899      * @dev Initializes the contract setting the deployer as the initial owner.
900      */
901     constructor() {
902         _transferOwnership(_msgSender());
903     }
904 
905     /**
906      * @dev Returns the address of the current owner.
907      */
908     function owner() public view virtual returns (address) {
909         return _owner;
910     }
911 
912     /**
913      * @dev Throws if called by any account other than the owner.
914      */
915     modifier onlyOwner() {
916         require(owner() == _msgSender(), "Ownable: caller is not the owner");
917         _;
918     }
919 
920     /**
921      * @dev Leaves the contract without owner. It will not be possible to call
922      * `onlyOwner` functions anymore. Can only be called by the current owner.
923      *
924      * NOTE: Renouncing ownership will leave the contract without an owner,
925      * thereby removing any functionality that is only available to the owner.
926      */
927     function renounceOwnership() public virtual onlyOwner {
928         _transferOwnership(address(0));
929     }
930 
931     /**
932      * @dev Transfers ownership of the contract to a new account (`newOwner`).
933      * Can only be called by the current owner.
934      */
935     function transferOwnership(address newOwner) public virtual onlyOwner {
936         require(newOwner != address(0), "Ownable: new owner is the zero address");
937         _transferOwnership(newOwner);
938     }
939 
940     /**
941      * @dev Transfers ownership of the contract to a new account (`newOwner`).
942      * Internal function without access restriction.
943      */
944     function _transferOwnership(address newOwner) internal virtual {
945         address oldOwner = _owner;
946         _owner = newOwner;
947         emit OwnershipTransferred(oldOwner, newOwner);
948     }
949 }
950 
951 pragma solidity 0.8.7;
952 
953 contract Computation {
954     function _computeNamehash(string memory _name) public pure returns (bytes32 namehash) {
955         namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
956         namehash = keccak256(
957         abi.encodePacked(namehash, keccak256(abi.encodePacked('eth')))
958         );
959         namehash = keccak256(
960         abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
961         );
962     }
963 
964     function _checkASCII(string memory str) public pure returns (bool){
965         bytes memory b = bytes(str);
966         if(b.length > 15) return false;
967         if(b.length < 3) return false;
968 
969         for(uint i; i<b.length; i++){
970             bytes1 char = b[i];
971             if(
972                 !(char >= 0x30 && char <= 0x39) && //9-0
973                 !(char >= 0x61 && char <= 0x7A) //a-z
974             )
975                 return false;
976         }
977         return true;
978     }
979 
980     function _checkIfSameStrings(string memory a, string memory b) internal pure returns (bool) {
981         if (keccak256(bytes(a)) == keccak256(bytes(b))) {
982             return true;
983         } else {
984             return false;
985         }
986     }
987 }
988 
989 pragma solidity 0.8.7;
990 
991 abstract contract URI is ERC721Enumerable, Ownable {
992 
993     string public baseURI;
994 
995     function setBaseURI(string memory _baseURI) public onlyOwner {
996         baseURI = _baseURI;
997     }
998 
999     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1000         require(_exists(_tokenId), "Token does not exist.");
1001         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1002     }
1003 }
1004 
1005 
1006 // SPDX-License-Identifier: MIT
1007 
1008 pragma solidity 0.8.7;
1009 
1010 contract test is ERC721Enumerable,  Ownable, Computation, URI {
1011 
1012     uint256 nextTokenID;
1013     uint256[] public registrationCost;
1014     bool public registrationIsActive = true;
1015 
1016     //Collections mapping
1017     mapping(address => mapping(uint16 => string)) public _addressToCollections;
1018     //Names mapping
1019     mapping(bytes32 => uint256) private _nameHashToToken;
1020     mapping(uint256 => string) private _tokenToName;
1021     //Primary names mapping
1022     mapping(address => uint256) private _addressToTokenPrimary;
1023 
1024     constructor(string memory name_, string memory symbol_, string memory _baseURI, uint256 _nextTokenID, uint256[] memory _cost, string memory _firstCollection) ERC721(name_, symbol_) {
1025         baseURI = _baseURI;
1026         nextTokenID = _nextTokenID;
1027         registrationCost = _cost;
1028         _addressToCollections[address(this)][0] = _firstCollection;
1029     }
1030 
1031     function registerName(string memory _name, address collection, uint16 collectionIndex) public payable {
1032         require(registrationIsActive, "Registration must be active.");
1033         uint256 _cost = _calculateRegistrationCost(_name);
1034         require(_cost <= msg.value, "Ether value sent is not correct");
1035         require(_checkASCII(_name), "Name contains forbidden characters.");
1036         require(msg.sender == owner() || _checkEligibility(collection, collectionIndex), "Not eligible for this collection.");
1037         bytes32 hash = _computeNamehash(_name);
1038         require(_exists(hash) == false, "Name already exists.");
1039         string memory _extension = _addressToCollections[collection][collectionIndex];
1040         string memory _finalName = string(abi.encodePacked(_name, _extension));
1041         
1042         _safeMint(msg.sender, nextTokenID);
1043         _nameHashToToken[hash] = nextTokenID + 1;
1044         _tokenToName[nextTokenID] = _finalName;
1045 
1046         nextTokenID += 1;
1047     }
1048 
1049     function nameByTokenID(uint256 _tokenID) public view returns (string memory) {
1050         return _tokenToName[_tokenID];
1051     }
1052 
1053     function namesOfOwnerByIndex(address _owner, uint256 _index) public view returns (string memory) {
1054         uint256 _tokenID = tokenOfOwnerByIndex(_owner, _index);
1055         return _tokenToName[_tokenID];
1056     }
1057 
1058     function ownerOfName(string memory _name, string memory _extension) public view returns (address) {
1059         bytes32 hash = _computeNamehash(_name);
1060         uint256 tokenID = _nameHashToToken[hash] - 1;
1061         require(_exists(tokenID), "Name is not registered yet.");
1062         require(_checkIfSameStrings(string(abi.encodePacked(_name, _extension)), _tokenToName[tokenID]), "Name is not owned by anyone.");
1063         return ownerOf(tokenID);
1064     }
1065 
1066     function migrateExtension(string memory _name, address _oldCollection, uint16 _oldCollectionIndex, address _newCollection, uint16 _newCollectionIndex) public {
1067         require(_checkEligibility(_newCollection, _newCollectionIndex), "Not eligible for this collection.");
1068         require(ownerOfName(_name, _addressToCollections[_oldCollection][_oldCollectionIndex]) == msg.sender, "Not owned by caller");
1069         string memory _newExtension = _addressToCollections[_newCollection][_newCollectionIndex];
1070         string memory _newFinalName = string(abi.encodePacked(_name, _newExtension));
1071         bytes32 hash = _computeNamehash(_name);
1072         uint256 tokenID = _nameHashToToken[hash] - 1;
1073         _tokenToName[tokenID] = _newFinalName;
1074     }
1075 
1076     function setPrimaryName(uint256 _tokenID) public {
1077         require(ownerOf(_tokenID) == msg.sender, "Not owned by caller.");
1078         _addressToTokenPrimary[msg.sender] = _tokenID + 1;
1079     }
1080 
1081     function getPrimaryName(address _address) public view returns (string memory) {
1082         uint256 _tokenID = _addressToTokenPrimary[_address];
1083         require(_tokenID != 0, "Primary Name not set for the address.");
1084         return _tokenToName[_tokenID - 1];
1085     }
1086 
1087     function removePrimaryName(address _address) public {
1088         require(_address == msg.sender, "Address is not caller.");
1089         _addressToTokenPrimary[msg.sender] = 0;
1090     }
1091 
1092     function _removePrimaryName(address _address, uint256 _tokenID) internal {
1093         require(_isApprovedOrOwner(_msgSender(), _tokenID), "Caller is not owner nor approved.");
1094         require(ownerOf(_tokenID) == _address, "Address does not match.");
1095         if (_addressToTokenPrimary[_address] != 0 && _addressToTokenPrimary[_address] - 1 == _tokenID) {
1096             _addressToTokenPrimary[_address] = 0;
1097         }
1098     }
1099 
1100     function _checkEligibility(address collection, uint16 collectionIndex) public view returns (bool) {
1101         require(_collectionExists(collection, collectionIndex), "This collection is not eligible.");
1102         if(collection == address(this)) {
1103             return true;
1104         } else {
1105             ERC721 nftcontract = ERC721(collection);
1106             if (nftcontract.balanceOf(msg.sender) > 0) {
1107                 return true;
1108             } else {
1109                 return false;
1110             }
1111         }
1112     }
1113 
1114     function _collectionExists(address collection, uint16 collectionIndex) internal view returns(bool) {
1115         string memory _extension = _addressToCollections[collection][collectionIndex];
1116         bytes memory _bytesExtension = bytes(_extension); // Uses memory
1117         if (_bytesExtension.length == 0) {
1118             return false;
1119         } else {
1120             return true;
1121         }
1122     }
1123 
1124     function addCollections(address[] memory addresses, string[][] memory domains) public onlyOwner {
1125         require(addresses.length == domains.length);
1126 
1127         for(uint8 i=0; i<domains.length;i++) {
1128             for(uint8 j=0; j<domains[i].length; j++) {
1129                  _addressToCollections[addresses[i]][j] = domains[i][j];
1130             }
1131         }
1132     }
1133 
1134     function removeCollection(address _collectionAddress, uint16 _collectionIndex) public onlyOwner {
1135         _addressToCollections[_collectionAddress][_collectionIndex] = "";
1136     }
1137 
1138     function _exists(bytes32 _hash) public view virtual returns (bool) {
1139         if(_nameHashToToken[_hash] != 0) {
1140             return true;
1141         } else {
1142             return false;
1143         }
1144     }
1145 
1146     function _calculateRegistrationCost(string memory _name) internal view returns (uint256) {
1147         bytes memory b = bytes(_name);
1148         if(b.length == 3) return registrationCost[0];
1149         else if(b.length == 4) return registrationCost[1];
1150         else if(b.length == 5) return registrationCost[2];
1151         else return registrationCost[3];
1152     }
1153 
1154     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1155         if(_exists(tokenId)) {
1156             _removePrimaryName(from, tokenId);
1157         }
1158     }
1159 
1160     function withdraw() public onlyOwner {
1161         uint256 balance = address(this).balance;
1162         payable(msg.sender).transfer(balance);
1163     }
1164     
1165     function setRegistrationCost(uint256[] memory _cost) public onlyOwner {
1166         registrationCost = _cost;
1167     }
1168 
1169     function flipRegistrationState() public onlyOwner {
1170         registrationIsActive = !registrationIsActive;
1171     }
1172 
1173     function setNameSymbol(string memory name_, string memory symbol_) public onlyOwner {
1174         _setNameSymbol(name_, symbol_);
1175     }
1176     
1177 }