1 // SPDX-License-Identifier: MIT
2 
3 //Developer Info:
4 //Written by Blockchainguy.net
5 //Email: info@blockchainguy.net
6 //Instagram: @sheraz.manzoor
7 
8 
9 pragma solidity ^0.8.0;
10 interface IERC165 {
11     function supportsInterface(bytes4 interfaceId) external view returns (bool);
12 }
13 pragma solidity ^0.8.0;
14 interface IERC721Receiver {
15     function onERC721Received(
16         address operator,
17         address from,
18         uint256 tokenId,
19         bytes calldata data
20     ) external returns (bytes4);
21 }
22 pragma solidity ^0.8.0;
23 interface IERC721 is IERC165 {
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 indexed tokenId
28     );
29     event Approval(
30         address indexed owner,
31         address indexed approved,
32         uint256 indexed tokenId
33     );
34     event ApprovalForAll(
35         address indexed owner,
36         address indexed operator,
37         bool approved
38     );
39     function balanceOf(address owner) external view returns (uint256 balance);
40     function ownerOf(uint256 tokenId) external view returns (address owner);
41     function safeTransferFrom(
42         address from,
43         address to,
44         uint256 tokenId
45     ) external;
46     function transferFrom(
47         address from,
48         address to,
49         uint256 tokenId
50     ) external;
51     function approve(address to, uint256 tokenId) external;
52     function getApproved(uint256 tokenId)
53         external
54         view
55         returns (address operator);
56     function setApprovalForAll(address operator, bool _approved) external;
57     function isApprovedForAll(address owner, address operator)
58         external
59         view
60         returns (bool);
61     function safeTransferFrom(
62         address from,
63         address to,
64         uint256 tokenId,
65         bytes calldata data
66     ) external;
67 }
68 pragma solidity ^0.8.0;
69 interface IERC721Metadata is IERC721 {
70     function name() external view returns (string memory);
71     function symbol() external view returns (string memory);
72     function tokenURI(uint256 tokenId) external view returns (string memory);
73 }
74 pragma solidity ^0.8.0;
75 interface IERC721Enumerable is IERC721 {
76     function totalSupply() external view returns (uint256);
77     function tokenOfOwnerByIndex(address owner, uint256 index)
78         external
79         view
80         returns (uint256);
81     function tokenByIndex(uint256 index) external view returns (uint256);
82 }
83 pragma solidity ^0.8.1;
84 library Address {
85     function isContract(address account) internal view returns (bool) {
86 
87         return account.code.length > 0;
88     }
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(
91             address(this).balance >= amount,
92             "Address: insufficient balance"
93         );
94 
95         (bool success, ) = recipient.call{value: amount}("");
96         require(
97             success,
98             "Address: unable to send value, recipient may have reverted"
99         );
100     }
101     function functionCall(address target, bytes memory data)
102         internal
103         returns (bytes memory)
104     {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114     function functionCallWithValue(
115         address target,
116         bytes memory data,
117         uint256 value
118     ) internal returns (bytes memory) {
119         return
120             functionCallWithValue(
121                 target,
122                 data,
123                 value,
124                 "Address: low-level call with value failed"
125             );
126     }
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(
134             address(this).balance >= value,
135             "Address: insufficient balance for call"
136         );
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(
140             data
141         );
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144     function functionStaticCall(address target, bytes memory data)
145         internal
146         view
147         returns (bytes memory)
148     {
149         return
150             functionStaticCall(
151                 target,
152                 data,
153                 "Address: low-level static call failed"
154             );
155     }
156     function functionStaticCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166     function functionDelegateCall(address target, bytes memory data)
167         internal
168         returns (bytes memory)
169     {
170         return
171             functionDelegateCall(
172                 target,
173                 data,
174                 "Address: low-level delegate call failed"
175             );
176     }
177     function functionDelegateCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(isContract(target), "Address: delegate call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.delegatecall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187     function verifyCallResult(
188         bool success,
189         bytes memory returndata,
190         string memory errorMessage
191     ) internal pure returns (bytes memory) {
192         if (success) {
193             return returndata;
194         } else {
195             if (returndata.length > 0) {
196 
197                 assembly {
198                     let returndata_size := mload(returndata)
199                     revert(add(32, returndata), returndata_size)
200                 }
201             } else {
202                 revert(errorMessage);
203             }
204         }
205     }
206 }
207 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
208 pragma solidity ^0.8.0;
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 pragma solidity ^0.8.0;
220 
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(
225         address indexed previousOwner,
226         address indexed newOwner
227     );
228     constructor() {
229         _setOwner(_msgSender());
230     }
231     function owner() public view virtual returns (address) {
232         return _owner;
233     }
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238     function renounceOwnership() public virtual onlyOwner {
239         _setOwner(address(0));
240     }
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(
243             newOwner != address(0),
244             "Ownable: new owner is the zero address"
245         );
246         _setOwner(newOwner);
247     }
248 
249     function _setOwner(address newOwner) private {
250         address oldOwner = _owner;
251         _owner = newOwner;
252         emit OwnershipTransferred(oldOwner, newOwner);
253     }
254 }
255 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
256 pragma solidity ^0.8.0;
257 library Strings {
258     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
259     function toString(uint256 value) internal pure returns (string memory) {
260         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
261 
262         if (value == 0) {
263             return "0";
264         }
265         uint256 temp = value;
266         uint256 digits;
267         while (temp != 0) {
268             digits++;
269             temp /= 10;
270         }
271         bytes memory buffer = new bytes(digits);
272         while (value != 0) {
273             digits -= 1;
274             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
275             value /= 10;
276         }
277         return string(buffer);
278     }
279     function toHexString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0x00";
282         }
283         uint256 temp = value;
284         uint256 length = 0;
285         while (temp != 0) {
286             length++;
287             temp >>= 8;
288         }
289         return toHexString(value, length);
290     }
291     function toHexString(uint256 value, uint256 length)
292         internal
293         pure
294         returns (string memory)
295     {
296         bytes memory buffer = new bytes(2 * length + 2);
297         buffer[0] = "0";
298         buffer[1] = "x";
299         for (uint256 i = 2 * length + 1; i > 1; --i) {
300             buffer[i] = _HEX_SYMBOLS[value & 0xf];
301             value >>= 4;
302         }
303         require(value == 0, "Strings: hex length insufficient");
304         return string(buffer);
305     }
306 }
307 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
308 pragma solidity ^0.8.0;
309 abstract contract ERC165 is IERC165 {
310     function supportsInterface(bytes4 interfaceId)
311         public
312         view
313         virtual
314         override
315         returns (bool)
316     {
317         return interfaceId == type(IERC165).interfaceId;
318     }
319 }
320 
321 pragma solidity ^0.8.0;
322 
323 abstract contract ReentrancyGuard {
324     // word because each write operation emits an extra SLOAD to first read the
325     // back. This is the compiler's defense against contract upgrades and
326 
327     // but in exchange the refund on every call to nonReentrant will be lower in
328     // transaction's gas, it is best to keep them low in cases like this one, to
329     uint256 private constant _NOT_ENTERED = 1;
330     uint256 private constant _ENTERED = 2;
331 
332     uint256 private _status;
333 
334     constructor() {
335         _status = _NOT_ENTERED;
336     }
337     modifier nonReentrant() {
338         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
339         _status = _ENTERED;
340 
341         _;
342         // https://eips.ethereum.org/EIPS/eip-2200)
343         _status = _NOT_ENTERED;
344     }
345 }
346 
347 pragma solidity ^0.8.0;
348 contract ERC721A is
349     Context,
350     ERC165,
351     IERC721,
352     IERC721Metadata,
353     IERC721Enumerable
354 {
355     using Address for address;
356     using Strings for uint256;
357 
358     struct TokenOwnership {
359         address addr;
360         uint64 startTimestamp;
361     }
362 
363     struct AddressData {
364         uint128 balance;
365         uint128 numberMinted;
366     }
367 
368     uint256 private currentIndex = 0;
369 
370     uint256 internal immutable collectionSize;
371     uint256 internal immutable maxBatchSize;
372     string private _name;
373     string private _symbol;
374     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
375     mapping(uint256 => TokenOwnership) private _ownerships;
376     mapping(address => AddressData) private _addressData;
377     mapping(uint256 => address) private _tokenApprovals;
378     mapping(address => mapping(address => bool)) private _operatorApprovals;
379     constructor(
380         string memory name_,
381         string memory symbol_,
382         uint256 maxBatchSize_,
383         uint256 collectionSize_
384     ) {
385         require(
386             collectionSize_ > 0,
387             "ERC721A: collection must have a nonzero supply"
388         );
389         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
390         _name = name_;
391         _symbol = symbol_;
392         maxBatchSize = maxBatchSize_;
393         collectionSize = collectionSize_;
394     }
395     function totalSupply() public view override returns (uint256) {
396         return currentIndex;
397     }
398     function tokenByIndex(uint256 index)
399         public
400         view
401         override
402         returns (uint256)
403     {
404         require(index < totalSupply(), "ERC721A: global index out of bounds");
405         return index;
406     }
407     function tokenOfOwnerByIndex(address owner, uint256 index)
408         public
409         view
410         override
411         returns (uint256)
412     {
413         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
414         uint256 numMintedSoFar = totalSupply();
415         uint256 tokenIdsIdx = 0;
416         address currOwnershipAddr = address(0);
417         for (uint256 i = 0; i < numMintedSoFar; i++) {
418             TokenOwnership memory ownership = _ownerships[i];
419             if (ownership.addr != address(0)) {
420                 currOwnershipAddr = ownership.addr;
421             }
422             if (currOwnershipAddr == owner) {
423                 if (tokenIdsIdx == index) {
424                     return i;
425                 }
426                 tokenIdsIdx++;
427             }
428         }
429         revert("ERC721A: unable to get token of owner by index");
430     }
431     function supportsInterface(bytes4 interfaceId)
432         public
433         view
434         virtual
435         override(ERC165, IERC165)
436         returns (bool)
437     {
438         return
439             interfaceId == type(IERC721).interfaceId ||
440             interfaceId == type(IERC721Metadata).interfaceId ||
441             interfaceId == type(IERC721Enumerable).interfaceId ||
442             super.supportsInterface(interfaceId);
443     }
444     function balanceOf(address owner) public view override returns (uint256) {
445         require(
446             owner != address(0),
447             "ERC721A: balance query for the zero address"
448         );
449         return uint256(_addressData[owner].balance);
450     }
451 
452     function _numberMinted(address owner) internal view returns (uint256) {
453         require(
454             owner != address(0),
455             "ERC721A: number minted query for the zero address"
456         );
457         return uint256(_addressData[owner].numberMinted);
458     }
459 
460     function ownershipOf(uint256 tokenId)
461         internal
462         view
463         returns (TokenOwnership memory)
464     {
465         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
466 
467         uint256 lowestTokenToCheck;
468         if (tokenId >= maxBatchSize) {
469             lowestTokenToCheck = tokenId - maxBatchSize + 1;
470         }
471 
472         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
473             TokenOwnership memory ownership = _ownerships[curr];
474             if (ownership.addr != address(0)) {
475                 return ownership;
476             }
477         }
478 
479         revert("ERC721A: unable to determine the owner of token");
480     }
481     function ownerOf(uint256 tokenId) public view override returns (address) {
482         return ownershipOf(tokenId).addr;
483     }
484     function name() public view virtual override returns (string memory) {
485         return _name;
486     }
487     function symbol() public view virtual override returns (string memory) {
488         return _symbol;
489     }
490     function tokenURI(uint256 tokenId)
491         public
492         view
493         virtual
494         override
495         returns (string memory)
496     {
497         require(
498             _exists(tokenId),
499             "ERC721Metadata: URI query for nonexistent token"
500         );
501 
502         string memory baseURI = _baseURI();
503         return
504             bytes(baseURI).length > 0
505                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
506                 : "";
507     }
508     function _baseURI() internal view virtual returns (string memory) {
509         return "";
510     }
511     function approve(address to, uint256 tokenId) public override {
512         address owner = ERC721A.ownerOf(tokenId);
513         require(to != owner, "ERC721A: approval to current owner");
514 
515         require(
516             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
517             "ERC721A: approve caller is not owner nor approved for all"
518         );
519 
520         _approve(to, tokenId, owner);
521     }
522     function getApproved(uint256 tokenId)
523         public
524         view
525         override
526         returns (address)
527     {
528         require(
529             _exists(tokenId),
530             "ERC721A: approved query for nonexistent token"
531         );
532 
533         return _tokenApprovals[tokenId];
534     }
535     function setApprovalForAll(address operator, bool approved)
536         public
537         override
538     {
539         require(operator != _msgSender(), "ERC721A: approve to caller");
540 
541         _operatorApprovals[_msgSender()][operator] = approved;
542         emit ApprovalForAll(_msgSender(), operator, approved);
543     }
544     function isApprovedForAll(address owner, address operator)
545         public
546         view
547         virtual
548         override
549         returns (bool)
550     {
551         return _operatorApprovals[owner][operator];
552     }
553     function transferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) public override {
558         _transfer(from, to, tokenId);
559     }
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) public override {
565         safeTransferFrom(from, to, tokenId, "");
566     }
567     function safeTransferFrom(
568         address from,
569         address to,
570         uint256 tokenId,
571         bytes memory _data
572     ) public override {
573         _transfer(from, to, tokenId);
574         require(
575             _checkOnERC721Received(from, to, tokenId, _data),
576             "ERC721A: transfer to non ERC721Receiver implementer"
577         );
578     }
579     function _exists(uint256 tokenId) internal view returns (bool) {
580         return tokenId < currentIndex;
581     }
582 
583     function _safeMint(address to, uint256 quantity) internal {
584         _safeMint(to, quantity, "");
585     }
586     function _safeMint(
587         address to,
588         uint256 quantity,
589         bytes memory _data
590     ) internal {
591         uint256 startTokenId = currentIndex;
592         require(to != address(0), "ERC721A: mint to the zero address");
593         require(!_exists(startTokenId), "ERC721A: token already minted");
594         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
595 
596         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
597 
598         AddressData memory addressData = _addressData[to];
599         _addressData[to] = AddressData(
600             addressData.balance + uint128(quantity),
601             addressData.numberMinted + uint128(quantity)
602         );
603         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
604 
605         uint256 updatedIndex = startTokenId;
606 
607         for (uint256 i = 0; i < quantity; i++) {
608             emit Transfer(address(0), to, updatedIndex);
609             require(
610                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
611                 "ERC721A: transfer to non ERC721Receiver implementer"
612             );
613             updatedIndex++;
614         }
615 
616         currentIndex = updatedIndex;
617         _afterTokenTransfers(address(0), to, startTokenId, quantity);
618     }
619     function _transfer(
620         address from,
621         address to,
622         uint256 tokenId
623     ) private {
624         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
625 
626         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
627             getApproved(tokenId) == _msgSender() ||
628             isApprovedForAll(prevOwnership.addr, _msgSender()));
629 
630         require(
631             isApprovedOrOwner,
632             "ERC721A: transfer caller is not owner nor approved"
633         );
634 
635         require(
636             prevOwnership.addr == from,
637             "ERC721A: transfer from incorrect owner"
638         );
639         require(to != address(0), "ERC721A: transfer to the zero address");
640 
641         _beforeTokenTransfers(from, to, tokenId, 1);
642         _approve(address(0), tokenId, prevOwnership.addr);
643 
644         _addressData[from].balance -= 1;
645         _addressData[to].balance += 1;
646         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
647         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
648         uint256 nextTokenId = tokenId + 1;
649         if (_ownerships[nextTokenId].addr == address(0)) {
650             if (_exists(nextTokenId)) {
651                 _ownerships[nextTokenId] = TokenOwnership(
652                     prevOwnership.addr,
653                     prevOwnership.startTimestamp
654                 );
655             }
656         }
657 
658         emit Transfer(from, to, tokenId);
659         _afterTokenTransfers(from, to, tokenId, 1);
660     }
661     function _approve(
662         address to,
663         uint256 tokenId,
664         address owner
665     ) private {
666         _tokenApprovals[tokenId] = to;
667         emit Approval(owner, to, tokenId);
668     }
669 
670     uint256 public nextOwnerToExplicitlySet = 0;
671     function _setOwnersExplicit(uint256 quantity) internal {
672         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
673         require(quantity > 0, "quantity must be nonzero");
674         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
675         if (endIndex > collectionSize - 1) {
676             endIndex = collectionSize - 1;
677         }
678         require(_exists(endIndex), "not enough minted yet for this cleanup");
679         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
680             if (_ownerships[i].addr == address(0)) {
681                 TokenOwnership memory ownership = ownershipOf(i);
682                 _ownerships[i] = TokenOwnership(
683                     ownership.addr,
684                     ownership.startTimestamp
685                 );
686             }
687         }
688         nextOwnerToExplicitlySet = endIndex + 1;
689     }
690     function _checkOnERC721Received(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes memory _data
695     ) private returns (bool) {
696         if (to.isContract()) {
697             try
698                 IERC721Receiver(to).onERC721Received(
699                     _msgSender(),
700                     from,
701                     tokenId,
702                     _data
703                 )
704             returns (bytes4 retval) {
705                 return retval == IERC721Receiver(to).onERC721Received.selector;
706             } catch (bytes memory reason) {
707                 if (reason.length == 0) {
708                     revert(
709                         "ERC721A: transfer to non ERC721Receiver implementer"
710                     );
711                 } else {
712                     assembly {
713                         revert(add(32, reason), mload(reason))
714                     }
715                 }
716             }
717         } else {
718             return true;
719         }
720     }
721     function _beforeTokenTransfers(
722         address from,
723         address to,
724         uint256 startTokenId,
725         uint256 quantity
726     ) internal virtual {}
727     function _afterTokenTransfers(
728         address from,
729         address to,
730         uint256 startTokenId,
731         uint256 quantity
732     ) internal virtual {}
733 }
734 
735 contract Phase3 is Ownable, ERC721A, ReentrancyGuard {
736     uint256 public maxToken = 1000;
737     uint256 public maxTokentoMint = 516;
738     string private _baseTokenURI= "https://crumbos.vercel.app/api/phase3/";
739     string public _extension = "";
740     address public PHASE1_CONTRACT_ADDRESS = 0xF3ff64b9477b19adcf15e71945282DFAc1a1703b;
741     address public PHASE2_CONTRACT_ADDRESS = 0xA76AAb0aA0587b52B9a57C400c9a7001f7a8472C;
742     address public CRUMBOS_CONTRACT_ADDRESS = 0x8F60ee65DD44260D09628FC6Ddc49bBc0F52577b;
743     address public BURN_ADDRESS = 0x0000000000000000000000000000000000001001;
744     bool public mergeStarted = false;
745     uint256 public maxPerTx = 10;
746 
747     uint256 public mutationPrice = 0 ether;
748     uint256 public mintingPrice = 0.04 ether;
749 
750 
751     constructor()  ERC721A("PIGEONS OF NEW YORK: Phase 3", "PONY", 1000, maxToken)
752     {}
753 
754     modifier callerIsUser() {
755         require(tx.origin == msg.sender, "The caller is another contract");
756         _;
757     }
758     function mergeNfts(uint[] memory idsOfPhase1, uint[] memory idsOfPhase2, uint[] memory idsOfCrumbos ) external payable nonReentrant{
759 
760         uint crumbosBalance = IERC721(CRUMBOS_CONTRACT_ADDRESS).balanceOf(msg.sender);
761         uint totalNftsToMint = idsOfPhase1.length + idsOfPhase2.length;
762 
763         require(idsOfCrumbos.length == totalNftsToMint, "Invalid Arguments");
764         require(crumbosBalance >= totalNftsToMint, "You donot have enough Crumbos.");
765         require(idsOfPhase1.length > 0 || idsOfPhase2.length > 0, "Select atleast 1 Nft to burn");
766         require(idsOfCrumbos.length > 0, "Add Crumbos Id");
767         require(totalSupply() + totalNftsToMint <= maxTokentoMint, "Max Supply Reached.");
768         require(msg.value == mutationPrice * totalNftsToMint, "INVALID_ETH");
769         require(mergeStarted, "Not Started Yet!");
770 
771         require(IERC721(CRUMBOS_CONTRACT_ADDRESS).isApprovedForAll(msg.sender, address(this)) , "Approve CRUMBOS Nfts");
772          //Burning Nfts of Crumbos
773         for(uint i=0; i<idsOfCrumbos.length; i++){
774             IERC721(CRUMBOS_CONTRACT_ADDRESS).safeTransferFrom(msg.sender, BURN_ADDRESS, idsOfCrumbos[i]);
775         }
776 
777 
778         if(idsOfPhase1.length > 0){
779             require(IERC721(PHASE1_CONTRACT_ADDRESS).isApprovedForAll(msg.sender, address(this)) , "Approve Phase 1 Nfts");
780             //Burning Nfts of Phase1
781             for(uint i=0; i<idsOfPhase1.length; i++){
782                 IERC721(PHASE1_CONTRACT_ADDRESS).safeTransferFrom(msg.sender, BURN_ADDRESS, idsOfPhase1[i]);
783             }
784         }
785 
786         if(idsOfPhase2.length > 0){
787             require(IERC721(PHASE2_CONTRACT_ADDRESS).isApprovedForAll(msg.sender, address(this)) , "Approve Phase 2 Nfts");
788             //Burning Nfts of Phase2
789             for(uint i=0; i<idsOfPhase2.length; i++){
790                 IERC721(PHASE2_CONTRACT_ADDRESS).safeTransferFrom(msg.sender, BURN_ADDRESS, idsOfPhase2[i]);
791             }
792         }
793 
794         _safeMint(msg.sender, totalNftsToMint);
795 
796     }
797     
798     function buy(uint256 quantity) public payable {
799         require(mergeStarted, "Not Started Yet!");
800         require(totalSupply() + quantity <= maxTokentoMint, "Max Supply Reached.");
801         require(msg.value == mintingPrice * quantity, "INVALID_ETH");
802         require(quantity > 0, "CANNOT_MINT_THAT_MANY");
803         require(quantity <= maxPerTx, "You cannot mint more than the limit.");
804 
805         _safeMint(msg.sender, quantity);
806 
807     }
808     function get_data_for_dapp(address _temp) public view returns(bool,bool,bool,uint,uint,uint,uint,uint,uint){
809 
810         return(IERC721(PHASE1_CONTRACT_ADDRESS).isApprovedForAll(_temp, address(this)),
811             IERC721(PHASE2_CONTRACT_ADDRESS).isApprovedForAll(_temp, address(this)),
812             IERC721(CRUMBOS_CONTRACT_ADDRESS).isApprovedForAll(_temp, address(this)), 
813             IERC721(CRUMBOS_CONTRACT_ADDRESS).balanceOf(_temp), 
814             IERC721(PHASE1_CONTRACT_ADDRESS).balanceOf(_temp), 
815             totalSupply(),
816             mintingPrice,
817             mutationPrice,
818             maxTokentoMint
819             );
820 
821     }
822     function setMaxLimits(uint256 t_max_per_tx) external onlyOwner {
823         maxPerTx = t_max_per_tx;
824     }
825    function sendGiftsToOwner(address _wallet, uint256 _num) external onlyOwner{
826             require(totalSupply() + _num < maxToken, "Max Supply Reached.");
827             _safeMint(_wallet, _num);
828     }
829     function sendGifts(address _wallet, uint256 _num) external onlyOwner{
830          require(totalSupply() + _num <= maxToken, "Max Supply Reached.");
831             _safeMint(_wallet, _num);
832     }
833    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
834             require(totalSupply() + _num <= maxToken, "Max Supply Reached.");
835             _safeMint(_wallet, _num);
836     }
837     function updateMintingPrice(uint256 price_in_wei) external onlyOwner{
838             mintingPrice = price_in_wei;
839     }
840     function updateMutationPrice(uint256 price_in_wei) external onlyOwner{
841             mutationPrice = price_in_wei;
842     }
843     function changeCollectionAddress(address phase1, address phase2, address crumbos) external onlyOwner{
844             PHASE1_CONTRACT_ADDRESS = phase1;
845             PHASE2_CONTRACT_ADDRESS = phase2;
846             CRUMBOS_CONTRACT_ADDRESS = crumbos;
847     }
848 
849 
850     function _baseURI() internal view virtual override returns (string memory) {
851         return _baseTokenURI;
852     }
853 
854     function setBaseURI(string calldata baseURI) external onlyOwner {
855         _baseTokenURI = baseURI;
856     }
857 
858     function withdraw() external onlyOwner {
859         payable(msg.sender).transfer(address(this).balance);
860     }
861     function setmaxToken(uint _temp) onlyOwner public {
862         maxToken = _temp;
863     }
864     function setmaxTokentoMint(uint _temp) onlyOwner public {
865         maxTokentoMint = _temp;
866     }
867     function updateExtension(string memory _temp) onlyOwner public {
868         _extension = _temp;
869     }
870     function setMergeStarted(bool _temp) onlyOwner public {
871         mergeStarted = _temp;
872     }
873     function numberMinted(address owner) public view returns (uint256) {
874         return _numberMinted(owner);
875     }
876 
877     function getOwnershipData(uint256 tokenId)
878         external
879         view
880         returns (TokenOwnership memory)
881     {
882         return ownershipOf(tokenId);
883     }
884 
885     function tokenURI(uint256 tokenId)
886         public
887         view
888         virtual
889         override
890         returns (string memory)
891     {
892         require(
893             _exists(tokenId),
894             "ERC721Metadata: URI query for nonexistent token"
895         );
896 
897         string memory _tokenURI = super.tokenURI(tokenId);
898         return
899             bytes(_tokenURI).length > 0
900                 ? string(abi.encodePacked(_tokenURI, _extension))
901                 : "";
902     }
903 }