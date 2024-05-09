1 // SPDX-License-Identifier: MIT
2 
3 // PEPELODEON
4 // Max Supply = 4444
5 // Max per wallet = 5
6 // 1 free, rest 0.005 eth each
7 
8 pragma solidity ^0.8.0;
9 
10 library MerkleProof {
11     function verify(
12         bytes32[] memory proof,
13         bytes32 root,
14         bytes32 leaf
15     ) internal pure returns (bool) {
16         return processProof(proof, leaf) == root;
17     }
18 
19     function processProof(bytes32[] memory proof, bytes32 leaf)
20         internal
21         pure
22         returns (bytes32)
23     {
24         bytes32 computedHash = leaf;
25         for (uint256 i = 0; i < proof.length; i++) {
26             bytes32 proofElement = proof[i];
27             if (computedHash <= proofElement) {
28                 computedHash = _efficientHash(computedHash, proofElement);
29             } else {
30                 computedHash = _efficientHash(proofElement, computedHash);
31             }
32         }
33         return computedHash;
34     }
35 
36     function _efficientHash(bytes32 a, bytes32 b)
37         private
38         pure
39         returns (bytes32 value)
40     {
41         assembly {
42             mstore(0x00, a)
43             mstore(0x20, b)
44             value := keccak256(0x00, 0x40)
45         }
46     }
47 }
48 
49 abstract contract ReentrancyGuard {
50     uint256 private constant _NOT_ENTERED = 1;
51     uint256 private constant _ENTERED = 2;
52 
53     uint256 private _status;
54 
55     constructor() {
56         _status = _NOT_ENTERED;
57     }
58 
59     modifier nonReentrant() {
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61         _status = _ENTERED;
62 
63         _;
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 /**
69  * @dev Wrappers over Solidity's arithmetic operations.
70  *
71  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
72  * now has built in overflow checking.
73  */
74 library SafeMath {
75     /**
76      * @dev Returns the addition of two unsigned integers, with an overflow flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryAdd(uint256 a, uint256 b)
81         internal
82         pure
83         returns (bool, uint256)
84     {
85         unchecked {
86             uint256 c = a + b;
87             if (c < a) return (false, 0);
88             return (true, c);
89         }
90     }
91 
92     /**
93      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
94      *
95      * _Available since v3.4._
96      */
97     function trySub(uint256 a, uint256 b)
98         internal
99         pure
100         returns (bool, uint256)
101     {
102         unchecked {
103             if (b > a) return (false, 0);
104             return (true, a - b);
105         }
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function tryMul(uint256 a, uint256 b)
114         internal
115         pure
116         returns (bool, uint256)
117     {
118         unchecked {
119             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120             // benefit is lost if 'b' is also tested.
121             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122             if (a == 0) return (true, 0);
123             uint256 c = a * b;
124             if (c / a != b) return (false, 0);
125             return (true, c);
126         }
127     }
128 
129     /**
130      * @dev Returns the division of two unsigned integers, with a division by zero flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryDiv(uint256 a, uint256 b)
135         internal
136         pure
137         returns (bool, uint256)
138     {
139         unchecked {
140             if (b == 0) return (false, 0);
141             return (true, a / b);
142         }
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMod(uint256 a, uint256 b)
151         internal
152         pure
153         returns (bool, uint256)
154     {
155         unchecked {
156             if (b == 0) return (false, 0);
157             return (true, a % b);
158         }
159     }
160 
161     /**
162      * @dev Returns the addition of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `+` operator.
166      *
167      * Requirements:
168      *
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a + b;
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         return a * b;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers, reverting on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator.
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a / b;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * reverting when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a % b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
235      * overflow (when the result is negative).
236      *
237      * CAUTION: This function is deprecated because it requires allocating memory for the error
238      * message unnecessarily. For custom revert reasons use {trySub}.
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      *
244      * - Subtraction cannot overflow.
245      */
246     function sub(
247         uint256 a,
248         uint256 b,
249         string memory errorMessage
250     ) internal pure returns (uint256) {
251         unchecked {
252             require(b <= a, errorMessage);
253             return a - b;
254         }
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259      * division by zero. The result is rounded towards zero.
260      *
261      * Counterpart to Solidity's `/` operator. Note: this function uses a
262      * `revert` opcode (which leaves remaining gas untouched) while Solidity
263      * uses an invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function div(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a / b;
277         }
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b > 0, errorMessage);
302             return a % b;
303         }
304     }
305 }
306 
307 library Strings {
308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
309 
310     function toString(uint256 value) internal pure returns (string memory) {
311         if (value == 0) {
312             return "0";
313         }
314         uint256 temp = value;
315         uint256 digits;
316         while (temp != 0) {
317             digits++;
318             temp /= 10;
319         }
320         bytes memory buffer = new bytes(digits);
321         while (value != 0) {
322             digits -= 1;
323             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
324             value /= 10;
325         }
326         return string(buffer);
327     }
328 
329     function toHexString(uint256 value) internal pure returns (string memory) {
330         if (value == 0) {
331             return "0x00";
332         }
333         uint256 temp = value;
334         uint256 length = 0;
335         while (temp != 0) {
336             length++;
337             temp >>= 8;
338         }
339         return toHexString(value, length);
340     }
341 
342     function toHexString(uint256 value, uint256 length)
343         internal
344         pure
345         returns (string memory)
346     {
347         bytes memory buffer = new bytes(2 * length + 2);
348         buffer[0] = "0";
349         buffer[1] = "x";
350         for (uint256 i = 2 * length + 1; i > 1; --i) {
351             buffer[i] = _HEX_SYMBOLS[value & 0xf];
352             value >>= 4;
353         }
354         require(value == 0, "Strings: hex length insufficient");
355         return string(buffer);
356     }
357 }
358 
359 abstract contract Context {
360     function _msgSender() internal view virtual returns (address) {
361         return msg.sender;
362     }
363 
364     function _msgData() internal view virtual returns (bytes calldata) {
365         return msg.data;
366     }
367 }
368 
369 abstract contract Ownable is Context {
370     address private _owner;
371 
372     event OwnershipTransferred(
373         address indexed previousOwner,
374         address indexed newOwner
375     );
376 
377     constructor() {
378         _transferOwnership(_msgSender());
379     }
380 
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     function renounceOwnership() public virtual onlyOwner {
391         _transferOwnership(address(0));
392     }
393 
394     function transferOwnership(address newOwner) public virtual onlyOwner {
395         require(
396             newOwner != address(0),
397             "Ownable: new owner is the zero address"
398         );
399         _transferOwnership(newOwner);
400     }
401 
402     function _transferOwnership(address newOwner) internal virtual {
403         address oldOwner = _owner;
404         _owner = newOwner;
405         emit OwnershipTransferred(oldOwner, newOwner);
406     }
407 }
408 
409 library Address {
410     function isContract(address account) internal view returns (bool) {
411         uint256 size;
412         assembly {
413             size := extcodesize(account)
414         }
415         return size > 0;
416     }
417 
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(
420             address(this).balance >= amount,
421             "Address: insufficient balance"
422         );
423 
424         (bool success, ) = recipient.call{value: amount}("");
425         require(
426             success,
427             "Address: unable to send value, recipient may have reverted"
428         );
429     }
430 
431     function functionCall(address target, bytes memory data)
432         internal
433         returns (bytes memory)
434     {
435         return functionCall(target, data, "Address: low-level call failed");
436     }
437 
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     function functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 value
450     ) internal returns (bytes memory) {
451         return
452             functionCallWithValue(
453                 target,
454                 data,
455                 value,
456                 "Address: low-level call with value failed"
457             );
458     }
459 
460     function functionCallWithValue(
461         address target,
462         bytes memory data,
463         uint256 value,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(
467             address(this).balance >= value,
468             "Address: insufficient balance for call"
469         );
470         require(isContract(target), "Address: call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.call{value: value}(
473             data
474         );
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     function functionStaticCall(address target, bytes memory data)
479         internal
480         view
481         returns (bytes memory)
482     {
483         return
484             functionStaticCall(
485                 target,
486                 data,
487                 "Address: low-level static call failed"
488             );
489     }
490 
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     function functionDelegateCall(address target, bytes memory data)
503         internal
504         returns (bytes memory)
505     {
506         return
507             functionDelegateCall(
508                 target,
509                 data,
510                 "Address: low-level delegate call failed"
511             );
512     }
513 
514     function functionDelegateCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(isContract(target), "Address: delegate call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.delegatecall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             if (returndata.length > 0) {
534                 assembly {
535                     let returndata_size := mload(returndata)
536                     revert(add(32, returndata), returndata_size)
537                 }
538             } else {
539                 revert(errorMessage);
540             }
541         }
542     }
543 }
544 
545 interface IERC721Receiver {
546     function onERC721Received(
547         address operator,
548         address from,
549         uint256 tokenId,
550         bytes calldata data
551     ) external returns (bytes4);
552 }
553 
554 interface IERC165 {
555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
556 }
557 
558 abstract contract ERC165 is IERC165 {
559     function supportsInterface(bytes4 interfaceId)
560         public
561         view
562         virtual
563         override
564         returns (bool)
565     {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 interface IERC721 is IERC165 {
571     event Transfer(
572         address indexed from,
573         address indexed to,
574         uint256 indexed tokenId
575     );
576     event Approval(
577         address indexed owner,
578         address indexed approved,
579         uint256 indexed tokenId
580     );
581     event ApprovalForAll(
582         address indexed owner,
583         address indexed operator,
584         bool approved
585     );
586 
587     function balanceOf(address owner) external view returns (uint256 balance);
588 
589     function ownerOf(uint256 tokenId) external view returns (address owner);
590 
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     function transferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     function approve(address to, uint256 tokenId) external;
604 
605     function getApproved(uint256 tokenId)
606         external
607         view
608         returns (address operator);
609 
610     function setApprovalForAll(address operator, bool _approved) external;
611 
612     function isApprovedForAll(address owner, address operator)
613         external
614         view
615         returns (bool);
616 
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId,
621         bytes calldata data
622     ) external;
623 }
624 
625 interface IERC721Enumerable is IERC721 {
626     function totalSupply() external view returns (uint256);
627 
628     function tokenOfOwnerByIndex(address owner, uint256 index)
629         external
630         view
631         returns (uint256 tokenId);
632 
633     function tokenByIndex(uint256 index) external view returns (uint256);
634 }
635 
636 interface IERC721Metadata is IERC721 {
637     function name() external view returns (string memory);
638 
639     function symbol() external view returns (string memory);
640 
641     function tokenURI(uint256 tokenId) external view returns (string memory);
642 }
643 
644 contract ERC721A is
645     Context,
646     ERC165,
647     IERC721,
648     IERC721Metadata,
649     IERC721Enumerable
650 {
651     using Address for address;
652     using Strings for uint256;
653 
654     struct TokenOwnership {
655         address addr;
656         uint64 startTimestamp;
657     }
658 
659     struct AddressData {
660         uint128 balance;
661         uint128 numberMinted;
662     }
663 
664     uint256 private currentIndex = 1;
665 
666     uint256 internal immutable collectionSize;
667     uint256 internal immutable maxBatchSize;
668     string private _name;
669     string private _symbol;
670     mapping(uint256 => TokenOwnership) private _ownerships;
671     mapping(address => AddressData) private _addressData;
672     mapping(uint256 => address) private _tokenApprovals;
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     constructor(
676         string memory name_,
677         string memory symbol_,
678         uint256 maxBatchSize_,
679         uint256 collectionSize_
680     ) {
681         require(
682             collectionSize_ > 0,
683             "ERC721A: collection must have a nonzero supply"
684         );
685         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
686         _name = name_;
687         _symbol = symbol_;
688         maxBatchSize = maxBatchSize_;
689         collectionSize = collectionSize_;
690     }
691 
692     function totalSupply() public view override returns (uint256) {
693         return currentIndex - 1;
694     }
695 
696     function tokenByIndex(uint256 index)
697         public
698         view
699         override
700         returns (uint256)
701     {
702         require(index < totalSupply(), "ERC721A: global index out of bounds");
703         return index;
704     }
705 
706     function tokenOfOwnerByIndex(address owner, uint256 index)
707         public
708         view
709         override
710         returns (uint256)
711     {
712         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
713         uint256 numMintedSoFar = totalSupply();
714         uint256 tokenIdsIdx = 0;
715         address currOwnershipAddr = address(0);
716         for (uint256 i = 0; i < numMintedSoFar; i++) {
717             TokenOwnership memory ownership = _ownerships[i];
718             if (ownership.addr != address(0)) {
719                 currOwnershipAddr = ownership.addr;
720             }
721             if (currOwnershipAddr == owner) {
722                 if (tokenIdsIdx == index) {
723                     return i;
724                 }
725                 tokenIdsIdx++;
726             }
727         }
728         revert("ERC721A: unable to get token of owner by index");
729     }
730 
731     function supportsInterface(bytes4 interfaceId)
732         public
733         view
734         virtual
735         override(ERC165, IERC165)
736         returns (bool)
737     {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             interfaceId == type(IERC721Enumerable).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     function balanceOf(address owner) public view override returns (uint256) {
746         require(
747             owner != address(0),
748             "ERC721A: balance query for the zero address"
749         );
750         return uint256(_addressData[owner].balance);
751     }
752 
753     function _numberMinted(address owner) internal view returns (uint256) {
754         require(
755             owner != address(0),
756             "ERC721A: number minted query for the zero address"
757         );
758         return uint256(_addressData[owner].numberMinted);
759     }
760 
761     function ownershipOf(uint256 tokenId)
762         internal
763         view
764         returns (TokenOwnership memory)
765     {
766         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
767 
768         uint256 lowestTokenToCheck;
769         if (tokenId >= maxBatchSize) {
770             lowestTokenToCheck = tokenId - maxBatchSize + 1;
771         }
772 
773         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
774             TokenOwnership memory ownership = _ownerships[curr];
775             if (ownership.addr != address(0)) {
776                 return ownership;
777             }
778         }
779 
780         revert("ERC721A: unable to determine the owner of token");
781     }
782 
783     function ownerOf(uint256 tokenId) public view override returns (address) {
784         return ownershipOf(tokenId).addr;
785     }
786 
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     function tokenURI(uint256 tokenId)
796         public
797         view
798         virtual
799         override
800         returns (string memory)
801     {
802         require(
803             _exists(tokenId),
804             "ERC721Metadata: URI query for nonexistent token"
805         );
806 
807         string memory baseURI = _baseURI();
808         return
809             bytes(baseURI).length > 0
810                 ? string(
811                     abi.encodePacked(
812                         baseURI,
813                         tokenId.toString(),
814                         _getUriExtension()
815                     )
816                 )
817                 : "";
818     }
819 
820     function _baseURI() internal view virtual returns (string memory) {
821         return "";
822     }
823 
824     function _getUriExtension() internal view virtual returns (string memory) {
825         return "";
826     }
827 
828     function approve(address to, uint256 tokenId) public override {
829         address owner = ERC721A.ownerOf(tokenId);
830         require(to != owner, "ERC721A: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721A: approve caller is not owner nor approved for all"
835         );
836 
837         _approve(to, tokenId, owner);
838     }
839 
840     function getApproved(uint256 tokenId)
841         public
842         view
843         override
844         returns (address)
845     {
846         require(
847             _exists(tokenId),
848             "ERC721A: approved query for nonexistent token"
849         );
850 
851         return _tokenApprovals[tokenId];
852     }
853 
854     function setApprovalForAll(address operator, bool approved)
855         public
856         override
857     {
858         require(operator != _msgSender(), "ERC721A: approve to caller");
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     function isApprovedForAll(address owner, address operator)
865         public
866         view
867         virtual
868         override
869         returns (bool)
870     {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public override {
879         _transfer(from, to, tokenId);
880     }
881 
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public override {
887         safeTransferFrom(from, to, tokenId, "");
888     }
889 
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) public override {
896         _transfer(from, to, tokenId);
897         require(
898             _checkOnERC721Received(from, to, tokenId, _data),
899             "ERC721A: transfer to non ERC721Receiver implementer"
900         );
901     }
902 
903     function _exists(uint256 tokenId) internal view returns (bool) {
904         return tokenId < currentIndex;
905     }
906 
907     function _safeMint(address to, uint256 quantity) internal {
908         _safeMint(to, quantity, "");
909     }
910 
911     function _safeMint(
912         address to,
913         uint256 quantity,
914         bytes memory _data
915     ) internal {
916         uint256 startTokenId = currentIndex;
917         require(to != address(0), "ERC721A: mint to the zero address");
918         require(!_exists(startTokenId), "ERC721A: token already minted");
919         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
920 
921         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
922 
923         AddressData memory addressData = _addressData[to];
924         _addressData[to] = AddressData(
925             addressData.balance + uint128(quantity),
926             addressData.numberMinted + uint128(quantity)
927         );
928         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
929 
930         uint256 updatedIndex = startTokenId;
931 
932         for (uint256 i = 0; i < quantity; i++) {
933             emit Transfer(address(0), to, updatedIndex);
934             require(
935                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
936                 "ERC721A: transfer to non ERC721Receiver implementer"
937             );
938             updatedIndex++;
939         }
940 
941         currentIndex = updatedIndex;
942         _afterTokenTransfers(address(0), to, startTokenId, quantity);
943     }
944 
945     function _transfer(
946         address from,
947         address to,
948         uint256 tokenId
949     ) private {
950         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
951 
952         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
953             getApproved(tokenId) == _msgSender() ||
954             isApprovedForAll(prevOwnership.addr, _msgSender()));
955 
956         require(
957             isApprovedOrOwner,
958             "ERC721A: transfer caller is not owner nor approved"
959         );
960 
961         require(
962             prevOwnership.addr == from,
963             "ERC721A: transfer from incorrect owner"
964         );
965         require(to != address(0), "ERC721A: transfer to the zero address");
966 
967         _beforeTokenTransfers(from, to, tokenId, 1);
968         _approve(address(0), tokenId, prevOwnership.addr);
969 
970         _addressData[from].balance -= 1;
971         _addressData[to].balance += 1;
972         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
973         uint256 nextTokenId = tokenId + 1;
974         if (_ownerships[nextTokenId].addr == address(0)) {
975             if (_exists(nextTokenId)) {
976                 _ownerships[nextTokenId] = TokenOwnership(
977                     prevOwnership.addr,
978                     prevOwnership.startTimestamp
979                 );
980             }
981         }
982 
983         emit Transfer(from, to, tokenId);
984         _afterTokenTransfers(from, to, tokenId, 1);
985     }
986 
987     function _approve(
988         address to,
989         uint256 tokenId,
990         address owner
991     ) private {
992         _tokenApprovals[tokenId] = to;
993         emit Approval(owner, to, tokenId);
994     }
995 
996     uint256 public nextOwnerToExplicitlySet = 0;
997 
998     function _setOwnersExplicit(uint256 quantity) internal {
999         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1000         require(quantity > 0, "quantity must be nonzero");
1001         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1002         if (endIndex > collectionSize - 1) {
1003             endIndex = collectionSize - 1;
1004         }
1005         require(_exists(endIndex), "not enough minted yet for this cleanup");
1006         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1007             if (_ownerships[i].addr == address(0)) {
1008                 TokenOwnership memory ownership = ownershipOf(i);
1009                 _ownerships[i] = TokenOwnership(
1010                     ownership.addr,
1011                     ownership.startTimestamp
1012                 );
1013             }
1014         }
1015         nextOwnerToExplicitlySet = endIndex + 1;
1016     }
1017 
1018     function _checkOnERC721Received(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) private returns (bool) {
1024         if (to.isContract()) {
1025             try
1026                 IERC721Receiver(to).onERC721Received(
1027                     _msgSender(),
1028                     from,
1029                     tokenId,
1030                     _data
1031                 )
1032             returns (bytes4 retval) {
1033                 return retval == IERC721Receiver(to).onERC721Received.selector;
1034             } catch (bytes memory reason) {
1035                 if (reason.length == 0) {
1036                     revert(
1037                         "ERC721A: transfer to non ERC721Receiver implementer"
1038                     );
1039                 } else {
1040                     assembly {
1041                         revert(add(32, reason), mload(reason))
1042                     }
1043                 }
1044             }
1045         } else {
1046             return true;
1047         }
1048     }
1049 
1050     function _beforeTokenTransfers(
1051         address from,
1052         address to,
1053         uint256 startTokenId,
1054         uint256 quantity
1055     ) internal virtual {}
1056 
1057     function _afterTokenTransfers(
1058         address from,
1059         address to,
1060         uint256 startTokenId,
1061         uint256 quantity
1062     ) internal virtual {}
1063 }
1064 
1065 contract Pepelodeon is Ownable, ERC721A, ReentrancyGuard {
1066     using Strings for uint256;
1067     using SafeMath for uint256;
1068 
1069     string public uriSuffix = ".json";
1070 
1071     uint256 public MAX_PER_Transaction = 5; // maximum amount that user can mint per transaction
1072     uint256 public MAX_PER_Wallet = 5;
1073     
1074 
1075     //prices
1076    
1077     uint256 public price = 0.005 ether; 
1078 
1079     
1080 
1081     uint256 private constant TotalCollectionSize_ = 4444; // total number of nfts
1082     uint256 private constant MaxMintPerBatch_ = 200; //max mint per traction
1083 
1084 
1085     bool public paused = true;
1086     bool public presaleIsActive = false;
1087 
1088     string private baseTokenURI="ipfs://QmToDGTjhPKFoZknRHpAKWbcCSM71Jvy8E8G3CxVD7AwNh/";
1089     
1090 
1091     bytes32 public merkleRoot;
1092 
1093     constructor()
1094         ERC721A(
1095             "Pepelodeon",
1096             "PLDN",
1097              MaxMintPerBatch_,
1098             TotalCollectionSize_
1099         )
1100     {
1101        
1102         
1103     }
1104 
1105     function supportsInterface(bytes4 interfaceId)
1106         public
1107         view
1108         override(ERC721A)
1109         returns (bool)
1110     {
1111         return
1112             interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1113     }
1114 
1115     function setMerkleRoot(bytes32 m) public onlyOwner {
1116         merkleRoot = m;
1117     }
1118 
1119     function getMerkleRoot() public view returns (bytes32) {
1120         return merkleRoot;
1121     }
1122 
1123  
1124 
1125     function mint(uint256 quantity) public payable {
1126         require(!paused, "mint is paused");
1127         require(
1128             totalSupply() + quantity <= TotalCollectionSize_,
1129             "reached max supply"
1130         );
1131         require(numberMinted(msg.sender) + quantity <= MAX_PER_Wallet, "limit per wallet exceeded");
1132         require(quantity <= MAX_PER_Transaction, "can not mint this many");
1133 
1134         if(msg.value==0 && quantity==1)
1135         {
1136         require(balanceOf(msg.sender)<1,"Already minted free!");
1137             _safeMint(msg.sender, quantity);
1138         }
1139         else if(balanceOf(msg.sender)>=1)
1140         {
1141         require(msg.value >=_shouldPay(quantity),"Insufficient funds!");
1142             _safeMint(msg.sender, quantity);
1143         }
1144         else
1145         {
1146         require(msg.value >=_shouldPay(quantity-1), "Insufficient funds!");
1147             _safeMint(msg.sender, quantity);
1148         }
1149     
1150     }
1151 
1152     function _shouldPay(uint256 _quantity) 
1153         private 
1154         view
1155         returns(uint256)
1156     {
1157         uint256  shouldPay=price*_quantity;
1158         return shouldPay;
1159     }
1160 
1161     function isValid(bytes32[] memory merkleproof, bytes32 leaf)
1162         public
1163         view
1164         returns (bool)
1165     {
1166         return MerkleProof.verify(merkleproof, merkleRoot, leaf);
1167     }
1168 
1169     function tokenURI(uint256 tokenId)
1170         public
1171         view
1172         virtual
1173         override
1174         returns (string memory)
1175     {
1176         require(
1177             _exists(tokenId),
1178             "ERC721Metadata: URI query for nonexistent token"
1179         );
1180        
1181             string memory baseURI = _baseURI();
1182             return
1183                 bytes(baseURI).length > 0
1184                     ? string(
1185                         abi.encodePacked(baseURI, tokenId.toString(),uriSuffix)
1186                     )
1187                     : "";
1188        
1189         
1190     }
1191 
1192 
1193 
1194     function setBaseURI(string memory baseURI) public onlyOwner {
1195         baseTokenURI = baseURI;
1196     }
1197 
1198     function _baseURI() internal view virtual override returns (string memory) {
1199         return baseTokenURI;
1200     }
1201 
1202     function numberMinted(address owner) public view returns (uint256) {
1203         return _numberMinted(owner);
1204     }
1205 
1206     function getOwnershipData(uint256 tokenId)
1207         external
1208         view
1209         returns (TokenOwnership memory)
1210     {
1211         return ownershipOf(tokenId);
1212     }
1213 
1214     function withdraw() public onlyOwner nonReentrant {
1215         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1216         require(os);
1217     }
1218 
1219 
1220    
1221 
1222     function setMAX_PER_Transaction(uint256 q) public onlyOwner {
1223         MAX_PER_Transaction = q;
1224     }
1225   
1226 
1227     function setMaxPerWallet(uint256 _newLimit) public onlyOwner {
1228         MAX_PER_Wallet = _newLimit;
1229     }
1230 
1231    
1232 
1233     function pause(bool _state) public onlyOwner {
1234         paused = _state;
1235     }
1236 
1237 
1238     
1239 }