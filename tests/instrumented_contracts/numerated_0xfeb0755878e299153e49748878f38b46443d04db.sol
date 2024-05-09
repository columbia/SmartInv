1 /*
2     hey mfers.
3  */
4 pragma solidity ^0.8.0;
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(uint256 a, uint256 b)
13         internal
14         pure
15         returns (bool, uint256)
16     {
17         uint256 c = a + b;
18         if (c < a) return (false, 0);
19         return (true, c);
20     }
21 
22     /**
23      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function trySub(uint256 a, uint256 b)
28         internal
29         pure
30         returns (bool, uint256)
31     {
32         if (b > a) return (false, 0);
33         return (true, a - b);
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
38      *
39      * _Available since v3.4._
40      */
41     function tryMul(uint256 a, uint256 b)
42         internal
43         pure
44         returns (bool, uint256)
45     {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b)
61         internal
62         pure
63         returns (bool, uint256)
64     {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b)
75         internal
76         pure
77         returns (bool, uint256)
78     {
79         if (b == 0) return (false, 0);
80         return (true, a % b);
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b <= a, "SafeMath: subtraction overflow");
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         if (a == 0) return 0;
126         uint256 c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128         return c;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers, reverting on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         require(b > 0, "SafeMath: division by zero");
145         return a / b;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * reverting when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b > 0, "SafeMath: modulo by zero");
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         require(b <= a, errorMessage);
184         return a - b;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * CAUTION: This function is deprecated because it requires allocating memory for the error
192      * message unnecessarily. For custom revert reasons use {tryDiv}.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         return a / b;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * reverting with custom message when dividing by zero.
214      *
215      * CAUTION: This function is deprecated because it requires allocating memory for the error
216      * message unnecessarily. For custom revert reasons use {tryMod}.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(
227         uint256 a,
228         uint256 b,
229         string memory errorMessage
230     ) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 abstract contract Context {
237     function _msgSender() internal view virtual returns ( address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 abstract contract Ownable is Context {
247     address payable private _owner;
248 
249     event OwnershipTransferred(
250         address indexed previousOwner,
251         address indexed newOwner
252     );
253 
254     constructor() {
255         _setOwner(_msgSender());
256     }
257 
258     function owner() public view virtual returns (address payable) {
259         return _owner;
260     }
261 
262     modifier onlyOwner() {
263         require(owner() == _msgSender(), "Ownable: caller is not the owner");
264         _;
265     }
266 
267     function renounceOwnership() public virtual onlyOwner {
268         _setOwner(address(0));
269     }
270 
271     function transferOwnership(address newOwner) public virtual onlyOwner {
272         require(
273             newOwner != address(0),
274             "Ownable: new owner is the zero address"
275         );
276         _setOwner(newOwner);
277     }
278 
279     function _setOwner(address newOwner) private {
280         address oldOwner = _owner;
281         _owner = payable(newOwner);
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 interface IERC165 {
287     function supportsInterface(bytes4 interfaceId) external view returns (bool);
288 }
289 
290 abstract contract ERC165 is IERC165 {
291     function supportsInterface(bytes4 interfaceId)
292         public
293         view
294         virtual
295         override
296         returns (bool)
297     {
298         return interfaceId == type(IERC165).interfaceId;
299     }
300 }
301 
302 interface IERC721 is IERC165 {
303     event Transfer(
304         address indexed from,
305         address indexed to,
306         uint256 indexed tokenId
307     );
308 
309     event Approval(
310         address indexed owner,
311         address indexed approved,
312         uint256 indexed tokenId
313     );
314 
315     event ApprovalForAll(
316         address indexed owner,
317         address indexed operator,
318         bool approved
319     );
320 
321     function balanceOf(address owner) external view returns (uint256 balance);
322 
323     function ownerOf(uint256 tokenId) external view returns (address owner);
324 
325     function safeTransferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     function approve(address to, uint256 tokenId) external;
338 
339     function getApproved(uint256 tokenId)
340         external
341         view
342         returns (address operator);
343 
344     function setApprovalForAll(address operator, bool _approved) external;
345 
346     function isApprovedForAll(address owner, address operator)
347         external
348         view
349         returns (bool);
350 
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 tokenId,
355         bytes calldata data
356     ) external;
357 }
358 
359 interface IERC721Metadata is IERC721 {
360     function name() external view returns (string memory);
361 
362     function symbol() external view returns (string memory);
363 
364     function tokenURI(uint256 tokenId) external view returns (string memory);
365 }
366 
367 library Address {
368     function isContract(address account) internal view returns (bool) {
369         uint256 size;
370         assembly {
371             size := extcodesize(account)
372         }
373         return size > 0;
374     }
375 
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(
378             address(this).balance >= amount,
379             "Address: insufficient balance"
380         );
381 
382         (bool success, ) = recipient.call{value: amount}("");
383         require(
384             success,
385             "Address: unable to send value, recipient may have reverted"
386         );
387     }
388 
389     function functionCall(address target, bytes memory data)
390         internal
391         returns (bytes memory)
392     {
393         return functionCall(target, data, "Address: low-level call failed");
394     }
395 
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return
410             functionCallWithValue(
411                 target,
412                 data,
413                 value,
414                 "Address: low-level call with value failed"
415             );
416     }
417 
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(
425             address(this).balance >= value,
426             "Address: insufficient balance for call"
427         );
428         require(isContract(target), "Address: call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.call{value: value}(
431             data
432         );
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     function functionStaticCall(address target, bytes memory data)
437         internal
438         view
439         returns (bytes memory)
440     {
441         return
442             functionStaticCall(
443                 target,
444                 data,
445                 "Address: low-level static call failed"
446             );
447     }
448 
449     function functionStaticCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     function functionDelegateCall(address target, bytes memory data)
461         internal
462         returns (bytes memory)
463     {
464         return
465             functionDelegateCall(
466                 target,
467                 data,
468                 "Address: low-level delegate call failed"
469             );
470     }
471 
472     function functionDelegateCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(isContract(target), "Address: delegate call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.delegatecall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             if (returndata.length > 0) {
492                 assembly {
493                     let returndata_size := mload(returndata)
494                     revert(add(32, returndata), returndata_size)
495                 }
496             } else {
497                 revert(errorMessage);
498             }
499         }
500     }
501 }
502 
503 library Strings {
504     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
505 
506     function toString(uint256 value) internal pure returns (string memory) {
507         if (value == 0) {
508             return "0";
509         }
510         uint256 temp = value;
511         uint256 digits;
512         while (temp != 0) {
513             digits++;
514             temp /= 10;
515         }
516         bytes memory buffer = new bytes(digits);
517         while (value != 0) {
518             digits -= 1;
519             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
520             value /= 10;
521         }
522         return string(buffer);
523     }
524 
525     function toHexString(uint256 value) internal pure returns (string memory) {
526         if (value == 0) {
527             return "0x00";
528         }
529         uint256 temp = value;
530         uint256 length = 0;
531         while (temp != 0) {
532             length++;
533             temp >>= 8;
534         }
535         return toHexString(value, length);
536     }
537 
538     function toHexString(uint256 value, uint256 length)
539         internal
540         pure
541         returns (string memory)
542     {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553 }
554 
555 interface IERC721Receiver {
556     function onERC721Received(
557         address operator,
558         address from,
559         uint256 tokenId,
560         bytes calldata data
561     ) external returns (bytes4);
562 }
563 
564 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
565     using Address for address;
566     using Strings for uint256;
567 
568     string private _name;
569 
570     string private _symbol;
571 
572     mapping(uint256 => address) private _owners;
573 
574     mapping(address => uint256) private _balances;
575 
576     mapping(uint256 => address) private _tokenApprovals;
577 
578     mapping(address => mapping(address => bool)) private _operatorApprovals;
579 
580     constructor(string memory name_, string memory symbol_) {
581         _name = name_;
582         _symbol = symbol_;
583     }
584 
585     function supportsInterface(bytes4 interfaceId)
586         public
587         view
588         virtual
589         override(ERC165, IERC165)
590         returns (bool)
591     {
592         return
593             interfaceId == type(IERC721).interfaceId ||
594             interfaceId == type(IERC721Metadata).interfaceId ||
595             super.supportsInterface(interfaceId);
596     }
597 
598     function balanceOf(address owner)
599         public
600         view
601         virtual
602         override
603         returns (uint256)
604     {
605         require(
606             owner != address(0),
607             "ERC721: balance query for the zero address"
608         );
609         return _balances[owner];
610     }
611 
612     function ownerOf(uint256 tokenId)
613         public
614         view
615         virtual
616         override
617         returns (address)
618     {
619         address owner = _owners[tokenId];
620         require(
621             owner != address(0),
622             "ERC721: owner query for nonexistent token"
623         );
624         return owner;
625     }
626 
627     function name() public view virtual override returns (string memory) {
628         return _name;
629     }
630 
631     function symbol() public view virtual override returns (string memory) {
632         return _symbol;
633     }
634 
635     function tokenURI(uint256 tokenId)
636         public
637         view
638         virtual
639         override
640         returns (string memory)
641     {
642         require(
643             _exists(tokenId),
644             "ERC721Metadata: URI query for nonexistent token"
645         );
646 
647         string memory baseURI = _baseURI();
648         return
649             bytes(baseURI).length > 0
650                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
651                 : "";
652     }
653 
654     function _baseURI() internal view virtual returns (string memory) {
655         return "";
656     }
657 
658     function approve(address to, uint256 tokenId) public virtual override {
659         address owner = ERC721.ownerOf(tokenId);
660         require(to != owner, "ERC721: approval to current owner");
661 
662         require(
663             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
664             "ERC721: approve caller is not owner nor approved for all"
665         );
666 
667         _approve(to, tokenId);
668     }
669 
670     function getApproved(uint256 tokenId)
671         public
672         view
673         virtual
674         override
675         returns (address)
676     {
677         require(
678             _exists(tokenId),
679             "ERC721: approved query for nonexistent token"
680         );
681 
682         return _tokenApprovals[tokenId];
683     }
684 
685     function setApprovalForAll(address operator, bool approved)
686         public
687         virtual
688         override
689     {
690         require(operator != _msgSender(), "ERC721: approve to caller");
691 
692         _operatorApprovals[_msgSender()][operator] = approved;
693         emit ApprovalForAll(_msgSender(), operator, approved);
694     }
695 
696     function isApprovedForAll(address owner, address operator)
697         public
698         view
699         virtual
700         override
701         returns (bool)
702     {
703         return _operatorApprovals[owner][operator];
704     }
705 
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) public virtual override {
711         //solhint-disable-next-line max-line-length
712         require(
713             _isApprovedOrOwner(_msgSender(), tokenId),
714             "ERC721: transfer caller is not owner nor approved"
715         );
716 
717         _transfer(from, to, tokenId);
718     }
719 
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         safeTransferFrom(from, to, tokenId, "");
726     }
727 
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) public virtual override {
734         require(
735             _isApprovedOrOwner(_msgSender(), tokenId),
736             "ERC721: transfer caller is not owner nor approved"
737         );
738         _safeTransfer(from, to, tokenId, _data);
739     }
740 
741     function _safeTransfer(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes memory _data
746     ) internal virtual {
747         _transfer(from, to, tokenId);
748         require(
749             _checkOnERC721Received(from, to, tokenId, _data),
750             "ERC721: transfer to non ERC721Receiver implementer"
751         );
752     }
753 
754     function _exists(uint256 tokenId) internal view virtual returns (bool) {
755         return _owners[tokenId] != address(0);
756     }
757 
758     function _isApprovedOrOwner(address spender, uint256 tokenId)
759         internal
760         view
761         virtual
762         returns (bool)
763     {
764         require(
765             _exists(tokenId),
766             "ERC721: operator query for nonexistent token"
767         );
768         address owner = ERC721.ownerOf(tokenId);
769         return (spender == owner ||
770             getApproved(tokenId) == spender ||
771             isApprovedForAll(owner, spender));
772     }
773 
774     function _safeMint(address to, uint256 tokenId) internal virtual {
775         _safeMint(to, tokenId, "");
776     }
777 
778     function _safeMint(
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) internal virtual {
783         _mint(to, tokenId);
784         require(
785             _checkOnERC721Received(address(0), to, tokenId, _data),
786             "ERC721: transfer to non ERC721Receiver implementer"
787         );
788     }
789 
790     function _mint(address to, uint256 tokenId) internal virtual {
791         require(to != address(0), "ERC721: mint to the zero address");
792         require(!_exists(tokenId), "ERC721: token already minted");
793 
794         _beforeTokenTransfer(address(0), to, tokenId);
795 
796         _balances[to] += 1;
797         _owners[tokenId] = to;
798 
799         emit Transfer(address(0), to, tokenId);
800     }
801 
802     function _burn(uint256 tokenId) internal virtual {
803         address owner = ERC721.ownerOf(tokenId);
804 
805         _beforeTokenTransfer(owner, address(0), tokenId);
806 
807         // Clear approvals
808         _approve(address(0), tokenId);
809 
810         _balances[owner] -= 1;
811         delete _owners[tokenId];
812 
813         emit Transfer(owner, address(0), tokenId);
814     }
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 tokenId
820     ) internal virtual {
821         require(
822             ERC721.ownerOf(tokenId) == from,
823             "ERC721: transfer of token that is not own"
824         );
825         require(to != address(0), "ERC721: transfer to the zero address");
826 
827         _beforeTokenTransfer(from, to, tokenId);
828 
829         _approve(address(0), tokenId);
830 
831         _balances[from] -= 1;
832         _balances[to] += 1;
833         _owners[tokenId] = to;
834 
835         emit Transfer(from, to, tokenId);
836     }
837 
838     function _approve(address to, uint256 tokenId) internal virtual {
839         _tokenApprovals[tokenId] = to;
840         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
841     }
842 
843     function _checkOnERC721Received(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) private returns (bool) {
849         if (to.isContract()) {
850             try
851                 IERC721Receiver(to).onERC721Received(
852                     _msgSender(),
853                     from,
854                     tokenId,
855                     _data
856                 )
857             returns (bytes4 retval) {
858                 return retval == IERC721Receiver.onERC721Received.selector;
859             } catch (bytes memory reason) {
860                 if (reason.length == 0) {
861                     revert(
862                         "ERC721: transfer to non ERC721Receiver implementer"
863                     );
864                 } else {
865                     assembly {
866                         revert(add(32, reason), mload(reason))
867                     }
868                 }
869             }
870         } else {
871             return true;
872         }
873     }
874 
875     function _beforeTokenTransfer(
876         address from,
877         address to,
878         uint256 tokenId
879     ) internal virtual {}
880 }
881 
882 abstract contract ERC721URIStorage is ERC721 {
883     using Strings for uint256;
884 
885     mapping(uint256 => string) private _tokenURIs;
886 
887     function tokenURI(uint256 tokenId)
888         public
889         view
890         virtual
891         override
892         returns (string memory)
893     {
894         require(
895             _exists(tokenId),
896             "ERC721URIStorage: URI query for nonexistent token"
897         );
898 
899         string memory _tokenURI = _tokenURIs[tokenId];
900         string memory base = _baseURI();
901 
902         if (bytes(base).length == 0) {
903             return _tokenURI;
904         }
905         if (bytes(_tokenURI).length > 0) {
906             return string(abi.encodePacked(base, _tokenURI));
907         }
908 
909         return super.tokenURI(tokenId);
910     }
911 
912     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
913         internal
914         virtual
915     {
916         require(
917             _exists(tokenId),
918             "ERC721URIStorage: URI set of nonexistent token"
919         );
920         _tokenURIs[tokenId] = _tokenURI;
921     }
922 
923     function _burn(uint256 tokenId) internal virtual override {
924         super._burn(tokenId);
925 
926         if (bytes(_tokenURIs[tokenId]).length != 0) {
927             delete _tokenURIs[tokenId];
928         }
929     }
930 }
931 
932 interface IAccessControl {
933     event RoleAdminChanged(
934         bytes32 indexed role,
935         bytes32 indexed previousAdminRole,
936         bytes32 indexed newAdminRole
937     );
938 
939     event RoleGranted(
940         bytes32 indexed role,
941         address indexed account,
942         address indexed sender
943     );
944 
945     event RoleRevoked(
946         bytes32 indexed role,
947         address indexed account,
948         address indexed sender
949     );
950 
951     function hasRole(bytes32 role, address account)
952         external
953         view
954         returns (bool);
955 
956     function getRoleAdmin(bytes32 role) external view returns (bytes32);
957 
958     function grantRole(bytes32 role, address account) external;
959 
960     function revokeRole(bytes32 role, address account) external;
961 
962     function renounceRole(bytes32 role, address account) external;
963 }
964 
965 abstract contract AccessControl is Context, IAccessControl, ERC165 {
966     struct RoleData {
967         mapping(address => bool) members;
968         bytes32 adminRole;
969     }
970 
971     mapping(bytes32 => RoleData) private _roles;
972 
973     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
974 
975     modifier onlyRole(bytes32 role) {
976         _checkRole(role, _msgSender());
977         _;
978     }
979 
980     function supportsInterface(bytes4 interfaceId)
981         public
982         view
983         virtual
984         override
985         returns (bool)
986     {
987         return
988             interfaceId == type(IAccessControl).interfaceId ||
989             super.supportsInterface(interfaceId);
990     }
991 
992     function hasRole(bytes32 role, address account)
993         public
994         view
995         override
996         returns (bool)
997     {
998         return _roles[role].members[account];
999     }
1000 
1001     function _checkRole(bytes32 role, address account) internal view {
1002         if (!hasRole(role, account)) {
1003             revert(
1004                 string(
1005                     abi.encodePacked(
1006                         "AccessControl: account ",
1007                         Strings.toHexString(uint160(account), 20),
1008                         " is missing role ",
1009                         Strings.toHexString(uint256(role), 32)
1010                     )
1011                 )
1012             );
1013         }
1014     }
1015 
1016     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1017         return _roles[role].adminRole;
1018     }
1019 
1020     function grantRole(bytes32 role, address account)
1021         public
1022         virtual
1023         override
1024         onlyRole(getRoleAdmin(role))
1025     {
1026         _grantRole(role, account);
1027     }
1028 
1029     function revokeRole(bytes32 role, address account)
1030         public
1031         virtual
1032         override
1033         onlyRole(getRoleAdmin(role))
1034     {
1035         _revokeRole(role, account);
1036     }
1037 
1038     function renounceRole(bytes32 role, address account)
1039         public
1040         virtual
1041         override
1042     {
1043         require(
1044             account == _msgSender(),
1045             "AccessControl: can only renounce roles for self"
1046         );
1047 
1048         _revokeRole(role, account);
1049     }
1050 
1051     function _setupRole(bytes32 role, address account) internal virtual {
1052         _grantRole(role, account);
1053     }
1054 
1055     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1056         bytes32 previousAdminRole = getRoleAdmin(role);
1057         _roles[role].adminRole = adminRole;
1058         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1059     }
1060 
1061     function _grantRole(bytes32 role, address account) private {
1062         if (!hasRole(role, account)) {
1063             _roles[role].members[account] = true;
1064             emit RoleGranted(role, account, _msgSender());
1065         }
1066     }
1067 
1068     function _revokeRole(bytes32 role, address account) private {
1069         if (hasRole(role, account)) {
1070             _roles[role].members[account] = false;
1071             emit RoleRevoked(role, account, _msgSender());
1072         }
1073     }
1074 }
1075 
1076 contract MferCribs is ERC721URIStorage, Ownable, AccessControl {
1077     using SafeMath for uint256;
1078 
1079     bytes32 public constant PRE_SALE_ROLE = keccak256("PRE_SALE_ROLE");
1080     string private contractUri;
1081     string private baseUri;
1082     uint8 private platformRoyalty;
1083     mapping(uint256 => uint256) tokenSalePrices;
1084     event TokenSold(
1085         uint256 tokenId,
1086         address from,
1087         address to,
1088         uint256 price,
1089         uint256 royaltyPaid
1090     );
1091 
1092     bool public saleIsActive = false;
1093     uint256 public MAX_MINT;
1094     uint256 public constant apePrice = 22000000000000000; //0.022 ETH
1095     uint256 public constant maxApePurchase = 8888;
1096     uint256 public totalMintNumber;
1097 
1098     function totalSupply() public view returns (uint256) {
1099         return totalMintNumber;
1100     }
1101 
1102     function supportsInterface(bytes4 interfaceId)
1103         public
1104         view
1105         virtual
1106         override(ERC721, AccessControl)
1107         returns (bool)
1108     {
1109         return super.supportsInterface(interfaceId);
1110     }
1111 
1112     constructor() ERC721("Mfer Cribs", "MferCribs") {
1113       
1114         contractUri = "http://nft-stage-bwrld.s3-website.us-east-2.amazonaws.com/contract";
1115         baseUri = "http://nft-stage-bwrld.s3-website.us-east-2.amazonaws.com/ipfs/";
1116 
1117         MAX_MINT = 8888;
1118 
1119         totalMintNumber = 0;
1120         platformRoyalty = 5;
1121 
1122         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1123     }
1124 
1125     function contractURI() public view returns (string memory) {
1126         return contractUri;
1127     }
1128 
1129     function setContractUri(string memory newUri) public onlyOwner {
1130         contractUri = newUri;
1131     }
1132 
1133     function _baseURI() internal view override returns (string memory) {
1134         return baseUri;
1135     }
1136 
1137     function setBaseUri(string memory newUri) public onlyOwner {
1138         baseUri = newUri;
1139     }
1140 
1141     function withdraw() public onlyOwner {
1142         uint amount = address(this).balance;
1143 
1144         (bool success, ) = owner().call{value: amount}("");
1145         require(success, "Failed to send Ether");
1146     }
1147 
1148     function platformFee() public view returns (uint8) {
1149         return platformRoyalty;
1150     }
1151 
1152     function setPlatformFee(uint8 newFee) public onlyOwner {
1153         platformRoyalty = newFee;
1154     }
1155 
1156     function mintNFT(uint256 numberOfTokens) public payable {
1157         require(saleIsActive, "Sale must be active to mint");
1158         require(
1159             numberOfTokens <= maxApePurchase,
1160             "Can only mint x tokens at a time"
1161         );
1162         require(
1163             totalSupply().add(numberOfTokens) <= MAX_MINT,
1164             "Purchase would exceed max supply"
1165         );
1166         require(
1167             apePrice.mul(numberOfTokens) <= msg.value,
1168             "Ether value sent is not correct"
1169         );
1170 
1171         for (uint256 i = 0; i < numberOfTokens; i++) {
1172             uint256 mintIndex = totalSupply();
1173             if (totalSupply() < MAX_MINT) {
1174                 require(!_exists(mintIndex), "Has already been minted");
1175                 totalMintNumber = totalMintNumber + 1;
1176                 _mint(msg.sender, mintIndex);
1177             }
1178         }
1179     }
1180 
1181     /*
1182      * Pause sale if active, make active if paused
1183      */
1184     function flipSaleState() public onlyOwner {
1185         saleIsActive = !saleIsActive;
1186     }
1187 
1188     function isApprovedForAll(address _owner, address _operator)
1189         public
1190         view
1191         override
1192         returns (bool isOperator)
1193     {
1194         // Whitelist OpenSea proxy contract for easy trading.
1195 
1196         return isApprovedForAll(_owner, _operator);
1197     }
1198 
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal override {
1204         super._beforeTokenTransfer(from, to, tokenId);
1205         if (tokenSalePrices[tokenId] > 0) {
1206             tokenSalePrices[tokenId] = 0;
1207         }
1208     }
1209 }