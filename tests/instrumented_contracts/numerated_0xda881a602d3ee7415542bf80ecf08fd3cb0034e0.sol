1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 
9 abstract contract ReentrancyGuard {
10     uint256 private constant _NOT_ENTERED = 1;
11     uint256 private constant _ENTERED = 2;
12 
13     uint256 private _status;
14 
15     constructor() {
16         _status = _NOT_ENTERED;
17     }
18 
19     modifier nonReentrant() {
20         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
21         _status = _ENTERED;
22 
23         _;
24         _status = _NOT_ENTERED;
25     }
26 }
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations.
30  *
31  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
32  * now has built in overflow checking.
33  */
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, with an overflow flag.
37      *
38      * _Available since v3.4._
39      */
40     function tryAdd(uint256 a, uint256 b)
41         internal
42         pure
43         returns (bool, uint256)
44     {
45         unchecked {
46             uint256 c = a + b;
47             if (c < a) return (false, 0);
48             return (true, c);
49         }
50     }
51 
52     /**
53      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
54      *
55      * _Available since v3.4._
56      */
57     function trySub(uint256 a, uint256 b)
58         internal
59         pure
60         returns (bool, uint256)
61     {
62         unchecked {
63             if (b > a) return (false, 0);
64             return (true, a - b);
65         }
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMul(uint256 a, uint256 b)
74         internal
75         pure
76         returns (bool, uint256)
77     {
78         unchecked {
79             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80             // benefit is lost if 'b' is also tested.
81             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82             if (a == 0) return (true, 0);
83             uint256 c = a * b;
84             if (c / a != b) return (false, 0);
85             return (true, c);
86         }
87     }
88 
89     /**
90      * @dev Returns the division of two unsigned integers, with a division by zero flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryDiv(uint256 a, uint256 b)
95         internal
96         pure
97         returns (bool, uint256)
98     {
99         unchecked {
100             if (b == 0) return (false, 0);
101             return (true, a / b);
102         }
103     }
104 
105     /**
106      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryMod(uint256 a, uint256 b)
111         internal
112         pure
113         returns (bool, uint256)
114     {
115         unchecked {
116             if (b == 0) return (false, 0);
117             return (true, a % b);
118         }
119     }
120 
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a + b;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a - b;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a * b;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers, reverting on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator.
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a / b;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * reverting when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a % b;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * CAUTION: This function is deprecated because it requires allocating memory for the error
198      * message unnecessarily. For custom revert reasons use {trySub}.
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(
207         uint256 a,
208         uint256 b,
209         string memory errorMessage
210     ) internal pure returns (uint256) {
211         unchecked {
212             require(b <= a, errorMessage);
213             return a - b;
214         }
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a / b;
237         }
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * reverting with custom message when dividing by zero.
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {tryMod}.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b > 0, errorMessage);
262             return a % b;
263         }
264     }
265 }
266 
267 library Strings {
268     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
269 
270     function toString(uint256 value) internal pure returns (string memory) {
271         if (value == 0) {
272             return "0";
273         }
274         uint256 temp = value;
275         uint256 digits;
276         while (temp != 0) {
277             digits++;
278             temp /= 10;
279         }
280         bytes memory buffer = new bytes(digits);
281         while (value != 0) {
282             digits -= 1;
283             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
284             value /= 10;
285         }
286         return string(buffer);
287     }
288 
289     function toHexString(uint256 value) internal pure returns (string memory) {
290         if (value == 0) {
291             return "0x00";
292         }
293         uint256 temp = value;
294         uint256 length = 0;
295         while (temp != 0) {
296             length++;
297             temp >>= 8;
298         }
299         return toHexString(value, length);
300     }
301 
302     function toHexString(uint256 value, uint256 length)
303         internal
304         pure
305         returns (string memory)
306     {
307         bytes memory buffer = new bytes(2 * length + 2);
308         buffer[0] = "0";
309         buffer[1] = "x";
310         for (uint256 i = 2 * length + 1; i > 1; --i) {
311             buffer[i] = _HEX_SYMBOLS[value & 0xf];
312             value >>= 4;
313         }
314         require(value == 0, "Strings: hex length insufficient");
315         return string(buffer);
316     }
317 }
318 
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         return msg.data;
326     }
327 }
328 
329 abstract contract Ownable is Context {
330     address private _owner;
331 
332     event OwnershipTransferred(
333         address indexed previousOwner,
334         address indexed newOwner
335     );
336 
337     constructor() {
338         _transferOwnership(_msgSender());
339     }
340 
341     function owner() public view virtual returns (address) {
342         return _owner;
343     }
344 
345     modifier onlyOwner() {
346         require(owner() == _msgSender(), "Ownable: caller is not the owner");
347         _;
348     }
349 
350     function renounceOwnership() public virtual onlyOwner {
351         _transferOwnership(address(0));
352     }
353 
354     function transferOwnership(address newOwner) public virtual onlyOwner {
355         require(
356             newOwner != address(0),
357             "Ownable: new owner is the zero address"
358         );
359         _transferOwnership(newOwner);
360     }
361 
362     function _transferOwnership(address newOwner) internal virtual {
363         address oldOwner = _owner;
364         _owner = newOwner;
365         emit OwnershipTransferred(oldOwner, newOwner);
366     }
367 }
368 
369 library Address {
370     function isContract(address account) internal view returns (bool) {
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     function sendValue(address payable recipient, uint256 amount) internal {
379         require(
380             address(this).balance >= amount,
381             "Address: insufficient balance"
382         );
383 
384         (bool success, ) = recipient.call{value: amount}("");
385         require(
386             success,
387             "Address: unable to send value, recipient may have reverted"
388         );
389     }
390 
391     function functionCall(address target, bytes memory data)
392         internal
393         returns (bytes memory)
394     {
395         return functionCall(target, data, "Address: low-level call failed");
396     }
397 
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value
410     ) internal returns (bytes memory) {
411         return
412             functionCallWithValue(
413                 target,
414                 data,
415                 value,
416                 "Address: low-level call with value failed"
417             );
418     }
419 
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(
427             address(this).balance >= value,
428             "Address: insufficient balance for call"
429         );
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(
433             data
434         );
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     function functionStaticCall(address target, bytes memory data)
439         internal
440         view
441         returns (bytes memory)
442     {
443         return
444             functionStaticCall(
445                 target,
446                 data,
447                 "Address: low-level static call failed"
448             );
449     }
450 
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     function functionDelegateCall(address target, bytes memory data)
463         internal
464         returns (bytes memory)
465     {
466         return
467             functionDelegateCall(
468                 target,
469                 data,
470                 "Address: low-level delegate call failed"
471             );
472     }
473 
474     function functionDelegateCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             if (returndata.length > 0) {
494                 assembly {
495                     let returndata_size := mload(returndata)
496                     revert(add(32, returndata), returndata_size)
497                 }
498             } else {
499                 revert(errorMessage);
500             }
501         }
502     }
503 }
504 
505 interface IERC721Receiver {
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 interface IERC165 {
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 }
517 
518 abstract contract ERC165 is IERC165 {
519     function supportsInterface(bytes4 interfaceId)
520         public
521         view
522         virtual
523         override
524         returns (bool)
525     {
526         return interfaceId == type(IERC165).interfaceId;
527     }
528 }
529 
530 interface IERC721 is IERC165 {
531     event Transfer(
532         address indexed from,
533         address indexed to,
534         uint256 indexed tokenId
535     );
536     event Approval(
537         address indexed owner,
538         address indexed approved,
539         uint256 indexed tokenId
540     );
541     event ApprovalForAll(
542         address indexed owner,
543         address indexed operator,
544         bool approved
545     );
546 
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     function safeTransferFrom(
552         address from,
553         address to,
554         uint256 tokenId
555     ) external;
556 
557     function transferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     function approve(address to, uint256 tokenId) external;
564 
565     function getApproved(uint256 tokenId)
566         external
567         view
568         returns (address operator);
569 
570     function setApprovalForAll(address operator, bool _approved) external;
571 
572     function isApprovedForAll(address owner, address operator)
573         external
574         view
575         returns (bool);
576 
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes calldata data
582     ) external;
583 }
584 
585 interface IERC721Enumerable is IERC721 {
586     function totalSupply() external view returns (uint256);
587 
588     function tokenOfOwnerByIndex(address owner, uint256 index)
589         external
590         view
591         returns (uint256 tokenId);
592 
593     function tokenByIndex(uint256 index) external view returns (uint256);
594 }
595 
596 interface IERC721Metadata is IERC721 {
597     function name() external view returns (string memory);
598 
599     function symbol() external view returns (string memory);
600 
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 
604 contract ERC721A is
605     Context,
606     ERC165,
607     IERC721,
608     IERC721Metadata,
609     IERC721Enumerable
610 {
611     using Address for address;
612     using Strings for uint256;
613 
614     struct TokenOwnership {
615         address addr;
616         uint64 startTimestamp;
617     }
618 
619     struct AddressData {
620         uint128 balance;
621         uint128 numberMinted;
622     }
623 
624     uint256 private currentIndex = 1;
625 
626     uint256 internal immutable collectionSize;
627     uint256 internal immutable maxBatchSize;
628     string private _name;
629     string private _symbol;
630     mapping(uint256 => TokenOwnership) private _ownerships;
631     mapping(address => AddressData) private _addressData;
632     mapping(uint256 => address) private _tokenApprovals;
633     mapping(address => mapping(address => bool)) private _operatorApprovals;
634 
635     constructor(
636         string memory name_,
637         string memory symbol_,
638         uint256 maxBatchSize_,
639         uint256 collectionSize_
640     ) {
641         require(
642             collectionSize_ > 0,
643             "ERC721A: collection must have a nonzero supply"
644         );
645         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
646         _name = name_;
647         _symbol = symbol_;
648         maxBatchSize = maxBatchSize_;
649         collectionSize = collectionSize_;
650     }
651 
652     function totalSupply() public view override returns (uint256) {
653         return currentIndex - 1;
654     }
655 
656     function tokenByIndex(uint256 index)
657         public
658         view
659         override
660         returns (uint256)
661     {
662         require(index < totalSupply(), "ERC721A: global index out of bounds");
663         return index;
664     }
665 
666     function tokenOfOwnerByIndex(address owner, uint256 index)
667         public
668         view
669         override
670         returns (uint256)
671     {
672         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
673         uint256 numMintedSoFar = totalSupply();
674         uint256 tokenIdsIdx = 0;
675         address currOwnershipAddr = address(0);
676         for (uint256 i = 0; i < numMintedSoFar; i++) {
677             TokenOwnership memory ownership = _ownerships[i];
678             if (ownership.addr != address(0)) {
679                 currOwnershipAddr = ownership.addr;
680             }
681             if (currOwnershipAddr == owner) {
682                 if (tokenIdsIdx == index) {
683                     return i;
684                 }
685                 tokenIdsIdx++;
686             }
687         }
688         revert("ERC721A: unable to get token of owner by index");
689     }
690 
691     function supportsInterface(bytes4 interfaceId)
692         public
693         view
694         virtual
695         override(ERC165, IERC165)
696         returns (bool)
697     {
698         return
699             interfaceId == type(IERC721).interfaceId ||
700             interfaceId == type(IERC721Metadata).interfaceId ||
701             interfaceId == type(IERC721Enumerable).interfaceId ||
702             super.supportsInterface(interfaceId);
703     }
704 
705     function balanceOf(address owner) public view override returns (uint256) {
706         require(
707             owner != address(0),
708             "ERC721A: balance query for the zero address"
709         );
710         return uint256(_addressData[owner].balance);
711     }
712 
713     function _numberMinted(address owner) internal view returns (uint256) {
714         require(
715             owner != address(0),
716             "ERC721A: number minted query for the zero address"
717         );
718         return uint256(_addressData[owner].numberMinted);
719     }
720 
721     function ownershipOf(uint256 tokenId)
722         internal
723         view
724         returns (TokenOwnership memory)
725     {
726         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
727 
728         uint256 lowestTokenToCheck;
729         if (tokenId >= maxBatchSize) {
730             lowestTokenToCheck = tokenId - maxBatchSize + 1;
731         }
732 
733         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
734             TokenOwnership memory ownership = _ownerships[curr];
735             if (ownership.addr != address(0)) {
736                 return ownership;
737             }
738         }
739 
740         revert("ERC721A: unable to determine the owner of token");
741     }
742 
743     function ownerOf(uint256 tokenId) public view override returns (address) {
744         return ownershipOf(tokenId).addr;
745     }
746 
747     function name() public view virtual override returns (string memory) {
748         return _name;
749     }
750 
751     function symbol() public view virtual override returns (string memory) {
752         return _symbol;
753     }
754 
755     function tokenURI(uint256 tokenId)
756         public
757         view
758         virtual
759         override
760         returns (string memory)
761     {
762         require(
763             _exists(tokenId),
764             "ERC721Metadata: URI query for nonexistent token"
765         );
766 
767         string memory baseURI = _baseURI();
768         return
769             bytes(baseURI).length > 0
770                 ? string(
771                     abi.encodePacked(
772                         baseURI,
773                         tokenId.toString(),
774                         _getUriExtension()
775                     )
776                 )
777                 : "";
778     }
779 
780     function _baseURI() internal view virtual returns (string memory) {
781         return "";
782     }
783 
784     function _getUriExtension() internal view virtual returns (string memory) {
785         return "";
786     }
787 
788     function approve(address to, uint256 tokenId) public override {
789         address owner = ERC721A.ownerOf(tokenId);
790         require(to != owner, "ERC721A: approval to current owner");
791 
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721A: approve caller is not owner nor approved for all"
795         );
796 
797         _approve(to, tokenId, owner);
798     }
799 
800     function getApproved(uint256 tokenId)
801         public
802         view
803         override
804         returns (address)
805     {
806         require(
807             _exists(tokenId),
808             "ERC721A: approved query for nonexistent token"
809         );
810 
811         return _tokenApprovals[tokenId];
812     }
813 
814     function setApprovalForAll(address operator, bool approved)
815         public
816         override
817     {
818         require(operator != _msgSender(), "ERC721A: approve to caller");
819 
820         _operatorApprovals[_msgSender()][operator] = approved;
821         emit ApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     function isApprovedForAll(address owner, address operator)
825         public
826         view
827         virtual
828         override
829         returns (bool)
830     {
831         return _operatorApprovals[owner][operator];
832     }
833 
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public override {
839         _transfer(from, to, tokenId);
840     }
841 
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public override {
847         safeTransferFrom(from, to, tokenId, "");
848     }
849 
850     function safeTransferFrom(
851         address from,
852         address to,
853         uint256 tokenId,
854         bytes memory _data
855     ) public override {
856         _transfer(from, to, tokenId);
857         require(
858             _checkOnERC721Received(from, to, tokenId, _data),
859             "ERC721A: transfer to non ERC721Receiver implementer"
860         );
861     }
862 
863     function _exists(uint256 tokenId) internal view returns (bool) {
864         return tokenId < currentIndex;
865     }
866 
867     function _safeMint(address to, uint256 quantity) internal {
868         _safeMint(to, quantity, "");
869     }
870 
871     function _safeMint(
872         address to,
873         uint256 quantity,
874         bytes memory _data
875     ) internal {
876         uint256 startTokenId = currentIndex;
877         require(to != address(0), "ERC721A: mint to the zero address");
878         require(!_exists(startTokenId), "ERC721A: token already minted");
879         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         AddressData memory addressData = _addressData[to];
884         _addressData[to] = AddressData(
885             addressData.balance + uint128(quantity),
886             addressData.numberMinted + uint128(quantity)
887         );
888         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
889 
890         uint256 updatedIndex = startTokenId;
891 
892         for (uint256 i = 0; i < quantity; i++) {
893             emit Transfer(address(0), to, updatedIndex);
894             require(
895                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
896                 "ERC721A: transfer to non ERC721Receiver implementer"
897             );
898             updatedIndex++;
899         }
900 
901         currentIndex = updatedIndex;
902         _afterTokenTransfers(address(0), to, startTokenId, quantity);
903     }
904 
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) private {
910         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
911 
912         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
913             getApproved(tokenId) == _msgSender() ||
914             isApprovedForAll(prevOwnership.addr, _msgSender()));
915 
916         require(
917             isApprovedOrOwner,
918             "ERC721A: transfer caller is not owner nor approved"
919         );
920 
921         require(
922             prevOwnership.addr == from,
923             "ERC721A: transfer from incorrect owner"
924         );
925         require(to != address(0), "ERC721A: transfer to the zero address");
926 
927         _beforeTokenTransfers(from, to, tokenId, 1);
928         _approve(address(0), tokenId, prevOwnership.addr);
929 
930         _addressData[from].balance -= 1;
931         _addressData[to].balance += 1;
932         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
933         uint256 nextTokenId = tokenId + 1;
934         if (_ownerships[nextTokenId].addr == address(0)) {
935             if (_exists(nextTokenId)) {
936                 _ownerships[nextTokenId] = TokenOwnership(
937                     prevOwnership.addr,
938                     prevOwnership.startTimestamp
939                 );
940             }
941         }
942 
943         emit Transfer(from, to, tokenId);
944         _afterTokenTransfers(from, to, tokenId, 1);
945     }
946 
947     function _approve(
948         address to,
949         uint256 tokenId,
950         address owner
951     ) private {
952         _tokenApprovals[tokenId] = to;
953         emit Approval(owner, to, tokenId);
954     }
955 
956     uint256 public nextOwnerToExplicitlySet = 0;
957 
958     function _setOwnersExplicit(uint256 quantity) internal {
959         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
960         require(quantity > 0, "quantity must be nonzero");
961         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
962         if (endIndex > collectionSize - 1) {
963             endIndex = collectionSize - 1;
964         }
965         require(_exists(endIndex), "not enough minted yet for this cleanup");
966         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
967             if (_ownerships[i].addr == address(0)) {
968                 TokenOwnership memory ownership = ownershipOf(i);
969                 _ownerships[i] = TokenOwnership(
970                     ownership.addr,
971                     ownership.startTimestamp
972                 );
973             }
974         }
975         nextOwnerToExplicitlySet = endIndex + 1;
976     }
977 
978     function _checkOnERC721Received(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) private returns (bool) {
984         if (to.isContract()) {
985             try
986                 IERC721Receiver(to).onERC721Received(
987                     _msgSender(),
988                     from,
989                     tokenId,
990                     _data
991                 )
992             returns (bytes4 retval) {
993                 return retval == IERC721Receiver(to).onERC721Received.selector;
994             } catch (bytes memory reason) {
995                 if (reason.length == 0) {
996                     revert(
997                         "ERC721A: transfer to non ERC721Receiver implementer"
998                     );
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
1025 
1026 
1027 
1028 
1029 
1030 contract FreeBreadsdicks is Ownable, ERC721A, ReentrancyGuard {
1031     using Strings for uint256;
1032     using SafeMath for uint256;
1033 
1034 
1035     uint256 public MAX_PER_Transaction = 10; // maximum amount that user can mint per transaction
1036     uint256 public MAX_PER_WALLET = 20;
1037 
1038     //prices
1039     uint256 public price = 0.0069 ether; 
1040 
1041     //Required arguments for ERC721A constructor
1042     uint256 private constant TotalCollectionSize_ = 6969; // total number of nfts
1043 
1044     uint256 private freebies;
1045     uint16 private freebieLimit = 6549;
1046     
1047     bool public isFree = true;
1048     bool public paused = true;
1049 
1050 
1051     string private baseTokenURI;
1052 
1053     
1054     constructor()
1055         ERC721A(
1056             "Free Breadsdicks",
1057             "SDICKS",
1058             MAX_PER_Transaction,
1059             TotalCollectionSize_
1060         )
1061     {
1062 
1063         setBaseURI(
1064             "ipfs://Qmd9Gky9vxceF8Rf8vgMWWu4tP8K2JL4pEWJk8urg7fXBh/" //make sure the slash / is at the end of it
1065         );
1066         
1067     }
1068 
1069     function supportsInterface(bytes4 interfaceId)
1070         public
1071         view
1072         override(ERC721A)
1073         returns (bool)
1074     {
1075         return
1076             interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1077     }
1078 
1079     
1080 
1081 
1082     function mint(uint256 quantity) public payable {
1083         require(!paused, "mint is paused");
1084         require(
1085             totalSupply() + quantity <= TotalCollectionSize_,
1086             "reached max supply"
1087         );
1088          require(quantity <= MAX_PER_Transaction, "can not mint this many");
1089          require(
1090             (numberMinted(msg.sender) + quantity <= MAX_PER_WALLET),
1091             "Quantity exceeds allowed Mints"
1092         );
1093 
1094          if(!isFree || totalSupply() + quantity > freebieLimit) {
1095                 require(msg.value >= price * quantity, "insufficient funds");
1096             }
1097             else {
1098                 require(freebies + quantity <= freebieLimit, "not enough freebies left");
1099                 freebies = freebies + quantity;
1100             }
1101 
1102         _safeMint(msg.sender, quantity);
1103         }
1104     
1105 
1106     function tokenURI(uint256 tokenId)
1107         public
1108         view
1109         virtual
1110         override
1111         returns (string memory)
1112     {
1113         require(
1114             _exists(tokenId),
1115             "ERC721Metadata: URI query for nonexistent token"
1116         );
1117        
1118             string memory baseURI = _baseURI();
1119             return
1120                 bytes(baseURI).length > 0
1121                     ? string(
1122                         abi.encodePacked(baseURI, tokenId.toString(), ".json")
1123                     )
1124                     : "";
1125        
1126         
1127     }
1128 
1129 
1130 
1131     function setBaseURI(string memory baseURI) public onlyOwner {
1132         baseTokenURI = baseURI;
1133     }
1134 
1135     function _baseURI() internal view virtual override returns (string memory) {
1136         return baseTokenURI;
1137     }
1138 
1139     function numberMinted(address owner) public view returns (uint256) {
1140         return _numberMinted(owner);
1141     }
1142 
1143     function getOwnershipData(uint256 tokenId)
1144         external
1145         view
1146         returns (TokenOwnership memory)
1147     {
1148         return ownershipOf(tokenId);
1149     }
1150 
1151     function withdraw() public onlyOwner nonReentrant {
1152         // This will payout the owner the contract balance.
1153         // Do not remove this otherwise you will not be able to withdraw the funds.
1154         // =============================================================================
1155         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1156         require(os);
1157         // =============================================================================
1158     }
1159 
1160     
1161     function setPrice(uint256 _newPrice) public onlyOwner {
1162         price = _newPrice;
1163     }
1164 
1165     
1166     function setMAX_PER_Transaction(uint256 q) public onlyOwner {
1167         MAX_PER_Transaction = q;
1168     }
1169 
1170     function setMAX_PER_WALLET(uint256 q) public onlyOwner {
1171         MAX_PER_WALLET = q;
1172     }
1173 
1174 
1175     function pause(bool _state) public onlyOwner {
1176         paused = _state;
1177     }
1178 
1179     function FreebieTime(bool _state) public onlyOwner {
1180         isFree = _state;
1181     }
1182 
1183     
1184     function giveaway(address a, uint256 q) public onlyOwner {
1185         _safeMint(a, q);
1186     }
1187 }