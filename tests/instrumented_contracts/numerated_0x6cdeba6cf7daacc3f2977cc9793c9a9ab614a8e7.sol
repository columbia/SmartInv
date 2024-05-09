1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 
21 // File @openzeppelin/contracts/access/[email protected]
22 
23 
24 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
25 
26 
27 
28 
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     
35     constructor() {
36         _transferOwnership(_msgSender());
37     }
38 
39     
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44    
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _transferOwnership(newOwner);
59     }
60 
61     
62     function _transferOwnership(address newOwner) internal virtual {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 
70 // File @openzeppelin/contracts/utils/[email protected]
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
74 
75 
76 
77 
78 library Strings {
79     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
80 
81     
82     function toString(uint256 value) internal pure returns (string memory) {
83         
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117     
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 }
130 
131 
132 
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
136 
137 
138 
139 
140 interface IERC165 {
141     
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 
146 
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
150 
151 
152 
153 
154 interface IERC721 is IERC165 {
155     
156     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
157 
158     
159     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
160 
161     
162     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
163 
164     
165     function balanceOf(address owner) external view returns (uint256 balance);
166 
167     
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     
178     function transferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     
185     function approve(address to, uint256 tokenId) external;
186 
187     
188     function getApproved(uint256 tokenId) external view returns (address operator);
189 
190     
191     function setApprovalForAll(address operator, bool _approved) external;
192 
193     
194     function isApprovedForAll(address owner, address operator) external view returns (bool);
195 
196     
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId,
201         bytes calldata data
202     ) external;
203 }
204 
205 
206 
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
210 
211 
212 
213 
214 interface IERC721Receiver {
215     
216     function onERC721Received(
217         address operator,
218         address from,
219         uint256 tokenId,
220         bytes calldata data
221     ) external returns (bytes4);
222 }
223 
224 
225 
226 
227 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
228 
229 
230 
231 
232 interface IERC721Metadata is IERC721 {
233     
234     function name() external view returns (string memory);
235 
236     
237     function symbol() external view returns (string memory);
238 
239     
240     function tokenURI(uint256 tokenId) external view returns (string memory);
241 }
242 
243 
244 
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
248 
249 
250 
251 
252 interface IERC721Enumerable is IERC721 {
253     
254     function totalSupply() external view returns (uint256);
255 
256     
257     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
258 
259     
260     function tokenByIndex(uint256 index) external view returns (uint256);
261 }
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
265 
266 
267 library Counters {
268     struct Counter {
269         
270         uint256 _value; 
271     }
272 
273     function current(Counter storage counter) internal view returns (uint256) {
274         return counter._value;
275     }
276 
277     function increment(Counter storage counter) internal {
278         unchecked {
279             counter._value += 1;
280         }
281     }
282 
283     function decrement(Counter storage counter) internal {
284         uint256 value = counter._value;
285         require(value > 0, "Counter: decrement overflow");
286         unchecked {
287             counter._value = value - 1;
288         }
289     }
290 
291     function reset(Counter storage counter) internal {
292         counter._value = 0;
293     }
294 }
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
298 
299 
300 
301 
302 library Address {
303     
304     function isContract(address account) internal view returns (bool) {
305         
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     
360     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
361         return functionStaticCall(target, data, "Address: low-level static call failed");
362     }
363 
364     
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     
377     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
379     }
380 
381     
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             
403             if (returndata.length > 0) {
404                 
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
421 
422 
423 
424 
425 abstract contract ERC165 is IERC165 {
426     
427     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428         return interfaceId == type(IERC165).interfaceId;
429     }
430 }
431 
432 
433 // File contracts/ERC721A.sol
434 
435 
436 
437 
438 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
439     using Address for address;
440     using Strings for uint256;
441 
442     struct TokenOwnership {
443         address addr;
444         uint64 startTimestamp;
445     }
446 
447     struct AddressData {
448         uint128 balance;
449         uint128 numberMinted;
450     }
451 
452     uint256 internal currentIndex = 0;
453 
454     
455     string private _name;
456 
457     
458     string private _symbol;
459 
460     
461     mapping(uint256 => TokenOwnership) internal _ownerships;
462 
463     
464     mapping(address => AddressData) private _addressData;
465 
466     
467     mapping(uint256 => address) private _tokenApprovals;
468 
469     
470     mapping(address => mapping(address => bool)) private _operatorApprovals;
471 
472     constructor(string memory name_, string memory symbol_) {
473         _name = name_;
474         _symbol = symbol_;
475     }
476 
477     
478     function totalSupply() public view override returns (uint256) {
479         return currentIndex;
480     }
481 
482     
483     function tokenByIndex(uint256 index) public view override returns (uint256) {
484         require(index < totalSupply(), 'ERC721A: global index out of bounds');
485         return index;
486     }
487 
488     
489     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
490         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
491         uint256 numMintedSoFar = totalSupply();
492         uint256 tokenIdsIdx = 0;
493         address currOwnershipAddr = address(0);
494         for (uint256 i = 0; i < numMintedSoFar; i++) {
495             TokenOwnership memory ownership = _ownerships[i];
496             if (ownership.addr != address(0)) {
497                 currOwnershipAddr = ownership.addr;
498             }
499             if (currOwnershipAddr == owner) {
500                 if (tokenIdsIdx == index) {
501                     return i;
502                 }
503                 tokenIdsIdx++;
504             }
505         }
506         revert('ERC721A: unable to get token of owner by index');
507     }
508 
509     
510     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
511         return
512             interfaceId == type(IERC721).interfaceId ||
513             interfaceId == type(IERC721Metadata).interfaceId ||
514             interfaceId == type(IERC721Enumerable).interfaceId ||
515             super.supportsInterface(interfaceId);
516     }
517 
518     
519     function balanceOf(address owner) public view override returns (uint256) {
520         require(owner != address(0), 'ERC721A: balance query for the zero address');
521         return uint256(_addressData[owner].balance);
522     }
523 
524     function _numberMinted(address owner) internal view returns (uint256) {
525         require(owner != address(0), 'ERC721A: number minted query for the zero address');
526         return uint256(_addressData[owner].numberMinted);
527     }
528 
529     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
530         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
531 
532         for (uint256 curr = tokenId; ; curr--) {
533             TokenOwnership memory ownership = _ownerships[curr];
534             if (ownership.addr != address(0)) {
535                 return ownership;
536             }
537         }
538 
539         revert('ERC721A: unable to determine the owner of token');
540     }
541 
542     
543     function ownerOf(uint256 tokenId) public view override returns (address) {
544         return ownershipOf(tokenId).addr;
545     }
546 
547     
548     function name() public view virtual override returns (string memory) {
549         return _name;
550     }
551 
552     
553     function symbol() public view virtual override returns (string memory) {
554         return _symbol;
555     }
556 
557     
558     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
559         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
560 
561         string memory baseURI = _baseURI();
562         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
563     }
564 
565     
566     function _baseURI() internal view virtual returns (string memory) {
567         return '';
568     }
569 
570     
571     function approve(address to, uint256 tokenId) public override {
572         address owner = ERC721A.ownerOf(tokenId);
573         require(to != owner, 'ERC721A: approval to current owner');
574 
575         require(
576             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
577             'ERC721A: approve caller is not owner nor approved for all'
578         );
579 
580         _approve(to, tokenId, owner);
581     }
582 
583     
584     function getApproved(uint256 tokenId) public view override returns (address) {
585         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
586 
587         return _tokenApprovals[tokenId];
588     }
589 
590     
591     function setApprovalForAll(address operator, bool approved) public override {
592         require(operator != _msgSender(), 'ERC721A: approve to caller');
593 
594         _operatorApprovals[_msgSender()][operator] = approved;
595         emit ApprovalForAll(_msgSender(), operator, approved);
596     }
597 
598     
599     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
600         return _operatorApprovals[owner][operator];
601     }
602 
603     
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) public override {
609         _transfer(from, to, tokenId);
610     }
611 
612         function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) public override {
617         safeTransferFrom(from, to, tokenId, '');
618     }
619 
620     
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes memory _data
626     ) public override {
627         _transfer(from, to, tokenId);
628         require(
629             _checkOnERC721Received(from, to, tokenId, _data),
630             'ERC721A: transfer to non ERC721Receiver implementer'
631         );
632     }
633 
634     
635     function _exists(uint256 tokenId) internal view returns (bool) {
636         return tokenId < currentIndex;
637     }
638 
639     function _safeMint(address to, uint256 quantity) internal {
640         _safeMint(to, quantity, '');
641     }
642 
643     
644     function _safeMint(
645         address to,
646         uint256 quantity,
647         bytes memory _data
648     ) internal {
649         uint256 startTokenId = currentIndex;
650         require(to != address(0), 'ERC721A: mint to the zero address');
651         require(!_exists(startTokenId), 'ERC721A: token already minted');
652         require(quantity > 0, 'ERC721A: quantity must be greater 0');
653 
654         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
655 
656         AddressData memory addressData = _addressData[to];
657         _addressData[to] = AddressData(
658             addressData.balance + uint128(quantity),
659             addressData.numberMinted + uint128(quantity)
660         );
661         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
662 
663         uint256 updatedIndex = startTokenId;
664 
665         for (uint256 i = 0; i < quantity; i++) {
666             emit Transfer(address(0), to, updatedIndex);
667             require(
668                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
669                 'ERC721A: transfer to non ERC721Receiver implementer'
670             );
671             updatedIndex++;
672         }
673 
674       currentIndex = updatedIndex;
675         _afterTokenTransfers(address(0), to, startTokenId, quantity);
676     }
677 
678     
679     function _transfer(
680         address from,
681         address to,
682         uint256 tokenId
683     ) private {
684         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
685 
686         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
687             getApproved(tokenId) == _msgSender() ||
688             isApprovedForAll(prevOwnership.addr, _msgSender()));
689 
690         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
691 
692         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
693         require(to != address(0), 'ERC721A: transfer to the zero address');
694 
695         _beforeTokenTransfers(from, to, tokenId, 1);
696 
697         
698         _approve(address(0), tokenId, prevOwnership.addr);
699 
700         
701         unchecked {
702             _addressData[from].balance -= 1;
703             _addressData[to].balance += 1;
704         }
705 
706         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
707 
708         
709         uint256 nextTokenId = tokenId + 1;
710         if (_ownerships[nextTokenId].addr == address(0)) {
711             if (_exists(nextTokenId)) {
712                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
713             }
714         }
715 
716         emit Transfer(from, to, tokenId);
717         _afterTokenTransfers(from, to, tokenId, 1);
718     }
719 
720     
721     function _approve(
722         address to,
723         uint256 tokenId,
724         address owner
725     ) private {
726         _tokenApprovals[tokenId] = to;
727         emit Approval(owner, to, tokenId);
728     }
729 
730     
731     function _checkOnERC721Received(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) private returns (bool) {
737         if (to.isContract()) {
738             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
739                 return retval == IERC721Receiver(to).onERC721Received.selector;
740             } catch (bytes memory reason) {
741                 if (reason.length == 0) {
742                     revert('ERC721A: transfer to non ERC721Receiver implementer');
743                 } else {
744                     assembly {
745                         revert(add(32, reason), mload(reason))
746                     }
747                 }
748             }
749         } else {
750             return true;
751         }
752     }
753 
754     
755     function _beforeTokenTransfers(
756         address from,
757         address to,
758         uint256 startTokenId,
759         uint256 quantity
760     ) internal virtual {}
761 
762     
763     function _afterTokenTransfers(
764         address from,
765         address to,
766         uint256 startTokenId,
767         uint256 quantity
768     ) internal virtual {}
769 }
770 
771 contract NoOne is ERC721A, Ownable {
772 
773   using Strings for uint256;
774   using Counters for Counters.Counter;
775 
776   Counters.Counter private supply;
777 
778  string baseURI;
779   uint256 public cost = 0.002 ether;
780   uint256 public maxSupply = 6000;
781   uint256 public constant FREE_MAX_SUPPLY = 3500;
782   uint256 public constant MAX_PER_TX_FREE = 5;
783   uint256 public constant MAX_PER_TX = 5;
784   uint256 public maxMintAmount = 20;
785   string public baseExtension = ".json";
786   bool public paused = false;
787   bool public revealed = true;
788   string public notRevealedUri;
789   mapping(address => uint256) private _mintedFreeAmount;
790 
791   constructor() ERC721A("No One", "NO") {
792        _safeMint(_msgSender(), 10);
793   }
794 
795   // internal
796   function _baseURI() internal view virtual override returns (string memory) {
797     return baseURI;
798   }
799 
800   // public
801   function mint(uint256 _amount) external payable {
802         address _caller = _msgSender();
803         require(!paused, "Paused");
804         require(maxSupply >= totalSupply() + _amount, "Exceeds max supply");
805         require(_amount > 0, "No 0 mints");
806         require(tx.origin == _caller, "No contracts");
807 
808         if(FREE_MAX_SUPPLY >= totalSupply() && (_mintedFreeAmount[msg.sender] + _amount <= maxMintAmount)){
809             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
810             _mintedFreeAmount[msg.sender] += _amount;
811         }else{
812             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
813             require(_amount * cost <= msg.value, "Invalid funds provided");
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