1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 pragma solidity ^0.8.0;
8 interface IERC721Receiver {
9     function onERC721Received(
10         address operator,
11         address from,
12         uint256 tokenId,
13         bytes calldata data
14     ) external returns (bytes4);
15 }
16 pragma solidity ^0.8.0;
17 interface IERC721 is IERC165 {
18     event Transfer(
19         address indexed from,
20         address indexed to,
21         uint256 indexed tokenId
22     );
23     event Approval(
24         address indexed owner,
25         address indexed approved,
26         uint256 indexed tokenId
27     );
28     event ApprovalForAll(
29         address indexed owner,
30         address indexed operator,
31         bool approved
32     );
33     function balanceOf(address owner) external view returns (uint256 balance);
34     function ownerOf(uint256 tokenId) external view returns (address owner);
35     function safeTransferFrom(
36         address from,
37         address to,
38         uint256 tokenId
39     ) external;
40     function transferFrom(
41         address from,
42         address to,
43         uint256 tokenId
44     ) external;
45     function approve(address to, uint256 tokenId) external;
46     function getApproved(uint256 tokenId)
47         external
48         view
49         returns (address operator);
50     function setApprovalForAll(address operator, bool _approved) external;
51     function isApprovedForAll(address owner, address operator)
52         external
53         view
54         returns (bool);
55     function safeTransferFrom(
56         address from,
57         address to,
58         uint256 tokenId,
59         bytes calldata data
60     ) external;
61 }
62 pragma solidity ^0.8.0;
63 interface IERC721Metadata is IERC721 {
64     function name() external view returns (string memory);
65     function symbol() external view returns (string memory);
66     function tokenURI(uint256 tokenId) external view returns (string memory);
67 }
68 pragma solidity ^0.8.0;
69 interface IERC721Enumerable is IERC721 {
70     function totalSupply() external view returns (uint256);
71     function tokenOfOwnerByIndex(address owner, uint256 index)
72         external
73         view
74         returns (uint256);
75     function tokenByIndex(uint256 index) external view returns (uint256);
76 }
77 pragma solidity ^0.8.1;
78 library Address {
79     function isContract(address account) internal view returns (bool) {
80 
81         return account.code.length > 0;
82     }
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(
85             address(this).balance >= amount,
86             "Address: insufficient balance"
87         );
88 
89         (bool success, ) = recipient.call{value: amount}("");
90         require(
91             success,
92             "Address: unable to send value, recipient may have reverted"
93         );
94     }
95     function functionCall(address target, bytes memory data)
96         internal
97         returns (bytes memory)
98     {
99         return functionCall(target, data, "Address: low-level call failed");
100     }
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108     function functionCallWithValue(
109         address target,
110         bytes memory data,
111         uint256 value
112     ) internal returns (bytes memory) {
113         return
114             functionCallWithValue(
115                 target,
116                 data,
117                 value,
118                 "Address: low-level call with value failed"
119             );
120     }
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value,
125         string memory errorMessage
126     ) internal returns (bytes memory) {
127         require(
128             address(this).balance >= value,
129             "Address: insufficient balance for call"
130         );
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{value: value}(
134             data
135         );
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138     function functionStaticCall(address target, bytes memory data)
139         internal
140         view
141         returns (bytes memory)
142     {
143         return
144             functionStaticCall(
145                 target,
146                 data,
147                 "Address: low-level static call failed"
148             );
149     }
150     function functionStaticCall(
151         address target,
152         bytes memory data,
153         string memory errorMessage
154     ) internal view returns (bytes memory) {
155         require(isContract(target), "Address: static call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.staticcall(data);
158         return verifyCallResult(success, returndata, errorMessage);
159     }
160     function functionDelegateCall(address target, bytes memory data)
161         internal
162         returns (bytes memory)
163     {
164         return
165             functionDelegateCall(
166                 target,
167                 data,
168                 "Address: low-level delegate call failed"
169             );
170     }
171     function functionDelegateCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         require(isContract(target), "Address: delegate call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.delegatecall(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181     function verifyCallResult(
182         bool success,
183         bytes memory returndata,
184         string memory errorMessage
185     ) internal pure returns (bytes memory) {
186         if (success) {
187             return returndata;
188         } else {
189             if (returndata.length > 0) {
190 
191                 assembly {
192                     let returndata_size := mload(returndata)
193                     revert(add(32, returndata), returndata_size)
194                 }
195             } else {
196                 revert(errorMessage);
197             }
198         }
199     }
200 }
201 pragma solidity ^0.8.0;
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 pragma solidity ^0.8.0;
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(
216         address indexed previousOwner,
217         address indexed newOwner
218     );
219     constructor() {
220         _setOwner(_msgSender());
221     }
222     function owner() public view virtual returns (address) {
223         return _owner;
224     }
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229     function renounceOwnership() public virtual onlyOwner {
230         _setOwner(address(0));
231     }
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(
234             newOwner != address(0),
235             "Ownable: new owner is the zero address"
236         );
237         _setOwner(newOwner);
238     }
239 
240     function _setOwner(address newOwner) private {
241         address oldOwner = _owner;
242         _owner = newOwner;
243         emit OwnershipTransferred(oldOwner, newOwner);
244     }
245 }
246 pragma solidity ^0.8.0;
247 library Strings {
248     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
249     function toString(uint256 value) internal pure returns (string memory) {
250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
251 
252         if (value == 0) {
253             return "0";
254         }
255         uint256 temp = value;
256         uint256 digits;
257         while (temp != 0) {
258             digits++;
259             temp /= 10;
260         }
261         bytes memory buffer = new bytes(digits);
262         while (value != 0) {
263             digits -= 1;
264             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
265             value /= 10;
266         }
267         return string(buffer);
268     }
269     function toHexString(uint256 value) internal pure returns (string memory) {
270         if (value == 0) {
271             return "0x00";
272         }
273         uint256 temp = value;
274         uint256 length = 0;
275         while (temp != 0) {
276             length++;
277             temp >>= 8;
278         }
279         return toHexString(value, length);
280     }
281     function toHexString(uint256 value, uint256 length)
282         internal
283         pure
284         returns (string memory)
285     {
286         bytes memory buffer = new bytes(2 * length + 2);
287         buffer[0] = "0";
288         buffer[1] = "x";
289         for (uint256 i = 2 * length + 1; i > 1; --i) {
290             buffer[i] = _HEX_SYMBOLS[value & 0xf];
291             value >>= 4;
292         }
293         require(value == 0, "Strings: hex length insufficient");
294         return string(buffer);
295     }
296 }
297 pragma solidity ^0.8.0;
298 abstract contract ERC165 is IERC165 {
299     function supportsInterface(bytes4 interfaceId)
300         public
301         view
302         virtual
303         override
304         returns (bool)
305     {
306         return interfaceId == type(IERC165).interfaceId;
307     }
308 }
309 pragma solidity ^0.8.0;
310 abstract contract ReentrancyGuard {
311     // word because each write operation emits an extra SLOAD to first read the
312     // back. This is the compiler's defense against contract upgrades and
313 
314     // but in exchange the refund on every call to nonReentrant will be lower in
315     // transaction's gas, it is best to keep them low in cases like this one, to
316     uint256 private constant _NOT_ENTERED = 1;
317     uint256 private constant _ENTERED = 2;
318 
319     uint256 private _status;
320 
321     constructor() {
322         _status = _NOT_ENTERED;
323     }
324     modifier nonReentrant() {
325         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
326         _status = _ENTERED;
327 
328         _;
329         // https://eips.ethereum.org/EIPS/eip-2200)
330         _status = _NOT_ENTERED;
331     }
332 }
333 pragma solidity ^0.8.0;
334 contract ERC721A is
335     Context,
336     ERC165,
337     IERC721,
338     IERC721Metadata,
339     IERC721Enumerable
340 {
341     using Address for address;
342     using Strings for uint256;
343 
344     struct TokenOwnership {
345         address addr;
346         uint64 startTimestamp;
347     }
348 
349     struct AddressData {
350         uint128 balance;
351         uint128 numberMinted;
352     }
353 
354     uint256 private currentIndex = 0;
355 
356     uint256 internal immutable collectionSize;
357     uint256 internal immutable maxBatchSize;
358     string private _name;
359     string private _symbol;
360     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
361     mapping(uint256 => TokenOwnership) private _ownerships;
362     mapping(address => AddressData) private _addressData;
363     mapping(uint256 => address) private _tokenApprovals;
364     mapping(address => mapping(address => bool)) private _operatorApprovals;
365     constructor(
366         string memory name_,
367         string memory symbol_,
368         uint256 maxBatchSize_,
369         uint256 collectionSize_
370     ) {
371         require(
372             collectionSize_ > 0,
373             "ERC721A: collection must have a nonzero supply"
374         );
375         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
376         _name = name_;
377         _symbol = symbol_;
378         maxBatchSize = maxBatchSize_;
379         collectionSize = collectionSize_;
380     }
381     function totalSupply() public view override returns (uint256) {
382         return currentIndex;
383     }
384     function tokenByIndex(uint256 index)
385         public
386         view
387         override
388         returns (uint256)
389     {
390         require(index < totalSupply(), "ERC721A: global index out of bounds");
391         return index;
392     }
393     function tokenOfOwnerByIndex(address owner, uint256 index)
394         public
395         view
396         override
397         returns (uint256)
398     {
399         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
400         uint256 numMintedSoFar = totalSupply();
401         uint256 tokenIdsIdx = 0;
402         address currOwnershipAddr = address(0);
403         for (uint256 i = 0; i < numMintedSoFar; i++) {
404             TokenOwnership memory ownership = _ownerships[i];
405             if (ownership.addr != address(0)) {
406                 currOwnershipAddr = ownership.addr;
407             }
408             if (currOwnershipAddr == owner) {
409                 if (tokenIdsIdx == index) {
410                     return i;
411                 }
412                 tokenIdsIdx++;
413             }
414         }
415         revert("ERC721A: unable to get token of owner by index");
416     }
417     function supportsInterface(bytes4 interfaceId)
418         public
419         view
420         virtual
421         override(ERC165, IERC165)
422         returns (bool)
423     {
424         return
425             interfaceId == type(IERC721).interfaceId ||
426             interfaceId == type(IERC721Metadata).interfaceId ||
427             interfaceId == type(IERC721Enumerable).interfaceId ||
428             super.supportsInterface(interfaceId);
429     }
430     function balanceOf(address owner) public view override returns (uint256) {
431         require(
432             owner != address(0),
433             "ERC721A: balance query for the zero address"
434         );
435         return uint256(_addressData[owner].balance);
436     }
437 
438     function _numberMinted(address owner) internal view returns (uint256) {
439         require(
440             owner != address(0),
441             "ERC721A: number minted query for the zero address"
442         );
443         return uint256(_addressData[owner].numberMinted);
444     }
445 
446     function ownershipOf(uint256 tokenId)
447         internal
448         view
449         returns (TokenOwnership memory)
450     {
451         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
452 
453         uint256 lowestTokenToCheck;
454         if (tokenId >= maxBatchSize) {
455             lowestTokenToCheck = tokenId - maxBatchSize + 1;
456         }
457 
458         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
459             TokenOwnership memory ownership = _ownerships[curr];
460             if (ownership.addr != address(0)) {
461                 return ownership;
462             }
463         }
464 
465         revert("ERC721A: unable to determine the owner of token");
466     }
467     function ownerOf(uint256 tokenId) public view override returns (address) {
468         return ownershipOf(tokenId).addr;
469     }
470     function name() public view virtual override returns (string memory) {
471         return _name;
472     }
473     function symbol() public view virtual override returns (string memory) {
474         return _symbol;
475     }
476     function tokenURI(uint256 tokenId)
477         public
478         view
479         virtual
480         override
481         returns (string memory)
482     {
483         require(
484             _exists(tokenId),
485             "ERC721Metadata: URI query for nonexistent token"
486         );
487 
488         string memory baseURI = _baseURI();
489         return
490             bytes(baseURI).length > 0
491                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
492                 : "";
493     }
494     function _baseURI() internal view virtual returns (string memory) {
495         return "";
496     }
497     function approve(address to, uint256 tokenId) public override {
498         address owner = ERC721A.ownerOf(tokenId);
499         require(to != owner, "ERC721A: approval to current owner");
500 
501         require(
502             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
503             "ERC721A: approve caller is not owner nor approved for all"
504         );
505 
506         _approve(to, tokenId, owner);
507     }
508     function getApproved(uint256 tokenId)
509         public
510         view
511         override
512         returns (address)
513     {
514         require(
515             _exists(tokenId),
516             "ERC721A: approved query for nonexistent token"
517         );
518 
519         return _tokenApprovals[tokenId];
520     }
521     function setApprovalForAll(address operator, bool approved)
522         public
523         override
524     {
525         require(operator != _msgSender(), "ERC721A: approve to caller");
526 
527         _operatorApprovals[_msgSender()][operator] = approved;
528         emit ApprovalForAll(_msgSender(), operator, approved);
529     }
530     function isApprovedForAll(address owner, address operator)
531         public
532         view
533         virtual
534         override
535         returns (bool)
536     {
537         return _operatorApprovals[owner][operator];
538     }
539     function transferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) public override {
544         _transfer(from, to, tokenId);
545     }
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) public override {
551         safeTransferFrom(from, to, tokenId, "");
552     }
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId,
557         bytes memory _data
558     ) public override {
559         _transfer(from, to, tokenId);
560         require(
561             _checkOnERC721Received(from, to, tokenId, _data),
562             "ERC721A: transfer to non ERC721Receiver implementer"
563         );
564     }
565     function _exists(uint256 tokenId) internal view returns (bool) {
566         return tokenId < currentIndex;
567     }
568 
569     function _safeMint(address to, uint256 quantity) internal {
570         _safeMint(to, quantity, "");
571     }
572     function _safeMint(
573         address to,
574         uint256 quantity,
575         bytes memory _data
576     ) internal {
577         uint256 startTokenId = currentIndex;
578         require(to != address(0), "ERC721A: mint to the zero address");
579         require(!_exists(startTokenId), "ERC721A: token already minted");
580         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
581 
582         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
583 
584         AddressData memory addressData = _addressData[to];
585         _addressData[to] = AddressData(
586             addressData.balance + uint128(quantity),
587             addressData.numberMinted + uint128(quantity)
588         );
589         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
590 
591         uint256 updatedIndex = startTokenId;
592 
593         for (uint256 i = 0; i < quantity; i++) {
594             emit Transfer(address(0), to, updatedIndex);
595             require(
596                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
597                 "ERC721A: transfer to non ERC721Receiver implementer"
598             );
599             updatedIndex++;
600         }
601 
602         currentIndex = updatedIndex;
603         _afterTokenTransfers(address(0), to, startTokenId, quantity);
604     }
605     function _transfer(
606         address from,
607         address to,
608         uint256 tokenId
609     ) private {
610         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
611 
612         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
613             getApproved(tokenId) == _msgSender() ||
614             isApprovedForAll(prevOwnership.addr, _msgSender()));
615 
616         require(
617             isApprovedOrOwner,
618             "ERC721A: transfer caller is not owner nor approved"
619         );
620 
621         require(
622             prevOwnership.addr == from,
623             "ERC721A: transfer from incorrect owner"
624         );
625         require(to != address(0), "ERC721A: transfer to the zero address");
626 
627         _beforeTokenTransfers(from, to, tokenId, 1);
628         _approve(address(0), tokenId, prevOwnership.addr);
629 
630         _addressData[from].balance -= 1;
631         _addressData[to].balance += 1;
632         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
633         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
634         uint256 nextTokenId = tokenId + 1;
635         if (_ownerships[nextTokenId].addr == address(0)) {
636             if (_exists(nextTokenId)) {
637                 _ownerships[nextTokenId] = TokenOwnership(
638                     prevOwnership.addr,
639                     prevOwnership.startTimestamp
640                 );
641             }
642         }
643 
644         emit Transfer(from, to, tokenId);
645         _afterTokenTransfers(from, to, tokenId, 1);
646     }
647     function _approve(
648         address to,
649         uint256 tokenId,
650         address owner
651     ) private {
652         _tokenApprovals[tokenId] = to;
653         emit Approval(owner, to, tokenId);
654     }
655 
656     uint256 public nextOwnerToExplicitlySet = 0;
657     function _setOwnersExplicit(uint256 quantity) internal {
658         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
659         require(quantity > 0, "quantity must be nonzero");
660         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
661         if (endIndex > collectionSize - 1) {
662             endIndex = collectionSize - 1;
663         }
664         require(_exists(endIndex), "not enough minted yet for this cleanup");
665         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
666             if (_ownerships[i].addr == address(0)) {
667                 TokenOwnership memory ownership = ownershipOf(i);
668                 _ownerships[i] = TokenOwnership(
669                     ownership.addr,
670                     ownership.startTimestamp
671                 );
672             }
673         }
674         nextOwnerToExplicitlySet = endIndex + 1;
675     }
676     function _checkOnERC721Received(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes memory _data
681     ) private returns (bool) {
682         if (to.isContract()) {
683             try
684                 IERC721Receiver(to).onERC721Received(
685                     _msgSender(),
686                     from,
687                     tokenId,
688                     _data
689                 )
690             returns (bytes4 retval) {
691                 return retval == IERC721Receiver(to).onERC721Received.selector;
692             } catch (bytes memory reason) {
693                 if (reason.length == 0) {
694                     revert(
695                         "ERC721A: transfer to non ERC721Receiver implementer"
696                     );
697                 } else {
698                     assembly {
699                         revert(add(32, reason), mload(reason))
700                     }
701                 }
702             }
703         } else {
704             return true;
705         }
706     }
707     function _beforeTokenTransfers(
708         address from,
709         address to,
710         uint256 startTokenId,
711         uint256 quantity
712     ) internal virtual {}
713     function _afterTokenTransfers(
714         address from,
715         address to,
716         uint256 startTokenId,
717         uint256 quantity
718     ) internal virtual {}
719 }
720 pragma solidity ^0.8.0;
721 library MerkleProof {
722     function verify(
723         bytes32[] memory proof,
724         bytes32 root,
725         bytes32 leaf
726     ) internal pure returns (bool) {
727         return processProof(proof, leaf) == root;
728     }
729     function processProof(bytes32[] memory proof, bytes32 leaf)
730         internal
731         pure
732         returns (bytes32)
733     {
734         bytes32 computedHash = leaf;
735         for (uint256 i = 0; i < proof.length; i++) {
736             bytes32 proofElement = proof[i];
737             if (computedHash <= proofElement) {
738                 computedHash = _efficientHash(computedHash, proofElement);
739             } else {
740                 computedHash = _efficientHash(proofElement, computedHash);
741             }
742         }
743         return computedHash;
744     }
745 
746     function _efficientHash(bytes32 a, bytes32 b)
747         private
748         pure
749         returns (bytes32 value)
750     {
751         assembly {
752             mstore(0x00, a)
753             mstore(0x20, b)
754             value := keccak256(0x00, 0x40)
755         }
756     }
757 }
758 
759 contract deepblu is Ownable, ERC721A, ReentrancyGuard {
760 
761     bool public publicSale = false;
762     bool public whitelistSale = false;
763     bool public revealed = false;
764 
765     uint256 public maxPerAddress = 3;
766     uint256 public maxToken = 1997;
767     uint256 public price = 0.15 ether;
768 
769     string private _baseTokenURI;
770     string public notRevealedUri = "ipfs://QmXDngARjZYQAVQ5Q8PgRheNrwn7ReSwvERBHWfrbMGpqg/";
771 
772     bytes32 root;
773 
774     constructor(string memory _NAME, string memory _SYMBOL) ERC721A(_NAME, _SYMBOL, 250, maxToken){
775     }
776 
777     modifier callerIsUser() {
778         require(tx.origin == msg.sender, "The caller is another contract");
779         _;
780     }
781 
782     function numberMinted(address owner) public view returns (uint256) {
783         return _numberMinted(owner);
784     }
785 
786     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
787         return ownershipOf(tokenId);
788     }
789 
790     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
791         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
792 
793         if (revealed == false) {
794             return notRevealedUri;
795         }
796 
797         string memory _tokenURI = super.tokenURI(tokenId);
798         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
799     }
800 
801     function verify(bytes32[] memory proof) internal view returns (bool) {
802         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
803         return MerkleProof.verify(proof, root, leaf);
804     }
805 
806     function mint(uint256 quantity, bytes32[] memory proof) external payable callerIsUser {
807         require(whitelistSale || publicSale, "SALE_HAS_NOT_STARTED_YET");
808         require(quantity > 0, "INVALID_QUANTITY");
809         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
810         require(totalSupply() + quantity < maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
811         if(whitelistSale){
812             require(verify(proof), "ADDRESS_NOT_WHITELISTED");
813         }
814         require(msg.value >= price * quantity, "INVALID_ETH");
815         _safeMint(msg.sender, quantity);
816     }
817 
818     function airdrop(address _address, uint256 quantity) external onlyOwner {
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
830 
831     function setWalletLimit(uint256 _maxPerAddress) external onlyOwner {
832         maxPerAddress = _maxPerAddress;
833     }
834 
835     function setRoot(bytes32 _root) external onlyOwner {
836         root = _root;
837     }
838 
839     function flipPublicSale() external onlyOwner {
840         publicSale = !publicSale;
841     }
842 
843     function flipWhitelistSale() external onlyOwner {
844         whitelistSale = !whitelistSale;
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
862 }