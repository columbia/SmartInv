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
228      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
229      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
230      */
231     function walletOfOwner(address owner) external view returns (uint256 [] memory);
232 
233     /**
234      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
235      * Use along with {totalSupply} to enumerate all tokens.
236      */
237     function tokenByIndex(uint256 index) external view returns (uint256);
238 }
239 
240 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
241 /**
242  * @dev Implementation of the {IERC165} interface.
243  *
244  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
245  * for the additional interface id that will be supported. For example:
246  *
247  * ```solidity
248  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
249  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
250  * }
251  * ```
252  *
253  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
254  */
255 abstract contract ERC165 is IERC165 {
256     /**
257      * @dev See {IERC165-supportsInterface}.
258      */
259     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
260         return interfaceId == type(IERC165).interfaceId;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
265 error ApprovalCallerNotOwnerNorApproved();
266 error ApprovalQueryForNonexistentToken();
267 error ApproveToCaller();
268 error ApprovalToCurrentOwner();
269 error BalanceQueryForZeroAddress();
270 error MintedQueryForZeroAddress();
271 error BurnedQueryForZeroAddress();
272 error MintToZeroAddress();
273 error MintZeroQuantity();
274 error OwnerIndexOutOfBounds();
275 error OwnerQueryForNonexistentToken();
276 error TokenIndexOutOfBounds();
277 error TransferCallerNotOwnerNorApproved();
278 error TransferFromIncorrectOwner();
279 error TransferToNonERC721ReceiverImplementer();
280 error TransferToZeroAddress();
281 error URIQueryForNonexistentToken();
282 
283 /**
284  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
285  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
286  *
287  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
288  *
289  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
290  *
291  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
292  */
293 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
294     using Address for address;
295     using Strings for uint256;
296 
297     // Compiler will pack this into a single 256bit word.
298     struct TokenOwnership {
299         // The address of the owner.
300         address addr;
301         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
302         uint64 startTimestamp;
303         // Whether the token has been burned.
304         bool burned;
305     }
306 
307     // Compiler will pack this into a single 256bit word.
308     struct AddressData {
309         // Realistically, 2**64-1 is more than enough.
310         uint64 balance;
311         // Keeps track of mint count with minimal overhead for tokenomics.
312         uint64 numberMinted;
313         // Keeps track of burn count with minimal overhead for tokenomics.
314         uint64 numberBurned;
315     }
316 
317     // Compiler will pack the following 
318     // _currentIndex and _burnCounter into a single 256bit word.
319     
320     // The tokenId of the next token to be minted.
321     uint128 internal _currentIndex;
322 
323     // The number of tokens burned.
324     uint128 internal _burnCounter;
325 
326     // Token name
327     string private _name;
328 
329     // Token symbol
330     string private _symbol;
331 
332     // Mapping from token ID to ownership details
333     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
334     mapping(uint256 => TokenOwnership) internal _ownerships;
335 
336     // Mapping owner address to address data
337     mapping(address => AddressData) private _addressData;
338 
339     // Mapping from token ID to approved address
340     mapping(uint256 => address) private _tokenApprovals;
341 
342     // Mapping from owner to operator approvals
343     mapping(address => mapping(address => bool)) private _operatorApprovals;
344 
345     constructor(string memory name_, string memory symbol_) {
346         _name = name_;
347         _symbol = symbol_;
348     }
349 
350     /**
351      * @dev See {IERC721Enumerable-totalSupply}.
352      */
353     function totalSupply() public view override returns (uint256) {
354         // Counter underflow is impossible as _burnCounter cannot be incremented
355         // more than _currentIndex times
356         unchecked {
357             return _currentIndex - _burnCounter;    
358         }
359     }
360 
361     /**
362      * @dev See {IERC721Enumerable-tokenByIndex}.
363      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
364      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
365      */
366     function tokenByIndex(uint256 index) public view override returns (uint256) {
367         uint256 numMintedSoFar = _currentIndex;
368         uint256 tokenIdsIdx;
369 
370         // Counter overflow is impossible as the loop breaks when
371         // uint256 i is equal to another uint256 numMintedSoFar.
372         unchecked {
373             for (uint256 i; i < numMintedSoFar; i++) {
374                 TokenOwnership memory ownership = _ownerships[i];
375                 if (!ownership.burned) {
376                     if (tokenIdsIdx == index) {
377                         return i;
378                     }
379                     tokenIdsIdx++;
380                 }
381             }
382         }
383         revert TokenIndexOutOfBounds();
384     }
385 
386     /**
387      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
388      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
389      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
390      */
391     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
392         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
393         uint256 numMintedSoFar = _currentIndex;
394         uint256 tokenIdsIdx;
395         address currOwnershipAddr;
396 
397         // Counter overflow is impossible as the loop breaks when
398         // uint256 i is equal to another uint256 numMintedSoFar.
399         unchecked {
400             for (uint256 i; i < numMintedSoFar; i++) {
401                 TokenOwnership memory ownership = _ownerships[i];
402                 if (ownership.burned) {
403                     continue;
404                 }
405                 if (ownership.addr != address(0)) {
406                     currOwnershipAddr = ownership.addr;
407                 }
408                 if (currOwnershipAddr == owner) {
409                     if (tokenIdsIdx == index) {
410                         return i;
411                     }
412                     tokenIdsIdx++;
413                 }
414             }
415         }
416 
417         // Execution should never reach this point.
418         revert();
419     }
420 
421     /**
422      * @dev See {IERC721Enumerable-walletOfOwner}.
423      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
424      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
425      */
426     function walletOfOwner(address owner) public view override returns (uint256[] memory) {        
427         uint256 numMintedSoFar = _currentIndex;      
428         uint256 tokenIdsIdx;  
429         address currOwnershipAddr;
430 
431         uint256[] memory tokens = new uint256[](balanceOf(owner));
432 
433         // Counter overflow is impossible as the loop breaks when
434         // uint256 i is equal to another uint256 numMintedSoFar.
435         unchecked {
436             for (uint256 i; i < numMintedSoFar; i++) {
437                 TokenOwnership memory ownership = _ownerships[i];
438                 if (ownership.burned) {
439                     continue;
440                 }
441                 if (ownership.addr != address(0)) {
442                     currOwnershipAddr = ownership.addr;
443                 }
444                 if (currOwnershipAddr == owner) {
445                     tokens[tokenIdsIdx] = i; 
446                     tokenIdsIdx++;
447                 }
448             }
449         }
450         return tokens;
451     }
452 
453     /**
454      * @dev See {IERC165-supportsInterface}.
455      */
456     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
457         return
458             interfaceId == type(IERC721).interfaceId ||
459             interfaceId == type(IERC721Metadata).interfaceId ||
460             interfaceId == type(IERC721Enumerable).interfaceId ||
461             super.supportsInterface(interfaceId);
462     }
463 
464     /**
465      * @dev See {IERC721-balanceOf}.
466      */
467     function balanceOf(address owner) public view override returns (uint256) {
468         if (owner == address(0)) revert BalanceQueryForZeroAddress();
469         return uint256(_addressData[owner].balance);
470     }
471 
472     function _numberMinted(address owner) internal view returns (uint256) {
473         if (owner == address(0)) revert MintedQueryForZeroAddress();
474         return uint256(_addressData[owner].numberMinted);
475     }
476 
477     function _numberBurned(address owner) internal view returns (uint256) {
478         if (owner == address(0)) revert BurnedQueryForZeroAddress();
479         return uint256(_addressData[owner].numberBurned);
480     }
481 
482     /**
483      * Gas spent here starts off proportional to the maximum mint batch size.
484      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
485      */
486     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
487         uint256 curr = tokenId;
488 
489         unchecked {
490             if (curr < _currentIndex) {
491                 TokenOwnership memory ownership = _ownerships[curr];
492                 if (!ownership.burned) {
493                     if (ownership.addr != address(0)) {
494                         return ownership;
495                     }
496                     // Invariant: 
497                     // There will always be an ownership that has an address and is not burned 
498                     // before an ownership that does not have an address and is not burned.
499                     // Hence, curr will not underflow.
500                     while (true) {
501                         curr--;
502                         ownership = _ownerships[curr];
503                         if (ownership.addr != address(0)) {
504                             return ownership;
505                         }
506                     }
507                 }
508             }
509         }
510         revert OwnerQueryForNonexistentToken();
511     }
512 
513     /**
514      * @dev See {IERC721-ownerOf}.
515      */
516     function ownerOf(uint256 tokenId) public view override returns (address) {
517         return ownershipOf(tokenId).addr;
518     }
519 
520     /**
521      * @dev See {IERC721Metadata-name}.
522      */
523     function name() public view virtual override returns (string memory) {
524         return _name;
525     }
526 
527     /**
528      * @dev See {IERC721Metadata-symbol}.
529      */
530     function symbol() public view virtual override returns (string memory) {
531         return _symbol;
532     }
533 
534     /**
535      * @dev See {IERC721Metadata-tokenURI}.
536      */
537     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
538         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
539 
540         string memory baseURI = _baseURI();
541         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
542     }
543 
544     /**
545      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
546      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
547      * by default, can be overriden in child contracts.
548      */
549     function _baseURI() internal view virtual returns (string memory) {
550         return '';
551     }
552 
553     /**
554      * @dev See {IERC721-approve}.
555      */
556     function approve(address to, uint256 tokenId) public override {
557         address owner = ERC721A.ownerOf(tokenId);
558         if (to == owner) revert ApprovalToCurrentOwner();
559 
560         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
561             revert ApprovalCallerNotOwnerNorApproved();
562         }
563 
564         _approve(to, tokenId, owner);
565     }
566 
567     /**
568      * @dev See {IERC721-getApproved}.
569      */
570     function getApproved(uint256 tokenId) public view override returns (address) {
571         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
572 
573         return _tokenApprovals[tokenId];
574     }
575 
576     /**
577      * @dev See {IERC721-setApprovalForAll}.
578      */
579     function setApprovalForAll(address operator, bool approved) public override {
580         if (operator == _msgSender()) revert ApproveToCaller();
581 
582         _operatorApprovals[_msgSender()][operator] = approved;
583         emit ApprovalForAll(_msgSender(), operator, approved);
584     }
585 
586     /**
587      * @dev See {IERC721-isApprovedForAll}.
588      */
589     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
590         return _operatorApprovals[owner][operator];
591     }
592 
593     /**
594      * @dev See {IERC721-transferFrom}.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) public virtual override {
601         _transfer(from, to, tokenId);
602     }
603 
604     /**
605      * @dev See {IERC721-safeTransferFrom}.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) public virtual override {
612         safeTransferFrom(from, to, tokenId, '');
613     }
614 
615     /**
616      * @dev See {IERC721-safeTransferFrom}.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes memory _data
623     ) public virtual override {
624         _transfer(from, to, tokenId);
625         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
626             revert TransferToNonERC721ReceiverImplementer();
627         }
628     }
629 
630     /**
631      * @dev Returns whether `tokenId` exists.
632      *
633      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
634      *
635      * Tokens start existing when they are minted (`_mint`),
636      */
637     function _exists(uint256 tokenId) internal view returns (bool) {
638         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
639     }
640 
641     function _safeMint(address to, uint256 quantity) internal {
642         _safeMint(to, quantity, '');
643     }
644 
645     /**
646      * @dev Safely mints `quantity` tokens and transfers them to `to`.
647      *
648      * Requirements:
649      *
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
651      * - `quantity` must be greater than 0.
652      *
653      * Emits a {Transfer} event.
654      */
655     function _safeMint(
656         address to,
657         uint256 quantity,
658         bytes memory _data
659     ) internal {
660         _mint(to, quantity, _data, true);
661     }
662 
663     /**
664      * @dev Mints `quantity` tokens and transfers them to `to`.
665      *
666      * Requirements:
667      *
668      * - `to` cannot be the zero address.
669      * - `quantity` must be greater than 0.
670      *
671      * Emits a {Transfer} event.
672      */
673     function _mint(
674         address to,
675         uint256 quantity,
676         bytes memory _data,
677         bool safe
678     ) internal {
679         uint256 startTokenId = _currentIndex;
680         if (to == address(0)) revert MintToZeroAddress();
681         if (quantity == 0) revert MintZeroQuantity();
682 
683         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
684 
685         // Overflows are incredibly unrealistic.
686         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
687         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
688         unchecked {
689             _addressData[to].balance += uint64(quantity);
690             _addressData[to].numberMinted += uint64(quantity);
691 
692             _ownerships[startTokenId].addr = to;
693             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
694 
695             uint256 updatedIndex = startTokenId;
696 
697             for (uint256 i; i < quantity; i++) {
698                 emit Transfer(address(0), to, updatedIndex);
699                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
700                     revert TransferToNonERC721ReceiverImplementer();
701                 }
702                 updatedIndex++;
703             }
704 
705             _currentIndex = uint128(updatedIndex);
706         }
707         _afterTokenTransfers(address(0), to, startTokenId, quantity);
708     }
709 
710     /**
711      * @dev Transfers `tokenId` from `from` to `to`.
712      *
713      * Requirements:
714      *
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must be owned by `from`.
717      *
718      * Emits a {Transfer} event.
719      */
720     function _transfer(
721         address from,
722         address to,
723         uint256 tokenId
724     ) private {
725         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
726 
727         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
728             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
729             getApproved(tokenId) == _msgSender());
730 
731         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
732         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
733         if (to == address(0)) revert TransferToZeroAddress();
734 
735         _beforeTokenTransfers(from, to, tokenId, 1);
736 
737         // Clear approvals from the previous owner
738         _approve(address(0), tokenId, prevOwnership.addr);
739 
740         // Underflow of the sender's balance is impossible because we check for
741         // ownership above and the recipient's balance can't realistically overflow.
742         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
743         unchecked {
744             _addressData[from].balance -= 1;
745             _addressData[to].balance += 1;
746 
747             _ownerships[tokenId].addr = to;
748             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
749 
750             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
751             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
752             uint256 nextTokenId = tokenId + 1;
753             if (_ownerships[nextTokenId].addr == address(0)) {
754                 // This will suffice for checking _exists(nextTokenId),
755                 // as a burned slot cannot contain the zero address.
756                 if (nextTokenId < _currentIndex) {
757                     _ownerships[nextTokenId].addr = prevOwnership.addr;
758                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
759                 }
760             }
761         }
762 
763         emit Transfer(from, to, tokenId);
764         _afterTokenTransfers(from, to, tokenId, 1);
765     }
766 
767     /**
768      * @dev Destroys `tokenId`.
769      * The approval is cleared when the token is burned.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must exist.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _burn(uint256 tokenId) internal virtual {
778         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
779 
780         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
781 
782         // Clear approvals from the previous owner
783         _approve(address(0), tokenId, prevOwnership.addr);
784 
785         // Underflow of the sender's balance is impossible because we check for
786         // ownership above and the recipient's balance can't realistically overflow.
787         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
788         unchecked {
789             _addressData[prevOwnership.addr].balance -= 1;
790             _addressData[prevOwnership.addr].numberBurned += 1;
791 
792             // Keep track of who burned the token, and the timestamp of burning.
793             _ownerships[tokenId].addr = prevOwnership.addr;
794             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
795             _ownerships[tokenId].burned = true;
796 
797             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
798             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
799             uint256 nextTokenId = tokenId + 1;
800             if (_ownerships[nextTokenId].addr == address(0)) {
801                 // This will suffice for checking _exists(nextTokenId),
802                 // as a burned slot cannot contain the zero address.
803                 if (nextTokenId < _currentIndex) {
804                     _ownerships[nextTokenId].addr = prevOwnership.addr;
805                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
806                 }
807             }
808         }
809 
810         emit Transfer(prevOwnership.addr, address(0), tokenId);
811         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
812 
813         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
814         unchecked { 
815             _burnCounter++;
816         }
817     }
818 
819     /**
820      * @dev Approve `to` to operate on `tokenId`
821      *
822      * Emits a {Approval} event.
823      */
824     function _approve(
825         address to,
826         uint256 tokenId,
827         address owner
828     ) private {
829         _tokenApprovals[tokenId] = to;
830         emit Approval(owner, to, tokenId);
831     }
832 
833     /**
834      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
835      * The call is not executed if the target address is not a contract.
836      *
837      * @param from address representing the previous owner of the given token ID
838      * @param to target address that will receive the tokens
839      * @param tokenId uint256 ID of the token to be transferred
840      * @param _data bytes optional data to send along with the call
841      * @return bool whether the call correctly returned the expected magic value
842      */
843     function _checkOnERC721Received(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) private returns (bool) {
849         if (to.isContract()) {
850             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
851                 return retval == IERC721Receiver(to).onERC721Received.selector;
852             } catch (bytes memory reason) {
853                 if (reason.length == 0) {
854                     revert TransferToNonERC721ReceiverImplementer();
855                 } else {
856                     assembly {
857                         revert(add(32, reason), mload(reason))
858                     }
859                 }
860             }
861         } else {
862             return true;
863         }
864     }
865 
866     /**
867      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
868      * And also called before burning one token.
869      *
870      * startTokenId - the first token id to be transferred
871      * quantity - the amount to be transferred
872      *
873      * Calling conditions:
874      *
875      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
876      * transferred to `to`.
877      * - When `from` is zero, `tokenId` will be minted for `to`.
878      * - When `to` is zero, `tokenId` will be burned by `from`.
879      * - `from` and `to` are never both zero.
880      */
881     function _beforeTokenTransfers(
882         address from,
883         address to,
884         uint256 startTokenId,
885         uint256 quantity
886     ) internal virtual {}
887 
888     /**
889      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
890      * minting.
891      * And also called after one token has been burned.
892      *
893      * startTokenId - the first token id to be transferred
894      * quantity - the amount to be transferred
895      *
896      * Calling conditions:
897      *
898      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
899      * transferred to `to`.
900      * - When `from` is zero, `tokenId` has been minted for `to`.
901      * - When `to` is zero, `tokenId` has been burned by `from`.
902      * - `from` and `to` are never both zero.
903      */
904     function _afterTokenTransfers(
905         address from,
906         address to,
907         uint256 startTokenId,
908         uint256 quantity
909     ) internal virtual {}
910 }
911 
912 // File: @openzeppelin/contracts/utils/Strings.sol
913 /**
914  * @dev String operations.
915  */
916 library Strings {
917     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
918 
919     /**
920      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
921      */
922     function toString(uint256 value) internal pure returns (string memory) {
923         // Inspired by OraclizeAPI's implementation - MIT licence
924         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
925 
926         if (value == 0) {
927             return "0";
928         }
929         uint256 temp = value;
930         uint256 digits;
931         while (temp != 0) {
932             digits++;
933             temp /= 10;
934         }
935         bytes memory buffer = new bytes(digits);
936         while (value != 0) {
937             digits -= 1;
938             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
939             value /= 10;
940         }
941         return string(buffer);
942     }
943 
944     /**
945      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
946      */
947     function toHexString(uint256 value) internal pure returns (string memory) {
948         if (value == 0) {
949             return "0x00";
950         }
951         uint256 temp = value;
952         uint256 length = 0;
953         while (temp != 0) {
954             length++;
955             temp >>= 8;
956         }
957         return toHexString(value, length);
958     }
959 
960     /**
961      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
962      */
963     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
964         bytes memory buffer = new bytes(2 * length + 2);
965         buffer[0] = "0";
966         buffer[1] = "x";
967         for (uint256 i = 2 * length + 1; i > 1; --i) {
968             buffer[i] = _HEX_SYMBOLS[value & 0xf];
969             value >>= 4;
970         }
971         require(value == 0, "Strings: hex length insufficient");
972         return string(buffer);
973     }
974 }
975 
976 // File: @openzeppelin/contracts/utils/Address.sol
977 /**
978  * @dev Collection of functions related to the address type
979  */
980 library Address {
981     /**
982      * @dev Returns true if `account` is a contract.
983      *
984      * [IMPORTANT]
985      * ====
986      * It is unsafe to assume that an address for which this function returns
987      * false is an externally-owned account (EOA) and not a contract.
988      *
989      * Among others, `isContract` will return false for the following
990      * types of addresses:
991      *
992      *  - an externally-owned account
993      *  - a contract in construction
994      *  - an address where a contract will be created
995      *  - an address where a contract lived, but was destroyed
996      * ====
997      */
998     function isContract(address account) internal view returns (bool) {
999         // This method relies on extcodesize, which returns 0 for contracts in
1000         // construction, since the code is only stored at the end of the
1001         // constructor execution.
1002 
1003         uint256 size;
1004         assembly {
1005             size := extcodesize(account)
1006         }
1007         return size > 0;
1008     }
1009 
1010     /**
1011      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1012      * `recipient`, forwarding all available gas and reverting on errors.
1013      *
1014      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1015      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1016      * imposed by `transfer`, making them unable to receive funds via
1017      * `transfer`. {sendValue} removes this limitation.
1018      *
1019      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1020      *
1021      * IMPORTANT: because control is transferred to `recipient`, care must be
1022      * taken to not create reentrancy vulnerabilities. Consider using
1023      * {ReentrancyGuard} or the
1024      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1025      */
1026     function sendValue(address payable recipient, uint256 amount) internal {
1027         require(address(this).balance >= amount, "Address: insufficient balance");
1028 
1029         (bool success, ) = recipient.call{value: amount}("");
1030         require(success, "Address: unable to send value, recipient may have reverted");
1031     }
1032 
1033     /**
1034      * @dev Performs a Solidity function call using a low level `call`. A
1035      * plain `call` is an unsafe replacement for a function call: use this
1036      * function instead.
1037      *
1038      * If `target` reverts with a revert reason, it is bubbled up by this
1039      * function (like regular Solidity function calls).
1040      *
1041      * Returns the raw returned data. To convert to the expected return value,
1042      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1043      *
1044      * Requirements:
1045      *
1046      * - `target` must be a contract.
1047      * - calling `target` with `data` must not revert.
1048      *
1049      * _Available since v3.1._
1050      */
1051     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1052         return functionCall(target, data, "Address: low-level call failed");
1053     }
1054 
1055     /**
1056      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1057      * `errorMessage` as a fallback revert reason when `target` reverts.
1058      *
1059      * _Available since v3.1._
1060      */
1061     function functionCall(
1062         address target,
1063         bytes memory data,
1064         string memory errorMessage
1065     ) internal returns (bytes memory) {
1066         return functionCallWithValue(target, data, 0, errorMessage);
1067     }
1068 
1069     /**
1070      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1071      * but also transferring `value` wei to `target`.
1072      *
1073      * Requirements:
1074      *
1075      * - the calling contract must have an ETH balance of at least `value`.
1076      * - the called Solidity function must be `payable`.
1077      *
1078      * _Available since v3.1._
1079      */
1080     function functionCallWithValue(
1081         address target,
1082         bytes memory data,
1083         uint256 value
1084     ) internal returns (bytes memory) {
1085         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1086     }
1087 
1088     /**
1089      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1090      * with `errorMessage` as a fallback revert reason when `target` reverts.
1091      *
1092      * _Available since v3.1._
1093      */
1094     function functionCallWithValue(
1095         address target,
1096         bytes memory data,
1097         uint256 value,
1098         string memory errorMessage
1099     ) internal returns (bytes memory) {
1100         require(address(this).balance >= value, "Address: insufficient balance for call");
1101         require(isContract(target), "Address: call to non-contract");
1102 
1103         (bool success, bytes memory returndata) = target.call{value: value}(data);
1104         return _verifyCallResult(success, returndata, errorMessage);
1105     }
1106 
1107     /**
1108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1109      * but performing a static call.
1110      *
1111      * _Available since v3.3._
1112      */
1113     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1114         return functionStaticCall(target, data, "Address: low-level static call failed");
1115     }
1116 
1117     /**
1118      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1119      * but performing a static call.
1120      *
1121      * _Available since v3.3._
1122      */
1123     function functionStaticCall(
1124         address target,
1125         bytes memory data,
1126         string memory errorMessage
1127     ) internal view returns (bytes memory) {
1128         require(isContract(target), "Address: static call to non-contract");
1129 
1130         (bool success, bytes memory returndata) = target.staticcall(data);
1131         return _verifyCallResult(success, returndata, errorMessage);
1132     }
1133 
1134     /**
1135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1136      * but performing a delegate call.
1137      *
1138      * _Available since v3.4._
1139      */
1140     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1141         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1142     }
1143 
1144     /**
1145      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1146      * but performing a delegate call.
1147      *
1148      * _Available since v3.4._
1149      */
1150     function functionDelegateCall(
1151         address target,
1152         bytes memory data,
1153         string memory errorMessage
1154     ) internal returns (bytes memory) {
1155         require(isContract(target), "Address: delegate call to non-contract");
1156 
1157         (bool success, bytes memory returndata) = target.delegatecall(data);
1158         return _verifyCallResult(success, returndata, errorMessage);
1159     }
1160 
1161     function _verifyCallResult(
1162         bool success,
1163         bytes memory returndata,
1164         string memory errorMessage
1165     ) private pure returns (bytes memory) {
1166         if (success) {
1167             return returndata;
1168         } else {
1169             // Look for revert reason and bubble it up if present
1170             if (returndata.length > 0) {
1171                 // The easiest way to bubble the revert reason is using memory via assembly
1172 
1173                 assembly {
1174                     let returndata_size := mload(returndata)
1175                     revert(add(32, returndata), returndata_size)
1176                 }
1177             } else {
1178                 revert(errorMessage);
1179             }
1180         }
1181     }
1182 }
1183 
1184 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1185 /**
1186  * @title ERC721 token receiver interface
1187  * @dev Interface for any contract that wants to support safeTransfers
1188  * from ERC721 asset contracts.
1189  */
1190 interface IERC721Receiver {
1191     /**
1192      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1193      * by `operator` from `from`, this function is called.
1194      *
1195      * It must return its Solidity selector to confirm the token transfer.
1196      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1197      *
1198      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1199      */
1200     function onERC721Received(
1201         address operator,
1202         address from,
1203         uint256 tokenId,
1204         bytes calldata data
1205     ) external returns (bytes4);
1206 }
1207 
1208 /**
1209  * @dev Contract module which provides a basic access control mechanism, where
1210  * there is an account (an owner) that can be granted exclusive access to
1211  * specific functions.
1212  *
1213  * By default, the owner account will be the one that deploys the contract. This
1214  * can later be changed with {transferOwnership}.
1215  *
1216  * This module is used through inheritance. It will make available the modifier
1217  * `onlyOwner`, which can be applied to your functions to restrict their use to
1218  * the owner.
1219  */
1220 abstract contract Ownable is Context {
1221     address private _owner;
1222 
1223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1224 
1225     /**
1226      * @dev Initializes the contract setting the deployer as the initial owner.
1227      */
1228     constructor() {
1229         _setOwner(_msgSender());
1230     }
1231 
1232     /**
1233      * @dev Returns the address of the current owner.
1234      */
1235     function owner() public view virtual returns (address) {
1236         return _owner;
1237     }
1238 
1239     /**
1240      * @dev Throws if called by any account other than the owner.
1241      */
1242     modifier onlyOwner() {
1243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1244         _;
1245     }
1246 
1247     /**
1248      * @dev Leaves the contract without owner. It will not be possible to call
1249      * `onlyOwner` functions anymore. Can only be called by the current owner.
1250      *
1251      * NOTE: Renouncing ownership will leave the contract without an owner,
1252      * thereby removing any functionality that is only available to the owner.
1253      */
1254     function renounceOwnership() public virtual onlyOwner {
1255         _setOwner(address(0));
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Can only be called by the current owner.
1261      */
1262     function transferOwnership(address newOwner) public virtual onlyOwner {
1263         require(newOwner != address(0), "Ownable: new owner is the zero address");
1264         _setOwner(newOwner);
1265     }
1266 
1267     function _setOwner(address newOwner) private {
1268         address oldOwner = _owner;
1269         _owner = newOwner;
1270         emit OwnershipTransferred(oldOwner, newOwner);
1271     }
1272 }
1273 
1274 // File: Novas.sol
1275 
1276 contract Novas is ERC721A, Ownable {  
1277     using Address for address;
1278     using Strings for uint256;
1279 
1280     uint256 public DISCOUNT_PRICE            = 32100000000000000; 
1281     uint256 public NFT_PRICE                 = 43210000000000000;
1282     uint256 public constant MAX_NFT_PURCHASE = 9;
1283     uint256 public constant DISCOUNT_AMOUNT  = 3;
1284     uint256 public constant MINTABLE_AMOUNT  = 4111;
1285     uint256 public constant RESERVED_AMOUNT  = 210;
1286     uint256 public constant MAX_SUPPLY = MINTABLE_AMOUNT + RESERVED_AMOUNT;    
1287     
1288     bool public publicSalePhase = false;
1289     string private _baseTokenURI;
1290     
1291     constructor() ERC721A("THE NOVAS","NOVAS"){  
1292         _baseTokenURI = "https://metadata.thenovas.io/"; 
1293     }    
1294     
1295     function togglePublicSalePhase() public onlyOwner {
1296         publicSalePhase = !publicSalePhase;
1297     }
1298     
1299     function airdrop(address to, uint256 quantity) public onlyOwner { 
1300         uint256 totalSupply = totalSupply();      
1301         require(quantity > 0, "Amount too small");
1302         require(quantity <= MAX_NFT_PURCHASE, "Max 9 tokens per trx"); 
1303         require((totalSupply + quantity) <= MAX_SUPPLY, "Purchase exceeding max supply"); 
1304 
1305         _safeMint(to, quantity);        
1306     }
1307 
1308     function mint(uint256 quantity) public payable {  
1309         uint256 totalSupply = totalSupply();       
1310         require(publicSalePhase, "Can't mint");                
1311         require(quantity > 0, "Amount too small");
1312         require(quantity <= MAX_NFT_PURCHASE, "Max 9 tokens per trx"); 
1313         require((totalSupply + quantity) <= MINTABLE_AMOUNT, "Purchase exceeding max supply"); 
1314 
1315         if(quantity >= DISCOUNT_AMOUNT)
1316             require(DISCOUNT_PRICE * quantity == msg.value, "Sent eth val is incorrect");
1317         else
1318             require(NFT_PRICE * quantity == msg.value, "Sent eth val is incorrect");        
1319 
1320         _safeMint(msg.sender, quantity);  
1321     }
1322     
1323     function withdraw() public onlyOwner {
1324         uint256 balance = address(this).balance;
1325         payable(msg.sender).transfer(balance);
1326     }    
1327 
1328     function setPrice(uint256 price) public onlyOwner {       
1329         NFT_PRICE = price;
1330     }
1331 
1332     function setDiscountPrice(uint256 price) public onlyOwner {       
1333         DISCOUNT_PRICE = price;
1334     }
1335     
1336     function getBalance() public view onlyOwner returns (uint256){
1337         return address(this).balance;
1338     } 
1339 	
1340     function setBaseURI(string memory baseURI_) public onlyOwner {
1341         _baseTokenURI = baseURI_;
1342     }
1343 
1344     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {        
1345         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json"));
1346     }
1347 
1348     function numberMinted(address owner) public view returns (uint256) {
1349         return _numberMinted(owner);
1350     }
1351 }