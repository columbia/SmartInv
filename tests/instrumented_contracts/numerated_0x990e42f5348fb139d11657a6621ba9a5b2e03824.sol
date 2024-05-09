1 // File: contracts/GalacticTigerz.sol
2 
3 
4 
5 // File: @openzeppelin/contracts/utils/Counters.sol
6 
7 
8 
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
12 
13 
14 
15 pragma solidity >=0.7.0 <0.9.0;
16 
17 
18 
19 library Counters {
20 
21     struct Counter {
22 
23 
24 
25         uint256 _value; // default: 0
26 
27     }
28 
29 
30 
31     function current(Counter storage counter) internal view returns (uint256) {
32 
33         return counter._value;
34 
35     }
36 
37 
38 
39     function increment(Counter storage counter) internal {
40 
41         unchecked {
42 
43             counter._value += 1;
44 
45         }
46 
47     }
48 
49 
50 
51     function decrement(Counter storage counter) internal {
52 
53         uint256 value = counter._value;
54 
55         require(value > 0, "Counter: decrement overflow");
56 
57         unchecked {
58 
59             counter._value = value - 1;
60 
61         }
62 
63     }
64 
65 
66 
67     function reset(Counter storage counter) internal {
68 
69         counter._value = 0;
70 
71     }
72 
73 }
74 
75 
76 
77 
78 
79 
80 
81 pragma solidity >=0.7.0 <0.9.0;
82 
83 
84 
85 /**
86 
87  * @dev String operations.
88 
89  */
90 
91 library Strings {
92 
93     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
94 
95 
96 
97     /**
98 
99      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
100 
101      */
102 
103     function toString(uint256 value) internal pure returns (string memory) {
104 
105 
106 
107 
108 
109         if (value == 0) {
110 
111             return "0";
112 
113         }
114 
115         uint256 temp = value;
116 
117         uint256 digits;
118 
119         while (temp != 0) {
120 
121             digits++;
122 
123             temp /= 10;
124 
125         }
126 
127         bytes memory buffer = new bytes(digits);
128 
129         while (value != 0) {
130 
131             digits -= 1;
132 
133             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
134 
135             value /= 10;
136 
137         }
138 
139         return string(buffer);
140 
141     }
142 
143 
144 
145     /**
146 
147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
148 
149      */
150 
151     function toHexString(uint256 value) internal pure returns (string memory) {
152 
153         if (value == 0) {
154 
155             return "0x00";
156 
157         }
158 
159         uint256 temp = value;
160 
161         uint256 length = 0;
162 
163         while (temp != 0) {
164 
165             length++;
166 
167             temp >>= 8;
168 
169         }
170 
171         return toHexString(value, length);
172 
173     }
174 
175 
176 
177     /**
178 
179      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
180 
181      */
182 
183     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
184 
185         bytes memory buffer = new bytes(2 * length + 2);
186 
187         buffer[0] = "0";
188 
189         buffer[1] = "x";
190 
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192 
193             buffer[i] = _HEX_SYMBOLS[value & 0xf];
194 
195             value >>= 4;
196 
197         }
198 
199         require(value == 0, "Strings: hex length insufficient");
200 
201         return string(buffer);
202 
203     }
204 
205 }
206 
207 
208 
209 // File: @openzeppelin/contracts/utils/Context.sol
210 
211 
212 
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
216 
217 
218 
219 pragma solidity >=0.7.0 <0.9.0;
220 
221 
222 
223 abstract contract Context {
224 
225     function _msgSender() internal view virtual returns (address) {
226 
227         return msg.sender;
228 
229     }
230 
231 
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234 
235         return msg.data;
236 
237     }
238 
239 }
240 
241 
242 
243 // File: @openzeppelin/contracts/access/Ownable.sol
244 
245 
246 
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
250 
251 
252 
253 pragma solidity >=0.7.0 <0.9.0;
254 
255 
256 
257 
258 
259 abstract contract Ownable is Context {
260 
261     address private _owner;
262 
263 
264 
265     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
266 
267 
268 
269     /**
270 
271      * @dev Initializes the contract setting the deployer as the initial owner.
272 
273      */
274 
275     constructor() {
276 
277         _transferOwnership(_msgSender());
278 
279     }
280 
281 
282 
283     /**
284 
285      * @dev Returns the address of the current owner.
286 
287      */
288 
289     function owner() public view virtual returns (address) {
290 
291         return _owner;
292 
293     }
294 
295 
296 
297     /**
298 
299      * @dev Throws if called by any account other than the owner.
300 
301      */
302 
303     modifier onlyOwner() {
304 
305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
306 
307         _;
308 
309     }
310 
311 
312 
313     function renounceOwnership() public virtual onlyOwner {
314 
315         _transferOwnership(address(0));
316 
317     }
318 
319 
320 
321     /**
322 
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324 
325      * Can only be called by the current owner.
326 
327      */
328 
329     function transferOwnership(address newOwner) public virtual onlyOwner {
330 
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332 
333         _transferOwnership(newOwner);
334 
335     }
336 
337 
338 
339     function _transferOwnership(address newOwner) internal virtual {
340 
341         address oldOwner = _owner;
342 
343         _owner = newOwner;
344 
345         emit OwnershipTransferred(oldOwner, newOwner);
346 
347     }
348 
349 }
350 
351 
352 
353 // File: @openzeppelin/contracts/utils/Address.sol
354 
355 
356 
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
360 
361 
362 
363 pragma solidity >=0.7.0 <0.9.0;
364 
365 
366 
367 /**
368 
369  * @dev Collection of functions related to the address type
370 
371  */
372 
373 library Address {
374 
375 
376 
377     function isContract(address account) internal view returns (bool) {
378 
379 
380 
381 
382 
383         uint256 size;
384 
385         assembly {
386 
387             size := extcodesize(account)
388 
389         }
390 
391         return size > 0;
392 
393     }
394 
395 
396 
397     function sendValue(address payable recipient, uint256 amount) internal {
398 
399         require(address(this).balance >= amount, "Address: insufficient balance");
400 
401 
402 
403         (bool success, ) = recipient.call{value: amount}("");
404 
405         require(success, "Address: unable to send value, recipient may have reverted");
406 
407     }
408 
409 
410 
411 
412 
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414 
415         return functionCall(target, data, "Address: low-level call failed");
416 
417     }
418 
419 
420 
421     /**
422 
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424 
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426 
427      *
428 
429      * _Available since v3.1._
430 
431      */
432 
433     function functionCall(
434 
435         address target,
436 
437         bytes memory data,
438 
439         string memory errorMessage
440 
441     ) internal returns (bytes memory) {
442 
443         return functionCallWithValue(target, data, 0, errorMessage);
444 
445     }
446 
447 
448 
449 
450 
451     function functionCallWithValue(
452 
453         address target,
454 
455         bytes memory data,
456 
457         uint256 value
458 
459     ) internal returns (bytes memory) {
460 
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462 
463     }
464 
465 
466 
467     function functionCallWithValue(
468 
469         address target,
470 
471         bytes memory data,
472 
473         uint256 value,
474 
475         string memory errorMessage
476 
477     ) internal returns (bytes memory) {
478 
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480 
481         require(isContract(target), "Address: call to non-contract");
482 
483 
484 
485         (bool success, bytes memory returndata) = target.call{value: value}(data);
486 
487         return verifyCallResult(success, returndata, errorMessage);
488 
489     }
490 
491 
492 
493 
494 
495     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
496 
497         return functionStaticCall(target, data, "Address: low-level static call failed");
498 
499     }
500 
501 
502 
503  
504 
505     function functionStaticCall(
506 
507         address target,
508 
509         bytes memory data,
510 
511         string memory errorMessage
512 
513     ) internal view returns (bytes memory) {
514 
515         require(isContract(target), "Address: static call to non-contract");
516 
517 
518 
519         (bool success, bytes memory returndata) = target.staticcall(data);
520 
521         return verifyCallResult(success, returndata, errorMessage);
522 
523     }
524 
525 
526 
527 
528 
529     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
530 
531         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
532 
533     }
534 
535 
536 
537   
538 
539     function functionDelegateCall(
540 
541         address target,
542 
543         bytes memory data,
544 
545         string memory errorMessage
546 
547     ) internal returns (bytes memory) {
548 
549         require(isContract(target), "Address: delegate call to non-contract");
550 
551 
552 
553         (bool success, bytes memory returndata) = target.delegatecall(data);
554 
555         return verifyCallResult(success, returndata, errorMessage);
556 
557     }
558 
559 
560 
561  
562 
563     function verifyCallResult(
564 
565         bool success,
566 
567         bytes memory returndata,
568 
569         string memory errorMessage
570 
571     ) internal pure returns (bytes memory) {
572 
573         if (success) {
574 
575             return returndata;
576 
577         } else {
578 
579             // Look for revert reason and bubble it up if present
580 
581             if (returndata.length > 0) {
582 
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585 
586 
587                 assembly {
588 
589                     let returndata_size := mload(returndata)
590 
591                     revert(add(32, returndata), returndata_size)
592 
593                 }
594 
595             } else {
596 
597                 revert(errorMessage);
598 
599             }
600 
601         }
602 
603     }
604 
605 }
606 
607 
608 
609 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
610 
611 
612 
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
616 
617 
618 
619 pragma solidity >=0.7.0 <0.9.0;
620 
621 
622 
623 interface IERC721Receiver {
624 
625 
626 
627     function onERC721Received(
628 
629         address operator,
630 
631         address from,
632 
633         uint256 tokenId,
634 
635         bytes calldata data
636 
637     ) external returns (bytes4);
638 
639 }
640 
641 
642 
643 
644 
645 
646 
647 pragma solidity >=0.7.0 <0.9.0;
648 
649 
650 
651 
652 
653 interface IERC165 {
654 
655 
656 
657     function supportsInterface(bytes4 interfaceId) external view returns (bool);
658 
659 }
660 
661 
662 
663 
664 
665 pragma solidity >=0.7.0 <0.9.0;
666 
667 
668 
669 
670 
671 abstract contract ERC165 is IERC165 {
672 
673     /**
674 
675      * @dev See {IERC165-supportsInterface}.
676 
677      */
678 
679     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
680 
681         return interfaceId == type(IERC165).interfaceId;
682 
683     }
684 
685 }
686 
687 
688 
689 
690 
691 
692 
693 pragma solidity >=0.7.0 <0.9.0;
694 
695 
696 
697 
698 
699 /**
700 
701  * @dev Required interface of an ERC721 compliant contract.
702 
703  */
704 
705 interface IERC721 is IERC165 {
706 
707     /**
708 
709      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
710 
711      */
712 
713     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
714 
715 
716 
717     /**
718 
719      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
720 
721      */
722 
723     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
724 
725 
726 
727     /**
728 
729      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
730 
731      */
732 
733     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
734 
735 
736 
737     /**
738 
739      * @dev Returns the number of tokens in ``owner``'s account.
740 
741      */
742 
743     function balanceOf(address owner) external view returns (uint256 balance);
744 
745 
746 
747     function ownerOf(uint256 tokenId) external view returns (address owner);
748 
749 
750 
751     function safeTransferFrom(
752 
753         address from,
754 
755         address to,
756 
757         uint256 tokenId
758 
759     ) external;
760 
761 
762 
763 
764 
765     function transferFrom(
766 
767         address from,
768 
769         address to,
770 
771         uint256 tokenId
772 
773     ) external;
774 
775 
776 
777 
778 
779     function approve(address to, uint256 tokenId) external;
780 
781 
782 
783 
784 
785     function getApproved(uint256 tokenId) external view returns (address operator);
786 
787 
788 
789     function setApprovalForAll(address operator, bool _approved) external;
790 
791 
792 
793     function isApprovedForAll(address owner, address operator) external view returns (bool);
794 
795 
796 
797     
798 
799     function safeTransferFrom(
800 
801         address from,
802 
803         address to,
804 
805         uint256 tokenId,
806 
807         bytes calldata data
808 
809     ) external;
810 
811 }
812 
813 
814 
815 
816 
817 
818 
819 pragma solidity >=0.7.0 <0.9.0;
820 
821 
822 
823 
824 
825 
826 
827 interface IERC721Metadata is IERC721 {
828 
829     /**
830 
831      * @dev Returns the token collection name.
832 
833      */
834 
835     function name() external view returns (string memory);
836 
837 
838 
839     /**
840 
841      * @dev Returns the token collection symbol.
842 
843      */
844 
845     function symbol() external view returns (string memory);
846 
847 
848 
849     /**
850 
851      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
852 
853      */
854 
855     function tokenURI(uint256 tokenId) external view returns (string memory);
856 
857 }
858 
859 
860 
861 
862 
863 pragma solidity >=0.7.0 <0.9.0;
864 
865 
866 
867 
868 
869 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
870 
871     using Address for address;
872 
873     using Strings for uint256;
874 
875 
876 
877     // Token name
878 
879     string private _name;
880 
881 
882 
883     // Token symbol
884 
885     string private _symbol;
886 
887 
888 
889     // Mapping from token ID to owner address
890 
891     mapping(uint256 => address) private _owners;
892 
893 
894 
895     // Mapping owner address to token count
896 
897     mapping(address => uint256) private _balances;
898 
899 
900 
901     // Mapping from token ID to approved address
902 
903     mapping(uint256 => address) private _tokenApprovals;
904 
905 
906 
907     // Mapping from owner to operator approvals
908 
909     mapping(address => mapping(address => bool)) private _operatorApprovals;
910 
911 
912 
913     /**
914 
915      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
916 
917      */
918 
919     constructor(string memory name_, string memory symbol_) {
920 
921         _name = name_;
922 
923         _symbol = symbol_;
924 
925     }
926 
927 
928 
929     /**
930 
931      * @dev See {IERC165-supportsInterface}.
932 
933      */
934 
935     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
936 
937         return
938 
939             interfaceId == type(IERC721).interfaceId ||
940 
941             interfaceId == type(IERC721Metadata).interfaceId ||
942 
943             super.supportsInterface(interfaceId);
944 
945     }
946 
947 
948 
949     /**
950 
951      * @dev See {IERC721-balanceOf}.
952 
953      */
954 
955     function balanceOf(address owner) public view virtual override returns (uint256) {
956 
957         require(owner != address(0), "ERC721: balance query for the zero address");
958 
959         return _balances[owner];
960 
961     }
962 
963 
964 
965     /**
966 
967      * @dev See {IERC721-ownerOf}.
968 
969      */
970 
971     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
972 
973         address owner = _owners[tokenId];
974 
975         require(owner != address(0), "ERC721: owner query for nonexistent token");
976 
977         return owner;
978 
979     }
980 
981 
982 
983     /**
984 
985      * @dev See {IERC721Metadata-name}.
986 
987      */
988 
989     function name() public view virtual override returns (string memory) {
990 
991         return _name;
992 
993     }
994 
995 
996 
997     /**
998 
999      * @dev See {IERC721Metadata-symbol}.
1000 
1001      */
1002 
1003     function symbol() public view virtual override returns (string memory) {
1004 
1005         return _symbol;
1006 
1007     }
1008 
1009 
1010 
1011     /**
1012 
1013      * @dev See {IERC721Metadata-tokenURI}.
1014 
1015      */
1016 
1017     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1018 
1019         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1020 
1021 
1022 
1023         string memory baseURI = _baseURI();
1024 
1025         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1026 
1027     }
1028 
1029 
1030 
1031 
1032 
1033     function _baseURI() internal view virtual returns (string memory) {
1034 
1035         return "";
1036 
1037     }
1038 
1039 
1040 
1041     /**
1042 
1043      * @dev See {IERC721-approve}.
1044 
1045      */
1046 
1047     function approve(address to, uint256 tokenId) public virtual override {
1048 
1049         address owner = ERC721.ownerOf(tokenId);
1050 
1051         require(to != owner, "ERC721: approval to current owner");
1052 
1053 
1054 
1055         require(
1056 
1057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1058 
1059             "ERC721: approve caller is not owner nor approved for all"
1060 
1061         );
1062 
1063 
1064 
1065         _approve(to, tokenId);
1066 
1067     }
1068 
1069 
1070 
1071     /**
1072 
1073      * @dev See {IERC721-getApproved}.
1074 
1075      */
1076 
1077     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1078 
1079         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1080 
1081 
1082 
1083         return _tokenApprovals[tokenId];
1084 
1085     }
1086 
1087 
1088 
1089     /**
1090 
1091      * @dev See {IERC721-setApprovalForAll}.
1092 
1093      */
1094 
1095     function setApprovalForAll(address operator, bool approved) public virtual override {
1096 
1097         _setApprovalForAll(_msgSender(), operator, approved);
1098 
1099     }
1100 
1101 
1102 
1103     /**
1104 
1105      * @dev See {IERC721-isApprovedForAll}.
1106 
1107      */
1108 
1109     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1110 
1111         return _operatorApprovals[owner][operator];
1112 
1113     }
1114 
1115 
1116 
1117     /**
1118 
1119      * @dev See {IERC721-transferFrom}.
1120 
1121      */
1122 
1123     function transferFrom(
1124 
1125         address from,
1126 
1127         address to,
1128 
1129         uint256 tokenId
1130 
1131     ) public virtual override {
1132 
1133         //solhint-disable-next-line max-line-length
1134 
1135         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1136 
1137 
1138 
1139         _transfer(from, to, tokenId);
1140 
1141     }
1142 
1143 
1144 
1145     /**
1146 
1147      * @dev See {IERC721-safeTransferFrom}.
1148 
1149      */
1150 
1151     function safeTransferFrom(
1152 
1153         address from,
1154 
1155         address to,
1156 
1157         uint256 tokenId
1158 
1159     ) public virtual override {
1160 
1161         safeTransferFrom(from, to, tokenId, "");
1162 
1163     }
1164 
1165 
1166 
1167     /**
1168 
1169      * @dev See {IERC721-safeTransferFrom}.
1170 
1171      */
1172 
1173     function safeTransferFrom(
1174 
1175         address from,
1176 
1177         address to,
1178 
1179         uint256 tokenId,
1180 
1181         bytes memory _data
1182 
1183     ) public virtual override {
1184 
1185         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1186 
1187         _safeTransfer(from, to, tokenId, _data);
1188 
1189     }
1190 
1191 
1192 
1193 
1194 
1195     function _safeTransfer(
1196 
1197         address from,
1198 
1199         address to,
1200 
1201         uint256 tokenId,
1202 
1203         bytes memory _data
1204 
1205     ) internal virtual {
1206 
1207         _transfer(from, to, tokenId);
1208 
1209         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1210 
1211     }
1212 
1213 
1214 
1215 
1216 
1217     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1218 
1219         return _owners[tokenId] != address(0);
1220 
1221     }
1222 
1223 
1224 
1225 
1226 
1227     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1228 
1229         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1230 
1231         address owner = ERC721.ownerOf(tokenId);
1232 
1233         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1234 
1235     }
1236 
1237 
1238 
1239 
1240 
1241     function _safeMint(address to, uint256 tokenId) internal virtual {
1242 
1243         _safeMint(to, tokenId, "");
1244 
1245     }
1246 
1247 
1248 
1249   
1250 
1251     function _safeMint(
1252 
1253         address to,
1254 
1255         uint256 tokenId,
1256 
1257         bytes memory _data
1258 
1259     ) internal virtual {
1260 
1261         _mint(to, tokenId);
1262 
1263         require(
1264 
1265             _checkOnERC721Received(address(0), to, tokenId, _data),
1266 
1267             "ERC721: transfer to non ERC721Receiver implementer"
1268 
1269         );
1270 
1271     }
1272 
1273 
1274 
1275 
1276 
1277     function _mint(address to, uint256 tokenId) internal virtual {
1278 
1279         require(to != address(0), "ERC721: mint to the zero address");
1280 
1281         require(!_exists(tokenId), "ERC721: token already minted");
1282 
1283 
1284 
1285         _beforeTokenTransfer(address(0), to, tokenId);
1286 
1287 
1288 
1289         _balances[to] += 1;
1290 
1291         _owners[tokenId] = to;
1292 
1293 
1294 
1295         emit Transfer(address(0), to, tokenId);
1296 
1297     }
1298 
1299 
1300 
1301     function _burn(uint256 tokenId) internal virtual {
1302 
1303         address owner = ERC721.ownerOf(tokenId);
1304 
1305 
1306 
1307         _beforeTokenTransfer(owner, address(0), tokenId);
1308 
1309 
1310 
1311         // Clear approvals
1312 
1313         _approve(address(0), tokenId);
1314 
1315 
1316 
1317         _balances[owner] -= 1;
1318 
1319         delete _owners[tokenId];
1320 
1321 
1322 
1323         emit Transfer(owner, address(0), tokenId);
1324 
1325     }
1326 
1327 
1328 
1329 
1330 
1331     function _transfer(
1332 
1333         address from,
1334 
1335         address to,
1336 
1337         uint256 tokenId
1338 
1339     ) internal virtual {
1340 
1341         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1342 
1343         require(to != address(0), "ERC721: transfer to the zero address");
1344 
1345 
1346 
1347         _beforeTokenTransfer(from, to, tokenId);
1348 
1349 
1350 
1351         // Clear approvals from the previous owner
1352 
1353         _approve(address(0), tokenId);
1354 
1355 
1356 
1357         _balances[from] -= 1;
1358 
1359         _balances[to] += 1;
1360 
1361         _owners[tokenId] = to;
1362 
1363 
1364 
1365         emit Transfer(from, to, tokenId);
1366 
1367     }
1368 
1369 
1370 
1371 
1372 
1373     function _approve(address to, uint256 tokenId) internal virtual {
1374 
1375         _tokenApprovals[tokenId] = to;
1376 
1377         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1378 
1379     }
1380 
1381 
1382 
1383 
1384 
1385     function _setApprovalForAll(
1386 
1387         address owner,
1388 
1389         address operator,
1390 
1391         bool approved
1392 
1393     ) internal virtual {
1394 
1395         require(owner != operator, "ERC721: approve to caller");
1396 
1397         _operatorApprovals[owner][operator] = approved;
1398 
1399         emit ApprovalForAll(owner, operator, approved);
1400 
1401     }
1402 
1403 
1404 
1405 
1406 
1407     function _checkOnERC721Received(
1408 
1409         address from,
1410 
1411         address to,
1412 
1413         uint256 tokenId,
1414 
1415         bytes memory _data
1416 
1417     ) private returns (bool) {
1418 
1419         if (to.isContract()) {
1420 
1421             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1422 
1423                 return retval == IERC721Receiver.onERC721Received.selector;
1424 
1425             } catch (bytes memory reason) {
1426 
1427                 if (reason.length == 0) {
1428 
1429                     revert("ERC721: transfer to non ERC721Receiver implementer");
1430 
1431                 } else {
1432 
1433                     assembly {
1434 
1435                         revert(add(32, reason), mload(reason))
1436 
1437                     }
1438 
1439                 }
1440 
1441             }
1442 
1443         } else {
1444 
1445             return true;
1446 
1447         }
1448 
1449     }
1450 
1451 
1452 
1453 
1454 
1455     function _beforeTokenTransfer(
1456 
1457         address from,
1458 
1459         address to,
1460 
1461         uint256 tokenId
1462 
1463     ) internal virtual {}
1464 
1465 }
1466 
1467 
1468 
1469 
1470 
1471 // File: contracts/GalacticTigerz.sol
1472 
1473 
1474 
1475 
1476 
1477 
1478 
1479 pragma solidity >=0.7.0 <0.9.0;
1480 
1481 
1482 
1483 contract GalacticTigerz is ERC721, Ownable {
1484 
1485   using Strings for uint256;
1486 
1487   using Counters for Counters.Counter;
1488 
1489 
1490 
1491   Counters.Counter private supply;
1492 
1493 
1494 
1495   string public uriPrefix = "";
1496 
1497   string public uriSuffix = ".json";
1498 
1499   string public hiddenMetadataUri;
1500 
1501   
1502 
1503   uint256 public cost = 0.098 ether;
1504 
1505   uint256 public maxSupply = 444;
1506 
1507   uint256 public maxMintAmountPerTx = 1;
1508 
1509   uint256 public nftPerAddressLimit = 1;
1510 
1511 
1512 
1513   bool public paused = true;
1514 
1515   bool public onlyWhitelisted = true;
1516 
1517   bool public allowlist = true;
1518 
1519   bool public revealed = false;
1520 
1521 
1522 
1523   address[] public whitelistedAddresses ;
1524 
1525   mapping(address => uint256) public addressMintedBalance;
1526 
1527 
1528 
1529   constructor() ERC721("Galactic Tigerz", "GT") {
1530 
1531     setHiddenMetadataUri("ipfs://Qmb568Dcm7HRJYv1esXKj753W1rkCJB8Nhb7fYKxtFwgdz/hidden.json");
1532 
1533   }
1534 
1535 
1536 
1537   modifier mintCompliance(uint256 _mintAmount) {
1538 
1539     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1540 
1541     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1542 
1543     _;
1544 
1545   }
1546 
1547 
1548 
1549   function totalSupply() public view returns (uint256) {
1550 
1551     return supply.current();
1552 
1553   }
1554 
1555 
1556 
1557   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1558 
1559     require(!paused, "The contract is paused!");
1560 
1561     require(!onlyWhitelisted, "Only Whitelisted members can mint!");
1562 
1563     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1564 
1565 
1566 
1567     _mintLoop(msg.sender, _mintAmount);
1568 
1569   }
1570 
1571 
1572 
1573   function WhiteListMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1574 
1575     require(!paused, "The contract is paused!");
1576 
1577     //require(onlyWhitelisted, "Public mint started!");
1578 
1579     require(isWhitelisted(msg.sender), "user is not whitelisted");
1580 
1581     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1582 
1583 
1584 
1585     _mintLoop(msg.sender, _mintAmount);
1586 
1587   }
1588 
1589   
1590 
1591   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1592 
1593     _mintLoop2(_receiver, _mintAmount);
1594 
1595   }
1596 
1597 
1598 
1599   function isWhitelisted(address _user) public view returns (bool) {
1600 
1601     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1602 
1603       if (whitelistedAddresses[i] == _user) {
1604 
1605           return true;
1606 
1607       }
1608 
1609     }
1610 
1611     return false;
1612 
1613   }
1614 
1615 
1616 
1617   function walletOfOwner(address _owner)
1618 
1619     public
1620 
1621     view
1622 
1623     returns (uint256[] memory)
1624 
1625   {
1626 
1627     uint256 ownerTokenCount = balanceOf(_owner);
1628 
1629     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1630 
1631     uint256 currentTokenId = 1;
1632 
1633     uint256 ownedTokenIndex = 0;
1634 
1635 
1636 
1637     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1638 
1639       address currentTokenOwner = ownerOf(currentTokenId);
1640 
1641 
1642 
1643       if (currentTokenOwner == _owner) {
1644 
1645         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1646 
1647 
1648 
1649         ownedTokenIndex++;
1650 
1651       }
1652 
1653 
1654 
1655       currentTokenId++;
1656 
1657     }
1658 
1659 
1660 
1661     return ownedTokenIds;
1662 
1663   }
1664 
1665 
1666 
1667   function tokenURI(uint256 _tokenId)
1668 
1669     public
1670 
1671     view
1672 
1673     virtual
1674 
1675     override
1676 
1677     returns (string memory)
1678 
1679   {
1680 
1681     require(
1682 
1683       _exists(_tokenId),
1684 
1685       "ERC721Metadata: URI query for nonexistent token"
1686 
1687     );
1688 
1689 
1690 
1691     if (revealed == false) {
1692 
1693       return hiddenMetadataUri;
1694 
1695     }
1696 
1697 
1698 
1699     string memory currentBaseURI = _baseURI();
1700 
1701     return bytes(currentBaseURI).length > 0
1702 
1703         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1704 
1705         : "";
1706 
1707   }
1708 
1709 
1710 
1711   function setRevealed(bool _state) public onlyOwner {
1712 
1713     revealed = _state;
1714 
1715   }
1716 
1717 
1718 
1719   function setCost(uint256 _cost) public onlyOwner {
1720 
1721     cost = _cost;
1722 
1723   }
1724 
1725 
1726 
1727   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1728 
1729     maxMintAmountPerTx = _maxMintAmountPerTx;
1730 
1731   }
1732 
1733 
1734 
1735   function setnftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1736 
1737     nftPerAddressLimit = _nftPerAddressLimit;
1738 
1739   }
1740 
1741 
1742 
1743   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1744 
1745     hiddenMetadataUri = _hiddenMetadataUri;
1746 
1747   }
1748 
1749 
1750 
1751   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1752 
1753     uriPrefix = _uriPrefix;
1754 
1755   }
1756 
1757 
1758 
1759   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1760 
1761     uriSuffix = _uriSuffix;
1762 
1763   }
1764 
1765 
1766 
1767   function setPaused(bool _state) public onlyOwner {
1768 
1769     paused = _state;
1770 
1771   }
1772 
1773 
1774 
1775   function setOnlyWhitelisted(bool _state) public onlyOwner {
1776 
1777     onlyWhitelisted = _state;
1778 
1779   }
1780 
1781   function setAllowList() public onlyOwner {
1782 
1783       allowlist = false;
1784 
1785   }
1786 
1787 
1788 
1789   function whitelistUsers(address[] calldata _users) public onlyOwner {
1790 
1791     delete whitelistedAddresses;
1792 
1793     whitelistedAddresses = _users;
1794 
1795   }
1796 
1797 
1798 
1799 
1800 
1801   function withdraw() public onlyOwner {
1802 
1803     // =============================================================================
1804 
1805     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1806 
1807     require(os);
1808 
1809     // =============================================================================
1810 
1811   }
1812 
1813 
1814 
1815   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1816 
1817 
1818 
1819     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1820 
1821     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1822 
1823     
1824 
1825     for (uint256 i = 0; i < _mintAmount; i++) {
1826 
1827       supply.increment();
1828 
1829       addressMintedBalance[msg.sender]++;
1830 
1831       _safeMint(_receiver, supply.current());
1832 
1833     }
1834 
1835   }
1836 
1837 
1838 
1839   function _mintLoop2(address _receiver, uint256 _mintAmount) internal {
1840 
1841     for (uint256 i = 0; i < _mintAmount; i++) {
1842 
1843       supply.increment();
1844 
1845       _safeMint(_receiver, supply.current());
1846 
1847     }
1848 
1849   }
1850 
1851 
1852 
1853   function _baseURI() internal view virtual override returns (string memory) {
1854 
1855     return uriPrefix;
1856 
1857   }
1858 
1859 }