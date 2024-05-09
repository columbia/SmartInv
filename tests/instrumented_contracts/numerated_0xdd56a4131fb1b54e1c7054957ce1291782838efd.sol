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
27 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and making it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
262  * @dev See https://eips.ethereum.org/EIPS/eip-721
263  */
264 interface IERC721Metadata is IERC721 {
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 
281 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
287  * @dev See https://eips.ethereum.org/EIPS/eip-721
288  */
289 interface IERC721Enumerable is IERC721 {
290     /**
291      * @dev Returns the total amount of tokens stored by the contract.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
297      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
298      */
299     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
300 
301     /**
302      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
303      * Use along with {totalSupply} to enumerate all tokens.
304      */
305     function tokenByIndex(uint256 index) external view returns (uint256);
306 }
307 
308 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Implementation of the {IERC165} interface.
341  *
342  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
343  * for the additional interface id that will be supported. For example:
344  *
345  * ```solidity
346  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
347  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
348  * }
349  * ```
350  *
351  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
352  */
353 abstract contract ERC165 is IERC165 {
354     /**
355      * @dev See {IERC165-supportsInterface}.
356      */
357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
358         return interfaceId == type(IERC165).interfaceId;
359     }
360 }
361 
362 pragma solidity ^0.8.6;
363 
364 library Address {
365     function isContract(address account) internal view returns (bool) {
366         uint size;
367         assembly {
368             size := extcodesize(account)
369         }
370         return size > 0;
371     }
372 }
373 
374 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev String operations.
380  */
381 library Strings {
382     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
386      */
387     function toString(uint256 value) internal pure returns (string memory) {
388         // Inspired by OraclizeAPI's implementation - MIT licence
389         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
390 
391         if (value == 0) {
392             return "0";
393         }
394         uint256 temp = value;
395         uint256 digits;
396         while (temp != 0) {
397             digits++;
398             temp /= 10;
399         }
400         bytes memory buffer = new bytes(digits);
401         while (value != 0) {
402             digits -= 1;
403             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
404             value /= 10;
405         }
406         return string(buffer);
407     }
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
411      */
412     function toHexString(uint256 value) internal pure returns (string memory) {
413         if (value == 0) {
414             return "0x00";
415         }
416         uint256 temp = value;
417         uint256 length = 0;
418         while (temp != 0) {
419             length++;
420             temp >>= 8;
421         }
422         return toHexString(value, length);
423     }
424 
425     /**
426      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
427      */
428     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
429         bytes memory buffer = new bytes(2 * length + 2);
430         buffer[0] = "0";
431         buffer[1] = "x";
432         for (uint256 i = 2 * length + 1; i > 1; --i) {
433             buffer[i] = _HEX_SYMBOLS[value & 0xf];
434             value >>= 4;
435         }
436         require(value == 0, "Strings: hex length insufficient");
437         return string(buffer);
438     }
439 }
440 
441 pragma solidity ^0.8.7;
442 
443 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
444     using Address for address;
445     using Strings for uint256;
446     
447     string private _name;
448     string private _symbol;
449 
450     // Mapping from token ID to owner address
451     address[] internal _owners;
452 
453     mapping(uint256 => address) private _tokenApprovals;
454     mapping(address => mapping(address => bool)) private _operatorApprovals;
455 
456     /**
457      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
458      */
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462     }
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId)
468         public
469         view
470         virtual
471         override(ERC165, IERC165)
472         returns (bool)
473     {
474         return
475             interfaceId == type(IERC721).interfaceId ||
476             interfaceId == type(IERC721Metadata).interfaceId ||
477             super.supportsInterface(interfaceId);
478     }
479 
480     /**
481      * @dev See {IERC721-balanceOf}.
482      */
483     function balanceOf(address owner) 
484         public 
485         view 
486         virtual 
487         override 
488         returns (uint) 
489     {
490         require(owner != address(0), "ERC721: balance query for the zero address");
491 
492         uint count;
493         for( uint i; i < _owners.length; ++i ){
494           if( owner == _owners[i] )
495             ++count;
496         }
497         return count;
498     }
499 
500     /**
501      * @dev See {IERC721-ownerOf}.
502      */
503     function ownerOf(uint256 tokenId)
504         public
505         view
506         virtual
507         override
508         returns (address)
509     {
510         address owner = _owners[tokenId];
511         require(
512             owner != address(0),
513             "ERC721: owner query for nonexistent token"
514         );
515         return owner;
516     }
517 
518     /**
519      * @dev See {IERC721Metadata-name}.
520      */
521     function name() public view virtual override returns (string memory) {
522         return _name;
523     }
524 
525     /**
526      * @dev See {IERC721Metadata-symbol}.
527      */
528     function symbol() public view virtual override returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev See {IERC721-approve}.
534      */
535     function approve(address to, uint256 tokenId) public virtual override {
536         address owner = ERC721.ownerOf(tokenId);
537         require(to != owner, "ERC721: approval to current owner");
538 
539         require(
540             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
541             "ERC721: approve caller is not owner nor approved for all"
542         );
543 
544         _approve(to, tokenId);
545     }
546 
547     /**
548      * @dev See {IERC721-getApproved}.
549      */
550     function getApproved(uint256 tokenId)
551         public
552         view
553         virtual
554         override
555         returns (address)
556     {
557         require(
558             _exists(tokenId),
559             "ERC721: approved query for nonexistent token"
560         );
561 
562         return _tokenApprovals[tokenId];
563     }
564 
565     /**
566      * @dev See {IERC721-setApprovalForAll}.
567      */
568     function setApprovalForAll(address operator, bool approved)
569         public
570         virtual
571         override
572     {
573         require(operator != _msgSender(), "ERC721: approve to caller");
574 
575         _operatorApprovals[_msgSender()][operator] = approved;
576         emit ApprovalForAll(_msgSender(), operator, approved);
577     }
578 
579     /**
580      * @dev See {IERC721-isApprovedForAll}.
581      */
582     function isApprovedForAll(address owner, address operator)
583         public
584         view
585         virtual
586         override
587         returns (bool)
588     {
589         return _operatorApprovals[owner][operator];
590     }
591 
592     /**
593      * @dev See {IERC721-transferFrom}.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) public virtual override {
600         //solhint-disable-next-line max-line-length
601         require(
602             _isApprovedOrOwner(_msgSender(), tokenId),
603             "ERC721: transfer caller is not owner nor approved"
604         );
605 
606         _transfer(from, to, tokenId);
607     }
608 
609     /**
610      * @dev See {IERC721-safeTransferFrom}.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) public virtual override {
617         safeTransferFrom(from, to, tokenId, "");
618     }
619 
620     /**
621      * @dev See {IERC721-safeTransferFrom}.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId,
627         bytes memory _data
628     ) public virtual override {
629         require(
630             _isApprovedOrOwner(_msgSender(), tokenId),
631             "ERC721: transfer caller is not owner nor approved"
632         );
633         _safeTransfer(from, to, tokenId, _data);
634     }
635 
636     /**
637      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
638      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
639      *
640      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
641      *
642      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
643      * implement alternative mechanisms to perform token transfer, such as signature-based.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function _safeTransfer(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes memory _data
659     ) internal virtual {
660         _transfer(from, to, tokenId);
661         require(
662             _checkOnERC721Received(from, to, tokenId, _data),
663             "ERC721: transfer to non ERC721Receiver implementer"
664         );
665     }
666 
667     /**
668      * @dev Returns whether `tokenId` exists.
669      *
670      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
671      *
672      * Tokens start existing when they are minted (`_mint`),
673      * and stop existing when they are burned (`_burn`).
674      */
675     function _exists(uint256 tokenId) internal view virtual returns (bool) {
676         return tokenId < _owners.length && _owners[tokenId] != address(0);
677     }
678 
679     /**
680      * @dev Returns whether `spender` is allowed to manage `tokenId`.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function _isApprovedOrOwner(address spender, uint256 tokenId)
687         internal
688         view
689         virtual
690         returns (bool)
691     {
692         require(
693             _exists(tokenId),
694             "ERC721: operator query for nonexistent token"
695         );
696         address owner = ERC721.ownerOf(tokenId);
697         return (spender == owner ||
698             getApproved(tokenId) == spender ||
699             isApprovedForAll(owner, spender));
700     }
701 
702     /**
703      * @dev Safely mints `tokenId` and transfers it to `to`.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must not exist.
708      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
709      *
710      * Emits a {Transfer} event.
711      */
712     function _safeMint(address to, uint256 tokenId) internal virtual {
713         _safeMint(to, tokenId, "");
714     }
715 
716     /**
717      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
718      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
719      */
720     function _safeMint(
721         address to,
722         uint256 tokenId,
723         bytes memory _data
724     ) internal virtual {
725         _mint(to, tokenId);
726         require(
727             _checkOnERC721Received(address(0), to, tokenId, _data),
728             "ERC721: transfer to non ERC721Receiver implementer"
729         );
730     }
731 
732     /**
733      * @dev Mints `tokenId` and transfers it to `to`.
734      *
735      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
736      *
737      * Requirements:
738      *
739      * - `tokenId` must not exist.
740      * - `to` cannot be the zero address.
741      *
742      * Emits a {Transfer} event.
743      */
744     function _mint(address to, uint256 tokenId) internal virtual {
745         require(to != address(0), "ERC721: mint to the zero address");
746         require(!_exists(tokenId), "ERC721: token already minted");
747 
748         _beforeTokenTransfer(address(0), to, tokenId);
749         _owners.push(to);
750 
751         emit Transfer(address(0), to, tokenId);
752     }
753 
754     /**
755      * @dev Destroys `tokenId`.
756      * The approval is cleared when the token is burned.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _burn(uint256 tokenId) internal virtual {
765         address owner = ERC721.ownerOf(tokenId);
766 
767         _beforeTokenTransfer(owner, address(0), tokenId);
768 
769         // Clear approvals
770         _approve(address(0), tokenId);
771         _owners[tokenId] = address(0);
772 
773         emit Transfer(owner, address(0), tokenId);
774     }
775 
776     /**
777      * @dev Transfers `tokenId` from `from` to `to`.
778      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
779      *
780      * Requirements:
781      *
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _transfer(
788         address from,
789         address to,
790         uint256 tokenId
791     ) internal virtual {
792         require(
793             ERC721.ownerOf(tokenId) == from,
794             "ERC721: transfer of token that is not own"
795         );
796         require(to != address(0), "ERC721: transfer to the zero address");
797 
798         _beforeTokenTransfer(from, to, tokenId);
799 
800         // Clear approvals from the previous owner
801         _approve(address(0), tokenId);
802         _owners[tokenId] = to;
803 
804         emit Transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev Approve `to` to operate on `tokenId`
809      *
810      * Emits a {Approval} event.
811      */
812     function _approve(address to, uint256 tokenId) internal virtual {
813         _tokenApprovals[tokenId] = to;
814         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
815     }
816 
817     /**
818      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
819      * The call is not executed if the target address is not a contract.
820      *
821      * @param from address representing the previous owner of the given token ID
822      * @param to target address that will receive the tokens
823      * @param tokenId uint256 ID of the token to be transferred
824      * @param _data bytes optional data to send along with the call
825      * @return bool whether the call correctly returned the expected magic value
826      */
827     function _checkOnERC721Received(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) private returns (bool) {
833         if (to.isContract()) {
834             try
835                 IERC721Receiver(to).onERC721Received(
836                     _msgSender(),
837                     from,
838                     tokenId,
839                     _data
840                 )
841             returns (bytes4 retval) {
842                 return retval == IERC721Receiver.onERC721Received.selector;
843             } catch (bytes memory reason) {
844                 if (reason.length == 0) {
845                     revert(
846                         "ERC721: transfer to non ERC721Receiver implementer"
847                     );
848                 } else {
849                     assembly {
850                         revert(add(32, reason), mload(reason))
851                     }
852                 }
853             }
854         } else {
855             return true;
856         }
857     }
858 
859     /**
860      * @dev Hook that is called before any token transfer. This includes minting
861      * and burning.
862      *
863      * Calling conditions:
864      *
865      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
866      * transferred to `to`.
867      * - When `from` is zero, `tokenId` will be minted for `to`.
868      * - When `to` is zero, ``from``'s `tokenId` will be burned.
869      * - `from` and `to` are never both zero.
870      *
871      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
872      */
873     function _beforeTokenTransfer(
874         address from,
875         address to,
876         uint256 tokenId
877     ) internal virtual {}
878 }
879 
880 pragma solidity ^0.8.7;
881 
882 /**
883  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
884  * enumerability of all the token ids in the contract as well as all token ids owned by each
885  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
886  */
887 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      */
891     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
892         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
893     }
894 
895     /**
896      * @dev See {IERC721Enumerable-totalSupply}.
897      */
898     function totalSupply() public view virtual override returns (uint256) {
899         return _owners.length;
900     }
901 
902     /**
903      * @dev See {IERC721Enumerable-tokenByIndex}.
904      */
905     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
906         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
907         return index;
908     }
909 
910     /**
911      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
914         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
915 
916         uint count;
917         for(uint i; i < _owners.length; i++){
918             if(owner == _owners[i]){
919                 if(count == index) return i;
920                 else count++;
921             }
922         }
923 
924         revert("ERC721Enumerable: owner index out of bounds");
925     }
926 }
927 
928 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 /**
933  * @dev Contract module which provides a basic access control mechanism, where
934  * there is an account (an owner) that can be granted exclusive access to
935  * specific functions.
936  *
937  * By default, the owner account will be the one that deploys the contract. This
938  * can later be changed with {transferOwnership}.
939  *
940  * This module is used through inheritance. It will make available the modifier
941  * `onlyOwner`, which can be applied to your functions to restrict their use to
942  * the owner.
943  */
944 abstract contract Ownable is Context {
945     address private _owner;
946 
947     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
948 
949     /**
950      * @dev Initializes the contract setting the deployer as the initial owner.
951      */
952     constructor() {
953         _transferOwnership(_msgSender());
954     }
955 
956     /**
957      * @dev Returns the address of the current owner.
958      */
959     function owner() public view virtual returns (address) {
960         return _owner;
961     }
962 
963     /**
964      * @dev Throws if called by any account other than the owner.
965      */
966     modifier onlyOwner() {
967         require(owner() == _msgSender(), "Ownable: caller is not the owner");
968         _;
969     }
970 
971     /**
972      * @dev Leaves the contract without owner. It will not be possible to call
973      * `onlyOwner` functions anymore. Can only be called by the current owner.
974      *
975      * NOTE: Renouncing ownership will leave the contract without an owner,
976      * thereby removing any functionality that is only available to the owner.
977      */
978     function renounceOwnership() public virtual onlyOwner {
979         _transferOwnership(address(0));
980     }
981 
982     /**
983      * @dev Transfers ownership of the contract to a new account (`newOwner`).
984      * Can only be called by the current owner.
985      */
986     function transferOwnership(address newOwner) public virtual onlyOwner {
987         require(newOwner != address(0), "Ownable: new owner is the zero address");
988         _transferOwnership(newOwner);
989     }
990 
991     /**
992      * @dev Transfers ownership of the contract to a new account (`newOwner`).
993      * Internal function without access restriction.
994      */
995     function _transferOwnership(address newOwner) internal virtual {
996         address oldOwner = _owner;
997         _owner = newOwner;
998         emit OwnershipTransferred(oldOwner, newOwner);
999     }
1000 }
1001 
1002 pragma solidity ^0.8.11;
1003 pragma abicoder v2;
1004 
1005 contract Infernals is ERC721Enumerable, Ownable, ReentrancyGuard {
1006   bool                        public          infernalsUnleashed = false;
1007   string                      public          baseURI;
1008   uint                        public constant INFERNAL_SPAWN_RATE = 2;
1009   uint256                     public constant INFERNAL_MAYHEM = 5000;
1010   mapping(address => uint256) public          CAPTURED_INFERNALS;
1011     
1012   constructor() ERC721("The Infernals", "INFERNAL") {
1013     setBaseURI("ipfs://QmfRZJGZcQs5KR445eBGzWk7h8g9nTe1xwSLRsWGRz6MHZ/");
1014     _mint(msg.sender, totalSupply());
1015   }
1016     
1017   function withdraw() external onlyOwner nonReentrant {
1018     uint256 balance = address(this).balance;
1019     require(balance > 0);
1020 
1021     (bool ownerSuccess, ) = msg.sender.call{value: address(this).balance}("");
1022     require(ownerSuccess, "NO! INFERNAL CRUSH!");
1023   }
1024 
1025   function setBaseURI(string memory _baseURI) public onlyOwner {
1026     baseURI = _baseURI;
1027   }
1028 
1029   function unleashInfernalMayhem() external onlyOwner {
1030     infernalsUnleashed = !infernalsUnleashed;
1031   }
1032   
1033   function spawnInfernal(uint spawns) external payable nonReentrant {
1034     require(infernalsUnleashed, "INFERNALS CAGED");
1035     require(spawns <= INFERNAL_SPAWN_RATE, "TOO MANY INFERNAL CRUSH YOU");
1036     require(CAPTURED_INFERNALS[msg.sender] + spawns <= INFERNAL_SPAWN_RATE, "TOO MANY INFERNAL");
1037     require(totalSupply() + spawns <= INFERNAL_MAYHEM, "INFERNALS HAVE TAKEN OVER");
1038     
1039     CAPTURED_INFERNALS[msg.sender] += spawns;
1040     for(uint i = 0; i < spawns; i++) {
1041       _mint(msg.sender, totalSupply());
1042     }
1043   }
1044 
1045   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1046     require(_exists(_tokenId), "INFERNAL PERISHED");
1047     return string(abi.encodePacked(baseURI, Strings.toString(_tokenId)));
1048   }
1049 
1050   function infernalRise(address _to, uint256 numberOfSpawns) external onlyOwner {
1051     uint256 infernalPopulation = totalSupply();
1052     require(infernalPopulation + numberOfSpawns <= INFERNAL_MAYHEM, "INFERNAL OVERLOAD");
1053     for (uint256 i; i < numberOfSpawns; i++) {
1054       _safeMint(_to, infernalPopulation + i);
1055     }
1056   }
1057 }