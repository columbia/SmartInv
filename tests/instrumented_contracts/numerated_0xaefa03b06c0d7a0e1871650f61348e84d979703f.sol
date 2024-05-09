1 // SPDX-License-Identifier: SimPL-2.0
2 // File: @openzeppelin/contracts/utils/Context.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 // File: @openzeppelin/contracts/access/Ownable.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
21 
22 pragma solidity ^0.8.0;
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
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 // File: erc721a/contracts/IERC721A.sol
61 
62 
63 // ERC721A Contracts v4.0.0
64 
65 pragma solidity ^0.8.4;
66 
67 interface IERC721A {
68 
69     error ApprovalCallerNotOwnerNorApproved();
70 
71     error ApprovalQueryForNonexistentToken();
72 
73     error ApproveToCaller();
74 
75     error ApprovalToCurrentOwner();
76 
77     error BalanceQueryForZeroAddress();
78 
79     error MintToZeroAddress();
80 
81     error MintZeroQuantity();
82 
83     error OwnerQueryForNonexistentToken();
84 
85     error TransferCallerNotOwnerNorApproved();
86 
87     error TransferFromIncorrectOwner();
88 
89     error TransferToNonERC721ReceiverImplementer();
90 
91     error TransferToZeroAddress();
92 
93     error URIQueryForNonexistentToken();
94 
95     struct TokenOwnership {
96         address addr;
97         uint64 startTimestamp;
98         bool burned;
99     }
100 
101     function totalSupply() external view returns (uint256);
102 
103     // ==============================
104     //            IERC165
105     // ==============================
106 
107     function supportsInterface(bytes4 interfaceId) external view returns (bool);
108 
109     // ==============================
110     //            IERC721
111     // ==============================
112 
113 
114     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
115 
116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
117 
118     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
119 
120     function balanceOf(address owner) external view returns (uint256 balance);
121 
122     function ownerOf(uint256 tokenId) external view returns (address owner);
123 
124     function safeTransferFrom(
125         address from,
126         address to,
127         uint256 tokenId,
128         bytes calldata data
129     ) external;
130 
131     function safeTransferFrom(
132         address from,
133         address to,
134         uint256 tokenId
135     ) external;
136 
137     function transferFrom(
138         address from,
139         address to,
140         uint256 tokenId
141     ) external;
142 
143     function approve(address to, uint256 tokenId) external;
144 
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     // ==============================
152     //        IERC721Metadata
153     // ==============================
154 
155     function name() external view returns (string memory);
156 
157     function symbol() external view returns (string memory);
158 
159     function tokenURI(uint256 tokenId) external view returns (string memory);
160 }
161 
162 // File: erc721a/contracts/ERC721A.sol
163 
164 
165 // ERC721A Contracts v4.0.0
166 
167 pragma solidity ^0.8.4;
168 
169 interface ERC721A__IERC721Receiver {
170     function onERC721Received(
171         address operator,
172         address from,
173         uint256 tokenId,
174         bytes calldata data
175     ) external returns (bytes4);
176 }
177 
178 contract ERC721A is IERC721A {
179     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
180 
181     uint256 private constant BITPOS_NUMBER_MINTED = 64;
182 
183     uint256 private constant BITPOS_NUMBER_BURNED = 128;
184 
185     uint256 private constant BITPOS_AUX = 192;
186 
187     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
188 
189     uint256 private constant BITPOS_START_TIMESTAMP = 160;
190 
191     uint256 private constant BITMASK_BURNED = 1 << 224;
192     
193     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
194 
195     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
196 
197     uint256 private _currentIndex;
198 
199     uint256 private _burnCounter;
200 
201     string private _name;
202 
203     string private _symbol;
204 
205     mapping(uint256 => uint256) private _packedOwnerships;
206 
207     mapping(address => uint256) private _packedAddressData;
208 
209     mapping(uint256 => address) private _tokenApprovals;
210 
211     mapping(address => mapping(address => bool)) private _operatorApprovals;
212 
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216         _currentIndex = _startTokenId();
217     }
218 
219     function _startTokenId() internal view virtual returns (uint256) {
220         return 0;
221     }
222 
223     function _nextTokenId() internal view returns (uint256) {
224         return _currentIndex;
225     }
226 
227     function totalSupply() public view override returns (uint256) {
228         unchecked {
229             return _currentIndex - _burnCounter - _startTokenId();
230         }
231     }
232 
233     function _totalMinted() internal view returns (uint256) {
234         unchecked {
235             return _currentIndex - _startTokenId();
236         }
237     }
238 
239     function _totalBurned() internal view returns (uint256) {
240         return _burnCounter;
241     }
242 
243     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
244         return
245             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
246             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
247             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
248     }
249 
250     function balanceOf(address owner) public view override returns (uint256) {
251         if (owner == address(0)) revert BalanceQueryForZeroAddress();
252         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
253     }
254 
255     function _numberMinted(address owner) internal view returns (uint256) {
256         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
257     }
258 
259     function _numberBurned(address owner) internal view returns (uint256) {
260         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
261     }
262 
263     function _getAux(address owner) internal view returns (uint64) {
264         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
265     }
266 
267     function _setAux(address owner, uint64 aux) internal {
268         uint256 packed = _packedAddressData[owner];
269         uint256 auxCasted;
270         assembly { 
271             auxCasted := aux
272         }
273         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
274         _packedAddressData[owner] = packed;
275     }
276 
277     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
278         uint256 curr = tokenId;
279 
280         unchecked {
281             if (_startTokenId() <= curr)
282                 if (curr < _currentIndex) {
283                     uint256 packed = _packedOwnerships[curr];
284                     if (packed & BITMASK_BURNED == 0) {
285                         while (packed == 0) {
286                             packed = _packedOwnerships[--curr];
287                         }
288                         return packed;
289                     }
290                 }
291         }
292         revert OwnerQueryForNonexistentToken();
293     }
294 
295     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
296         ownership.addr = address(uint160(packed));
297         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
298         ownership.burned = packed & BITMASK_BURNED != 0;
299     }
300 
301     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
302         return _unpackedOwnership(_packedOwnerships[index]);
303     }
304 
305     function _initializeOwnershipAt(uint256 index) internal {
306         if (_packedOwnerships[index] == 0) {
307             _packedOwnerships[index] = _packedOwnershipOf(index);
308         }
309     }
310 
311     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
312         return _unpackedOwnership(_packedOwnershipOf(tokenId));
313     }
314 
315     function ownerOf(uint256 tokenId) public view override returns (address) {
316         return address(uint160(_packedOwnershipOf(tokenId)));
317     }
318 
319     function name() public view virtual override returns (string memory) {
320         return _name;
321     }
322 
323     function symbol() public view virtual override returns (string memory) {
324         return _symbol;
325     }
326 
327     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
328         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
329 
330         string memory baseURI = _baseURI();
331         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
332     }
333 
334     function _baseURI() internal view virtual returns (string memory) {
335         return '';
336     }
337 
338     function _addressToUint256(address value) private pure returns (uint256 result) {
339         assembly {
340             result := value
341         }
342     }
343 
344     function _boolToUint256(bool value) private pure returns (uint256 result) {
345         assembly {
346             result := value
347         }
348     }
349 
350     function approve(address to, uint256 tokenId) public override {
351         address owner = address(uint160(_packedOwnershipOf(tokenId)));
352         if (to == owner) revert ApprovalToCurrentOwner();
353 
354         if (_msgSenderERC721A() != owner)
355             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
356                 revert ApprovalCallerNotOwnerNorApproved();
357             }
358 
359         _tokenApprovals[tokenId] = to;
360         emit Approval(owner, to, tokenId);
361     }
362 
363     function getApproved(uint256 tokenId) public view override returns (address) {
364         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
365 
366         return _tokenApprovals[tokenId];
367     }
368 
369     function setApprovalForAll(address operator, bool approved) public virtual override {
370         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
371 
372         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
373         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
374     }
375 
376     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
377         return _operatorApprovals[owner][operator];
378     }
379 
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) public virtual override {
385         _transfer(from, to, tokenId);
386     }
387 
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) public virtual override {
393         safeTransferFrom(from, to, tokenId, '');
394     }
395 
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId,
400         bytes memory _data
401     ) public virtual override {
402         _transfer(from, to, tokenId);
403         if (to.code.length != 0)
404             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
405                 revert TransferToNonERC721ReceiverImplementer();
406             }
407     }
408 
409     function _exists(uint256 tokenId) internal view returns (bool) {
410         return
411             _startTokenId() <= tokenId &&
412             tokenId < _currentIndex && 
413             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; 
414     }
415 
416     function _safeMint(address to, uint256 quantity) internal {
417         _safeMint(to, quantity, '');
418     }
419 
420     function _safeMint(
421         address to,
422         uint256 quantity,
423         bytes memory _data
424     ) internal {
425         uint256 startTokenId = _currentIndex;
426         if (to == address(0)) revert MintToZeroAddress();
427         if (quantity == 0) revert MintZeroQuantity();
428 
429         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
430 
431         unchecked {
432             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
433 
434             _packedOwnerships[startTokenId] =
435                 _addressToUint256(to) |
436                 (block.timestamp << BITPOS_START_TIMESTAMP) |
437                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
438 
439             uint256 updatedIndex = startTokenId;
440             uint256 end = updatedIndex + quantity;
441 
442             if (to.code.length != 0) {
443                 do {
444                     emit Transfer(address(0), to, updatedIndex);
445                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
446                         revert TransferToNonERC721ReceiverImplementer();
447                     }
448                 } while (updatedIndex < end);
449                 // Reentrancy protection
450                 if (_currentIndex != startTokenId) revert();
451             } else {
452                 do {
453                     emit Transfer(address(0), to, updatedIndex++);
454                 } while (updatedIndex < end);
455             }
456             _currentIndex = updatedIndex;
457         }
458         _afterTokenTransfers(address(0), to, startTokenId, quantity);
459     }
460 
461 
462     function _mint(address to, uint256 quantity) internal {
463         uint256 startTokenId = _currentIndex;
464         if (to == address(0)) revert MintToZeroAddress();
465         if (quantity == 0) revert MintZeroQuantity();
466 
467         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
468 
469         unchecked {
470             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
471 
472             _packedOwnerships[startTokenId] =
473                 _addressToUint256(to) |
474                 (block.timestamp << BITPOS_START_TIMESTAMP) |
475                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
476 
477             uint256 updatedIndex = startTokenId;
478             uint256 end = updatedIndex + quantity;
479 
480             do {
481                 emit Transfer(address(0), to, updatedIndex++);
482             } while (updatedIndex < end);
483 
484             _currentIndex = updatedIndex;
485         }
486         _afterTokenTransfers(address(0), to, startTokenId, quantity);
487     }
488 
489 
490     function _transfer(
491         address from,
492         address to,
493         uint256 tokenId
494     ) private {
495         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
496 
497         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
498 
499         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
500             isApprovedForAll(from, _msgSenderERC721A()) ||
501             getApproved(tokenId) == _msgSenderERC721A());
502 
503         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
504         if (to == address(0)) revert TransferToZeroAddress();
505 
506         _beforeTokenTransfers(from, to, tokenId, 1);
507 
508         delete _tokenApprovals[tokenId];
509 
510         unchecked {
511             --_packedAddressData[from]; 
512             ++_packedAddressData[to]; 
513 
514 
515             _packedOwnerships[tokenId] =
516                 _addressToUint256(to) |
517                 (block.timestamp << BITPOS_START_TIMESTAMP) |
518                 BITMASK_NEXT_INITIALIZED;
519 
520             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
521                 uint256 nextTokenId = tokenId + 1;
522                 if (_packedOwnerships[nextTokenId] == 0) {
523                     if (nextTokenId != _currentIndex) {
524                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
525                     }
526                 }
527             }
528         }
529 
530         emit Transfer(from, to, tokenId);
531         _afterTokenTransfers(from, to, tokenId, 1);
532     }
533 
534     function _burn(uint256 tokenId) internal virtual {
535         _burn(tokenId, false);
536     }
537 
538     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
539         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
540 
541         address from = address(uint160(prevOwnershipPacked));
542 
543         if (approvalCheck) {
544             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
545                 isApprovedForAll(from, _msgSenderERC721A()) ||
546                 getApproved(tokenId) == _msgSenderERC721A());
547 
548             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
549         }
550 
551         _beforeTokenTransfers(from, address(0), tokenId, 1);
552 
553         delete _tokenApprovals[tokenId];
554 
555         unchecked {
556             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
557 
558             _packedOwnerships[tokenId] =
559                 _addressToUint256(from) |
560                 (block.timestamp << BITPOS_START_TIMESTAMP) |
561                 BITMASK_BURNED | 
562                 BITMASK_NEXT_INITIALIZED;
563 
564             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
565                 uint256 nextTokenId = tokenId + 1;
566                 if (_packedOwnerships[nextTokenId] == 0) {
567                     if (nextTokenId != _currentIndex) {
568                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
569                     }
570                 }
571             }
572         }
573 
574         emit Transfer(from, address(0), tokenId);
575         _afterTokenTransfers(from, address(0), tokenId, 1);
576         unchecked {
577             _burnCounter++;
578         }
579     }
580 
581     function _checkContractOnERC721Received(
582         address from,
583         address to,
584         uint256 tokenId,
585         bytes memory _data
586     ) private returns (bool) {
587         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
588             bytes4 retval
589         ) {
590             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
591         } catch (bytes memory reason) {
592             if (reason.length == 0) {
593                 revert TransferToNonERC721ReceiverImplementer();
594             } else {
595                 assembly {
596                     revert(add(32, reason), mload(reason))
597                 }
598             }
599         }
600     }
601 
602     function _beforeTokenTransfers(
603         address from,
604         address to,
605         uint256 startTokenId,
606         uint256 quantity
607     ) internal virtual {}
608 
609     function _afterTokenTransfers(
610         address from,
611         address to,
612         uint256 startTokenId,
613         uint256 quantity
614     ) internal virtual {}
615 
616     function _msgSenderERC721A() internal view virtual returns (address) {
617         return msg.sender;
618     }
619 
620     function _toString(uint256 value) internal pure returns (string memory ptr) {
621         assembly {
622 
623             ptr := add(mload(0x40), 128)
624             // Update the free memory pointer to allocate.
625             mstore(0x40, ptr)
626 
627             // Cache the end of the memory to calculate the length later.
628             let end := ptr
629             for { 
630                 // Initialize and perform the first pass without check.
631                 let temp := value
632                 // Move the pointer 1 byte leftwards to point to an empty character slot.
633                 ptr := sub(ptr, 1)
634                 // Write the character to the pointer. 48 is the ASCII index of '0'.
635                 mstore8(ptr, add(48, mod(temp, 10)))
636                 temp := div(temp, 10)
637             } temp { 
638                 // Keep dividing `temp` until zero.
639                 temp := div(temp, 10)
640             } { // Body of the for loop.
641                 ptr := sub(ptr, 1)
642                 mstore8(ptr, add(48, mod(temp, 10)))
643             }
644             
645             let length := sub(end, ptr)
646             // Move the pointer 32 bytes leftwards to make room for the length.
647             ptr := sub(ptr, 32)
648             // Store the length.
649             mstore(ptr, length)
650         }
651     }
652 }
653 
654 // File: nft.sol
655 
656 
657 
658 pragma solidity ^0.8.13;
659 
660 
661 
662 contract CatchOfTheDay is Ownable, ERC721A {
663     uint256 public maxSupply                    = 3000;
664     uint256 public maxFreeSupply                = 3000;
665     uint256 public maxPerAddressDuringFreeMint  = 1;
666     bool    public saleIsActive                 = false;
667 
668     address constant internal TEAM_ADDRESS = 0xdaa0340ABb4af5c624a04742F97CA476CAfB7751;
669 
670     string private _baseTokenURI;
671 
672     mapping(address => uint256) public freeMintedAmount;
673     mapping(address => uint256) public mintedAmount;
674 
675     constructor() ERC721A("Catch Of The Day", "CatchNFT") {
676         _safeMint(msg.sender, 200);
677     }
678 
679     modifier mintCompliance() {
680         require(saleIsActive, "Sale is not active yet.");
681         require(tx.origin == msg.sender, "Caller cannot be a contract.");
682         _;
683     }
684 
685     function freeMint(uint256 _quantity) external mintCompliance() {
686         require(
687             maxFreeSupply >= totalSupply() + _quantity,
688             "Exceeds max free supply."
689         );
690         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
691         require(
692             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
693             "Exceeds max free mints per address!"
694         );
695         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
696         _safeMint(msg.sender, _quantity);
697     }
698 
699     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
700         maxPerAddressDuringFreeMint = _amount;
701     }
702 
703     function flipSale() public onlyOwner {
704         saleIsActive = !saleIsActive;
705     }
706 
707     function cutMaxSupply(uint256 _amount) public onlyOwner {
708         require(
709             maxSupply - _amount >= totalSupply(), 
710             "Supply cannot fall below minted tokens."
711         );
712         maxSupply -= _amount;
713     }
714 
715     function setBaseURI(string calldata baseURI) external onlyOwner {
716         _baseTokenURI = baseURI;
717     }
718 
719     function _baseURI() internal view virtual override returns (string memory) {
720         return _baseTokenURI;
721     }
722 
723     function withdraw() external payable onlyOwner {
724 
725         (bool success, ) = payable(TEAM_ADDRESS).call{
726             value: address(this).balance
727         }("");
728         require(success, "transfer failed.");
729     }
730 }