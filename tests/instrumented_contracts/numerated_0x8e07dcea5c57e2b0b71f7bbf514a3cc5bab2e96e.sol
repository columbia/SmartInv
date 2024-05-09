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
63     event Transfer(
64         address indexed from,
65         address indexed to,
66         uint256 indexed tokenId
67     );
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(
73         address indexed owner,
74         address indexed approved,
75         uint256 indexed tokenId
76     );
77 
78     /**
79      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
80      */
81     event ApprovalForAll(
82         address indexed owner,
83         address indexed operator,
84         bool approved
85     );
86 
87     /**
88      * @dev Returns the number of tokens in ``owner``s account.
89      */
90     function balanceOf(address owner) external view returns (uint256 balance);
91 
92     /**
93      * @dev Returns the owner of the `tokenId` token.
94      *
95      * Requirements:
96      *
97      * - `tokenId` must exist.
98      */
99     function ownerOf(uint256 tokenId) external view returns (address owner);
100 
101     /**
102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Transfers `tokenId` token from `from` to `to`.
123      *
124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
125      *
126      * Requirements:
127      *
128      * - `from` cannot be the zero address.
129      * - `to` cannot be the zero address.
130      * - `tokenId` token must be owned by `from`.
131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
143      * The approval is cleared when the token is transferred.
144      *
145      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
146      *
147      * Requirements:
148      *
149      * - The caller must own the token or be an approved operator.
150      * - `tokenId` must exist.
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address to, uint256 tokenId) external;
155 
156     /**
157      * @dev Returns the account approved for `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function getApproved(uint256 tokenId)
164         external
165         view
166         returns (address operator);
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
185     function isApprovedForAll(address owner, address operator)
186         external
187         view
188         returns (bool);
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must exist and be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200      *
201      * Emits a {Transfer} event.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId,
207         bytes calldata data
208     ) external;
209 }
210 
211 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
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
236 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
242  * @dev See https://eips.ethereum.org/EIPS/eip-721
243  */
244 interface IERC721Enumerable is IERC721 {
245     /**
246      * @dev Returns the total amount of tokens stored by the contract.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
252      * Use along with {balanceOf} to enumerate all of ``owner``s tokens.
253      */
254     function tokenOfOwnerByIndex(address owner, uint256 index)
255         external
256         view
257         returns (uint256 tokenId);
258 
259     /**
260      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
261      * Use along with {totalSupply} to enumerate all tokens.
262      */
263     function tokenByIndex(uint256 index) external view returns (uint256);
264 }
265 
266 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @title ERC721 token receiver interface
272  * @dev Interface for any contract that wants to support safeTransfers
273  * from ERC721 asset contracts.
274  */
275 interface IERC721Receiver {
276     /**
277      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
278      * by `operator` from `from`, this function is called.
279      *
280      * It must return its Solidity selector to confirm the token transfer.
281      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
282      *
283      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
284      */
285     function onERC721Received(
286         address operator,
287         address from,
288         uint256 tokenId,
289         bytes calldata data
290     ) external returns (bytes4);
291 }
292 
293 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Implementation of the {IERC165} interface.
299  *
300  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
301  * for the additional interface id that will be supported. For example:
302  *
303  * ```solidity
304  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
305  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
306  * }
307  * ```
308  *
309  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
310  */
311 abstract contract ERC165 is IERC165 {
312     /**
313      * @dev See {IERC165-supportsInterface}.
314      */
315     function supportsInterface(bytes4 interfaceId)
316         public
317         view
318         virtual
319         override
320         returns (bool)
321     {
322         return interfaceId == type(IERC165).interfaceId;
323     }
324 }
325 
326 pragma solidity ^0.8.6;
327 
328 library Address {
329     function isContract(address account) internal view returns (bool) {
330         uint size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 }
337 
338 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev String operations.
344  */
345 library Strings {
346     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
350      */
351     function toString(uint256 value) internal pure returns (string memory) {
352         // Inspired by OraclizeAPIs implementation - MIT licence
353         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
354 
355         if (value == 0) {
356             return "0";
357         }
358         uint256 temp = value;
359         uint256 digits;
360         while (temp != 0) {
361             digits++;
362             temp /= 10;
363         }
364         bytes memory buffer = new bytes(digits);
365         while (value != 0) {
366             digits -= 1;
367             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
368             value /= 10;
369         }
370         return string(buffer);
371     }
372 
373     /**
374      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
375      */
376     function toHexString(uint256 value) internal pure returns (string memory) {
377         if (value == 0) {
378             return "0x00";
379         }
380         uint256 temp = value;
381         uint256 length = 0;
382         while (temp != 0) {
383             length++;
384             temp >>= 8;
385         }
386         return toHexString(value, length);
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
391      */
392     function toHexString(uint256 value, uint256 length)
393         internal
394         pure
395         returns (string memory)
396     {
397         bytes memory buffer = new bytes(2 * length + 2);
398         buffer[0] = "0";
399         buffer[1] = "x";
400         for (uint256 i = 2 * length + 1; i > 1; --i) {
401             buffer[i] = _HEX_SYMBOLS[value & 0xf];
402             value >>= 4;
403         }
404         require(value == 0, "Strings: hex length insufficient");
405         return string(buffer);
406     }
407 }
408 
409 pragma solidity ^0.8.7;
410 
411 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
412     using Address for address;
413     using Strings for uint256;
414 
415     string private _name;
416     string private _symbol;
417 
418     // Mapping from token ID to owner address
419     address[] internal _owners;
420 
421     mapping(uint256 => address) private _tokenApprovals;
422     mapping(address => mapping(address => bool)) private _operatorApprovals;
423 
424     /**
425      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
426      */
427     constructor(string memory name_, string memory symbol_) {
428         _name = name_;
429         _symbol = symbol_;
430     }
431 
432     /**
433      * @dev See {IERC165-supportsInterface}.
434      */
435     function supportsInterface(bytes4 interfaceId)
436         public
437         view
438         virtual
439         override(ERC165, IERC165)
440         returns (bool)
441     {
442         return
443             interfaceId == type(IERC721).interfaceId ||
444             interfaceId == type(IERC721Metadata).interfaceId ||
445             super.supportsInterface(interfaceId);
446     }
447 
448     /**
449      * @dev See {IERC721-balanceOf}.
450      */
451     function balanceOf(address owner)
452         public
453         view
454         virtual
455         override
456         returns (uint)
457     {
458         require(
459             owner != address(0),
460             "ERC721: balance query for the zero address"
461         );
462 
463         uint count;
464         for (uint i; i < _owners.length; ++i) {
465             if (owner == _owners[i]) ++count;
466         }
467         return count;
468     }
469 
470     /**
471      * @dev See {IERC721-ownerOf}.
472      */
473     function ownerOf(uint256 tokenId)
474         public
475         view
476         virtual
477         override
478         returns (address)
479     {
480         address owner = _owners[tokenId];
481         require(
482             owner != address(0),
483             "ERC721: owner query for nonexistent token"
484         );
485         return owner;
486     }
487 
488     /**
489      * @dev See {IERC721Metadata-name}.
490      */
491     function name() public view virtual override returns (string memory) {
492         return _name;
493     }
494 
495     /**
496      * @dev See {IERC721Metadata-symbol}.
497      */
498     function symbol() public view virtual override returns (string memory) {
499         return _symbol;
500     }
501 
502     /**
503      * @dev See {IERC721-approve}.
504      */
505     function approve(address to, uint256 tokenId) public virtual override {
506         address owner = ERC721.ownerOf(tokenId);
507         require(to != owner, "ERC721: approval to current owner");
508 
509         require(
510             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
511             "ERC721: approve caller is not owner nor approved for all"
512         );
513 
514         _approve(to, tokenId);
515     }
516 
517     /**
518      * @dev See {IERC721-getApproved}.
519      */
520     function getApproved(uint256 tokenId)
521         public
522         view
523         virtual
524         override
525         returns (address)
526     {
527         require(
528             _exists(tokenId),
529             "ERC721: approved query for nonexistent token"
530         );
531 
532         return _tokenApprovals[tokenId];
533     }
534 
535     /**
536      * @dev See {IERC721-setApprovalForAll}.
537      */
538     function setApprovalForAll(address operator, bool approved)
539         public
540         virtual
541         override
542     {
543         require(operator != _msgSender(), "ERC721: approve to caller");
544 
545         _operatorApprovals[_msgSender()][operator] = approved;
546         emit ApprovalForAll(_msgSender(), operator, approved);
547     }
548 
549     /**
550      * @dev See {IERC721-isApprovedForAll}.
551      */
552     function isApprovedForAll(address owner, address operator)
553         public
554         view
555         virtual
556         override
557         returns (bool)
558     {
559         return _operatorApprovals[owner][operator];
560     }
561 
562     /**
563      * @dev See {IERC721-transferFrom}.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) public virtual override {
570         //solhint-disable-next-line max-line-length
571         require(
572             _isApprovedOrOwner(_msgSender(), tokenId),
573             "ERC721: transfer caller is not owner nor approved"
574         );
575 
576         _transfer(from, to, tokenId);
577     }
578 
579     /**
580      * @dev See {IERC721-safeTransferFrom}.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) public virtual override {
587         safeTransferFrom(from, to, tokenId, "");
588     }
589 
590     /**
591      * @dev See {IERC721-safeTransferFrom}.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId,
597         bytes memory _data
598     ) public virtual override {
599         require(
600             _isApprovedOrOwner(_msgSender(), tokenId),
601             "ERC721: transfer caller is not owner nor approved"
602         );
603         _safeTransfer(from, to, tokenId, _data);
604     }
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
609      *
610      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
611      *
612      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
613      * implement alternative mechanisms to perform token transfer, such as signature-based.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function _safeTransfer(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes memory _data
629     ) internal virtual {
630         _transfer(from, to, tokenId);
631         require(
632             _checkOnERC721Received(from, to, tokenId, _data),
633             "ERC721: transfer to non ERC721Receiver implementer"
634         );
635     }
636 
637     /**
638      * @dev Returns whether `tokenId` exists.
639      *
640      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
641      *
642      * Tokens start existing when they are minted (`_mint`),
643      * and stop existing when they are burned (`_burn`).
644      */
645     function _exists(uint256 tokenId) internal view virtual returns (bool) {
646         return tokenId < _owners.length && _owners[tokenId] != address(0);
647     }
648 
649     /**
650      * @dev Returns whether `spender` is allowed to manage `tokenId`.
651      *
652      * Requirements:
653      *
654      * - `tokenId` must exist.
655      */
656     function _isApprovedOrOwner(address spender, uint256 tokenId)
657         internal
658         view
659         virtual
660         returns (bool)
661     {
662         require(
663             _exists(tokenId),
664             "ERC721: operator query for nonexistent token"
665         );
666         address owner = ERC721.ownerOf(tokenId);
667         return (spender == owner ||
668             getApproved(tokenId) == spender ||
669             isApprovedForAll(owner, spender));
670     }
671 
672     /**
673      * @dev Safely mints `tokenId` and transfers it to `to`.
674      *
675      * Requirements:
676      *
677      * - `tokenId` must not exist.
678      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
679      *
680      * Emits a {Transfer} event.
681      */
682     function _safeMint(address to, uint256 tokenId) internal virtual {
683         _safeMint(to, tokenId, "");
684     }
685 
686     /**
687      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
688      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
689      */
690     function _safeMint(
691         address to,
692         uint256 tokenId,
693         bytes memory _data
694     ) internal virtual {
695         _mint(to, tokenId);
696         require(
697             _checkOnERC721Received(address(0), to, tokenId, _data),
698             "ERC721: transfer to non ERC721Receiver implementer"
699         );
700     }
701 
702     /**
703      * @dev Mints `tokenId` and transfers it to `to`.
704      *
705      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
706      *
707      * Requirements:
708      *
709      * - `tokenId` must not exist.
710      * - `to` cannot be the zero address.
711      *
712      * Emits a {Transfer} event.
713      */
714     function _mint(address to, uint256 tokenId) internal virtual {
715         require(to != address(0), "ERC721: mint to the zero address");
716         require(!_exists(tokenId), "ERC721: token already minted");
717 
718         _beforeTokenTransfer(address(0), to, tokenId);
719         _owners.push(to);
720 
721         emit Transfer(address(0), to, tokenId);
722     }
723 
724     /**
725      * @dev Destroys `tokenId`.
726      * The approval is cleared when the token is burned.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _burn(uint256 tokenId) internal virtual {
735         address owner = ERC721.ownerOf(tokenId);
736 
737         _beforeTokenTransfer(owner, address(0), tokenId);
738 
739         // Clear approvals
740         _approve(address(0), tokenId);
741         _owners[tokenId] = address(0);
742 
743         emit Transfer(owner, address(0), tokenId);
744     }
745 
746     /**
747      * @dev Transfers `tokenId` from `from` to `to`.
748      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
749      *
750      * Requirements:
751      *
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must be owned by `from`.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _transfer(
758         address from,
759         address to,
760         uint256 tokenId
761     ) internal virtual {
762         require(
763             ERC721.ownerOf(tokenId) == from,
764             "ERC721: transfer of token that is not own"
765         );
766         require(to != address(0), "ERC721: transfer to the zero address");
767 
768         _beforeTokenTransfer(from, to, tokenId);
769 
770         // Clear approvals from the previous owner
771         _approve(address(0), tokenId);
772         _owners[tokenId] = to;
773 
774         emit Transfer(from, to, tokenId);
775     }
776 
777     /**
778      * @dev Approve `to` to operate on `tokenId`
779      *
780      * Emits a {Approval} event.
781      */
782     function _approve(address to, uint256 tokenId) internal virtual {
783         _tokenApprovals[tokenId] = to;
784         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
785     }
786 
787     /**
788      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
789      * The call is not executed if the target address is not a contract.
790      *
791      * @param from address representing the previous owner of the given token ID
792      * @param to target address that will receive the tokens
793      * @param tokenId uint256 ID of the token to be transferred
794      * @param _data bytes optional data to send along with the call
795      * @return bool whether the call correctly returned the expected magic value
796      */
797     function _checkOnERC721Received(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes memory _data
802     ) private returns (bool) {
803         if (to.isContract()) {
804             try
805                 IERC721Receiver(to).onERC721Received(
806                     _msgSender(),
807                     from,
808                     tokenId,
809                     _data
810                 )
811             returns (bytes4 retval) {
812                 return retval == IERC721Receiver.onERC721Received.selector;
813             } catch (bytes memory reason) {
814                 if (reason.length == 0) {
815                     revert(
816                         "ERC721: transfer to non ERC721Receiver implementer"
817                     );
818                 } else {
819                     assembly {
820                         revert(add(32, reason), mload(reason))
821                     }
822                 }
823             }
824         } else {
825             return true;
826         }
827     }
828 
829     /**
830      * @dev Hook that is called before any token transfer. This includes minting
831      * and burning.
832      *
833      * Calling conditions:
834      *
835      * - When `from` and `to` are both non-zero, ``from``s `tokenId` will be
836      * transferred to `to`.
837      * - When `from` is zero, `tokenId` will be minted for `to`.
838      * - When `to` is zero, ``from``s `tokenId` will be burned.
839      * - `from` and `to` are never both zero.
840      *
841      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
842      */
843     function _beforeTokenTransfer(
844         address from,
845         address to,
846         uint256 tokenId
847     ) internal virtual {}
848 }
849 
850 pragma solidity ^0.8.7;
851 
852 /**
853  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
854  * enumerability of all the token ids in the contract as well as all token ids owned by each
855  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
856  */
857 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId)
862         public
863         view
864         virtual
865         override(IERC165, ERC721)
866         returns (bool)
867     {
868         return
869             interfaceId == type(IERC721Enumerable).interfaceId ||
870             super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721Enumerable-totalSupply}.
875      */
876     function totalSupply() public view virtual override returns (uint256) {
877         return _owners.length;
878     }
879 
880     /**
881      * @dev See {IERC721Enumerable-tokenByIndex}.
882      */
883     function tokenByIndex(uint256 index)
884         public
885         view
886         virtual
887         override
888         returns (uint256)
889     {
890         require(
891             index < _owners.length,
892             "ERC721Enumerable: global index out of bounds"
893         );
894         return index;
895     }
896 
897     /**
898      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
899      */
900     function tokenOfOwnerByIndex(address owner, uint256 index)
901         public
902         view
903         virtual
904         override
905         returns (uint256 tokenId)
906     {
907         require(
908             index < balanceOf(owner),
909             "ERC721Enumerable: owner index out of bounds"
910         );
911 
912         uint count;
913         for (uint i; i < _owners.length; i++) {
914             if (owner == _owners[i]) {
915                 if (count == index) return i;
916                 else count++;
917             }
918         }
919 
920         revert("ERC721Enumerable: owner index out of bounds");
921     }
922 }
923 
924 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 /**
929  * @dev Contract module which provides a basic access control mechanism, where
930  * there is an account (an owner) that can be granted exclusive access to
931  * specific functions.
932  *
933  * By default, the owner account will be the one that deploys the contract. This
934  * can later be changed with {transferOwnership}.
935  *
936  * This module is used through inheritance. It will make available the modifier
937  * `onlyOwner`, which can be applied to your functions to restrict their use to
938  * the owner.
939  */
940 abstract contract Ownable is Context {
941     address private _owner;
942 
943     event OwnershipTransferred(
944         address indexed previousOwner,
945         address indexed newOwner
946     );
947 
948     /**
949      * @dev Initializes the contract setting the deployer as the initial owner.
950      */
951     constructor() {
952         _transferOwnership(_msgSender());
953     }
954 
955     /**
956      * @dev Returns the address of the current owner.
957      */
958     function owner() public view virtual returns (address) {
959         return _owner;
960     }
961 
962     /**
963      * @dev Throws if called by any account other than the owner.
964      */
965     modifier onlyOwner() {
966         require(owner() == _msgSender(), "Ownable: caller is not the owner");
967         _;
968     }
969 
970     /**
971      * @dev Leaves the contract without owner. It will not be possible to call
972      * `onlyOwner` functions anymore. Can only be called by the current owner.
973      *
974      * NOTE: Renouncing ownership will leave the contract without an owner,
975      * thereby removing any functionality that is only available to the owner.
976      */
977     function renounceOwnership() public virtual onlyOwner {
978         _transferOwnership(address(0));
979     }
980 
981     /**
982      * @dev Transfers ownership of the contract to a new account (`newOwner`).
983      * Can only be called by the current owner.
984      */
985     function transferOwnership(address newOwner) public virtual onlyOwner {
986         require(
987             newOwner != address(0),
988             "Ownable: new owner is the zero address"
989         );
990         _transferOwnership(newOwner);
991     }
992 
993     /**
994      * @dev Transfers ownership of the contract to a new account (`newOwner`).
995      * Internal function without access restriction.
996      */
997     function _transferOwnership(address newOwner) internal virtual {
998         address oldOwner = _owner;
999         _owner = newOwner;
1000         emit OwnershipTransferred(oldOwner, newOwner);
1001     }
1002 }
1003 
1004 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 /**
1009  * @dev These functions deal with verification of Merkle Trees proofs.
1010  *
1011  * The proofs can be generated using the JavaScript library
1012  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1013  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1014  *
1015  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1016  */
1017 library MerkleProof {
1018     /**
1019      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1020      * defined by `root`. For this, a `proof` must be provided, containing
1021      * sibling hashes on the branch from the leaf to the root of the tree. Each
1022      * pair of leaves and each pair of pre-images are assumed to be sorted.
1023      */
1024     function verify(
1025         bytes32[] memory proof,
1026         bytes32 root,
1027         bytes32 leaf
1028     ) internal pure returns (bool) {
1029         return processProof(proof, leaf) == root;
1030     }
1031 
1032     /**
1033      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1034      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1035      * hash matches the root of the tree. When processing the proof, the pairs
1036      * of leafs & pre-images are assumed to be sorted.
1037      *
1038      * _Available since v4.4._
1039      */
1040     function processProof(bytes32[] memory proof, bytes32 leaf)
1041         internal
1042         pure
1043         returns (bytes32)
1044     {
1045         bytes32 computedHash = leaf;
1046         for (uint256 i = 0; i < proof.length; i++) {
1047             bytes32 proofElement = proof[i];
1048             if (computedHash <= proofElement) {
1049                 // Hash(current computed hash + current element of the proof)
1050                 computedHash = keccak256(
1051                     abi.encodePacked(computedHash, proofElement)
1052                 );
1053             } else {
1054                 // Hash(current element of the proof + current computed hash)
1055                 computedHash = keccak256(
1056                     abi.encodePacked(proofElement, computedHash)
1057                 );
1058             }
1059         }
1060         return computedHash;
1061     }
1062 }
1063 
1064 pragma solidity ^0.8.11;
1065 pragma abicoder v2;
1066 
1067 contract LuminalUniverse is ERC721Enumerable, Ownable {
1068     using MerkleProof for bytes32[];
1069     string public baseURI;
1070 
1071     mapping(address => bool) public whitelistAllowance;
1072     mapping(address => uint256)public  genesisFreeClaimed;
1073     mapping(address => uint256) public genesisAllowance;
1074     mapping(address => uint256) public publicAllowance;
1075 
1076     bytes32 public allowlistMerkleRoot;
1077     bytes32 public genesisMerkleRoot;
1078 
1079     bool public whitelistSaleIsActive;
1080     bool public genesisSaleIsActive;
1081     bool public publicSaleIsActive;
1082 
1083     uint public constant MAX_TOKENS = 1445;
1084     uint public constant MAX_TOKEN_PER_TXN = 2;
1085     uint public constant TOKEN_PRICE = 0.04 ether;
1086 
1087     uint public constant maxAllowListSupply = 1001;
1088     uint public constant maxGenesisSupply = 445;
1089     uint public allowListMinted = 0;
1090     uint public genesisClaimMinted = 0;
1091 
1092     modifier blockContracts() {
1093         require(tx.origin == msg.sender, "No smart contracts are allowed");
1094         _;
1095     }
1096 
1097     constructor() ERC721("Luminal Universe", "LUMINALUNIVERSE") {
1098         setAllowListRoot(
1099             0x3435f0bb641e0f7bce96bd6096693a5e349d7ed4f3afe056f686639b0ecdfbea
1100         );
1101         setGenesisRoot(
1102             0xfe4954196fa78174190adcdc10c6d6bac285a4a4edefbd1823c878e174512264
1103         );
1104         setBaseURI(
1105           "ipfs://QmfYtu5ASZnfYdghiJTqYYN3maCVpuJPrvJRHbu3ZbkvZL/"
1106         );
1107     }
1108 
1109     //withdraw function
1110     function withdraw() external onlyOwner {
1111         uint256 balance = address(this).balance;
1112         require(balance > 0, "Your balance is zero");
1113         address localOwner = payable(msg.sender);
1114         (bool ownerSuccess, ) = localOwner.call{value: balance}("");
1115         require(ownerSuccess, "Failed to send to Owner");
1116     }
1117 
1118     //setBaseURI
1119     function setBaseURI(string memory _baseURI) public onlyOwner {
1120         baseURI = _baseURI;
1121     }
1122 
1123     //flipWhitelistSale
1124     function flipWhiteListSaleState() external onlyOwner {
1125         whitelistSaleIsActive = !whitelistSaleIsActive;
1126     }
1127 
1128     //flipGenesisSale
1129     function flipGenesisSaleState() external onlyOwner {
1130         genesisSaleIsActive = !genesisSaleIsActive;
1131     }
1132 
1133     //flipPublicSale
1134     function flipPublicSaleState() external onlyOwner {
1135         publicSaleIsActive = !publicSaleIsActive;
1136     }
1137 
1138     //setAllowListRoot for allowlist
1139     function setAllowListRoot(bytes32 _root) public onlyOwner {
1140         allowlistMerkleRoot = _root;
1141     }
1142 
1143     //setGenesisRoot for genesis holder
1144     function setGenesisRoot(bytes32 _root) public onlyOwner {
1145         genesisMerkleRoot = _root;
1146     }
1147 
1148     //leaf for allowlist merkle root
1149     function _allowlistLeaf(address account) internal pure returns (bytes32) {
1150         return keccak256(abi.encodePacked(account));
1151     }
1152 
1153     //leaf for genesis merkle root
1154     function _genesisLeaf(address account, uint numberOfFreeClaims)
1155         internal
1156         pure
1157         returns (bytes32)
1158     {
1159         return keccak256(abi.encodePacked(account, numberOfFreeClaims));
1160     }
1161 
1162     //verify function for merkle root
1163     function _verify(
1164         bytes32 _leaf,
1165         bytes32[] memory _proof,
1166         bytes32 root
1167     ) internal pure returns (bool) {
1168         return MerkleProof.verify(_proof, root, _leaf);
1169     }
1170 
1171     //airdrop
1172     function airdrop(address _to, uint256 numberOfTokens) external onlyOwner {
1173         uint256 supply = totalSupply();
1174         require(
1175             supply + numberOfTokens < MAX_TOKENS,
1176             "Purchase would exceed the max supply"
1177         );
1178         for (uint256 i; i < numberOfTokens; i++) {
1179             _safeMint(_to, supply + i);
1180         }
1181     }
1182 
1183     //whitelistMint
1184     function whitelistMint(bytes32[] memory _proof)
1185         external
1186         payable
1187         blockContracts
1188     {
1189         uint supply = totalSupply();
1190         require(whitelistSaleIsActive, "Whitelist sale is not active");
1191         require(
1192             _verify(_allowlistLeaf(msg.sender), _proof, allowlistMerkleRoot),
1193             "You are not whitelisted"
1194         );
1195         require(
1196             !whitelistAllowance[msg.sender],
1197             "You can only mint one for WL"
1198         );
1199         require(allowListMinted + 1 < maxAllowListSupply, "Exceeds allowlist supply");
1200         require(msg.value == TOKEN_PRICE, "Ether sent is not correct");
1201         allowListMinted += 1;
1202         whitelistAllowance[msg.sender] = true;
1203         _mint(msg.sender, supply);
1204     }
1205 
1206     function genesisFreeClaim(
1207         uint _numberOfTokens,
1208         uint _numberOfFreeClaims,
1209         bytes32[] memory _proof
1210     ) external blockContracts {
1211         uint supply = totalSupply();
1212         require(
1213             whitelistSaleIsActive,
1214             "Free uinverse claim for genesis is not active"
1215         );
1216         require(
1217             _verify(
1218                 _genesisLeaf(msg.sender, _numberOfFreeClaims),
1219                 _proof,
1220                 genesisMerkleRoot
1221             ),
1222             "You are not allowed to claim free universe"
1223         );
1224         require(
1225             genesisFreeClaimed[msg.sender] + _numberOfTokens <=
1226                 _numberOfFreeClaims,
1227             "Exceeds claim allowance"
1228         );
1229         require(
1230             genesisClaimMinted + _numberOfTokens < maxGenesisSupply,
1231             "Claim would exceed max supply"
1232         );
1233         genesisClaimMinted += _numberOfTokens;
1234         genesisFreeClaimed[msg.sender] += _numberOfTokens;
1235         for (uint i; i < _numberOfTokens; i++) {
1236             _mint(msg.sender, supply + i);
1237         }
1238     }
1239 
1240     function genesisMint(
1241         uint _numberOfTokens,
1242         uint _numberOfFreeClaims,
1243         bytes32[] memory _proof
1244     ) external payable blockContracts {
1245         uint supply = totalSupply();
1246         require(
1247             genesisSaleIsActive,
1248             "Genesis sale to mint universe is not active"
1249         );
1250         require(
1251             _verify(
1252                 _genesisLeaf(msg.sender, _numberOfFreeClaims),
1253                 _proof,
1254                 genesisMerkleRoot
1255             ),
1256             "You are not allowed to mint for Stage 2"
1257         );
1258         require(
1259             genesisAllowance[msg.sender] + _numberOfTokens <= MAX_TOKEN_PER_TXN,
1260             "Genesis holder can only mint 2 Universe per address"
1261         );
1262         require(
1263             supply + _numberOfTokens < MAX_TOKENS,
1264             "Purchase would exceed max supply"
1265         );
1266         require(
1267             msg.value == TOKEN_PRICE * _numberOfTokens,
1268             "Ether sent is not correct"
1269         );
1270         genesisAllowance[msg.sender] += _numberOfTokens;
1271         for (uint i; i < _numberOfTokens; i++) {
1272             _mint(msg.sender, supply + i);
1273         }
1274     }
1275 
1276     function publicMint(uint _numberOfTokens) external payable blockContracts {
1277         uint supply = totalSupply();
1278         require(
1279             publicSaleIsActive,
1280             "Public sale to mint uinverse is not active"
1281         );
1282         require(
1283             _numberOfTokens <= MAX_TOKEN_PER_TXN,
1284             "For public mint only 2 token per transaction are allowed"
1285         );
1286         require(
1287             publicAllowance[msg.sender] < MAX_TOKEN_PER_TXN,
1288             "You can only mint 2 max per wallet per address"
1289         );
1290         require(
1291             supply + _numberOfTokens < MAX_TOKENS,
1292             "Purchase would exceed max supply"
1293         );
1294         require(
1295             msg.value == TOKEN_PRICE * _numberOfTokens,
1296             "Ether sent is not correct"
1297         );
1298         publicAllowance[msg.sender] += _numberOfTokens;
1299         for (uint i; i < _numberOfTokens; i++) {
1300             _mint(msg.sender, supply + i);
1301         }
1302     }
1303 
1304     //tokenURI for nft
1305     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1306         require(_exists(_tokenId), "Token does not exist");
1307         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1308     }
1309 }