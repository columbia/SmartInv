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
201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
202 pragma solidity ^0.8.0;
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes calldata) {
209         return msg.data;
210     }
211 }
212 
213 pragma solidity ^0.8.0;
214 
215 abstract contract Ownable is Context {
216     address private _owner;
217 
218     event OwnershipTransferred(
219         address indexed previousOwner,
220         address indexed newOwner
221     );
222     constructor() {
223         _setOwner(_msgSender());
224     }
225     function owner() public view virtual returns (address) {
226         return _owner;
227     }
228     modifier onlyOwner() {
229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
230         _;
231     }
232     function renounceOwnership() public virtual onlyOwner {
233         _setOwner(address(0));
234     }
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(
237             newOwner != address(0),
238             "Ownable: new owner is the zero address"
239         );
240         _setOwner(newOwner);
241     }
242 
243     function _setOwner(address newOwner) private {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
250 pragma solidity ^0.8.0;
251 library Strings {
252     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
253     function toString(uint256 value) internal pure returns (string memory) {
254         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
255 
256         if (value == 0) {
257             return "0";
258         }
259         uint256 temp = value;
260         uint256 digits;
261         while (temp != 0) {
262             digits++;
263             temp /= 10;
264         }
265         bytes memory buffer = new bytes(digits);
266         while (value != 0) {
267             digits -= 1;
268             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
269             value /= 10;
270         }
271         return string(buffer);
272     }
273     function toHexString(uint256 value) internal pure returns (string memory) {
274         if (value == 0) {
275             return "0x00";
276         }
277         uint256 temp = value;
278         uint256 length = 0;
279         while (temp != 0) {
280             length++;
281             temp >>= 8;
282         }
283         return toHexString(value, length);
284     }
285     function toHexString(uint256 value, uint256 length)
286         internal
287         pure
288         returns (string memory)
289     {
290         bytes memory buffer = new bytes(2 * length + 2);
291         buffer[0] = "0";
292         buffer[1] = "x";
293         for (uint256 i = 2 * length + 1; i > 1; --i) {
294             buffer[i] = _HEX_SYMBOLS[value & 0xf];
295             value >>= 4;
296         }
297         require(value == 0, "Strings: hex length insufficient");
298         return string(buffer);
299     }
300 }
301 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
302 pragma solidity ^0.8.0;
303 abstract contract ERC165 is IERC165 {
304     function supportsInterface(bytes4 interfaceId)
305         public
306         view
307         virtual
308         override
309         returns (bool)
310     {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 pragma solidity ^0.8.0;
316 
317 abstract contract ReentrancyGuard {
318     // word because each write operation emits an extra SLOAD to first read the
319     // back. This is the compiler's defense against contract upgrades and
320 
321     // but in exchange the refund on every call to nonReentrant will be lower in
322     // transaction's gas, it is best to keep them low in cases like this one, to
323     uint256 private constant _NOT_ENTERED = 1;
324     uint256 private constant _ENTERED = 2;
325 
326     uint256 private _status;
327 
328     constructor() {
329         _status = _NOT_ENTERED;
330     }
331     modifier nonReentrant() {
332         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
333         _status = _ENTERED;
334 
335         _;
336         // https://eips.ethereum.org/EIPS/eip-2200)
337         _status = _NOT_ENTERED;
338     }
339 }
340 
341 pragma solidity ^0.8.0;
342 contract ERC721A is
343     Context,
344     ERC165,
345     IERC721,
346     IERC721Metadata,
347     IERC721Enumerable
348 {
349     using Address for address;
350     using Strings for uint256;
351 
352     struct TokenOwnership {
353         address addr;
354         uint64 startTimestamp;
355     }
356 
357     struct AddressData {
358         uint128 balance;
359         uint128 numberMinted;
360     }
361 
362     uint256 private currentIndex = 1;
363 
364     uint256 internal immutable collectionSize;
365     uint256 internal immutable maxBatchSize;
366     string private _name;
367     string private _symbol;
368     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
369     mapping(uint256 => TokenOwnership) private _ownerships;
370     mapping(address => AddressData) private _addressData;
371     mapping(uint256 => address) private _tokenApprovals;
372     mapping(address => mapping(address => bool)) private _operatorApprovals;
373     constructor(
374         string memory name_,
375         string memory symbol_,
376         uint256 maxBatchSize_,
377         uint256 collectionSize_
378     ) {
379         require(
380             collectionSize_ > 0,
381             "ERC721A: collection must have a nonzero supply"
382         );
383         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
384         _name = name_;
385         _symbol = symbol_;
386         maxBatchSize = maxBatchSize_;
387         collectionSize = collectionSize_;
388     }
389     function totalSupply() public view override returns (uint256) {
390         return currentIndex -1;
391     }
392     function tokenByIndex(uint256 index)
393         public
394         view
395         override
396         returns (uint256)
397     {
398         require(index < totalSupply(), "ERC721A: global index out of bounds");
399         return index;
400     }
401     function tokenOfOwnerByIndex(address owner, uint256 index)
402         public
403         view
404         override
405         returns (uint256)
406     {
407         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
408         uint256 numMintedSoFar = totalSupply();
409         uint256 tokenIdsIdx = 0;
410         address currOwnershipAddr = address(0);
411         for (uint256 i = 0; i < numMintedSoFar; i++) {
412             TokenOwnership memory ownership = _ownerships[i];
413             if (ownership.addr != address(0)) {
414                 currOwnershipAddr = ownership.addr;
415             }
416             if (currOwnershipAddr == owner) {
417                 if (tokenIdsIdx == index) {
418                     return i;
419                 }
420                 tokenIdsIdx++;
421             }
422         }
423         revert("ERC721A: unable to get token of owner by index");
424     }
425     function supportsInterface(bytes4 interfaceId)
426         public
427         view
428         virtual
429         override(ERC165, IERC165)
430         returns (bool)
431     {
432         return
433             interfaceId == type(IERC721).interfaceId ||
434             interfaceId == type(IERC721Metadata).interfaceId ||
435             interfaceId == type(IERC721Enumerable).interfaceId ||
436             super.supportsInterface(interfaceId);
437     }
438     function balanceOf(address owner) public view override returns (uint256) {
439         require(
440             owner != address(0),
441             "ERC721A: balance query for the zero address"
442         );
443         return uint256(_addressData[owner].balance);
444     }
445 
446     function _numberMinted(address owner) internal view returns (uint256) {
447         require(
448             owner != address(0),
449             "ERC721A: number minted query for the zero address"
450         );
451         return uint256(_addressData[owner].numberMinted);
452     }
453 
454     function ownershipOf(uint256 tokenId)
455         internal
456         view
457         returns (TokenOwnership memory)
458     {
459         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
460 
461         uint256 lowestTokenToCheck;
462         if (tokenId >= maxBatchSize) {
463             lowestTokenToCheck = tokenId - maxBatchSize + 1;
464         }
465 
466         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
467             TokenOwnership memory ownership = _ownerships[curr];
468             if (ownership.addr != address(0)) {
469                 return ownership;
470             }
471         }
472 
473         revert("ERC721A: unable to determine the owner of token");
474     }
475     function ownerOf(uint256 tokenId) public view override returns (address) {
476         return ownershipOf(tokenId).addr;
477     }
478     function name() public view virtual override returns (string memory) {
479         return _name;
480     }
481     function symbol() public view virtual override returns (string memory) {
482         return _symbol;
483     }
484     function tokenURI(uint256 tokenId)
485         public
486         view
487         virtual
488         override
489         returns (string memory)
490     {
491         require(
492             _exists(tokenId),
493             "ERC721Metadata: URI query for nonexistent token"
494         );
495 
496         string memory baseURI = _baseURI();
497         return
498             bytes(baseURI).length > 0
499                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
500                 : "";
501     }
502     function _baseURI() internal view virtual returns (string memory) {
503         return "";
504     }
505     function approve(address to, uint256 tokenId) public override {
506         address owner = ERC721A.ownerOf(tokenId);
507         require(to != owner, "ERC721A: approval to current owner");
508 
509         require(
510             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
511             "ERC721A: approve caller is not owner nor approved for all"
512         );
513 
514         _approve(to, tokenId, owner);
515     }
516     function getApproved(uint256 tokenId)
517         public
518         view
519         override
520         returns (address)
521     {
522         require(
523             _exists(tokenId),
524             "ERC721A: approved query for nonexistent token"
525         );
526 
527         return _tokenApprovals[tokenId];
528     }
529     function setApprovalForAll(address operator, bool approved)
530         public
531         override
532     {
533         require(operator != _msgSender(), "ERC721A: approve to caller");
534 
535         _operatorApprovals[_msgSender()][operator] = approved;
536         emit ApprovalForAll(_msgSender(), operator, approved);
537     }
538     function isApprovedForAll(address owner, address operator)
539         public
540         view
541         virtual
542         override
543         returns (bool)
544     {
545         return _operatorApprovals[owner][operator];
546     }
547     function transferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) public override {
552         _transfer(from, to, tokenId);
553     }
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId
558     ) public override {
559         safeTransferFrom(from, to, tokenId, "");
560     }
561     function safeTransferFrom(
562         address from,
563         address to,
564         uint256 tokenId,
565         bytes memory _data
566     ) public override {
567         _transfer(from, to, tokenId);
568         require(
569             _checkOnERC721Received(from, to, tokenId, _data),
570             "ERC721A: transfer to non ERC721Receiver implementer"
571         );
572     }
573     function _exists(uint256 tokenId) internal view returns (bool) {
574         return tokenId < currentIndex;
575     }
576 
577     function _safeMint(address to, uint256 quantity) internal {
578         _safeMint(to, quantity, "");
579     }
580     function _safeMint(
581         address to,
582         uint256 quantity,
583         bytes memory _data
584     ) internal {
585         uint256 startTokenId = currentIndex;
586         require(to != address(0), "ERC721A: mint to the zero address");
587         require(!_exists(startTokenId), "ERC721A: token already minted");
588         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
589 
590         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
591 
592         AddressData memory addressData = _addressData[to];
593         _addressData[to] = AddressData(
594             addressData.balance + uint128(quantity),
595             addressData.numberMinted + uint128(quantity)
596         );
597         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
598 
599         uint256 updatedIndex = startTokenId;
600 
601         for (uint256 i = 0; i < quantity; i++) {
602             emit Transfer(address(0), to, updatedIndex);
603             require(
604                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
605                 "ERC721A: transfer to non ERC721Receiver implementer"
606             );
607             updatedIndex++;
608         }
609 
610         currentIndex = updatedIndex;
611         _afterTokenTransfers(address(0), to, startTokenId, quantity);
612     }
613     function _transfer(
614         address from,
615         address to,
616         uint256 tokenId
617     ) private {
618         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
619 
620         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
621             getApproved(tokenId) == _msgSender() ||
622             isApprovedForAll(prevOwnership.addr, _msgSender()));
623 
624         require(
625             isApprovedOrOwner,
626             "ERC721A: transfer caller is not owner nor approved"
627         );
628 
629         require(
630             prevOwnership.addr == from,
631             "ERC721A: transfer from incorrect owner"
632         );
633         require(to != address(0), "ERC721A: transfer to the zero address");
634 
635         _beforeTokenTransfers(from, to, tokenId, 1);
636         _approve(address(0), tokenId, prevOwnership.addr);
637 
638         _addressData[from].balance -= 1;
639         _addressData[to].balance += 1;
640         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
641         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
642         uint256 nextTokenId = tokenId + 1;
643         if (_ownerships[nextTokenId].addr == address(0)) {
644             if (_exists(nextTokenId)) {
645                 _ownerships[nextTokenId] = TokenOwnership(
646                     prevOwnership.addr,
647                     prevOwnership.startTimestamp
648                 );
649             }
650         }
651 
652         emit Transfer(from, to, tokenId);
653         _afterTokenTransfers(from, to, tokenId, 1);
654     }
655     function _approve(
656         address to,
657         uint256 tokenId,
658         address owner
659     ) private {
660         _tokenApprovals[tokenId] = to;
661         emit Approval(owner, to, tokenId);
662     }
663 
664     uint256 public nextOwnerToExplicitlySet = 0;
665     function _setOwnersExplicit(uint256 quantity) internal {
666         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
667         require(quantity > 0, "quantity must be nonzero");
668         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
669         if (endIndex > collectionSize - 1) {
670             endIndex = collectionSize - 1;
671         }
672         require(_exists(endIndex), "not enough minted yet for this cleanup");
673         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
674             if (_ownerships[i].addr == address(0)) {
675                 TokenOwnership memory ownership = ownershipOf(i);
676                 _ownerships[i] = TokenOwnership(
677                     ownership.addr,
678                     ownership.startTimestamp
679                 );
680             }
681         }
682         nextOwnerToExplicitlySet = endIndex + 1;
683     }
684     function _checkOnERC721Received(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes memory _data
689     ) private returns (bool) {
690         if (to.isContract()) {
691             try
692                 IERC721Receiver(to).onERC721Received(
693                     _msgSender(),
694                     from,
695                     tokenId,
696                     _data
697                 )
698             returns (bytes4 retval) {
699                 return retval == IERC721Receiver(to).onERC721Received.selector;
700             } catch (bytes memory reason) {
701                 if (reason.length == 0) {
702                     revert(
703                         "ERC721A: transfer to non ERC721Receiver implementer"
704                     );
705                 } else {
706                     assembly {
707                         revert(add(32, reason), mload(reason))
708                     }
709                 }
710             }
711         } else {
712             return true;
713         }
714     }
715     function _beforeTokenTransfers(
716         address from,
717         address to,
718         uint256 startTokenId,
719         uint256 quantity
720     ) internal virtual {}
721     function _afterTokenTransfers(
722         address from,
723         address to,
724         uint256 startTokenId,
725         uint256 quantity
726     ) internal virtual {}
727 }
728 
729 pragma solidity ^0.8.0;
730 library MerkleProof {
731     function verify(
732         bytes32[] memory proof,
733         bytes32 root,
734         bytes32 leaf
735     ) internal pure returns (bool) {
736         return processProof(proof, leaf) == root;
737     }
738     function processProof(bytes32[] memory proof, bytes32 leaf)
739         internal
740         pure
741         returns (bytes32)
742     {
743         bytes32 computedHash = leaf;
744         for (uint256 i = 0; i < proof.length; i++) {
745             bytes32 proofElement = proof[i];
746             if (computedHash <= proofElement) {
747                 computedHash = _efficientHash(computedHash, proofElement);
748             } else {
749                 computedHash = _efficientHash(proofElement, computedHash);
750             }
751         }
752         return computedHash;
753     }
754 
755     function _efficientHash(bytes32 a, bytes32 b)
756         private
757         pure
758         returns (bytes32 value)
759     {
760         assembly {
761             mstore(0x00, a)
762             mstore(0x20, b)
763             value := keccak256(0x00, 0x40)
764         }
765     }
766 }
767 
768 contract UnderTheRock is Ownable, ERC721A, ReentrancyGuard {
769 
770     bool public publicSale = false;
771     bool public whitelistSale = false;
772 
773     uint256 public maxPerTx = 3;
774     uint256 public maxPerAddress = 3;
775     uint256 public maxToken = 888;
776     uint256 public price = 0.0222 ether;
777 
778     string private _baseTokenURI = "";
779 
780     bytes32 root;
781 
782     constructor(string memory _NAME, string memory _SYMBOL)
783         ERC721A(_NAME, _SYMBOL, 1000, maxToken)
784         
785     {}
786 
787     modifier callerIsUser() {
788         require(tx.origin == msg.sender, "The caller is another contract");
789         _;
790     }
791 
792     function numberMinted(address owner) public view returns (uint256) {
793         return _numberMinted(owner);
794     }
795 
796     function getOwnershipData(uint256 tokenId)
797         external
798         view
799         returns (TokenOwnership memory)
800     {
801         return ownershipOf(tokenId);
802     }
803 
804     function tokenURI(uint256 tokenId)
805         public
806         view
807         virtual
808         override
809         returns (string memory)
810     {
811         require(
812             _exists(tokenId),
813             "ERC721Metadata: URI query for nonexistent token"
814         );
815 
816         string memory _tokenURI = super.tokenURI(tokenId);
817         return
818             bytes(_tokenURI).length > 0
819                 ? string(abi.encodePacked(_tokenURI, ".json"))
820                 : "";
821     }
822 
823     function verify(bytes32[] memory proof) internal view returns (bool) {
824         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
825         return MerkleProof.verify(proof, root, leaf);
826     }
827 
828     function mint(uint256 quantity, bytes32[] memory proof) external payable callerIsUser {
829         require(whitelistSale || publicSale, "SALE_HAS_NOT_STARTED_YET");
830         require(numberMinted(msg.sender) + quantity <= maxPerAddress, "PER_WALLET_LIMIT_REACHED");
831         require(quantity > 0, "INVALID_QUANTITY");
832         require(quantity <= maxPerTx, "CANNOT_MINT_THAT_MANY");
833         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
834         if(whitelistSale){
835             require(verify(proof), "ADDRESS_NOT_WHITELISTED");
836         }
837         if(numberMinted(msg.sender) > 0){
838             require(msg.value >= price * quantity, "INVALID_ETH");
839         }else{
840             require(msg.value >= (price * quantity) - price, "INVALID_ETH");
841         }
842         _safeMint(msg.sender, quantity);
843     }
844 
845     function teamAllocationMint(address _address, uint256 quantity) external onlyOwner {
846         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
847         _safeMint(_address, quantity);
848     }
849 
850     function _baseURI() internal view virtual override returns (string memory) {
851         return _baseTokenURI;
852     }
853    
854     
855 
856     function setPrice(uint256 _PriceInWEI) external onlyOwner {
857         price = _PriceInWEI;
858     }
859 
860     function setRoot(bytes32 _root) external onlyOwner {
861         root = _root;
862     }
863 
864     function flipPublicSaleState() external onlyOwner {
865         publicSale = !publicSale;
866     }
867 
868     function flipWhitelistState() external onlyOwner {
869         whitelistSale = !whitelistSale;
870     }
871 
872     function setBaseURI(string calldata baseURI) external onlyOwner {
873         _baseTokenURI = baseURI;
874     }
875 
876     function withdraw() external onlyOwner {
877         payable(msg.sender).transfer(address(this).balance);
878     }
879 }