1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7         uint256 size;
8         assembly {
9             size := extcodesize(account)
10         }
11         return size > 0;
12     }
13 }
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length)
66         internal
67         pure
68         returns (string memory)
69     {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 
82 /**
83  * @title ERC721 token receiver interface
84  * @dev Interface for any contract that wants to support safeTransfers
85  * from ERC721 asset contracts.
86  */
87 interface IERC721Receiver {
88     /**
89      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
90      * by `operator` from `from`, this function is called.
91      *
92      * It must return its Solidity selector to confirm the token transfer.
93      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
94      *
95      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
96      */
97     function onERC721Received(
98         address operator,
99         address from,
100         uint256 tokenId,
101         bytes calldata data
102     ) external returns (bytes4);
103 }
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 /**
127  * @dev Implementation of the {IERC165} interface.
128  *
129  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
130  * for the additional interface id that will be supported. For example:
131  *
132  * ```solidity
133  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
134  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
135  * }
136  * ```
137  *
138  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
139  */
140 abstract contract ERC165 is IERC165 {
141     /**
142      * @dev See {IERC165-supportsInterface}.
143      */
144     function supportsInterface(bytes4 interfaceId)
145         public
146         view
147         virtual
148         override
149         returns (bool)
150     {
151         return interfaceId == type(IERC165).interfaceId;
152     }
153 }
154 
155 /**
156  * @dev Required interface of an ERC721 compliant contract.
157  */
158 interface IERC721 is IERC165 {
159     /**
160      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
161      */
162     event Transfer(
163         address indexed from,
164         address indexed to,
165         uint256 indexed tokenId
166     );
167 
168     /**
169      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
170      */
171     event Approval(
172         address indexed owner,
173         address indexed approved,
174         uint256 indexed tokenId
175     );
176 
177     /**
178      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
179      */
180     event ApprovalForAll(
181         address indexed owner,
182         address indexed operator,
183         bool approved
184     );
185 
186     /**
187      * @dev Returns the number of tokens in ``owner``'s account.
188      */
189     function balanceOf(address owner) external view returns (uint256 balance);
190 
191     /**
192      * @dev Returns the owner of the `tokenId` token.
193      *
194      * Requirements:
195      *
196      * - `tokenId` must exist.
197      */
198     function ownerOf(uint256 tokenId) external view returns (address owner);
199 
200     /**
201      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
202      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Transfers `tokenId` token from `from` to `to`.
222      *
223      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must be owned by `from`.
230      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(
235         address from,
236         address to,
237         uint256 tokenId
238     ) external;
239 
240     /**
241      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
242      * The approval is cleared when the token is transferred.
243      *
244      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
245      *
246      * Requirements:
247      *
248      * - The caller must own the token or be an approved operator.
249      * - `tokenId` must exist.
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address to, uint256 tokenId) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId)
263         external
264         view
265         returns (address operator);
266 
267     /**
268      * @dev Approve or remove `operator` as an operator for the caller.
269      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
270      *
271      * Requirements:
272      *
273      * - The `operator` cannot be the caller.
274      *
275      * Emits an {ApprovalForAll} event.
276      */
277     function setApprovalForAll(address operator, bool _approved) external;
278 
279     /**
280      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
281      *
282      * See {setApprovalForAll}
283      */
284     function isApprovedForAll(address owner, address operator)
285         external
286         view
287         returns (bool);
288 
289     /**
290      * @dev Safely transfers `tokenId` token from `from` to `to`.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must exist and be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
299      *
300      * Emits a {Transfer} event.
301      */
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId,
306         bytes calldata data
307     ) external;
308 }
309 
310 /**
311  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
312  * @dev See https://eips.ethereum.org/EIPS/eip-721
313  */
314 interface IERC721Enumerable is IERC721 {
315     /**
316      * @dev Returns the total amount of tokens stored by the contract.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     /**
321      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
322      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
323      */
324     function tokenOfOwnerByIndex(address owner, uint256 index)
325         external
326         view
327         returns (uint256 tokenId);
328 
329     /**
330      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
331      * Use along with {totalSupply} to enumerate all tokens.
332      */
333     function tokenByIndex(uint256 index) external view returns (uint256);
334 }
335 
336 /**
337  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
338  * @dev See https://eips.ethereum.org/EIPS/eip-721
339  */
340 interface IERC721Metadata is IERC721 {
341     /**
342      * @dev Returns the token collection name.
343      */
344     function name() external view returns (string memory);
345 
346     /**
347      * @dev Returns the token collection symbol.
348      */
349     function symbol() external view returns (string memory);
350 
351     /**
352      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
353      */
354     function tokenURI(uint256 tokenId) external view returns (string memory);
355 }
356 
357 /**
358  * @dev Provides information about the current execution context, including the
359  * sender of the transaction and its data. While these are generally available
360  * via msg.sender and msg.data, they should not be accessed in such a direct
361  * manner, since when dealing with meta-transactions the account sending and
362  * paying for execution may not be the actual sender (as far as an application
363  * is concerned).
364  *
365  * This contract is only required for intermediate, library-like contracts.
366  */
367 abstract contract Context {
368     function _msgSender() internal view virtual returns (address) {
369         return msg.sender;
370     }
371 
372     function _msgData() internal view virtual returns (bytes calldata) {
373         return msg.data;
374     }
375 }
376 
377 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
378     using Address for address;
379     using Strings for uint256;
380 
381     string private _name;
382     string private _symbol;
383 
384     // Mapping from token ID to owner address
385     address[] internal _owners;
386 
387     mapping(uint256 => address) private _tokenApprovals;
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390     /**
391      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
392      */
393     constructor(string memory name_, string memory symbol_) {
394         _name = name_;
395         _symbol = symbol_;
396     }
397 
398     /**
399      * @dev See {IERC165-supportsInterface}.
400      */
401     function supportsInterface(bytes4 interfaceId)
402         public
403         view
404         virtual
405         override(ERC165, IERC165)
406         returns (bool)
407     {
408         return
409             interfaceId == type(IERC721).interfaceId ||
410             interfaceId == type(IERC721Metadata).interfaceId ||
411             super.supportsInterface(interfaceId);
412     }
413 
414     /**
415      * @dev See {IERC721-balanceOf}.
416      */
417     function balanceOf(address owner)
418         public
419         view
420         virtual
421         override
422         returns (uint256)
423     {
424         require(
425             owner != address(0),
426             "ERC721: balance query for the zero address"
427         );
428 
429         uint256 count;
430         for (uint256 i; i < _owners.length; ++i) {
431             if (owner == _owners[i]) ++count;
432         }
433         return count;
434     }
435 
436     /**
437      * @dev See {IERC721-ownerOf}.
438      */
439     function ownerOf(uint256 tokenId)
440         public
441         view
442         virtual
443         override
444         returns (address)
445     {
446         address owner = _owners[tokenId];
447         require(
448             owner != address(0),
449             "ERC721: owner query for nonexistent token"
450         );
451         return owner;
452     }
453 
454     /**
455      * @dev See {IERC721Metadata-name}.
456      */
457     function name() public view virtual override returns (string memory) {
458         return _name;
459     }
460 
461     /**
462      * @dev See {IERC721Metadata-symbol}.
463      */
464     function symbol() public view virtual override returns (string memory) {
465         return _symbol;
466     }
467 
468     /**
469      * @dev See {IERC721-approve}.
470      */
471     function approve(address to, uint256 tokenId) public virtual override {
472         address owner = ERC721.ownerOf(tokenId);
473         require(to != owner, "ERC721: approval to current owner");
474 
475         require(
476             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
477             "ERC721: approve caller is not owner nor approved for all"
478         );
479 
480         _approve(to, tokenId);
481     }
482 
483     /**
484      * @dev See {IERC721-getApproved}.
485      */
486     function getApproved(uint256 tokenId)
487         public
488         view
489         virtual
490         override
491         returns (address)
492     {
493         require(
494             _exists(tokenId),
495             "ERC721: approved query for nonexistent token"
496         );
497 
498         return _tokenApprovals[tokenId];
499     }
500 
501     /**
502      * @dev See {IERC721-setApprovalForAll}.
503      */
504     function setApprovalForAll(address operator, bool approved)
505         public
506         virtual
507         override
508     {
509         require(operator != _msgSender(), "ERC721: approve to caller");
510 
511         _operatorApprovals[_msgSender()][operator] = approved;
512         emit ApprovalForAll(_msgSender(), operator, approved);
513     }
514 
515     /**
516      * @dev See {IERC721-isApprovedForAll}.
517      */
518     function isApprovedForAll(address owner, address operator)
519         public
520         view
521         virtual
522         override
523         returns (bool)
524     {
525         return _operatorApprovals[owner][operator];
526     }
527 
528     /**
529      * @dev See {IERC721-transferFrom}.
530      */
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) public virtual override {
536         //solhint-disable-next-line max-line-length
537         require(
538             _isApprovedOrOwner(_msgSender(), tokenId),
539             "ERC721: transfer caller is not owner nor approved"
540         );
541 
542         _transfer(from, to, tokenId);
543     }
544 
545     /**
546      * @dev See {IERC721-safeTransferFrom}.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) public virtual override {
553         safeTransferFrom(from, to, tokenId, "");
554     }
555 
556     /**
557      * @dev See {IERC721-safeTransferFrom}.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId,
563         bytes memory _data
564     ) public virtual override {
565         require(
566             _isApprovedOrOwner(_msgSender(), tokenId),
567             "ERC721: transfer caller is not owner nor approved"
568         );
569         _safeTransfer(from, to, tokenId, _data);
570     }
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
574      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
575      *
576      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
577      *
578      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
579      * implement alternative mechanisms to perform token transfer, such as signature-based.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function _safeTransfer(
591         address from,
592         address to,
593         uint256 tokenId,
594         bytes memory _data
595     ) internal virtual {
596         _transfer(from, to, tokenId);
597         require(
598             _checkOnERC721Received(from, to, tokenId, _data),
599             "ERC721: transfer to non ERC721Receiver implementer"
600         );
601     }
602 
603     /**
604      * @dev Returns whether `tokenId` exists.
605      *
606      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
607      *
608      * Tokens start existing when they are minted (`_mint`),
609      * and stop existing when they are burned (`_burn`).
610      */
611     function _exists(uint256 tokenId) internal view virtual returns (bool) {
612         return tokenId < _owners.length && _owners[tokenId] != address(0);
613     }
614 
615     /**
616      * @dev Returns whether `spender` is allowed to manage `tokenId`.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function _isApprovedOrOwner(address spender, uint256 tokenId)
623         internal
624         view
625         virtual
626         returns (bool)
627     {
628         require(
629             _exists(tokenId),
630             "ERC721: operator query for nonexistent token"
631         );
632         address owner = ERC721.ownerOf(tokenId);
633         return (spender == owner ||
634             getApproved(tokenId) == spender ||
635             isApprovedForAll(owner, spender));
636     }
637 
638     /**
639      * @dev Safely mints `tokenId` and transfers it to `to`.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must not exist.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function _safeMint(address to, uint256 tokenId) internal virtual {
649         _safeMint(to, tokenId, "");
650     }
651 
652     /**
653      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
654      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
655      */
656     function _safeMint(
657         address to,
658         uint256 tokenId,
659         bytes memory _data
660     ) internal virtual {
661         _mint(to, tokenId);
662         require(
663             _checkOnERC721Received(address(0), to, tokenId, _data),
664             "ERC721: transfer to non ERC721Receiver implementer"
665         );
666     }
667 
668     /**
669      * @dev Mints `tokenId` and transfers it to `to`.
670      *
671      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
672      *
673      * Requirements:
674      *
675      * - `tokenId` must not exist.
676      * - `to` cannot be the zero address.
677      *
678      * Emits a {Transfer} event.
679      */
680     function _mint(address to, uint256 tokenId) internal virtual {
681         require(to != address(0), "ERC721: mint to the zero address");
682         require(!_exists(tokenId), "ERC721: token already minted");
683 
684         _beforeTokenTransfer(address(0), to, tokenId);
685         _owners.push(to);
686 
687         emit Transfer(address(0), to, tokenId);
688     }
689 
690     /**
691      * @dev Destroys `tokenId`.
692      * The approval is cleared when the token is burned.
693      *
694      * Requirements:
695      *
696      * - `tokenId` must exist.
697      *
698      * Emits a {Transfer} event.
699      */
700     function _burn(uint256 tokenId) internal virtual {
701         address owner = ERC721.ownerOf(tokenId);
702 
703         _beforeTokenTransfer(owner, address(0), tokenId);
704 
705         // Clear approvals
706         _approve(address(0), tokenId);
707         _owners[tokenId] = address(0);
708 
709         emit Transfer(owner, address(0), tokenId);
710     }
711 
712     /**
713      * @dev Transfers `tokenId` from `from` to `to`.
714      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
715      *
716      * Requirements:
717      *
718      * - `to` cannot be the zero address.
719      * - `tokenId` token must be owned by `from`.
720      *
721      * Emits a {Transfer} event.
722      */
723     function _transfer(
724         address from,
725         address to,
726         uint256 tokenId
727     ) internal virtual {
728         require(
729             ERC721.ownerOf(tokenId) == from,
730             "ERC721: transfer of token that is not own"
731         );
732         require(to != address(0), "ERC721: transfer to the zero address");
733 
734         _beforeTokenTransfer(from, to, tokenId);
735 
736         // Clear approvals from the previous owner
737         _approve(address(0), tokenId);
738         _owners[tokenId] = to;
739 
740         emit Transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev Approve `to` to operate on `tokenId`
745      *
746      * Emits a {Approval} event.
747      */
748     function _approve(address to, uint256 tokenId) internal virtual {
749         _tokenApprovals[tokenId] = to;
750         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
751     }
752 
753     /**
754      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
755      * The call is not executed if the target address is not a contract.
756      *
757      * @param from address representing the previous owner of the given token ID
758      * @param to target address that will receive the tokens
759      * @param tokenId uint256 ID of the token to be transferred
760      * @param _data bytes optional data to send along with the call
761      * @return bool whether the call correctly returned the expected magic value
762      */
763     function _checkOnERC721Received(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) private returns (bool) {
769         if (to.isContract()) {
770             try
771                 IERC721Receiver(to).onERC721Received(
772                     _msgSender(),
773                     from,
774                     tokenId,
775                     _data
776                 )
777             returns (bytes4 retval) {
778                 return retval == IERC721Receiver.onERC721Received.selector;
779             } catch (bytes memory reason) {
780                 if (reason.length == 0) {
781                     revert(
782                         "ERC721: transfer to non ERC721Receiver implementer"
783                     );
784                 } else {
785                     assembly {
786                         revert(add(32, reason), mload(reason))
787                     }
788                 }
789             }
790         } else {
791             return true;
792         }
793     }
794 
795     /**
796      * @dev Hook that is called before any token transfer. This includes minting
797      * and burning.
798      *
799      * Calling conditions:
800      *
801      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
802      * transferred to `to`.
803      * - When `from` is zero, `tokenId` will be minted for `to`.
804      * - When `to` is zero, ``from``'s `tokenId` will be burned.
805      * - `from` and `to` are never both zero.
806      *
807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
808      */
809     function _beforeTokenTransfer(
810         address from,
811         address to,
812         uint256 tokenId
813     ) internal virtual {}
814 }
815 
816 /**
817  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
818  * enumerability of all the token ids in the contract as well as all token ids owned by each
819  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
820  */
821 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId)
826         public
827         view
828         virtual
829         override(IERC165, ERC721)
830         returns (bool)
831     {
832         return
833             interfaceId == type(IERC721Enumerable).interfaceId ||
834             super.supportsInterface(interfaceId);
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-totalSupply}.
839      */
840     function totalSupply() public view virtual override returns (uint256) {
841         return _owners.length;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-tokenByIndex}.
846      */
847     function tokenByIndex(uint256 index)
848         public
849         view
850         virtual
851         override
852         returns (uint256)
853     {
854         require(
855             index < _owners.length,
856             "ERC721Enumerable: global index out of bounds"
857         );
858         return index;
859     }
860 
861     /**
862      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
863      */
864     function tokenOfOwnerByIndex(address owner, uint256 index)
865         public
866         view
867         virtual
868         override
869         returns (uint256 tokenId)
870     {
871         require(
872             index < balanceOf(owner),
873             "ERC721Enumerable: owner index out of bounds"
874         );
875 
876         uint256 count;
877         for (uint256 i; i < _owners.length; i++) {
878             if (owner == _owners[i]) {
879                 if (count == index) return i;
880                 else count++;
881             }
882         }
883 
884         revert("ERC721Enumerable: owner index out of bounds");
885     }
886 }
887 
888 /**
889  * @dev Contract module which provides a basic access control mechanism, where
890  * there is an account (an owner) that can be granted exclusive access to
891  * specific functions.
892  *
893  * By default, the owner account will be the one that deploys the contract. This
894  * can later be changed with {transferOwnership}.
895  *
896  * This module is used through inheritance. It will make available the modifier
897  * `onlyOwner`, which can be applied to your functions to restrict their use to
898  * the owner.
899  */
900 abstract contract Ownable is Context {
901     address private _owner;
902 
903     event OwnershipTransferred(
904         address indexed previousOwner,
905         address indexed newOwner
906     );
907 
908     /**
909      * @dev Initializes the contract setting the deployer as the initial owner.
910      */
911     constructor() {
912         _transferOwnership(_msgSender());
913     }
914 
915     /**
916      * @dev Returns the address of the current owner.
917      */
918     function owner() public view virtual returns (address) {
919         return _owner;
920     }
921 
922     /**
923      * @dev Throws if called by any account other than the owner.
924      */
925     modifier onlyOwner() {
926         require(owner() == _msgSender(), "Ownable: caller is not the owner");
927         _;
928     }
929 
930     /**
931      * @dev Leaves the contract without owner. It will not be possible to call
932      * `onlyOwner` functions anymore. Can only be called by the current owner.
933      *
934      * NOTE: Renouncing ownership will leave the contract without an owner,
935      * thereby removing any functionality that is only available to the owner.
936      */
937     function renounceOwnership() public virtual onlyOwner {
938         _transferOwnership(address(0));
939     }
940 
941     /**
942      * @dev Transfers ownership of the contract to a new account (`newOwner`).
943      * Can only be called by the current owner.
944      */
945     function transferOwnership(address newOwner) public virtual onlyOwner {
946         require(
947             newOwner != address(0),
948             "Ownable: new owner is the zero address"
949         );
950         _transferOwnership(newOwner);
951     }
952 
953     /**
954      * @dev Transfers ownership of the contract to a new account (`newOwner`).
955      * Internal function without access restriction.
956      */
957     function _transferOwnership(address newOwner) internal virtual {
958         address oldOwner = _owner;
959         _owner = newOwner;
960         emit OwnershipTransferred(oldOwner, newOwner);
961     }
962 }
963 
964 /**
965  * @dev These functions deal with verification of Merkle Trees proofs.
966  *
967  * The proofs can be generated using the JavaScript library
968  * https://github.com/miguelmota/merkletreejs[merkletreejs].
969  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
970  *
971  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
972  */
973 library MerkleProof {
974     /**
975      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
976      * defined by `root`. For this, a `proof` must be provided, containing
977      * sibling hashes on the branch from the leaf to the root of the tree. Each
978      * pair of leaves and each pair of pre-images are assumed to be sorted.
979      */
980     function verify(
981         bytes32[] memory proof,
982         bytes32 root,
983         bytes32 leaf
984     ) internal pure returns (bool) {
985         return processProof(proof, leaf) == root;
986     }
987 
988     /**
989      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
990      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
991      * hash matches the root of the tree. When processing the proof, the pairs
992      * of leafs & pre-images are assumed to be sorted.
993      *
994      * _Available since v4.4._
995      */
996     function processProof(bytes32[] memory proof, bytes32 leaf)
997         internal
998         pure
999         returns (bytes32)
1000     {
1001         bytes32 computedHash = leaf;
1002         for (uint256 i = 0; i < proof.length; i++) {
1003             bytes32 proofElement = proof[i];
1004             if (computedHash <= proofElement) {
1005                 // Hash(current computed hash + current element of the proof)
1006                 computedHash = keccak256(
1007                     abi.encodePacked(computedHash, proofElement)
1008                 );
1009             } else {
1010                 // Hash(current element of the proof + current computed hash)
1011                 computedHash = keccak256(
1012                     abi.encodePacked(proofElement, computedHash)
1013                 );
1014             }
1015         }
1016         return computedHash;
1017     }
1018 }
1019 
1020 contract TrumpyDumpy is ERC721Enumerable, Ownable {
1021     string public baseURI;
1022 
1023     uint256 public constant MAX_SUPPLY = 10000;
1024     
1025     uint256 public maxMintPerWallet = 5;
1026     uint256 public currentPrice = 0 ether;
1027     bool public isPreSale = false;
1028     bool public isPublicSale = false;
1029     bool public isRevealed = false;
1030 
1031     bytes32 public whitelistMerkleRoot;
1032     
1033     mapping(address => uint256) public whitelistAddressToMinted;
1034     mapping(address => uint256) public addressToMinted;
1035 
1036 
1037     constructor(string memory _baseURI) ERC721("Trumpy Dumpy", "Trumpy") {
1038         baseURI = _baseURI;
1039     }
1040 
1041     function setReveal(bool reveal, string memory _baseURI) public onlyOwner {
1042         isRevealed = reveal;
1043         baseURI = _baseURI;
1044     }
1045 
1046     function setSale(bool preSale, bool publicSale) public onlyOwner {
1047         isPreSale = preSale;
1048         isPublicSale = publicSale;
1049     }
1050     function setCurrentPrice(uint256 _currentPrice) public onlyOwner {
1051         currentPrice = _currentPrice;
1052     }
1053     function setMaxPerWallet(uint256 _maxMintPerWallet) public onlyOwner {
1054         maxMintPerWallet = _maxMintPerWallet;
1055     }
1056 
1057     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot)
1058         external
1059         onlyOwner
1060     {
1061         whitelistMerkleRoot = _whitelistMerkleRoot;
1062     }
1063 
1064     function getAllowance(string memory allowance, bytes32[] calldata proof)
1065         public
1066         view
1067         returns (uint256)
1068     {
1069         string memory payload = string(abi.encodePacked(_msgSender()));
1070         require(
1071             _verify(_leaf(allowance, payload), proof),
1072             "Invalid Merkle Tree proof supplied."
1073         );
1074         return whitelistAddressToMinted[_msgSender()];
1075     }
1076     
1077 
1078     function tokenURI(uint256 _tokenId)
1079         public
1080         view
1081         override
1082         returns (string memory)
1083     {
1084         require(_exists(_tokenId), "Token does not exist.");
1085         if (!isRevealed) return baseURI;
1086         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json"));
1087     }
1088 
1089 
1090     function giveAway(address[] calldata _users) external onlyOwner {
1091         uint256 totalSupply = _owners.length;
1092         require(totalSupply + _users.length <= MAX_SUPPLY, "Excedes max supply.");
1093         for (uint256 i; i < _users.length; i++) _mint(_users[i], totalSupply + i);
1094     }
1095 
1096 
1097     function publicMint(uint256 count) public payable {
1098         uint256 totalSupply = _owners.length;
1099         require(isPublicSale, "Public sale not started");
1100         require(totalSupply + count <= MAX_SUPPLY, "Excedes max supply.");
1101         require(count <= maxMintPerWallet - addressToMinted[_msgSender()], "Exceeds max per wallet.");
1102         require(count * currentPrice == msg.value, "Invalid funds provided.");
1103         
1104         addressToMinted[_msgSender()] += count;
1105 
1106         for (uint256 i; i < count; i++) {
1107             _mint(_msgSender(), totalSupply + i);
1108         }
1109     }
1110 
1111     function whitelistMint(
1112         uint256 count,
1113         uint256 allowance,
1114         bytes32[] calldata proof
1115     ) public payable {
1116         uint256 totalSupply = _owners.length;
1117         require(isPreSale, "pre sale not started");
1118         require(totalSupply + count <= MAX_SUPPLY, "Excedes max supply.");
1119         string memory payload = string(abi.encodePacked(_msgSender()));
1120         require(_verify(_leaf(Strings.toString(allowance), payload), proof),"Invalid Merkle Tree proof supplied.");
1121         require(whitelistAddressToMinted[_msgSender()] + count <= allowance, "Exceeds whitelist supply");
1122         require(count * currentPrice == msg.value, "Invalid funds provided.");
1123 
1124         whitelistAddressToMinted[_msgSender()] += count;
1125         
1126         for (uint256 i; i < count; i++) {
1127             _mint(_msgSender(), totalSupply + i);
1128         }
1129     }
1130 
1131     function burn(uint256 tokenId) public {
1132         require(
1133             _isApprovedOrOwner(_msgSender(), tokenId),
1134             "Not approved to burn."
1135         );
1136         _burn(tokenId);
1137     }
1138 
1139     function withdraw() public {
1140         (bool success, ) = payable(owner()).call{value: address(this).balance}(
1141             ""
1142         );
1143         require(success, "Failed to send.");
1144     }
1145 
1146     function walletOfOwner(address _owner)
1147         public
1148         view
1149         returns (uint256[] memory)
1150     {
1151         uint256 tokenCount = balanceOf(_owner);
1152         if (tokenCount == 0) return new uint256[](0);
1153 
1154         uint256[] memory tokensId = new uint256[](tokenCount);
1155         for (uint256 i; i < tokenCount; i++) {
1156             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1157         }
1158         return tokensId;
1159     }
1160 
1161     function batchTransferFrom(
1162         address _from,
1163         address _to,
1164         uint256[] memory _tokenIds
1165     ) public {
1166         for (uint256 i = 0; i < _tokenIds.length; i++) {
1167             transferFrom(_from, _to, _tokenIds[i]);
1168         }
1169     }
1170 
1171     function batchSafeTransferFrom(
1172         address _from,
1173         address _to,
1174         uint256[] memory _tokenIds,
1175         bytes memory data_
1176     ) public {
1177         for (uint256 i = 0; i < _tokenIds.length; i++) {
1178             safeTransferFrom(_from, _to, _tokenIds[i], data_);
1179         }
1180     }
1181 
1182     function isOwnerOf(address account, uint256[] calldata _tokenIds)
1183         external
1184         view
1185         returns (bool)
1186     {
1187         for (uint256 i; i < _tokenIds.length; ++i) {
1188             if (_owners[_tokenIds[i]] != account) return false;
1189         }
1190 
1191         return true;
1192     }
1193 
1194     function _mint(address to, uint256 tokenId) internal virtual override {
1195         _owners.push(to);
1196         emit Transfer(address(0), to, tokenId);
1197     }
1198 
1199     function _leaf(string memory allowance, string memory payload)
1200         internal
1201         pure
1202         returns (bytes32)
1203     {
1204         return keccak256(abi.encodePacked(payload, allowance));
1205     }
1206 
1207     function _verify(bytes32 leaf, bytes32[] memory proof)
1208         internal
1209         view
1210         returns (bool)
1211     {
1212         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
1213     }
1214 }