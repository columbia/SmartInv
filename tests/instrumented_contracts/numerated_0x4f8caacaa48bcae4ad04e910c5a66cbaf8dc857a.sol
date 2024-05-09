1 // SPDX-License-Identifier: MIT
2 
3 // TheJIMS NFT
4 // Max Supply = 5678
5 // Max per wallet = 5
6 // 1 free, rest 0.0055 eth each
7 // THE GAME IS ABOUT TO BEGIN
8 
9 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
10 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
11 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
12 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
13 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
14 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
15 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
16 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
17 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
18 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
19 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
20 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
21 // ((((((((((#@@@@@@@@@@((@@@@@@@@@@(((@@@@@@@@@(((((%@@@@@@@@(((((@@@@@@@@@@&(((((
22 // ((((((((((#@@@@@@@@@@((@@@@@@@@@@(((@@@@@@@@@@&((@@@@@@@@@@((#@@@@@@@@@@@@@@@(((
23 // (((((((((((((&@@@@@((((((@@@@@@(((((((@@@@@@@@@@@@@@@@@@@((((#@@@@@(((((@@@@@(((
24 // (((((((((((((&@@@@@((((((@@@@@@(((((((@@@@@%@@@@@@@@@@@@@(((((@@@@@@@@@@@@@(((((
25 // (((((((((((((&@@@@@((((((@@@@@@(((((((@@@@@((@@@@@((@@@@@((((((((&@@@@@@@@@@@(((
26 // (((%@@@@@((((&@@@@@((((((@@@@@@(((((((@@@@@(((&@&(((@@@@@((((#@@@@@(((((@@@@@(((
27 // ((((@@@@@@@@@@@@@@(((((@@@@@@@@@@(((@@@@@@@@@@(((&@@@@@@@@@(((@@@@@@@@@@@@@@@(((
28 // (((((((@@@@@@@@#(((((((@@@@@@@@@@(((@@@@@@@@@@(((&@@@@@@@@@((((((@@@@@@@@@((((((
29 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
30 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
31 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
32 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
33 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
34 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
35 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
36 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
37 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
38 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
39 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
40 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
41 
42 pragma solidity ^0.8.0;
43 
44 library MerkleProof {
45     function verify(
46         bytes32[] memory proof,
47         bytes32 root,
48         bytes32 leaf
49     ) internal pure returns (bool) {
50         return processProof(proof, leaf) == root;
51     }
52 
53     function processProof(bytes32[] memory proof, bytes32 leaf)
54         internal
55         pure
56         returns (bytes32)
57     {
58         bytes32 computedHash = leaf;
59         for (uint256 i = 0; i < proof.length; i++) {
60             bytes32 proofElement = proof[i];
61             if (computedHash <= proofElement) {
62                 computedHash = _efficientHash(computedHash, proofElement);
63             } else {
64                 computedHash = _efficientHash(proofElement, computedHash);
65             }
66         }
67         return computedHash;
68     }
69 
70     function _efficientHash(bytes32 a, bytes32 b)
71         private
72         pure
73         returns (bytes32 value)
74     {
75         assembly {
76             mstore(0x00, a)
77             mstore(0x20, b)
78             value := keccak256(0x00, 0x40)
79         }
80     }
81 }
82 
83 abstract contract ReentrancyGuard {
84     uint256 private constant _NOT_ENTERED = 1;
85     uint256 private constant _ENTERED = 2;
86 
87     uint256 private _status;
88 
89     constructor() {
90         _status = _NOT_ENTERED;
91     }
92 
93     modifier nonReentrant() {
94         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
95         _status = _ENTERED;
96 
97         _;
98         _status = _NOT_ENTERED;
99     }
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations.
104  *
105  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
106  * now has built in overflow checking.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, with an overflow flag.
111      *
112      * _Available since v3.4._
113      */
114     function tryAdd(uint256 a, uint256 b)
115         internal
116         pure
117         returns (bool, uint256)
118     {
119         unchecked {
120             uint256 c = a + b;
121             if (c < a) return (false, 0);
122             return (true, c);
123         }
124     }
125 
126     /**
127      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function trySub(uint256 a, uint256 b)
132         internal
133         pure
134         returns (bool, uint256)
135     {
136         unchecked {
137             if (b > a) return (false, 0);
138             return (true, a - b);
139         }
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryMul(uint256 a, uint256 b)
148         internal
149         pure
150         returns (bool, uint256)
151     {
152         unchecked {
153             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154             // benefit is lost if 'b' is also tested.
155             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156             if (a == 0) return (true, 0);
157             uint256 c = a * b;
158             if (c / a != b) return (false, 0);
159             return (true, c);
160         }
161     }
162 
163     /**
164      * @dev Returns the division of two unsigned integers, with a division by zero flag.
165      *
166      * _Available since v3.4._
167      */
168     function tryDiv(uint256 a, uint256 b)
169         internal
170         pure
171         returns (bool, uint256)
172     {
173         unchecked {
174             if (b == 0) return (false, 0);
175             return (true, a / b);
176         }
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
181      *
182      * _Available since v3.4._
183      */
184     function tryMod(uint256 a, uint256 b)
185         internal
186         pure
187         returns (bool, uint256)
188     {
189         unchecked {
190             if (b == 0) return (false, 0);
191             return (true, a % b);
192         }
193     }
194 
195     /**
196      * @dev Returns the addition of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `+` operator.
200      *
201      * Requirements:
202      *
203      * - Addition cannot overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a + b;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a - b;
221     }
222 
223     /**
224      * @dev Returns the multiplication of two unsigned integers, reverting on
225      * overflow.
226      *
227      * Counterpart to Solidity's `*` operator.
228      *
229      * Requirements:
230      *
231      * - Multiplication cannot overflow.
232      */
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a * b;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers, reverting on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator.
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a / b;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * reverting when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a % b;
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
269      * overflow (when the result is negative).
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {trySub}.
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         unchecked {
286             require(b <= a, errorMessage);
287             return a - b;
288         }
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b > 0, errorMessage);
310             return a / b;
311         }
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * reverting with custom message when dividing by zero.
317      *
318      * CAUTION: This function is deprecated because it requires allocating memory for the error
319      * message unnecessarily. For custom revert reasons use {tryMod}.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a % b;
337         }
338     }
339 }
340 
341 library Strings {
342     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
343 
344     function toString(uint256 value) internal pure returns (string memory) {
345         if (value == 0) {
346             return "0";
347         }
348         uint256 temp = value;
349         uint256 digits;
350         while (temp != 0) {
351             digits++;
352             temp /= 10;
353         }
354         bytes memory buffer = new bytes(digits);
355         while (value != 0) {
356             digits -= 1;
357             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
358             value /= 10;
359         }
360         return string(buffer);
361     }
362 
363     function toHexString(uint256 value) internal pure returns (string memory) {
364         if (value == 0) {
365             return "0x00";
366         }
367         uint256 temp = value;
368         uint256 length = 0;
369         while (temp != 0) {
370             length++;
371             temp >>= 8;
372         }
373         return toHexString(value, length);
374     }
375 
376     function toHexString(uint256 value, uint256 length)
377         internal
378         pure
379         returns (string memory)
380     {
381         bytes memory buffer = new bytes(2 * length + 2);
382         buffer[0] = "0";
383         buffer[1] = "x";
384         for (uint256 i = 2 * length + 1; i > 1; --i) {
385             buffer[i] = _HEX_SYMBOLS[value & 0xf];
386             value >>= 4;
387         }
388         require(value == 0, "Strings: hex length insufficient");
389         return string(buffer);
390     }
391 }
392 
393 abstract contract Context {
394     function _msgSender() internal view virtual returns (address) {
395         return msg.sender;
396     }
397 
398     function _msgData() internal view virtual returns (bytes calldata) {
399         return msg.data;
400     }
401 }
402 
403 abstract contract Ownable is Context {
404     address private _owner;
405 
406     event OwnershipTransferred(
407         address indexed previousOwner,
408         address indexed newOwner
409     );
410 
411     constructor() {
412         _transferOwnership(_msgSender());
413     }
414 
415     function owner() public view virtual returns (address) {
416         return _owner;
417     }
418 
419     modifier onlyOwner() {
420         require(owner() == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     function renounceOwnership() public virtual onlyOwner {
425         _transferOwnership(address(0));
426     }
427 
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(
430             newOwner != address(0),
431             "Ownable: new owner is the zero address"
432         );
433         _transferOwnership(newOwner);
434     }
435 
436     function _transferOwnership(address newOwner) internal virtual {
437         address oldOwner = _owner;
438         _owner = newOwner;
439         emit OwnershipTransferred(oldOwner, newOwner);
440     }
441 }
442 
443 library Address {
444     function isContract(address account) internal view returns (bool) {
445         uint256 size;
446         assembly {
447             size := extcodesize(account)
448         }
449         return size > 0;
450     }
451 
452     function sendValue(address payable recipient, uint256 amount) internal {
453         require(
454             address(this).balance >= amount,
455             "Address: insufficient balance"
456         );
457 
458         (bool success, ) = recipient.call{value: amount}("");
459         require(
460             success,
461             "Address: unable to send value, recipient may have reverted"
462         );
463     }
464 
465     function functionCall(address target, bytes memory data)
466         internal
467         returns (bytes memory)
468     {
469         return functionCall(target, data, "Address: low-level call failed");
470     }
471 
472     function functionCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, errorMessage);
478     }
479 
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value
484     ) internal returns (bytes memory) {
485         return
486             functionCallWithValue(
487                 target,
488                 data,
489                 value,
490                 "Address: low-level call with value failed"
491             );
492     }
493 
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(
501             address(this).balance >= value,
502             "Address: insufficient balance for call"
503         );
504         require(isContract(target), "Address: call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.call{value: value}(
507             data
508         );
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     function functionStaticCall(address target, bytes memory data)
513         internal
514         view
515         returns (bytes memory)
516     {
517         return
518             functionStaticCall(
519                 target,
520                 data,
521                 "Address: low-level static call failed"
522             );
523     }
524 
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     function functionDelegateCall(address target, bytes memory data)
537         internal
538         returns (bytes memory)
539     {
540         return
541             functionDelegateCall(
542                 target,
543                 data,
544                 "Address: low-level delegate call failed"
545             );
546     }
547 
548     function functionDelegateCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(isContract(target), "Address: delegate call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.delegatecall(data);
556         return verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     function verifyCallResult(
560         bool success,
561         bytes memory returndata,
562         string memory errorMessage
563     ) internal pure returns (bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             if (returndata.length > 0) {
568                 assembly {
569                     let returndata_size := mload(returndata)
570                     revert(add(32, returndata), returndata_size)
571                 }
572             } else {
573                 revert(errorMessage);
574             }
575         }
576     }
577 }
578 
579 interface IERC721Receiver {
580     function onERC721Received(
581         address operator,
582         address from,
583         uint256 tokenId,
584         bytes calldata data
585     ) external returns (bytes4);
586 }
587 
588 interface IERC165 {
589     function supportsInterface(bytes4 interfaceId) external view returns (bool);
590 }
591 
592 abstract contract ERC165 is IERC165 {
593     function supportsInterface(bytes4 interfaceId)
594         public
595         view
596         virtual
597         override
598         returns (bool)
599     {
600         return interfaceId == type(IERC165).interfaceId;
601     }
602 }
603 
604 interface IERC721 is IERC165 {
605     event Transfer(
606         address indexed from,
607         address indexed to,
608         uint256 indexed tokenId
609     );
610     event Approval(
611         address indexed owner,
612         address indexed approved,
613         uint256 indexed tokenId
614     );
615     event ApprovalForAll(
616         address indexed owner,
617         address indexed operator,
618         bool approved
619     );
620 
621     function balanceOf(address owner) external view returns (uint256 balance);
622 
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     function approve(address to, uint256 tokenId) external;
638 
639     function getApproved(uint256 tokenId)
640         external
641         view
642         returns (address operator);
643 
644     function setApprovalForAll(address operator, bool _approved) external;
645 
646     function isApprovedForAll(address owner, address operator)
647         external
648         view
649         returns (bool);
650 
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId,
655         bytes calldata data
656     ) external;
657 }
658 
659 interface IERC721Enumerable is IERC721 {
660     function totalSupply() external view returns (uint256);
661 
662     function tokenOfOwnerByIndex(address owner, uint256 index)
663         external
664         view
665         returns (uint256 tokenId);
666 
667     function tokenByIndex(uint256 index) external view returns (uint256);
668 }
669 
670 interface IERC721Metadata is IERC721 {
671     function name() external view returns (string memory);
672 
673     function symbol() external view returns (string memory);
674 
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 }
677 
678 contract ERC721A is
679     Context,
680     ERC165,
681     IERC721,
682     IERC721Metadata,
683     IERC721Enumerable
684 {
685     using Address for address;
686     using Strings for uint256;
687 
688     struct TokenOwnership {
689         address addr;
690         uint64 startTimestamp;
691     }
692 
693     struct AddressData {
694         uint128 balance;
695         uint128 numberMinted;
696     }
697 
698     uint256 private currentIndex = 1;
699 
700     uint256 internal immutable collectionSize;
701     uint256 internal immutable maxBatchSize;
702     string private _name;
703     string private _symbol;
704     mapping(uint256 => TokenOwnership) private _ownerships;
705     mapping(address => AddressData) private _addressData;
706     mapping(uint256 => address) private _tokenApprovals;
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     constructor(
710         string memory name_,
711         string memory symbol_,
712         uint256 maxBatchSize_,
713         uint256 collectionSize_
714     ) {
715         require(
716             collectionSize_ > 0,
717             "ERC721A: collection must have a nonzero supply"
718         );
719         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
720         _name = name_;
721         _symbol = symbol_;
722         maxBatchSize = maxBatchSize_;
723         collectionSize = collectionSize_;
724     }
725 
726     function totalSupply() public view override returns (uint256) {
727         return currentIndex - 1;
728     }
729 
730     function tokenByIndex(uint256 index)
731         public
732         view
733         override
734         returns (uint256)
735     {
736         require(index < totalSupply(), "ERC721A: global index out of bounds");
737         return index;
738     }
739 
740     function tokenOfOwnerByIndex(address owner, uint256 index)
741         public
742         view
743         override
744         returns (uint256)
745     {
746         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
747         uint256 numMintedSoFar = totalSupply();
748         uint256 tokenIdsIdx = 0;
749         address currOwnershipAddr = address(0);
750         for (uint256 i = 0; i < numMintedSoFar; i++) {
751             TokenOwnership memory ownership = _ownerships[i];
752             if (ownership.addr != address(0)) {
753                 currOwnershipAddr = ownership.addr;
754             }
755             if (currOwnershipAddr == owner) {
756                 if (tokenIdsIdx == index) {
757                     return i;
758                 }
759                 tokenIdsIdx++;
760             }
761         }
762         revert("ERC721A: unable to get token of owner by index");
763     }
764 
765     function supportsInterface(bytes4 interfaceId)
766         public
767         view
768         virtual
769         override(ERC165, IERC165)
770         returns (bool)
771     {
772         return
773             interfaceId == type(IERC721).interfaceId ||
774             interfaceId == type(IERC721Metadata).interfaceId ||
775             interfaceId == type(IERC721Enumerable).interfaceId ||
776             super.supportsInterface(interfaceId);
777     }
778 
779     function balanceOf(address owner) public view override returns (uint256) {
780         require(
781             owner != address(0),
782             "ERC721A: balance query for the zero address"
783         );
784         return uint256(_addressData[owner].balance);
785     }
786 
787     function _numberMinted(address owner) internal view returns (uint256) {
788         require(
789             owner != address(0),
790             "ERC721A: number minted query for the zero address"
791         );
792         return uint256(_addressData[owner].numberMinted);
793     }
794 
795     function ownershipOf(uint256 tokenId)
796         internal
797         view
798         returns (TokenOwnership memory)
799     {
800         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
801 
802         uint256 lowestTokenToCheck;
803         if (tokenId >= maxBatchSize) {
804             lowestTokenToCheck = tokenId - maxBatchSize + 1;
805         }
806 
807         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
808             TokenOwnership memory ownership = _ownerships[curr];
809             if (ownership.addr != address(0)) {
810                 return ownership;
811             }
812         }
813 
814         revert("ERC721A: unable to determine the owner of token");
815     }
816 
817     function ownerOf(uint256 tokenId) public view override returns (address) {
818         return ownershipOf(tokenId).addr;
819     }
820 
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     function symbol() public view virtual override returns (string memory) {
826         return _symbol;
827     }
828 
829     function tokenURI(uint256 tokenId)
830         public
831         view
832         virtual
833         override
834         returns (string memory)
835     {
836         require(
837             _exists(tokenId),
838             "ERC721Metadata: URI query for nonexistent token"
839         );
840 
841         string memory baseURI = _baseURI();
842         return
843             bytes(baseURI).length > 0
844                 ? string(
845                     abi.encodePacked(
846                         baseURI,
847                         tokenId.toString(),
848                         _getUriExtension()
849                     )
850                 )
851                 : "";
852     }
853 
854     function _baseURI() internal view virtual returns (string memory) {
855         return "";
856     }
857 
858     function _getUriExtension() internal view virtual returns (string memory) {
859         return "";
860     }
861 
862     function approve(address to, uint256 tokenId) public override {
863         address owner = ERC721A.ownerOf(tokenId);
864         require(to != owner, "ERC721A: approval to current owner");
865 
866         require(
867             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
868             "ERC721A: approve caller is not owner nor approved for all"
869         );
870 
871         _approve(to, tokenId, owner);
872     }
873 
874     function getApproved(uint256 tokenId)
875         public
876         view
877         override
878         returns (address)
879     {
880         require(
881             _exists(tokenId),
882             "ERC721A: approved query for nonexistent token"
883         );
884 
885         return _tokenApprovals[tokenId];
886     }
887 
888     function setApprovalForAll(address operator, bool approved)
889         public
890         override
891     {
892         require(operator != _msgSender(), "ERC721A: approve to caller");
893 
894         _operatorApprovals[_msgSender()][operator] = approved;
895         emit ApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     function isApprovedForAll(address owner, address operator)
899         public
900         view
901         virtual
902         override
903         returns (bool)
904     {
905         return _operatorApprovals[owner][operator];
906     }
907 
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public override {
913         _transfer(from, to, tokenId);
914     }
915 
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public override {
921         safeTransferFrom(from, to, tokenId, "");
922     }
923 
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public override {
930         _transfer(from, to, tokenId);
931         require(
932             _checkOnERC721Received(from, to, tokenId, _data),
933             "ERC721A: transfer to non ERC721Receiver implementer"
934         );
935     }
936 
937     function _exists(uint256 tokenId) internal view returns (bool) {
938         return tokenId < currentIndex;
939     }
940 
941     function _safeMint(address to, uint256 quantity) internal {
942         _safeMint(to, quantity, "");
943     }
944 
945     function _safeMint(
946         address to,
947         uint256 quantity,
948         bytes memory _data
949     ) internal {
950         uint256 startTokenId = currentIndex;
951         require(to != address(0), "ERC721A: mint to the zero address");
952         require(!_exists(startTokenId), "ERC721A: token already minted");
953         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
954 
955         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
956 
957         AddressData memory addressData = _addressData[to];
958         _addressData[to] = AddressData(
959             addressData.balance + uint128(quantity),
960             addressData.numberMinted + uint128(quantity)
961         );
962         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
963 
964         uint256 updatedIndex = startTokenId;
965 
966         for (uint256 i = 0; i < quantity; i++) {
967             emit Transfer(address(0), to, updatedIndex);
968             require(
969                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
970                 "ERC721A: transfer to non ERC721Receiver implementer"
971             );
972             updatedIndex++;
973         }
974 
975         currentIndex = updatedIndex;
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) private {
984         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
985 
986         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
987             getApproved(tokenId) == _msgSender() ||
988             isApprovedForAll(prevOwnership.addr, _msgSender()));
989 
990         require(
991             isApprovedOrOwner,
992             "ERC721A: transfer caller is not owner nor approved"
993         );
994 
995         require(
996             prevOwnership.addr == from,
997             "ERC721A: transfer from incorrect owner"
998         );
999         require(to != address(0), "ERC721A: transfer to the zero address");
1000 
1001         _beforeTokenTransfers(from, to, tokenId, 1);
1002         _approve(address(0), tokenId, prevOwnership.addr);
1003 
1004         _addressData[from].balance -= 1;
1005         _addressData[to].balance += 1;
1006         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1007         uint256 nextTokenId = tokenId + 1;
1008         if (_ownerships[nextTokenId].addr == address(0)) {
1009             if (_exists(nextTokenId)) {
1010                 _ownerships[nextTokenId] = TokenOwnership(
1011                     prevOwnership.addr,
1012                     prevOwnership.startTimestamp
1013                 );
1014             }
1015         }
1016 
1017         emit Transfer(from, to, tokenId);
1018         _afterTokenTransfers(from, to, tokenId, 1);
1019     }
1020 
1021     function _approve(
1022         address to,
1023         uint256 tokenId,
1024         address owner
1025     ) private {
1026         _tokenApprovals[tokenId] = to;
1027         emit Approval(owner, to, tokenId);
1028     }
1029 
1030     uint256 public nextOwnerToExplicitlySet = 0;
1031 
1032     function _setOwnersExplicit(uint256 quantity) internal {
1033         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1034         require(quantity > 0, "quantity must be nonzero");
1035         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1036         if (endIndex > collectionSize - 1) {
1037             endIndex = collectionSize - 1;
1038         }
1039         require(_exists(endIndex), "not enough minted yet for this cleanup");
1040         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1041             if (_ownerships[i].addr == address(0)) {
1042                 TokenOwnership memory ownership = ownershipOf(i);
1043                 _ownerships[i] = TokenOwnership(
1044                     ownership.addr,
1045                     ownership.startTimestamp
1046                 );
1047             }
1048         }
1049         nextOwnerToExplicitlySet = endIndex + 1;
1050     }
1051 
1052     function _checkOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         if (to.isContract()) {
1059             try
1060                 IERC721Receiver(to).onERC721Received(
1061                     _msgSender(),
1062                     from,
1063                     tokenId,
1064                     _data
1065                 )
1066             returns (bytes4 retval) {
1067                 return retval == IERC721Receiver(to).onERC721Received.selector;
1068             } catch (bytes memory reason) {
1069                 if (reason.length == 0) {
1070                     revert(
1071                         "ERC721A: transfer to non ERC721Receiver implementer"
1072                     );
1073                 } else {
1074                     assembly {
1075                         revert(add(32, reason), mload(reason))
1076                     }
1077                 }
1078             }
1079         } else {
1080             return true;
1081         }
1082     }
1083 
1084     function _beforeTokenTransfers(
1085         address from,
1086         address to,
1087         uint256 startTokenId,
1088         uint256 quantity
1089     ) internal virtual {}
1090 
1091     function _afterTokenTransfers(
1092         address from,
1093         address to,
1094         uint256 startTokenId,
1095         uint256 quantity
1096     ) internal virtual {}
1097 }
1098 
1099 contract THEJIMS is Ownable, ERC721A, ReentrancyGuard {
1100     using Strings for uint256;
1101     using SafeMath for uint256;
1102     bool public burnable;
1103 
1104     string public uriSuffix = ".json";
1105 
1106     uint256 public MAX_PER_Transaction = 5; // maximum amount that user can mint per transaction
1107     uint256 public TotalCollectionSize_ = 5678; // total number of nfts
1108     uint256 public MAX_PER_Wallet = 5;
1109 
1110     //prices
1111 
1112     uint256 public price = 0.0055 ether;
1113 
1114     uint256 private constant MaxMintPerBatch_ = 200; //max mint per traction
1115     uint256 public remaining;
1116 
1117     mapping(uint256 => uint256) public cache;
1118     mapping(uint256 => uint256) public cachePosition;
1119 
1120     bool public paused = true;
1121     bool public presaleIsActive = false;
1122 
1123     string private baseTokenURI = "";
1124 
1125     bytes32 public merkleRoot;
1126 
1127     constructor()
1128         ERC721A("THEJIMS", "JIMS", MaxMintPerBatch_, TotalCollectionSize_)
1129     {}
1130 
1131     function supportsInterface(bytes4 interfaceId)
1132         public
1133         view
1134         override(ERC721A)
1135         returns (bool)
1136     {
1137         return
1138             interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
1139     }
1140 
1141     function setMerkleRoot(bytes32 m) public onlyOwner {
1142         merkleRoot = m;
1143     }
1144 
1145     function getMerkleRoot() public view returns (bytes32) {
1146         return merkleRoot;
1147     }
1148 
1149     // function hashTransaction(address sender, uint256 qty, address address_) private pure returns(bytes32)
1150     // {
1151     //       bytes32 hash = keccak256(abi.encodePacked(
1152     //         "\x19Ethereum Signed Message:\n32",
1153     //         keccak256(abi.encodePacked(sender, qty, address_)))
1154     //       );
1155     //       return hash;
1156     // }
1157 
1158     function burn(uint256 tokenId) external returns (uint256) {
1159         require(burnable, "This contract does not allow burning");
1160         require(
1161             msg.sender == ownerOf(tokenId),
1162             "Burner is not the owner of token"
1163         );
1164         // _burn(tokenId);
1165         return tokenId;
1166     }
1167 
1168     function VerifyMessage(
1169         bytes32 _hashedMessage,
1170         uint8 _v,
1171         bytes32 _r,
1172         bytes32 _s
1173     ) public pure returns (address) {
1174         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1175         bytes32 prefixedHashMessage = keccak256(
1176             abi.encodePacked(prefix, _hashedMessage)
1177         );
1178         address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
1179         return signer;
1180     }
1181 
1182     function mint(uint256 quantity) public payable {
1183         require(!paused, "mint is paused");
1184         require(
1185             totalSupply() + quantity <= TotalCollectionSize_,
1186             "reached max supply"
1187         );
1188         require(
1189             numberMinted(msg.sender) + quantity <= MAX_PER_Wallet,
1190             "limit per wallet exceeded"
1191         );
1192         require(quantity <= MAX_PER_Transaction, "can not mint this many");
1193 
1194         if (msg.value == 0 && quantity == 1) {
1195             require(balanceOf(msg.sender) < 1, "Already minted free!");
1196             _safeMint(msg.sender, quantity);
1197         } else if (balanceOf(msg.sender) >= 1) {
1198             require(msg.value >= _shouldPay(quantity), "Insufficient funds!");
1199             _safeMint(msg.sender, quantity);
1200         } else {
1201             require(
1202                 msg.value >= _shouldPay(quantity - 1),
1203                 "Insufficient funds!"
1204             );
1205             _safeMint(msg.sender, quantity);
1206         }
1207     }
1208 
1209     function _shouldPay(uint256 _quantity) private view returns (uint256) {
1210         uint256 shouldPay = price * _quantity;
1211         return shouldPay;
1212     }
1213 
1214     function isValid(bytes32[] memory merkleproof, bytes32 leaf)
1215         public
1216         view
1217         returns (bool)
1218     {
1219         return MerkleProof.verify(merkleproof, merkleRoot, leaf);
1220     }
1221 
1222     function tokenURI(uint256 tokenId)
1223         public
1224         view
1225         virtual
1226         override
1227         returns (string memory)
1228     {
1229         require(
1230             _exists(tokenId),
1231             "ERC721Metadata: URI query for nonexistent token"
1232         );
1233 
1234         string memory baseURI = _baseURI();
1235         return
1236             bytes(baseURI).length > 0
1237                 ? string(
1238                     abi.encodePacked(baseURI, tokenId.toString(), uriSuffix)
1239                 )
1240                 : "";
1241     }
1242 
1243     function airdrop(address[] memory address_, uint256 tokenCount)
1244         external
1245         onlyOwner
1246         returns (uint256)
1247     {
1248         require(
1249             totalSupply() + address_.length * tokenCount <=
1250                 TotalCollectionSize_,
1251             "This exceeds the maximum number of NFTs on sale!"
1252         );
1253         for (uint256 i = 0; i < address_.length; ) {
1254             _safeMint(address_[i], tokenCount);
1255             ++i;
1256         }
1257         return totalSupply();
1258     }
1259 
1260     function setBaseURI(string memory baseURI) public onlyOwner {
1261         baseTokenURI = baseURI;
1262     }
1263 
1264     function _baseURI() internal view virtual override returns (string memory) {
1265         return baseTokenURI;
1266     }
1267 
1268     function numberMinted(address owner) public view returns (uint256) {
1269         return _numberMinted(owner);
1270     }
1271 
1272     function getOwnershipData(uint256 tokenId)
1273         external
1274         view
1275         returns (TokenOwnership memory)
1276     {
1277         return ownershipOf(tokenId);
1278     }
1279 
1280     function withdraw() public onlyOwner nonReentrant {
1281         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1282         require(os);
1283     }
1284 
1285     function setMAX_PER_Transaction(uint256 q) public onlyOwner {
1286         MAX_PER_Transaction = q;
1287     }
1288 
1289     function setCollectionSize(uint256 q) public onlyOwner {
1290         TotalCollectionSize_ = q;
1291     }
1292 
1293     function setMaxPerWallet(uint256 _newLimit) public onlyOwner {
1294         MAX_PER_Wallet = _newLimit;
1295     }
1296 
1297     function pause(bool _state) public onlyOwner {
1298         paused = _state;
1299     }
1300 }