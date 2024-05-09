1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-06
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-06
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/access/[email protected]
26 
27 
28 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
29 
30 
31 
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     
39     constructor() {
40         _transferOwnership(_msgSender());
41     }
42 
43     
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48    
49     modifier onlyOwner() {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59     
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 
74 // File @openzeppelin/contracts/utils/[email protected]
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
78 
79 
80 
81 
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84 
85     
86     function toString(uint256 value) internal pure returns (string memory) {
87         
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 
136 
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
140 
141 
142 
143 
144 interface IERC165 {
145     
146     function supportsInterface(bytes4 interfaceId) external view returns (bool);
147 }
148 
149 
150 
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
154 
155 
156 
157 
158 interface IERC721 is IERC165 {
159     
160     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
161 
162     
163     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
164 
165     
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     
169     function balanceOf(address owner) external view returns (uint256 balance);
170 
171     
172     function ownerOf(uint256 tokenId) external view returns (address owner);
173 
174     
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     
182     function transferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     
189     function approve(address to, uint256 tokenId) external;
190 
191     
192     function getApproved(uint256 tokenId) external view returns (address operator);
193 
194     
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     
198     function isApprovedForAll(address owner, address operator) external view returns (bool);
199 
200     
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId,
205         bytes calldata data
206     ) external;
207 }
208 
209 
210 
211 
212 
213 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
214 
215 
216 
217 
218 interface IERC721Receiver {
219     
220     function onERC721Received(
221         address operator,
222         address from,
223         uint256 tokenId,
224         bytes calldata data
225     ) external returns (bytes4);
226 }
227 
228 
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
232 
233 
234 
235 
236 interface IERC721Metadata is IERC721 {
237     
238     function name() external view returns (string memory);
239 
240     
241     function symbol() external view returns (string memory);
242 
243     
244     function tokenURI(uint256 tokenId) external view returns (string memory);
245 }
246 
247 
248 
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
252 
253 
254 
255 
256 interface IERC721Enumerable is IERC721 {
257     
258     function totalSupply() external view returns (uint256);
259 
260     
261     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
262 
263     
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 
268 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
269 
270 
271 library Counters {
272     struct Counter {
273         
274         uint256 _value; 
275     }
276 
277     function current(Counter storage counter) internal view returns (uint256) {
278         return counter._value;
279     }
280 
281     function increment(Counter storage counter) internal {
282         unchecked {
283             counter._value += 1;
284         }
285     }
286 
287     function decrement(Counter storage counter) internal {
288         uint256 value = counter._value;
289         require(value > 0, "Counter: decrement overflow");
290         unchecked {
291             counter._value = value - 1;
292         }
293     }
294 
295     function reset(Counter storage counter) internal {
296         counter._value = 0;
297     }
298 }
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
302 
303 
304 
305 
306 library Address {
307     
308     function isContract(address account) internal view returns (bool) {
309         
310 
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.call{value: value}(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     
398     function verifyCallResult(
399         bool success,
400         bytes memory returndata,
401         string memory errorMessage
402     ) internal pure returns (bytes memory) {
403         if (success) {
404             return returndata;
405         } else {
406             
407             if (returndata.length > 0) {
408                 
409 
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 }
420 
421 
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
425 
426 
427 
428 
429 abstract contract ERC165 is IERC165 {
430     
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         return interfaceId == type(IERC165).interfaceId;
433     }
434 }
435 
436 
437 // File contracts/ERC721A.sol
438 
439 
440 
441 
442 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
443     using Address for address;
444     using Strings for uint256;
445 
446     struct TokenOwnership {
447         address addr;
448         uint64 startTimestamp;
449     }
450 
451     struct AddressData {
452         uint128 balance;
453         uint128 numberMinted;
454     }
455 
456     uint256 internal currentIndex = 0;
457 
458     
459     string private _name;
460 
461     
462     string private _symbol;
463 
464     
465     mapping(uint256 => TokenOwnership) internal _ownerships;
466 
467     
468     mapping(address => AddressData) private _addressData;
469 
470     
471     mapping(uint256 => address) private _tokenApprovals;
472 
473     
474     mapping(address => mapping(address => bool)) private _operatorApprovals;
475 
476     constructor(string memory name_, string memory symbol_) {
477         _name = name_;
478         _symbol = symbol_;
479     }
480 
481     
482     function totalSupply() public view override returns (uint256) {
483         return currentIndex;
484     }
485 
486     
487     function tokenByIndex(uint256 index) public view override returns (uint256) {
488         require(index < totalSupply(), 'ERC721A: global index out of bounds');
489         return index;
490     }
491 
492     
493     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
494         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
495         uint256 numMintedSoFar = totalSupply();
496         uint256 tokenIdsIdx = 0;
497         address currOwnershipAddr = address(0);
498         for (uint256 i = 0; i < numMintedSoFar; i++) {
499             TokenOwnership memory ownership = _ownerships[i];
500             if (ownership.addr != address(0)) {
501                 currOwnershipAddr = ownership.addr;
502             }
503             if (currOwnershipAddr == owner) {
504                 if (tokenIdsIdx == index) {
505                     return i;
506                 }
507                 tokenIdsIdx++;
508             }
509         }
510         revert('ERC721A: unable to get token of owner by index');
511     }
512 
513     
514     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
515         return
516             interfaceId == type(IERC721).interfaceId ||
517             interfaceId == type(IERC721Metadata).interfaceId ||
518             interfaceId == type(IERC721Enumerable).interfaceId ||
519             super.supportsInterface(interfaceId);
520     }
521 
522     
523     function balanceOf(address owner) public view override returns (uint256) {
524         require(owner != address(0), 'ERC721A: balance query for the zero address');
525         return uint256(_addressData[owner].balance);
526     }
527 
528     function _numberMinted(address owner) internal view returns (uint256) {
529         require(owner != address(0), 'ERC721A: number minted query for the zero address');
530         return uint256(_addressData[owner].numberMinted);
531     }
532 
533     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
534         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
535 
536         for (uint256 curr = tokenId; ; curr--) {
537             TokenOwnership memory ownership = _ownerships[curr];
538             if (ownership.addr != address(0)) {
539                 return ownership;
540             }
541         }
542 
543         revert('ERC721A: unable to determine the owner of token');
544     }
545 
546     
547     function ownerOf(uint256 tokenId) public view override returns (address) {
548         return ownershipOf(tokenId).addr;
549     }
550 
551     
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     
562     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
563         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
564 
565         string memory baseURI = _baseURI();
566         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
567     }
568 
569     
570     function _baseURI() internal view virtual returns (string memory) {
571         return '';
572     }
573 
574     
575     function approve(address to, uint256 tokenId) public override {
576         address owner = ERC721A.ownerOf(tokenId);
577         require(to != owner, 'ERC721A: approval to current owner');
578 
579         require(
580             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
581             'ERC721A: approve caller is not owner nor approved for all'
582         );
583 
584         _approve(to, tokenId, owner);
585     }
586 
587     
588     function getApproved(uint256 tokenId) public view override returns (address) {
589         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
590 
591         return _tokenApprovals[tokenId];
592     }
593 
594     
595     function setApprovalForAll(address operator, bool approved) public override {
596         require(operator != _msgSender(), 'ERC721A: approve to caller');
597 
598         _operatorApprovals[_msgSender()][operator] = approved;
599         emit ApprovalForAll(_msgSender(), operator, approved);
600     }
601 
602     
603     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
604         return _operatorApprovals[owner][operator];
605     }
606 
607     
608     function transferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) public override {
613         _transfer(from, to, tokenId);
614     }
615 
616         function safeTransferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) public override {
621         safeTransferFrom(from, to, tokenId, '');
622     }
623 
624     
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes memory _data
630     ) public override {
631         _transfer(from, to, tokenId);
632         require(
633             _checkOnERC721Received(from, to, tokenId, _data),
634             'ERC721A: transfer to non ERC721Receiver implementer'
635         );
636     }
637 
638     
639     function _exists(uint256 tokenId) internal view returns (bool) {
640         return tokenId < currentIndex;
641     }
642 
643     function _safeMint(address to, uint256 quantity) internal {
644         _safeMint(to, quantity, '');
645     }
646 
647     
648     function _safeMint(
649         address to,
650         uint256 quantity,
651         bytes memory _data
652     ) internal {
653         uint256 startTokenId = currentIndex;
654         require(to != address(0), 'ERC721A: mint to the zero address');
655         require(!_exists(startTokenId), 'ERC721A: token already minted');
656         require(quantity > 0, 'ERC721A: quantity must be greater 0');
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
673                 'ERC721A: transfer to non ERC721Receiver implementer'
674             );
675             updatedIndex++;
676         }
677 
678       currentIndex = updatedIndex;
679         _afterTokenTransfers(address(0), to, startTokenId, quantity);
680     }
681 
682     
683     function _transfer(
684         address from,
685         address to,
686         uint256 tokenId
687     ) private {
688         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
689 
690         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
691             getApproved(tokenId) == _msgSender() ||
692             isApprovedForAll(prevOwnership.addr, _msgSender()));
693 
694         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
695 
696         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
697         require(to != address(0), 'ERC721A: transfer to the zero address');
698 
699         _beforeTokenTransfers(from, to, tokenId, 1);
700 
701         
702         _approve(address(0), tokenId, prevOwnership.addr);
703 
704         
705         unchecked {
706             _addressData[from].balance -= 1;
707             _addressData[to].balance += 1;
708         }
709 
710         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
711 
712         
713         uint256 nextTokenId = tokenId + 1;
714         if (_ownerships[nextTokenId].addr == address(0)) {
715             if (_exists(nextTokenId)) {
716                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
717             }
718         }
719 
720         emit Transfer(from, to, tokenId);
721         _afterTokenTransfers(from, to, tokenId, 1);
722     }
723 
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
734     
735     function _checkOnERC721Received(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes memory _data
740     ) private returns (bool) {
741         if (to.isContract()) {
742             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
743                 return retval == IERC721Receiver(to).onERC721Received.selector;
744             } catch (bytes memory reason) {
745                 if (reason.length == 0) {
746                     revert('ERC721A: transfer to non ERC721Receiver implementer');
747                 } else {
748                     assembly {
749                         revert(add(32, reason), mload(reason))
750                     }
751                 }
752             }
753         } else {
754             return true;
755         }
756     }
757 
758     
759     function _beforeTokenTransfers(
760         address from,
761         address to,
762         uint256 startTokenId,
763         uint256 quantity
764     ) internal virtual {}
765 
766     
767     function _afterTokenTransfers(
768         address from,
769         address to,
770         uint256 startTokenId,
771         uint256 quantity
772     ) internal virtual {}
773 }
774 
775 contract EliteAnalithicsPass is ERC721A, Ownable {
776 
777   using Strings for uint256;
778   using Counters for Counters.Counter;
779 
780   Counters.Counter private supply;
781 
782  string baseURI;
783   uint256 public cost = 0.002 ether;
784   uint256 public maxSupply = 4000;
785   uint256 public constant FREE_MAX_SUPPLY = 2000;
786   uint256 public constant MAX_PER_TX_FREE = 2;
787   uint256 public constant MAX_PER_TX = 2;
788   uint256 public maxMintAmount = 20;
789   string public baseExtension = ".json";
790   bool public paused = false;
791   bool public revealed = true;
792   string public notRevealedUri;
793   mapping(address => uint256) private _mintedFreeAmount;
794 
795   constructor() ERC721A("Elite Analithics Pass", "EAP") {
796        _safeMint(_msgSender(), 10);
797   }
798 
799   // internal
800   function _baseURI() internal view virtual override returns (string memory) {
801     return baseURI;
802   }
803 
804   // public
805   function mint(uint256 _amount) external payable {
806         address _caller = _msgSender();
807         require(!paused, "Paused");
808         require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
809         require(_amount > 0, "No 0 mints");
810         require(tx.origin == _caller, "No contracts");
811 
812         if(FREE_MAX_SUPPLY >= totalSupply() && (_mintedFreeAmount[msg.sender] + _amount <= maxMintAmount)){
813             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
814             _mintedFreeAmount[msg.sender] += _amount;
815         }else{
816             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
817             require(_amount * cost <= msg.value, "Invalid funds provided");
818         }
819 
820         _safeMint(_caller, _amount);
821     }
822 
823   function walletOfOwner(address _owner)
824     public
825     view
826     returns (uint256[] memory)
827   {
828     uint256 ownerTokenCount = balanceOf(_owner);
829     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
830     for (uint256 i; i < ownerTokenCount; i++) {
831       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
832     }
833     return tokenIds;
834   }
835 
836   function tokenURI(uint256 tokenId)
837     public
838     view
839     virtual
840     override
841     returns (string memory)
842   {
843     require(
844       _exists(tokenId),
845       "ERC721Metadata: URI query for nonexistent token"
846     );
847     
848     if(revealed == false) {
849         return notRevealedUri;
850     }
851 
852     string memory currentBaseURI = _baseURI();
853     return bytes(currentBaseURI).length > 0
854         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
855         : "";
856   }
857 
858   //only owner
859   function reveal() public onlyOwner {
860       revealed = true;
861   }
862   
863   function setCost(uint256 _newCost) public onlyOwner {
864     cost = _newCost;
865   }
866 
867   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
868     maxMintAmount = _newmaxMintAmount;
869   }
870   
871   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
872     notRevealedUri = _notRevealedURI;
873   }
874 
875   function setBaseURI(string memory _newBaseURI) public onlyOwner {
876     baseURI = _newBaseURI;
877   }
878 
879   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
880     baseExtension = _newBaseExtension;
881   }
882 
883   function pause(bool _state) public onlyOwner {
884     paused = _state;
885   }
886  
887   function withdraw() public onlyOwner {
888         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
889         require(os, "Withdraw failed!");
890   }
891   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
892     for (uint256 i = 1; i <= _mintAmount; i++) {
893       supply.increment();
894       _safeMint(_receiver, supply.current());
895     }
896   }
897 
898   
899 
900     
901 }