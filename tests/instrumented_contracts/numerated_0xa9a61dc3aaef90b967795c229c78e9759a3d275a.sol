1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract ReentrancyGuard {
6 
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9     uint256 private _status;
10 
11     constructor() {
12         _status = _NOT_ENTERED;
13     }
14 
15     modifier nonReentrant() {
16         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
17         _status = _ENTERED;
18         _;
19 
20         _status = _NOT_ENTERED;
21     }
22 }
23 
24 pragma solidity ^0.8.0;
25 
26 library Strings {
27     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
28 
29     function toString(uint256 value) internal pure returns (string memory) {
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 pragma solidity ^0.8.0;
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 pragma solidity ^0.8.0;
88 
89 abstract contract Ownable is Context {
90     address private _owner;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor() {
95         _transferOwnership(_msgSender());
96     }
97 
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(owner() == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _transferOwnership(newOwner);
114     }
115 
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 pragma solidity ^0.8.1;
124 
125 library Address {
126 
127     function isContract(address account) internal view returns (bool) {
128 
129         return account.code.length > 0;
130     }
131 
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
140         return functionCall(target, data, "Address: low-level call failed");
141     }
142 
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     function functionCallWithValue(
152         address target,
153         bytes memory data,
154         uint256 value
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
157     }
158 
159     function functionCallWithValue(
160         address target,
161         bytes memory data,
162         uint256 value,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         require(address(this).balance >= value, "Address: insufficient balance for call");
166         require(isContract(target), "Address: call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.call{value: value}(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
173         return functionStaticCall(target, data, "Address: low-level static call failed");
174     }
175 
176     function functionStaticCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         require(isContract(target), "Address: static call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.staticcall(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
189     }
190 
191     function functionDelegateCall(
192         address target,
193         bytes memory data,
194         string memory errorMessage
195     ) internal returns (bytes memory) {
196         require(isContract(target), "Address: delegate call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.delegatecall(data);
199         return verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     function verifyCallResult(
203         bool success,
204         bytes memory returndata,
205         string memory errorMessage
206     ) internal pure returns (bytes memory) {
207         if (success) {
208             return returndata;
209         } else {
210             if (returndata.length > 0) {
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 pragma solidity ^0.8.0;
224 
225 interface IERC721Receiver {
226 
227     function onERC721Received(
228         address operator,
229         address from,
230         uint256 tokenId,
231         bytes calldata data
232     ) external returns (bytes4);
233 }
234 
235 pragma solidity ^0.8.0;
236 
237 interface IERC165 {
238 
239     function supportsInterface(bytes4 interfaceId) external view returns (bool);
240 }
241 
242 pragma solidity ^0.8.0;
243 
244 abstract contract ERC165 is IERC165 {
245 
246     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
247         return interfaceId == type(IERC165).interfaceId;
248     }
249 }
250 
251 pragma solidity ^0.8.0;
252 
253 
254 interface IERC721 is IERC165 {
255 
256     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
257     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
258     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
259     function balanceOf(address owner) external view returns (uint256 balance);
260     function ownerOf(uint256 tokenId) external view returns (address owner);
261 
262     function safeTransferFrom(
263         address from,
264         address to,
265         uint256 tokenId,
266         bytes calldata data
267     ) external;
268 
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId
273     ) external;
274 
275     function transferFrom(
276         address from,
277         address to,
278         uint256 tokenId
279     ) external;
280 
281     function approve(address to, uint256 tokenId) external;
282     function setApprovalForAll(address operator, bool _approved) external;
283     function getApproved(uint256 tokenId) external view returns (address operator);
284     function isApprovedForAll(address owner, address operator) external view returns (bool);
285 }
286 
287 pragma solidity ^0.8.0;
288 
289 
290 interface IERC721Metadata is IERC721 {
291 
292     function name() external view returns (string memory);
293     function symbol() external view returns (string memory);
294     function tokenURI(uint256 tokenId) external view returns (string memory);
295 }
296 
297 pragma solidity ^0.8.4;
298 
299 interface IERC721A is IERC721, IERC721Metadata {
300 
301     error ApprovalCallerNotOwnerNorApproved();
302     error ApprovalQueryForNonexistentToken();
303     error ApproveToCaller();
304     error ApprovalToCurrentOwner();
305     error BalanceQueryForZeroAddress();
306     error MintToZeroAddress();
307     error MintZeroQuantity();
308     error OwnerQueryForNonexistentToken();
309     error TransferCallerNotOwnerNorApproved();
310     error TransferFromIncorrectOwner();
311     error TransferToNonERC721ReceiverImplementer();
312     error TransferToZeroAddress();
313     error URIQueryForNonexistentToken();
314 
315     struct TokenOwnership {
316         address addr;
317         uint64 startTimestamp;
318         bool burned;
319     }
320 
321     struct AddressData {
322         uint64 balance;
323         uint64 numberMinted;
324         uint64 numberBurned;
325         uint64 aux;
326     }
327 
328     function totalSupply() external view returns (uint256);
329 }
330 
331 pragma solidity ^0.8.4;
332 
333 contract ERC721A is Context, ERC165, IERC721A {
334     using Address for address;
335     using Strings for uint256;
336     uint256 internal _currentIndex;
337 
338     uint256 internal _burnCounter;
339     string private _name;
340     string private _symbol;
341 
342     mapping(uint256 => TokenOwnership) internal _ownerships;
343     mapping(address => AddressData) private _addressData;
344     mapping(uint256 => address) private _tokenApprovals;
345     mapping(address => mapping(address => bool)) private _operatorApprovals;
346 
347     constructor(string memory name_, string memory symbol_) {
348         _name = name_;
349         _symbol = symbol_;
350         _currentIndex = _startTokenId();
351     }
352 
353     function _startTokenId() internal view virtual returns (uint256) {
354         return 0;
355     }
356 
357     function totalSupply() public view override returns (uint256) {
358         unchecked {
359             return _currentIndex - _burnCounter - _startTokenId();
360         }
361     }
362 
363     function _totalMinted() internal view returns (uint256) {
364         unchecked {
365             return _currentIndex - _startTokenId();
366         }
367     }
368 
369     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
370         return
371             interfaceId == type(IERC721).interfaceId ||
372             interfaceId == type(IERC721Metadata).interfaceId ||
373             super.supportsInterface(interfaceId);
374     }
375 
376 
377     function balanceOf(address owner) public view override returns (uint256) {
378         if (owner == address(0)) revert BalanceQueryForZeroAddress();
379         return uint256(_addressData[owner].balance);
380     }
381 
382     function _numberMinted(address owner) internal view returns (uint256) {
383         return uint256(_addressData[owner].numberMinted);
384     }
385 
386     function _numberBurned(address owner) internal view returns (uint256) {
387         return uint256(_addressData[owner].numberBurned);
388     }
389 
390     function _getAux(address owner) internal view returns (uint64) {
391         return _addressData[owner].aux;
392     }
393 
394     function _setAux(address owner, uint64 aux) internal {
395         _addressData[owner].aux = aux;
396     }
397 
398     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
399         uint256 curr = tokenId;
400 
401         unchecked {
402             if (_startTokenId() <= curr) if (curr < _currentIndex) {
403                 TokenOwnership memory ownership = _ownerships[curr];
404                 if (!ownership.burned) {
405                     if (ownership.addr != address(0)) {
406                         return ownership;
407                     }
408                     while (true) {
409                         curr--;
410                         ownership = _ownerships[curr];
411                         if (ownership.addr != address(0)) {
412                             return ownership;
413                         }
414                     }
415                 }
416             }
417         }
418         revert OwnerQueryForNonexistentToken();
419     }
420 
421     function ownerOf(uint256 tokenId) public view override returns (address) {
422         return _ownershipOf(tokenId).addr;
423     }
424 
425     function name() public view virtual override returns (string memory) {
426         return _name;
427     }
428 
429     function symbol() public view virtual override returns (string memory) {
430         return _symbol;
431     }
432 
433     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
434         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
435 
436         string memory baseURI = _baseURI();
437         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
438     }
439 
440     function _baseURI() internal view virtual returns (string memory) {
441         return '';
442     }
443 
444     function approve(address to, uint256 tokenId) public override {
445         address owner = ERC721A.ownerOf(tokenId);
446         if (to == owner) revert ApprovalToCurrentOwner();
447 
448         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
449             revert ApprovalCallerNotOwnerNorApproved();
450         }
451 
452         _approve(to, tokenId, owner);
453     }
454 
455     function getApproved(uint256 tokenId) public view override returns (address) {
456         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
457 
458         return _tokenApprovals[tokenId];
459     }
460 
461     function setApprovalForAll(address operator, bool approved) public virtual override {
462         if (operator == _msgSender()) revert ApproveToCaller();
463 
464         _operatorApprovals[_msgSender()][operator] = approved;
465         emit ApprovalForAll(_msgSender(), operator, approved);
466     }
467 
468     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
469         return _operatorApprovals[owner][operator];
470     }
471 
472     function transferFrom(
473         address from,
474         address to,
475         uint256 tokenId
476     ) public virtual override {
477         _transfer(from, to, tokenId);
478     }
479 
480     function safeTransferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) public virtual override {
485         safeTransferFrom(from, to, tokenId, '');
486     }
487 
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes memory _data
493     ) public virtual override {
494         _transfer(from, to, tokenId);
495         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
496             revert TransferToNonERC721ReceiverImplementer();
497         }
498     }
499 
500     function _exists(uint256 tokenId) internal view returns (bool) {
501         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
502     }
503 
504     function _safeMint(address to, uint256 quantity) internal {
505         _safeMint(to, quantity, '');
506     }
507 
508     function _safeMint(
509         address to,
510         uint256 quantity,
511         bytes memory _data
512     ) internal {
513         uint256 startTokenId = _currentIndex;
514         if (to == address(0)) revert MintToZeroAddress();
515         if (quantity == 0) revert MintZeroQuantity();
516 
517         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
518 
519         unchecked {
520             _addressData[to].balance += uint64(quantity);
521             _addressData[to].numberMinted += uint64(quantity);
522             _ownerships[startTokenId].addr = to;
523             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
524 
525             uint256 updatedIndex = startTokenId;
526             uint256 end = updatedIndex + quantity;
527 
528             if (to.isContract()) {
529                 do {
530                     emit Transfer(address(0), to, updatedIndex);
531                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
532                         revert TransferToNonERC721ReceiverImplementer();
533                     }
534                 } while (updatedIndex < end);
535                 if (_currentIndex != startTokenId) revert();
536             } else {
537                 do {
538                     emit Transfer(address(0), to, updatedIndex++);
539                 } while (updatedIndex < end);
540             }
541             _currentIndex = updatedIndex;
542         }
543         _afterTokenTransfers(address(0), to, startTokenId, quantity);
544     }
545 
546     function _mint(address to, uint256 quantity) internal {
547         uint256 startTokenId = _currentIndex;
548         if (to == address(0)) revert MintToZeroAddress();
549         if (quantity == 0) revert MintZeroQuantity();
550 
551         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
552 
553         unchecked {
554             _addressData[to].balance += uint64(quantity);
555             _addressData[to].numberMinted += uint64(quantity);
556             _ownerships[startTokenId].addr = to;
557             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
558 
559             uint256 updatedIndex = startTokenId;
560             uint256 end = updatedIndex + quantity;
561 
562             do {
563                 emit Transfer(address(0), to, updatedIndex++);
564             } while (updatedIndex < end);
565 
566             _currentIndex = updatedIndex;
567         }
568         _afterTokenTransfers(address(0), to, startTokenId, quantity);
569     }
570 
571     function _transfer(
572         address from,
573         address to,
574         uint256 tokenId
575     ) private {
576         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
577 
578         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
579 
580         bool isApprovedOrOwner = (_msgSender() == from ||
581             isApprovedForAll(from, _msgSender()) ||
582             getApproved(tokenId) == _msgSender());
583 
584         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
585         if (to == address(0)) revert TransferToZeroAddress();
586 
587         _beforeTokenTransfers(from, to, tokenId, 1);
588 
589         _approve(address(0), tokenId, from);
590 
591         unchecked {
592             _addressData[from].balance -= 1;
593             _addressData[to].balance += 1;
594             TokenOwnership storage currSlot = _ownerships[tokenId];
595             currSlot.addr = to;
596             currSlot.startTimestamp = uint64(block.timestamp);
597 
598             uint256 nextTokenId = tokenId + 1;
599             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
600             if (nextSlot.addr == address(0)) {
601                 if (nextTokenId != _currentIndex) {
602                     nextSlot.addr = from;
603                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
604                 }
605             }
606         }
607 
608         emit Transfer(from, to, tokenId);
609         _afterTokenTransfers(from, to, tokenId, 1);
610     }
611 
612     function _burn(uint256 tokenId) internal virtual {
613         _burn(tokenId, false);
614     }
615 
616     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
617         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
618 
619         address from = prevOwnership.addr;
620 
621         if (approvalCheck) {
622             bool isApprovedOrOwner = (_msgSender() == from ||
623                 isApprovedForAll(from, _msgSender()) ||
624                 getApproved(tokenId) == _msgSender());
625 
626             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
627         }
628 
629         _beforeTokenTransfers(from, address(0), tokenId, 1);
630 
631         _approve(address(0), tokenId, from);
632 
633         unchecked {
634             AddressData storage addressData = _addressData[from];
635             addressData.balance -= 1;
636             addressData.numberBurned += 1;
637             TokenOwnership storage currSlot = _ownerships[tokenId];
638             currSlot.addr = from;
639             currSlot.startTimestamp = uint64(block.timestamp);
640             currSlot.burned = true;
641 
642             uint256 nextTokenId = tokenId + 1;
643             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
644             if (nextSlot.addr == address(0)) {
645                 if (nextTokenId != _currentIndex) {
646                     nextSlot.addr = from;
647                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
648                 }
649             }
650         }
651 
652         emit Transfer(from, address(0), tokenId);
653         _afterTokenTransfers(from, address(0), tokenId, 1);
654 
655         unchecked {
656             _burnCounter++;
657         }
658     }
659 
660     function _approve(
661         address to,
662         uint256 tokenId,
663         address owner
664     ) private {
665         _tokenApprovals[tokenId] = to;
666         emit Approval(owner, to, tokenId);
667     }
668 
669     function _checkContractOnERC721Received(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes memory _data
674     ) private returns (bool) {
675         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
676             return retval == IERC721Receiver(to).onERC721Received.selector;
677         } catch (bytes memory reason) {
678             if (reason.length == 0) {
679                 revert TransferToNonERC721ReceiverImplementer();
680             } else {
681                 assembly {
682                     revert(add(32, reason), mload(reason))
683                 }
684             }
685         }
686     }
687 
688     function _beforeTokenTransfers(
689         address from,
690         address to,
691         uint256 startTokenId,
692         uint256 quantity
693     ) internal virtual {}
694 
695     function _afterTokenTransfers(
696         address from,
697         address to,
698         uint256 startTokenId,
699         uint256 quantity
700     ) internal virtual {}
701 }
702 
703 contract FOXES is ERC721A, Ownable, ReentrancyGuard {
704 
705     using Strings for uint256;
706 
707     string public uriPrefix = "ipfs://QmaY8JHCU6YXztyxyDzVcPLVCsmf49mcDB1A2vjmeYEoS1/";
708     string public uriSuffix = "";
709 
710     // Mint
711     uint256 public MAX_SUPPLY = 1000;
712     uint256 public MAX_PER_TX = 20;
713     uint256 public PRICE = 0.05 ether;
714     
715     // FreeMint
716     uint256 public FREE_SUPPLY = 200;
717     uint256 public FREE_PER_WALLET = 2;
718 
719     bool public SALE_ACTIVE = false;
720 
721     constructor() ERC721A("FOXES OPERA", "FOXES") {
722     }
723 
724     modifier mintCompliance(uint256 _amount) {        
725         if (totalSupply() >= FREE_SUPPLY) {
726             require(PRICE * _amount == msg.value, "Insufficient funds!");
727             require(_amount > 0 && _amount <= MAX_PER_TX, "Exceeds max paid per tx!");
728         }else{
729             require(_amount > 0 && _amount <= FREE_PER_WALLET, "Exceeds max free mint per tx");
730         }
731         _;
732     }
733 
734     // Mint
735     function mint(uint256 _amount) public payable mintCompliance(_amount) {
736         _safeMint(msg.sender, _amount);
737     }
738 
739     function setFreeMint(uint256 _freeSupply, uint256 _freePerWallet) public onlyOwner() {
740         require(_freePerWallet > 0 && _freeSupply <= MAX_SUPPLY, "Not valid quantity!");
741         FREE_SUPPLY = _freeSupply;
742         FREE_PER_WALLET = _freePerWallet;
743     }
744 
745     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
746         uint256 ownerTokenCount = balanceOf(_owner);
747         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
748         uint256 currentTokenId = _startTokenId();
749         uint256 ownedTokenIndex = 0;
750         address latestOwnerAddress;
751         while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
752         TokenOwnership memory ownership = _ownerships[currentTokenId];
753         if (!ownership.burned) {
754             if (ownership.addr != address(0)) {
755             latestOwnerAddress = ownership.addr;
756             }
757             if (latestOwnerAddress == _owner) {
758             ownedTokenIds[ownedTokenIndex] = currentTokenId;
759             ownedTokenIndex++;
760             }
761         }
762         currentTokenId++;
763         }
764         return ownedTokenIds;
765     }
766 
767     function _startTokenId() internal view virtual override returns (uint256) {
768         return 1;
769     }
770 
771     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
772         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
773         string memory currentBaseURI = _baseURI();
774         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : '';
775     }
776 
777     function setupOS() external onlyOwner {
778         require(totalSupply() < MAX_SUPPLY, "Max supply exceeded!");
779         _safeMint(msg.sender, 1);
780     }
781 
782     function mintForAddress(uint256 _amount, address _receiver) public payable onlyOwner {
783         require(totalSupply() + _amount <= MAX_SUPPLY, "Exceeds max supply");
784         _safeMint(_receiver, _amount);
785     }
786 
787     function withdraw() public onlyOwner nonReentrant {
788         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
789         require(os);
790     }
791 
792     function toogleState() public onlyOwner {
793 		SALE_ACTIVE = !SALE_ACTIVE;
794 	}
795 
796     function setMaxPerTxn(uint256 _maxAPerTxn) public onlyOwner() {
797         MAX_PER_TX = _maxAPerTxn;
798     }
799 
800     function setCost(uint256 _price) public onlyOwner {
801         PRICE = _price;
802     }
803 
804     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
805         MAX_SUPPLY = _maxSupply;
806     }
807 
808     function _baseURI() internal view override returns (string memory) {
809         return uriPrefix;
810     }
811 
812     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
813         uriPrefix = _uriPrefix;
814     }
815 
816     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
817         uriSuffix = _uriSuffix;
818     }
819 
820 }