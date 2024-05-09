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
336     // Mapping from token ID to staking timestamp
337     mapping(uint256 => uint64) private _stakingTimestamps;
338 
339     // Mapping from owner to operator approvals
340     mapping(address => mapping(address => bool)) private _operatorApprovals;
341 
342     constructor(string memory name_, string memory symbol_) {
343         _name = name_;
344         _symbol = symbol_;
345     }
346 
347     /**
348      * @dev See {IERC721Enumerable-totalSupply}.
349      */
350     function totalSupply() public view override returns (uint256) {
351         // Counter underflow is impossible as _burnCounter cannot be incremented
352         // more than _currentIndex times
353         unchecked {
354             return _currentIndex - _burnCounter;    
355         }
356     }
357 
358     function _totalStake(address _owner) internal view returns (uint256) {
359         uint256 result = 0;      
360         uint256[] memory tokens = walletOfOwner(_owner);
361 
362         for(uint256 i=0; i<tokens.length; i++) {
363             result += (uint64(block.timestamp) - _stakingTimestamps[tokens[i]]) * (uint(10)**uint(18)) / 28800;            
364         }
365         return result;
366     }
367 
368     function _claim(address _owner) internal returns (uint256) {        
369         uint256[] memory tokens = walletOfOwner(_owner);
370         require(tokens.length > 0, "Not a holder");
371 
372         uint256 stake = 0;
373         for(uint256 i=0; i<tokens.length; i++) {
374             stake += (uint64(block.timestamp) - _stakingTimestamps[tokens[i]]) * (uint(10)**uint(18)) / 28800;            
375         }
376         require(stake > 0, "Nothing to claim");
377         
378         for(uint256 i=0; i<tokens.length; i++) {           
379             _stakingTimestamps[tokens[i]] = uint64(block.timestamp);      
380         }
381         return stake;
382     }    
383 
384     /**
385      * @dev See {IERC721Enumerable-tokenByIndex}.
386      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
387      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
388      */
389     function tokenByIndex(uint256 index) public view override returns (uint256) {
390         uint256 numMintedSoFar = _currentIndex;
391         uint256 tokenIdsIdx;
392 
393         // Counter overflow is impossible as the loop breaks when
394         // uint256 i is equal to another uint256 numMintedSoFar.
395         unchecked {
396             for (uint256 i; i < numMintedSoFar; i++) {
397                 TokenOwnership memory ownership = _ownerships[i];
398                 if (!ownership.burned) {
399                     if (tokenIdsIdx == index) {
400                         return i;
401                     }
402                     tokenIdsIdx++;
403                 }
404             }
405         }
406         revert TokenIndexOutOfBounds();
407     }
408 
409     /**
410      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
411      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
412      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
413      */
414     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
415         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
416         uint256 numMintedSoFar = _currentIndex;
417         uint256 tokenIdsIdx;
418         address currOwnershipAddr;
419 
420         // Counter overflow is impossible as the loop breaks when
421         // uint256 i is equal to another uint256 numMintedSoFar.
422         unchecked {
423             for (uint256 i; i < numMintedSoFar; i++) {
424                 TokenOwnership memory ownership = _ownerships[i];
425                 if (ownership.burned) {
426                     continue;
427                 }
428                 if (ownership.addr != address(0)) {
429                     currOwnershipAddr = ownership.addr;
430                 }
431                 if (currOwnershipAddr == owner) {
432                     if (tokenIdsIdx == index) {
433                         return i;
434                     }
435                     tokenIdsIdx++;
436                 }
437             }
438         }
439 
440         // Execution should never reach this point.
441         revert();
442     }
443 
444     /**
445      * @dev See {IERC721Enumerable-walletOfOwner}.
446      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
447      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
448      */
449     function walletOfOwner(address owner) internal view returns (uint256[] memory) {        
450         uint256 numMintedSoFar = _currentIndex;      
451         uint256 tokenIdsIdx;  
452         address currOwnershipAddr;
453 
454         uint256[] memory tokens = new uint256[](balanceOf(owner));
455         if(balanceOf(owner) > 0)
456         {       
457             unchecked {
458                 for (uint256 i; i < numMintedSoFar; i++) {
459                     TokenOwnership memory ownership = _ownerships[i];
460                     if (ownership.burned) {
461                         continue;
462                     }
463                     if (ownership.addr != address(0)) {
464                         currOwnershipAddr = ownership.addr;
465                     }
466                     if (currOwnershipAddr == owner) {
467                         tokens[tokenIdsIdx] = i;
468                         tokenIdsIdx++;
469                     }
470                     if(tokenIdsIdx == balanceOf(owner))
471                         break;
472                 }
473             }
474         }
475         return tokens;
476     }
477 
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
482         return
483             interfaceId == type(IERC721).interfaceId ||
484             interfaceId == type(IERC721Metadata).interfaceId ||
485             interfaceId == type(IERC721Enumerable).interfaceId ||
486             super.supportsInterface(interfaceId);
487     }
488 
489     /**
490      * @dev See {IERC721-balanceOf}.
491      */
492     function balanceOf(address owner) public view override returns (uint256) {
493         if (owner == address(0)) revert BalanceQueryForZeroAddress();
494         return uint256(_addressData[owner].balance);
495     }
496 
497     function _numberMinted(address owner) internal view returns (uint256) {
498         if (owner == address(0)) revert MintedQueryForZeroAddress();
499         return uint256(_addressData[owner].numberMinted);
500     }
501 
502     function _numberBurned(address owner) internal view returns (uint256) {
503         if (owner == address(0)) revert BurnedQueryForZeroAddress();
504         return uint256(_addressData[owner].numberBurned);
505     }
506 
507     /**
508      * Gas spent here starts off proportional to the maximum mint batch size.
509      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
510      */
511     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
512         uint256 curr = tokenId;
513 
514         unchecked {
515             if (curr < _currentIndex) {
516                 TokenOwnership memory ownership = _ownerships[curr];
517                 if (!ownership.burned) {
518                     if (ownership.addr != address(0)) {
519                         return ownership;
520                     }
521                     // Invariant: 
522                     // There will always be an ownership that has an address and is not burned 
523                     // before an ownership that does not have an address and is not burned.
524                     // Hence, curr will not underflow.
525                     while (true) {
526                         curr--;
527                         ownership = _ownerships[curr];
528                         if (ownership.addr != address(0)) {
529                             return ownership;
530                         }
531                     }
532                 }
533             }
534         }
535         revert OwnerQueryForNonexistentToken();
536     }
537 
538     /**
539      * @dev See {IERC721-ownerOf}.
540      */
541     function ownerOf(uint256 tokenId) public view override returns (address) {
542         return ownershipOf(tokenId).addr;
543     }
544 
545     /**
546      * @dev See {IERC721Metadata-name}.
547      */
548     function name() public view virtual override returns (string memory) {
549         return _name;
550     }
551 
552     /**
553      * @dev See {IERC721Metadata-symbol}.
554      */
555     function symbol() public view virtual override returns (string memory) {
556         return _symbol;
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-tokenURI}.
561      */
562     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
563         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
564 
565         string memory baseURI = _baseURI();
566         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
567     }
568 
569     /**
570      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
571      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
572      * by default, can be overriden in child contracts.
573      */
574     function _baseURI() internal view virtual returns (string memory) {
575         return '';
576     }
577 
578     /**
579      * @dev See {IERC721-approve}.
580      */
581     function approve(address to, uint256 tokenId) public override {
582         address owner = ERC721A.ownerOf(tokenId);
583         if (to == owner) revert ApprovalToCurrentOwner();
584 
585         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
586             revert ApprovalCallerNotOwnerNorApproved();
587         }
588 
589         _approve(to, tokenId, owner);
590     }
591 
592     /**
593      * @dev See {IERC721-getApproved}.
594      */
595     function getApproved(uint256 tokenId) public view override returns (address) {
596         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
597 
598         return _tokenApprovals[tokenId];
599     }
600 
601     /**
602      * @dev See {IERC721-setApprovalForAll}.
603      */
604     function setApprovalForAll(address operator, bool approved) public override {
605         if (operator == _msgSender()) revert ApproveToCaller();
606 
607         _operatorApprovals[_msgSender()][operator] = approved;
608         emit ApprovalForAll(_msgSender(), operator, approved);
609     }
610 
611     /**
612      * @dev See {IERC721-isApprovedForAll}.
613      */
614     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
615         return _operatorApprovals[owner][operator];
616     }
617 
618     /**
619      * @dev See {IERC721-transferFrom}.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) public virtual override {
626         _transfer(from, to, tokenId);
627     }
628 
629     /**
630      * @dev See {IERC721-safeTransferFrom}.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) public virtual override {
637         safeTransferFrom(from, to, tokenId, '');
638     }
639 
640     /**
641      * @dev See {IERC721-safeTransferFrom}.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId,
647         bytes memory _data
648     ) public virtual override {
649         _transfer(from, to, tokenId);
650         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
651             revert TransferToNonERC721ReceiverImplementer();
652         }
653     }
654 
655     /**
656      * @dev Returns whether `tokenId` exists.
657      *
658      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
659      *
660      * Tokens start existing when they are minted (`_mint`),
661      */
662     function _exists(uint256 tokenId) internal view returns (bool) {
663         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
664     }
665 
666     function _safeMint(address to, uint256 quantity) internal {
667         _safeMint(to, quantity, '');
668     }
669 
670     /**
671      * @dev Safely mints `quantity` tokens and transfers them to `to`.
672      *
673      * Requirements:
674      *
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
676      * - `quantity` must be greater than 0.
677      *
678      * Emits a {Transfer} event.
679      */
680     function _safeMint(
681         address to,
682         uint256 quantity,
683         bytes memory _data
684     ) internal {
685         _mint(to, quantity, _data, true);
686     }
687 
688     /**
689      * @dev Mints `quantity` tokens and transfers them to `to`.
690      *
691      * Requirements:
692      *
693      * - `to` cannot be the zero address.
694      * - `quantity` must be greater than 0.
695      *
696      * Emits a {Transfer} event.
697      */
698     function _mint(
699         address to,
700         uint256 quantity,
701         bytes memory _data,
702         bool safe
703     ) internal {
704         uint256 startTokenId = _currentIndex;
705         if (to == address(0)) revert MintToZeroAddress();
706         if (quantity == 0) revert MintZeroQuantity();
707 
708         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
709 
710         // Overflows are incredibly unrealistic.
711         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
712         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
713         unchecked {
714             _addressData[to].balance += uint64(quantity);
715             _addressData[to].numberMinted += uint64(quantity);
716 
717             _ownerships[startTokenId].addr = to;
718             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
719 
720             uint256 updatedIndex = startTokenId;
721 
722             for (uint256 i; i < quantity; i++) {
723                 _stakingTimestamps[updatedIndex] = uint64(block.timestamp);
724                 emit Transfer(address(0), to, updatedIndex);
725                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
726                     revert TransferToNonERC721ReceiverImplementer();
727                 }
728                 updatedIndex++;
729             }
730 
731             _currentIndex = uint128(updatedIndex);
732         }
733         _afterTokenTransfers(address(0), to, startTokenId, quantity);
734     }
735 
736     /**
737      * @dev Transfers `tokenId` from `from` to `to`.
738      *
739      * Requirements:
740      *
741      * - `to` cannot be the zero address.
742      * - `tokenId` token must be owned by `from`.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _transfer(
747         address from,
748         address to,
749         uint256 tokenId
750     ) private {
751         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
752 
753         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
754             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
755             getApproved(tokenId) == _msgSender());
756 
757         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
758         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
759         if (to == address(0)) revert TransferToZeroAddress();
760 
761         _beforeTokenTransfers(from, to, tokenId, 1);
762 
763         // Clear approvals from the previous owner
764         _approve(address(0), tokenId, prevOwnership.addr);
765 
766         // Underflow of the sender's balance is impossible because we check for
767         // ownership above and the recipient's balance can't realistically overflow.
768         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
769         unchecked {
770             _addressData[from].balance -= 1;
771             _addressData[to].balance += 1;
772 
773             _ownerships[tokenId].addr = to;
774             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
775             _stakingTimestamps[tokenId] = uint64(block.timestamp);
776 
777             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
778             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
779             uint256 nextTokenId = tokenId + 1;
780             if (_ownerships[nextTokenId].addr == address(0)) {
781                 // This will suffice for checking _exists(nextTokenId),
782                 // as a burned slot cannot contain the zero address.
783                 if (nextTokenId < _currentIndex) {
784                     _ownerships[nextTokenId].addr = prevOwnership.addr;
785                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
786                 }
787             }
788         }
789 
790         emit Transfer(from, to, tokenId);
791         _afterTokenTransfers(from, to, tokenId, 1);
792     }
793 
794     /**
795      * @dev Destroys `tokenId`.
796      * The approval is cleared when the token is burned.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _burn(uint256 tokenId) internal virtual {
805         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
806 
807         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
808 
809         // Clear approvals from the previous owner
810         _approve(address(0), tokenId, prevOwnership.addr);
811 
812         // Underflow of the sender's balance is impossible because we check for
813         // ownership above and the recipient's balance can't realistically overflow.
814         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
815         unchecked {
816             _addressData[prevOwnership.addr].balance -= 1;
817             _addressData[prevOwnership.addr].numberBurned += 1;
818 
819             // Keep track of who burned the token, and the timestamp of burning.
820             _ownerships[tokenId].addr = prevOwnership.addr;
821             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
822             _ownerships[tokenId].burned = true;
823 
824             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
825             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
826             uint256 nextTokenId = tokenId + 1;
827             if (_ownerships[nextTokenId].addr == address(0)) {
828                 // This will suffice for checking _exists(nextTokenId),
829                 // as a burned slot cannot contain the zero address.
830                 if (nextTokenId < _currentIndex) {
831                     _ownerships[nextTokenId].addr = prevOwnership.addr;
832                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
833                 }
834             }
835         }
836 
837         emit Transfer(prevOwnership.addr, address(0), tokenId);
838         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
839 
840         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
841         unchecked { 
842             _burnCounter++;
843         }
844     }
845 
846     /**
847      * @dev Approve `to` to operate on `tokenId`
848      *
849      * Emits a {Approval} event.
850      */
851     function _approve(
852         address to,
853         uint256 tokenId,
854         address owner
855     ) private {
856         _tokenApprovals[tokenId] = to;
857         emit Approval(owner, to, tokenId);
858     }
859 
860     /**
861      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
862      * The call is not executed if the target address is not a contract.
863      *
864      * @param from address representing the previous owner of the given token ID
865      * @param to target address that will receive the tokens
866      * @param tokenId uint256 ID of the token to be transferred
867      * @param _data bytes optional data to send along with the call
868      * @return bool whether the call correctly returned the expected magic value
869      */
870     function _checkOnERC721Received(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) private returns (bool) {
876         if (to.isContract()) {
877             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
878                 return retval == IERC721Receiver(to).onERC721Received.selector;
879             } catch (bytes memory reason) {
880                 if (reason.length == 0) {
881                     revert TransferToNonERC721ReceiverImplementer();
882                 } else {
883                     assembly {
884                         revert(add(32, reason), mload(reason))
885                     }
886                 }
887             }
888         } else {
889             return true;
890         }
891     }
892 
893     /**
894      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
895      * And also called before burning one token.
896      *
897      * startTokenId - the first token id to be transferred
898      * quantity - the amount to be transferred
899      *
900      * Calling conditions:
901      *
902      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
903      * transferred to `to`.
904      * - When `from` is zero, `tokenId` will be minted for `to`.
905      * - When `to` is zero, `tokenId` will be burned by `from`.
906      * - `from` and `to` are never both zero.
907      */
908     function _beforeTokenTransfers(
909         address from,
910         address to,
911         uint256 startTokenId,
912         uint256 quantity
913     ) internal virtual {}
914 
915     /**
916      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
917      * minting.
918      * And also called after one token has been burned.
919      *
920      * startTokenId - the first token id to be transferred
921      * quantity - the amount to be transferred
922      *
923      * Calling conditions:
924      *
925      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
926      * transferred to `to`.
927      * - When `from` is zero, `tokenId` has been minted for `to`.
928      * - When `to` is zero, `tokenId` has been burned by `from`.
929      * - `from` and `to` are never both zero.
930      */
931     function _afterTokenTransfers(
932         address from,
933         address to,
934         uint256 startTokenId,
935         uint256 quantity
936     ) internal virtual {}
937 }
938 
939 // File: @openzeppelin/contracts/utils/Strings.sol
940 /**
941  * @dev String operations.
942  */
943 library Strings {
944     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
945 
946     /**
947      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
948      */
949     function toString(uint256 value) internal pure returns (string memory) {
950         // Inspired by OraclizeAPI's implementation - MIT licence
951         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
952 
953         if (value == 0) {
954             return "0";
955         }
956         uint256 temp = value;
957         uint256 digits;
958         while (temp != 0) {
959             digits++;
960             temp /= 10;
961         }
962         bytes memory buffer = new bytes(digits);
963         while (value != 0) {
964             digits -= 1;
965             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
966             value /= 10;
967         }
968         return string(buffer);
969     }
970 
971     /**
972      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
973      */
974     function toHexString(uint256 value) internal pure returns (string memory) {
975         if (value == 0) {
976             return "0x00";
977         }
978         uint256 temp = value;
979         uint256 length = 0;
980         while (temp != 0) {
981             length++;
982             temp >>= 8;
983         }
984         return toHexString(value, length);
985     }
986 
987     /**
988      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
989      */
990     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
991         bytes memory buffer = new bytes(2 * length + 2);
992         buffer[0] = "0";
993         buffer[1] = "x";
994         for (uint256 i = 2 * length + 1; i > 1; --i) {
995             buffer[i] = _HEX_SYMBOLS[value & 0xf];
996             value >>= 4;
997         }
998         require(value == 0, "Strings: hex length insufficient");
999         return string(buffer);
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/utils/Address.sol
1004 /**
1005  * @dev Collection of functions related to the address type
1006  */
1007 library Address {
1008     /**
1009      * @dev Returns true if `account` is a contract.
1010      *
1011      * [IMPORTANT]
1012      * ====
1013      * It is unsafe to assume that an address for which this function returns
1014      * false is an externally-owned account (EOA) and not a contract.
1015      *
1016      * Among others, `isContract` will return false for the following
1017      * types of addresses:
1018      *
1019      *  - an externally-owned account
1020      *  - a contract in construction
1021      *  - an address where a contract will be created
1022      *  - an address where a contract lived, but was destroyed
1023      * ====
1024      */
1025     function isContract(address account) internal view returns (bool) {
1026         // This method relies on extcodesize, which returns 0 for contracts in
1027         // construction, since the code is only stored at the end of the
1028         // constructor execution.
1029 
1030         uint256 size;
1031         assembly {
1032             size := extcodesize(account)
1033         }
1034         return size > 0;
1035     }
1036 
1037     /**
1038      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1039      * `recipient`, forwarding all available gas and reverting on errors.
1040      *
1041      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1042      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1043      * imposed by `transfer`, making them unable to receive funds via
1044      * `transfer`. {sendValue} removes this limitation.
1045      *
1046      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1047      *
1048      * IMPORTANT: because control is transferred to `recipient`, care must be
1049      * taken to not create reentrancy vulnerabilities. Consider using
1050      * {ReentrancyGuard} or the
1051      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1052      */
1053     function sendValue(address payable recipient, uint256 amount) internal {
1054         require(address(this).balance >= amount, "Address: insufficient balance");
1055 
1056         (bool success, ) = recipient.call{value: amount}("");
1057         require(success, "Address: unable to send value, recipient may have reverted");
1058     }
1059 
1060     /**
1061      * @dev Performs a Solidity function call using a low level `call`. A
1062      * plain `call` is an unsafe replacement for a function call: use this
1063      * function instead.
1064      *
1065      * If `target` reverts with a revert reason, it is bubbled up by this
1066      * function (like regular Solidity function calls).
1067      *
1068      * Returns the raw returned data. To convert to the expected return value,
1069      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1070      *
1071      * Requirements:
1072      *
1073      * - `target` must be a contract.
1074      * - calling `target` with `data` must not revert.
1075      *
1076      * _Available since v3.1._
1077      */
1078     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1079         return functionCall(target, data, "Address: low-level call failed");
1080     }
1081 
1082     /**
1083      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1084      * `errorMessage` as a fallback revert reason when `target` reverts.
1085      *
1086      * _Available since v3.1._
1087      */
1088     function functionCall(
1089         address target,
1090         bytes memory data,
1091         string memory errorMessage
1092     ) internal returns (bytes memory) {
1093         return functionCallWithValue(target, data, 0, errorMessage);
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1098      * but also transferring `value` wei to `target`.
1099      *
1100      * Requirements:
1101      *
1102      * - the calling contract must have an ETH balance of at least `value`.
1103      * - the called Solidity function must be `payable`.
1104      *
1105      * _Available since v3.1._
1106      */
1107     function functionCallWithValue(
1108         address target,
1109         bytes memory data,
1110         uint256 value
1111     ) internal returns (bytes memory) {
1112         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1113     }
1114 
1115     /**
1116      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1117      * with `errorMessage` as a fallback revert reason when `target` reverts.
1118      *
1119      * _Available since v3.1._
1120      */
1121     function functionCallWithValue(
1122         address target,
1123         bytes memory data,
1124         uint256 value,
1125         string memory errorMessage
1126     ) internal returns (bytes memory) {
1127         require(address(this).balance >= value, "Address: insufficient balance for call");
1128         require(isContract(target), "Address: call to non-contract");
1129 
1130         (bool success, bytes memory returndata) = target.call{value: value}(data);
1131         return _verifyCallResult(success, returndata, errorMessage);
1132     }
1133 
1134     /**
1135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1136      * but performing a static call.
1137      *
1138      * _Available since v3.3._
1139      */
1140     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1141         return functionStaticCall(target, data, "Address: low-level static call failed");
1142     }
1143 
1144     /**
1145      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1146      * but performing a static call.
1147      *
1148      * _Available since v3.3._
1149      */
1150     function functionStaticCall(
1151         address target,
1152         bytes memory data,
1153         string memory errorMessage
1154     ) internal view returns (bytes memory) {
1155         require(isContract(target), "Address: static call to non-contract");
1156 
1157         (bool success, bytes memory returndata) = target.staticcall(data);
1158         return _verifyCallResult(success, returndata, errorMessage);
1159     }
1160 
1161     /**
1162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1163      * but performing a delegate call.
1164      *
1165      * _Available since v3.4._
1166      */
1167     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1168         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1169     }
1170 
1171     /**
1172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1173      * but performing a delegate call.
1174      *
1175      * _Available since v3.4._
1176      */
1177     function functionDelegateCall(
1178         address target,
1179         bytes memory data,
1180         string memory errorMessage
1181     ) internal returns (bytes memory) {
1182         require(isContract(target), "Address: delegate call to non-contract");
1183 
1184         (bool success, bytes memory returndata) = target.delegatecall(data);
1185         return _verifyCallResult(success, returndata, errorMessage);
1186     }
1187 
1188     function _verifyCallResult(
1189         bool success,
1190         bytes memory returndata,
1191         string memory errorMessage
1192     ) private pure returns (bytes memory) {
1193         if (success) {
1194             return returndata;
1195         } else {
1196             // Look for revert reason and bubble it up if present
1197             if (returndata.length > 0) {
1198                 // The easiest way to bubble the revert reason is using memory via assembly
1199 
1200                 assembly {
1201                     let returndata_size := mload(returndata)
1202                     revert(add(32, returndata), returndata_size)
1203                 }
1204             } else {
1205                 revert(errorMessage);
1206             }
1207         }
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1212 /**
1213  * @title ERC721 token receiver interface
1214  * @dev Interface for any contract that wants to support safeTransfers
1215  * from ERC721 asset contracts.
1216  */
1217 interface IERC721Receiver {
1218     /**
1219      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1220      * by `operator` from `from`, this function is called.
1221      *
1222      * It must return its Solidity selector to confirm the token transfer.
1223      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1224      *
1225      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1226      */
1227     function onERC721Received(
1228         address operator,
1229         address from,
1230         uint256 tokenId,
1231         bytes calldata data
1232     ) external returns (bytes4);
1233 }
1234 
1235 /**
1236  * @dev Contract module which provides a basic access control mechanism, where
1237  * there is an account (an owner) that can be granted exclusive access to
1238  * specific functions.
1239  *
1240  * By default, the owner account will be the one that deploys the contract. This
1241  * can later be changed with {transferOwnership}.
1242  *
1243  * This module is used through inheritance. It will make available the modifier
1244  * `onlyOwner`, which can be applied to your functions to restrict their use to
1245  * the owner.
1246  */
1247 abstract contract Ownable is Context {
1248     address private _owner;
1249 
1250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1251 
1252     /**
1253      * @dev Initializes the contract setting the deployer as the initial owner.
1254      */
1255     constructor() {
1256         _setOwner(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns the address of the current owner.
1261      */
1262     function owner() public view virtual returns (address) {
1263         return _owner;
1264     }
1265 
1266     /**
1267      * @dev Throws if called by any account other than the owner.
1268      */
1269     modifier onlyOwner() {
1270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1271         _;
1272     }
1273 
1274     /**
1275      * @dev Leaves the contract without owner. It will not be possible to call
1276      * `onlyOwner` functions anymore. Can only be called by the current owner.
1277      *
1278      * NOTE: Renouncing ownership will leave the contract without an owner,
1279      * thereby removing any functionality that is only available to the owner.
1280      */
1281     function renounceOwnership() public virtual onlyOwner {
1282         _setOwner(address(0));
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(newOwner != address(0), "Ownable: new owner is the zero address");
1291         _setOwner(newOwner);
1292     }
1293 
1294     function _setOwner(address newOwner) private {
1295         address oldOwner = _owner;
1296         _owner = newOwner;
1297         emit OwnershipTransferred(oldOwner, newOwner);
1298     }
1299 }
1300 
1301 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1302 /**
1303  * @dev These functions deal with verification of Merkle Trees proofs.
1304  *
1305  * The proofs can be generated using the JavaScript library
1306  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1307  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1308  *
1309  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1310  */
1311 library MerkleProof {
1312     /**
1313      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1314      * defined by `root`. For this, a `proof` must be provided, containing
1315      * sibling hashes on the branch from the leaf to the root of the tree. Each
1316      * pair of leaves and each pair of pre-images are assumed to be sorted.
1317      */
1318     function verify(
1319         bytes32[] memory proof,
1320         bytes32 root,
1321         bytes32 leaf
1322     ) internal pure returns (bool) {
1323         return processProof(proof, leaf) == root;
1324     }
1325 
1326     /**
1327      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1328      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1329      * hash matches the root of the tree. When processing the proof, the pairs
1330      * of leafs & pre-images are assumed to be sorted.
1331      *
1332      * _Available since v4.4._
1333      */
1334     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1335         bytes32 computedHash = leaf;
1336         for (uint256 i = 0; i < proof.length; i++) {
1337             bytes32 proofElement = proof[i];
1338             if (computedHash <= proofElement) {
1339                 // Hash(current computed hash + current element of the proof)
1340                 computedHash = _efficientHash(computedHash, proofElement);
1341             } else {
1342                 // Hash(current element of the proof + current computed hash)
1343                 computedHash = _efficientHash(proofElement, computedHash);
1344             }
1345         }
1346         return computedHash;
1347     }
1348 
1349     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1350         assembly {
1351             mstore(0x00, a)
1352             mstore(0x20, b)
1353             value := keccak256(0x00, 0x40)
1354         }
1355     }
1356 }
1357 
1358 // File: VaccinatedSloths
1359 
1360 abstract contract VaccinatedSloths {    
1361     function vaccinate(address recipient, uint256 amount) public virtual;      
1362 }
1363 
1364 // File: CryoPreservation
1365 
1366 abstract contract CryoPreservation {
1367     function decryogenize(address recipient, string[] memory reason) public virtual;  
1368 }
1369 
1370 abstract contract SlothToken {    
1371     function transferFrom(
1372         address sender,
1373         address recipient,
1374         uint256 amount
1375     ) public virtual returns (bool);
1376 }
1377 
1378 // File: Sloths.sol
1379 
1380 contract Sloths is ERC721A, Ownable {  
1381     using Address for address;
1382     using Strings for uint256;
1383 
1384     struct VaccinationStatus { 
1385         uint256 tokenId;
1386         bool vaccinated;
1387     }
1388     
1389     uint256 public MAX_NFT_WALLET = 2; 
1390     uint256 public constant MAX_NFT_TRX = 10;          
1391     uint256 public constant MAX_SUPPLY = 4444;
1392     uint256 public constant RESERVED_AMOUNT = 200;    
1393 
1394     bool public isRevealed = false;
1395     bool public vaccinationPhase = false;    
1396     bool public publicSalePhase = false;
1397     bool public allowListEnabled = true;
1398     bool public claimTokensEnabled = false;
1399 
1400     address private _vaccinationContract;
1401     address private _tokenContract;    
1402     address private _tokenWallet;    
1403 
1404     string private _baseTokenURI;
1405     string private _suffix = ".json";
1406     bytes32 private root;    
1407 
1408     mapping(address => uint256) private walletAdoptedAmount;
1409     mapping(uint256 => bool) private _vaccinatedSloths;   
1410     
1411     constructor() ERC721A("Casual Sloths","CSLOTHS") {        
1412         _safeMint(0x1EB1Ea9f19D14fEc432714f4db7aA2240864246C, 150);
1413         _safeMint(0x4fE440D856059f08e0301a5Edc40556e73e4A600, 25);
1414         _safeMint(0x1BC80b413562Bc3362f7e8d7431255d5D18441a7, 25);
1415     }
1416 
1417     function adopt(uint256 quantity, bytes32[] memory _proof) public {       
1418         uint256 totalSupply = totalSupply();    
1419         require(publicSalePhase, "Can't adopt");         
1420         require(quantity > 0, "Amount too small");
1421         require(quantity <= MAX_NFT_TRX, "Max 10 tokens per trx"); 
1422         require((totalSupply + quantity) <= MAX_SUPPLY, "Purchase exceeding max supply"); 
1423         require((walletAdoptedAmount[msg.sender] + quantity) <= MAX_NFT_WALLET, "Can't adopt more per wallet");        
1424 
1425         if(allowListEnabled) 
1426             require(MerkleProof.verify(_proof, root, keccak256(abi.encodePacked(msg.sender))), "Not allowed to mint");    
1427 
1428         walletAdoptedAmount[msg.sender] += quantity;
1429         _safeMint(msg.sender, quantity);  
1430     }
1431 
1432     function vaccinateSloths(uint256[] memory tokenIds) public {        
1433         require(vaccinationPhase, "Vaccination phase not started");
1434         require(tokenIds.length > 0, "Amount too small");
1435         require(tokenIds.length <= MAX_NFT_TRX, "Max 10 tokens per trx"); 
1436 
1437         for (uint256 i = 0; i < tokenIds.length; i++) {
1438             if(ownerOf(tokenIds[i]) != msg.sender || _vaccinatedSloths[tokenIds[i]] == true)
1439                 revert("Invalid token passed");
1440 
1441             _vaccinatedSloths[tokenIds[i]] = true;
1442         }
1443         VaccinatedSloths(_vaccinationContract).vaccinate(msg.sender, tokenIds.length);         
1444     }
1445 
1446     function isVaccinated(uint256 skip, uint256 take) public view returns (VaccinationStatus[] memory) {
1447         require(take > 0, "Amount too small");        
1448 
1449         VaccinationStatus[] memory result = new VaccinationStatus[](take);
1450         for (uint256 i = skip; i < (skip + take); i++) {            
1451             result[i].tokenId = i;
1452             result[i].vaccinated = _vaccinatedSloths[i];
1453         }
1454         return result;        
1455     }   
1456 
1457     function togglePublicSalePhase() public onlyOwner {
1458         publicSalePhase = !publicSalePhase;
1459     }
1460 
1461     function toggleAllowlist() public onlyOwner {
1462         allowListEnabled = !allowListEnabled;
1463     }
1464 
1465     function toggleReveal() public onlyOwner {
1466         isRevealed = !isRevealed;
1467     }
1468 
1469     function toggleVaccinationPhase() public onlyOwner {
1470         vaccinationPhase = !vaccinationPhase;
1471     }
1472 
1473     function toggleClaimTokens() public onlyOwner {
1474         claimTokensEnabled = !claimTokensEnabled;
1475     }
1476     
1477     function withdraw() public onlyOwner {
1478         uint256 balance = address(this).balance;
1479         payable(msg.sender).transfer(balance);
1480     }    
1481 
1482     function setVaccinationContract(address _contract) public onlyOwner {
1483         _vaccinationContract = _contract;
1484     }
1485 
1486     function setTokenContract(address _contract, address _wallet) public onlyOwner {
1487         _tokenContract = _contract;
1488         _tokenWallet = _wallet;
1489     } 
1490 
1491     function setRoot(uint256 _root) public onlyOwner {
1492         root = bytes32(_root);
1493     } 
1494 
1495     function setMaxPerWallet(uint256 _max) public onlyOwner {
1496         MAX_NFT_WALLET = _max;
1497     } 
1498     
1499     function getBalance() public view onlyOwner returns (uint256){
1500         return address(this).balance;
1501     } 
1502 	
1503     function setBaseURI(string memory baseURI_, string memory suffix) public onlyOwner {
1504         _baseTokenURI = baseURI_;
1505         _suffix = suffix;
1506     }
1507 
1508     function claimTokens() public {    
1509         require(claimTokensEnabled, "Cant claim tokens");
1510 
1511         uint256 tokens = _claim(msg.sender);
1512         SlothToken(_tokenContract).transferFrom(_tokenWallet, msg.sender, tokens);
1513     }
1514 
1515     function totalStake(address _owner) public view returns (uint256) {            
1516         return _totalStake(_owner);
1517     }
1518 
1519     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  
1520         require(
1521             _exists(tokenId),
1522             "ERC721Metadata: URI query for nonexistent token"
1523         );      
1524         if(!isRevealed)
1525             return _baseTokenURI;
1526             
1527         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _suffix));
1528     }
1529 }