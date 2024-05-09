1 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 
161 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
162 
163 // pragma solidity ^0.5.0;
164 
165 /**
166  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
167  * the optional functions; to access them see {ERC20Detailed}.
168  */
169 interface IERC20 {
170     /**
171      * @dev Returns the amount of tokens in existence.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     /**
176      * @dev Returns the amount of tokens owned by `account`.
177      */
178     function balanceOf(address account) external view returns (uint256);
179 
180     /**
181      * @dev Moves `amount` tokens from the caller's account to `recipient`.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Returns the remaining number of tokens that `spender` will be
191      * allowed to spend on behalf of `owner` through {transferFrom}. This is
192      * zero by default.
193      *
194      * This value changes when {approve} or {transferFrom} are called.
195      */
196     function allowance(address owner, address spender) external view returns (uint256);
197 
198     /**
199      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * // importANT: Beware that changing an allowance with this method brings the risk
204      * that someone may use both the old and the new allowance by unfortunate
205      * transaction ordering. One possible solution to mitigate this race
206      * condition is to first reduce the spender's allowance to 0 and set the
207      * desired value afterwards:
208      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address spender, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Moves `amount` tokens from `sender` to `recipient` using the
216      * allowance mechanism. `amount` is then deducted from the caller's
217      * allowance.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
227      * another (`to`).
228      *
229      * Note that `value` may be zero.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 
241 // Dependency file: contracts/external/Require.sol
242 
243 /*
244     Copyright 2019 dYdX Trading Inc.
245 
246     Licensed under the Apache License, Version 2.0 (the "License");
247     you may not use this file except in compliance with the License.
248     You may obtain a copy of the License at
249 
250     http://www.apache.org/licenses/LICENSE-2.0
251 
252     Unless required by applicable law or agreed to in writing, software
253     distributed under the License is distributed on an "AS IS" BASIS,
254     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
255     See the License for the specific language governing permissions and
256     limitations under the License.
257 */
258 
259 // pragma solidity ^0.5.7;
260 
261 /**
262  * @title Require
263  * @author dYdX
264  *
265  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
266  */
267 library Require {
268 
269     // ============ Constants ============
270 
271     uint256 constant ASCII_ZERO = 48; // '0'
272     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
273     uint256 constant ASCII_LOWER_EX = 120; // 'x'
274     bytes2 constant COLON = 0x3a20; // ': '
275     bytes2 constant COMMA = 0x2c20; // ', '
276     bytes2 constant LPAREN = 0x203c; // ' <'
277     byte constant RPAREN = 0x3e; // '>'
278     uint256 constant FOUR_BIT_MASK = 0xf;
279 
280     // ============ Library Functions ============
281 
282     function that(
283         bool must,
284         bytes32 file,
285         bytes32 reason
286     )
287     internal
288     pure
289     {
290         if (!must) {
291             revert(
292                 string(
293                     abi.encodePacked(
294                         stringifyTruncated(file),
295                         COLON,
296                         stringifyTruncated(reason)
297                     )
298                 )
299             );
300         }
301     }
302 
303     function that(
304         bool must,
305         bytes32 file,
306         bytes32 reason,
307         uint256 payloadA
308     )
309     internal
310     pure
311     {
312         if (!must) {
313             revert(
314                 string(
315                     abi.encodePacked(
316                         stringifyTruncated(file),
317                         COLON,
318                         stringifyTruncated(reason),
319                         LPAREN,
320                         stringify(payloadA),
321                         RPAREN
322                     )
323                 )
324             );
325         }
326     }
327 
328     function that(
329         bool must,
330         bytes32 file,
331         bytes32 reason,
332         uint256 payloadA,
333         uint256 payloadB
334     )
335     internal
336     pure
337     {
338         if (!must) {
339             revert(
340                 string(
341                     abi.encodePacked(
342                         stringifyTruncated(file),
343                         COLON,
344                         stringifyTruncated(reason),
345                         LPAREN,
346                         stringify(payloadA),
347                         COMMA,
348                         stringify(payloadB),
349                         RPAREN
350                     )
351                 )
352             );
353         }
354     }
355 
356     function that(
357         bool must,
358         bytes32 file,
359         bytes32 reason,
360         address payloadA
361     )
362     internal
363     pure
364     {
365         if (!must) {
366             revert(
367                 string(
368                     abi.encodePacked(
369                         stringifyTruncated(file),
370                         COLON,
371                         stringifyTruncated(reason),
372                         LPAREN,
373                         stringify(payloadA),
374                         RPAREN
375                     )
376                 )
377             );
378         }
379     }
380 
381     function that(
382         bool must,
383         bytes32 file,
384         bytes32 reason,
385         address payloadA,
386         uint256 payloadB
387     )
388     internal
389     pure
390     {
391         if (!must) {
392             revert(
393                 string(
394                     abi.encodePacked(
395                         stringifyTruncated(file),
396                         COLON,
397                         stringifyTruncated(reason),
398                         LPAREN,
399                         stringify(payloadA),
400                         COMMA,
401                         stringify(payloadB),
402                         RPAREN
403                     )
404                 )
405             );
406         }
407     }
408 
409     function that(
410         bool must,
411         bytes32 file,
412         bytes32 reason,
413         address payloadA,
414         uint256 payloadB,
415         uint256 payloadC
416     )
417     internal
418     pure
419     {
420         if (!must) {
421             revert(
422                 string(
423                     abi.encodePacked(
424                         stringifyTruncated(file),
425                         COLON,
426                         stringifyTruncated(reason),
427                         LPAREN,
428                         stringify(payloadA),
429                         COMMA,
430                         stringify(payloadB),
431                         COMMA,
432                         stringify(payloadC),
433                         RPAREN
434                     )
435                 )
436             );
437         }
438     }
439 
440     function that(
441         bool must,
442         bytes32 file,
443         bytes32 reason,
444         bytes32 payloadA
445     )
446     internal
447     pure
448     {
449         if (!must) {
450             revert(
451                 string(
452                     abi.encodePacked(
453                         stringifyTruncated(file),
454                         COLON,
455                         stringifyTruncated(reason),
456                         LPAREN,
457                         stringify(payloadA),
458                         RPAREN
459                     )
460                 )
461             );
462         }
463     }
464 
465     function that(
466         bool must,
467         bytes32 file,
468         bytes32 reason,
469         bytes32 payloadA,
470         uint256 payloadB,
471         uint256 payloadC
472     )
473     internal
474     pure
475     {
476         if (!must) {
477             revert(
478                 string(
479                     abi.encodePacked(
480                         stringifyTruncated(file),
481                         COLON,
482                         stringifyTruncated(reason),
483                         LPAREN,
484                         stringify(payloadA),
485                         COMMA,
486                         stringify(payloadB),
487                         COMMA,
488                         stringify(payloadC),
489                         RPAREN
490                     )
491                 )
492             );
493         }
494     }
495 
496     // ============ Private Functions ============
497 
498     function stringifyTruncated(
499         bytes32 input
500     )
501     private
502     pure
503     returns (bytes memory)
504     {
505         // put the input bytes into the result
506         bytes memory result = abi.encodePacked(input);
507 
508         // determine the length of the input by finding the location of the last non-zero byte
509         for (uint256 i = 32; i > 0; ) {
510             // reverse-for-loops with unsigned integer
511             /* solium-disable-next-line security/no-modify-for-iter-var */
512             i--;
513 
514             // find the last non-zero byte in order to determine the length
515             if (result[i] != 0) {
516                 uint256 length = i + 1;
517 
518                 /* solium-disable-next-line security/no-inline-assembly */
519                 assembly {
520                     mstore(result, length) // r.length = length;
521                 }
522 
523                 return result;
524             }
525         }
526 
527         // all bytes are zero
528         return new bytes(0);
529     }
530 
531     function stringify(
532         uint256 input
533     )
534     private
535     pure
536     returns (bytes memory)
537     {
538         if (input == 0) {
539             return "0";
540         }
541 
542         // get the final string length
543         uint256 j = input;
544         uint256 length;
545         while (j != 0) {
546             length++;
547             j /= 10;
548         }
549 
550         // allocate the string
551         bytes memory bstr = new bytes(length);
552 
553         // populate the string starting with the least-significant character
554         j = input;
555         for (uint256 i = length; i > 0; ) {
556             // reverse-for-loops with unsigned integer
557             /* solium-disable-next-line security/no-modify-for-iter-var */
558             i--;
559 
560             // take last decimal digit
561             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
562 
563             // remove the last decimal digit
564             j /= 10;
565         }
566 
567         return bstr;
568     }
569 
570     function stringify(
571         address input
572     )
573     private
574     pure
575     returns (bytes memory)
576     {
577         uint256 z = uint256(input);
578 
579         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
580         bytes memory result = new bytes(42);
581 
582         // populate the result with "0x"
583         result[0] = byte(uint8(ASCII_ZERO));
584         result[1] = byte(uint8(ASCII_LOWER_EX));
585 
586         // for each byte (starting from the lowest byte), populate the result with two characters
587         for (uint256 i = 0; i < 20; i++) {
588             // each byte takes two characters
589             uint256 shift = i * 2;
590 
591             // populate the least-significant character
592             result[41 - shift] = char(z & FOUR_BIT_MASK);
593             z = z >> 4;
594 
595             // populate the most-significant character
596             result[40 - shift] = char(z & FOUR_BIT_MASK);
597             z = z >> 4;
598         }
599 
600         return result;
601     }
602 
603     function stringify(
604         bytes32 input
605     )
606     private
607     pure
608     returns (bytes memory)
609     {
610         uint256 z = uint256(input);
611 
612         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
613         bytes memory result = new bytes(66);
614 
615         // populate the result with "0x"
616         result[0] = byte(uint8(ASCII_ZERO));
617         result[1] = byte(uint8(ASCII_LOWER_EX));
618 
619         // for each byte (starting from the lowest byte), populate the result with two characters
620         for (uint256 i = 0; i < 32; i++) {
621             // each byte takes two characters
622             uint256 shift = i * 2;
623 
624             // populate the least-significant character
625             result[65 - shift] = char(z & FOUR_BIT_MASK);
626             z = z >> 4;
627 
628             // populate the most-significant character
629             result[64 - shift] = char(z & FOUR_BIT_MASK);
630             z = z >> 4;
631         }
632 
633         return result;
634     }
635 
636     function char(
637         uint256 input
638     )
639     private
640     pure
641     returns (byte)
642     {
643         // return ASCII digit (0-9)
644         if (input < 10) {
645             return byte(uint8(input + ASCII_ZERO));
646         }
647 
648         // return ASCII letter (a-f)
649         return byte(uint8(input + ASCII_RELATIVE_ZERO));
650     }
651 }
652 
653 // Dependency file: contracts/external/Decimal.sol
654 
655 /*
656     Copyright 2019 dYdX Trading Inc.
657     Copyright 2020 Zero Set Dollar Devs
658 
659     Licensed under the Apache License, Version 2.0 (the "License");
660     you may not use this file except in compliance with the License.
661     You may obtain a copy of the License at
662 
663     http://www.apache.org/licenses/LICENSE-2.0
664 
665     Unless required by applicable law or agreed to in writing, software
666     distributed under the License is distributed on an "AS IS" BASIS,
667     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
668     See the License for the specific language governing permissions and
669     limitations under the License.
670 */
671 
672 // pragma solidity ^0.5.7;
673 pragma experimental ABIEncoderV2;
674 
675 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
676 
677 /**
678  * @title Decimal
679  * @author dYdX
680  *
681  * Library that defines a fixed-point number with 18 decimal places.
682  */
683 library Decimal {
684     using SafeMath for uint256;
685 
686     // ============ Constants ============
687 
688     uint256 constant BASE = 10**18;
689 
690     // ============ Structs ============
691 
692 
693     struct D256 {
694         uint256 value;
695     }
696 
697     // ============ Static Functions ============
698 
699     function zero()
700     internal
701     pure
702     returns (D256 memory)
703     {
704         return D256({ value: 0 });
705     }
706 
707     function one()
708     internal
709     pure
710     returns (D256 memory)
711     {
712         return D256({ value: BASE });
713     }
714 
715     function from(
716         uint256 a
717     )
718     internal
719     pure
720     returns (D256 memory)
721     {
722         return D256({ value: a.mul(BASE) });
723     }
724 
725     function ratio(
726         uint256 a,
727         uint256 b
728     )
729     internal
730     pure
731     returns (D256 memory)
732     {
733         return D256({ value: getPartial(a, BASE, b) });
734     }
735 
736     // ============ Self Functions ============
737 
738     function add(
739         D256 memory self,
740         uint256 b
741     )
742     internal
743     pure
744     returns (D256 memory)
745     {
746         return D256({ value: self.value.add(b.mul(BASE)) });
747     }
748 
749     function sub(
750         D256 memory self,
751         uint256 b
752     )
753     internal
754     pure
755     returns (D256 memory)
756     {
757         return D256({ value: self.value.sub(b.mul(BASE)) });
758     }
759 
760     function sub(
761         D256 memory self,
762         uint256 b,
763         string memory reason
764     )
765     internal
766     pure
767     returns (D256 memory)
768     {
769         return D256({ value: self.value.sub(b.mul(BASE), reason) });
770     }
771 
772     function mul(
773         D256 memory self,
774         uint256 b
775     )
776     internal
777     pure
778     returns (D256 memory)
779     {
780         return D256({ value: self.value.mul(b) });
781     }
782 
783     function div(
784         D256 memory self,
785         uint256 b
786     )
787     internal
788     pure
789     returns (D256 memory)
790     {
791         return D256({ value: self.value.div(b) });
792     }
793 
794     function pow(
795         D256 memory self,
796         uint256 b
797     )
798     internal
799     pure
800     returns (D256 memory)
801     {
802         if (b == 0) {
803             return from(1);
804         }
805 
806         D256 memory temp = D256({ value: self.value });
807         for (uint256 i = 1; i < b; i++) {
808             temp = mul(temp, self);
809         }
810 
811         return temp;
812     }
813 
814     function add(
815         D256 memory self,
816         D256 memory b
817     )
818     internal
819     pure
820     returns (D256 memory)
821     {
822         return D256({ value: self.value.add(b.value) });
823     }
824 
825     function sub(
826         D256 memory self,
827         D256 memory b
828     )
829     internal
830     pure
831     returns (D256 memory)
832     {
833         return D256({ value: self.value.sub(b.value) });
834     }
835 
836     function sub(
837         D256 memory self,
838         D256 memory b,
839         string memory reason
840     )
841     internal
842     pure
843     returns (D256 memory)
844     {
845         return D256({ value: self.value.sub(b.value, reason) });
846     }
847 
848     function mul(
849         D256 memory self,
850         D256 memory b
851     )
852     internal
853     pure
854     returns (D256 memory)
855     {
856         return D256({ value: getPartial(self.value, b.value, BASE) });
857     }
858 
859     function div(
860         D256 memory self,
861         D256 memory b
862     )
863     internal
864     pure
865     returns (D256 memory)
866     {
867         return D256({ value: getPartial(self.value, BASE, b.value) });
868     }
869 
870     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
871         return self.value == b.value;
872     }
873 
874     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
875         return compareTo(self, b) == 2;
876     }
877 
878     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
879         return compareTo(self, b) == 0;
880     }
881 
882     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
883         return compareTo(self, b) > 0;
884     }
885 
886     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
887         return compareTo(self, b) < 2;
888     }
889 
890     function isZero(D256 memory self) internal pure returns (bool) {
891         return self.value == 0;
892     }
893 
894     function asUint256(D256 memory self) internal pure returns (uint256) {
895         return self.value.div(BASE);
896     }
897 
898     // ============ Core Methods ============
899 
900     function getPartial(
901         uint256 target,
902         uint256 numerator,
903         uint256 denominator
904     )
905     private
906     pure
907     returns (uint256)
908     {
909         return target.mul(numerator).div(denominator);
910     }
911 
912     function compareTo(
913         D256 memory a,
914         D256 memory b
915     )
916     private
917     pure
918     returns (uint256)
919     {
920         if (a.value == b.value) {
921             return 1;
922         }
923         return a.value > b.value ? 2 : 0;
924     }
925 }
926 
927 
928 // Dependency file: contracts/Constants.sol
929 
930 /*
931     Copyright 2020 Zero Set Dollar Devs
932 
933     Licensed under the Apache License, Version 2.0 (the "License");
934     you may not use this file except in compliance with the License.
935     You may obtain a copy of the License at
936 
937     http://www.apache.org/licenses/LICENSE-2.0
938 
939     Unless required by applicable law or agreed to in writing, software
940     distributed under the License is distributed on an "AS IS" BASIS,
941     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
942     See the License for the specific language governing permissions and
943     limitations under the License.
944 */
945 
946 // pragma solidity ^0.5.17;
947 
948 
949 // import "contracts/external/Decimal.sol";
950 
951 library Constants {
952    /* Chain */
953     uint256 private constant CHAIN_ID = 1; // Mainnet
954 
955     /* Bootstrapping */
956     uint256 private constant BOOTSTRAPPING_PERIOD = 126; // 126 epochs
957     uint256 private constant BOOTSTRAPPING_PRICE = 132e16; // 1.32 USDC
958 
959     /* Oracle */
960     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
961     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
962 
963     /* Bonding */
964     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ZSD -> 100M ZSDS
965 
966     /* Epoch */
967     struct EpochStrategy {
968         uint256 offset;
969         uint256 start;
970         uint256 period;
971     }
972 
973     uint256 private constant EPOCH_OFFSET = 0;
974     uint256 private constant EPOCH_START = 1609005600;
975     uint256 private constant EPOCH_PERIOD = 14400;
976 
977     /* Governance */
978     uint256 private constant GOVERNANCE_PERIOD = 18;
979     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
980     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
981     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
982 
983     /* DAO */
984     uint256 private constant ADVANCE_INCENTIVE = 75e18; // 75 ZSD
985     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
986 
987     /* Pool */
988     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 9; // 9 epochs fluid
989 
990     /* Market */
991     uint256 private constant COUPON_EXPIRATION = 180;
992     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
993     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
994     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 3600; // 1 hour
995 
996     /* Regulator */
997     uint256 private constant SUPPLY_CHANGE_DIVISOR = 9e18; // 9%
998     uint256 private constant SUPPLY_CHANGE_LIMIT = 6e16; // 6%
999     uint256 private constant ORACLE_POOL_RATIO = 30; // 30%
1000 
1001     /**
1002      * Getters
1003      */
1004     function getUsdcAddress() internal pure returns (address) {
1005         return USDC;
1006     }
1007 
1008     function getOracleReserveMinimum() internal pure returns (uint256) {
1009         return ORACLE_RESERVE_MINIMUM;
1010     }
1011 
1012     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1013         return EpochStrategy({
1014             offset: EPOCH_OFFSET,
1015             start: EPOCH_START,
1016             period: EPOCH_PERIOD
1017         });
1018     }
1019 
1020     function getInitialStakeMultiple() internal pure returns (uint256) {
1021         return INITIAL_STAKE_MULTIPLE;
1022     }
1023 
1024     function getBootstrappingPeriod() internal pure returns (uint256) {
1025         return BOOTSTRAPPING_PERIOD;
1026     }
1027 
1028     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1029         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1030     }
1031 
1032     function getGovernancePeriod() internal pure returns (uint256) {
1033         return GOVERNANCE_PERIOD;
1034     }
1035 
1036     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1037         return Decimal.D256({value: GOVERNANCE_QUORUM});
1038     }
1039 
1040     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1041         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1042     }
1043 
1044     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1045         return GOVERNANCE_EMERGENCY_DELAY;
1046     }
1047 
1048     function getAdvanceIncentive() internal pure returns (uint256) {
1049         return ADVANCE_INCENTIVE;
1050     }
1051 
1052     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1053         return DAO_EXIT_LOCKUP_EPOCHS;
1054     }
1055 
1056     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1057         return POOL_EXIT_LOCKUP_EPOCHS;
1058     }
1059 
1060     function getCouponExpiration() internal pure returns (uint256) {
1061         return COUPON_EXPIRATION;
1062     }
1063 
1064     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1065         return Decimal.D256({value: DEBT_RATIO_CAP});
1066     }
1067     
1068     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1069         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1070     }
1071 
1072     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1073         return COUPON_REDEMPTION_PENALTY_DECAY;
1074     }
1075 
1076     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1077         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1078     }
1079 
1080     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1081         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1082     }
1083 
1084     function getOraclePoolRatio() internal pure returns (uint256) {
1085         return ORACLE_POOL_RATIO;
1086     }
1087 
1088     function getChainId() internal pure returns (uint256) {
1089         return CHAIN_ID;
1090     }
1091 }
1092 
1093 
1094 // Dependency file: contracts/token/IDollar.sol
1095 
1096 /*
1097     Copyright 2020 Zero Set Dollar Devs
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
1112 // pragma solidity ^0.5.17;
1113 
1114 
1115 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1116 
1117 contract IDollar is IERC20 {
1118     function burn(uint256 amount) public;
1119     function burnFrom(address account, uint256 amount) public;
1120     function mint(address account, uint256 amount) public returns (bool);
1121 }
1122 
1123 
1124 // Dependency file: contracts/oracle/IDAO.sol
1125 
1126 /*
1127     Copyright 2020 Zero Set Dollar Devs
1128 
1129     Licensed under the Apache License, Version 2.0 (the "License");
1130     you may not use this file except in compliance with the License.
1131     You may obtain a copy of the License at
1132 
1133     http://www.apache.org/licenses/LICENSE-2.0
1134 
1135     Unless required by applicable law or agreed to in writing, software
1136     distributed under the License is distributed on an "AS IS" BASIS,
1137     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1138     See the License for the specific language governing permissions and
1139     limitations under the License.
1140 */
1141 
1142 // pragma solidity ^0.5.17;
1143 
1144 contract IDAO {
1145     function epoch() external view returns (uint256);
1146 }
1147 
1148 // Dependency file: contracts/oracle/IUSDC.sol
1149 
1150 /*
1151     Copyright 2020 Zero Set Dollar Devs
1152 
1153     Licensed under the Apache License, Version 2.0 (the "License");
1154     you may not use this file except in compliance with the License.
1155     You may obtain a copy of the License at
1156 
1157     http://www.apache.org/licenses/LICENSE-2.0
1158 
1159     Unless required by applicable law or agreed to in writing, software
1160     distributed under the License is distributed on an "AS IS" BASIS,
1161     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1162     See the License for the specific language governing permissions and
1163     limitations under the License.
1164 */
1165 
1166 // pragma solidity ^0.5.17;
1167 
1168 contract IUSDC {
1169     function isBlacklisted(address _account) external view returns (bool);
1170 }
1171 
1172 // Dependency file: contracts/oracle/PoolState.sol
1173 
1174 /*
1175     Copyright 2020 Zero Set Dollar Devs
1176 
1177     Licensed under the Apache License, Version 2.0 (the "License");
1178     you may not use this file except in compliance with the License.
1179     You may obtain a copy of the License at
1180 
1181     http://www.apache.org/licenses/LICENSE-2.0
1182 
1183     Unless required by applicable law or agreed to in writing, software
1184     distributed under the License is distributed on an "AS IS" BASIS,
1185     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1186     See the License for the specific language governing permissions and
1187     limitations under the License.
1188 */
1189 
1190 // pragma solidity ^0.5.17;
1191 
1192 
1193 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1194 // import "contracts/token/IDollar.sol";
1195 // import "contracts/oracle/IDAO.sol";
1196 // import "contracts/oracle/IUSDC.sol";
1197 
1198 contract PoolAccount {
1199     enum Status {
1200         Frozen,
1201         Fluid,
1202         Locked
1203     }
1204 
1205     struct State {
1206         uint256 staged;
1207         uint256 claimable;
1208         uint256 bonded;
1209         uint256 phantom;
1210         uint256 fluidUntil;
1211     }
1212 }
1213 
1214 contract PoolStorage {
1215     struct Provider {
1216         IDAO dao;
1217         IDollar dollar;
1218         IERC20 univ2;
1219     }
1220     
1221     struct Balance {
1222         uint256 staged;
1223         uint256 claimable;
1224         uint256 bonded;
1225         uint256 phantom;
1226     }
1227 
1228     struct State {
1229         Balance balance;
1230         Provider provider;
1231 
1232         bool paused;
1233 
1234         mapping(address => PoolAccount.State) accounts;
1235     }
1236 }
1237 
1238 contract PoolState {
1239     PoolStorage.State _state;
1240 }
1241 
1242 
1243 // Dependency file: contracts/oracle/PoolGetters.sol
1244 
1245 /*
1246     Copyright 2020 Zero Set Dollar Devs
1247 
1248     Licensed under the Apache License, Version 2.0 (the "License");
1249     you may not use this file except in compliance with the License.
1250     You may obtain a copy of the License at
1251 
1252     http://www.apache.org/licenses/LICENSE-2.0
1253 
1254     Unless required by applicable law or agreed to in writing, software
1255     distributed under the License is distributed on an "AS IS" BASIS,
1256     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1257     See the License for the specific language governing permissions and
1258     limitations under the License.
1259 */
1260 
1261 // pragma solidity ^0.5.17;
1262 
1263 
1264 // import "@openzeppelin/contracts/math/SafeMath.sol";
1265 // import "contracts/oracle/PoolState.sol";
1266 // import "contracts/Constants.sol";
1267 
1268 contract PoolGetters is PoolState {
1269     using SafeMath for uint256;
1270 
1271     /**
1272      * Global
1273      */
1274 
1275     function usdc() public view returns (address) {
1276         return Constants.getUsdcAddress();
1277     }
1278 
1279     function dao() public view returns (IDAO) {
1280         return _state.provider.dao;
1281     }
1282 
1283     function dollar() public view returns (IDollar) {
1284         return _state.provider.dollar;
1285     }
1286 
1287     function univ2() public view returns (IERC20) {
1288         return _state.provider.univ2;
1289     }
1290 
1291     function totalBonded() public view returns (uint256) {
1292         return _state.balance.bonded;
1293     }
1294 
1295     function totalStaged() public view returns (uint256) {
1296         return _state.balance.staged;
1297     }
1298 
1299     function totalClaimable() public view returns (uint256) {
1300         return _state.balance.claimable;
1301     }
1302 
1303     function totalPhantom() public view returns (uint256) {
1304         return _state.balance.phantom;
1305     }
1306 
1307     function totalRewarded() public view returns (uint256) {
1308         return dollar().balanceOf(address(this)).sub(totalClaimable());
1309     }
1310 
1311     function paused() public view returns (bool) {
1312         return _state.paused;
1313     }
1314 
1315     /**
1316      * Account
1317      */
1318 
1319     function balanceOfStaged(address account) public view returns (uint256) {
1320         return _state.accounts[account].staged;
1321     }
1322 
1323     function balanceOfClaimable(address account) public view returns (uint256) {
1324         return _state.accounts[account].claimable;
1325     }
1326 
1327     function balanceOfBonded(address account) public view returns (uint256) {
1328         return _state.accounts[account].bonded;
1329     }
1330 
1331     function balanceOfPhantom(address account) public view returns (uint256) {
1332         return _state.accounts[account].phantom;
1333     }
1334 
1335     function balanceOfRewarded(address account) public view returns (uint256) {
1336         uint256 totalBonded = totalBonded();
1337         if (totalBonded == 0) {
1338             return 0;
1339         }
1340 
1341         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1342         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1343             .mul(balanceOfBonded(account))
1344             .div(totalBonded);
1345 
1346         uint256 balanceOfPhantom = balanceOfPhantom(account);
1347         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1348             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1349         }
1350         return 0;
1351     }
1352 
1353     function statusOf(address account) public view returns (PoolAccount.Status) {
1354         return epoch() >= _state.accounts[account].fluidUntil ?
1355             PoolAccount.Status.Frozen :
1356             PoolAccount.Status.Fluid;
1357     }
1358 
1359     /**
1360      * Epoch
1361      */
1362 
1363     function epoch() internal view returns (uint256) {
1364         return dao().epoch();
1365     }
1366 }
1367 
1368 
1369 // Dependency file: contracts/oracle/PoolSetters.sol
1370 
1371 /*
1372     Copyright 2020 Zero Set Dollar Devs
1373 
1374     Licensed under the Apache License, Version 2.0 (the "License");
1375     you may not use this file except in compliance with the License.
1376     You may obtain a copy of the License at
1377 
1378     http://www.apache.org/licenses/LICENSE-2.0
1379 
1380     Unless required by applicable law or agreed to in writing, software
1381     distributed under the License is distributed on an "AS IS" BASIS,
1382     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1383     See the License for the specific language governing permissions and
1384     limitations under the License.
1385 */
1386 
1387 // pragma solidity ^0.5.17;
1388 
1389 
1390 // import "@openzeppelin/contracts/math/SafeMath.sol";
1391 // import "contracts/oracle/PoolState.sol";
1392 // import "contracts/oracle/PoolGetters.sol";
1393 
1394 contract PoolSetters is PoolState, PoolGetters {
1395     using SafeMath for uint256;
1396 
1397     /**
1398      * Global
1399      */
1400 
1401     function pause() internal {
1402         _state.paused = true;
1403     }
1404 
1405     /**
1406      * Account
1407      */
1408 
1409     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1410         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1411         _state.balance.bonded = _state.balance.bonded.add(amount);
1412     }
1413 
1414     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1415         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1416         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1417     }
1418 
1419     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1420         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1421         _state.balance.staged = _state.balance.staged.add(amount);
1422     }
1423 
1424     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1425         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1426         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1427     }
1428 
1429     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1430         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1431         _state.balance.claimable = _state.balance.claimable.add(amount);
1432     }
1433 
1434     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1435         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1436         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1437     }
1438 
1439     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1440         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1441         _state.balance.phantom = _state.balance.phantom.add(amount);
1442     }
1443 
1444     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1445         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1446         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1447     }
1448 
1449     function unfreeze(address account) internal {
1450         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1451     }
1452 }
1453 
1454 
1455 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1456 
1457 // pragma solidity >=0.5.0;
1458 
1459 interface IUniswapV2Pair {
1460     event Approval(address indexed owner, address indexed spender, uint value);
1461     event Transfer(address indexed from, address indexed to, uint value);
1462 
1463     function name() external pure returns (string memory);
1464     function symbol() external pure returns (string memory);
1465     function decimals() external pure returns (uint8);
1466     function totalSupply() external view returns (uint);
1467     function balanceOf(address owner) external view returns (uint);
1468     function allowance(address owner, address spender) external view returns (uint);
1469 
1470     function approve(address spender, uint value) external returns (bool);
1471     function transfer(address to, uint value) external returns (bool);
1472     function transferFrom(address from, address to, uint value) external returns (bool);
1473 
1474     function DOMAIN_SEPARATOR() external view returns (bytes32);
1475     function PERMIT_TYPEHASH() external pure returns (bytes32);
1476     function nonces(address owner) external view returns (uint);
1477 
1478     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1479 
1480     event Mint(address indexed sender, uint amount0, uint amount1);
1481     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1482     event Swap(
1483         address indexed sender,
1484         uint amount0In,
1485         uint amount1In,
1486         uint amount0Out,
1487         uint amount1Out,
1488         address indexed to
1489     );
1490     event Sync(uint112 reserve0, uint112 reserve1);
1491 
1492     function MINIMUM_LIQUIDITY() external pure returns (uint);
1493     function factory() external view returns (address);
1494     function token0() external view returns (address);
1495     function token1() external view returns (address);
1496     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1497     function price0CumulativeLast() external view returns (uint);
1498     function price1CumulativeLast() external view returns (uint);
1499     function kLast() external view returns (uint);
1500 
1501     function mint(address to) external returns (uint liquidity);
1502     function burn(address to) external returns (uint amount0, uint amount1);
1503     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1504     function skim(address to) external;
1505     function sync() external;
1506 
1507     function initialize(address, address) external;
1508 }
1509 
1510 
1511 // Dependency file: contracts/external/UniswapV2Library.sol
1512 
1513 // pragma solidity >=0.5.0;
1514 
1515 // import "@openzeppelin/contracts/math/SafeMath.sol";
1516 // import '/Users/khuyen/Documents/ProjectSecret/zsd-mainet/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
1517 
1518 library UniswapV2Library {
1519     using SafeMath for uint;
1520 
1521     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1522     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1523         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1524         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1525         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1526     }
1527 
1528     // calculates the CREATE2 address for a pair without making any external calls
1529     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1530         (address token0, address token1) = sortTokens(tokenA, tokenB);
1531         pair = address(uint(keccak256(abi.encodePacked(
1532                 hex'ff',
1533                 factory,
1534                 keccak256(abi.encodePacked(token0, token1)),
1535                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1536             ))));
1537     }
1538 
1539     // fetches and sorts the reserves for a pair
1540     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1541         (address token0,) = sortTokens(tokenA, tokenB);
1542         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1543         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1544     }
1545 
1546     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1547     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1548         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1549         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1550         amountB = amountA.mul(reserveB) / reserveA;
1551     }
1552 }
1553 
1554 // Dependency file: contracts/oracle/Liquidity.sol
1555 
1556 /*
1557     Copyright 2020 Zero Set Dollar Devs
1558 
1559     Licensed under the Apache License, Version 2.0 (the "License");
1560     you may not use this file except in compliance with the License.
1561     You may obtain a copy of the License at
1562 
1563     http://www.apache.org/licenses/LICENSE-2.0
1564 
1565     Unless required by applicable law or agreed to in writing, software
1566     distributed under the License is distributed on an "AS IS" BASIS,
1567     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1568     See the License for the specific language governing permissions and
1569     limitations under the License.
1570 */
1571 
1572 // pragma solidity ^0.5.17;
1573 
1574 
1575 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1576 // import '/Users/khuyen/Documents/ProjectSecret/zsd-mainet/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
1577 // import 'contracts/external/UniswapV2Library.sol';
1578 // import "contracts/Constants.sol";
1579 // import "contracts/oracle/PoolGetters.sol";
1580 
1581 contract Liquidity is PoolGetters {
1582     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1583 
1584     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1585         (address dollar, address usdc) = (address(dollar()), usdc());
1586         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1587 
1588         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1589              dollarAmount :
1590              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1591 
1592         address pair = address(univ2());
1593         IERC20(dollar).transfer(pair, dollarAmount);
1594         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1595         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1596     }
1597 
1598     // overridable for testing
1599     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1600         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1601         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1602         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1603     }
1604 }
1605 
1606 
1607 // Root file: contracts/oracle/Pool.sol
1608 
1609 /*
1610     Copyright 2020 Zero Set Dollar Devs
1611 
1612     Licensed under the Apache License, Version 2.0 (the "License");
1613     you may not use this file except in compliance with the License.
1614     You may obtain a copy of the License at
1615 
1616     http://www.apache.org/licenses/LICENSE-2.0
1617 
1618     Unless required by applicable law or agreed to in writing, software
1619     distributed under the License is distributed on an "AS IS" BASIS,
1620     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1621     See the License for the specific language governing permissions and
1622     limitations under the License.
1623 */
1624 
1625 pragma solidity ^0.5.17;
1626 
1627 
1628 // import "@openzeppelin/contracts/math/SafeMath.sol";
1629 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1630 // import "contracts/external/Require.sol";
1631 // import "contracts/Constants.sol";
1632 // import "contracts/oracle/PoolSetters.sol";
1633 // import "contracts/oracle/Liquidity.sol";
1634 
1635 contract Pool is PoolSetters, Liquidity {
1636     using SafeMath for uint256;
1637 
1638     constructor(address dollar, address univ2) public {
1639         _state.provider.dao = IDAO(msg.sender);
1640         _state.provider.dollar = IDollar(dollar);
1641         _state.provider.univ2 = IERC20(univ2);
1642     }
1643 
1644     bytes32 private constant FILE = "Pool";
1645 
1646     event Deposit(address indexed account, uint256 value);
1647     event Withdraw(address indexed account, uint256 value);
1648     event Claim(address indexed account, uint256 value);
1649     event Bond(address indexed account, uint256 start, uint256 value);
1650     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1651     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1652 
1653     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1654         univ2().transferFrom(msg.sender, address(this), value);
1655         incrementBalanceOfStaged(msg.sender, value);
1656 
1657         balanceCheck();
1658 
1659         emit Deposit(msg.sender, value);
1660     }
1661 
1662     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1663         univ2().transfer(msg.sender, value);
1664         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1665 
1666         balanceCheck();
1667 
1668         emit Withdraw(msg.sender, value);
1669     }
1670 
1671     function claim(uint256 value) external onlyFrozen(msg.sender) {
1672         dollar().transfer(msg.sender, value);
1673         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1674 
1675         balanceCheck();
1676 
1677         emit Claim(msg.sender, value);
1678     }
1679 
1680     function bond(uint256 value) external notPaused {
1681         unfreeze(msg.sender);
1682 
1683         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1684         uint256 newPhantom = totalBonded() == 0 ?
1685             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1686             totalRewardedWithPhantom.mul(value).div(totalBonded());
1687 
1688         incrementBalanceOfBonded(msg.sender, value);
1689         incrementBalanceOfPhantom(msg.sender, newPhantom);
1690         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1691 
1692         balanceCheck();
1693 
1694         emit Bond(msg.sender, epoch().add(1), value);
1695     }
1696 
1697     function unbond(uint256 value) external {
1698         unfreeze(msg.sender);
1699 
1700         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1701         Require.that(
1702             balanceOfBonded > 0,
1703             FILE,
1704             "insufficient bonded balance"
1705         );
1706 
1707         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1708         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1709 
1710         incrementBalanceOfStaged(msg.sender, value);
1711         incrementBalanceOfClaimable(msg.sender, newClaimable);
1712         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1713         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1714 
1715         balanceCheck();
1716 
1717         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1718     }
1719 
1720     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1721         Require.that(
1722             totalBonded() > 0,
1723             FILE,
1724             "insufficient total bonded"
1725         );
1726 
1727         Require.that(
1728             totalRewarded() > 0,
1729             FILE,
1730             "insufficient total rewarded"
1731         );
1732 
1733         Require.that(
1734             balanceOfRewarded(msg.sender) >= value,
1735             FILE,
1736             "insufficient rewarded balance"
1737         );
1738 
1739         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1740 
1741         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1742         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1743 
1744         incrementBalanceOfBonded(msg.sender, newUniv2);
1745         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1746 
1747 
1748         balanceCheck();
1749 
1750         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1751     }
1752 
1753     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1754         IERC20(token).transfer(address(dao()), value);
1755     }
1756 
1757     function emergencyPause() external onlyDao {
1758         pause();
1759     }
1760 
1761     function balanceCheck() private {
1762         Require.that(
1763             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1764             FILE,
1765             "Inconsistent UNI-V2 balances"
1766         );
1767     }
1768 
1769     modifier onlyFrozen(address account) {
1770         Require.that(
1771             statusOf(account) == PoolAccount.Status.Frozen,
1772             FILE,
1773             "Not frozen"
1774         );
1775 
1776         _;
1777     }
1778 
1779     modifier onlyDao() {
1780         Require.that(
1781             msg.sender == address(dao()),
1782             FILE,
1783             "Not dao"
1784         );
1785 
1786         _;
1787     }
1788 
1789     modifier notPaused() {
1790         Require.that(
1791             !paused(),
1792             FILE,
1793             "Paused"
1794         );
1795 
1796         _;
1797     }
1798 }