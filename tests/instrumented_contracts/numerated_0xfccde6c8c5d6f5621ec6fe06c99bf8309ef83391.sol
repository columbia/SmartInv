1 // SPDX-License-Identifier: MIT
2 /**
3 
4  */
5 pragma solidity ^0.8.0;
6 pragma solidity ^0.8.0;
7 interface IERC165 {
8     function supportsInterface(bytes4 interfaceId) external view returns (bool);
9 }
10 pragma solidity ^0.8.0;
11 interface IERC721Receiver {
12     function onERC721Received(
13         address operator,
14         address from,
15         uint256 tokenId,
16         bytes calldata data
17     ) external returns (bytes4);
18 }
19 pragma solidity ^0.8.0;
20 interface IERC721 is IERC165 {
21     event Transfer(
22         address indexed from,
23         address indexed to,
24         uint256 indexed tokenId
25     );
26     event Approval(
27         address indexed owner,
28         address indexed approved,
29         uint256 indexed tokenId
30     );
31     event ApprovalForAll(
32         address indexed owner,
33         address indexed operator,
34         bool approved
35     );
36     function balanceOf(address owner) external view returns (uint256 balance);
37     function ownerOf(uint256 tokenId) external view returns (address owner);
38     function safeTransferFrom(
39         address from,
40         address to,
41         uint256 tokenId
42     ) external;
43     function transferFrom(
44         address from,
45         address to,
46         uint256 tokenId
47     ) external;
48     function approve(address to, uint256 tokenId) external;
49     function getApproved(uint256 tokenId)
50         external
51         view
52         returns (address operator);
53     function setApprovalForAll(address operator, bool _approved) external;
54     function isApprovedForAll(address owner, address operator)
55         external
56         view
57         returns (bool);
58     function safeTransferFrom(
59         address from,
60         address to,
61         uint256 tokenId,
62         bytes calldata data
63     ) external;
64 }
65 pragma solidity ^0.8.0;
66 interface IERC721Metadata is IERC721 {
67     function name() external view returns (string memory);
68     function symbol() external view returns (string memory);
69     function tokenURI(uint256 tokenId) external view returns (string memory);
70 }
71 pragma solidity ^0.8.0;
72 interface IERC721Enumerable is IERC721 {
73     function totalSupply() external view returns (uint256);
74     function tokenOfOwnerByIndex(address owner, uint256 index)
75         external
76         view
77         returns (uint256);
78     function tokenByIndex(uint256 index) external view returns (uint256);
79 }
80 pragma solidity ^0.8.1;
81 library Address {
82     function isContract(address account) internal view returns (bool) {
83 
84         return account.code.length > 0;
85     }
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(
88             address(this).balance >= amount,
89             "Address: insufficient balance"
90         );
91 
92         (bool success, ) = recipient.call{value: amount}("");
93         require(
94             success,
95             "Address: unable to send value, recipient may have reverted"
96         );
97     }
98     function functionCall(address target, bytes memory data)
99         internal
100         returns (bytes memory)
101     {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104     function functionCall(
105         address target,
106         bytes memory data,
107         string memory errorMessage
108     ) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, 0, errorMessage);
110     }
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return
117             functionCallWithValue(
118                 target,
119                 data,
120                 value,
121                 "Address: low-level call with value failed"
122             );
123     }
124     function functionCallWithValue(
125         address target,
126         bytes memory data,
127         uint256 value,
128         string memory errorMessage
129     ) internal returns (bytes memory) {
130         require(
131             address(this).balance >= value,
132             "Address: insufficient balance for call"
133         );
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(
137             data
138         );
139         return verifyCallResult(success, returndata, errorMessage);
140     }
141     function functionStaticCall(address target, bytes memory data)
142         internal
143         view
144         returns (bytes memory)
145     {
146         return
147             functionStaticCall(
148                 target,
149                 data,
150                 "Address: low-level static call failed"
151             );
152     }
153     function functionStaticCall(
154         address target,
155         bytes memory data,
156         string memory errorMessage
157     ) internal view returns (bytes memory) {
158         require(isContract(target), "Address: static call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.staticcall(data);
161         return verifyCallResult(success, returndata, errorMessage);
162     }
163     function functionDelegateCall(address target, bytes memory data)
164         internal
165         returns (bytes memory)
166     {
167         return
168             functionDelegateCall(
169                 target,
170                 data,
171                 "Address: low-level delegate call failed"
172             );
173     }
174     function functionDelegateCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         require(isContract(target), "Address: delegate call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.delegatecall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184     function verifyCallResult(
185         bool success,
186         bytes memory returndata,
187         string memory errorMessage
188     ) internal pure returns (bytes memory) {
189         if (success) {
190             return returndata;
191         } else {
192             if (returndata.length > 0) {
193 
194                 assembly {
195                     let returndata_size := mload(returndata)
196                     revert(add(32, returndata), returndata_size)
197                 }
198             } else {
199                 revert(errorMessage);
200             }
201         }
202     }
203 }
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
215 
216 pragma solidity ^0.8.0;
217 
218 abstract contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(
222         address indexed previousOwner,
223         address indexed newOwner
224     );
225     constructor() {
226         _setOwner(_msgSender());
227     }
228     function owner() public view virtual returns (address) {
229         return _owner;
230     }
231     modifier onlyOwner() {
232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
233         _;
234     }
235     function renounceOwnership() public virtual onlyOwner {
236         _setOwner(address(0));
237     }
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(
240             newOwner != address(0),
241             "Ownable: new owner is the zero address"
242         );
243         _setOwner(newOwner);
244     }
245 
246     function _setOwner(address newOwner) private {
247         address oldOwner = _owner;
248         _owner = newOwner;
249         emit OwnershipTransferred(oldOwner, newOwner);
250     }
251 }
252 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
253 pragma solidity ^0.8.0;
254 library Strings {
255     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
256     function toString(uint256 value) internal pure returns (string memory) {
257         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
258 
259         if (value == 0) {
260             return "0";
261         }
262         uint256 temp = value;
263         uint256 digits;
264         while (temp != 0) {
265             digits++;
266             temp /= 10;
267         }
268         bytes memory buffer = new bytes(digits);
269         while (value != 0) {
270             digits -= 1;
271             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
272             value /= 10;
273         }
274         return string(buffer);
275     }
276     function toHexString(uint256 value) internal pure returns (string memory) {
277         if (value == 0) {
278             return "0x00";
279         }
280         uint256 temp = value;
281         uint256 length = 0;
282         while (temp != 0) {
283             length++;
284             temp >>= 8;
285         }
286         return toHexString(value, length);
287     }
288     function toHexString(uint256 value, uint256 length)
289         internal
290         pure
291         returns (string memory)
292     {
293         bytes memory buffer = new bytes(2 * length + 2);
294         buffer[0] = "0";
295         buffer[1] = "x";
296         for (uint256 i = 2 * length + 1; i > 1; --i) {
297             buffer[i] = _HEX_SYMBOLS[value & 0xf];
298             value >>= 4;
299         }
300         require(value == 0, "Strings: hex length insufficient");
301         return string(buffer);
302     }
303 }
304 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
305 pragma solidity ^0.8.0;
306 abstract contract ERC165 is IERC165 {
307     function supportsInterface(bytes4 interfaceId)
308         public
309         view
310         virtual
311         override
312         returns (bool)
313     {
314         return interfaceId == type(IERC165).interfaceId;
315     }
316 }
317 
318 pragma solidity ^0.8.0;
319 
320 abstract contract ReentrancyGuard {
321     // word because each write operation emits an extra SLOAD to first read the
322     // back. This is the compiler's defense against contract upgrades and
323 
324     // but in exchange the refund on every call to nonReentrant will be lower in
325     // transaction's gas, it is best to keep them low in cases like this one, to
326     uint256 private constant _NOT_ENTERED = 1;
327     uint256 private constant _ENTERED = 2;
328 
329     uint256 private _status;
330 
331     constructor() {
332         _status = _NOT_ENTERED;
333     }
334     modifier nonReentrant() {
335         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
336         _status = _ENTERED;
337 
338         _;
339         // https://eips.ethereum.org/EIPS/eip-2200)
340         _status = _NOT_ENTERED;
341     }
342 }
343 
344 pragma solidity ^0.8.0;
345 contract ERC721A is
346     Context,
347     ERC165,
348     IERC721,
349     IERC721Metadata,
350     IERC721Enumerable
351 {
352     using Address for address;
353     using Strings for uint256;
354 
355     struct TokenOwnership {
356         address addr;
357         uint64 startTimestamp;
358     }
359 
360     struct AddressData {
361         uint128 balance;
362         uint128 numberMinted;
363     }
364 
365     uint256 private currentIndex = 0;
366 
367     uint256 internal immutable collectionSize;
368     uint256 internal immutable maxBatchSize;
369     string private _name;
370     string private _symbol;
371     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
372     mapping(uint256 => TokenOwnership) private _ownerships;
373     mapping(address => AddressData) private _addressData;
374     mapping(uint256 => address) private _tokenApprovals;
375     mapping(address => mapping(address => bool)) private _operatorApprovals;
376     constructor(
377         string memory name_,
378         string memory symbol_,
379         uint256 maxBatchSize_,
380         uint256 collectionSize_
381     ) {
382         require(
383             collectionSize_ > 0,
384             "ERC721A: collection must have a nonzero supply"
385         );
386         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
387         _name = name_;
388         _symbol = symbol_;
389         maxBatchSize = maxBatchSize_;
390         collectionSize = collectionSize_;
391     }
392     function totalSupply() public view override returns (uint256) {
393         return currentIndex;
394     }
395     function tokenByIndex(uint256 index)
396         public
397         view
398         override
399         returns (uint256)
400     {
401         require(index < totalSupply(), "ERC721A: global index out of bounds");
402         return index;
403     }
404     function tokenOfOwnerByIndex(address owner, uint256 index)
405         public
406         view
407         override
408         returns (uint256)
409     {
410         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
411         uint256 numMintedSoFar = totalSupply();
412         uint256 tokenIdsIdx = 0;
413         address currOwnershipAddr = address(0);
414         for (uint256 i = 0; i < numMintedSoFar; i++) {
415             TokenOwnership memory ownership = _ownerships[i];
416             if (ownership.addr != address(0)) {
417                 currOwnershipAddr = ownership.addr;
418             }
419             if (currOwnershipAddr == owner) {
420                 if (tokenIdsIdx == index) {
421                     return i;
422                 }
423                 tokenIdsIdx++;
424             }
425         }
426         revert("ERC721A: unable to get token of owner by index");
427     }
428     function supportsInterface(bytes4 interfaceId)
429         public
430         view
431         virtual
432         override(ERC165, IERC165)
433         returns (bool)
434     {
435         return
436             interfaceId == type(IERC721).interfaceId ||
437             interfaceId == type(IERC721Metadata).interfaceId ||
438             interfaceId == type(IERC721Enumerable).interfaceId ||
439             super.supportsInterface(interfaceId);
440     }
441     function balanceOf(address owner) public view override returns (uint256) {
442         require(
443             owner != address(0),
444             "ERC721A: balance query for the zero address"
445         );
446         return uint256(_addressData[owner].balance);
447     }
448 
449     function _numberMinted(address owner) internal view returns (uint256) {
450         require(
451             owner != address(0),
452             "ERC721A: number minted query for the zero address"
453         );
454         return uint256(_addressData[owner].numberMinted);
455     }
456 
457     function ownershipOf(uint256 tokenId)
458         internal
459         view
460         returns (TokenOwnership memory)
461     {
462         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
463 
464         uint256 lowestTokenToCheck;
465         if (tokenId >= maxBatchSize) {
466             lowestTokenToCheck = tokenId - maxBatchSize + 1;
467         }
468 
469         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
470             TokenOwnership memory ownership = _ownerships[curr];
471             if (ownership.addr != address(0)) {
472                 return ownership;
473             }
474         }
475 
476         revert("ERC721A: unable to determine the owner of token");
477     }
478     function ownerOf(uint256 tokenId) public view override returns (address) {
479         return ownershipOf(tokenId).addr;
480     }
481     function name() public view virtual override returns (string memory) {
482         return _name;
483     }
484     function symbol() public view virtual override returns (string memory) {
485         return _symbol;
486     }
487     function tokenURI(uint256 tokenId)
488         public
489         view
490         virtual
491         override
492         returns (string memory)
493     {
494         require(
495             _exists(tokenId),
496             "ERC721Metadata: URI query for nonexistent token"
497         );
498 
499         string memory baseURI = _baseURI();
500         return
501             bytes(baseURI).length > 0
502                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
503                 : "";
504     }
505     function _baseURI() internal view virtual returns (string memory) {
506         return "";
507     }
508     function approve(address to, uint256 tokenId) public override {
509         address owner = ERC721A.ownerOf(tokenId);
510         require(to != owner, "ERC721A: approval to current owner");
511 
512         require(
513             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
514             "ERC721A: approve caller is not owner nor approved for all"
515         );
516 
517         _approve(to, tokenId, owner);
518     }
519     function getApproved(uint256 tokenId)
520         public
521         view
522         override
523         returns (address)
524     {
525         require(
526             _exists(tokenId),
527             "ERC721A: approved query for nonexistent token"
528         );
529 
530         return _tokenApprovals[tokenId];
531     }
532     function setApprovalForAll(address operator, bool approved)
533         public
534         override
535     {
536         require(operator != _msgSender(), "ERC721A: approve to caller");
537 
538         _operatorApprovals[_msgSender()][operator] = approved;
539         emit ApprovalForAll(_msgSender(), operator, approved);
540     }
541     function isApprovedForAll(address owner, address operator)
542         public
543         view
544         virtual
545         override
546         returns (bool)
547     {
548         return _operatorApprovals[owner][operator];
549     }
550     function transferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) public override {
555         _transfer(from, to, tokenId);
556     }
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) public override {
562         safeTransferFrom(from, to, tokenId, "");
563     }
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId,
568         bytes memory _data
569     ) public override {
570         _transfer(from, to, tokenId);
571         require(
572             _checkOnERC721Received(from, to, tokenId, _data),
573             "ERC721A: transfer to non ERC721Receiver implementer"
574         );
575     }
576     function _exists(uint256 tokenId) internal view returns (bool) {
577         return tokenId < currentIndex;
578     }
579 
580     function _safeMint(address to, uint256 quantity) internal {
581         _safeMint(to, quantity, "");
582     }
583     function _safeMint(
584         address to,
585         uint256 quantity,
586         bytes memory _data
587     ) internal {
588         uint256 startTokenId = currentIndex;
589         require(to != address(0), "ERC721A: mint to the zero address");
590         require(!_exists(startTokenId), "ERC721A: token already minted");
591         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
592 
593         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
594 
595         AddressData memory addressData = _addressData[to];
596         _addressData[to] = AddressData(
597             addressData.balance + uint128(quantity),
598             addressData.numberMinted + uint128(quantity)
599         );
600         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
601 
602         uint256 updatedIndex = startTokenId;
603 
604         for (uint256 i = 0; i < quantity; i++) {
605             emit Transfer(address(0), to, updatedIndex);
606             require(
607                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
608                 "ERC721A: transfer to non ERC721Receiver implementer"
609             );
610             updatedIndex++;
611         }
612 
613         currentIndex = updatedIndex;
614         _afterTokenTransfers(address(0), to, startTokenId, quantity);
615     }
616     function _transfer(
617         address from,
618         address to,
619         uint256 tokenId
620     ) private {
621         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
622 
623         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
624             getApproved(tokenId) == _msgSender() ||
625             isApprovedForAll(prevOwnership.addr, _msgSender()));
626 
627         require(
628             isApprovedOrOwner,
629             "ERC721A: transfer caller is not owner nor approved"
630         );
631 
632         require(
633             prevOwnership.addr == from,
634             "ERC721A: transfer from incorrect owner"
635         );
636         require(to != address(0), "ERC721A: transfer to the zero address");
637 
638         _beforeTokenTransfers(from, to, tokenId, 1);
639         _approve(address(0), tokenId, prevOwnership.addr);
640 
641         _addressData[from].balance -= 1;
642         _addressData[to].balance += 1;
643         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
644         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
645         uint256 nextTokenId = tokenId + 1;
646         if (_ownerships[nextTokenId].addr == address(0)) {
647             if (_exists(nextTokenId)) {
648                 _ownerships[nextTokenId] = TokenOwnership(
649                     prevOwnership.addr,
650                     prevOwnership.startTimestamp
651                 );
652             }
653         }
654 
655         emit Transfer(from, to, tokenId);
656         _afterTokenTransfers(from, to, tokenId, 1);
657     }
658     function _approve(
659         address to,
660         uint256 tokenId,
661         address owner
662     ) private {
663         _tokenApprovals[tokenId] = to;
664         emit Approval(owner, to, tokenId);
665     }
666 
667     uint256 public nextOwnerToExplicitlySet = 0;
668     function _setOwnersExplicit(uint256 quantity) internal {
669         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
670         require(quantity > 0, "quantity must be nonzero");
671         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
672         if (endIndex > collectionSize - 1) {
673             endIndex = collectionSize - 1;
674         }
675         require(_exists(endIndex), "not enough minted yet for this cleanup");
676         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
677             if (_ownerships[i].addr == address(0)) {
678                 TokenOwnership memory ownership = ownershipOf(i);
679                 _ownerships[i] = TokenOwnership(
680                     ownership.addr,
681                     ownership.startTimestamp
682                 );
683             }
684         }
685         nextOwnerToExplicitlySet = endIndex + 1;
686     }
687     function _checkOnERC721Received(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes memory _data
692     ) private returns (bool) {
693         if (to.isContract()) {
694             try
695                 IERC721Receiver(to).onERC721Received(
696                     _msgSender(),
697                     from,
698                     tokenId,
699                     _data
700                 )
701             returns (bytes4 retval) {
702                 return retval == IERC721Receiver(to).onERC721Received.selector;
703             } catch (bytes memory reason) {
704                 if (reason.length == 0) {
705                     revert(
706                         "ERC721A: transfer to non ERC721Receiver implementer"
707                     );
708                 } else {
709                     assembly {
710                         revert(add(32, reason), mload(reason))
711                     }
712                 }
713             }
714         } else {
715             return true;
716         }
717     }
718     function _beforeTokenTransfers(
719         address from,
720         address to,
721         uint256 startTokenId,
722         uint256 quantity
723     ) internal virtual {}
724     function _afterTokenTransfers(
725         address from,
726         address to,
727         uint256 startTokenId,
728         uint256 quantity
729     ) internal virtual {}
730 }
731 
732 pragma solidity ^0.8.0;
733 library MerkleProof {
734     function verify(
735         bytes32[] memory proof,
736         bytes32 root,
737         bytes32 leaf
738     ) internal pure returns (bool) {
739         return processProof(proof, leaf) == root;
740     }
741     function processProof(bytes32[] memory proof, bytes32 leaf)
742         internal
743         pure
744         returns (bytes32)
745     {
746         bytes32 computedHash = leaf;
747         for (uint256 i = 0; i < proof.length; i++) {
748             bytes32 proofElement = proof[i];
749             if (computedHash <= proofElement) {
750                 computedHash = _efficientHash(computedHash, proofElement);
751             } else {
752                 computedHash = _efficientHash(proofElement, computedHash);
753             }
754         }
755         return computedHash;
756     }
757 
758     function _efficientHash(bytes32 a, bytes32 b)
759         private
760         pure
761         returns (bytes32 value)
762     {
763         assembly {
764             mstore(0x00, a)
765             mstore(0x20, b)
766             value := keccak256(0x00, 0x40)
767         }
768     }
769 }
770 
771 contract TheRealBanditos is Ownable, ERC721A, ReentrancyGuard {
772 
773     bool public publicSale = false;
774     bool public whitelistSale = false;
775 
776     uint256 public maxPerTx = 30;
777     uint256 public maxPerTxWl = 3;
778     uint256 public maxPerAddress = 100;
779     uint256 public maxToken = 3333;
780     uint256 public price = 0.03 ether;
781 
782     string private _baseTokenURI = "";
783     mapping(address => bool) private _whitelist;
784 
785     bytes32 root;
786 
787     constructor(string memory _NAME, string memory _SYMBOL)
788         ERC721A(_NAME, _SYMBOL, 1000, maxToken)
789     {}
790 
791     modifier callerIsUser() {
792         require(tx.origin == msg.sender, "The caller is another contract");
793         _;
794     }
795 
796     function numberMinted(address owner) public view returns (uint256) {
797         return _numberMinted(owner);
798     }
799 
800     function getOwnershipData(uint256 tokenId)
801         external
802         view
803         returns (TokenOwnership memory)
804     {
805         return ownershipOf(tokenId);
806     }
807 
808     function tokenURI(uint256 tokenId)
809         public
810         view
811         virtual
812         override
813         returns (string memory)
814     {
815         require(
816             _exists(tokenId),
817             "ERC721Metadata: URI query for nonexistent token"
818         );
819 
820         string memory _tokenURI = super.tokenURI(tokenId);
821         return
822             bytes(_tokenURI).length > 0
823                 ? string(abi.encodePacked(_tokenURI, ""))
824                 : "";
825     }
826 
827     function verify(bytes32[] memory proof) internal view returns (bool) {
828         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
829         return MerkleProof.verify(proof, root, leaf);
830     }
831 
832     function mint(uint256 quantity, address _to) external payable callerIsUser {
833         require(publicSale, "SALE_HAS_NOT_STARTED_YET");
834         require(quantity > 0, "INVALID_QUANTITY");
835         require(quantity <= maxPerTx, "CANNOT_MINT_THAT_MANY");
836         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
837         require(msg.value >= price * quantity || msg.sender == owner() , "Value below price");
838         _safeMint(_to, quantity);
839     }
840 
841     function mint_(uint256 quantity) external payable callerIsUser {
842         require(whitelistSale, "SALE_HAS_NOT_STARTED_YET");
843         require(quantity > 0, "INVALID_QUANTITY");
844         require(quantity <= maxPerTxWl, "CANNOT_MINT_THAT_MANY");
845         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_MINT_DESIRED_AMOUNT");
846         require(_whitelist[msg.sender] != true, "No whitelist");
847         _safeMint(msg.sender, quantity);
848         _whitelist[msg.sender] = true;
849     }
850 
851     function teamAllocationMint(address _address, uint256 quantity) external onlyOwner {
852           _safeMint(_address, quantity);
853     }
854 
855     function _baseURI() internal view virtual override returns (string memory) {
856         return _baseTokenURI;
857     }
858 
859     function setPrice(uint256 _PriceInWEI) external onlyOwner {
860         price = _PriceInWEI;
861     }
862 
863     function setRoot(bytes32 _root) external onlyOwner {
864         root = _root;
865     }
866 
867     function flipPublicSaleState() external onlyOwner {
868         publicSale = !publicSale;
869     }
870 
871     function flipWhitelistState() external onlyOwner {
872         whitelistSale = !whitelistSale;
873     }
874 
875     function setBaseURI(string calldata baseURI) external onlyOwner {
876         _baseTokenURI = baseURI;
877     }
878 
879     function withdraw() external onlyOwner {
880         payable(msg.sender).transfer(address(this).balance);
881     }
882 }