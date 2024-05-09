1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 pragma solidity ^0.8.0;
10 
11 interface IERC721Receiver {
12     function onERC721Received(
13         address operator,
14         address from,
15         uint256 tokenId,
16         bytes calldata data
17     ) external returns (bytes4);
18 }
19 
20 pragma solidity ^0.8.0;
21 
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
38 
39     function balanceOf(address owner) external view returns (uint256 balance);
40 
41     function ownerOf(uint256 tokenId) external view returns (address owner);
42 
43     function safeTransferFrom(
44         address from,
45         address to,
46         uint256 tokenId
47     ) external;
48 
49     function transferFrom(
50         address from,
51         address to,
52         uint256 tokenId
53     ) external;
54 
55     function approve(address to, uint256 tokenId) external;
56 
57     function getApproved(uint256 tokenId)
58         external
59         view
60         returns (address operator);
61 
62     function setApprovalForAll(address operator, bool _approved) external;
63 
64     function isApprovedForAll(address owner, address operator)
65         external
66         view
67         returns (bool);
68 
69     function safeTransferFrom(
70         address from,
71         address to,
72         uint256 tokenId,
73         bytes calldata data
74     ) external;
75 }
76 
77 pragma solidity ^0.8.0;
78 
79 interface IERC721Metadata is IERC721 {
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function tokenURI(uint256 tokenId) external view returns (string memory);
85 }
86 
87 pragma solidity ^0.8.0;
88 
89 interface IERC721Enumerable is IERC721 {
90     function totalSupply() external view returns (uint256);
91 
92     function tokenOfOwnerByIndex(address owner, uint256 index)
93         external
94         view
95         returns (uint256);
96 
97     function tokenByIndex(uint256 index) external view returns (uint256);
98 }
99 
100 pragma solidity ^0.8.1;
101 
102 library Address {
103     function isContract(address account) internal view returns (bool) {
104         return account.code.length > 0;
105     }
106 
107     function sendValue(address payable recipient, uint256 amount) internal {
108         require(
109             address(this).balance >= amount,
110             "Address: insufficient balance"
111         );
112 
113         (bool success, ) = recipient.call{value: amount}("");
114         require(
115             success,
116             "Address: unable to send value, recipient may have reverted"
117         );
118     }
119 
120     function functionCall(address target, bytes memory data)
121         internal
122         returns (bytes memory)
123     {
124         return functionCall(target, data, "Address: low-level call failed");
125     }
126 
127     function functionCall(
128         address target,
129         bytes memory data,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value
139     ) internal returns (bytes memory) {
140         return
141             functionCallWithValue(
142                 target,
143                 data,
144                 value,
145                 "Address: low-level call with value failed"
146             );
147     }
148 
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(
156             address(this).balance >= value,
157             "Address: insufficient balance for call"
158         );
159         require(isContract(target), "Address: call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.call{value: value}(
162             data
163         );
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     function functionStaticCall(address target, bytes memory data)
168         internal
169         view
170         returns (bytes memory)
171     {
172         return
173             functionStaticCall(
174                 target,
175                 data,
176                 "Address: low-level static call failed"
177             );
178     }
179 
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     function functionDelegateCall(address target, bytes memory data)
192         internal
193         returns (bytes memory)
194     {
195         return
196             functionDelegateCall(
197                 target,
198                 data,
199                 "Address: low-level delegate call failed"
200             );
201     }
202 
203     function functionDelegateCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     function verifyCallResult(
215         bool success,
216         bytes memory returndata,
217         string memory errorMessage
218     ) internal pure returns (bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             if (returndata.length > 0) {
223                 assembly {
224                     let returndata_size := mload(returndata)
225                     revert(add(32, returndata), returndata_size)
226                 }
227             } else {
228                 revert(errorMessage);
229             }
230         }
231     }
232 }
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
235 pragma solidity ^0.8.0;
236 
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(
253         address indexed previousOwner,
254         address indexed newOwner
255     );
256 
257     constructor() {
258         _setOwner(_msgSender());
259     }
260 
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     modifier onlyOwner() {
266         require(owner() == _msgSender(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270     function renounceOwnership() public virtual onlyOwner {
271         _setOwner(address(0));
272     }
273 
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(
276             newOwner != address(0),
277             "Ownable: new owner is the zero address"
278         );
279         _setOwner(newOwner);
280     }
281 
282     function _setOwner(address newOwner) private {
283         address oldOwner = _owner;
284         _owner = newOwner;
285         emit OwnershipTransferred(oldOwner, newOwner);
286     }
287 }
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
290 pragma solidity ^0.8.0;
291 
292 library Strings {
293     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
294 
295     function toString(uint256 value) internal pure returns (string memory) {
296         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
297 
298         if (value == 0) {
299             return "0";
300         }
301         uint256 temp = value;
302         uint256 digits;
303         while (temp != 0) {
304             digits++;
305             temp /= 10;
306         }
307         bytes memory buffer = new bytes(digits);
308         while (value != 0) {
309             digits -= 1;
310             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
311             value /= 10;
312         }
313         return string(buffer);
314     }
315 
316     function toHexString(uint256 value) internal pure returns (string memory) {
317         if (value == 0) {
318             return "0x00";
319         }
320         uint256 temp = value;
321         uint256 length = 0;
322         while (temp != 0) {
323             length++;
324             temp >>= 8;
325         }
326         return toHexString(value, length);
327     }
328 
329     function toHexString(uint256 value, uint256 length)
330         internal
331         pure
332         returns (string memory)
333     {
334         bytes memory buffer = new bytes(2 * length + 2);
335         buffer[0] = "0";
336         buffer[1] = "x";
337         for (uint256 i = 2 * length + 1; i > 1; --i) {
338             buffer[i] = _HEX_SYMBOLS[value & 0xf];
339             value >>= 4;
340         }
341         require(value == 0, "Strings: hex length insufficient");
342         return string(buffer);
343     }
344 }
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
347 pragma solidity ^0.8.0;
348 
349 abstract contract ERC165 is IERC165 {
350     function supportsInterface(bytes4 interfaceId)
351         public
352         view
353         virtual
354         override
355         returns (bool)
356     {
357         return interfaceId == type(IERC165).interfaceId;
358     }
359 }
360 
361 pragma solidity ^0.8.0;
362 
363 abstract contract ReentrancyGuard {
364     // word because each write operation emits an extra SLOAD to first read the
365     // back. This is the compiler's defense against contract upgrades and
366 
367     // but in exchange the refund on every call to nonReentrant will be lower in
368     // transaction's gas, it is best to keep them low in cases like this one, to
369     uint256 private constant _NOT_ENTERED = 1;
370     uint256 private constant _ENTERED = 2;
371 
372     uint256 private _status;
373 
374     constructor() {
375         _status = _NOT_ENTERED;
376     }
377 
378     modifier nonReentrant() {
379         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
380         _status = _ENTERED;
381 
382         _;
383         // https://eips.ethereum.org/EIPS/eip-2200)
384         _status = _NOT_ENTERED;
385     }
386 }
387 
388 pragma solidity ^0.8.0;
389 
390 contract ERC721A is
391     Context,
392     ERC165,
393     IERC721,
394     IERC721Metadata,
395     IERC721Enumerable
396 {
397     using Address for address;
398     using Strings for uint256;
399 
400     struct TokenOwnership {
401         address addr;
402         uint64 startTimestamp;
403     }
404 
405     struct AddressData {
406         uint128 balance;
407         uint128 numberMinted;
408     }
409 
410     uint256 private currentIndex = 0;
411 
412     uint256 internal immutable collectionSize;
413     uint256 internal immutable maxBatchSize;
414     string private _name;
415     string private _symbol;
416     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
417     mapping(uint256 => TokenOwnership) private _ownerships;
418     mapping(address => AddressData) private _addressData;
419     mapping(uint256 => address) private _tokenApprovals;
420     mapping(address => mapping(address => bool)) private _operatorApprovals;
421 
422     constructor(
423         string memory name_,
424         string memory symbol_,
425         uint256 maxBatchSize_,
426         uint256 collectionSize_
427     ) {
428         require(
429             collectionSize_ > 0,
430             "ERC721A: collection must have a nonzero supply"
431         );
432         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
433         _name = name_;
434         _symbol = symbol_;
435         maxBatchSize = maxBatchSize_;
436         collectionSize = collectionSize_;
437     }
438 
439     function totalSupply() public view override returns (uint256) {
440         return currentIndex;
441     }
442 
443     function tokenByIndex(uint256 index)
444         public
445         view
446         override
447         returns (uint256)
448     {
449         require(index < totalSupply(), "ERC721A: global index out of bounds");
450         return index;
451     }
452 
453     function tokenOfOwnerByIndex(address owner, uint256 index)
454         public
455         view
456         override
457         returns (uint256)
458     {
459         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
460         uint256 numMintedSoFar = totalSupply();
461         uint256 tokenIdsIdx = 0;
462         address currOwnershipAddr = address(0);
463         for (uint256 i = 0; i < numMintedSoFar; i++) {
464             TokenOwnership memory ownership = _ownerships[i];
465             if (ownership.addr != address(0)) {
466                 currOwnershipAddr = ownership.addr;
467             }
468             if (currOwnershipAddr == owner) {
469                 if (tokenIdsIdx == index) {
470                     return i;
471                 }
472                 tokenIdsIdx++;
473             }
474         }
475         revert("ERC721A: unable to get token of owner by index");
476     }
477 
478     function supportsInterface(bytes4 interfaceId)
479         public
480         view
481         virtual
482         override(ERC165, IERC165)
483         returns (bool)
484     {
485         return
486             interfaceId == type(IERC721).interfaceId ||
487             interfaceId == type(IERC721Metadata).interfaceId ||
488             interfaceId == type(IERC721Enumerable).interfaceId ||
489             super.supportsInterface(interfaceId);
490     }
491 
492     function balanceOf(address owner) public view override returns (uint256) {
493         require(
494             owner != address(0),
495             "ERC721A: balance query for the zero address"
496         );
497         return uint256(_addressData[owner].balance);
498     }
499 
500     function _numberMinted(address owner) internal view returns (uint256) {
501         require(
502             owner != address(0),
503             "ERC721A: number minted query for the zero address"
504         );
505         return uint256(_addressData[owner].numberMinted);
506     }
507 
508     function ownershipOf(uint256 tokenId)
509         internal
510         view
511         returns (TokenOwnership memory)
512     {
513         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
514 
515         uint256 lowestTokenToCheck;
516         if (tokenId >= maxBatchSize) {
517             lowestTokenToCheck = tokenId - maxBatchSize + 1;
518         }
519 
520         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
521             TokenOwnership memory ownership = _ownerships[curr];
522             if (ownership.addr != address(0)) {
523                 return ownership;
524             }
525         }
526 
527         revert("ERC721A: unable to determine the owner of token");
528     }
529 
530     function ownerOf(uint256 tokenId) public view override returns (address) {
531         return ownershipOf(tokenId).addr;
532     }
533 
534     function name() public view virtual override returns (string memory) {
535         return _name;
536     }
537 
538     function symbol() public view virtual override returns (string memory) {
539         return _symbol;
540     }
541 
542     function tokenURI(uint256 tokenId)
543         public
544         view
545         virtual
546         override
547         returns (string memory)
548     {
549         require(
550             _exists(tokenId),
551             "ERC721Metadata: URI query for nonexistent token"
552         );
553 
554         string memory baseURI = _baseURI();
555         return
556             bytes(baseURI).length > 0
557                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
558                 : "";
559     }
560 
561     function _baseURI() internal view virtual returns (string memory) {
562         return "";
563     }
564 
565     function approve(address to, uint256 tokenId) public override {
566         address owner = ERC721A.ownerOf(tokenId);
567         require(to != owner, "ERC721A: approval to current owner");
568 
569         require(
570             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
571             "ERC721A: approve caller is not owner nor approved for all"
572         );
573 
574         _approve(to, tokenId, owner);
575     }
576 
577     function getApproved(uint256 tokenId)
578         public
579         view
580         override
581         returns (address)
582     {
583         require(
584             _exists(tokenId),
585             "ERC721A: approved query for nonexistent token"
586         );
587 
588         return _tokenApprovals[tokenId];
589     }
590 
591     function setApprovalForAll(address operator, bool approved)
592         public
593         override
594     {
595         require(operator != _msgSender(), "ERC721A: approve to caller");
596 
597         _operatorApprovals[_msgSender()][operator] = approved;
598         emit ApprovalForAll(_msgSender(), operator, approved);
599     }
600 
601     function isApprovedForAll(address owner, address operator)
602         public
603         view
604         virtual
605         override
606         returns (bool)
607     {
608         return _operatorApprovals[owner][operator];
609     }
610 
611     function transferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) public override {
616         _transfer(from, to, tokenId);
617     }
618 
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) public override {
624         safeTransferFrom(from, to, tokenId, "");
625     }
626 
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes memory _data
632     ) public override {
633         _transfer(from, to, tokenId);
634         require(
635             _checkOnERC721Received(from, to, tokenId, _data),
636             "ERC721A: transfer to non ERC721Receiver implementer"
637         );
638     }
639 
640     function _exists(uint256 tokenId) internal view returns (bool) {
641         return tokenId < currentIndex;
642     }
643 
644     function _safeMint(address to, uint256 quantity) internal {
645         _safeMint(to, quantity, "");
646     }
647 
648     function _safeMint(
649         address to,
650         uint256 quantity,
651         bytes memory _data
652     ) internal {
653         uint256 startTokenId = currentIndex;
654         require(to != address(0), "ERC721A: mint to the zero address");
655         require(!_exists(startTokenId), "ERC721A: token already minted");
656         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
657 
658         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
659 
660         AddressData memory addressData = _addressData[to];
661         _addressData[to] = AddressData(
662             addressData.balance + uint128(quantity),
663             addressData.numberMinted + uint128(quantity)
664         );
665         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
666 
667         uint256 updatedIndex = startTokenId;
668 
669         for (uint256 i = 0; i < quantity; i++) {
670             emit Transfer(address(0), to, updatedIndex);
671             require(
672                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
673                 "ERC721A: transfer to non ERC721Receiver implementer"
674             );
675             updatedIndex++;
676         }
677 
678         currentIndex = updatedIndex;
679         _afterTokenTransfers(address(0), to, startTokenId, quantity);
680     }
681 
682     function _transfer(
683         address from,
684         address to,
685         uint256 tokenId
686     ) private {
687         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
688 
689         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
690             getApproved(tokenId) == _msgSender() ||
691             isApprovedForAll(prevOwnership.addr, _msgSender()));
692 
693         require(
694             isApprovedOrOwner,
695             "ERC721A: transfer caller is not owner nor approved"
696         );
697 
698         require(
699             prevOwnership.addr == from,
700             "ERC721A: transfer from incorrect owner"
701         );
702         require(to != address(0), "ERC721A: transfer to the zero address");
703 
704         _beforeTokenTransfers(from, to, tokenId, 1);
705         _approve(address(0), tokenId, prevOwnership.addr);
706 
707         _addressData[from].balance -= 1;
708         _addressData[to].balance += 1;
709         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
710         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
711         uint256 nextTokenId = tokenId + 1;
712         if (_ownerships[nextTokenId].addr == address(0)) {
713             if (_exists(nextTokenId)) {
714                 _ownerships[nextTokenId] = TokenOwnership(
715                     prevOwnership.addr,
716                     prevOwnership.startTimestamp
717                 );
718             }
719         }
720 
721         emit Transfer(from, to, tokenId);
722         _afterTokenTransfers(from, to, tokenId, 1);
723     }
724 
725     function _approve(
726         address to,
727         uint256 tokenId,
728         address owner
729     ) private {
730         _tokenApprovals[tokenId] = to;
731         emit Approval(owner, to, tokenId);
732     }
733 
734     uint256 public nextOwnerToExplicitlySet = 0;
735 
736     function _setOwnersExplicit(uint256 quantity) internal {
737         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
738         require(quantity > 0, "quantity must be nonzero");
739         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
740         if (endIndex > collectionSize - 1) {
741             endIndex = collectionSize - 1;
742         }
743         require(_exists(endIndex), "not enough minted yet for this cleanup");
744         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
745             if (_ownerships[i].addr == address(0)) {
746                 TokenOwnership memory ownership = ownershipOf(i);
747                 _ownerships[i] = TokenOwnership(
748                     ownership.addr,
749                     ownership.startTimestamp
750                 );
751             }
752         }
753         nextOwnerToExplicitlySet = endIndex + 1;
754     }
755 
756     function _checkOnERC721Received(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) private returns (bool) {
762         if (to.isContract()) {
763             try
764                 IERC721Receiver(to).onERC721Received(
765                     _msgSender(),
766                     from,
767                     tokenId,
768                     _data
769                 )
770             returns (bytes4 retval) {
771                 return retval == IERC721Receiver(to).onERC721Received.selector;
772             } catch (bytes memory reason) {
773                 if (reason.length == 0) {
774                     revert(
775                         "ERC721A: transfer to non ERC721Receiver implementer"
776                     );
777                 } else {
778                     assembly {
779                         revert(add(32, reason), mload(reason))
780                     }
781                 }
782             }
783         } else {
784             return true;
785         }
786     }
787 
788     function _beforeTokenTransfers(
789         address from,
790         address to,
791         uint256 startTokenId,
792         uint256 quantity
793     ) internal virtual {}
794 
795     function _afterTokenTransfers(
796         address from,
797         address to,
798         uint256 startTokenId,
799         uint256 quantity
800     ) internal virtual {}
801 }
802 
803 contract BabyElephantsSquad is Ownable, ERC721A, ReentrancyGuard {
804     using Strings for uint256;
805     address public ElephantContract;
806 
807     string public uriPrefix = "";
808 
809     string public uriSuffix = ".json";
810     string public hiddenMetadataUri;
811 
812     uint256 public cost = 0.022 ether;
813     uint256 public maxSupply = 2222;
814     uint256 public maxMintAmountPerTx = 20;
815 
816     bool public publicMint = true; // By default public minting is paused
817     bool public publicClaim = true; // By default claim baby NFTs is paused
818     bool public revealed = false; //  By default NFTs is in hidden state
819 
820     mapping(uint256 => bool) public claimedBabyElephant;
821 
822     constructor(address _contract) ERC721A("Baby Elephants Squad", "BES", 1000, maxSupply) {
823         ElephantContract = _contract; // Epic Elephant Squad Contract Address
824     }
825 
826     modifier mintCompliance(uint256 _mintAmount) {
827         require(
828             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
829             "Invalid mint amount!"
830         );
831         require(
832             totalSupply() + _mintAmount <= maxSupply,
833             "Max supply exceeded!"
834         );
835         _;
836     }
837 
838     function mint(uint256 _mintAmount)
839         public
840         payable
841         mintCompliance(_mintAmount)
842     {
843         require(!publicMint, "The contract is paused!");
844         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
845         _safeMint(msg.sender, _mintAmount);
846     }
847 
848     function claimBabyElephant()
849         public
850     {
851         require(!publicClaim, "The contract is paused!");
852         uint256 elephantsOwned = IERC721(ElephantContract).balanceOf(msg.sender);
853         require(elephantsOwned > 0, "No Elephants owned!");
854 
855         uint256 claimAmount = 0;
856         uint256 lastClaimableToken = 0;
857         for (uint256 i = 0; i < elephantsOwned; i++) {
858             uint256 tokenId = IERC721Enumerable(ElephantContract).tokenOfOwnerByIndex(msg.sender, i);
859             if (!claimedBabyElephant[tokenId]) { 
860                 claimAmount++;
861                 claimedBabyElephant[tokenId] = true;
862                 lastClaimableToken = tokenId;
863             }
864         }
865 
866         if (claimAmount % 2 == 1) {
867             claimAmount--;
868             delete claimedBabyElephant[lastClaimableToken];
869         }
870 
871         require(claimAmount > 0, "No reedemable Elephants!");
872         _safeMint(msg.sender, claimAmount / 2);
873     }
874 
875     function claimableElephantsCount(address _owner)
876         public
877         view
878         returns (uint256)
879     {
880         uint256 elephantsOwned = IERC721(ElephantContract).balanceOf(_owner);
881 
882         uint256 claimAmount = 0;
883         uint256 lastClaimableToken = 0;
884         for (uint256 i = 0; i < elephantsOwned; i++) {
885             uint256 tokenId = IERC721Enumerable(ElephantContract).tokenOfOwnerByIndex(_owner, i);
886             if (!claimedBabyElephant[tokenId]) { 
887                 claimAmount++;
888                 lastClaimableToken = tokenId;
889             }
890         }
891 
892         if (claimAmount % 2 == 1) {
893             claimAmount--;
894         }
895 
896         return (claimAmount / 2);
897     }
898 
899     function getOwnershipData(uint256 tokenId)
900         external
901         view
902         returns (TokenOwnership memory)
903     {
904         return ownershipOf(tokenId);
905     }
906 
907     function mintForAddress(address _address, uint256 quantity)
908         external
909         onlyOwner
910     {
911         require(
912             totalSupply() + quantity <= maxSupply,
913             "NOT_ENOUGH_SUPPLY_TO_GIVEAWAY_DESIRED_AMOUNT"
914         );
915         _safeMint(_address, quantity);
916     }
917 
918     function walletOfOwner(address _owner)
919         public
920         view
921         returns (uint256[] memory)
922     {
923         uint256 ownerTokenCount = balanceOf(_owner);
924         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
925         uint256 currentTokenId = 1;
926         uint256 ownedTokenIndex = 0;
927 
928         while (
929             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
930         ) {
931             address currentTokenOwner = ownerOf(currentTokenId);
932 
933             if (currentTokenOwner == _owner) {
934                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
935 
936                 ownedTokenIndex++;
937             }
938 
939             currentTokenId++;
940         }
941 
942         return ownedTokenIds;
943     }
944 
945     function tokenURI(uint256 _tokenId)
946         public
947         view
948         virtual
949         override
950         returns (string memory)
951     {
952         require(
953             _exists(_tokenId),
954             "ERC721Metadata: URI query for nonexistent token"
955         );
956 
957         if (revealed == false) {
958             return hiddenMetadataUri;
959         }
960 
961         string memory currentBaseURI = _baseURI();
962         return
963             bytes(currentBaseURI).length > 0
964                 ? string(
965                     abi.encodePacked(
966                         currentBaseURI,
967                         _tokenId.toString(),
968                         uriSuffix
969                     )
970                 )
971                 : "";
972     }
973 
974     function setRevealed() public onlyOwner {
975         revealed = !revealed;
976     }
977 
978     function setCost(uint256 _cost) public onlyOwner {
979         cost = _cost;
980     }
981 
982     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
983         public
984         onlyOwner
985     {
986         maxMintAmountPerTx = _maxMintAmountPerTx;
987     }
988 
989     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
990         public
991         onlyOwner
992     {
993         hiddenMetadataUri = _hiddenMetadataUri;
994     }
995 
996     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
997         uriPrefix = _uriPrefix;
998     }
999 
1000     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1001         uriSuffix = _uriSuffix;
1002     }
1003 
1004     function setPublicMint() public onlyOwner {
1005         publicMint = !publicMint;
1006     }
1007 
1008     function setPublicClaim() public onlyOwner {
1009         publicClaim = !publicClaim;
1010     }
1011 
1012     function setElephantContract(address _address) public onlyOwner {
1013         ElephantContract = _address;
1014     }
1015 
1016     function _baseURI() internal view virtual override returns (string memory) {
1017         return uriPrefix;
1018     }
1019 
1020     function withdraw() external onlyOwner {
1021         payable(msg.sender).transfer(address(this).balance);
1022     }
1023 }