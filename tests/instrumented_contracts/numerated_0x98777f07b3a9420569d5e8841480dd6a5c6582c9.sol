1 // SPDX-License-Identifier: MIT
2 /**
3  * @title ThePresidents
4  * @author DevAmerican
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 pragma solidity ^0.8.0;
8 interface IERC165 {
9     function supportsInterface(bytes4 interfaceId) external view returns (bool);
10 }
11 pragma solidity ^0.8.0;
12 interface IERC721Receiver {
13     function onERC721Received(
14         address operator,
15         address from,
16         uint256 tokenId,
17         bytes calldata data
18     ) external returns (bytes4);
19 }
20 pragma solidity ^0.8.0;
21 interface IERC721 is IERC165 {
22     event Transfer(
23         address indexed from,
24         address indexed to,
25         uint256 indexed tokenId
26     );
27     event Approval(
28         address indexed owner,
29         address indexed approved,
30         uint256 indexed tokenId
31     );
32     event ApprovalForAll(
33         address indexed owner,
34         address indexed operator,
35         bool approved
36     );
37     function balanceOf(address owner) external view returns (uint256 balance);
38     function ownerOf(uint256 tokenId) external view returns (address owner);
39     function safeTransferFrom(
40         address from,
41         address to,
42         uint256 tokenId
43     ) external;
44     function transferFrom(
45         address from,
46         address to,
47         uint256 tokenId
48     ) external;
49     function approve(address to, uint256 tokenId) external;
50     function getApproved(uint256 tokenId)
51         external
52         view
53         returns (address operator);
54     function setApprovalForAll(address operator, bool _approved) external;
55     function isApprovedForAll(address owner, address operator)
56         external
57         view
58         returns (bool);
59     function safeTransferFrom(
60         address from,
61         address to,
62         uint256 tokenId,
63         bytes calldata data
64     ) external;
65 }
66 pragma solidity ^0.8.0;
67 interface IERC721Metadata is IERC721 {
68     function name() external view returns (string memory);
69     function symbol() external view returns (string memory);
70     function tokenURI(uint256 tokenId) external view returns (string memory);
71 }
72 pragma solidity ^0.8.0;
73 interface IERC721Enumerable is IERC721 {
74     function totalSupply() external view returns (uint256);
75     function tokenOfOwnerByIndex(address owner, uint256 index)
76         external
77         view
78         returns (uint256);
79     function tokenByIndex(uint256 index) external view returns (uint256);
80 }
81 pragma solidity ^0.8.1;
82 library Address {
83     function isContract(address account) internal view returns (bool) {
84 
85         return account.code.length > 0;
86     }
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(
89             address(this).balance >= amount,
90             "Address: insufficient balance"
91         );
92 
93         (bool success, ) = recipient.call{value: amount}("");
94         require(
95             success,
96             "Address: unable to send value, recipient may have reverted"
97         );
98     }
99     function functionCall(address target, bytes memory data)
100         internal
101         returns (bytes memory)
102     {
103         return functionCall(target, data, "Address: low-level call failed");
104     }
105     function functionCall(
106         address target,
107         bytes memory data,
108         string memory errorMessage
109     ) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return
118             functionCallWithValue(
119                 target,
120                 data,
121                 value,
122                 "Address: low-level call with value failed"
123             );
124     }
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(
132             address(this).balance >= value,
133             "Address: insufficient balance for call"
134         );
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{value: value}(
138             data
139         );
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142     function functionStaticCall(address target, bytes memory data)
143         internal
144         view
145         returns (bytes memory)
146     {
147         return
148             functionStaticCall(
149                 target,
150                 data,
151                 "Address: low-level static call failed"
152             );
153     }
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164     function functionDelegateCall(address target, bytes memory data)
165         internal
166         returns (bytes memory)
167     {
168         return
169             functionDelegateCall(
170                 target,
171                 data,
172                 "Address: low-level delegate call failed"
173             );
174     }
175     function functionDelegateCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(isContract(target), "Address: delegate call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.delegatecall(data);
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185     function verifyCallResult(
186         bool success,
187         bytes memory returndata,
188         string memory errorMessage
189     ) internal pure returns (bytes memory) {
190         if (success) {
191             return returndata;
192         } else {
193             if (returndata.length > 0) {
194 
195                 assembly {
196                     let returndata_size := mload(returndata)
197                     revert(add(32, returndata), returndata_size)
198                 }
199             } else {
200                 revert(errorMessage);
201             }
202         }
203     }
204 }
205 pragma solidity ^0.8.0;
206 abstract contract Context {
207     function _msgSender() internal view virtual returns (address) {
208         return msg.sender;
209     }
210 
211     function _msgData() internal view virtual returns (bytes calldata) {
212         return msg.data;
213     }
214 }
215 pragma solidity ^0.8.0;
216 abstract contract Ownable is Context {
217     address private _owner;
218 
219     event OwnershipTransferred(
220         address indexed previousOwner,
221         address indexed newOwner
222     );
223     constructor() {
224         _setOwner(_msgSender());
225     }
226     function owner() public view virtual returns (address) {
227         return _owner;
228     }
229     modifier onlyOwner() {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233     function renounceOwnership() public virtual onlyOwner {
234         _setOwner(address(0));
235     }
236     function transferOwnership(address newOwner) public virtual onlyOwner {
237         require(
238             newOwner != address(0),
239             "Ownable: new owner is the zero address"
240         );
241         _setOwner(newOwner);
242     }
243 
244     function _setOwner(address newOwner) private {
245         address oldOwner = _owner;
246         _owner = newOwner;
247         emit OwnershipTransferred(oldOwner, newOwner);
248     }
249 }
250 pragma solidity ^0.8.0;
251 library Strings {
252     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
253     function toString(uint256 value) internal pure returns (string memory) {
254 
255         if (value == 0) {
256             return "0";
257         }
258         uint256 temp = value;
259         uint256 digits;
260         while (temp != 0) {
261             digits++;
262             temp /= 10;
263         }
264         bytes memory buffer = new bytes(digits);
265         while (value != 0) {
266             digits -= 1;
267             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
268             value /= 10;
269         }
270         return string(buffer);
271     }
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284     function toHexString(uint256 value, uint256 length)
285         internal
286         pure
287         returns (string memory)
288     {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
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
312 pragma solidity ^0.8.0;
313 abstract contract ReentrancyGuard {
314     uint256 private constant _NOT_ENTERED = 1;
315     uint256 private constant _ENTERED = 2;
316 
317     uint256 private _status;
318 
319     constructor() {
320         _status = _NOT_ENTERED;
321     }
322     modifier nonReentrant() {
323         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
324         _status = _ENTERED;
325 
326         _;
327         // https://eips.ethereum.org/EIPS/eip-2200)
328         _status = _NOT_ENTERED;
329     }
330 }
331 pragma solidity ^0.8.0;
332 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
333     using Address for address;
334     using Strings for uint256;
335 
336     struct TokenOwnership {
337         address addr;
338         uint64 startTimestamp;
339     }
340 
341     struct AddressData {
342         uint128 balance;
343         uint128 numberMinted;
344     }
345 
346     uint256 private currentIndex = 0;
347 
348     uint256 internal immutable collectionSize;
349     uint256 internal immutable maxBatchSize;
350     string private _name;
351     string private _symbol;
352     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
353     mapping(uint256 => TokenOwnership) private _ownerships;
354     mapping(address => AddressData) private _addressData;
355     mapping(uint256 => address) private _tokenApprovals;
356     mapping(address => mapping(address => bool)) private _operatorApprovals;
357     constructor(
358         string memory name_,
359         string memory symbol_,
360         uint256 maxBatchSize_,
361         uint256 collectionSize_
362     ) {
363         require(
364             collectionSize_ > 0,
365             "ERC721A: collection must have a nonzero supply"
366         );
367         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
368         _name = name_;
369         _symbol = symbol_;
370         maxBatchSize = maxBatchSize_;
371         collectionSize = collectionSize_;
372     }
373     function totalSupply() public view override returns (uint256) {
374         return currentIndex;
375     }
376     function tokenByIndex(uint256 index)
377         public
378         view
379         override
380         returns (uint256)
381     {
382         require(index < totalSupply(), "ERC721A: global index out of bounds");
383         return index;
384     }
385     function tokenOfOwnerByIndex(address owner, uint256 index)
386         public
387         view
388         override
389         returns (uint256)
390     {
391         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
392         uint256 numMintedSoFar = totalSupply();
393         uint256 tokenIdsIdx = 0;
394         address currOwnershipAddr = address(0);
395         for (uint256 i = 0; i < numMintedSoFar; i++) {
396             TokenOwnership memory ownership = _ownerships[i];
397             if (ownership.addr != address(0)) {
398                 currOwnershipAddr = ownership.addr;
399             }
400             if (currOwnershipAddr == owner) {
401                 if (tokenIdsIdx == index) {
402                     return i;
403                 }
404                 tokenIdsIdx++;
405             }
406         }
407         revert("ERC721A: unable to get token of owner by index");
408     }
409     function supportsInterface(bytes4 interfaceId)
410         public
411         view
412         virtual
413         override(ERC165, IERC165)
414         returns (bool)
415     {
416         return
417             interfaceId == type(IERC721).interfaceId ||
418             interfaceId == type(IERC721Metadata).interfaceId ||
419             interfaceId == type(IERC721Enumerable).interfaceId ||
420             super.supportsInterface(interfaceId);
421     }
422     function balanceOf(address owner) public view override returns (uint256) {
423         require(
424             owner != address(0),
425             "ERC721A: balance query for the zero address"
426         );
427         return uint256(_addressData[owner].balance);
428     }
429 
430     function _numberMinted(address owner) internal view returns (uint256) {
431         require(
432             owner != address(0),
433             "ERC721A: number minted query for the zero address"
434         );
435         return uint256(_addressData[owner].numberMinted);
436     }
437 
438     function ownershipOf(uint256 tokenId)
439         internal
440         view
441         returns (TokenOwnership memory)
442     {
443         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
444 
445         uint256 lowestTokenToCheck;
446         if (tokenId >= maxBatchSize) {
447             lowestTokenToCheck = tokenId - maxBatchSize + 1;
448         }
449 
450         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
451             TokenOwnership memory ownership = _ownerships[curr];
452             if (ownership.addr != address(0)) {
453                 return ownership;
454             }
455         }
456 
457         revert("ERC721A: unable to determine the owner of token");
458     }
459     function ownerOf(uint256 tokenId) public view override returns (address) {
460         return ownershipOf(tokenId).addr;
461     }
462     function name() public view virtual override returns (string memory) {
463         return _name;
464     }
465     function symbol() public view virtual override returns (string memory) {
466         return _symbol;
467     }
468     function tokenURI(uint256 tokenId)
469         public
470         view
471         virtual
472         override
473         returns (string memory)
474     {
475         require(
476             _exists(tokenId),
477             "ERC721Metadata: URI query for nonexistent token"
478         );
479 
480         string memory baseURI = _baseURI();
481         return
482             bytes(baseURI).length > 0
483                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
484                 : "";
485     }
486     function _baseURI() internal view virtual returns (string memory) {
487         return "";
488     }
489     function approve(address to, uint256 tokenId) public override {
490         address owner = ERC721A.ownerOf(tokenId);
491         require(to != owner, "ERC721A: approval to current owner");
492 
493         require(
494             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
495             "ERC721A: approve caller is not owner nor approved for all"
496         );
497 
498         _approve(to, tokenId, owner);
499     }
500     function getApproved(uint256 tokenId)
501         public
502         view
503         override
504         returns (address)
505     {
506         require(
507             _exists(tokenId),
508             "ERC721A: approved query for nonexistent token"
509         );
510 
511         return _tokenApprovals[tokenId];
512     }
513     function setApprovalForAll(address operator, bool approved)
514         public
515         override
516     {
517         require(operator != _msgSender(), "ERC721A: approve to caller");
518 
519         _operatorApprovals[_msgSender()][operator] = approved;
520         emit ApprovalForAll(_msgSender(), operator, approved);
521     }
522     function isApprovedForAll(address owner, address operator)
523         public
524         view
525         virtual
526         override
527         returns (bool)
528     {
529         return _operatorApprovals[owner][operator];
530     }
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) public override {
536         _transfer(from, to, tokenId);
537     }
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) public override {
543         safeTransferFrom(from, to, tokenId, "");
544     }
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId,
549         bytes memory _data
550     ) public override {
551         _transfer(from, to, tokenId);
552         require(
553             _checkOnERC721Received(from, to, tokenId, _data),
554             "ERC721A: transfer to non ERC721Receiver implementer"
555         );
556     }
557     function _exists(uint256 tokenId) internal view returns (bool) {
558         return tokenId < currentIndex;
559     }
560 
561     function _safeMint(address to, uint256 quantity) internal {
562         _safeMint(to, quantity, "");
563     }
564     function _safeMint(
565         address to,
566         uint256 quantity,
567         bytes memory _data
568     ) internal {
569         uint256 startTokenId = currentIndex;
570         require(to != address(0), "ERC721A: mint to the zero address");
571         require(!_exists(startTokenId), "ERC721A: token already minted");
572         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
573 
574         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
575 
576         AddressData memory addressData = _addressData[to];
577         _addressData[to] = AddressData(
578             addressData.balance + uint128(quantity),
579             addressData.numberMinted + uint128(quantity)
580         );
581         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
582 
583         uint256 updatedIndex = startTokenId;
584 
585         for (uint256 i = 0; i < quantity; i++) {
586             emit Transfer(address(0), to, updatedIndex);
587             require(
588                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
589                 "ERC721A: transfer to non ERC721Receiver implementer"
590             );
591             updatedIndex++;
592         }
593 
594         currentIndex = updatedIndex;
595         _afterTokenTransfers(address(0), to, startTokenId, quantity);
596     }
597     function _transfer(
598         address from,
599         address to,
600         uint256 tokenId
601     ) private {
602         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
603 
604         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
605             getApproved(tokenId) == _msgSender() ||
606             isApprovedForAll(prevOwnership.addr, _msgSender()));
607 
608         require(
609             isApprovedOrOwner,
610             "ERC721A: transfer caller is not owner nor approved"
611         );
612 
613         require(
614             prevOwnership.addr == from,
615             "ERC721A: transfer from incorrect owner"
616         );
617         require(to != address(0), "ERC721A: transfer to the zero address");
618 
619         _beforeTokenTransfers(from, to, tokenId, 1);
620         _approve(address(0), tokenId, prevOwnership.addr);
621 
622         _addressData[from].balance -= 1;
623         _addressData[to].balance += 1;
624         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
625         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
626         uint256 nextTokenId = tokenId + 1;
627         if (_ownerships[nextTokenId].addr == address(0)) {
628             if (_exists(nextTokenId)) {
629                 _ownerships[nextTokenId] = TokenOwnership(
630                     prevOwnership.addr,
631                     prevOwnership.startTimestamp
632                 );
633             }
634         }
635 
636         emit Transfer(from, to, tokenId);
637         _afterTokenTransfers(from, to, tokenId, 1);
638     }
639     function _approve(
640         address to,
641         uint256 tokenId,
642         address owner
643     ) private {
644         _tokenApprovals[tokenId] = to;
645         emit Approval(owner, to, tokenId);
646     }
647 
648     uint256 public nextOwnerToExplicitlySet = 0;
649     function _setOwnersExplicit(uint256 quantity) internal {
650         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
651         require(quantity > 0, "quantity must be nonzero");
652         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
653         if (endIndex > collectionSize - 1) {
654             endIndex = collectionSize - 1;
655         }
656         require(_exists(endIndex), "not enough minted yet for this cleanup");
657         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
658             if (_ownerships[i].addr == address(0)) {
659                 TokenOwnership memory ownership = ownershipOf(i);
660                 _ownerships[i] = TokenOwnership(
661                     ownership.addr,
662                     ownership.startTimestamp
663                 );
664             }
665         }
666         nextOwnerToExplicitlySet = endIndex + 1;
667     }
668     function _checkOnERC721Received(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes memory _data
673     ) private returns (bool) {
674         if (to.isContract()) {
675             try
676                 IERC721Receiver(to).onERC721Received(
677                     _msgSender(),
678                     from,
679                     tokenId,
680                     _data
681                 )
682             returns (bytes4 retval) {
683                 return retval == IERC721Receiver(to).onERC721Received.selector;
684             } catch (bytes memory reason) {
685                 if (reason.length == 0) {
686                     revert(
687                         "ERC721A: transfer to non ERC721Receiver implementer"
688                     );
689                 } else {
690                     assembly {
691                         revert(add(32, reason), mload(reason))
692                     }
693                 }
694             }
695         } else {
696             return true;
697         }
698     }
699     function _beforeTokenTransfers(
700         address from,
701         address to,
702         uint256 startTokenId,
703         uint256 quantity
704     ) internal virtual {}
705     function _afterTokenTransfers(
706         address from,
707         address to,
708         uint256 startTokenId,
709         uint256 quantity
710     ) internal virtual {}
711 }
712 pragma solidity ^0.8.0;
713 interface ITheAmericansNFT {
714     function balanceOf(address owner) external view returns (uint256);
715     function ownerOf(uint256 tokenId) external view returns (address);
716     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
717 }
718 pragma solidity ^0.8.0;
719 interface ITheAmericansStake {
720     function getStakedAmericans(address staker) external view returns (uint256[] memory);
721     function getStakedAmount(address staker) external view returns (uint256);
722     function getStaker(uint256 tokenId) external view returns (address);
723 }
724 
725 contract ThePresidents is Ownable, ERC721A, ReentrancyGuard {
726 
727     ITheAmericansNFT public immutable theamericanNFT;
728     ITheAmericansStake public immutable theamericanStake;
729 
730     bool public publicSale = false;
731     bool public nftSale = false;
732     bool public revealed = false;
733 
734     uint256 public maxPerAddress = 50;
735     uint256 public maxToken = 10000;
736     uint256 public price = 0.019 ether;
737 
738     string private _baseTokenURI = "";
739     string public notRevealedUri = "ipfs://QmXhLe5nuh4SpNwmKCwkM6dPpzuzQXpccqUpZ3yJN17KW7/";
740 
741     uint256[40] claimedBitMap;
742 
743     constructor(string memory _NAME, string memory _SYMBOL, address _theAmericansNFT, address _theAmericansStake) ERC721A (_NAME, _SYMBOL, 250, maxToken) {
744         theamericanNFT = ITheAmericansNFT(_theAmericansNFT);
745         theamericanStake = ITheAmericansStake(_theAmericansStake);
746     }
747 
748     modifier callerIsUser() {
749         require(tx.origin == msg.sender, "The caller is another contract");
750         _;
751     }
752 
753     function isClaimed(uint256 tokenId) public view returns (bool) {
754         uint256 claimedWordIndex = tokenId / 256;
755         uint256 claimedBitIndex = tokenId % 256;
756         uint256 claimedWord = claimedBitMap[claimedWordIndex];
757         uint256 mask = (1 << claimedBitIndex);
758         return claimedWord & mask == mask;
759     }
760 
761     function _setClaimed(uint256 tokenId) internal {
762         uint256 claimedWordIndex = tokenId / 256;
763         uint256 claimedBitIndex = tokenId % 256;
764         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
765     }
766 
767     function numberMinted(address owner) public view returns (uint256) {
768         return _numberMinted(owner);
769     }
770 
771     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
772         return ownershipOf(tokenId);
773     }
774 
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
777         if (revealed == false) {
778             return notRevealedUri;
779         }
780         string memory _tokenURI = super.tokenURI(tokenId);
781         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
782     }
783 
784     function mint(uint256 quantity, uint256[] memory tokenIds) external payable callerIsUser {
785         require(publicSale || nftSale, "SALE_HAS_NOT_STARTED_YET");
786         if(nftSale){
787             uint256 tokensToMint;
788             for(uint256 i; i < tokenIds.length; ++i){
789                 if(theamericanNFT.ownerOf(tokenIds[i]) == msg.sender){
790                     if (!isClaimed(tokenIds[i])) {
791                         _setClaimed(tokenIds[i]);
792                         tokensToMint++;
793                     }
794                 } else if(theamericanStake.getStaker(tokenIds[i]) == msg.sender){
795                     if (!isClaimed(tokenIds[i])) {
796                         _setClaimed(tokenIds[i]);
797                         tokensToMint++;
798                     }
799                 }
800             }
801             require(tokensToMint > 0, "NOTHING_TO_USE");
802             quantity = tokensToMint;
803         } else if(publicSale){
804             require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
805         }
806         require(quantity > 0, "INVALID_QUANTITY");
807         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
808         require(msg.value >= price * quantity, "INVALID_ETH");
809         _safeMint(msg.sender, quantity);
810     }
811 
812     function teamAllocationMint(address _address, uint256 quantity) external onlyOwner {
813         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
814         _safeMint(_address, quantity);
815     }
816 
817     function _baseURI() internal view virtual override returns (string memory) {
818         return _baseTokenURI;
819     }
820 
821     function setPrice(uint256 _PriceInWEI) external onlyOwner {
822         price = _PriceInWEI;
823     }
824 
825     function flipPublicSale() external onlyOwner {
826         publicSale = !publicSale;
827     }
828 
829     function flipNFTSale() external onlyOwner {
830         nftSale = !nftSale;
831     }
832 
833     function setBaseURI(string calldata baseURI) external onlyOwner {
834         _baseTokenURI = baseURI;
835     }
836 
837     function setMaxPerAddress(uint256 _maxPerAddress) external onlyOwner {
838         maxPerAddress = _maxPerAddress;
839     }
840 
841     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
842         notRevealedUri = _notRevealedURI;
843     }
844 
845     function reveal() external onlyOwner {
846         revealed = !revealed;
847     }
848 
849     function withdraw() external onlyOwner {
850         payable(msg.sender).transfer(address(this).balance);
851     }
852 }