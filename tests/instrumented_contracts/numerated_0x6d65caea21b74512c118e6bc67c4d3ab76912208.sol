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
416      * @dev See {IERC721Enumerable-walletOfOwner}.
417      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
418      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
419      */
420     function walletOfOwner(address owner) internal view returns (uint256[] memory) {        
421         uint256 numMintedSoFar = _currentIndex;      
422         uint256 tokenIdsIdx;  
423         address currOwnershipAddr;
424 
425         uint256[] memory tokens = new uint256[](balanceOf(owner));
426         if(balanceOf(owner) > 0)
427         {       
428             unchecked {
429                 for (uint256 i; i < numMintedSoFar; i++) {
430                     TokenOwnership memory ownership = _ownerships[i];
431                     if (ownership.burned) {
432                         continue;
433                     }
434                     if (ownership.addr != address(0)) {
435                         currOwnershipAddr = ownership.addr;
436                     }
437                     if (currOwnershipAddr == owner) {
438                         tokens[tokenIdsIdx] = i;
439                         tokenIdsIdx++;
440                     }
441                     if(tokenIdsIdx == balanceOf(owner))
442                         break;
443                 }
444             }
445         }
446         return tokens;
447     }
448 
449     /**
450      * @dev See {IERC165-supportsInterface}.
451      */
452     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
453         return
454             interfaceId == type(IERC721).interfaceId ||
455             interfaceId == type(IERC721Metadata).interfaceId ||
456             interfaceId == type(IERC721Enumerable).interfaceId ||
457             super.supportsInterface(interfaceId);
458     }
459 
460     /**
461      * @dev See {IERC721-balanceOf}.
462      */
463     function balanceOf(address owner) public view override returns (uint256) {
464         if (owner == address(0)) revert BalanceQueryForZeroAddress();
465         return uint256(_addressData[owner].balance);
466     }
467 
468     function _numberMinted(address owner) internal view returns (uint256) {
469         if (owner == address(0)) revert MintedQueryForZeroAddress();
470         return uint256(_addressData[owner].numberMinted);
471     }
472 
473     function _numberBurned(address owner) internal view returns (uint256) {
474         if (owner == address(0)) revert BurnedQueryForZeroAddress();
475         return uint256(_addressData[owner].numberBurned);
476     }
477 
478     /**
479      * Gas spent here starts off proportional to the maximum mint batch size.
480      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
481      */
482     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
483         uint256 curr = tokenId;
484 
485         unchecked {
486             if (curr < _currentIndex) {
487                 TokenOwnership memory ownership = _ownerships[curr];
488                 if (!ownership.burned) {
489                     if (ownership.addr != address(0)) {
490                         return ownership;
491                     }
492                     // Invariant: 
493                     // There will always be an ownership that has an address and is not burned 
494                     // before an ownership that does not have an address and is not burned.
495                     // Hence, curr will not underflow.
496                     while (true) {
497                         curr--;
498                         ownership = _ownerships[curr];
499                         if (ownership.addr != address(0)) {
500                             return ownership;
501                         }
502                     }
503                 }
504             }
505         }
506         revert OwnerQueryForNonexistentToken();
507     }
508 
509     /**
510      * @dev See {IERC721-ownerOf}.
511      */
512     function ownerOf(uint256 tokenId) public view override returns (address) {
513         return ownershipOf(tokenId).addr;
514     }
515 
516     /**
517      * @dev See {IERC721Metadata-name}.
518      */
519     function name() public view virtual override returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev See {IERC721Metadata-symbol}.
525      */
526     function symbol() public view virtual override returns (string memory) {
527         return _symbol;
528     }
529 
530     /**
531      * @dev See {IERC721Metadata-tokenURI}.
532      */
533     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
534         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
535 
536         string memory baseURI = _baseURI();
537         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
538     }
539 
540     /**
541      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
542      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
543      * by default, can be overriden in child contracts.
544      */
545     function _baseURI() internal view virtual returns (string memory) {
546         return '';
547     }
548 
549     /**
550      * @dev See {IERC721-approve}.
551      */
552     function approve(address to, uint256 tokenId) public override {
553         address owner = ERC721A.ownerOf(tokenId);
554         if (to == owner) revert ApprovalToCurrentOwner();
555 
556         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
557             revert ApprovalCallerNotOwnerNorApproved();
558         }
559 
560         _approve(to, tokenId, owner);
561     }
562 
563     /**
564      * @dev See {IERC721-getApproved}.
565      */
566     function getApproved(uint256 tokenId) public view override returns (address) {
567         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
568 
569         return _tokenApprovals[tokenId];
570     }
571 
572     /**
573      * @dev See {IERC721-setApprovalForAll}.
574      */
575     function setApprovalForAll(address operator, bool approved) public override {
576         if (operator == _msgSender()) revert ApproveToCaller();
577 
578         _operatorApprovals[_msgSender()][operator] = approved;
579         emit ApprovalForAll(_msgSender(), operator, approved);
580     }
581 
582     /**
583      * @dev See {IERC721-isApprovedForAll}.
584      */
585     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
586         return _operatorApprovals[owner][operator];
587     }
588 
589     /**
590      * @dev See {IERC721-transferFrom}.
591      */
592     function transferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) public virtual override {
597         _transfer(from, to, tokenId);
598     }
599 
600     /**
601      * @dev See {IERC721-safeTransferFrom}.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) public virtual override {
608         safeTransferFrom(from, to, tokenId, '');
609     }
610 
611     /**
612      * @dev See {IERC721-safeTransferFrom}.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId,
618         bytes memory _data
619     ) public virtual override {
620         _transfer(from, to, tokenId);
621         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
622             revert TransferToNonERC721ReceiverImplementer();
623         }
624     }
625 
626     /**
627      * @dev Returns whether `tokenId` exists.
628      *
629      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
630      *
631      * Tokens start existing when they are minted (`_mint`),
632      */
633     function _exists(uint256 tokenId) internal view returns (bool) {
634         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
635     }
636 
637     function _safeMint(address to, uint256 quantity) internal {
638         _safeMint(to, quantity, '');
639     }
640 
641     /**
642      * @dev Safely mints `quantity` tokens and transfers them to `to`.
643      *
644      * Requirements:
645      *
646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
647      * - `quantity` must be greater than 0.
648      *
649      * Emits a {Transfer} event.
650      */
651     function _safeMint(
652         address to,
653         uint256 quantity,
654         bytes memory _data
655     ) internal {
656         _mint(to, quantity, _data, true);
657     }
658 
659     /**
660      * @dev Mints `quantity` tokens and transfers them to `to`.
661      *
662      * Requirements:
663      *
664      * - `to` cannot be the zero address.
665      * - `quantity` must be greater than 0.
666      *
667      * Emits a {Transfer} event.
668      */
669     function _mint(
670         address to,
671         uint256 quantity,
672         bytes memory _data,
673         bool safe
674     ) internal {
675         uint256 startTokenId = _currentIndex;
676         if (to == address(0)) revert MintToZeroAddress();
677         if (quantity == 0) revert MintZeroQuantity();
678 
679         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
680 
681         // Overflows are incredibly unrealistic.
682         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
683         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
684         unchecked {
685             _addressData[to].balance += uint64(quantity);
686             _addressData[to].numberMinted += uint64(quantity);
687 
688             _ownerships[startTokenId].addr = to;
689             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
690 
691             uint256 updatedIndex = startTokenId;
692 
693             for (uint256 i; i < quantity; i++) {                
694                 emit Transfer(address(0), to, updatedIndex);
695                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
696                     revert TransferToNonERC721ReceiverImplementer();
697                 }
698                 updatedIndex++;
699             }
700 
701             _currentIndex = uint128(updatedIndex);
702         }
703         _afterTokenTransfers(address(0), to, startTokenId, quantity);
704     }
705 
706     /**
707      * @dev Transfers `tokenId` from `from` to `to`.
708      *
709      * Requirements:
710      *
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must be owned by `from`.
713      *
714      * Emits a {Transfer} event.
715      */
716     function _transfer(
717         address from,
718         address to,
719         uint256 tokenId
720     ) private {
721         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
722 
723         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
724             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
725             getApproved(tokenId) == _msgSender());
726 
727         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
728         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
729         if (to == address(0)) revert TransferToZeroAddress();
730 
731         _beforeTokenTransfers(from, to, tokenId, 1);
732 
733         // Clear approvals from the previous owner
734         _approve(address(0), tokenId, prevOwnership.addr);
735 
736         // Underflow of the sender's balance is impossible because we check for
737         // ownership above and the recipient's balance can't realistically overflow.
738         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
739         unchecked {
740             _addressData[from].balance -= 1;
741             _addressData[to].balance += 1;
742 
743             _ownerships[tokenId].addr = to;
744             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);            
745 
746             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
747             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
748             uint256 nextTokenId = tokenId + 1;
749             if (_ownerships[nextTokenId].addr == address(0)) {
750                 // This will suffice for checking _exists(nextTokenId),
751                 // as a burned slot cannot contain the zero address.
752                 if (nextTokenId < _currentIndex) {
753                     _ownerships[nextTokenId].addr = prevOwnership.addr;
754                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
755                 }
756             }
757         }
758 
759         emit Transfer(from, to, tokenId);
760         _afterTokenTransfers(from, to, tokenId, 1);
761     }
762 
763     /**
764      * @dev Destroys `tokenId`.
765      * The approval is cleared when the token is burned.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _burn(uint256 tokenId) internal virtual {
774         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
775 
776         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
777 
778         // Clear approvals from the previous owner
779         _approve(address(0), tokenId, prevOwnership.addr);
780 
781         // Underflow of the sender's balance is impossible because we check for
782         // ownership above and the recipient's balance can't realistically overflow.
783         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
784         unchecked {
785             _addressData[prevOwnership.addr].balance -= 1;
786             _addressData[prevOwnership.addr].numberBurned += 1;
787 
788             // Keep track of who burned the token, and the timestamp of burning.
789             _ownerships[tokenId].addr = prevOwnership.addr;
790             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
791             _ownerships[tokenId].burned = true;
792 
793             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
794             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
795             uint256 nextTokenId = tokenId + 1;
796             if (_ownerships[nextTokenId].addr == address(0)) {
797                 // This will suffice for checking _exists(nextTokenId),
798                 // as a burned slot cannot contain the zero address.
799                 if (nextTokenId < _currentIndex) {
800                     _ownerships[nextTokenId].addr = prevOwnership.addr;
801                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
802                 }
803             }
804         }
805 
806         emit Transfer(prevOwnership.addr, address(0), tokenId);
807         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
808 
809         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
810         unchecked { 
811             _burnCounter++;
812         }
813     }
814 
815     /**
816      * @dev Approve `to` to operate on `tokenId`
817      *
818      * Emits a {Approval} event.
819      */
820     function _approve(
821         address to,
822         uint256 tokenId,
823         address owner
824     ) private {
825         _tokenApprovals[tokenId] = to;
826         emit Approval(owner, to, tokenId);
827     }
828 
829     /**
830      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
831      * The call is not executed if the target address is not a contract.
832      *
833      * @param from address representing the previous owner of the given token ID
834      * @param to target address that will receive the tokens
835      * @param tokenId uint256 ID of the token to be transferred
836      * @param _data bytes optional data to send along with the call
837      * @return bool whether the call correctly returned the expected magic value
838      */
839     function _checkOnERC721Received(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) private returns (bool) {
845         if (to.isContract()) {
846             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
847                 return retval == IERC721Receiver(to).onERC721Received.selector;
848             } catch (bytes memory reason) {
849                 if (reason.length == 0) {
850                     revert TransferToNonERC721ReceiverImplementer();
851                 } else {
852                     assembly {
853                         revert(add(32, reason), mload(reason))
854                     }
855                 }
856             }
857         } else {
858             return true;
859         }
860     }
861 
862     /**
863      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
864      * And also called before burning one token.
865      *
866      * startTokenId - the first token id to be transferred
867      * quantity - the amount to be transferred
868      *
869      * Calling conditions:
870      *
871      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
872      * transferred to `to`.
873      * - When `from` is zero, `tokenId` will be minted for `to`.
874      * - When `to` is zero, `tokenId` will be burned by `from`.
875      * - `from` and `to` are never both zero.
876      */
877     function _beforeTokenTransfers(
878         address from,
879         address to,
880         uint256 startTokenId,
881         uint256 quantity
882     ) internal virtual {}
883 
884     /**
885      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
886      * minting.
887      * And also called after one token has been burned.
888      *
889      * startTokenId - the first token id to be transferred
890      * quantity - the amount to be transferred
891      *
892      * Calling conditions:
893      *
894      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
895      * transferred to `to`.
896      * - When `from` is zero, `tokenId` has been minted for `to`.
897      * - When `to` is zero, `tokenId` has been burned by `from`.
898      * - `from` and `to` are never both zero.
899      */
900     function _afterTokenTransfers(
901         address from,
902         address to,
903         uint256 startTokenId,
904         uint256 quantity
905     ) internal virtual {}
906 }
907 
908 // File: @openzeppelin/contracts/utils/Strings.sol
909 /**
910  * @dev String operations.
911  */
912 library Strings {
913     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
914 
915     /**
916      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
917      */
918     function toString(uint256 value) internal pure returns (string memory) {
919         // Inspired by OraclizeAPI's implementation - MIT licence
920         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
921 
922         if (value == 0) {
923             return "0";
924         }
925         uint256 temp = value;
926         uint256 digits;
927         while (temp != 0) {
928             digits++;
929             temp /= 10;
930         }
931         bytes memory buffer = new bytes(digits);
932         while (value != 0) {
933             digits -= 1;
934             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
935             value /= 10;
936         }
937         return string(buffer);
938     }
939 
940     /**
941      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
942      */
943     function toHexString(uint256 value) internal pure returns (string memory) {
944         if (value == 0) {
945             return "0x00";
946         }
947         uint256 temp = value;
948         uint256 length = 0;
949         while (temp != 0) {
950             length++;
951             temp >>= 8;
952         }
953         return toHexString(value, length);
954     }
955 
956     /**
957      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
958      */
959     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
960         bytes memory buffer = new bytes(2 * length + 2);
961         buffer[0] = "0";
962         buffer[1] = "x";
963         for (uint256 i = 2 * length + 1; i > 1; --i) {
964             buffer[i] = _HEX_SYMBOLS[value & 0xf];
965             value >>= 4;
966         }
967         require(value == 0, "Strings: hex length insufficient");
968         return string(buffer);
969     }
970 }
971 
972 // File: @openzeppelin/contracts/utils/Address.sol
973 /**
974  * @dev Collection of functions related to the address type
975  */
976 library Address {
977     /**
978      * @dev Returns true if `account` is a contract.
979      *
980      * [IMPORTANT]
981      * ====
982      * It is unsafe to assume that an address for which this function returns
983      * false is an externally-owned account (EOA) and not a contract.
984      *
985      * Among others, `isContract` will return false for the following
986      * types of addresses:
987      *
988      *  - an externally-owned account
989      *  - a contract in construction
990      *  - an address where a contract will be created
991      *  - an address where a contract lived, but was destroyed
992      * ====
993      */
994     function isContract(address account) internal view returns (bool) {
995         // This method relies on extcodesize, which returns 0 for contracts in
996         // construction, since the code is only stored at the end of the
997         // constructor execution.
998 
999         uint256 size;
1000         assembly {
1001             size := extcodesize(account)
1002         }
1003         return size > 0;
1004     }
1005 
1006     /**
1007      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1008      * `recipient`, forwarding all available gas and reverting on errors.
1009      *
1010      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1011      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1012      * imposed by `transfer`, making them unable to receive funds via
1013      * `transfer`. {sendValue} removes this limitation.
1014      *
1015      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1016      *
1017      * IMPORTANT: because control is transferred to `recipient`, care must be
1018      * taken to not create reentrancy vulnerabilities. Consider using
1019      * {ReentrancyGuard} or the
1020      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1021      */
1022     function sendValue(address payable recipient, uint256 amount) internal {
1023         require(address(this).balance >= amount, "Address: insufficient balance");
1024 
1025         (bool success, ) = recipient.call{value: amount}("");
1026         require(success, "Address: unable to send value, recipient may have reverted");
1027     }
1028 
1029     /**
1030      * @dev Performs a Solidity function call using a low level `call`. A
1031      * plain `call` is an unsafe replacement for a function call: use this
1032      * function instead.
1033      *
1034      * If `target` reverts with a revert reason, it is bubbled up by this
1035      * function (like regular Solidity function calls).
1036      *
1037      * Returns the raw returned data. To convert to the expected return value,
1038      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1039      *
1040      * Requirements:
1041      *
1042      * - `target` must be a contract.
1043      * - calling `target` with `data` must not revert.
1044      *
1045      * _Available since v3.1._
1046      */
1047     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1048         return functionCall(target, data, "Address: low-level call failed");
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1053      * `errorMessage` as a fallback revert reason when `target` reverts.
1054      *
1055      * _Available since v3.1._
1056      */
1057     function functionCall(
1058         address target,
1059         bytes memory data,
1060         string memory errorMessage
1061     ) internal returns (bytes memory) {
1062         return functionCallWithValue(target, data, 0, errorMessage);
1063     }
1064 
1065     /**
1066      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1067      * but also transferring `value` wei to `target`.
1068      *
1069      * Requirements:
1070      *
1071      * - the calling contract must have an ETH balance of at least `value`.
1072      * - the called Solidity function must be `payable`.
1073      *
1074      * _Available since v3.1._
1075      */
1076     function functionCallWithValue(
1077         address target,
1078         bytes memory data,
1079         uint256 value
1080     ) internal returns (bytes memory) {
1081         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1086      * with `errorMessage` as a fallback revert reason when `target` reverts.
1087      *
1088      * _Available since v3.1._
1089      */
1090     function functionCallWithValue(
1091         address target,
1092         bytes memory data,
1093         uint256 value,
1094         string memory errorMessage
1095     ) internal returns (bytes memory) {
1096         require(address(this).balance >= value, "Address: insufficient balance for call");
1097         require(isContract(target), "Address: call to non-contract");
1098 
1099         (bool success, bytes memory returndata) = target.call{value: value}(data);
1100         return _verifyCallResult(success, returndata, errorMessage);
1101     }
1102 
1103     /**
1104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1105      * but performing a static call.
1106      *
1107      * _Available since v3.3._
1108      */
1109     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1110         return functionStaticCall(target, data, "Address: low-level static call failed");
1111     }
1112 
1113     /**
1114      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1115      * but performing a static call.
1116      *
1117      * _Available since v3.3._
1118      */
1119     function functionStaticCall(
1120         address target,
1121         bytes memory data,
1122         string memory errorMessage
1123     ) internal view returns (bytes memory) {
1124         require(isContract(target), "Address: static call to non-contract");
1125 
1126         (bool success, bytes memory returndata) = target.staticcall(data);
1127         return _verifyCallResult(success, returndata, errorMessage);
1128     }
1129 
1130     /**
1131      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1132      * but performing a delegate call.
1133      *
1134      * _Available since v3.4._
1135      */
1136     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1137         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1138     }
1139 
1140     /**
1141      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1142      * but performing a delegate call.
1143      *
1144      * _Available since v3.4._
1145      */
1146     function functionDelegateCall(
1147         address target,
1148         bytes memory data,
1149         string memory errorMessage
1150     ) internal returns (bytes memory) {
1151         require(isContract(target), "Address: delegate call to non-contract");
1152 
1153         (bool success, bytes memory returndata) = target.delegatecall(data);
1154         return _verifyCallResult(success, returndata, errorMessage);
1155     }
1156 
1157     function _verifyCallResult(
1158         bool success,
1159         bytes memory returndata,
1160         string memory errorMessage
1161     ) private pure returns (bytes memory) {
1162         if (success) {
1163             return returndata;
1164         } else {
1165             // Look for revert reason and bubble it up if present
1166             if (returndata.length > 0) {
1167                 // The easiest way to bubble the revert reason is using memory via assembly
1168 
1169                 assembly {
1170                     let returndata_size := mload(returndata)
1171                     revert(add(32, returndata), returndata_size)
1172                 }
1173             } else {
1174                 revert(errorMessage);
1175             }
1176         }
1177     }
1178 }
1179 
1180 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1181 /**
1182  * @title ERC721 token receiver interface
1183  * @dev Interface for any contract that wants to support safeTransfers
1184  * from ERC721 asset contracts.
1185  */
1186 interface IERC721Receiver {
1187     /**
1188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1189      * by `operator` from `from`, this function is called.
1190      *
1191      * It must return its Solidity selector to confirm the token transfer.
1192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1193      *
1194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1195      */
1196     function onERC721Received(
1197         address operator,
1198         address from,
1199         uint256 tokenId,
1200         bytes calldata data
1201     ) external returns (bytes4);
1202 }
1203 
1204 /**
1205  * @dev Contract module which provides a basic access control mechanism, where
1206  * there is an account (an owner) that can be granted exclusive access to
1207  * specific functions.
1208  *
1209  * By default, the owner account will be the one that deploys the contract. This
1210  * can later be changed with {transferOwnership}.
1211  *
1212  * This module is used through inheritance. It will make available the modifier
1213  * `onlyOwner`, which can be applied to your functions to restrict their use to
1214  * the owner.
1215  */
1216 abstract contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _setOwner(_msgSender());
1226     }
1227 
1228     /**
1229      * @dev Returns the address of the current owner.
1230      */
1231     function owner() public view virtual returns (address) {
1232         return _owner;
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Leaves the contract without owner. It will not be possible to call
1245      * `onlyOwner` functions anymore. Can only be called by the current owner.
1246      *
1247      * NOTE: Renouncing ownership will leave the contract without an owner,
1248      * thereby removing any functionality that is only available to the owner.
1249      */
1250     function renounceOwnership() public virtual onlyOwner {
1251         _setOwner(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(newOwner != address(0), "Ownable: new owner is the zero address");
1260         _setOwner(newOwner);
1261     }
1262 
1263     function _setOwner(address newOwner) private {
1264         address oldOwner = _owner;
1265         _owner = newOwner;
1266         emit OwnershipTransferred(oldOwner, newOwner);
1267     }
1268 }
1269 
1270 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1271 /**
1272  * @dev These functions deal with verification of Merkle Trees proofs.
1273  *
1274  * The proofs can be generated using the JavaScript library
1275  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1276  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1277  *
1278  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1279  */
1280 library MerkleProof {
1281     /**
1282      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1283      * defined by `root`. For this, a `proof` must be provided, containing
1284      * sibling hashes on the branch from the leaf to the root of the tree. Each
1285      * pair of leaves and each pair of pre-images are assumed to be sorted.
1286      */
1287     function verify(
1288         bytes32[] memory proof,
1289         bytes32 root,
1290         bytes32 leaf
1291     ) internal pure returns (bool) {
1292         return processProof(proof, leaf) == root;
1293     }
1294 
1295     /**
1296      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1297      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1298      * hash matches the root of the tree. When processing the proof, the pairs
1299      * of leafs & pre-images are assumed to be sorted.
1300      *
1301      * _Available since v4.4._
1302      */
1303     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1304         bytes32 computedHash = leaf;
1305         for (uint256 i = 0; i < proof.length; i++) {
1306             bytes32 proofElement = proof[i];
1307             if (computedHash <= proofElement) {
1308                 // Hash(current computed hash + current element of the proof)
1309                 computedHash = _efficientHash(computedHash, proofElement);
1310             } else {
1311                 // Hash(current element of the proof + current computed hash)
1312                 computedHash = _efficientHash(proofElement, computedHash);
1313             }
1314         }
1315         return computedHash;
1316     }
1317 
1318     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1319         assembly {
1320             mstore(0x00, a)
1321             mstore(0x20, b)
1322             value := keccak256(0x00, 0x40)
1323         }
1324     }
1325 }
1326 
1327 // File: Meows.sol
1328 
1329 contract Meows is ERC721A, Ownable {  
1330     using Address for address;
1331     using Strings for uint256;
1332     
1333     uint256 public NFT_PRICE = 25000000000000000;
1334     uint256 public MAX_SUPPLY = 9000;
1335     uint256 public MAX_NFT_WALLET = 5; 
1336     uint256 public constant MAX_NFT_TRX = 10;
1337     uint256 public constant RESERVED_AMOUNT = 200;    
1338 
1339     bool public isRevealed = false;
1340     bool public salePhase = false;
1341     bool public whitelistListEnabled = true;
1342 
1343     string private _baseTokenURI;
1344     string private _suffix = ".json";
1345     bytes32 private root;    
1346 
1347     address private comm_wallet = 0x25B5d916BA2fE2F84710896f5D8415F88d4BE3b3;
1348     address private wallet_1 = 0x7cd0dbf2D755d432a09A4C9A497C44f3aC496581;    
1349     address private wallet_2 = 0x32681C1F840DB7ec68eFA469f8318b50195c81c3;
1350     address private wallet_3 = 0x94487A5737B8D83Bd64ED8Eb77A313866Adc1181;
1351     address private wallet_4 = 0x9173a1408Fe3329A697386238f9BE6d0ED3108D8;  
1352 
1353     mapping(address => uint256) private wlAmount;   
1354     
1355     constructor() ERC721A("MEOWs NFT","MEOWS") {
1356          _safeMint(comm_wallet, 150);         
1357          _safeMint(wallet_2, 10);
1358          _safeMint(wallet_3, 10);
1359          _safeMint(wallet_4, 10);
1360     }
1361 
1362     function mint(uint256 quantity, bytes32[] memory _proof) public payable {       
1363         uint256 totalSupply = totalSupply();    
1364         require(salePhase, "Can't mint");         
1365         require(quantity > 0, "Amount too small");
1366         require(quantity <= MAX_NFT_TRX, "Max 10 tokens per trx"); 
1367         require(NFT_PRICE * quantity == msg.value, "Sent ether val is incorrect");   
1368         require((totalSupply + quantity) <= MAX_SUPPLY, "Purchase exceeding max supply");                
1369 
1370         if(whitelistListEnabled) {
1371             require((wlAmount[msg.sender] + quantity) <= MAX_NFT_WALLET, "Can't mint more per wallet"); 
1372             require(MerkleProof.verify(_proof, root, keccak256(abi.encodePacked(msg.sender))), "Not whitelisted");   
1373             wlAmount[msg.sender] += quantity; 
1374         }        
1375         _safeMint(msg.sender, quantity);  
1376     }
1377 
1378     function airdrop(address to, uint256 quantity) public onlyOwner { 
1379         uint256 totalSupply = totalSupply();      
1380         require(quantity > 0, "Amount too small");
1381         require(quantity <= MAX_NFT_TRX, "Max 10 tokens per trx"); 
1382         require((totalSupply + quantity) <= MAX_SUPPLY, "Purchase exceeding max supply"); 
1383 
1384         _safeMint(to, quantity);        
1385     }
1386 
1387     function toggleSalePhase() public onlyOwner {
1388         salePhase = !salePhase;
1389     }
1390 
1391     function toggleWhitelist() public onlyOwner {
1392         whitelistListEnabled = !whitelistListEnabled;
1393     }
1394 
1395     function toggleReveal() public onlyOwner {
1396         isRevealed = !isRevealed;
1397     }
1398     
1399     function withdraw() public onlyOwner {
1400         uint256 balance = address(this).balance;
1401         payable(msg.sender).transfer(balance);
1402     } 
1403 
1404     function withdrawPercentages() public onlyOwner {
1405         uint256 balance = address(this).balance;
1406         payable(comm_wallet).transfer(balance * 8 / 100);
1407         payable(wallet_1).transfer(balance * 7 / 100);
1408         payable(wallet_2).transfer(balance * 9 / 100);
1409         payable(wallet_3).transfer(balance * 38 / 100);
1410         payable(wallet_4).transfer(balance * 38 / 100);
1411     } 
1412 
1413     function setRoot(uint256 _root) public onlyOwner {
1414         root = bytes32(_root);
1415     } 
1416 
1417     function setMaxPerWallet(uint256 _max) public onlyOwner {
1418         MAX_NFT_WALLET = _max;
1419     } 
1420 
1421     function setMaxSupply(uint256 _supply) public onlyOwner {
1422         MAX_SUPPLY = _supply;
1423     } 
1424 
1425     function setPrice(uint256 price) public onlyOwner {       
1426         NFT_PRICE = price;
1427     }
1428     
1429     function getBalance() public view onlyOwner returns (uint256){
1430         return address(this).balance;
1431     } 
1432 	
1433     function setBaseURI(string memory baseURI_) public onlyOwner {
1434         _baseTokenURI = baseURI_;        
1435     }
1436 
1437     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  
1438         require(
1439             _exists(tokenId),
1440             "ERC721Metadata: URI query for nonexistent token"
1441         );      
1442         if(!isRevealed)
1443             return _baseTokenURI;
1444             
1445         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _suffix));
1446     }
1447 }