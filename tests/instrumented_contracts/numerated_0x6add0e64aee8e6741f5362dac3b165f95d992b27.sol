1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 /**
6 
7     !Disclaimer!
8 
9     These contracts have been used to create tutorials,
10 
11     and was created for the purpose to teach people
12 
13     how to create smart contracts on the blockchain.
14 
15     please review this code on your own before using any of
16 
17     the following code for production.
18 
19     HashLips will not be liable in any way if for the use 
20 
21     of the code. That being said, the code has been tested 
22 
23     to the best of the developers' knowledge to work as intended.
24 
25 */
26 
27 
28 
29 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
30 
31 pragma solidity ^0.8.0;
32 
33 
34 
35 /**
36 
37  * @dev Interface of the ERC165 standard, as defined in the
38 
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40 
41  *
42 
43  * Implementers can declare support of contract interfaces, which can then be
44 
45  * queried by others ({ERC165Checker}).
46 
47  *
48 
49  * For an implementation, see {ERC165}.
50 
51  */
52 
53 interface IERC165 {
54 
55     /**
56 
57      * @dev Returns true if this contract implements the interface defined by
58 
59      * `interfaceId`. See the corresponding
60 
61      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
62 
63      * to learn more about how these ids are created.
64 
65      *
66 
67      * This function call must use less than 30 000 gas.
68 
69      */
70 
71     function supportsInterface(bytes4 interfaceId) external view returns (bool);
72 
73 }
74 
75 
76 
77 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
78 
79 pragma solidity ^0.8.0;
80 
81 
82 
83 /**
84 
85  * @dev Required interface of an ERC721 compliant contract.
86 
87  */
88 
89 interface IERC721 is IERC165 {
90 
91     /**
92 
93      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
94 
95      */
96 
97     event Transfer(
98 
99         address indexed from,
100 
101         address indexed to,
102 
103         uint256 indexed tokenId
104 
105     );
106 
107 
108 
109     /**
110 
111      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
112 
113      */
114 
115     event Approval(
116 
117         address indexed owner,
118 
119         address indexed approved,
120 
121         uint256 indexed tokenId
122 
123     );
124 
125 
126 
127     /**
128 
129      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
130 
131      */
132 
133     event ApprovalForAll(
134 
135         address indexed owner,
136 
137         address indexed operator,
138 
139         bool approved
140 
141     );
142 
143 
144 
145     /**
146 
147      * @dev Returns the number of tokens in ``owner``'s account.
148 
149      */
150 
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153 
154 
155     /**
156 
157      * @dev Returns the owner of the `tokenId` token.
158 
159      *
160 
161      * Requirements:
162 
163      *
164 
165      * - `tokenId` must exist.
166 
167      */
168 
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171 
172 
173     /**
174 
175      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
176 
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178 
179      *
180 
181      * Requirements:
182 
183      *
184 
185      * - `from` cannot be the zero address.
186 
187      * - `to` cannot be the zero address.
188 
189      * - `tokenId` token must exist and be owned by `from`.
190 
191      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
192 
193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
194 
195      *
196 
197      * Emits a {Transfer} event.
198 
199      */
200 
201     function safeTransferFrom(
202 
203         address from,
204 
205         address to,
206 
207         uint256 tokenId
208 
209     ) external;
210 
211 
212 
213     /**
214 
215      * @dev Transfers `tokenId` token from `from` to `to`.
216 
217      *
218 
219      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
220 
221      *
222 
223      * Requirements:
224 
225      *
226 
227      * - `from` cannot be the zero address.
228 
229      * - `to` cannot be the zero address.
230 
231      * - `tokenId` token must be owned by `from`.
232 
233      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
234 
235      *
236 
237      * Emits a {Transfer} event.
238 
239      */
240 
241     function transferFrom(
242 
243         address from,
244 
245         address to,
246 
247         uint256 tokenId
248 
249     ) external;
250 
251 
252 
253     /**
254 
255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
256 
257      * The approval is cleared when the token is transferred.
258 
259      *
260 
261      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
262 
263      *
264 
265      * Requirements:
266 
267      *
268 
269      * - The caller must own the token or be an approved operator.
270 
271      * - `tokenId` must exist.
272 
273      *
274 
275      * Emits an {Approval} event.
276 
277      */
278 
279     function approve(address to, uint256 tokenId) external;
280 
281 
282 
283     /**
284 
285      * @dev Returns the account approved for `tokenId` token.
286 
287      *
288 
289      * Requirements:
290 
291      *
292 
293      * - `tokenId` must exist.
294 
295      */
296 
297     function getApproved(uint256 tokenId)
298 
299         external
300 
301         view
302 
303         returns (address operator);
304 
305 
306 
307     /**
308 
309      * @dev Approve or remove `operator` as an operator for the caller.
310 
311      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
312 
313      *
314 
315      * Requirements:
316 
317      *
318 
319      * - The `operator` cannot be the caller.
320 
321      *
322 
323      * Emits an {ApprovalForAll} event.
324 
325      */
326 
327     function setApprovalForAll(address operator, bool _approved) external;
328 
329 
330 
331     /**
332 
333      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
334 
335      *
336 
337      * See {setApprovalForAll}
338 
339      */
340 
341     function isApprovedForAll(address owner, address operator)
342 
343         external
344 
345         view
346 
347         returns (bool);
348 
349 
350 
351     /**
352 
353      * @dev Safely transfers `tokenId` token from `from` to `to`.
354 
355      *
356 
357      * Requirements:
358 
359      *
360 
361      * - `from` cannot be the zero address.
362 
363      * - `to` cannot be the zero address.
364 
365      * - `tokenId` token must exist and be owned by `from`.
366 
367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
368 
369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
370 
371      *
372 
373      * Emits a {Transfer} event.
374 
375      */
376 
377     function safeTransferFrom(
378 
379         address from,
380 
381         address to,
382 
383         uint256 tokenId,
384 
385         bytes calldata data
386 
387     ) external;
388 
389 }
390 
391 
392 
393 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
394 
395 pragma solidity ^0.8.0;
396 
397 
398 
399 /**
400 
401  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
402 
403  * @dev See https://eips.ethereum.org/EIPS/eip-721
404 
405  */
406 
407 interface IERC721Enumerable is IERC721 {
408 
409     /**
410 
411      * @dev Returns the total amount of tokens stored by the contract.
412 
413      */
414 
415     function totalSupply() external view returns (uint256);
416 
417 
418 
419     /**
420 
421      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
422 
423      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
424 
425      */
426 
427     function tokenOfOwnerByIndex(address owner, uint256 index)
428 
429         external
430 
431         view
432 
433         returns (uint256 tokenId);
434 
435 
436 
437     /**
438 
439      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
440 
441      * Use along with {totalSupply} to enumerate all tokens.
442 
443      */
444 
445     function tokenByIndex(uint256 index) external view returns (uint256);
446 
447 }
448 
449 
450 
451 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
452 
453 pragma solidity ^0.8.0;
454 
455 
456 
457 /**
458 
459  * @dev Implementation of the {IERC165} interface.
460 
461  *
462 
463  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
464 
465  * for the additional interface id that will be supported. For example:
466 
467  *
468 
469  * ```solidity
470 
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472 
473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
474 
475  * }
476 
477  * ```
478 
479  *
480 
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482 
483  */
484 
485 abstract contract ERC165 is IERC165 {
486 
487     /**
488 
489      * @dev See {IERC165-supportsInterface}.
490 
491      */
492 
493     function supportsInterface(bytes4 interfaceId)
494 
495         public
496 
497         view
498 
499         virtual
500 
501         override
502 
503         returns (bool)
504 
505     {
506 
507         return interfaceId == type(IERC165).interfaceId;
508 
509     }
510 
511 }
512 
513 
514 
515 // File: @openzeppelin/contracts/utils/Strings.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 
522 
523 /**
524 
525  * @dev String operations.
526 
527  */
528 
529 library Strings {
530 
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533 
534 
535     /**
536 
537      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
538 
539      */
540 
541     function toString(uint256 value) internal pure returns (string memory) {
542 
543         // Inspired by OraclizeAPI's implementation - MIT licence
544 
545         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
546 
547 
548 
549         if (value == 0) {
550 
551             return "0";
552 
553         }
554 
555         uint256 temp = value;
556 
557         uint256 digits;
558 
559         while (temp != 0) {
560 
561             digits++;
562 
563             temp /= 10;
564 
565         }
566 
567         bytes memory buffer = new bytes(digits);
568 
569         while (value != 0) {
570 
571             digits -= 1;
572 
573             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
574 
575             value /= 10;
576 
577         }
578 
579         return string(buffer);
580 
581     }
582 
583 
584 
585     /**
586 
587      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
588 
589      */
590 
591     function toHexString(uint256 value) internal pure returns (string memory) {
592 
593         if (value == 0) {
594 
595             return "0x00";
596 
597         }
598 
599         uint256 temp = value;
600 
601         uint256 length = 0;
602 
603         while (temp != 0) {
604 
605             length++;
606 
607             temp >>= 8;
608 
609         }
610 
611         return toHexString(value, length);
612 
613     }
614 
615 
616 
617     /**
618 
619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
620 
621      */
622 
623     function toHexString(uint256 value, uint256 length)
624 
625         internal
626 
627         pure
628 
629         returns (string memory)
630 
631     {
632 
633         bytes memory buffer = new bytes(2 * length + 2);
634 
635         buffer[0] = "0";
636 
637         buffer[1] = "x";
638 
639         for (uint256 i = 2 * length + 1; i > 1; --i) {
640 
641             buffer[i] = _HEX_SYMBOLS[value & 0xf];
642 
643             value >>= 4;
644 
645         }
646 
647         require(value == 0, "Strings: hex length insufficient");
648 
649         return string(buffer);
650 
651     }
652 
653 }
654 
655 
656 
657 // File: @openzeppelin/contracts/utils/Address.sol
658 
659 
660 
661 pragma solidity ^0.8.0;
662 
663 
664 
665 /**
666 
667  * @dev Collection of functions related to the address type
668 
669  */
670 
671 library Address {
672 
673     /**
674 
675      * @dev Returns true if `account` is a contract.
676 
677      *
678 
679      * [IMPORTANT]
680 
681      * ====
682 
683      * It is unsafe to assume that an address for which this function returns
684 
685      * false is an externally-owned account (EOA) and not a contract.
686 
687      *
688 
689      * Among others, `isContract` will return false for the following
690 
691      * types of addresses:
692 
693      *
694 
695      *  - an externally-owned account
696 
697      *  - a contract in construction
698 
699      *  - an address where a contract will be created
700 
701      *  - an address where a contract lived, but was destroyed
702 
703      * ====
704 
705      */
706 
707     function isContract(address account) internal view returns (bool) {
708 
709         // This method relies on extcodesize, which returns 0 for contracts in
710 
711         // construction, since the code is only stored at the end of the
712 
713         // constructor execution.
714 
715 
716 
717         uint256 size;
718 
719         assembly {
720 
721             size := extcodesize(account)
722 
723         }
724 
725         return size > 0;
726 
727     }
728 
729 
730 
731     /**
732 
733      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
734 
735      * `recipient`, forwarding all available gas and reverting on errors.
736 
737      *
738 
739      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
740 
741      * of certain opcodes, possibly making contracts go over the 2300 gas limit
742 
743      * imposed by `transfer`, making them unable to receive funds via
744 
745      * `transfer`. {sendValue} removes this limitation.
746 
747      *
748 
749      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
750 
751      *
752 
753      * IMPORTANT: because control is transferred to `recipient`, care must be
754 
755      * taken to not create reentrancy vulnerabilities. Consider using
756 
757      * {ReentrancyGuard} or the
758 
759      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
760 
761      */
762 
763     function sendValue(address payable recipient, uint256 amount) internal {
764 
765         require(
766 
767             address(this).balance >= amount,
768 
769             "Address: insufficient balance"
770 
771         );
772 
773 
774 
775         (bool success, ) = recipient.call{value: amount}("");
776 
777         require(
778 
779             success,
780 
781             "Address: unable to send value, recipient may have reverted"
782 
783         );
784 
785     }
786 
787 
788 
789     /**
790 
791      * @dev Performs a Solidity function call using a low level `call`. A
792 
793      * plain `call` is an unsafe replacement for a function call: use this
794 
795      * function instead.
796 
797      *
798 
799      * If `target` reverts with a revert reason, it is bubbled up by this
800 
801      * function (like regular Solidity function calls).
802 
803      *
804 
805      * Returns the raw returned data. To convert to the expected return value,
806 
807      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
808 
809      *
810 
811      * Requirements:
812 
813      *
814 
815      * - `target` must be a contract.
816 
817      * - calling `target` with `data` must not revert.
818 
819      *
820 
821      * _Available since v3.1._
822 
823      */
824 
825     function functionCall(address target, bytes memory data)
826 
827         internal
828 
829         returns (bytes memory)
830 
831     {
832 
833         return functionCall(target, data, "Address: low-level call failed");
834 
835     }
836 
837 
838 
839     /**
840 
841      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
842 
843      * `errorMessage` as a fallback revert reason when `target` reverts.
844 
845      *
846 
847      * _Available since v3.1._
848 
849      */
850 
851     function functionCall(
852 
853         address target,
854 
855         bytes memory data,
856 
857         string memory errorMessage
858 
859     ) internal returns (bytes memory) {
860 
861         return functionCallWithValue(target, data, 0, errorMessage);
862 
863     }
864 
865 
866 
867     /**
868 
869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
870 
871      * but also transferring `value` wei to `target`.
872 
873      *
874 
875      * Requirements:
876 
877      *
878 
879      * - the calling contract must have an ETH balance of at least `value`.
880 
881      * - the called Solidity function must be `payable`.
882 
883      *
884 
885      * _Available since v3.1._
886 
887      */
888 
889     function functionCallWithValue(
890 
891         address target,
892 
893         bytes memory data,
894 
895         uint256 value
896 
897     ) internal returns (bytes memory) {
898 
899         return
900 
901             functionCallWithValue(
902 
903                 target,
904 
905                 data,
906 
907                 value,
908 
909                 "Address: low-level call with value failed"
910 
911             );
912 
913     }
914 
915 
916 
917     /**
918 
919      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
920 
921      * with `errorMessage` as a fallback revert reason when `target` reverts.
922 
923      *
924 
925      * _Available since v3.1._
926 
927      */
928 
929     function functionCallWithValue(
930 
931         address target,
932 
933         bytes memory data,
934 
935         uint256 value,
936 
937         string memory errorMessage
938 
939     ) internal returns (bytes memory) {
940 
941         require(
942 
943             address(this).balance >= value,
944 
945             "Address: insufficient balance for call"
946 
947         );
948 
949         require(isContract(target), "Address: call to non-contract");
950 
951 
952 
953         (bool success, bytes memory returndata) = target.call{value: value}(
954 
955             data
956 
957         );
958 
959         return verifyCallResult(success, returndata, errorMessage);
960 
961     }
962 
963 
964 
965     /**
966 
967      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
968 
969      * but performing a static call.
970 
971      *
972 
973      * _Available since v3.3._
974 
975      */
976 
977     function functionStaticCall(address target, bytes memory data)
978 
979         internal
980 
981         view
982 
983         returns (bytes memory)
984 
985     {
986 
987         return
988 
989             functionStaticCall(
990 
991                 target,
992 
993                 data,
994 
995                 "Address: low-level static call failed"
996 
997             );
998 
999     }
1000 
1001 
1002 
1003     /**
1004 
1005      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1006 
1007      * but performing a static call.
1008 
1009      *
1010 
1011      * _Available since v3.3._
1012 
1013      */
1014 
1015     function functionStaticCall(
1016 
1017         address target,
1018 
1019         bytes memory data,
1020 
1021         string memory errorMessage
1022 
1023     ) internal view returns (bytes memory) {
1024 
1025         require(isContract(target), "Address: static call to non-contract");
1026 
1027 
1028 
1029         (bool success, bytes memory returndata) = target.staticcall(data);
1030 
1031         return verifyCallResult(success, returndata, errorMessage);
1032 
1033     }
1034 
1035 
1036 
1037     /**
1038 
1039      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1040 
1041      * but performing a delegate call.
1042 
1043      *
1044 
1045      * _Available since v3.4._
1046 
1047      */
1048 
1049     function functionDelegateCall(address target, bytes memory data)
1050 
1051         internal
1052 
1053         returns (bytes memory)
1054 
1055     {
1056 
1057         return
1058 
1059             functionDelegateCall(
1060 
1061                 target,
1062 
1063                 data,
1064 
1065                 "Address: low-level delegate call failed"
1066 
1067             );
1068 
1069     }
1070 
1071 
1072 
1073     /**
1074 
1075      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1076 
1077      * but performing a delegate call.
1078 
1079      *
1080 
1081      * _Available since v3.4._
1082 
1083      */
1084 
1085     function functionDelegateCall(
1086 
1087         address target,
1088 
1089         bytes memory data,
1090 
1091         string memory errorMessage
1092 
1093     ) internal returns (bytes memory) {
1094 
1095         require(isContract(target), "Address: delegate call to non-contract");
1096 
1097 
1098 
1099         (bool success, bytes memory returndata) = target.delegatecall(data);
1100 
1101         return verifyCallResult(success, returndata, errorMessage);
1102 
1103     }
1104 
1105 
1106 
1107     /**
1108 
1109      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1110 
1111      * revert reason using the provided one.
1112 
1113      *
1114 
1115      * _Available since v4.3._
1116 
1117      */
1118 
1119     function verifyCallResult(
1120 
1121         bool success,
1122 
1123         bytes memory returndata,
1124 
1125         string memory errorMessage
1126 
1127     ) internal pure returns (bytes memory) {
1128 
1129         if (success) {
1130 
1131             return returndata;
1132 
1133         } else {
1134 
1135             // Look for revert reason and bubble it up if present
1136 
1137             if (returndata.length > 0) {
1138 
1139                 // The easiest way to bubble the revert reason is using memory via assembly
1140 
1141 
1142 
1143                 assembly {
1144 
1145                     let returndata_size := mload(returndata)
1146 
1147                     revert(add(32, returndata), returndata_size)
1148 
1149                 }
1150 
1151             } else {
1152 
1153                 revert(errorMessage);
1154 
1155             }
1156 
1157         }
1158 
1159     }
1160 
1161 }
1162 
1163 
1164 
1165 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1166 
1167 
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 
1173 /**
1174 
1175  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1176 
1177  * @dev See https://eips.ethereum.org/EIPS/eip-721
1178 
1179  */
1180 
1181 interface IERC721Metadata is IERC721 {
1182 
1183     /**
1184 
1185      * @dev Returns the token collection name.
1186 
1187      */
1188 
1189     function name() external view returns (string memory);
1190 
1191 
1192 
1193     /**
1194 
1195      * @dev Returns the token collection symbol.
1196 
1197      */
1198 
1199     function symbol() external view returns (string memory);
1200 
1201 
1202 
1203     /**
1204 
1205      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1206 
1207      */
1208 
1209     function tokenURI(uint256 tokenId) external view returns (string memory);
1210 
1211 }
1212 
1213 
1214 
1215 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1216 
1217 
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 
1222 
1223 /**
1224 
1225  * @title ERC721 token receiver interface
1226 
1227  * @dev Interface for any contract that wants to support safeTransfers
1228 
1229  * from ERC721 asset contracts.
1230 
1231  */
1232 
1233 interface IERC721Receiver {
1234 
1235     /**
1236 
1237      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1238 
1239      * by `operator` from `from`, this function is called.
1240 
1241      *
1242 
1243      * It must return its Solidity selector to confirm the token transfer.
1244 
1245      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1246 
1247      *
1248 
1249      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1250 
1251      */
1252 
1253     function onERC721Received(
1254 
1255         address operator,
1256 
1257         address from,
1258 
1259         uint256 tokenId,
1260 
1261         bytes calldata data
1262 
1263     ) external returns (bytes4);
1264 
1265 }
1266 
1267 
1268 
1269 // File: @openzeppelin/contracts/utils/Context.sol
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 
1275 /**
1276 
1277  * @dev Provides information about the current execution context, including the
1278 
1279  * sender of the transaction and its data. While these are generally available
1280 
1281  * via msg.sender and msg.data, they should not be accessed in such a direct
1282 
1283  * manner, since when dealing with meta-transactions the account sending and
1284 
1285  * paying for execution may not be the actual sender (as far as an application
1286 
1287  * is concerned).
1288 
1289  *
1290 
1291  * This contract is only required for intermediate, library-like contracts.
1292 
1293  */
1294 
1295 abstract contract Context {
1296 
1297     function _msgSender() internal view virtual returns (address) {
1298 
1299         return msg.sender;
1300 
1301     }
1302 
1303 
1304 
1305     function _msgData() internal view virtual returns (bytes calldata) {
1306 
1307         return msg.data;
1308 
1309     }
1310 
1311 }
1312 
1313 
1314 
1315 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 
1321 /**
1322 
1323  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1324 
1325  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1326 
1327  * {ERC721Enumerable}.
1328 
1329  */
1330 
1331 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1332 
1333     using Address for address;
1334 
1335     using Strings for uint256;
1336 
1337 
1338 
1339     // Token name
1340 
1341     string private _name;
1342 
1343 
1344 
1345     // Token symbol
1346 
1347     string private _symbol;
1348 
1349 
1350 
1351     // Mapping from token ID to owner address
1352 
1353     mapping(uint256 => address) private _owners;
1354 
1355 
1356 
1357     // Mapping owner address to token count
1358 
1359     mapping(address => uint256) private _balances;
1360 
1361 
1362 
1363     // Mapping from token ID to approved address
1364 
1365     mapping(uint256 => address) private _tokenApprovals;
1366 
1367 
1368 
1369     // Mapping from owner to operator approvals
1370 
1371     mapping(address => mapping(address => bool)) private _operatorApprovals;
1372 
1373 
1374 
1375     /**
1376 
1377      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1378 
1379      */
1380 
1381     constructor(string memory name_, string memory symbol_) {
1382 
1383         _name = name_;
1384 
1385         _symbol = symbol_;
1386 
1387     }
1388 
1389 
1390 
1391     /**
1392 
1393      * @dev See {IERC165-supportsInterface}.
1394 
1395      */
1396 
1397     function supportsInterface(bytes4 interfaceId)
1398 
1399         public
1400 
1401         view
1402 
1403         virtual
1404 
1405         override(ERC165, IERC165)
1406 
1407         returns (bool)
1408 
1409     {
1410 
1411         return
1412 
1413             interfaceId == type(IERC721).interfaceId ||
1414 
1415             interfaceId == type(IERC721Metadata).interfaceId ||
1416 
1417             super.supportsInterface(interfaceId);
1418 
1419     }
1420 
1421 
1422 
1423     /**
1424 
1425      * @dev See {IERC721-balanceOf}.
1426 
1427      */
1428 
1429     function balanceOf(address owner)
1430 
1431         public
1432 
1433         view
1434 
1435         virtual
1436 
1437         override
1438 
1439         returns (uint256)
1440 
1441     {
1442 
1443         require(
1444 
1445             owner != address(0),
1446 
1447             "ERC721: balance query for the zero address"
1448 
1449         );
1450 
1451         return _balances[owner];
1452 
1453     }
1454 
1455 
1456 
1457     /**
1458 
1459      * @dev See {IERC721-ownerOf}.
1460 
1461      */
1462 
1463     function ownerOf(uint256 tokenId)
1464 
1465         public
1466 
1467         view
1468 
1469         virtual
1470 
1471         override
1472 
1473         returns (address)
1474 
1475     {
1476 
1477         address owner = _owners[tokenId];
1478 
1479         require(
1480 
1481             owner != address(0),
1482 
1483             "ERC721: owner query for nonexistent token"
1484 
1485         );
1486 
1487         return owner;
1488 
1489     }
1490 
1491 
1492 
1493     /**
1494 
1495      * @dev See {IERC721Metadata-name}.
1496 
1497      */
1498 
1499     function name() public view virtual override returns (string memory) {
1500 
1501         return _name;
1502 
1503     }
1504 
1505 
1506 
1507     /**
1508 
1509      * @dev See {IERC721Metadata-symbol}.
1510 
1511      */
1512 
1513     function symbol() public view virtual override returns (string memory) {
1514 
1515         return _symbol;
1516 
1517     }
1518 
1519 
1520 
1521     /**
1522 
1523      * @dev See {IERC721Metadata-tokenURI}.
1524 
1525      */
1526 
1527     function tokenURI(uint256 tokenId)
1528 
1529         public
1530 
1531         view
1532 
1533         virtual
1534 
1535         override
1536 
1537         returns (string memory)
1538 
1539     {
1540 
1541         require(
1542 
1543             _exists(tokenId),
1544 
1545             "ERC721Metadata: URI query for nonexistent token"
1546 
1547         );
1548 
1549 
1550 
1551         string memory baseURI = _baseURI();
1552 
1553         return
1554 
1555             bytes(baseURI).length > 0
1556 
1557                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1558 
1559                 : "";
1560 
1561     }
1562 
1563 
1564 
1565     /**
1566 
1567      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1568 
1569      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1570 
1571      * by default, can be overriden in child contracts.
1572 
1573      */
1574 
1575     function _baseURI() internal view virtual returns (string memory) {
1576 
1577         return "";
1578 
1579     }
1580 
1581 
1582 
1583     /**
1584 
1585      * @dev See {IERC721-approve}.
1586 
1587      */
1588 
1589     function approve(address to, uint256 tokenId) public virtual override {
1590 
1591         address owner = ERC721.ownerOf(tokenId);
1592 
1593         require(to != owner, "ERC721: approval to current owner");
1594 
1595 
1596 
1597         require(
1598 
1599             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1600 
1601             "ERC721: approve caller is not owner nor approved for all"
1602 
1603         );
1604 
1605 
1606 
1607         _approve(to, tokenId);
1608 
1609     }
1610 
1611 
1612 
1613     /**
1614 
1615      * @dev See {IERC721-getApproved}.
1616 
1617      */
1618 
1619     function getApproved(uint256 tokenId)
1620 
1621         public
1622 
1623         view
1624 
1625         virtual
1626 
1627         override
1628 
1629         returns (address)
1630 
1631     {
1632 
1633         require(
1634 
1635             _exists(tokenId),
1636 
1637             "ERC721: approved query for nonexistent token"
1638 
1639         );
1640 
1641 
1642 
1643         return _tokenApprovals[tokenId];
1644 
1645     }
1646 
1647 
1648 
1649     /**
1650 
1651      * @dev See {IERC721-setApprovalForAll}.
1652 
1653      */
1654 
1655     function setApprovalForAll(address operator, bool approved)
1656 
1657         public
1658 
1659         virtual
1660 
1661         override
1662 
1663     {
1664 
1665         require(operator != _msgSender(), "ERC721: approve to caller");
1666 
1667 
1668 
1669         _operatorApprovals[_msgSender()][operator] = approved;
1670 
1671         emit ApprovalForAll(_msgSender(), operator, approved);
1672 
1673     }
1674 
1675 
1676 
1677     /**
1678 
1679      * @dev See {IERC721-isApprovedForAll}.
1680 
1681      */
1682 
1683     function isApprovedForAll(address owner, address operator)
1684 
1685         public
1686 
1687         view
1688 
1689         virtual
1690 
1691         override
1692 
1693         returns (bool)
1694 
1695     {
1696 
1697         return _operatorApprovals[owner][operator];
1698 
1699     }
1700 
1701 
1702 
1703     /**
1704 
1705      * @dev See {IERC721-transferFrom}.
1706 
1707      */
1708 
1709     function transferFrom(
1710 
1711         address from,
1712 
1713         address to,
1714 
1715         uint256 tokenId
1716 
1717     ) public virtual override {
1718 
1719         //solhint-disable-next-line max-line-length
1720 
1721         require(
1722 
1723             _isApprovedOrOwner(_msgSender(), tokenId),
1724 
1725             "ERC721: transfer caller is not owner nor approved"
1726 
1727         );
1728 
1729 
1730 
1731         _transfer(from, to, tokenId);
1732 
1733     }
1734 
1735 
1736 
1737     /**
1738 
1739      * @dev See {IERC721-safeTransferFrom}.
1740 
1741      */
1742 
1743     function safeTransferFrom(
1744 
1745         address from,
1746 
1747         address to,
1748 
1749         uint256 tokenId
1750 
1751     ) public virtual override {
1752 
1753         safeTransferFrom(from, to, tokenId, "");
1754 
1755     }
1756 
1757 
1758 
1759     /**
1760 
1761      * @dev See {IERC721-safeTransferFrom}.
1762 
1763      */
1764 
1765     function safeTransferFrom(
1766 
1767         address from,
1768 
1769         address to,
1770 
1771         uint256 tokenId,
1772 
1773         bytes memory _data
1774 
1775     ) public virtual override {
1776 
1777         require(
1778 
1779             _isApprovedOrOwner(_msgSender(), tokenId),
1780 
1781             "ERC721: transfer caller is not owner nor approved"
1782 
1783         );
1784 
1785         _safeTransfer(from, to, tokenId, _data);
1786 
1787     }
1788 
1789 
1790 
1791     /**
1792 
1793      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1794 
1795      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1796 
1797      *
1798 
1799      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1800 
1801      *
1802 
1803      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1804 
1805      * implement alternative mechanisms to perform token transfer, such as signature-based.
1806 
1807      *
1808 
1809      * Requirements:
1810 
1811      *
1812 
1813      * - `from` cannot be the zero address.
1814 
1815      * - `to` cannot be the zero address.
1816 
1817      * - `tokenId` token must exist and be owned by `from`.
1818 
1819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1820 
1821      *
1822 
1823      * Emits a {Transfer} event.
1824 
1825      */
1826 
1827     function _safeTransfer(
1828 
1829         address from,
1830 
1831         address to,
1832 
1833         uint256 tokenId,
1834 
1835         bytes memory _data
1836 
1837     ) internal virtual {
1838 
1839         _transfer(from, to, tokenId);
1840 
1841         require(
1842 
1843             _checkOnERC721Received(from, to, tokenId, _data),
1844 
1845             "ERC721: transfer to non ERC721Receiver implementer"
1846 
1847         );
1848 
1849     }
1850 
1851 
1852 
1853     /**
1854 
1855      * @dev Returns whether `tokenId` exists.
1856 
1857      *
1858 
1859      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1860 
1861      *
1862 
1863      * Tokens start existing when they are minted (`_mint`),
1864 
1865      * and stop existing when they are burned (`_burn`).
1866 
1867      */
1868 
1869     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1870 
1871         return _owners[tokenId] != address(0);
1872 
1873     }
1874 
1875 
1876 
1877     /**
1878 
1879      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1880 
1881      *
1882 
1883      * Requirements:
1884 
1885      *
1886 
1887      * - `tokenId` must exist.
1888 
1889      */
1890 
1891     function _isApprovedOrOwner(address spender, uint256 tokenId)
1892 
1893         internal
1894 
1895         view
1896 
1897         virtual
1898 
1899         returns (bool)
1900 
1901     {
1902 
1903         require(
1904 
1905             _exists(tokenId),
1906 
1907             "ERC721: operator query for nonexistent token"
1908 
1909         );
1910 
1911         address owner = ERC721.ownerOf(tokenId);
1912 
1913         return (spender == owner ||
1914 
1915             getApproved(tokenId) == spender ||
1916 
1917             isApprovedForAll(owner, spender));
1918 
1919     }
1920 
1921 
1922 
1923     /**
1924 
1925      * @dev Safely mints `tokenId` and transfers it to `to`.
1926 
1927      *
1928 
1929      * Requirements:
1930 
1931      *
1932 
1933      * - `tokenId` must not exist.
1934 
1935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1936 
1937      *
1938 
1939      * Emits a {Transfer} event.
1940 
1941      */
1942 
1943     function _safeMint(address to, uint256 tokenId) internal virtual {
1944 
1945         _safeMint(to, tokenId, "");
1946 
1947     }
1948 
1949 
1950 
1951     /**
1952 
1953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1954 
1955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1956 
1957      */
1958 
1959     function _safeMint(
1960 
1961         address to,
1962 
1963         uint256 tokenId,
1964 
1965         bytes memory _data
1966 
1967     ) internal virtual {
1968 
1969         _mint(to, tokenId);
1970 
1971         require(
1972 
1973             _checkOnERC721Received(address(0), to, tokenId, _data),
1974 
1975             "ERC721: transfer to non ERC721Receiver implementer"
1976 
1977         );
1978 
1979     }
1980 
1981 
1982 
1983     /**
1984 
1985      * @dev Mints `tokenId` and transfers it to `to`.
1986 
1987      *
1988 
1989      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1990 
1991      *
1992 
1993      * Requirements:
1994 
1995      *
1996 
1997      * - `tokenId` must not exist.
1998 
1999      * - `to` cannot be the zero address.
2000 
2001      *
2002 
2003      * Emits a {Transfer} event.
2004 
2005      */
2006 
2007     function _mint(address to, uint256 tokenId) internal virtual {
2008 
2009         require(to != address(0), "ERC721: mint to the zero address");
2010 
2011         require(!_exists(tokenId), "ERC721: token already minted");
2012 
2013 
2014 
2015         _beforeTokenTransfer(address(0), to, tokenId);
2016 
2017 
2018 
2019         _balances[to] += 1;
2020 
2021         _owners[tokenId] = to;
2022 
2023 
2024 
2025         emit Transfer(address(0), to, tokenId);
2026 
2027     }
2028 
2029 
2030 
2031     /**
2032 
2033      * @dev Destroys `tokenId`.
2034 
2035      * The approval is cleared when the token is burned.
2036 
2037      *
2038 
2039      * Requirements:
2040 
2041      *
2042 
2043      * - `tokenId` must exist.
2044 
2045      *
2046 
2047      * Emits a {Transfer} event.
2048 
2049      */
2050 
2051     function _burn(uint256 tokenId) internal virtual {
2052 
2053         address owner = ERC721.ownerOf(tokenId);
2054 
2055 
2056 
2057         _beforeTokenTransfer(owner, address(0), tokenId);
2058 
2059 
2060 
2061         // Clear approvals
2062 
2063         _approve(address(0), tokenId);
2064 
2065 
2066 
2067         _balances[owner] -= 1;
2068 
2069         delete _owners[tokenId];
2070 
2071 
2072 
2073         emit Transfer(owner, address(0), tokenId);
2074 
2075     }
2076 
2077 
2078 
2079     /**
2080 
2081      * @dev Transfers `tokenId` from `from` to `to`.
2082 
2083      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2084 
2085      *
2086 
2087      * Requirements:
2088 
2089      *
2090 
2091      * - `to` cannot be the zero address.
2092 
2093      * - `tokenId` token must be owned by `from`.
2094 
2095      *
2096 
2097      * Emits a {Transfer} event.
2098 
2099      */
2100 
2101     function _transfer(
2102 
2103         address from,
2104 
2105         address to,
2106 
2107         uint256 tokenId
2108 
2109     ) internal virtual {
2110 
2111         require(
2112 
2113             ERC721.ownerOf(tokenId) == from,
2114 
2115             "ERC721: transfer of token that is not own"
2116 
2117         );
2118 
2119         require(to != address(0), "ERC721: transfer to the zero address");
2120 
2121 
2122 
2123         _beforeTokenTransfer(from, to, tokenId);
2124 
2125 
2126 
2127         // Clear approvals from the previous owner
2128 
2129         _approve(address(0), tokenId);
2130 
2131 
2132 
2133         _balances[from] -= 1;
2134 
2135         _balances[to] += 1;
2136 
2137         _owners[tokenId] = to;
2138 
2139 
2140 
2141         emit Transfer(from, to, tokenId);
2142 
2143     }
2144 
2145 
2146 
2147     /**
2148 
2149      * @dev Approve `to` to operate on `tokenId`
2150 
2151      *
2152 
2153      * Emits a {Approval} event.
2154 
2155      */
2156 
2157     function _approve(address to, uint256 tokenId) internal virtual {
2158 
2159         _tokenApprovals[tokenId] = to;
2160 
2161         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2162 
2163     }
2164 
2165 
2166 
2167     /**
2168 
2169      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2170 
2171      * The call is not executed if the target address is not a contract.
2172 
2173      *
2174 
2175      * @param from address representing the previous owner of the given token ID
2176 
2177      * @param to target address that will receive the tokens
2178 
2179      * @param tokenId uint256 ID of the token to be transferred
2180 
2181      * @param _data bytes optional data to send along with the call
2182 
2183      * @return bool whether the call correctly returned the expected magic value
2184 
2185      */
2186 
2187     function _checkOnERC721Received(
2188 
2189         address from,
2190 
2191         address to,
2192 
2193         uint256 tokenId,
2194 
2195         bytes memory _data
2196 
2197     ) private returns (bool) {
2198 
2199         if (to.isContract()) {
2200 
2201             try
2202 
2203                 IERC721Receiver(to).onERC721Received(
2204 
2205                     _msgSender(),
2206 
2207                     from,
2208 
2209                     tokenId,
2210 
2211                     _data
2212 
2213                 )
2214 
2215             returns (bytes4 retval) {
2216 
2217                 return retval == IERC721Receiver.onERC721Received.selector;
2218 
2219             } catch (bytes memory reason) {
2220 
2221                 if (reason.length == 0) {
2222 
2223                     revert(
2224 
2225                         "ERC721: transfer to non ERC721Receiver implementer"
2226 
2227                     );
2228 
2229                 } else {
2230 
2231                     assembly {
2232 
2233                         revert(add(32, reason), mload(reason))
2234 
2235                     }
2236 
2237                 }
2238 
2239             }
2240 
2241         } else {
2242 
2243             return true;
2244 
2245         }
2246 
2247     }
2248 
2249 
2250 
2251     /**
2252 
2253      * @dev Hook that is called before any token transfer. This includes minting
2254 
2255      * and burning.
2256 
2257      *
2258 
2259      * Calling conditions:
2260 
2261      *
2262 
2263      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2264 
2265      * transferred to `to`.
2266 
2267      * - When `from` is zero, `tokenId` will be minted for `to`.
2268 
2269      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2270 
2271      * - `from` and `to` are never both zero.
2272 
2273      *
2274 
2275      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2276 
2277      */
2278 
2279     function _beforeTokenTransfer(
2280 
2281         address from,
2282 
2283         address to,
2284 
2285         uint256 tokenId
2286 
2287     ) internal virtual {}
2288 
2289 }
2290 
2291 
2292 
2293 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2294 
2295 
2296 
2297 pragma solidity ^0.8.0;
2298 
2299 
2300 
2301 /**
2302 
2303  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2304 
2305  * enumerability of all the token ids in the contract as well as all token ids owned by each
2306 
2307  * account.
2308 
2309  */
2310 
2311 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2312 
2313     // Mapping from owner to list of owned token IDs
2314 
2315     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2316 
2317 
2318 
2319     // Mapping from token ID to index of the owner tokens list
2320 
2321     mapping(uint256 => uint256) private _ownedTokensIndex;
2322 
2323 
2324 
2325     // Array with all token ids, used for enumeration
2326 
2327     uint256[] private _allTokens;
2328 
2329 
2330 
2331     // Mapping from token id to position in the allTokens array
2332 
2333     mapping(uint256 => uint256) private _allTokensIndex;
2334 
2335 
2336 
2337     /**
2338 
2339      * @dev See {IERC165-supportsInterface}.
2340 
2341      */
2342 
2343     function supportsInterface(bytes4 interfaceId)
2344 
2345         public
2346 
2347         view
2348 
2349         virtual
2350 
2351         override(IERC165, ERC721)
2352 
2353         returns (bool)
2354 
2355     {
2356 
2357         return
2358 
2359             interfaceId == type(IERC721Enumerable).interfaceId ||
2360 
2361             super.supportsInterface(interfaceId);
2362 
2363     }
2364 
2365 
2366 
2367     /**
2368 
2369      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2370 
2371      */
2372 
2373     function tokenOfOwnerByIndex(address owner, uint256 index)
2374 
2375         public
2376 
2377         view
2378 
2379         virtual
2380 
2381         override
2382 
2383         returns (uint256)
2384 
2385     {
2386 
2387         require(
2388 
2389             index < ERC721.balanceOf(owner),
2390 
2391             "ERC721Enumerable: owner index out of bounds"
2392 
2393         );
2394 
2395         return _ownedTokens[owner][index];
2396 
2397     }
2398 
2399 
2400 
2401     /**
2402 
2403      * @dev See {IERC721Enumerable-totalSupply}.
2404 
2405      */
2406 
2407     function totalSupply() public view virtual override returns (uint256) {
2408 
2409         return _allTokens.length;
2410 
2411     }
2412 
2413 
2414 
2415     /**
2416 
2417      * @dev See {IERC721Enumerable-tokenByIndex}.
2418 
2419      */
2420 
2421     function tokenByIndex(uint256 index)
2422 
2423         public
2424 
2425         view
2426 
2427         virtual
2428 
2429         override
2430 
2431         returns (uint256)
2432 
2433     {
2434 
2435         require(
2436 
2437             index < ERC721Enumerable.totalSupply(),
2438 
2439             "ERC721Enumerable: global index out of bounds"
2440 
2441         );
2442 
2443         return _allTokens[index];
2444 
2445     }
2446 
2447 
2448 
2449     /**
2450 
2451      * @dev Hook that is called before any token transfer. This includes minting
2452 
2453      * and burning.
2454 
2455      *
2456 
2457      * Calling conditions:
2458 
2459      *
2460 
2461      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2462 
2463      * transferred to `to`.
2464 
2465      * - When `from` is zero, `tokenId` will be minted for `to`.
2466 
2467      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2468 
2469      * - `from` cannot be the zero address.
2470 
2471      * - `to` cannot be the zero address.
2472 
2473      *
2474 
2475      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2476 
2477      */
2478 
2479     function _beforeTokenTransfer(
2480 
2481         address from,
2482 
2483         address to,
2484 
2485         uint256 tokenId
2486 
2487     ) internal virtual override {
2488 
2489         super._beforeTokenTransfer(from, to, tokenId);
2490 
2491 
2492 
2493         if (from == address(0)) {
2494 
2495             _addTokenToAllTokensEnumeration(tokenId);
2496 
2497         } else if (from != to) {
2498 
2499             _removeTokenFromOwnerEnumeration(from, tokenId);
2500 
2501         }
2502 
2503         if (to == address(0)) {
2504 
2505             _removeTokenFromAllTokensEnumeration(tokenId);
2506 
2507         } else if (to != from) {
2508 
2509             _addTokenToOwnerEnumeration(to, tokenId);
2510 
2511         }
2512 
2513     }
2514 
2515 
2516 
2517     /**
2518 
2519      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2520 
2521      * @param to address representing the new owner of the given token ID
2522 
2523      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2524 
2525      */
2526 
2527     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2528 
2529         uint256 length = ERC721.balanceOf(to);
2530 
2531         _ownedTokens[to][length] = tokenId;
2532 
2533         _ownedTokensIndex[tokenId] = length;
2534 
2535     }
2536 
2537 
2538 
2539     /**
2540 
2541      * @dev Private function to add a token to this extension's token tracking data structures.
2542 
2543      * @param tokenId uint256 ID of the token to be added to the tokens list
2544 
2545      */
2546 
2547     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2548 
2549         _allTokensIndex[tokenId] = _allTokens.length;
2550 
2551         _allTokens.push(tokenId);
2552 
2553     }
2554 
2555 
2556 
2557     /**
2558 
2559      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2560 
2561      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2562 
2563      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2564 
2565      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2566 
2567      * @param from address representing the previous owner of the given token ID
2568 
2569      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2570 
2571      */
2572 
2573     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2574 
2575         private
2576 
2577     {
2578 
2579         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2580 
2581         // then delete the last slot (swap and pop).
2582 
2583 
2584 
2585         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2586 
2587         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2588 
2589 
2590 
2591         // When the token to delete is the last token, the swap operation is unnecessary
2592 
2593         if (tokenIndex != lastTokenIndex) {
2594 
2595             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2596 
2597 
2598 
2599             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2600 
2601             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2602 
2603         }
2604 
2605 
2606 
2607         // This also deletes the contents at the last position of the array
2608 
2609         delete _ownedTokensIndex[tokenId];
2610 
2611         delete _ownedTokens[from][lastTokenIndex];
2612 
2613     }
2614 
2615 
2616 
2617     /**
2618 
2619      * @dev Private function to remove a token from this extension's token tracking data structures.
2620 
2621      * This has O(1) time complexity, but alters the order of the _allTokens array.
2622 
2623      * @param tokenId uint256 ID of the token to be removed from the tokens list
2624 
2625      */
2626 
2627     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2628 
2629         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2630 
2631         // then delete the last slot (swap and pop).
2632 
2633 
2634 
2635         uint256 lastTokenIndex = _allTokens.length - 1;
2636 
2637         uint256 tokenIndex = _allTokensIndex[tokenId];
2638 
2639 
2640 
2641         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2642 
2643         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2644 
2645         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2646 
2647         uint256 lastTokenId = _allTokens[lastTokenIndex];
2648 
2649 
2650 
2651         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2652 
2653         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2654 
2655 
2656 
2657         // This also deletes the contents at the last position of the array
2658 
2659         delete _allTokensIndex[tokenId];
2660 
2661         _allTokens.pop();
2662 
2663     }
2664 
2665 }
2666 
2667 
2668 
2669 // File: @openzeppelin/contracts/access/Ownable.sol
2670 
2671 pragma solidity ^0.8.0;
2672 
2673 
2674 
2675 /**
2676 
2677  * @dev Contract module which provides a basic access control mechanism, where
2678 
2679  * there is an account (an owner) that can be granted exclusive access to
2680 
2681  * specific functions.
2682 
2683  *
2684 
2685  * By default, the owner account will be the one that deploys the contract. This
2686 
2687  * can later be changed with {transferOwnership}.
2688 
2689  *
2690 
2691  * This module is used through inheritance. It will make available the modifier
2692 
2693  * `onlyOwner`, which can be applied to your functions to restrict their use to
2694 
2695  * the owner.
2696 
2697  */
2698 
2699 abstract contract Ownable is Context {
2700 
2701     address private _owner;
2702 
2703 
2704 
2705     event OwnershipTransferred(
2706 
2707         address indexed previousOwner,
2708 
2709         address indexed newOwner
2710 
2711     );
2712 
2713 
2714 
2715     /**
2716 
2717      * @dev Initializes the contract setting the deployer as the initial owner.
2718 
2719      */
2720 
2721     constructor() {
2722 
2723         _setOwner(_msgSender());
2724 
2725     }
2726 
2727 
2728 
2729     /**
2730 
2731      * @dev Returns the address of the current owner.
2732 
2733      */
2734 
2735     function owner() public view virtual returns (address) {
2736 
2737         return _owner;
2738 
2739     }
2740 
2741 
2742 
2743     /**
2744 
2745      * @dev Throws if called by any account other than the owner.
2746 
2747      */
2748 
2749     modifier onlyOwner() {
2750 
2751         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2752 
2753         _;
2754 
2755     }
2756 
2757 
2758 
2759     /**
2760 
2761      * @dev Leaves the contract without owner. It will not be possible to call
2762 
2763      * `onlyOwner` functions anymore. Can only be called by the current owner.
2764 
2765      *
2766 
2767      * NOTE: Renouncing ownership will leave the contract without an owner,
2768 
2769      * thereby removing any functionality that is only available to the owner.
2770 
2771      */
2772 
2773     function renounceOwnership() public virtual onlyOwner {
2774 
2775         _setOwner(address(0));
2776 
2777     }
2778 
2779 
2780 
2781     /**
2782 
2783      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2784 
2785      * Can only be called by the current owner.
2786 
2787      */
2788 
2789     function transferOwnership(address newOwner) public virtual onlyOwner {
2790 
2791         require(
2792 
2793             newOwner != address(0),
2794 
2795             "Ownable: new owner is the zero address"
2796 
2797         );
2798 
2799         _setOwner(newOwner);
2800 
2801     }
2802 
2803 
2804 
2805     function _setOwner(address newOwner) private {
2806 
2807         address oldOwner = _owner;
2808 
2809         _owner = newOwner;
2810 
2811         emit OwnershipTransferred(oldOwner, newOwner);
2812 
2813     }
2814 
2815 }
2816 
2817 
2818 
2819 pragma solidity >=0.7.0 <0.9.0;
2820 
2821 
2822 
2823 contract Babystarlords is ERC721Enumerable, Ownable {
2824 
2825     using Strings for uint256;
2826 
2827 
2828 
2829     string public baseURI;
2830 
2831     string public baseExtension = ".json";
2832 
2833     string public notRevealedUri;
2834 
2835     uint256 public cost = 0.01 ether;
2836 
2837     uint256 public maxSupply = 7777;
2838 
2839     uint256 public maxMintAmount = 10;
2840 
2841     uint256 public nftPerAddressLimit = 3;
2842 
2843     bool public paused = true;
2844 
2845     bool public revealed = false;
2846 
2847     bool public onlyWhitelisted = false;
2848 
2849     address[] public whitelistedAddresses;
2850 
2851     mapping(address => uint256) public addressMintedBalance;
2852 
2853 
2854 
2855     constructor(
2856 
2857         string memory _name,
2858 
2859         string memory _symbol,
2860 
2861         string memory _initBaseURI,
2862 
2863         string memory _initNotRevealedUri
2864 
2865     ) ERC721(_name, _symbol) {
2866 
2867         setBaseURI(_initBaseURI);
2868 
2869         setNotRevealedURI(_initNotRevealedUri);
2870 
2871     }
2872 
2873 
2874 
2875     // internal
2876 
2877     function _baseURI() internal view virtual override returns (string memory) {
2878 
2879         return baseURI;
2880 
2881     }
2882 
2883 
2884 
2885     // public
2886 
2887     function mint(uint256 _mintAmount) public payable {
2888 
2889         require(!paused, "the contract is paused");
2890 
2891         uint256 supply = totalSupply();
2892 
2893         require(_mintAmount > 0, "need to mint at least 1 NFT");
2894 
2895         require(
2896 
2897             _mintAmount <= maxMintAmount,
2898 
2899             "max mint amount per session exceeded"
2900 
2901         );
2902 
2903         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2904 
2905 
2906 
2907         if (msg.sender != owner()) {
2908 
2909             if (onlyWhitelisted == true) {
2910 
2911                 require(isWhitelisted(msg.sender), "user is not whitelisted");
2912 
2913                 uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2914 
2915                 require(
2916 
2917                     ownerMintedCount + _mintAmount <= nftPerAddressLimit,
2918 
2919                     "max NFT per address exceeded"
2920 
2921                 );
2922 
2923             }
2924 
2925             require(
2926 
2927                 msg.value >= getCurrentCost(_mintAmount) * _mintAmount,
2928 
2929                 "insufficient funds"
2930 
2931             );
2932 
2933         }
2934 
2935 
2936 
2937         for (uint256 i = 1; i <= _mintAmount; i++) {
2938 
2939             addressMintedBalance[msg.sender]++;
2940 
2941             _safeMint(msg.sender, supply + i);
2942 
2943         }
2944 
2945     }
2946 
2947 
2948 
2949     function getCurrentCost(uint256 _mintAmount)
2950 
2951         public
2952 
2953         view
2954 
2955         returns (uint256 _cost)
2956 
2957     {
2958 
2959         uint256 supply = totalSupply();
2960 
2961         if (supply + _mintAmount <= 1000) {
2962 
2963             return 0;
2964 
2965         } else if (supply + _mintAmount <= 2000) {
2966 
2967             return cost;
2968 
2969         } else if (supply + _mintAmount <= 3000) {
2970 
2971             return cost * 2;
2972 
2973         } else if (supply + _mintAmount <= 4000) {
2974 
2975             return cost * 3;
2976 
2977         } else if (supply + _mintAmount <= 5000) {
2978 
2979             return cost * 4;
2980 
2981         } else if (supply + _mintAmount <= 6000) {
2982 
2983             return cost * 5;
2984 
2985         } else if (supply + _mintAmount <= maxSupply) {
2986 
2987             return cost * 6;
2988 
2989         }
2990 
2991     }
2992 
2993 
2994 
2995     function isWhitelisted(address _user) public view returns (bool) {
2996 
2997         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
2998 
2999             if (whitelistedAddresses[i] == _user) {
3000 
3001                 return true;
3002 
3003             }
3004 
3005         }
3006 
3007         return false;
3008 
3009     }
3010 
3011 
3012 
3013     function walletOfOwner(address _owner)
3014 
3015         public
3016 
3017         view
3018 
3019         returns (uint256[] memory)
3020 
3021     {
3022 
3023         uint256 ownerTokenCount = balanceOf(_owner);
3024 
3025         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
3026 
3027         for (uint256 i; i < ownerTokenCount; i++) {
3028 
3029             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
3030 
3031         }
3032 
3033         return tokenIds;
3034 
3035     }
3036 
3037 
3038 
3039     function tokenURI(uint256 tokenId)
3040 
3041         public
3042 
3043         view
3044 
3045         virtual
3046 
3047         override
3048 
3049         returns (string memory)
3050 
3051     {
3052 
3053         require(
3054 
3055             _exists(tokenId),
3056 
3057             "ERC721Metadata: URI query for nonexistent token"
3058 
3059         );
3060 
3061 
3062 
3063         if (revealed == false) {
3064 
3065             return notRevealedUri;
3066 
3067         }
3068 
3069 
3070 
3071         string memory currentBaseURI = _baseURI();
3072 
3073         return
3074 
3075             bytes(currentBaseURI).length > 0
3076 
3077                 ? string(
3078 
3079                     abi.encodePacked(
3080 
3081                         currentBaseURI,
3082 
3083                         tokenId.toString(),
3084 
3085                         baseExtension
3086 
3087                     )
3088 
3089                 )
3090 
3091                 : "";
3092 
3093     }
3094 
3095 
3096 
3097     //only owner
3098 
3099     function reveal() public onlyOwner {
3100 
3101         revealed = true;
3102 
3103     }
3104 
3105 
3106 
3107     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
3108 
3109         nftPerAddressLimit = _limit;
3110 
3111     }
3112 
3113 
3114 
3115     function setCost(uint256 _newCost) public onlyOwner {
3116 
3117         cost = _newCost;
3118 
3119     }
3120 
3121 
3122 
3123     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
3124 
3125         maxMintAmount = _newmaxMintAmount;
3126 
3127     }
3128 
3129 
3130 
3131     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3132 
3133         baseURI = _newBaseURI;
3134 
3135     }
3136 
3137 
3138 
3139     function setBaseExtension(string memory _newBaseExtension)
3140 
3141         public
3142 
3143         onlyOwner
3144 
3145     {
3146 
3147         baseExtension = _newBaseExtension;
3148 
3149     }
3150 
3151 
3152 
3153     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
3154 
3155         notRevealedUri = _notRevealedURI;
3156 
3157     }
3158 
3159 
3160 
3161     function pause(bool _state) public onlyOwner {
3162 
3163         paused = _state;
3164 
3165     }
3166 
3167 
3168 
3169     function setOnlyWhitelisted(bool _state) public onlyOwner {
3170 
3171         onlyWhitelisted = _state;
3172 
3173     }
3174 
3175 
3176 
3177     function whitelistUsers(address[] calldata _users) public onlyOwner {
3178 
3179         delete whitelistedAddresses;
3180 
3181         whitelistedAddresses = _users;
3182 
3183     }
3184 
3185 
3186 
3187     function withdraw() external onlyOwner {
3188 
3189         (bool success, ) = payable(msg.sender).call{
3190 
3191             value: address(this).balance
3192 
3193         }("");
3194 
3195         require(success);
3196 
3197     }
3198 
3199 }