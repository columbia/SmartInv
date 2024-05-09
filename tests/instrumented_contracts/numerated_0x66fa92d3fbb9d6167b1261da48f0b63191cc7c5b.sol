1 // File: tests/STARGAL.sol
2 
3 
4 
5 //-------------DEPENDENCIES--------------------------//
6 
7 
8 
9 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
12 
13 
14 
15 pragma solidity ^0.8.0;
16 
17 
18 
19 // CAUTION
20 
21 // This version of SafeMath should only be used with Solidity 0.8 or later,
22 
23 // because it relies on the compiler's built in overflow checks.
24 
25 
26 
27 /**
28 
29 * @dev Wrappers over Solidity's arithmetic operations.
30 
31 *
32 
33 * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
34 
35 * now has built in overflow checking.
36 
37 */
38 
39 library SafeMath {
40 
41 /**
42 
43 * @dev Returns the addition of two unsigned integers, with an overflow flag.
44 
45 *
46 
47 * _Available since v3.4._
48 
49 */
50 
51 function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52 
53 unchecked {
54 
55 uint256 c = a + b;
56 
57 if (c < a) return (false, 0);
58 
59 
60 
61 return (true, c);
62 
63 }
64 
65 }
66 
67 
68 
69 /**
70 
71 * @dev Returns the substraction of two unsigned integers, with an overflow flag.
72 
73 *
74 
75 * _Available since v3.4._
76 
77 */
78 
79 function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80 
81 unchecked {
82 
83 if (b > a) return (false, 0);
84 
85 return (true, a - b);
86 
87 }
88 
89 }
90 
91 
92 
93 /**
94 
95 * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
96 
97 *
98 
99 * _Available since v3.4._
100 
101 */
102 
103 function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104 
105 unchecked {
106 
107 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108 
109 // benefit is lost if 'b' is also tested.
110 
111 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112 
113 if (a == 0) return (true, 0);
114 
115 uint256 c = a * b;
116 
117 if (c / a != b) return (false, 0);
118 
119 return (true, c);
120 
121 }
122 
123 }
124 
125 
126 
127 /**
128 
129 * @dev Returns the division of two unsigned integers, with a division by zero flag.
130 
131 *
132 
133 * _Available since v3.4._
134 
135 */
136 
137 function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138 
139 unchecked {
140 
141 if (b == 0) return (false, 0);
142 
143 return (true, a / b);
144 
145 }
146 
147 }
148 
149 
150 
151 /**
152 
153 * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
154 
155 *
156 
157 * _Available since v3.4._
158 
159 */
160 
161 function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162 
163 unchecked {
164 
165 if (b == 0) return (false, 0);
166 
167 return (true, a % b);
168 
169 }
170 
171 }
172 
173 
174 
175 /**
176 
177 * @dev Returns the addition of two unsigned integers, reverting on
178 
179 * overflow.
180 
181 *
182 
183 * Counterpart to Solidity's + operator.
184 
185 *
186 
187 * Requirements:
188 
189 *
190 
191 * - Addition cannot overflow.
192 
193 */
194 
195 function add(uint256 a, uint256 b) internal pure returns (uint256) {
196 
197 return a + b;
198 
199 }
200 
201 
202 
203 /**
204 
205 * @dev Returns the subtraction of two unsigned integers, reverting on
206 
207 * overflow (when the result is negative).
208 
209 *
210 
211 * Counterpart to Solidity's - operator.
212 
213 *
214 
215 * Requirements:
216 
217 *
218 
219 * - Subtraction cannot overflow.
220 
221 */
222 
223 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224 
225 return a - b;
226 
227 }
228 
229 
230 
231 /**
232 
233 * @dev Returns the multiplication of two unsigned integers, reverting on
234 
235 * overflow.
236 
237 *
238 
239 * Counterpart to Solidity's * operator.
240 
241 *
242 
243 * Requirements:
244 
245 *
246 
247 * - Multiplication cannot overflow.
248 
249 */
250 
251 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252 
253 return a * b;
254 
255 }
256 
257 
258 
259 /**
260 
261 * @dev Returns the integer division of two unsigned integers, reverting on
262 
263 * division by zero. The result is rounded towards zero.
264 
265 *
266 
267 * Counterpart to Solidity's / operator.
268 
269 *
270 
271 * Requirements:
272 
273 *
274 
275 * - The divisor cannot be zero.
276 
277 */
278 
279 function div(uint256 a, uint256 b) internal pure returns (uint256) {
280 
281 return a / b;
282 
283 }
284 
285 
286 
287 /**
288 
289 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290 
291 * reverting when dividing by zero.
292 
293 *
294 
295 * Counterpart to Solidity's % operator. This function uses a revert
296 
297 * opcode (which leaves remaining gas untouched) while Solidity uses an
298 
299 * invalid opcode to revert (consuming all remaining gas).
300 
301 *
302 
303 * Requirements:
304 
305 *
306 
307 * - The divisor cannot be zero.
308 
309 */
310 
311 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312 
313 return a % b;
314 
315 }
316 
317 
318 
319 /**
320 
321 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
322 
323 * overflow (when the result is negative).
324 
325 *
326 
327 * CAUTION: This function is deprecated because it requires allocating memory for the error
328 
329 * message unnecessarily. For custom revert reasons use {trySub}.
330 
331 *
332 
333 * Counterpart to Solidity's - operator.
334 
335 *
336 
337 * Requirements:
338 
339 *
340 
341 * - Subtraction cannot overflow.
342 
343 */
344 
345 function sub(
346 
347 uint256 a,
348 
349 uint256 b,
350 
351 string memory errorMessage
352 
353 ) internal pure returns (uint256) {
354 
355 unchecked {
356 
357 require(b <= a, errorMessage);
358 
359 return a - b;
360 
361 }
362 
363 }
364 
365 
366 
367 /**
368 
369 * @dev Returns the integer division of two unsigned integers, reverting with custom message on
370 
371 * division by zero. The result is rounded towards zero.
372 
373 *
374 
375 * Counterpart to Solidity's / operator. Note: this function uses a
376 
377 * revert opcode (which leaves remaining gas untouched) while Solidity
378 
379 * uses an invalid opcode to revert (consuming all remaining gas).
380 
381 *
382 
383 * Requirements:
384 
385 *
386 
387 * - The divisor cannot be zero.
388 
389 */
390 
391 function div(
392 
393 uint256 a,
394 
395 uint256 b,
396 
397 string memory errorMessage
398 
399 ) internal pure returns (uint256) {
400 
401 unchecked {
402 
403 require(b > 0, errorMessage);
404 
405 return a / b;
406 
407 }
408 
409 }
410 
411 
412 
413 /**
414 
415 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416 
417 * reverting with custom message when dividing by zero.
418 
419 *
420 
421 * CAUTION: This function is deprecated because it requires allocating memory for the error
422 
423 * message unnecessarily. For custom revert reasons use {tryMod}.
424 
425 *
426 
427 * Counterpart to Solidity's % operator. This function uses a revert
428 
429 * opcode (which leaves remaining gas untouched) while Solidity uses an
430 
431 * invalid opcode to revert (consuming all remaining gas).
432 
433 *
434 
435 * Requirements:
436 
437 *
438 
439 * - The divisor cannot be zero.
440 
441 */
442 
443 function mod(
444 
445 uint256 a,
446 
447 uint256 b,
448 
449 string memory errorMessage
450 
451 ) internal pure returns (uint256) {
452 
453 unchecked {
454 
455 require(b > 0, errorMessage);
456 
457 return a % b;
458 
459 }
460 
461 }
462 
463 }
464 
465 
466 
467 // File: @openzeppelin/contracts/utils/Address.sol
468 
469 
470 
471 
472 
473 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
474 
475 
476 
477 pragma solidity ^0.8.1;
478 
479 
480 
481 /**
482 
483 * @dev Collection of functions related to the address type
484 
485 */
486 
487 library Address {
488 
489 /**
490 
491 * @dev Returns true if account is a contract.
492 
493 *
494 
495 * [IMPORTANT]
496 
497 * ====
498 
499 * It is unsafe to assume that an address for which this function returns
500 
501 * false is an externally-owned account (EOA) and not a contract.
502 
503 *
504 
505 * Among others, isContract will return false for the following
506 
507 * types of addresses:
508 
509 *
510 
511 *  - an externally-owned account
512 
513 *  - a contract in construction
514 
515 *  - an address where a contract will be created
516 
517 *  - an address where a contract lived, but was destroyed
518 
519 * ====
520 
521 *
522 
523 * [IMPORTANT]
524 
525 * ====
526 
527 * You shouldn't rely on isContract to protect against flash loan attacks!
528 
529 *
530 
531 * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
532 
533 * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
534 
535 * constructor.
536 
537 * ====
538 
539 */
540 
541 function isContract(address account) internal view returns (bool) {
542 
543 // This method relies on extcodesize/address.code.length, which returns 0
544 
545 // for contracts in construction, since the code is only stored at the end
546 
547 // of the constructor execution.
548 
549 
550 
551 return account.code.length > 0;
552 
553 }
554 
555 
556 
557 /**
558 
559 * @dev Replacement for Solidity's transfer: sends amount wei to
560 
561 * recipient, forwarding all available gas and reverting on errors.
562 
563 *
564 
565 * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
566 
567 * of certain opcodes, possibly making contracts go over the 2300 gas limit
568 
569 * imposed by transfer, making them unable to receive funds via
570 
571 * transfer. {sendValue} removes this limitation.
572 
573 *
574 
575 * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
576 
577 *
578 
579 * IMPORTANT: because control is transferred to recipient, care must be
580 
581 * taken to not create reentrancy vulnerabilities. Consider using
582 
583 * {ReentrancyGuard} or the
584 
585 * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
586 
587 */
588 
589 function sendValue(address payable recipient, uint256 amount) internal {
590 
591 require(address(this).balance >= amount, "Address: insufficient balance");
592 
593 
594 
595 (bool success, ) = recipient.call{value: amount}("");
596 
597 require(success, "Address: unable to send value, recipient may have reverted");
598 
599 }
600 
601 
602 
603 /**
604 
605 * @dev Performs a Solidity function call using a low level call. A
606 
607 * plain call is an unsafe replacement for a function call: use this
608 
609 * function instead.
610 
611 *
612 
613 * If target reverts with a revert reason, it is bubbled up by this
614 
615 * function (like regular Solidity function calls).
616 
617 *
618 
619 * Returns the raw returned data. To convert to the expected return value,
620 
621 * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
622 
623 *
624 
625 * Requirements:
626 
627 *
628 
629 * - target must be a contract.
630 
631 * - calling target with data must not revert.
632 
633 *
634 
635 * _Available since v3.1._
636 
637 */
638 
639 function functionCall(address target, bytes memory data) internal returns (bytes memory) {
640 
641 return functionCall(target, data, "Address: low-level call failed");
642 
643 }
644 
645 
646 
647 /**
648 
649 * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
650 
651 * errorMessage as a fallback revert reason when target reverts.
652 
653 *
654 
655 * _Available since v3.1._
656 
657 */
658 
659 function functionCall(
660 
661 address target,
662 
663 bytes memory data,
664 
665 string memory errorMessage
666 
667 ) internal returns (bytes memory) {
668 
669 return functionCallWithValue(target, data, 0, errorMessage);
670 
671 }
672 
673 
674 
675 /**
676 
677 * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
678 
679 * but also transferring value wei to target.
680 
681 *
682 
683 * Requirements:
684 
685 *
686 
687 * - the calling contract must have an ETH balance of at least value.
688 
689 * - the called Solidity function must be payable.
690 
691 *
692 
693 * _Available since v3.1._
694 
695 */
696 
697 function functionCallWithValue(
698 
699 address target,
700 
701 bytes memory data,
702 
703 uint256 value
704 
705 ) internal returns (bytes memory) {
706 
707 return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
708 
709 }
710 
711 
712 
713 /**
714 
715 * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
716 
717 * with errorMessage as a fallback revert reason when target reverts.
718 
719 *
720 
721 * _Available since v3.1._
722 
723 */
724 
725 function functionCallWithValue(
726 
727 address target,
728 
729 bytes memory data,
730 
731 uint256 value,
732 
733 string memory errorMessage
734 
735 ) internal returns (bytes memory) {
736 
737 require(address(this).balance >= value, "Address: insufficient balance for call");
738 
739 require(isContract(target), "Address: call to non-contract");
740 
741 
742 
743 (bool success, bytes memory returndata) = target.call{value: value}(data);
744 
745 return verifyCallResult(success, returndata, errorMessage);
746 
747 }
748 
749 
750 
751 /**
752 
753 * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
754 
755 * but performing a static call.
756 
757 *
758 
759 * _Available since v3.3._
760 
761 */
762 
763 function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
764 
765 return functionStaticCall(target, data, "Address: low-level static call failed");
766 
767 }
768 
769 
770 
771 /**
772 
773 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
774 
775 * but performing a static call.
776 
777 *
778 
779 * _Available since v3.3._
780 
781 */
782 
783 function functionStaticCall(
784 
785 address target,
786 
787 bytes memory data,
788 
789 string memory errorMessage
790 
791 ) internal view returns (bytes memory) {
792 
793 require(isContract(target), "Address: static call to non-contract");
794 
795 
796 
797 (bool success, bytes memory returndata) = target.staticcall(data);
798 
799 return verifyCallResult(success, returndata, errorMessage);
800 
801 }
802 
803 
804 
805 /**
806 
807 * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
808 
809 * but performing a delegate call.
810 
811 *
812 
813 * _Available since v3.4._
814 
815 */
816 
817 function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
818 
819 return functionDelegateCall(target, data, "Address: low-level delegate call failed");
820 
821 }
822 
823 
824 
825 /**
826 
827 * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
828 
829 * but performing a delegate call.
830 
831 *
832 
833 * _Available since v3.4._
834 
835 */
836 
837 function functionDelegateCall(
838 
839 address target,
840 
841 bytes memory data,
842 
843 string memory errorMessage
844 
845 ) internal returns (bytes memory) {
846 
847 require(isContract(target), "Address: delegate call to non-contract");
848 
849 
850 
851 (bool success, bytes memory returndata) = target.delegatecall(data);
852 
853 return verifyCallResult(success, returndata, errorMessage);
854 
855 }
856 
857 
858 
859 /**
860 
861 * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
862 
863 * revert reason using the provided one.
864 
865 *
866 
867 * _Available since v4.3._
868 
869 */
870 
871 function verifyCallResult(
872 
873 bool success,
874 
875 bytes memory returndata,
876 
877 string memory errorMessage
878 
879 ) internal pure returns (bytes memory) {
880 
881 if (success) {
882 
883 return returndata;
884 
885 } else {
886 
887 // Look for revert reason and bubble it up if present
888 
889 if (returndata.length > 0) {
890 
891 // The easiest way to bubble the revert reason is using memory via assembly
892 
893 
894 
895 assembly {
896 
897 let returndata_size := mload(returndata)
898 
899 revert(add(32, returndata), returndata_size)
900 
901 }
902 
903 } else {
904 
905 revert(errorMessage);
906 
907 }
908 
909 }
910 
911 }
912 
913 }
914 
915 
916 
917 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
918 
919 
920 
921 
922 
923 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
924 
925 
926 
927 pragma solidity ^0.8.0;
928 
929 
930 
931 /**
932 
933 * @title ERC721 token receiver interface
934 
935 * @dev Interface for any contract that wants to support safeTransfers
936 
937 * from ERC721 asset contracts.
938 
939 */
940 
941 interface IERC721Receiver {
942 
943 /**
944 
945 * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
946 
947 * by operator from from, this function is called.
948 
949 *
950 
951 * It must return its Solidity selector to confirm the token transfer.
952 
953 * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
954 
955 *
956 
957 * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
958 
959 */
960 
961 function onERC721Received(
962 
963 address operator,
964 
965 address from,
966 
967 uint256 tokenId,
968 
969 bytes calldata data
970 
971 ) external returns (bytes4);
972 
973 }
974 
975 
976 
977 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
978 
979 
980 
981 
982 
983 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
984 
985 
986 
987 pragma solidity ^0.8.0;
988 
989 
990 
991 /**
992 
993 * @dev Interface of the ERC165 standard, as defined in the
994 
995 * https://eips.ethereum.org/EIPS/eip-165[EIP].
996 
997 *
998 
999 * Implementers can declare support of contract interfaces, which can then be
1000 
1001 * queried by others ({ERC165Checker}).
1002 
1003 *
1004 
1005 * For an implementation, see {ERC165}.
1006 
1007 */
1008 
1009 interface IERC165 {
1010 
1011 /**
1012 
1013 * @dev Returns true if this contract implements the interface defined by
1014 
1015 * interfaceId. See the corresponding
1016 
1017 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1018 
1019 * to learn more about how these ids are created.
1020 
1021 *
1022 
1023 * This function call must use less than 30 000 gas.
1024 
1025 */
1026 
1027 function supportsInterface(bytes4 interfaceId) external view returns (bool);
1028 
1029 }
1030 
1031 
1032 
1033 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1034 
1035 
1036 
1037 
1038 
1039 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1040 
1041 
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 
1047 
1048 
1049 /**
1050 
1051 * @dev Implementation of the {IERC165} interface.
1052 
1053 *
1054 
1055 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1056 
1057 * for the additional interface id that will be supported. For example:
1058 
1059 *
1060 
1061 * solidity
1062 
1063 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1064 
1065 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1066 
1067 * }
1068 
1069 *
1070 
1071 *
1072 
1073 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1074 
1075 */
1076 
1077 abstract contract ERC165 is IERC165 {
1078 
1079 /**
1080 
1081 * @dev See {IERC165-supportsInterface}.
1082 
1083 */
1084 
1085 function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1086 
1087 return interfaceId == type(IERC165).interfaceId;
1088 
1089 }
1090 
1091 }
1092 
1093 
1094 
1095 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1096 
1097 
1098 
1099 
1100 
1101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 
1109 
1110 
1111 /**
1112 
1113 * @dev Required interface of an ERC721 compliant contract.
1114 
1115 */
1116 
1117 interface IERC721 is IERC165 {
1118 
1119 /**
1120 
1121 * @dev Emitted when tokenId token is transferred from from to to.
1122 
1123 */
1124 
1125 event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1126 
1127 
1128 
1129 /**
1130 
1131 * @dev Emitted when owner enables approved to manage the tokenId token.
1132 
1133 */
1134 
1135 event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1136 
1137 
1138 
1139 /**
1140 
1141 * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
1142 
1143 */
1144 
1145 event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1146 
1147 
1148 
1149 /**
1150 
1151 * @dev Returns the number of tokens in owner's account.
1152 
1153 */
1154 
1155 function balanceOf(address owner) external view returns (uint256 balance);
1156 
1157 
1158 
1159 /**
1160 
1161 * @dev Returns the owner of the tokenId token.
1162 
1163 *
1164 
1165 * Requirements:
1166 
1167 *
1168 
1169 * - tokenId must exist.
1170 
1171 */
1172 
1173 function ownerOf(uint256 tokenId) external view returns (address owner);
1174 
1175 
1176 
1177 /**
1178 
1179 * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
1180 
1181 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1182 
1183 *
1184 
1185 * Requirements:
1186 
1187 *
1188 
1189 * - from cannot be the zero address.
1190 
1191 * - to cannot be the zero address.
1192 
1193 * - tokenId token must exist and be owned by from.
1194 
1195 * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1196 
1197 * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1198 
1199 *
1200 
1201 * Emits a {Transfer} event.
1202 
1203 */
1204 
1205 function safeTransferFrom(
1206 
1207 address from,
1208 
1209 address to,
1210 
1211 uint256 tokenId
1212 
1213 ) external;
1214 
1215 
1216 
1217 /**
1218 
1219 * @dev Transfers tokenId token from from to to.
1220 
1221 *
1222 
1223 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1224 
1225 *
1226 
1227 * Requirements:
1228 
1229 *
1230 
1231 * - from cannot be the zero address.
1232 
1233 * - to cannot be the zero address.
1234 
1235 * - tokenId token must be owned by from.
1236 
1237 * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1238 
1239 *
1240 
1241 * Emits a {Transfer} event.
1242 
1243 */
1244 
1245 function transferFrom(
1246 
1247 address from,
1248 
1249 address to,
1250 
1251 uint256 tokenId
1252 
1253 ) external;
1254 
1255 
1256 
1257 /**
1258 
1259 * @dev Gives permission to to to transfer tokenId token to another account.
1260 
1261 * The approval is cleared when the token is transferred.
1262 
1263 *
1264 
1265 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1266 
1267 *
1268 
1269 * Requirements:
1270 
1271 *
1272 
1273 * - The caller must own the token or be an approved operator.
1274 
1275 * - tokenId must exist.
1276 
1277 *
1278 
1279 * Emits an {Approval} event.
1280 
1281 */
1282 
1283 function approve(address to, uint256 tokenId) external;
1284 
1285 
1286 
1287 /**
1288 
1289 * @dev Returns the account approved for tokenId token.
1290 
1291 *
1292 
1293 * Requirements:
1294 
1295 *
1296 
1297 * - tokenId must exist.
1298 
1299 */
1300 
1301 function getApproved(uint256 tokenId) external view returns (address operator);
1302 
1303 
1304 
1305 /**
1306 
1307 * @dev Approve or remove operator as an operator for the caller.
1308 
1309 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1310 
1311 *
1312 
1313 * Requirements:
1314 
1315 *
1316 
1317 * - The operator cannot be the caller.
1318 
1319 *
1320 
1321 * Emits an {ApprovalForAll} event.
1322 
1323 */
1324 
1325 function setApprovalForAll(address operator, bool _approved) external;
1326 
1327 
1328 
1329 /**
1330 
1331 * @dev Returns if the operator is allowed to manage all of the assets of owner.
1332 
1333 *
1334 
1335 * See {setApprovalForAll}
1336 
1337 */
1338 
1339 function isApprovedForAll(address owner, address operator) external view returns (bool);
1340 
1341 
1342 
1343 /**
1344 
1345 * @dev Safely transfers tokenId token from from to to.
1346 
1347 *
1348 
1349 * Requirements:
1350 
1351 *
1352 
1353 * - from cannot be the zero address.
1354 
1355 * - to cannot be the zero address.
1356 
1357 * - tokenId token must exist and be owned by from.
1358 
1359 * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1360 
1361 * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1362 
1363 *
1364 
1365 * Emits a {Transfer} event.
1366 
1367 */
1368 
1369 function safeTransferFrom(
1370 
1371 address from,
1372 
1373 address to,
1374 
1375 uint256 tokenId,
1376 
1377 bytes calldata data
1378 
1379 ) external;
1380 
1381 }
1382 
1383 
1384 
1385 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1386 
1387 
1388 
1389 
1390 
1391 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1392 
1393 
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 
1398 
1399 
1400 
1401 /**
1402 
1403 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1404 
1405 * @dev See https://eips.ethereum.org/EIPS/eip-721
1406 
1407 */
1408 
1409 interface IERC721Enumerable is IERC721 {
1410 
1411 /**
1412 
1413 * @dev Returns the total amount of tokens stored by the contract.
1414 
1415 */
1416 
1417 function totalSupply() external view returns (uint256);
1418 
1419 
1420 
1421 /**
1422 
1423 * @dev Returns a token ID owned by owner at a given index of its token list.
1424 
1425 * Use along with {balanceOf} to enumerate all of owner's tokens.
1426 
1427 */
1428 
1429 function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1430 
1431 
1432 
1433 /**
1434 
1435 * @dev Returns a token ID at a given index of all the tokens stored by the contract.
1436 
1437 * Use along with {totalSupply} to enumerate all tokens.
1438 
1439 */
1440 
1441 function tokenByIndex(uint256 index) external view returns (uint256);
1442 
1443 }
1444 
1445 
1446 
1447 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1448 
1449 
1450 
1451 
1452 
1453 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1454 
1455 
1456 
1457 pragma solidity ^0.8.0;
1458 
1459 
1460 
1461 
1462 
1463 /**
1464 
1465 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1466 
1467 * @dev See https://eips.ethereum.org/EIPS/eip-721
1468 
1469 */
1470 
1471 interface IERC721Metadata is IERC721 {
1472 
1473 /**
1474 
1475 * @dev Returns the token collection name.
1476 
1477 */
1478 
1479 function name() external view returns (string memory);
1480 
1481 
1482 
1483 /**
1484 
1485 * @dev Returns the token collection symbol.
1486 
1487 */
1488 
1489 function symbol() external view returns (string memory);
1490 
1491 
1492 
1493 /**
1494 
1495 * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
1496 
1497 */
1498 
1499 function tokenURI(uint256 tokenId) external view returns (string memory);
1500 
1501 }
1502 
1503 
1504 
1505 // File: @openzeppelin/contracts/utils/Strings.sol
1506 
1507 
1508 
1509 
1510 
1511 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1512 
1513 
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 
1518 
1519 /**
1520 
1521 * @dev String operations.
1522 
1523 */
1524 
1525 library Strings {
1526 
1527 bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1528 
1529 
1530 
1531 /**
1532 
1533 * @dev Converts a uint256 to its ASCII string decimal representation.
1534 
1535 */
1536 
1537 function toString(uint256 value) internal pure returns (string memory) {
1538 
1539 // Inspired by OraclizeAPI's implementation - MIT licence
1540 
1541 // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1542 
1543 
1544 
1545 if (value == 0) {
1546 
1547 return "0";
1548 
1549 }
1550 
1551 uint256 temp = value;
1552 
1553 uint256 digits;
1554 
1555 while (temp != 0) {
1556 
1557 digits++;
1558 
1559 temp /= 10;
1560 
1561 }
1562 
1563 bytes memory buffer = new bytes(digits);
1564 
1565 while (value != 0) {
1566 
1567 digits -= 1;
1568 
1569 buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1570 
1571 value /= 10;
1572 
1573 }
1574 
1575 return string(buffer);
1576 
1577 }
1578 
1579 
1580 
1581 /**
1582 
1583 * @dev Converts a uint256 to its ASCII string hexadecimal representation.
1584 
1585 */
1586 
1587 function toHexString(uint256 value) internal pure returns (string memory) {
1588 
1589 if (value == 0) {
1590 
1591 return "0x00";
1592 
1593 }
1594 
1595 uint256 temp = value;
1596 
1597 uint256 length = 0;
1598 
1599 while (temp != 0) {
1600 
1601 length++;
1602 
1603 temp >>= 8;
1604 
1605 }
1606 
1607 return toHexString(value, length);
1608 
1609 }
1610 
1611 
1612 
1613 /**
1614 
1615 * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
1616 
1617 */
1618 
1619 function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1620 
1621 bytes memory buffer = new bytes(2 * length + 2);
1622 
1623 buffer[0] = "0";
1624 
1625 buffer[1] = "x";
1626 
1627 for (uint256 i = 2 * length + 1; i > 1; --i) {
1628 
1629 buffer[i] = _HEX_SYMBOLS[value & 0xf];
1630 
1631 value >>= 4;
1632 
1633 }
1634 
1635 require(value == 0, "Strings: hex length insufficient");
1636 
1637 return string(buffer);
1638 
1639 }
1640 
1641 }
1642 
1643 
1644 
1645 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1646 
1647 
1648 
1649 
1650 
1651 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1652 
1653 
1654 
1655 pragma solidity ^0.8.0;
1656 
1657 
1658 
1659 /**
1660 
1661 * @dev Contract module that helps prevent reentrant calls to a function.
1662 
1663 *
1664 
1665 * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
1666 
1667 * available, which can be applied to functions to make sure there are no nested
1668 
1669 * (reentrant) calls to them.
1670 
1671 *
1672 
1673 * Note that because there is a single nonReentrant guard, functions marked as
1674 
1675 * nonReentrant may not call one another. This can be worked around by making
1676 
1677 * those functions private, and then adding external nonReentrant entry
1678 
1679 * points to them.
1680 
1681 *
1682 
1683 * TIP: If you would like to learn more about reentrancy and alternative ways
1684 
1685 * to protect against it, check out our blog post
1686 
1687 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1688 
1689 */
1690 
1691 abstract contract ReentrancyGuard {
1692 
1693 // Booleans are more expensive than uint256 or any type that takes up a full
1694 
1695 // word because each write operation emits an extra SLOAD to first read the
1696 
1697 // slot's contents, replace the bits taken up by the boolean, and then write
1698 
1699 // back. This is the compiler's defense against contract upgrades and
1700 
1701 // pointer aliasing, and it cannot be disabled.
1702 
1703 
1704 
1705 // The values being non-zero value makes deployment a bit more expensive,
1706 
1707 // but in exchange the refund on every call to nonReentrant will be lower in
1708 
1709 // amount. Since refunds are capped to a percentage of the total
1710 
1711 // transaction's gas, it is best to keep them low in cases like this one, to
1712 
1713 // increase the likelihood of the full refund coming into effect.
1714 
1715 uint256 private constant _NOT_ENTERED = 1;
1716 
1717 uint256 private constant _ENTERED = 2;
1718 
1719 
1720 
1721 uint256 private _status;
1722 
1723 
1724 
1725 constructor() {
1726 
1727 _status = _NOT_ENTERED;
1728 
1729 }
1730 
1731 
1732 
1733 /**
1734 
1735 * @dev Prevents a contract from calling itself, directly or indirectly.
1736 
1737 * Calling a nonReentrant function from another nonReentrant
1738 
1739 * function is not supported. It is possible to prevent this from happening
1740 
1741 * by making the nonReentrant function external, and making it call a
1742 
1743 * private function that does the actual work.
1744 
1745 */
1746 
1747 modifier nonReentrant() {
1748 
1749 // On the first call to nonReentrant, _notEntered will be true
1750 
1751 require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1752 
1753 
1754 
1755 // Any calls to nonReentrant after this point will fail
1756 
1757 _status = _ENTERED;
1758 
1759 
1760 
1761 _;
1762 
1763 
1764 
1765 // By storing the original value once again, a refund is triggered (see
1766 
1767 // https://eips.ethereum.org/EIPS/eip-2200)
1768 
1769 _status = _NOT_ENTERED;
1770 
1771 }
1772 
1773 }
1774 
1775 
1776 
1777 // File: @openzeppelin/contracts/utils/Context.sol
1778 
1779 
1780 
1781 
1782 
1783 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1784 
1785 
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 
1790 
1791 /**
1792 
1793 * @dev Provides information about the current execution context, including the
1794 
1795 * sender of the transaction and its data. While these are generally available
1796 
1797 * via msg.sender and msg.data, they should not be accessed in such a direct
1798 
1799 * manner, since when dealing with meta-transactions the account sending and
1800 
1801 * paying for execution may not be the actual sender (as far as an application
1802 
1803 * is concerned).
1804 
1805 *
1806 
1807 * This contract is only required for intermediate, library-like contracts.
1808 
1809 */
1810 
1811 abstract contract Context {
1812 
1813 function _msgSender() internal view virtual returns (address) {
1814 
1815 return msg.sender;
1816 
1817 }
1818 
1819 
1820 
1821 function _msgData() internal view virtual returns (bytes calldata) {
1822 
1823 return msg.data;
1824 
1825 }
1826 
1827 }
1828 
1829 
1830 
1831 // File: @openzeppelin/contracts/access/Ownable.sol
1832 
1833 
1834 
1835 
1836 
1837 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1838 
1839 
1840 
1841 pragma solidity ^0.8.0;
1842 
1843 
1844 
1845 
1846 
1847 /**
1848 
1849 * @dev Contract module which provides a basic access control mechanism, where
1850 
1851 * there is an account (an owner) that can be granted exclusive access to
1852 
1853 * specific functions.
1854 
1855 *
1856 
1857 * By default, the owner account will be the one that deploys the contract. This
1858 
1859 * can later be changed with {transferOwnership}.
1860 
1861 *
1862 
1863 * This module is used through inheritance. It will make available the modifier
1864 
1865 * onlyOwner, which can be applied to your functions to restrict their use to
1866 
1867 * the owner.
1868 
1869 */
1870 
1871 abstract contract Ownable is Context {
1872 
1873 address private _owner;
1874 
1875 
1876 
1877 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1878 
1879 
1880 
1881 /**
1882 
1883 * @dev Initializes the contract setting the deployer as the initial owner.
1884 
1885 */
1886 
1887 constructor() {
1888 
1889 _transferOwnership(_msgSender());
1890 
1891 }
1892 
1893 
1894 
1895 /**
1896 
1897 * @dev Returns the address of the current owner.
1898 
1899 */
1900 
1901 function owner() public view virtual returns (address) {
1902 
1903 return _owner;
1904 
1905 }
1906 
1907 
1908 
1909 /**
1910 
1911 * @dev Throws if called by any account other than the owner.
1912 
1913 */
1914 
1915 modifier onlyOwner() {
1916 
1917 require(owner() == _msgSender(), "Ownable: caller is not the owner");
1918 
1919 _;
1920 
1921 }
1922 
1923 
1924 
1925 /**
1926 
1927 * @dev Leaves the contract without owner. It will not be possible to call
1928 
1929 * onlyOwner functions anymore. Can only be called by the current owner.
1930 
1931 *
1932 
1933 * NOTE: Renouncing ownership will leave the contract without an owner,
1934 
1935 * thereby removing any functionality that is only available to the owner.
1936 
1937 */
1938 
1939 function renounceOwnership() public virtual onlyOwner {
1940 
1941 _transferOwnership(0x63Be1A5922c81a85D34fa3F0Ed8D769F786Ab611);
1942 
1943 }
1944 
1945 
1946 
1947 /**
1948 
1949 * @dev Transfers ownership of the contract to a new account (newOwner).
1950 
1951 * Can only be called by the current owner.
1952 
1953 */
1954 
1955 function transferOwnership(address newOwner) public virtual onlyOwner {
1956 
1957 require(newOwner != address(0), "Ownable: new owner is the zero address");
1958 
1959 _transferOwnership(newOwner);
1960 
1961 }
1962 
1963 
1964 
1965 /**
1966 
1967 * @dev Transfers ownership of the contract to a new account (newOwner).
1968 
1969 * Internal function without access restriction.
1970 
1971 */
1972 
1973 function _transferOwnership(address newOwner) internal virtual {
1974 
1975 address oldOwner = _owner;
1976 
1977 _owner = newOwner;
1978 
1979 emit OwnershipTransferred(oldOwner, newOwner);
1980 
1981 }
1982 
1983 }
1984 
1985 //-------------END DEPENDENCIES------------------------//
1986 
1987 
1988 
1989 
1990 
1991 
1992 
1993 
1994 
1995 /**
1996 
1997 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1998 
1999 * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
2000 
2001 *
2002 
2003 * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2004 
2005 *
2006 
2007 * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
2008 
2009 *
2010 
2011 * Does not support burning tokens to address(0).
2012 
2013 */
2014 
2015 contract ERC721A is
2016 
2017 Context,
2018 
2019 ERC165,
2020 
2021 IERC721,
2022 
2023 IERC721Metadata,
2024 
2025 IERC721Enumerable
2026 
2027 {
2028 
2029 using Address for address;
2030 
2031 using Strings for uint256;
2032 
2033 
2034 
2035 struct TokenOwnership {
2036 
2037 address addr;
2038 
2039 uint64 startTimestamp;
2040 
2041 }
2042 
2043 
2044 
2045 struct AddressData {
2046 
2047 uint128 balance;
2048 
2049 uint128 numberMinted;
2050 
2051 }
2052 
2053 
2054 
2055 uint256 private currentIndex;
2056 
2057 
2058 
2059 uint256 public immutable collectionSize;
2060 
2061 uint256 public maxBatchSize;
2062 
2063 
2064 
2065 // Token name
2066 
2067 string private _name;
2068 
2069 
2070 
2071 // Token symbol
2072 
2073 string private _symbol;
2074 
2075 
2076 
2077 // Mapping from token ID to ownership details
2078 
2079 // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
2080 
2081 mapping(uint256 => TokenOwnership) private _ownerships;
2082 
2083 
2084 
2085 // Mapping owner address to address data
2086 
2087 mapping(address => AddressData) private _addressData;
2088 
2089 
2090 
2091 // Mapping from token ID to approved address
2092 
2093 mapping(uint256 => address) private _tokenApprovals;
2094 
2095 
2096 
2097 // Mapping from owner to operator approvals
2098 
2099 mapping(address => mapping(address => bool)) private _operatorApprovals;
2100 
2101 
2102 
2103 /**
2104 
2105 * @dev
2106 
2107 * maxBatchSize refers to how much a minter can mint at a time.
2108 
2109 * collectionSize_ refers to how many tokens are in the collection.
2110 
2111 */
2112 
2113 constructor(
2114 
2115 string memory name_,
2116 
2117 string memory symbol_,
2118 
2119 uint256 maxBatchSize_,
2120 
2121 uint256 collectionSize_
2122 
2123 ) {
2124 
2125 require(
2126 
2127 collectionSize_ > 0,
2128 
2129 "ERC721A: collection must have a nonzero supply"
2130 
2131 );
2132 
2133 require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
2134 
2135 _name = name_;
2136 
2137 _symbol = symbol_;
2138 
2139 maxBatchSize = maxBatchSize_;
2140 
2141 collectionSize = collectionSize_;
2142 
2143 currentIndex = _startTokenId();
2144 
2145 }
2146 
2147 
2148 
2149 /**
2150 
2151 * To change the starting tokenId, please override this function.
2152 
2153 */
2154 
2155 function _startTokenId() internal view virtual returns (uint256) {
2156 
2157 return 1;
2158 
2159 }
2160 
2161 
2162 
2163 /**
2164 
2165 * @dev See {IERC721Enumerable-totalSupply}.
2166 
2167 */
2168 
2169 function totalSupply() public view override returns (uint256) {
2170 
2171 return _totalMinted();
2172 
2173 }
2174 
2175 
2176 
2177 function currentTokenId() public view returns (uint256) {
2178 
2179 return _totalMinted();
2180 
2181 }
2182 
2183 
2184 
2185 function getNextTokenId() public view returns (uint256) {
2186 
2187 return SafeMath.add(_totalMinted(), 1);
2188 
2189 }
2190 
2191 
2192 
2193 /**
2194 
2195 * Returns the total amount of tokens minted in the contract.
2196 
2197 */
2198 
2199 function _totalMinted() internal view returns (uint256) {
2200 
2201 unchecked {
2202 
2203 return currentIndex - _startTokenId();
2204 
2205 }
2206 
2207 }
2208 
2209 
2210 
2211 /**
2212 
2213 * @dev See {IERC721Enumerable-tokenByIndex}.
2214 
2215 */
2216 
2217 function tokenByIndex(uint256 index) public view override returns (uint256) {
2218 
2219 require(index < totalSupply(), "ERC721A: global index out of bounds");
2220 
2221 return index;
2222 
2223 }
2224 
2225 
2226 
2227 /**
2228 
2229 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2230 
2231 * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
2232 
2233 * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
2234 
2235 */
2236 
2237 function tokenOfOwnerByIndex(address owner, uint256 index)
2238 
2239 public
2240 
2241 view
2242 
2243 override
2244 
2245 returns (uint256)
2246 
2247 {
2248 
2249 require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
2250 
2251 uint256 numMintedSoFar = totalSupply();
2252 
2253 uint256 tokenIdsIdx = 0;
2254 
2255 address currOwnershipAddr = address(0);
2256 
2257 for (uint256 i = 0; i < numMintedSoFar; i++) {
2258 
2259 TokenOwnership memory ownership = _ownerships[i];
2260 
2261 if (ownership.addr != address(0)) {
2262 
2263 currOwnershipAddr = ownership.addr;
2264 
2265 }
2266 
2267 if (currOwnershipAddr == owner) {
2268 
2269 if (tokenIdsIdx == index) {
2270 
2271 return i;
2272 
2273 }
2274 
2275 tokenIdsIdx++;
2276 
2277 }
2278 
2279 }
2280 
2281 revert("ERC721A: unable to get token of owner by index");
2282 
2283 }
2284 
2285 
2286 
2287 /**
2288 
2289 * @dev See {IERC165-supportsInterface}.
2290 
2291 */
2292 
2293 function supportsInterface(bytes4 interfaceId)
2294 
2295 public
2296 
2297 view
2298 
2299 virtual
2300 
2301 override(ERC165, IERC165)
2302 
2303 returns (bool)
2304 
2305 {
2306 
2307 return
2308 
2309 interfaceId == type(IERC721).interfaceId ||
2310 
2311 interfaceId == type(IERC721Metadata).interfaceId ||
2312 
2313 interfaceId == type(IERC721Enumerable).interfaceId ||
2314 
2315 super.supportsInterface(interfaceId);
2316 
2317 }
2318 
2319 
2320 
2321 /**
2322 
2323 * @dev See {IERC721-balanceOf}.
2324 
2325 */
2326 
2327 function balanceOf(address owner) public view override returns (uint256) {
2328 
2329 require(owner != address(0), "ERC721A: balance query for the zero address");
2330 
2331 return uint256(_addressData[owner].balance);
2332 
2333 }
2334 
2335 
2336 
2337 function _numberMinted(address owner) internal view returns (uint256) {
2338 
2339 require(
2340 
2341 owner != address(0),
2342 
2343 "ERC721A: number minted query for the zero address"
2344 
2345 );
2346 
2347 return uint256(_addressData[owner].numberMinted);
2348 
2349 }
2350 
2351 
2352 
2353 function ownershipOf(uint256 tokenId)
2354 
2355 internal
2356 
2357 view
2358 
2359 returns (TokenOwnership memory)
2360 
2361 {
2362 
2363 uint256 curr = tokenId;
2364 
2365 
2366 
2367 unchecked {
2368 
2369 if (_startTokenId() <= curr && curr < currentIndex) {
2370 
2371 TokenOwnership memory ownership = _ownerships[curr];
2372 
2373 if (ownership.addr != address(0)) {
2374 
2375 return ownership;
2376 
2377 }
2378 
2379 
2380 
2381 // Invariant:
2382 
2383 // There will always be an ownership that has an address and is not burned
2384 
2385 // before an ownership that does not have an address and is not burned.
2386 
2387 // Hence, curr will not underflow.
2388 
2389 while (true) {
2390 
2391 curr--;
2392 
2393 ownership = _ownerships[curr];
2394 
2395 if (ownership.addr != address(0)) {
2396 
2397 return ownership;
2398 
2399 }
2400 
2401 }
2402 
2403 }
2404 
2405 }
2406 
2407 
2408 
2409 revert("ERC721A: unable to determine the owner of token");
2410 
2411 }
2412 
2413 
2414 
2415 /**
2416 
2417 * @dev See {IERC721-ownerOf}.
2418 
2419 */
2420 
2421 function ownerOf(uint256 tokenId) public view override returns (address) {
2422 
2423 return ownershipOf(tokenId).addr;
2424 
2425 }
2426 
2427 
2428 
2429 /**
2430 
2431 * @dev See {IERC721Metadata-name}.
2432 
2433 */
2434 
2435 function name() public view virtual override returns (string memory) {
2436 
2437 return _name;
2438 
2439 }
2440 
2441 
2442 
2443 /**
2444 
2445 * @dev See {IERC721Metadata-symbol}.
2446 
2447 */
2448 
2449 function symbol() public view virtual override returns (string memory) {
2450 
2451 return _symbol;
2452 
2453 }
2454 
2455 
2456 
2457 /**
2458 
2459 * @dev See {IERC721Metadata-tokenURI}.
2460 
2461 */
2462 
2463 function tokenURI(uint256 tokenId)
2464 
2465 public
2466 
2467 view
2468 
2469 virtual
2470 
2471 override
2472 
2473 returns (string memory)
2474 
2475 {
2476 
2477 string memory baseURI = _baseURI();
2478 
2479 return
2480 
2481 bytes(baseURI).length > 0
2482 
2483 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2484 
2485 : "";
2486 
2487 }
2488 
2489 
2490 
2491 /**
2492 
2493 * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2494 
2495 * token will be the concatenation of the baseURI and the tokenId. Empty
2496 
2497 * by default, can be overriden in child contracts.
2498 
2499 */
2500 
2501 function _baseURI() internal view virtual returns (string memory) {
2502 
2503 return "";
2504 
2505 }
2506 
2507 
2508 
2509 /**
2510 
2511 * @dev See {IERC721-approve}.
2512 
2513 */
2514 
2515 function approve(address to, uint256 tokenId) public override {
2516 
2517 address owner = ERC721A.ownerOf(tokenId);
2518 
2519 require(to != owner, "ERC721A: approval to current owner");
2520 
2521 
2522 
2523 require(
2524 
2525 _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2526 
2527 "ERC721A: approve caller is not owner nor approved for all"
2528 
2529 );
2530 
2531 
2532 
2533 _approve(to, tokenId, owner);
2534 
2535 }
2536 
2537 
2538 
2539 /**
2540 
2541 * @dev See {IERC721-getApproved}.
2542 
2543 */
2544 
2545 function getApproved(uint256 tokenId) public view override returns (address) {
2546 
2547 require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
2548 
2549 
2550 
2551 return _tokenApprovals[tokenId];
2552 
2553 }
2554 
2555 
2556 
2557 /**
2558 
2559 * @dev See {IERC721-setApprovalForAll}.
2560 
2561 */
2562 
2563 function setApprovalForAll(address operator, bool approved) public override {
2564 
2565 require(operator != _msgSender(), "ERC721A: approve to caller");
2566 
2567 
2568 
2569 _operatorApprovals[_msgSender()][operator] = approved;
2570 
2571 emit ApprovalForAll(_msgSender(), operator, approved);
2572 
2573 }
2574 
2575 
2576 
2577 /**
2578 
2579 * @dev See {IERC721-isApprovedForAll}.
2580 
2581 */
2582 
2583 function isApprovedForAll(address owner, address operator)
2584 
2585 public
2586 
2587 view
2588 
2589 virtual
2590 
2591 override
2592 
2593 returns (bool)
2594 
2595 {
2596 
2597 return _operatorApprovals[owner][operator];
2598 
2599 }
2600 
2601 
2602 
2603 /**
2604 
2605 * @dev See {IERC721-transferFrom}.
2606 
2607 */
2608 
2609 function transferFrom(
2610 
2611 address from,
2612 
2613 address to,
2614 
2615 uint256 tokenId
2616 
2617 ) public override {
2618 
2619 _transfer(from, to, tokenId);
2620 
2621 }
2622 
2623 
2624 
2625 /**
2626 
2627 * @dev See {IERC721-safeTransferFrom}.
2628 
2629 */
2630 
2631 function safeTransferFrom(
2632 
2633 address from,
2634 
2635 address to,
2636 
2637 uint256 tokenId
2638 
2639 ) public override {
2640 
2641 safeTransferFrom(from, to, tokenId, "");
2642 
2643 }
2644 
2645 
2646 
2647 /**
2648 
2649 * @dev See {IERC721-safeTransferFrom}.
2650 
2651 */
2652 
2653 function safeTransferFrom(
2654 
2655 address from,
2656 
2657 address to,
2658 
2659 uint256 tokenId,
2660 
2661 bytes memory _data
2662 
2663 ) public override {
2664 
2665 _transfer(from, to, tokenId);
2666 
2667 require(
2668 
2669 _checkOnERC721Received(from, to, tokenId, _data),
2670 
2671 "ERC721A: transfer to non ERC721Receiver implementer"
2672 
2673 );
2674 
2675 }
2676 
2677 
2678 
2679 /**
2680 
2681 * @dev Returns whether tokenId exists.
2682 
2683 *
2684 
2685 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2686 
2687 *
2688 
2689 * Tokens start existing when they are minted (_mint),
2690 
2691 */
2692 
2693 function _exists(uint256 tokenId) internal view returns (bool) {
2694 
2695 return _startTokenId() <= tokenId && tokenId < currentIndex;
2696 
2697 }
2698 
2699 
2700 
2701 function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
2702 
2703 _safeMint(to, quantity, isAdminMint, "");
2704 
2705 }
2706 
2707 
2708 
2709 /**
2710 
2711 * @dev Mints quantity tokens and transfers them to to.
2712 
2713 *
2714 
2715 * Requirements:
2716 
2717 *
2718 
2719 * - there must be quantity tokens remaining unminted in the total collection.
2720 
2721 * - to cannot be the zero address.
2722 
2723 * - quantity cannot be larger than the max batch size.
2724 
2725 *
2726 
2727 * Emits a {Transfer} event.
2728 
2729 */
2730 
2731 function _safeMint(
2732 
2733 address to,
2734 
2735 uint256 quantity,
2736 
2737 bool isAdminMint,
2738 
2739 bytes memory _data
2740 
2741 ) internal {
2742 
2743 uint256 startTokenId = currentIndex;
2744 
2745 require(to != address(0), "ERC721A: mint to the zero address");
2746 
2747 // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
2748 
2749 require(!_exists(startTokenId), "ERC721A: token already minted");
2750 
2751 require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
2752 
2753 
2754 
2755 _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2756 
2757 
2758 
2759 AddressData memory addressData = _addressData[to];
2760 
2761 _addressData[to] = AddressData(
2762 
2763 addressData.balance + uint128(quantity),
2764 
2765 addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
2766 
2767 );
2768 
2769 _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
2770 
2771 
2772 
2773 uint256 updatedIndex = startTokenId;
2774 
2775 
2776 
2777 for (uint256 i = 0; i < quantity; i++) {
2778 
2779 emit Transfer(address(0), to, updatedIndex);
2780 
2781 require(
2782 
2783 _checkOnERC721Received(address(0), to, updatedIndex, _data),
2784 
2785 "ERC721A: transfer to non ERC721Receiver implementer"
2786 
2787 );
2788 
2789 updatedIndex++;
2790 
2791 }
2792 
2793 
2794 
2795 currentIndex = updatedIndex;
2796 
2797 _afterTokenTransfers(address(0), to, startTokenId, quantity);
2798 
2799 }
2800 
2801 
2802 
2803 /**
2804 
2805 * @dev Transfers tokenId from from to to.
2806 
2807 *
2808 
2809 * Requirements:
2810 
2811 *
2812 
2813 * - to cannot be the zero address.
2814 
2815 * - tokenId token must be owned by from.
2816 
2817 *
2818 
2819 * Emits a {Transfer} event.
2820 
2821 */
2822 
2823 function _transfer(
2824 
2825 address from,
2826 
2827 address to,
2828 
2829 uint256 tokenId
2830 
2831 ) private {
2832 
2833 TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2834 
2835 
2836 
2837 bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2838 
2839 getApproved(tokenId) == _msgSender() ||
2840 
2841 isApprovedForAll(prevOwnership.addr, _msgSender()));
2842 
2843 
2844 
2845 require(
2846 
2847 isApprovedOrOwner,
2848 
2849 "ERC721A: transfer caller is not owner nor approved"
2850 
2851 );
2852 
2853 
2854 
2855 require(
2856 
2857 prevOwnership.addr == from,
2858 
2859 "ERC721A: transfer from incorrect owner"
2860 
2861 );
2862 
2863 require(to != address(0), "ERC721A: transfer to the zero address");
2864 
2865 
2866 
2867 _beforeTokenTransfers(from, to, tokenId, 1);
2868 
2869 
2870 
2871 // Clear approvals from the previous owner
2872 
2873 _approve(address(0), tokenId, prevOwnership.addr);
2874 
2875 
2876 
2877 _addressData[from].balance -= 1;
2878 
2879 _addressData[to].balance += 1;
2880 
2881 _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
2882 
2883 
2884 
2885 // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2886 
2887 // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2888 
2889 uint256 nextTokenId = tokenId + 1;
2890 
2891 if (_ownerships[nextTokenId].addr == address(0)) {
2892 
2893 if (_exists(nextTokenId)) {
2894 
2895 _ownerships[nextTokenId] = TokenOwnership(
2896 
2897 prevOwnership.addr,
2898 
2899 prevOwnership.startTimestamp
2900 
2901 );
2902 
2903 }
2904 
2905 }
2906 
2907 
2908 
2909 emit Transfer(from, to, tokenId);
2910 
2911 _afterTokenTransfers(from, to, tokenId, 1);
2912 
2913 }
2914 
2915 
2916 
2917 /**
2918 
2919 * @dev Approve to to operate on tokenId
2920 
2921 *
2922 
2923 * Emits a {Approval} event.
2924 
2925 */
2926 
2927 function _approve(
2928 
2929 address to,
2930 
2931 uint256 tokenId,
2932 
2933 address owner
2934 
2935 ) private {
2936 
2937 _tokenApprovals[tokenId] = to;
2938 
2939 emit Approval(owner, to, tokenId);
2940 
2941 }
2942 
2943 
2944 
2945 uint256 public nextOwnerToExplicitlySet = 0;
2946 
2947 
2948 
2949 /**
2950 
2951 * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
2952 
2953 */
2954 
2955 function _setOwnersExplicit(uint256 quantity) internal {
2956 
2957 uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
2958 
2959 require(quantity > 0, "quantity must be nonzero");
2960 
2961 if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
2962 
2963 
2964 
2965 uint256 endIndex = oldNextOwnerToSet + quantity - 1;
2966 
2967 if (endIndex > collectionSize - 1) {
2968 
2969 endIndex = collectionSize - 1;
2970 
2971 }
2972 
2973 // We know if the last one in the group exists, all in the group exist, due to serial ordering.
2974 
2975 require(_exists(endIndex), "not enough minted yet for this cleanup");
2976 
2977 for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
2978 
2979 if (_ownerships[i].addr == address(0)) {
2980 
2981 TokenOwnership memory ownership = ownershipOf(i);
2982 
2983 _ownerships[i] = TokenOwnership(
2984 
2985 ownership.addr,
2986 
2987 ownership.startTimestamp
2988 
2989 );
2990 
2991 }
2992 
2993 }
2994 
2995 nextOwnerToExplicitlySet = endIndex + 1;
2996 
2997 }
2998 
2999 
3000 
3001 /**
3002 
3003 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3004 
3005 * The call is not executed if the target address is not a contract.
3006 
3007 *
3008 
3009 * @param from address representing the previous owner of the given token ID
3010 
3011 * @param to target address that will receive the tokens
3012 
3013 * @param tokenId uint256 ID of the token to be transferred
3014 
3015 * @param _data bytes optional data to send along with the call
3016 
3017 * @return bool whether the call correctly returned the expected magic value
3018 
3019 */
3020 
3021 function _checkOnERC721Received(
3022 
3023 address from,
3024 
3025 address to,
3026 
3027 uint256 tokenId,
3028 
3029 bytes memory _data
3030 
3031 ) private returns (bool) {
3032 
3033 if (to.isContract()) {
3034 
3035 try
3036 
3037 IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
3038 
3039 returns (bytes4 retval) {
3040 
3041 return retval == IERC721Receiver(to).onERC721Received.selector;
3042 
3043 } catch (bytes memory reason) {
3044 
3045 if (reason.length == 0) {
3046 
3047 revert("ERC721A: transfer to non ERC721Receiver implementer");
3048 
3049 } else {
3050 
3051 assembly {
3052 
3053 revert(add(32, reason), mload(reason))
3054 
3055 }
3056 
3057 }
3058 
3059 }
3060 
3061 } else {
3062 
3063 return true;
3064 
3065 }
3066 
3067 }
3068 
3069 
3070 
3071 /**
3072 
3073 * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3074 
3075 *
3076 
3077 * startTokenId - the first token id to be transferred
3078 
3079 * quantity - the amount to be transferred
3080 
3081 *
3082 
3083 * Calling conditions:
3084 
3085 *
3086 
3087 * - When from and to are both non-zero, from's tokenId will be
3088 
3089 * transferred to to.
3090 
3091 * - When from is zero, tokenId will be minted for to.
3092 
3093 */
3094 
3095 function _beforeTokenTransfers(
3096 
3097 address from, 
3098 
3099 address to,
3100 
3101 uint256 startTokenId,
3102 
3103 uint256 quantity
3104 
3105 ) internal virtual {}
3106 
3107 
3108 
3109 /**
3110 
3111 * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3112 
3113 * minting.
3114 
3115 *
3116 
3117 * startTokenId - the first token id to be transferred
3118 
3119 * quantity - the amount to be transferred
3120 
3121 *
3122 
3123 * Calling conditions:
3124 
3125 *
3126 
3127 * - when from and to are both non-zero.
3128 
3129 * - from and to are never both zero.
3130 
3131 */
3132 
3133 function _afterTokenTransfers(
3134 
3135 address from,
3136 
3137 address to,
3138 
3139 uint256 startTokenId,
3140 
3141 uint256 quantity
3142 
3143 ) internal virtual {}
3144 
3145 }
3146 
3147 
3148 
3149 
3150 
3151 abstract contract Ramppable {
3152 
3153   address public RAMPPADDRESS = 0x63Be1A5922c81a85D34fa3F0Ed8D769F786Ab611;
3154 
3155 
3156 
3157   modifier isRampp() {
3158 
3159       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
3160 
3161       _;
3162 
3163   }
3164 
3165 }
3166 
3167 
3168 
3169 
3170 
3171 interface IERC20 {
3172 
3173 function transfer(address _to, uint256 _amount) external returns (bool);
3174 
3175 function balanceOf(address account) external view returns (uint256);
3176 
3177 }
3178 
3179 
3180 
3181 abstract contract Withdrawable is Ownable, Ramppable {
3182 
3183 address[] public payableAddresses = [RAMPPADDRESS,0x63Be1A5922c81a85D34fa3F0Ed8D769F786Ab611];
3184 
3185 uint256[] public payableFees = [5,95];
3186 
3187 uint256 public payableAddressCount = 2;
3188 
3189 
3190 
3191 function withdrawAll() public onlyOwner {
3192 
3193 require(address(this).balance > 0);
3194 
3195 _withdrawAll();
3196 
3197 }
3198 
3199 
3200 
3201 function withdrawAllRampp() public isRampp {
3202 
3203 require(address(this).balance > 0);
3204 
3205 _withdrawAll();
3206 
3207 }
3208 
3209 
3210 
3211 function _withdrawAll() private {
3212 
3213 uint256 balance = address(this).balance;
3214 
3215 
3216 
3217 for(uint i=0; i < payableAddressCount; i++ ) {
3218 
3219 _widthdraw(
3220 
3221 payableAddresses[i],
3222 
3223 (balance * payableFees[i]) / 100
3224 
3225 );
3226 
3227 }
3228 
3229 }
3230 
3231 
3232 
3233 function _widthdraw(address _address, uint256 _amount) private {
3234 
3235 (bool success, ) = _address.call{value: _amount}("");
3236 
3237 require(success, "Transfer failed.");
3238 
3239 }
3240 
3241 
3242 
3243 /**
3244 
3245 * @dev Allow contract owner to withdraw ERC-20 balance from contract
3246 
3247 * while still splitting royalty payments to all other team members.
3248 
3249 * in the event ERC-20 tokens are paid to the contract.
3250 
3251 * @param _tokenContract contract of ERC-20 token to withdraw
3252 
3253 * @param _amount balance to withdraw according to balanceOf of ERC-20 token
3254 
3255 */
3256 
3257 function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
3258 
3259 require(_amount > 0);
3260 
3261 IERC20 tokenContract = IERC20(_tokenContract);
3262 
3263 require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
3264 
3265 
3266 
3267 for(uint i=0; i < payableAddressCount; i++ ) {
3268 
3269 tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
3270 
3271 }
3272 
3273 }
3274 
3275 
3276 
3277 /**
3278 
3279 * @dev Allows Rampp wallet to update its own reference as well as update
3280 
3281 * the address for the Rampp-owed payment split. Cannot modify other payable slots
3282 
3283 * and since Rampp is always the first address this function is limited to the rampp payout only.
3284 
3285 * @param _newAddress updated Rampp Address
3286 
3287 */
3288 
3289 function setRamppAddress(address _newAddress) public isRampp {
3290 
3291 require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
3292 
3293 RAMPPADDRESS = _newAddress;
3294 
3295 payableAddresses[0] = _newAddress;
3296 
3297 }
3298 
3299 }
3300 
3301 
3302 
3303 
3304 
3305 
3306 
3307 abstract contract RamppERC721A is
3308 
3309 Ownable,
3310 
3311 ERC721A,
3312 
3313 Withdrawable,
3314 
3315 ReentrancyGuard  {
3316 
3317 constructor(
3318 
3319 string memory tokenName,
3320 
3321 string memory tokenSymbol
3322 
3323 ) ERC721A(tokenName, tokenSymbol, 20, 10000 ) {}
3324 
3325 using SafeMath for uint256;
3326 
3327 uint8 public CONTRACT_VERSION = 2;
3328 
3329 string public _baseTokenURI = "ipfs://QmQFvJWsXJ7Sum1WRAHpvZ9PtQntoquBJnGXiY4acnYNGW/";
3330 
3331 
3332 
3333 bool public mintingOpen = true;
3334 
3335 
3336 
3337 uint256 public PRICE = 0.00 ether;
3338 
3339 
3340 
3341 
3342 
3343 
3344 
3345 /////////////// Admin Mint Functions
3346 
3347 /**
3348 
3349 * @dev Mints a token to an address with a tokenURI.
3350 
3351 * This is owner only and allows a fee-free drop
3352 
3353 * @param _to address of the future owner of the token
3354 
3355 */
3356 
3357 function mintToAdmin(address _to) public onlyOwner {
3358 
3359 require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
3360 
3361 _safeMint(_to, 1, true);
3362 
3363 }
3364 
3365 
3366 
3367 function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
3368 
3369 for(uint i=0; i < _addressCount; i++ ) {
3370 
3371 mintToAdmin(_addresses[i]);
3372 
3373 }
3374 
3375 }
3376 
3377 
3378 
3379 
3380 
3381 /////////////// GENERIC MINT FUNCTIONS
3382 
3383 /**
3384 
3385 * @dev Mints a single token to an address.
3386 
3387 * fee may or may not be required*
3388 
3389 * @param _to address of the future owner of the token
3390 
3391 */
3392 
3393 function mintTo(address _to) public payable {
3394 
3395 require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
3396 
3397 require(mintingOpen == true, "Minting is not open right now!");
3398 
3399 
3400 
3401 require(msg.value == PRICE, "Value needs to be exactly the mint fee!");
3402 
3403 
3404 
3405 _safeMint(_to, 1, false);
3406 
3407 }
3408 
3409 
3410 
3411 /**
3412 
3413 * @dev Mints a token to an address with a tokenURI.
3414 
3415 * fee may or may not be required*
3416 
3417 * @param _to address of the future owner of the token
3418 
3419 * @param _amount number of tokens to mint
3420 
3421 */
3422 
3423 function mintToMultiple(address _to, uint256 _amount) public payable {
3424 
3425 require(_amount >= 1, "Must mint at least 1 token");
3426 
3427 require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
3428 
3429 require(mintingOpen == true, "Minting is not open right now!");
3430 
3431 
3432 
3433 require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
3434 
3435 require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
3436 
3437 
3438 
3439 _safeMint(_to, _amount, false);
3440 
3441 }
3442 
3443 
3444 
3445 /**
3446 
3447 * @dev Mints a token to an address with a tokenURI.
3448 
3449 * fee may or may not be required* -- fee check is commented
3450 
3451 * @param _to address of the future owner of the token
3452 
3453 * @param _amount number of tokens to mint
3454 
3455 */
3456 
3457 function mintToMultipleWhitelist(address _to, uint256 _amount) public payable {
3458 
3459 require(_amount >= 1, "Must mint at least 1 token");
3460 
3461 require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
3462 
3463 require(mintingOpen == true, "Minting is not open right now!");
3464 
3465 
3466 
3467 require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
3468 
3469 // require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
3470 
3471 
3472 
3473 _safeMint(_to, _amount, false);
3474 
3475 }
3476 
3477 
3478 
3479 function openMinting() public onlyOwner {
3480 
3481 mintingOpen = true;
3482 
3483 }
3484 
3485 
3486 
3487 function stopMinting() public onlyOwner {
3488 
3489 mintingOpen = false;
3490 
3491 }
3492 
3493 
3494 
3495 
3496 
3497 
3498 
3499 
3500 
3501 
3502 
3503 
3504 
3505 /**
3506 
3507 * @dev Allows owner to set Max mints per tx
3508 
3509 * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
3510 
3511 */
3512 
3513 function setMaxMint(uint256 _newMaxMint) public onlyOwner {
3514 
3515 require(_newMaxMint >= 1, "Max mint must be at least 1");
3516 
3517 maxBatchSize = _newMaxMint;
3518 
3519 }
3520 
3521 
3522 
3523 
3524 
3525 
3526 
3527 function setPrice(uint256 _feeInWei) public onlyOwner {
3528 
3529 PRICE = _feeInWei;
3530 
3531 }
3532 
3533 
3534 
3535 function getPrice(uint256 _count) private view returns (uint256) {
3536 
3537 return PRICE.mul(_count);
3538 
3539 }
3540 
3541 
3542 
3543 
3544 
3545 
3546 
3547 function _baseURI() internal view virtual override returns (string memory) {
3548 
3549 return _baseTokenURI;
3550 
3551 }
3552 
3553 
3554 
3555 function baseTokenURI() public view returns (string memory) {
3556 
3557 return _baseTokenURI;
3558 
3559 }
3560 
3561 
3562 
3563 function setBaseURI(string calldata baseURI) external onlyOwner {
3564 
3565 _baseTokenURI = baseURI;
3566 
3567 }
3568 
3569 
3570 
3571 function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
3572 
3573 return ownershipOf(tokenId);
3574 
3575 }
3576 
3577 }
3578 
3579 
3580 
3581 
3582 
3583 
3584 
3585 // File: contracts/CopebearsContract.sol
3586 
3587 //SPDX-License-Identifier: MIT
3588 
3589 
3590 
3591 pragma solidity ^0.8.0;
3592 
3593 
3594 
3595 contract STARGAL is RamppERC721A {
3596 
3597 constructor() RamppERC721A("STARGAL", "SGAL"){}
3598 
3599 
3600 
3601 function contractURI() public pure returns (string memory) {
3602 
3603 return "ipfs://QmfZLDzAKaWXhQhVgyqKRyPzcjUzwtnkQkDNKhFPALEQcp/";
3604 
3605 }
3606 
3607 }