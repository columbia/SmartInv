1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.0
3 /**
4 ███████╗████████╗██╗  ██╗    ██████╗  ██████╗ ██╗███╗   ██╗██╗  ██╗███████╗
5 ██╔════╝╚══██╔══╝██║  ██║    ██╔══██╗██╔═══██╗██║████╗  ██║██║ ██╔╝██╔════╝
6 █████╗     ██║   ███████║    ██║  ██║██║   ██║██║██╔██╗ ██║█████╔╝ ███████╗
7 ██╔══╝     ██║   ██╔══██║    ██║  ██║██║   ██║██║██║╚██╗██║██╔═██╗ ╚════██║
8 ███████╗   ██║   ██║  ██║    ██████╔╝╚██████╔╝██║██║ ╚████║██║  ██╗███████║
9 ╚══════╝   ╚═╝   ╚═╝  ╚═╝    ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
10     __                  __                     ____               __  
11    / /_  __  __   _____/ /_  ____  _________  / __/_______  _____/ /_ 
12   / __ \/ / / /  / ___/ __ \/ __ \/ ___/ __ \/ /_/ ___/ _ \/ ___/ __ \
13  / /_/ / /_/ /  / /__/ / / / /_/ / /__/ /_/ / __/ /  /  __(__  ) / / /
14 /_.___/\__, /   \___/_/ /_/\____/\___/\____/_/ /_/   \___/____/_/ /_/ 
15       /____/                                                                                                                       
16  */
17 pragma solidity ^0.8.0;
18 /** ________     __                        ____                  __        __                            __ 
19    /  _/ __ \   / /__________ _____  _____/ __/__  _____   _____/ /_____ _/ /____  ____ ___  ___  ____  / /_
20    / // /_/ /  / __/ ___/ __ `/ __ \/ ___/ /_/ _ \/ ___/  / ___/ __/ __ `/ __/ _ \/ __ `__ \/ _ \/ __ \/ __/
21  _/ // ____/  / /_/ /  / /_/ / / / (__  ) __/  __/ /     (__  ) /_/ /_/ / /_/  __/ / / / / /  __/ / / / /_  
22 /___/_/       \__/_/   \__,_/_/ /_/____/_/  \___/_/     /____/\__/\__,_/\__/\___/_/ /_/ /_/\___/_/ /_/\__/  
23   
24 Choco Fresh LLC hereby irrevocably assigns and otherwise transfers 
25 the intellectual property rights that which include the likeness of the enclosed 
26 image attached to the corresponding token, to the warranted NFT Owner.
27 
28 The enclosed image on the corresponding token is hereby 
29 the intellectual property of each warranted NFT Owner. The NFT Owner has authorized 
30 use of the image attached to their token for personal & commercial use.
31 
32 Choco Fresh LLC retains the “Eth Doinks” copyright & intellectual 
33 properties including: NIL, & Authors Rights. In addition Choco Fresh LLC 
34 retains copyright & intellectual properties including: 
35 NIL, & Authors Rights of the original attributes.                                                                                                      
36 **/
37 library Strings {
38     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
39     uint8 private constant _ADDRESS_LENGTH = 20;
40 
41  
42     function toString(uint256 value) internal pure returns (string memory) {
43        
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     function toHexString(uint256 value) internal pure returns (string memory) {
63         if (value == 0) {
64             return "0x00";
65         }
66         uint256 temp = value;
67         uint256 length = 0;
68         while (temp != 0) {
69             length++;
70             temp >>= 8;
71         }
72         return toHexString(value, length);
73     }
74 
75     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
76         bytes memory buffer = new bytes(2 * length + 2);
77         buffer[0] = "0";
78         buffer[1] = "x";
79         for (uint256 i = 2 * length + 1; i > 1; --i) {
80             buffer[i] = _HEX_SYMBOLS[value & 0xf];
81             value >>= 4;
82         }
83         require(value == 0, "Strings: hex length insufficient");
84         return string(buffer);
85     }
86 
87 
88     function toHexString(address addr) internal pure returns (string memory) {
89         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
90     }
91 }
92 
93 
94 pragma solidity ^0.8.1;
95 
96 library Address {
97  
98     function isContract(address account) internal view returns (bool) {
99     
100 
101         return account.code.length > 0;
102     }
103   
104     function sendValue(address payable recipient, uint256 amount) internal {
105         require(address(this).balance >= amount, "Address: insufficient balance");
106 
107         (bool success, ) = recipient.call{value: amount}("");
108         require(success, "Address: unable to send value, recipient may have reverted");
109     }
110 
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     function functionCall(
116         address target,
117         bytes memory data,
118         string memory errorMessage
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value
127     ) internal returns (bytes memory) {
128         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
129     }
130 
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143    
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     function functionStaticCall(
149         address target,
150         bytes memory data,
151         string memory errorMessage
152     ) internal view returns (bytes memory) {
153         require(isContract(target), "Address: static call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.staticcall(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
161     }
162 
163     function functionDelegateCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.delegatecall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     function verifyCallResult(
175         bool success,
176         bytes memory returndata,
177         string memory errorMessage
178     ) internal pure returns (bytes memory) {
179         if (success) {
180             return returndata;
181         } else {
182            
183             if (returndata.length > 0) {
184                 
185                 assembly {
186                     let returndata_size := mload(returndata)
187                     revert(add(32, returndata), returndata_size)
188                 }
189             } else {
190                 revert(errorMessage);
191             }
192         }
193     }
194 }
195 
196 
197 
198 pragma solidity ^0.8.0;
199 
200 abstract contract ReentrancyGuard {
201 
202     uint256 private constant _NOT_ENTERED = 1;
203     uint256 private constant _ENTERED = 2;
204 
205     uint256 private _status;
206 
207     constructor() {
208         _status = _NOT_ENTERED;
209     }
210 
211     modifier nonReentrant() {
212    
213         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
214 
215      
216         _status = _ENTERED;
217 
218         _;
219 
220         _status = _NOT_ENTERED;
221     }
222 }
223 
224 
225 pragma solidity ^0.8.0;
226 
227 abstract contract Context {
228     function _msgSender() internal view virtual returns (address) {
229         return msg.sender;
230     }
231 
232     function _msgData() internal view virtual returns (bytes calldata) {
233         return msg.data;
234     }
235 }
236 
237 
238 pragma solidity ^0.8.0;
239 
240 abstract contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     constructor() {
246         _transferOwnership(_msgSender());
247     }
248 
249     modifier onlyOwner() {
250         _checkOwner();
251         _;
252     }
253 
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     function _checkOwner() internal view virtual {
259         require(owner() == _msgSender(), "Ownable: caller is not the owner");
260     }
261 
262     function renounceOwnership() public virtual onlyOwner {
263         _transferOwnership(address(0));
264     }
265 
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         _transferOwnership(newOwner);
269     }
270 
271     function _transferOwnership(address newOwner) internal virtual {
272         address oldOwner = _owner;
273         _owner = newOwner;
274         emit OwnershipTransferred(oldOwner, newOwner);
275     }
276 }
277 
278 
279 pragma solidity ^0.8.4;
280 
281 interface IERC721A {
282   
283     error ApprovalCallerNotOwnerNorApproved();
284 
285     error ApprovalQueryForNonexistentToken();
286 
287     error ApproveToCaller();
288 
289     error BalanceQueryForZeroAddress();
290 
291     error MintToZeroAddress();
292 
293     error MintZeroQuantity();
294 
295     error OwnerQueryForNonexistentToken();
296 
297     error TransferCallerNotOwnerNorApproved();
298 
299     error TransferFromIncorrectOwner();
300 
301     error TransferToNonERC721ReceiverImplementer();
302 
303     error TransferToZeroAddress();
304 
305     error URIQueryForNonexistentToken();
306 
307     error MintERC2309QuantityExceedsLimit();
308 
309     error OwnershipNotInitializedForExtraData();
310 
311     // =============================================================
312     //                            STRUCTS
313     // =============================================================
314 
315     struct TokenOwnership {
316         // The address of the owner.
317         address addr;
318 
319         uint64 startTimestamp;
320 
321         bool burned;
322 
323         uint24 extraData;
324     }
325 
326     // =============================================================
327     //                         TOKEN COUNTERS
328     // =============================================================
329 
330     function totalSupply() external view returns (uint256);
331 
332     // =============================================================
333     //                            IERC165
334     // =============================================================
335 
336     function supportsInterface(bytes4 interfaceId) external view returns (bool);
337 
338     // =============================================================
339     //                            IERC721
340     // =============================================================
341 
342     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
343 
344     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
345 
346     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
347 
348     function balanceOf(address owner) external view returns (uint256 balance);
349 
350     function ownerOf(uint256 tokenId) external view returns (address owner);
351 
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId,
356         bytes calldata data
357     ) external;
358 
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId
363     ) external;
364 
365     function transferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external;
370 
371     function approve(address to, uint256 tokenId) external;
372 
373     function setApprovalForAll(address operator, bool _approved) external;
374 
375     function getApproved(uint256 tokenId) external view returns (address operator);
376 
377     function isApprovedForAll(address owner, address operator) external view returns (bool);
378 
379     // =============================================================
380     //                        IERC721Metadata
381     // =============================================================
382 
383     function name() external view returns (string memory);
384 
385     function symbol() external view returns (string memory);
386 
387     function tokenURI(uint256 tokenId) external view returns (string memory);
388 
389     // =============================================================
390     //                           IERC2309
391     // =============================================================
392 
393     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
394 }
395 
396 // ERC721A Contracts v4.2.0
397 // Creator: Chiru Labs
398 
399 pragma solidity ^0.8.4;
400 
401 
402 interface ERC721A__IERC721Receiver {
403     function onERC721Received(
404         address operator,
405         address from,
406         uint256 tokenId,
407         bytes calldata data
408     ) external returns (bytes4);
409 }
410 
411 contract ERC721A is IERC721A {
412 
413     struct TokenApprovalRef {
414         address value;
415     }
416 
417     // =============================================================
418     //                           CONSTANTS
419     // =============================================================
420 
421     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
422     
423     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
424    
425     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
426     
427     uint256 private constant _BITPOS_AUX = 192;
428 
429     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
430    
431     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
432  
433     uint256 private constant _BITMASK_BURNED = 1 << 224;
434 
435     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
436 
437     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
438 
439     uint256 private constant _BITPOS_EXTRA_DATA = 232;
440 
441     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
442 
443     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
444 
445     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
446 
447     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
448         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
449 
450     // =============================================================
451     //                            STORAGE
452     // =============================================================
453 
454     uint256 private _currentIndex;
455 
456     uint256 private _burnCounter;
457 
458     string private _name;
459 
460     string private _symbol;
461 
462     mapping(uint256 => uint256) private _packedOwnerships;
463 
464     mapping(address => uint256) private _packedAddressData;
465 
466     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
467 
468     mapping(address => mapping(address => bool)) private _operatorApprovals;
469 
470     // =============================================================
471     //                          CONSTRUCTOR
472     // =============================================================
473 
474     constructor(string memory name_, string memory symbol_) {
475         _name = name_;
476         _symbol = symbol_;
477         _currentIndex = _startTokenId();
478     }
479 
480     // =============================================================
481     //                   TOKEN COUNTING OPERATIONS
482     // =============================================================
483 
484     function _startTokenId() internal view virtual returns (uint256) {
485         return 0;
486     }
487 
488     function _nextTokenId() internal view virtual returns (uint256) {
489         return _currentIndex;
490     }
491 
492     function totalSupply() public view virtual override returns (uint256) {
493 
494         unchecked {
495             return _currentIndex - _burnCounter - _startTokenId();
496         }
497     }
498 
499     function _totalMinted() internal view virtual returns (uint256) {
500 
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     function _totalBurned() internal view virtual returns (uint256) {
507         return _burnCounter;
508     }
509 
510     // =============================================================
511     //                    ADDRESS DATA OPERATIONS
512     // =============================================================
513 
514     function balanceOf(address owner) public view virtual override returns (uint256) {
515         if (owner == address(0)) revert BalanceQueryForZeroAddress();
516         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     function _numberMinted(address owner) internal view returns (uint256) {
520         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     function _numberBurned(address owner) internal view returns (uint256) {
524         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
525     }
526 
527     function _getAux(address owner) internal view returns (uint64) {
528         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
529     }
530 
531     function _setAux(address owner, uint64 aux) internal virtual {
532         uint256 packed = _packedAddressData[owner];
533         uint256 auxCasted;
534 
535         assembly {
536             auxCasted := aux
537         }
538         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
539         _packedAddressData[owner] = packed;
540     }
541 
542     // =============================================================
543     //                            IERC165
544     // =============================================================
545 
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547 
548         return
549             interfaceId == 0x01ffc9a7 || 
550             interfaceId == 0x80ac58cd || 
551             interfaceId == 0x5b5e139f; 
552     }
553 
554     // =============================================================
555     //                        IERC721Metadata
556     // =============================================================
557 
558     function name() public view virtual override returns (string memory) {
559         return _name;
560     }
561 
562     function symbol() public view virtual override returns (string memory) {
563         return _symbol;
564     }
565 
566     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
567         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
568 
569         string memory baseURI = _baseURI();
570         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
571     }
572 
573     function _baseURI() internal view virtual returns (string memory) {
574         return '';
575     }
576 
577     // =============================================================
578     //                     OWNERSHIPS OPERATIONS
579     // =============================================================
580 
581     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
582         return address(uint160(_packedOwnershipOf(tokenId)));
583     }
584 
585     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
586         return _unpackedOwnership(_packedOwnershipOf(tokenId));
587     }
588 
589     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
590         return _unpackedOwnership(_packedOwnerships[index]);
591     }
592 
593     function _initializeOwnershipAt(uint256 index) internal virtual {
594         if (_packedOwnerships[index] == 0) {
595             _packedOwnerships[index] = _packedOwnershipOf(index);
596         }
597     }
598 
599     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
600         uint256 curr = tokenId;
601 
602         unchecked {
603             if (_startTokenId() <= curr)
604                 if (curr < _currentIndex) {
605                     uint256 packed = _packedOwnerships[curr];
606 
607                     if (packed & _BITMASK_BURNED == 0) {
608 
609                         while (packed == 0) {
610                             packed = _packedOwnerships[--curr];
611                         }
612                         return packed;
613                     }
614                 }
615         }
616         revert OwnerQueryForNonexistentToken();
617     }
618 
619     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
620         ownership.addr = address(uint160(packed));
621         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
622         ownership.burned = packed & _BITMASK_BURNED != 0;
623         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
624     }
625 
626     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
627         assembly {
628 
629             owner := and(owner, _BITMASK_ADDRESS)
630 
631             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
632         }
633     }
634 
635     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
636 
637         assembly {
638 
639             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
640         }
641     }
642 
643     // =============================================================
644     //                      APPROVAL OPERATIONS
645     // =============================================================
646 
647     function approve(address to, uint256 tokenId) public virtual override {
648         address owner = ownerOf(tokenId);
649 
650         if (_msgSenderERC721A() != owner)
651             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
652                 revert ApprovalCallerNotOwnerNorApproved();
653             }
654 
655         _tokenApprovals[tokenId].value = to;
656         emit Approval(owner, to, tokenId);
657     }
658 
659     function getApproved(uint256 tokenId) public view virtual override returns (address) {
660         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
661 
662         return _tokenApprovals[tokenId].value;
663     }
664 
665     function setApprovalForAll(address operator, bool approved) public virtual override {
666         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
667 
668         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
669         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
670     }
671 
672     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
673         return _operatorApprovals[owner][operator];
674     }
675 
676     function _exists(uint256 tokenId) internal view virtual returns (bool) {
677         return
678             _startTokenId() <= tokenId &&
679             tokenId < _currentIndex && 
680             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0;
681     }
682 
683 
684     function _isSenderApprovedOrOwner(
685         address approvedAddress,
686         address owner,
687         address msgSender
688     ) private pure returns (bool result) {
689         assembly {
690 
691             owner := and(owner, _BITMASK_ADDRESS)
692 
693             msgSender := and(msgSender, _BITMASK_ADDRESS)
694 
695             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
696         }
697     }
698 
699 
700     function _getApprovedSlotAndAddress(uint256 tokenId)
701         private
702         view
703         returns (uint256 approvedAddressSlot, address approvedAddress)
704     {
705         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
706 
707         assembly {
708             approvedAddressSlot := tokenApproval.slot
709             approvedAddress := sload(approvedAddressSlot)
710         }
711     }
712 
713     // =============================================================
714     //                      TRANSFER OPERATIONS
715     // =============================================================
716 
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
723 
724         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
725 
726         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
727 
728         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
729             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
730 
731         if (to == address(0)) revert TransferToZeroAddress();
732 
733         _beforeTokenTransfers(from, to, tokenId, 1);
734 
735 
736         assembly {
737             if approvedAddress {
738 
739                 sstore(approvedAddressSlot, 0)
740             }
741         }
742 
743         unchecked {
744 
745             --_packedAddressData[from];
746             ++_packedAddressData[to];
747 
748   
749             _packedOwnerships[tokenId] = _packOwnershipData(
750                 to,
751                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
752             );
753 
754             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
755                 uint256 nextTokenId = tokenId + 1;
756 
757                 if (_packedOwnerships[nextTokenId] == 0) {
758 
759                     if (nextTokenId != _currentIndex) {
760                       
761                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
762                     }
763                 }
764             }
765         }
766 
767         emit Transfer(from, to, tokenId);
768         _afterTokenTransfers(from, to, tokenId, 1);
769     }
770 
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId
775     ) public virtual override {
776         safeTransferFrom(from, to, tokenId, '');
777     }
778 
779 
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) public virtual override {
786         transferFrom(from, to, tokenId);
787         if (to.code.length != 0)
788             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
789                 revert TransferToNonERC721ReceiverImplementer();
790             }
791     }
792 
793     function _beforeTokenTransfers(
794         address from,
795         address to,
796         uint256 startTokenId,
797         uint256 quantity
798     ) internal virtual {}
799 
800     function _afterTokenTransfers(
801         address from,
802         address to,
803         uint256 startTokenId,
804         uint256 quantity
805     ) internal virtual {}
806 
807     function _checkContractOnERC721Received(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) private returns (bool) {
813         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
814             bytes4 retval
815         ) {
816             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
817         } catch (bytes memory reason) {
818             if (reason.length == 0) {
819                 revert TransferToNonERC721ReceiverImplementer();
820             } else {
821                 assembly {
822                     revert(add(32, reason), mload(reason))
823                 }
824             }
825         }
826     }
827 
828     // =============================================================
829     //                        MINT OPERATIONS
830     // =============================================================
831 
832     function _mint(address to, uint256 quantity) internal virtual {
833         uint256 startTokenId = _currentIndex;
834         if (quantity == 0) revert MintZeroQuantity();
835 
836         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
837 
838 
839         unchecked {
840  
841             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
842 
843             _packedOwnerships[startTokenId] = _packOwnershipData(
844                 to,
845                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
846             );
847 
848             uint256 toMasked;
849             uint256 end = startTokenId + quantity;
850 
851             assembly {
852 
853                 toMasked := and(to, _BITMASK_ADDRESS)
854 
855                 log4(
856                     0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, startTokenId 
857                 )
858 
859                 for {
860                     let tokenId := add(startTokenId, 1)
861                 } iszero(eq(tokenId, end)) {
862                     tokenId := add(tokenId, 1)
863                 } {
864 
865                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
866                 }
867             }
868             if (toMasked == 0) revert MintToZeroAddress();
869 
870             _currentIndex = end;
871         }
872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
873     }
874 
875     function _mintERC2309(address to, uint256 quantity) internal virtual {
876         uint256 startTokenId = _currentIndex;
877         if (to == address(0)) revert MintToZeroAddress();
878         if (quantity == 0) revert MintZeroQuantity();
879         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         unchecked {
884 
885             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
886 
887             _packedOwnerships[startTokenId] = _packOwnershipData(
888                 to,
889                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
890             );
891 
892             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
893 
894             _currentIndex = startTokenId + quantity;
895         }
896         _afterTokenTransfers(address(0), to, startTokenId, quantity);
897     }
898 
899     function _safeMint(
900         address to,
901         uint256 quantity,
902         bytes memory _data
903     ) internal virtual {
904         _mint(to, quantity);
905 
906         unchecked {
907             if (to.code.length != 0) {
908                 uint256 end = _currentIndex;
909                 uint256 index = end - quantity;
910                 do {
911                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
912                         revert TransferToNonERC721ReceiverImplementer();
913                     }
914                 } while (index < end);
915 
916                 if (_currentIndex != end) revert();
917             }
918         }
919     }
920 
921     function _safeMint(address to, uint256 quantity) internal virtual {
922         _safeMint(to, quantity, '');
923     }
924 
925     // =============================================================
926     //                        BURN OPERATIONS
927     // =============================================================
928 
929     function _burn(uint256 tokenId) internal virtual {
930         _burn(tokenId, false);
931     }
932 
933     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
934         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
935 
936         address from = address(uint160(prevOwnershipPacked));
937 
938         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
939 
940         if (approvalCheck) {
941 
942             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
943                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
944         }
945 
946         _beforeTokenTransfers(from, address(0), tokenId, 1);
947 
948         assembly {
949             if approvedAddress {
950 
951                 sstore(approvedAddressSlot, 0)
952             }
953         }
954 
955         unchecked {
956 
957             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
958 
959             _packedOwnerships[tokenId] = _packOwnershipData(
960                 from,
961                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
962             );
963 
964             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
965                 uint256 nextTokenId = tokenId + 1;
966 
967                 if (_packedOwnerships[nextTokenId] == 0) {
968 
969                     if (nextTokenId != _currentIndex) {
970 
971                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
972                     }
973                 }
974             }
975         }
976 
977         emit Transfer(from, address(0), tokenId);
978         _afterTokenTransfers(from, address(0), tokenId, 1);
979 
980         unchecked {
981             _burnCounter++;
982         }
983     }
984 
985     // =============================================================
986     //                     EXTRA DATA OPERATIONS
987     // =============================================================
988 
989     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
990         uint256 packed = _packedOwnerships[index];
991         if (packed == 0) revert OwnershipNotInitializedForExtraData();
992         uint256 extraDataCasted;
993 
994         assembly {
995             extraDataCasted := extraData
996         }
997         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
998         _packedOwnerships[index] = packed;
999     }
1000 
1001     function _extraData(
1002         address from,
1003         address to,
1004         uint24 previousExtraData
1005     ) internal view virtual returns (uint24) {}
1006 
1007 
1008     function _nextExtraData(
1009         address from,
1010         address to,
1011         uint256 prevOwnershipPacked
1012     ) private view returns (uint256) {
1013         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1014         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1015     }
1016 
1017     // =============================================================
1018     //                       OTHER OPERATIONS
1019     // =============================================================
1020 
1021     function _msgSenderERC721A() internal view virtual returns (address) {
1022         return msg.sender;
1023     }
1024 
1025   
1026     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1027         assembly {
1028 
1029             ptr := add(mload(0x40), 128)
1030 
1031             mstore(0x40, ptr)
1032 
1033 
1034             let end := ptr
1035 
1036             for {
1037 
1038                 let temp := value
1039                 
1040                 ptr := sub(ptr, 1)
1041                 
1042                 mstore8(ptr, add(48, mod(temp, 10)))
1043                 temp := div(temp, 10)
1044             } temp {
1045 
1046                 temp := div(temp, 10)
1047             } {
1048            
1049                 ptr := sub(ptr, 1)
1050                 mstore8(ptr, add(48, mod(temp, 10)))
1051             }
1052 
1053             let length := sub(end, ptr)
1054           
1055             ptr := sub(ptr, 32)
1056             
1057             mstore(ptr, length)
1058         }
1059     }
1060 }
1061 
1062 // File: contracts/DOINKS.sol
1063 
1064 pragma solidity ^0.8.0;
1065 
1066 // =============================================================
1067 //                       PROJECT INFO
1068 // =============================================================
1069 error FreeMintNotActive();
1070 
1071 contract ethdoinks is ERC721A, Ownable, ReentrancyGuard {
1072   using Address for address;
1073   using Strings for uint;
1074 
1075   string  private  baseTokenURI = "ipfs://bafybeiepfviadstx4dmvkvscukpwa6evlaambof6bary2vr5l3gyd263jm";
1076 
1077   uint256 public constant  maxSupply = 420;
1078   uint256 public constant MAX_MINTS_PER_TX = 5;
1079   uint256 public constant FREE_MINTS_PER_TX = 1;
1080   uint256 public constant PUBLIC_SALE_PRICE = .0069 ether;
1081   uint256 public constant TOTAL_FREE_MINTS = 212;
1082   bool public isFreeMintActive = false;
1083   bool public isPublicSaleActive = false;
1084   
1085   mapping(address => bool) public claimedFreeMint;
1086 
1087       constructor(string memory _baseTokenURI) ERC721A("Eth Doinks", "DOINK") {
1088 
1089   }
1090     function freeMint() external {
1091     if(!isFreeMintActive) revert FreeMintNotActive();
1092     require(totalSupply() < TOTAL_FREE_MINTS, "No more free mints available");
1093     require(!claimedFreeMint[msg. sender],"You have already claimed your free mint");
1094     claimedFreeMint[msg.sender] = true;
1095     _safeMint (msg. sender, 1);
1096     }
1097     
1098 
1099   function mint(uint256 numberOfTokens)
1100       external
1101       payable
1102   
1103   {
1104     require(isPublicSaleActive, "Public sale is not open");
1105     require(totalSupply() > TOTAL_FREE_MINTS, "Free mints are still available"); // you can't mint until free mints are sold
1106     require(
1107     totalSupply() + numberOfTokens <= maxSupply,
1108         "Maximum supply exceeded"
1109     );
1110 
1111     {
1112         require(
1113             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1114             "Incorrect ETH value sent"
1115         );
1116     
1117     _safeMint(msg.sender, numberOfTokens);
1118     }
1119   }
1120 
1121   function setBaseURI(string memory baseURI)
1122     public
1123     onlyOwner
1124   {
1125     baseTokenURI = baseURI;
1126   }
1127 
1128   function _startTokenId() internal view virtual override returns (uint256) {
1129         return 1;
1130     }
1131 
1132   function AirdropMint(uint quantity, address user)
1133     public
1134     onlyOwner
1135   {
1136     require(
1137       quantity > 0,
1138       "Invalid mint amount"
1139     );
1140     require(
1141       totalSupply() + quantity <= maxSupply,
1142       "Maximum supply exceeded"
1143     );
1144     _safeMint(user, quantity);
1145   }
1146 
1147   function withdraw()
1148     public
1149     onlyOwner
1150     nonReentrant
1151   {
1152     Address.sendValue(payable(msg.sender), address(this).balance);
1153   }
1154 
1155   function tokenURI(uint _tokenId)
1156     public
1157     view
1158     virtual
1159     override
1160     returns (string memory)
1161   {
1162     require(
1163       _exists(_tokenId),
1164       "ERC721Metadata: URI query for nonexistent token"
1165     );
1166     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1167   }
1168 
1169   function _baseURI()
1170     internal
1171     view
1172     virtual
1173     override
1174     returns (string memory)
1175   {
1176     return baseTokenURI;
1177   }
1178 
1179   function setIsPublicSaleActive(bool _isPublicSaleActive)
1180       external
1181       onlyOwner
1182   {
1183       isPublicSaleActive = _isPublicSaleActive;
1184   }
1185    
1186    function setIsFreeMintActive (bool _isFreeMintActive)
1187      external onlyOwner
1188     {
1189     isFreeMintActive= _isFreeMintActive;
1190     }
1191 
1192 /** function setNumFreeMints(uint256 _numfreemints)
1193       external
1194       onlyOwner
1195   {
1196       TOTAL_FREE_MINTS = _numfreemints;
1197   }
1198 
1199   function setSalePrice(uint256 _price)
1200       external
1201       onlyOwner
1202   {
1203       PUBLIC_SALE_PRICE = _price;
1204   }
1205 
1206   function setMaxLimitPerTransaction(uint256 _limit)
1207       external
1208       onlyOwner
1209   {
1210       MAX_MINTS_PER_TX = _limit;
1211   } 
1212                                                                                                                      
1213  */
1214 }