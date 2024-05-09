1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 pragma solidity ^0.8.0;
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 pragma solidity ^0.8.0;
9 interface IERC721Receiver {
10     function onERC721Received(
11         address operator,
12         address from,
13         uint256 tokenId,
14         bytes calldata data
15     ) external returns (bytes4);
16 }
17 pragma solidity ^0.8.0;
18 interface IERC721 is IERC165 {
19     event Transfer(
20         address indexed from,
21         address indexed to,
22         uint256 indexed tokenId
23     );
24     event Approval(
25         address indexed owner,
26         address indexed approved,
27         uint256 indexed tokenId
28     );
29     event ApprovalForAll(
30         address indexed owner,
31         address indexed operator,
32         bool approved
33     );
34     function balanceOf(address owner) external view returns (uint256 balance);
35     function ownerOf(uint256 tokenId) external view returns (address owner);
36     function safeTransferFrom(
37         address from,
38         address to,
39         uint256 tokenId
40     ) external;
41     function transferFrom(
42         address from,
43         address to,
44         uint256 tokenId
45     ) external;
46     function approve(address to, uint256 tokenId) external;
47     function getApproved(uint256 tokenId)
48         external
49         view
50         returns (address operator);
51     function setApprovalForAll(address operator, bool _approved) external;
52     function isApprovedForAll(address owner, address operator)
53         external
54         view
55         returns (bool);
56     function safeTransferFrom(
57         address from,
58         address to,
59         uint256 tokenId,
60         bytes calldata data
61     ) external;
62 }
63 pragma solidity ^0.8.0;
64 interface IERC721Metadata is IERC721 {
65     function name() external view returns (string memory);
66     function symbol() external view returns (string memory);
67     function tokenURI(uint256 tokenId) external view returns (string memory);
68 }
69 pragma solidity ^0.8.0;
70 interface IERC721Enumerable is IERC721 {
71     function totalSupply() external view returns (uint256);
72     function tokenOfOwnerByIndex(address owner, uint256 index)
73         external
74         view
75         returns (uint256);
76     function tokenByIndex(uint256 index) external view returns (uint256);
77 }
78 pragma solidity ^0.8.1;
79 library Address {
80     function isContract(address account) internal view returns (bool) {
81 
82         return account.code.length > 0;
83     }
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(
86             address(this).balance >= amount,
87             "Address: insufficient balance"
88         );
89 
90         (bool success, ) = recipient.call{value: amount}("");
91         require(
92             success,
93             "Address: unable to send value, recipient may have reverted"
94         );
95     }
96     function functionCall(address target, bytes memory data)
97         internal
98         returns (bytes memory)
99     {
100         return functionCall(target, data, "Address: low-level call failed");
101     }
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return
115             functionCallWithValue(
116                 target,
117                 data,
118                 value,
119                 "Address: low-level call with value failed"
120             );
121     }
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         require(
129             address(this).balance >= value,
130             "Address: insufficient balance for call"
131         );
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(
135             data
136         );
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139     function functionStaticCall(address target, bytes memory data)
140         internal
141         view
142         returns (bytes memory)
143     {
144         return
145             functionStaticCall(
146                 target,
147                 data,
148                 "Address: low-level static call failed"
149             );
150     }
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161     function functionDelegateCall(address target, bytes memory data)
162         internal
163         returns (bytes memory)
164     {
165         return
166             functionDelegateCall(
167                 target,
168                 data,
169                 "Address: low-level delegate call failed"
170             );
171     }
172     function functionDelegateCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         require(isContract(target), "Address: delegate call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.delegatecall(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182     function verifyCallResult(
183         bool success,
184         bytes memory returndata,
185         string memory errorMessage
186     ) internal pure returns (bytes memory) {
187         if (success) {
188             return returndata;
189         } else {
190             if (returndata.length > 0) {
191 
192                 assembly {
193                     let returndata_size := mload(returndata)
194                     revert(add(32, returndata), returndata_size)
195                 }
196             } else {
197                 revert(errorMessage);
198             }
199         }
200     }
201 }
202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
203 pragma solidity ^0.8.0;
204 abstract contract Context {
205     function _msgSender() internal view virtual returns (address) {
206         return msg.sender;
207     }
208 
209     function _msgData() internal view virtual returns (bytes calldata) {
210         return msg.data;
211     }
212 }
213 
214 pragma solidity ^0.8.0;
215 
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
250 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
251 pragma solidity ^0.8.0;
252 library Strings {
253     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
254     function toString(uint256 value) internal pure returns (string memory) {
255         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
256 
257         if (value == 0) {
258             return "0";
259         }
260         uint256 temp = value;
261         uint256 digits;
262         while (temp != 0) {
263             digits++;
264             temp /= 10;
265         }
266         bytes memory buffer = new bytes(digits);
267         while (value != 0) {
268             digits -= 1;
269             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
270             value /= 10;
271         }
272         return string(buffer);
273     }
274     function toHexString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0x00";
277         }
278         uint256 temp = value;
279         uint256 length = 0;
280         while (temp != 0) {
281             length++;
282             temp >>= 8;
283         }
284         return toHexString(value, length);
285     }
286     function toHexString(uint256 value, uint256 length)
287         internal
288         pure
289         returns (string memory)
290     {
291         bytes memory buffer = new bytes(2 * length + 2);
292         buffer[0] = "0";
293         buffer[1] = "x";
294         for (uint256 i = 2 * length + 1; i > 1; --i) {
295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
296             value >>= 4;
297         }
298         require(value == 0, "Strings: hex length insufficient");
299         return string(buffer);
300     }
301 }
302 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
303 pragma solidity ^0.8.0;
304 abstract contract ERC165 is IERC165 {
305     function supportsInterface(bytes4 interfaceId)
306         public
307         view
308         virtual
309         override
310         returns (bool)
311     {
312         return interfaceId == type(IERC165).interfaceId;
313     }
314 }
315 
316 pragma solidity ^0.8.0;
317 
318 abstract contract ReentrancyGuard {
319     // word because each write operation emits an extra SLOAD to first read the
320     // back. This is the compiler's defense against contract upgrades and
321 
322     // but in exchange the refund on every call to nonReentrant will be lower in
323     // transaction's gas, it is best to keep them low in cases like this one, to
324     uint256 private constant _NOT_ENTERED = 1;
325     uint256 private constant _ENTERED = 2;
326 
327     uint256 private _status;
328 
329     constructor() {
330         _status = _NOT_ENTERED;
331     }
332     modifier nonReentrant() {
333         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
334         _status = _ENTERED;
335 
336         _;
337         // https://eips.ethereum.org/EIPS/eip-2200)
338         _status = _NOT_ENTERED;
339     }
340 }
341 
342 pragma solidity ^0.8.0;
343 contract ERC721A is
344     Context,
345     ERC165,
346     IERC721,
347     IERC721Metadata,
348     IERC721Enumerable
349 {
350     using Address for address;
351     using Strings for uint256;
352 
353     struct TokenOwnership {
354         address addr;
355         uint64 startTimestamp;
356     }
357 
358     struct AddressData {
359         uint128 balance;
360         uint128 numberMinted;
361     }
362 
363     uint256 private currentIndex = 0;
364 
365     uint256 internal immutable collectionSize;
366     uint256 internal immutable maxBatchSize;
367     string private _name;
368     string private _symbol;
369     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
370     mapping(uint256 => TokenOwnership) private _ownerships;
371     mapping(address => AddressData) private _addressData;
372     mapping(uint256 => address) private _tokenApprovals;
373     mapping(address => mapping(address => bool)) private _operatorApprovals;
374     constructor(
375         string memory name_,
376         string memory symbol_,
377         uint256 maxBatchSize_,
378         uint256 collectionSize_
379     ) {
380         require(
381             collectionSize_ > 0,
382             "ERC721A: collection must have a nonzero supply"
383         );
384         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
385         _name = name_;
386         _symbol = symbol_;
387         maxBatchSize = maxBatchSize_;
388         collectionSize = collectionSize_;
389     }
390     function totalSupply() public view override returns (uint256) {
391         return currentIndex;
392     }
393     function tokenByIndex(uint256 index)
394         public
395         view
396         override
397         returns (uint256)
398     {
399         require(index < totalSupply(), "ERC721A: global index out of bounds");
400         return index;
401     }
402     function tokenOfOwnerByIndex(address owner, uint256 index)
403         public
404         view
405         override
406         returns (uint256)
407     {
408         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
409         uint256 numMintedSoFar = totalSupply();
410         uint256 tokenIdsIdx = 0;
411         address currOwnershipAddr = address(0);
412         for (uint256 i = 0; i < numMintedSoFar; i++) {
413             TokenOwnership memory ownership = _ownerships[i];
414             if (ownership.addr != address(0)) {
415                 currOwnershipAddr = ownership.addr;
416             }
417             if (currOwnershipAddr == owner) {
418                 if (tokenIdsIdx == index) {
419                     return i;
420                 }
421                 tokenIdsIdx++;
422             }
423         }
424         revert("ERC721A: unable to get token of owner by index");
425     }
426     function supportsInterface(bytes4 interfaceId)
427         public
428         view
429         virtual
430         override(ERC165, IERC165)
431         returns (bool)
432     {
433         return
434             interfaceId == type(IERC721).interfaceId ||
435             interfaceId == type(IERC721Metadata).interfaceId ||
436             interfaceId == type(IERC721Enumerable).interfaceId ||
437             super.supportsInterface(interfaceId);
438     }
439     function balanceOf(address owner) public view override returns (uint256) {
440         require(
441             owner != address(0),
442             "ERC721A: balance query for the zero address"
443         );
444         return uint256(_addressData[owner].balance);
445     }
446 
447     function _numberMinted(address owner) internal view returns (uint256) {
448         require(
449             owner != address(0),
450             "ERC721A: number minted query for the zero address"
451         );
452         return uint256(_addressData[owner].numberMinted);
453     }
454 
455     function ownershipOf(uint256 tokenId)
456         internal
457         view
458         returns (TokenOwnership memory)
459     {
460         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
461 
462         uint256 lowestTokenToCheck;
463         if (tokenId >= maxBatchSize) {
464             lowestTokenToCheck = tokenId - maxBatchSize + 1;
465         }
466 
467         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
468             TokenOwnership memory ownership = _ownerships[curr];
469             if (ownership.addr != address(0)) {
470                 return ownership;
471             }
472         }
473 
474         revert("ERC721A: unable to determine the owner of token");
475     }
476     function ownerOf(uint256 tokenId) public view override returns (address) {
477         return ownershipOf(tokenId).addr;
478     }
479     function name() public view virtual override returns (string memory) {
480         return _name;
481     }
482     function symbol() public view virtual override returns (string memory) {
483         return _symbol;
484     }
485     function tokenURI(uint256 tokenId)
486         public
487         view
488         virtual
489         override
490         returns (string memory)
491     {
492         require(
493             _exists(tokenId),
494             "ERC721Metadata: URI query for nonexistent token"
495         );
496 
497         string memory baseURI = _baseURI();
498         return
499             bytes(baseURI).length > 0
500                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
501                 : "";
502     }
503     function _baseURI() internal view virtual returns (string memory) {
504         return "";
505     }
506     function approve(address to, uint256 tokenId) public override {
507         address owner = ERC721A.ownerOf(tokenId);
508         require(to != owner, "ERC721A: approval to current owner");
509 
510         require(
511             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
512             "ERC721A: approve caller is not owner nor approved for all"
513         );
514 
515         _approve(to, tokenId, owner);
516     }
517     function getApproved(uint256 tokenId)
518         public
519         view
520         override
521         returns (address)
522     {
523         require(
524             _exists(tokenId),
525             "ERC721A: approved query for nonexistent token"
526         );
527 
528         return _tokenApprovals[tokenId];
529     }
530     function setApprovalForAll(address operator, bool approved)
531         public
532         override
533     {
534         require(operator != _msgSender(), "ERC721A: approve to caller");
535 
536         _operatorApprovals[_msgSender()][operator] = approved;
537         emit ApprovalForAll(_msgSender(), operator, approved);
538     }
539     function isApprovedForAll(address owner, address operator)
540         public
541         view
542         virtual
543         override
544         returns (bool)
545     {
546         return _operatorApprovals[owner][operator];
547     }
548     function transferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) public override {
553         _transfer(from, to, tokenId);
554     }
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId
559     ) public override {
560         safeTransferFrom(from, to, tokenId, "");
561     }
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes memory _data
567     ) public override {
568         _transfer(from, to, tokenId);
569         require(
570             _checkOnERC721Received(from, to, tokenId, _data),
571             "ERC721A: transfer to non ERC721Receiver implementer"
572         );
573     }
574     function _exists(uint256 tokenId) internal view returns (bool) {
575         return tokenId < currentIndex;
576     }
577 
578     function _safeMint(address to, uint256 quantity) internal {
579         _safeMint(to, quantity, "");
580     }
581     function _safeMint(
582         address to,
583         uint256 quantity,
584         bytes memory _data
585     ) internal {
586         uint256 startTokenId = currentIndex;
587         require(to != address(0), "ERC721A: mint to the zero address");
588         require(!_exists(startTokenId), "ERC721A: token already minted");
589         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
590 
591         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
592 
593         AddressData memory addressData = _addressData[to];
594         _addressData[to] = AddressData(
595             addressData.balance + uint128(quantity),
596             addressData.numberMinted + uint128(quantity)
597         );
598         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
599 
600         uint256 updatedIndex = startTokenId;
601 
602         for (uint256 i = 0; i < quantity; i++) {
603             emit Transfer(address(0), to, updatedIndex);
604             require(
605                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
606                 "ERC721A: transfer to non ERC721Receiver implementer"
607             );
608             updatedIndex++;
609         }
610 
611         currentIndex = updatedIndex;
612         _afterTokenTransfers(address(0), to, startTokenId, quantity);
613     }
614     function _transfer(
615         address from,
616         address to,
617         uint256 tokenId
618     ) private {
619         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
620 
621         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
622             getApproved(tokenId) == _msgSender() ||
623             isApprovedForAll(prevOwnership.addr, _msgSender()));
624 
625         require(
626             isApprovedOrOwner,
627             "ERC721A: transfer caller is not owner nor approved"
628         );
629 
630         require(
631             prevOwnership.addr == from,
632             "ERC721A: transfer from incorrect owner"
633         );
634         require(to != address(0), "ERC721A: transfer to the zero address");
635 
636         _beforeTokenTransfers(from, to, tokenId, 1);
637         _approve(address(0), tokenId, prevOwnership.addr);
638 
639         _addressData[from].balance -= 1;
640         _addressData[to].balance += 1;
641         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
642         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
643         uint256 nextTokenId = tokenId + 1;
644         if (_ownerships[nextTokenId].addr == address(0)) {
645             if (_exists(nextTokenId)) {
646                 _ownerships[nextTokenId] = TokenOwnership(
647                     prevOwnership.addr,
648                     prevOwnership.startTimestamp
649                 );
650             }
651         }
652 
653         emit Transfer(from, to, tokenId);
654         _afterTokenTransfers(from, to, tokenId, 1);
655     }
656     function _approve(
657         address to,
658         uint256 tokenId,
659         address owner
660     ) private {
661         _tokenApprovals[tokenId] = to;
662         emit Approval(owner, to, tokenId);
663     }
664 
665     uint256 public nextOwnerToExplicitlySet = 0;
666     function _setOwnersExplicit(uint256 quantity) internal {
667         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
668         require(quantity > 0, "quantity must be nonzero");
669         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
670         if (endIndex > collectionSize - 1) {
671             endIndex = collectionSize - 1;
672         }
673         require(_exists(endIndex), "not enough minted yet for this cleanup");
674         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
675             if (_ownerships[i].addr == address(0)) {
676                 TokenOwnership memory ownership = ownershipOf(i);
677                 _ownerships[i] = TokenOwnership(
678                     ownership.addr,
679                     ownership.startTimestamp
680                 );
681             }
682         }
683         nextOwnerToExplicitlySet = endIndex + 1;
684     }
685     function _checkOnERC721Received(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes memory _data
690     ) private returns (bool) {
691         if (to.isContract()) {
692             try
693                 IERC721Receiver(to).onERC721Received(
694                     _msgSender(),
695                     from,
696                     tokenId,
697                     _data
698                 )
699             returns (bytes4 retval) {
700                 return retval == IERC721Receiver(to).onERC721Received.selector;
701             } catch (bytes memory reason) {
702                 if (reason.length == 0) {
703                     revert(
704                         "ERC721A: transfer to non ERC721Receiver implementer"
705                     );
706                 } else {
707                     assembly {
708                         revert(add(32, reason), mload(reason))
709                     }
710                 }
711             }
712         } else {
713             return true;
714         }
715     }
716     function _beforeTokenTransfers(
717         address from,
718         address to,
719         uint256 startTokenId,
720         uint256 quantity
721     ) internal virtual {}
722     function _afterTokenTransfers(
723         address from,
724         address to,
725         uint256 startTokenId,
726         uint256 quantity
727     ) internal virtual {}
728 }
729 
730 pragma solidity ^0.8.0;
731 library MerkleProof {
732     function verify(
733         bytes32[] memory proof,
734         bytes32 root,
735         bytes32 leaf
736     ) internal pure returns (bool) {
737         return processProof(proof, leaf) == root;
738     }
739     function processProof(bytes32[] memory proof, bytes32 leaf)
740         internal
741         pure
742         returns (bytes32)
743     {
744         bytes32 computedHash = leaf;
745         for (uint256 i = 0; i < proof.length; i++) {
746             bytes32 proofElement = proof[i];
747             if (computedHash <= proofElement) {
748                 computedHash = _efficientHash(computedHash, proofElement);
749             } else {
750                 computedHash = _efficientHash(proofElement, computedHash);
751             }
752         }
753         return computedHash;
754     }
755 
756     function _efficientHash(bytes32 a, bytes32 b)
757         private
758         pure
759         returns (bytes32 value)
760     {
761         assembly {
762             mstore(0x00, a)
763             mstore(0x20, b)
764             value := keccak256(0x00, 0x40)
765         }
766     }
767 }
768 
769 contract AperiansContract is Ownable, ERC721A, ReentrancyGuard {
770 
771     bool public publicSale = false;
772     bool public freeMintStatus = false;
773     bool public revealed = false;
774 
775     uint256 public maxPerTx = 5;
776     uint256 public maxPerAddress = 5;
777     uint256 public maxToken = 9001;
778     uint256 public freeMintLimit = 5000;
779     uint256 public price = 0.03 ether;
780 
781     string private _baseTokenURI;
782     string public notRevealedUri = "ipfs://QmcyCu9WRV3eG3FXhXUCuFBh6AZALchZuuEoNpAX99hJo9/";
783     string public _extension = ".json";
784 
785     mapping (address => bool) public freeMinted;
786 
787     constructor()  ERC721A("Aperians Club", "AC", 1000, maxToken)
788     {}
789 
790     modifier callerIsUser() {
791         require(tx.origin == msg.sender, "The caller is another contract");
792         _;
793     }
794 
795 
796     function mint(uint256 quantity) external payable callerIsUser {
797         require(publicSale, "SALE_HAS_NOT_STARTED_YET");
798         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
799         require(quantity > 0, "INVALID_QUANTITY");
800         require(quantity <= maxPerTx, "CANNOT_MINT_THAT_MANY");
801         require(totalSupply() + quantity < maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
802         require(msg.value == price * quantity, "INVALID_ETH");
803         freeMinted[msg.sender] = true;
804 
805         _safeMint(msg.sender, quantity);
806     }
807 
808     function free_mint() external payable callerIsUser {
809         require(freeMintStatus, "FREE_MINT_HAVE_NOT_STARTED_YET");
810         require(totalSupply() + 1 < maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
811         require(totalSupply() + 1 < freeMintLimit, "FREE_LIMIT_REACHED");
812         require(!freeMinted[msg.sender], "YOU_HAVE_ALREADY_CLAIMED");
813 
814         _safeMint(msg.sender, 1);
815         freeMinted[msg.sender] = true;
816     }
817 
818     function ownerMint(address _address, uint256 quantity) external onlyOwner {
819         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
820         _safeMint(_address, quantity);
821     }
822 
823     function _baseURI() internal view virtual override returns (string memory) {
824         return _baseTokenURI;
825     }
826 
827     function setPrice(uint256 _PriceInWEI) external onlyOwner {
828         price = _PriceInWEI;
829     }
830     function setFreeLimit(uint256 _temp) external onlyOwner {
831         freeMintLimit = _temp;
832     }
833     function setMaxLimits(uint256 t_max_per_tx, uint256 t_max_per_address) external onlyOwner {
834 
835         maxPerTx = t_max_per_tx;
836         maxPerAddress = t_max_per_address;
837     }
838 
839 
840     function flipPublicSaleState() external onlyOwner {
841         publicSale = !publicSale;
842     }
843     function flipFreeMintState() external onlyOwner {
844         freeMintStatus = !freeMintStatus;
845     }
846 
847     function setBaseURI(string calldata baseURI) external onlyOwner {
848         _baseTokenURI = baseURI;
849     }
850 
851     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
852         notRevealedUri = _notRevealedURI;
853     }
854 
855     function reveal() external onlyOwner {
856         revealed = !revealed;
857     }
858 
859     function withdraw() external onlyOwner {
860         payable(msg.sender).transfer(address(this).balance);
861     }
862     function updateExtension(string memory _temp) onlyOwner public {
863         _extension = _temp;
864     }
865     function numberMinted(address owner) public view returns (uint256) {
866         return _numberMinted(owner);
867     }
868 
869     function getOwnershipData(uint256 tokenId)
870         external
871         view
872         returns (TokenOwnership memory)
873     {
874         return ownershipOf(tokenId);
875     }
876 
877     function tokenURI(uint256 tokenId)
878         public
879         view
880         virtual
881         override
882         returns (string memory)
883     {
884         require(
885             _exists(tokenId),
886             "ERC721Metadata: URI query for nonexistent token"
887         );
888 
889         if (revealed == false) {
890             return notRevealedUri;
891         }
892 
893         string memory _tokenURI = super.tokenURI(tokenId);
894         return
895             bytes(_tokenURI).length > 0
896                 ? string(abi.encodePacked(_tokenURI, _extension))
897                 : "";
898     }
899 }