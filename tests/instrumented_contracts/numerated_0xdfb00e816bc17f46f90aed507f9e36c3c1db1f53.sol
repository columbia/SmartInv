1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 library Address {
5     function isContract(address account) internal view returns (bool) {
6         uint256 size;
7         assembly {
8             size := extcodesize(account)
9         }
10         return size > 0;
11     }
12 
13     function sendValue(address payable recipient, uint256 amount) internal {
14         require(
15             address(this).balance >= amount,
16             "Address: insufficient balance"
17         );
18 
19         (bool success, ) = recipient.call{value: amount}("");
20         require(
21             success,
22             "Address: unable to send value, recipient may have reverted"
23         );
24     }
25 
26     function functionCall(address target, bytes memory data)
27         internal
28         returns (bytes memory)
29     {
30         return functionCall(target, data, "Address: low-level call failed");
31     }
32 
33     function functionCall(
34         address target,
35         bytes memory data,
36         string memory errorMessage
37     ) internal returns (bytes memory) {
38         return functionCallWithValue(target, data, 0, errorMessage);
39     }
40 
41     function functionCallWithValue(
42         address target,
43         bytes memory data,
44         uint256 value
45     ) internal returns (bytes memory) {
46         return
47             functionCallWithValue(
48                 target,
49                 data,
50                 value,
51                 "Address: low-level call with value failed"
52             );
53     }
54 
55     function functionCallWithValue(
56         address target,
57         bytes memory data,
58         uint256 value,
59         string memory errorMessage
60     ) internal returns (bytes memory) {
61         require(
62             address(this).balance >= value,
63             "Address: insufficient balance for call"
64         );
65         require(isContract(target), "Address: call to non-contract");
66 
67         (bool success, bytes memory returndata) = target.call{value: value}(
68             data
69         );
70         return verifyCallResult(success, returndata, errorMessage);
71     }
72 
73     function functionStaticCall(address target, bytes memory data)
74         internal
75         view
76         returns (bytes memory)
77     {
78         return
79             functionStaticCall(
80                 target,
81                 data,
82                 "Address: low-level static call failed"
83             );
84     }
85 
86     function functionStaticCall(
87         address target,
88         bytes memory data,
89         string memory errorMessage
90     ) internal view returns (bytes memory) {
91         require(isContract(target), "Address: static call to non-contract");
92 
93         (bool success, bytes memory returndata) = target.staticcall(data);
94         return verifyCallResult(success, returndata, errorMessage);
95     }
96 
97     function functionDelegateCall(address target, bytes memory data)
98         internal
99         returns (bytes memory)
100     {
101         return
102             functionDelegateCall(
103                 target,
104                 data,
105                 "Address: low-level delegate call failed"
106             );
107     }
108 
109     function functionDelegateCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         require(isContract(target), "Address: delegate call to non-contract");
115 
116         (bool success, bytes memory returndata) = target.delegatecall(data);
117         return verifyCallResult(success, returndata, errorMessage);
118     }
119 
120     function verifyCallResult(
121         bool success,
122         bytes memory returndata,
123         string memory errorMessage
124     ) internal pure returns (bytes memory) {
125         if (success) {
126             return returndata;
127         } else {
128             // Look for revert reason and bubble it up if present
129             if (returndata.length > 0) {
130                 // The easiest way to bubble the revert reason is using memory via assembly
131 
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
143 library SafeMath {
144     function tryAdd(uint256 a, uint256 b)
145         internal
146         pure
147         returns (bool, uint256)
148     {
149         unchecked {
150             uint256 c = a + b;
151             if (c < a) return (false, 0);
152             return (true, c);
153         }
154     }
155 
156     function trySub(uint256 a, uint256 b)
157         internal
158         pure
159         returns (bool, uint256)
160     {
161         unchecked {
162             if (b > a) return (false, 0);
163             return (true, a - b);
164         }
165     }
166 
167     function tryMul(uint256 a, uint256 b)
168         internal
169         pure
170         returns (bool, uint256)
171     {
172         unchecked {
173             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174             // benefit is lost if 'b' is also tested.
175             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176             if (a == 0) return (true, 0);
177             uint256 c = a * b;
178             if (c / a != b) return (false, 0);
179             return (true, c);
180         }
181     }
182 
183     function tryDiv(uint256 a, uint256 b)
184         internal
185         pure
186         returns (bool, uint256)
187     {
188         unchecked {
189             if (b == 0) return (false, 0);
190             return (true, a / b);
191         }
192     }
193 
194     function tryMod(uint256 a, uint256 b)
195         internal
196         pure
197         returns (bool, uint256)
198     {
199         unchecked {
200             if (b == 0) return (false, 0);
201             return (true, a % b);
202         }
203     }
204 
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a + b;
207     }
208 
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a - b;
211     }
212 
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a * b;
215     }
216 
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a / b;
219     }
220 
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a % b;
223     }
224 
225     function sub(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b <= a, errorMessage);
232             return a - b;
233         }
234     }
235 
236     function div(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b > 0, errorMessage);
243             return a / b;
244         }
245     }
246 
247     function mod(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         unchecked {
253             require(b > 0, errorMessage);
254             return a % b;
255         }
256     }
257 }
258 
259 library Counters {
260     struct Counter {
261         uint256 _value; // default: 0
262     }
263 
264     function current(Counter storage counter) internal view returns (uint256) {
265         return counter._value;
266     }
267 
268     function increment(Counter storage counter) internal {
269         unchecked {
270             counter._value += 1;
271         }
272     }
273 
274     function decrement(Counter storage counter) internal {
275         uint256 value = counter._value;
276         require(value > 0, "Counter: decrement overflow");
277         unchecked {
278             counter._value = value - 1;
279         }
280     }
281 
282     function reset(Counter storage counter) internal {
283         counter._value = 0;
284     }
285 }
286 
287 library Strings {
288     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
289 
290     function toString(uint256 value) internal pure returns (string memory) {
291         // Inspired by OraclizeAPI's implementation - MIT licence
292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
293 
294         if (value == 0) {
295             return "0";
296         }
297         uint256 temp = value;
298         uint256 digits;
299         while (temp != 0) {
300             digits++;
301             temp /= 10;
302         }
303         bytes memory buffer = new bytes(digits);
304         while (value != 0) {
305             digits -= 1;
306             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
307             value /= 10;
308         }
309         return string(buffer);
310     }
311 
312     function toHexString(uint256 value) internal pure returns (string memory) {
313         if (value == 0) {
314             return "0x00";
315         }
316         uint256 temp = value;
317         uint256 length = 0;
318         while (temp != 0) {
319             length++;
320             temp >>= 8;
321         }
322         return toHexString(value, length);
323     }
324 
325     function toHexString(uint256 value, uint256 length)
326         internal
327         pure
328         returns (string memory)
329     {
330         bytes memory buffer = new bytes(2 * length + 2);
331         buffer[0] = "0";
332         buffer[1] = "x";
333         for (uint256 i = 2 * length + 1; i > 1; --i) {
334             buffer[i] = _HEX_SYMBOLS[value & 0xf];
335             value >>= 4;
336         }
337         require(value == 0, "Strings: hex length insufficient");
338         return string(buffer);
339     }
340 }
341 
342 interface IERC165 {
343     function supportsInterface(bytes4 interfaceId) external view returns (bool);
344 }
345 
346 interface IERC721 is IERC165 {
347     event Transfer(
348         address indexed from,
349         address indexed to,
350         uint256 indexed tokenId
351     );
352 
353     event Approval(
354         address indexed owner,
355         address indexed approved,
356         uint256 indexed tokenId
357     );
358 
359     event ApprovalForAll(
360         address indexed owner,
361         address indexed operator,
362         bool approved
363     );
364 
365     function balanceOf(address owner) external view returns (uint256 balance);
366 
367     function ownerOf(uint256 tokenId) external view returns (address owner);
368 
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId
373     ) external;
374 
375     function transferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) external;
380 
381     function approve(address to, uint256 tokenId) external;
382 
383     function getApproved(uint256 tokenId)
384         external
385         view
386         returns (address operator);
387 
388     function setApprovalForAll(address operator, bool _approved) external;
389 
390     function isApprovedForAll(address owner, address operator)
391         external
392         view
393         returns (bool);
394 
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId,
399         bytes calldata data
400     ) external;
401 }
402 
403 interface IERC721Receiver {
404     function onERC721Received(
405         address operator,
406         address from,
407         uint256 tokenId,
408         bytes calldata data
409     ) external returns (bytes4);
410 }
411 
412 interface IERC721Enumerable is IERC721 {
413     function totalSupply() external view returns (uint256);
414 
415     function tokenOfOwnerByIndex(address owner, uint256 index)
416         external
417         view
418         returns (uint256 tokenId);
419 
420     function tokenByIndex(uint256 index) external view returns (uint256);
421 }
422 
423 interface IERC721Metadata is IERC721 {
424     function name() external view returns (string memory);
425 
426     function symbol() external view returns (string memory);
427 
428     function tokenURI(uint256 tokenId) external view returns (string memory);
429 }
430 
431 abstract contract ReentrancyGuard {
432     uint256 private constant _NOT_ENTERED = 1;
433     uint256 private constant _ENTERED = 2;
434     uint256 private _status;
435 
436     constructor() {
437         _status = _NOT_ENTERED;
438     }
439 
440     modifier nonReentrant() {
441         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
442         _status = _ENTERED;
443         _;
444         _status = _NOT_ENTERED;
445     }
446 }
447 
448 abstract contract ERC165 is IERC165 {
449     /**
450      * @dev See {IERC165-supportsInterface}.
451      */
452     function supportsInterface(bytes4 interfaceId)
453         public
454         view
455         virtual
456         override
457         returns (bool)
458     {
459         return interfaceId == type(IERC165).interfaceId;
460     }
461 }
462 
463 abstract contract Context {
464     function _msgSender() internal view virtual returns (address) {
465         return msg.sender;
466     }
467 
468     function _msgData() internal view virtual returns (bytes calldata) {
469         return msg.data;
470     }
471 }
472 
473 abstract contract Ownable is Context {
474     address private _owner;
475 
476     event OwnershipTransferred(
477         address indexed previousOwner,
478         address indexed newOwner
479     );
480 
481     constructor() {
482         _transferOwnership(_msgSender());
483     }
484 
485     function owner() public view virtual returns (address) {
486         return _owner;
487     }
488 
489     modifier onlyOwner() {
490         require(owner() == _msgSender(), "Ownable: caller is not the owner");
491         _;
492     }
493 
494     function renounceOwnership() public virtual onlyOwner {
495         _transferOwnership(address(0));
496     }
497 
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(
500             newOwner != address(0),
501             "Ownable: new owner is the zero address"
502         );
503         _transferOwnership(newOwner);
504     }
505 
506     function _transferOwnership(address newOwner) internal virtual {
507         address oldOwner = _owner;
508         _owner = newOwner;
509         emit OwnershipTransferred(oldOwner, newOwner);
510     }
511 }
512 
513 error ApprovalCallerNotOwnerNorApproved();
514 error ApprovalQueryForNonexistentToken();
515 error ApproveToCaller();
516 error ApprovalToCurrentOwner();
517 error BalanceQueryForZeroAddress();
518 error MintedQueryForZeroAddress();
519 error BurnedQueryForZeroAddress();
520 error MintToZeroAddress();
521 error MintZeroQuantity();
522 error OwnerIndexOutOfBounds();
523 error OwnerQueryForNonexistentToken();
524 error TokenIndexOutOfBounds();
525 error TransferCallerNotOwnerNorApproved();
526 error TransferFromIncorrectOwner();
527 error TransferToNonERC721ReceiverImplementer();
528 error TransferToZeroAddress();
529 error URIQueryForNonexistentToken();
530 
531 contract ERC721A is
532     Context,
533     ERC165,
534     IERC721,
535     IERC721Metadata,
536     IERC721Enumerable
537 {
538     using Address for address;
539     using Strings for uint256;
540 
541     // Compiler will pack this into a single 256bit word.
542     struct TokenOwnership {
543         // The address of the owner.
544         address addr;
545         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
546         uint64 startTimestamp;
547         // Whether the token has been burned.
548         bool burned;
549     }
550 
551     // Compiler will pack this into a single 256bit word.
552     struct AddressData {
553         // Realistically, 2**64-1 is more than enough.
554         uint64 balance;
555         // Keeps track of mint count with minimal overhead for tokenomics.
556         uint64 numberMinted;
557         // Keeps track of burn count with minimal overhead for tokenomics.
558         uint64 numberBurned;
559     }
560 
561     // Compiler will pack the following
562     // _currentIndex and _burnCounter into a single 256bit word.
563 
564     // The tokenId of the next token to be minted.
565     uint128 internal _currentIndex = 1;
566 
567     // The number of tokens burned.
568     uint128 internal _burnCounter;
569 
570     // Token name
571     string private _name;
572 
573     // Token symbol
574     string private _symbol;
575 
576     // Mapping from token ID to ownership details
577     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
578     mapping(uint256 => TokenOwnership) internal _ownerships;
579 
580     // Mapping owner address to address data
581     mapping(address => AddressData) private _addressData;
582 
583     // Mapping from token ID to approved address
584     mapping(uint256 => address) private _tokenApprovals;
585 
586     // Mapping from owner to operator approvals
587     mapping(address => mapping(address => bool)) private _operatorApprovals;
588 
589     constructor(string memory name_, string memory symbol_) {
590         _name = name_;
591         _symbol = symbol_;
592     }
593 
594     function totalSupply() public view override returns (uint256) {
595         // Counter underflow is impossible as _burnCounter cannot be incremented
596         // more than _currentIndex times
597         unchecked {
598             return _currentIndex - _burnCounter -1;
599         }
600     }
601 
602     function tokenByIndex(uint256 index)
603         public
604         view
605         override
606         returns (uint256)
607     {
608         uint256 numMintedSoFar = _currentIndex;
609         uint256 tokenIdsIdx;
610 
611         // Counter overflow is impossible as the loop breaks when
612         // uint256 i is equal to another uint256 numMintedSoFar.
613         unchecked {
614             for (uint256 i; i < numMintedSoFar; i++) {
615                 TokenOwnership memory ownership = _ownerships[i];
616                 if (!ownership.burned) {
617                     if (tokenIdsIdx == index) {
618                         return i;
619                     }
620                     tokenIdsIdx++;
621                 }
622             }
623         }
624         revert TokenIndexOutOfBounds();
625     }
626 
627     function tokenOfOwnerByIndex(address owner, uint256 index)
628         public
629         view
630         override
631         returns (uint256)
632     {
633         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
634         uint256 numMintedSoFar = _currentIndex;
635         uint256 tokenIdsIdx;
636         address currOwnershipAddr;
637 
638         // Counter overflow is impossible as the loop breaks when
639         // uint256 i is equal to another uint256 numMintedSoFar.
640         unchecked {
641             for (uint256 i; i < numMintedSoFar; i++) {
642                 TokenOwnership memory ownership = _ownerships[i];
643                 if (ownership.burned) {
644                     continue;
645                 }
646                 if (ownership.addr != address(0)) {
647                     currOwnershipAddr = ownership.addr;
648                 }
649                 if (currOwnershipAddr == owner) {
650                     if (tokenIdsIdx == index) {
651                         return i;
652                     }
653                     tokenIdsIdx++;
654                 }
655             }
656         }
657 
658         // Execution should never reach this point.
659         revert();
660     }
661 
662     function supportsInterface(bytes4 interfaceId)
663         public
664         view
665         virtual
666         override(ERC165, IERC165)
667         returns (bool)
668     {
669         return
670             interfaceId == type(IERC721).interfaceId ||
671             interfaceId == type(IERC721Metadata).interfaceId ||
672             interfaceId == type(IERC721Enumerable).interfaceId ||
673             super.supportsInterface(interfaceId);
674     }
675 
676     function balanceOf(address owner) public view override returns (uint256) {
677         if (owner == address(0)) revert BalanceQueryForZeroAddress();
678         return uint256(_addressData[owner].balance);
679     }
680 
681     function _numberMinted(address owner) internal view returns (uint256) {
682         if (owner == address(0)) revert MintedQueryForZeroAddress();
683         return uint256(_addressData[owner].numberMinted);
684     }
685 
686     function _numberBurned(address owner) internal view returns (uint256) {
687         if (owner == address(0)) revert BurnedQueryForZeroAddress();
688         return uint256(_addressData[owner].numberBurned);
689     }
690 
691     function ownershipOf(uint256 tokenId)
692         internal
693         view
694         returns (TokenOwnership memory)
695     {
696         uint256 curr = tokenId;
697 
698         unchecked {
699             if (curr < _currentIndex) {
700                 TokenOwnership memory ownership = _ownerships[curr];
701                 if (!ownership.burned) {
702                     if (ownership.addr != address(0)) {
703                         return ownership;
704                     }
705                     // Invariant:
706                     // There will always be an ownership that has an address and is not burned
707                     // before an ownership that does not have an address and is not burned.
708                     // Hence, curr will not underflow.
709                     while (true) {
710                         curr--;
711                         ownership = _ownerships[curr];
712                         if (ownership.addr != address(0)) {
713                             return ownership;
714                         }
715                     }
716                 }
717             }
718         }
719         revert OwnerQueryForNonexistentToken();
720     }
721 
722     function ownerOf(uint256 tokenId) public view override returns (address) {
723         return ownershipOf(tokenId).addr;
724     }
725 
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729 
730     function symbol() public view virtual override returns (string memory) {
731         return _symbol;
732     }
733 
734     function tokenURI(uint256 tokenId)
735         public
736         view
737         virtual
738         override
739         returns (string memory)
740     {
741         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
742 
743         string memory baseURI = _baseURI();
744         return
745             bytes(baseURI).length != 0
746                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
747                 : "";
748     }
749 
750     function _baseURI() internal view virtual returns (string memory) {
751         return "";
752     }
753 
754     function approve(address to, uint256 tokenId) public override {
755         address owner = ERC721A.ownerOf(tokenId);
756         if (to == owner) revert ApprovalToCurrentOwner();
757 
758         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
759             revert ApprovalCallerNotOwnerNorApproved();
760         }
761 
762         _approve(to, tokenId, owner);
763     }
764 
765     function getApproved(uint256 tokenId)
766         public
767         view
768         override
769         returns (address)
770     {
771         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
772 
773         return _tokenApprovals[tokenId];
774     }
775 
776     function setApprovalForAll(address operator, bool approved)
777         public
778         override
779     {
780         if (operator == _msgSender()) revert ApproveToCaller();
781 
782         _operatorApprovals[_msgSender()][operator] = approved;
783         emit ApprovalForAll(_msgSender(), operator, approved);
784     }
785 
786     function isApprovedForAll(address owner, address operator)
787         public
788         view
789         virtual
790         override
791         returns (bool)
792     {
793         return _operatorApprovals[owner][operator];
794     }
795 
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         _transfer(from, to, tokenId);
802     }
803 
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         safeTransferFrom(from, to, tokenId, "");
810     }
811 
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) public virtual override {
818         _transfer(from, to, tokenId);
819         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
820             revert TransferToNonERC721ReceiverImplementer();
821         }
822     }
823 
824     function _exists(uint256 tokenId) internal view returns (bool) {
825         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
826     }
827 
828     function _safeMint(address to, uint256 quantity) internal {
829         _safeMint(to, quantity, "");
830     }
831 
832     function _safeMint(
833         address to,
834         uint256 quantity,
835         bytes memory _data
836     ) internal {
837         _mint(to, quantity, _data, true);
838     }
839 
840     function _mint(
841         address to,
842         uint256 quantity,
843         bytes memory _data,
844         bool safe
845     ) internal {
846         uint256 startTokenId = _currentIndex;
847         if (to == address(0)) revert MintToZeroAddress();
848         if (quantity == 0) revert MintZeroQuantity();
849 
850         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
851 
852         // Overflows are incredibly unrealistic.
853         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
854         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
855         unchecked {
856             _addressData[to].balance += uint64(quantity);
857             _addressData[to].numberMinted += uint64(quantity);
858 
859             _ownerships[startTokenId].addr = to;
860             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
861 
862             uint256 updatedIndex = startTokenId;
863 
864             for (uint256 i; i < quantity; i++) {
865                 emit Transfer(address(0), to, updatedIndex);
866                 if (
867                     safe &&
868                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
869                 ) {
870                     revert TransferToNonERC721ReceiverImplementer();
871                 }
872                 updatedIndex++;
873             }
874 
875             _currentIndex = uint128(updatedIndex);
876         }
877         _afterTokenTransfers(address(0), to, startTokenId, quantity);
878     }
879 
880     function _transfer(
881         address from,
882         address to,
883         uint256 tokenId
884     ) private {
885         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
886 
887         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
888             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
889             getApproved(tokenId) == _msgSender());
890 
891         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
892         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
893         if (to == address(0)) revert TransferToZeroAddress();
894 
895         _beforeTokenTransfers(from, to, tokenId, 1);
896 
897         // Clear approvals from the previous owner
898         _approve(address(0), tokenId, prevOwnership.addr);
899 
900         // Underflow of the sender's balance is impossible because we check for
901         // ownership above and the recipient's balance can't realistically overflow.
902         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
903         unchecked {
904             _addressData[from].balance -= 1;
905             _addressData[to].balance += 1;
906 
907             _ownerships[tokenId].addr = to;
908             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
909 
910             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
911             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
912             uint256 nextTokenId = tokenId + 1;
913             if (_ownerships[nextTokenId].addr == address(0)) {
914                 // This will suffice for checking _exists(nextTokenId),
915                 // as a burned slot cannot contain the zero address.
916                 if (nextTokenId < _currentIndex) {
917                     _ownerships[nextTokenId].addr = prevOwnership.addr;
918                     _ownerships[nextTokenId].startTimestamp = prevOwnership
919                         .startTimestamp;
920                 }
921             }
922         }
923 
924         emit Transfer(from, to, tokenId);
925         _afterTokenTransfers(from, to, tokenId, 1);
926     }
927 
928     function _burn(uint256 tokenId) internal virtual {
929         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
930 
931         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
932 
933         // Clear approvals from the previous owner
934         _approve(address(0), tokenId, prevOwnership.addr);
935 
936         // Underflow of the sender's balance is impossible because we check for
937         // ownership above and the recipient's balance can't realistically overflow.
938         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
939         unchecked {
940             _addressData[prevOwnership.addr].balance -= 1;
941             _addressData[prevOwnership.addr].numberBurned += 1;
942 
943             // Keep track of who burned the token, and the timestamp of burning.
944             _ownerships[tokenId].addr = prevOwnership.addr;
945             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
946             _ownerships[tokenId].burned = true;
947 
948             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
949             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
950             uint256 nextTokenId = tokenId + 1;
951             if (_ownerships[nextTokenId].addr == address(0)) {
952                 // This will suffice for checking _exists(nextTokenId),
953                 // as a burned slot cannot contain the zero address.
954                 if (nextTokenId < _currentIndex) {
955                     _ownerships[nextTokenId].addr = prevOwnership.addr;
956                     _ownerships[nextTokenId].startTimestamp = prevOwnership
957                         .startTimestamp;
958                 }
959             }
960         }
961 
962         emit Transfer(prevOwnership.addr, address(0), tokenId);
963         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
964 
965         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
966         unchecked {
967             _burnCounter++;
968         }
969     }
970 
971     function _approve(
972         address to,
973         uint256 tokenId,
974         address owner
975     ) private {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(owner, to, tokenId);
978     }
979 
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try
988                 IERC721Receiver(to).onERC721Received(
989                     _msgSender(),
990                     from,
991                     tokenId,
992                     _data
993                 )
994             returns (bytes4 retval) {
995                 return retval == IERC721Receiver(to).onERC721Received.selector;
996             } catch (bytes memory reason) {
997                 if (reason.length == 0) {
998                     revert TransferToNonERC721ReceiverImplementer();
999                 } else {
1000                     assembly {
1001                         revert(add(32, reason), mload(reason))
1002                     }
1003                 }
1004             }
1005         } else {
1006             return true;
1007         }
1008     }
1009 
1010     function _beforeTokenTransfers(
1011         address from,
1012         address to,
1013         uint256 startTokenId,
1014         uint256 quantity
1015     ) internal virtual {}
1016 
1017     function _afterTokenTransfers(
1018         address from,
1019         address to,
1020         uint256 startTokenId,
1021         uint256 quantity
1022     ) internal virtual {}
1023 }
1024 
1025 contract ERVGandalf is ERC721A, ReentrancyGuard, Ownable {
1026     using SafeMath for uint256;
1027     using Counters for Counters.Counter;
1028 
1029     Counters.Counter private _tokenIdTracker;
1030     uint256 public MAX_ELEMENTS = 2930;
1031     uint256 public PRICE = 88 * 10**14; //0.0088 Ether
1032     uint256 public SALE_START = 1658037600 ; // July 17, 2022 06:00:00 UTC
1033 
1034     bool public isPaused = false;
1035 
1036     string public baseTokenURI;
1037 
1038     mapping(address => bool) _freeClaimed;
1039 
1040     event CreateERVGandalfNFT(uint256 indexed id);
1041 
1042     constructor(string memory baseURI) ERC721A("E.R.V Gandalf", "GANDALF") {
1043         baseTokenURI = baseURI;
1044         transferOwnership(address(0xC307b94288d569E9Bbf75a17EB684E5325D646e2));
1045         _tokenIdTracker.increment();
1046     }
1047 
1048     function mint(uint256 _count) public payable {
1049         uint256 total = totalSupply();
1050         require(SALE_START < block.timestamp, "Minting not started");
1051         require(!isPaused, "Sale is Paused.");
1052         require(total + _count <= MAX_ELEMENTS, "Max limit");
1053         require(total <= MAX_ELEMENTS, "All NFT's are sold out");
1054         if(_freeClaimed[_msgSender()]){
1055             require(msg.value >= salePrice(_count), "Value below price");
1056         }else{
1057             require(_count == 1, "Can not mint more than 1 free NFT");
1058             _freeClaimed[_msgSender()] = true;
1059         }
1060         _safeMint(_msgSender(), _count);
1061         emit CreateERVGandalfNFT(_count);
1062         _withdraw(owner(), address(this).balance);
1063     }
1064 
1065     function isFreeClaimed(address _sender) public view returns(bool){
1066         return _freeClaimed[_sender];
1067     }
1068 
1069     function salePrice(uint256 _count) public view returns (uint256) {
1070         return PRICE.mul(_count);
1071     }
1072 
1073     function _baseURI() internal view virtual override returns (string memory) {
1074         return baseTokenURI;
1075     }
1076 
1077     function setBaseURI(string memory baseURI) public onlyOwner {
1078         baseTokenURI = baseURI;
1079     }
1080 
1081     function tokenURI(uint256 tokenId)
1082         public
1083         view
1084         virtual
1085         override
1086         returns (string memory)
1087     {
1088         require(
1089             _exists(tokenId),
1090             "ERC721Metadata: URI query for nonexistent token"
1091         );
1092 
1093         uint256 metaId = tokenId;
1094         string memory uriSuffix = ".json";
1095         string memory currentBaseURI = _baseURI();
1096 
1097         return
1098             bytes(currentBaseURI).length > 0
1099                 ? string(
1100                     abi.encodePacked(
1101                         currentBaseURI,
1102                         Strings.toString(metaId),
1103                         uriSuffix
1104                     )
1105                 )
1106                 : "";
1107     }
1108 
1109     function walletOfOwner(address _owner)
1110         external
1111         view
1112         returns (uint256[] memory)
1113     {
1114         uint256 tokenCount = balanceOf(_owner);
1115 
1116         uint256[] memory tokensId = new uint256[](tokenCount);
1117         for (uint256 i = 0; i < tokenCount; i++) {
1118             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1119         }
1120 
1121         return tokensId;
1122     }
1123 
1124     function setMaxElements(uint256 _maxElements) external onlyOwner {
1125         MAX_ELEMENTS = _maxElements;
1126     }
1127 
1128     function pauseMinting() external onlyOwner {
1129         isPaused = true;
1130     }
1131 
1132     function resumeMinting() external onlyOwner {
1133         isPaused = false;
1134     }
1135 
1136     function setSalePrice(uint256 _price) external onlyOwner {
1137         PRICE = _price;
1138     }
1139 
1140     function setSaleStart(uint256 _time) external onlyOwner {
1141         SALE_START = _time;
1142     }
1143     
1144     function withdrawAll() external nonReentrant onlyOwner {
1145         uint256 balance = address(this).balance;
1146         require(balance > 0);
1147         _withdraw(owner(), balance);
1148     }
1149 
1150     function _withdraw(address _address, uint256 _amount) private {
1151         payable(_address).transfer(_amount);
1152     }
1153 
1154 }