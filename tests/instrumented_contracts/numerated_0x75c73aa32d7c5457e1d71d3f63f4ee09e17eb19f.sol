1 // SPDX-License-Identifier: MIT
2 /**
3  * @title TheAmericans Scroll
4  * @author DevAmerican
5  * @type ERC721A
6  * @version v1.0.0
7  * @dev Used for Ethereum projects compatible with OpenSea
8  */
9 
10 pragma solidity ^0.8.4;
11 library Address {
12     function isContract(address account) internal view returns (bool) {
13         return account.code.length > 0;
14     }
15 
16     function sendValue(address payable recipient, uint256 amount) internal {
17         require(
18             address(this).balance >= amount,
19             "Address: insufficient balance"
20         );
21 
22         (bool success, ) = recipient.call{value: amount}("");
23         require(
24             success,
25             "Address: unable to send value, recipient may have reverted"
26         );
27     }
28 
29     function functionCall(address target, bytes memory data)
30         internal
31         returns (bytes memory)
32     {
33         return functionCall(target, data, "Address: low-level call failed");
34     }
35 
36     function functionCall(
37         address target,
38         bytes memory data,
39         string memory errorMessage
40     ) internal returns (bytes memory) {
41         return functionCallWithValue(target, data, 0, errorMessage);
42     }
43 
44     function functionCallWithValue(
45         address target,
46         bytes memory data,
47         uint256 value
48     ) internal returns (bytes memory) {
49         return
50             functionCallWithValue(
51                 target,
52                 data,
53                 value,
54                 "Address: low-level call with value failed"
55             );
56     }
57 
58     function functionCallWithValue(
59         address target,
60         bytes memory data,
61         uint256 value,
62         string memory errorMessage
63     ) internal returns (bytes memory) {
64         require(
65             address(this).balance >= value,
66             "Address: insufficient balance for call"
67         );
68         require(isContract(target), "Address: call to non-contract");
69 
70         (bool success, bytes memory returndata) = target.call{value: value}(
71             data
72         );
73         return verifyCallResult(success, returndata, errorMessage);
74     }
75 
76     function functionStaticCall(address target, bytes memory data)
77         internal
78         view
79         returns (bytes memory)
80     {
81         return
82             functionStaticCall(
83                 target,
84                 data,
85                 "Address: low-level static call failed"
86             );
87     }
88 
89     function functionStaticCall(
90         address target,
91         bytes memory data,
92         string memory errorMessage
93     ) internal view returns (bytes memory) {
94         require(isContract(target), "Address: static call to non-contract");
95 
96         (bool success, bytes memory returndata) = target.staticcall(data);
97         return verifyCallResult(success, returndata, errorMessage);
98     }
99 
100     function functionDelegateCall(address target, bytes memory data)
101         internal
102         returns (bytes memory)
103     {
104         return
105             functionDelegateCall(
106                 target,
107                 data,
108                 "Address: low-level delegate call failed"
109             );
110     }
111 
112     function functionDelegateCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         require(isContract(target), "Address: delegate call to non-contract");
118 
119         (bool success, bytes memory returndata) = target.delegatecall(data);
120         return verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     function verifyCallResult(
124         bool success,
125         bytes memory returndata,
126         string memory errorMessage
127     ) internal pure returns (bytes memory) {
128         if (success) {
129             return returndata;
130         } else {
131             if (returndata.length > 0) {
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 pragma solidity ^0.8.0;
144 interface IERC721Receiver {
145     function onERC721Received(
146         address operator,
147         address from,
148         uint256 tokenId,
149         bytes calldata data
150     ) external returns (bytes4);
151 }
152 
153 pragma solidity ^0.8.0;
154 interface IERC165 {
155     function supportsInterface(bytes4 interfaceId) external view returns (bool);
156 }
157 
158 pragma solidity ^0.8.0;
159 interface IERC721 is IERC165 {
160     event Transfer(
161         address indexed from,
162         address indexed to,
163         uint256 indexed tokenId
164     );
165     event Approval(
166         address indexed owner,
167         address indexed approved,
168         uint256 indexed tokenId
169     );
170     event ApprovalForAll(
171         address indexed owner,
172         address indexed operator,
173         bool approved
174     );
175 
176     function balanceOf(address owner) external view returns (uint256 balance);
177 
178     function ownerOf(uint256 tokenId) external view returns (address owner);
179 
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     function transferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     function approve(address to, uint256 tokenId) external;
200 
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     function getApproved(uint256 tokenId)
204         external
205         view
206         returns (address operator);
207 
208     function isApprovedForAll(address owner, address operator)
209         external
210         view
211         returns (bool);
212 }
213 
214 pragma solidity ^0.8.0;
215 interface IERC721Metadata is IERC721 {
216     function name() external view returns (string memory);
217 
218     function symbol() external view returns (string memory);
219 
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 pragma solidity ^0.8.4;
224 interface IERC721A is IERC721, IERC721Metadata {
225     error ApprovalCallerNotOwnerNorApproved();
226     error ApprovalQueryForNonexistentToken();
227     error ApproveToCaller();
228     error ApprovalToCurrentOwner();
229     error BalanceQueryForZeroAddress();
230     error MintToZeroAddress();
231     error MintZeroQuantity();
232     error OwnerQueryForNonexistentToken();
233     error TransferCallerNotOwnerNorApproved();
234     error TransferFromIncorrectOwner();
235     error TransferToNonERC721ReceiverImplementer();
236     error TransferToZeroAddress();
237     error URIQueryForNonexistentToken();
238 
239     struct TokenOwnership {
240         address addr;
241         uint64 startTimestamp;
242         bool burned;
243     }
244 
245     struct AddressData {
246         uint64 balance;
247         uint64 numberMinted;
248         uint64 numberBurned;
249         uint64 aux;
250     }
251 
252     function totalSupply() external view returns (uint256);
253 }
254 
255 pragma solidity ^0.8.0;
256 interface IERC721Enumerable is IERC721 {
257     function totalSupply() external view returns (uint256);
258 
259     function tokenOfOwnerByIndex(address owner, uint256 index)
260         external
261         view
262         returns (uint256);
263 
264     function tokenByIndex(uint256 index) external view returns (uint256);
265 }
266 
267 pragma solidity ^0.8.0;
268 abstract contract ERC165 is IERC165 {
269     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
270         return interfaceId == type(IERC165).interfaceId;
271     }
272 }
273 
274 pragma solidity ^0.8.0;
275 library Strings {
276     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
277     uint8 private constant _ADDRESS_LENGTH = 20;
278 
279     function toString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0";
282         }
283         uint256 temp = value;
284         uint256 digits;
285         while (temp != 0) {
286             digits++;
287             temp /= 10;
288         }
289         bytes memory buffer = new bytes(digits);
290         while (value != 0) {
291             digits -= 1;
292             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
293             value /= 10;
294         }
295         return string(buffer);
296     }
297 
298     function toHexString(uint256 value) internal pure returns (string memory) {
299         if (value == 0) {
300             return "0x00";
301         }
302         uint256 temp = value;
303         uint256 length = 0;
304         while (temp != 0) {
305             length++;
306             temp >>= 8;
307         }
308         return toHexString(value, length);
309     }
310 
311     function toHexString(uint256 value, uint256 length)
312         internal
313         pure
314         returns (string memory)
315     {
316         bytes memory buffer = new bytes(2 * length + 2);
317         buffer[0] = "0";
318         buffer[1] = "x";
319         for (uint256 i = 2 * length + 1; i > 1; --i) {
320             buffer[i] = _HEX_SYMBOLS[value & 0xf];
321             value >>= 4;
322         }
323         require(value == 0, "Strings: hex length insufficient");
324         return string(buffer);
325     }
326 
327     function toHexString(address addr) internal pure returns (string memory) {
328         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
329     }
330 }
331 
332 pragma solidity ^0.8.0;
333 abstract contract Context {
334     function _msgSender() internal view virtual returns (address) {
335         return msg.sender;
336     }
337 
338     function _msgData() internal view virtual returns (bytes calldata) {
339         return msg.data;
340     }
341 }
342 
343 pragma solidity ^0.8.0;
344 abstract contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(
348         address indexed previousOwner,
349         address indexed newOwner
350     );
351 
352     constructor() {
353         _transferOwnership(_msgSender());
354     }
355 
356     modifier onlyOwner() {
357         _checkOwner();
358         _;
359     }
360 
361     function owner() public view virtual returns (address) {
362         return _owner;
363     }
364 
365     function _checkOwner() internal view virtual {
366         require(owner() == _msgSender(), "Ownable: caller is not the owner");
367     }
368 
369     function renounceOwnership() public virtual onlyOwner {
370         _transferOwnership(address(0));
371     }
372 
373     function transferOwnership(address newOwner) public virtual onlyOwner {
374         require(
375             newOwner != address(0),
376             "Ownable: new owner is the zero address"
377         );
378         _transferOwnership(newOwner);
379     }
380 
381     function _transferOwnership(address newOwner) internal virtual {
382         address oldOwner = _owner;
383         _owner = newOwner;
384         emit OwnershipTransferred(oldOwner, newOwner);
385     }
386 }
387 
388 pragma solidity ^0.8.0;
389 abstract contract ReentrancyGuard {
390     uint256 private constant _NOT_ENTERED = 1;
391     uint256 private constant _ENTERED = 2;
392 
393     uint256 private _status;
394 
395     constructor() {
396         _status = _NOT_ENTERED;
397     }
398 
399     modifier nonReentrant() {
400         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
401 
402         _status = _ENTERED;
403 
404         _;
405 
406         _status = _NOT_ENTERED;
407     }
408 }
409 
410 pragma solidity ^0.8.4;
411 contract ERC721A is Context, ERC165, IERC721A {
412     using Address for address;
413     using Strings for uint256;
414 
415     uint256 internal _currentIndex;
416 
417     uint256 internal _burnCounter;
418 
419     string private _name;
420 
421     string private _symbol;
422 
423     mapping(uint256 => TokenOwnership) internal _ownerships;
424 
425     mapping(address => AddressData) private _addressData;
426 
427     mapping(uint256 => address) private _tokenApprovals;
428 
429     mapping(address => mapping(address => bool)) private _operatorApprovals;
430 
431     constructor(string memory name_, string memory symbol_) {
432         _name = name_;
433         _symbol = symbol_;
434         _currentIndex = _startTokenId();
435     }
436 
437     function _startTokenId() internal view virtual returns (uint256) {
438         return 0;
439     }
440 
441     function totalSupply() public view override returns (uint256) {
442         unchecked {
443             return _currentIndex - _burnCounter - _startTokenId();
444         }
445     }
446 
447     function _totalMinted() internal view returns (uint256) {
448         unchecked {
449             return _currentIndex - _startTokenId();
450         }
451     }
452 
453     function supportsInterface(bytes4 interfaceId)
454         public
455         view
456         virtual
457         override(ERC165, IERC165)
458         returns (bool)
459     {
460         return
461             interfaceId == type(IERC721).interfaceId ||
462             interfaceId == type(IERC721Metadata).interfaceId ||
463             super.supportsInterface(interfaceId);
464     }
465 
466     function balanceOf(address owner) public view override returns (uint256) {
467         if (owner == address(0)) revert BalanceQueryForZeroAddress();
468         return uint256(_addressData[owner].balance);
469     }
470 
471     function _numberMinted(address owner) internal view returns (uint256) {
472         return uint256(_addressData[owner].numberMinted);
473     }
474 
475     function _numberBurned(address owner) internal view returns (uint256) {
476         return uint256(_addressData[owner].numberBurned);
477     }
478 
479     function _getAux(address owner) internal view returns (uint64) {
480         return _addressData[owner].aux;
481     }
482 
483     function _setAux(address owner, uint64 aux) internal {
484         _addressData[owner].aux = aux;
485     }
486 
487     function _ownershipOf(uint256 tokenId)
488         internal
489         view
490         returns (TokenOwnership memory)
491     {
492         uint256 curr = tokenId;
493 
494         unchecked {
495             if (_startTokenId() <= curr)
496                 if (curr < _currentIndex) {
497                     TokenOwnership memory ownership = _ownerships[curr];
498                     if (!ownership.burned) {
499                         if (ownership.addr != address(0)) {
500                             return ownership;
501                         }
502                         while (true) {
503                             curr--;
504                             ownership = _ownerships[curr];
505                             if (ownership.addr != address(0)) {
506                                 return ownership;
507                             }
508                         }
509                     }
510                 }
511         }
512         revert OwnerQueryForNonexistentToken();
513     }
514 
515     function ownerOf(uint256 tokenId) public view override returns (address) {
516         return _ownershipOf(tokenId).addr;
517     }
518 
519     function name() public view virtual override returns (string memory) {
520         return _name;
521     }
522 
523     function symbol() public view virtual override returns (string memory) {
524         return _symbol;
525     }
526 
527     function tokenURI(uint256 tokenId)
528         public
529         view
530         virtual
531         override
532         returns (string memory)
533     {
534         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
535 
536         string memory baseURI = _baseURI();
537         return
538             bytes(baseURI).length != 0
539                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
540                 : "";
541     }
542 
543     function _baseURI() internal view virtual returns (string memory) {
544         return "";
545     }
546 
547     function approve(address to, uint256 tokenId) public override {
548         address owner = ERC721A.ownerOf(tokenId);
549         if (to == owner) revert ApprovalToCurrentOwner();
550 
551         if (_msgSender() != owner)
552             if (!isApprovedForAll(owner, _msgSender())) {
553                 revert ApprovalCallerNotOwnerNorApproved();
554             }
555 
556         _approve(to, tokenId, owner);
557     }
558 
559     function getApproved(uint256 tokenId)
560         public
561         view
562         override
563         returns (address)
564     {
565         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
566 
567         return _tokenApprovals[tokenId];
568     }
569 
570     function setApprovalForAll(address operator, bool approved)
571         public
572         virtual
573         override
574     {
575         if (operator == _msgSender()) revert ApproveToCaller();
576 
577         _operatorApprovals[_msgSender()][operator] = approved;
578         emit ApprovalForAll(_msgSender(), operator, approved);
579     }
580 
581     function isApprovedForAll(address owner, address operator)
582         public
583         view
584         virtual
585         override
586         returns (bool)
587     {
588         return _operatorApprovals[owner][operator];
589     }
590 
591     function transferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) public virtual override {
596         _transfer(from, to, tokenId);
597     }
598 
599     function safeTransferFrom(
600         address from,
601         address to,
602         uint256 tokenId
603     ) public virtual override {
604         safeTransferFrom(from, to, tokenId, "");
605     }
606 
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes memory _data
612     ) public virtual override {
613         _transfer(from, to, tokenId);
614         if (to.isContract())
615             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
616                 revert TransferToNonERC721ReceiverImplementer();
617             }
618     }
619 
620     function _exists(uint256 tokenId) internal view returns (bool) {
621         return
622             _startTokenId() <= tokenId &&
623             tokenId < _currentIndex &&
624             !_ownerships[tokenId].burned;
625     }
626 
627     function _safeMint(address to, uint256 quantity) internal {
628         _safeMint(to, quantity, "");
629     }
630 
631     function _safeMint(
632         address to,
633         uint256 quantity,
634         bytes memory _data
635     ) internal {
636         uint256 startTokenId = _currentIndex;
637         if (to == address(0)) revert MintToZeroAddress();
638         if (quantity == 0) revert MintZeroQuantity();
639 
640         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
641 
642         unchecked {
643             _addressData[to].balance += uint64(quantity);
644             _addressData[to].numberMinted += uint64(quantity);
645 
646             _ownerships[startTokenId].addr = to;
647             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
648 
649             uint256 updatedIndex = startTokenId;
650             uint256 end = updatedIndex + quantity;
651 
652             if (to.isContract()) {
653                 do {
654                     emit Transfer(address(0), to, updatedIndex);
655                     if (
656                         !_checkContractOnERC721Received(
657                             address(0),
658                             to,
659                             updatedIndex++,
660                             _data
661                         )
662                     ) {
663                         revert TransferToNonERC721ReceiverImplementer();
664                     }
665                 } while (updatedIndex < end);
666                 if (_currentIndex != startTokenId) revert();
667             } else {
668                 do {
669                     emit Transfer(address(0), to, updatedIndex++);
670                 } while (updatedIndex < end);
671             }
672             _currentIndex = updatedIndex;
673         }
674         _afterTokenTransfers(address(0), to, startTokenId, quantity);
675     }
676 
677     function _mint(address to, uint256 quantity) internal {
678         uint256 startTokenId = _currentIndex;
679         if (to == address(0)) revert MintToZeroAddress();
680         if (quantity == 0) revert MintZeroQuantity();
681 
682         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
683 
684         unchecked {
685             _addressData[to].balance += uint64(quantity);
686             _addressData[to].numberMinted += uint64(quantity);
687 
688             _ownerships[startTokenId].addr = to;
689             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
690 
691             uint256 updatedIndex = startTokenId;
692             uint256 end = updatedIndex + quantity;
693 
694             do {
695                 emit Transfer(address(0), to, updatedIndex++);
696             } while (updatedIndex < end);
697 
698             _currentIndex = updatedIndex;
699         }
700         _afterTokenTransfers(address(0), to, startTokenId, quantity);
701     }
702 
703     function _transfer(
704         address from,
705         address to,
706         uint256 tokenId
707     ) private {
708         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
709 
710         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
711 
712         bool isApprovedOrOwner = (_msgSender() == from ||
713             isApprovedForAll(from, _msgSender()) ||
714             getApproved(tokenId) == _msgSender());
715 
716         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
717         if (to == address(0)) revert TransferToZeroAddress();
718 
719         _beforeTokenTransfers(from, to, tokenId, 1);
720 
721         _approve(address(0), tokenId, from);
722 
723         unchecked {
724             _addressData[from].balance -= 1;
725             _addressData[to].balance += 1;
726 
727             TokenOwnership storage currSlot = _ownerships[tokenId];
728             currSlot.addr = to;
729             currSlot.startTimestamp = uint64(block.timestamp);
730 
731             uint256 nextTokenId = tokenId + 1;
732             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
733             if (nextSlot.addr == address(0)) {
734                 if (nextTokenId != _currentIndex) {
735                     nextSlot.addr = from;
736                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
737                 }
738             }
739         }
740 
741         emit Transfer(from, to, tokenId);
742         _afterTokenTransfers(from, to, tokenId, 1);
743     }
744 
745     function _burn(uint256 tokenId) internal virtual {
746         _burn(tokenId, false);
747     }
748 
749     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
750         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
751 
752         address from = prevOwnership.addr;
753 
754         if (approvalCheck) {
755             bool isApprovedOrOwner = (_msgSender() == from ||
756                 isApprovedForAll(from, _msgSender()) ||
757                 getApproved(tokenId) == _msgSender());
758 
759             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
760         }
761 
762         _beforeTokenTransfers(from, address(0), tokenId, 1);
763 
764         _approve(address(0), tokenId, from);
765 
766         unchecked {
767             AddressData storage addressData = _addressData[from];
768             addressData.balance -= 1;
769             addressData.numberBurned += 1;
770 
771             TokenOwnership storage currSlot = _ownerships[tokenId];
772             currSlot.addr = from;
773             currSlot.startTimestamp = uint64(block.timestamp);
774             currSlot.burned = true;
775 
776             uint256 nextTokenId = tokenId + 1;
777             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
778             if (nextSlot.addr == address(0)) {
779                 if (nextTokenId != _currentIndex) {
780                     nextSlot.addr = from;
781                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
782                 }
783             }
784         }
785 
786         emit Transfer(from, address(0), tokenId);
787         _afterTokenTransfers(from, address(0), tokenId, 1);
788 
789         unchecked {
790             _burnCounter++;
791         }
792     }
793 
794     function _approve(
795         address to,
796         uint256 tokenId,
797         address owner
798     ) private {
799         _tokenApprovals[tokenId] = to;
800         emit Approval(owner, to, tokenId);
801     }
802 
803     function _checkContractOnERC721Received(
804         address from,
805         address to,
806         uint256 tokenId,
807         bytes memory _data
808     ) private returns (bool) {
809         try
810             IERC721Receiver(to).onERC721Received(
811                 _msgSender(),
812                 from,
813                 tokenId,
814                 _data
815             )
816         returns (bytes4 retval) {
817             return retval == IERC721Receiver(to).onERC721Received.selector;
818         } catch (bytes memory reason) {
819             if (reason.length == 0) {
820                 revert TransferToNonERC721ReceiverImplementer();
821             } else {
822                 assembly {
823                     revert(add(32, reason), mload(reason))
824                 }
825             }
826         }
827     }
828 
829     function _beforeTokenTransfers(
830         address from,
831         address to,
832         uint256 startTokenId,
833         uint256 quantity
834     ) internal virtual {}
835 
836     function _afterTokenTransfers(
837         address from,
838         address to,
839         uint256 startTokenId,
840         uint256 quantity
841     ) internal virtual {}
842 }
843 
844 pragma solidity ^0.8.0;
845 interface IAccessControl {
846     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
847     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
848     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
849     function hasRole(bytes32 role, address account) external view returns (bool);
850     function getRoleAdmin(bytes32 role) external view returns (bytes32);
851     function grantRole(bytes32 role, address account) external;
852     function revokeRole(bytes32 role, address account) external;
853     function renounceRole(bytes32 role, address account) external;
854 }
855 
856 pragma solidity ^0.8.0;
857 abstract contract AccessControl is Context, IAccessControl, ERC165 {
858     struct RoleData {
859         mapping(address => bool) members;
860         bytes32 adminRole;
861     }
862     mapping(bytes32 => RoleData) private _roles;
863     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
864     modifier onlyRole(bytes32 role) {
865         _checkRole(role);
866         _;
867     }
868     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
869         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
870     }
871     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
872         return _roles[role].members[account];
873     }
874     function _checkRole(bytes32 role) internal view virtual {
875         _checkRole(role, _msgSender());
876     }
877     function _checkRole(bytes32 role, address account) internal view virtual {
878         if (!hasRole(role, account)) {
879             revert(
880                 string(
881                     abi.encodePacked(
882                         "AccessControl: account ",
883                         Strings.toHexString(uint160(account), 20),
884                         " is missing role ",
885                         Strings.toHexString(uint256(role), 32)
886                     )
887                 )
888             );
889         }
890     }
891     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
892         return _roles[role].adminRole;
893     }
894     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
895         _grantRole(role, account);
896     }
897     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
898         _revokeRole(role, account);
899     }
900     function renounceRole(bytes32 role, address account) public virtual override {
901         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
902 
903         _revokeRole(role, account);
904     }
905     function _setupRole(bytes32 role, address account) internal virtual {
906         _grantRole(role, account);
907     }
908     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
909         bytes32 previousAdminRole = getRoleAdmin(role);
910         _roles[role].adminRole = adminRole;
911         emit RoleAdminChanged(role, previousAdminRole, adminRole);
912     }
913     function _grantRole(bytes32 role, address account) internal virtual {
914         if (!hasRole(role, account)) {
915             _roles[role].members[account] = true;
916             emit RoleGranted(role, account, _msgSender());
917         }
918     }
919     function _revokeRole(bytes32 role, address account) internal virtual {
920         if (hasRole(role, account)) {
921             _roles[role].members[account] = false;
922             emit RoleRevoked(role, account, _msgSender());
923         }
924     }
925 }
926 
927 pragma solidity ^0.8.0;
928 interface IERC2981 is IERC165 {
929     function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
930 }
931 
932 pragma solidity ^0.8.0;
933 abstract contract ERC2981 is IERC2981, ERC165 {
934     struct RoyaltyInfo {
935         address receiver;
936         uint96 royaltyFraction;
937     }
938     RoyaltyInfo private _defaultRoyaltyInfo;
939     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
940     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
941         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
942     }
943     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
944         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
945 
946         if (royalty.receiver == address(0)) {
947             royalty = _defaultRoyaltyInfo;
948         }
949 
950         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
951 
952         return (royalty.receiver, royaltyAmount);
953     }
954     function _feeDenominator() internal pure virtual returns (uint96) {
955         return 10000;
956     }
957     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
958         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
959         require(receiver != address(0), "ERC2981: invalid receiver");
960 
961         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
962     }
963     function _deleteDefaultRoyalty() internal virtual {
964         delete _defaultRoyaltyInfo;
965     }
966     function _setTokenRoyalty(
967         uint256 tokenId,
968         address receiver,
969         uint96 feeNumerator
970     ) internal virtual {
971         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
972         require(receiver != address(0), "ERC2981: Invalid parameters");
973 
974         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
975     }
976     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
977         delete _tokenRoyaltyInfo[tokenId];
978     }
979 }
980 
981 pragma solidity ^0.8.4;
982 interface ITheAmericanStake {
983     function getStakedAmericans(address staker) external view returns (uint256[] memory);
984 }
985 
986 pragma solidity ^0.8.4;
987 contract TheAmericansScroll is ERC721A, ReentrancyGuard, Ownable, ERC2981, AccessControl{
988     bytes32 public constant SUPPORT_ROLE = keccak256("SUPPORT");
989 
990     string private _baseURIExtended;
991     bool public claimActive;
992 
993     bytes32 public merkleRoots;
994 
995     mapping(address => bool) public isClaimed;
996 
997     constructor(string memory _name, string memory _symbol)
998         ERC721A(_name, _symbol) {
999         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1000         _setupRole(SUPPORT_ROLE, msg.sender);
1001     }
1002 
1003     function _leafFromAddressAndNumTokens(address _a, uint256 _n) private pure returns (bytes32){
1004         return keccak256(abi.encodePacked(_a, _n));
1005     }
1006 
1007     function _checkProof(bytes32[] calldata proof, bytes32 _hash) private view returns (bool) {
1008         bytes32 el;
1009         bytes32 h = _hash;
1010         for (uint256 i = 0; i < proof.length; i += 1) {
1011             el = proof[i];
1012             if (h < el) {
1013                 h = keccak256(abi.encodePacked(h, el));
1014             } else {
1015                 h = keccak256(abi.encodePacked(el, h));
1016             }
1017         }
1018         return h == merkleRoots;
1019     }
1020 
1021     function mint(bytes32[] calldata _proof, uint256 _quantity) external nonReentrant {
1022         require(claimActive, "AIRDROP_NOT_YET_STARTED");
1023         require(isClaimed[msg.sender] != true, "CLAIMED_ALREADY");
1024         require(_quantity > 0, "INVALID_QUANTITY");
1025         require(_checkProof(_proof, _leafFromAddressAndNumTokens(msg.sender, _quantity)), "WRONG_PROOF");
1026         isClaimed[msg.sender] = true;
1027         _safeMint(msg.sender, _quantity);
1028     }
1029 
1030     function burn(uint256 tokenId) external {
1031         _burn(tokenId, true);
1032     }
1033 
1034     function setBaseURI(string memory baseURI_) external onlyOwner {
1035         _baseURIExtended = baseURI_;
1036     }
1037 
1038     function _baseURI() internal view virtual override returns (string memory) {
1039         return _baseURIExtended;
1040     }
1041 
1042     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC721A, ERC2981) returns (bool) {
1043         return super.supportsInterface(interfaceId);
1044     }
1045 
1046     function setClaimActive() external onlyOwner {
1047         claimActive = !claimActive;
1048     }
1049 
1050     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external onlyRole(SUPPORT_ROLE) {
1051         _setDefaultRoyalty(receiver, feeNumerator);
1052     }
1053 
1054     function deleteDefaultRoyalty() external onlyRole(SUPPORT_ROLE) {
1055         _deleteDefaultRoyalty();
1056     }
1057 
1058     function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external onlyRole(SUPPORT_ROLE) {
1059         _setTokenRoyalty(tokenId, receiver, feeNumerator);
1060     }
1061 
1062     function resetTokenRoyalty(uint256 tokenId) external onlyRole(SUPPORT_ROLE) {
1063         _resetTokenRoyalty(tokenId);
1064     }
1065 
1066     function setAirdropRoot(bytes32 _merkleRoot) external onlyOwner {
1067         merkleRoots = _merkleRoot;
1068     }
1069 
1070 }