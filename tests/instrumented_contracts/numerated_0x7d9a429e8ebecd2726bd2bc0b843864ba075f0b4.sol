1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
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
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
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
257 pragma solidity ^0.5.7;
258 
259 /**
260  * @title Require
261  * @author dYdX
262  *
263  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
264  */
265 library Require {
266 
267     // ============ Constants ============
268 
269     uint256 constant ASCII_ZERO = 48; // '0'
270     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
271     uint256 constant ASCII_LOWER_EX = 120; // 'x'
272     bytes2 constant COLON = 0x3a20; // ': '
273     bytes2 constant COMMA = 0x2c20; // ', '
274     bytes2 constant LPAREN = 0x203c; // ' <'
275     byte constant RPAREN = 0x3e; // '>'
276     uint256 constant FOUR_BIT_MASK = 0xf;
277 
278     // ============ Library Functions ============
279 
280     function that(
281         bool must,
282         bytes32 file,
283         bytes32 reason
284     )
285     internal
286     pure
287     {
288         if (!must) {
289             revert(
290                 string(
291                     abi.encodePacked(
292                         stringifyTruncated(file),
293                         COLON,
294                         stringifyTruncated(reason)
295                     )
296                 )
297             );
298         }
299     }
300 
301     function that(
302         bool must,
303         bytes32 file,
304         bytes32 reason,
305         uint256 payloadA
306     )
307     internal
308     pure
309     {
310         if (!must) {
311             revert(
312                 string(
313                     abi.encodePacked(
314                         stringifyTruncated(file),
315                         COLON,
316                         stringifyTruncated(reason),
317                         LPAREN,
318                         stringify(payloadA),
319                         RPAREN
320                     )
321                 )
322             );
323         }
324     }
325 
326     function that(
327         bool must,
328         bytes32 file,
329         bytes32 reason,
330         uint256 payloadA,
331         uint256 payloadB
332     )
333     internal
334     pure
335     {
336         if (!must) {
337             revert(
338                 string(
339                     abi.encodePacked(
340                         stringifyTruncated(file),
341                         COLON,
342                         stringifyTruncated(reason),
343                         LPAREN,
344                         stringify(payloadA),
345                         COMMA,
346                         stringify(payloadB),
347                         RPAREN
348                     )
349                 )
350             );
351         }
352     }
353 
354     function that(
355         bool must,
356         bytes32 file,
357         bytes32 reason,
358         address payloadA
359     )
360     internal
361     pure
362     {
363         if (!must) {
364             revert(
365                 string(
366                     abi.encodePacked(
367                         stringifyTruncated(file),
368                         COLON,
369                         stringifyTruncated(reason),
370                         LPAREN,
371                         stringify(payloadA),
372                         RPAREN
373                     )
374                 )
375             );
376         }
377     }
378 
379     function that(
380         bool must,
381         bytes32 file,
382         bytes32 reason,
383         address payloadA,
384         uint256 payloadB
385     )
386     internal
387     pure
388     {
389         if (!must) {
390             revert(
391                 string(
392                     abi.encodePacked(
393                         stringifyTruncated(file),
394                         COLON,
395                         stringifyTruncated(reason),
396                         LPAREN,
397                         stringify(payloadA),
398                         COMMA,
399                         stringify(payloadB),
400                         RPAREN
401                     )
402                 )
403             );
404         }
405     }
406 
407     function that(
408         bool must,
409         bytes32 file,
410         bytes32 reason,
411         address payloadA,
412         uint256 payloadB,
413         uint256 payloadC
414     )
415     internal
416     pure
417     {
418         if (!must) {
419             revert(
420                 string(
421                     abi.encodePacked(
422                         stringifyTruncated(file),
423                         COLON,
424                         stringifyTruncated(reason),
425                         LPAREN,
426                         stringify(payloadA),
427                         COMMA,
428                         stringify(payloadB),
429                         COMMA,
430                         stringify(payloadC),
431                         RPAREN
432                     )
433                 )
434             );
435         }
436     }
437 
438     function that(
439         bool must,
440         bytes32 file,
441         bytes32 reason,
442         bytes32 payloadA
443     )
444     internal
445     pure
446     {
447         if (!must) {
448             revert(
449                 string(
450                     abi.encodePacked(
451                         stringifyTruncated(file),
452                         COLON,
453                         stringifyTruncated(reason),
454                         LPAREN,
455                         stringify(payloadA),
456                         RPAREN
457                     )
458                 )
459             );
460         }
461     }
462 
463     function that(
464         bool must,
465         bytes32 file,
466         bytes32 reason,
467         bytes32 payloadA,
468         uint256 payloadB,
469         uint256 payloadC
470     )
471     internal
472     pure
473     {
474         if (!must) {
475             revert(
476                 string(
477                     abi.encodePacked(
478                         stringifyTruncated(file),
479                         COLON,
480                         stringifyTruncated(reason),
481                         LPAREN,
482                         stringify(payloadA),
483                         COMMA,
484                         stringify(payloadB),
485                         COMMA,
486                         stringify(payloadC),
487                         RPAREN
488                     )
489                 )
490             );
491         }
492     }
493 
494     // ============ Private Functions ============
495 
496     function stringifyTruncated(
497         bytes32 input
498     )
499     private
500     pure
501     returns (bytes memory)
502     {
503         // put the input bytes into the result
504         bytes memory result = abi.encodePacked(input);
505 
506         // determine the length of the input by finding the location of the last non-zero byte
507         for (uint256 i = 32; i > 0; ) {
508             // reverse-for-loops with unsigned integer
509             /* solium-disable-next-line security/no-modify-for-iter-var */
510             i--;
511 
512             // find the last non-zero byte in order to determine the length
513             if (result[i] != 0) {
514                 uint256 length = i + 1;
515 
516                 /* solium-disable-next-line security/no-inline-assembly */
517                 assembly {
518                     mstore(result, length) // r.length = length;
519                 }
520 
521                 return result;
522             }
523         }
524 
525         // all bytes are zero
526         return new bytes(0);
527     }
528 
529     function stringify(
530         uint256 input
531     )
532     private
533     pure
534     returns (bytes memory)
535     {
536         if (input == 0) {
537             return "0";
538         }
539 
540         // get the final string length
541         uint256 j = input;
542         uint256 length;
543         while (j != 0) {
544             length++;
545             j /= 10;
546         }
547 
548         // allocate the string
549         bytes memory bstr = new bytes(length);
550 
551         // populate the string starting with the least-significant character
552         j = input;
553         for (uint256 i = length; i > 0; ) {
554             // reverse-for-loops with unsigned integer
555             /* solium-disable-next-line security/no-modify-for-iter-var */
556             i--;
557 
558             // take last decimal digit
559             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
560 
561             // remove the last decimal digit
562             j /= 10;
563         }
564 
565         return bstr;
566     }
567 
568     function stringify(
569         address input
570     )
571     private
572     pure
573     returns (bytes memory)
574     {
575         uint256 z = uint256(input);
576 
577         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
578         bytes memory result = new bytes(42);
579 
580         // populate the result with "0x"
581         result[0] = byte(uint8(ASCII_ZERO));
582         result[1] = byte(uint8(ASCII_LOWER_EX));
583 
584         // for each byte (starting from the lowest byte), populate the result with two characters
585         for (uint256 i = 0; i < 20; i++) {
586             // each byte takes two characters
587             uint256 shift = i * 2;
588 
589             // populate the least-significant character
590             result[41 - shift] = char(z & FOUR_BIT_MASK);
591             z = z >> 4;
592 
593             // populate the most-significant character
594             result[40 - shift] = char(z & FOUR_BIT_MASK);
595             z = z >> 4;
596         }
597 
598         return result;
599     }
600 
601     function stringify(
602         bytes32 input
603     )
604     private
605     pure
606     returns (bytes memory)
607     {
608         uint256 z = uint256(input);
609 
610         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
611         bytes memory result = new bytes(66);
612 
613         // populate the result with "0x"
614         result[0] = byte(uint8(ASCII_ZERO));
615         result[1] = byte(uint8(ASCII_LOWER_EX));
616 
617         // for each byte (starting from the lowest byte), populate the result with two characters
618         for (uint256 i = 0; i < 32; i++) {
619             // each byte takes two characters
620             uint256 shift = i * 2;
621 
622             // populate the least-significant character
623             result[65 - shift] = char(z & FOUR_BIT_MASK);
624             z = z >> 4;
625 
626             // populate the most-significant character
627             result[64 - shift] = char(z & FOUR_BIT_MASK);
628             z = z >> 4;
629         }
630 
631         return result;
632     }
633 
634     function char(
635         uint256 input
636     )
637     private
638     pure
639     returns (byte)
640     {
641         // return ASCII digit (0-9)
642         if (input < 10) {
643             return byte(uint8(input + ASCII_ZERO));
644         }
645 
646         // return ASCII letter (a-f)
647         return byte(uint8(input + ASCII_RELATIVE_ZERO));
648     }
649 }
650 
651 // File: contracts/external/Decimal.sol
652 
653 /*
654     Copyright 2019 dYdX Trading Inc.
655     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
656 
657     Licensed under the Apache License, Version 2.0 (the "License");
658     you may not use this file except in compliance with the License.
659     You may obtain a copy of the License at
660 
661     http://www.apache.org/licenses/LICENSE-2.0
662 
663     Unless required by applicable law or agreed to in writing, software
664     distributed under the License is distributed on an "AS IS" BASIS,
665     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
666     See the License for the specific language governing permissions and
667     limitations under the License.
668 */
669 
670 pragma solidity ^0.5.7;
671 
672 
673 /**
674  * @title Decimal
675  * @author dYdX
676  *
677  * Library that defines a fixed-point number with 18 decimal places.
678  */
679 library Decimal {
680     using SafeMath for uint256;
681 
682     // ============ Constants ============
683 
684     uint256 constant BASE = 10**18;
685 
686     // ============ Structs ============
687 
688 
689     struct D256 {
690         uint256 value;
691     }
692 
693     // ============ Static Functions ============
694 
695     function zero()
696     internal
697     pure
698     returns (D256 memory)
699     {
700         return D256({ value: 0 });
701     }
702 
703     function one()
704     internal
705     pure
706     returns (D256 memory)
707     {
708         return D256({ value: BASE });
709     }
710 
711     function from(
712         uint256 a
713     )
714     internal
715     pure
716     returns (D256 memory)
717     {
718         return D256({ value: a.mul(BASE) });
719     }
720 
721     function ratio(
722         uint256 a,
723         uint256 b
724     )
725     internal
726     pure
727     returns (D256 memory)
728     {
729         return D256({ value: getPartial(a, BASE, b) });
730     }
731 
732     // ============ Self Functions ============
733 
734     function add(
735         D256 memory self,
736         uint256 b
737     )
738     internal
739     pure
740     returns (D256 memory)
741     {
742         return D256({ value: self.value.add(b.mul(BASE)) });
743     }
744 
745     function sub(
746         D256 memory self,
747         uint256 b
748     )
749     internal
750     pure
751     returns (D256 memory)
752     {
753         return D256({ value: self.value.sub(b.mul(BASE)) });
754     }
755 
756     function sub(
757         D256 memory self,
758         uint256 b,
759         string memory reason
760     )
761     internal
762     pure
763     returns (D256 memory)
764     {
765         return D256({ value: self.value.sub(b.mul(BASE), reason) });
766     }
767 
768     function mul(
769         D256 memory self,
770         uint256 b
771     )
772     internal
773     pure
774     returns (D256 memory)
775     {
776         return D256({ value: self.value.mul(b) });
777     }
778 
779     function div(
780         D256 memory self,
781         uint256 b
782     )
783     internal
784     pure
785     returns (D256 memory)
786     {
787         return D256({ value: self.value.div(b) });
788     }
789 
790     function pow(
791         D256 memory self,
792         uint256 b
793     )
794     internal
795     pure
796     returns (D256 memory)
797     {
798         if (b == 0) {
799             return from(1);
800         }
801 
802         D256 memory temp = D256({ value: self.value });
803         for (uint256 i = 1; i < b; i++) {
804             temp = mul(temp, self);
805         }
806 
807         return temp;
808     }
809 
810     function add(
811         D256 memory self,
812         D256 memory b
813     )
814     internal
815     pure
816     returns (D256 memory)
817     {
818         return D256({ value: self.value.add(b.value) });
819     }
820 
821     function sub(
822         D256 memory self,
823         D256 memory b
824     )
825     internal
826     pure
827     returns (D256 memory)
828     {
829         return D256({ value: self.value.sub(b.value) });
830     }
831 
832     function sub(
833         D256 memory self,
834         D256 memory b,
835         string memory reason
836     )
837     internal
838     pure
839     returns (D256 memory)
840     {
841         return D256({ value: self.value.sub(b.value, reason) });
842     }
843 
844     function mul(
845         D256 memory self,
846         D256 memory b
847     )
848     internal
849     pure
850     returns (D256 memory)
851     {
852         return D256({ value: getPartial(self.value, b.value, BASE) });
853     }
854 
855     function div(
856         D256 memory self,
857         D256 memory b
858     )
859     internal
860     pure
861     returns (D256 memory)
862     {
863         return D256({ value: getPartial(self.value, BASE, b.value) });
864     }
865 
866     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
867         return self.value == b.value;
868     }
869 
870     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
871         return compareTo(self, b) == 2;
872     }
873 
874     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
875         return compareTo(self, b) == 0;
876     }
877 
878     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
879         return compareTo(self, b) > 0;
880     }
881 
882     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
883         return compareTo(self, b) < 2;
884     }
885 
886     function isZero(D256 memory self) internal pure returns (bool) {
887         return self.value == 0;
888     }
889 
890     function asUint256(D256 memory self) internal pure returns (uint256) {
891         return self.value.div(BASE);
892     }
893 
894     // ============ Core Methods ============
895 
896     function getPartial(
897         uint256 target,
898         uint256 numerator,
899         uint256 denominator
900     )
901     private
902     pure
903     returns (uint256)
904     {
905         return target.mul(numerator).div(denominator);
906     }
907 
908     function compareTo(
909         D256 memory a,
910         D256 memory b
911     )
912     private
913     pure
914     returns (uint256)
915     {
916         if (a.value == b.value) {
917             return 1;
918         }
919         return a.value > b.value ? 2 : 0;
920     }
921 }
922 
923 // File: contracts/Constants.sol
924 
925 /*
926     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
927 
928     Licensed under the Apache License, Version 2.0 (the "License");
929     you may not use this file except in compliance with the License.
930     You may obtain a copy of the License at
931 
932     http://www.apache.org/licenses/LICENSE-2.0
933 
934     Unless required by applicable law or agreed to in writing, software
935     distributed under the License is distributed on an "AS IS" BASIS,
936     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
937     See the License for the specific language governing permissions and
938     limitations under the License.
939 */
940 
941 pragma solidity ^0.5.17;
942 
943 
944 library Constants {
945     /* Chain */
946     uint256 private constant CHAIN_ID = 1; // Mainnet
947 
948     /* Bootstrapping */
949     uint256 private constant TARGET_SUPPLY = 25e24; // 25M DAIQ
950     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 DAI (targeting 4.5% inflation)
951 
952     /* Oracle */
953     address private constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
954     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 DAI
955 
956     /* Bonding */
957     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 DAIQ -> 100M DAIQS
958 
959     /* Epoch */
960     struct EpochStrategy {
961         uint256 offset;
962         uint256 minPeriod;
963         uint256 maxPeriod;
964     }
965 
966     uint256 private constant EPOCH_OFFSET = 86400; //1 day
967     uint256 private constant EPOCH_MIN_PERIOD = 1800; //30 minutes
968     uint256 private constant EPOCH_MAX_PERIOD = 7200; //2 hours
969 
970     /* Governance */
971     uint256 private constant GOVERNANCE_PERIOD = 21;
972     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
973     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
974     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
975 
976     /* DAO */
977     uint256 private constant DAI_ADVANCE_INCENTIVE_CAP = 150e18; //150 DAI
978     uint256 private constant ADVANCE_INCENTIVE = 100e18; // 100 DAIQ
979     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
980 
981     /* Pool */
982     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 12; // 12 epochs fluid
983 
984     /* Market */
985     uint256 private constant COUPON_EXPIRATION = 360;
986     uint256 private constant DEBT_RATIO_CAP = 40e16; // 40%
987     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
988 
989     /* Regulator */
990     uint256 private constant SUPPLY_CHANGE_DIVISOR = 12e18; // 12
991     uint256 private constant SUPPLY_CHANGE_LIMIT = 10e16; // 10%
992     uint256 private constant ORACLE_POOL_RATIO = 60; // 60%
993 
994     /**
995      * Getters
996      */
997     function getDAIAddress() internal pure returns (address) {
998         return DAI;
999     }
1000 
1001     function getOracleReserveMinimum() internal pure returns (uint256) {
1002         return ORACLE_RESERVE_MINIMUM;
1003     }
1004 
1005     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1006         return EpochStrategy({
1007             offset: EPOCH_OFFSET,
1008             minPeriod: EPOCH_MIN_PERIOD,
1009             maxPeriod: EPOCH_MAX_PERIOD
1010         });
1011     }
1012 
1013     function getInitialStakeMultiple() internal pure returns (uint256) {
1014         return INITIAL_STAKE_MULTIPLE;
1015     }
1016 
1017     function getBootstrappingTarget() internal pure returns (Decimal.D256 memory) {
1018         return Decimal.from(TARGET_SUPPLY);
1019     }
1020 
1021     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1022         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1023     }
1024 
1025     function getGovernancePeriod() internal pure returns (uint256) {
1026         return GOVERNANCE_PERIOD;
1027     }
1028 
1029     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1030         return Decimal.D256({value: GOVERNANCE_QUORUM});
1031     }
1032 
1033     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1034         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1035     }
1036 
1037     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1038         return GOVERNANCE_EMERGENCY_DELAY;
1039     }
1040 
1041     function getAdvanceIncentive() internal pure returns (uint256) {
1042         return ADVANCE_INCENTIVE;
1043     }
1044 
1045     function getDaiAdvanceIncentiveCap() internal pure returns (uint256) {
1046         return DAI_ADVANCE_INCENTIVE_CAP;
1047     }
1048 
1049     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1050         return DAO_EXIT_LOCKUP_EPOCHS;
1051     }
1052 
1053     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1054         return POOL_EXIT_LOCKUP_EPOCHS;
1055     }
1056 
1057     function getCouponExpiration() internal pure returns (uint256) {
1058         return COUPON_EXPIRATION;
1059     }
1060 
1061     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1062         return Decimal.D256({value: DEBT_RATIO_CAP});
1063     }
1064 
1065     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1066         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1067     }
1068 
1069     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1070         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1071     }
1072 
1073     function getSupplyChangeDivisor() internal pure returns (Decimal.D256 memory) {
1074         return Decimal.D256({value: SUPPLY_CHANGE_DIVISOR});
1075     }
1076 
1077     function getOraclePoolRatio() internal pure returns (uint256) {
1078         return ORACLE_POOL_RATIO;
1079     }
1080 
1081     function getChainId() internal pure returns (uint256) {
1082         return CHAIN_ID;
1083     }
1084 }
1085 
1086 // File: contracts/token/IDollar.sol
1087 
1088 /*
1089     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1090 
1091     Licensed under the Apache License, Version 2.0 (the "License");
1092     you may not use this file except in compliance with the License.
1093     You may obtain a copy of the License at
1094 
1095     http://www.apache.org/licenses/LICENSE-2.0
1096 
1097     Unless required by applicable law or agreed to in writing, software
1098     distributed under the License is distributed on an "AS IS" BASIS,
1099     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1100     See the License for the specific language governing permissions and
1101     limitations under the License.
1102 */
1103 
1104 pragma solidity ^0.5.17;
1105 
1106 
1107 contract IDollar is IERC20 {
1108     function burn(uint256 amount) public;
1109     function burnFrom(address account, uint256 amount) public;
1110     function mint(address account, uint256 amount) public returns (bool);
1111 }
1112 
1113 // File: contracts/oracle/IDAO.sol
1114 
1115 /*
1116     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1117 
1118     Licensed under the Apache License, Version 2.0 (the "License");
1119     you may not use this file except in compliance with the License.
1120     You may obtain a copy of the License at
1121 
1122     http://www.apache.org/licenses/LICENSE-2.0
1123 
1124     Unless required by applicable law or agreed to in writing, software
1125     distributed under the License is distributed on an "AS IS" BASIS,
1126     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1127     See the License for the specific language governing permissions and
1128     limitations under the License.
1129 */
1130 
1131 pragma solidity ^0.5.17;
1132 
1133 contract IDAO {
1134     function epoch() external view returns (uint256);
1135 }
1136 
1137 // File: contracts/oracle/PoolState.sol
1138 
1139 /*
1140     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1141 
1142     Licensed under the Apache License, Version 2.0 (the "License");
1143     you may not use this file except in compliance with the License.
1144     You may obtain a copy of the License at
1145 
1146     http://www.apache.org/licenses/LICENSE-2.0
1147 
1148     Unless required by applicable law or agreed to in writing, software
1149     distributed under the License is distributed on an "AS IS" BASIS,
1150     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1151     See the License for the specific language governing permissions and
1152     limitations under the License.
1153 */
1154 
1155 pragma solidity ^0.5.17;
1156 
1157 
1158 
1159 
1160 contract PoolAccount {
1161     enum Status {
1162         Frozen,
1163         Fluid,
1164         Locked
1165     }
1166 
1167     struct State {
1168         uint256 staged;
1169         uint256 claimable;
1170         uint256 bonded;
1171         uint256 phantom;
1172         uint256 fluidUntil;
1173     }
1174 }
1175 
1176 contract PoolStorage {
1177     struct Provider {
1178         IDAO dao;
1179         IDollar dollar;
1180         IERC20 univ2;
1181     }
1182 
1183     struct Balance {
1184         uint256 staged;
1185         uint256 claimable;
1186         uint256 bonded;
1187         uint256 phantom;
1188     }
1189 
1190     struct State {
1191         Balance balance;
1192         Provider provider;
1193 
1194         bool paused;
1195 
1196         mapping(address => PoolAccount.State) accounts;
1197     }
1198 }
1199 
1200 contract PoolState {
1201     PoolStorage.State _state;
1202 }
1203 
1204 // File: contracts/oracle/PoolGetters.sol
1205 
1206 /*
1207     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1208 
1209     Licensed under the Apache License, Version 2.0 (the "License");
1210     you may not use this file except in compliance with the License.
1211     You may obtain a copy of the License at
1212 
1213     http://www.apache.org/licenses/LICENSE-2.0
1214 
1215     Unless required by applicable law or agreed to in writing, software
1216     distributed under the License is distributed on an "AS IS" BASIS,
1217     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1218     See the License for the specific language governing permissions and
1219     limitations under the License.
1220 */
1221 
1222 pragma solidity ^0.5.17;
1223 
1224 
1225 
1226 
1227 contract PoolGetters is PoolState {
1228     using SafeMath for uint256;
1229 
1230     /**
1231      * Global
1232      */
1233 
1234     function dai() public view returns (address) {
1235         return Constants.getDAIAddress();
1236     }
1237 
1238     function dao() public view returns (IDAO) {
1239         return _state.provider.dao;
1240     }
1241 
1242     function dollar() public view returns (IDollar) {
1243         return _state.provider.dollar;
1244     }
1245 
1246     function univ2() public view returns (IERC20) {
1247         return _state.provider.univ2;
1248     }
1249 
1250     function totalBonded() public view returns (uint256) {
1251         return _state.balance.bonded;
1252     }
1253 
1254     function totalStaged() public view returns (uint256) {
1255         return _state.balance.staged;
1256     }
1257 
1258     function totalClaimable() public view returns (uint256) {
1259         return _state.balance.claimable;
1260     }
1261 
1262     function totalPhantom() public view returns (uint256) {
1263         return _state.balance.phantom;
1264     }
1265 
1266     function totalRewarded() public view returns (uint256) {
1267         return dollar().balanceOf(address(this)).sub(totalClaimable());
1268     }
1269 
1270     function paused() public view returns (bool) {
1271         return _state.paused;
1272     }
1273 
1274     /**
1275      * Account
1276      */
1277 
1278     function balanceOfStaged(address account) public view returns (uint256) {
1279         return _state.accounts[account].staged;
1280     }
1281 
1282     function balanceOfClaimable(address account) public view returns (uint256) {
1283         return _state.accounts[account].claimable;
1284     }
1285 
1286     function balanceOfBonded(address account) public view returns (uint256) {
1287         return _state.accounts[account].bonded;
1288     }
1289 
1290     function balanceOfPhantom(address account) public view returns (uint256) {
1291         return _state.accounts[account].phantom;
1292     }
1293 
1294     function balanceOfRewarded(address account) public view returns (uint256) {
1295         uint256 totalBonded = totalBonded();
1296         if (totalBonded == 0) {
1297             return 0;
1298         }
1299 
1300         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1301         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1302             .mul(balanceOfBonded(account))
1303             .div(totalBonded);
1304 
1305         uint256 balanceOfPhantom = balanceOfPhantom(account);
1306         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1307             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1308         }
1309         return 0;
1310     }
1311 
1312     function statusOf(address account) public view returns (PoolAccount.Status) {
1313         return epoch() >= _state.accounts[account].fluidUntil ?
1314             PoolAccount.Status.Frozen :
1315             PoolAccount.Status.Fluid;
1316     }
1317 
1318     /**
1319      * Epoch
1320      */
1321 
1322     function epoch() internal view returns (uint256) {
1323         return dao().epoch();
1324     }
1325 }
1326 
1327 // File: contracts/oracle/PoolSetters.sol
1328 
1329 /*
1330     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1331 
1332     Licensed under the Apache License, Version 2.0 (the "License");
1333     you may not use this file except in compliance with the License.
1334     You may obtain a copy of the License at
1335 
1336     http://www.apache.org/licenses/LICENSE-2.0
1337 
1338     Unless required by applicable law or agreed to in writing, software
1339     distributed under the License is distributed on an "AS IS" BASIS,
1340     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1341     See the License for the specific language governing permissions and
1342     limitations under the License.
1343 */
1344 
1345 pragma solidity ^0.5.17;
1346 
1347 
1348 
1349 
1350 contract PoolSetters is PoolState, PoolGetters {
1351     using SafeMath for uint256;
1352 
1353     /**
1354      * Global
1355      */
1356 
1357     function pause() internal {
1358         _state.paused = true;
1359     }
1360 
1361     /**
1362      * Account
1363      */
1364 
1365     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1366         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1367         _state.balance.bonded = _state.balance.bonded.add(amount);
1368     }
1369 
1370     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1371         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1372         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1373     }
1374 
1375     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1376         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1377         _state.balance.staged = _state.balance.staged.add(amount);
1378     }
1379 
1380     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1381         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1382         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1383     }
1384 
1385     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1386         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1387         _state.balance.claimable = _state.balance.claimable.add(amount);
1388     }
1389 
1390     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1391         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1392         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1393     }
1394 
1395     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1396         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1397         _state.balance.phantom = _state.balance.phantom.add(amount);
1398     }
1399 
1400     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1401         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1402         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1403     }
1404 
1405     function unfreeze(address account) internal {
1406         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1407     }
1408 }
1409 
1410 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1411 
1412 pragma solidity >=0.5.0;
1413 
1414 interface IUniswapV2Pair {
1415     event Approval(address indexed owner, address indexed spender, uint value);
1416     event Transfer(address indexed from, address indexed to, uint value);
1417 
1418     function name() external pure returns (string memory);
1419     function symbol() external pure returns (string memory);
1420     function decimals() external pure returns (uint8);
1421     function totalSupply() external view returns (uint);
1422     function balanceOf(address owner) external view returns (uint);
1423     function allowance(address owner, address spender) external view returns (uint);
1424 
1425     function approve(address spender, uint value) external returns (bool);
1426     function transfer(address to, uint value) external returns (bool);
1427     function transferFrom(address from, address to, uint value) external returns (bool);
1428 
1429     function DOMAIN_SEPARATOR() external view returns (bytes32);
1430     function PERMIT_TYPEHASH() external pure returns (bytes32);
1431     function nonces(address owner) external view returns (uint);
1432 
1433     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1434 
1435     event Mint(address indexed sender, uint amount0, uint amount1);
1436     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1437     event Swap(
1438         address indexed sender,
1439         uint amount0In,
1440         uint amount1In,
1441         uint amount0Out,
1442         uint amount1Out,
1443         address indexed to
1444     );
1445     event Sync(uint112 reserve0, uint112 reserve1);
1446 
1447     function MINIMUM_LIQUIDITY() external pure returns (uint);
1448     function factory() external view returns (address);
1449     function token0() external view returns (address);
1450     function token1() external view returns (address);
1451     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1452     function price0CumulativeLast() external view returns (uint);
1453     function price1CumulativeLast() external view returns (uint);
1454     function kLast() external view returns (uint);
1455 
1456     function mint(address to) external returns (uint liquidity);
1457     function burn(address to) external returns (uint amount0, uint amount1);
1458     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1459     function skim(address to) external;
1460     function sync() external;
1461 
1462     function initialize(address, address) external;
1463 }
1464 
1465 // File: contracts/external/UniswapV2Library.sol
1466 
1467 pragma solidity >=0.5.0;
1468 
1469 
1470 
1471 library UniswapV2Library {
1472     using SafeMath for uint;
1473 
1474     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1475     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1476         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1477         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1478         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1479     }
1480 
1481     // calculates the CREATE2 address for a pair without making any external calls
1482     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1483         (address token0, address token1) = sortTokens(tokenA, tokenB);
1484         pair = address(uint(keccak256(abi.encodePacked(
1485                 hex'ff',
1486                 factory,
1487                 keccak256(abi.encodePacked(token0, token1)),
1488                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1489             ))));
1490     }
1491 
1492     // fetches and sorts the reserves for a pair
1493     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1494         (address token0,) = sortTokens(tokenA, tokenB);
1495         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1496         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1497     }
1498 
1499     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1500     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1501         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1502         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1503         amountB = amountA.mul(reserveB) / reserveA;
1504     }
1505 }
1506 
1507 // File: contracts/oracle/Liquidity.sol
1508 
1509 /*
1510     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1511 
1512     Licensed under the Apache License, Version 2.0 (the "License");
1513     you may not use this file except in compliance with the License.
1514     You may obtain a copy of the License at
1515 
1516     http://www.apache.org/licenses/LICENSE-2.0
1517 
1518     Unless required by applicable law or agreed to in writing, software
1519     distributed under the License is distributed on an "AS IS" BASIS,
1520     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1521     See the License for the specific language governing permissions and
1522     limitations under the License.
1523 */
1524 
1525 pragma solidity ^0.5.17;
1526 
1527 
1528 
1529 
1530 
1531 
1532 contract Liquidity is PoolGetters {
1533     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1534 
1535     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1536         (address dollar, address dai) = (address(dollar()), dai());
1537         (uint reserveA, uint reserveB) = getReserves(dollar, dai);
1538 
1539         uint256 daiAmount = (reserveA == 0 && reserveB == 0) ?
1540              dollarAmount :
1541              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1542 
1543         address pair = address(univ2());
1544         IERC20(dollar).transfer(pair, dollarAmount);
1545         IERC20(dai).transferFrom(msg.sender, pair, daiAmount);
1546         return (daiAmount, IUniswapV2Pair(pair).mint(address(this)));
1547     }
1548 
1549     // overridable for testing
1550     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1551         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1552         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1553         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1554     }
1555 }
1556 
1557 // File: contracts/oracle/Pool.sol
1558 
1559 /*
1560     Copyright 2020 Daiquilibrium devs, based on the works of the Dynamic Dollar Devs and the Empty Set Squad
1561 
1562     Licensed under the Apache License, Version 2.0 (the "License");
1563     you may not use this file except in compliance with the License.
1564     You may obtain a copy of the License at
1565 
1566     http://www.apache.org/licenses/LICENSE-2.0
1567 
1568     Unless required by applicable law or agreed to in writing, software
1569     distributed under the License is distributed on an "AS IS" BASIS,
1570     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1571     See the License for the specific language governing permissions and
1572     limitations under the License.
1573 */
1574 
1575 pragma solidity ^0.5.17;
1576 pragma experimental ABIEncoderV2;
1577 
1578 
1579 
1580 
1581 
1582 
1583 
1584 contract Pool is PoolSetters, Liquidity {
1585     using SafeMath for uint256;
1586 
1587     constructor(address dollar, address univ2) public {
1588         _state.provider.dao = IDAO(msg.sender);
1589         _state.provider.dollar = IDollar(dollar);
1590         _state.provider.univ2 = IERC20(univ2);
1591     }
1592 
1593     bytes32 private constant FILE = "Pool";
1594 
1595     event Deposit(address indexed account, uint256 value);
1596     event Withdraw(address indexed account, uint256 value);
1597     event Claim(address indexed account, uint256 value);
1598     event Bond(address indexed account, uint256 start, uint256 value);
1599     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1600     event Provide(address indexed account, uint256 value, uint256 lessDai, uint256 newUniv2);
1601 
1602     function deposit(uint256 value) external onlyFrozenOrFluid(msg.sender) notPaused {
1603         univ2().transferFrom(msg.sender, address(this), value);
1604         incrementBalanceOfStaged(msg.sender, value);
1605 
1606         balanceCheck();
1607 
1608         emit Deposit(msg.sender, value);
1609     }
1610 
1611     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1612         univ2().transfer(msg.sender, value);
1613         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1614 
1615         balanceCheck();
1616 
1617         emit Withdraw(msg.sender, value);
1618     }
1619 
1620     function claim(uint256 value) external onlyFrozen(msg.sender) {
1621         dollar().transfer(msg.sender, value);
1622         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1623 
1624         balanceCheck();
1625 
1626         emit Claim(msg.sender, value);
1627     }
1628 
1629     function bond(uint256 value) external notPaused {
1630         unfreeze(msg.sender);
1631 
1632         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1633         uint256 newPhantom = totalBonded() == 0 ?
1634             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1635             totalRewardedWithPhantom.mul(value).div(totalBonded());
1636 
1637         incrementBalanceOfBonded(msg.sender, value);
1638         incrementBalanceOfPhantom(msg.sender, newPhantom);
1639         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1640 
1641         balanceCheck();
1642 
1643         emit Bond(msg.sender, epoch().add(1), value);
1644     }
1645 
1646     function unbond(uint256 value) external {
1647         unfreeze(msg.sender);
1648 
1649         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1650         Require.that(
1651             balanceOfBonded > 0,
1652             FILE,
1653             "insufficient bonded balance"
1654         );
1655 
1656         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1657         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1658 
1659         incrementBalanceOfStaged(msg.sender, value);
1660         incrementBalanceOfClaimable(msg.sender, newClaimable);
1661         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1662         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1663 
1664         balanceCheck();
1665 
1666         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1667     }
1668 
1669     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1670         Require.that(
1671             totalBonded() > 0,
1672             FILE,
1673             "insufficient total bonded"
1674         );
1675 
1676         Require.that(
1677             totalRewarded() > 0,
1678             FILE,
1679             "insufficient total rewarded"
1680         );
1681 
1682         Require.that(
1683             balanceOfRewarded(msg.sender) >= value,
1684             FILE,
1685             "insufficient rewarded balance"
1686         );
1687 
1688         (uint256 lessDai, uint256 newUniv2) = addLiquidity(value);
1689 
1690         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1691         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1692 
1693         incrementBalanceOfBonded(msg.sender, newUniv2);
1694         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1695 
1696 
1697         balanceCheck();
1698 
1699         emit Provide(msg.sender, value, lessDai, newUniv2);
1700     }
1701 
1702     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1703         IERC20(token).transfer(address(dao()), value);
1704     }
1705 
1706     function emergencyPause() external onlyDao {
1707         pause();
1708     }
1709 
1710     function balanceCheck() private {
1711         Require.that(
1712             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1713             FILE,
1714             "Inconsistent UNI-V2 balances"
1715         );
1716     }
1717 
1718     modifier onlyFrozen(address account) {
1719         Require.that(
1720             statusOf(account) == PoolAccount.Status.Frozen,
1721             FILE,
1722             "Not frozen"
1723         );
1724 
1725         _;
1726     }
1727 
1728     modifier onlyFrozenOrFluid(address account) {
1729         Require.that(
1730             statusOf(account) == PoolAccount.Status.Frozen ||  statusOf(account) == PoolAccount.Status.Fluid,
1731             FILE,
1732             "Not frozen or fluid"
1733         );
1734 
1735         _;
1736     }
1737 
1738     modifier onlyDao() {
1739         Require.that(
1740             msg.sender == address(dao()),
1741             FILE,
1742             "Not dao"
1743         );
1744 
1745         _;
1746     }
1747 
1748     modifier notPaused() {
1749         Require.that(
1750             !paused(),
1751             FILE,
1752             "Paused"
1753         );
1754 
1755         _;
1756     }
1757 }