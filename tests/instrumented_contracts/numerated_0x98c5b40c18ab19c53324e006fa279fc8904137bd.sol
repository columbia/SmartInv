1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 library MerkleProof {
5     function verify(
6         bytes32[] memory proof,
7         bytes32 root,
8         bytes32 leaf
9     ) internal pure returns (bool) {
10         return processProof(proof, leaf) == root;
11     }
12 
13     function processProof(bytes32[] memory proof, bytes32 leaf)
14         internal
15         pure
16         returns (bytes32)
17     {
18         bytes32 computedHash = leaf;
19         for (uint256 i = 0; i < proof.length; i++) {
20             bytes32 proofElement = proof[i];
21             if (computedHash <= proofElement) {
22                 computedHash = _efficientHash(computedHash, proofElement);
23             } else {
24                 computedHash = _efficientHash(proofElement, computedHash);
25             }
26         }
27         return computedHash;
28     }
29 
30     function _efficientHash(bytes32 a, bytes32 b)
31         private
32         pure
33         returns (bytes32 value)
34     {
35         assembly {
36             mstore(0x00, a)
37             mstore(0x20, b)
38             value := keccak256(0x00, 0x40)
39         }
40     }
41 }
42 
43 abstract contract ReentrancyGuard {
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     modifier nonReentrant() {
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55         _status = _ENTERED;
56 
57         _;
58         _status = _NOT_ENTERED;
59     }
60 }
61 
62 /**
63  * @dev Wrappers over Solidity's arithmetic operations.
64  *
65  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
66  * now has built in overflow checking.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, with an overflow flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryAdd(uint256 a, uint256 b)
75         internal
76         pure
77         returns (bool, uint256)
78     {
79         unchecked {
80             uint256 c = a + b;
81             if (c < a) return (false, 0);
82             return (true, c);
83         }
84     }
85 
86     /**
87      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
88      *
89      * _Available since v3.4._
90      */
91     function trySub(uint256 a, uint256 b)
92         internal
93         pure
94         returns (bool, uint256)
95     {
96         unchecked {
97             if (b > a) return (false, 0);
98             return (true, a - b);
99         }
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryMul(uint256 a, uint256 b)
108         internal
109         pure
110         returns (bool, uint256)
111     {
112         unchecked {
113             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114             // benefit is lost if 'b' is also tested.
115             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116             if (a == 0) return (true, 0);
117             uint256 c = a * b;
118             if (c / a != b) return (false, 0);
119             return (true, c);
120         }
121     }
122 
123     /**
124      * @dev Returns the division of two unsigned integers, with a division by zero flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryDiv(uint256 a, uint256 b)
129         internal
130         pure
131         returns (bool, uint256)
132     {
133         unchecked {
134             if (b == 0) return (false, 0);
135             return (true, a / b);
136         }
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMod(uint256 a, uint256 b)
145         internal
146         pure
147         returns (bool, uint256)
148     {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a % b);
152         }
153     }
154 
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      *
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a + b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a * b;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers, reverting on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator.
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a / b;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * reverting when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a % b;
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229      * overflow (when the result is negative).
230      *
231      * CAUTION: This function is deprecated because it requires allocating memory for the error
232      * message unnecessarily. For custom revert reasons use {trySub}.
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b <= a, errorMessage);
247             return a - b;
248         }
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a / b;
271         }
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * reverting with custom message when dividing by zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryMod}.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a % b;
297         }
298     }
299 }
300 
301 library Strings {
302     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
303 
304     function toString(uint256 value) internal pure returns (string memory) {
305         if (value == 0) {
306             return "0";
307         }
308         uint256 temp = value;
309         uint256 digits;
310         while (temp != 0) {
311             digits++;
312             temp /= 10;
313         }
314         bytes memory buffer = new bytes(digits);
315         while (value != 0) {
316             digits -= 1;
317             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
318             value /= 10;
319         }
320         return string(buffer);
321     }
322 
323     function toHexString(uint256 value) internal pure returns (string memory) {
324         if (value == 0) {
325             return "0x00";
326         }
327         uint256 temp = value;
328         uint256 length = 0;
329         while (temp != 0) {
330             length++;
331             temp >>= 8;
332         }
333         return toHexString(value, length);
334     }
335 
336     function toHexString(uint256 value, uint256 length)
337         internal
338         pure
339         returns (string memory)
340     {
341         bytes memory buffer = new bytes(2 * length + 2);
342         buffer[0] = "0";
343         buffer[1] = "x";
344         for (uint256 i = 2 * length + 1; i > 1; --i) {
345             buffer[i] = _HEX_SYMBOLS[value & 0xf];
346             value >>= 4;
347         }
348         require(value == 0, "Strings: hex length insufficient");
349         return string(buffer);
350     }
351 }
352 
353 abstract contract Context {
354     function _msgSender() internal view virtual returns (address) {
355         return msg.sender;
356     }
357 
358     function _msgData() internal view virtual returns (bytes calldata) {
359         return msg.data;
360     }
361 }
362 
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(
367         address indexed previousOwner,
368         address indexed newOwner
369     );
370 
371     constructor() {
372         _transferOwnership(_msgSender());
373     }
374 
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     modifier onlyOwner() {
380         require(owner() == _msgSender(), "Ownable: caller is not the owner");
381         _;
382     }
383 
384     function renounceOwnership() public virtual onlyOwner {
385         _transferOwnership(address(0));
386     }
387 
388     function transferOwnership(address newOwner) public virtual onlyOwner {
389         require(
390             newOwner != address(0),
391             "Ownable: new owner is the zero address"
392         );
393         _transferOwnership(newOwner);
394     }
395 
396     function _transferOwnership(address newOwner) internal virtual {
397         address oldOwner = _owner;
398         _owner = newOwner;
399         emit OwnershipTransferred(oldOwner, newOwner);
400     }
401 }
402 
403 library Address {
404     function isContract(address account) internal view returns (bool) {
405         uint256 size;
406         assembly {
407             size := extcodesize(account)
408         }
409         return size > 0;
410     }
411 
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(
414             address(this).balance >= amount,
415             "Address: insufficient balance"
416         );
417 
418         (bool success, ) = recipient.call{value: amount}("");
419         require(
420             success,
421             "Address: unable to send value, recipient may have reverted"
422         );
423     }
424 
425     function functionCall(address target, bytes memory data)
426         internal
427         returns (bytes memory)
428     {
429         return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     function functionCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         return functionCallWithValue(target, data, 0, errorMessage);
438     }
439 
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value
444     ) internal returns (bytes memory) {
445         return
446             functionCallWithValue(
447                 target,
448                 data,
449                 value,
450                 "Address: low-level call with value failed"
451             );
452     }
453 
454     function functionCallWithValue(
455         address target,
456         bytes memory data,
457         uint256 value,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(
461             address(this).balance >= value,
462             "Address: insufficient balance for call"
463         );
464         require(isContract(target), "Address: call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.call{value: value}(
467             data
468         );
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     function functionStaticCall(address target, bytes memory data)
473         internal
474         view
475         returns (bytes memory)
476     {
477         return
478             functionStaticCall(
479                 target,
480                 data,
481                 "Address: low-level static call failed"
482             );
483     }
484 
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     function functionDelegateCall(address target, bytes memory data)
497         internal
498         returns (bytes memory)
499     {
500         return
501             functionDelegateCall(
502                 target,
503                 data,
504                 "Address: low-level delegate call failed"
505             );
506     }
507 
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     function verifyCallResult(
520         bool success,
521         bytes memory returndata,
522         string memory errorMessage
523     ) internal pure returns (bytes memory) {
524         if (success) {
525             return returndata;
526         } else {
527             if (returndata.length > 0) {
528                 assembly {
529                     let returndata_size := mload(returndata)
530                     revert(add(32, returndata), returndata_size)
531                 }
532             } else {
533                 revert(errorMessage);
534             }
535         }
536     }
537 }
538 
539 interface IERC721Receiver {
540     function onERC721Received(
541         address operator,
542         address from,
543         uint256 tokenId,
544         bytes calldata data
545     ) external returns (bytes4);
546 }
547 
548 interface IERC165 {
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 abstract contract ERC165 is IERC165 {
553     function supportsInterface(bytes4 interfaceId)
554         public
555         view
556         virtual
557         override
558         returns (bool)
559     {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 interface IERC721 is IERC165 {
565     event Transfer(
566         address indexed from,
567         address indexed to,
568         uint256 indexed tokenId
569     );
570     event Approval(
571         address indexed owner,
572         address indexed approved,
573         uint256 indexed tokenId
574     );
575     event ApprovalForAll(
576         address indexed owner,
577         address indexed operator,
578         bool approved
579     );
580 
581     function balanceOf(address owner) external view returns (uint256 balance);
582 
583     function ownerOf(uint256 tokenId) external view returns (address owner);
584 
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId
589     ) external;
590 
591     function transferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     function approve(address to, uint256 tokenId) external;
598 
599     function getApproved(uint256 tokenId)
600         external
601         view
602         returns (address operator);
603 
604     function setApprovalForAll(address operator, bool _approved) external;
605 
606     function isApprovedForAll(address owner, address operator)
607         external
608         view
609         returns (bool);
610 
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 }
618 
619 interface IERC721Enumerable is IERC721 {
620     function totalSupply() external view returns (uint256);
621 
622     function tokenOfOwnerByIndex(address owner, uint256 index)
623         external
624         view
625         returns (uint256 tokenId);
626 
627     function tokenByIndex(uint256 index) external view returns (uint256);
628 }
629 
630 interface IERC721Metadata is IERC721 {
631     function name() external view returns (string memory);
632 
633     function symbol() external view returns (string memory);
634 
635     function tokenURI(uint256 tokenId) external view returns (string memory);
636 }
637 
638 contract ERC721A is
639     Context,
640     ERC165,
641     IERC721,
642     IERC721Metadata,
643     IERC721Enumerable
644 {
645     using Address for address;
646     using Strings for uint256;
647 
648     struct TokenOwnership {
649         address addr;
650         uint64 startTimestamp;
651     }
652 
653     struct AddressData {
654         uint128 balance;
655         uint128 numberMinted;
656     }
657 
658     uint256 private currentIndex = 1;
659 
660     uint256 internal immutable collectionSize;
661     uint256 internal immutable maxBatchSize;
662     string private _name;
663     string private _symbol;
664     mapping(uint256 => TokenOwnership) private _ownerships;
665     mapping(address => AddressData) private _addressData;
666     mapping(uint256 => address) private _tokenApprovals;
667     mapping(address => mapping(address => bool)) private _operatorApprovals;
668 
669     constructor(
670         string memory name_,
671         string memory symbol_,
672         uint256 maxBatchSize_,
673         uint256 collectionSize_
674     ) {
675         require(
676             collectionSize_ > 0,
677             "ERC721A: collection must have a nonzero supply"
678         );
679         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
680         _name = name_;
681         _symbol = symbol_;
682         maxBatchSize = maxBatchSize_;
683         collectionSize = collectionSize_;
684     }
685 
686     function totalSupply() public view override returns (uint256) {
687         return currentIndex - 1;
688     }
689 
690     function tokenByIndex(uint256 index)
691         public
692         view
693         override
694         returns (uint256)
695     {
696         require(index < totalSupply(), "ERC721A: global index out of bounds");
697         return index;
698     }
699 
700     function tokenOfOwnerByIndex(address owner, uint256 index)
701         public
702         view
703         override
704         returns (uint256)
705     {
706         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
707         uint256 numMintedSoFar = totalSupply();
708         uint256 tokenIdsIdx = 0;
709         address currOwnershipAddr = address(0);
710         for (uint256 i = 0; i < numMintedSoFar; i++) {
711             TokenOwnership memory ownership = _ownerships[i];
712             if (ownership.addr != address(0)) {
713                 currOwnershipAddr = ownership.addr;
714             }
715             if (currOwnershipAddr == owner) {
716                 if (tokenIdsIdx == index) {
717                     return i;
718                 }
719                 tokenIdsIdx++;
720             }
721         }
722         revert("ERC721A: unable to get token of owner by index");
723     }
724 
725     function supportsInterface(bytes4 interfaceId)
726         public
727         view
728         virtual
729         override(ERC165, IERC165)
730         returns (bool)
731     {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             interfaceId == type(IERC721Enumerable).interfaceId ||
736             super.supportsInterface(interfaceId);
737     }
738 
739     function balanceOf(address owner) public view override returns (uint256) {
740         require(
741             owner != address(0),
742             "ERC721A: balance query for the zero address"
743         );
744         return uint256(_addressData[owner].balance);
745     }
746 
747     function _numberMinted(address owner) internal view returns (uint256) {
748         require(
749             owner != address(0),
750             "ERC721A: number minted query for the zero address"
751         );
752         return uint256(_addressData[owner].numberMinted);
753     }
754 
755     function ownershipOf(uint256 tokenId)
756         internal
757         view
758         returns (TokenOwnership memory)
759     {
760         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
761 
762         uint256 lowestTokenToCheck;
763         if (tokenId >= maxBatchSize) {
764             lowestTokenToCheck = tokenId - maxBatchSize + 1;
765         }
766 
767         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
768             TokenOwnership memory ownership = _ownerships[curr];
769             if (ownership.addr != address(0)) {
770                 return ownership;
771             }
772         }
773 
774         revert("ERC721A: unable to determine the owner of token");
775     }
776 
777     function ownerOf(uint256 tokenId) public view override returns (address) {
778         return ownershipOf(tokenId).addr;
779     }
780 
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     function symbol() public view virtual override returns (string memory) {
786         return _symbol;
787     }
788 
789     function tokenURI(uint256 tokenId)
790         public
791         view
792         virtual
793         override
794         returns (string memory)
795     {
796         require(
797             _exists(tokenId),
798             "ERC721Metadata: URI query for nonexistent token"
799         );
800 
801         string memory baseURI = _baseURI();
802         return
803             bytes(baseURI).length > 0
804                 ? string(
805                     abi.encodePacked(
806                         baseURI,
807                         tokenId.toString(),
808                         _getUriExtension()
809                     )
810                 )
811                 : "";
812     }
813 
814     function _baseURI() internal view virtual returns (string memory) {
815         return "";
816     }
817 
818     function _getUriExtension() internal view virtual returns (string memory) {
819         return "";
820     }
821 
822     function approve(address to, uint256 tokenId) public override {
823         address owner = ERC721A.ownerOf(tokenId);
824         require(to != owner, "ERC721A: approval to current owner");
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             "ERC721A: approve caller is not owner nor approved for all"
829         );
830 
831         _approve(to, tokenId, owner);
832     }
833 
834     function getApproved(uint256 tokenId)
835         public
836         view
837         override
838         returns (address)
839     {
840         require(
841             _exists(tokenId),
842             "ERC721A: approved query for nonexistent token"
843         );
844 
845         return _tokenApprovals[tokenId];
846     }
847 
848     function setApprovalForAll(address operator, bool approved)
849         public
850         override
851     {
852         require(operator != _msgSender(), "ERC721A: approve to caller");
853 
854         _operatorApprovals[_msgSender()][operator] = approved;
855         emit ApprovalForAll(_msgSender(), operator, approved);
856     }
857 
858     function isApprovedForAll(address owner, address operator)
859         public
860         view
861         virtual
862         override
863         returns (bool)
864     {
865         return _operatorApprovals[owner][operator];
866     }
867 
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public override {
873         _transfer(from, to, tokenId);
874     }
875 
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public override {
881         safeTransferFrom(from, to, tokenId, "");
882     }
883 
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public override {
890         _transfer(from, to, tokenId);
891         require(
892             _checkOnERC721Received(from, to, tokenId, _data),
893             "ERC721A: transfer to non ERC721Receiver implementer"
894         );
895     }
896 
897     function _exists(uint256 tokenId) internal view returns (bool) {
898         return tokenId < currentIndex;
899     }
900 
901     function _safeMint(address to, uint256 quantity) internal {
902         _safeMint(to, quantity, "");
903     }
904 
905     function _safeMint(
906         address to,
907         uint256 quantity,
908         bytes memory _data
909     ) internal {
910         uint256 startTokenId = currentIndex;
911         require(to != address(0), "ERC721A: mint to the zero address");
912         require(!_exists(startTokenId), "ERC721A: token already minted");
913         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
914 
915         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
916 
917         AddressData memory addressData = _addressData[to];
918         _addressData[to] = AddressData(
919             addressData.balance + uint128(quantity),
920             addressData.numberMinted + uint128(quantity)
921         );
922         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
923 
924         uint256 updatedIndex = startTokenId;
925 
926         for (uint256 i = 0; i < quantity; i++) {
927             emit Transfer(address(0), to, updatedIndex);
928             require(
929                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
930                 "ERC721A: transfer to non ERC721Receiver implementer"
931             );
932             updatedIndex++;
933         }
934 
935         currentIndex = updatedIndex;
936         _afterTokenTransfers(address(0), to, startTokenId, quantity);
937     }
938 
939     function _transfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) private {
944         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
945 
946         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
947             getApproved(tokenId) == _msgSender() ||
948             isApprovedForAll(prevOwnership.addr, _msgSender()));
949 
950         require(
951             isApprovedOrOwner,
952             "ERC721A: transfer caller is not owner nor approved"
953         );
954 
955         require(
956             prevOwnership.addr == from,
957             "ERC721A: transfer from incorrect owner"
958         );
959         require(to != address(0), "ERC721A: transfer to the zero address");
960 
961         _beforeTokenTransfers(from, to, tokenId, 1);
962         _approve(address(0), tokenId, prevOwnership.addr);
963 
964         _addressData[from].balance -= 1;
965         _addressData[to].balance += 1;
966         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
967         uint256 nextTokenId = tokenId + 1;
968         if (_ownerships[nextTokenId].addr == address(0)) {
969             if (_exists(nextTokenId)) {
970                 _ownerships[nextTokenId] = TokenOwnership(
971                     prevOwnership.addr,
972                     prevOwnership.startTimestamp
973                 );
974             }
975         }
976 
977         emit Transfer(from, to, tokenId);
978         _afterTokenTransfers(from, to, tokenId, 1);
979     }
980 
981     function _approve(
982         address to,
983         uint256 tokenId,
984         address owner
985     ) private {
986         _tokenApprovals[tokenId] = to;
987         emit Approval(owner, to, tokenId);
988     }
989 
990     uint256 public nextOwnerToExplicitlySet = 0;
991 
992     function _setOwnersExplicit(uint256 quantity) internal {
993         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
994         require(quantity > 0, "quantity must be nonzero");
995         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
996         if (endIndex > collectionSize - 1) {
997             endIndex = collectionSize - 1;
998         }
999         require(_exists(endIndex), "not enough minted yet for this cleanup");
1000         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1001             if (_ownerships[i].addr == address(0)) {
1002                 TokenOwnership memory ownership = ownershipOf(i);
1003                 _ownerships[i] = TokenOwnership(
1004                     ownership.addr,
1005                     ownership.startTimestamp
1006                 );
1007             }
1008         }
1009         nextOwnerToExplicitlySet = endIndex + 1;
1010     }
1011 
1012     function _checkOnERC721Received(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) private returns (bool) {
1018         if (to.isContract()) {
1019             try
1020                 IERC721Receiver(to).onERC721Received(
1021                     _msgSender(),
1022                     from,
1023                     tokenId,
1024                     _data
1025                 )
1026             returns (bytes4 retval) {
1027                 return retval == IERC721Receiver(to).onERC721Received.selector;
1028             } catch (bytes memory reason) {
1029                 if (reason.length == 0) {
1030                     revert(
1031                         "ERC721A: transfer to non ERC721Receiver implementer"
1032                     );
1033                 } else {
1034                     assembly {
1035                         revert(add(32, reason), mload(reason))
1036                     }
1037                 }
1038             }
1039         } else {
1040             return true;
1041         }
1042     }
1043 
1044     function _beforeTokenTransfers(
1045         address from,
1046         address to,
1047         uint256 startTokenId,
1048         uint256 quantity
1049     ) internal virtual {}
1050 
1051     function _afterTokenTransfers(
1052         address from,
1053         address to,
1054         uint256 startTokenId,
1055         uint256 quantity
1056     ) internal virtual {}
1057 }
1058 
1059 contract ETHFP is Ownable, ERC721A, ReentrancyGuard {
1060     using Strings for uint256;
1061     using SafeMath for uint256;
1062 
1063     uint256 public MAX_PER_Transaction = 1; // maximum amount that user can mint per transaction
1064     uint256 public MAX_PER_Address = 1;
1065 
1066     
1067     uint256 public price = 0 ether; 
1068 
1069     uint96 public royaltyFeesInBips;
1070     
1071     address public royaltyRecipient =
1072         0xb72b18Abd12511388bED432d628708391a9Ba0e4;
1073 
1074     uint256 private constant TotalCollectionSize_ = 5555; 
1075     uint256 private constant MaxMintPerBatch_ = 255; //Required to reserve this amount in constructor.
1076 
1077     uint256 private reserveNFTs;
1078     uint16 private reserveLimit = 255;
1079 
1080     bool public whiteListIsActive = true;
1081     bool public privateListIsActive = true;
1082     
1083     bool public paused = true;
1084     bool public revealed = false;
1085 
1086     uint256 private whiteListSpots = 1000;
1087     uint256 private privateListSpots = 4300;
1088 
1089     string private baseTokenURI;
1090     string public notRevealedURI;
1091 
1092     address private teamWallet; 
1093     bytes32 public merkleRoot;
1094 
1095     constructor(
1096         string memory _uri, 
1097         string memory _hiddenURI, 
1098         uint96 _royaltyFeesInBips, 
1099         bytes32 _root, 
1100         address _teamWallet)
1101         ERC721A(
1102             "1 ETH FP",
1103             "1EthFP",
1104             MaxMintPerBatch_,
1105             TotalCollectionSize_
1106         )
1107     {
1108         
1109         setBaseURI(_uri);
1110         setNotRevealedURI(_hiddenURI);
1111         royaltyFeesInBips = _royaltyFeesInBips;
1112         merkleRoot = _root;
1113         teamWallet = _teamWallet;
1114         reserveNFT(255);
1115     }
1116 
1117     function supportsInterface(bytes4 interfaceId)
1118         public
1119         view
1120         override(ERC721A)
1121         returns (bool)
1122     {
1123         return
1124             interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1125     }
1126 
1127     function setMerkleRoot(bytes32 m) public onlyOwner {
1128         merkleRoot = m;
1129     }
1130 
1131 
1132     //Note: This function will revert unless the reserveLimit is changed.
1133     function reserveNFT(uint256 quantity) public onlyOwner {
1134         require(
1135             totalSupply() + quantity <= collectionSize,
1136             "reached max supply"
1137         );
1138         require(reserveNFTs + quantity <= reserveLimit, "Reserve limit exceeded.");
1139         reserveNFTs = reserveNFTs + quantity;
1140         _safeMint(teamWallet, quantity);
1141     }
1142 
1143     function mint(uint256 quantity) public payable {
1144         require(!paused, "mint is paused");
1145         require(!whiteListIsActive, "WL active. Public Minting not started");
1146         require(!privateListIsActive, "PL active. Public Minting not started");
1147         require(
1148             totalSupply() + quantity <= TotalCollectionSize_,
1149             "reached max supply"
1150         );
1151          require(quantity <= MAX_PER_Transaction, "can not mint this many");
1152         require(
1153             (numberMinted(msg.sender) + quantity <= MAX_PER_Address),
1154             "Quantity exceeds allowed Mints"
1155         );
1156         
1157         require(msg.value >= price * quantity, "Need to send more ETH.");
1158         _safeMint(msg.sender, quantity);
1159     }
1160 
1161     function presaleAndWhitelistMint(uint256 quantity, bytes32[] calldata merkleproof)
1162         public
1163         payable
1164     {
1165          require(!paused, "minting is paused");
1166          require(privateListIsActive || whiteListIsActive, "minting is public");
1167          require(
1168             totalSupply() + quantity <= TotalCollectionSize_,
1169             "reached max supply"
1170         );
1171         require(
1172             isValid(merkleproof, keccak256(abi.encodePacked(msg.sender))),
1173             "Not whitelisted"
1174         );
1175         require(
1176             (numberMinted(msg.sender) + quantity <= MAX_PER_Address),
1177             "Quantity exceeds allowed Mints"
1178         );
1179         require(quantity <= MAX_PER_Transaction, "can not mint this many");
1180         require(msg.value >= price * quantity, "Need to send more ETH.");
1181 
1182         if(whiteListIsActive) {
1183             require(
1184             totalSupply() + quantity <= whiteListSpots,
1185             "Whitelist sold out"
1186         );
1187 
1188         } else {
1189              require(
1190             totalSupply() + quantity <= privateListSpots,
1191             "Whitelist sold out"
1192              );
1193         }
1194         
1195         _safeMint(msg.sender, quantity);
1196     }
1197 
1198     function isValid(bytes32[] memory merkleproof, bytes32 leaf)
1199         public
1200         view
1201         returns (bool)
1202     {
1203         return MerkleProof.verify(merkleproof, merkleRoot, leaf);
1204     }
1205 
1206     function tokenURI(uint256 tokenId)
1207         public
1208         view
1209         virtual
1210         override
1211         returns (string memory)
1212     {
1213         require(
1214             _exists(tokenId),
1215             "ERC721Metadata: URI query for nonexistent token"
1216         );
1217         
1218            if (revealed) {
1219             string memory baseURI = _baseURI();
1220             return
1221                 bytes(baseURI).length > 0
1222                     ? string(
1223                         abi.encodePacked(baseURI, tokenId.toString(), ".json")
1224                     )
1225                     : "";
1226         } else {
1227             return notRevealedURI;
1228         }
1229         
1230     }
1231 
1232     
1233     function setBaseURI(string memory baseURI) public onlyOwner {
1234         baseTokenURI = baseURI;
1235     }
1236 
1237     function setNotRevealedURI(string memory URI) public onlyOwner {
1238         notRevealedURI = URI;
1239     }
1240 
1241     function _baseURI() internal view virtual override returns (string memory) {
1242         return baseTokenURI;
1243     }
1244 
1245     function numberMinted(address owner) public view returns (uint256) {
1246         return _numberMinted(owner);
1247     }
1248 
1249     function getOwnershipData(uint256 tokenId)
1250         external
1251         view
1252         returns (TokenOwnership memory)
1253     {
1254         return ownershipOf(tokenId);
1255     }
1256 
1257     function withdraw() public onlyOwner nonReentrant {
1258         // This will payout the owner the contract balance.
1259         // Do not remove this otherwise you will not be able to withdraw the funds.
1260         // =============================================================================
1261         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1262         require(os);
1263         // =============================================================================
1264     }
1265 
1266     
1267 
1268     function setPrice(uint256 _newPrice) public onlyOwner {
1269         price = _newPrice;
1270     }
1271 
1272     function setTeamWallet(address _newTeamWallet) public onlyOwner {
1273         teamWallet = _newTeamWallet;
1274     }
1275 
1276     /**
1277     Note: It may not be a good idea to be able to adjust the reserve limit if you want to be
1278     transparent with users.
1279 
1280     function setReserveLimit(uint256 _newLimit) public onlyOwner {
1281         reserveLimit = _newLimit;
1282     }
1283 
1284     */
1285 
1286 
1287     function setWhitelistLimit(uint256 _newLimit) public onlyOwner {
1288         whiteListSpots = _newLimit;
1289     }
1290 
1291     function setPrivateListLimit(uint256 _newLimit) public onlyOwner {
1292         privateListSpots = _newLimit;
1293     }
1294 
1295 
1296     function setMAX_PER_Transaction(uint256 _newLimit) public onlyOwner {
1297         MAX_PER_Transaction = _newLimit;
1298     }
1299 
1300     function setMAX_PER_Address(uint256 _newLimit) public onlyOwner {
1301         MAX_PER_Address = _newLimit;
1302     }
1303 
1304     function reveal() public onlyOwner {
1305         revealed = !revealed;
1306     }
1307 
1308 
1309     function pause(bool _state) public onlyOwner {
1310         paused = _state;
1311     }
1312 
1313     function setWhitelistActive(bool _state) public onlyOwner {
1314         whiteListIsActive = _state;
1315     }
1316 
1317     function setPrivateListActive(bool _state) public onlyOwner {
1318         privateListIsActive = _state;
1319     }
1320 
1321 
1322     function airdrop(address beneficiary, uint256 amount) public onlyOwner {
1323         require(beneficiary != address(0), "Cannot airdrop to zero address");
1324         _safeMint(beneficiary, amount);
1325     }
1326 }