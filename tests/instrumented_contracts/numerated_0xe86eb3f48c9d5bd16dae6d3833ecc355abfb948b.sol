1 // SPDX-License-Identifier: MIT
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 
5 pragma solidity ^0.8.0;
6 
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
28 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId,
83         bytes calldata data
84     ) external;
85 
86     /**
87      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
88      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must exist and be owned by `from`.
95      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
96      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
97      *
98      * Emits a {Transfer} event.
99      */
100     function safeTransferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Transfers `tokenId` token from `from` to `to`.
108      *
109      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
110      *
111      * Requirements:
112      *
113      * - `from` cannot be the zero address.
114      * - `to` cannot be the zero address.
115      * - `tokenId` token must be owned by `from`.
116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(
121         address from,
122         address to,
123         uint256 tokenId
124     ) external;
125 
126     /**
127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
128      * The approval is cleared when the token is transferred.
129      *
130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
131      *
132      * Requirements:
133      *
134      * - The caller must own the token or be an approved operator.
135      * - `tokenId` must exist.
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address to, uint256 tokenId) external;
140 
141     /**
142      * @dev Approve or remove `operator` as an operator for the caller.
143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
144      *
145      * Requirements:
146      *
147      * - The `operator` cannot be the caller.
148      *
149      * Emits an {ApprovalForAll} event.
150      */
151     function setApprovalForAll(address operator, bool _approved) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId) external view returns (address operator);
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator) external view returns (bool);
168 }
169 
170 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
178  * @dev See https://eips.ethereum.org/EIPS/eip-721
179  */
180 interface IERC721Metadata is IERC721 {
181     /**
182      * @dev Returns the token collection name.
183      */
184     function name() external view returns (string memory);
185 
186     /**
187      * @dev Returns the token collection symbol.
188      */
189     function symbol() external view returns (string memory);
190 
191     /**
192      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
193      */
194     function tokenURI(uint256 tokenId) external view returns (string memory);
195 }
196 
197 
198 
199 // ERC721A Contracts v3.3.0
200 // Creator: Chiru Labs
201 
202 pragma solidity ^0.8.4;
203 
204 
205 
206 /**
207  * @dev Interface of an ERC721A compliant contract.
208  */
209 interface IERC721A is IERC721, IERC721Metadata {
210     /**
211      * The caller must own the token or be an approved operator.
212      */
213     error ApprovalCallerNotOwnerNorApproved();
214 
215     /**
216      * The token does not exist.
217      */
218     error ApprovalQueryForNonexistentToken();
219 
220     /**
221      * The caller cannot approve to their own address.
222      */
223     error ApproveToCaller();
224 
225     /**
226      * The caller cannot approve to the current owner.
227      */
228     error ApprovalToCurrentOwner();
229 
230     /**
231      * Cannot query the balance for the zero address.
232      */
233     error BalanceQueryForZeroAddress();
234 
235     /**
236      * Cannot mint to the zero address.
237      */
238     error MintToZeroAddress();
239 
240     /**
241      * The quantity of tokens minted must be more than zero.
242      */
243     error MintZeroQuantity();
244 
245     /**
246      * The token does not exist.
247      */
248     error OwnerQueryForNonexistentToken();
249 
250     /**
251      * The caller must own the token or be an approved operator.
252      */
253     error TransferCallerNotOwnerNorApproved();
254 
255     /**
256      * The token must be owned by `from`.
257      */
258     error TransferFromIncorrectOwner();
259 
260     /**
261      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
262      */
263     error TransferToNonERC721ReceiverImplementer();
264 
265     /**
266      * Cannot transfer to the zero address.
267      */
268     error TransferToZeroAddress();
269 
270     /**
271      * The token does not exist.
272      */
273     error URIQueryForNonexistentToken();
274 
275     // Compiler will pack this into a single 256bit word.
276     struct TokenOwnership {
277         // The address of the owner.
278         address addr;
279         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
280         uint64 startTimestamp;
281         // Whether the token has been burned.
282         bool burned;
283     }
284 
285     // Compiler will pack this into a single 256bit word.
286     struct AddressData {
287         // Realistically, 2**64-1 is more than enough.
288         uint64 balance;
289         // Keeps track of mint count with minimal overhead for tokenomics.
290         uint64 numberMinted;
291         // Keeps track of burn count with minimal overhead for tokenomics.
292         uint64 numberBurned;
293         // For miscellaneous variable(s) pertaining to the address
294         // (e.g. number of whitelist mint slots used).
295         // If there are multiple variables, please pack them into a uint64.
296         uint64 aux;
297     }
298 
299     /**
300      * @dev Returns the total amount of tokens stored by the contract.
301      * 
302      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
303      */
304     function totalSupply() external view returns (uint256);
305 }
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 
332 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 
337 
338 /**
339  * @dev Implementation of the {IERC165} interface.
340  *
341  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
342  * for the additional interface id that will be supported. For example:
343  *
344  * ```solidity
345  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
347  * }
348  * ```
349  *
350  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
351  */
352 abstract contract ERC165 is IERC165 {
353     /**
354      * @dev See {IERC165-supportsInterface}.
355      */
356     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357         return interfaceId == type(IERC165).interfaceId;
358     }
359 }
360 
361 // ERC721A Contracts v3.3.0
362 // Creator: Chiru Labs
363 
364 pragma solidity ^0.8.4;
365 
366 
367 /**
368  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
369  * the Metadata extension. Built to optimize for lower gas during batch mints.
370  *
371  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
372  *
373  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
374  *
375  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
376  */
377 contract ERC721A is Context, ERC165, IERC721A {
378     using Address for address;
379     using Strings for uint256;
380 
381     // The tokenId of the next token to be minted.
382     uint256 internal _currentIndex;
383 
384     // The number of tokens burned.
385     uint256 internal _burnCounter;
386 
387     // Token name
388     string private _name;
389 
390     // Token symbol
391     string private _symbol;
392 
393     // Mapping from token ID to ownership details
394     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
395     mapping(uint256 => TokenOwnership) internal _ownerships;
396 
397     // Mapping owner address to address data
398     mapping(address => AddressData) private _addressData;
399 
400     // Mapping from token ID to approved address
401     mapping(uint256 => address) private _tokenApprovals;
402 
403     // Mapping from owner to operator approvals
404     mapping(address => mapping(address => bool)) private _operatorApprovals;
405 
406     constructor(string memory name_, string memory symbol_) {
407         _name = name_;
408         _symbol = symbol_;
409         _currentIndex = _startTokenId();
410     }
411 
412     /**
413      * To change the starting tokenId, please override this function.
414      */
415     function _startTokenId() internal view virtual returns (uint256) {
416         return 0;
417     }
418 
419     /**
420      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
421      */
422     function totalSupply() public view override returns (uint256) {
423         // Counter underflow is impossible as _burnCounter cannot be incremented
424         // more than _currentIndex - _startTokenId() times
425         unchecked {
426             return _currentIndex - _burnCounter - _startTokenId();
427         }
428     }
429 
430     /**
431      * Returns the total amount of tokens minted in the contract.
432      */
433     function _totalMinted() internal view returns (uint256) {
434         // Counter underflow is impossible as _currentIndex does not decrement,
435         // and it is initialized to _startTokenId()
436         unchecked {
437             return _currentIndex - _startTokenId();
438         }
439     }
440 
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
445         return
446             interfaceId == type(IERC721).interfaceId ||
447             interfaceId == type(IERC721Metadata).interfaceId ||
448             super.supportsInterface(interfaceId);
449     }
450 
451     /**
452      * @dev See {IERC721-balanceOf}.
453      */
454     function balanceOf(address owner) public view override returns (uint256) {
455         if (owner == address(0)) revert BalanceQueryForZeroAddress();
456         return uint256(_addressData[owner].balance);
457     }
458 
459     /**
460      * Returns the number of tokens minted by `owner`.
461      */
462     function _numberMinted(address owner) internal view returns (uint256) {
463         return uint256(_addressData[owner].numberMinted);
464     }
465 
466     /**
467      * Returns the number of tokens burned by or on behalf of `owner`.
468      */
469     function _numberBurned(address owner) internal view returns (uint256) {
470         return uint256(_addressData[owner].numberBurned);
471     }
472 
473     /**
474      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
475      */
476     function _getAux(address owner) internal view returns (uint64) {
477         return _addressData[owner].aux;
478     }
479 
480     /**
481      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
482      * If there are multiple variables, please pack them into a uint64.
483      */
484     function _setAux(address owner, uint64 aux) internal {
485         _addressData[owner].aux = aux;
486     }
487 
488     /**
489      * Gas spent here starts off proportional to the maximum mint batch size.
490      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
491      */
492     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
493         uint256 curr = tokenId;
494 
495         unchecked {
496             if (_startTokenId() <= curr) if (curr < _currentIndex) {
497                 TokenOwnership memory ownership = _ownerships[curr];
498                 if (!ownership.burned) {
499                     if (ownership.addr != address(0)) {
500                         return ownership;
501                     }
502                     // Invariant:
503                     // There will always be an ownership that has an address and is not burned
504                     // before an ownership that does not have an address and is not burned.
505                     // Hence, curr will not underflow.
506                     while (true) {
507                         curr--;
508                         ownership = _ownerships[curr];
509                         if (ownership.addr != address(0)) {
510                             return ownership;
511                         }
512                     }
513                 }
514             }
515         }
516         revert OwnerQueryForNonexistentToken();
517     }
518 
519     /**
520      * @dev See {IERC721-ownerOf}.
521      */
522     function ownerOf(uint256 tokenId) public view override returns (address) {
523         return _ownershipOf(tokenId).addr;
524     }
525 
526     /**
527      * @dev See {IERC721Metadata-name}.
528      */
529     function name() public view virtual override returns (string memory) {
530         return _name;
531     }
532 
533     /**
534      * @dev See {IERC721Metadata-symbol}.
535      */
536     function symbol() public view virtual override returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev See {IERC721Metadata-tokenURI}.
542      */
543     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
544         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
545 
546         string memory baseURI = _baseURI();
547         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
548     }
549 
550     /**
551      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
552      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
553      * by default, can be overriden in child contracts.
554      */
555     function _baseURI() internal view virtual returns (string memory) {
556         return '';
557     }
558 
559     /**
560      * @dev See {IERC721-approve}.
561      */
562     function approve(address to, uint256 tokenId) public override {
563         address owner = ERC721A.ownerOf(tokenId);
564         if (to == owner) revert ApprovalToCurrentOwner();
565 
566         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
567             revert ApprovalCallerNotOwnerNorApproved();
568         }
569 
570         _approve(to, tokenId, owner);
571     }
572 
573     /**
574      * @dev See {IERC721-getApproved}.
575      */
576     function getApproved(uint256 tokenId) public view override returns (address) {
577         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
578 
579         return _tokenApprovals[tokenId];
580     }
581 
582     /**
583      * @dev See {IERC721-setApprovalForAll}.
584      */
585     function setApprovalForAll(address operator, bool approved) public virtual override {
586         if (operator == _msgSender()) revert ApproveToCaller();
587 
588         _operatorApprovals[_msgSender()][operator] = approved;
589         emit ApprovalForAll(_msgSender(), operator, approved);
590     }
591 
592     /**
593      * @dev See {IERC721-isApprovedForAll}.
594      */
595     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
596         return _operatorApprovals[owner][operator];
597     }
598 
599     /**
600      * @dev See {IERC721-transferFrom}.
601      */
602     function transferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) public virtual override {
607         _transfer(from, to, tokenId);
608     }
609 
610     /**
611      * @dev See {IERC721-safeTransferFrom}.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) public virtual override {
618         safeTransferFrom(from, to, tokenId, '');
619     }
620 
621     /**
622      * @dev See {IERC721-safeTransferFrom}.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes memory _data
629     ) public virtual override {
630         _transfer(from, to, tokenId);
631         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
632             revert TransferToNonERC721ReceiverImplementer();
633         }
634     }
635 
636     /**
637      * @dev Returns whether `tokenId` exists.
638      *
639      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
640      *
641      * Tokens start existing when they are minted (`_mint`),
642      */
643     function _exists(uint256 tokenId) internal view returns (bool) {
644         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
645     }
646 
647     /**
648      * @dev Equivalent to `_safeMint(to, quantity, '')`.
649      */
650     function _safeMint(address to, uint256 quantity) internal {
651         _safeMint(to, quantity, '');
652     }
653 
654     /**
655      * @dev Safely mints `quantity` tokens and transfers them to `to`.
656      *
657      * Requirements:
658      *
659      * - If `to` refers to a smart contract, it must implement
660      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
661      * - `quantity` must be greater than 0.
662      *
663      * Emits a {Transfer} event.
664      */
665     function _safeMint(
666         address to,
667         uint256 quantity,
668         bytes memory _data
669     ) internal {
670         uint256 startTokenId = _currentIndex;
671         if (to == address(0)) revert MintToZeroAddress();
672         if (quantity == 0) revert MintZeroQuantity();
673 
674         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
675 
676         // Overflows are incredibly unrealistic.
677         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
678         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
679         unchecked {
680             _addressData[to].balance += uint64(quantity);
681             _addressData[to].numberMinted += uint64(quantity);
682 
683             _ownerships[startTokenId].addr = to;
684             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
685 
686             uint256 updatedIndex = startTokenId;
687             uint256 end = updatedIndex + quantity;
688 
689             if (to.isContract()) {
690                 do {
691                     emit Transfer(address(0), to, updatedIndex);
692                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
693                         revert TransferToNonERC721ReceiverImplementer();
694                     }
695                 } while (updatedIndex < end);
696                 // Reentrancy protection
697                 if (_currentIndex != startTokenId) revert();
698             } else {
699                 do {
700                     emit Transfer(address(0), to, updatedIndex++);
701                 } while (updatedIndex < end);
702             }
703             _currentIndex = updatedIndex;
704         }
705         _afterTokenTransfers(address(0), to, startTokenId, quantity);
706     }
707 
708     /**
709      * @dev Mints `quantity` tokens and transfers them to `to`.
710      *
711      * Requirements:
712      *
713      * - `to` cannot be the zero address.
714      * - `quantity` must be greater than 0.
715      *
716      * Emits a {Transfer} event.
717      */
718     function _mint(address to, uint256 quantity) internal {
719         uint256 startTokenId = _currentIndex;
720         if (to == address(0)) revert MintToZeroAddress();
721         if (quantity == 0) revert MintZeroQuantity();
722 
723         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
724 
725         // Overflows are incredibly unrealistic.
726         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
727         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
728         unchecked {
729             _addressData[to].balance += uint64(quantity);
730             _addressData[to].numberMinted += uint64(quantity);
731 
732             _ownerships[startTokenId].addr = to;
733             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
734 
735             uint256 updatedIndex = startTokenId;
736             uint256 end = updatedIndex + quantity;
737 
738             do {
739                 emit Transfer(address(0), to, updatedIndex++);
740             } while (updatedIndex < end);
741 
742             _currentIndex = updatedIndex;
743         }
744         _afterTokenTransfers(address(0), to, startTokenId, quantity);
745     }
746 
747     /**
748      * @dev Transfers `tokenId` from `from` to `to`.
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
761     ) private {
762         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
763 
764         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
765 
766         bool isApprovedOrOwner = (_msgSender() == from ||
767             isApprovedForAll(from, _msgSender()) ||
768             getApproved(tokenId) == _msgSender());
769 
770         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
771         if (to == address(0)) revert TransferToZeroAddress();
772 
773         _beforeTokenTransfers(from, to, tokenId, 1);
774 
775         // Clear approvals from the previous owner
776         _approve(address(0), tokenId, from);
777 
778         // Underflow of the sender's balance is impossible because we check for
779         // ownership above and the recipient's balance can't realistically overflow.
780         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
781         unchecked {
782             _addressData[from].balance -= 1;
783             _addressData[to].balance += 1;
784 
785             TokenOwnership storage currSlot = _ownerships[tokenId];
786             currSlot.addr = to;
787             currSlot.startTimestamp = uint64(block.timestamp);
788 
789             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
790             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
791             uint256 nextTokenId = tokenId + 1;
792             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
793             if (nextSlot.addr == address(0)) {
794                 // This will suffice for checking _exists(nextTokenId),
795                 // as a burned slot cannot contain the zero address.
796                 if (nextTokenId != _currentIndex) {
797                     nextSlot.addr = from;
798                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
799                 }
800             }
801         }
802 
803         emit Transfer(from, to, tokenId);
804         _afterTokenTransfers(from, to, tokenId, 1);
805     }
806 
807     /**
808      * @dev Equivalent to `_burn(tokenId, false)`.
809      */
810     function _burn(uint256 tokenId) internal virtual {
811         _burn(tokenId, false);
812     }
813 
814     /**
815      * @dev Destroys `tokenId`.
816      * The approval is cleared when the token is burned.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
825         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
826 
827         address from = prevOwnership.addr;
828 
829         if (approvalCheck) {
830             bool isApprovedOrOwner = (_msgSender() == from ||
831                 isApprovedForAll(from, _msgSender()) ||
832                 getApproved(tokenId) == _msgSender());
833 
834             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
835         }
836 
837         _beforeTokenTransfers(from, address(0), tokenId, 1);
838 
839         // Clear approvals from the previous owner
840         _approve(address(0), tokenId, from);
841 
842         // Underflow of the sender's balance is impossible because we check for
843         // ownership above and the recipient's balance can't realistically overflow.
844         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
845         unchecked {
846             AddressData storage addressData = _addressData[from];
847             addressData.balance -= 1;
848             addressData.numberBurned += 1;
849 
850             // Keep track of who burned the token, and the timestamp of burning.
851             TokenOwnership storage currSlot = _ownerships[tokenId];
852             currSlot.addr = from;
853             currSlot.startTimestamp = uint64(block.timestamp);
854             currSlot.burned = true;
855 
856             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
857             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
858             uint256 nextTokenId = tokenId + 1;
859             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
860             if (nextSlot.addr == address(0)) {
861                 // This will suffice for checking _exists(nextTokenId),
862                 // as a burned slot cannot contain the zero address.
863                 if (nextTokenId != _currentIndex) {
864                     nextSlot.addr = from;
865                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
866                 }
867             }
868         }
869 
870         emit Transfer(from, address(0), tokenId);
871         _afterTokenTransfers(from, address(0), tokenId, 1);
872 
873         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
874         unchecked {
875             _burnCounter++;
876         }
877     }
878 
879     /**
880      * @dev Approve `to` to operate on `tokenId`
881      *
882      * Emits a {Approval} event.
883      */
884     function _approve(
885         address to,
886         uint256 tokenId,
887         address owner
888     ) private {
889         _tokenApprovals[tokenId] = to;
890         emit Approval(owner, to, tokenId);
891     }
892 
893     /**
894      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
895      *
896      * @param from address representing the previous owner of the given token ID
897      * @param to target address that will receive the tokens
898      * @param tokenId uint256 ID of the token to be transferred
899      * @param _data bytes optional data to send along with the call
900      * @return bool whether the call correctly returned the expected magic value
901      */
902     function _checkContractOnERC721Received(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) private returns (bool) {
908         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
909             return retval == IERC721Receiver(to).onERC721Received.selector;
910         } catch (bytes memory reason) {
911             if (reason.length == 0) {
912                 revert TransferToNonERC721ReceiverImplementer();
913             } else {
914                 assembly {
915                     revert(add(32, reason), mload(reason))
916                 }
917             }
918         }
919     }
920 
921     /**
922      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
923      * And also called before burning one token.
924      *
925      * startTokenId - the first token id to be transferred
926      * quantity - the amount to be transferred
927      *
928      * Calling conditions:
929      *
930      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
931      * transferred to `to`.
932      * - When `from` is zero, `tokenId` will be minted for `to`.
933      * - When `to` is zero, `tokenId` will be burned by `from`.
934      * - `from` and `to` are never both zero.
935      */
936     function _beforeTokenTransfers(
937         address from,
938         address to,
939         uint256 startTokenId,
940         uint256 quantity
941     ) internal virtual {}
942 
943     /**
944      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
945      * minting.
946      * And also called after one token has been burned.
947      *
948      * startTokenId - the first token id to be transferred
949      * quantity - the amount to be transferred
950      *
951      * Calling conditions:
952      *
953      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
954      * transferred to `to`.
955      * - When `from` is zero, `tokenId` has been minted for `to`.
956      * - When `to` is zero, `tokenId` has been burned by `from`.
957      * - `from` and `to` are never both zero.
958      */
959     function _afterTokenTransfers(
960         address from,
961         address to,
962         uint256 startTokenId,
963         uint256 quantity
964     ) internal virtual {}
965 }
966 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 /**
971  * @title ERC721 token receiver interface
972  * @dev Interface for any contract that wants to support safeTransfers
973  * from ERC721 asset contracts.
974  */
975 interface IERC721Receiver {
976     /**
977      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
978      * by `operator` from `from`, this function is called.
979      *
980      * It must return its Solidity selector to confirm the token transfer.
981      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
982      *
983      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
984      */
985     function onERC721Received(
986         address operator,
987         address from,
988         uint256 tokenId,
989         bytes calldata data
990     ) external returns (bytes4);
991 }
992 
993 
994 
995 
996 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @dev String operations.
1002  */
1003 library Strings {
1004     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1005     uint8 private constant _ADDRESS_LENGTH = 20;
1006 
1007     /**
1008      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1009      */
1010     function toString(uint256 value) internal pure returns (string memory) {
1011         // Inspired by OraclizeAPI's implementation - MIT licence
1012         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1013 
1014         if (value == 0) {
1015             return "0";
1016         }
1017         uint256 temp = value;
1018         uint256 digits;
1019         while (temp != 0) {
1020             digits++;
1021             temp /= 10;
1022         }
1023         bytes memory buffer = new bytes(digits);
1024         while (value != 0) {
1025             digits -= 1;
1026             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1027             value /= 10;
1028         }
1029         return string(buffer);
1030     }
1031 
1032     /**
1033      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1034      */
1035     function toHexString(uint256 value) internal pure returns (string memory) {
1036         if (value == 0) {
1037             return "0x00";
1038         }
1039         uint256 temp = value;
1040         uint256 length = 0;
1041         while (temp != 0) {
1042             length++;
1043             temp >>= 8;
1044         }
1045         return toHexString(value, length);
1046     }
1047 
1048     /**
1049      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1050      */
1051     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1052         bytes memory buffer = new bytes(2 * length + 2);
1053         buffer[0] = "0";
1054         buffer[1] = "x";
1055         for (uint256 i = 2 * length + 1; i > 1; --i) {
1056             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1057             value >>= 4;
1058         }
1059         require(value == 0, "Strings: hex length insufficient");
1060         return string(buffer);
1061     }
1062 
1063     /**
1064      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1065      */
1066     function toHexString(address addr) internal pure returns (string memory) {
1067         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1068     }
1069 }
1070 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1071 
1072 pragma solidity ^0.8.1;
1073 
1074 /**
1075  * @dev Collection of functions related to the address type
1076  */
1077 library Address {
1078     /**
1079      * @dev Returns true if `account` is a contract.
1080      *
1081      * [IMPORTANT]
1082      * ====
1083      * It is unsafe to assume that an address for which this function returns
1084      * false is an externally-owned account (EOA) and not a contract.
1085      *
1086      * Among others, `isContract` will return false for the following
1087      * types of addresses:
1088      *
1089      *  - an externally-owned account
1090      *  - a contract in construction
1091      *  - an address where a contract will be created
1092      *  - an address where a contract lived, but was destroyed
1093      * ====
1094      *
1095      * [IMPORTANT]
1096      * ====
1097      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1098      *
1099      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1100      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1101      * constructor.
1102      * ====
1103      */
1104     function isContract(address account) internal view returns (bool) {
1105         // This method relies on extcodesize/address.code.length, which returns 0
1106         // for contracts in construction, since the code is only stored at the end
1107         // of the constructor execution.
1108 
1109         return account.code.length > 0;
1110     }
1111 
1112     /**
1113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1114      * `recipient`, forwarding all available gas and reverting on errors.
1115      *
1116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1118      * imposed by `transfer`, making them unable to receive funds via
1119      * `transfer`. {sendValue} removes this limitation.
1120      *
1121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1122      *
1123      * IMPORTANT: because control is transferred to `recipient`, care must be
1124      * taken to not create reentrancy vulnerabilities. Consider using
1125      * {ReentrancyGuard} or the
1126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1127      */
1128     function sendValue(address payable recipient, uint256 amount) internal {
1129         require(address(this).balance >= amount, "Address: insufficient balance");
1130 
1131         (bool success, ) = recipient.call{value: amount}("");
1132         require(success, "Address: unable to send value, recipient may have reverted");
1133     }
1134 
1135     /**
1136      * @dev Performs a Solidity function call using a low level `call`. A
1137      * plain `call` is an unsafe replacement for a function call: use this
1138      * function instead.
1139      *
1140      * If `target` reverts with a revert reason, it is bubbled up by this
1141      * function (like regular Solidity function calls).
1142      *
1143      * Returns the raw returned data. To convert to the expected return value,
1144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1145      *
1146      * Requirements:
1147      *
1148      * - `target` must be a contract.
1149      * - calling `target` with `data` must not revert.
1150      *
1151      * _Available since v3.1._
1152      */
1153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1154         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1159      * `errorMessage` as a fallback revert reason when `target` reverts.
1160      *
1161      * _Available since v3.1._
1162      */
1163     function functionCall(
1164         address target,
1165         bytes memory data,
1166         string memory errorMessage
1167     ) internal returns (bytes memory) {
1168         return functionCallWithValue(target, data, 0, errorMessage);
1169     }
1170 
1171     /**
1172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1173      * but also transferring `value` wei to `target`.
1174      *
1175      * Requirements:
1176      *
1177      * - the calling contract must have an ETH balance of at least `value`.
1178      * - the called Solidity function must be `payable`.
1179      *
1180      * _Available since v3.1._
1181      */
1182     function functionCallWithValue(
1183         address target,
1184         bytes memory data,
1185         uint256 value
1186     ) internal returns (bytes memory) {
1187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1188     }
1189 
1190     /**
1191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1192      * with `errorMessage` as a fallback revert reason when `target` reverts.
1193      *
1194      * _Available since v3.1._
1195      */
1196     function functionCallWithValue(
1197         address target,
1198         bytes memory data,
1199         uint256 value,
1200         string memory errorMessage
1201     ) internal returns (bytes memory) {
1202         require(address(this).balance >= value, "Address: insufficient balance for call");
1203         (bool success, bytes memory returndata) = target.call{value: value}(data);
1204         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1205     }
1206 
1207     /**
1208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1209      * but performing a static call.
1210      *
1211      * _Available since v3.3._
1212      */
1213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1214         return functionStaticCall(target, data, "Address: low-level static call failed");
1215     }
1216 
1217     /**
1218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1219      * but performing a static call.
1220      *
1221      * _Available since v3.3._
1222      */
1223     function functionStaticCall(
1224         address target,
1225         bytes memory data,
1226         string memory errorMessage
1227     ) internal view returns (bytes memory) {
1228         (bool success, bytes memory returndata) = target.staticcall(data);
1229         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1230     }
1231 
1232     /**
1233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1234      * but performing a delegate call.
1235      *
1236      * _Available since v3.4._
1237      */
1238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1240     }
1241 
1242     /**
1243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1244      * but performing a delegate call.
1245      *
1246      * _Available since v3.4._
1247      */
1248     function functionDelegateCall(
1249         address target,
1250         bytes memory data,
1251         string memory errorMessage
1252     ) internal returns (bytes memory) {
1253         (bool success, bytes memory returndata) = target.delegatecall(data);
1254         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1255     }
1256 
1257     /**
1258      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1259      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1260      *
1261      * _Available since v4.8._
1262      */
1263     function verifyCallResultFromTarget(
1264         address target,
1265         bool success,
1266         bytes memory returndata,
1267         string memory errorMessage
1268     ) internal view returns (bytes memory) {
1269         if (success) {
1270             if (returndata.length == 0) {
1271                 // only check isContract if the call was successful and the return data is empty
1272                 // otherwise we already know that it was a contract
1273                 require(isContract(target), "Address: call to non-contract");
1274             }
1275             return returndata;
1276         } else {
1277             _revert(returndata, errorMessage);
1278         }
1279     }
1280 
1281     /**
1282      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1283      * revert reason or using the provided one.
1284      *
1285      * _Available since v4.3._
1286      */
1287     function verifyCallResult(
1288         bool success,
1289         bytes memory returndata,
1290         string memory errorMessage
1291     ) internal pure returns (bytes memory) {
1292         if (success) {
1293             return returndata;
1294         } else {
1295             _revert(returndata, errorMessage);
1296         }
1297     }
1298 
1299     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1300         // Look for revert reason and bubble it up if present
1301         if (returndata.length > 0) {
1302             // The easiest way to bubble the revert reason is using memory via assembly
1303             /// @solidity memory-safe-assembly
1304             assembly {
1305                 let returndata_size := mload(returndata)
1306                 revert(add(32, returndata), returndata_size)
1307             }
1308         } else {
1309             revert(errorMessage);
1310         }
1311     }
1312 }
1313 
1314 
1315 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 /**
1320  * @dev These functions deal with verification of Merkle Tree proofs.
1321  *
1322  * The proofs can be generated using the JavaScript library
1323  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1324  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1325  *
1326  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1327  *
1328  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1329  * hashing, or use a hash function other than keccak256 for hashing leaves.
1330  * This is because the concatenation of a sorted pair of internal nodes in
1331  * the merkle tree could be reinterpreted as a leaf value.
1332  */
1333 library MerkleProof {
1334     /**
1335      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1336      * defined by `root`. For this, a `proof` must be provided, containing
1337      * sibling hashes on the branch from the leaf to the root of the tree. Each
1338      * pair of leaves and each pair of pre-images are assumed to be sorted.
1339      */
1340     function verify(
1341         bytes32[] memory proof,
1342         bytes32 root,
1343         bytes32 leaf
1344     ) internal pure returns (bool) {
1345         return processProof(proof, leaf) == root;
1346     }
1347 
1348     /**
1349      * @dev Calldata version of {verify}
1350      *
1351      * _Available since v4.7._
1352      */
1353     function verifyCalldata(
1354         bytes32[] calldata proof,
1355         bytes32 root,
1356         bytes32 leaf
1357     ) internal pure returns (bool) {
1358         return processProofCalldata(proof, leaf) == root;
1359     }
1360 
1361     /**
1362      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1363      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1364      * hash matches the root of the tree. When processing the proof, the pairs
1365      * of leafs & pre-images are assumed to be sorted.
1366      *
1367      * _Available since v4.4._
1368      */
1369     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1370         bytes32 computedHash = leaf;
1371         for (uint256 i = 0; i < proof.length; i++) {
1372             computedHash = _hashPair(computedHash, proof[i]);
1373         }
1374         return computedHash;
1375     }
1376 
1377     /**
1378      * @dev Calldata version of {processProof}
1379      *
1380      * _Available since v4.7._
1381      */
1382     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1383         bytes32 computedHash = leaf;
1384         for (uint256 i = 0; i < proof.length; i++) {
1385             computedHash = _hashPair(computedHash, proof[i]);
1386         }
1387         return computedHash;
1388     }
1389 
1390     /**
1391      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1392      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1393      *
1394      * _Available since v4.7._
1395      */
1396     function multiProofVerify(
1397         bytes32[] memory proof,
1398         bool[] memory proofFlags,
1399         bytes32 root,
1400         bytes32[] memory leaves
1401     ) internal pure returns (bool) {
1402         return processMultiProof(proof, proofFlags, leaves) == root;
1403     }
1404 
1405     /**
1406      * @dev Calldata version of {multiProofVerify}
1407      *
1408      * _Available since v4.7._
1409      */
1410     function multiProofVerifyCalldata(
1411         bytes32[] calldata proof,
1412         bool[] calldata proofFlags,
1413         bytes32 root,
1414         bytes32[] memory leaves
1415     ) internal pure returns (bool) {
1416         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1417     }
1418 
1419     /**
1420      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1421      * consuming from one or the other at each step according to the instructions given by
1422      * `proofFlags`.
1423      *
1424      * _Available since v4.7._
1425      */
1426     function processMultiProof(
1427         bytes32[] memory proof,
1428         bool[] memory proofFlags,
1429         bytes32[] memory leaves
1430     ) internal pure returns (bytes32 merkleRoot) {
1431         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1432         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1433         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1434         // the merkle tree.
1435         uint256 leavesLen = leaves.length;
1436         uint256 totalHashes = proofFlags.length;
1437 
1438         // Check proof validity.
1439         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1440 
1441         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1442         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1443         bytes32[] memory hashes = new bytes32[](totalHashes);
1444         uint256 leafPos = 0;
1445         uint256 hashPos = 0;
1446         uint256 proofPos = 0;
1447         // At each step, we compute the next hash using two values:
1448         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1449         //   get the next hash.
1450         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1451         //   `proof` array.
1452         for (uint256 i = 0; i < totalHashes; i++) {
1453             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1454             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1455             hashes[i] = _hashPair(a, b);
1456         }
1457 
1458         if (totalHashes > 0) {
1459             return hashes[totalHashes - 1];
1460         } else if (leavesLen > 0) {
1461             return leaves[0];
1462         } else {
1463             return proof[0];
1464         }
1465     }
1466 
1467     /**
1468      * @dev Calldata version of {processMultiProof}
1469      *
1470      * _Available since v4.7._
1471      */
1472     function processMultiProofCalldata(
1473         bytes32[] calldata proof,
1474         bool[] calldata proofFlags,
1475         bytes32[] memory leaves
1476     ) internal pure returns (bytes32 merkleRoot) {
1477         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1478         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1479         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1480         // the merkle tree.
1481         uint256 leavesLen = leaves.length;
1482         uint256 totalHashes = proofFlags.length;
1483 
1484         // Check proof validity.
1485         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1486 
1487         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1488         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1489         bytes32[] memory hashes = new bytes32[](totalHashes);
1490         uint256 leafPos = 0;
1491         uint256 hashPos = 0;
1492         uint256 proofPos = 0;
1493         // At each step, we compute the next hash using two values:
1494         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1495         //   get the next hash.
1496         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1497         //   `proof` array.
1498         for (uint256 i = 0; i < totalHashes; i++) {
1499             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1500             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1501             hashes[i] = _hashPair(a, b);
1502         }
1503 
1504         if (totalHashes > 0) {
1505             return hashes[totalHashes - 1];
1506         } else if (leavesLen > 0) {
1507             return leaves[0];
1508         } else {
1509             return proof[0];
1510         }
1511     }
1512 
1513     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1514         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1515     }
1516 
1517     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1518         /// @solidity memory-safe-assembly
1519         assembly {
1520             mstore(0x00, a)
1521             mstore(0x20, b)
1522             value := keccak256(0x00, 0x40)
1523         }
1524     }
1525 }
1526 
1527 
1528 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 
1533 
1534 /**
1535  * @dev Contract module which provides a basic access control mechanism, where
1536  * there is an account (an owner) that can be granted exclusive access to
1537  * specific functions.
1538  *
1539  * By default, the owner account will be the one that deploys the contract. This
1540  * can later be changed with {transferOwnership}.
1541  *
1542  * This module is used through inheritance. It will make available the modifier
1543  * `onlyOwner`, which can be applied to your functions to restrict their use to
1544  * the owner.
1545  */
1546 abstract contract Ownable is Context {
1547     address private _owner;
1548 
1549     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1550 
1551     /**
1552      * @dev Initializes the contract setting the deployer as the initial owner.
1553      */
1554     constructor() {
1555         _transferOwnership(_msgSender());
1556     }
1557 
1558     /**
1559      * @dev Throws if called by any account other than the owner.
1560      */
1561     modifier onlyOwner() {
1562         _checkOwner();
1563         _;
1564     }
1565 
1566     /**
1567      * @dev Returns the address of the current owner.
1568      */
1569     function owner() public view virtual returns (address) {
1570         return _owner;
1571     }
1572 
1573     /**
1574      * @dev Throws if the sender is not the owner.
1575      */
1576     function _checkOwner() internal view virtual {
1577         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1578     }
1579 
1580     /**
1581      * @dev Leaves the contract without owner. It will not be possible to call
1582      * `onlyOwner` functions anymore. Can only be called by the current owner.
1583      *
1584      * NOTE: Renouncing ownership will leave the contract without an owner,
1585      * thereby removing any functionality that is only available to the owner.
1586      */
1587     function renounceOwnership() public virtual onlyOwner {
1588         _transferOwnership(address(0));
1589     }
1590 
1591     /**
1592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1593      * Can only be called by the current owner.
1594      */
1595     function transferOwnership(address newOwner) public virtual onlyOwner {
1596         require(newOwner != address(0), "Ownable: new owner is the zero address");
1597         _transferOwnership(newOwner);
1598     }
1599 
1600     /**
1601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1602      * Internal function without access restriction.
1603      */
1604     function _transferOwnership(address newOwner) internal virtual {
1605         address oldOwner = _owner;
1606         _owner = newOwner;
1607         emit OwnershipTransferred(oldOwner, newOwner);
1608     }
1609 }
1610 
1611 
1612 pragma solidity >=0.8.6;
1613 
1614 
1615 
1616 interface TrollToken {
1617     function updateRewardOnMint(address _to, uint256 _amount) external;
1618 
1619     function updateReward(address _from, address _to) external;
1620 
1621     function getReward(address _to) external;
1622 
1623     function spend(address _from, uint256 _amount) external;
1624 }
1625 
1626 contract MoonTrolls is ERC721A, Ownable {
1627 
1628     uint public price = 0.005 ether;
1629     uint public maxSupply = 7000;
1630     uint public maxTx = 3;
1631 
1632     mapping(address => uint256) public _preSaleCounter;
1633 
1634     bytes32 public merkleRoot;
1635 
1636     bool private mintOpen = false;
1637     bool private presaleOpen = false;
1638 
1639     string internal baseTokenURI = '';
1640     
1641     TrollToken public trollToken;
1642 
1643 
1644 
1645     constructor() ERC721A("MoonTrolls", "MTROLL") {}
1646 
1647     function toggleMint() external onlyOwner {
1648         mintOpen = !mintOpen;
1649     }
1650 
1651     function togglePresale() external onlyOwner {
1652         presaleOpen = !presaleOpen;
1653     }
1654     
1655     function setPrice(uint newPrice) external onlyOwner {
1656         price = newPrice;
1657     }
1658     
1659     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1660         baseTokenURI = _uri;
1661     }
1662 
1663     function setMerkleRoot(bytes32 root) external onlyOwner {
1664         merkleRoot = root;
1665     }
1666     
1667     function setMaxSupply(uint newSupply) external onlyOwner {
1668         maxSupply = newSupply;
1669     }
1670 
1671     function setToken(address _contract) external onlyOwner {
1672         trollToken = TrollToken(_contract);
1673     }
1674     
1675     function setMaxTx(uint newMax) external onlyOwner {
1676         maxTx = newMax;
1677     }
1678 
1679     function _baseURI() internal override view returns (string memory) {
1680         return baseTokenURI;
1681     }
1682 
1683     function buyTo(address to, uint qty) external onlyOwner {
1684         _mintTo(to, qty);
1685     }
1686 
1687     function buyPre(uint qty, bytes32[] memory proof) external payable {
1688         require(presaleOpen, "store closed");
1689         require(
1690             _preSaleCounter[msg.sender] + qty <= maxTx,
1691             "Exceeded max available to purchase"
1692         );
1693         _preSaleCounter[msg.sender] =
1694             _preSaleCounter[msg.sender] +
1695             qty;
1696         require(verify(proof), "address not in whitelist");
1697         _buy(qty);
1698     }
1699     
1700     function buy(uint qty) external payable {
1701         require(mintOpen, "store closed");
1702         require(
1703             _preSaleCounter[msg.sender] + qty <= maxTx,
1704             "Exceeded max available to purchase"
1705         );
1706         _preSaleCounter[msg.sender] =
1707             _preSaleCounter[msg.sender] +
1708             qty;
1709         _buy(qty);
1710     }
1711 
1712     function _buy(uint qty) internal {
1713         require(qty <= maxTx && qty > 0, "TRANSACTION: qty of mints not alowed");
1714         uint free = balanceOf(_msgSender()) == 0 ? 1 : 0;
1715         require(msg.value >= price * (qty - free), "PAYMENT: invalid value");
1716         _mintTo(_msgSender(), qty);
1717         trollToken.updateRewardOnMint(_msgSender(), qty);
1718     }
1719 
1720     function _mintTo(address to, uint qty) internal {
1721         require(qty + totalSupply() <= maxSupply, "SUPPLY: Value exceeds totalSupply");
1722         _mint(to, qty);
1723     }
1724     
1725     function withdraw() external onlyOwner {
1726         payable(_msgSender()).transfer(address(this).balance);
1727     }
1728 
1729     function verify(bytes32[] memory proof) internal view returns (bool) {
1730         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1731         return MerkleProof.verify(proof, merkleRoot, leaf);
1732     }
1733 
1734     function claimTokens() external {
1735         trollToken.updateReward(msg.sender, address(0));
1736         trollToken.getReward(msg.sender);
1737     }
1738 
1739     function spendTokens(uint256 _amount) external {
1740         trollToken.spend(msg.sender, _amount);
1741     }
1742 
1743     function _beforeTokenTransfers(
1744         address from,
1745         address to,
1746         uint256 tokenId,
1747         uint256 quantity
1748     ) internal virtual override {
1749         super._beforeTokenTransfers(from, to, tokenId, quantity);
1750         if (from != address(0)) {
1751             trollToken.updateReward(from, to);
1752         }
1753     }
1754 }