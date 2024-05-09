1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 interface IERC165 {
4     function supportsInterface(bytes4 interfaceId) external view returns (bool);
5 }
6 pragma solidity ^0.8.0;
7 interface IERC721Receiver {
8     function onERC721Received(
9         address operator,
10         address from,
11         uint256 tokenId,
12         bytes calldata data
13     ) external returns (bytes4);
14 }
15 pragma solidity ^0.8.0;
16 interface IERC721 is IERC165 {
17     event Transfer(
18         address indexed from,
19         address indexed to,
20         uint256 indexed tokenId
21     );
22     event Approval(
23         address indexed owner,
24         address indexed approved,
25         uint256 indexed tokenId
26     );
27     event ApprovalForAll(
28         address indexed owner,
29         address indexed operator,
30         bool approved
31     );
32     function balanceOf(address owner) external view returns (uint256 balance);
33     function ownerOf(uint256 tokenId) external view returns (address owner);
34     function safeTransferFrom(
35         address from,
36         address to,
37         uint256 tokenId
38     ) external;
39     function transferFrom(
40         address from,
41         address to,
42         uint256 tokenId
43     ) external;
44     function approve(address to, uint256 tokenId) external;
45     function getApproved(uint256 tokenId)
46         external
47         view
48         returns (address operator);
49     function setApprovalForAll(address operator, bool _approved) external;
50     function isApprovedForAll(address owner, address operator)
51         external
52         view
53         returns (bool);
54     function safeTransferFrom(
55         address from,
56         address to,
57         uint256 tokenId,
58         bytes calldata data
59     ) external;
60 }
61 pragma solidity ^0.8.0;
62 interface IERC721Metadata is IERC721 {
63     function name() external view returns (string memory);
64     function symbol() external view returns (string memory);
65     function tokenURI(uint256 tokenId) external view returns (string memory);
66 }
67 pragma solidity ^0.8.0;
68 interface IERC721Enumerable is IERC721 {
69     function totalSupply() external view returns (uint256);
70     function tokenOfOwnerByIndex(address owner, uint256 index)
71         external
72         view
73         returns (uint256);
74     function tokenByIndex(uint256 index) external view returns (uint256);
75 }
76 pragma solidity ^0.8.1;
77 library Address {
78     function isContract(address account) internal view returns (bool) {
79 
80         return account.code.length > 0;
81     }
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(
84             address(this).balance >= amount,
85             "Address: insufficient balance"
86         );
87 
88         (bool success, ) = recipient.call{value: amount}("");
89         require(
90             success,
91             "Address: unable to send value, recipient may have reverted"
92         );
93     }
94     function functionCall(address target, bytes memory data)
95         internal
96         returns (bytes memory)
97     {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107     function functionCallWithValue(
108         address target,
109         bytes memory data,
110         uint256 value
111     ) internal returns (bytes memory) {
112         return
113             functionCallWithValue(
114                 target,
115                 data,
116                 value,
117                 "Address: low-level call with value failed"
118             );
119     }
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value,
124         string memory errorMessage
125     ) internal returns (bytes memory) {
126         require(
127             address(this).balance >= value,
128             "Address: insufficient balance for call"
129         );
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(
133             data
134         );
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137     function functionStaticCall(address target, bytes memory data)
138         internal
139         view
140         returns (bytes memory)
141     {
142         return
143             functionStaticCall(
144                 target,
145                 data,
146                 "Address: low-level static call failed"
147             );
148     }
149     function functionStaticCall(
150         address target,
151         bytes memory data,
152         string memory errorMessage
153     ) internal view returns (bytes memory) {
154         require(isContract(target), "Address: static call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.staticcall(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     }
159     function functionDelegateCall(address target, bytes memory data)
160         internal
161         returns (bytes memory)
162     {
163         return
164             functionDelegateCall(
165                 target,
166                 data,
167                 "Address: low-level delegate call failed"
168             );
169     }
170     function functionDelegateCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal returns (bytes memory) {
175         require(isContract(target), "Address: delegate call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.delegatecall(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180     function verifyCallResult(
181         bool success,
182         bytes memory returndata,
183         string memory errorMessage
184     ) internal pure returns (bytes memory) {
185         if (success) {
186             return returndata;
187         } else {
188             if (returndata.length > 0) {
189 
190                 assembly {
191                     let returndata_size := mload(returndata)
192                     revert(add(32, returndata), returndata_size)
193                 }
194             } else {
195                 revert(errorMessage);
196             }
197         }
198     }
199 }
200 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
211 
212 pragma solidity ^0.8.0;
213 
214 abstract contract Ownable is Context {
215     address private _owner;
216 
217     event OwnershipTransferred(
218         address indexed previousOwner,
219         address indexed newOwner
220     );
221     constructor() {
222         _setOwner(_msgSender());
223     }
224     function owner() public view virtual returns (address) {
225         return _owner;
226     }
227     modifier onlyOwner() {
228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
229         _;
230     }
231     function renounceOwnership() public virtual onlyOwner {
232         _setOwner(address(0));
233     }
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(
236             newOwner != address(0),
237             "Ownable: new owner is the zero address"
238         );
239         _setOwner(newOwner);
240     }
241 
242     function _setOwner(address newOwner) private {
243         address oldOwner = _owner;
244         _owner = newOwner;
245         emit OwnershipTransferred(oldOwner, newOwner);
246     }
247 }
248 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
249 pragma solidity ^0.8.0;
250 library Strings {
251     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
252     function toString(uint256 value) internal pure returns (string memory) {
253         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
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
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
301 pragma solidity ^0.8.0;
302 abstract contract ERC165 is IERC165 {
303     function supportsInterface(bytes4 interfaceId)
304         public
305         view
306         virtual
307         override
308         returns (bool)
309     {
310         return interfaceId == type(IERC165).interfaceId;
311     }
312 }
313 
314 pragma solidity ^0.8.0;
315 
316 abstract contract ReentrancyGuard {
317     // word because each write operation emits an extra SLOAD to first read the
318     // back. This is the compiler's defense against contract upgrades and
319 
320     // but in exchange the refund on every call to nonReentrant will be lower in
321     // transaction's gas, it is best to keep them low in cases like this one, to
322     uint256 private constant _NOT_ENTERED = 1;
323     uint256 private constant _ENTERED = 2;
324 
325     uint256 private _status;
326 
327     constructor() {
328         _status = _NOT_ENTERED;
329     }
330     modifier nonReentrant() {
331         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
332         _status = _ENTERED;
333 
334         _;
335         // https://eips.ethereum.org/EIPS/eip-2200)
336         _status = _NOT_ENTERED;
337     }
338 }
339 
340 pragma solidity ^0.8.0;
341 contract ERC721A is
342     Context,
343     ERC165,
344     IERC721,
345     IERC721Metadata,
346     IERC721Enumerable
347 {
348     using Address for address;
349     using Strings for uint256;
350 
351     struct TokenOwnership {
352         address addr;
353         uint64 startTimestamp;
354     }
355 
356     struct AddressData {
357         uint128 balance;
358         uint128 numberMinted;
359     }
360 
361     uint256 private currentIndex = 0;
362 
363     uint256 internal immutable collectionSize;
364     uint256 internal immutable maxBatchSize;
365     string private _name;
366     string private _symbol;
367     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
368     mapping(uint256 => TokenOwnership) private _ownerships;
369     mapping(address => AddressData) private _addressData;
370     mapping(uint256 => address) private _tokenApprovals;
371     mapping(address => mapping(address => bool)) private _operatorApprovals;
372     constructor(
373         string memory name_,
374         string memory symbol_,
375         uint256 maxBatchSize_,
376         uint256 collectionSize_
377     ) {
378         require(
379             collectionSize_ > 0,
380             "ERC721A: collection must have a nonzero supply"
381         );
382         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
383         _name = name_;
384         _symbol = symbol_;
385         maxBatchSize = maxBatchSize_;
386         collectionSize = collectionSize_;
387     }
388     function totalSupply() public view override returns (uint256) {
389         return currentIndex;
390     }
391     function tokenByIndex(uint256 index)
392         public
393         view
394         override
395         returns (uint256)
396     {
397         require(index < totalSupply(), "ERC721A: global index out of bounds");
398         return index;
399     }
400     function tokenOfOwnerByIndex(address owner, uint256 index)
401         public
402         view
403         override
404         returns (uint256)
405     {
406         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
407         uint256 numMintedSoFar = totalSupply();
408         uint256 tokenIdsIdx = 0;
409         address currOwnershipAddr = address(0);
410         for (uint256 i = 0; i < numMintedSoFar; i++) {
411             TokenOwnership memory ownership = _ownerships[i];
412             if (ownership.addr != address(0)) {
413                 currOwnershipAddr = ownership.addr;
414             }
415             if (currOwnershipAddr == owner) {
416                 if (tokenIdsIdx == index) {
417                     return i;
418                 }
419                 tokenIdsIdx++;
420             }
421         }
422         revert("ERC721A: unable to get token of owner by index");
423     }
424     function supportsInterface(bytes4 interfaceId)
425         public
426         view
427         virtual
428         override(ERC165, IERC165)
429         returns (bool)
430     {
431         return
432             interfaceId == type(IERC721).interfaceId ||
433             interfaceId == type(IERC721Metadata).interfaceId ||
434             interfaceId == type(IERC721Enumerable).interfaceId ||
435             super.supportsInterface(interfaceId);
436     }
437     function balanceOf(address owner) public view override returns (uint256) {
438         require(
439             owner != address(0),
440             "ERC721A: balance query for the zero address"
441         );
442         return uint256(_addressData[owner].balance);
443     }
444 
445     function _numberMinted(address owner) internal view returns (uint256) {
446         require(
447             owner != address(0),
448             "ERC721A: number minted query for the zero address"
449         );
450         return uint256(_addressData[owner].numberMinted);
451     }
452 
453     function ownershipOf(uint256 tokenId)
454         internal
455         view
456         returns (TokenOwnership memory)
457     {
458         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
459 
460         uint256 lowestTokenToCheck;
461         if (tokenId >= maxBatchSize) {
462             lowestTokenToCheck = tokenId - maxBatchSize + 1;
463         }
464 
465         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
466             TokenOwnership memory ownership = _ownerships[curr];
467             if (ownership.addr != address(0)) {
468                 return ownership;
469             }
470         }
471 
472         revert("ERC721A: unable to determine the owner of token");
473     }
474     function ownerOf(uint256 tokenId) public view override returns (address) {
475         return ownershipOf(tokenId).addr;
476     }
477     function name() public view virtual override returns (string memory) {
478         return _name;
479     }
480     function symbol() public view virtual override returns (string memory) {
481         return _symbol;
482     }
483     function tokenURI(uint256 tokenId)
484         public
485         view
486         virtual
487         override
488         returns (string memory)
489     {
490         require(
491             _exists(tokenId),
492             "ERC721Metadata: URI query for nonexistent token"
493         );
494 
495         string memory baseURI = _baseURI();
496         return
497             bytes(baseURI).length > 0
498                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
499                 : "";
500     }
501     function _baseURI() internal view virtual returns (string memory) {
502         return "";
503     }
504     function approve(address to, uint256 tokenId) public override {
505         address owner = ERC721A.ownerOf(tokenId);
506         require(to != owner, "ERC721A: approval to current owner");
507 
508         require(
509             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
510             "ERC721A: approve caller is not owner nor approved for all"
511         );
512 
513         _approve(to, tokenId, owner);
514     }
515     function getApproved(uint256 tokenId)
516         public
517         view
518         override
519         returns (address)
520     {
521         require(
522             _exists(tokenId),
523             "ERC721A: approved query for nonexistent token"
524         );
525 
526         return _tokenApprovals[tokenId];
527     }
528     function setApprovalForAll(address operator, bool approved)
529         public
530         override
531     {
532         require(operator != _msgSender(), "ERC721A: approve to caller");
533 
534         _operatorApprovals[_msgSender()][operator] = approved;
535         emit ApprovalForAll(_msgSender(), operator, approved);
536     }
537     function isApprovedForAll(address owner, address operator)
538         public
539         view
540         virtual
541         override
542         returns (bool)
543     {
544         return _operatorApprovals[owner][operator];
545     }
546     function transferFrom(
547         address from,
548         address to,
549         uint256 tokenId
550     ) public override {
551         _transfer(from, to, tokenId);
552     }
553     function safeTransferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) public override {
558         safeTransferFrom(from, to, tokenId, "");
559     }
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes memory _data
565     ) public override {
566         _transfer(from, to, tokenId);
567         require(
568             _checkOnERC721Received(from, to, tokenId, _data),
569             "ERC721A: transfer to non ERC721Receiver implementer"
570         );
571     }
572     function _exists(uint256 tokenId) internal view returns (bool) {
573         return tokenId < currentIndex;
574     }
575 
576     function _safeMint(address to, uint256 quantity) internal {
577         _safeMint(to, quantity, "");
578     }
579     function _safeMint(
580         address to,
581         uint256 quantity,
582         bytes memory _data
583     ) internal {
584         uint256 startTokenId = currentIndex;
585         require(to != address(0), "ERC721A: mint to the zero address");
586         require(!_exists(startTokenId), "ERC721A: token already minted");
587         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
588 
589         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
590 
591         AddressData memory addressData = _addressData[to];
592         _addressData[to] = AddressData(
593             addressData.balance + uint128(quantity),
594             addressData.numberMinted + uint128(quantity)
595         );
596         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
597 
598         uint256 updatedIndex = startTokenId;
599 
600         for (uint256 i = 0; i < quantity; i++) {
601             emit Transfer(address(0), to, updatedIndex);
602             require(
603                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
604                 "ERC721A: transfer to non ERC721Receiver implementer"
605             );
606             updatedIndex++;
607         }
608 
609         currentIndex = updatedIndex;
610         _afterTokenTransfers(address(0), to, startTokenId, quantity);
611     }
612     function _transfer(
613         address from,
614         address to,
615         uint256 tokenId
616     ) private {
617         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
618 
619         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
620             getApproved(tokenId) == _msgSender() ||
621             isApprovedForAll(prevOwnership.addr, _msgSender()));
622 
623         require(
624             isApprovedOrOwner,
625             "ERC721A: transfer caller is not owner nor approved"
626         );
627 
628         require(
629             prevOwnership.addr == from,
630             "ERC721A: transfer from incorrect owner"
631         );
632         require(to != address(0), "ERC721A: transfer to the zero address");
633 
634         _beforeTokenTransfers(from, to, tokenId, 1);
635         _approve(address(0), tokenId, prevOwnership.addr);
636 
637         _addressData[from].balance -= 1;
638         _addressData[to].balance += 1;
639         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
640         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
641         uint256 nextTokenId = tokenId + 1;
642         if (_ownerships[nextTokenId].addr == address(0)) {
643             if (_exists(nextTokenId)) {
644                 _ownerships[nextTokenId] = TokenOwnership(
645                     prevOwnership.addr,
646                     prevOwnership.startTimestamp
647                 );
648             }
649         }
650 
651         emit Transfer(from, to, tokenId);
652         _afterTokenTransfers(from, to, tokenId, 1);
653     }
654     function _approve(
655         address to,
656         uint256 tokenId,
657         address owner
658     ) private {
659         _tokenApprovals[tokenId] = to;
660         emit Approval(owner, to, tokenId);
661     }
662 
663     uint256 public nextOwnerToExplicitlySet = 0;
664     function _setOwnersExplicit(uint256 quantity) internal {
665         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
666         require(quantity > 0, "quantity must be nonzero");
667         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
668         if (endIndex > collectionSize - 1) {
669             endIndex = collectionSize - 1;
670         }
671         require(_exists(endIndex), "not enough minted yet for this cleanup");
672         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
673             if (_ownerships[i].addr == address(0)) {
674                 TokenOwnership memory ownership = ownershipOf(i);
675                 _ownerships[i] = TokenOwnership(
676                     ownership.addr,
677                     ownership.startTimestamp
678                 );
679             }
680         }
681         nextOwnerToExplicitlySet = endIndex + 1;
682     }
683     function _checkOnERC721Received(
684         address from,
685         address to,
686         uint256 tokenId,
687         bytes memory _data
688     ) private returns (bool) {
689         if (to.isContract()) {
690             try
691                 IERC721Receiver(to).onERC721Received(
692                     _msgSender(),
693                     from,
694                     tokenId,
695                     _data
696                 )
697             returns (bytes4 retval) {
698                 return retval == IERC721Receiver(to).onERC721Received.selector;
699             } catch (bytes memory reason) {
700                 if (reason.length == 0) {
701                     revert(
702                         "ERC721A: transfer to non ERC721Receiver implementer"
703                     );
704                 } else {
705                     assembly {
706                         revert(add(32, reason), mload(reason))
707                     }
708                 }
709             }
710         } else {
711             return true;
712         }
713     }
714     function _beforeTokenTransfers(
715         address from,
716         address to,
717         uint256 startTokenId,
718         uint256 quantity
719     ) internal virtual {}
720     function _afterTokenTransfers(
721         address from,
722         address to,
723         uint256 startTokenId,
724         uint256 quantity
725     ) internal virtual {}
726 }
727 
728 pragma solidity ^0.8.0;
729 contract TheCelebrities is Ownable, ERC721A, ReentrancyGuard {
730     bool public claimActive = false;
731     bool public revealed = false;
732     uint256 public maxToken = 5000;
733     string private _baseTokenURI = "ipfs://revealed/";
734     string public notRevealedUri = "ipfs://notrevealed/";
735     mapping(address => bool) public isClaimed;
736     bytes32 root;
737 
738     constructor(string memory _NAME, string memory _SYMBOL) ERC721A(_NAME, _SYMBOL, 250, maxToken){
739     }
740 
741     modifier callerIsUser() {
742         require(tx.origin == msg.sender, "CONTRACT_CANNOT_CALL_THIS");
743         _;
744     }
745 
746     function numberMinted(address owner) public view returns (uint256) {
747         return _numberMinted(owner);
748     }
749 
750     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
751         return ownershipOf(tokenId);
752     }
753 
754     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
755         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
756         if (revealed == false) {
757             return notRevealedUri;
758         }
759         string memory _tokenURI = super.tokenURI(tokenId);
760         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
761     }
762 
763     function _leafFromAddressAndNumTokens(address _a, uint256 _n) private pure returns (bytes32){
764         return keccak256(abi.encodePacked(_a, _n));
765     }
766 
767     function _checkProof(bytes32[] calldata proof, bytes32 _hash) private view returns (bool) {
768         bytes32 el;
769         bytes32 h = _hash;
770         for (uint256 i = 0; i < proof.length; i += 1) {
771             el = proof[i];
772             if (h < el) {
773                 h = keccak256(abi.encodePacked(h, el));
774             } else {
775                 h = keccak256(abi.encodePacked(el, h));
776             }
777         }
778         return h == root;
779     }
780 
781     function mint(uint256 _quantity, bytes32[] calldata _proof) external payable callerIsUser {
782         require(claimActive, "CLAIM_NOT_YET_ACTIVE");
783         require(isClaimed[msg.sender] != true, "CLAIMED_ALREADY");
784         require(_quantity > 0, "INVALID_QUANTITY");
785         require(_checkProof(_proof, _leafFromAddressAndNumTokens(msg.sender, _quantity)), "WRONG_PROOF");
786         isClaimed[msg.sender] = true;
787         _safeMint(msg.sender, _quantity);
788     }
789 
790     function teamAllocationMint(address _address, uint256 quantity) external onlyOwner {
791         require(totalSupply() + quantity <= maxToken, "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT");
792         _safeMint(_address, quantity);
793     }
794 
795     function _baseURI() internal view virtual override returns (string memory) {
796         return _baseTokenURI;
797     }
798 
799     function setRoot(bytes32 _root) external onlyOwner {
800         root = _root;
801     }
802 
803     function setBaseURI(string calldata baseURI) external onlyOwner {
804         _baseTokenURI = baseURI;
805     }
806 
807     function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
808         notRevealedUri = _notRevealedURI;
809     }
810 
811     function reveal() external onlyOwner {
812         revealed = !revealed;
813     }
814 
815     function flipClaim() external onlyOwner {
816         claimActive = !claimActive;
817     }
818 
819     function withdraw() external onlyOwner {
820         payable(msg.sender).transfer(address(this).balance);
821     }
822 }