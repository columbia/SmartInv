1 // File: @openzeppelin/contracts/access/Ownable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
52 /**
53  * @dev Required interface of an ERC721 compliant contract.
54  */
55 interface IERC721 is IERC165 {
56     /**
57      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
58      */
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
63      */
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 /**
212  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
213  * @dev See https://eips.ethereum.org/EIPS/eip-721
214  */
215 interface IERC721Enumerable is IERC721 {
216     /**
217      * @dev Returns the total amount of tokens stored by the contract.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
223      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
224      */
225     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
226 
227     /**
228      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
229      * Use along with {totalSupply} to enumerate all tokens.
230      */
231     function tokenByIndex(uint256 index) external view returns (uint256);
232 }
233 
234 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
235 /**
236  * @dev Implementation of the {IERC165} interface.
237  *
238  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
239  * for the additional interface id that will be supported. For example:
240  *
241  * ```solidity
242  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
243  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
244  * }
245  * ```
246  *
247  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
248  */
249 abstract contract ERC165 is IERC165 {
250     /**
251      * @dev See {IERC165-supportsInterface}.
252      */
253     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
254         return interfaceId == type(IERC165).interfaceId;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
259 error ApprovalCallerNotOwnerNorApproved();
260 error ApprovalQueryForNonexistentToken();
261 error ApproveToCaller();
262 error ApprovalToCurrentOwner();
263 error BalanceQueryForZeroAddress();
264 error MintedQueryForZeroAddress();
265 error BurnedQueryForZeroAddress();
266 error MintToZeroAddress();
267 error MintZeroQuantity();
268 error OwnerIndexOutOfBounds();
269 error OwnerQueryForNonexistentToken();
270 error TokenIndexOutOfBounds();
271 error TransferCallerNotOwnerNorApproved();
272 error TransferFromIncorrectOwner();
273 error TransferToNonERC721ReceiverImplementer();
274 error TransferToZeroAddress();
275 error URIQueryForNonexistentToken();
276 
277 /**
278  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
279  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
280  *
281  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
282  *
283  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
284  *
285  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
286  */
287 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
288     using Address for address;
289     using Strings for uint256;
290 
291     // Compiler will pack this into a single 256bit word.
292     struct TokenOwnership {
293         // The address of the owner.
294         address addr;
295         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
296         uint64 startTimestamp;
297         // Whether the token has been burned.
298         bool burned;
299     }
300 
301     // Compiler will pack this into a single 256bit word.
302     struct AddressData {
303         // Realistically, 2**64-1 is more than enough.
304         uint64 balance;
305         // Keeps track of mint count with minimal overhead for tokenomics.
306         uint64 numberMinted;
307         // Keeps track of burn count with minimal overhead for tokenomics.
308         uint64 numberBurned;
309     }
310 
311     // Compiler will pack the following 
312     // _currentIndex and _burnCounter into a single 256bit word.
313     
314     // The tokenId of the next token to be minted.
315     uint128 internal _currentIndex;
316 
317     // The number of tokens burned.
318     uint128 internal _burnCounter;
319 
320     // Token name
321     string private _name;
322 
323     // Token symbol
324     string private _symbol;
325 
326     // Mapping from token ID to ownership details
327     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
328     mapping(uint256 => TokenOwnership) internal _ownerships;
329 
330     // Mapping owner address to address data
331     mapping(address => AddressData) private _addressData;
332 
333     // Mapping from token ID to approved address
334     mapping(uint256 => address) private _tokenApprovals;
335 
336     // Mapping from owner to operator approvals
337     mapping(address => mapping(address => bool)) private _operatorApprovals;
338 
339     constructor(string memory name_, string memory symbol_) {
340         _name = name_;
341         _symbol = symbol_;
342     }
343 
344     /**
345      * @dev See {IERC721Enumerable-totalSupply}.
346      */
347     function totalSupply() public view override returns (uint256) {
348         // Counter underflow is impossible as _burnCounter cannot be incremented
349         // more than _currentIndex times
350         unchecked {
351             return _currentIndex - _burnCounter;    
352         }
353     }
354 
355     /**
356      * @dev See {IERC721Enumerable-tokenByIndex}.
357      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
358      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
359      */
360     function tokenByIndex(uint256 index) public view override returns (uint256) {
361         uint256 numMintedSoFar = _currentIndex;
362         uint256 tokenIdsIdx;
363 
364         // Counter overflow is impossible as the loop breaks when
365         // uint256 i is equal to another uint256 numMintedSoFar.
366         unchecked {
367             for (uint256 i; i < numMintedSoFar; i++) {
368                 TokenOwnership memory ownership = _ownerships[i];
369                 if (!ownership.burned) {
370                     if (tokenIdsIdx == index) {
371                         return i;
372                     }
373                     tokenIdsIdx++;
374                 }
375             }
376         }
377         revert TokenIndexOutOfBounds();
378     }
379 
380     /**
381      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
382      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
383      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
384      */
385     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
386         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
387         uint256 numMintedSoFar = _currentIndex;
388         uint256 tokenIdsIdx;
389         address currOwnershipAddr;
390 
391         // Counter overflow is impossible as the loop breaks when
392         // uint256 i is equal to another uint256 numMintedSoFar.
393         unchecked {
394             for (uint256 i; i < numMintedSoFar; i++) {
395                 TokenOwnership memory ownership = _ownerships[i];
396                 if (ownership.burned) {
397                     continue;
398                 }
399                 if (ownership.addr != address(0)) {
400                     currOwnershipAddr = ownership.addr;
401                 }
402                 if (currOwnershipAddr == owner) {
403                     if (tokenIdsIdx == index) {
404                         return i;
405                     }
406                     tokenIdsIdx++;
407                 }
408             }
409         }
410 
411         // Execution should never reach this point.
412         revert();
413     }
414 
415     /**
416      * @dev See {IERC165-supportsInterface}.
417      */
418     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
419         return
420             interfaceId == type(IERC721).interfaceId ||
421             interfaceId == type(IERC721Metadata).interfaceId ||
422             interfaceId == type(IERC721Enumerable).interfaceId ||
423             super.supportsInterface(interfaceId);
424     }
425 
426     /**
427      * @dev See {IERC721-balanceOf}.
428      */
429     function balanceOf(address owner) public view override returns (uint256) {
430         if (owner == address(0)) revert BalanceQueryForZeroAddress();
431         return uint256(_addressData[owner].balance);
432     }
433 
434     function _numberMinted(address owner) internal view returns (uint256) {
435         if (owner == address(0)) revert MintedQueryForZeroAddress();
436         return uint256(_addressData[owner].numberMinted);
437     }
438 
439     function _numberBurned(address owner) internal view returns (uint256) {
440         if (owner == address(0)) revert BurnedQueryForZeroAddress();
441         return uint256(_addressData[owner].numberBurned);
442     }
443 
444     /**
445      * Gas spent here starts off proportional to the maximum mint batch size.
446      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
447      */
448     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
449         uint256 curr = tokenId;
450 
451         unchecked {
452             if (curr < _currentIndex) {
453                 TokenOwnership memory ownership = _ownerships[curr];
454                 if (!ownership.burned) {
455                     if (ownership.addr != address(0)) {
456                         return ownership;
457                     }
458                     // Invariant: 
459                     // There will always be an ownership that has an address and is not burned 
460                     // before an ownership that does not have an address and is not burned.
461                     // Hence, curr will not underflow.
462                     while (true) {
463                         curr--;
464                         ownership = _ownerships[curr];
465                         if (ownership.addr != address(0)) {
466                             return ownership;
467                         }
468                     }
469                 }
470             }
471         }
472         revert OwnerQueryForNonexistentToken();
473     }
474 
475     /**
476      * @dev See {IERC721-ownerOf}.
477      */
478     function ownerOf(uint256 tokenId) public view override returns (address) {
479         return ownershipOf(tokenId).addr;
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
497      * @dev See {IERC721Metadata-tokenURI}.
498      */
499     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
500         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
501 
502         string memory baseURI = _baseURI();
503         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
504     }
505 
506     /**
507      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
508      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
509      * by default, can be overriden in child contracts.
510      */
511     function _baseURI() internal view virtual returns (string memory) {
512         return '';
513     }
514 
515     /**
516      * @dev See {IERC721-approve}.
517      */
518     function approve(address to, uint256 tokenId) public override {
519         address owner = ERC721A.ownerOf(tokenId);
520         if (to == owner) revert ApprovalToCurrentOwner();
521 
522         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
523             revert ApprovalCallerNotOwnerNorApproved();
524         }
525 
526         _approve(to, tokenId, owner);
527     }
528 
529     /**
530      * @dev See {IERC721-getApproved}.
531      */
532     function getApproved(uint256 tokenId) public view override returns (address) {
533         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
534 
535         return _tokenApprovals[tokenId];
536     }
537 
538     /**
539      * @dev See {IERC721-setApprovalForAll}.
540      */
541     function setApprovalForAll(address operator, bool approved) public override {
542         if (operator == _msgSender()) revert ApproveToCaller();
543 
544         _operatorApprovals[_msgSender()][operator] = approved;
545         emit ApprovalForAll(_msgSender(), operator, approved);
546     }
547 
548     /**
549      * @dev See {IERC721-isApprovedForAll}.
550      */
551     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
552         return _operatorApprovals[owner][operator];
553     }
554 
555     /**
556      * @dev See {IERC721-transferFrom}.
557      */
558     function transferFrom(
559         address from,
560         address to,
561         uint256 tokenId
562     ) public virtual override {
563         _transfer(from, to, tokenId);
564     }
565 
566     /**
567      * @dev See {IERC721-safeTransferFrom}.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) public virtual override {
574         safeTransferFrom(from, to, tokenId, '');
575     }
576 
577     /**
578      * @dev See {IERC721-safeTransferFrom}.
579      */
580     function safeTransferFrom(
581         address from,
582         address to,
583         uint256 tokenId,
584         bytes memory _data
585     ) public virtual override {
586         _transfer(from, to, tokenId);
587         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
588             revert TransferToNonERC721ReceiverImplementer();
589         }
590     }
591 
592     /**
593      * @dev Returns whether `tokenId` exists.
594      *
595      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
596      *
597      * Tokens start existing when they are minted (`_mint`),
598      */
599     function _exists(uint256 tokenId) internal view returns (bool) {
600         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
601     }
602 
603     function _safeMint(address to, uint256 quantity) internal {
604         _safeMint(to, quantity, '');
605     }
606 
607     /**
608      * @dev Safely mints `quantity` tokens and transfers them to `to`.
609      *
610      * Requirements:
611      *
612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
613      * - `quantity` must be greater than 0.
614      *
615      * Emits a {Transfer} event.
616      */
617     function _safeMint(
618         address to,
619         uint256 quantity,
620         bytes memory _data
621     ) internal {
622         _mint(to, quantity, _data, true);
623     }
624 
625     /**
626      * @dev Mints `quantity` tokens and transfers them to `to`.
627      *
628      * Requirements:
629      *
630      * - `to` cannot be the zero address.
631      * - `quantity` must be greater than 0.
632      *
633      * Emits a {Transfer} event.
634      */
635     function _mint(
636         address to,
637         uint256 quantity,
638         bytes memory _data,
639         bool safe
640     ) internal {
641         uint256 startTokenId = _currentIndex;
642         if (to == address(0)) revert MintToZeroAddress();
643         if (quantity == 0) revert MintZeroQuantity();
644 
645         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
646 
647         // Overflows are incredibly unrealistic.
648         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
649         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
650         unchecked {
651             _addressData[to].balance += uint64(quantity);
652             _addressData[to].numberMinted += uint64(quantity);
653 
654             _ownerships[startTokenId].addr = to;
655             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
656 
657             uint256 updatedIndex = startTokenId;
658 
659             for (uint256 i; i < quantity; i++) {
660                 emit Transfer(address(0), to, updatedIndex);
661                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
662                     revert TransferToNonERC721ReceiverImplementer();
663                 }
664                 updatedIndex++;
665             }
666 
667             _currentIndex = uint128(updatedIndex);
668         }
669         _afterTokenTransfers(address(0), to, startTokenId, quantity);
670     }
671 
672     /**
673      * @dev Transfers `tokenId` from `from` to `to`.
674      *
675      * Requirements:
676      *
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must be owned by `from`.
679      *
680      * Emits a {Transfer} event.
681      */
682     function _transfer(
683         address from,
684         address to,
685         uint256 tokenId
686     ) private {
687         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
688 
689         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
690             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
691             getApproved(tokenId) == _msgSender());
692 
693         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
694         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
695         if (to == address(0)) revert TransferToZeroAddress();
696 
697         _beforeTokenTransfers(from, to, tokenId, 1);
698 
699         // Clear approvals from the previous owner
700         _approve(address(0), tokenId, prevOwnership.addr);
701 
702         // Underflow of the sender's balance is impossible because we check for
703         // ownership above and the recipient's balance can't realistically overflow.
704         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
705         unchecked {
706             _addressData[from].balance -= 1;
707             _addressData[to].balance += 1;
708 
709             _ownerships[tokenId].addr = to;
710             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
711 
712             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
713             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
714             uint256 nextTokenId = tokenId + 1;
715             if (_ownerships[nextTokenId].addr == address(0)) {
716                 // This will suffice for checking _exists(nextTokenId),
717                 // as a burned slot cannot contain the zero address.
718                 if (nextTokenId < _currentIndex) {
719                     _ownerships[nextTokenId].addr = prevOwnership.addr;
720                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
721                 }
722             }
723         }
724 
725         emit Transfer(from, to, tokenId);
726         _afterTokenTransfers(from, to, tokenId, 1);
727     }
728 
729     /**
730      * @dev Destroys `tokenId`.
731      * The approval is cleared when the token is burned.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _burn(uint256 tokenId) internal virtual {
740         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
741 
742         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
743 
744         // Clear approvals from the previous owner
745         _approve(address(0), tokenId, prevOwnership.addr);
746 
747         // Underflow of the sender's balance is impossible because we check for
748         // ownership above and the recipient's balance can't realistically overflow.
749         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
750         unchecked {
751             _addressData[prevOwnership.addr].balance -= 1;
752             _addressData[prevOwnership.addr].numberBurned += 1;
753 
754             // Keep track of who burned the token, and the timestamp of burning.
755             _ownerships[tokenId].addr = prevOwnership.addr;
756             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
757             _ownerships[tokenId].burned = true;
758 
759             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
760             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
761             uint256 nextTokenId = tokenId + 1;
762             if (_ownerships[nextTokenId].addr == address(0)) {
763                 // This will suffice for checking _exists(nextTokenId),
764                 // as a burned slot cannot contain the zero address.
765                 if (nextTokenId < _currentIndex) {
766                     _ownerships[nextTokenId].addr = prevOwnership.addr;
767                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
768                 }
769             }
770         }
771 
772         emit Transfer(prevOwnership.addr, address(0), tokenId);
773         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
774 
775         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
776         unchecked { 
777             _burnCounter++;
778         }
779     }
780 
781     /**
782      * @dev Approve `to` to operate on `tokenId`
783      *
784      * Emits a {Approval} event.
785      */
786     function _approve(
787         address to,
788         uint256 tokenId,
789         address owner
790     ) private {
791         _tokenApprovals[tokenId] = to;
792         emit Approval(owner, to, tokenId);
793     }
794 
795     /**
796      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
797      * The call is not executed if the target address is not a contract.
798      *
799      * @param from address representing the previous owner of the given token ID
800      * @param to target address that will receive the tokens
801      * @param tokenId uint256 ID of the token to be transferred
802      * @param _data bytes optional data to send along with the call
803      * @return bool whether the call correctly returned the expected magic value
804      */
805     function _checkOnERC721Received(
806         address from,
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) private returns (bool) {
811         if (to.isContract()) {
812             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
813                 return retval == IERC721Receiver(to).onERC721Received.selector;
814             } catch (bytes memory reason) {
815                 if (reason.length == 0) {
816                     revert TransferToNonERC721ReceiverImplementer();
817                 } else {
818                     assembly {
819                         revert(add(32, reason), mload(reason))
820                     }
821                 }
822             }
823         } else {
824             return true;
825         }
826     }
827 
828     /**
829      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
830      * And also called before burning one token.
831      *
832      * startTokenId - the first token id to be transferred
833      * quantity - the amount to be transferred
834      *
835      * Calling conditions:
836      *
837      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
838      * transferred to `to`.
839      * - When `from` is zero, `tokenId` will be minted for `to`.
840      * - When `to` is zero, `tokenId` will be burned by `from`.
841      * - `from` and `to` are never both zero.
842      */
843     function _beforeTokenTransfers(
844         address from,
845         address to,
846         uint256 startTokenId,
847         uint256 quantity
848     ) internal virtual {}
849 
850     /**
851      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
852      * minting.
853      * And also called after one token has been burned.
854      *
855      * startTokenId - the first token id to be transferred
856      * quantity - the amount to be transferred
857      *
858      * Calling conditions:
859      *
860      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
861      * transferred to `to`.
862      * - When `from` is zero, `tokenId` has been minted for `to`.
863      * - When `to` is zero, `tokenId` has been burned by `from`.
864      * - `from` and `to` are never both zero.
865      */
866     function _afterTokenTransfers(
867         address from,
868         address to,
869         uint256 startTokenId,
870         uint256 quantity
871     ) internal virtual {}
872 }
873 
874 // File: @openzeppelin/contracts/utils/Strings.sol
875 /**
876  * @dev String operations.
877  */
878 library Strings {
879     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
880 
881     /**
882      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
883      */
884     function toString(uint256 value) internal pure returns (string memory) {
885         // Inspired by OraclizeAPI's implementation - MIT licence
886         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
887 
888         if (value == 0) {
889             return "0";
890         }
891         uint256 temp = value;
892         uint256 digits;
893         while (temp != 0) {
894             digits++;
895             temp /= 10;
896         }
897         bytes memory buffer = new bytes(digits);
898         while (value != 0) {
899             digits -= 1;
900             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
901             value /= 10;
902         }
903         return string(buffer);
904     }
905 
906     /**
907      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
908      */
909     function toHexString(uint256 value) internal pure returns (string memory) {
910         if (value == 0) {
911             return "0x00";
912         }
913         uint256 temp = value;
914         uint256 length = 0;
915         while (temp != 0) {
916             length++;
917             temp >>= 8;
918         }
919         return toHexString(value, length);
920     }
921 
922     /**
923      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
924      */
925     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
926         bytes memory buffer = new bytes(2 * length + 2);
927         buffer[0] = "0";
928         buffer[1] = "x";
929         for (uint256 i = 2 * length + 1; i > 1; --i) {
930             buffer[i] = _HEX_SYMBOLS[value & 0xf];
931             value >>= 4;
932         }
933         require(value == 0, "Strings: hex length insufficient");
934         return string(buffer);
935     }
936 }
937 
938 // File: @openzeppelin/contracts/utils/Address.sol
939 /**
940  * @dev Collection of functions related to the address type
941  */
942 library Address {
943     /**
944      * @dev Returns true if `account` is a contract.
945      *
946      * [IMPORTANT]
947      * ====
948      * It is unsafe to assume that an address for which this function returns
949      * false is an externally-owned account (EOA) and not a contract.
950      *
951      * Among others, `isContract` will return false for the following
952      * types of addresses:
953      *
954      *  - an externally-owned account
955      *  - a contract in construction
956      *  - an address where a contract will be created
957      *  - an address where a contract lived, but was destroyed
958      * ====
959      */
960     function isContract(address account) internal view returns (bool) {
961         // This method relies on extcodesize, which returns 0 for contracts in
962         // construction, since the code is only stored at the end of the
963         // constructor execution.
964 
965         uint256 size;
966         assembly {
967             size := extcodesize(account)
968         }
969         return size > 0;
970     }
971 
972     /**
973      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
974      * `recipient`, forwarding all available gas and reverting on errors.
975      *
976      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
977      * of certain opcodes, possibly making contracts go over the 2300 gas limit
978      * imposed by `transfer`, making them unable to receive funds via
979      * `transfer`. {sendValue} removes this limitation.
980      *
981      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
982      *
983      * IMPORTANT: because control is transferred to `recipient`, care must be
984      * taken to not create reentrancy vulnerabilities. Consider using
985      * {ReentrancyGuard} or the
986      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
987      */
988     function sendValue(address payable recipient, uint256 amount) internal {
989         require(address(this).balance >= amount, "Address: insufficient balance");
990 
991         (bool success, ) = recipient.call{value: amount}("");
992         require(success, "Address: unable to send value, recipient may have reverted");
993     }
994 
995     /**
996      * @dev Performs a Solidity function call using a low level `call`. A
997      * plain `call` is an unsafe replacement for a function call: use this
998      * function instead.
999      *
1000      * If `target` reverts with a revert reason, it is bubbled up by this
1001      * function (like regular Solidity function calls).
1002      *
1003      * Returns the raw returned data. To convert to the expected return value,
1004      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1005      *
1006      * Requirements:
1007      *
1008      * - `target` must be a contract.
1009      * - calling `target` with `data` must not revert.
1010      *
1011      * _Available since v3.1._
1012      */
1013     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1014         return functionCall(target, data, "Address: low-level call failed");
1015     }
1016 
1017     /**
1018      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1019      * `errorMessage` as a fallback revert reason when `target` reverts.
1020      *
1021      * _Available since v3.1._
1022      */
1023     function functionCall(
1024         address target,
1025         bytes memory data,
1026         string memory errorMessage
1027     ) internal returns (bytes memory) {
1028         return functionCallWithValue(target, data, 0, errorMessage);
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1033      * but also transferring `value` wei to `target`.
1034      *
1035      * Requirements:
1036      *
1037      * - the calling contract must have an ETH balance of at least `value`.
1038      * - the called Solidity function must be `payable`.
1039      *
1040      * _Available since v3.1._
1041      */
1042     function functionCallWithValue(
1043         address target,
1044         bytes memory data,
1045         uint256 value
1046     ) internal returns (bytes memory) {
1047         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1048     }
1049 
1050     /**
1051      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1052      * with `errorMessage` as a fallback revert reason when `target` reverts.
1053      *
1054      * _Available since v3.1._
1055      */
1056     function functionCallWithValue(
1057         address target,
1058         bytes memory data,
1059         uint256 value,
1060         string memory errorMessage
1061     ) internal returns (bytes memory) {
1062         require(address(this).balance >= value, "Address: insufficient balance for call");
1063         require(isContract(target), "Address: call to non-contract");
1064 
1065         (bool success, bytes memory returndata) = target.call{value: value}(data);
1066         return _verifyCallResult(success, returndata, errorMessage);
1067     }
1068 
1069     /**
1070      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1071      * but performing a static call.
1072      *
1073      * _Available since v3.3._
1074      */
1075     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1076         return functionStaticCall(target, data, "Address: low-level static call failed");
1077     }
1078 
1079     /**
1080      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1081      * but performing a static call.
1082      *
1083      * _Available since v3.3._
1084      */
1085     function functionStaticCall(
1086         address target,
1087         bytes memory data,
1088         string memory errorMessage
1089     ) internal view returns (bytes memory) {
1090         require(isContract(target), "Address: static call to non-contract");
1091 
1092         (bool success, bytes memory returndata) = target.staticcall(data);
1093         return _verifyCallResult(success, returndata, errorMessage);
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1098      * but performing a delegate call.
1099      *
1100      * _Available since v3.4._
1101      */
1102     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1103         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1104     }
1105 
1106     /**
1107      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1108      * but performing a delegate call.
1109      *
1110      * _Available since v3.4._
1111      */
1112     function functionDelegateCall(
1113         address target,
1114         bytes memory data,
1115         string memory errorMessage
1116     ) internal returns (bytes memory) {
1117         require(isContract(target), "Address: delegate call to non-contract");
1118 
1119         (bool success, bytes memory returndata) = target.delegatecall(data);
1120         return _verifyCallResult(success, returndata, errorMessage);
1121     }
1122 
1123     function _verifyCallResult(
1124         bool success,
1125         bytes memory returndata,
1126         string memory errorMessage
1127     ) private pure returns (bytes memory) {
1128         if (success) {
1129             return returndata;
1130         } else {
1131             // Look for revert reason and bubble it up if present
1132             if (returndata.length > 0) {
1133                 // The easiest way to bubble the revert reason is using memory via assembly
1134 
1135                 assembly {
1136                     let returndata_size := mload(returndata)
1137                     revert(add(32, returndata), returndata_size)
1138                 }
1139             } else {
1140                 revert(errorMessage);
1141             }
1142         }
1143     }
1144 }
1145 
1146 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1147 /**
1148  * @title ERC721 token receiver interface
1149  * @dev Interface for any contract that wants to support safeTransfers
1150  * from ERC721 asset contracts.
1151  */
1152 interface IERC721Receiver {
1153     /**
1154      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1155      * by `operator` from `from`, this function is called.
1156      *
1157      * It must return its Solidity selector to confirm the token transfer.
1158      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1159      *
1160      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1161      */
1162     function onERC721Received(
1163         address operator,
1164         address from,
1165         uint256 tokenId,
1166         bytes calldata data
1167     ) external returns (bytes4);
1168 }
1169 
1170 /**
1171  * @dev Contract module which provides a basic access control mechanism, where
1172  * there is an account (an owner) that can be granted exclusive access to
1173  * specific functions.
1174  *
1175  * By default, the owner account will be the one that deploys the contract. This
1176  * can later be changed with {transferOwnership}.
1177  *
1178  * This module is used through inheritance. It will make available the modifier
1179  * `onlyOwner`, which can be applied to your functions to restrict their use to
1180  * the owner.
1181  */
1182 abstract contract Ownable is Context {
1183     address private _owner;
1184 
1185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1186 
1187     /**
1188      * @dev Initializes the contract setting the deployer as the initial owner.
1189      */
1190     constructor() {
1191         _setOwner(_msgSender());
1192     }
1193 
1194     /**
1195      * @dev Returns the address of the current owner.
1196      */
1197     function owner() public view virtual returns (address) {
1198         return _owner;
1199     }
1200 
1201     /**
1202      * @dev Throws if called by any account other than the owner.
1203      */
1204     modifier onlyOwner() {
1205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1206         _;
1207     }
1208 
1209     /**
1210      * @dev Leaves the contract without owner. It will not be possible to call
1211      * `onlyOwner` functions anymore. Can only be called by the current owner.
1212      *
1213      * NOTE: Renouncing ownership will leave the contract without an owner,
1214      * thereby removing any functionality that is only available to the owner.
1215      */
1216     function renounceOwnership() public virtual onlyOwner {
1217         _setOwner(address(0));
1218     }
1219 
1220     /**
1221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1222      * Can only be called by the current owner.
1223      */
1224     function transferOwnership(address newOwner) public virtual onlyOwner {
1225         require(newOwner != address(0), "Ownable: new owner is the zero address");
1226         _setOwner(newOwner);
1227     }
1228 
1229     function _setOwner(address newOwner) private {
1230         address oldOwner = _owner;
1231         _owner = newOwner;
1232         emit OwnershipTransferred(oldOwner, newOwner);
1233     }
1234 }
1235 
1236 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1237 /**
1238  * @dev These functions deal with verification of Merkle Trees proofs.
1239  *
1240  * The proofs can be generated using the JavaScript library
1241  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1242  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1243  *
1244  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1245  */
1246 library MerkleProof {
1247     /**
1248      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1249      * defined by `root`. For this, a `proof` must be provided, containing
1250      * sibling hashes on the branch from the leaf to the root of the tree. Each
1251      * pair of leaves and each pair of pre-images are assumed to be sorted.
1252      */
1253     function verify(
1254         bytes32[] memory proof,
1255         bytes32 root,
1256         bytes32 leaf
1257     ) internal pure returns (bool) {
1258         return processProof(proof, leaf) == root;
1259     }
1260 
1261     /**
1262      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1263      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1264      * hash matches the root of the tree. When processing the proof, the pairs
1265      * of leafs & pre-images are assumed to be sorted.
1266      *
1267      * _Available since v4.4._
1268      */
1269     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1270         bytes32 computedHash = leaf;
1271         for (uint256 i = 0; i < proof.length; i++) {
1272             bytes32 proofElement = proof[i];
1273             if (computedHash <= proofElement) {
1274                 // Hash(current computed hash + current element of the proof)
1275                 computedHash = _efficientHash(computedHash, proofElement);
1276             } else {
1277                 // Hash(current element of the proof + current computed hash)
1278                 computedHash = _efficientHash(proofElement, computedHash);
1279             }
1280         }
1281         return computedHash;
1282     }
1283 
1284     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1285         assembly {
1286             mstore(0x00, a)
1287             mstore(0x20, b)
1288             value := keccak256(0x00, 0x40)
1289         }
1290     }
1291 }
1292 
1293 // File: Avocados.sol
1294 
1295 contract Avocados is ERC721A, Ownable {  
1296     using Address for address;
1297     using Strings for uint256;
1298 
1299     uint256 public WL_PRICE = 35000000000000000; 
1300     uint256 public NFT_PRICE = 40000000000000000;
1301     uint256 public constant MAX_NFT_PURCHASE = 10;
1302     uint256 public constant MAX_NFT_WHITELIST = 4;
1303     uint256 public constant MINTABLE_AMOUNT = 7577;
1304     uint256 public constant RESERVED_AMOUNT = 200;
1305     uint256 public constant MAX_SUPPLY = MINTABLE_AMOUNT + RESERVED_AMOUNT;
1306     
1307     bytes32 public root;
1308     bool public whitelistPhase = false; 
1309     bool public publicSalePhase = false;
1310 
1311     string private _baseTokenURI;
1312     
1313     constructor() ERC721A("Adorable Avocados","AVCDO"){  
1314         root = 0x015e002ed68efbada69078c43195cb05c399d551134e6b17268d42925f9c58b8;     
1315         _baseTokenURI = "https://metadata.adorableavocados.com/"; 
1316     }
1317     
1318     function toggleWhitelistPhase() public onlyOwner {
1319         whitelistPhase = !whitelistPhase;
1320     }
1321     
1322     function togglePublicSalePhase() public onlyOwner {
1323         publicSalePhase = !publicSalePhase;
1324     }
1325     
1326     function airdrop(address to, uint256 quantity) public onlyOwner { 
1327         uint256 totalSupply = totalSupply();      
1328         require(quantity > 0, "Amount too small");
1329         require(quantity <= MAX_NFT_PURCHASE, "Max 10 tokens per trx"); 
1330         require((totalSupply + quantity) <= MAX_SUPPLY, "Purchase exceeding max supply"); 
1331 
1332         _safeMint(to, quantity);        
1333     }
1334 
1335     function mintChecks(uint256 quantity) private view {
1336         uint256 totalSupply = totalSupply();         
1337         require(quantity > 0, "Amount too small");
1338         require(quantity <= MAX_NFT_PURCHASE, "Max 10 tokens per trx"); 
1339         require((totalSupply + quantity) <= MINTABLE_AMOUNT, "Purchase exceeding max supply"); 
1340     }
1341 
1342     function whitelistMint(uint256 quantity, bytes32[] memory _proof) public payable {   
1343         require(whitelistPhase, "Can't mint"); 
1344         require(WL_PRICE * quantity == msg.value, "Sent ether val is incorrect");       
1345         require((MAX_NFT_WHITELIST - balanceOf(msg.sender)) >= quantity, "Cant mint that much"); 
1346 
1347         mintChecks(quantity);
1348 
1349         //whitelist
1350         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1351         require(MerkleProof.verify(_proof, root, leaf), "Not whitelisted");       
1352 
1353         _safeMint(msg.sender, quantity);
1354     }
1355 
1356     function mint(uint256 quantity) public payable {        
1357         require(publicSalePhase, "Can't mint");
1358         require(NFT_PRICE * quantity == msg.value, "Sent ether val is incorrect");
1359         mintChecks(quantity);
1360 
1361         _safeMint(msg.sender, quantity);  
1362     }
1363    
1364     function setRoot(uint256 _root) public onlyOwner {
1365         root = bytes32(_root);
1366     }  
1367     
1368     function withdraw() public onlyOwner {
1369         uint256 balance = address(this).balance;
1370         payable(msg.sender).transfer(balance);
1371     }    
1372 
1373     function setPrice(uint256 price) public onlyOwner {       
1374         NFT_PRICE = price;
1375     }
1376 
1377     function setWLPrice(uint256 price) public onlyOwner {       
1378         WL_PRICE = price;
1379     }
1380     
1381     function getBalance() public view onlyOwner returns (uint256){
1382         return address(this).balance;
1383     } 
1384 	
1385     function setBaseURI(string memory baseURI_) public onlyOwner {
1386         _baseTokenURI = baseURI_;
1387     }
1388 
1389     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {        
1390         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json"));
1391     }
1392 
1393     function numberMinted(address owner) public view returns (uint256) {
1394         return _numberMinted(owner);
1395     }
1396 }