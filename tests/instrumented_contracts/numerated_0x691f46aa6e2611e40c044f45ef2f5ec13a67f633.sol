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
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Enumerable is IERC721 {
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Implementation of the {IERC165} interface.
253  *
254  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
255  * for the additional interface id that will be supported. For example:
256  *
257  * ```solidity
258  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
259  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
260  * }
261  * ```
262  *
263  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
264  */
265 abstract contract ERC165 is IERC165 {
266     /**
267      * @dev See {IERC165-supportsInterface}.
268      */
269     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270         return interfaceId == type(IERC165).interfaceId;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
280  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
281  *
282  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
283  *
284  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
285  *
286  * Does not support burning tokens to address(0).
287  */
288 contract ERC721A is
289   Context,
290   ERC165,
291   IERC721,
292   IERC721Metadata,
293   IERC721Enumerable
294 {
295   using Address for address;
296   using Strings for uint256;
297 
298   struct TokenOwnership {
299     address addr;
300     uint64 startTimestamp;
301   }
302 
303   struct AddressData {
304     uint128 balance;
305     uint128 numberMinted;
306   }
307 
308   uint256 private currentIndex = 0;
309 
310   uint256 internal immutable collectionSize;
311   uint256 internal immutable maxBatchSize;
312 
313   // Token name
314   string private _name;
315 
316   // Token symbol
317   string private _symbol;
318 
319   // Mapping from token ID to ownership details
320   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
321   mapping(uint256 => TokenOwnership) private _ownerships;
322 
323   // Mapping owner address to address data
324   mapping(address => AddressData) private _addressData;
325 
326   // Mapping from token ID to approved address
327   mapping(uint256 => address) private _tokenApprovals;
328 
329   // Mapping from owner to operator approvals
330   mapping(address => mapping(address => bool)) private _operatorApprovals;
331 
332   /**
333    * @dev
334    * `maxBatchSize` refers to how much a minter can mint at a time.
335    * `collectionSize_` refers to how many tokens are in the collection.
336    */
337   constructor(
338     string memory name_,
339     string memory symbol_,
340     uint256 maxBatchSize_,
341     uint256 collectionSize_
342   ) {
343     require(
344       collectionSize_ > 0,
345       "ERC721A: collection must have a nonzero supply"
346     );
347     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
348     _name = name_;
349     _symbol = symbol_;
350     maxBatchSize = maxBatchSize_;
351     collectionSize = collectionSize_;
352   }
353 
354   /**
355    * @dev See {IERC721Enumerable-totalSupply}.
356    */
357   function totalSupply() public view override returns (uint256) {
358     return currentIndex;
359   }
360 
361   /**
362    * @dev See {IERC721Enumerable-tokenByIndex}.
363    */
364   function tokenByIndex(uint256 index) public view override returns (uint256) {
365     require(index < totalSupply(), "ERC721A: global index out of bounds");
366     return index;
367   }
368 
369   /**
370    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
371    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
372    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
373    */
374   function tokenOfOwnerByIndex(address owner, uint256 index)
375     public
376     view
377     override
378     returns (uint256)
379   {
380     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
381     uint256 numMintedSoFar = totalSupply();
382     uint256 tokenIdsIdx = 0;
383     address currOwnershipAddr = address(0);
384     for (uint256 i = 0; i < numMintedSoFar; i++) {
385       TokenOwnership memory ownership = _ownerships[i];
386       if (ownership.addr != address(0)) {
387         currOwnershipAddr = ownership.addr;
388       }
389       if (currOwnershipAddr == owner) {
390         if (tokenIdsIdx == index) {
391           return i;
392         }
393         tokenIdsIdx++;
394       }
395     }
396     revert("ERC721A: unable to get token of owner by index");
397   }
398 
399   /**
400    * @dev See {IERC165-supportsInterface}.
401    */
402   function supportsInterface(bytes4 interfaceId)
403     public
404     view
405     virtual
406     override(ERC165, IERC165)
407     returns (bool)
408   {
409     return
410       interfaceId == type(IERC721).interfaceId ||
411       interfaceId == type(IERC721Metadata).interfaceId ||
412       interfaceId == type(IERC721Enumerable).interfaceId ||
413       super.supportsInterface(interfaceId);
414   }
415 
416   /**
417    * @dev See {IERC721-balanceOf}.
418    */
419   function balanceOf(address owner) public view override returns (uint256) {
420     require(owner != address(0), "ERC721A: balance query for the zero address");
421     return uint256(_addressData[owner].balance);
422   }
423 
424   function _numberMinted(address owner) internal view returns (uint256) {
425     require(
426       owner != address(0),
427       "ERC721A: number minted query for the zero address"
428     );
429     return uint256(_addressData[owner].numberMinted);
430   }
431 
432   function ownershipOf(uint256 tokenId)
433     internal
434     view
435     returns (TokenOwnership memory)
436   {
437     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
438 
439     uint256 lowestTokenToCheck;
440     if (tokenId >= maxBatchSize) {
441       lowestTokenToCheck = tokenId - maxBatchSize + 1;
442     }
443 
444     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
445       TokenOwnership memory ownership = _ownerships[curr];
446       if (ownership.addr != address(0)) {
447         return ownership;
448       }
449     }
450 
451     revert("ERC721A: unable to determine the owner of token");
452   }
453 
454   /**
455    * @dev See {IERC721-ownerOf}.
456    */
457   function ownerOf(uint256 tokenId) public view override returns (address) {
458     return ownershipOf(tokenId).addr;
459   }
460 
461   /**
462    * @dev See {IERC721Metadata-name}.
463    */
464   function name() public view virtual override returns (string memory) {
465     return _name;
466   }
467 
468   /**
469    * @dev See {IERC721Metadata-symbol}.
470    */
471   function symbol() public view virtual override returns (string memory) {
472     return _symbol;
473   }
474 
475   /**
476    * @dev See {IERC721Metadata-tokenURI}.
477    */
478   function tokenURI(uint256 tokenId)
479     public
480     view
481     virtual
482     override
483     returns (string memory)
484   {
485     require(
486       _exists(tokenId),
487       "ERC721Metadata: URI query for nonexistent token"
488     );
489 
490     string memory baseURI = _baseURI();
491     return
492       bytes(baseURI).length > 0
493         ? string(abi.encodePacked(baseURI, tokenId.toString()))
494         : "";
495   }
496 
497   /**
498    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
499    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
500    * by default, can be overriden in child contracts.
501    */
502   function _baseURI() internal view virtual returns (string memory) {
503     return "";
504   }
505 
506   /**
507    * @dev See {IERC721-approve}.
508    */
509   function approve(address to, uint256 tokenId) public override {
510     address owner = ERC721A.ownerOf(tokenId);
511     require(to != owner, "ERC721A: approval to current owner");
512 
513     require(
514       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
515       "ERC721A: approve caller is not owner nor approved for all"
516     );
517 
518     _approve(to, tokenId, owner);
519   }
520 
521   /**
522    * @dev See {IERC721-getApproved}.
523    */
524   function getApproved(uint256 tokenId) public view override returns (address) {
525     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
526 
527     return _tokenApprovals[tokenId];
528   }
529 
530   /**
531    * @dev See {IERC721-setApprovalForAll}.
532    */
533   function setApprovalForAll(address operator, bool approved) public override {
534     require(operator != _msgSender(), "ERC721A: approve to caller");
535 
536     _operatorApprovals[_msgSender()][operator] = approved;
537     emit ApprovalForAll(_msgSender(), operator, approved);
538   }
539 
540   /**
541    * @dev See {IERC721-isApprovedForAll}.
542    */
543   function isApprovedForAll(address owner, address operator)
544     public
545     view
546     virtual
547     override
548     returns (bool)
549   {
550     return _operatorApprovals[owner][operator];
551   }
552 
553   /**
554    * @dev See {IERC721-transferFrom}.
555    */
556   function transferFrom(
557     address from,
558     address to,
559     uint256 tokenId
560   ) public override {
561     _transfer(from, to, tokenId);
562   }
563 
564   /**
565    * @dev See {IERC721-safeTransferFrom}.
566    */
567   function safeTransferFrom(
568     address from,
569     address to,
570     uint256 tokenId
571   ) public override {
572     safeTransferFrom(from, to, tokenId, "");
573   }
574 
575   /**
576    * @dev See {IERC721-safeTransferFrom}.
577    */
578   function safeTransferFrom(
579     address from,
580     address to,
581     uint256 tokenId,
582     bytes memory _data
583   ) public override {
584     _transfer(from, to, tokenId);
585     require(
586       _checkOnERC721Received(from, to, tokenId, _data),
587       "ERC721A: transfer to non ERC721Receiver implementer"
588     );
589   }
590 
591   /**
592    * @dev Returns whether `tokenId` exists.
593    *
594    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
595    *
596    * Tokens start existing when they are minted (`_mint`),
597    */
598   function _exists(uint256 tokenId) internal view returns (bool) {
599     return tokenId < currentIndex;
600   }
601 
602   function _safeMint(address to, uint256 quantity) internal {
603     _safeMint(to, quantity, "");
604   }
605 
606   /**
607    * @dev Mints `quantity` tokens and transfers them to `to`.
608    *
609    * Requirements:
610    *
611    * - there must be `quantity` tokens remaining unminted in the total collection.
612    * - `to` cannot be the zero address.
613    * - `quantity` cannot be larger than the max batch size.
614    *
615    * Emits a {Transfer} event.
616    */
617   function _safeMint(
618     address to,
619     uint256 quantity,
620     bytes memory _data
621   ) internal {
622     uint256 startTokenId = currentIndex;
623     require(to != address(0), "ERC721A: mint to the zero address");
624     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
625     require(!_exists(startTokenId), "ERC721A: token already minted");
626     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
627 
628     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
629 
630     AddressData memory addressData = _addressData[to];
631     _addressData[to] = AddressData(
632       addressData.balance + uint128(quantity),
633       addressData.numberMinted + uint128(quantity)
634     );
635     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
636 
637     uint256 updatedIndex = startTokenId;
638 
639     for (uint256 i = 0; i < quantity; i++) {
640       emit Transfer(address(0), to, updatedIndex);
641       require(
642         _checkOnERC721Received(address(0), to, updatedIndex, _data),
643         "ERC721A: transfer to non ERC721Receiver implementer"
644       );
645       updatedIndex++;
646     }
647 
648     currentIndex = updatedIndex;
649     _afterTokenTransfers(address(0), to, startTokenId, quantity);
650   }
651 
652   /**
653    * @dev Transfers `tokenId` from `from` to `to`.
654    *
655    * Requirements:
656    *
657    * - `to` cannot be the zero address.
658    * - `tokenId` token must be owned by `from`.
659    *
660    * Emits a {Transfer} event.
661    */
662   function _transfer(
663     address from,
664     address to,
665     uint256 tokenId
666   ) private {
667     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
668 
669     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
670       getApproved(tokenId) == _msgSender() ||
671       isApprovedForAll(prevOwnership.addr, _msgSender()));
672 
673     require(
674       isApprovedOrOwner,
675       "ERC721A: transfer caller is not owner nor approved"
676     );
677 
678     require(
679       prevOwnership.addr == from,
680       "ERC721A: transfer from incorrect owner"
681     );
682     require(to != address(0), "ERC721A: transfer to the zero address");
683 
684     _beforeTokenTransfers(from, to, tokenId, 1);
685 
686     // Clear approvals from the previous owner
687     _approve(address(0), tokenId, prevOwnership.addr);
688 
689     _addressData[from].balance -= 1;
690     _addressData[to].balance += 1;
691     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
692 
693     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
694     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
695     uint256 nextTokenId = tokenId + 1;
696     if (_ownerships[nextTokenId].addr == address(0)) {
697       if (_exists(nextTokenId)) {
698         _ownerships[nextTokenId] = TokenOwnership(
699           prevOwnership.addr,
700           prevOwnership.startTimestamp
701         );
702       }
703     }
704 
705     emit Transfer(from, to, tokenId);
706     _afterTokenTransfers(from, to, tokenId, 1);
707   }
708 
709   /**
710    * @dev Approve `to` to operate on `tokenId`
711    *
712    * Emits a {Approval} event.
713    */
714   function _approve(
715     address to,
716     uint256 tokenId,
717     address owner
718   ) private {
719     _tokenApprovals[tokenId] = to;
720     emit Approval(owner, to, tokenId);
721   }
722 
723   uint256 public nextOwnerToExplicitlySet = 0;
724 
725   /**
726    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
727    */
728   function _setOwnersExplicit(uint256 quantity) internal {
729     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
730     require(quantity > 0, "quantity must be nonzero");
731     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
732     if (endIndex > collectionSize - 1) {
733       endIndex = collectionSize - 1;
734     }
735     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
736     require(_exists(endIndex), "not enough minted yet for this cleanup");
737     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
738       if (_ownerships[i].addr == address(0)) {
739         TokenOwnership memory ownership = ownershipOf(i);
740         _ownerships[i] = TokenOwnership(
741           ownership.addr,
742           ownership.startTimestamp
743         );
744       }
745     }
746     nextOwnerToExplicitlySet = endIndex + 1;
747   }
748 
749   /**
750    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
751    * The call is not executed if the target address is not a contract.
752    *
753    * @param from address representing the previous owner of the given token ID
754    * @param to target address that will receive the tokens
755    * @param tokenId uint256 ID of the token to be transferred
756    * @param _data bytes optional data to send along with the call
757    * @return bool whether the call correctly returned the expected magic value
758    */
759   function _checkOnERC721Received(
760     address from,
761     address to,
762     uint256 tokenId,
763     bytes memory _data
764   ) private returns (bool) {
765     if (to.isContract()) {
766       try
767         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
768       returns (bytes4 retval) {
769         return retval == IERC721Receiver(to).onERC721Received.selector;
770       } catch (bytes memory reason) {
771         if (reason.length == 0) {
772           revert("ERC721A: transfer to non ERC721Receiver implementer");
773         } else {
774           assembly {
775             revert(add(32, reason), mload(reason))
776           }
777         }
778       }
779     } else {
780       return true;
781     }
782   }
783 
784   /**
785    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
786    *
787    * startTokenId - the first token id to be transferred
788    * quantity - the amount to be transferred
789    *
790    * Calling conditions:
791    *
792    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
793    * transferred to `to`.
794    * - When `from` is zero, `tokenId` will be minted for `to`.
795    */
796   function _beforeTokenTransfers(
797     address from,
798     address to,
799     uint256 startTokenId,
800     uint256 quantity
801   ) internal virtual {}
802 
803   /**
804    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
805    * minting.
806    *
807    * startTokenId - the first token id to be transferred
808    * quantity - the amount to be transferred
809    *
810    * Calling conditions:
811    *
812    * - when `from` and `to` are both non-zero.
813    * - `from` and `to` are never both zero.
814    */
815   function _afterTokenTransfers(
816     address from,
817     address to,
818     uint256 startTokenId,
819     uint256 quantity
820   ) internal virtual {}
821 }
822 
823 // File: @openzeppelin/contracts/utils/Strings.sol
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev String operations.
829  */
830 library Strings {
831     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
832 
833     /**
834      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
835      */
836     function toString(uint256 value) internal pure returns (string memory) {
837         // Inspired by OraclizeAPI's implementation - MIT licence
838         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
839 
840         if (value == 0) {
841             return "0";
842         }
843         uint256 temp = value;
844         uint256 digits;
845         while (temp != 0) {
846             digits++;
847             temp /= 10;
848         }
849         bytes memory buffer = new bytes(digits);
850         while (value != 0) {
851             digits -= 1;
852             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
853             value /= 10;
854         }
855         return string(buffer);
856     }
857 
858     /**
859      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
860      */
861     function toHexString(uint256 value) internal pure returns (string memory) {
862         if (value == 0) {
863             return "0x00";
864         }
865         uint256 temp = value;
866         uint256 length = 0;
867         while (temp != 0) {
868             length++;
869             temp >>= 8;
870         }
871         return toHexString(value, length);
872     }
873 
874     /**
875      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
876      */
877     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
878         bytes memory buffer = new bytes(2 * length + 2);
879         buffer[0] = "0";
880         buffer[1] = "x";
881         for (uint256 i = 2 * length + 1; i > 1; --i) {
882             buffer[i] = _HEX_SYMBOLS[value & 0xf];
883             value >>= 4;
884         }
885         require(value == 0, "Strings: hex length insufficient");
886         return string(buffer);
887     }
888 }
889 
890 // File: @openzeppelin/contracts/utils/Address.sol
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Collection of functions related to the address type
896  */
897 library Address {
898     /**
899      * @dev Returns true if `account` is a contract.
900      *
901      * [IMPORTANT]
902      * ====
903      * It is unsafe to assume that an address for which this function returns
904      * false is an externally-owned account (EOA) and not a contract.
905      *
906      * Among others, `isContract` will return false for the following
907      * types of addresses:
908      *
909      *  - an externally-owned account
910      *  - a contract in construction
911      *  - an address where a contract will be created
912      *  - an address where a contract lived, but was destroyed
913      * ====
914      */
915     function isContract(address account) internal view returns (bool) {
916         // This method relies on extcodesize, which returns 0 for contracts in
917         // construction, since the code is only stored at the end of the
918         // constructor execution.
919 
920         uint256 size;
921         assembly {
922             size := extcodesize(account)
923         }
924         return size > 0;
925     }
926 
927     /**
928      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
929      * `recipient`, forwarding all available gas and reverting on errors.
930      *
931      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
932      * of certain opcodes, possibly making contracts go over the 2300 gas limit
933      * imposed by `transfer`, making them unable to receive funds via
934      * `transfer`. {sendValue} removes this limitation.
935      *
936      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
937      *
938      * IMPORTANT: because control is transferred to `recipient`, care must be
939      * taken to not create reentrancy vulnerabilities. Consider using
940      * {ReentrancyGuard} or the
941      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
942      */
943     function sendValue(address payable recipient, uint256 amount) internal {
944         require(address(this).balance >= amount, "Address: insufficient balance");
945 
946         (bool success, ) = recipient.call{value: amount}("");
947         require(success, "Address: unable to send value, recipient may have reverted");
948     }
949 
950     /**
951      * @dev Performs a Solidity function call using a low level `call`. A
952      * plain `call` is an unsafe replacement for a function call: use this
953      * function instead.
954      *
955      * If `target` reverts with a revert reason, it is bubbled up by this
956      * function (like regular Solidity function calls).
957      *
958      * Returns the raw returned data. To convert to the expected return value,
959      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
960      *
961      * Requirements:
962      *
963      * - `target` must be a contract.
964      * - calling `target` with `data` must not revert.
965      *
966      * _Available since v3.1._
967      */
968     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
969         return functionCall(target, data, "Address: low-level call failed");
970     }
971 
972     /**
973      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
974      * `errorMessage` as a fallback revert reason when `target` reverts.
975      *
976      * _Available since v3.1._
977      */
978     function functionCall(
979         address target,
980         bytes memory data,
981         string memory errorMessage
982     ) internal returns (bytes memory) {
983         return functionCallWithValue(target, data, 0, errorMessage);
984     }
985 
986     /**
987      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
988      * but also transferring `value` wei to `target`.
989      *
990      * Requirements:
991      *
992      * - the calling contract must have an ETH balance of at least `value`.
993      * - the called Solidity function must be `payable`.
994      *
995      * _Available since v3.1._
996      */
997     function functionCallWithValue(
998         address target,
999         bytes memory data,
1000         uint256 value
1001     ) internal returns (bytes memory) {
1002         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1007      * with `errorMessage` as a fallback revert reason when `target` reverts.
1008      *
1009      * _Available since v3.1._
1010      */
1011     function functionCallWithValue(
1012         address target,
1013         bytes memory data,
1014         uint256 value,
1015         string memory errorMessage
1016     ) internal returns (bytes memory) {
1017         require(address(this).balance >= value, "Address: insufficient balance for call");
1018         require(isContract(target), "Address: call to non-contract");
1019 
1020         (bool success, bytes memory returndata) = target.call{value: value}(data);
1021         return _verifyCallResult(success, returndata, errorMessage);
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1026      * but performing a static call.
1027      *
1028      * _Available since v3.3._
1029      */
1030     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1031         return functionStaticCall(target, data, "Address: low-level static call failed");
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1036      * but performing a static call.
1037      *
1038      * _Available since v3.3._
1039      */
1040     function functionStaticCall(
1041         address target,
1042         bytes memory data,
1043         string memory errorMessage
1044     ) internal view returns (bytes memory) {
1045         require(isContract(target), "Address: static call to non-contract");
1046 
1047         (bool success, bytes memory returndata) = target.staticcall(data);
1048         return _verifyCallResult(success, returndata, errorMessage);
1049     }
1050 
1051     /**
1052      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1053      * but performing a delegate call.
1054      *
1055      * _Available since v3.4._
1056      */
1057     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1058         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1059     }
1060 
1061     /**
1062      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1063      * but performing a delegate call.
1064      *
1065      * _Available since v3.4._
1066      */
1067     function functionDelegateCall(
1068         address target,
1069         bytes memory data,
1070         string memory errorMessage
1071     ) internal returns (bytes memory) {
1072         require(isContract(target), "Address: delegate call to non-contract");
1073 
1074         (bool success, bytes memory returndata) = target.delegatecall(data);
1075         return _verifyCallResult(success, returndata, errorMessage);
1076     }
1077 
1078     function _verifyCallResult(
1079         bool success,
1080         bytes memory returndata,
1081         string memory errorMessage
1082     ) private pure returns (bytes memory) {
1083         if (success) {
1084             return returndata;
1085         } else {
1086             // Look for revert reason and bubble it up if present
1087             if (returndata.length > 0) {
1088                 // The easiest way to bubble the revert reason is using memory via assembly
1089 
1090                 assembly {
1091                     let returndata_size := mload(returndata)
1092                     revert(add(32, returndata), returndata_size)
1093                 }
1094             } else {
1095                 revert(errorMessage);
1096             }
1097         }
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106  * @title ERC721 token receiver interface
1107  * @dev Interface for any contract that wants to support safeTransfers
1108  * from ERC721 asset contracts.
1109  */
1110 interface IERC721Receiver {
1111     /**
1112      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1113      * by `operator` from `from`, this function is called.
1114      *
1115      * It must return its Solidity selector to confirm the token transfer.
1116      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1117      *
1118      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1119      */
1120     function onERC721Received(
1121         address operator,
1122         address from,
1123         uint256 tokenId,
1124         bytes calldata data
1125     ) external returns (bytes4);
1126 }
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 /**
1131  * @dev Contract module which provides a basic access control mechanism, where
1132  * there is an account (an owner) that can be granted exclusive access to
1133  * specific functions.
1134  *
1135  * By default, the owner account will be the one that deploys the contract. This
1136  * can later be changed with {transferOwnership}.
1137  *
1138  * This module is used through inheritance. It will make available the modifier
1139  * `onlyOwner`, which can be applied to your functions to restrict their use to
1140  * the owner.
1141  */
1142 abstract contract Ownable is Context {
1143     address private _owner;
1144 
1145     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1146 
1147     /**
1148      * @dev Initializes the contract setting the deployer as the initial owner.
1149      */
1150     constructor() {
1151         _setOwner(_msgSender());
1152     }
1153 
1154     /**
1155      * @dev Returns the address of the current owner.
1156      */
1157     function owner() public view virtual returns (address) {
1158         return _owner;
1159     }
1160 
1161     /**
1162      * @dev Throws if called by any account other than the owner.
1163      */
1164     modifier onlyOwner() {
1165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1166         _;
1167     }
1168 
1169     /**
1170      * @dev Leaves the contract without owner. It will not be possible to call
1171      * `onlyOwner` functions anymore. Can only be called by the current owner.
1172      *
1173      * NOTE: Renouncing ownership will leave the contract without an owner,
1174      * thereby removing any functionality that is only available to the owner.
1175      */
1176     function renounceOwnership() public virtual onlyOwner {
1177         _setOwner(address(0));
1178     }
1179 
1180     /**
1181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1182      * Can only be called by the current owner.
1183      */
1184     function transferOwnership(address newOwner) public virtual onlyOwner {
1185         require(newOwner != address(0), "Ownable: new owner is the zero address");
1186         _setOwner(newOwner);
1187     }
1188 
1189     function _setOwner(address newOwner) private {
1190         address oldOwner = _owner;
1191         _owner = newOwner;
1192         emit OwnershipTransferred(oldOwner, newOwner);
1193     }
1194 }
1195 
1196 // File: Avocados.sol
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 contract Dinos is ERC721A, Ownable {  
1201     using Address for address;
1202     using Strings for uint256;
1203 
1204     uint256 public NFT_PRICE = 20000000000000000; // 0.02 ETH    
1205     uint256 public constant MAX_NFT_PURCHASE = 20;  
1206     uint256 public constant MINT_SUPPLY = 5900;
1207     uint256 public constant TEAM_SUPPLY = 100;
1208     uint256 public constant FREE_MINT_AMOUNT = 1000;    
1209     
1210     bool public publicSalePhase = false;
1211     string private _baseTokenURI;
1212     
1213     constructor() ERC721A("DegenDinos","DGNDNS", MAX_NFT_PURCHASE, MINT_SUPPLY + TEAM_SUPPLY){              
1214     }
1215 
1216     function togglePublicSalePhase() public onlyOwner {
1217         publicSalePhase = !publicSalePhase;
1218     }   
1219 
1220     function airdrop(uint256 quantity, address to) public onlyOwner {
1221         uint256 totalSupply = totalSupply(); 
1222         require(quantity <= MAX_NFT_PURCHASE, "Max 20 tokens per trx"); 
1223         require((totalSupply + quantity) <= (MINT_SUPPLY + TEAM_SUPPLY), "Purchase exceeding max supply");
1224 
1225         _safeMint(to, quantity);
1226     } 
1227 
1228     function mint(uint256 quantity) public payable {  
1229         uint256 totalSupply = totalSupply(); 
1230 
1231         require(publicSalePhase, "Can't mint");                
1232         require(quantity > 0, "Amount too small");
1233         require(quantity <= MAX_NFT_PURCHASE, "Max 20 tokens per trx"); 
1234         require((totalSupply + quantity) <= MINT_SUPPLY, "Purchase exceeding max supply");
1235         if(totalSupply >= FREE_MINT_AMOUNT) {    
1236             require(NFT_PRICE * quantity == msg.value, "Sent eth val is incorrect"); 
1237         }
1238 
1239         _safeMint(msg.sender, quantity);  
1240     }
1241     
1242     function withdraw() public payable onlyOwner {
1243         uint256 balance = address(this).balance;
1244         payable(msg.sender).transfer(balance);
1245     }    
1246 
1247     function setPrice(uint256 price) public onlyOwner {       
1248         NFT_PRICE = price;
1249     }
1250     
1251     function getBalance() public view onlyOwner returns (uint256){
1252         return address(this).balance;
1253     } 
1254 	
1255     function setBaseURI(string memory baseURI_) public onlyOwner {
1256         _baseTokenURI = baseURI_;
1257     }
1258 
1259     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {        
1260         return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json"));
1261     }
1262 
1263     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1264         _setOwnersExplicit(quantity);
1265     }
1266 
1267     function numberMinted(address owner) public view returns (uint256) {
1268         return _numberMinted(owner);
1269     }
1270 }