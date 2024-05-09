1 pragma solidity ^0.8.0;
2 
3 
4 abstract contract ReentrancyGuard {
5 
6     uint256 private constant _NOT_ENTERED = 1;
7     uint256 private constant _ENTERED = 2;
8 
9     uint256 private _status;
10 
11     constructor() {
12         _status = _NOT_ENTERED;
13     }
14 
15     modifier nonReentrant() {
16         
17         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
18 
19         
20         _status = _ENTERED;
21 
22         _;
23 
24         
25         _status = _NOT_ENTERED;
26     }
27 }
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36     uint8 private constant _ADDRESS_LENGTH = 20;
37 
38     
39     function toString(uint256 value) internal pure returns (string memory) {
40       
41         if (value == 0) {
42             return "0";
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 
59  
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
74         bytes memory buffer = new bytes(2 * length + 2);
75         buffer[0] = "0";
76         buffer[1] = "x";
77         for (uint256 i = 2 * length + 1; i > 1; --i) {
78             buffer[i] = _HEX_SYMBOLS[value & 0xf];
79             value >>= 4;
80         }
81         require(value == 0, "Strings: hex length insufficient");
82         return string(buffer);
83     }
84 
85     function toHexString(address addr) internal pure returns (string memory) {
86         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
87     }
88 }
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 
95 library MerkleProof {
96  
97     function verify(
98         bytes32[] memory proof,
99         bytes32 root,
100         bytes32 leaf
101     ) internal pure returns (bool) {
102         return processProof(proof, leaf) == root;
103     }
104 
105   
106     function verifyCalldata(
107         bytes32[] calldata proof,
108         bytes32 root,
109         bytes32 leaf
110     ) internal pure returns (bool) {
111         return processProofCalldata(proof, leaf) == root;
112     }
113 
114    
115     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
116         bytes32 computedHash = leaf;
117         for (uint256 i = 0; i < proof.length; i++) {
118             computedHash = _hashPair(computedHash, proof[i]);
119         }
120         return computedHash;
121     }
122 
123 
124     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             computedHash = _hashPair(computedHash, proof[i]);
128         }
129         return computedHash;
130     }
131 
132   
133     function multiProofVerify(
134         bytes32[] memory proof,
135         bool[] memory proofFlags,
136         bytes32 root,
137         bytes32[] memory leaves
138     ) internal pure returns (bool) {
139         return processMultiProof(proof, proofFlags, leaves) == root;
140     }
141 
142  
143     function multiProofVerifyCalldata(
144         bytes32[] calldata proof,
145         bool[] calldata proofFlags,
146         bytes32 root,
147         bytes32[] memory leaves
148     ) internal pure returns (bool) {
149         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
150     }
151 
152    
153     function processMultiProof(
154         bytes32[] memory proof,
155         bool[] memory proofFlags,
156         bytes32[] memory leaves
157     ) internal pure returns (bytes32 merkleRoot) {
158    
159         uint256 leavesLen = leaves.length;
160         uint256 totalHashes = proofFlags.length;
161 
162         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
163 
164         bytes32[] memory hashes = new bytes32[](totalHashes);
165         uint256 leafPos = 0;
166         uint256 hashPos = 0;
167         uint256 proofPos = 0;
168     
169         for (uint256 i = 0; i < totalHashes; i++) {
170             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
171             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
172             hashes[i] = _hashPair(a, b);
173         }
174 
175         if (totalHashes > 0) {
176             return hashes[totalHashes - 1];
177         } else if (leavesLen > 0) {
178             return leaves[0];
179         } else {
180             return proof[0];
181         }
182     }
183 
184   
185     function processMultiProofCalldata(
186         bytes32[] calldata proof,
187         bool[] calldata proofFlags,
188         bytes32[] memory leaves
189     ) internal pure returns (bytes32 merkleRoot) {
190   
191         uint256 leavesLen = leaves.length;
192         uint256 totalHashes = proofFlags.length;
193 
194         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
195 
196       
197         bytes32[] memory hashes = new bytes32[](totalHashes);
198         uint256 leafPos = 0;
199         uint256 hashPos = 0;
200         uint256 proofPos = 0;
201       
202         for (uint256 i = 0; i < totalHashes; i++) {
203             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
204             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
205             hashes[i] = _hashPair(a, b);
206         }
207 
208         if (totalHashes > 0) {
209             return hashes[totalHashes - 1];
210         } else if (leavesLen > 0) {
211             return leaves[0];
212         } else {
213             return proof[0];
214         }
215     }
216 
217     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
218         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
219     }
220 
221     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
222      
223         assembly {
224             mstore(0x00, a)
225             mstore(0x20, b)
226             value := keccak256(0x00, 0x40)
227         }
228     }
229 }
230 
231 
232 
233 pragma solidity ^0.8.0;
234 
235 
236 library Counters {
237     struct Counter {
238       
239         uint256 _value; // default: 0
240     }
241 
242     function current(Counter storage counter) internal view returns (uint256) {
243         return counter._value;
244     }
245 
246     function increment(Counter storage counter) internal {
247         unchecked {
248             counter._value += 1;
249         }
250     }
251 
252     function decrement(Counter storage counter) internal {
253         uint256 value = counter._value;
254         require(value > 0, "Counter: decrement overflow");
255         unchecked {
256             counter._value = value - 1;
257         }
258     }
259 
260     function reset(Counter storage counter) internal {
261         counter._value = 0;
262     }
263 }
264 
265 
266 pragma solidity ^0.8.0;
267 
268 
269 abstract contract Context {
270     function _msgSender() internal view virtual returns (address) {
271         return msg.sender;
272     }
273 
274     function _msgData() internal view virtual returns (bytes calldata) {
275         return msg.data;
276     }
277 }
278 
279 pragma solidity ^0.8.0;
280 
281 
282 
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288   
289     constructor() {
290         _transferOwnership(_msgSender());
291     }
292 
293  
294     modifier onlyOwner() {
295         _checkOwner();
296         _;
297     }
298 
299    
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304    
305     function _checkOwner() internal view virtual {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307     }
308 
309 
310     function renounceOwnership() public virtual onlyOwner {
311         _transferOwnership(address(0));
312     }
313 
314  
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         _transferOwnership(newOwner);
318     }
319 
320    
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 
329 
330 pragma solidity ^0.8.4;
331 
332 
333 interface IERC721A {
334    
335     error ApprovalCallerNotOwnerNorApproved();
336 
337  
338     error ApprovalQueryForNonexistentToken();
339 
340  
341     error ApproveToCaller();
342 
343  
344     error BalanceQueryForZeroAddress();
345 
346    
347     error MintToZeroAddress();
348 
349  
350     error MintZeroQuantity();
351 
352  
353     error OwnerQueryForNonexistentToken();
354 
355  
356     error TransferCallerNotOwnerNorApproved();
357 
358  
359     error TransferFromIncorrectOwner();
360 
361  
362     error TransferToNonERC721ReceiverImplementer();
363 
364 
365     error TransferToZeroAddress();
366 
367  
368     error URIQueryForNonexistentToken();
369 
370   
371     error MintERC2309QuantityExceedsLimit();
372 
373  
374     error OwnershipNotInitializedForExtraData();
375 
376    
377     struct TokenOwnership {
378         
379         address addr;
380       
381         uint64 startTimestamp;
382 
383         bool burned;
384 
385         uint24 extraData;
386     }
387 
388 
389     function totalSupply() external view returns (uint256);
390 
391 
392     function supportsInterface(bytes4 interfaceId) external view returns (bool);
393 
394  
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397 
398     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
399 
400 
401     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
402 
403     function balanceOf(address owner) external view returns (uint256 balance);
404 
405 
406     function ownerOf(uint256 tokenId) external view returns (address owner);
407 
408   
409     function safeTransferFrom(
410         address from,
411         address to,
412         uint256 tokenId,
413         bytes calldata data
414     ) external;
415 
416   
417     function safeTransferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423   
424     function transferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430    
431     function approve(address to, uint256 tokenId) external;
432 
433   
434     function setApprovalForAll(address operator, bool _approved) external;
435 
436   
437     function getApproved(uint256 tokenId) external view returns (address operator);
438 
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     function name() external view returns (string memory);
442 
443     function symbol() external view returns (string memory);
444 
445     function tokenURI(uint256 tokenId) external view returns (string memory);
446 
447 
448     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
449 }
450 
451 
452 
453 pragma solidity ^0.8.4;
454 
455 
456 
457 interface ERC721A__IERC721Receiver {
458     function onERC721Received(
459         address operator,
460         address from,
461         uint256 tokenId,
462         bytes calldata data
463     ) external returns (bytes4);
464 }
465 
466 
467 contract ERC721A is IERC721A {
468 
469     struct TokenApprovalRef {
470         address value;
471     }
472 
473   
474     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
475 
476     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
477 
478     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
479 
480     uint256 private constant _BITPOS_AUX = 192;
481 
482     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
483 
484     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
485 
486     uint256 private constant _BITMASK_BURNED = 1 << 224;
487 
488     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
489 
490     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
491 
492     uint256 private constant _BITPOS_EXTRA_DATA = 232;
493 
494     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
495 
496    
497     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
498 
499   
500     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 369;
501 
502   
503     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
504         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
505 
506   
507     uint256 private _currentIndex;
508 
509   
510     uint256 private _burnCounter;
511 
512     // Token name
513     string private _name;
514 
515     // Token symbol
516     string private _symbol;
517 
518     
519     mapping(uint256 => uint256) private _packedOwnerships;
520 
521  
522     mapping(address => uint256) private _packedAddressData;
523 
524     // Mapping from token ID to approved address.
525     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
526 
527     // Mapping from owner to operator approvals
528     mapping(address => mapping(address => bool)) private _operatorApprovals;
529 
530  
531     constructor(string memory name_, string memory symbol_) {
532         _name = name_;
533         _symbol = symbol_;
534         _currentIndex = _startTokenId();
535     }
536 
537     function _startTokenId() internal view virtual returns (uint256) {
538         return 1;
539     }
540 
541   
542     function _nextTokenId() internal view virtual returns (uint256) {
543         return _currentIndex;
544     }
545 
546  
547     function totalSupply() public view virtual override returns (uint256) {
548      
549         unchecked {
550             return _currentIndex - _burnCounter - _startTokenId();
551         }
552     }
553 
554 
555     function _totalMinted() internal view virtual returns (uint256) {
556       
557         unchecked {
558             return _currentIndex - _startTokenId();
559         }
560     }
561 
562  
563     function _totalBurned() internal view virtual returns (uint256) {
564         return _burnCounter;
565     }
566 
567   
568     function balanceOf(address owner) public view virtual override returns (uint256) {
569         if (owner == address(0)) revert BalanceQueryForZeroAddress();
570         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573    
574     function _numberMinted(address owner) internal view returns (uint256) {
575         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
576     }
577 
578   
579     function _numberBurned(address owner) internal view returns (uint256) {
580         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
581     }
582 
583   
584     function _getAux(address owner) internal view returns (uint64) {
585         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
586     }
587 
588 
589     function _setAux(address owner, uint64 aux) internal virtual {
590         uint256 packed = _packedAddressData[owner];
591         uint256 auxCasted;
592         
593         assembly {
594             auxCasted := aux
595         }
596         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
597         _packedAddressData[owner] = packed;
598     }
599 
600 
601     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602        
603         return
604             interfaceId == 0x01ffc9a7 || 
605             interfaceId == 0x80ac58cd || 
606             interfaceId == 0x5b5e139f;
607     }
608 
609  
610     function name() public view virtual override returns (string memory) {
611         return _name;
612     }
613 
614  
615     function symbol() public view virtual override returns (string memory) {
616         return _symbol;
617     }
618 
619 
620     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
621         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
622 
623         string memory baseURI = _baseURI();
624         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
625     }
626 
627 
628     function _baseURI() internal view virtual returns (string memory) {
629         return '';
630     }
631 
632   
633     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
634         return address(uint160(_packedOwnershipOf(tokenId)));
635     }
636 
637  
638     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
639         return _unpackedOwnership(_packedOwnershipOf(tokenId));
640     }
641 
642   
643     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
644         return _unpackedOwnership(_packedOwnerships[index]);
645     }
646 
647    
648     function _initializeOwnershipAt(uint256 index) internal virtual {
649         if (_packedOwnerships[index] == 0) {
650             _packedOwnerships[index] = _packedOwnershipOf(index);
651         }
652     }
653 
654   
655     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
656         uint256 curr = tokenId;
657 
658         unchecked {
659             if (_startTokenId() <= curr)
660                 if (curr < _currentIndex) {
661                     uint256 packed = _packedOwnerships[curr];
662                  
663                     if (packed & _BITMASK_BURNED == 0) {
664                        
665                         while (packed == 0) {
666                             packed = _packedOwnerships[--curr];
667                         }
668                         return packed;
669                     }
670                 }
671         }
672         revert OwnerQueryForNonexistentToken();
673     }
674 
675  
676     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
677         ownership.addr = address(uint160(packed));
678         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
679         ownership.burned = packed & _BITMASK_BURNED != 0;
680         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
681     }
682 
683  
684     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
685         assembly {
686            
687             owner := and(owner, _BITMASK_ADDRESS)
688           
689             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
690         }
691     }
692 
693    
694     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
695        
696         assembly {
697         
698             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
699         }
700     }
701 
702    
703     function approve(address to, uint256 tokenId) public virtual override {
704         address owner = ownerOf(tokenId);
705 
706         if (_msgSenderERC721A() != owner)
707             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
708                 revert ApprovalCallerNotOwnerNorApproved();
709             }
710 
711         _tokenApprovals[tokenId].value = to;
712         emit Approval(owner, to, tokenId);
713     }
714 
715  
716     function getApproved(uint256 tokenId) public view virtual override returns (address) {
717         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
718 
719         return _tokenApprovals[tokenId].value;
720     }
721 
722   
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
725 
726         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
727         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
728     }
729 
730  
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735   
736     function _exists(uint256 tokenId) internal view virtual returns (bool) {
737         return
738             _startTokenId() <= tokenId &&
739             tokenId < _currentIndex && 
740             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; 
741     }
742 
743   
744     function _isSenderApprovedOrOwner(
745         address approvedAddress,
746         address owner,
747         address msgSender
748     ) private pure returns (bool result) {
749         assembly {
750             
751             owner := and(owner, _BITMASK_ADDRESS)         
752             msgSender := and(msgSender, _BITMASK_ADDRESS)  
753             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
754         }
755     }
756 
757  
758     function _getApprovedSlotAndAddress(uint256 tokenId)
759         private
760         view
761         returns (uint256 approvedAddressSlot, address approvedAddress)
762     {
763         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
764         
765         assembly {
766             approvedAddressSlot := tokenApproval.slot
767             approvedAddress := sload(approvedAddressSlot)
768         }
769     }
770 
771 
772     function transferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) public virtual override {
777         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
778 
779         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
780 
781         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
782 
783        
784         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
785             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
786 
787         if (to == address(0)) revert TransferToZeroAddress();
788 
789         _beforeTokenTransfers(from, to, tokenId, 1);
790 
791        
792         assembly {
793             if approvedAddress {
794                 
795                 sstore(approvedAddressSlot, 0)
796             }
797         }
798 
799       
800         unchecked {
801           
802             --_packedAddressData[from]; 
803             ++_packedAddressData[to];
804 
805            
806             _packedOwnerships[tokenId] = _packOwnershipData(
807                 to,
808                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
809             );
810 
811           
812             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
813                 uint256 nextTokenId = tokenId + 1;
814                
815                 if (_packedOwnerships[nextTokenId] == 0) {
816                    
817                     if (nextTokenId != _currentIndex) {
818                       
819                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
820                     }
821                 }
822             }
823         }
824 
825         emit Transfer(from, to, tokenId);
826         _afterTokenTransfers(from, to, tokenId, 1);
827     }
828 
829  
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         safeTransferFrom(from, to, tokenId, '');
836     }
837 
838  
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) public virtual override {
845         transferFrom(from, to, tokenId);
846         if (to.code.length != 0)
847             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
848                 revert TransferToNonERC721ReceiverImplementer();
849             }
850     }
851 
852   
853     function _beforeTokenTransfers(
854         address from,
855         address to,
856         uint256 startTokenId,
857         uint256 quantity
858     ) internal virtual {}
859 
860 
861     function _afterTokenTransfers(
862         address from,
863         address to,
864         uint256 startTokenId,
865         uint256 quantity
866     ) internal virtual {}
867 
868 
869     function _checkContractOnERC721Received(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) private returns (bool) {
875         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
876             bytes4 retval
877         ) {
878             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
879         } catch (bytes memory reason) {
880             if (reason.length == 0) {
881                 revert TransferToNonERC721ReceiverImplementer();
882             } else {
883                 assembly {
884                     revert(add(32, reason), mload(reason))
885                 }
886             }
887         }
888     }
889 
890 
891     function _mint(address to, uint256 quantity) internal virtual {
892         uint256 startTokenId = _currentIndex;
893         if (quantity == 0) revert MintZeroQuantity();
894 
895         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
896 
897       
898         unchecked {
899           
900             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
901 
902           
903             _packedOwnerships[startTokenId] = _packOwnershipData(
904                 to,
905                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
906             );
907 
908             uint256 toMasked;
909             uint256 end = startTokenId + quantity;
910 
911           
912             assembly {
913                
914                 toMasked := and(to, _BITMASK_ADDRESS)
915                
916                 log4(
917                     0,
918                     0, 
919                     _TRANSFER_EVENT_SIGNATURE, 
920                     0, 
921                     toMasked, 
922                     startTokenId 
923                 )
924 
925                 for {
926                     let tokenId := add(startTokenId, 1)
927                 } iszero(eq(tokenId, end)) {
928                     tokenId := add(tokenId, 1)
929                 } {
930                     
931                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
932                 }
933             }
934             if (toMasked == 0) revert MintToZeroAddress();
935 
936             _currentIndex = end;
937         }
938         _afterTokenTransfers(address(0), to, startTokenId, quantity);
939     }
940 
941  
942     function _mintERC2309(address to, uint256 quantity) internal virtual {
943         uint256 startTokenId = _currentIndex;
944         if (to == address(0)) revert MintToZeroAddress();
945         if (quantity == 0) revert MintZeroQuantity();
946         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
947 
948         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
949 
950       
951         unchecked {
952           
953             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
954 
955             _packedOwnerships[startTokenId] = _packOwnershipData(
956                 to,
957                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
958             );
959 
960             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
961 
962             _currentIndex = startTokenId + quantity;
963         }
964         _afterTokenTransfers(address(0), to, startTokenId, quantity);
965     }
966 
967  
968     function _safeMint(
969         address to,
970         uint256 quantity,
971         bytes memory _data
972     ) internal virtual {
973         _mint(to, quantity);
974 
975         unchecked {
976             if (to.code.length != 0) {
977                 uint256 end = _currentIndex;
978                 uint256 index = end - quantity;
979                 do {
980                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
981                         revert TransferToNonERC721ReceiverImplementer();
982                     }
983                 } while (index < end);
984                 
985                 if (_currentIndex != end) revert();
986             }
987         }
988     }
989 
990   
991     function _safeMint(address to, uint256 quantity) internal virtual {
992         _safeMint(to, quantity, '');
993     }
994 
995   
996     function _burn(uint256 tokenId) internal virtual {
997         _burn(tokenId, false);
998     }
999 
1000    
1001     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1002         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1003 
1004         address from = address(uint160(prevOwnershipPacked));
1005 
1006         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1007 
1008         if (approvalCheck) {
1009           
1010             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1011                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1012         }
1013 
1014         _beforeTokenTransfers(from, address(0), tokenId, 1);
1015 
1016       
1017         assembly {
1018             if approvedAddress {
1019              
1020                 sstore(approvedAddressSlot, 0)
1021             }
1022         }
1023 
1024         unchecked {
1025           
1026             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1027 
1028          
1029             _packedOwnerships[tokenId] = _packOwnershipData(
1030                 from,
1031                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1032             );
1033 
1034            
1035             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1036                 uint256 nextTokenId = tokenId + 1;
1037                
1038                 if (_packedOwnerships[nextTokenId] == 0) {
1039                     
1040                     if (nextTokenId != _currentIndex) {
1041                        
1042                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1043                     }
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, address(0), tokenId);
1049         _afterTokenTransfers(from, address(0), tokenId, 1);
1050 
1051 
1052         unchecked {
1053             _burnCounter++;
1054         }
1055     }
1056 
1057    
1058     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1059         uint256 packed = _packedOwnerships[index];
1060         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1061         uint256 extraDataCasted;
1062        
1063         assembly {
1064             extraDataCasted := extraData
1065         }
1066         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1067         _packedOwnerships[index] = packed;
1068     }
1069 
1070    
1071     function _extraData(
1072         address from,
1073         address to,
1074         uint24 previousExtraData
1075     ) internal view virtual returns (uint24) {}
1076 
1077   
1078     function _nextExtraData(
1079         address from,
1080         address to,
1081         uint256 prevOwnershipPacked
1082     ) private view returns (uint256) {
1083         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1084         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1085     }
1086 
1087   
1088     function _msgSenderERC721A() internal view virtual returns (address) {
1089         return msg.sender;
1090     }
1091 
1092    
1093     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1094         assembly {
1095        
1096             ptr := add(mload(0x40), 128)
1097            
1098             mstore(0x40, ptr)
1099 
1100             
1101             let end := ptr
1102 
1103            
1104             for {
1105                
1106                 let temp := value
1107                
1108                 ptr := sub(ptr, 1)
1109                 
1110                 mstore8(ptr, add(48, mod(temp, 10)))
1111                 temp := div(temp, 10)
1112             } temp {
1113                
1114                 temp := div(temp, 10)
1115             } {
1116                 
1117                 ptr := sub(ptr, 1)
1118                 mstore8(ptr, add(48, mod(temp, 10)))
1119             }
1120 
1121             let length := sub(end, ptr)
1122             
1123             ptr := sub(ptr, 32)
1124             
1125             mstore(ptr, length)
1126         }
1127     }
1128 }
1129 
1130 
1131 
1132 
1133 pragma solidity ^0.8.4;
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 contract Cult_Pass is ERC721A, Ownable, ReentrancyGuard {
1142     using Strings for uint256;
1143     using Counters for Counters.Counter;
1144 
1145     Counters.Counter private _tokenIdCounter;
1146 
1147 
1148     string public PROVENANCE_HASH;
1149 
1150 
1151     string public baseURI;
1152     string public baseExtension = ".json";
1153 
1154  
1155 
1156     uint256 public constant MAX_SUPPLY = 369;
1157     uint256 private _currentId;
1158 
1159 
1160 
1161     uint256 public constant whitelist_LIMIT = 0;
1162     uint256 public constant whitelist_PRICE = 0 ether;
1163 
1164  
1165 
1166     uint256 public constant public_LIMIT = 3;
1167     uint256 public constant public_PRICE = 0 ether;
1168 
1169 
1170     bool public publicIsActive = false;
1171     bool public whitelistIsActive = false;
1172 
1173 
1174     bytes32 public root; 
1175 
1176     mapping(address => uint256) private _alreadyMinted;
1177 
1178   
1179     address public beneficiary;
1180 
1181 
1182     address public royalties;
1183 
1184    
1185     address public nftContractAddress;
1186 
1187   
1188     constructor(
1189         address _royalties,
1190         address _beneficiary,
1191         string memory _initBaseURI 
1192         
1193         ) ERC721A("Puxxies Gang", "PG") {
1194         beneficiary = _beneficiary;
1195         royalties = _royalties;
1196         setBaseURI(_initBaseURI);
1197         
1198     }
1199 
1200 
1201     function _msgSender() internal view virtual override returns (address) {
1202         return msg.sender;
1203     }
1204 
1205     function _msgData()
1206         internal
1207         view
1208         virtual
1209         override
1210         returns (bytes calldata)
1211     {
1212         return msg.data;
1213     }
1214 
1215     function setProvenanceHash(string calldata hash) public onlyOwner {
1216         PROVENANCE_HASH = hash;
1217     }
1218 
1219     function setBeneficiary(address _beneficiary) public onlyOwner {
1220         beneficiary = _beneficiary;
1221     }
1222 
1223     function setRoyalties(address _royalties) public onlyOwner {
1224         royalties = _royalties;
1225     }
1226 
1227   
1228     function setPublicActive(bool _publicIsActive) public onlyOwner {
1229         publicIsActive = _publicIsActive;
1230     }
1231 
1232     
1233     function setWhitelistActive(bool _whitelistIsActive) public onlyOwner {
1234         whitelistIsActive = _whitelistIsActive;
1235     }
1236 
1237    
1238     function _baseURI() internal view virtual override returns (string memory) {
1239         return baseURI;
1240     }
1241 
1242     function alreadyMinted(address addr) public view returns (uint256) {
1243         return _alreadyMinted[addr];
1244     }
1245 
1246     
1247 
1248 
1249     
1250     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1251         return MerkleProof.verify(proof, root, leaf);
1252     }
1253 
1254   
1255     function whitelistMint(uint256 quantity, bytes32[] memory proof) public payable nonReentrant {
1256         address sender = _msgSender();
1257         require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Address is not on the whitelist");
1258         require(whitelistIsActive, "Sale is closed");
1259         require(
1260             quantity <= whitelist_LIMIT - _alreadyMinted[sender],
1261             "Insufficient mints left"
1262         );
1263         require(msg.value == whitelist_PRICE * quantity, "Incorrect payable amount");
1264 
1265         _alreadyMinted[sender] += quantity;
1266         _internalMint(sender, quantity);
1267     }
1268 
1269    
1270     function publicMint(uint256 quantity) public payable nonReentrant {
1271         address sender = _msgSender();
1272 
1273         require(publicIsActive, "Sale is closed");
1274         require(
1275             quantity <= public_LIMIT - _alreadyMinted[sender],
1276             "Insufficient mints left"
1277         );
1278         require(msg.value == public_PRICE * quantity, "Incorrect payable amount");
1279 
1280         _alreadyMinted[sender] += quantity;
1281         _internalMint(sender, quantity);
1282     }
1283 
1284 
1285     function ownerMint(address to, uint256 quantity) public onlyOwner {
1286         _internalMint(to, quantity);
1287     }
1288 
1289    
1290     function withdraw() public onlyOwner {
1291         payable(beneficiary).transfer(address(this).balance);
1292     }
1293 
1294 
1295   
1296     function tokenURI(uint256 tokenId)
1297     public
1298     view
1299     virtual
1300     override
1301     returns (string memory)
1302     {
1303     require(
1304       _exists(tokenId),
1305       "ERC721Metadata: URI query for nonexistent token"
1306     );
1307 
1308  
1309     string memory currentBaseURI = _baseURI();
1310     return bytes(currentBaseURI).length > 0
1311         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1312         : "";
1313     }
1314 
1315   
1316     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1317     baseURI = _newBaseURI;
1318     }
1319 
1320 
1321     function numberMinted(address owner) public view returns (uint256) {
1322         return _numberMinted(owner);
1323     }
1324 
1325  
1326     function _internalMint(address to, uint256 quantity) private {
1327         require(
1328             numberMinted(msg.sender) + quantity <= MAX_SUPPLY,
1329             "can not mint this many"
1330         );
1331    
1332             _safeMint(to, quantity);
1333     }
1334 
1335 
1336   
1337 
1338     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1339         external
1340         view
1341         returns (address, uint256 royaltyAmount)
1342     {
1343         _tokenId; // silence solc warning
1344         royaltyAmount = (_salePrice / 100) * 5;
1345         return (royalties, royaltyAmount);
1346     }
1347 
1348 
1349     function supportsInterface(bytes4 interfaceId)
1350         public
1351         view
1352         override(ERC721A)
1353         returns (bool)
1354     {
1355         return super.supportsInterface(interfaceId);
1356     }
1357 }