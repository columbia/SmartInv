1 // SPDX-License-Identifier: MIT
2 /**
3  * @title moonfrens.io
4  * @author AhmYieMoonFren
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 pragma solidity ^0.8.0;
8 pragma solidity ^0.8.0;
9 interface IERC165 {
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 pragma solidity ^0.8.0;
13 interface IERC721Receiver {
14     function onERC721Received(
15         address operator,
16         address from,
17         uint256 tokenId,
18         bytes calldata data
19     ) external returns (bytes4);
20 }
21 pragma solidity ^0.8.0;
22 interface IERC721 is IERC165 {
23     event Transfer(
24         address indexed from,
25         address indexed to,
26         uint256 indexed tokenId
27     );
28     event Approval(
29         address indexed owner,
30         address indexed approved,
31         uint256 indexed tokenId
32     );
33     event ApprovalForAll(
34         address indexed owner,
35         address indexed operator,
36         bool approved
37     );
38     function balanceOf(address owner) external view returns (uint256 balance);
39     function ownerOf(uint256 tokenId) external view returns (address owner);
40     function safeTransferFrom(
41         address from,
42         address to,
43         uint256 tokenId
44     ) external;
45     function transferFrom(
46         address from,
47         address to,
48         uint256 tokenId
49     ) external;
50     function approve(address to, uint256 tokenId) external;
51     function getApproved(uint256 tokenId)
52         external
53         view
54         returns (address operator);
55     function setApprovalForAll(address operator, bool _approved) external;
56     function isApprovedForAll(address owner, address operator)
57         external
58         view
59         returns (bool);
60     function safeTransferFrom(
61         address from,
62         address to,
63         uint256 tokenId,
64         bytes calldata data
65     ) external;
66 }
67 pragma solidity ^0.8.0;
68 interface IERC721Metadata is IERC721 {
69     function name() external view returns (string memory);
70     function symbol() external view returns (string memory);
71     function tokenURI(uint256 tokenId) external view returns (string memory);
72 }
73 pragma solidity ^0.8.0;
74 interface IERC721Enumerable is IERC721 {
75     function totalSupply() external view returns (uint256);
76     function tokenOfOwnerByIndex(address owner, uint256 index)
77         external
78         view
79         returns (uint256);
80     function tokenByIndex(uint256 index) external view returns (uint256);
81 }
82 pragma solidity ^0.8.1;
83 library Address {
84     function isContract(address account) internal view returns (bool) {
85 
86         return account.code.length > 0;
87     }
88     function sendValue(address payable recipient, uint256 amount) internal {
89         require(
90             address(this).balance >= amount,
91             "Address: insufficient balance"
92         );
93 
94         (bool success, ) = recipient.call{value: amount}("");
95         require(
96             success,
97             "Address: unable to send value, recipient may have reverted"
98         );
99     }
100     function functionCall(address target, bytes memory data)
101         internal
102         returns (bytes memory)
103     {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106     function functionCall(
107         address target,
108         bytes memory data,
109         string memory errorMessage
110     ) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, errorMessage);
112     }
113     function functionCallWithValue(
114         address target,
115         bytes memory data,
116         uint256 value
117     ) internal returns (bytes memory) {
118         return
119             functionCallWithValue(
120                 target,
121                 data,
122                 value,
123                 "Address: low-level call with value failed"
124             );
125     }
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(
133             address(this).balance >= value,
134             "Address: insufficient balance for call"
135         );
136         require(isContract(target), "Address: call to non-contract");
137 
138         (bool success, bytes memory returndata) = target.call{value: value}(
139             data
140         );
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143     function functionStaticCall(address target, bytes memory data)
144         internal
145         view
146         returns (bytes memory)
147     {
148         return
149             functionStaticCall(
150                 target,
151                 data,
152                 "Address: low-level static call failed"
153             );
154     }
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165     function functionDelegateCall(address target, bytes memory data)
166         internal
167         returns (bytes memory)
168     {
169         return
170             functionDelegateCall(
171                 target,
172                 data,
173                 "Address: low-level delegate call failed"
174             );
175     }
176     function functionDelegateCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal returns (bytes memory) {
181         require(isContract(target), "Address: delegate call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.delegatecall(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186     function verifyCallResult(
187         bool success,
188         bytes memory returndata,
189         string memory errorMessage
190     ) internal pure returns (bytes memory) {
191         if (success) {
192             return returndata;
193         } else {
194             if (returndata.length > 0) {
195 
196                 assembly {
197                     let returndata_size := mload(returndata)
198                     revert(add(32, returndata), returndata_size)
199                 }
200             } else {
201                 revert(errorMessage);
202             }
203         }
204     }
205 }
206 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
207 pragma solidity ^0.8.0;
208 abstract contract Context {
209     function _msgSender() internal view virtual returns (address) {
210         return msg.sender;
211     }
212 
213     function _msgData() internal view virtual returns (bytes calldata) {
214         return msg.data;
215     }
216 }
217 
218 pragma solidity ^0.8.0;
219 
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(
224         address indexed previousOwner,
225         address indexed newOwner
226     );
227     constructor() {
228         _setOwner(_msgSender());
229     }
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233     modifier onlyOwner() {
234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
235         _;
236     }
237     function renounceOwnership() public virtual onlyOwner {
238         _setOwner(address(0));
239     }
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(
242             newOwner != address(0),
243             "Ownable: new owner is the zero address"
244         );
245         _setOwner(newOwner);
246     }
247 
248     function _setOwner(address newOwner) private {
249         address oldOwner = _owner;
250         _owner = newOwner;
251         emit OwnershipTransferred(oldOwner, newOwner);
252     }
253 }
254 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
255 pragma solidity ^0.8.0;
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258     function toString(uint256 value) internal pure returns (string memory) {
259         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
260 
261         if (value == 0) {
262             return "0";
263         }
264         uint256 temp = value;
265         uint256 digits;
266         while (temp != 0) {
267             digits++;
268             temp /= 10;
269         }
270         bytes memory buffer = new bytes(digits);
271         while (value != 0) {
272             digits -= 1;
273             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
274             value /= 10;
275         }
276         return string(buffer);
277     }
278     function toHexString(uint256 value) internal pure returns (string memory) {
279         if (value == 0) {
280             return "0x00";
281         }
282         uint256 temp = value;
283         uint256 length = 0;
284         while (temp != 0) {
285             length++;
286             temp >>= 8;
287         }
288         return toHexString(value, length);
289     }
290     function toHexString(uint256 value, uint256 length)
291         internal
292         pure
293         returns (string memory)
294     {
295         bytes memory buffer = new bytes(2 * length + 2);
296         buffer[0] = "0";
297         buffer[1] = "x";
298         for (uint256 i = 2 * length + 1; i > 1; --i) {
299             buffer[i] = _HEX_SYMBOLS[value & 0xf];
300             value >>= 4;
301         }
302         require(value == 0, "Strings: hex length insufficient");
303         return string(buffer);
304     }
305 }
306 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
307 pragma solidity ^0.8.0;
308 abstract contract ERC165 is IERC165 {
309     function supportsInterface(bytes4 interfaceId)
310         public
311         view
312         virtual
313         override
314         returns (bool)
315     {
316         return interfaceId == type(IERC165).interfaceId;
317     }
318 }
319 
320 pragma solidity ^0.8.0;
321 
322 abstract contract ReentrancyGuard {
323     // word because each write operation emits an extra SLOAD to first read the
324     // back. This is the compiler's defense against contract upgrades and
325 
326     // but in exchange the refund on every call to nonReentrant will be lower in
327     // transaction's gas, it is best to keep them low in cases like this one, to
328     uint256 private constant _NOT_ENTERED = 1;
329     uint256 private constant _ENTERED = 2;
330 
331     uint256 private _status;
332 
333     constructor() {
334         _status = _NOT_ENTERED;
335     }
336     modifier nonReentrant() {
337         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
338         _status = _ENTERED;
339 
340         _;
341         // https://eips.ethereum.org/EIPS/eip-2200)
342         _status = _NOT_ENTERED;
343     }
344 }
345 
346 pragma solidity ^0.8.0;
347 contract ERC721A is
348     Context,
349     ERC165,
350     IERC721,
351     IERC721Metadata,
352     IERC721Enumerable
353 {
354     using Address for address;
355     using Strings for uint256;
356 
357     struct TokenOwnership {
358         address addr;
359         uint64 startTimestamp;
360     }
361 
362     struct AddressData {
363         uint128 balance;
364         uint128 numberMinted;
365     }
366 
367     uint256 private currentIndex = 0;
368 
369     uint256 internal immutable collectionSize;
370     uint256 internal immutable maxBatchSize;
371     string private _name;
372     string private _symbol;
373     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
374     mapping(uint256 => TokenOwnership) private _ownerships;
375     mapping(address => AddressData) private _addressData;
376     mapping(uint256 => address) private _tokenApprovals;
377     mapping(address => mapping(address => bool)) private _operatorApprovals;
378     constructor(
379         string memory name_,
380         string memory symbol_,
381         uint256 maxBatchSize_,
382         uint256 collectionSize_
383     ) {
384         require(
385             collectionSize_ > 0,
386             "ERC721A: collection must have a nonzero supply"
387         );
388         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
389         _name = name_;
390         _symbol = symbol_;
391         maxBatchSize = maxBatchSize_;
392         collectionSize = collectionSize_;
393     }
394     function totalSupply() public view override returns (uint256) {
395         return currentIndex;
396     }
397     function tokenByIndex(uint256 index)
398         public
399         view
400         override
401         returns (uint256)
402     {
403         require(index < totalSupply(), "ERC721A: global index out of bounds");
404         return index;
405     }
406     function tokenOfOwnerByIndex(address owner, uint256 index)
407         public
408         view
409         override
410         returns (uint256)
411     {
412         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
413         uint256 numMintedSoFar = totalSupply();
414         uint256 tokenIdsIdx = 0;
415         address currOwnershipAddr = address(0);
416         for (uint256 i = 0; i < numMintedSoFar; i++) {
417             TokenOwnership memory ownership = _ownerships[i];
418             if (ownership.addr != address(0)) {
419                 currOwnershipAddr = ownership.addr;
420             }
421             if (currOwnershipAddr == owner) {
422                 if (tokenIdsIdx == index) {
423                     return i;
424                 }
425                 tokenIdsIdx++;
426             }
427         }
428         revert("ERC721A: unable to get token of owner by index");
429     }
430     function supportsInterface(bytes4 interfaceId)
431         public
432         view
433         virtual
434         override(ERC165, IERC165)
435         returns (bool)
436     {
437         return
438             interfaceId == type(IERC721).interfaceId ||
439             interfaceId == type(IERC721Metadata).interfaceId ||
440             interfaceId == type(IERC721Enumerable).interfaceId ||
441             super.supportsInterface(interfaceId);
442     }
443     function balanceOf(address owner) public view override returns (uint256) {
444         require(
445             owner != address(0),
446             "ERC721A: balance query for the zero address"
447         );
448         return uint256(_addressData[owner].balance);
449     }
450 
451     function _numberMinted(address owner) internal view returns (uint256) {
452         require(
453             owner != address(0),
454             "ERC721A: number minted query for the zero address"
455         );
456         return uint256(_addressData[owner].numberMinted);
457     }
458 
459     function ownershipOf(uint256 tokenId)
460         internal
461         view
462         returns (TokenOwnership memory)
463     {
464         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
465 
466         uint256 lowestTokenToCheck;
467         if (tokenId >= maxBatchSize) {
468             lowestTokenToCheck = tokenId - maxBatchSize + 1;
469         }
470 
471         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
472             TokenOwnership memory ownership = _ownerships[curr];
473             if (ownership.addr != address(0)) {
474                 return ownership;
475             }
476         }
477 
478         revert("ERC721A: unable to determine the owner of token");
479     }
480     function ownerOf(uint256 tokenId) public view override returns (address) {
481         return ownershipOf(tokenId).addr;
482     }
483     function name() public view virtual override returns (string memory) {
484         return _name;
485     }
486     function symbol() public view virtual override returns (string memory) {
487         return _symbol;
488     }
489     function tokenURI(uint256 tokenId)
490         public
491         view
492         virtual
493         override
494         returns (string memory)
495     {
496         require(
497             _exists(tokenId),
498             "ERC721Metadata: URI query for nonexistent token"
499         );
500 
501         string memory baseURI = _baseURI();
502         return
503             bytes(baseURI).length > 0
504                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
505                 : "";
506     }
507     function _baseURI() internal view virtual returns (string memory) {
508         return "";
509     }
510     function approve(address to, uint256 tokenId) public override {
511         address owner = ERC721A.ownerOf(tokenId);
512         require(to != owner, "ERC721A: approval to current owner");
513 
514         require(
515             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
516             "ERC721A: approve caller is not owner nor approved for all"
517         );
518 
519         _approve(to, tokenId, owner);
520     }
521     function getApproved(uint256 tokenId)
522         public
523         view
524         override
525         returns (address)
526     {
527         require(
528             _exists(tokenId),
529             "ERC721A: approved query for nonexistent token"
530         );
531 
532         return _tokenApprovals[tokenId];
533     }
534     function setApprovalForAll(address operator, bool approved)
535         public
536         override
537     {
538         require(operator != _msgSender(), "ERC721A: approve to caller");
539 
540         _operatorApprovals[_msgSender()][operator] = approved;
541         emit ApprovalForAll(_msgSender(), operator, approved);
542     }
543     function isApprovedForAll(address owner, address operator)
544         public
545         view
546         virtual
547         override
548         returns (bool)
549     {
550         return _operatorApprovals[owner][operator];
551     }
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) public override {
557         _transfer(from, to, tokenId);
558     }
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) public override {
564         safeTransferFrom(from, to, tokenId, "");
565     }
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes memory _data
571     ) public override {
572         _transfer(from, to, tokenId);
573         require(
574             _checkOnERC721Received(from, to, tokenId, _data),
575             "ERC721A: transfer to non ERC721Receiver implementer"
576         );
577     }
578     function _exists(uint256 tokenId) internal view returns (bool) {
579         return tokenId < currentIndex;
580     }
581 
582     function _safeMint(address to, uint256 quantity) internal {
583         _safeMint(to, quantity, "");
584     }
585     function _safeMint(
586         address to,
587         uint256 quantity,
588         bytes memory _data
589     ) internal {
590         uint256 startTokenId = currentIndex;
591         require(to != address(0), "ERC721A: mint to the zero address");
592         require(!_exists(startTokenId), "ERC721A: token already minted");
593         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
594 
595         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
596 
597         AddressData memory addressData = _addressData[to];
598         _addressData[to] = AddressData(
599             addressData.balance + uint128(quantity),
600             addressData.numberMinted + uint128(quantity)
601         );
602         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
603 
604         uint256 updatedIndex = startTokenId;
605 
606         for (uint256 i = 0; i < quantity; i++) {
607             emit Transfer(address(0), to, updatedIndex);
608             require(
609                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
610                 "ERC721A: transfer to non ERC721Receiver implementer"
611             );
612             updatedIndex++;
613         }
614 
615         currentIndex = updatedIndex;
616         _afterTokenTransfers(address(0), to, startTokenId, quantity);
617     }
618     function _transfer(
619         address from,
620         address to,
621         uint256 tokenId
622     ) private {
623         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
624 
625         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
626             getApproved(tokenId) == _msgSender() ||
627             isApprovedForAll(prevOwnership.addr, _msgSender()));
628 
629         require(
630             isApprovedOrOwner,
631             "ERC721A: transfer caller is not owner nor approved"
632         );
633 
634         require(
635             prevOwnership.addr == from,
636             "ERC721A: transfer from incorrect owner"
637         );
638         require(to != address(0), "ERC721A: transfer to the zero address");
639 
640         _beforeTokenTransfers(from, to, tokenId, 1);
641         _approve(address(0), tokenId, prevOwnership.addr);
642 
643         _addressData[from].balance -= 1;
644         _addressData[to].balance += 1;
645         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
646         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
647         uint256 nextTokenId = tokenId + 1;
648         if (_ownerships[nextTokenId].addr == address(0)) {
649             if (_exists(nextTokenId)) {
650                 _ownerships[nextTokenId] = TokenOwnership(
651                     prevOwnership.addr,
652                     prevOwnership.startTimestamp
653                 );
654             }
655         }
656 
657         emit Transfer(from, to, tokenId);
658         _afterTokenTransfers(from, to, tokenId, 1);
659     }
660     function _approve(
661         address to,
662         uint256 tokenId,
663         address owner
664     ) private {
665         _tokenApprovals[tokenId] = to;
666         emit Approval(owner, to, tokenId);
667     }
668 
669     uint256 public nextOwnerToExplicitlySet = 0;
670     function _setOwnersExplicit(uint256 quantity) internal {
671         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
672         require(quantity > 0, "quantity must be nonzero");
673         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
674         if (endIndex > collectionSize - 1) {
675             endIndex = collectionSize - 1;
676         }
677         require(_exists(endIndex), "not enough minted yet for this cleanup");
678         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
679             if (_ownerships[i].addr == address(0)) {
680                 TokenOwnership memory ownership = ownershipOf(i);
681                 _ownerships[i] = TokenOwnership(
682                     ownership.addr,
683                     ownership.startTimestamp
684                 );
685             }
686         }
687         nextOwnerToExplicitlySet = endIndex + 1;
688     }
689     function _checkOnERC721Received(
690         address from,
691         address to,
692         uint256 tokenId,
693         bytes memory _data
694     ) private returns (bool) {
695         if (to.isContract()) {
696             try
697                 IERC721Receiver(to).onERC721Received(
698                     _msgSender(),
699                     from,
700                     tokenId,
701                     _data
702                 )
703             returns (bytes4 retval) {
704                 return retval == IERC721Receiver(to).onERC721Received.selector;
705             } catch (bytes memory reason) {
706                 if (reason.length == 0) {
707                     revert(
708                         "ERC721A: transfer to non ERC721Receiver implementer"
709                     );
710                 } else {
711                     assembly {
712                         revert(add(32, reason), mload(reason))
713                     }
714                 }
715             }
716         } else {
717             return true;
718         }
719     }
720     function _beforeTokenTransfers(
721         address from,
722         address to,
723         uint256 startTokenId,
724         uint256 quantity
725     ) internal virtual {}
726     function _afterTokenTransfers(
727         address from,
728         address to,
729         uint256 startTokenId,
730         uint256 quantity
731     ) internal virtual {}
732 }
733 
734 contract moonfrens is Ownable, ERC721A, ReentrancyGuard {
735 
736     bool public publicSale = false;
737     bool public revealed = false;
738 
739     uint256 public maxPerTx = 10;
740     uint256 public maxPerAddress = 100;
741     uint256 public maxToken = 5555;
742     uint256 public price = 0.02 ether;
743 
744     string private _baseTokenURI;
745     string public notRevealedUri = "ipfs://QmRxjkiMnzhDSC157y417h21Jf6hMRF3hyo95PLStbVJPh/";
746 
747     constructor(string memory _NAME, string memory _SYMBOL)
748         ERC721A(_NAME, _SYMBOL, maxPerAddress, maxToken)
749     {}
750 
751     modifier callerIsUser() {
752         require(tx.origin == msg.sender, "The caller is another contract");
753         _;
754     }
755 
756     function numberMinted(address owner) public view returns (uint256) {
757         return _numberMinted(owner);
758     }
759 
760     function getOwnershipData(uint256 tokenId)
761         external
762         view
763         returns (TokenOwnership memory)
764     {
765         return ownershipOf(tokenId);
766     }
767 
768     function tokenURI(uint256 tokenId)
769         public
770         view
771         virtual
772         override
773         returns (string memory)
774     {
775         require(
776             _exists(tokenId),
777             "ERC721Metadata: URI query for nonexistent token"
778         );
779 
780         if (revealed == false) {
781             return notRevealedUri;
782         }
783 
784         string memory _tokenURI = super.tokenURI(tokenId);
785         return
786             bytes(_tokenURI).length > 0
787                 ? string(abi.encodePacked(_tokenURI, ".json"))
788                 : "";
789     }
790 
791     function mint(uint256 quantity) external payable callerIsUser {
792         require(publicSale, "SALE_HAS_NOT_STARTED_YET");
793         require(quantity > 0, "INVALID_QUANTITY");
794         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
795         require(quantity <= maxPerTx, "CANNOT_MINT_THAT_MANY");
796         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
797         if(numberMinted(msg.sender) >= 2){
798             require(msg.value >= price * quantity, "INVALID_ETH");
799         }else if(numberMinted(msg.sender) + quantity < 3){
800              require(msg.value == 0, "INVALID_ETH");
801         }else{
802             require(msg.value == price * ( quantity - 2), "INVALID_ETH");
803         }
804         _safeMint(msg.sender, quantity);
805     }
806 
807     function ownerMint(address _address, uint256 quantity) external onlyOwner {
808         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
809         _safeMint(_address, quantity);
810     }
811 
812     function _baseURI() internal view virtual override returns (string memory) {
813         return _baseTokenURI;
814     }
815 
816     function setPrice(uint256 _PriceInWEI) external onlyOwner {
817         price = _PriceInWEI;
818     }
819 
820     function flipPublicSaleState() external onlyOwner {
821         publicSale = !publicSale;
822     }
823 
824     function setBaseURI(string calldata baseURI) external onlyOwner {
825         _baseTokenURI = baseURI;
826     }
827 
828     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
829         notRevealedUri = _notRevealedURI;
830     }
831 
832     function reveal() external onlyOwner {
833         revealed = !revealed;
834     }
835 
836     function withdraw() external onlyOwner {
837         payable(msg.sender).transfer(address(this).balance);
838     }
839 }