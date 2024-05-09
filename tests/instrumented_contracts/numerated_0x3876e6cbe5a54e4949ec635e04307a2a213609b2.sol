1 // SPDX-License-Identifier: MIT
2 // /ReentrancyGuard.sol
3 
4 pragma solidity ^0.8.0;
5 
6 abstract contract ReentrancyGuard {
7     // Booleans are more expensive than uint256 or any type that takes up a full
8     // word because each write operation emits an extra SLOAD to first read the
9     // slot's contents, replace the bits taken up by the boolean, and then write
10     // back. This is the compiler's defense against contract upgrades and
11     // pointer aliasing, and it cannot be disabled.
12 
13     // The values being non-zero value makes deployment a bit more expensive,
14     // but in exchange the refund on every call to nonReentrant will be lower in
15     // amount. Since refunds are capped to a percentage of the total
16     // transaction's gas, it is best to keep them low in cases like this one, to
17     // increase the likelihood of the full refund coming into effect.
18     uint256 private constant _NOT_ENTERED = 1;
19     uint256 private constant _ENTERED = 2;
20 
21     uint256 private _status;
22 
23     constructor() {
24         _status = _NOT_ENTERED;
25     }
26 
27     modifier nonReentrant() {
28         // On the first call to nonReentrant, _notEntered will be true
29         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
30 
31         // Any calls to nonReentrant after this point will fail
32         _status = _ENTERED;
33 
34         _;
35 
36         // By storing the original value once again, a refund is triggered (see
37         // https://eips.ethereum.org/EIPS/eip-2200)
38         _status = _NOT_ENTERED;
39     }
40 }
41 // /Strings.sol
42 
43 
44 
45 pragma solidity ^0.8.0;
46 
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     function toString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 // /Context.sol
96 
97 
98 pragma solidity ^0.8.0;
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 // /Ownable.sol
110 
111 
112 
113 pragma solidity ^0.8.0;
114 
115 
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     constructor() {
122         _transferOwnership(_msgSender());
123     }
124 
125     function owner() public view virtual returns (address) {
126         return _owner;
127     }
128 
129     modifier onlyOwner() {
130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133 
134     function renounceOwnership() public virtual onlyOwner {
135         _transferOwnership(address(0));
136     }
137 
138     function transferOwnership(address newOwner) public virtual onlyOwner {
139         require(newOwner != address(0), "Ownable: new owner is the zero address");
140         _transferOwnership(newOwner);
141     }
142 
143     function _transferOwnership(address newOwner) internal virtual {
144         address oldOwner = _owner;
145         _owner = newOwner;
146         emit OwnershipTransferred(oldOwner, newOwner);
147     }
148 }
149 
150 // /Address.sol
151 
152 
153 pragma solidity ^0.8.1;
154 
155 library Address {
156     function isContract(address account) internal view returns (bool) {
157         return account.code.length > 0;
158     }
159 
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         require(isContract(target), "Address: call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.call{value: value}(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
201         return functionStaticCall(target, data, "Address: low-level static call failed");
202     }
203 
204     function functionStaticCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal view returns (bytes memory) {
209         require(isContract(target), "Address: static call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.staticcall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
216         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
217     }
218 
219     function functionDelegateCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(isContract(target), "Address: delegate call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     function verifyCallResult(
231         bool success,
232         bytes memory returndata,
233         string memory errorMessage
234     ) internal pure returns (bytes memory) {
235         if (success) {
236             return returndata;
237         } else {
238             // Look for revert reason and bubble it up if present
239             if (returndata.length > 0) {
240                 // The easiest way to bubble the revert reason is using memory via assembly
241 
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // /IERC721Receiver.sol
254 
255 
256 
257 pragma solidity ^0.8.0;
258 
259 interface IERC721Receiver {
260     function onERC721Received(
261         address operator,
262         address from,
263         uint256 tokenId,
264         bytes calldata data
265     ) external returns (bytes4);
266 }
267 
268 // /IERC165.sol
269 
270 
271 
272 pragma solidity ^0.8.0;
273 
274 interface IERC165 {
275     function supportsInterface(bytes4 interfaceId) external view returns (bool);
276 }
277 
278 // /ERC165.sol
279 
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Implementation of the {IERC165} interface.
286  *
287  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
288  * for the additional interface id that will be supported. For example:
289  *
290  * ```solidity
291  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
292  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
293  * }
294  * ```
295  *
296  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
297  */
298 abstract contract ERC165 is IERC165 {
299     /**
300      * @dev See {IERC165-supportsInterface}.
301      */
302     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303         return interfaceId == type(IERC165).interfaceId;
304     }
305 }
306 
307 // /IERC721.sol
308 
309 
310 
311 pragma solidity ^0.8.0;
312 
313 
314 interface IERC721 is IERC165 {
315     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
316 
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
320 
321     function balanceOf(address owner) external view returns (uint256 balance);
322 
323     function ownerOf(uint256 tokenId) external view returns (address owner);
324 
325     function safeTransferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     function approve(address to, uint256 tokenId) external;
338 
339     function getApproved(uint256 tokenId) external view returns (address operator);
340 
341     function setApprovalForAll(address operator, bool _approved) external;
342 
343     function isApprovedForAll(address owner, address operator) external view returns (bool);
344 
345     function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId,
349         bytes calldata data
350     ) external;
351 }
352 
353 // /IERC721Metadata.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 
360 interface IERC721Metadata is IERC721 {
361     function name() external view returns (string memory);
362 
363     function symbol() external view returns (string memory);
364 
365     function tokenURI(uint256 tokenId) external view returns (string memory);
366 }
367 
368 // /IERC721Enumerable.sol
369 
370 
371 
372 pragma solidity ^0.8.0;
373 
374 
375 /**
376  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
377  * @dev See https://eips.ethereum.org/EIPS/eip-721
378  */
379 interface IERC721Enumerable is IERC721 {
380     /**
381      * @dev Returns the total amount of tokens stored by the contract.
382      */
383     function totalSupply() external view returns (uint256);
384 
385     /**
386      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
387      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
388      */
389     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
390 
391     /**
392      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
393      * Use along with {totalSupply} to enumerate all tokens.
394      */
395     function tokenByIndex(uint256 index) external view returns (uint256);
396 }
397 // /ERC721A.sol
398 
399 
400 
401 pragma solidity ^0.8.0;
402 
403 
404 
405 
406 
407 
408 
409 
410 
411 /**
412  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
413  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
414  *
415  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
416  *
417  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
418  *
419  * Does not support burning tokens to address(0).
420  */
421 contract ERC721A is
422   Context,
423   ERC165,
424   IERC721,
425   IERC721Metadata,
426   IERC721Enumerable
427 {
428   using Address for address;
429   using Strings for uint256;
430 
431   struct TokenOwnership {
432     address addr;
433     uint64 startTimestamp;
434   }
435 
436   struct AddressData {
437     uint128 balance;
438     uint128 numberMinted;
439   }
440 
441   uint256 private currentIndex = 0;
442 
443   uint256 collectionSize;
444   uint256 maxBatchSize;
445 
446   // Token name
447   string private _name;
448 
449   // Token symbol
450   string private _symbol;
451 
452   // Mapping from token ID to ownership details
453   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
454   mapping(uint256 => TokenOwnership) private _ownerships;
455 
456   // Mapping owner address to address data
457   mapping(address => AddressData) private _addressData;
458 
459   // Mapping from token ID to approved address
460   mapping(uint256 => address) private _tokenApprovals;
461 
462   // Mapping from owner to operator approvals
463   mapping(address => mapping(address => bool)) private _operatorApprovals;
464 
465   /**
466    * @dev
467    * `maxBatchSize` refers to how much a minter can mint at a time.
468    * `collectionSize_` refers to how many tokens are in the collection.
469    */
470   constructor(
471     string memory name_,
472     string memory symbol_,
473     uint256 maxBatchSize_,
474     uint256 collectionSize_
475   ) {
476     require(
477       collectionSize_ > 0,
478       "ERC721A: collection must have a nonzero supply"
479     );
480     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
481     _name = name_;
482     _symbol = symbol_;
483     maxBatchSize = maxBatchSize_;
484     collectionSize = collectionSize_;
485   }
486 
487   /**
488    * @dev See {IERC721Enumerable-totalSupply}.
489    */
490   function totalSupply() public view override returns (uint256) {
491     return currentIndex;
492   }
493 
494   /**
495    * @dev See {IERC721Enumerable-tokenByIndex}.
496    */
497   function tokenByIndex(uint256 index) public view override returns (uint256) {
498     require(index < totalSupply(), "ERC721A: global index out of bounds");
499     return index;
500   }
501 
502   /**
503    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
504    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
505    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
506    */
507   function tokenOfOwnerByIndex(address owner, uint256 index)
508     public
509     view
510     override
511     returns (uint256)
512   {
513     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
514     uint256 numMintedSoFar = totalSupply();
515     uint256 tokenIdsIdx = 0;
516     address currOwnershipAddr = address(0);
517     for (uint256 i = 0; i < numMintedSoFar; i++) {
518       TokenOwnership memory ownership = _ownerships[i];
519       if (ownership.addr != address(0)) {
520         currOwnershipAddr = ownership.addr;
521       }
522       if (currOwnershipAddr == owner) {
523         if (tokenIdsIdx == index) {
524           return i;
525         }
526         tokenIdsIdx++;
527       }
528     }
529     revert("ERC721A: unable to get token of owner by index");
530   }
531 
532   /**
533    * @dev See {IERC165-supportsInterface}.
534    */
535   function supportsInterface(bytes4 interfaceId)
536     public
537     view
538     virtual
539     override(ERC165, IERC165)
540     returns (bool)
541   {
542     return
543       interfaceId == type(IERC721).interfaceId ||
544       interfaceId == type(IERC721Metadata).interfaceId ||
545       interfaceId == type(IERC721Enumerable).interfaceId ||
546       super.supportsInterface(interfaceId);
547   }
548 
549   /**
550    * @dev See {IERC721-balanceOf}.
551    */
552   function balanceOf(address owner) public view override returns (uint256) {
553     require(owner != address(0), "ERC721A: balance query for the zero address");
554     return uint256(_addressData[owner].balance);
555   }
556 
557   function _numberMinted(address owner) internal view returns (uint256) {
558     require(
559       owner != address(0),
560       "ERC721A: number minted query for the zero address"
561     );
562     return uint256(_addressData[owner].numberMinted);
563   }
564 
565   function ownershipOf(uint256 tokenId)
566     internal
567     view
568     returns (TokenOwnership memory)
569   {
570     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
571 
572     uint256 lowestTokenToCheck;
573     if (tokenId >= maxBatchSize) {
574       lowestTokenToCheck = tokenId - maxBatchSize + 1;
575     }
576 
577     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
578       TokenOwnership memory ownership = _ownerships[curr];
579       if (ownership.addr != address(0)) {
580         return ownership;
581       }
582     }
583 
584     revert("ERC721A: unable to determine the owner of token");
585   }
586 
587   /**
588    * @dev See {IERC721-ownerOf}.
589    */
590   function ownerOf(uint256 tokenId) public view override returns (address) {
591     return ownershipOf(tokenId).addr;
592   }
593 
594   /**
595    * @dev See {IERC721Metadata-name}.
596    */
597   function name() public view virtual override returns (string memory) {
598     return _name;
599   }
600 
601   /**
602    * @dev See {IERC721Metadata-symbol}.
603    */
604   function symbol() public view virtual override returns (string memory) {
605     return _symbol;
606   }
607 
608   /**
609    * @dev See {IERC721Metadata-tokenURI}.
610    */
611   function tokenURI(uint256 tokenId)
612     public
613     view
614     virtual
615     override
616     returns (string memory)
617   {
618     require(
619       _exists(tokenId),
620       "ERC721Metadata: URI query for nonexistent token"
621     );
622 
623     string memory baseURI = _baseURI();
624     return
625       bytes(baseURI).length > 0
626         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
627         : "";
628   }
629 
630   /**
631    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
632    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
633    * by default, can be overriden in child contracts.
634    */
635   function _baseURI() internal view virtual returns (string memory) {
636     return "";
637   }
638 
639   /**
640    * @dev See {IERC721-approve}.
641    */
642   function approve(address to, uint256 tokenId) public override {
643     address owner = ERC721A.ownerOf(tokenId);
644     require(to != owner, "ERC721A: approval to current owner");
645 
646     require(
647       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
648       "ERC721A: approve caller is not owner nor approved for all"
649     );
650 
651     _approve(to, tokenId, owner);
652   }
653 
654   /**
655    * @dev See {IERC721-getApproved}.
656    */
657   function getApproved(uint256 tokenId) public view override returns (address) {
658     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
659 
660     return _tokenApprovals[tokenId];
661   }
662 
663   /**
664    * @dev See {IERC721-setApprovalForAll}.
665    */
666   function setApprovalForAll(address operator, bool approved) public override {
667     require(operator != _msgSender(), "ERC721A: approve to caller");
668 
669     _operatorApprovals[_msgSender()][operator] = approved;
670     emit ApprovalForAll(_msgSender(), operator, approved);
671   }
672 
673   /**
674    * @dev See {IERC721-isApprovedForAll}.
675    */
676   function isApprovedForAll(address owner, address operator)
677     public
678     view
679     virtual
680     override
681     returns (bool)
682   {
683     return _operatorApprovals[owner][operator];
684   }
685 
686   /**
687    * @dev See {IERC721-transferFrom}.
688    */
689   function transferFrom(
690     address from,
691     address to,
692     uint256 tokenId
693   ) public override {
694     _transfer(from, to, tokenId);
695   }
696 
697   /**
698    * @dev See {IERC721-safeTransferFrom}.
699    */
700   function safeTransferFrom(
701     address from,
702     address to,
703     uint256 tokenId
704   ) public override {
705     safeTransferFrom(from, to, tokenId, "");
706   }
707 
708   /**
709    * @dev See {IERC721-safeTransferFrom}.
710    */
711   function safeTransferFrom(
712     address from,
713     address to,
714     uint256 tokenId,
715     bytes memory _data
716   ) public override {
717     _transfer(from, to, tokenId);
718     require(
719       _checkOnERC721Received(from, to, tokenId, _data),
720       "ERC721A: transfer to non ERC721Receiver implementer"
721     );
722   }
723 
724   /**
725    * @dev Returns whether `tokenId` exists.
726    *
727    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
728    *
729    * Tokens start existing when they are minted (`_mint`),
730    */
731   function _exists(uint256 tokenId) internal view returns (bool) {
732     return tokenId < currentIndex;
733   }
734 
735   function _safeMint(address to, uint256 quantity) internal {
736     _safeMint(to, quantity, "");
737   }
738 
739   /**
740    * @dev Mints `quantity` tokens and transfers them to `to`.
741    *
742    * Requirements:
743    *
744    * - there must be `quantity` tokens remaining unminted in the total collection.
745    * - `to` cannot be the zero address.
746    * - `quantity` cannot be larger than the max batch size.
747    *
748    * Emits a {Transfer} event.
749    */
750   function _safeMint(
751     address to,
752     uint256 quantity,
753     bytes memory _data
754   ) internal {
755     uint256 startTokenId = currentIndex;
756     require(to != address(0), "ERC721A: mint to the zero address");
757     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
758     require(!_exists(startTokenId), "ERC721A: token already minted");
759     // require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
760 
761     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
762 
763     AddressData memory addressData = _addressData[to];
764     _addressData[to] = AddressData(
765       addressData.balance + uint128(quantity),
766       addressData.numberMinted + uint128(quantity)
767     );
768     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
769 
770     uint256 updatedIndex = startTokenId;
771 
772     for (uint256 i = 0; i < quantity; i++) {
773       emit Transfer(address(0), to, updatedIndex);
774       require(
775         _checkOnERC721Received(address(0), to, updatedIndex, _data),
776         "ERC721A: transfer to non ERC721Receiver implementer"
777       );
778       updatedIndex++;
779     }
780 
781     currentIndex = updatedIndex;
782     _afterTokenTransfers(address(0), to, startTokenId, quantity);
783   }
784 
785   /**
786    * @dev Transfers `tokenId` from `from` to `to`.
787    *
788    * Requirements:
789    *
790    * - `to` cannot be the zero address.
791    * - `tokenId` token must be owned by `from`.
792    *
793    * Emits a {Transfer} event.
794    */
795   function _transfer(
796     address from,
797     address to,
798     uint256 tokenId
799   ) private {
800     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
801 
802     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
803       getApproved(tokenId) == _msgSender() ||
804       isApprovedForAll(prevOwnership.addr, _msgSender()));
805 
806     require(
807       isApprovedOrOwner,
808       "ERC721A: transfer caller is not owner nor approved"
809     );
810 
811     require(
812       prevOwnership.addr == from,
813       "ERC721A: transfer from incorrect owner"
814     );
815     require(to != address(0), "ERC721A: transfer to the zero address");
816 
817     _beforeTokenTransfers(from, to, tokenId, 1);
818 
819     // Clear approvals from the previous owner
820     _approve(address(0), tokenId, prevOwnership.addr);
821 
822     _addressData[from].balance -= 1;
823     _addressData[to].balance += 1;
824     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
825 
826     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
827     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
828     uint256 nextTokenId = tokenId + 1;
829     if (_ownerships[nextTokenId].addr == address(0)) {
830       if (_exists(nextTokenId)) {
831         _ownerships[nextTokenId] = TokenOwnership(
832           prevOwnership.addr,
833           prevOwnership.startTimestamp
834         );
835       }
836     }
837 
838     emit Transfer(from, to, tokenId);
839     _afterTokenTransfers(from, to, tokenId, 1);
840   }
841 
842   /**
843    * @dev Approve `to` to operate on `tokenId`
844    *
845    * Emits a {Approval} event.
846    */
847   function _approve(
848     address to,
849     uint256 tokenId,
850     address owner
851   ) private {
852     _tokenApprovals[tokenId] = to;
853     emit Approval(owner, to, tokenId);
854   }
855 
856   uint256 public nextOwnerToExplicitlySet = 0;
857 
858   /**
859    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
860    */
861   function _setOwnersExplicit(uint256 quantity) internal {
862     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
863     require(quantity > 0, "quantity must be nonzero");
864     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
865     if (endIndex > collectionSize - 1) {
866       endIndex = collectionSize - 1;
867     }
868     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
869     require(_exists(endIndex), "not enough minted yet for this cleanup");
870     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
871       if (_ownerships[i].addr == address(0)) {
872         TokenOwnership memory ownership = ownershipOf(i);
873         _ownerships[i] = TokenOwnership(
874           ownership.addr,
875           ownership.startTimestamp
876         );
877       }
878     }
879     nextOwnerToExplicitlySet = endIndex + 1;
880   }
881 
882   /**
883    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
884    * The call is not executed if the target address is not a contract.
885    *
886    * @param from address representing the previous owner of the given token ID
887    * @param to target address that will receive the tokens
888    * @param tokenId uint256 ID of the token to be transferred
889    * @param _data bytes optional data to send along with the call
890    * @return bool whether the call correctly returned the expected magic value
891    */
892   function _checkOnERC721Received(
893     address from,
894     address to,
895     uint256 tokenId,
896     bytes memory _data
897   ) private returns (bool) {
898     if (to.isContract()) {
899       try
900         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
901       returns (bytes4 retval) {
902         return retval == IERC721Receiver(to).onERC721Received.selector;
903       } catch (bytes memory reason) {
904         if (reason.length == 0) {
905           revert("ERC721A: transfer to non ERC721Receiver implementer");
906         } else {
907           assembly {
908             revert(add(32, reason), mload(reason))
909           }
910         }
911       }
912     } else {
913       return true;
914     }
915   }
916 
917   /**
918    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
919    *
920    * startTokenId - the first token id to be transferred
921    * quantity - the amount to be transferred
922    *
923    * Calling conditions:
924    *
925    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
926    * transferred to `to`.
927    * - When `from` is zero, `tokenId` will be minted for `to`.
928    */
929   function _beforeTokenTransfers(
930     address from,
931     address to,
932     uint256 startTokenId,
933     uint256 quantity
934   ) internal virtual {}
935 
936   /**
937    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
938    * minting.
939    *
940    * startTokenId - the first token id to be transferred
941    * quantity - the amount to be transferred
942    *
943    * Calling conditions:
944    *
945    * - when `from` and `to` are both non-zero.
946    * - `from` and `to` are never both zero.
947    */
948   function _afterTokenTransfers(
949     address from,
950     address to,
951     uint256 startTokenId,
952     uint256 quantity
953   ) internal virtual {}
954 }
955 // /MerkleProof.sol
956 
957 
958 pragma solidity ^0.8.0;
959 
960 library MerkleProof {
961     /**
962      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
963      * defined by `root`. For this, a `proof` must be provided, containing
964      * sibling hashes on the branch from the leaf to the root of the tree. Each
965      * pair of leaves and each pair of pre-images are assumed to be sorted.
966      */
967     function verify(
968         bytes32[] memory proof,
969         bytes32 root,
970         bytes32 leaf
971     ) internal pure returns (bool) {
972         return processProof(proof, leaf) == root;
973     }
974 
975     /**
976      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
977      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
978      * hash matches the root of the tree. When processing the proof, the pairs
979      * of leafs & pre-images are assumed to be sorted.
980      *
981      * _Available since v4.4._
982      */
983     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
984         bytes32 computedHash = leaf;
985         for (uint256 i = 0; i < proof.length; i++) {
986             bytes32 proofElement = proof[i];
987             if (computedHash <= proofElement) {
988                 // Hash(current computed hash + current element of the proof)
989                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
990             } else {
991                 // Hash(current element of the proof + current computed hash)
992                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
993             }
994         }
995         return computedHash;
996     }
997 }
998 
999 pragma solidity ^0.8.7;
1000 
1001 contract MiniGrandeBySSC is Ownable, ERC721A, ReentrancyGuard {
1002 
1003     uint256 private _publicPrice = 0.007 ether;
1004     uint256 private _presalePrice = 0 ether;
1005     uint256 private _maxPurchaseDuringWhitelist = 1;
1006     uint256 private _maxPurchaseDuringSale = 1;
1007     uint256 private _maxPerTransaction = 1;
1008     uint256 private _maxMint = 2000;
1009     address private _team = 0x6FEf5A781A35d158096736dBc561F298ef47B86c;
1010     bytes32 public merkleRoot = 0x8daf3296866531d8a9a23e382da52d37f29af1f17e5e9ed8a403c896de82be5f;
1011     mapping(address => uint256) public presaleAddressMintCount;
1012     mapping(address => uint256) public saleAddressMintCount;
1013     uint32 public whitelistMinted = 0;
1014     uint32 private _maxWhitelistMints = 200;
1015 
1016     bool public isPaused = false;
1017     bool public isPublicMint = false;
1018     bool public isWhitelistMint = false;
1019     string private _tokenURI = "ipfs://QmZzPHpPmtBHACKpu4MQ6XH2mNXJcJgRhdv1KYpnHqQ6q9/";
1020     
1021     constructor() ERC721A("MiniGrandeBySecretSocietyClub", "MINIBYSSC", _maxPerTransaction, _maxMint) {}
1022 
1023     function setMaxWhitelistMints (uint32 val) external onlyOwner {
1024         _maxWhitelistMints = val;
1025     }
1026 
1027     function setMaxMintPerWalletWhitelist (uint256 val) external onlyOwner {
1028         _maxPurchaseDuringWhitelist = val;
1029     }
1030 
1031     function setMaxMintPerWalletSale (uint256 val) external onlyOwner {
1032         _maxPurchaseDuringSale = val;
1033     }
1034 
1035     function checkIsPublicMint () external view returns (bool) {
1036         return isPublicMint;
1037     }
1038 
1039     function pause() external onlyOwner {
1040         isPaused = true;
1041     }
1042 
1043     function unpause() external onlyOwner {
1044         isPaused = false;
1045     }
1046 
1047     function setTeam(address team) external onlyOwner {
1048         _team = team;
1049     }
1050 
1051     function getPublicPrice() external view returns(uint256) {
1052         return _publicPrice;
1053     }
1054 
1055     function setPublicMint (bool value) external onlyOwner {
1056         isPublicMint = value;
1057     }
1058 
1059     function setWhitelistMint (bool value) external onlyOwner {
1060         isWhitelistMint = value;
1061     }
1062 
1063     function setPresalePrice (uint256 price) external onlyOwner {
1064         _presalePrice = price;
1065     }
1066 
1067     function setPublicPrice (uint256 price) external onlyOwner {
1068         _publicPrice = price;
1069     }
1070 
1071     function setCollectionSize (uint256 size) external onlyOwner {
1072         collectionSize = size;
1073         _maxMint = size;
1074     }
1075 
1076     modifier mintGuard(uint256 tokenCount) {
1077         require(!isPaused, "Paused!");
1078         
1079         require(tokenCount > 0 && tokenCount <= _maxPerTransaction, "Max one per transaction");
1080         require(msg.sender == tx.origin, "Sender not origin");
1081         // Price check
1082         if (isPublicMint) {
1083             require(_publicPrice * tokenCount <= msg.value, "Insufficient funds");
1084         } else {
1085             require(_presalePrice * tokenCount <= msg.value, "Insufficient funds");
1086         }
1087         require(totalSupply() + tokenCount <= _maxMint+1, "Sold out!");
1088         _;
1089     }
1090 
1091     function mint(uint256 amount) external payable mintGuard(amount) {
1092         require(isPublicMint, "Sale has not started!");
1093         require(saleAddressMintCount[msg.sender] + amount <= _maxPurchaseDuringSale, "Only one NFT can be minted");
1094         saleAddressMintCount[msg.sender] += amount;
1095 
1096         _safeMint(msg.sender, amount);
1097     }
1098 
1099     function mintPresale(bytes32[] calldata proof, uint256 amount) external payable mintGuard(amount) {
1100         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You're not on the whitelist");
1101         require(isWhitelistMint, "You're on the whitelist but mint has not started!!");
1102         require(presaleAddressMintCount[msg.sender] + amount <= _maxPurchaseDuringWhitelist, "Only one NFT can be minted");
1103         presaleAddressMintCount[msg.sender] += amount;
1104         require(whitelistMinted < _maxWhitelistMints, "All whitelist mints have been claimed!");
1105         whitelistMinted += 1;
1106 
1107         _safeMint(msg.sender, amount);
1108     }
1109 
1110     function setMaxBatchSize (uint256 val) external onlyOwner {
1111         maxBatchSize = val;
1112         _maxPerTransaction = val;
1113     }
1114 
1115     function cashout() external onlyOwner {
1116         payable(_team).transfer(address(this).balance);
1117     }
1118 
1119     function setCashout(address addr) external onlyOwner returns(address) {
1120         _team = addr;
1121         return addr;
1122     }
1123 
1124     function devMint(uint32 qty) external onlyOwner {
1125         _safeMint(msg.sender, qty);
1126     }
1127 
1128     function setMerkleRoot(bytes32 root) external onlyOwner {
1129         merkleRoot = root;
1130     }
1131 
1132     function setMaxMint(uint256 maxMint) external onlyOwner {
1133         _maxMint = maxMint;
1134     }
1135 
1136     function setBaseURI(string calldata baseURI) external onlyOwner {
1137         _tokenURI = baseURI;
1138     }
1139 
1140     function _baseURI() internal view virtual override returns (string memory) {
1141         return _tokenURI;
1142     }
1143 }