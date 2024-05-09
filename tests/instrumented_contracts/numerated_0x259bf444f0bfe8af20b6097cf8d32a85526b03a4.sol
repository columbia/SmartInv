1 // File: ConansCircle/ReentrancyGuard.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 
7 abstract contract ReentrancyGuard {
8     // Booleans are more expensive than uint256 or any type that takes up a full
9     // word because each write operation emits an extra SLOAD to first read the
10     // slot's contents, replace the bits taken up by the boolean, and then write
11     // back. This is the compiler's defense against contract upgrades and
12     // pointer aliasing, and it cannot be disabled.
13 
14     // The values being non-zero value makes deployment a bit more expensive,
15     // but in exchange the refund on every call to nonReentrant will be lower in
16     // amount. Since refunds are capped to a percentage of the total
17     // transaction's gas, it is best to keep them low in cases like this one, to
18     // increase the likelihood of the full refund coming into effect.
19     uint256 private constant _NOT_ENTERED = 1;
20     uint256 private constant _ENTERED = 2;
21 
22     uint256 private _status;
23 
24     constructor() {
25         _status = _NOT_ENTERED;
26     }
27 
28     modifier nonReentrant() {
29         // On the first call to nonReentrant, _notEntered will be true
30         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
31 
32         // Any calls to nonReentrant after this point will fail
33         _status = _ENTERED;
34 
35         _;
36 
37         // By storing the original value once again, a refund is triggered (see
38         // https://eips.ethereum.org/EIPS/eip-2200)
39         _status = _NOT_ENTERED;
40     }
41 }
42 // File: ConansCircle/Strings.sol
43 
44 
45 
46 pragma solidity ^0.8.0;
47 
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50 
51     function toString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 // File: ConansCircle/Context.sol
97 
98 
99 pragma solidity ^0.8.0;
100 
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 // File: ConansCircle/Ownable.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     function owner() public view virtual returns (address) {
127         return _owner;
128     }
129 
130     modifier onlyOwner() {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134 
135     function renounceOwnership() public virtual onlyOwner {
136         _transferOwnership(address(0));
137     }
138 
139     function transferOwnership(address newOwner) public virtual onlyOwner {
140         require(newOwner != address(0), "Ownable: new owner is the zero address");
141         _transferOwnership(newOwner);
142     }
143 
144     function _transferOwnership(address newOwner) internal virtual {
145         address oldOwner = _owner;
146         _owner = newOwner;
147         emit OwnershipTransferred(oldOwner, newOwner);
148     }
149 }
150 
151 // File: ConansCircle/Address.sol
152 
153 
154 pragma solidity ^0.8.1;
155 
156 library Address {
157     function isContract(address account) internal view returns (bool) {
158         return account.code.length > 0;
159     }
160 
161     function sendValue(address payable recipient, uint256 amount) internal {
162         require(address(this).balance >= amount, "Address: insufficient balance");
163 
164         (bool success, ) = recipient.call{value: amount}("");
165         require(success, "Address: unable to send value, recipient may have reverted");
166     }
167 
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         require(isContract(target), "Address: call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.call{value: value}(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
202         return functionStaticCall(target, data, "Address: low-level static call failed");
203     }
204 
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
217         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
218     }
219 
220     function functionDelegateCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         require(isContract(target), "Address: delegate call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.delegatecall(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     function verifyCallResult(
232         bool success,
233         bytes memory returndata,
234         string memory errorMessage
235     ) internal pure returns (bytes memory) {
236         if (success) {
237             return returndata;
238         } else {
239             // Look for revert reason and bubble it up if present
240             if (returndata.length > 0) {
241                 // The easiest way to bubble the revert reason is using memory via assembly
242 
243                 assembly {
244                     let returndata_size := mload(returndata)
245                     revert(add(32, returndata), returndata_size)
246                 }
247             } else {
248                 revert(errorMessage);
249             }
250         }
251     }
252 }
253 
254 // File: ConansCircle/IERC721Receiver.sol
255 
256 
257 
258 pragma solidity ^0.8.0;
259 
260 interface IERC721Receiver {
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 // File: ConansCircle/IERC165.sol
270 
271 
272 
273 pragma solidity ^0.8.0;
274 
275 interface IERC165 {
276     function supportsInterface(bytes4 interfaceId) external view returns (bool);
277 }
278 
279 // File: ConansCircle/ERC165.sol
280 
281 
282 pragma solidity ^0.8.0;
283 
284 
285 /**
286  * @dev Implementation of the {IERC165} interface.
287  *
288  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
289  * for the additional interface id that will be supported. For example:
290  *
291  * ```solidity
292  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
293  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
294  * }
295  * ```
296  *
297  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
298  */
299 abstract contract ERC165 is IERC165 {
300     /**
301      * @dev See {IERC165-supportsInterface}.
302      */
303     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
304         return interfaceId == type(IERC165).interfaceId;
305     }
306 }
307 
308 // File: ConansCircle/IERC721.sol
309 
310 
311 
312 pragma solidity ^0.8.0;
313 
314 
315 interface IERC721 is IERC165 {
316     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
317 
318     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
319 
320     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
321 
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324     function ownerOf(uint256 tokenId) external view returns (address owner);
325 
326     function safeTransferFrom(
327         address from,
328         address to,
329         uint256 tokenId
330     ) external;
331 
332     function transferFrom(
333         address from,
334         address to,
335         uint256 tokenId
336     ) external;
337 
338     function approve(address to, uint256 tokenId) external;
339 
340     function getApproved(uint256 tokenId) external view returns (address operator);
341 
342     function setApprovalForAll(address operator, bool _approved) external;
343 
344     function isApprovedForAll(address owner, address operator) external view returns (bool);
345 
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external;
352 }
353 
354 // File: ConansCircle/IERC721Metadata.sol
355 
356 
357 
358 pragma solidity ^0.8.0;
359 
360 
361 interface IERC721Metadata is IERC721 {
362     function name() external view returns (string memory);
363 
364     function symbol() external view returns (string memory);
365 
366     function tokenURI(uint256 tokenId) external view returns (string memory);
367 }
368 
369 // File: ConansCircle/IERC721Enumerable.sol
370 
371 
372 
373 pragma solidity ^0.8.0;
374 
375 
376 /**
377  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
378  * @dev See https://eips.ethereum.org/EIPS/eip-721
379  */
380 interface IERC721Enumerable is IERC721 {
381     /**
382      * @dev Returns the total amount of tokens stored by the contract.
383      */
384     function totalSupply() external view returns (uint256);
385 
386     /**
387      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
388      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
389      */
390     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
391 
392     /**
393      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
394      * Use along with {totalSupply} to enumerate all tokens.
395      */
396     function tokenByIndex(uint256 index) external view returns (uint256);
397 }
398 // File: ConansCircle/ERC721A.sol
399 
400 
401 
402 pragma solidity ^0.8.0;
403 
404 
405 
406 
407 
408 
409 
410 
411 
412 /**
413  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
414  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
415  *
416  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
417  *
418  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
419  *
420  * Does not support burning tokens to address(0).
421  */
422 contract ERC721A is
423   Context,
424   ERC165,
425   IERC721,
426   IERC721Metadata,
427   IERC721Enumerable
428 {
429   using Address for address;
430   using Strings for uint256;
431 
432   struct TokenOwnership {
433     address addr;
434     uint64 startTimestamp;
435   }
436 
437   struct AddressData {
438     uint128 balance;
439     uint128 numberMinted;
440   }
441 
442   uint256 private currentIndex = 0;
443 
444   uint256 internal immutable collectionSize;
445   uint256 internal immutable maxBatchSize;
446 
447   // Token name
448   string private _name;
449 
450   // Token symbol
451   string private _symbol;
452 
453   // Mapping from token ID to ownership details
454   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
455   mapping(uint256 => TokenOwnership) private _ownerships;
456 
457   // Mapping owner address to address data
458   mapping(address => AddressData) private _addressData;
459 
460   // Mapping from token ID to approved address
461   mapping(uint256 => address) private _tokenApprovals;
462 
463   // Mapping from owner to operator approvals
464   mapping(address => mapping(address => bool)) private _operatorApprovals;
465 
466   /**
467    * @dev
468    * `maxBatchSize` refers to how much a minter can mint at a time.
469    * `collectionSize_` refers to how many tokens are in the collection.
470    */
471   constructor(
472     string memory name_,
473     string memory symbol_,
474     uint256 maxBatchSize_,
475     uint256 collectionSize_
476   ) {
477     require(
478       collectionSize_ > 0,
479       "ERC721A: collection must have a nonzero supply"
480     );
481     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
482     _name = name_;
483     _symbol = symbol_;
484     maxBatchSize = maxBatchSize_;
485     collectionSize = collectionSize_;
486   }
487 
488   /**
489    * @dev See {IERC721Enumerable-totalSupply}.
490    */
491   function totalSupply() public view override returns (uint256) {
492     return currentIndex;
493   }
494 
495   /**
496    * @dev See {IERC721Enumerable-tokenByIndex}.
497    */
498   function tokenByIndex(uint256 index) public view override returns (uint256) {
499     require(index < totalSupply(), "ERC721A: global index out of bounds");
500     return index;
501   }
502 
503   /**
504    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
505    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
506    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
507    */
508   function tokenOfOwnerByIndex(address owner, uint256 index)
509     public
510     view
511     override
512     returns (uint256)
513   {
514     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
515     uint256 numMintedSoFar = totalSupply();
516     uint256 tokenIdsIdx = 0;
517     address currOwnershipAddr = address(0);
518     for (uint256 i = 0; i < numMintedSoFar; i++) {
519       TokenOwnership memory ownership = _ownerships[i];
520       if (ownership.addr != address(0)) {
521         currOwnershipAddr = ownership.addr;
522       }
523       if (currOwnershipAddr == owner) {
524         if (tokenIdsIdx == index) {
525           return i;
526         }
527         tokenIdsIdx++;
528       }
529     }
530     revert("ERC721A: unable to get token of owner by index");
531   }
532 
533   /**
534    * @dev See {IERC165-supportsInterface}.
535    */
536   function supportsInterface(bytes4 interfaceId)
537     public
538     view
539     virtual
540     override(ERC165, IERC165)
541     returns (bool)
542   {
543     return
544       interfaceId == type(IERC721).interfaceId ||
545       interfaceId == type(IERC721Metadata).interfaceId ||
546       interfaceId == type(IERC721Enumerable).interfaceId ||
547       super.supportsInterface(interfaceId);
548   }
549 
550   /**
551    * @dev See {IERC721-balanceOf}.
552    */
553   function balanceOf(address owner) public view override returns (uint256) {
554     require(owner != address(0), "ERC721A: balance query for the zero address");
555     return uint256(_addressData[owner].balance);
556   }
557 
558   function _numberMinted(address owner) internal view returns (uint256) {
559     require(
560       owner != address(0),
561       "ERC721A: number minted query for the zero address"
562     );
563     return uint256(_addressData[owner].numberMinted);
564   }
565 
566   function ownershipOf(uint256 tokenId)
567     internal
568     view
569     returns (TokenOwnership memory)
570   {
571     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
572 
573     uint256 lowestTokenToCheck;
574     if (tokenId >= maxBatchSize) {
575       lowestTokenToCheck = tokenId - maxBatchSize + 1;
576     }
577 
578     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
579       TokenOwnership memory ownership = _ownerships[curr];
580       if (ownership.addr != address(0)) {
581         return ownership;
582       }
583     }
584 
585     revert("ERC721A: unable to determine the owner of token");
586   }
587 
588   /**
589    * @dev See {IERC721-ownerOf}.
590    */
591   function ownerOf(uint256 tokenId) public view override returns (address) {
592     return ownershipOf(tokenId).addr;
593   }
594 
595   /**
596    * @dev See {IERC721Metadata-name}.
597    */
598   function name() public view virtual override returns (string memory) {
599     return _name;
600   }
601 
602   /**
603    * @dev See {IERC721Metadata-symbol}.
604    */
605   function symbol() public view virtual override returns (string memory) {
606     return _symbol;
607   }
608 
609   /**
610    * @dev See {IERC721Metadata-tokenURI}.
611    */
612   function tokenURI(uint256 tokenId)
613     public
614     view
615     virtual
616     override
617     returns (string memory)
618   {
619     require(
620       _exists(tokenId),
621       "ERC721Metadata: URI query for nonexistent token"
622     );
623 
624     string memory baseURI = _baseURI();
625     return
626       bytes(baseURI).length > 0
627         ? string(abi.encodePacked(baseURI, tokenId.toString()))
628         : "";
629   }
630 
631   /**
632    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
633    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
634    * by default, can be overriden in child contracts.
635    */
636   function _baseURI() internal view virtual returns (string memory) {
637     return "";
638   }
639 
640   /**
641    * @dev See {IERC721-approve}.
642    */
643   function approve(address to, uint256 tokenId) public override {
644     address owner = ERC721A.ownerOf(tokenId);
645     require(to != owner, "ERC721A: approval to current owner");
646 
647     require(
648       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
649       "ERC721A: approve caller is not owner nor approved for all"
650     );
651 
652     _approve(to, tokenId, owner);
653   }
654 
655   /**
656    * @dev See {IERC721-getApproved}.
657    */
658   function getApproved(uint256 tokenId) public view override returns (address) {
659     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
660 
661     return _tokenApprovals[tokenId];
662   }
663 
664   /**
665    * @dev See {IERC721-setApprovalForAll}.
666    */
667   function setApprovalForAll(address operator, bool approved) public override {
668     require(operator != _msgSender(), "ERC721A: approve to caller");
669 
670     _operatorApprovals[_msgSender()][operator] = approved;
671     emit ApprovalForAll(_msgSender(), operator, approved);
672   }
673 
674   /**
675    * @dev See {IERC721-isApprovedForAll}.
676    */
677   function isApprovedForAll(address owner, address operator)
678     public
679     view
680     virtual
681     override
682     returns (bool)
683   {
684     return _operatorApprovals[owner][operator];
685   }
686 
687   /**
688    * @dev See {IERC721-transferFrom}.
689    */
690   function transferFrom(
691     address from,
692     address to,
693     uint256 tokenId
694   ) public override {
695     _transfer(from, to, tokenId);
696   }
697 
698   /**
699    * @dev See {IERC721-safeTransferFrom}.
700    */
701   function safeTransferFrom(
702     address from,
703     address to,
704     uint256 tokenId
705   ) public override {
706     safeTransferFrom(from, to, tokenId, "");
707   }
708 
709   /**
710    * @dev See {IERC721-safeTransferFrom}.
711    */
712   function safeTransferFrom(
713     address from,
714     address to,
715     uint256 tokenId,
716     bytes memory _data
717   ) public override {
718     _transfer(from, to, tokenId);
719     require(
720       _checkOnERC721Received(from, to, tokenId, _data),
721       "ERC721A: transfer to non ERC721Receiver implementer"
722     );
723   }
724 
725   /**
726    * @dev Returns whether `tokenId` exists.
727    *
728    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
729    *
730    * Tokens start existing when they are minted (`_mint`),
731    */
732   function _exists(uint256 tokenId) internal view returns (bool) {
733     return tokenId < currentIndex;
734   }
735 
736   function _safeMint(address to, uint256 quantity) internal {
737     _safeMint(to, quantity, "");
738   }
739 
740   /**
741    * @dev Mints `quantity` tokens and transfers them to `to`.
742    *
743    * Requirements:
744    *
745    * - there must be `quantity` tokens remaining unminted in the total collection.
746    * - `to` cannot be the zero address.
747    * - `quantity` cannot be larger than the max batch size.
748    *
749    * Emits a {Transfer} event.
750    */
751   function _safeMint(
752     address to,
753     uint256 quantity,
754     bytes memory _data
755   ) internal {
756     uint256 startTokenId = currentIndex;
757     require(to != address(0), "ERC721A: mint to the zero address");
758     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
759     require(!_exists(startTokenId), "ERC721A: token already minted");
760     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
761 
762     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
763 
764     AddressData memory addressData = _addressData[to];
765     _addressData[to] = AddressData(
766       addressData.balance + uint128(quantity),
767       addressData.numberMinted + uint128(quantity)
768     );
769     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
770 
771     uint256 updatedIndex = startTokenId;
772 
773     for (uint256 i = 0; i < quantity; i++) {
774       emit Transfer(address(0), to, updatedIndex);
775       require(
776         _checkOnERC721Received(address(0), to, updatedIndex, _data),
777         "ERC721A: transfer to non ERC721Receiver implementer"
778       );
779       updatedIndex++;
780     }
781 
782     currentIndex = updatedIndex;
783     _afterTokenTransfers(address(0), to, startTokenId, quantity);
784   }
785 
786   /**
787    * @dev Transfers `tokenId` from `from` to `to`.
788    *
789    * Requirements:
790    *
791    * - `to` cannot be the zero address.
792    * - `tokenId` token must be owned by `from`.
793    *
794    * Emits a {Transfer} event.
795    */
796   function _transfer(
797     address from,
798     address to,
799     uint256 tokenId
800   ) private {
801     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
802 
803     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
804       getApproved(tokenId) == _msgSender() ||
805       isApprovedForAll(prevOwnership.addr, _msgSender()));
806 
807     require(
808       isApprovedOrOwner,
809       "ERC721A: transfer caller is not owner nor approved"
810     );
811 
812     require(
813       prevOwnership.addr == from,
814       "ERC721A: transfer from incorrect owner"
815     );
816     require(to != address(0), "ERC721A: transfer to the zero address");
817 
818     _beforeTokenTransfers(from, to, tokenId, 1);
819 
820     // Clear approvals from the previous owner
821     _approve(address(0), tokenId, prevOwnership.addr);
822 
823     _addressData[from].balance -= 1;
824     _addressData[to].balance += 1;
825     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
826 
827     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
828     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
829     uint256 nextTokenId = tokenId + 1;
830     if (_ownerships[nextTokenId].addr == address(0)) {
831       if (_exists(nextTokenId)) {
832         _ownerships[nextTokenId] = TokenOwnership(
833           prevOwnership.addr,
834           prevOwnership.startTimestamp
835         );
836       }
837     }
838 
839     emit Transfer(from, to, tokenId);
840     _afterTokenTransfers(from, to, tokenId, 1);
841   }
842 
843   /**
844    * @dev Approve `to` to operate on `tokenId`
845    *
846    * Emits a {Approval} event.
847    */
848   function _approve(
849     address to,
850     uint256 tokenId,
851     address owner
852   ) private {
853     _tokenApprovals[tokenId] = to;
854     emit Approval(owner, to, tokenId);
855   }
856 
857   uint256 public nextOwnerToExplicitlySet = 0;
858 
859   /**
860    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
861    */
862   function _setOwnersExplicit(uint256 quantity) internal {
863     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
864     require(quantity > 0, "quantity must be nonzero");
865     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
866     if (endIndex > collectionSize - 1) {
867       endIndex = collectionSize - 1;
868     }
869     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
870     require(_exists(endIndex), "not enough minted yet for this cleanup");
871     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
872       if (_ownerships[i].addr == address(0)) {
873         TokenOwnership memory ownership = ownershipOf(i);
874         _ownerships[i] = TokenOwnership(
875           ownership.addr,
876           ownership.startTimestamp
877         );
878       }
879     }
880     nextOwnerToExplicitlySet = endIndex + 1;
881   }
882 
883   /**
884    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
885    * The call is not executed if the target address is not a contract.
886    *
887    * @param from address representing the previous owner of the given token ID
888    * @param to target address that will receive the tokens
889    * @param tokenId uint256 ID of the token to be transferred
890    * @param _data bytes optional data to send along with the call
891    * @return bool whether the call correctly returned the expected magic value
892    */
893   function _checkOnERC721Received(
894     address from,
895     address to,
896     uint256 tokenId,
897     bytes memory _data
898   ) private returns (bool) {
899     if (to.isContract()) {
900       try
901         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
902       returns (bytes4 retval) {
903         return retval == IERC721Receiver(to).onERC721Received.selector;
904       } catch (bytes memory reason) {
905         if (reason.length == 0) {
906           revert("ERC721A: transfer to non ERC721Receiver implementer");
907         } else {
908           assembly {
909             revert(add(32, reason), mload(reason))
910           }
911         }
912       }
913     } else {
914       return true;
915     }
916   }
917 
918   /**
919    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
920    *
921    * startTokenId - the first token id to be transferred
922    * quantity - the amount to be transferred
923    *
924    * Calling conditions:
925    *
926    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
927    * transferred to `to`.
928    * - When `from` is zero, `tokenId` will be minted for `to`.
929    */
930   function _beforeTokenTransfers(
931     address from,
932     address to,
933     uint256 startTokenId,
934     uint256 quantity
935   ) internal virtual {}
936 
937   /**
938    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
939    * minting.
940    *
941    * startTokenId - the first token id to be transferred
942    * quantity - the amount to be transferred
943    *
944    * Calling conditions:
945    *
946    * - when `from` and `to` are both non-zero.
947    * - `from` and `to` are never both zero.
948    */
949   function _afterTokenTransfers(
950     address from,
951     address to,
952     uint256 startTokenId,
953     uint256 quantity
954   ) internal virtual {}
955 }
956 // File: ConansCircle/MerkleProof.sol
957 
958 
959 pragma solidity ^0.8.0;
960 
961 library MerkleProof {
962     /**
963      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
964      * defined by `root`. For this, a `proof` must be provided, containing
965      * sibling hashes on the branch from the leaf to the root of the tree. Each
966      * pair of leaves and each pair of pre-images are assumed to be sorted.
967      */
968     function verify(
969         bytes32[] memory proof,
970         bytes32 root,
971         bytes32 leaf
972     ) internal pure returns (bool) {
973         return processProof(proof, leaf) == root;
974     }
975 
976     /**
977      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
978      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
979      * hash matches the root of the tree. When processing the proof, the pairs
980      * of leafs & pre-images are assumed to be sorted.
981      *
982      * _Available since v4.4._
983      */
984     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
985         bytes32 computedHash = leaf;
986         for (uint256 i = 0; i < proof.length; i++) {
987             bytes32 proofElement = proof[i];
988             if (computedHash <= proofElement) {
989                 // Hash(current computed hash + current element of the proof)
990                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
991             } else {
992                 // Hash(current element of the proof + current computed hash)
993                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
994             }
995         }
996         return computedHash;
997     }
998 }
999 
1000 // File: ConansCircle/ConansCircle.sol
1001 
1002 
1003 pragma solidity ^0.8.7;
1004 
1005 
1006 
1007 
1008 
1009 contract ConansCircle is Ownable, ERC721A, ReentrancyGuard {
1010     uint256 private _publicPrice = 0.03 ether;
1011     uint256 private _presalePrice = 0.03 ether;
1012     bool public isWhitelistMintStarted = false;
1013     bool public isPublicMintStarted = false;
1014 
1015     uint256 private constant _maxPurchaseDuringWhitelist = 1;
1016     uint256 private constant _maxPerTransaction = 2;
1017     uint256 private _maxMint = 2500;
1018     address private _team = 0x17f3C41EEf2E55c8b3969B958ee04d3417f9a699;
1019     bytes32 public merkleRoot = 0x0;
1020     mapping(address => uint256) public presaleAddressMintCount;
1021     bool public isPaused = false;
1022     string private _tokenURI = "ipfs://QmXddgi4iCf1CE9Pm9KwR3298LJ4R7xFtcf3SfvNbqEAhS/";
1023 
1024     constructor() ERC721A("ConansCircle", "CONAN", _maxPerTransaction, _maxMint) {}
1025 
1026     function setWhitelistMint (bool value) external onlyOwner {
1027         isWhitelistMintStarted = value;
1028     }
1029 
1030     function setPublicMint (bool value) external onlyOwner {
1031         isPublicMintStarted = value;
1032     }
1033 
1034     function getIsPublicMintStarted () external view returns (bool) {
1035         return isPublicMintStarted;
1036     }
1037 
1038     function pause() external onlyOwner {
1039         isPaused = true;
1040     }
1041 
1042     function unpause() external onlyOwner {
1043         isPaused = false;
1044     }
1045 
1046     function setWhitelistPrice (uint256 price) external onlyOwner {
1047         _presalePrice = price;
1048     }
1049 
1050     function setPublicPrice (uint256 price) external onlyOwner {
1051         _publicPrice = price;
1052     }
1053 
1054     modifier mintGuard(uint256 tokenCount) {
1055         require(!isPaused, "Sale not started");
1056         require(tokenCount > 0 && tokenCount <= _maxPerTransaction, "Max one per transaction");
1057         require(msg.sender == tx.origin, "Sender not origin");
1058         // Price check
1059         if (isPublicMintStarted) {
1060             require(_publicPrice * tokenCount <= msg.value, "Insufficient funds");
1061         } else {
1062             require(_presalePrice * tokenCount <= msg.value, "Insufficient funds");
1063         }
1064         require(totalSupply() + tokenCount <= _maxMint+1, "Sold out!");
1065         _;
1066     }
1067 
1068     function mint(uint256 amount) external payable mintGuard(amount) {
1069         require(isPublicMintStarted, "Sale not started");
1070         require(amount <= _maxPerTransaction, "Exceed transaction limit");
1071         _safeMint(msg.sender, amount);
1072     }
1073 
1074     function mintPresale(bytes32[] calldata proof, uint256 amount) external payable mintGuard(amount) {
1075         require(isWhitelistMintStarted, "Whitelist mint has not started!");
1076         require(amount <= _maxPurchaseDuringWhitelist, "Exceed transaction limit");
1077         require(presaleAddressMintCount[msg.sender] + amount <= _maxPurchaseDuringWhitelist, "Maximum limit reached");
1078         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not eligible for presale");
1079 
1080         presaleAddressMintCount[msg.sender] += amount;
1081         _safeMint(msg.sender, amount);
1082     }
1083 
1084     function cashout() external onlyOwner {
1085         payable(_team).transfer(address(this).balance);
1086     }
1087 
1088     function setCashout(address addr) external onlyOwner returns(address) {
1089         _team = addr;
1090         return addr;
1091     }
1092 
1093     function devMint(uint32 qty) external onlyOwner {
1094         _safeMint(msg.sender, qty);
1095     }
1096 
1097     function setMerkleRoot(bytes32 root) external onlyOwner {
1098         merkleRoot = root;
1099     }
1100 
1101     function setMaxMint(uint256 maxMint) external onlyOwner {
1102         _maxMint = maxMint;
1103     }
1104 
1105     function setBaseURI(string calldata baseURI) external onlyOwner {
1106         _tokenURI = baseURI;
1107     }
1108 
1109     function _baseURI() internal view virtual override returns (string memory) {
1110         return _tokenURI;
1111     }
1112 }