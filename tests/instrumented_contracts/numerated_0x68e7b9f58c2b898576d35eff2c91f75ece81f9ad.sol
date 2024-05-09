1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.17;
4 pragma experimental ABIEncoderV2;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      *
58      * _Available since v2.4.0._
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      * - The divisor cannot be zero.
115      *
116      * _Available since v2.4.0._
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         // Solidity only automatically asserts when dividing by 0
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      *
153      * _Available since v2.4.0._
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
162 
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: contracts/external/Require.sol
240 
241 /*
242     Copyright 2019 dYdX Trading Inc.
243 
244     Licensed under the Apache License, Version 2.0 (the "License");
245     you may not use this file except in compliance with the License.
246     You may obtain a copy of the License at
247 
248     http://www.apache.org/licenses/LICENSE-2.0
249 
250     Unless required by applicable law or agreed to in writing, software
251     distributed under the License is distributed on an "AS IS" BASIS,
252     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
253     See the License for the specific language governing permissions and
254     limitations under the License.
255 */
256 
257 /**
258  * @title Require
259  * @author dYdX
260  *
261  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
262  */
263 library Require {
264 
265     // ============ Constants ============
266 
267     uint256 constant ASCII_ZERO = 48; // '0'
268     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
269     uint256 constant ASCII_LOWER_EX = 120; // 'x'
270     bytes2 constant COLON = 0x3a20; // ': '
271     bytes2 constant COMMA = 0x2c20; // ', '
272     bytes2 constant LPAREN = 0x203c; // ' <'
273     byte constant RPAREN = 0x3e; // '>'
274     uint256 constant FOUR_BIT_MASK = 0xf;
275 
276     // ============ Library Functions ============
277 
278     function that(
279         bool must,
280         bytes32 file,
281         bytes32 reason
282     )
283     internal
284     pure
285     {
286         if (!must) {
287             revert(
288                 string(
289                     abi.encodePacked(
290                         stringifyTruncated(file),
291                         COLON,
292                         stringifyTruncated(reason)
293                     )
294                 )
295             );
296         }
297     }
298 
299     function that(
300         bool must,
301         bytes32 file,
302         bytes32 reason,
303         uint256 payloadA
304     )
305     internal
306     pure
307     {
308         if (!must) {
309             revert(
310                 string(
311                     abi.encodePacked(
312                         stringifyTruncated(file),
313                         COLON,
314                         stringifyTruncated(reason),
315                         LPAREN,
316                         stringify(payloadA),
317                         RPAREN
318                     )
319                 )
320             );
321         }
322     }
323 
324     function that(
325         bool must,
326         bytes32 file,
327         bytes32 reason,
328         uint256 payloadA,
329         uint256 payloadB
330     )
331     internal
332     pure
333     {
334         if (!must) {
335             revert(
336                 string(
337                     abi.encodePacked(
338                         stringifyTruncated(file),
339                         COLON,
340                         stringifyTruncated(reason),
341                         LPAREN,
342                         stringify(payloadA),
343                         COMMA,
344                         stringify(payloadB),
345                         RPAREN
346                     )
347                 )
348             );
349         }
350     }
351 
352     function that(
353         bool must,
354         bytes32 file,
355         bytes32 reason,
356         address payloadA
357     )
358     internal
359     pure
360     {
361         if (!must) {
362             revert(
363                 string(
364                     abi.encodePacked(
365                         stringifyTruncated(file),
366                         COLON,
367                         stringifyTruncated(reason),
368                         LPAREN,
369                         stringify(payloadA),
370                         RPAREN
371                     )
372                 )
373             );
374         }
375     }
376 
377     function that(
378         bool must,
379         bytes32 file,
380         bytes32 reason,
381         address payloadA,
382         uint256 payloadB
383     )
384     internal
385     pure
386     {
387         if (!must) {
388             revert(
389                 string(
390                     abi.encodePacked(
391                         stringifyTruncated(file),
392                         COLON,
393                         stringifyTruncated(reason),
394                         LPAREN,
395                         stringify(payloadA),
396                         COMMA,
397                         stringify(payloadB),
398                         RPAREN
399                     )
400                 )
401             );
402         }
403     }
404 
405     function that(
406         bool must,
407         bytes32 file,
408         bytes32 reason,
409         address payloadA,
410         uint256 payloadB,
411         uint256 payloadC
412     )
413     internal
414     pure
415     {
416         if (!must) {
417             revert(
418                 string(
419                     abi.encodePacked(
420                         stringifyTruncated(file),
421                         COLON,
422                         stringifyTruncated(reason),
423                         LPAREN,
424                         stringify(payloadA),
425                         COMMA,
426                         stringify(payloadB),
427                         COMMA,
428                         stringify(payloadC),
429                         RPAREN
430                     )
431                 )
432             );
433         }
434     }
435 
436     function that(
437         bool must,
438         bytes32 file,
439         bytes32 reason,
440         bytes32 payloadA
441     )
442     internal
443     pure
444     {
445         if (!must) {
446             revert(
447                 string(
448                     abi.encodePacked(
449                         stringifyTruncated(file),
450                         COLON,
451                         stringifyTruncated(reason),
452                         LPAREN,
453                         stringify(payloadA),
454                         RPAREN
455                     )
456                 )
457             );
458         }
459     }
460 
461     function that(
462         bool must,
463         bytes32 file,
464         bytes32 reason,
465         bytes32 payloadA,
466         uint256 payloadB,
467         uint256 payloadC
468     )
469     internal
470     pure
471     {
472         if (!must) {
473             revert(
474                 string(
475                     abi.encodePacked(
476                         stringifyTruncated(file),
477                         COLON,
478                         stringifyTruncated(reason),
479                         LPAREN,
480                         stringify(payloadA),
481                         COMMA,
482                         stringify(payloadB),
483                         COMMA,
484                         stringify(payloadC),
485                         RPAREN
486                     )
487                 )
488             );
489         }
490     }
491 
492     // ============ Private Functions ============
493 
494     function stringifyTruncated(
495         bytes32 input
496     )
497     private
498     pure
499     returns (bytes memory)
500     {
501         // put the input bytes into the result
502         bytes memory result = abi.encodePacked(input);
503 
504         // determine the length of the input by finding the location of the last non-zero byte
505         for (uint256 i = 32; i > 0; ) {
506             // reverse-for-loops with unsigned integer
507             /* solium-disable-next-line security/no-modify-for-iter-var */
508             i--;
509 
510             // find the last non-zero byte in order to determine the length
511             if (result[i] != 0) {
512                 uint256 length = i + 1;
513 
514                 /* solium-disable-next-line security/no-inline-assembly */
515                 assembly {
516                     mstore(result, length) // r.length = length;
517                 }
518 
519                 return result;
520             }
521         }
522 
523         // all bytes are zero
524         return new bytes(0);
525     }
526 
527     function stringify(
528         uint256 input
529     )
530     private
531     pure
532     returns (bytes memory)
533     {
534         if (input == 0) {
535             return "0";
536         }
537 
538         // get the final string length
539         uint256 j = input;
540         uint256 length;
541         while (j != 0) {
542             length++;
543             j /= 10;
544         }
545 
546         // allocate the string
547         bytes memory bstr = new bytes(length);
548 
549         // populate the string starting with the least-significant character
550         j = input;
551         for (uint256 i = length; i > 0; ) {
552             // reverse-for-loops with unsigned integer
553             /* solium-disable-next-line security/no-modify-for-iter-var */
554             i--;
555 
556             // take last decimal digit
557             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
558 
559             // remove the last decimal digit
560             j /= 10;
561         }
562 
563         return bstr;
564     }
565 
566     function stringify(
567         address input
568     )
569     private
570     pure
571     returns (bytes memory)
572     {
573         uint256 z = uint256(input);
574 
575         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
576         bytes memory result = new bytes(42);
577 
578         // populate the result with "0x"
579         result[0] = byte(uint8(ASCII_ZERO));
580         result[1] = byte(uint8(ASCII_LOWER_EX));
581 
582         // for each byte (starting from the lowest byte), populate the result with two characters
583         for (uint256 i = 0; i < 20; i++) {
584             // each byte takes two characters
585             uint256 shift = i * 2;
586 
587             // populate the least-significant character
588             result[41 - shift] = char(z & FOUR_BIT_MASK);
589             z = z >> 4;
590 
591             // populate the most-significant character
592             result[40 - shift] = char(z & FOUR_BIT_MASK);
593             z = z >> 4;
594         }
595 
596         return result;
597     }
598 
599     function stringify(
600         bytes32 input
601     )
602     private
603     pure
604     returns (bytes memory)
605     {
606         uint256 z = uint256(input);
607 
608         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
609         bytes memory result = new bytes(66);
610 
611         // populate the result with "0x"
612         result[0] = byte(uint8(ASCII_ZERO));
613         result[1] = byte(uint8(ASCII_LOWER_EX));
614 
615         // for each byte (starting from the lowest byte), populate the result with two characters
616         for (uint256 i = 0; i < 32; i++) {
617             // each byte takes two characters
618             uint256 shift = i * 2;
619 
620             // populate the least-significant character
621             result[65 - shift] = char(z & FOUR_BIT_MASK);
622             z = z >> 4;
623 
624             // populate the most-significant character
625             result[64 - shift] = char(z & FOUR_BIT_MASK);
626             z = z >> 4;
627         }
628 
629         return result;
630     }
631 
632     function char(
633         uint256 input
634     )
635     private
636     pure
637     returns (byte)
638     {
639         // return ASCII digit (0-9)
640         if (input < 10) {
641             return byte(uint8(input + ASCII_ZERO));
642         }
643 
644         // return ASCII letter (a-f)
645         return byte(uint8(input + ASCII_RELATIVE_ZERO));
646     }
647 }
648 
649 // File: contracts/external/Decimal.sol
650 
651 /*
652     Copyright 2019 dYdX Trading Inc.
653     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
654 
655     Licensed under the Apache License, Version 2.0 (the "License");
656     you may not use this file except in compliance with the License.
657     You may obtain a copy of the License at
658 
659     http://www.apache.org/licenses/LICENSE-2.0
660 
661     Unless required by applicable law or agreed to in writing, software
662     distributed under the License is distributed on an "AS IS" BASIS,
663     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
664     See the License for the specific language governing permissions and
665     limitations under the License.
666 */
667 
668 
669 /**
670  * @title Decimal
671  * @author dYdX
672  *
673  * Library that defines a fixed-point number with 18 decimal places.
674  */
675 library Decimal {
676     using SafeMath for uint256;
677 
678     // ============ Constants ============
679 
680     uint256 constant BASE = 10**18;
681 
682     // ============ Structs ============
683 
684 
685     struct D256 {
686         uint256 value;
687     }
688 
689     // ============ Static Functions ============
690 
691     function zero()
692     internal
693     pure
694     returns (D256 memory)
695     {
696         return D256({ value: 0 });
697     }
698 
699     function one()
700     internal
701     pure
702     returns (D256 memory)
703     {
704         return D256({ value: BASE });
705     }
706 
707     function from(
708         uint256 a
709     )
710     internal
711     pure
712     returns (D256 memory)
713     {
714         return D256({ value: a.mul(BASE) });
715     }
716 
717     function ratio(
718         uint256 a,
719         uint256 b
720     )
721     internal
722     pure
723     returns (D256 memory)
724     {
725         return D256({ value: getPartial(a, BASE, b) });
726     }
727 
728     // ============ Self Functions ============
729 
730     function add(
731         D256 memory self,
732         uint256 b
733     )
734     internal
735     pure
736     returns (D256 memory)
737     {
738         return D256({ value: self.value.add(b.mul(BASE)) });
739     }
740 
741     function sub(
742         D256 memory self,
743         uint256 b
744     )
745     internal
746     pure
747     returns (D256 memory)
748     {
749         return D256({ value: self.value.sub(b.mul(BASE)) });
750     }
751 
752     function sub(
753         D256 memory self,
754         uint256 b,
755         string memory reason
756     )
757     internal
758     pure
759     returns (D256 memory)
760     {
761         return D256({ value: self.value.sub(b.mul(BASE), reason) });
762     }
763 
764     function mul(
765         D256 memory self,
766         uint256 b
767     )
768     internal
769     pure
770     returns (D256 memory)
771     {
772         return D256({ value: self.value.mul(b) });
773     }
774 
775     function div(
776         D256 memory self,
777         uint256 b
778     )
779     internal
780     pure
781     returns (D256 memory)
782     {
783         return D256({ value: self.value.div(b) });
784     }
785 
786     function pow(
787         D256 memory self,
788         uint256 b
789     )
790     internal
791     pure
792     returns (D256 memory)
793     {
794         if (b == 0) {
795             return from(1);
796         }
797 
798         D256 memory temp = D256({ value: self.value });
799         for (uint256 i = 1; i < b; i++) {
800             temp = mul(temp, self);
801         }
802 
803         return temp;
804     }
805 
806     function add(
807         D256 memory self,
808         D256 memory b
809     )
810     internal
811     pure
812     returns (D256 memory)
813     {
814         return D256({ value: self.value.add(b.value) });
815     }
816 
817     function sub(
818         D256 memory self,
819         D256 memory b
820     )
821     internal
822     pure
823     returns (D256 memory)
824     {
825         return D256({ value: self.value.sub(b.value) });
826     }
827 
828     function sub(
829         D256 memory self,
830         D256 memory b,
831         string memory reason
832     )
833     internal
834     pure
835     returns (D256 memory)
836     {
837         return D256({ value: self.value.sub(b.value, reason) });
838     }
839 
840     function mul(
841         D256 memory self,
842         D256 memory b
843     )
844     internal
845     pure
846     returns (D256 memory)
847     {
848         return D256({ value: getPartial(self.value, b.value, BASE) });
849     }
850 
851     function div(
852         D256 memory self,
853         D256 memory b
854     )
855     internal
856     pure
857     returns (D256 memory)
858     {
859         return D256({ value: getPartial(self.value, BASE, b.value) });
860     }
861 
862     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
863         return self.value == b.value;
864     }
865 
866     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
867         return compareTo(self, b) == 2;
868     }
869 
870     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
871         return compareTo(self, b) == 0;
872     }
873 
874     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
875         return compareTo(self, b) > 0;
876     }
877 
878     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
879         return compareTo(self, b) < 2;
880     }
881 
882     function isZero(D256 memory self) internal pure returns (bool) {
883         return self.value == 0;
884     }
885 
886     function asUint256(D256 memory self) internal pure returns (uint256) {
887         return self.value.div(BASE);
888     }
889 
890     // ============ Core Methods ============
891 
892     function getPartial(
893         uint256 target,
894         uint256 numerator,
895         uint256 denominator
896     )
897     private
898     pure
899     returns (uint256)
900     {
901         return target.mul(numerator).div(denominator);
902     }
903 
904     function compareTo(
905         D256 memory a,
906         D256 memory b
907     )
908     private
909     pure
910     returns (uint256)
911     {
912         if (a.value == b.value) {
913             return 1;
914         }
915         return a.value > b.value ? 2 : 0;
916     }
917 }
918 
919 // File: contracts/Constants.sol
920 
921 /*
922     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
923 
924     Licensed under the Apache License, Version 2.0 (the "License");
925     you may not use this file except in compliance with the License.
926     You may obtain a copy of the License at
927 
928     http://www.apache.org/licenses/LICENSE-2.0
929 
930     Unless required by applicable law or agreed to in writing, software
931     distributed under the License is distributed on an "AS IS" BASIS,
932     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
933     See the License for the specific language governing permissions and
934     limitations under the License.
935 */
936 
937 library Constants {
938     /* Chain */
939     uint256 private constant CHAIN_ID = 1; // Mainnet
940 
941     /* Bootstrapping */
942     uint256 private constant BOOTSTRAPPING_PERIOD = 168; // 168 epochs / 7 days
943     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC (targeting 4.5% inflation)
944 
945     /* Oracle */
946     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
947     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e9; // 1,000 USDC
948 
949     /* Bonding */
950     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 SSD -> 100M SSDS
951 
952     /* Epoch */
953     struct EpochStrategy {
954         uint256 offset;
955         uint256 start;
956         uint256 period;
957     }
958 
959     uint256 private constant EPOCH_OFFSET = 0;
960     uint256 private constant EPOCH_START = 1610596800;
961     uint256 private constant EPOCH_PERIOD = 3600;
962 
963     /* Governance */
964     uint256 private constant GOVERNANCE_PERIOD = 36;
965     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
966     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
967     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
968 
969     /* DAO */
970     uint256 private constant ADVANCE_INCENTIVE = 60e18; // 60$
971     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 36; // 36 epochs fluid
972 
973     /* Pool */
974     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 12; // 12 epochs fluid
975 
976     /* Market */
977     uint256 private constant COUPON_EXPIRATION = 720;
978     uint256 private constant DEBT_RATIO_CAP = 30e16; // 30%
979 
980     /* Regulator */
981     uint256 private constant SUPPLY_CHANGE_DIVISOR = 12e18; // 12
982     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
983     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
984 
985     /**
986      * Getters
987      */
988     function getUsdcAddress() internal pure returns (address) {
989         return USDC;
990     }
991 
992     function getOracleReserveMinimum() internal pure returns (uint256) {
993         return ORACLE_RESERVE_MINIMUM;
994     }
995 
996     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
997         return EpochStrategy({
998             offset: EPOCH_OFFSET,
999             start: EPOCH_START,
1000             period: EPOCH_PERIOD
1001         });
1002     }
1003 
1004     function getInitialStakeMultiple() internal pure returns (uint256) {
1005         return INITIAL_STAKE_MULTIPLE;
1006     }
1007 
1008     function getBootstrappingPeriod() internal pure returns (uint256) {
1009         return BOOTSTRAPPING_PERIOD;
1010     }
1011 
1012     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1013         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1014     }
1015 
1016     function getGovernancePeriod() internal pure returns (uint256) {
1017         return GOVERNANCE_PERIOD;
1018     }
1019 
1020     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1021         return Decimal.D256({value: GOVERNANCE_QUORUM});
1022     }
1023 
1024     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1025         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1026     }
1027 
1028     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1029         return GOVERNANCE_EMERGENCY_DELAY;
1030     }
1031 
1032     function getAdvanceIncentive() internal pure returns (uint256) {
1033         return ADVANCE_INCENTIVE;
1034     }
1035 
1036     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1037         return DAO_EXIT_LOCKUP_EPOCHS;
1038     }
1039 
1040     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1041         return POOL_EXIT_LOCKUP_EPOCHS;
1042     }
1043 
1044     function getCouponExpiration() internal pure returns (uint256) {
1045         return COUPON_EXPIRATION;
1046     }
1047 
1048     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1049         return Decimal.D256({value: DEBT_RATIO_CAP});
1050     }
1051 
1052     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1053         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1054     }
1055 
1056     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1057         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1058     }
1059 
1060     function getOraclePoolRatio() internal pure returns (uint256) {
1061         return ORACLE_POOL_RATIO;
1062     }
1063 
1064     function getChainId() internal pure returns (uint256) {
1065         return CHAIN_ID;
1066     }
1067 }
1068 
1069 // File: contracts/token/IDollar.sol
1070 
1071 /*
1072     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1073 
1074     Licensed under the Apache License, Version 2.0 (the "License");
1075     you may not use this file except in compliance with the License.
1076     You may obtain a copy of the License at
1077 
1078     http://www.apache.org/licenses/LICENSE-2.0
1079 
1080     Unless required by applicable law or agreed to in writing, software
1081     distributed under the License is distributed on an "AS IS" BASIS,
1082     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1083     See the License for the specific language governing permissions and
1084     limitations under the License.
1085 */
1086 
1087 
1088 contract IDollar is IERC20 {
1089     function burn(uint256 amount) public;
1090     function burnFrom(address account, uint256 amount) public;
1091     function mint(address account, uint256 amount) public returns (bool);
1092 }
1093 
1094 // File: contracts/oracle/IDAO.sol
1095 
1096 /*
1097     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1098 
1099     Licensed under the Apache License, Version 2.0 (the "License");
1100     you may not use this file except in compliance with the License.
1101     You may obtain a copy of the License at
1102 
1103     http://www.apache.org/licenses/LICENSE-2.0
1104 
1105     Unless required by applicable law or agreed to in writing, software
1106     distributed under the License is distributed on an "AS IS" BASIS,
1107     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1108     See the License for the specific language governing permissions and
1109     limitations under the License.
1110 */
1111 
1112 contract IDAO {
1113     function epoch() external view returns (uint256);
1114 }
1115 
1116 // File: contracts/oracle/IUSDC.sol
1117 
1118 /*
1119     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1120 
1121     Licensed under the Apache License, Version 2.0 (the "License");
1122     you may not use this file except in compliance with the License.
1123     You may obtain a copy of the License at
1124 
1125     http://www.apache.org/licenses/LICENSE-2.0
1126 
1127     Unless required by applicable law or agreed to in writing, software
1128     distributed under the License is distributed on an "AS IS" BASIS,
1129     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1130     See the License for the specific language governing permissions and
1131     limitations under the License.
1132 */
1133 
1134 contract IUSDC {
1135     function isBlacklisted(address _account) external view returns (bool);
1136 }
1137 
1138 // File: contracts/oracle/PoolState.sol
1139 
1140 /*
1141     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1142 
1143     Licensed under the Apache License, Version 2.0 (the "License");
1144     you may not use this file except in compliance with the License.
1145     You may obtain a copy of the License at
1146 
1147     http://www.apache.org/licenses/LICENSE-2.0
1148 
1149     Unless required by applicable law or agreed to in writing, software
1150     distributed under the License is distributed on an "AS IS" BASIS,
1151     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1152     See the License for the specific language governing permissions and
1153     limitations under the License.
1154 */
1155 
1156 
1157 
1158 contract PoolAccount {
1159     enum Status {
1160         Frozen,
1161         Fluid,
1162         Locked
1163     }
1164 
1165     struct State {
1166         uint256 staged;
1167         uint256 claimable;
1168         uint256 bonded;
1169         uint256 phantom;
1170         uint256 fluidUntil;
1171     }
1172 }
1173 
1174 contract PoolStorage {
1175     struct Provider {
1176         IDAO dao;
1177         IDollar dollar;
1178         IERC20 univ2;
1179     }
1180 
1181     struct Balance {
1182         uint256 staged;
1183         uint256 claimable;
1184         uint256 bonded;
1185         uint256 phantom;
1186     }
1187 
1188     struct State {
1189         Balance balance;
1190         Provider provider;
1191 
1192         bool paused;
1193 
1194         mapping(address => PoolAccount.State) accounts;
1195     }
1196 }
1197 
1198 contract PoolState {
1199     PoolStorage.State _state;
1200 }
1201 
1202 // File: contracts/oracle/PoolGetters.sol
1203 
1204 /*
1205     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1206 
1207     Licensed under the Apache License, Version 2.0 (the "License");
1208     you may not use this file except in compliance with the License.
1209     You may obtain a copy of the License at
1210 
1211     http://www.apache.org/licenses/LICENSE-2.0
1212 
1213     Unless required by applicable law or agreed to in writing, software
1214     distributed under the License is distributed on an "AS IS" BASIS,
1215     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1216     See the License for the specific language governing permissions and
1217     limitations under the License.
1218 */
1219 
1220 
1221 contract PoolGetters is PoolState {
1222     using SafeMath for uint256;
1223 
1224     /**
1225      * Global
1226      */
1227 
1228     function usdc() public view returns (address) {
1229         return Constants.getUsdcAddress();
1230     }
1231 
1232     function dao() public view returns (IDAO) {
1233         return _state.provider.dao;
1234     }
1235 
1236     function dollar() public view returns (IDollar) {
1237         return _state.provider.dollar;
1238     }
1239 
1240     function univ2() public view returns (IERC20) {
1241         return _state.provider.univ2;
1242     }
1243 
1244     function totalBonded() public view returns (uint256) {
1245         return _state.balance.bonded;
1246     }
1247 
1248     function totalStaged() public view returns (uint256) {
1249         return _state.balance.staged;
1250     }
1251 
1252     function totalClaimable() public view returns (uint256) {
1253         return _state.balance.claimable;
1254     }
1255 
1256     function totalPhantom() public view returns (uint256) {
1257         return _state.balance.phantom;
1258     }
1259 
1260     function totalRewarded() public view returns (uint256) {
1261         return dollar().balanceOf(address(this)).sub(totalClaimable());
1262     }
1263 
1264     function paused() public view returns (bool) {
1265         return _state.paused;
1266     }
1267 
1268     /**
1269      * Account
1270      */
1271 
1272     function balanceOfStaged(address account) public view returns (uint256) {
1273         return _state.accounts[account].staged;
1274     }
1275 
1276     function balanceOfClaimable(address account) public view returns (uint256) {
1277         return _state.accounts[account].claimable;
1278     }
1279 
1280     function balanceOfBonded(address account) public view returns (uint256) {
1281         return _state.accounts[account].bonded;
1282     }
1283 
1284     function balanceOfPhantom(address account) public view returns (uint256) {
1285         return _state.accounts[account].phantom;
1286     }
1287 
1288     function balanceOfRewarded(address account) public view returns (uint256) {
1289         uint256 totalBonded = totalBonded();
1290         if (totalBonded == 0) {
1291             return 0;
1292         }
1293 
1294         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1295         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1296             .mul(balanceOfBonded(account))
1297             .div(totalBonded);
1298 
1299         uint256 balanceOfPhantom = balanceOfPhantom(account);
1300         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1301             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1302         }
1303         return 0;
1304     }
1305 
1306     function statusOf(address account) public view returns (PoolAccount.Status) {
1307         return epoch() >= _state.accounts[account].fluidUntil ?
1308             PoolAccount.Status.Frozen :
1309             PoolAccount.Status.Fluid;
1310     }
1311 
1312     /**
1313      * Epoch
1314      */
1315 
1316     function epoch() internal view returns (uint256) {
1317         return dao().epoch();
1318     }
1319 }
1320 
1321 // File: contracts/oracle/PoolSetters.sol
1322 
1323 /*
1324     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1325 
1326     Licensed under the Apache License, Version 2.0 (the "License");
1327     you may not use this file except in compliance with the License.
1328     You may obtain a copy of the License at
1329 
1330     http://www.apache.org/licenses/LICENSE-2.0
1331 
1332     Unless required by applicable law or agreed to in writing, software
1333     distributed under the License is distributed on an "AS IS" BASIS,
1334     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1335     See the License for the specific language governing permissions and
1336     limitations under the License.
1337 */
1338 
1339 
1340 contract PoolSetters is PoolState, PoolGetters {
1341     using SafeMath for uint256;
1342 
1343     /**
1344      * Global
1345      */
1346 
1347     function pause() internal {
1348         _state.paused = true;
1349     }
1350 
1351     /**
1352      * Account
1353      */
1354 
1355     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1356         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1357         _state.balance.bonded = _state.balance.bonded.add(amount);
1358     }
1359 
1360     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1361         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1362         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1363     }
1364 
1365     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1366         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1367         _state.balance.staged = _state.balance.staged.add(amount);
1368     }
1369 
1370     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1371         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1372         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1373     }
1374 
1375     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1376         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1377         _state.balance.claimable = _state.balance.claimable.add(amount);
1378     }
1379 
1380     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1381         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1382         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1383     }
1384 
1385     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1386         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1387         _state.balance.phantom = _state.balance.phantom.add(amount);
1388     }
1389 
1390     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1391         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1392         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1393     }
1394 
1395     function unfreeze(address account) internal {
1396         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1397     }
1398 }
1399 
1400 // File: sushiswap/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
1401 
1402 interface IUniswapV2Pair {
1403     event Approval(address indexed owner, address indexed spender, uint value);
1404     event Transfer(address indexed from, address indexed to, uint value);
1405 
1406     function name() external pure returns (string memory);
1407     function symbol() external pure returns (string memory);
1408     function decimals() external pure returns (uint8);
1409     function totalSupply() external view returns (uint);
1410     function balanceOf(address owner) external view returns (uint);
1411     function allowance(address owner, address spender) external view returns (uint);
1412 
1413     function approve(address spender, uint value) external returns (bool);
1414     function transfer(address to, uint value) external returns (bool);
1415     function transferFrom(address from, address to, uint value) external returns (bool);
1416 
1417     function DOMAIN_SEPARATOR() external view returns (bytes32);
1418     function PERMIT_TYPEHASH() external pure returns (bytes32);
1419     function nonces(address owner) external view returns (uint);
1420 
1421     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1422 
1423     event Mint(address indexed sender, uint amount0, uint amount1);
1424     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1425     event Swap(
1426         address indexed sender,
1427         uint amount0In,
1428         uint amount1In,
1429         uint amount0Out,
1430         uint amount1Out,
1431         address indexed to
1432     );
1433     event Sync(uint112 reserve0, uint112 reserve1);
1434 
1435     function MINIMUM_LIQUIDITY() external pure returns (uint);
1436     function factory() external view returns (address);
1437     function token0() external view returns (address);
1438     function token1() external view returns (address);
1439     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1440     function price0CumulativeLast() external view returns (uint);
1441     function price1CumulativeLast() external view returns (uint);
1442     function kLast() external view returns (uint);
1443 
1444     function mint(address to) external returns (uint liquidity);
1445     function burn(address to) external returns (uint amount0, uint amount1);
1446     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1447     function skim(address to) external;
1448     function sync() external;
1449 
1450     function initialize(address, address) external;
1451 }
1452 
1453 // File: contracts/external/UniswapV2Library.sol
1454 
1455 
1456 
1457 library UniswapV2Library {
1458     using SafeMath for uint;
1459 
1460     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1461     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1462         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1463         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1464         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1465     }
1466 
1467     // calculates the CREATE2 address for a pair without making any external calls
1468     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1469         (address token0, address token1) = sortTokens(tokenA, tokenB);
1470         pair = address(uint(keccak256(abi.encodePacked(
1471                 hex'ff',
1472                 factory,
1473                 keccak256(abi.encodePacked(token0, token1)),
1474                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
1475             ))));
1476     }
1477 
1478     // fetches and sorts the reserves for a pair
1479     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1480         (address token0,) = sortTokens(tokenA, tokenB);
1481         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1482         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1483     }
1484 
1485     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1486     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1487         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1488         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1489         amountB = amountA.mul(reserveB) / reserveA;
1490     }
1491 }
1492 
1493 // File: contracts/oracle/Liquidity.sol
1494 
1495 /*
1496     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1497 
1498     Licensed under the Apache License, Version 2.0 (the "License");
1499     you may not use this file except in compliance with the License.
1500     You may obtain a copy of the License at
1501 
1502     http://www.apache.org/licenses/LICENSE-2.0
1503 
1504     Unless required by applicable law or agreed to in writing, software
1505     distributed under the License is distributed on an "AS IS" BASIS,
1506     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1507     See the License for the specific language governing permissions and
1508     limitations under the License.
1509 */
1510 
1511 
1512 
1513 
1514 contract Liquidity is PoolGetters {
1515     address private constant UNISWAP_FACTORY = address(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
1516 
1517     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1518         (address dollar, address usdc) = (address(dollar()), usdc());
1519         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1520 
1521         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1522              dollarAmount :
1523              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1524 
1525         address pair = address(univ2());
1526         IERC20(dollar).transfer(pair, dollarAmount);
1527         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1528         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1529     }
1530 
1531     // overridable for testing
1532     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1533         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1534         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1535         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1536     }
1537 }
1538 
1539 // File: contracts/oracle/Pool.sol
1540 
1541 /*
1542     Copyright 2021 Sushi Set Devs, based on the works of the Empty Set Squad
1543 
1544     Licensed under the Apache License, Version 2.0 (the "License");
1545     you may not use this file except in compliance with the License.
1546     You may obtain a copy of the License at
1547 
1548     http://www.apache.org/licenses/LICENSE-2.0
1549 
1550     Unless required by applicable law or agreed to in writing, software
1551     distributed under the License is distributed on an "AS IS" BASIS,
1552     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1553     See the License for the specific language governing permissions and
1554     limitations under the License.
1555 */
1556 
1557 
1558 
1559 
1560 contract Pool is PoolSetters, Liquidity {
1561     using SafeMath for uint256;
1562 
1563     constructor(address dollar, address univ2) public {
1564         _state.provider.dao = IDAO(msg.sender);
1565         _state.provider.dollar = IDollar(dollar);
1566         _state.provider.univ2 = IERC20(univ2);
1567     }
1568 
1569     bytes32 private constant FILE = "Pool";
1570 
1571     event Deposit(address indexed account, uint256 value);
1572     event Withdraw(address indexed account, uint256 value);
1573     event Claim(address indexed account, uint256 value);
1574     event Bond(address indexed account, uint256 start, uint256 value);
1575     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1576     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1577 
1578     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1579         univ2().transferFrom(msg.sender, address(this), value);
1580         incrementBalanceOfStaged(msg.sender, value);
1581 
1582         balanceCheck();
1583 
1584         emit Deposit(msg.sender, value);
1585     }
1586 
1587     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1588         univ2().transfer(msg.sender, value);
1589         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1590 
1591         balanceCheck();
1592 
1593         emit Withdraw(msg.sender, value);
1594     }
1595 
1596     function claim(uint256 value) external onlyFrozen(msg.sender) {
1597         dollar().transfer(msg.sender, value);
1598         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1599 
1600         balanceCheck();
1601 
1602         emit Claim(msg.sender, value);
1603     }
1604 
1605     function bond(uint256 value) external notPaused {
1606         unfreeze(msg.sender);
1607 
1608         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1609         uint256 newPhantom = totalBonded() == 0 ?
1610             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1611             totalRewardedWithPhantom.mul(value).div(totalBonded());
1612 
1613         incrementBalanceOfBonded(msg.sender, value);
1614         incrementBalanceOfPhantom(msg.sender, newPhantom);
1615         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1616 
1617         balanceCheck();
1618 
1619         emit Bond(msg.sender, epoch().add(1), value);
1620     }
1621 
1622     function unbond(uint256 value) external {
1623         unfreeze(msg.sender);
1624 
1625         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1626         Require.that(
1627             balanceOfBonded > 0,
1628             FILE,
1629             "insufficient bonded balance"
1630         );
1631 
1632         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1633         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1634 
1635         incrementBalanceOfStaged(msg.sender, value);
1636         incrementBalanceOfClaimable(msg.sender, newClaimable);
1637         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1638         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1639 
1640         balanceCheck();
1641 
1642         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1643     }
1644 
1645     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1646         Require.that(
1647             totalBonded() > 0,
1648             FILE,
1649             "insufficient total bonded"
1650         );
1651 
1652         Require.that(
1653             totalRewarded() > 0,
1654             FILE,
1655             "insufficient total rewarded"
1656         );
1657 
1658         Require.that(
1659             balanceOfRewarded(msg.sender) >= value,
1660             FILE,
1661             "insufficient rewarded balance"
1662         );
1663 
1664         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1665 
1666         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1667         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1668 
1669         incrementBalanceOfBonded(msg.sender, newUniv2);
1670         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1671 
1672 
1673         balanceCheck();
1674 
1675         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1676     }
1677 
1678     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1679         IERC20(token).transfer(address(dao()), value);
1680     }
1681 
1682     function emergencyPause() external onlyDao {
1683         pause();
1684     }
1685 
1686     function balanceCheck() private {
1687         Require.that(
1688             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1689             FILE,
1690             "Inconsistent UNI-V2 balances"
1691         );
1692     }
1693 
1694     modifier onlyFrozen(address account) {
1695         Require.that(
1696             statusOf(account) == PoolAccount.Status.Frozen,
1697             FILE,
1698             "Not frozen"
1699         );
1700 
1701         _;
1702     }
1703 
1704     modifier onlyDao() {
1705         Require.that(
1706             msg.sender == address(dao()),
1707             FILE,
1708             "Not dao"
1709         );
1710 
1711         _;
1712     }
1713 
1714     modifier notPaused() {
1715         Require.that(
1716             !paused(),
1717             FILE,
1718             "Paused"
1719         );
1720 
1721         _;
1722     }
1723 }