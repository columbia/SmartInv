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
657     Copyright 2020 BullProtocol Devs 
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
931     Copyright 2020 BullProtocol Devs 
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
952     /* Chain */
953     uint256 private constant CHAIN_ID = 1; // Mainnet
954 
955     /* Bootstrapping */
956     uint256 private constant BOOTSTRAPPING_PERIOD = 300; // 300 epochs
957     uint256 private constant BOOTSTRAPPING_PRICE = 130e16;
958 
959     /* Oracle */
960     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
961     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
962 
963     /* Bonding */
964     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 BSD -> 100M BSDS
965 
966     /* Epoch */
967     struct EpochStrategy {
968         uint256 offset;
969         uint256 start;
970         uint256 period;
971     }
972 
973     uint256 private constant EPOCH_OFFSET = 0;
974     uint256 private constant EPOCH_START = 1609261200;
975     uint256 private constant EPOCH_PERIOD = 3600; // 1 hour
976 
977     /* Governance */
978     uint256 private constant GOVERNANCE_PERIOD = 72; // 72 epochs
979     uint256 private constant GOVERNANCE_EXPIRATION = 24; // 24 epochs
980     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
981     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
982     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
983     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 12; // 12 epochs
984 
985     /* DAO */
986     uint256 private constant ADVANCE_INCENTIVE_BELOW_ONE_DOLLAR = 100e18; // 100 BSD for reward if price <=1 USDC
987     uint256 private constant ADVANCE_INCENTIVE_ABOVE_ONE_DOLLAR = 100e6; // 100 USDC convert from BSD price for reward
988     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 72; // 72 epochs fluid
989 
990     /* Pool */
991     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
992 
993     /* Market */
994     uint256 private constant COUPON_EXPIRATION = 720;
995     uint256 private constant DEBT_RATIO_CAP = 15e16; // 15%
996 
997     /* Regulator */
998     uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%
999     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1000     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
1001     uint256 private constant TREASURY_RATIO = 150; // 1.5%
1002 
1003     /* Assets */
1004     address private constant TREASURY_ADDRESS = address(0xB8f2F09adc4fA5c15600BC461a3a3beC2eDFE9b9);
1005 
1006     /**
1007      * Getters
1008      */
1009 
1010     function getUsdcAddress() internal pure returns (address) {
1011         return USDC;
1012     }
1013 
1014     function getOracleReserveMinimum() internal pure returns (uint256) {
1015         return ORACLE_RESERVE_MINIMUM;
1016     }
1017 
1018     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1019         return EpochStrategy({
1020             offset: EPOCH_OFFSET,
1021             start: EPOCH_START,
1022             period: EPOCH_PERIOD
1023         });
1024     }
1025 
1026     function getInitialStakeMultiple() internal pure returns (uint256) {
1027         return INITIAL_STAKE_MULTIPLE;
1028     }
1029 
1030     function getBootstrappingPeriod() internal pure returns (uint256) {
1031         return BOOTSTRAPPING_PERIOD;
1032     }
1033 
1034     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1035         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1036     }
1037 
1038     function getGovernancePeriod() internal pure returns (uint256) {
1039         return GOVERNANCE_PERIOD;
1040     }
1041 
1042     function getGovernanceExpiration() internal pure returns (uint256) {
1043         return GOVERNANCE_EXPIRATION;
1044     }
1045 
1046     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1047         return Decimal.D256({value: GOVERNANCE_QUORUM});
1048     }
1049 
1050     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1051         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1052     }
1053 
1054     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1055         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1056     }
1057 
1058     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1059         return GOVERNANCE_EMERGENCY_DELAY;
1060     }
1061 
1062     function getAdvanceIncentive() internal pure returns (uint256) {
1063         return ADVANCE_INCENTIVE_BELOW_ONE_DOLLAR;
1064     }
1065 
1066     function getAdvanceIncentiveRate() internal pure returns (uint256) {
1067         return ADVANCE_INCENTIVE_ABOVE_ONE_DOLLAR;
1068     }
1069 
1070     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1071         return DAO_EXIT_LOCKUP_EPOCHS;
1072     }
1073 
1074     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1075         return POOL_EXIT_LOCKUP_EPOCHS;
1076     }
1077 
1078     function getCouponExpiration() internal pure returns (uint256) {
1079         return COUPON_EXPIRATION;
1080     }
1081 
1082     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1083         return Decimal.D256({value: DEBT_RATIO_CAP});
1084     }
1085 
1086     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1087         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1088     }
1089 
1090     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1091         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1092     }
1093 
1094     function getOraclePoolRatio() internal pure returns (uint256) {
1095         return ORACLE_POOL_RATIO;
1096     }
1097 
1098     function getTreasuryRatio() internal pure returns (uint256) {
1099         return TREASURY_RATIO;
1100     }
1101 
1102     function getChainId() internal pure returns (uint256) {
1103         return CHAIN_ID;
1104     }
1105 
1106     function getTreasuryAddress() internal pure returns (address) {
1107         return TREASURY_ADDRESS;
1108     }
1109 }
1110 
1111 
1112 // Dependency file: contracts/token/IDollar.sol
1113 
1114 /*
1115     Copyright 2020 BullProtocol Devs 
1116 
1117     Licensed under the Apache License, Version 2.0 (the "License");
1118     you may not use this file except in compliance with the License.
1119     You may obtain a copy of the License at
1120 
1121     http://www.apache.org/licenses/LICENSE-2.0
1122 
1123     Unless required by applicable law or agreed to in writing, software
1124     distributed under the License is distributed on an "AS IS" BASIS,
1125     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1126     See the License for the specific language governing permissions and
1127     limitations under the License.
1128 */
1129 
1130 // pragma solidity ^0.5.17;
1131 
1132 
1133 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1134 
1135 contract IDollar is IERC20 {
1136     function burn(uint256 amount) public;
1137     function burnFrom(address account, uint256 amount) public;
1138     function mint(address account, uint256 amount) public returns (bool);
1139 }
1140 
1141 
1142 // Dependency file: contracts/oracle/IDAO.sol
1143 
1144 /*
1145     Copyright 2020 BullProtocol Devs
1146 
1147     Licensed under the Apache License, Version 2.0 (the "License");
1148     you may not use this file except in compliance with the License.
1149     You may obtain a copy of the License at
1150 
1151     http://www.apache.org/licenses/LICENSE-2.0
1152 
1153     Unless required by applicable law or agreed to in writing, software
1154     distributed under the License is distributed on an "AS IS" BASIS,
1155     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1156     See the License for the specific language governing permissions and
1157     limitations under the License.
1158 */
1159 
1160 // pragma solidity ^0.5.17;
1161 
1162 contract IDAO {
1163     function epoch() external view returns (uint256);
1164 }
1165 
1166 // Dependency file: contracts/oracle/IUSDC.sol
1167 
1168 /*
1169     Copyright 2020 BullProtocol Devs
1170 
1171     Licensed under the Apache License, Version 2.0 (the "License");
1172     you may not use this file except in compliance with the License.
1173     You may obtain a copy of the License at
1174 
1175     http://www.apache.org/licenses/LICENSE-2.0
1176 
1177     Unless required by applicable law or agreed to in writing, software
1178     distributed under the License is distributed on an "AS IS" BASIS,
1179     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1180     See the License for the specific language governing permissions and
1181     limitations under the License.
1182 */
1183 
1184 // pragma solidity ^0.5.17;
1185 
1186 contract IUSDC {
1187     function isBlacklisted(address _account) external view returns (bool);
1188 }
1189 
1190 // Dependency file: contracts/oracle/PoolState.sol
1191 
1192 /*
1193     Copyright 2020 BullProtocol Devs
1194 
1195     Licensed under the Apache License, Version 2.0 (the "License");
1196     you may not use this file except in compliance with the License.
1197     You may obtain a copy of the License at
1198 
1199     http://www.apache.org/licenses/LICENSE-2.0
1200 
1201     Unless required by applicable law or agreed to in writing, software
1202     distributed under the License is distributed on an "AS IS" BASIS,
1203     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1204     See the License for the specific language governing permissions and
1205     limitations under the License.
1206 */
1207 
1208 // pragma solidity ^0.5.17;
1209 
1210 
1211 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1212 // import "contracts/token/IDollar.sol";
1213 // import "contracts/oracle/IDAO.sol";
1214 // import "contracts/oracle/IUSDC.sol";
1215 
1216 contract PoolAccount {
1217     enum Status {
1218         Frozen,
1219         Fluid,
1220         Locked
1221     }
1222 
1223     struct State {
1224         uint256 staged;
1225         uint256 claimable;
1226         uint256 bonded;
1227         uint256 phantom;
1228         uint256 fluidUntil;
1229     }
1230 }
1231 
1232 contract PoolStorage {
1233     struct Provider {
1234         IDAO dao;
1235         IDollar dollar;
1236         IERC20 univ2;
1237     }
1238     
1239     struct Balance {
1240         uint256 staged;
1241         uint256 claimable;
1242         uint256 bonded;
1243         uint256 phantom;
1244     }
1245 
1246     struct State {
1247         Balance balance;
1248         Provider provider;
1249 
1250         bool paused;
1251 
1252         mapping(address => PoolAccount.State) accounts;
1253     }
1254 }
1255 
1256 contract PoolState {
1257     PoolStorage.State _state;
1258 }
1259 
1260 
1261 // Dependency file: contracts/oracle/PoolGetters.sol
1262 
1263 /*
1264     Copyright 2020 BullProtocol Devs
1265 
1266     Licensed under the Apache License, Version 2.0 (the "License");
1267     you may not use this file except in compliance with the License.
1268     You may obtain a copy of the License at
1269 
1270     http://www.apache.org/licenses/LICENSE-2.0
1271 
1272     Unless required by applicable law or agreed to in writing, software
1273     distributed under the License is distributed on an "AS IS" BASIS,
1274     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1275     See the License for the specific language governing permissions and
1276     limitations under the License.
1277 */
1278 
1279 // pragma solidity ^0.5.17;
1280 
1281 
1282 // import "@openzeppelin/contracts/math/SafeMath.sol";
1283 // import "contracts/oracle/PoolState.sol";
1284 // import "contracts/Constants.sol";
1285 
1286 contract PoolGetters is PoolState {
1287     using SafeMath for uint256;
1288 
1289     /**
1290      * Global
1291      */
1292 
1293     function usdc() public view returns (address) {
1294         return Constants.getUsdcAddress();
1295     }
1296 
1297     function dao() public view returns (IDAO) {
1298         return _state.provider.dao;
1299     }
1300 
1301     function dollar() public view returns (IDollar) {
1302         return _state.provider.dollar;
1303     }
1304 
1305     function univ2() public view returns (IERC20) {
1306         return _state.provider.univ2;
1307     }
1308 
1309     function totalBonded() public view returns (uint256) {
1310         return _state.balance.bonded;
1311     }
1312 
1313     function totalStaged() public view returns (uint256) {
1314         return _state.balance.staged;
1315     }
1316 
1317     function totalClaimable() public view returns (uint256) {
1318         return _state.balance.claimable;
1319     }
1320 
1321     function totalPhantom() public view returns (uint256) {
1322         return _state.balance.phantom;
1323     }
1324 
1325     function totalRewarded() public view returns (uint256) {
1326         return dollar().balanceOf(address(this)).sub(totalClaimable());
1327     }
1328 
1329     function paused() public view returns (bool) {
1330         return _state.paused;
1331     }
1332 
1333     /**
1334      * Account
1335      */
1336 
1337     function balanceOfStaged(address account) public view returns (uint256) {
1338         return _state.accounts[account].staged;
1339     }
1340 
1341     function balanceOfClaimable(address account) public view returns (uint256) {
1342         return _state.accounts[account].claimable;
1343     }
1344 
1345     function balanceOfBonded(address account) public view returns (uint256) {
1346         return _state.accounts[account].bonded;
1347     }
1348 
1349     function balanceOfPhantom(address account) public view returns (uint256) {
1350         return _state.accounts[account].phantom;
1351     }
1352 
1353     function balanceOfRewarded(address account) public view returns (uint256) {
1354         uint256 totalBonded = totalBonded();
1355         if (totalBonded == 0) {
1356             return 0;
1357         }
1358 
1359         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1360         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1361             .mul(balanceOfBonded(account))
1362             .div(totalBonded);
1363 
1364         uint256 balanceOfPhantom = balanceOfPhantom(account);
1365         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1366             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1367         }
1368         return 0;
1369     }
1370 
1371     function statusOf(address account) public view returns (PoolAccount.Status) {
1372         return epoch() >= _state.accounts[account].fluidUntil ?
1373             PoolAccount.Status.Frozen :
1374             PoolAccount.Status.Fluid;
1375     }
1376 
1377     /**
1378      * Epoch
1379      */
1380 
1381     function epoch() internal view returns (uint256) {
1382         return dao().epoch();
1383     }
1384 }
1385 
1386 
1387 // Dependency file: contracts/oracle/PoolSetters.sol
1388 
1389 /*
1390     Copyright 2020 BullProtocol Devs
1391 
1392     Licensed under the Apache License, Version 2.0 (the "License");
1393     you may not use this file except in compliance with the License.
1394     You may obtain a copy of the License at
1395 
1396     http://www.apache.org/licenses/LICENSE-2.0
1397 
1398     Unless required by applicable law or agreed to in writing, software
1399     distributed under the License is distributed on an "AS IS" BASIS,
1400     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1401     See the License for the specific language governing permissions and
1402     limitations under the License.
1403 */
1404 
1405 // pragma solidity ^0.5.17;
1406 
1407 
1408 // import "@openzeppelin/contracts/math/SafeMath.sol";
1409 // import "contracts/oracle/PoolState.sol";
1410 // import "contracts/oracle/PoolGetters.sol";
1411 
1412 contract PoolSetters is PoolState, PoolGetters {
1413     using SafeMath for uint256;
1414 
1415     /**
1416      * Global
1417      */
1418 
1419     function pause() internal {
1420         _state.paused = true;
1421     }
1422 
1423     /**
1424      * Account
1425      */
1426 
1427     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1428         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1429         _state.balance.bonded = _state.balance.bonded.add(amount);
1430     }
1431 
1432     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1433         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1434         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1435     }
1436 
1437     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1438         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1439         _state.balance.staged = _state.balance.staged.add(amount);
1440     }
1441 
1442     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1443         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1444         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1445     }
1446 
1447     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1448         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1449         _state.balance.claimable = _state.balance.claimable.add(amount);
1450     }
1451 
1452     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1453         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1454         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1455     }
1456 
1457     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1458         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1459         _state.balance.phantom = _state.balance.phantom.add(amount);
1460     }
1461 
1462     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1463         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1464         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1465     }
1466 
1467     function unfreeze(address account) internal {
1468         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1469     }
1470 }
1471 
1472 
1473 // Dependency file: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1474 
1475 // pragma solidity >=0.5.0;
1476 
1477 interface IUniswapV2Pair {
1478     event Approval(address indexed owner, address indexed spender, uint value);
1479     event Transfer(address indexed from, address indexed to, uint value);
1480 
1481     function name() external pure returns (string memory);
1482     function symbol() external pure returns (string memory);
1483     function decimals() external pure returns (uint8);
1484     function totalSupply() external view returns (uint);
1485     function balanceOf(address owner) external view returns (uint);
1486     function allowance(address owner, address spender) external view returns (uint);
1487 
1488     function approve(address spender, uint value) external returns (bool);
1489     function transfer(address to, uint value) external returns (bool);
1490     function transferFrom(address from, address to, uint value) external returns (bool);
1491 
1492     function DOMAIN_SEPARATOR() external view returns (bytes32);
1493     function PERMIT_TYPEHASH() external pure returns (bytes32);
1494     function nonces(address owner) external view returns (uint);
1495 
1496     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1497 
1498     event Mint(address indexed sender, uint amount0, uint amount1);
1499     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1500     event Swap(
1501         address indexed sender,
1502         uint amount0In,
1503         uint amount1In,
1504         uint amount0Out,
1505         uint amount1Out,
1506         address indexed to
1507     );
1508     event Sync(uint112 reserve0, uint112 reserve1);
1509 
1510     function MINIMUM_LIQUIDITY() external pure returns (uint);
1511     function factory() external view returns (address);
1512     function token0() external view returns (address);
1513     function token1() external view returns (address);
1514     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1515     function price0CumulativeLast() external view returns (uint);
1516     function price1CumulativeLast() external view returns (uint);
1517     function kLast() external view returns (uint);
1518 
1519     function mint(address to) external returns (uint liquidity);
1520     function burn(address to) external returns (uint amount0, uint amount1);
1521     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1522     function skim(address to) external;
1523     function sync() external;
1524 
1525     function initialize(address, address) external;
1526 }
1527 
1528 
1529 // Dependency file: contracts/external/UniswapV2Library.sol
1530 
1531 // pragma solidity >=0.5.0;
1532 
1533 // import "@openzeppelin/contracts/math/SafeMath.sol";
1534 // import '/Users/khuyen/Documents/ProjectSecret/bsd/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
1535 
1536 library UniswapV2Library {
1537     using SafeMath for uint;
1538 
1539     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1540     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1541         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1542         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1543         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1544     }
1545 
1546     // calculates the CREATE2 address for a pair without making any external calls
1547     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1548         (address token0, address token1) = sortTokens(tokenA, tokenB);
1549         pair = address(uint(keccak256(abi.encodePacked(
1550                 hex'ff',
1551                 factory,
1552                 keccak256(abi.encodePacked(token0, token1)),
1553                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1554             ))));
1555     }
1556 
1557     // fetches and sorts the reserves for a pair
1558     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1559         (address token0,) = sortTokens(tokenA, tokenB);
1560         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1561         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1562     }
1563 
1564     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1565     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1566         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1567         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1568         amountB = amountA.mul(reserveB) / reserveA;
1569     }
1570 }
1571 
1572 // Dependency file: contracts/oracle/Liquidity.sol
1573 
1574 /*
1575     Copyright 2020 BullProtocol Devs
1576 
1577     Licensed under the Apache License, Version 2.0 (the "License");
1578     you may not use this file except in compliance with the License.
1579     You may obtain a copy of the License at
1580 
1581     http://www.apache.org/licenses/LICENSE-2.0
1582 
1583     Unless required by applicable law or agreed to in writing, software
1584     distributed under the License is distributed on an "AS IS" BASIS,
1585     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1586     See the License for the specific language governing permissions and
1587     limitations under the License.
1588 */
1589 
1590 // pragma solidity ^0.5.17;
1591 
1592 
1593 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1594 // import '/Users/khuyen/Documents/ProjectSecret/bsd/node_modules/@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
1595 // import 'contracts/external/UniswapV2Library.sol';
1596 // import "contracts/Constants.sol";
1597 // import "contracts/oracle/PoolGetters.sol";
1598 
1599 contract Liquidity is PoolGetters {
1600     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1601 
1602     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1603         (address dollar, address usdc) = (address(dollar()), usdc());
1604         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1605 
1606         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1607              dollarAmount :
1608              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1609 
1610         address pair = address(univ2());
1611         IERC20(dollar).transfer(pair, dollarAmount);
1612         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1613         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1614     }
1615 
1616     // overridable for testing
1617     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1618         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1619         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1620         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1621     }
1622 }
1623 
1624 
1625 // Root file: contracts/oracle/Pool.sol
1626 
1627 /*
1628     Copyright 2020 BullProtocol Devs
1629 
1630     Licensed under the Apache License, Version 2.0 (the "License");
1631     you may not use this file except in compliance with the License.
1632     You may obtain a copy of the License at
1633 
1634     http://www.apache.org/licenses/LICENSE-2.0
1635 
1636     Unless required by applicable law or agreed to in writing, software
1637     distributed under the License is distributed on an "AS IS" BASIS,
1638     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1639     See the License for the specific language governing permissions and
1640     limitations under the License.
1641 */
1642 
1643 pragma solidity ^0.5.17;
1644 
1645 
1646 // import "@openzeppelin/contracts/math/SafeMath.sol";
1647 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1648 // import "contracts/external/Require.sol";
1649 // import "contracts/Constants.sol";
1650 // import "contracts/oracle/PoolSetters.sol";
1651 // import "contracts/oracle/Liquidity.sol";
1652 
1653 contract Pool is PoolSetters, Liquidity {
1654     using SafeMath for uint256;
1655 
1656     constructor(address dollar, address univ2) public {
1657         _state.provider.dao = IDAO(msg.sender);
1658         _state.provider.dollar = IDollar(dollar);
1659         _state.provider.univ2 = IERC20(univ2);
1660     }
1661 
1662     bytes32 private constant FILE = "Pool";
1663 
1664     event Deposit(address indexed account, uint256 value);
1665     event Withdraw(address indexed account, uint256 value);
1666     event Claim(address indexed account, uint256 value);
1667     event Bond(address indexed account, uint256 start, uint256 value);
1668     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1669     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1670 
1671     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1672         univ2().transferFrom(msg.sender, address(this), value);
1673         incrementBalanceOfStaged(msg.sender, value);
1674 
1675         balanceCheck();
1676 
1677         emit Deposit(msg.sender, value);
1678     }
1679 
1680     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1681         univ2().transfer(msg.sender, value);
1682         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1683 
1684         balanceCheck();
1685 
1686         emit Withdraw(msg.sender, value);
1687     }
1688 
1689     function claim(uint256 value) external onlyFrozen(msg.sender) {
1690         dollar().transfer(msg.sender, value);
1691         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1692 
1693         balanceCheck();
1694 
1695         emit Claim(msg.sender, value);
1696     }
1697 
1698     function bond(uint256 value) external notPaused {
1699         unfreeze(msg.sender);
1700 
1701         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1702         uint256 newPhantom = totalBonded() == 0 ?
1703             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1704             totalRewardedWithPhantom.mul(value).div(totalBonded());
1705 
1706         incrementBalanceOfBonded(msg.sender, value);
1707         incrementBalanceOfPhantom(msg.sender, newPhantom);
1708         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1709 
1710         balanceCheck();
1711 
1712         emit Bond(msg.sender, epoch().add(1), value);
1713     }
1714 
1715     function unbond(uint256 value) external {
1716         unfreeze(msg.sender);
1717 
1718         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1719         Require.that(
1720             balanceOfBonded > 0,
1721             FILE,
1722             "insufficient bonded balance"
1723         );
1724 
1725         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1726         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1727 
1728         incrementBalanceOfStaged(msg.sender, value);
1729         incrementBalanceOfClaimable(msg.sender, newClaimable);
1730         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1731         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1732 
1733         balanceCheck();
1734 
1735         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1736     }
1737 
1738     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1739         Require.that(
1740             totalBonded() > 0,
1741             FILE,
1742             "insufficient total bonded"
1743         );
1744 
1745         Require.that(
1746             totalRewarded() > 0,
1747             FILE,
1748             "insufficient total rewarded"
1749         );
1750 
1751         Require.that(
1752             balanceOfRewarded(msg.sender) >= value,
1753             FILE,
1754             "insufficient rewarded balance"
1755         );
1756 
1757         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1758 
1759         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1760         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1761 
1762         incrementBalanceOfBonded(msg.sender, newUniv2);
1763         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1764 
1765 
1766         balanceCheck();
1767 
1768         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1769     }
1770 
1771     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1772         IERC20(token).transfer(address(dao()), value);
1773     }
1774 
1775     function emergencyPause() external onlyDao {
1776         pause();
1777     }
1778 
1779     function balanceCheck() private {
1780         Require.that(
1781             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1782             FILE,
1783             "Inconsistent UNI-V2 balances"
1784         );
1785     }
1786 
1787     modifier onlyFrozen(address account) {
1788         Require.that(
1789             statusOf(account) == PoolAccount.Status.Frozen,
1790             FILE,
1791             "Not frozen"
1792         );
1793 
1794         _;
1795     }
1796 
1797     modifier onlyDao() {
1798         Require.that(
1799             msg.sender == address(dao()),
1800             FILE,
1801             "Not dao"
1802         );
1803 
1804         _;
1805     }
1806 
1807     modifier notPaused() {
1808         Require.that(
1809             !paused(),
1810             FILE,
1811             "Paused"
1812         );
1813 
1814         _;
1815     }
1816 }