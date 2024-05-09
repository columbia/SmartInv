1 pragma solidity ^0.8.0;
2 interface IERC165 {
3     function supportsInterface(bytes4 interfaceId) external view returns (bool);
4 }
5 pragma solidity ^0.8.0;
6 interface IERC721Receiver {
7     function onERC721Received(
8         address operator,
9         address from,
10         uint256 tokenId,
11         bytes calldata data
12     ) external returns (bytes4);
13 }
14 pragma solidity ^0.8.0;
15 interface IERC721 is IERC165 {
16     event Transfer(
17         address indexed from,
18         address indexed to,
19         uint256 indexed tokenId
20     );
21     event Approval(
22         address indexed owner,
23         address indexed approved,
24         uint256 indexed tokenId
25     );
26     event ApprovalForAll(
27         address indexed owner,
28         address indexed operator,
29         bool approved
30     );
31     function balanceOf(address owner) external view returns (uint256 balance);
32     function ownerOf(uint256 tokenId) external view returns (address owner);
33     function safeTransferFrom(
34         address from,
35         address to,
36         uint256 tokenId
37     ) external;
38     function transferFrom(
39         address from,
40         address to,
41         uint256 tokenId
42     ) external;
43     function approve(address to, uint256 tokenId) external;
44     function getApproved(uint256 tokenId)
45         external
46         view
47         returns (address operator);
48     function setApprovalForAll(address operator, bool _approved) external;
49     function isApprovedForAll(address owner, address operator)
50         external
51         view
52         returns (bool);
53     function safeTransferFrom(
54         address from,
55         address to,
56         uint256 tokenId,
57         bytes calldata data
58     ) external;
59 }
60 pragma solidity ^0.8.0;
61 interface IERC721Metadata is IERC721 {
62     function name() external view returns (string memory);
63     function symbol() external view returns (string memory);
64     function tokenURI(uint256 tokenId) external view returns (string memory);
65 }
66 pragma solidity ^0.8.0;
67 interface IERC721Enumerable is IERC721 {
68     function totalSupply() external view returns (uint256);
69     function tokenOfOwnerByIndex(address owner, uint256 index)
70         external
71         view
72         returns (uint256);
73     function tokenByIndex(uint256 index) external view returns (uint256);
74 }
75 pragma solidity ^0.8.1;
76 library Address {
77     function isContract(address account) internal view returns (bool) {
78 
79         return account.code.length > 0;
80     }
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(
83             address(this).balance >= amount,
84             "Address: insufficient balance"
85         );
86 
87         (bool success, ) = recipient.call{value: amount}("");
88         require(
89             success,
90             "Address: unable to send value, recipient may have reverted"
91         );
92     }
93     function functionCall(address target, bytes memory data)
94         internal
95         returns (bytes memory)
96     {
97         return functionCall(target, data, "Address: low-level call failed");
98     }
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106     function functionCallWithValue(
107         address target,
108         bytes memory data,
109         uint256 value
110     ) internal returns (bytes memory) {
111         return
112             functionCallWithValue(
113                 target,
114                 data,
115                 value,
116                 "Address: low-level call with value failed"
117             );
118     }
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value,
123         string memory errorMessage
124     ) internal returns (bytes memory) {
125         require(
126             address(this).balance >= value,
127             "Address: insufficient balance for call"
128         );
129         require(isContract(target), "Address: call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.call{value: value}(
132             data
133         );
134         return verifyCallResult(success, returndata, errorMessage);
135     }
136     function functionStaticCall(address target, bytes memory data)
137         internal
138         view
139         returns (bytes memory)
140     {
141         return
142             functionStaticCall(
143                 target,
144                 data,
145                 "Address: low-level static call failed"
146             );
147     }
148     function functionStaticCall(
149         address target,
150         bytes memory data,
151         string memory errorMessage
152     ) internal view returns (bytes memory) {
153         require(isContract(target), "Address: static call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.staticcall(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158     function functionDelegateCall(address target, bytes memory data)
159         internal
160         returns (bytes memory)
161     {
162         return
163             functionDelegateCall(
164                 target,
165                 data,
166                 "Address: low-level delegate call failed"
167             );
168     }
169     function functionDelegateCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(isContract(target), "Address: delegate call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.delegatecall(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179     function verifyCallResult(
180         bool success,
181         bytes memory returndata,
182         string memory errorMessage
183     ) internal pure returns (bytes memory) {
184         if (success) {
185             return returndata;
186         } else {
187             if (returndata.length > 0) {
188 
189                 assembly {
190                     let returndata_size := mload(returndata)
191                     revert(add(32, returndata), returndata_size)
192                 }
193             } else {
194                 revert(errorMessage);
195             }
196         }
197     }
198 }
199 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
200 pragma solidity ^0.8.0;
201 abstract contract Context {
202     function _msgSender() internal view virtual returns (address) {
203         return msg.sender;
204     }
205 
206     function _msgData() internal view virtual returns (bytes calldata) {
207         return msg.data;
208     }
209 }
210 
211 pragma solidity ^0.8.0;
212 
213 abstract contract Ownable is Context {
214     address private _owner;
215 
216     event OwnershipTransferred(
217         address indexed previousOwner,
218         address indexed newOwner
219     );
220     constructor() {
221         _setOwner(_msgSender());
222     }
223     function owner() public view virtual returns (address) {
224         return _owner;
225     }
226     modifier onlyOwner() {
227         require(owner() == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230     function renounceOwnership() public virtual onlyOwner {
231         _setOwner(address(0));
232     }
233     function transferOwnership(address newOwner) public virtual onlyOwner {
234         require(
235             newOwner != address(0),
236             "Ownable: new owner is the zero address"
237         );
238         _setOwner(newOwner);
239     }
240 
241     function _setOwner(address newOwner) private {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
248 pragma solidity ^0.8.0;
249 library Strings {
250     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
251     function toString(uint256 value) internal pure returns (string memory) {
252         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
253 
254         if (value == 0) {
255             return "0";
256         }
257         uint256 temp = value;
258         uint256 digits;
259         while (temp != 0) {
260             digits++;
261             temp /= 10;
262         }
263         bytes memory buffer = new bytes(digits);
264         while (value != 0) {
265             digits -= 1;
266             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
267             value /= 10;
268         }
269         return string(buffer);
270     }
271     function toHexString(uint256 value) internal pure returns (string memory) {
272         if (value == 0) {
273             return "0x00";
274         }
275         uint256 temp = value;
276         uint256 length = 0;
277         while (temp != 0) {
278             length++;
279             temp >>= 8;
280         }
281         return toHexString(value, length);
282     }
283     function toHexString(uint256 value, uint256 length)
284         internal
285         pure
286         returns (string memory)
287     {
288         bytes memory buffer = new bytes(2 * length + 2);
289         buffer[0] = "0";
290         buffer[1] = "x";
291         for (uint256 i = 2 * length + 1; i > 1; --i) {
292             buffer[i] = _HEX_SYMBOLS[value & 0xf];
293             value >>= 4;
294         }
295         require(value == 0, "Strings: hex length insufficient");
296         return string(buffer);
297     }
298 }
299 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
300 pragma solidity ^0.8.0;
301 abstract contract ERC165 is IERC165 {
302     function supportsInterface(bytes4 interfaceId)
303         public
304         view
305         virtual
306         override
307         returns (bool)
308     {
309         return interfaceId == type(IERC165).interfaceId;
310     }
311 }
312 
313 
314 // SPDX-License-Identifier: MIT
315 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 /**
321  * @dev Interface for the NFT Royalty Standard.
322  *
323  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
324  * support for royalty payments across all NFT marketplaces and ecosystem participants.
325  *
326  * _Available since v4.5._
327  */
328 interface IERC2981 is IERC165 {
329     /**
330      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
331      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
332      */
333     function royaltyInfo(uint256 tokenId, uint256 salePrice)
334         external
335         view
336         returns (address receiver, uint256 royaltyAmount);
337 }
338 
339 
340 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 
345 /**
346  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
347  *
348  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
349  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
350  *
351  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
352  * fee is specified in basis points by default.
353  *
354  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
355  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
356  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
357  *
358  * _Available since v4.5._
359  */
360 abstract contract ERC2981 is IERC2981, ERC165 {
361     struct RoyaltyInfo {
362         address receiver;
363         uint96 royaltyFraction;
364     }
365 
366     RoyaltyInfo private _defaultRoyaltyInfo;
367     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
368 
369     /**
370      * @dev See {IERC165-supportsInterface}.
371      */
372     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
373         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
374     }
375 
376     /**
377      * @inheritdoc IERC2981
378      */
379     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
380         external
381         view
382         virtual
383         override
384         returns (address, uint256)
385     {
386         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
387 
388         if (royalty.receiver == address(0)) {
389             royalty = _defaultRoyaltyInfo;
390         }
391 
392         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
393 
394         return (royalty.receiver, royaltyAmount);
395     }
396 
397     /**
398      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
399      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
400      * override.
401      */
402     function _feeDenominator() internal pure virtual returns (uint96) {
403         return 10000;
404     }
405 
406     /**
407      * @dev Sets the royalty information that all ids in this contract will default to.
408      *
409      * Requirements:
410      *
411      * - `receiver` cannot be the zero address.
412      * - `feeNumerator` cannot be greater than the fee denominator.
413      */
414     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
415         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
416         require(receiver != address(0), "ERC2981: invalid receiver");
417 
418         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
419     }
420 
421     /**
422      * @dev Removes default royalty information.
423      */
424     function _deleteDefaultRoyalty() internal virtual {
425         delete _defaultRoyaltyInfo;
426     }
427 
428     /**
429      * @dev Sets the royalty information for a specific token id, overriding the global default.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must be already minted.
434      * - `receiver` cannot be the zero address.
435      * - `feeNumerator` cannot be greater than the fee denominator.
436      */
437     function _setTokenRoyalty(
438         uint256 tokenId,
439         address receiver,
440         uint96 feeNumerator
441     ) internal virtual {
442         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
443         require(receiver != address(0), "ERC2981: Invalid parameters");
444 
445         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
446     }
447 
448     /**
449      * @dev Resets royalty information for the token id back to the global default.
450      */
451     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
452         delete _tokenRoyaltyInfo[tokenId];
453     }
454 }
455 
456 
457 
458 pragma solidity ^0.8.0;
459 contract ERC721A is
460     Context,
461     ERC165,
462     ERC2981,
463     IERC721,
464     IERC721Metadata,
465     IERC721Enumerable
466 {
467     using Address for address;
468     using Strings for uint256;
469 
470     struct TokenOwnership {
471         address addr;
472         uint64 startTimestamp;
473     }
474 
475     struct AddressData {
476         uint128 balance;
477         uint128 numberMinted;
478     }
479 
480     uint256 private currentIndex = 0;
481 
482     uint256 internal immutable collectionSize;
483     uint256 internal immutable maxBatchSize;
484     string private _name;
485     string private _symbol;
486     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
487     mapping(uint256 => TokenOwnership) private _ownerships;
488     mapping(address => AddressData) private _addressData;
489     mapping(uint256 => address) private _tokenApprovals;
490     mapping(address => mapping(address => bool)) private _operatorApprovals;
491     constructor(
492         string memory name_,
493         string memory symbol_,
494         uint256 maxBatchSize_,
495         uint256 collectionSize_
496     ) {
497         require(
498             collectionSize_ > 0,
499             "ERC721A: collection must have a nonzero supply"
500         );
501         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
502         _name = name_;
503         _symbol = symbol_;
504         maxBatchSize = maxBatchSize_;
505         collectionSize = collectionSize_;
506     }
507     function totalSupply() public view override returns (uint256) {
508         return currentIndex;
509     }
510     function tokenByIndex(uint256 index)
511         public
512         view
513         override
514         returns (uint256)
515     {
516         require(index < totalSupply(), "ERC721A: global index out of bounds");
517         return index;
518     }
519     function tokenOfOwnerByIndex(address owner, uint256 index)
520         public
521         view
522         override
523         returns (uint256)
524     {
525         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
526         uint256 numMintedSoFar = totalSupply();
527         uint256 tokenIdsIdx = 0;
528         address currOwnershipAddr = address(0);
529         for (uint256 i = 0; i < numMintedSoFar; i++) {
530             TokenOwnership memory ownership = _ownerships[i];
531             if (ownership.addr != address(0)) {
532                 currOwnershipAddr = ownership.addr;
533             }
534             if (currOwnershipAddr == owner) {
535                 if (tokenIdsIdx == index) {
536                     return i;
537                 }
538                 tokenIdsIdx++;
539             }
540         }
541         revert("ERC721A: unable to get token of owner by index");
542     }
543     function supportsInterface(bytes4 interfaceId)
544         public
545         view
546         virtual
547         override(ERC2981, ERC165, IERC165)
548         returns (bool)
549     {
550         return
551             interfaceId == type(IERC2981).interfaceId ||
552             interfaceId == type(IERC721).interfaceId ||
553             interfaceId == type(IERC721Metadata).interfaceId ||
554             interfaceId == type(IERC721Enumerable).interfaceId ||
555             super.supportsInterface(interfaceId);
556     }
557 
558 
559 
560 
561     function balanceOf(address owner) public view override returns (uint256) {
562         require(
563             owner != address(0),
564             "ERC721A: balance query for the zero address"
565         );
566         return uint256(_addressData[owner].balance);
567     }
568 
569     function _numberMinted(address owner) internal view returns (uint256) {
570         require(
571             owner != address(0),
572             "ERC721A: number minted query for the zero address"
573         );
574         return uint256(_addressData[owner].numberMinted);
575     }
576 
577     function ownershipOf(uint256 tokenId)
578         internal
579         view
580         returns (TokenOwnership memory)
581     {
582         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
583 
584         uint256 lowestTokenToCheck;
585         if (tokenId >= maxBatchSize) {
586             lowestTokenToCheck = tokenId - maxBatchSize + 1;
587         }
588 
589         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
590             TokenOwnership memory ownership = _ownerships[curr];
591             if (ownership.addr != address(0)) {
592                 return ownership;
593             }
594         }
595 
596         revert("ERC721A: unable to determine the owner of token");
597     }
598     function ownerOf(uint256 tokenId) public view override returns (address) {
599         return ownershipOf(tokenId).addr;
600     }
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604     function symbol() public view virtual override returns (string memory) {
605         return _symbol;
606     }
607     function tokenURI(uint256 tokenId)
608         public
609         view
610         virtual
611         override
612         returns (string memory)
613     {
614         require(
615             _exists(tokenId),
616             "ERC721Metadata: URI query for nonexistent token"
617         );
618 
619         string memory baseURI = _baseURI();
620         return
621             bytes(baseURI).length > 0
622                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
623                 : "";
624     }
625     function _baseURI() internal view virtual returns (string memory) {
626         return "";
627     }
628     function approve(address to, uint256 tokenId) public override {
629         address owner = ERC721A.ownerOf(tokenId);
630         require(to != owner, "ERC721A: approval to current owner");
631 
632         require(
633             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
634             "ERC721A: approve caller is not owner nor approved for all"
635         );
636 
637         _approve(to, tokenId, owner);
638     }
639     function getApproved(uint256 tokenId)
640         public
641         view
642         override
643         returns (address)
644     {
645         require(
646             _exists(tokenId),
647             "ERC721A: approved query for nonexistent token"
648         );
649 
650         return _tokenApprovals[tokenId];
651     }
652     function setApprovalForAll(address operator, bool approved)
653         public
654         override
655     {
656         require(operator != _msgSender(), "ERC721A: approve to caller");
657 
658         _operatorApprovals[_msgSender()][operator] = approved;
659         emit ApprovalForAll(_msgSender(), operator, approved);
660     }
661     function isApprovedForAll(address owner, address operator)
662         public
663         view
664         virtual
665         override
666         returns (bool)
667     {
668         return _operatorApprovals[owner][operator];
669     }
670     function transferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) public override {
675         _transfer(from, to, tokenId);
676     }
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) public override {
682         safeTransferFrom(from, to, tokenId, "");
683     }
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes memory _data
689     ) public override {
690         _transfer(from, to, tokenId);
691         require(
692             _checkOnERC721Received(from, to, tokenId, _data),
693             "ERC721A: transfer to non ERC721Receiver implementer"
694         );
695     }
696     function _exists(uint256 tokenId) internal view returns (bool) {
697         return tokenId < currentIndex;
698     }
699 
700     function _safeMint(address to, uint256 quantity) internal {
701         _safeMint(to, quantity, "");
702     }
703     function _safeMint(
704         address to,
705         uint256 quantity,
706         bytes memory _data
707     ) internal {
708         uint256 startTokenId = currentIndex;
709         require(to != address(0), "ERC721A: mint to the zero address");
710         require(!_exists(startTokenId), "ERC721A: token already minted");
711         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
712 
713         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
714 
715         AddressData memory addressData = _addressData[to];
716         _addressData[to] = AddressData(
717             addressData.balance + uint128(quantity),
718             addressData.numberMinted + uint128(quantity)
719         );
720         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
721 
722         uint256 updatedIndex = startTokenId;
723 
724         for (uint256 i = 0; i < quantity; i++) {
725             emit Transfer(address(0), to, updatedIndex);
726             require(
727                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
728                 "ERC721A: transfer to non ERC721Receiver implementer"
729             );
730             updatedIndex++;
731         }
732 
733         currentIndex = updatedIndex;
734         _afterTokenTransfers(address(0), to, startTokenId, quantity);
735     }
736     function _transfer(
737         address from,
738         address to,
739         uint256 tokenId
740     ) private {
741         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
742 
743         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
744             getApproved(tokenId) == _msgSender() ||
745             isApprovedForAll(prevOwnership.addr, _msgSender()));
746 
747         require(
748             isApprovedOrOwner,
749             "ERC721A: transfer caller is not owner nor approved"
750         );
751 
752         require(
753             prevOwnership.addr == from,
754             "ERC721A: transfer from incorrect owner"
755         );
756         require(to != address(0), "ERC721A: transfer to the zero address");
757 
758         _beforeTokenTransfers(from, to, tokenId, 1);
759         _approve(address(0), tokenId, prevOwnership.addr);
760 
761         _addressData[from].balance -= 1;
762         _addressData[to].balance += 1;
763         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
764         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
765         uint256 nextTokenId = tokenId + 1;
766         if (_ownerships[nextTokenId].addr == address(0)) {
767             if (_exists(nextTokenId)) {
768                 _ownerships[nextTokenId] = TokenOwnership(
769                     prevOwnership.addr,
770                     prevOwnership.startTimestamp
771                 );
772             }
773         }
774 
775         emit Transfer(from, to, tokenId);
776         _afterTokenTransfers(from, to, tokenId, 1);
777     }
778     function _approve(
779         address to,
780         uint256 tokenId,
781         address owner
782     ) private {
783         _tokenApprovals[tokenId] = to;
784         emit Approval(owner, to, tokenId);
785     }
786 
787     uint256 public nextOwnerToExplicitlySet = 0;
788     function _setOwnersExplicit(uint256 quantity) internal {
789         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
790         require(quantity > 0, "quantity must be nonzero");
791         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
792         if (endIndex > collectionSize - 1) {
793             endIndex = collectionSize - 1;
794         }
795         require(_exists(endIndex), "not enough minted yet for this cleanup");
796         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
797             if (_ownerships[i].addr == address(0)) {
798                 TokenOwnership memory ownership = ownershipOf(i);
799                 _ownerships[i] = TokenOwnership(
800                     ownership.addr,
801                     ownership.startTimestamp
802                 );
803             }
804         }
805         nextOwnerToExplicitlySet = endIndex + 1;
806     }
807     function _checkOnERC721Received(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) private returns (bool) {
813         if (to.isContract()) {
814             try
815                 IERC721Receiver(to).onERC721Received(
816                     _msgSender(),
817                     from,
818                     tokenId,
819                     _data
820                 )
821             returns (bytes4 retval) {
822                 return retval == IERC721Receiver(to).onERC721Received.selector;
823             } catch (bytes memory reason) {
824                 if (reason.length == 0) {
825                     revert(
826                         "ERC721A: transfer to non ERC721Receiver implementer"
827                     );
828                 } else {
829                     assembly {
830                         revert(add(32, reason), mload(reason))
831                     }
832                 }
833             }
834         } else {
835             return true;
836         }
837     }
838     function _beforeTokenTransfers(
839         address from,
840         address to,
841         uint256 startTokenId,
842         uint256 quantity
843     ) internal virtual {}
844     function _afterTokenTransfers(
845         address from,
846         address to,
847         uint256 startTokenId,
848         uint256 quantity
849     ) internal virtual {}
850 }
851 
852 library MerkleProof {
853     function verify(
854         bytes32[] memory proof,
855         bytes32 root,
856         bytes32 leaf
857     ) internal pure returns (bool) {
858         return processProof(proof, leaf) == root;
859     }
860     function processProof(bytes32[] memory proof, bytes32 leaf)
861         internal
862         pure
863         returns (bytes32)
864     {
865         bytes32 computedHash = leaf;
866         for (uint256 i = 0; i < proof.length; i++) {
867             bytes32 proofElement = proof[i];
868             if (computedHash <= proofElement) {
869                 computedHash = _efficientHash(computedHash, proofElement);
870             } else {
871                 computedHash = _efficientHash(proofElement, computedHash);
872             }
873         }
874         return computedHash;
875     }
876 
877     function _efficientHash(bytes32 a, bytes32 b)
878         private
879         pure
880         returns (bytes32 value)
881     {
882         assembly {
883             mstore(0x00, a)
884             mstore(0x20, b)
885             value := keccak256(0x00, 0x40)
886         }
887     }
888 }
889 
890 
891 interface IERC20 {
892     function transfer(address,uint) external;
893     function balanceOf(address) external returns(uint);
894 }
895 
896 
897 contract theVillainsNFT is Ownable, ERC721A {
898 
899     bool public publicSale;
900     bool public whitelistSale;
901 
902     mapping(address => uint) public freemints;
903     mapping(address => uint) public whitelistmints;
904 
905 
906     using Strings for uint256;
907 
908     uint256 public maxToken = 1668;
909     uint256 public whitelist_price = 0.033333 ether;
910     uint256 public public_price =    0.044444 ether;
911 
912     string private _baseTokenURI;
913     
914     bytes32 public root;
915 
916 
917     constructor(string memory name, string memory uri, bytes32 _root)
918         ERC721A(name, name, 50, maxToken)
919     {
920         _setDefaultRoyalty(msg.sender,1000);
921         _baseTokenURI = uri;
922         root = _root;
923 
924     }
925 
926     modifier callerIsEOA() {
927         require(tx.origin == msg.sender, "???");
928         _;
929     }
930 
931     function numberMinted(address owner) internal view returns (uint256) {
932         return _numberMinted(owner);
933     }
934 
935     function getOwnershipData(uint256 tokenId)
936         external
937         view
938         returns (TokenOwnership memory)
939     {
940         return ownershipOf(tokenId);
941     }
942 
943     function tokenURI(uint256 tokenId)
944         public
945         view
946         virtual
947         override
948         returns (string memory)
949     {
950         require(
951             _exists(tokenId),
952             "ERC721Metadata: URI query for nonexistent token"
953         );
954 
955 
956         string memory _tokenURI = super.tokenURI(tokenId);
957         return
958             bytes(_tokenURI).length > 0
959                 ? string(abi.encodePacked(_tokenURI, ".json"))
960                 : "";
961     }
962 
963 
964 
965     function verifyFreeMint(bytes32[] memory proof, uint256 permited) internal view returns (bool) {
966         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,":freemint:",permited.toString()));
967         return  MerkleProof.verify(proof, root, leaf) ;
968     }
969 
970     function verifyWhitelistMint(bytes32[] memory proof, uint256 permited) internal view returns (bool) {
971         bytes32 leaf = keccak256(abi.encodePacked(msg.sender,":whitelist:",permited.toString()));
972         return  MerkleProof.verify(proof, root, leaf) ;
973     }
974 
975 
976 
977     function freeMint(uint256 quantity, uint256 permited, bytes32[] memory proof) external callerIsEOA {
978         require(!whitelistSale && !publicSale, "FreeMint_OVER");
979         require(quantity > 0, "INVALID_QUANTITY");
980         freemints[msg.sender]+=quantity;
981         require(verifyFreeMint(proof, permited ),"INVALID PROOF");
982         require( freemints[msg.sender] <= permited, "CANNOT_MINT_THAT_MANY");
983         require(totalSupply() + quantity < 368, "NOT_ENOUGH_FOR_FREE_MINT");
984 
985         _safeMint(msg.sender,quantity);
986 
987     }
988 
989     function whitelistMint(uint256 quantity, uint256 permited, bytes32[] memory proof) external payable callerIsEOA {
990         require(whitelistSale, "SALE_HAS_NOT_STARTED_YET");
991         require(!publicSale, "WHITELIST_OVER");
992         require(quantity > 0, "INVALID_QUANTITY");
993 
994         whitelistmints[msg.sender]+=quantity;
995         
996             require( whitelist_price*quantity <= msg.value, "ETH" );
997             require(verifyWhitelistMint(proof, permited ),"INVALID PROOF");
998             require( whitelistmints[msg.sender] <= permited, "CANNOT_MINT_THAT_MANY");   
999 
1000         require(totalSupply() + quantity < maxToken, "NOT_ENOUGH_SUPPLY");
1001         _safeMint(msg.sender, quantity);
1002     }
1003 
1004 
1005     function publicMint() external payable callerIsEOA {
1006         require( publicSale , "SALE_HAS_NOT_STARTED_YET");
1007         require( public_price <= msg.value, "ETH" );
1008         require(totalSupply() + 1 < maxToken, "NOT_ENOUGH_SUPPLY");
1009         _safeMint(msg.sender,1);
1010 
1011     }
1012 
1013     function ownerMint(address _address, uint256 quantity) external onlyOwner {
1014         require(totalSupply() + quantity < maxToken, "NOT_ENOUGH_SUPPLY");
1015         _safeMint(_address, quantity);
1016     }
1017 
1018     function _baseURI() internal view virtual override returns (string memory) {
1019         return _baseTokenURI;
1020     }
1021 
1022 
1023     function setRoot(bytes32 _root) external onlyOwner {
1024         root = _root;
1025     }
1026 
1027     function flipPublicSaleState() external onlyOwner {
1028         publicSale = !publicSale;
1029     }
1030 
1031     function flipWhitelistState() external onlyOwner {
1032         whitelistSale = !whitelistSale;
1033     }
1034 
1035     function setBaseURI(string calldata baseURI) external onlyOwner {
1036         _baseTokenURI = baseURI;
1037     }
1038 
1039     function withdraw() external onlyOwner {
1040         payable(msg.sender).transfer(address(this).balance);
1041     }
1042 
1043     function rescueToken(IERC20 token) external onlyOwner{
1044         token.transfer(msg.sender, token.balanceOf(address(this)));
1045     }
1046     
1047     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyOwner {
1048         _setDefaultRoyalty( receiver,  feeNumerator);
1049     }
1050 
1051     function deleteDefaultRoyalty() external onlyOwner {
1052         _deleteDefaultRoyalty();
1053     }
1054 
1055     function setTokenRoyalty(uint256 tokenId,address receiver,uint96 feeNumerator) external onlyOwner {
1056         _setTokenRoyalty(tokenId,receiver,feeNumerator);
1057     }
1058 
1059     function resetTokenRoyalty(uint256 tokenId) external onlyOwner {
1060         _resetTokenRoyalty(tokenId);
1061     }
1062 
1063     fallback() external payable{}
1064     receive() external payable{}
1065     
1066 }