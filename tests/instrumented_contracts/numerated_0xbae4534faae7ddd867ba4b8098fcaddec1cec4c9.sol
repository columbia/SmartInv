1 // SPDX-License-Identifier: MIT
2 
3 // Created by: Darknezz Dev Team
4 // Contract ERC721A From: Chiru Labs
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId,
86         bytes calldata data
87     ) external;
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
131      * The approval is cleared when the token is transferred.
132      *
133      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
134      *
135      * Requirements:
136      *
137      * - The caller must own the token or be an approved operator.
138      * - `tokenId` must exist.
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address to, uint256 tokenId) external;
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns the account approved for `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function getApproved(uint256 tokenId) external view returns (address operator);
164 
165     /**
166      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
167      *
168      * See {setApprovalForAll}
169      */
170     function isApprovedForAll(address owner, address operator) external view returns (bool);
171 }
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Metadata is IERC721 {
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
196      */
197     function tokenURI(uint256 tokenId) external view returns (string memory);
198 }
199 
200 
201 
202 // ERC721A Contracts v3.3.0
203 // Creator: Chiru Labs
204 
205 pragma solidity ^0.8.4;
206 
207 
208 
209 /**
210  * @dev Interface of an ERC721A compliant contract.
211  */
212 interface IERC721A is IERC721, IERC721Metadata {
213     /**
214      * The caller must own the token or be an approved operator.
215      */
216     error ApprovalCallerNotOwnerNorApproved();
217 
218     /**
219      * The token does not exist.
220      */
221     error ApprovalQueryForNonexistentToken();
222 
223     /**
224      * The caller cannot approve to their own address.
225      */
226     error ApproveToCaller();
227 
228     /**
229      * The caller cannot approve to the current owner.
230      */
231     error ApprovalToCurrentOwner();
232 
233     /**
234      * Cannot query the balance for the zero address.
235      */
236     error BalanceQueryForZeroAddress();
237 
238     /**
239      * Cannot mint to the zero address.
240      */
241     error MintToZeroAddress();
242 
243     /**
244      * The quantity of tokens minted must be more than zero.
245      */
246     error MintZeroQuantity();
247 
248     /**
249      * The token does not exist.
250      */
251     error OwnerQueryForNonexistentToken();
252 
253     /**
254      * The caller must own the token or be an approved operator.
255      */
256     error TransferCallerNotOwnerNorApproved();
257 
258     /**
259      * The token must be owned by `from`.
260      */
261     error TransferFromIncorrectOwner();
262 
263     /**
264      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
265      */
266     error TransferToNonERC721ReceiverImplementer();
267 
268     /**
269      * Cannot transfer to the zero address.
270      */
271     error TransferToZeroAddress();
272 
273     /**
274      * The token does not exist.
275      */
276     error URIQueryForNonexistentToken();
277 
278     // Compiler will pack this into a single 256bit word.
279     struct TokenOwnership {
280         // The address of the owner.
281         address addr;
282         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
283         uint64 startTimestamp;
284         // Whether the token has been burned.
285         bool burned;
286     }
287 
288     // Compiler will pack this into a single 256bit word.
289     struct AddressData {
290         // Realistically, 2**64-1 is more than enough.
291         uint64 balance;
292         // Keeps track of mint count with minimal overhead for tokenomics.
293         uint64 numberMinted;
294         // Keeps track of burn count with minimal overhead for tokenomics.
295         uint64 numberBurned;
296         // For miscellaneous variable(s) pertaining to the address
297         // (e.g. number of whitelist mint slots used).
298         // If there are multiple variables, please pack them into a uint64.
299         uint64 aux;
300     }
301 
302     /**
303      * @dev Returns the total amount of tokens stored by the contract.
304      * 
305      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
306      */
307     function totalSupply() external view returns (uint256);
308 }
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Provides information about the current execution context, including the
317  * sender of the transaction and its data. While these are generally available
318  * via msg.sender and msg.data, they should not be accessed in such a direct
319  * manner, since when dealing with meta-transactions the account sending and
320  * paying for execution may not be the actual sender (as far as an application
321  * is concerned).
322  *
323  * This contract is only required for intermediate, library-like contracts.
324  */
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 
340 
341 /**
342  * @dev Implementation of the {IERC165} interface.
343  *
344  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
345  * for the additional interface id that will be supported. For example:
346  *
347  * ```solidity
348  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
349  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
350  * }
351  * ```
352  *
353  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
354  */
355 abstract contract ERC165 is IERC165 {
356     /**
357      * @dev See {IERC165-supportsInterface}.
358      */
359     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360         return interfaceId == type(IERC165).interfaceId;
361     }
362 }
363 
364 // ERC721A Contracts v3.3.0
365 // Creator: Chiru Labs
366 
367 pragma solidity ^0.8.4;
368 
369 
370 /**
371  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
372  * the Metadata extension. Built to optimize for lower gas during batch mints.
373  *
374  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
375  *
376  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
377  *
378  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
379  */
380 contract ERC721A is Context, ERC165, IERC721A {
381     using Address for address;
382     using Strings for uint256;
383 
384     // The tokenId of the next token to be minted.
385     uint256 internal _currentIndex;
386 
387     // The number of tokens burned.
388     uint256 internal _burnCounter;
389 
390     // Token name
391     string private _name;
392 
393     // Token symbol
394     string private _symbol;
395 
396     // Mapping from token ID to ownership details
397     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
398     mapping(uint256 => TokenOwnership) internal _ownerships;
399 
400     // Mapping owner address to address data
401     mapping(address => AddressData) private _addressData;
402 
403     // Mapping from token ID to approved address
404     mapping(uint256 => address) private _tokenApprovals;
405 
406     // Mapping from owner to operator approvals
407     mapping(address => mapping(address => bool)) private _operatorApprovals;
408 
409     constructor(string memory name_, string memory symbol_) {
410         _name = name_;
411         _symbol = symbol_;
412         _currentIndex = _startTokenId();
413     }
414 
415     /**
416      * To change the starting tokenId, please override this function.
417      */
418     function _startTokenId() internal view virtual returns (uint256) {
419         return 0;
420     }
421 
422     /**
423      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
424      */
425     function totalSupply() public view override returns (uint256) {
426         // Counter underflow is impossible as _burnCounter cannot be incremented
427         // more than _currentIndex - _startTokenId() times
428         unchecked {
429             return _currentIndex - _burnCounter - _startTokenId();
430         }
431     }
432 
433     /**
434      * Returns the total amount of tokens minted in the contract.
435      */
436     function _totalMinted() internal view returns (uint256) {
437         // Counter underflow is impossible as _currentIndex does not decrement,
438         // and it is initialized to _startTokenId()
439         unchecked {
440             return _currentIndex - _startTokenId();
441         }
442     }
443 
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
448         return
449             interfaceId == type(IERC721).interfaceId ||
450             interfaceId == type(IERC721Metadata).interfaceId ||
451             super.supportsInterface(interfaceId);
452     }
453 
454     /**
455      * @dev See {IERC721-balanceOf}.
456      */
457     function balanceOf(address owner) public view override returns (uint256) {
458         if (owner == address(0)) revert BalanceQueryForZeroAddress();
459         return uint256(_addressData[owner].balance);
460     }
461 
462     /**
463      * Returns the number of tokens minted by `owner`.
464      */
465     function _numberMinted(address owner) internal view returns (uint256) {
466         return uint256(_addressData[owner].numberMinted);
467     }
468 
469     /**
470      * Returns the number of tokens burned by or on behalf of `owner`.
471      */
472     function _numberBurned(address owner) internal view returns (uint256) {
473         return uint256(_addressData[owner].numberBurned);
474     }
475 
476     /**
477      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
478      */
479     function _getAux(address owner) internal view returns (uint64) {
480         return _addressData[owner].aux;
481     }
482 
483     /**
484      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
485      * If there are multiple variables, please pack them into a uint64.
486      */
487     function _setAux(address owner, uint64 aux) internal {
488         _addressData[owner].aux = aux;
489     }
490 
491     /**
492      * Gas spent here starts off proportional to the maximum mint batch size.
493      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
494      */
495     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
496         uint256 curr = tokenId;
497 
498         unchecked {
499             if (_startTokenId() <= curr) if (curr < _currentIndex) {
500                 TokenOwnership memory ownership = _ownerships[curr];
501                 if (!ownership.burned) {
502                     if (ownership.addr != address(0)) {
503                         return ownership;
504                     }
505                     // Invariant:
506                     // There will always be an ownership that has an address and is not burned
507                     // before an ownership that does not have an address and is not burned.
508                     // Hence, curr will not underflow.
509                     while (true) {
510                         curr--;
511                         ownership = _ownerships[curr];
512                         if (ownership.addr != address(0)) {
513                             return ownership;
514                         }
515                     }
516                 }
517             }
518         }
519         revert OwnerQueryForNonexistentToken();
520     }
521 
522     /**
523      * @dev See {IERC721-ownerOf}.
524      */
525     function ownerOf(uint256 tokenId) public view override returns (address) {
526         return _ownershipOf(tokenId).addr;
527     }
528 
529     /**
530      * @dev See {IERC721Metadata-name}.
531      */
532     function name() public view virtual override returns (string memory) {
533         return _name;
534     }
535 
536     /**
537      * @dev See {IERC721Metadata-symbol}.
538      */
539     function symbol() public view virtual override returns (string memory) {
540         return _symbol;
541     }
542 
543     /**
544      * @dev See {IERC721Metadata-tokenURI}.
545      */
546     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
547         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
548 
549         string memory baseURI = _baseURI();
550         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
551     }
552 
553     /**
554      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
555      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
556      * by default, can be overriden in child contracts.
557      */
558     function _baseURI() internal view virtual returns (string memory) {
559         return '';
560     }
561 
562     /**
563      * @dev See {IERC721-approve}.
564      */
565     function approve(address to, uint256 tokenId) public override {
566         address owner = ERC721A.ownerOf(tokenId);
567         if (to == owner) revert ApprovalToCurrentOwner();
568 
569         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
570             revert ApprovalCallerNotOwnerNorApproved();
571         }
572 
573         _approve(to, tokenId, owner);
574     }
575 
576     /**
577      * @dev See {IERC721-getApproved}.
578      */
579     function getApproved(uint256 tokenId) public view override returns (address) {
580         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
581 
582         return _tokenApprovals[tokenId];
583     }
584 
585     /**
586      * @dev See {IERC721-setApprovalForAll}.
587      */
588     function setApprovalForAll(address operator, bool approved) public virtual override {
589         if (operator == _msgSender()) revert ApproveToCaller();
590 
591         _operatorApprovals[_msgSender()][operator] = approved;
592         emit ApprovalForAll(_msgSender(), operator, approved);
593     }
594 
595     /**
596      * @dev See {IERC721-isApprovedForAll}.
597      */
598     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
599         return _operatorApprovals[owner][operator];
600     }
601 
602     /**
603      * @dev See {IERC721-transferFrom}.
604      */
605     function transferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) public virtual override {
610         _transfer(from, to, tokenId);
611     }
612 
613     /**
614      * @dev See {IERC721-safeTransferFrom}.
615      */
616     function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) public virtual override {
621         safeTransferFrom(from, to, tokenId, '');
622     }
623 
624     /**
625      * @dev See {IERC721-safeTransferFrom}.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes memory _data
632     ) public virtual override {
633         _transfer(from, to, tokenId);
634         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
635             revert TransferToNonERC721ReceiverImplementer();
636         }
637     }
638 
639     /**
640      * @dev Returns whether `tokenId` exists.
641      *
642      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
643      *
644      * Tokens start existing when they are minted (`_mint`),
645      */
646     function _exists(uint256 tokenId) internal view returns (bool) {
647         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
648     }
649 
650     /**
651      * @dev Equivalent to `_safeMint(to, quantity, '')`.
652      */
653     function _safeMint(address to, uint256 quantity) internal {
654         _safeMint(to, quantity, '');
655     }
656 
657     /**
658      * @dev Safely mints `quantity` tokens and transfers them to `to`.
659      *
660      * Requirements:
661      *
662      * - If `to` refers to a smart contract, it must implement
663      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
664      * - `quantity` must be greater than 0.
665      *
666      * Emits a {Transfer} event.
667      */
668     function _safeMint(
669         address to,
670         uint256 quantity,
671         bytes memory _data
672     ) internal {
673         uint256 startTokenId = _currentIndex;
674         if (to == address(0)) revert MintToZeroAddress();
675         if (quantity == 0) revert MintZeroQuantity();
676 
677         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
678 
679         // Overflows are incredibly unrealistic.
680         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
681         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
682         unchecked {
683             _addressData[to].balance += uint64(quantity);
684             _addressData[to].numberMinted += uint64(quantity);
685 
686             _ownerships[startTokenId].addr = to;
687             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
688 
689             uint256 updatedIndex = startTokenId;
690             uint256 end = updatedIndex + quantity;
691 
692             if (to.isContract()) {
693                 do {
694                     emit Transfer(address(0), to, updatedIndex);
695                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
696                         revert TransferToNonERC721ReceiverImplementer();
697                     }
698                 } while (updatedIndex < end);
699                 // Reentrancy protection
700                 if (_currentIndex != startTokenId) revert();
701             } else {
702                 do {
703                     emit Transfer(address(0), to, updatedIndex++);
704                 } while (updatedIndex < end);
705             }
706             _currentIndex = updatedIndex;
707         }
708         _afterTokenTransfers(address(0), to, startTokenId, quantity);
709     }
710 
711     /**
712      * @dev Mints `quantity` tokens and transfers them to `to`.
713      *
714      * Requirements:
715      *
716      * - `to` cannot be the zero address.
717      * - `quantity` must be greater than 0.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _mint(address to, uint256 quantity) internal {
722         uint256 startTokenId = _currentIndex;
723         if (to == address(0)) revert MintToZeroAddress();
724         if (quantity == 0) revert MintZeroQuantity();
725 
726         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
727 
728         // Overflows are incredibly unrealistic.
729         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
730         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
731         unchecked {
732             _addressData[to].balance += uint64(quantity);
733             _addressData[to].numberMinted += uint64(quantity);
734 
735             _ownerships[startTokenId].addr = to;
736             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
737 
738             uint256 updatedIndex = startTokenId;
739             uint256 end = updatedIndex + quantity;
740 
741             do {
742                 emit Transfer(address(0), to, updatedIndex++);
743             } while (updatedIndex < end);
744 
745             _currentIndex = updatedIndex;
746         }
747         _afterTokenTransfers(address(0), to, startTokenId, quantity);
748     }
749 
750     /**
751      * @dev Transfers `tokenId` from `from` to `to`.
752      *
753      * Requirements:
754      *
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must be owned by `from`.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _transfer(
761         address from,
762         address to,
763         uint256 tokenId
764     ) private {
765         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
766 
767         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
768 
769         bool isApprovedOrOwner = (_msgSender() == from ||
770             isApprovedForAll(from, _msgSender()) ||
771             getApproved(tokenId) == _msgSender());
772 
773         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
774         if (to == address(0)) revert TransferToZeroAddress();
775 
776         _beforeTokenTransfers(from, to, tokenId, 1);
777 
778         // Clear approvals from the previous owner
779         _approve(address(0), tokenId, from);
780 
781         // Underflow of the sender's balance is impossible because we check for
782         // ownership above and the recipient's balance can't realistically overflow.
783         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
784         unchecked {
785             _addressData[from].balance -= 1;
786             _addressData[to].balance += 1;
787 
788             TokenOwnership storage currSlot = _ownerships[tokenId];
789             currSlot.addr = to;
790             currSlot.startTimestamp = uint64(block.timestamp);
791 
792             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
793             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
794             uint256 nextTokenId = tokenId + 1;
795             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
796             if (nextSlot.addr == address(0)) {
797                 // This will suffice for checking _exists(nextTokenId),
798                 // as a burned slot cannot contain the zero address.
799                 if (nextTokenId != _currentIndex) {
800                     nextSlot.addr = from;
801                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
802                 }
803             }
804         }
805 
806         emit Transfer(from, to, tokenId);
807         _afterTokenTransfers(from, to, tokenId, 1);
808     }
809 
810     /**
811      * @dev Equivalent to `_burn(tokenId, false)`.
812      */
813     function _burn(uint256 tokenId) internal virtual {
814         _burn(tokenId, false);
815     }
816 
817     /**
818      * @dev Destroys `tokenId`.
819      * The approval is cleared when the token is burned.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
828         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
829 
830         address from = prevOwnership.addr;
831 
832         if (approvalCheck) {
833             bool isApprovedOrOwner = (_msgSender() == from ||
834                 isApprovedForAll(from, _msgSender()) ||
835                 getApproved(tokenId) == _msgSender());
836 
837             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
838         }
839 
840         _beforeTokenTransfers(from, address(0), tokenId, 1);
841 
842         // Clear approvals from the previous owner
843         _approve(address(0), tokenId, from);
844 
845         // Underflow of the sender's balance is impossible because we check for
846         // ownership above and the recipient's balance can't realistically overflow.
847         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
848         unchecked {
849             AddressData storage addressData = _addressData[from];
850             addressData.balance -= 1;
851             addressData.numberBurned += 1;
852 
853             // Keep track of who burned the token, and the timestamp of burning.
854             TokenOwnership storage currSlot = _ownerships[tokenId];
855             currSlot.addr = from;
856             currSlot.startTimestamp = uint64(block.timestamp);
857             currSlot.burned = true;
858 
859             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
860             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
861             uint256 nextTokenId = tokenId + 1;
862             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
863             if (nextSlot.addr == address(0)) {
864                 // This will suffice for checking _exists(nextTokenId),
865                 // as a burned slot cannot contain the zero address.
866                 if (nextTokenId != _currentIndex) {
867                     nextSlot.addr = from;
868                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
869                 }
870             }
871         }
872 
873         emit Transfer(from, address(0), tokenId);
874         _afterTokenTransfers(from, address(0), tokenId, 1);
875 
876         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
877         unchecked {
878             _burnCounter++;
879         }
880     }
881 
882     /**
883      * @dev Approve `to` to operate on `tokenId`
884      *
885      * Emits a {Approval} event.
886      */
887     function _approve(
888         address to,
889         uint256 tokenId,
890         address owner
891     ) private {
892         _tokenApprovals[tokenId] = to;
893         emit Approval(owner, to, tokenId);
894     }
895 
896     /**
897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
898      *
899      * @param from address representing the previous owner of the given token ID
900      * @param to target address that will receive the tokens
901      * @param tokenId uint256 ID of the token to be transferred
902      * @param _data bytes optional data to send along with the call
903      * @return bool whether the call correctly returned the expected magic value
904      */
905     function _checkContractOnERC721Received(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) private returns (bool) {
911         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
912             return retval == IERC721Receiver(to).onERC721Received.selector;
913         } catch (bytes memory reason) {
914             if (reason.length == 0) {
915                 revert TransferToNonERC721ReceiverImplementer();
916             } else {
917                 assembly {
918                     revert(add(32, reason), mload(reason))
919                 }
920             }
921         }
922     }
923 
924     /**
925      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
926      * And also called before burning one token.
927      *
928      * startTokenId - the first token id to be transferred
929      * quantity - the amount to be transferred
930      *
931      * Calling conditions:
932      *
933      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
934      * transferred to `to`.
935      * - When `from` is zero, `tokenId` will be minted for `to`.
936      * - When `to` is zero, `tokenId` will be burned by `from`.
937      * - `from` and `to` are never both zero.
938      */
939     function _beforeTokenTransfers(
940         address from,
941         address to,
942         uint256 startTokenId,
943         uint256 quantity
944     ) internal virtual {}
945 
946     /**
947      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
948      * minting.
949      * And also called after one token has been burned.
950      *
951      * startTokenId - the first token id to be transferred
952      * quantity - the amount to be transferred
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` has been minted for `to`.
959      * - When `to` is zero, `tokenId` has been burned by `from`.
960      * - `from` and `to` are never both zero.
961      */
962     function _afterTokenTransfers(
963         address from,
964         address to,
965         uint256 startTokenId,
966         uint256 quantity
967     ) internal virtual {}
968 }
969 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @title ERC721 token receiver interface
975  * @dev Interface for any contract that wants to support safeTransfers
976  * from ERC721 asset contracts.
977  */
978 interface IERC721Receiver {
979     /**
980      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
981      * by `operator` from `from`, this function is called.
982      *
983      * It must return its Solidity selector to confirm the token transfer.
984      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
985      *
986      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
987      */
988     function onERC721Received(
989         address operator,
990         address from,
991         uint256 tokenId,
992         bytes calldata data
993     ) external returns (bytes4);
994 }
995 
996 
997 
998 
999 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 /**
1004  * @dev String operations.
1005  */
1006 library Strings {
1007     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1008     uint8 private constant _ADDRESS_LENGTH = 20;
1009 
1010     /**
1011      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1012      */
1013     function toString(uint256 value) internal pure returns (string memory) {
1014         // Inspired by OraclizeAPI's implementation - MIT licence
1015         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1016 
1017         if (value == 0) {
1018             return "0";
1019         }
1020         uint256 temp = value;
1021         uint256 digits;
1022         while (temp != 0) {
1023             digits++;
1024             temp /= 10;
1025         }
1026         bytes memory buffer = new bytes(digits);
1027         while (value != 0) {
1028             digits -= 1;
1029             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1030             value /= 10;
1031         }
1032         return string(buffer);
1033     }
1034 
1035     /**
1036      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1037      */
1038     function toHexString(uint256 value) internal pure returns (string memory) {
1039         if (value == 0) {
1040             return "0x00";
1041         }
1042         uint256 temp = value;
1043         uint256 length = 0;
1044         while (temp != 0) {
1045             length++;
1046             temp >>= 8;
1047         }
1048         return toHexString(value, length);
1049     }
1050 
1051     /**
1052      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1053      */
1054     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1055         bytes memory buffer = new bytes(2 * length + 2);
1056         buffer[0] = "0";
1057         buffer[1] = "x";
1058         for (uint256 i = 2 * length + 1; i > 1; --i) {
1059             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1060             value >>= 4;
1061         }
1062         require(value == 0, "Strings: hex length insufficient");
1063         return string(buffer);
1064     }
1065 
1066     /**
1067      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1068      */
1069     function toHexString(address addr) internal pure returns (string memory) {
1070         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1071     }
1072 }
1073 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1074 
1075 pragma solidity ^0.8.1;
1076 
1077 /**
1078  * @dev Collection of functions related to the address type
1079  */
1080 library Address {
1081     /**
1082      * @dev Returns true if `account` is a contract.
1083      *
1084      * [IMPORTANT]
1085      * ====
1086      * It is unsafe to assume that an address for which this function returns
1087      * false is an externally-owned account (EOA) and not a contract.
1088      *
1089      * Among others, `isContract` will return false for the following
1090      * types of addresses:
1091      *
1092      *  - an externally-owned account
1093      *  - a contract in construction
1094      *  - an address where a contract will be created
1095      *  - an address where a contract lived, but was destroyed
1096      * ====
1097      *
1098      * [IMPORTANT]
1099      * ====
1100      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1101      *
1102      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1103      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1104      * constructor.
1105      * ====
1106      */
1107     function isContract(address account) internal view returns (bool) {
1108         // This method relies on extcodesize/address.code.length, which returns 0
1109         // for contracts in construction, since the code is only stored at the end
1110         // of the constructor execution.
1111 
1112         return account.code.length > 0;
1113     }
1114 
1115     /**
1116      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1117      * `recipient`, forwarding all available gas and reverting on errors.
1118      *
1119      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1120      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1121      * imposed by `transfer`, making them unable to receive funds via
1122      * `transfer`. {sendValue} removes this limitation.
1123      *
1124      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1125      *
1126      * IMPORTANT: because control is transferred to `recipient`, care must be
1127      * taken to not create reentrancy vulnerabilities. Consider using
1128      * {ReentrancyGuard} or the
1129      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1130      */
1131     function sendValue(address payable recipient, uint256 amount) internal {
1132         require(address(this).balance >= amount, "Address: insufficient balance");
1133 
1134         (bool success, ) = recipient.call{value: amount}("");
1135         require(success, "Address: unable to send value, recipient may have reverted");
1136     }
1137 
1138     /**
1139      * @dev Performs a Solidity function call using a low level `call`. A
1140      * plain `call` is an unsafe replacement for a function call: use this
1141      * function instead.
1142      *
1143      * If `target` reverts with a revert reason, it is bubbled up by this
1144      * function (like regular Solidity function calls).
1145      *
1146      * Returns the raw returned data. To convert to the expected return value,
1147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1148      *
1149      * Requirements:
1150      *
1151      * - `target` must be a contract.
1152      * - calling `target` with `data` must not revert.
1153      *
1154      * _Available since v3.1._
1155      */
1156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1157         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1158     }
1159 
1160     /**
1161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1162      * `errorMessage` as a fallback revert reason when `target` reverts.
1163      *
1164      * _Available since v3.1._
1165      */
1166     function functionCall(
1167         address target,
1168         bytes memory data,
1169         string memory errorMessage
1170     ) internal returns (bytes memory) {
1171         return functionCallWithValue(target, data, 0, errorMessage);
1172     }
1173 
1174     /**
1175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1176      * but also transferring `value` wei to `target`.
1177      *
1178      * Requirements:
1179      *
1180      * - the calling contract must have an ETH balance of at least `value`.
1181      * - the called Solidity function must be `payable`.
1182      *
1183      * _Available since v3.1._
1184      */
1185     function functionCallWithValue(
1186         address target,
1187         bytes memory data,
1188         uint256 value
1189     ) internal returns (bytes memory) {
1190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1191     }
1192 
1193     /**
1194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1195      * with `errorMessage` as a fallback revert reason when `target` reverts.
1196      *
1197      * _Available since v3.1._
1198      */
1199     function functionCallWithValue(
1200         address target,
1201         bytes memory data,
1202         uint256 value,
1203         string memory errorMessage
1204     ) internal returns (bytes memory) {
1205         require(address(this).balance >= value, "Address: insufficient balance for call");
1206         (bool success, bytes memory returndata) = target.call{value: value}(data);
1207         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1208     }
1209 
1210     /**
1211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1212      * but performing a static call.
1213      *
1214      * _Available since v3.3._
1215      */
1216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1217         return functionStaticCall(target, data, "Address: low-level static call failed");
1218     }
1219 
1220     /**
1221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1222      * but performing a static call.
1223      *
1224      * _Available since v3.3._
1225      */
1226     function functionStaticCall(
1227         address target,
1228         bytes memory data,
1229         string memory errorMessage
1230     ) internal view returns (bytes memory) {
1231         (bool success, bytes memory returndata) = target.staticcall(data);
1232         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1233     }
1234 
1235     /**
1236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1237      * but performing a delegate call.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1243     }
1244 
1245     /**
1246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1247      * but performing a delegate call.
1248      *
1249      * _Available since v3.4._
1250      */
1251     function functionDelegateCall(
1252         address target,
1253         bytes memory data,
1254         string memory errorMessage
1255     ) internal returns (bytes memory) {
1256         (bool success, bytes memory returndata) = target.delegatecall(data);
1257         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1258     }
1259 
1260     /**
1261      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1262      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1263      *
1264      * _Available since v4.8._
1265      */
1266     function verifyCallResultFromTarget(
1267         address target,
1268         bool success,
1269         bytes memory returndata,
1270         string memory errorMessage
1271     ) internal view returns (bytes memory) {
1272         if (success) {
1273             if (returndata.length == 0) {
1274                 // only check isContract if the call was successful and the return data is empty
1275                 // otherwise we already know that it was a contract
1276                 require(isContract(target), "Address: call to non-contract");
1277             }
1278             return returndata;
1279         } else {
1280             _revert(returndata, errorMessage);
1281         }
1282     }
1283 
1284     /**
1285      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1286      * revert reason or using the provided one.
1287      *
1288      * _Available since v4.3._
1289      */
1290     function verifyCallResult(
1291         bool success,
1292         bytes memory returndata,
1293         string memory errorMessage
1294     ) internal pure returns (bytes memory) {
1295         if (success) {
1296             return returndata;
1297         } else {
1298             _revert(returndata, errorMessage);
1299         }
1300     }
1301 
1302     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1303         // Look for revert reason and bubble it up if present
1304         if (returndata.length > 0) {
1305             // The easiest way to bubble the revert reason is using memory via assembly
1306             /// @solidity memory-safe-assembly
1307             assembly {
1308                 let returndata_size := mload(returndata)
1309                 revert(add(32, returndata), returndata_size)
1310             }
1311         } else {
1312             revert(errorMessage);
1313         }
1314     }
1315 }
1316 
1317 
1318 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1319 
1320 pragma solidity ^0.8.0;
1321 
1322 /**
1323  * @dev These functions deal with verification of Merkle Tree proofs.
1324  *
1325  * The proofs can be generated using the JavaScript library
1326  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1327  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1328  *
1329  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1330  *
1331  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1332  * hashing, or use a hash function other than keccak256 for hashing leaves.
1333  * This is because the concatenation of a sorted pair of internal nodes in
1334  * the merkle tree could be reinterpreted as a leaf value.
1335  */
1336 library MerkleProof {
1337     /**
1338      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1339      * defined by `root`. For this, a `proof` must be provided, containing
1340      * sibling hashes on the branch from the leaf to the root of the tree. Each
1341      * pair of leaves and each pair of pre-images are assumed to be sorted.
1342      */
1343     function verify(
1344         bytes32[] memory proof,
1345         bytes32 root,
1346         bytes32 leaf
1347     ) internal pure returns (bool) {
1348         return processProof(proof, leaf) == root;
1349     }
1350 
1351     /**
1352      * @dev Calldata version of {verify}
1353      *
1354      * _Available since v4.7._
1355      */
1356     function verifyCalldata(
1357         bytes32[] calldata proof,
1358         bytes32 root,
1359         bytes32 leaf
1360     ) internal pure returns (bool) {
1361         return processProofCalldata(proof, leaf) == root;
1362     }
1363 
1364     /**
1365      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1366      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1367      * hash matches the root of the tree. When processing the proof, the pairs
1368      * of leafs & pre-images are assumed to be sorted.
1369      *
1370      * _Available since v4.4._
1371      */
1372     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1373         bytes32 computedHash = leaf;
1374         for (uint256 i = 0; i < proof.length; i++) {
1375             computedHash = _hashPair(computedHash, proof[i]);
1376         }
1377         return computedHash;
1378     }
1379 
1380     /**
1381      * @dev Calldata version of {processProof}
1382      *
1383      * _Available since v4.7._
1384      */
1385     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1386         bytes32 computedHash = leaf;
1387         for (uint256 i = 0; i < proof.length; i++) {
1388             computedHash = _hashPair(computedHash, proof[i]);
1389         }
1390         return computedHash;
1391     }
1392 
1393     /**
1394      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1395      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1396      *
1397      * _Available since v4.7._
1398      */
1399     function multiProofVerify(
1400         bytes32[] memory proof,
1401         bool[] memory proofFlags,
1402         bytes32 root,
1403         bytes32[] memory leaves
1404     ) internal pure returns (bool) {
1405         return processMultiProof(proof, proofFlags, leaves) == root;
1406     }
1407 
1408     /**
1409      * @dev Calldata version of {multiProofVerify}
1410      *
1411      * _Available since v4.7._
1412      */
1413     function multiProofVerifyCalldata(
1414         bytes32[] calldata proof,
1415         bool[] calldata proofFlags,
1416         bytes32 root,
1417         bytes32[] memory leaves
1418     ) internal pure returns (bool) {
1419         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1420     }
1421 
1422     /**
1423      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1424      * consuming from one or the other at each step according to the instructions given by
1425      * `proofFlags`.
1426      *
1427      * _Available since v4.7._
1428      */
1429     function processMultiProof(
1430         bytes32[] memory proof,
1431         bool[] memory proofFlags,
1432         bytes32[] memory leaves
1433     ) internal pure returns (bytes32 merkleRoot) {
1434         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1435         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1436         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1437         // the merkle tree.
1438         uint256 leavesLen = leaves.length;
1439         uint256 totalHashes = proofFlags.length;
1440 
1441         // Check proof validity.
1442         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1443 
1444         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1445         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1446         bytes32[] memory hashes = new bytes32[](totalHashes);
1447         uint256 leafPos = 0;
1448         uint256 hashPos = 0;
1449         uint256 proofPos = 0;
1450         // At each step, we compute the next hash using two values:
1451         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1452         //   get the next hash.
1453         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1454         //   `proof` array.
1455         for (uint256 i = 0; i < totalHashes; i++) {
1456             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1457             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1458             hashes[i] = _hashPair(a, b);
1459         }
1460 
1461         if (totalHashes > 0) {
1462             return hashes[totalHashes - 1];
1463         } else if (leavesLen > 0) {
1464             return leaves[0];
1465         } else {
1466             return proof[0];
1467         }
1468     }
1469 
1470     /**
1471      * @dev Calldata version of {processMultiProof}
1472      *
1473      * _Available since v4.7._
1474      */
1475     function processMultiProofCalldata(
1476         bytes32[] calldata proof,
1477         bool[] calldata proofFlags,
1478         bytes32[] memory leaves
1479     ) internal pure returns (bytes32 merkleRoot) {
1480         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1481         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1482         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1483         // the merkle tree.
1484         uint256 leavesLen = leaves.length;
1485         uint256 totalHashes = proofFlags.length;
1486 
1487         // Check proof validity.
1488         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1489 
1490         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1491         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1492         bytes32[] memory hashes = new bytes32[](totalHashes);
1493         uint256 leafPos = 0;
1494         uint256 hashPos = 0;
1495         uint256 proofPos = 0;
1496         // At each step, we compute the next hash using two values:
1497         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1498         //   get the next hash.
1499         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1500         //   `proof` array.
1501         for (uint256 i = 0; i < totalHashes; i++) {
1502             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1503             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1504             hashes[i] = _hashPair(a, b);
1505         }
1506 
1507         if (totalHashes > 0) {
1508             return hashes[totalHashes - 1];
1509         } else if (leavesLen > 0) {
1510             return leaves[0];
1511         } else {
1512             return proof[0];
1513         }
1514     }
1515 
1516     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1517         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1518     }
1519 
1520     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1521         /// @solidity memory-safe-assembly
1522         assembly {
1523             mstore(0x00, a)
1524             mstore(0x20, b)
1525             value := keccak256(0x00, 0x40)
1526         }
1527     }
1528 }
1529 
1530 
1531 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1532 
1533 pragma solidity ^0.8.0;
1534 
1535 
1536 
1537 /**
1538  * @dev Contract module which provides a basic access control mechanism, where
1539  * there is an account (an owner) that can be granted exclusive access to
1540  * specific functions.
1541  *
1542  * By default, the owner account will be the one that deploys the contract. This
1543  * can later be changed with {transferOwnership}.
1544  *
1545  * This module is used through inheritance. It will make available the modifier
1546  * `onlyOwner`, which can be applied to your functions to restrict their use to
1547  * the owner.
1548  */
1549 abstract contract Ownable is Context {
1550     address private _owner;
1551 
1552     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1553 
1554     /**
1555      * @dev Initializes the contract setting the deployer as the initial owner.
1556      */
1557     constructor() {
1558         _transferOwnership(_msgSender());
1559     }
1560 
1561     /**
1562      * @dev Throws if called by any account other than the owner.
1563      */
1564     modifier onlyOwner() {
1565         _checkOwner();
1566         _;
1567     }
1568 
1569     /**
1570      * @dev Returns the address of the current owner.
1571      */
1572     function owner() public view virtual returns (address) {
1573         return _owner;
1574     }
1575 
1576     /**
1577      * @dev Throws if the sender is not the owner.
1578      */
1579     function _checkOwner() internal view virtual {
1580         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1581     }
1582 
1583     /**
1584      * @dev Leaves the contract without owner. It will not be possible to call
1585      * `onlyOwner` functions anymore. Can only be called by the current owner.
1586      *
1587      * NOTE: Renouncing ownership will leave the contract without an owner,
1588      * thereby removing any functionality that is only available to the owner.
1589      */
1590     function renounceOwnership() public virtual onlyOwner {
1591         _transferOwnership(address(0));
1592     }
1593 
1594     /**
1595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1596      * Can only be called by the current owner.
1597      */
1598     function transferOwnership(address newOwner) public virtual onlyOwner {
1599         require(newOwner != address(0), "Ownable: new owner is the zero address");
1600         _transferOwnership(newOwner);
1601     }
1602 
1603     /**
1604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1605      * Internal function without access restriction.
1606      */
1607     function _transferOwnership(address newOwner) internal virtual {
1608         address oldOwner = _owner;
1609         _owner = newOwner;
1610         emit OwnershipTransferred(oldOwner, newOwner);
1611     }
1612 }
1613 
1614 
1615 
1616 
1617 
1618 
1619 
1620 pragma solidity >=0.8.6;
1621 
1622 
1623 
1624 interface FearToken {
1625     function updateRewardOnMint(address _to, uint256 _amount) external;
1626 
1627     function updateReward(address _from, address _to) external;
1628 
1629     function getReward(address _to) external;
1630 
1631     function spend(address _from, uint256 _amount) external;
1632 }
1633 
1634 contract Darknezz is ERC721A, Ownable {
1635 
1636     uint public price = 0.0078 ether;
1637     uint public maxSupply = 6666;
1638     uint public maxTx = 3;
1639 
1640     mapping(address => uint256) public _preSaleCounter;
1641     mapping(address => bool) private pactOfSacrifice;
1642 
1643     bytes32 public merkleRoot;
1644 
1645     bool private mintOpen = false;
1646     bool private presaleOpen = false;
1647 
1648     string internal baseTokenURI = '';
1649     
1650     FearToken public fearToken;
1651 
1652 
1653 
1654     constructor() ERC721A("Darknezz", "DRKNZZ") {}
1655 
1656     function toggleMint() external onlyOwner {
1657         mintOpen = !mintOpen;
1658     }
1659 
1660     function togglePresale() external onlyOwner {
1661         presaleOpen = !presaleOpen;
1662     }
1663     
1664     function setPrice(uint newPrice) external onlyOwner {
1665         price = newPrice;
1666     }
1667     
1668     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1669         baseTokenURI = _uri;
1670     }
1671 
1672     function setMerkleRoot(bytes32 root) external onlyOwner {
1673         merkleRoot = root;
1674     }
1675     
1676     function setMaxSupply(uint newSupply) external onlyOwner {
1677         maxSupply = newSupply;
1678     }
1679 
1680     function setToken(address _contract) external onlyOwner {
1681         fearToken = FearToken(_contract);
1682     }
1683     
1684     function setMaxTx(uint newMax) external onlyOwner {
1685         maxTx = newMax;
1686     }
1687 
1688     function _baseURI() internal override view returns (string memory) {
1689         return baseTokenURI;
1690     }
1691 
1692     function buyTo(address to, uint qty) external onlyOwner {
1693         _mintTo(to, qty);
1694     }
1695 
1696     function buyPre(uint qty, bytes32[] memory proof) external payable {
1697         require(presaleOpen, "store closed");
1698         require(
1699             _preSaleCounter[msg.sender] + qty <= maxTx,
1700             "Exceeded max available to purchase"
1701         );
1702         _preSaleCounter[msg.sender] =
1703             _preSaleCounter[msg.sender] +
1704             qty;
1705         require(verify(proof), "address not in whitelist");
1706         _buy(qty);
1707     }
1708     
1709     function buy(uint qty) external payable {
1710         require(mintOpen, "store closed");
1711         require(
1712             _preSaleCounter[msg.sender] + qty <= maxTx,
1713             "Exceeded max available to purchase"
1714         );
1715         _preSaleCounter[msg.sender] =
1716             _preSaleCounter[msg.sender] +
1717             qty;
1718         _buy(qty);
1719     }
1720 
1721     function _buy(uint qty) internal {
1722         require(qty <= maxTx && qty > 0, "TRANSACTION: qty of mints not alowed");
1723         uint free = balanceOf(_msgSender()) == 0 ? 1 : 0;
1724         require(msg.value >= price * (qty - free), "PAYMENT: invalid value");
1725         _mintTo(_msgSender(), qty);
1726         fearToken.updateRewardOnMint(_msgSender(), qty);
1727     }
1728 
1729     function _mintTo(address to, uint qty) internal {
1730         require(qty + totalSupply() <= maxSupply, "SUPPLY: Value exceeds totalSupply");
1731         _mint(to, qty);
1732     }
1733     
1734     function withdraw() external onlyOwner {
1735         payable(_msgSender()).transfer(address(this).balance);
1736     }
1737 
1738     function verify(bytes32[] memory proof) internal view returns (bool) {
1739         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1740         return MerkleProof.verify(proof, merkleRoot, leaf);
1741     }
1742 
1743     function claimTokens() external {
1744         fearToken.updateReward(msg.sender, address(0));
1745         fearToken.getReward(msg.sender);
1746     }
1747 
1748     function spendTokens(uint256 _amount) external {
1749         fearToken.spend(msg.sender, _amount);
1750     }
1751 
1752     function _beforeTokenTransfers(
1753         address from,
1754         address to,
1755         uint256 tokenId,
1756         uint256 quantity
1757     ) internal virtual override {
1758         super._beforeTokenTransfers(from, to, tokenId, quantity);
1759         if (from != address(0)) {
1760             fearToken.updateReward(from, to);
1761         }
1762     }
1763 
1764     function addPact(address a) public onlyOwner {
1765         pactOfSacrifice[a] = true;
1766     }
1767 
1768     function removePact(address a) public onlyOwner {
1769         pactOfSacrifice[a] = false;
1770     }
1771 
1772     modifier onlyPacts() {
1773         require(pactOfSacrifice[_msgSender()], 'Not a pact of sacrifice');
1774         _;
1775     }
1776 
1777     function mintFromPact(address a, uint quantity) public onlyPacts {
1778         _safeMint(a, quantity);
1779     }
1780 
1781     function burnFromPact(uint256 tokenId) public onlyPacts {
1782         require(_exists(tokenId), 'Token does not exist');
1783         _burn(tokenId);
1784     }
1785 }