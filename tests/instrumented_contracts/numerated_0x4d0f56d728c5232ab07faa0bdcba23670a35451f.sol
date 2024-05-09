1 // File: contracts/IUniswapV2Factory.sol
2 
3 
4 
5 pragma solidity 0.8.13;
6 
7 
8 
9 interface IUniswapV2Factory {
10 
11     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
12 
13 
14 
15     function feeTo() external view returns (address);
16 
17     function feeToSetter() external view returns (address);
18 
19 
20 
21     function getPair(address tokenA, address tokenB) external view returns (address pair);
22 
23     function allPairs(uint) external view returns (address pair);
24 
25     function allPairsLength() external view returns (uint);
26 
27 
28 
29     function createPair(address tokenA, address tokenB) external returns (address pair);
30 
31 
32 
33     function setFeeTo(address) external;
34 
35     function setFeeToSetter(address) external;
36 
37 }
38 
39 
40 // File: contracts/utils/SafeCast.sol
41 
42 
43 
44 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
45 
46 
47 
48 pragma solidity ^0.8.0;
49 
50 
51 
52 /**
53 
54  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
55 
56  * checks.
57 
58  *
59 
60  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
61 
62  * easily result in undesired exploitation or bugs, since developers usually
63 
64  * assume that overflows raise errors. `SafeCast` restores this intuition by
65 
66  * reverting the transaction when such an operation overflows.
67 
68  *
69 
70  * Using this library instead of the unchecked operations eliminates an entire
71 
72  * class of bugs, so it's recommended to use it always.
73 
74  *
75 
76  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
77 
78  * all math on `uint256` and `int256` and then downcasting.
79 
80  */
81 
82 library SafeCast {
83 
84     /**
85 
86      * @dev Returns the downcasted uint224 from uint256, reverting on
87 
88      * overflow (when the input is greater than largest uint224).
89 
90      *
91 
92      * Counterpart to Solidity's `uint224` operator.
93 
94      *
95 
96      * Requirements:
97 
98      *
99 
100      * - input must fit into 224 bits
101 
102      */
103 
104     function toUint224(uint256 value) internal pure returns (uint224) {
105 
106         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
107 
108         return uint224(value);
109 
110     }
111 
112 
113 
114     /**
115 
116      * @dev Returns the downcasted uint128 from uint256, reverting on
117 
118      * overflow (when the input is greater than largest uint128).
119 
120      *
121 
122      * Counterpart to Solidity's `uint128` operator.
123 
124      *
125 
126      * Requirements:
127 
128      *
129 
130      * - input must fit into 128 bits
131 
132      */
133 
134     function toUint128(uint256 value) internal pure returns (uint128) {
135 
136         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
137 
138         return uint128(value);
139 
140     }
141 
142 
143 
144     /**
145 
146      * @dev Returns the downcasted uint96 from uint256, reverting on
147 
148      * overflow (when the input is greater than largest uint96).
149 
150      *
151 
152      * Counterpart to Solidity's `uint96` operator.
153 
154      *
155 
156      * Requirements:
157 
158      *
159 
160      * - input must fit into 96 bits
161 
162      */
163 
164     function toUint96(uint256 value) internal pure returns (uint96) {
165 
166         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
167 
168         return uint96(value);
169 
170     }
171 
172 
173 
174     /**
175 
176      * @dev Returns the downcasted uint64 from uint256, reverting on
177 
178      * overflow (when the input is greater than largest uint64).
179 
180      *
181 
182      * Counterpart to Solidity's `uint64` operator.
183 
184      *
185 
186      * Requirements:
187 
188      *
189 
190      * - input must fit into 64 bits
191 
192      */
193 
194     function toUint64(uint256 value) internal pure returns (uint64) {
195 
196         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
197 
198         return uint64(value);
199 
200     }
201 
202 
203 
204     /**
205 
206      * @dev Returns the downcasted uint32 from uint256, reverting on
207 
208      * overflow (when the input is greater than largest uint32).
209 
210      *
211 
212      * Counterpart to Solidity's `uint32` operator.
213 
214      *
215 
216      * Requirements:
217 
218      *
219 
220      * - input must fit into 32 bits
221 
222      */
223 
224     function toUint32(uint256 value) internal pure returns (uint32) {
225 
226         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
227 
228         return uint32(value);
229 
230     }
231 
232 
233 
234     /**
235 
236      * @dev Returns the downcasted uint16 from uint256, reverting on
237 
238      * overflow (when the input is greater than largest uint16).
239 
240      *
241 
242      * Counterpart to Solidity's `uint16` operator.
243 
244      *
245 
246      * Requirements:
247 
248      *
249 
250      * - input must fit into 16 bits
251 
252      */
253 
254     function toUint16(uint256 value) internal pure returns (uint16) {
255 
256         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
257 
258         return uint16(value);
259 
260     }
261 
262 
263 
264     /**
265 
266      * @dev Returns the downcasted uint8 from uint256, reverting on
267 
268      * overflow (when the input is greater than largest uint8).
269 
270      *
271 
272      * Counterpart to Solidity's `uint8` operator.
273 
274      *
275 
276      * Requirements:
277 
278      *
279 
280      * - input must fit into 8 bits.
281 
282      */
283 
284     function toUint8(uint256 value) internal pure returns (uint8) {
285 
286         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
287 
288         return uint8(value);
289 
290     }
291 
292 
293 
294     /**
295 
296      * @dev Converts a signed int256 into an unsigned uint256.
297 
298      *
299 
300      * Requirements:
301 
302      *
303 
304      * - input must be greater than or equal to 0.
305 
306      */
307 
308     function toUint256(int256 value) internal pure returns (uint256) {
309 
310         require(value >= 0, "SafeCast: value must be positive");
311 
312         return uint256(value);
313 
314     }
315 
316 
317 
318     /**
319 
320      * @dev Returns the downcasted int128 from int256, reverting on
321 
322      * overflow (when the input is less than smallest int128 or
323 
324      * greater than largest int128).
325 
326      *
327 
328      * Counterpart to Solidity's `int128` operator.
329 
330      *
331 
332      * Requirements:
333 
334      *
335 
336      * - input must fit into 128 bits
337 
338      *
339 
340      * _Available since v3.1._
341 
342      */
343 
344     function toInt128(int256 value) internal pure returns (int128) {
345 
346         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
347 
348         return int128(value);
349 
350     }
351 
352 
353 
354     /**
355 
356      * @dev Returns the downcasted int64 from int256, reverting on
357 
358      * overflow (when the input is less than smallest int64 or
359 
360      * greater than largest int64).
361 
362      *
363 
364      * Counterpart to Solidity's `int64` operator.
365 
366      *
367 
368      * Requirements:
369 
370      *
371 
372      * - input must fit into 64 bits
373 
374      *
375 
376      * _Available since v3.1._
377 
378      */
379 
380     function toInt64(int256 value) internal pure returns (int64) {
381 
382         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
383 
384         return int64(value);
385 
386     }
387 
388 
389 
390     /**
391 
392      * @dev Returns the downcasted int32 from int256, reverting on
393 
394      * overflow (when the input is less than smallest int32 or
395 
396      * greater than largest int32).
397 
398      *
399 
400      * Counterpart to Solidity's `int32` operator.
401 
402      *
403 
404      * Requirements:
405 
406      *
407 
408      * - input must fit into 32 bits
409 
410      *
411 
412      * _Available since v3.1._
413 
414      */
415 
416     function toInt32(int256 value) internal pure returns (int32) {
417 
418         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
419 
420         return int32(value);
421 
422     }
423 
424 
425 
426     /**
427 
428      * @dev Returns the downcasted int16 from int256, reverting on
429 
430      * overflow (when the input is less than smallest int16 or
431 
432      * greater than largest int16).
433 
434      *
435 
436      * Counterpart to Solidity's `int16` operator.
437 
438      *
439 
440      * Requirements:
441 
442      *
443 
444      * - input must fit into 16 bits
445 
446      *
447 
448      * _Available since v3.1._
449 
450      */
451 
452     function toInt16(int256 value) internal pure returns (int16) {
453 
454         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
455 
456         return int16(value);
457 
458     }
459 
460 
461 
462     /**
463 
464      * @dev Returns the downcasted int8 from int256, reverting on
465 
466      * overflow (when the input is less than smallest int8 or
467 
468      * greater than largest int8).
469 
470      *
471 
472      * Counterpart to Solidity's `int8` operator.
473 
474      *
475 
476      * Requirements:
477 
478      *
479 
480      * - input must fit into 8 bits.
481 
482      *
483 
484      * _Available since v3.1._
485 
486      */
487 
488     function toInt8(int256 value) internal pure returns (int8) {
489 
490         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
491 
492         return int8(value);
493 
494     }
495 
496 
497 
498     /**
499 
500      * @dev Converts an unsigned uint256 into a signed int256.
501 
502      *
503 
504      * Requirements:
505 
506      *
507 
508      * - input must be less than or equal to maxInt256.
509 
510      */
511 
512     function toInt256(uint256 value) internal pure returns (int256) {
513 
514         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
515 
516         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
517 
518         return int256(value);
519 
520     }
521 
522 }
523 
524 
525 // File: contracts/extensions/IVotes.sol
526 
527 
528 
529 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 
535 /**
536 
537  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
538 
539  *
540 
541  * _Available since v4.5._
542 
543  */
544 
545 interface IVotes {
546 
547     /**
548 
549      * @dev Emitted when an account changes their delegate.
550 
551      */
552 
553     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
554 
555 
556 
557     /**
558 
559      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
560 
561      */
562 
563     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
564 
565 
566 
567     /**
568 
569      * @dev Returns the current amount of votes that `account` has.
570 
571      */
572 
573     function getVotes(address account) external view returns (uint256);
574 
575 
576 
577     /**
578 
579      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
580 
581      */
582 
583     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
584 
585 
586 
587     /**
588 
589      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
590 
591      *
592 
593      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
594 
595      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
596 
597      * vote.
598 
599      */
600 
601     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
602 
603 
604 
605     /**
606 
607      * @dev Returns the delegate that `account` has chosen.
608 
609      */
610 
611     function delegates(address account) external view returns (address);
612 
613 
614 
615     /**
616 
617      * @dev Delegates votes from the sender to `delegatee`.
618 
619      */
620 
621     function delegate(address delegatee) external;
622 
623 
624 
625     /**
626 
627      * @dev Delegates votes from signer to `delegatee`.
628 
629      */
630 
631     function delegateBySig(
632 
633         address delegatee,
634 
635         uint256 nonce,
636 
637         uint256 expiry,
638 
639         uint8 v,
640 
641         bytes32 r,
642 
643         bytes32 s
644 
645     ) external;
646 
647 }
648 
649 
650 // File: contracts/utils/Strings.sol
651 
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
655 
656 
657 
658 pragma solidity ^0.8.0;
659 
660 
661 
662 /**
663 
664  * @dev String operations.
665 
666  */
667 
668 library Strings {
669 
670     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
671 
672 
673 
674     /**
675 
676      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
677 
678      */
679 
680     function toString(uint256 value) internal pure returns (string memory) {
681 
682         // Inspired by OraclizeAPI's implementation - MIT licence
683 
684         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
685 
686 
687 
688         if (value == 0) {
689 
690             return "0";
691 
692         }
693 
694         uint256 temp = value;
695 
696         uint256 digits;
697 
698         while (temp != 0) {
699 
700             digits++;
701 
702             temp /= 10;
703 
704         }
705 
706         bytes memory buffer = new bytes(digits);
707 
708         while (value != 0) {
709 
710             digits -= 1;
711 
712             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
713 
714             value /= 10;
715 
716         }
717 
718         return string(buffer);
719 
720     }
721 
722 
723 
724     /**
725 
726      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
727 
728      */
729 
730     function toHexString(uint256 value) internal pure returns (string memory) {
731 
732         if (value == 0) {
733 
734             return "0x00";
735 
736         }
737 
738         uint256 temp = value;
739 
740         uint256 length = 0;
741 
742         while (temp != 0) {
743 
744             length++;
745 
746             temp >>= 8;
747 
748         }
749 
750         return toHexString(value, length);
751 
752     }
753 
754 
755 
756     /**
757 
758      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
759 
760      */
761 
762     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
763 
764         bytes memory buffer = new bytes(2 * length + 2);
765 
766         buffer[0] = "0";
767 
768         buffer[1] = "x";
769 
770         for (uint256 i = 2 * length + 1; i > 1; --i) {
771 
772             buffer[i] = _HEX_SYMBOLS[value & 0xf];
773 
774             value >>= 4;
775 
776         }
777 
778         require(value == 0, "Strings: hex length insufficient");
779 
780         return string(buffer);
781 
782     }
783 
784 }
785 
786 
787 // File: contracts/utils/ECDSA.sol
788 
789 
790 
791 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
792 
793 
794 
795 pragma solidity ^0.8.0;
796 
797 
798 
799 
800 /**
801 
802  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
803 
804  *
805 
806  * These functions can be used to verify that a message was signed by the holder
807 
808  * of the private keys of a given address.
809 
810  */
811 
812 library ECDSA {
813 
814     enum RecoverError {
815 
816         NoError,
817 
818         InvalidSignature,
819 
820         InvalidSignatureLength,
821 
822         InvalidSignatureS,
823 
824         InvalidSignatureV
825 
826     }
827 
828 
829 
830     function _throwError(RecoverError error) private pure {
831 
832         if (error == RecoverError.NoError) {
833 
834             return; // no error: do nothing
835 
836         } else if (error == RecoverError.InvalidSignature) {
837 
838             revert("ECDSA: invalid signature");
839 
840         } else if (error == RecoverError.InvalidSignatureLength) {
841 
842             revert("ECDSA: invalid signature length");
843 
844         } else if (error == RecoverError.InvalidSignatureS) {
845 
846             revert("ECDSA: invalid signature 's' value");
847 
848         } else if (error == RecoverError.InvalidSignatureV) {
849 
850             revert("ECDSA: invalid signature 'v' value");
851 
852         }
853 
854     }
855 
856 
857 
858     /**
859 
860      * @dev Returns the address that signed a hashed message (`hash`) with
861 
862      * `signature` or error string. This address can then be used for verification purposes.
863 
864      *
865 
866      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
867 
868      * this function rejects them by requiring the `s` value to be in the lower
869 
870      * half order, and the `v` value to be either 27 or 28.
871 
872      *
873 
874      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
875 
876      * verification to be secure: it is possible to craft signatures that
877 
878      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
879 
880      * this is by receiving a hash of the original message (which may otherwise
881 
882      * be too long), and then calling {toEthSignedMessageHash} on it.
883 
884      *
885 
886      * Documentation for signature generation:
887 
888      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
889 
890      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
891 
892      *
893 
894      * _Available since v4.3._
895 
896      */
897 
898     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
899 
900         // Check the signature length
901 
902         // - case 65: r,s,v signature (standard)
903 
904         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
905 
906         if (signature.length == 65) {
907 
908             bytes32 r;
909 
910             bytes32 s;
911 
912             uint8 v;
913 
914             // ecrecover takes the signature parameters, and the only way to get them
915 
916             // currently is to use assembly.
917 
918             assembly {
919 
920                 r := mload(add(signature, 0x20))
921 
922                 s := mload(add(signature, 0x40))
923 
924                 v := byte(0, mload(add(signature, 0x60)))
925 
926             }
927 
928             return tryRecover(hash, v, r, s);
929 
930         } else if (signature.length == 64) {
931 
932             bytes32 r;
933 
934             bytes32 vs;
935 
936             // ecrecover takes the signature parameters, and the only way to get them
937 
938             // currently is to use assembly.
939 
940             assembly {
941 
942                 r := mload(add(signature, 0x20))
943 
944                 vs := mload(add(signature, 0x40))
945 
946             }
947 
948             return tryRecover(hash, r, vs);
949 
950         } else {
951 
952             return (address(0), RecoverError.InvalidSignatureLength);
953 
954         }
955 
956     }
957 
958 
959 
960     /**
961 
962      * @dev Returns the address that signed a hashed message (`hash`) with
963 
964      * `signature`. This address can then be used for verification purposes.
965 
966      *
967 
968      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
969 
970      * this function rejects them by requiring the `s` value to be in the lower
971 
972      * half order, and the `v` value to be either 27 or 28.
973 
974      *
975 
976      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
977 
978      * verification to be secure: it is possible to craft signatures that
979 
980      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
981 
982      * this is by receiving a hash of the original message (which may otherwise
983 
984      * be too long), and then calling {toEthSignedMessageHash} on it.
985 
986      */
987 
988     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
989 
990         (address recovered, RecoverError error) = tryRecover(hash, signature);
991 
992         _throwError(error);
993 
994         return recovered;
995 
996     }
997 
998 
999 
1000     /**
1001 
1002      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1003 
1004      *
1005 
1006      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1007 
1008      *
1009 
1010      * _Available since v4.3._
1011 
1012      */
1013 
1014     function tryRecover(
1015 
1016         bytes32 hash,
1017 
1018         bytes32 r,
1019 
1020         bytes32 vs
1021 
1022     ) internal pure returns (address, RecoverError) {
1023 
1024         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1025 
1026         uint8 v = uint8((uint256(vs) >> 255) + 27);
1027 
1028         return tryRecover(hash, v, r, s);
1029 
1030     }
1031 
1032 
1033 
1034     /**
1035 
1036      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1037 
1038      *
1039 
1040      * _Available since v4.2._
1041 
1042      */
1043 
1044     function recover(
1045 
1046         bytes32 hash,
1047 
1048         bytes32 r,
1049 
1050         bytes32 vs
1051 
1052     ) internal pure returns (address) {
1053 
1054         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1055 
1056         _throwError(error);
1057 
1058         return recovered;
1059 
1060     }
1061 
1062 
1063 
1064     /**
1065 
1066      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1067 
1068      * `r` and `s` signature fields separately.
1069 
1070      *
1071 
1072      * _Available since v4.3._
1073 
1074      */
1075 
1076     function tryRecover(
1077 
1078         bytes32 hash,
1079 
1080         uint8 v,
1081 
1082         bytes32 r,
1083 
1084         bytes32 s
1085 
1086     ) internal pure returns (address, RecoverError) {
1087 
1088         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1089 
1090         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1091 
1092         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1093 
1094         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1095 
1096         //
1097 
1098         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1099 
1100         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1101 
1102         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1103 
1104         // these malleable signatures as well.
1105 
1106         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1107 
1108             return (address(0), RecoverError.InvalidSignatureS);
1109 
1110         }
1111 
1112         if (v != 27 && v != 28) {
1113 
1114             return (address(0), RecoverError.InvalidSignatureV);
1115 
1116         }
1117 
1118 
1119 
1120         // If the signature is valid (and not malleable), return the signer address
1121 
1122         address signer = ecrecover(hash, v, r, s);
1123 
1124         if (signer == address(0)) {
1125 
1126             return (address(0), RecoverError.InvalidSignature);
1127 
1128         }
1129 
1130 
1131 
1132         return (signer, RecoverError.NoError);
1133 
1134     }
1135 
1136 
1137 
1138     /**
1139 
1140      * @dev Overload of {ECDSA-recover} that receives the `v`,
1141 
1142      * `r` and `s` signature fields separately.
1143 
1144      */
1145 
1146     function recover(
1147 
1148         bytes32 hash,
1149 
1150         uint8 v,
1151 
1152         bytes32 r,
1153 
1154         bytes32 s
1155 
1156     ) internal pure returns (address) {
1157 
1158         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1159 
1160         _throwError(error);
1161 
1162         return recovered;
1163 
1164     }
1165 
1166 
1167 
1168     /**
1169 
1170      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1171 
1172      * produces hash corresponding to the one signed with the
1173 
1174      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1175 
1176      * JSON-RPC method as part of EIP-191.
1177 
1178      *
1179 
1180      * See {recover}.
1181 
1182      */
1183 
1184     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1185 
1186         // 32 is the length in bytes of hash,
1187 
1188         // enforced by the type signature above
1189 
1190         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1191 
1192     }
1193 
1194 
1195 
1196     /**
1197 
1198      * @dev Returns an Ethereum Signed Message, created from `s`. This
1199 
1200      * produces hash corresponding to the one signed with the
1201 
1202      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1203 
1204      * JSON-RPC method as part of EIP-191.
1205 
1206      *
1207 
1208      * See {recover}.
1209 
1210      */
1211 
1212     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1213 
1214         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1215 
1216     }
1217 
1218 
1219 
1220     /**
1221 
1222      * @dev Returns an Ethereum Signed Typed Data, created from a
1223 
1224      * `domainSeparator` and a `structHash`. This produces hash corresponding
1225 
1226      * to the one signed with the
1227 
1228      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1229 
1230      * JSON-RPC method as part of EIP-712.
1231 
1232      *
1233 
1234      * See {recover}.
1235 
1236      */
1237 
1238     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1239 
1240         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1241 
1242     }
1243 
1244 }
1245 
1246 
1247 // File: contracts/utils/draft-EIP712.sol
1248 
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1252 
1253 
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 
1258 
1259 
1260 /**
1261 
1262  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1263 
1264  *
1265 
1266  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1267 
1268  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1269 
1270  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1271 
1272  *
1273 
1274  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1275 
1276  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1277 
1278  * ({_hashTypedDataV4}).
1279 
1280  *
1281 
1282  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1283 
1284  * the chain id to protect against replay attacks on an eventual fork of the chain.
1285 
1286  *
1287 
1288  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1289 
1290  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1291 
1292  *
1293 
1294  * _Available since v3.4._
1295 
1296  */
1297 
1298 abstract contract EIP712 {
1299 
1300     /* solhint-disable var-name-mixedcase */
1301 
1302     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1303 
1304     // invalidate the cached domain separator if the chain id changes.
1305 
1306     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1307 
1308     uint256 private immutable _CACHED_CHAIN_ID;
1309 
1310     address private immutable _CACHED_THIS;
1311 
1312 
1313 
1314     bytes32 private immutable _HASHED_NAME;
1315 
1316     bytes32 private immutable _HASHED_VERSION;
1317 
1318     bytes32 private immutable _TYPE_HASH;
1319 
1320 
1321 
1322     /* solhint-enable var-name-mixedcase */
1323 
1324 
1325 
1326     /**
1327 
1328      * @dev Initializes the domain separator and parameter caches.
1329 
1330      *
1331 
1332      * The meaning of `name` and `version` is specified in
1333 
1334      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1335 
1336      *
1337 
1338      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1339 
1340      * - `version`: the current major version of the signing domain.
1341 
1342      *
1343 
1344      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1345 
1346      * contract upgrade].
1347 
1348      */
1349 
1350     constructor(string memory name, string memory version) {
1351 
1352         bytes32 hashedName = keccak256(bytes(name));
1353 
1354         bytes32 hashedVersion = keccak256(bytes(version));
1355 
1356         bytes32 typeHash = keccak256(
1357 
1358             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1359 
1360         );
1361 
1362         _HASHED_NAME = hashedName;
1363 
1364         _HASHED_VERSION = hashedVersion;
1365 
1366         _CACHED_CHAIN_ID = block.chainid;
1367 
1368         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1369 
1370         _CACHED_THIS = address(this);
1371 
1372         _TYPE_HASH = typeHash;
1373 
1374     }
1375 
1376 
1377 
1378     /**
1379 
1380      * @dev Returns the domain separator for the current chain.
1381 
1382      */
1383 
1384     function _domainSeparatorV4() internal view returns (bytes32) {
1385 
1386         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1387 
1388             return _CACHED_DOMAIN_SEPARATOR;
1389 
1390         } else {
1391 
1392             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1393 
1394         }
1395 
1396     }
1397 
1398 
1399 
1400     function _buildDomainSeparator(
1401 
1402         bytes32 typeHash,
1403 
1404         bytes32 nameHash,
1405 
1406         bytes32 versionHash
1407 
1408     ) private view returns (bytes32) {
1409 
1410         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1411 
1412     }
1413 
1414 
1415 
1416     /**
1417 
1418      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1419 
1420      * function returns the hash of the fully encoded EIP712 message for this domain.
1421 
1422      *
1423 
1424      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1425 
1426      *
1427 
1428      * ```solidity
1429 
1430      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1431 
1432      *     keccak256("Mail(address to,string contents)"),
1433 
1434      *     mailTo,
1435 
1436      *     keccak256(bytes(mailContents))
1437 
1438      * )));
1439 
1440      * address signer = ECDSA.recover(digest, signature);
1441 
1442      * ```
1443 
1444      */
1445 
1446     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1447 
1448         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1449 
1450     }
1451 
1452 }
1453 
1454 
1455 // File: contracts/extensions/draft-IERC20Permit.sol
1456 
1457 
1458 
1459 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1460 
1461 
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 
1466 
1467 /**
1468 
1469  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1470 
1471  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1472 
1473  *
1474 
1475  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1476 
1477  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1478 
1479  * need to send a transaction, and thus is not required to hold Ether at all.
1480 
1481  */
1482 
1483 interface IERC20Permit {
1484 
1485     /**
1486 
1487      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1488 
1489      * given ``owner``'s signed approval.
1490 
1491      *
1492 
1493      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1494 
1495      * ordering also apply here.
1496 
1497      *
1498 
1499      * Emits an {Approval} event.
1500 
1501      *
1502 
1503      * Requirements:
1504 
1505      *
1506 
1507      * - `spender` cannot be the zero address.
1508 
1509      * - `deadline` must be a timestamp in the future.
1510 
1511      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1512 
1513      * over the EIP712-formatted function arguments.
1514 
1515      * - the signature must use ``owner``'s current nonce (see {nonces}).
1516 
1517      *
1518 
1519      * For more information on the signature format, see the
1520 
1521      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1522 
1523      * section].
1524 
1525      */
1526 
1527     function permit(
1528 
1529         address owner,
1530 
1531         address spender,
1532 
1533         uint256 value,
1534 
1535         uint256 deadline,
1536 
1537         uint8 v,
1538 
1539         bytes32 r,
1540 
1541         bytes32 s
1542 
1543     ) external;
1544 
1545 
1546 
1547     /**
1548 
1549      * @dev Returns the current nonce for `owner`. This value must be
1550 
1551      * included whenever a signature is generated for {permit}.
1552 
1553      *
1554 
1555      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1556 
1557      * prevents a signature from being used multiple times.
1558 
1559      */
1560 
1561     function nonces(address owner) external view returns (uint256);
1562 
1563 
1564 
1565     /**
1566 
1567      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1568 
1569      */
1570 
1571     // solhint-disable-next-line func-name-mixedcase
1572 
1573     function DOMAIN_SEPARATOR() external view returns (bytes32);
1574 
1575 }
1576 
1577 
1578 // File: contracts/utils/Counters.sol
1579 
1580 
1581 
1582 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1583 
1584 
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 
1590 /**
1591 
1592  * @title Counters
1593 
1594  * @author Matt Condon (@shrugs)
1595 
1596  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1597 
1598  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1599 
1600  *
1601 
1602  * Include with `using Counters for Counters.Counter;`
1603 
1604  */
1605 
1606 library Counters {
1607 
1608     struct Counter {
1609 
1610         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1611 
1612         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1613 
1614         // this feature: see https://github.com/ethereum/solidity/issues/4637
1615 
1616         uint256 _value; // default: 0
1617 
1618     }
1619 
1620 
1621 
1622     function current(Counter storage counter) internal view returns (uint256) {
1623 
1624         return counter._value;
1625 
1626     }
1627 
1628 
1629 
1630     function increment(Counter storage counter) internal {
1631 
1632         unchecked {
1633 
1634             counter._value += 1;
1635 
1636         }
1637 
1638     }
1639 
1640 
1641 
1642     function decrement(Counter storage counter) internal {
1643 
1644         uint256 value = counter._value;
1645 
1646         require(value > 0, "Counter: decrement overflow");
1647 
1648         unchecked {
1649 
1650             counter._value = value - 1;
1651 
1652         }
1653 
1654     }
1655 
1656 
1657 
1658     function reset(Counter storage counter) internal {
1659 
1660         counter._value = 0;
1661 
1662     }
1663 
1664 }
1665 
1666 
1667 // File: contracts/utils/Math.sol
1668 
1669 
1670 
1671 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1672 
1673 
1674 
1675 pragma solidity ^0.8.0;
1676 
1677 
1678 
1679 /**
1680 
1681  * @dev Standard math utilities missing in the Solidity language.
1682 
1683  */
1684 
1685 library Math {
1686 
1687     /**
1688 
1689      * @dev Returns the largest of two numbers.
1690 
1691      */
1692 
1693     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1694 
1695         return a >= b ? a : b;
1696 
1697     }
1698 
1699 
1700 
1701     /**
1702 
1703      * @dev Returns the smallest of two numbers.
1704 
1705      */
1706 
1707     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1708 
1709         return a < b ? a : b;
1710 
1711     }
1712 
1713 
1714 
1715     /**
1716 
1717      * @dev Returns the average of two numbers. The result is rounded towards
1718 
1719      * zero.
1720 
1721      */
1722 
1723     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1724 
1725         // (a + b) / 2 can overflow.
1726 
1727         return (a & b) + (a ^ b) / 2;
1728 
1729     }
1730 
1731 
1732 
1733     /**
1734 
1735      * @dev Returns the ceiling of the division of two numbers.
1736 
1737      *
1738 
1739      * This differs from standard division with `/` in that it rounds up instead
1740 
1741      * of rounding down.
1742 
1743      */
1744 
1745     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1746 
1747         // (a + b - 1) / b can overflow on addition, so we distribute.
1748 
1749         return a / b + (a % b == 0 ? 0 : 1);
1750 
1751     }
1752 
1753 }
1754 
1755 
1756 // File: contracts/utils/Arrays.sol
1757 
1758 
1759 
1760 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1761 
1762 
1763 
1764 pragma solidity ^0.8.0;
1765 
1766 
1767 
1768 
1769 /**
1770 
1771  * @dev Collection of functions related to array types.
1772 
1773  */
1774 
1775 library Arrays {
1776 
1777     /**
1778 
1779      * @dev Searches a sorted `array` and returns the first index that contains
1780 
1781      * a value greater or equal to `element`. If no such index exists (i.e. all
1782 
1783      * values in the array are strictly less than `element`), the array length is
1784 
1785      * returned. Time complexity O(log n).
1786 
1787      *
1788 
1789      * `array` is expected to be sorted in ascending order, and to contain no
1790 
1791      * repeated elements.
1792 
1793      */
1794 
1795     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1796 
1797         if (array.length == 0) {
1798 
1799             return 0;
1800 
1801         }
1802 
1803 
1804 
1805         uint256 low = 0;
1806 
1807         uint256 high = array.length;
1808 
1809 
1810 
1811         while (low < high) {
1812 
1813             uint256 mid = Math.average(low, high);
1814 
1815 
1816 
1817             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1818 
1819             // because Math.average rounds down (it does integer division with truncation).
1820 
1821             if (array[mid] > element) {
1822 
1823                 high = mid;
1824 
1825             } else {
1826 
1827                 low = mid + 1;
1828 
1829             }
1830 
1831         }
1832 
1833 
1834 
1835         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1836 
1837         if (low > 0 && array[low - 1] == element) {
1838 
1839             return low - 1;
1840 
1841         } else {
1842 
1843             return low;
1844 
1845         }
1846 
1847     }
1848 
1849 }
1850 
1851 
1852 // File: contracts/extensions/Context.sol
1853 
1854 
1855 
1856 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1857 
1858 
1859 
1860 pragma solidity ^0.8.0;
1861 
1862 
1863 
1864 /**
1865 
1866  * @dev Provides information about the current execution context, including the
1867 
1868  * sender of the transaction and its data. While these are generally available
1869 
1870  * via msg.sender and msg.data, they should not be accessed in such a direct
1871 
1872  * manner, since when dealing with meta-transactions the account sending and
1873 
1874  * paying for execution may not be the actual sender (as far as an application
1875 
1876  * is concerned).
1877 
1878  *
1879 
1880  * This contract is only required for intermediate, library-like contracts.
1881 
1882  */
1883 
1884 abstract contract Context {
1885 
1886     function _msgSender() internal view virtual returns (address) {
1887 
1888         return msg.sender;
1889 
1890     }
1891 
1892 
1893 
1894     function _msgData() internal view virtual returns (bytes calldata) {
1895 
1896         return msg.data;
1897 
1898     }
1899 
1900 }
1901 
1902 
1903 // File: contracts/extensions/Ownable.sol
1904 
1905 
1906 
1907 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1908 
1909 
1910 
1911 pragma solidity ^0.8.0;
1912 
1913 
1914 
1915 
1916 /**
1917 
1918  * @dev Contract module which provides a basic access control mechanism, where
1919 
1920  * there is an account (an owner) that can be granted exclusive access to
1921 
1922  * specific functions.
1923 
1924  *
1925 
1926  * By default, the owner account will be the one that deploys the contract. This
1927 
1928  * can later be changed with {transferOwnership}.
1929 
1930  *
1931 
1932  * This module is used through inheritance. It will make available the modifier
1933 
1934  * `onlyOwner`, which can be applied to your functions to restrict their use to
1935 
1936  * the owner.
1937 
1938  */
1939 
1940 abstract contract Ownable is Context {
1941 
1942     address private _owner;
1943 
1944 
1945 
1946     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1947 
1948 
1949 
1950     /**
1951 
1952      * @dev Initializes the contract setting the deployer as the initial owner.
1953 
1954      */
1955 
1956     constructor() {
1957 
1958         _transferOwnership(_msgSender());
1959 
1960     }
1961 
1962 
1963 
1964     /**
1965 
1966      * @dev Returns the address of the current owner.
1967 
1968      */
1969 
1970     function owner() public view virtual returns (address) {
1971 
1972         return _owner;
1973 
1974     }
1975 
1976 
1977 
1978     /**
1979 
1980      * @dev Throws if called by any account other than the owner.
1981 
1982      */
1983 
1984     modifier onlyOwner() {
1985 
1986         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1987 
1988         _;
1989 
1990     }
1991 
1992 
1993 
1994     /**
1995 
1996      * @dev Leaves the contract without owner. It will not be possible to call
1997 
1998      * `onlyOwner` functions anymore. Can only be called by the current owner.
1999 
2000      *
2001 
2002      * NOTE: Renouncing ownership will leave the contract without an owner,
2003 
2004      * thereby removing any functionality that is only available to the owner.
2005 
2006      */
2007 
2008     function renounceOwnership() public virtual onlyOwner {
2009 
2010         _transferOwnership(address(0));
2011 
2012     }
2013 
2014 
2015 
2016     /**
2017 
2018      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2019 
2020      * Can only be called by the current owner.
2021 
2022      */
2023 
2024     function transferOwnership(address newOwner) public virtual onlyOwner {
2025 
2026         require(newOwner != address(0), "Ownable: new owner is the zero address");
2027 
2028         _transferOwnership(newOwner);
2029 
2030     }
2031 
2032 
2033 
2034     /**
2035 
2036      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2037 
2038      * Internal function without access restriction.
2039 
2040      */
2041 
2042     function _transferOwnership(address newOwner) internal virtual {
2043 
2044         address oldOwner = _owner;
2045 
2046         _owner = newOwner;
2047 
2048         emit OwnershipTransferred(oldOwner, newOwner);
2049 
2050     }
2051 
2052 }
2053 
2054 
2055 // File: contracts/extensions/IUniswapV2Router01.sol
2056 
2057 
2058 
2059 pragma solidity ^0.8.0;
2060 
2061 
2062 
2063 interface IUniswapV2Router01 {
2064 
2065     function factory() external pure returns (address);
2066 
2067     function WETH() external pure returns (address);
2068 
2069  
2070 
2071     function addLiquidity(
2072 
2073         address tokenA,
2074 
2075         address tokenB,
2076 
2077         uint amountADesired,
2078 
2079         uint amountBDesired,
2080 
2081         uint amountAMin,
2082 
2083         uint amountBMin,
2084 
2085         address to,
2086 
2087         uint deadline
2088 
2089     ) external returns (uint amountA, uint amountB, uint liquidity);
2090 
2091     function addLiquidityETH(
2092 
2093         address token,
2094 
2095         uint amountTokenDesired,
2096 
2097         uint amountTokenMin,
2098 
2099         uint amountETHMin,
2100 
2101         address to,
2102 
2103         uint deadline
2104 
2105     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2106 
2107     function removeLiquidity(
2108 
2109         address tokenA,
2110 
2111         address tokenB,
2112 
2113         uint liquidity,
2114 
2115         uint amountAMin,
2116 
2117         uint amountBMin,
2118 
2119         address to,
2120 
2121         uint deadline
2122 
2123     ) external returns (uint amountA, uint amountB);
2124 
2125     function removeLiquidityETH(
2126 
2127         address token,
2128 
2129         uint liquidity,
2130 
2131         uint amountTokenMin,
2132 
2133         uint amountETHMin,
2134 
2135         address to,
2136 
2137         uint deadline
2138 
2139     ) external returns (uint amountToken, uint amountETH);
2140 
2141     function removeLiquidityWithPermit(
2142 
2143         address tokenA,
2144 
2145         address tokenB,
2146 
2147         uint liquidity,
2148 
2149         uint amountAMin,
2150 
2151         uint amountBMin,
2152 
2153         address to,
2154 
2155         uint deadline,
2156 
2157         bool approveMax, uint8 v, bytes32 r, bytes32 s
2158 
2159     ) external returns (uint amountA, uint amountB);
2160 
2161     function removeLiquidityETHWithPermit(
2162 
2163         address token,
2164 
2165         uint liquidity,
2166 
2167         uint amountTokenMin,
2168 
2169         uint amountETHMin,
2170 
2171         address to,
2172 
2173         uint deadline,
2174 
2175         bool approveMax, uint8 v, bytes32 r, bytes32 s
2176 
2177     ) external returns (uint amountToken, uint amountETH);
2178 
2179     function swapExactTokensForTokens(
2180 
2181         uint amountIn,
2182 
2183         uint amountOutMin,
2184 
2185         address[] calldata path,
2186 
2187         address to,
2188 
2189         uint deadline
2190 
2191     ) external returns (uint[] memory amounts);
2192 
2193     function swapTokensForExactTokens(
2194 
2195         uint amountOut,
2196 
2197         uint amountInMax,
2198 
2199         address[] calldata path,
2200 
2201         address to,
2202 
2203         uint deadline
2204 
2205     ) external returns (uint[] memory amounts);
2206 
2207     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
2208 
2209         external
2210 
2211         payable
2212 
2213         returns (uint[] memory amounts);
2214 
2215     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
2216 
2217         external
2218 
2219         returns (uint[] memory amounts);
2220 
2221     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
2222 
2223         external
2224 
2225         returns (uint[] memory amounts);
2226 
2227     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
2228 
2229         external
2230 
2231         payable
2232 
2233         returns (uint[] memory amounts);
2234 
2235  
2236 
2237     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
2238 
2239     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
2240 
2241     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
2242 
2243     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
2244 
2245     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
2246 
2247 }
2248 // File: contracts/extensions/IUniswapV2Router02.sol
2249 
2250 
2251 
2252 pragma solidity ^0.8.0;
2253 
2254 
2255 
2256 
2257 interface IUniswapV2Router02 is IUniswapV2Router01 {
2258 
2259     function removeLiquidityETHSupportingFeeOnTransferTokens(
2260 
2261         address token,
2262 
2263         uint liquidity,
2264 
2265         uint amountTokenMin,
2266 
2267         uint amountETHMin,
2268 
2269         address to,
2270 
2271         uint deadline
2272 
2273     ) external returns (uint amountETH);
2274 
2275     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
2276 
2277         address token,
2278 
2279         uint liquidity,
2280 
2281         uint amountTokenMin,
2282 
2283         uint amountETHMin,
2284 
2285         address to,
2286 
2287         uint deadline,
2288 
2289         bool approveMax, uint8 v, bytes32 r, bytes32 s
2290 
2291     ) external returns (uint amountETH);
2292 
2293  
2294 
2295     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
2296 
2297         uint amountIn,
2298 
2299         uint amountOutMin,
2300 
2301         address[] calldata path,
2302 
2303         address to,
2304 
2305         uint deadline
2306 
2307     ) external;
2308 
2309     function swapExactETHForTokensSupportingFeeOnTransferTokens(
2310 
2311         uint amountOutMin,
2312 
2313         address[] calldata path,
2314 
2315         address to,
2316 
2317         uint deadline
2318 
2319     ) external payable;
2320 
2321     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2322 
2323         uint amountIn,
2324 
2325         uint amountOutMin,
2326 
2327         address[] calldata path,
2328 
2329         address to,
2330 
2331         uint deadline
2332 
2333     ) external;
2334 
2335 }
2336 // File: contracts/extensions/IERC20.sol
2337 
2338 
2339 
2340 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
2341 
2342 
2343 
2344 pragma solidity ^0.8.0;
2345 
2346 
2347 
2348 /**
2349 
2350  * @dev Interface of the ERC20 standard as defined in the EIP.
2351 
2352  */
2353 
2354 interface IERC20 {
2355 
2356     /**
2357 
2358      * @dev Returns the amount of tokens in existence.
2359 
2360      */
2361 
2362     function totalSupply() external view returns (uint256);
2363 
2364 
2365 
2366     /**
2367 
2368      * @dev Returns the amount of tokens owned by `account`.
2369 
2370      */
2371 
2372     function balanceOf(address account) external view returns (uint256);
2373 
2374 
2375 
2376     /**
2377 
2378      * @dev Moves `amount` tokens from the caller's account to `to`.
2379 
2380      *
2381 
2382      * Returns a boolean value indicating whether the operation succeeded.
2383 
2384      *
2385 
2386      * Emits a {Transfer} event.
2387 
2388      */
2389 
2390     function transfer(address to, uint256 amount) external returns (bool);
2391 
2392 
2393 
2394     /**
2395 
2396      * @dev Returns the remaining number of tokens that `spender` will be
2397 
2398      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2399 
2400      * zero by default.
2401 
2402      *
2403 
2404      * This value changes when {approve} or {transferFrom} are called.
2405 
2406      */
2407 
2408     function allowance(address owner, address spender) external view returns (uint256);
2409 
2410 
2411 
2412     /**
2413 
2414      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2415 
2416      *
2417 
2418      * Returns a boolean value indicating whether the operation succeeded.
2419 
2420      *
2421 
2422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2423 
2424      * that someone may use both the old and the new allowance by unfortunate
2425 
2426      * transaction ordering. One possible solution to mitigate this race
2427 
2428      * condition is to first reduce the spender's allowance to 0 and set the
2429 
2430      * desired value afterwards:
2431 
2432      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2433 
2434      *
2435 
2436      * Emits an {Approval} event.
2437 
2438      */
2439 
2440     function approve(address spender, uint256 amount) external returns (bool);
2441 
2442 
2443 
2444     /**
2445 
2446      * @dev Moves `amount` tokens from `from` to `to` using the
2447 
2448      * allowance mechanism. `amount` is then deducted from the caller's
2449 
2450      * allowance.
2451 
2452      *
2453 
2454      * Returns a boolean value indicating whether the operation succeeded.
2455 
2456      *
2457 
2458      * Emits a {Transfer} event.
2459 
2460      */
2461 
2462     function transferFrom(
2463 
2464         address from,
2465 
2466         address to,
2467 
2468         uint256 amount
2469 
2470     ) external returns (bool);
2471 
2472 
2473 
2474     /**
2475 
2476      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2477 
2478      * another (`to`).
2479 
2480      *
2481 
2482      * Note that `value` may be zero.
2483 
2484      */
2485 
2486     event Transfer(address indexed from, address indexed to, uint256 value);
2487 
2488 
2489 
2490     /**
2491 
2492      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2493 
2494      * a call to {approve}. `value` is the new allowance.
2495 
2496      */
2497 
2498     event Approval(address indexed owner, address indexed spender, uint256 value);
2499 
2500 }
2501 
2502 
2503 // File: contracts/extensions/IERC20Metadata.sol
2504 
2505 
2506 
2507 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2508 
2509 
2510 
2511 pragma solidity ^0.8.0;
2512 
2513 
2514 
2515 
2516 /**
2517 
2518  * @dev Interface for the optional metadata functions from the ERC20 standard.
2519 
2520  *
2521 
2522  * _Available since v4.1._
2523 
2524  */
2525 
2526 interface IERC20Metadata is IERC20 {
2527 
2528     /**
2529 
2530      * @dev Returns the name of the token.
2531 
2532      */
2533 
2534     function name() external view returns (string memory);
2535 
2536 
2537 
2538     /**
2539 
2540      * @dev Returns the symbol of the token.
2541 
2542      */
2543 
2544     function symbol() external view returns (string memory);
2545 
2546 
2547 
2548     /**
2549 
2550      * @dev Returns the decimals places of the token.
2551 
2552      */
2553 
2554     function decimals() external view returns (uint8);
2555 
2556 }
2557 
2558 
2559 // File: contracts/extensions/ERC20.sol
2560 
2561 
2562 
2563 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
2564 
2565 
2566 
2567 pragma solidity ^0.8.0;
2568 
2569 
2570 
2571 
2572 
2573 
2574 /**
2575 
2576  * @dev Implementation of the {IERC20} interface.
2577 
2578  *
2579 
2580  * This implementation is agnostic to the way tokens are created. This means
2581 
2582  * that a supply mechanism has to be added in a derived contract using {_mint}.
2583 
2584  * For a generic mechanism see {ERC20PresetMinterPauser}.
2585 
2586  *
2587 
2588  * TIP: For a detailed writeup see our guide
2589 
2590  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2591 
2592  * to implement supply mechanisms].
2593 
2594  *
2595 
2596  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2597 
2598  * instead returning `false` on failure. This behavior is nonetheless
2599 
2600  * conventional and does not conflict with the expectations of ERC20
2601 
2602  * applications.
2603 
2604  *
2605 
2606  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2607 
2608  * This allows applications to reconstruct the allowance for all accounts just
2609 
2610  * by listening to said events. Other implementations of the EIP may not emit
2611 
2612  * these events, as it isn't required by the specification.
2613 
2614  *
2615 
2616  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2617 
2618  * functions have been added to mitigate the well-known issues around setting
2619 
2620  * allowances. See {IERC20-approve}.
2621 
2622  */
2623 
2624 contract ERC20 is Context, IERC20, IERC20Metadata {
2625 
2626     mapping(address => uint256) private _balances;
2627 
2628 
2629 
2630     mapping(address => mapping(address => uint256)) private _allowances;
2631 
2632 
2633 
2634     uint256 private _totalSupply;
2635 
2636 
2637 
2638     string private _name;
2639 
2640     string private _symbol;
2641 
2642 
2643 
2644     /**
2645 
2646      * @dev Sets the values for {name} and {symbol}.
2647 
2648      *
2649 
2650      * The default value of {decimals} is 18. To select a different value for
2651 
2652      * {decimals} you should overload it.
2653 
2654      *
2655 
2656      * All two of these values are immutable: they can only be set once during
2657 
2658      * construction.
2659 
2660      */
2661 
2662     constructor(string memory name_, string memory symbol_) {
2663 
2664         _name = name_;
2665 
2666         _symbol = symbol_;
2667 
2668     }
2669 
2670 
2671 
2672     /**
2673 
2674      * @dev Returns the name of the token.
2675 
2676      */
2677 
2678     function name() public view virtual override returns (string memory) {
2679 
2680         return _name;
2681 
2682     }
2683 
2684 
2685 
2686     /**
2687 
2688      * @dev Returns the symbol of the token, usually a shorter version of the
2689 
2690      * name.
2691 
2692      */
2693 
2694     function symbol() public view virtual override returns (string memory) {
2695 
2696         return _symbol;
2697 
2698     }
2699 
2700 
2701 
2702     /**
2703 
2704      * @dev Returns the number of decimals used to get its user representation.
2705 
2706      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2707 
2708      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2709 
2710      *
2711 
2712      * Tokens usually opt for a value of 18, imitating the relationship between
2713 
2714      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2715 
2716      * overridden;
2717 
2718      *
2719 
2720      * NOTE: This information is only used for _display_ purposes: it in
2721 
2722      * no way affects any of the arithmetic of the contract, including
2723 
2724      * {IERC20-balanceOf} and {IERC20-transfer}.
2725 
2726      */
2727 
2728     function decimals() public view virtual override returns (uint8) {
2729 
2730         return 18;
2731 
2732     }
2733 
2734 
2735 
2736     /**
2737 
2738      * @dev See {IERC20-totalSupply}.
2739 
2740      */
2741 
2742     function totalSupply() public view virtual override returns (uint256) {
2743 
2744         return _totalSupply;
2745 
2746     }
2747 
2748 
2749 
2750     /**
2751 
2752      * @dev See {IERC20-balanceOf}.
2753 
2754      */
2755 
2756     function balanceOf(address account) public view virtual override returns (uint256) {
2757 
2758         return _balances[account];
2759 
2760     }
2761 
2762 
2763 
2764     /**
2765 
2766      * @dev See {IERC20-transfer}.
2767 
2768      *
2769 
2770      * Requirements:
2771 
2772      *
2773 
2774      * - `to` cannot be the zero address.
2775 
2776      * - the caller must have a balance of at least `amount`.
2777 
2778      */
2779 
2780     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2781 
2782         address owner = _msgSender();
2783 
2784         _transfer(owner, to, amount);
2785 
2786         return true;
2787 
2788     }
2789 
2790 
2791 
2792     /**
2793 
2794      * @dev See {IERC20-allowance}.
2795 
2796      */
2797 
2798     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2799 
2800         return _allowances[owner][spender];
2801 
2802     }
2803 
2804 
2805 
2806     /**
2807 
2808      * @dev See {IERC20-approve}.
2809 
2810      *
2811 
2812      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2813 
2814      * `transferFrom`. This is semantically equivalent to an infinite approval.
2815 
2816      *
2817 
2818      * Requirements:
2819 
2820      *
2821 
2822      * - `spender` cannot be the zero address.
2823 
2824      */
2825 
2826     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2827 
2828         address owner = _msgSender();
2829 
2830         _approve(owner, spender, amount);
2831 
2832         return true;
2833 
2834     }
2835 
2836 
2837 
2838     /**
2839 
2840      * @dev See {IERC20-transferFrom}.
2841 
2842      *
2843 
2844      * Emits an {Approval} event indicating the updated allowance. This is not
2845 
2846      * required by the EIP. See the note at the beginning of {ERC20}.
2847 
2848      *
2849 
2850      * NOTE: Does not update the allowance if the current allowance
2851 
2852      * is the maximum `uint256`.
2853 
2854      *
2855 
2856      * Requirements:
2857 
2858      *
2859 
2860      * - `from` and `to` cannot be the zero address.
2861 
2862      * - `from` must have a balance of at least `amount`.
2863 
2864      * - the caller must have allowance for ``from``'s tokens of at least
2865 
2866      * `amount`.
2867 
2868      */
2869 
2870     function transferFrom(
2871 
2872         address from,
2873 
2874         address to,
2875 
2876         uint256 amount
2877 
2878     ) public virtual override returns (bool) {
2879 
2880         address spender = _msgSender();
2881 
2882         _spendAllowance(from, spender, amount);
2883 
2884         _transfer(from, to, amount);
2885 
2886         return true;
2887 
2888     }
2889 
2890 
2891 
2892     /**
2893 
2894      * @dev Atomically increases the allowance granted to `spender` by the caller.
2895 
2896      *
2897 
2898      * This is an alternative to {approve} that can be used as a mitigation for
2899 
2900      * problems described in {IERC20-approve}.
2901 
2902      *
2903 
2904      * Emits an {Approval} event indicating the updated allowance.
2905 
2906      *
2907 
2908      * Requirements:
2909 
2910      *
2911 
2912      * - `spender` cannot be the zero address.
2913 
2914      */
2915 
2916     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2917 
2918         address owner = _msgSender();
2919 
2920         _approve(owner, spender, _allowances[owner][spender] + addedValue);
2921 
2922         return true;
2923 
2924     }
2925 
2926 
2927 
2928     /**
2929 
2930      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2931 
2932      *
2933 
2934      * This is an alternative to {approve} that can be used as a mitigation for
2935 
2936      * problems described in {IERC20-approve}.
2937 
2938      *
2939 
2940      * Emits an {Approval} event indicating the updated allowance.
2941 
2942      *
2943 
2944      * Requirements:
2945 
2946      *
2947 
2948      * - `spender` cannot be the zero address.
2949 
2950      * - `spender` must have allowance for the caller of at least
2951 
2952      * `subtractedValue`.
2953 
2954      */
2955 
2956     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2957 
2958         address owner = _msgSender();
2959 
2960         uint256 currentAllowance = _allowances[owner][spender];
2961 
2962         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2963 
2964         unchecked {
2965 
2966             _approve(owner, spender, currentAllowance - subtractedValue);
2967 
2968         }
2969 
2970 
2971 
2972         return true;
2973 
2974     }
2975 
2976 
2977 
2978     /**
2979 
2980      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2981 
2982      *
2983 
2984      * This internal function is equivalent to {transfer}, and can be used to
2985 
2986      * e.g. implement automatic token fees, slashing mechanisms, etc.
2987 
2988      *
2989 
2990      * Emits a {Transfer} event.
2991 
2992      *
2993 
2994      * Requirements:
2995 
2996      *
2997 
2998      * - `from` cannot be the zero address.
2999 
3000      * - `to` cannot be the zero address.
3001 
3002      * - `from` must have a balance of at least `amount`.
3003 
3004      */
3005 
3006     function _transfer(
3007 
3008         address from,
3009 
3010         address to,
3011 
3012         uint256 amount
3013 
3014     ) internal virtual {
3015 
3016         require(from != address(0), "ERC20: transfer from the zero address");
3017 
3018         require(to != address(0), "ERC20: transfer to the zero address");
3019 
3020 
3021 
3022         _beforeTokenTransfer(from, to, amount);
3023 
3024 
3025 
3026         uint256 fromBalance = _balances[from];
3027 
3028         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
3029 
3030         unchecked {
3031 
3032             _balances[from] = fromBalance - amount;
3033 
3034         }
3035 
3036         _balances[to] += amount;
3037 
3038 
3039 
3040         emit Transfer(from, to, amount);
3041 
3042 
3043 
3044         _afterTokenTransfer(from, to, amount);
3045 
3046     }
3047 
3048 
3049 
3050     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3051 
3052      * the total supply.
3053 
3054      *
3055 
3056      * Emits a {Transfer} event with `from` set to the zero address.
3057 
3058      *
3059 
3060      * Requirements:
3061 
3062      *
3063 
3064      * - `account` cannot be the zero address.
3065 
3066      */
3067 
3068     function _mint(address account, uint256 amount) internal virtual {
3069 
3070         require(account != address(0), "ERC20: mint to the zero address");
3071 
3072 
3073 
3074         _beforeTokenTransfer(address(0), account, amount);
3075 
3076 
3077 
3078         _totalSupply += amount;
3079 
3080         _balances[account] += amount;
3081 
3082         emit Transfer(address(0), account, amount);
3083 
3084 
3085 
3086         _afterTokenTransfer(address(0), account, amount);
3087 
3088     }
3089 
3090 
3091 
3092     /**
3093 
3094      * @dev Destroys `amount` tokens from `account`, reducing the
3095 
3096      * total supply.
3097 
3098      *
3099 
3100      * Emits a {Transfer} event with `to` set to the zero address.
3101 
3102      *
3103 
3104      * Requirements:
3105 
3106      *
3107 
3108      * - `account` cannot be the zero address.
3109 
3110      * - `account` must have at least `amount` tokens.
3111 
3112      */
3113 
3114     function _burn(address account, uint256 amount) internal virtual {
3115 
3116         require(account != address(0), "ERC20: burn from the zero address");
3117 
3118 
3119 
3120         _beforeTokenTransfer(account, address(0), amount);
3121 
3122 
3123 
3124         uint256 accountBalance = _balances[account];
3125 
3126         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
3127 
3128         unchecked {
3129 
3130             _balances[account] = accountBalance - amount;
3131 
3132         }
3133 
3134         _totalSupply -= amount;
3135 
3136 
3137 
3138         emit Transfer(account, address(0), amount);
3139 
3140 
3141 
3142         _afterTokenTransfer(account, address(0), amount);
3143 
3144     }
3145 
3146 
3147 
3148     /**
3149 
3150      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3151 
3152      *
3153 
3154      * This internal function is equivalent to `approve`, and can be used to
3155 
3156      * e.g. set automatic allowances for certain subsystems, etc.
3157 
3158      *
3159 
3160      * Emits an {Approval} event.
3161 
3162      *
3163 
3164      * Requirements:
3165 
3166      *
3167 
3168      * - `owner` cannot be the zero address.
3169 
3170      * - `spender` cannot be the zero address.
3171 
3172      */
3173 
3174     function _approve(
3175 
3176         address owner,
3177 
3178         address spender,
3179 
3180         uint256 amount
3181 
3182     ) internal virtual {
3183 
3184         require(owner != address(0), "ERC20: approve from the zero address");
3185 
3186         require(spender != address(0), "ERC20: approve to the zero address");
3187 
3188 
3189 
3190         _allowances[owner][spender] = amount;
3191 
3192         emit Approval(owner, spender, amount);
3193 
3194     }
3195 
3196 
3197 
3198     /**
3199 
3200      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
3201 
3202      *
3203 
3204      * Does not update the allowance amount in case of infinite allowance.
3205 
3206      * Revert if not enough allowance is available.
3207 
3208      *
3209 
3210      * Might emit an {Approval} event.
3211 
3212      */
3213 
3214     function _spendAllowance(
3215 
3216         address owner,
3217 
3218         address spender,
3219 
3220         uint256 amount
3221 
3222     ) internal virtual {
3223 
3224         uint256 currentAllowance = allowance(owner, spender);
3225 
3226         if (currentAllowance != type(uint256).max) {
3227 
3228             require(currentAllowance >= amount, "ERC20: insufficient allowance");
3229 
3230             unchecked {
3231 
3232                 _approve(owner, spender, currentAllowance - amount);
3233 
3234             }
3235 
3236         }
3237 
3238     }
3239 
3240 
3241 
3242     /**
3243 
3244      * @dev Hook that is called before any transfer of tokens. This includes
3245 
3246      * minting and burning.
3247 
3248      *
3249 
3250      * Calling conditions:
3251 
3252      *
3253 
3254      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3255 
3256      * will be transferred to `to`.
3257 
3258      * - when `from` is zero, `amount` tokens will be minted for `to`.
3259 
3260      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3261 
3262      * - `from` and `to` are never both zero.
3263 
3264      *
3265 
3266      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3267 
3268      */
3269 
3270     function _beforeTokenTransfer(
3271 
3272         address from,
3273 
3274         address to,
3275 
3276         uint256 amount
3277 
3278     ) internal virtual {}
3279 
3280 
3281 
3282     /**
3283 
3284      * @dev Hook that is called after any transfer of tokens. This includes
3285 
3286      * minting and burning.
3287 
3288      *
3289 
3290      * Calling conditions:
3291 
3292      *
3293 
3294      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3295 
3296      * has been transferred to `to`.
3297 
3298      * - when `from` is zero, `amount` tokens have been minted for `to`.
3299 
3300      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
3301 
3302      * - `from` and `to` are never both zero.
3303 
3304      *
3305 
3306      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3307 
3308      */
3309 
3310     function _afterTokenTransfer(
3311 
3312         address from,
3313 
3314         address to,
3315 
3316         uint256 amount
3317 
3318     ) internal virtual {}
3319 
3320 }
3321 
3322 
3323 // File: contracts/extensions/draft-ERC20Permit.sol
3324 
3325 
3326 
3327 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
3328 
3329 
3330 
3331 pragma solidity ^0.8.0;
3332 
3333 
3334 
3335 
3336 
3337 
3338 
3339 
3340 /**
3341 
3342  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
3343 
3344  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
3345 
3346  *
3347 
3348  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
3349 
3350  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
3351 
3352  * need to send a transaction, and thus is not required to hold Ether at all.
3353 
3354  *
3355 
3356  * _Available since v3.4._
3357 
3358  */
3359 
3360 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
3361 
3362     using Counters for Counters.Counter;
3363 
3364 
3365 
3366     mapping(address => Counters.Counter) private _nonces;
3367 
3368 
3369 
3370     // solhint-disable-next-line var-name-mixedcase
3371 
3372     bytes32 private immutable _PERMIT_TYPEHASH =
3373 
3374         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
3375 
3376 
3377 
3378     /**
3379 
3380      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
3381 
3382      *
3383 
3384      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
3385 
3386      */
3387 
3388     constructor(string memory name) EIP712(name, "1") {}
3389 
3390 
3391 
3392     /**
3393 
3394      * @dev See {IERC20Permit-permit}.
3395 
3396      */
3397 
3398     function permit(
3399 
3400         address owner,
3401 
3402         address spender,
3403 
3404         uint256 value,
3405 
3406         uint256 deadline,
3407 
3408         uint8 v,
3409 
3410         bytes32 r,
3411 
3412         bytes32 s
3413 
3414     ) public virtual override {
3415 
3416         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
3417 
3418 
3419 
3420         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
3421 
3422 
3423 
3424         bytes32 hash = _hashTypedDataV4(structHash);
3425 
3426 
3427 
3428         address signer = ECDSA.recover(hash, v, r, s);
3429 
3430         require(signer == owner, "ERC20Permit: invalid signature");
3431 
3432 
3433 
3434         _approve(owner, spender, value);
3435 
3436     }
3437 
3438 
3439 
3440     /**
3441 
3442      * @dev See {IERC20Permit-nonces}.
3443 
3444      */
3445 
3446     function nonces(address owner) public view virtual override returns (uint256) {
3447 
3448         return _nonces[owner].current();
3449 
3450     }
3451 
3452 
3453 
3454     /**
3455 
3456      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
3457 
3458      */
3459 
3460     // solhint-disable-next-line func-name-mixedcase
3461 
3462     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
3463 
3464         return _domainSeparatorV4();
3465 
3466     }
3467 
3468 
3469 
3470     /**
3471 
3472      * @dev "Consume a nonce": return the current value and increment.
3473 
3474      *
3475 
3476      * _Available since v4.1._
3477 
3478      */
3479 
3480     function _useNonce(address owner) internal virtual returns (uint256 current) {
3481 
3482         Counters.Counter storage nonce = _nonces[owner];
3483 
3484         current = nonce.current();
3485 
3486         nonce.increment();
3487 
3488     }
3489 
3490 }
3491 
3492 
3493 // File: contracts/extensions/ERC20Votes.sol
3494 
3495 
3496 
3497 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Votes.sol)
3498 
3499 
3500 
3501 pragma solidity ^0.8.0;
3502 
3503 
3504 
3505 
3506 
3507 
3508 
3509 
3510 /**
3511 
3512  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
3513 
3514  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
3515 
3516  *
3517 
3518  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
3519 
3520  *
3521 
3522  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
3523 
3524  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
3525 
3526  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
3527 
3528  *
3529 
3530  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
3531 
3532  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
3533 
3534  *
3535 
3536  * _Available since v4.2._
3537 
3538  */
3539 
3540 abstract contract ERC20Votes is IVotes, ERC20Permit {
3541 
3542     struct Checkpoint {
3543 
3544         uint32 fromBlock;
3545 
3546         uint224 votes;
3547 
3548     }
3549 
3550 
3551 
3552     bytes32 private constant _DELEGATION_TYPEHASH =
3553 
3554         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
3555 
3556 
3557 
3558     mapping(address => address) private _delegates;
3559 
3560     mapping(address => Checkpoint[]) private _checkpoints;
3561 
3562     Checkpoint[] private _totalSupplyCheckpoints;
3563 
3564 
3565 
3566     /**
3567 
3568      * @dev Get the `pos`-th checkpoint for `account`.
3569 
3570      */
3571 
3572     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
3573 
3574         return _checkpoints[account][pos];
3575 
3576     }
3577 
3578 
3579 
3580     /**
3581 
3582      * @dev Get number of checkpoints for `account`.
3583 
3584      */
3585 
3586     function numCheckpoints(address account) public view virtual returns (uint32) {
3587 
3588         return SafeCast.toUint32(_checkpoints[account].length);
3589 
3590     }
3591 
3592 
3593 
3594     /**
3595 
3596      * @dev Get the address `account` is currently delegating to.
3597 
3598      */
3599 
3600     function delegates(address account) public view virtual override returns (address) {
3601 
3602         return _delegates[account];
3603 
3604     }
3605 
3606 
3607 
3608     /**
3609 
3610      * @dev Gets the current votes balance for `account`
3611 
3612      */
3613 
3614     function getVotes(address account) public view virtual override returns (uint256) {
3615 
3616         uint256 pos = _checkpoints[account].length;
3617 
3618         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
3619 
3620     }
3621 
3622 
3623 
3624     /**
3625 
3626      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
3627 
3628      *
3629 
3630      * Requirements:
3631 
3632      *
3633 
3634      * - `blockNumber` must have been already mined
3635 
3636      */
3637 
3638     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
3639 
3640         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3641 
3642         return _checkpointsLookup(_checkpoints[account], blockNumber);
3643 
3644     }
3645 
3646 
3647 
3648     /**
3649 
3650      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
3651 
3652      * It is but NOT the sum of all the delegated votes!
3653 
3654      *
3655 
3656      * Requirements:
3657 
3658      *
3659 
3660      * - `blockNumber` must have been already mined
3661 
3662      */
3663 
3664     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
3665 
3666         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
3667 
3668         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
3669 
3670     }
3671 
3672 
3673 
3674     /**
3675 
3676      * @dev Lookup a value in a list of (sorted) checkpoints.
3677 
3678      */
3679 
3680     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
3681 
3682         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
3683 
3684         //
3685 
3686         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
3687 
3688         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
3689 
3690         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
3691 
3692         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
3693 
3694         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
3695 
3696         // out of bounds (in which case we're looking too far in the past and the result is 0).
3697 
3698         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
3699 
3700         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
3701 
3702         // the same.
3703 
3704         uint256 high = ckpts.length;
3705 
3706         uint256 low = 0;
3707 
3708         while (low < high) {
3709 
3710             uint256 mid = Math.average(low, high);
3711 
3712             if (ckpts[mid].fromBlock > blockNumber) {
3713 
3714                 high = mid;
3715 
3716             } else {
3717 
3718                 low = mid + 1;
3719 
3720             }
3721 
3722         }
3723 
3724 
3725 
3726         return high == 0 ? 0 : ckpts[high - 1].votes;
3727 
3728     }
3729 
3730 
3731 
3732     /**
3733 
3734      * @dev Delegate votes from the sender to `delegatee`.
3735 
3736      */
3737 
3738     function delegate(address delegatee) public virtual override {
3739 
3740         _delegate(_msgSender(), delegatee);
3741 
3742     }
3743 
3744 
3745 
3746     /**
3747 
3748      * @dev Delegates votes from signer to `delegatee`
3749 
3750      */
3751 
3752     function delegateBySig(
3753 
3754         address delegatee,
3755 
3756         uint256 nonce,
3757 
3758         uint256 expiry,
3759 
3760         uint8 v,
3761 
3762         bytes32 r,
3763 
3764         bytes32 s
3765 
3766     ) public virtual override {
3767 
3768         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
3769 
3770         address signer = ECDSA.recover(
3771 
3772             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
3773 
3774             v,
3775 
3776             r,
3777 
3778             s
3779 
3780         );
3781 
3782         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
3783 
3784         _delegate(signer, delegatee);
3785 
3786     }
3787 
3788 
3789 
3790     /**
3791 
3792      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
3793 
3794      */
3795 
3796     function _maxSupply() internal view virtual returns (uint224) {
3797 
3798         return type(uint224).max;
3799 
3800     }
3801 
3802 
3803 
3804     /**
3805 
3806      * @dev Snapshots the totalSupply after it has been increased.
3807 
3808      */
3809 
3810     function _mint(address account, uint256 amount) internal virtual override {
3811 
3812         super._mint(account, amount);
3813 
3814         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
3815 
3816 
3817 
3818         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
3819 
3820     }
3821 
3822 
3823 
3824     /**
3825 
3826      * @dev Snapshots the totalSupply after it has been decreased.
3827 
3828      */
3829 
3830     function _burn(address account, uint256 amount) internal virtual override {
3831 
3832         super._burn(account, amount);
3833 
3834 
3835 
3836         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
3837 
3838     }
3839 
3840 
3841 
3842     /**
3843 
3844      * @dev Move voting power when tokens are transferred.
3845 
3846      *
3847 
3848      * Emits a {DelegateVotesChanged} event.
3849 
3850      */
3851 
3852     function _afterTokenTransfer(
3853 
3854         address from,
3855 
3856         address to,
3857 
3858         uint256 amount
3859 
3860     ) internal virtual override {
3861 
3862         super._afterTokenTransfer(from, to, amount);
3863 
3864 
3865 
3866         _moveVotingPower(delegates(from), delegates(to), amount);
3867 
3868     }
3869 
3870 
3871 
3872     /**
3873 
3874      * @dev Change delegation for `delegator` to `delegatee`.
3875 
3876      *
3877 
3878      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
3879 
3880      */
3881 
3882     function _delegate(address delegator, address delegatee) internal virtual {
3883 
3884         address currentDelegate = delegates(delegator);
3885 
3886         uint256 delegatorBalance = balanceOf(delegator);
3887 
3888         _delegates[delegator] = delegatee;
3889 
3890 
3891 
3892         emit DelegateChanged(delegator, currentDelegate, delegatee);
3893 
3894 
3895 
3896         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
3897 
3898     }
3899 
3900 
3901 
3902     function _moveVotingPower(
3903 
3904         address src,
3905 
3906         address dst,
3907 
3908         uint256 amount
3909 
3910     ) private {
3911 
3912         if (src != dst && amount > 0) {
3913 
3914             if (src != address(0)) {
3915 
3916                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
3917 
3918                 emit DelegateVotesChanged(src, oldWeight, newWeight);
3919 
3920             }
3921 
3922 
3923 
3924             if (dst != address(0)) {
3925 
3926                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
3927 
3928                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
3929 
3930             }
3931 
3932         }
3933 
3934     }
3935 
3936 
3937 
3938     function _writeCheckpoint(
3939 
3940         Checkpoint[] storage ckpts,
3941 
3942         function(uint256, uint256) view returns (uint256) op,
3943 
3944         uint256 delta
3945 
3946     ) private returns (uint256 oldWeight, uint256 newWeight) {
3947 
3948         uint256 pos = ckpts.length;
3949 
3950         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
3951 
3952         newWeight = op(oldWeight, delta);
3953 
3954 
3955 
3956         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
3957 
3958             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
3959 
3960         } else {
3961 
3962             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
3963 
3964         }
3965 
3966     }
3967 
3968 
3969 
3970     function _add(uint256 a, uint256 b) private pure returns (uint256) {
3971 
3972         return a + b;
3973 
3974     }
3975 
3976 
3977 
3978     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
3979 
3980         return a - b;
3981 
3982     }
3983 
3984 }
3985 
3986 
3987 // File: contracts/extensions/ERC20Snapshot.sol
3988 
3989 
3990 
3991 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
3992 
3993 
3994 
3995 pragma solidity ^0.8.0;
3996 
3997 
3998 
3999 
4000 
4001 
4002 /**
4003 
4004  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
4005 
4006  * total supply at the time are recorded for later access.
4007 
4008  *
4009 
4010  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
4011 
4012  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
4013 
4014  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
4015 
4016  * used to create an efficient ERC20 forking mechanism.
4017 
4018  *
4019 
4020  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
4021 
4022  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
4023 
4024  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
4025 
4026  * and the account address.
4027 
4028  *
4029 
4030  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
4031 
4032  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
4033 
4034  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
4035 
4036  *
4037 
4038  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
4039 
4040  * alternative consider {ERC20Votes}.
4041 
4042  *
4043 
4044  * ==== Gas Costs
4045 
4046  *
4047 
4048  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
4049 
4050  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
4051 
4052  * smaller since identical balances in subsequent snapshots are stored as a single entry.
4053 
4054  *
4055 
4056  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
4057 
4058  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
4059 
4060  * transfers will have normal cost until the next snapshot, and so on.
4061 
4062  */
4063 
4064 
4065 
4066 abstract contract ERC20Snapshot is ERC20 {
4067 
4068     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
4069 
4070     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
4071 
4072 
4073 
4074     using Arrays for uint256[];
4075 
4076     using Counters for Counters.Counter;
4077 
4078 
4079 
4080     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
4081 
4082     // Snapshot struct, but that would impede usage of functions that work on an array.
4083 
4084     struct Snapshots {
4085 
4086         uint256[] ids;
4087 
4088         uint256[] values;
4089 
4090     }
4091 
4092 
4093 
4094     mapping(address => Snapshots) private _accountBalanceSnapshots;
4095 
4096     Snapshots private _totalSupplySnapshots;
4097 
4098 
4099 
4100     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
4101 
4102     Counters.Counter private _currentSnapshotId;
4103 
4104 
4105 
4106     /**
4107 
4108      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
4109 
4110      */
4111 
4112     event Snapshot(uint256 id);
4113 
4114 
4115 
4116     /**
4117 
4118      * @dev Creates a new snapshot and returns its snapshot id.
4119 
4120      *
4121 
4122      * Emits a {Snapshot} event that contains the same id.
4123 
4124      *
4125 
4126      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
4127 
4128      * set of accounts, for example using {AccessControl}, or it may be open to the public.
4129 
4130      *
4131 
4132      * [WARNING]
4133 
4134      * ====
4135 
4136      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
4137 
4138      * you must consider that it can potentially be used by attackers in two ways.
4139 
4140      *
4141 
4142      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
4143 
4144      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
4145 
4146      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
4147 
4148      * section above.
4149 
4150      *
4151 
4152      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
4153 
4154      * ====
4155 
4156      */
4157 
4158     function _snapshot() internal virtual returns (uint256) {
4159 
4160         _currentSnapshotId.increment();
4161 
4162 
4163 
4164         uint256 currentId = _getCurrentSnapshotId();
4165 
4166         emit Snapshot(currentId);
4167 
4168         return currentId;
4169 
4170     }
4171 
4172 
4173 
4174     /**
4175 
4176      * @dev Get the current snapshotId
4177 
4178      */
4179 
4180     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
4181 
4182         return _currentSnapshotId.current();
4183 
4184     }
4185 
4186 
4187 
4188     /**
4189 
4190      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
4191 
4192      */
4193 
4194     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
4195 
4196         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
4197 
4198 
4199 
4200         return snapshotted ? value : balanceOf(account);
4201 
4202     }
4203 
4204 
4205 
4206     /**
4207 
4208      * @dev Retrieves the total supply at the time `snapshotId` was created.
4209 
4210      */
4211 
4212     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
4213 
4214         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
4215 
4216 
4217 
4218         return snapshotted ? value : totalSupply();
4219 
4220     }
4221 
4222 
4223 
4224     // Update balance and/or total supply snapshots before the values are modified. This is implemented
4225 
4226     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
4227 
4228     function _beforeTokenTransfer(
4229 
4230         address from,
4231 
4232         address to,
4233 
4234         uint256 amount
4235 
4236     ) internal virtual override {
4237 
4238         super._beforeTokenTransfer(from, to, amount);
4239 
4240 
4241 
4242         if (from == address(0)) {
4243 
4244             // mint
4245 
4246             _updateAccountSnapshot(to);
4247 
4248             _updateTotalSupplySnapshot();
4249 
4250         } else if (to == address(0)) {
4251 
4252             // burn
4253 
4254             _updateAccountSnapshot(from);
4255 
4256             _updateTotalSupplySnapshot();
4257 
4258         } else {
4259 
4260             // transfer
4261 
4262             _updateAccountSnapshot(from);
4263 
4264             _updateAccountSnapshot(to);
4265 
4266         }
4267 
4268     }
4269 
4270 
4271 
4272     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
4273 
4274         require(snapshotId > 0, "ERC20Snapshot: id is 0");
4275 
4276         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
4277 
4278 
4279 
4280         // When a valid snapshot is queried, there are three possibilities:
4281 
4282         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
4283 
4284         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
4285 
4286         //  to this id is the current one.
4287 
4288         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
4289 
4290         //  requested id, and its value is the one to return.
4291 
4292         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
4293 
4294         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
4295 
4296         //  larger than the requested one.
4297 
4298         //
4299 
4300         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
4301 
4302         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
4303 
4304         // exactly this.
4305 
4306 
4307 
4308         uint256 index = snapshots.ids.findUpperBound(snapshotId);
4309 
4310 
4311 
4312         if (index == snapshots.ids.length) {
4313 
4314             return (false, 0);
4315 
4316         } else {
4317 
4318             return (true, snapshots.values[index]);
4319 
4320         }
4321 
4322     }
4323 
4324 
4325 
4326     function _updateAccountSnapshot(address account) private {
4327 
4328         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
4329 
4330     }
4331 
4332 
4333 
4334     function _updateTotalSupplySnapshot() private {
4335 
4336         _updateSnapshot(_totalSupplySnapshots, totalSupply());
4337 
4338     }
4339 
4340 
4341 
4342     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
4343 
4344         uint256 currentId = _getCurrentSnapshotId();
4345 
4346         if (_lastSnapshotId(snapshots.ids) < currentId) {
4347 
4348             snapshots.ids.push(currentId);
4349 
4350             snapshots.values.push(currentValue);
4351 
4352         }
4353 
4354     }
4355 
4356 
4357 
4358     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
4359 
4360         if (ids.length == 0) {
4361 
4362             return 0;
4363 
4364         } else {
4365 
4366             return ids[ids.length - 1];
4367 
4368         }
4369 
4370     }
4371 
4372 }
4373 
4374 
4375 // File: contracts/extensions/ERC20Burnable.sol
4376 
4377 
4378 
4379 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
4380 
4381 
4382 
4383 pragma solidity ^0.8.0;
4384 
4385 
4386 
4387 
4388 
4389 /**
4390 
4391  * @dev Extension of {ERC20} that allows token holders to destroy both their own
4392 
4393  * tokens and those that they have an allowance for, in a way that can be
4394 
4395  * recognized off-chain (via event analysis).
4396 
4397  */
4398 
4399 abstract contract ERC20Burnable is Context, ERC20 {
4400 
4401     /**
4402 
4403      * @dev Destroys `amount` tokens from the caller.
4404 
4405      *
4406 
4407      * See {ERC20-_burn}.
4408 
4409      */
4410 
4411     function burn(uint256 amount) public virtual {
4412 
4413         _burn(_msgSender(), amount);
4414 
4415     }
4416 
4417 
4418 
4419     /**
4420 
4421      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
4422 
4423      * allowance.
4424 
4425      *
4426 
4427      * See {ERC20-_burn} and {ERC20-allowance}.
4428 
4429      *
4430 
4431      * Requirements:
4432 
4433      *
4434 
4435      * - the caller must have allowance for ``accounts``'s tokens of at least
4436 
4437      * `amount`.
4438 
4439      */
4440 
4441     function burnFrom(address account, uint256 amount) public virtual {
4442 
4443         _spendAllowance(account, _msgSender(), amount);
4444 
4445         _burn(account, amount);
4446 
4447     }
4448 
4449 }
4450 
4451 
4452 // File: contracts/extensions/IRewardTracker.sol
4453 
4454 
4455 
4456 pragma solidity ^0.8.13;
4457 
4458 
4459 
4460 
4461 
4462 interface IRewardTracker is IERC20 {
4463 
4464     event RewardsDistributed(address indexed from, uint256 weiAmount);
4465 
4466     event RewardWithdrawn(address indexed to, uint256 weiAmount);
4467 
4468     event ExcludeFromRewards(address indexed account, bool excluded);
4469 
4470     event Claim(address indexed account, uint256 amount);
4471 
4472     event Compound(address indexed account, uint256 amount, uint256 tokens);
4473 
4474     event LogErrorString(string message);
4475 
4476 
4477 
4478     struct AccountInfo {
4479 
4480         address account;
4481 
4482         uint256 withdrawableRewards;
4483 
4484         uint256 totalRewards;
4485 
4486         uint256 lastClaimTime;
4487 
4488     }
4489 
4490 
4491 
4492     receive() external payable;
4493 
4494 
4495 
4496     function distributeRewards() external payable;
4497 
4498 
4499 
4500     function setBalance(address payable account, uint256 newBalance) external;
4501 
4502 
4503 
4504     function excludeFromRewards(address account, bool excluded) external;
4505 
4506 
4507 
4508     function isExcludedFromRewards(address account) external view returns (bool);
4509 
4510 
4511 
4512     function manualSendReward(uint256 amount, address holder) external;
4513 
4514 
4515 
4516     function processAccount(address payable account) external returns (bool);
4517 
4518 
4519 
4520     function compoundAccount(address payable account) external returns (bool);
4521 
4522 
4523 
4524     function withdrawableRewardOf(address account) external view returns (uint256);
4525 
4526 
4527 
4528     function withdrawnRewardOf(address account) external view returns (uint256);
4529 
4530     
4531 
4532     function accumulativeRewardOf(address account) external view returns (uint256);
4533 
4534 
4535 
4536     function getAccountInfo(address account) external view returns (address, uint256, uint256, uint256, uint256);
4537 
4538 
4539 
4540     function getLastClaimTime(address account) external view returns (uint256);
4541 
4542 
4543 
4544     function name() external pure returns (string memory);
4545 
4546 
4547 
4548     function symbol() external pure returns (string memory);
4549 
4550 
4551 
4552     function decimals() external pure returns (uint8);
4553 
4554 
4555 
4556     function totalSupply() external view override returns (uint256);
4557 
4558 
4559 
4560     function balanceOf(address account) external view override returns (uint256);
4561 
4562 
4563 
4564     function transfer(address, uint256) external pure override returns (bool);
4565 
4566 
4567 
4568     function allowance(address, address) external pure override returns (uint256);
4569 
4570 
4571 
4572     function approve(address, uint256) external pure override returns (bool);
4573 
4574 
4575 
4576     function transferFrom(address, address, uint256) external pure override returns (bool);
4577 
4578 }
4579 // File: contracts/RewardTracker.sol
4580 
4581 
4582 
4583 pragma solidity ^0.8.13;
4584 
4585 
4586 
4587 
4588 
4589 
4590 contract RewardTracker is IRewardTracker, Ownable {
4591 
4592     address immutable UNISWAPROUTER;
4593 
4594 
4595 
4596     string private constant _name = "AGFI_RewardTracker";
4597 
4598     string private constant _symbol = "AGFI_RewardTracker";
4599 
4600 
4601 
4602     uint256 public lastProcessedIndex;
4603 
4604 
4605 
4606     uint256 private _totalSupply;
4607 
4608     mapping(address => uint256) private _balances;
4609 
4610 
4611 
4612     uint256 private constant magnitude = 2**128;
4613 
4614     uint256 public immutable minTokenBalanceForRewards;
4615 
4616     uint256 private magnifiedRewardPerShare;
4617 
4618     uint256 public totalRewardsDistributed;
4619 
4620     uint256 public totalRewardsWithdrawn;
4621 
4622 
4623 
4624     address public immutable tokenAddress;
4625 
4626 
4627 
4628     mapping(address => bool) public excludedFromRewards;
4629 
4630     mapping(address => int256) private magnifiedRewardCorrections;
4631 
4632     mapping(address => uint256) private withdrawnRewards;
4633 
4634     mapping(address => uint256) private lastClaimTimes;
4635 
4636 
4637 
4638     constructor(address _tokenAddress, address _uniswapRouter) {
4639 
4640         minTokenBalanceForRewards = 1 * (10**9);
4641 
4642         tokenAddress = _tokenAddress;
4643 
4644         UNISWAPROUTER = _uniswapRouter;
4645 
4646     }
4647 
4648 
4649 
4650     receive() external override payable {
4651 
4652         distributeRewards();
4653 
4654     }
4655 
4656 
4657 
4658     function distributeRewards() public override payable {
4659 
4660         require(_totalSupply > 0, "Total supply invalid");
4661 
4662         if (msg.value > 0) {
4663 
4664             magnifiedRewardPerShare =
4665 
4666                 magnifiedRewardPerShare +
4667 
4668                 ((msg.value * magnitude) / _totalSupply);
4669 
4670             emit RewardsDistributed(msg.sender, msg.value);
4671 
4672             totalRewardsDistributed += msg.value;
4673 
4674         }
4675 
4676     }
4677 
4678 
4679 
4680     function setBalance(address payable account, uint256 newBalance)
4681 
4682         external
4683 
4684         override
4685 
4686         onlyOwner
4687 
4688     {
4689 
4690         if (excludedFromRewards[account]) {
4691 
4692             return;
4693 
4694         }
4695 
4696         if (newBalance >= minTokenBalanceForRewards) {
4697 
4698             _setBalance(account, newBalance);
4699 
4700         } else {
4701 
4702             _setBalance(account, 0);
4703 
4704         }
4705 
4706     }
4707 
4708 
4709 
4710     function excludeFromRewards(address account, bool excluded)
4711 
4712         external
4713 
4714         override
4715 
4716         onlyOwner
4717 
4718     {
4719 
4720         require(
4721 
4722             excludedFromRewards[account] != excluded,
4723 
4724             "AGFI_RewardTracker: account already set to requested state"
4725 
4726         );
4727 
4728         excludedFromRewards[account] = excluded;
4729 
4730         if (excluded) {
4731 
4732             _setBalance(account, 0);
4733 
4734         } else {
4735 
4736             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
4737 
4738             if (newBalance >= minTokenBalanceForRewards) {
4739 
4740                 _setBalance(account, newBalance);
4741 
4742             } else {
4743 
4744                 _setBalance(account, 0);
4745 
4746             }
4747 
4748         }
4749 
4750         emit ExcludeFromRewards(account, excluded);
4751 
4752     }
4753 
4754 
4755 
4756     function isExcludedFromRewards(address account) public override view returns (bool) {
4757 
4758         return excludedFromRewards[account];
4759 
4760     }
4761 
4762 
4763 
4764     function manualSendReward(uint256 amount, address holder)
4765 
4766         external
4767 
4768         override
4769 
4770         onlyOwner
4771 
4772     {
4773 
4774         uint256 contractETHBalance = address(this).balance;
4775 
4776         (bool success, ) = payable(holder).call{
4777 
4778             value: amount > 0 ? amount : contractETHBalance
4779 
4780         }("");
4781 
4782         require(success, "Manual send failed.");
4783 
4784     }
4785 
4786 
4787 
4788     function _setBalance(address account, uint256 newBalance) internal {
4789 
4790         uint256 currentBalance = _balances[account];
4791 
4792         if (newBalance > currentBalance) {
4793 
4794             uint256 addAmount = newBalance - currentBalance;
4795 
4796             _mint(account, addAmount);
4797 
4798         } else if (newBalance < currentBalance) {
4799 
4800             uint256 subAmount = currentBalance - newBalance;
4801 
4802             _burn(account, subAmount);
4803 
4804         }
4805 
4806     }
4807 
4808 
4809 
4810     function _mint(address account, uint256 amount) private {
4811 
4812         require(
4813 
4814             account != address(0),
4815 
4816             "AGFI_RewardTracker: mint to the zero address"
4817 
4818         );
4819 
4820         _totalSupply += amount;
4821 
4822         _balances[account] += amount;
4823 
4824         emit Transfer(address(0), account, amount);
4825 
4826         magnifiedRewardCorrections[account] =
4827 
4828             magnifiedRewardCorrections[account] -
4829 
4830             int256(magnifiedRewardPerShare * amount);
4831 
4832     }
4833 
4834 
4835 
4836     function _burn(address account, uint256 amount) private {
4837 
4838         require(
4839 
4840             account != address(0),
4841 
4842             "AGFI_RewardTracker: burn from the zero address"
4843 
4844         );
4845 
4846         uint256 accountBalance = _balances[account];
4847 
4848         require(
4849 
4850             accountBalance >= amount,
4851 
4852             "AGFI_RewardTracker: burn amount exceeds balance"
4853 
4854         );
4855 
4856         _balances[account] = accountBalance - amount;
4857 
4858         _totalSupply -= amount;
4859 
4860         emit Transfer(account, address(0), amount);
4861 
4862         magnifiedRewardCorrections[account] =
4863 
4864             magnifiedRewardCorrections[account] +
4865 
4866             int256(magnifiedRewardPerShare * amount);
4867 
4868     }
4869 
4870 
4871 
4872     function processAccount(address payable account)
4873 
4874         public
4875 
4876         override
4877 
4878         onlyOwner
4879 
4880         returns (bool)
4881 
4882     {
4883 
4884         uint256 amount = _withdrawRewardOfUser(account);
4885 
4886         if (amount > 0) {
4887 
4888             lastClaimTimes[account] = block.timestamp;
4889 
4890             emit Claim(account, amount);
4891 
4892             return true;
4893 
4894         }
4895 
4896         return false;
4897 
4898     }
4899 
4900 
4901 
4902     function _withdrawRewardOfUser(address payable account)
4903 
4904         private
4905 
4906         returns (uint256)
4907 
4908     {
4909 
4910         uint256 _withdrawableReward = withdrawableRewardOf(account);
4911 
4912         if (_withdrawableReward > 0) {
4913 
4914             withdrawnRewards[account] += _withdrawableReward;
4915 
4916             totalRewardsWithdrawn += _withdrawableReward;
4917 
4918             (bool success, ) = account.call{value: _withdrawableReward}("");
4919 
4920             if (!success) {
4921 
4922                 withdrawnRewards[account] -= _withdrawableReward;
4923 
4924                 totalRewardsWithdrawn -= _withdrawableReward;
4925 
4926                 emit LogErrorString("Withdraw failed");
4927 
4928                 return 0;
4929 
4930             }
4931 
4932             emit RewardWithdrawn(account, _withdrawableReward);
4933 
4934             return _withdrawableReward;
4935 
4936         }
4937 
4938         return 0;
4939 
4940     }
4941 
4942 
4943 
4944     function compoundAccount(address payable account)
4945 
4946         public
4947 
4948         override
4949 
4950         onlyOwner
4951 
4952         returns (bool)
4953 
4954     {
4955 
4956         (uint256 amount, uint256 tokens) = _compoundRewardOfUser(account);
4957 
4958         if (amount > 0) {
4959 
4960             lastClaimTimes[account] = block.timestamp;
4961 
4962             emit Compound(account, amount, tokens);
4963 
4964             return true;
4965 
4966         }
4967 
4968         return false;
4969 
4970     }
4971 
4972 
4973 
4974     function _compoundRewardOfUser(address payable account)
4975 
4976         private
4977 
4978         returns (uint256, uint256)
4979 
4980     {
4981 
4982         uint256 _withdrawableReward = withdrawableRewardOf(account);
4983 
4984         if (_withdrawableReward > 0) {
4985 
4986             withdrawnRewards[account] += _withdrawableReward;
4987 
4988             totalRewardsWithdrawn += _withdrawableReward;
4989 
4990 
4991 
4992             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
4993 
4994                 UNISWAPROUTER
4995 
4996             );
4997 
4998 
4999 
5000             address[] memory path = new address[](2);
5001 
5002             path[0] = uniswapV2Router.WETH();
5003 
5004             path[1] = address(tokenAddress);
5005 
5006 
5007 
5008             bool success;
5009 
5010             uint256 tokens;
5011 
5012 
5013 
5014             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
5015 
5016             try
5017 
5018                 uniswapV2Router
5019 
5020                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
5021 
5022                     value: _withdrawableReward
5023 
5024                 }(0, path, address(account), block.timestamp)
5025 
5026             {
5027 
5028                 success = true;
5029 
5030                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
5031 
5032             } catch Error(
5033 
5034                 string memory reason /*err*/
5035 
5036             ) {
5037 
5038                 emit LogErrorString(reason);
5039 
5040                 success = false;
5041 
5042             }
5043 
5044 
5045 
5046             if (!success) {
5047 
5048                 withdrawnRewards[account] -= _withdrawableReward;
5049 
5050                 totalRewardsWithdrawn -= _withdrawableReward;
5051 
5052                 emit LogErrorString("Withdraw failed");
5053 
5054                 return (0, 0);
5055 
5056             }
5057 
5058 
5059 
5060             emit RewardWithdrawn(account, _withdrawableReward);
5061 
5062             return (_withdrawableReward, tokens);
5063 
5064         }
5065 
5066         return (0, 0);
5067 
5068     }
5069 
5070 
5071 
5072     function withdrawableRewardOf(address account)
5073 
5074         public
5075 
5076         override
5077 
5078         view
5079 
5080         returns (uint256)
5081 
5082     {
5083 
5084         return accumulativeRewardOf(account) - withdrawnRewards[account];
5085 
5086     }
5087 
5088 
5089 
5090     function withdrawnRewardOf(address account) public view returns (uint256) {
5091 
5092         return withdrawnRewards[account];
5093 
5094     }
5095 
5096 
5097 
5098     function accumulativeRewardOf(address account)
5099 
5100         public
5101 
5102         override
5103 
5104         view
5105 
5106         returns (uint256)
5107 
5108     {
5109 
5110         int256 a = int256(magnifiedRewardPerShare * balanceOf(account));
5111 
5112         int256 b = magnifiedRewardCorrections[account]; // this is an explicit int256 (signed)
5113 
5114         return uint256(a + b) / magnitude;
5115 
5116     }
5117 
5118 
5119 
5120     function getAccountInfo(address account)
5121 
5122         public
5123 
5124         override
5125 
5126         view
5127 
5128         returns (
5129 
5130             address,
5131 
5132             uint256,
5133 
5134             uint256,
5135 
5136             uint256,
5137 
5138             uint256
5139 
5140         )
5141 
5142     {
5143 
5144         AccountInfo memory info;
5145 
5146         info.account = account;
5147 
5148         info.withdrawableRewards = withdrawableRewardOf(account);
5149 
5150         info.totalRewards = accumulativeRewardOf(account);
5151 
5152         info.lastClaimTime = lastClaimTimes[account];
5153 
5154         return (
5155 
5156             info.account,
5157 
5158             info.withdrawableRewards,
5159 
5160             info.totalRewards,
5161 
5162             info.lastClaimTime,
5163 
5164             totalRewardsWithdrawn
5165 
5166         );
5167 
5168     }
5169 
5170 
5171 
5172     function getLastClaimTime(address account) public override view returns (uint256) {
5173 
5174         return lastClaimTimes[account];
5175 
5176     }
5177 
5178 
5179 
5180     function name() public override pure returns (string memory) {
5181 
5182         return _name;
5183 
5184     }
5185 
5186 
5187 
5188     function symbol() public override pure returns (string memory) {
5189 
5190         return _symbol;
5191 
5192     }
5193 
5194 
5195 
5196     function decimals() public override pure returns (uint8) {
5197 
5198         return 9;
5199 
5200     }
5201 
5202 
5203 
5204     function totalSupply() public view override returns (uint256) {
5205 
5206         return _totalSupply;
5207 
5208     }
5209 
5210 
5211 
5212     function balanceOf(address account) public view override returns (uint256) {
5213 
5214         return _balances[account];
5215 
5216     }
5217 
5218 
5219 
5220     function transfer(address, uint256) public pure override returns (bool) {
5221 
5222         revert("AGFI_RewardTracker: method not implemented");
5223 
5224     }
5225 
5226 
5227 
5228     function allowance(address, address)
5229 
5230         public
5231 
5232         pure
5233 
5234         override
5235 
5236         returns (uint256)
5237 
5238     {
5239 
5240         revert("AGFI_RewardTracker: method not implemented");
5241 
5242     }
5243 
5244 
5245 
5246     function approve(address, uint256) public pure override returns (bool) {
5247 
5248         revert("AGFI_RewardTracker: method not implemented");
5249 
5250     }
5251 
5252 
5253 
5254     function transferFrom(
5255 
5256         address,
5257 
5258         address,
5259 
5260         uint256
5261 
5262     ) public pure override returns (bool) {
5263 
5264         revert("AGFI_RewardTracker: method not implemented");
5265 
5266     }
5267 
5268 }
5269 // File: contracts/AggregatedFinance.sol
5270 
5271 
5272 
5273 pragma solidity ^0.8.13;
5274 
5275 
5276 
5277 
5278 
5279 
5280 
5281 
5282 
5283 
5284 
5285 
5286 /// @custom:security-contact team@aggregated.finance
5287 
5288 contract AggregatedFinance is ERC20, ERC20Burnable, ERC20Snapshot, Ownable, ERC20Permit, ERC20Votes {
5289 
5290     address constant UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
5291 
5292 
5293 
5294     // non-immutable reward tracker so it can be upgraded if needed
5295 
5296     IRewardTracker public rewardTracker;
5297 
5298     IUniswapV2Router02 public immutable uniswapV2Router;
5299 
5300     address public immutable uniswapV2Pair;
5301 
5302 
5303 
5304     mapping (address => uint256) private _balances;
5305 
5306     mapping (address => mapping(address => uint256)) private _allowances;
5307 
5308     mapping (address => bool) public _blacklist;
5309 
5310     mapping (address => bool) private _isExcludedFromFees;
5311 
5312     mapping (address => uint256) private _holderLastTransferTimestamp;
5313 
5314     mapping (address => bool) public automatedMarketMakerPairs;
5315 
5316 
5317 
5318     bool public limitsInEffect = true;
5319 
5320     bool public transferDelayEnabled = true;
5321 
5322     bool private swapping;
5323 
5324     uint8 public swapIndex; // tracks which fee is being sold off
5325 
5326     bool private isCompounding;
5327 
5328     bool public transferTaxEnabled = false;
5329 
5330     bool public swapEnabled = false;
5331 
5332     bool public compoundingEnabled = true;
5333 
5334     uint256 public lastSwapTime;
5335 
5336     uint256 private launchedAt;
5337 
5338 
5339 
5340     // Fee channel definitions. Enable each individually, and define tax rates for each.
5341 
5342     bool public buyFeeC1Enabled = true;
5343 
5344     bool public buyFeeC2Enabled = false;
5345 
5346     bool public buyFeeC3Enabled = true;
5347 
5348     bool public buyFeeC4Enabled = true;
5349 
5350     bool public buyFeeC5Enabled = true;
5351 
5352 
5353 
5354     bool public sellFeeC1Enabled = true;
5355 
5356     bool public sellFeeC2Enabled = true;
5357 
5358     bool public sellFeeC3Enabled = true;
5359 
5360     bool public sellFeeC4Enabled = true;
5361 
5362     bool public sellFeeC5Enabled = true;
5363 
5364 
5365 
5366     bool public swapC1Enabled = true;
5367 
5368     bool public swapC2Enabled = true;
5369 
5370     bool public swapC3Enabled = true;
5371 
5372     bool public swapC4Enabled = true;
5373 
5374     bool public swapC5Enabled = true;
5375 
5376 
5377 
5378     bool public c2BurningEnabled = true;
5379 
5380     bool public c3RewardsEnabled = true;
5381 
5382 
5383 
5384     uint256 public tokensForC1;
5385 
5386     uint256 public tokensForC2;
5387 
5388     uint256 public tokensForC3;
5389 
5390     uint256 public tokensForC4;
5391 
5392     uint256 public tokensForC5;
5393 
5394 
5395 
5396     // treasury wallet, default to 0x3e822d55e79eA9F53C744BD9179d89dDec081556
5397 
5398     address public c1Wallet;
5399 
5400 
5401 
5402     // burning wallet, default to the staking rewards wallet, but when burning is enabled 
5403 
5404     // it will just burn them. The wallet still needs to be defined to function:
5405 
5406     // 0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f
5407 
5408     address public c2Wallet;
5409 
5410 
5411 
5412     // rewards wallet, default to the rewards contract itself, not a wallet. But
5413 
5414     // if rewards are disabled then they'll fall back to the staking rewards wallet:
5415 
5416     // 0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f
5417 
5418     address public c3Wallet;
5419 
5420 
5421 
5422     // staking rewards wallet, default to 0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f
5423 
5424     address public c4Wallet;
5425 
5426 
5427 
5428     // operations wallet, default to 0xf05E5AeFeCd9c370fbfFff94c6c4614E6c165b78
5429 
5430     address public c5Wallet;
5431 
5432 
5433 
5434     uint256 public buyTotalFees = 1200; // 12% default
5435 
5436     uint256 public buyC1Fee = 400; // 4% Treasury
5437 
5438     uint256 public buyC2Fee = 0; // Nothing
5439 
5440     uint256 public buyC3Fee = 300; // 3% Eth Rewards
5441 
5442     uint256 public buyC4Fee = 300; // 3% Eth Staking Pool
5443 
5444     uint256 public buyC5Fee = 200; // 2% Operations
5445 
5446  
5447 
5448     uint256 public sellTotalFees = 1300; // 13% default
5449 
5450     uint256 public sellC1Fee = 400; // 4% Treasury
5451 
5452     uint256 public sellC2Fee = 100; // 1% Auto Burn
5453 
5454     uint256 public sellC3Fee = 300; // 3% Eth Rewards
5455 
5456     uint256 public sellC4Fee = 300; // 3% Eth Staking Pool
5457 
5458     uint256 public sellC5Fee = 200; // 2% Operations
5459 
5460 
5461 
5462     event LogErrorString(string message);
5463 
5464     event SwapEnabled(bool enabled);
5465 
5466     event TaxEnabled(bool enabled);
5467 
5468     event TransferTaxEnabled(bool enabled);
5469 
5470     event CompoundingEnabled(bool enabled);
5471 
5472     event ChangeSwapTokensAtAmount(uint256 amount);
5473 
5474     event LimitsReinstated();
5475 
5476     event LimitsRemoved();
5477 
5478     event C2BurningModified(bool enabled);
5479 
5480     event C3RewardsModified(bool enabled);
5481 
5482     event ChannelWalletsModified(address indexed newAddress, uint8 idx);
5483 
5484 
5485 
5486     event BoughtEarly(address indexed sniper);
5487 
5488     event ExcludeFromFees(address indexed account, bool isExcluded);
5489 
5490     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
5491 
5492     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
5493 
5494     event SetRewardTracker(address indexed newAddress);
5495 
5496     event FeesUpdated();
5497 
5498     event SendChannel1(uint256 amount);
5499 
5500     event SendChannel2(uint256 amount);
5501 
5502     event SendChannel3(uint256 amount);
5503 
5504     event SendChannel4(uint256 amount);
5505 
5506     event SendChannel5(uint256 amount);
5507 
5508     event TokensBurned(uint256 amountBurned);
5509 
5510     event NativeWithdrawn();
5511 
5512     event FeesWithdrawn();
5513 
5514 
5515 
5516     constructor()
5517 
5518         ERC20("Aggregated Finance", "AGFI")
5519 
5520         ERC20Permit("Aggregated Finance")
5521 
5522     {
5523 
5524         c1Wallet = address(0x3e822d55e79eA9F53C744BD9179d89dDec081556);
5525 
5526         c2Wallet = address(0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f);
5527 
5528         c3Wallet = address(0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f);
5529 
5530         c4Wallet = address(0x16cc620dBBACc751DAB85d7Fc1164C62858d9b9f);
5531 
5532         c5Wallet = address(0xf05E5AeFeCd9c370fbfFff94c6c4614E6c165b78);
5533 
5534 
5535 
5536         rewardTracker = new RewardTracker(address(this), UNISWAPROUTER);
5537 
5538 
5539 
5540         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
5541 
5542 
5543 
5544         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
5545 
5546 
5547 
5548         uniswapV2Router = _uniswapV2Router;
5549 
5550         uniswapV2Pair = _uniswapV2Pair;
5551 
5552 
5553 
5554         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
5555 
5556 
5557 
5558         rewardTracker.excludeFromRewards(address(rewardTracker), true);
5559 
5560         rewardTracker.excludeFromRewards(address(this), true);
5561 
5562         rewardTracker.excludeFromRewards(owner(), true);
5563 
5564         rewardTracker.excludeFromRewards(address(_uniswapV2Router), true);
5565 
5566         rewardTracker.excludeFromRewards(address(0xdead), true); // we won't use the dead address as we can burn, but just in case someone burns their tokens
5567 
5568 
5569 
5570         excludeFromFees(owner(), true);
5571 
5572         excludeFromFees(address(rewardTracker), true);
5573 
5574         excludeFromFees(address(this), true);
5575 
5576         excludeFromFees(address(0xdead), true);
5577 
5578 
5579 
5580         _mint(owner(), 1000000000000 * (1e9)); // 1,000,000,000,000 tokens with 9 decimal places
5581 
5582     }
5583 
5584 
5585 
5586     receive() external payable {}
5587 
5588 
5589 
5590     function decimals() override public pure returns (uint8) {
5591 
5592         return 9;
5593 
5594     }
5595 
5596 
5597 
5598     function excludeFromFees(address account, bool excluded) public onlyOwner {
5599 
5600         _isExcludedFromFees[account] = excluded;
5601 
5602         emit ExcludeFromFees(account, excluded);
5603 
5604     }
5605 
5606 
5607 
5608     function isExcludedFromFees(address account) public view returns (bool) {
5609 
5610         return _isExcludedFromFees[account];
5611 
5612     }
5613 
5614 
5615 
5616     function blacklistAccount(address account, bool isBlacklisted) public onlyOwner {
5617 
5618         _blacklist[account] = isBlacklisted;
5619 
5620     }
5621 
5622 
5623 
5624     function setAutomatedMarketMakerPair(address pair, bool enabled) public onlyOwner {
5625 
5626         require(pair != uniswapV2Pair, "AGFI: The pair cannot be removed from automatedMarketMakerPairs");
5627 
5628         _setAutomatedMarketMakerPair(pair, enabled);
5629 
5630     }
5631 
5632 
5633 
5634     function _setAutomatedMarketMakerPair(address pair, bool enabled) private {
5635 
5636         automatedMarketMakerPairs[pair] = enabled;
5637 
5638         emit SetAutomatedMarketMakerPair(pair, enabled);
5639 
5640     }
5641 
5642 
5643 
5644     function setRewardTracker(address payable newTracker) public onlyOwner {
5645 
5646         require(newTracker != address(0), "AGFI: newTracker cannot be zero address");
5647 
5648         rewardTracker = IRewardTracker(newTracker);
5649 
5650         emit SetRewardTracker(newTracker);
5651 
5652     }
5653 
5654 
5655 
5656     function claim() public {
5657 
5658         rewardTracker.processAccount(payable(_msgSender()));
5659 
5660     }
5661 
5662 
5663 
5664     function compound() public {
5665 
5666         require(compoundingEnabled, "AGFI: compounding is not enabled");
5667 
5668         isCompounding = true;
5669 
5670         rewardTracker.compoundAccount(payable(_msgSender()));
5671 
5672         isCompounding = false;
5673 
5674     }
5675 
5676 
5677 
5678     function withdrawableRewardOf(address account)
5679 
5680         public
5681 
5682         view
5683 
5684         returns (uint256)
5685 
5686     {
5687 
5688         return rewardTracker.withdrawableRewardOf(account);
5689 
5690     }
5691 
5692 
5693 
5694     function withdrawnRewardOf(address account) public view returns (uint256) {
5695 
5696         return rewardTracker.withdrawnRewardOf(account);
5697 
5698     }
5699 
5700 
5701 
5702     function accumulativeRewardOf(address account) public view returns (uint256) {
5703 
5704         return rewardTracker.accumulativeRewardOf(account);
5705 
5706     }
5707 
5708 
5709 
5710     function getAccountInfo(address account)
5711 
5712         public
5713 
5714         view
5715 
5716         returns (
5717 
5718             address,
5719 
5720             uint256,
5721 
5722             uint256,
5723 
5724             uint256,
5725 
5726             uint256
5727 
5728         )
5729 
5730     {
5731 
5732         return rewardTracker.getAccountInfo(account);
5733 
5734     }
5735 
5736 
5737 
5738     function enableTrading() external onlyOwner {
5739 
5740         swapEnabled = true;
5741 
5742         transferTaxEnabled = true;
5743 
5744         launchedAt = block.number;
5745 
5746     }
5747 
5748 
5749 
5750     function getLastClaimTime(address account) public view returns (uint256) {
5751 
5752         return rewardTracker.getLastClaimTime(account);
5753 
5754     }
5755 
5756 
5757 
5758     function setCompoundingEnabled(bool enabled) external onlyOwner {
5759 
5760         compoundingEnabled = enabled;
5761 
5762         emit CompoundingEnabled(enabled);
5763 
5764     }
5765 
5766 
5767 
5768     function setSwapEnabled(bool enabled) external onlyOwner {
5769 
5770         swapEnabled = enabled;
5771 
5772         emit SwapEnabled(enabled);
5773 
5774     }
5775 
5776 
5777 
5778     function setSwapChannels(bool c1, bool c2, bool c3, bool c4, bool c5) external onlyOwner {
5779 
5780         swapC1Enabled = c1;
5781 
5782         swapC2Enabled = c2;
5783 
5784         swapC3Enabled = c3;
5785 
5786         swapC4Enabled = c4;
5787 
5788         swapC5Enabled = c5;
5789 
5790     }
5791 
5792 
5793 
5794     function setTransferTaxEnabled(bool enabled) external onlyOwner {
5795 
5796         transferTaxEnabled = enabled;
5797 
5798         emit TransferTaxEnabled(enabled);
5799 
5800     }
5801 
5802 
5803 
5804     function removeLimits() external onlyOwner {
5805 
5806         limitsInEffect = false;
5807 
5808         emit LimitsRemoved();
5809 
5810     }
5811 
5812 
5813 
5814     function reinstateLimits() external onlyOwner {
5815 
5816         limitsInEffect = true;
5817 
5818         emit LimitsReinstated();
5819 
5820     }
5821 
5822 
5823 
5824     function modifyC2Burning(bool enabled) external onlyOwner {
5825 
5826         c2BurningEnabled = enabled;
5827 
5828         emit C2BurningModified(enabled);
5829 
5830     }
5831 
5832 
5833 
5834     function modifyC3Rewards(bool enabled) external onlyOwner {
5835 
5836         c3RewardsEnabled = enabled;
5837 
5838         emit C3RewardsModified(enabled);
5839 
5840     }
5841 
5842 
5843 
5844     function modifyChannelWallet(address newAddress, uint8 idx) external onlyOwner {
5845 
5846         require(newAddress != address(0), "AGFI: newAddress can not be zero address.");
5847 
5848 
5849 
5850         if (idx == 1) {
5851 
5852             c1Wallet = newAddress;
5853 
5854         } else if (idx == 2) {
5855 
5856             c2Wallet = newAddress;
5857 
5858         } else if (idx == 3) {
5859 
5860             c3Wallet = newAddress;
5861 
5862         } else if (idx == 4) {
5863 
5864             c4Wallet = newAddress;
5865 
5866         } else if (idx == 5) {
5867 
5868             c5Wallet = newAddress;
5869 
5870         }
5871 
5872 
5873 
5874         emit ChannelWalletsModified(newAddress, idx);
5875 
5876     }
5877 
5878 
5879 
5880     // disable Transfer delay - cannot be reenabled
5881 
5882     function disableTransferDelay() external onlyOwner returns (bool) {
5883 
5884         transferDelayEnabled = false;
5885 
5886         // not bothering with an event emission, as it's only called once
5887 
5888         return true;
5889 
5890     }
5891 
5892 
5893 
5894     function updateBuyFees(
5895 
5896         bool _enableC1,
5897 
5898         uint256 _c1Fee,
5899 
5900         bool _enableC2,
5901 
5902         uint256 _c2Fee,
5903 
5904         bool _enableC3,
5905 
5906         uint256 _c3Fee,
5907 
5908         bool _enableC4,
5909 
5910         uint256 _c4Fee,
5911 
5912         bool _enableC5,
5913 
5914         uint256 _c5Fee
5915 
5916     ) external onlyOwner {
5917 
5918         buyFeeC1Enabled = _enableC1;
5919 
5920         buyC1Fee = _c1Fee;
5921 
5922         buyFeeC2Enabled = _enableC2;
5923 
5924         buyC2Fee = _c2Fee;
5925 
5926         buyFeeC3Enabled = _enableC3;
5927 
5928         buyC3Fee = _c3Fee;
5929 
5930         buyFeeC4Enabled = _enableC4;
5931 
5932         buyC4Fee = _c4Fee;
5933 
5934         buyFeeC5Enabled = _enableC5;
5935 
5936         buyC5Fee = _c5Fee;
5937 
5938 
5939 
5940         buyTotalFees = _c1Fee + _c2Fee + _c3Fee + _c4Fee + _c5Fee;
5941 
5942         require(buyTotalFees <= 3000, "AGFI: Must keep fees at 30% or less");
5943 
5944         emit FeesUpdated();
5945 
5946     }
5947 
5948  
5949 
5950     function updateSellFees(
5951 
5952         bool _enableC1,
5953 
5954         uint256 _c1Fee,
5955 
5956         bool _enableC2,
5957 
5958         uint256 _c2Fee,
5959 
5960         bool _enableC3,
5961 
5962         uint256 _c3Fee,
5963 
5964         bool _enableC4,
5965 
5966         uint256 _c4Fee,
5967 
5968         bool _enableC5,
5969 
5970         uint256 _c5Fee
5971 
5972     ) external onlyOwner {
5973 
5974         sellFeeC1Enabled = _enableC1;
5975 
5976         sellC1Fee = _c1Fee;
5977 
5978         sellFeeC2Enabled = _enableC2;
5979 
5980         sellC2Fee = _c2Fee;
5981 
5982         sellFeeC3Enabled = _enableC3;
5983 
5984         sellC3Fee = _c3Fee;
5985 
5986         sellFeeC4Enabled = _enableC4;
5987 
5988         sellC4Fee = _c4Fee;
5989 
5990         sellFeeC5Enabled = _enableC5;
5991 
5992         sellC5Fee = _c5Fee;
5993 
5994 
5995 
5996         sellTotalFees = _c1Fee + _c2Fee + _c3Fee + _c4Fee + _c5Fee;
5997 
5998         require(sellTotalFees <= 3000, "AGFI: Must keep fees at 30% or less");
5999 
6000         emit FeesUpdated();
6001 
6002     }
6003 
6004 
6005 
6006     function snapshot() public onlyOwner {
6007 
6008         _snapshot();
6009 
6010     }
6011 
6012 
6013 
6014     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Snapshot) {
6015 
6016         super._beforeTokenTransfer(from, to, amount);
6017 
6018     }
6019 
6020 
6021 
6022     function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
6023 
6024         super._afterTokenTransfer(from, to, amount);
6025 
6026     }
6027 
6028 
6029 
6030     function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
6031 
6032         super._mint(to, amount);
6033 
6034     }
6035 
6036 
6037 
6038     function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
6039 
6040         super._burn(account, amount);
6041 
6042     }
6043 
6044 
6045 
6046     function _transfer(
6047 
6048         address from,
6049 
6050         address to,
6051 
6052         uint256 amount
6053 
6054     ) internal override {
6055 
6056         require(from != address(0), "_transfer: transfer from the zero address");
6057 
6058         require(to != address(0), "_transfer: transfer to the zero address");
6059 
6060         require(!_blacklist[from], "_transfer: Sender is blacklisted");
6061 
6062         require(!_blacklist[to], "_transfer: Recipient is blacklisted");
6063 
6064 
6065 
6066          if (amount == 0) {
6067 
6068             _executeTransfer(from, to, 0);
6069 
6070             return;
6071 
6072         }
6073 
6074  
6075 
6076         if (limitsInEffect) {
6077 
6078             if (
6079 
6080                 from != owner() &&
6081 
6082                 to != owner() &&
6083 
6084                 to != address(0) &&
6085 
6086                 to != address(0xdead) &&
6087 
6088                 !swapping
6089 
6090             ) {
6091 
6092                 if (!swapEnabled) {
6093 
6094                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "_transfer: Trading is not active.");
6095 
6096                 }
6097 
6098  
6099 
6100                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
6101 
6102                 if (transferDelayEnabled){
6103 
6104                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
6105 
6106                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer: Transfer Delay enabled.  Only one purchase per block allowed.");
6107 
6108                         _holderLastTransferTimestamp[tx.origin] = block.number;
6109 
6110                     }
6111 
6112                 }
6113 
6114             }
6115 
6116         }
6117 
6118  
6119 
6120         // anti bot logic
6121 
6122         if (block.number <= (launchedAt + 3) && 
6123 
6124             to != uniswapV2Pair && 
6125 
6126             to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
6127 
6128         ) {
6129 
6130             _blacklist[to] = true;
6131 
6132             emit BoughtEarly(to);
6133 
6134         }
6135 
6136 
6137 
6138         if (
6139 
6140             swapEnabled && // only executeSwap when enabled
6141 
6142             !swapping && // and its not currently swapping (no reentry)
6143 
6144             !automatedMarketMakerPairs[from] && // no swap on remove liquidity step 1 or DEX buy
6145 
6146             from != address(uniswapV2Router) && // no swap on remove liquidity step 2
6147 
6148             from != owner() && // and not the contract owner
6149 
6150             to != owner()
6151 
6152         ) {
6153 
6154             swapping = true;
6155 
6156 
6157 
6158             _executeSwap();
6159 
6160 
6161 
6162             lastSwapTime = block.timestamp;
6163 
6164             swapping = false;
6165 
6166         }
6167 
6168 
6169 
6170         bool takeFee;
6171 
6172 
6173 
6174         if (
6175 
6176             from == address(uniswapV2Pair) ||
6177 
6178             to == address(uniswapV2Pair) ||
6179 
6180             automatedMarketMakerPairs[to] ||
6181 
6182             automatedMarketMakerPairs[from] ||
6183 
6184             transferTaxEnabled
6185 
6186         ) {
6187 
6188             takeFee = true;
6189 
6190         }
6191 
6192 
6193 
6194         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping || isCompounding || !transferTaxEnabled) {
6195 
6196             takeFee = false;
6197 
6198         }
6199 
6200 
6201 
6202         // only take fees on buys/sells, do not take on wallet transfers
6203 
6204         if (takeFee) {
6205 
6206             uint256 fees;
6207 
6208             // on sell
6209 
6210             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
6211 
6212                 fees = (amount * sellTotalFees) / 10000;
6213 
6214                 if (sellFeeC1Enabled) {
6215 
6216                     tokensForC1 += fees * sellC1Fee / sellTotalFees;
6217 
6218                 }
6219 
6220                 if (sellFeeC2Enabled) {
6221 
6222                     tokensForC2 += fees * sellC2Fee / sellTotalFees;
6223 
6224                 }
6225 
6226                 if (sellFeeC3Enabled) {
6227 
6228                     tokensForC3 += fees * sellC3Fee / sellTotalFees;
6229 
6230                 }
6231 
6232                 if (sellFeeC4Enabled) {
6233 
6234                     tokensForC4 += fees * sellC4Fee / sellTotalFees;
6235 
6236                 }
6237 
6238                 if (sellFeeC5Enabled) {
6239 
6240                     tokensForC5 += fees * sellC5Fee / sellTotalFees;
6241 
6242                 }
6243 
6244             // on buy
6245 
6246             } else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
6247 
6248                 fees = (amount * buyTotalFees) / 10000;
6249 
6250 
6251 
6252                 if (buyFeeC1Enabled) {
6253 
6254                     tokensForC1 += fees * buyC1Fee / buyTotalFees;
6255 
6256                 }
6257 
6258                 if (buyFeeC2Enabled) {
6259 
6260                     tokensForC2 += fees * buyC2Fee / buyTotalFees;
6261 
6262                 }
6263 
6264                 if (buyFeeC3Enabled) {
6265 
6266                     tokensForC3 += fees * buyC3Fee / buyTotalFees;
6267 
6268                 }
6269 
6270                 if (buyFeeC4Enabled) {
6271 
6272                     tokensForC4 += fees * buyC4Fee / buyTotalFees;
6273 
6274                 }
6275 
6276                 if (buyFeeC5Enabled) {
6277 
6278                     tokensForC5 += fees * buyC5Fee / buyTotalFees;
6279 
6280                 }
6281 
6282             }
6283 
6284  
6285 
6286             amount -= fees;
6287 
6288             if (fees > 0){
6289 
6290                 _executeTransfer(from, address(this), fees);
6291 
6292             }
6293 
6294         }
6295 
6296  
6297 
6298         _executeTransfer(from, to, amount);
6299 
6300 
6301 
6302         rewardTracker.setBalance(payable(from), balanceOf(from));
6303 
6304         rewardTracker.setBalance(payable(to), balanceOf(to));
6305 
6306     }
6307 
6308 
6309 
6310     function _executeSwap() private {
6311 
6312         uint256 contractTokenBalance = balanceOf(address(this));
6313 
6314         if (contractTokenBalance <= 0) { return; }
6315 
6316         
6317 
6318         if (swapIndex == 0 && swapC1Enabled && tokensForC1 > 0) {
6319 
6320             // channel 1 (treasury)
6321 
6322             swapTokensForNative(tokensForC1);
6323 
6324             (bool success, ) = payable(c1Wallet).call{value: address(this).balance}("");
6325 
6326             if (success) {
6327 
6328                 emit SendChannel1(tokensForC1);
6329 
6330             } else {
6331 
6332                 emit LogErrorString("Wallet failed to receive channel 1 tokens");
6333 
6334             }
6335 
6336             tokensForC1 = 0;
6337 
6338 
6339 
6340         } else if (swapIndex == 1 && swapC2Enabled && tokensForC2 > 0) {
6341 
6342             // channel 2 (burning)
6343 
6344             if (c2BurningEnabled) {
6345 
6346                 _burn(address(this), tokensForC2);
6347 
6348                 emit TokensBurned(tokensForC2);
6349 
6350             } else {
6351 
6352                 swapTokensForNative(tokensForC2);
6353 
6354                 (bool success, ) = payable(c2Wallet).call{value: address(this).balance}("");
6355 
6356                 if (success) {
6357 
6358                     emit SendChannel2(tokensForC2);
6359 
6360                 } else {
6361 
6362                     emit LogErrorString("Wallet failed to receive channel 1 tokens");
6363 
6364                 }
6365 
6366             }
6367 
6368             tokensForC2 = 0;
6369 
6370 
6371 
6372         } else if (swapIndex == 2 && swapC3Enabled && tokensForC3 > 0) {
6373 
6374             // channel 3 (rewards)
6375 
6376             if (c3RewardsEnabled) {
6377 
6378                 swapTokensForNative(tokensForC3);
6379 
6380                 (bool success, ) = payable(rewardTracker).call{value: address(this).balance}("");
6381 
6382                 if (success) {
6383 
6384                     emit SendChannel3(tokensForC3);
6385 
6386                 } else {
6387 
6388                     emit LogErrorString("Wallet failed to receive channel 3 tokens");
6389 
6390                 }
6391 
6392             } else {
6393 
6394                 _executeTransfer(address(this), c3Wallet, tokensForC3);
6395 
6396                 emit SendChannel3(tokensForC3);
6397 
6398             }
6399 
6400             tokensForC3 = 0;
6401 
6402 
6403 
6404         } else if (swapIndex == 3 && swapC4Enabled && tokensForC4 > 0) {
6405 
6406             // channel 4 (staking rewards)
6407 
6408             _executeTransfer(address(this), c4Wallet, tokensForC4);
6409 
6410             emit SendChannel4(tokensForC4);
6411 
6412             tokensForC4 = 0;
6413 
6414 
6415 
6416         } else if (swapIndex == 4 && swapC5Enabled && tokensForC5 > 0) {
6417 
6418             // channel 5 (operations funds)
6419 
6420             swapTokensForNative(tokensForC5);
6421 
6422             (bool success, ) = payable(c5Wallet).call{value: address(this).balance}("");
6423 
6424             if (success) {
6425 
6426                 emit SendChannel5(tokensForC5);
6427 
6428             } else {
6429 
6430                 emit LogErrorString("Wallet failed to receive channel 5 tokens");
6431 
6432             }
6433 
6434             tokensForC5 = 0;
6435 
6436         }
6437 
6438 
6439 
6440         if (swapIndex == 4) {
6441 
6442             swapIndex = 0; // reset back to the start
6443 
6444         } else {
6445 
6446             swapIndex++; // advance for the next swap call
6447 
6448         }
6449 
6450     }
6451 
6452 
6453 
6454     // withdraw tokens
6455 
6456     function withdrawCollectedFees() public onlyOwner {
6457 
6458         _executeTransfer(address(this), msg.sender, balanceOf(address(this)));
6459 
6460         tokensForC1 = 0;
6461 
6462         tokensForC2 = 0;
6463 
6464         tokensForC3 = 0;
6465 
6466         tokensForC4 = 0;
6467 
6468         tokensForC5 = 0;
6469 
6470         emit FeesWithdrawn();
6471 
6472     }
6473 
6474 
6475 
6476     function _executeTransfer(address sender, address recipient, uint256 amount) private {
6477 
6478         super._transfer(sender, recipient, amount);
6479 
6480     }
6481 
6482 
6483 
6484     // withdraw native
6485 
6486     function withdrawCollectedNative() public onlyOwner {
6487 
6488         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
6489 
6490         if (success) {
6491 
6492             emit NativeWithdrawn();
6493 
6494         } else {
6495 
6496             emit LogErrorString("Wallet failed to receive channel 5 tokens");
6497 
6498         }
6499 
6500     }
6501 
6502 
6503 
6504     // swap the tokens back to ETH
6505 
6506     function swapTokensForNative(uint256 tokens) private {
6507 
6508         address[] memory path = new address[](2);
6509 
6510         path[0] = address(this);
6511 
6512         path[1] = uniswapV2Router.WETH();
6513 
6514         _approve(address(this), address(uniswapV2Router), tokens);
6515 
6516         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
6517 
6518             tokens,
6519 
6520             0, // accept any amount of native
6521 
6522             path,
6523 
6524             address(this),
6525 
6526             block.timestamp
6527 
6528         );
6529 
6530     }
6531 
6532 }