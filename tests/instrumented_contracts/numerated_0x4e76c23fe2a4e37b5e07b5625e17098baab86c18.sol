1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 
6 // 
7 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // 
30 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 // 
169 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
170 /**
171  * @title ERC721 token receiver interface
172  * @dev Interface for any contract that wants to support safeTransfers
173  * from ERC721 asset contracts.
174  */
175 interface IERC721Receiver {
176     /**
177      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
178      * by `operator` from `from`, this function is called.
179      *
180      * It must return its Solidity selector to confirm the token transfer.
181      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
182      *
183      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
184      */
185     function onERC721Received(
186         address operator,
187         address from,
188         uint256 tokenId,
189         bytes calldata data
190     ) external returns (bytes4);
191 }
192 
193 // 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Metadata is IERC721 {
200     /**
201      * @dev Returns the token collection name.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the token collection symbol.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
212      */
213     function tokenURI(uint256 tokenId) external view returns (string memory);
214 }
215 
216 // 
217 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
218 /**
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234         return msg.data;
235     }
236 }
237 
238 // 
239 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
240 /**
241  * @dev String operations.
242  */
243 library Strings {
244     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
248      */
249     function toString(uint256 value) internal pure returns (string memory) {
250         // Inspired by OraclizeAPI's implementation - MIT licence
251         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
252 
253         if (value == 0) {
254             return "0";
255         }
256         uint256 temp = value;
257         uint256 digits;
258         while (temp != 0) {
259             digits++;
260             temp /= 10;
261         }
262         bytes memory buffer = new bytes(digits);
263         while (value != 0) {
264             digits -= 1;
265             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
266             value /= 10;
267         }
268         return string(buffer);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
273      */
274     function toHexString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0x00";
277         }
278         uint256 temp = value;
279         uint256 length = 0;
280         while (temp != 0) {
281             length++;
282             temp >>= 8;
283         }
284         return toHexString(value, length);
285     }
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
289      */
290     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
291         bytes memory buffer = new bytes(2 * length + 2);
292         buffer[0] = "0";
293         buffer[1] = "x";
294         for (uint256 i = 2 * length + 1; i > 1; --i) {
295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
296             value >>= 4;
297         }
298         require(value == 0, "Strings: hex length insufficient");
299         return string(buffer);
300     }
301 }
302 
303 // 
304 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
305 /**
306  * @dev Implementation of the {IERC165} interface.
307  *
308  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
309  * for the additional interface id that will be supported. For example:
310  *
311  * ```solidity
312  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
314  * }
315  * ```
316  *
317  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
318  */
319 abstract contract ERC165 is IERC165 {
320     /**
321      * @dev See {IERC165-supportsInterface}.
322      */
323     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324         return interfaceId == type(IERC165).interfaceId;
325     }
326 }
327 
328 // 
329 library AddressGasOptimized {
330     function isContract(address account) internal view returns (bool) {
331         uint size;
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 }
338 
339 // 
340 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
341     using AddressGasOptimized for address;
342     using Strings for uint256;
343     
344     string private _name;
345     string private _symbol;
346 
347     // Mapping from token ID to owner address
348     address[] internal _owners;
349 
350     mapping(uint256 => address) private _tokenApprovals;
351     mapping(address => mapping(address => bool)) private _operatorApprovals;
352 
353     /**
354      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
355      */
356     constructor(string memory name_, string memory symbol_) {
357         _name = name_;
358         _symbol = symbol_;
359     }
360 
361     /**
362      * @dev See {IERC165-supportsInterface}.
363      */
364     function supportsInterface(bytes4 interfaceId)
365         public
366         view
367         virtual
368         override(ERC165, IERC165)
369         returns (bool)
370     {
371         return
372             interfaceId == type(IERC721).interfaceId ||
373             interfaceId == type(IERC721Metadata).interfaceId ||
374             super.supportsInterface(interfaceId);
375     }
376 
377     /**
378      * @dev See {IERC721-balanceOf}.
379      */
380     function balanceOf(address owner) 
381         public 
382         view 
383         virtual 
384         override 
385         returns (uint) 
386     {
387         require(owner != address(0), "ERC721: balance query for the zero address");
388 
389         uint count;
390         for( uint i; i < _owners.length; ++i ){
391           if( owner == _owners[i] )
392             ++count;
393         }
394         return count;
395     }
396 
397     /**
398      * @dev See {IERC721-ownerOf}.
399      */
400     function ownerOf(uint256 tokenId)
401         public
402         view
403         virtual
404         override
405         returns (address)
406     {
407         address owner = _owners[tokenId];
408         require(
409             owner != address(0),
410             "ERC721: owner query for nonexistent token"
411         );
412         return owner;
413     }
414 
415     /**
416      * @dev See {IERC721Metadata-name}.
417      */
418     function name() public view virtual override returns (string memory) {
419         return _name;
420     }
421 
422     /**
423      * @dev See {IERC721Metadata-symbol}.
424      */
425     function symbol() public view virtual override returns (string memory) {
426         return _symbol;
427     }
428 
429     /**
430      * @dev See {IERC721-approve}.
431      */
432     function approve(address to, uint256 tokenId) public virtual override {
433         address owner = ERC721.ownerOf(tokenId);
434         require(to != owner, "ERC721: approval to current owner");
435 
436         require(
437             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
438             "ERC721: approve caller is not owner nor approved for all"
439         );
440 
441         _approve(to, tokenId);
442     }
443 
444     /**
445      * @dev See {IERC721-getApproved}.
446      */
447     function getApproved(uint256 tokenId)
448         public
449         view
450         virtual
451         override
452         returns (address)
453     {
454         require(
455             _exists(tokenId),
456             "ERC721: approved query for nonexistent token"
457         );
458 
459         return _tokenApprovals[tokenId];
460     }
461 
462     /**
463      * @dev See {IERC721-setApprovalForAll}.
464      */
465     function setApprovalForAll(address operator, bool approved)
466         public
467         virtual
468         override
469     {
470         require(operator != _msgSender(), "ERC721: approve to caller");
471 
472         _operatorApprovals[_msgSender()][operator] = approved;
473         emit ApprovalForAll(_msgSender(), operator, approved);
474     }
475 
476     /**
477      * @dev See {IERC721-isApprovedForAll}.
478      */
479     function isApprovedForAll(address owner, address operator)
480         public
481         view
482         virtual
483         override
484         returns (bool)
485     {
486         return _operatorApprovals[owner][operator];
487     }
488 
489     /**
490      * @dev See {IERC721-transferFrom}.
491      */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) public virtual override {
497         //solhint-disable-next-line max-line-length
498         require(
499             _isApprovedOrOwner(_msgSender(), tokenId),
500             "ERC721: transfer caller is not owner nor approved"
501         );
502 
503         _transfer(from, to, tokenId);
504     }
505 
506     /**
507      * @dev See {IERC721-safeTransferFrom}.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) public virtual override {
514         safeTransferFrom(from, to, tokenId, "");
515     }
516 
517     /**
518      * @dev See {IERC721-safeTransferFrom}.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId,
524         bytes memory _data
525     ) public virtual override {
526         require(
527             _isApprovedOrOwner(_msgSender(), tokenId),
528             "ERC721: transfer caller is not owner nor approved"
529         );
530         _safeTransfer(from, to, tokenId, _data);
531     }
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
536      *
537      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
538      *
539      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
540      * implement alternative mechanisms to perform token transfer, such as signature-based.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must exist and be owned by `from`.
547      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
548      *
549      * Emits a {Transfer} event.
550      */
551     function _safeTransfer(
552         address from,
553         address to,
554         uint256 tokenId,
555         bytes memory _data
556     ) internal virtual {
557         _transfer(from, to, tokenId);
558         require(
559             _checkOnERC721Received(from, to, tokenId, _data),
560             "ERC721: transfer to non ERC721Receiver implementer"
561         );
562     }
563 
564     /**
565      * @dev Returns whether `tokenId` exists.
566      *
567      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
568      *
569      * Tokens start existing when they are minted (`_mint`),
570      * and stop existing when they are burned (`_burn`).
571      */
572     function _exists(uint256 tokenId) internal view virtual returns (bool) {
573         return tokenId < _owners.length && _owners[tokenId] != address(0);
574     }
575 
576     /**
577      * @dev Returns whether `spender` is allowed to manage `tokenId`.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function _isApprovedOrOwner(address spender, uint256 tokenId)
584         internal
585         view
586         virtual
587         returns (bool)
588     {
589         require(
590             _exists(tokenId),
591             "ERC721: operator query for nonexistent token"
592         );
593         address owner = ERC721.ownerOf(tokenId);
594         return (spender == owner ||
595             getApproved(tokenId) == spender ||
596             isApprovedForAll(owner, spender));
597     }
598 
599     /**
600      * @dev Safely mints `tokenId` and transfers it to `to`.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must not exist.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function _safeMint(address to, uint256 tokenId) internal virtual {
610         _safeMint(to, tokenId, "");
611     }
612 
613     /**
614      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
615      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
616      */
617     function _safeMint(
618         address to,
619         uint256 tokenId,
620         bytes memory _data
621     ) internal virtual {
622         _mint(to, tokenId);
623         require(
624             _checkOnERC721Received(address(0), to, tokenId, _data),
625             "ERC721: transfer to non ERC721Receiver implementer"
626         );
627     }
628 
629     /**
630      * @dev Mints `tokenId` and transfers it to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
633      *
634      * Requirements:
635      *
636      * - `tokenId` must not exist.
637      * - `to` cannot be the zero address.
638      *
639      * Emits a {Transfer} event.
640      */
641     function _mint(address to, uint256 tokenId) internal virtual {
642         require(to != address(0), "ERC721: mint to the zero address");
643         require(!_exists(tokenId), "ERC721: token already minted");
644 
645         _beforeTokenTransfer(address(0), to, tokenId);
646         _owners.push(to);
647 
648         emit Transfer(address(0), to, tokenId);
649     }
650 
651     /**
652      * @dev Destroys `tokenId`.
653      * The approval is cleared when the token is burned.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      *
659      * Emits a {Transfer} event.
660      */
661     function _burn(uint256 tokenId) internal virtual {
662         address owner = ERC721.ownerOf(tokenId);
663 
664         _beforeTokenTransfer(owner, address(0), tokenId);
665 
666         // Clear approvals
667         _approve(address(0), tokenId);
668         _owners[tokenId] = address(0);
669 
670         emit Transfer(owner, address(0), tokenId);
671     }
672 
673     /**
674      * @dev Transfers `tokenId` from `from` to `to`.
675      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must be owned by `from`.
681      *
682      * Emits a {Transfer} event.
683      */
684     function _transfer(
685         address from,
686         address to,
687         uint256 tokenId
688     ) internal virtual {
689         require(
690             ERC721.ownerOf(tokenId) == from,
691             "ERC721: transfer of token that is not own"
692         );
693         require(to != address(0), "ERC721: transfer to the zero address");
694 
695         _beforeTokenTransfer(from, to, tokenId);
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
732                 IERC721Receiver(to).onERC721Received(
733                     _msgSender(),
734                     from,
735                     tokenId,
736                     _data
737                 )
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
755 
756     /**
757      * @dev Hook that is called before any token transfer. This includes minting
758      * and burning.
759      *
760      * Calling conditions:
761      *
762      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
763      * transferred to `to`.
764      * - When `from` is zero, `tokenId` will be minted for `to`.
765      * - When `to` is zero, ``from``'s `tokenId` will be burned.
766      * - `from` and `to` are never both zero.
767      *
768      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
769      */
770     function _beforeTokenTransfer(
771         address from,
772         address to,
773         uint256 tokenId
774     ) internal virtual {}
775 }
776 
777 // 
778 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
779 /**
780  * @dev Contract module which provides a basic access control mechanism, where
781  * there is an account (an owner) that can be granted exclusive access to
782  * specific functions.
783  *
784  * By default, the owner account will be the one that deploys the contract. This
785  * can later be changed with {transferOwnership}.
786  *
787  * This module is used through inheritance. It will make available the modifier
788  * `onlyOwner`, which can be applied to your functions to restrict their use to
789  * the owner.
790  */
791 abstract contract Ownable is Context {
792     address private _owner;
793 
794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial owner.
798      */
799     constructor() {
800         _transferOwnership(_msgSender());
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view virtual returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if called by any account other than the owner.
812      */
813     modifier onlyOwner() {
814         require(owner() == _msgSender(), "Ownable: caller is not the owner");
815         _;
816     }
817 
818     /**
819      * @dev Leaves the contract without owner. It will not be possible to call
820      * `onlyOwner` functions anymore. Can only be called by the current owner.
821      *
822      * NOTE: Renouncing ownership will leave the contract without an owner,
823      * thereby removing any functionality that is only available to the owner.
824      */
825     function renounceOwnership() public virtual onlyOwner {
826         _transferOwnership(address(0));
827     }
828 
829     /**
830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
831      * Can only be called by the current owner.
832      */
833     function transferOwnership(address newOwner) public virtual onlyOwner {
834         require(newOwner != address(0), "Ownable: new owner is the zero address");
835         _transferOwnership(newOwner);
836     }
837 
838     /**
839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
840      * Internal function without access restriction.
841      */
842     function _transferOwnership(address newOwner) internal virtual {
843         address oldOwner = _owner;
844         _owner = newOwner;
845         emit OwnershipTransferred(oldOwner, newOwner);
846     }
847 }
848 
849 // 
850 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
851 /**
852  * @dev These functions deal with verification of Merkle Trees proofs.
853  *
854  * The proofs can be generated using the JavaScript library
855  * https://github.com/miguelmota/merkletreejs[merkletreejs].
856  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
857  *
858  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
859  */
860 library MerkleProof {
861     /**
862      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
863      * defined by `root`. For this, a `proof` must be provided, containing
864      * sibling hashes on the branch from the leaf to the root of the tree. Each
865      * pair of leaves and each pair of pre-images are assumed to be sorted.
866      */
867     function verify(
868         bytes32[] memory proof,
869         bytes32 root,
870         bytes32 leaf
871     ) internal pure returns (bool) {
872         return processProof(proof, leaf) == root;
873     }
874 
875     /**
876      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
877      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
878      * hash matches the root of the tree. When processing the proof, the pairs
879      * of leafs & pre-images are assumed to be sorted.
880      *
881      * _Available since v4.4._
882      */
883     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
884         bytes32 computedHash = leaf;
885         for (uint256 i = 0; i < proof.length; i++) {
886             bytes32 proofElement = proof[i];
887             if (computedHash <= proofElement) {
888                 // Hash(current computed hash + current element of the proof)
889                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
890             } else {
891                 // Hash(current element of the proof + current computed hash)
892                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
893             }
894         }
895         return computedHash;
896     }
897 }
898 
899 // 
900 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
901 /**
902  * @dev Contract module that helps prevent reentrant calls to a function.
903  *
904  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
905  * available, which can be applied to functions to make sure there are no nested
906  * (reentrant) calls to them.
907  *
908  * Note that because there is a single `nonReentrant` guard, functions marked as
909  * `nonReentrant` may not call one another. This can be worked around by making
910  * those functions `private`, and then adding `external` `nonReentrant` entry
911  * points to them.
912  *
913  * TIP: If you would like to learn more about reentrancy and alternative ways
914  * to protect against it, check out our blog post
915  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
916  */
917 abstract contract ReentrancyGuard {
918     // Booleans are more expensive than uint256 or any type that takes up a full
919     // word because each write operation emits an extra SLOAD to first read the
920     // slot's contents, replace the bits taken up by the boolean, and then write
921     // back. This is the compiler's defense against contract upgrades and
922     // pointer aliasing, and it cannot be disabled.
923 
924     // The values being non-zero value makes deployment a bit more expensive,
925     // but in exchange the refund on every call to nonReentrant will be lower in
926     // amount. Since refunds are capped to a percentage of the total
927     // transaction's gas, it is best to keep them low in cases like this one, to
928     // increase the likelihood of the full refund coming into effect.
929     uint256 private constant _NOT_ENTERED = 1;
930     uint256 private constant _ENTERED = 2;
931 
932     uint256 private _status;
933 
934     constructor() {
935         _status = _NOT_ENTERED;
936     }
937 
938     /**
939      * @dev Prevents a contract from calling itself, directly or indirectly.
940      * Calling a `nonReentrant` function from another `nonReentrant`
941      * function is not supported. It is possible to prevent this from happening
942      * by making the `nonReentrant` function external, and making it call a
943      * `private` function that does the actual work.
944      */
945     modifier nonReentrant() {
946         // On the first call to nonReentrant, _notEntered will be true
947         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
948 
949         // Any calls to nonReentrant after this point will fail
950         _status = _ENTERED;
951 
952         _;
953 
954         // By storing the original value once again, a refund is triggered (see
955         // https://eips.ethereum.org/EIPS/eip-2200)
956         _status = _NOT_ENTERED;
957     }
958 }
959 
960 // 
961 /**
962 *  ______   __     __  __     __            ______   ______     ______   ______    
963 * /\  == \ /\ \   /\_\_\_\   /\ \          /\  == \ /\  ___\   /\__  _\ /\  ___\  
964 * \ \  _-/ \ \ \  \/_/\_\/_  \ \ \____     \ \  _-/ \ \  __\   \/_/\ \/ \ \___  \ 
965 *  \ \_\    \ \_\   /\_\/\_\  \ \_____\     \ \_\    \ \_____\    \ \_\  \/\_____\
966 *   \/_/     \/_/   \/_/\/_/   \/_____/      \/_/     \/_____/     \/_/   \/_____/ 
967 */
968 contract PixlPets is ERC721, Ownable, ReentrancyGuard {
969 
970     bool public IS_PUBLIC_SALE_ACTIVE = false;
971 
972     uint256 public constant FREE_MINT_MAPPING_ID = 0;
973     uint256 public constant PRESALE_MAPPING_ID = 1;
974     uint256 public constant PUBLIC_MAPPING_ID = 2;
975 
976     uint256 public constant MAX_PER_FREE_MINT = 1; 
977     uint256 public MAX_PER_PS_SPOT = 2;
978     uint256 public MAX_PER_PUBLIC_MINT = 10;
979     uint256 public PRESALE_MINT_PRICE = 0.088 ether;
980     uint256 public PUBLIC_MINT_PRICE = 0.12 ether;
981     uint256 public MAX_SUPPLY = 15000; 
982     uint256 public PHASE_ID = 1;
983 
984     bytes32 public presaleMerkleRoot;
985     bytes32 public freeMintMerkleRoot;
986 
987     string public baseURI;
988 
989     /** 
990     * @dev Allow for multiple "phases" of mints to take place on a single contract,
991     *  keeping track of wallet supply limits for each phase. 
992     */
993     mapping(uint => mapping(uint => mapping(address => uint))) public phaseToMappingIdToSupplyMap;
994 
995 
996     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
997         require(
998             price * numberOfTokens == msg.value,
999             "Incorrect ETH value sent"
1000         );
1001         _;
1002     }
1003 
1004     modifier hasAvailableSupply(uint256 potentialNewBalance, uint256 limit) {
1005         require(potentialNewBalance <= limit, 
1006             "Exceeds allocated supply for this user via attempted mint function.");
1007         _;
1008     }
1009 
1010     modifier isValidMerkleProof(bytes32 root, bytes32[] calldata proof) {
1011         require(_verify(msg.sender, root, proof), "Sender not in MerkleTree");
1012         _;
1013     }
1014 
1015 
1016     constructor(string memory _baseURI) ERC721("Pixl Pets", "PIXLP") {
1017         baseURI = _baseURI;
1018 
1019         address purgatory = 0x0000000000000000000000000000000000000000;
1020         _owners.push(purgatory); // Offest to create gas optimized 1-indexed id space
1021     }
1022 
1023 
1024     /******** Read-only Functions *********/
1025 
1026     function totalSupply() external view virtual returns (uint256) {
1027         return _owners.length - 1;
1028     }
1029 
1030     function tokenURI(uint256 _tokenId) external view override returns (string memory) {
1031         require(_exists(_tokenId), "Token does not exist.");
1032         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1033     }
1034 
1035     /** 
1036     * @dev Use in front end to render counts for user's Mint UI in single SC call,
1037     *   drastically reducing load on Infura for pageLoads:
1038     *   (numFreeMintsRemaining, numPresaleMintsRemaining, numPublicMintsRemaining, 
1039     *       totalMinted, totalRemainingSupply)
1040     */
1041     function getMintProgress(address userWallet, bytes32[] calldata freeMintProof, bytes32[] calldata presaleProof) 
1042         external 
1043         view 
1044         returns (uint, uint, uint, uint, uint) 
1045     {
1046         uint totalMinted = _owners.length - 1;
1047         uint freeMintsRemaining = 0;
1048         uint psMintsRemaining = 0;
1049         uint publicMintsRemaining = MAX_PER_PUBLIC_MINT 
1050             - phaseToMappingIdToSupplyMap[PHASE_ID][PUBLIC_MAPPING_ID][userWallet];
1051 
1052         if (_verify(userWallet, freeMintMerkleRoot, freeMintProof)) {
1053             freeMintsRemaining += (MAX_PER_FREE_MINT 
1054                 - phaseToMappingIdToSupplyMap[PHASE_ID][FREE_MINT_MAPPING_ID][userWallet]);
1055         }
1056         if (_verify(userWallet, presaleMerkleRoot, presaleProof)) { 
1057             psMintsRemaining += (MAX_PER_PS_SPOT 
1058                 - phaseToMappingIdToSupplyMap[PHASE_ID][PRESALE_MAPPING_ID][userWallet]);
1059         }
1060 
1061         return (
1062             freeMintsRemaining, 
1063             psMintsRemaining, 
1064             publicMintsRemaining, 
1065             totalMinted, 
1066             MAX_SUPPLY - totalMinted
1067         );
1068     }
1069 
1070 
1071     /******** Minting Functions *********/
1072 
1073     /** 
1074     * @dev Combine full free claim and presale in single transaction to save ~30k wei gas. 
1075     * @notice Congratulations!!! You're saving some gas by combining your free claim and WL mint txns!
1076     */
1077     function omegaMint(bytes32[] calldata freeMintProof, bytes32[] calldata presaleProof) 
1078         external 
1079         payable
1080         isCorrectPayment(PRESALE_MINT_PRICE, MAX_PER_PS_SPOT)
1081         hasAvailableSupply(
1082             phaseToMappingIdToSupplyMap[PHASE_ID][FREE_MINT_MAPPING_ID][msg.sender] + MAX_PER_FREE_MINT, 
1083             MAX_PER_FREE_MINT)
1084         hasAvailableSupply(
1085             phaseToMappingIdToSupplyMap[PHASE_ID][PRESALE_MAPPING_ID][msg.sender] + MAX_PER_PS_SPOT, 
1086             MAX_PER_PS_SPOT)
1087         isValidMerkleProof(presaleMerkleRoot, presaleProof)
1088         isValidMerkleProof(freeMintMerkleRoot, freeMintProof)
1089         nonReentrant
1090     {
1091         uint256 totalSupplySaveFunctionGas = _owners.length - 1;
1092         require(
1093             totalSupplySaveFunctionGas + MAX_PER_PS_SPOT + MAX_PER_FREE_MINT <= MAX_SUPPLY, 
1094             "Exceeds max supply, collection is sold out!"
1095         );
1096 
1097         phaseToMappingIdToSupplyMap[PHASE_ID][FREE_MINT_MAPPING_ID][msg.sender] += MAX_PER_FREE_MINT;
1098         phaseToMappingIdToSupplyMap[PHASE_ID][PRESALE_MAPPING_ID][msg.sender] += MAX_PER_PS_SPOT;
1099 
1100         for(uint i; i < MAX_PER_FREE_MINT + MAX_PER_PS_SPOT; i++) {
1101             _mint(msg.sender, totalSupplySaveFunctionGas + i + 1);
1102         }
1103     }
1104 
1105     /** 
1106     * @dev Check MerkleTree to see if able to claim, then GIMME THAT PIXL PET!!!
1107     * @notice Congratulations lucky Founder's Pass holder or giveaway winner: you've earned a free PIXL Pet! 
1108     */
1109     function claimFreeMint(bytes32[] calldata proof) 
1110         external 
1111         hasAvailableSupply(
1112             phaseToMappingIdToSupplyMap[PHASE_ID][FREE_MINT_MAPPING_ID][msg.sender] + 1,
1113             MAX_PER_FREE_MINT)
1114         isValidMerkleProof(freeMintMerkleRoot, proof)
1115         nonReentrant
1116     {
1117         uint256 totalSupplySaveFunctionGas = _owners.length - 1;
1118         require(
1119             totalSupplySaveFunctionGas + 1 <= MAX_SUPPLY, 
1120             "Exceeds max supply, should've claimed sooner :/"
1121         );
1122 
1123         phaseToMappingIdToSupplyMap[PHASE_ID][FREE_MINT_MAPPING_ID][msg.sender] += 1;
1124         _mint(msg.sender, totalSupplySaveFunctionGas + 1);
1125     }
1126     
1127     /** 
1128     * @dev Check preset MerkleRoot for inclusion of wallet in Presale set before minting up to .
1129     * @notice Congratulations lucky Founder's Pass holder or giveaway winner: you've earned PIXL Pet Presale spots! 
1130     */
1131     function presaleMint(uint256 amount, bytes32[] calldata proof) 
1132         external 
1133         payable 
1134         isCorrectPayment(PRESALE_MINT_PRICE, amount)
1135         hasAvailableSupply(
1136             phaseToMappingIdToSupplyMap[PHASE_ID][PRESALE_MAPPING_ID][msg.sender] + amount, 
1137             MAX_PER_PS_SPOT)
1138         isValidMerkleProof(presaleMerkleRoot, proof)
1139         nonReentrant
1140     {
1141         uint256 totalSupplySaveFunctionGas = _owners.length - 1;
1142         require(totalSupplySaveFunctionGas + amount <= MAX_SUPPLY, "Exceeds Max supply, Pixl Pets are sold out!");
1143         
1144         phaseToMappingIdToSupplyMap[PHASE_ID][PRESALE_MAPPING_ID][msg.sender] += amount;
1145         for(uint i; i < amount; i++) {
1146             _mint(msg.sender, totalSupplySaveFunctionGas + i + 1);
1147         }
1148     }
1149     
1150     function publicMint(uint256 amount) 
1151         external 
1152         payable
1153         isCorrectPayment(PUBLIC_MINT_PRICE, amount)
1154         hasAvailableSupply(
1155             phaseToMappingIdToSupplyMap[PHASE_ID][PUBLIC_MAPPING_ID][msg.sender] + amount, 
1156             MAX_PER_PUBLIC_MINT)
1157         nonReentrant
1158     {
1159         uint256 totalSupplySaveFunctionGas = _owners.length - 1;
1160         require(IS_PUBLIC_SALE_ACTIVE, 'Public sale is inactive! pls stop');
1161         require(totalSupplySaveFunctionGas + amount <= MAX_SUPPLY, "Exceeds max supply, Pixl Pets are sold out!");
1162 
1163         phaseToMappingIdToSupplyMap[PHASE_ID][PUBLIC_MAPPING_ID][msg.sender] += amount;
1164         for(uint i; i < amount; i++) { 
1165             _mint(msg.sender, totalSupplySaveFunctionGas + i + 1);
1166         }
1167     }
1168 
1169     function burn(uint256 tokenId) external { 
1170         require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved to burn.");
1171         _burn(tokenId);
1172     }
1173 
1174 
1175     /*********** ADMIN FUNCTIONS ************/
1176 
1177     function adminMint(uint256 amount, address _to) 
1178         external
1179         onlyOwner
1180     {
1181         uint256 totalSupplySaveFunctionGas = _owners.length - 1;
1182         require(totalSupplySaveFunctionGas + amount <= MAX_SUPPLY, "Exceeds max supply.");
1183     
1184         for(uint i; i < amount; i++) { 
1185             _mint(_to, totalSupplySaveFunctionGas + i + 1);
1186         }
1187     }
1188 
1189 
1190     /** @dev Will enable presale mints! */
1191     function setPresaleMerkleRoot(bytes32 _presaleMerkleRoot) external onlyOwner {
1192         presaleMerkleRoot = _presaleMerkleRoot;
1193     }
1194 
1195     /** @dev Will enable claimable free mints! */
1196     function setFreeMintMerkleRoot(bytes32 _freeMintMerkleRoot) external onlyOwner {
1197         freeMintMerkleRoot = _freeMintMerkleRoot;
1198     }
1199 
1200     function setBaseURI(string memory _baseURI) external onlyOwner {
1201         baseURI = _baseURI;
1202     }
1203 
1204     function updateMaxSupply(uint256 _MAX_SUPPLY) external onlyOwner {
1205         MAX_SUPPLY = _MAX_SUPPLY;
1206     }
1207 
1208     function toggleIsPublicSaleActive() external onlyOwner {
1209         IS_PUBLIC_SALE_ACTIVE = !IS_PUBLIC_SALE_ACTIVE;
1210     }
1211 
1212 
1213     function updateMaxPresaleSupply(uint256 _MAX_PER_PS_SPOT) external onlyOwner {
1214         MAX_PER_PS_SPOT = _MAX_PER_PS_SPOT;
1215     }
1216 
1217     function updateMaxPublicSupply(uint256 _MAX_PER_PUBLIC_MINT) external onlyOwner {
1218         MAX_PER_PUBLIC_MINT = _MAX_PER_PUBLIC_MINT;
1219     }
1220 
1221 
1222     /** @dev Value in wei (ether_value * (10 ** 18)) aka add 18 zeroes */
1223     function updatePresaleMintPrice(uint256 _PRESALE_MINT_PRICE) external onlyOwner {
1224         PRESALE_MINT_PRICE = _PRESALE_MINT_PRICE;
1225     }
1226 
1227     /** @dev Value in wei (ether_value * (10 ** 18)) aka add 18 zeroes */
1228     function updatePublicMintPrice(uint256 _PUBLIC_MINT_PRICE) external onlyOwner {
1229         PUBLIC_MINT_PRICE = _PUBLIC_MINT_PRICE;
1230     }
1231 
1232 
1233     /** @dev Effectively reset wallet supply mappings by allocating a new spot in memory */
1234     function incrementPhaseVersion()
1235         external
1236         onlyOwner
1237     {
1238         PHASE_ID += 1;
1239     }
1240 
1241     /** @dev Revert to a previous wallet supply mapping  */
1242     function decrementPhaseVersion()
1243         external
1244         onlyOwner
1245     {
1246         PHASE_ID -= 1;
1247     }
1248 
1249     function batchSafeTransferFrom(address _from, address _to, uint256[] memory _tokenIds, bytes memory data_) 
1250         external 
1251         onlyOwner
1252     {
1253         for (uint256 i = 0; i < _tokenIds.length; i++) {
1254             safeTransferFrom(_from, _to, _tokenIds[i], data_);
1255         }
1256     }
1257 
1258     function withdrawETH() external onlyOwner {
1259         (bool success, ) = (msg.sender).call{value: address(this).balance}("");
1260         require(success, "Failed to send ETH.");
1261     }
1262 
1263 
1264     /********** PRIVATE FUNCTIONS *********/
1265 
1266     function _mint(address to, uint256 tokenId) internal virtual override {
1267         _owners.push(to);
1268         emit Transfer(address(0), to, tokenId);
1269     }
1270     
1271     /** @dev Turn msg.sender into a string, hash it, and check if its valid within merkle root + proof */
1272     function _verify(
1273         address _buyerAddress, 
1274         bytes32 _merkleRoot, 
1275         bytes32[] memory _proof) internal pure returns (bool) {
1276         return _merkleRoot != 0 
1277             && MerkleProof.verify(_proof, _merkleRoot, keccak256(abi.encodePacked(_buyerAddress)));
1278     }
1279 
1280 }