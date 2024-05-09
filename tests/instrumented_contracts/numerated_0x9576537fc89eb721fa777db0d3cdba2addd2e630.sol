1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 
17 // File @openzeppelin/contracts/access/[email protected]
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
21 
22 
23 
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40    
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _transferOwnership(newOwner);
55     }
56 
57     
58     function _transferOwnership(address newOwner) internal virtual {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 
66 // File @openzeppelin/contracts/utils/[email protected]
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
70 
71 
72 
73 
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     
78     function toString(uint256 value) internal pure returns (string memory) {
79         
80 
81         if (value == 0) {
82             return "0";
83         }
84         uint256 temp = value;
85         uint256 digits;
86         while (temp != 0) {
87             digits++;
88             temp /= 10;
89         }
90         bytes memory buffer = new bytes(digits);
91         while (value != 0) {
92             digits -= 1;
93             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
94             value /= 10;
95         }
96         return string(buffer);
97     }
98 
99     
100     function toHexString(uint256 value) internal pure returns (string memory) {
101         if (value == 0) {
102             return "0x00";
103         }
104         uint256 temp = value;
105         uint256 length = 0;
106         while (temp != 0) {
107             length++;
108             temp >>= 8;
109         }
110         return toHexString(value, length);
111     }
112 
113     
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = _HEX_SYMBOLS[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 }
126 
127 
128 
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
132 
133 
134 
135 
136 interface IERC165 {
137     
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 
142 
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
146 
147 
148 
149 
150 interface IERC721 is IERC165 {
151     
152     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
153 
154     
155     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
156 
157     
158     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
159 
160     
161     function balanceOf(address owner) external view returns (uint256 balance);
162 
163     
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId
171     ) external;
172 
173     
174     function transferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     
181     function approve(address to, uint256 tokenId) external;
182 
183     
184     function getApproved(uint256 tokenId) external view returns (address operator);
185 
186     
187     function setApprovalForAll(address operator, bool _approved) external;
188 
189     
190     function isApprovedForAll(address owner, address operator) external view returns (bool);
191 
192     
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId,
197         bytes calldata data
198     ) external;
199 }
200 
201 
202 
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
206 
207 
208 
209 
210 interface IERC721Receiver {
211     
212     function onERC721Received(
213         address operator,
214         address from,
215         uint256 tokenId,
216         bytes calldata data
217     ) external returns (bytes4);
218 }
219 
220 
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
224 
225 
226 
227 
228 interface IERC721Metadata is IERC721 {
229     
230     function name() external view returns (string memory);
231 
232     
233     function symbol() external view returns (string memory);
234 
235     
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 
240 
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
244 
245 
246 
247 
248 interface IERC721Enumerable is IERC721 {
249     
250     function totalSupply() external view returns (uint256);
251 
252     
253     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
254 
255     
256     function tokenByIndex(uint256 index) external view returns (uint256);
257 }
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
261 
262 
263 library Counters {
264     struct Counter {
265         
266         uint256 _value; 
267     }
268 
269     function current(Counter storage counter) internal view returns (uint256) {
270         return counter._value;
271     }
272 
273     function increment(Counter storage counter) internal {
274         unchecked {
275             counter._value += 1;
276         }
277     }
278 
279     function decrement(Counter storage counter) internal {
280         uint256 value = counter._value;
281         require(value > 0, "Counter: decrement overflow");
282         unchecked {
283             counter._value = value - 1;
284         }
285     }
286 
287     function reset(Counter storage counter) internal {
288         counter._value = 0;
289     }
290 }
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
294 
295 
296 
297 
298 library Address {
299     
300     function isContract(address account) internal view returns (bool) {
301         
302 
303         uint256 size;
304         assembly {
305             size := extcodesize(account)
306         }
307         return size > 0;
308     }
309 
310     
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value,
346         string memory errorMessage
347     ) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         require(isContract(target), "Address: call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.call{value: value}(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     
361     function functionStaticCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     
378     function functionDelegateCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(isContract(target), "Address: delegate call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.delegatecall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     
390     function verifyCallResult(
391         bool success,
392         bytes memory returndata,
393         string memory errorMessage
394     ) internal pure returns (bytes memory) {
395         if (success) {
396             return returndata;
397         } else {
398             
399             if (returndata.length > 0) {
400                 
401 
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
417 
418 
419 
420 
421 abstract contract ERC165 is IERC165 {
422     
423     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424         return interfaceId == type(IERC165).interfaceId;
425     }
426 }
427 
428 
429 // File contracts/ERC721A.sol
430 
431 
432 
433 
434 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
435     using Address for address;
436     using Strings for uint256;
437 
438     struct TokenOwnership {
439         address addr;
440         uint64 startTimestamp;
441     }
442 
443     struct AddressData {
444         uint128 balance;
445         uint128 numberMinted;
446     }
447 
448     uint256 internal currentIndex = 0;
449 
450     
451     string private _name;
452 
453     
454     string private _symbol;
455 
456     
457     mapping(uint256 => TokenOwnership) internal _ownerships;
458 
459     
460     mapping(address => AddressData) private _addressData;
461 
462     
463     mapping(uint256 => address) private _tokenApprovals;
464 
465     
466     mapping(address => mapping(address => bool)) private _operatorApprovals;
467 
468     constructor(string memory name_, string memory symbol_) {
469         _name = name_;
470         _symbol = symbol_;
471     }
472 
473     
474     function totalSupply() public view override returns (uint256) {
475         return currentIndex;
476     }
477 
478     
479     function tokenByIndex(uint256 index) public view override returns (uint256) {
480         require(index < totalSupply(), 'ERC721A: global index out of bounds');
481         return index;
482     }
483 
484     
485     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
486         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
487         uint256 numMintedSoFar = totalSupply();
488         uint256 tokenIdsIdx = 0;
489         address currOwnershipAddr = address(0);
490         for (uint256 i = 0; i < numMintedSoFar; i++) {
491             TokenOwnership memory ownership = _ownerships[i];
492             if (ownership.addr != address(0)) {
493                 currOwnershipAddr = ownership.addr;
494             }
495             if (currOwnershipAddr == owner) {
496                 if (tokenIdsIdx == index) {
497                     return i;
498                 }
499                 tokenIdsIdx++;
500             }
501         }
502         revert('ERC721A: unable to get token of owner by index');
503     }
504 
505     
506     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
507         return
508             interfaceId == type(IERC721).interfaceId ||
509             interfaceId == type(IERC721Metadata).interfaceId ||
510             interfaceId == type(IERC721Enumerable).interfaceId ||
511             super.supportsInterface(interfaceId);
512     }
513 
514     
515     function balanceOf(address owner) public view override returns (uint256) {
516         require(owner != address(0), 'ERC721A: balance query for the zero address');
517         return uint256(_addressData[owner].balance);
518     }
519 
520     function _numberMinted(address owner) internal view returns (uint256) {
521         require(owner != address(0), 'ERC721A: number minted query for the zero address');
522         return uint256(_addressData[owner].numberMinted);
523     }
524 
525     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
526         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
527 
528         for (uint256 curr = tokenId; ; curr--) {
529             TokenOwnership memory ownership = _ownerships[curr];
530             if (ownership.addr != address(0)) {
531                 return ownership;
532             }
533         }
534 
535         revert('ERC721A: unable to determine the owner of token');
536     }
537 
538     
539     function ownerOf(uint256 tokenId) public view override returns (address) {
540         return ownershipOf(tokenId).addr;
541     }
542 
543     
544     function name() public view virtual override returns (string memory) {
545         return _name;
546     }
547 
548     
549     function symbol() public view virtual override returns (string memory) {
550         return _symbol;
551     }
552 
553     
554     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
555         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
556 
557         string memory baseURI = _baseURI();
558         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
559     }
560 
561     
562     function _baseURI() internal view virtual returns (string memory) {
563         return '';
564     }
565 
566     
567     function approve(address to, uint256 tokenId) public override {
568         address owner = ERC721A.ownerOf(tokenId);
569         require(to != owner, 'ERC721A: approval to current owner');
570 
571         require(
572             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
573             'ERC721A: approve caller is not owner nor approved for all'
574         );
575 
576         _approve(to, tokenId, owner);
577     }
578 
579     
580     function getApproved(uint256 tokenId) public view override returns (address) {
581         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
582 
583         return _tokenApprovals[tokenId];
584     }
585 
586     
587     function setApprovalForAll(address operator, bool approved) public override {
588         require(operator != _msgSender(), 'ERC721A: approve to caller');
589 
590         _operatorApprovals[_msgSender()][operator] = approved;
591         emit ApprovalForAll(_msgSender(), operator, approved);
592     }
593 
594     
595     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
596         return _operatorApprovals[owner][operator];
597     }
598 
599     
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) public override {
605         _transfer(from, to, tokenId);
606     }
607 
608         function safeTransferFrom(
609         address from,
610         address to,
611         uint256 tokenId
612     ) public override {
613         safeTransferFrom(from, to, tokenId, '');
614     }
615 
616     
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId,
621         bytes memory _data
622     ) public override {
623         _transfer(from, to, tokenId);
624         require(
625             _checkOnERC721Received(from, to, tokenId, _data),
626             'ERC721A: transfer to non ERC721Receiver implementer'
627         );
628     }
629 
630     
631     function _exists(uint256 tokenId) internal view returns (bool) {
632         return tokenId < currentIndex;
633     }
634 
635     function _safeMint(address to, uint256 quantity) internal {
636         _safeMint(to, quantity, '');
637     }
638 
639     
640     function _safeMint(
641         address to,
642         uint256 quantity,
643         bytes memory _data
644     ) internal {
645         uint256 startTokenId = currentIndex;
646         require(to != address(0), 'ERC721A: mint to the zero address');
647         require(!_exists(startTokenId), 'ERC721A: token already minted');
648         require(quantity > 0, 'ERC721A: quantity must be greater 0');
649 
650         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
651 
652         AddressData memory addressData = _addressData[to];
653         _addressData[to] = AddressData(
654             addressData.balance + uint128(quantity),
655             addressData.numberMinted + uint128(quantity)
656         );
657         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
658 
659         uint256 updatedIndex = startTokenId;
660 
661         for (uint256 i = 0; i < quantity; i++) {
662             emit Transfer(address(0), to, updatedIndex);
663             require(
664                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
665                 'ERC721A: transfer to non ERC721Receiver implementer'
666             );
667             updatedIndex++;
668         }
669 
670       currentIndex = updatedIndex;
671         _afterTokenTransfers(address(0), to, startTokenId, quantity);
672     }
673 
674     
675     function _transfer(
676         address from,
677         address to,
678         uint256 tokenId
679     ) private {
680         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
681 
682         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
683             getApproved(tokenId) == _msgSender() ||
684             isApprovedForAll(prevOwnership.addr, _msgSender()));
685 
686         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
687 
688         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
689         require(to != address(0), 'ERC721A: transfer to the zero address');
690 
691         _beforeTokenTransfers(from, to, tokenId, 1);
692 
693         
694         _approve(address(0), tokenId, prevOwnership.addr);
695 
696         
697         unchecked {
698             _addressData[from].balance -= 1;
699             _addressData[to].balance += 1;
700         }
701 
702         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
703 
704         
705         uint256 nextTokenId = tokenId + 1;
706         if (_ownerships[nextTokenId].addr == address(0)) {
707             if (_exists(nextTokenId)) {
708                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
709             }
710         }
711 
712         emit Transfer(from, to, tokenId);
713         _afterTokenTransfers(from, to, tokenId, 1);
714     }
715 
716     
717     function _approve(
718         address to,
719         uint256 tokenId,
720         address owner
721     ) private {
722         _tokenApprovals[tokenId] = to;
723         emit Approval(owner, to, tokenId);
724     }
725 
726     
727     function _checkOnERC721Received(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) private returns (bool) {
733         if (to.isContract()) {
734             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
735                 return retval == IERC721Receiver(to).onERC721Received.selector;
736             } catch (bytes memory reason) {
737                 if (reason.length == 0) {
738                     revert('ERC721A: transfer to non ERC721Receiver implementer');
739                 } else {
740                     assembly {
741                         revert(add(32, reason), mload(reason))
742                     }
743                 }
744             }
745         } else {
746             return true;
747         }
748     }
749 
750     
751     function _beforeTokenTransfers(
752         address from,
753         address to,
754         uint256 startTokenId,
755         uint256 quantity
756     ) internal virtual {}
757 
758     
759     function _afterTokenTransfers(
760         address from,
761         address to,
762         uint256 startTokenId,
763         uint256 quantity
764     ) internal virtual {}
765 }
766 
767 contract Crypto is ERC721A, Ownable {
768 
769   using Strings for uint256;
770   using Counters for Counters.Counter;
771 
772   Counters.Counter private supply;
773 
774  string baseURI;
775   string public baseExtension = ".json";
776   uint256 public constant MAX_PER_TX_FREE = 5;
777   uint256 public constant MAX_PER_TX = 5;
778   uint256 public constant FREE_MAX_SUPPLY = 4500;
779   uint256 public cost = 0.002 ether;
780   uint256 public maxSupply = 10000;
781   uint256 public maxMintAmount = 20;
782   bool public paused = true;
783   bool public revealed = false;
784   string public notRevealedUri;
785 
786   constructor(
787     string memory _name,
788     string memory _symbol,
789     string memory _initBaseURI,
790     string memory _initNotRevealedUri
791   ) ERC721A(_name, _symbol) {
792     setBaseURI(_initBaseURI);
793     setNotRevealedURI(_initNotRevealedUri);
794   }
795 
796   // internal
797   function _baseURI() internal view virtual override returns (string memory) {
798     return baseURI;
799   }
800 
801   // public
802   function mint(uint256 _amount) external payable {
803         address _caller = _msgSender();
804         require(!paused, "Paused");
805         require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
806         require(_amount > 0, "No 0 mints");
807         require(tx.origin == _caller, "No contracts");
808 
809         if(FREE_MAX_SUPPLY >= totalSupply()){
810             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
811         }else{
812             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
813             require(_amount * cost == msg.value, "Invalid funds provided");
814         }
815 
816         _safeMint(_caller, _amount);
817     }
818 
819   function walletOfOwner(address _owner)
820     public
821     view
822     returns (uint256[] memory)
823   {
824     uint256 ownerTokenCount = balanceOf(_owner);
825     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
826     for (uint256 i; i < ownerTokenCount; i++) {
827       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
828     }
829     return tokenIds;
830   }
831 
832   function tokenURI(uint256 tokenId)
833     public
834     view
835     virtual
836     override
837     returns (string memory)
838   {
839     require(
840       _exists(tokenId),
841       "ERC721Metadata: URI query for nonexistent token"
842     );
843     
844     if(revealed == false) {
845         return notRevealedUri;
846     }
847 
848     string memory currentBaseURI = _baseURI();
849     return bytes(currentBaseURI).length > 0
850         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
851         : "";
852   }
853 
854   //only owner
855   function reveal() public onlyOwner {
856       revealed = true;
857   }
858   
859   function setCost(uint256 _newCost) public onlyOwner {
860     cost = _newCost;
861   }
862 
863   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
864     maxMintAmount = _newmaxMintAmount;
865   }
866   
867   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
868     notRevealedUri = _notRevealedURI;
869   }
870 
871   function setBaseURI(string memory _newBaseURI) public onlyOwner {
872     baseURI = _newBaseURI;
873   }
874 
875   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
876     baseExtension = _newBaseExtension;
877   }
878 
879   function pause(bool _state) public onlyOwner {
880     paused = _state;
881   }
882  
883   function withdraw() public onlyOwner {
884         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
885         require(os, "Withdraw failed!");
886   }
887   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
888     for (uint256 i = 1; i <= _mintAmount; i++) {
889       supply.increment();
890       _safeMint(_receiver, supply.current());
891     }
892   }
893 
894   
895 
896     
897 }