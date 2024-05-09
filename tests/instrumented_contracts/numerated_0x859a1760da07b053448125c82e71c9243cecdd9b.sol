1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-09
3 */
4 
5 pragma solidity ^0.5.17;
6 pragma experimental ABIEncoderV2;
7 
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot overflow.
60      *
61      * _Available since v2.4.0._
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      *
119      * _Available since v2.4.0._
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      *
156      * _Available since v2.4.0._
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
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
239 /*
240     Copyright 2019 dYdX Trading Inc.
241 
242     Licensed under the Apache License, Version 2.0 (the "License");
243     you may not use this file except in compliance with the License.
244     You may obtain a copy of the License at
245 
246     http://www.apache.org/licenses/LICENSE-2.0
247 
248     Unless required by applicable law or agreed to in writing, software
249     distributed under the License is distributed on an "AS IS" BASIS,
250     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
251     See the License for the specific language governing permissions and
252     limitations under the License.
253 */
254 /**
255  * @title Require
256  * @author dYdX
257  *
258  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
259  */
260 library Require {
261 
262     // ============ Constants ============
263 
264     uint256 constant ASCII_ZERO = 48; // '0'
265     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
266     uint256 constant ASCII_LOWER_EX = 120; // 'x'
267     bytes2 constant COLON = 0x3a20; // ': '
268     bytes2 constant COMMA = 0x2c20; // ', '
269     bytes2 constant LPAREN = 0x203c; // ' <'
270     byte constant RPAREN = 0x3e; // '>'
271     uint256 constant FOUR_BIT_MASK = 0xf;
272 
273     // ============ Library Functions ============
274 
275     function that(
276         bool must,
277         bytes32 file,
278         bytes32 reason
279     )
280     internal
281     pure
282     {
283         if (!must) {
284             revert(
285                 string(
286                     abi.encodePacked(
287                         stringifyTruncated(file),
288                         COLON,
289                         stringifyTruncated(reason)
290                     )
291                 )
292             );
293         }
294     }
295 
296     function that(
297         bool must,
298         bytes32 file,
299         bytes32 reason,
300         uint256 payloadA
301     )
302     internal
303     pure
304     {
305         if (!must) {
306             revert(
307                 string(
308                     abi.encodePacked(
309                         stringifyTruncated(file),
310                         COLON,
311                         stringifyTruncated(reason),
312                         LPAREN,
313                         stringify(payloadA),
314                         RPAREN
315                     )
316                 )
317             );
318         }
319     }
320 
321     function that(
322         bool must,
323         bytes32 file,
324         bytes32 reason,
325         uint256 payloadA,
326         uint256 payloadB
327     )
328     internal
329     pure
330     {
331         if (!must) {
332             revert(
333                 string(
334                     abi.encodePacked(
335                         stringifyTruncated(file),
336                         COLON,
337                         stringifyTruncated(reason),
338                         LPAREN,
339                         stringify(payloadA),
340                         COMMA,
341                         stringify(payloadB),
342                         RPAREN
343                     )
344                 )
345             );
346         }
347     }
348 
349     function that(
350         bool must,
351         bytes32 file,
352         bytes32 reason,
353         address payloadA
354     )
355     internal
356     pure
357     {
358         if (!must) {
359             revert(
360                 string(
361                     abi.encodePacked(
362                         stringifyTruncated(file),
363                         COLON,
364                         stringifyTruncated(reason),
365                         LPAREN,
366                         stringify(payloadA),
367                         RPAREN
368                     )
369                 )
370             );
371         }
372     }
373 
374     function that(
375         bool must,
376         bytes32 file,
377         bytes32 reason,
378         address payloadA,
379         uint256 payloadB
380     )
381     internal
382     pure
383     {
384         if (!must) {
385             revert(
386                 string(
387                     abi.encodePacked(
388                         stringifyTruncated(file),
389                         COLON,
390                         stringifyTruncated(reason),
391                         LPAREN,
392                         stringify(payloadA),
393                         COMMA,
394                         stringify(payloadB),
395                         RPAREN
396                     )
397                 )
398             );
399         }
400     }
401 
402     function that(
403         bool must,
404         bytes32 file,
405         bytes32 reason,
406         address payloadA,
407         uint256 payloadB,
408         uint256 payloadC
409     )
410     internal
411     pure
412     {
413         if (!must) {
414             revert(
415                 string(
416                     abi.encodePacked(
417                         stringifyTruncated(file),
418                         COLON,
419                         stringifyTruncated(reason),
420                         LPAREN,
421                         stringify(payloadA),
422                         COMMA,
423                         stringify(payloadB),
424                         COMMA,
425                         stringify(payloadC),
426                         RPAREN
427                     )
428                 )
429             );
430         }
431     }
432 
433     function that(
434         bool must,
435         bytes32 file,
436         bytes32 reason,
437         bytes32 payloadA
438     )
439     internal
440     pure
441     {
442         if (!must) {
443             revert(
444                 string(
445                     abi.encodePacked(
446                         stringifyTruncated(file),
447                         COLON,
448                         stringifyTruncated(reason),
449                         LPAREN,
450                         stringify(payloadA),
451                         RPAREN
452                     )
453                 )
454             );
455         }
456     }
457 
458     function that(
459         bool must,
460         bytes32 file,
461         bytes32 reason,
462         bytes32 payloadA,
463         uint256 payloadB,
464         uint256 payloadC
465     )
466     internal
467     pure
468     {
469         if (!must) {
470             revert(
471                 string(
472                     abi.encodePacked(
473                         stringifyTruncated(file),
474                         COLON,
475                         stringifyTruncated(reason),
476                         LPAREN,
477                         stringify(payloadA),
478                         COMMA,
479                         stringify(payloadB),
480                         COMMA,
481                         stringify(payloadC),
482                         RPAREN
483                     )
484                 )
485             );
486         }
487     }
488 
489     // ============ Private Functions ============
490 
491     function stringifyTruncated(
492         bytes32 input
493     )
494     private
495     pure
496     returns (bytes memory)
497     {
498         // put the input bytes into the result
499         bytes memory result = abi.encodePacked(input);
500 
501         // determine the length of the input by finding the location of the last non-zero byte
502         for (uint256 i = 32; i > 0; ) {
503             // reverse-for-loops with unsigned integer
504             /* solium-disable-next-line security/no-modify-for-iter-var */
505             i--;
506 
507             // find the last non-zero byte in order to determine the length
508             if (result[i] != 0) {
509                 uint256 length = i + 1;
510 
511                 /* solium-disable-next-line security/no-inline-assembly */
512                 assembly {
513                     mstore(result, length) // r.length = length;
514                 }
515 
516                 return result;
517             }
518         }
519 
520         // all bytes are zero
521         return new bytes(0);
522     }
523 
524     function stringify(
525         uint256 input
526     )
527     private
528     pure
529     returns (bytes memory)
530     {
531         if (input == 0) {
532             return "0";
533         }
534 
535         // get the final string length
536         uint256 j = input;
537         uint256 length;
538         while (j != 0) {
539             length++;
540             j /= 10;
541         }
542 
543         // allocate the string
544         bytes memory bstr = new bytes(length);
545 
546         // populate the string starting with the least-significant character
547         j = input;
548         for (uint256 i = length; i > 0; ) {
549             // reverse-for-loops with unsigned integer
550             /* solium-disable-next-line security/no-modify-for-iter-var */
551             i--;
552 
553             // take last decimal digit
554             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
555 
556             // remove the last decimal digit
557             j /= 10;
558         }
559 
560         return bstr;
561     }
562 
563     function stringify(
564         address input
565     )
566     private
567     pure
568     returns (bytes memory)
569     {
570         uint256 z = uint256(input);
571 
572         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
573         bytes memory result = new bytes(42);
574 
575         // populate the result with "0x"
576         result[0] = byte(uint8(ASCII_ZERO));
577         result[1] = byte(uint8(ASCII_LOWER_EX));
578 
579         // for each byte (starting from the lowest byte), populate the result with two characters
580         for (uint256 i = 0; i < 20; i++) {
581             // each byte takes two characters
582             uint256 shift = i * 2;
583 
584             // populate the least-significant character
585             result[41 - shift] = char(z & FOUR_BIT_MASK);
586             z = z >> 4;
587 
588             // populate the most-significant character
589             result[40 - shift] = char(z & FOUR_BIT_MASK);
590             z = z >> 4;
591         }
592 
593         return result;
594     }
595 
596     function stringify(
597         bytes32 input
598     )
599     private
600     pure
601     returns (bytes memory)
602     {
603         uint256 z = uint256(input);
604 
605         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
606         bytes memory result = new bytes(66);
607 
608         // populate the result with "0x"
609         result[0] = byte(uint8(ASCII_ZERO));
610         result[1] = byte(uint8(ASCII_LOWER_EX));
611 
612         // for each byte (starting from the lowest byte), populate the result with two characters
613         for (uint256 i = 0; i < 32; i++) {
614             // each byte takes two characters
615             uint256 shift = i * 2;
616 
617             // populate the least-significant character
618             result[65 - shift] = char(z & FOUR_BIT_MASK);
619             z = z >> 4;
620 
621             // populate the most-significant character
622             result[64 - shift] = char(z & FOUR_BIT_MASK);
623             z = z >> 4;
624         }
625 
626         return result;
627     }
628 
629     function char(
630         uint256 input
631     )
632     private
633     pure
634     returns (byte)
635     {
636         // return ASCII digit (0-9)
637         if (input < 10) {
638             return byte(uint8(input + ASCII_ZERO));
639         }
640 
641         // return ASCII letter (a-f)
642         return byte(uint8(input + ASCII_RELATIVE_ZERO));
643     }
644 }
645 
646 /*
647     Copyright 2019 dYdX Trading Inc.
648     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
649 
650     Licensed under the Apache License, Version 2.0 (the "License");
651     you may not use this file except in compliance with the License.
652     You may obtain a copy of the License at
653 
654     http://www.apache.org/licenses/LICENSE-2.0
655 
656     Unless required by applicable law or agreed to in writing, software
657     distributed under the License is distributed on an "AS IS" BASIS,
658     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
659     See the License for the specific language governing permissions and
660     limitations under the License.
661 */
662 /**
663  * @title Decimal
664  * @author dYdX
665  *
666  * Library that defines a fixed-point number with 18 decimal places.
667  */
668 library Decimal {
669     using SafeMath for uint256;
670 
671     // ============ Constants ============
672 
673     uint256 constant BASE = 10**18;
674 
675     // ============ Structs ============
676 
677 
678     struct D256 {
679         uint256 value;
680     }
681 
682     // ============ Static Functions ============
683 
684     function zero()
685     internal
686     pure
687     returns (D256 memory)
688     {
689         return D256({ value: 0 });
690     }
691 
692     function one()
693     internal
694     pure
695     returns (D256 memory)
696     {
697         return D256({ value: BASE });
698     }
699 
700     function from(
701         uint256 a
702     )
703     internal
704     pure
705     returns (D256 memory)
706     {
707         return D256({ value: a.mul(BASE) });
708     }
709 
710     function ratio(
711         uint256 a,
712         uint256 b
713     )
714     internal
715     pure
716     returns (D256 memory)
717     {
718         return D256({ value: getPartial(a, BASE, b) });
719     }
720 
721     // ============ Self Functions ============
722 
723     function add(
724         D256 memory self,
725         uint256 b
726     )
727     internal
728     pure
729     returns (D256 memory)
730     {
731         return D256({ value: self.value.add(b.mul(BASE)) });
732     }
733 
734     function sub(
735         D256 memory self,
736         uint256 b
737     )
738     internal
739     pure
740     returns (D256 memory)
741     {
742         return D256({ value: self.value.sub(b.mul(BASE)) });
743     }
744 
745     function sub(
746         D256 memory self,
747         uint256 b,
748         string memory reason
749     )
750     internal
751     pure
752     returns (D256 memory)
753     {
754         return D256({ value: self.value.sub(b.mul(BASE), reason) });
755     }
756 
757     function mul(
758         D256 memory self,
759         uint256 b
760     )
761     internal
762     pure
763     returns (D256 memory)
764     {
765         return D256({ value: self.value.mul(b) });
766     }
767 
768     function div(
769         D256 memory self,
770         uint256 b
771     )
772     internal
773     pure
774     returns (D256 memory)
775     {
776         return D256({ value: self.value.div(b) });
777     }
778 
779     function pow(
780         D256 memory self,
781         uint256 b
782     )
783     internal
784     pure
785     returns (D256 memory)
786     {
787         if (b == 0) {
788             return from(1);
789         }
790 
791         D256 memory temp = D256({ value: self.value });
792         for (uint256 i = 1; i < b; i++) {
793             temp = mul(temp, self);
794         }
795 
796         return temp;
797     }
798 
799     function add(
800         D256 memory self,
801         D256 memory b
802     )
803     internal
804     pure
805     returns (D256 memory)
806     {
807         return D256({ value: self.value.add(b.value) });
808     }
809 
810     function sub(
811         D256 memory self,
812         D256 memory b
813     )
814     internal
815     pure
816     returns (D256 memory)
817     {
818         return D256({ value: self.value.sub(b.value) });
819     }
820 
821     function sub(
822         D256 memory self,
823         D256 memory b,
824         string memory reason
825     )
826     internal
827     pure
828     returns (D256 memory)
829     {
830         return D256({ value: self.value.sub(b.value, reason) });
831     }
832 
833     function mul(
834         D256 memory self,
835         D256 memory b
836     )
837     internal
838     pure
839     returns (D256 memory)
840     {
841         return D256({ value: getPartial(self.value, b.value, BASE) });
842     }
843 
844     function div(
845         D256 memory self,
846         D256 memory b
847     )
848     internal
849     pure
850     returns (D256 memory)
851     {
852         return D256({ value: getPartial(self.value, BASE, b.value) });
853     }
854 
855     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
856         return self.value == b.value;
857     }
858 
859     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
860         return compareTo(self, b) == 2;
861     }
862 
863     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
864         return compareTo(self, b) == 0;
865     }
866 
867     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
868         return compareTo(self, b) > 0;
869     }
870 
871     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
872         return compareTo(self, b) < 2;
873     }
874 
875     function isZero(D256 memory self) internal pure returns (bool) {
876         return self.value == 0;
877     }
878 
879     function asUint256(D256 memory self) internal pure returns (uint256) {
880         return self.value.div(BASE);
881     }
882 
883     // ============ Core Methods ============
884 
885     function getPartial(
886         uint256 target,
887         uint256 numerator,
888         uint256 denominator
889     )
890     private
891     pure
892     returns (uint256)
893     {
894         return target.mul(numerator).div(denominator);
895     }
896 
897     function compareTo(
898         D256 memory a,
899         D256 memory b
900     )
901     private
902     pure
903     returns (uint256)
904     {
905         if (a.value == b.value) {
906             return 1;
907         }
908         return a.value > b.value ? 2 : 0;
909     }
910 }
911 
912 /*
913     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
914 
915     Licensed under the Apache License, Version 2.0 (the "License");
916     you may not use this file except in compliance with the License.
917     You may obtain a copy of the License at
918 
919     http://www.apache.org/licenses/LICENSE-2.0
920 
921     Unless required by applicable law or agreed to in writing, software
922     distributed under the License is distributed on an "AS IS" BASIS,
923     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
924     See the License for the specific language governing permissions and
925     limitations under the License.
926 */
927 library Constants {
928     /* Chain */
929     uint256 private constant CHAIN_ID = 1; // Mainnet
930 
931     /* Bootstrapping */
932     uint256 private constant BOOTSTRAPPING_PERIOD = 300;
933     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC
934     uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 3; // 30 days @ 8 hours
935 
936     /* Oracle */
937     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
938     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
939 
940     /* Bonding */
941     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESD -> 100M ESDS
942 
943     /* Epoch */
944     struct EpochStrategy {
945         uint256 offset;
946         uint256 start;
947         uint256 period;
948     }
949 
950     uint256 private constant PREVIOUS_EPOCH_OFFSET = 91;
951     uint256 private constant PREVIOUS_EPOCH_START = 1600905600;
952     uint256 private constant PREVIOUS_EPOCH_PERIOD = 3600;
953 
954     uint256 private constant CURRENT_EPOCH_OFFSET = 106;
955     uint256 private constant CURRENT_EPOCH_START = 1602201600;
956     uint256 private constant CURRENT_EPOCH_PERIOD = 3600;
957 
958     /* Governance */
959     uint256 private constant GOVERNANCE_PERIOD = 72;
960     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
961     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
962     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 12; // 6 epochs
963 
964     /* DAO */
965     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ESD
966     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 72; // 72 epochs fluid
967 
968     /* Pool */
969     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
970 
971     /* Market */
972     uint256 private constant COUPON_EXPIRATION = 360;
973     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
974 
975     /* Regulator */
976     uint256 private constant SUPPLY_CHANGE_LIMIT = 2e16; // 2%
977     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 5e16; // 5%
978     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
979 
980     /**
981      * Getters
982      */
983 
984     function getUsdcAddress() internal pure returns (address) {
985         return USDC;
986     }
987 
988     function getOracleReserveMinimum() internal pure returns (uint256) {
989         return ORACLE_RESERVE_MINIMUM;
990     }
991 
992     function getPreviousEpochStrategy() internal pure returns (EpochStrategy memory) {
993         return EpochStrategy({
994             offset: PREVIOUS_EPOCH_OFFSET,
995             start: PREVIOUS_EPOCH_START,
996             period: PREVIOUS_EPOCH_PERIOD
997         });
998     }
999 
1000     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
1001         return EpochStrategy({
1002             offset: CURRENT_EPOCH_OFFSET,
1003             start: CURRENT_EPOCH_START,
1004             period: CURRENT_EPOCH_PERIOD
1005         });
1006     }
1007 
1008     function getInitialStakeMultiple() internal pure returns (uint256) {
1009         return INITIAL_STAKE_MULTIPLE;
1010     }
1011 
1012     function getBootstrappingPeriod() internal pure returns (uint256) {
1013         return BOOTSTRAPPING_PERIOD;
1014     }
1015 
1016     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1017         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1018     }
1019 
1020     function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
1021         return BOOTSTRAPPING_SPEEDUP_FACTOR;
1022     }
1023 
1024     function getGovernancePeriod() internal pure returns (uint256) {
1025         return GOVERNANCE_PERIOD;
1026     }
1027 
1028     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1029         return Decimal.D256({value: GOVERNANCE_QUORUM});
1030     }
1031 
1032     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1033         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1034     }
1035 
1036     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1037         return GOVERNANCE_EMERGENCY_DELAY;
1038     }
1039 
1040     function getAdvanceIncentive() internal pure returns (uint256) {
1041         return ADVANCE_INCENTIVE;
1042     }
1043 
1044     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1045         return DAO_EXIT_LOCKUP_EPOCHS;
1046     }
1047 
1048     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1049         return POOL_EXIT_LOCKUP_EPOCHS;
1050     }
1051 
1052     function getCouponExpiration() internal pure returns (uint256) {
1053         return COUPON_EXPIRATION;
1054     }
1055 
1056     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1057         return Decimal.D256({value: DEBT_RATIO_CAP});
1058     }
1059 
1060     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1061         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1062     }
1063 
1064     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1065         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1066     }
1067 
1068     function getOraclePoolRatio() internal pure returns (uint256) {
1069         return ORACLE_POOL_RATIO;
1070     }
1071 
1072     function getChainId() internal pure returns (uint256) {
1073         return CHAIN_ID;
1074     }
1075 }
1076 
1077 /*
1078     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1079 
1080     Licensed under the Apache License, Version 2.0 (the "License");
1081     you may not use this file except in compliance with the License.
1082     You may obtain a copy of the License at
1083 
1084     http://www.apache.org/licenses/LICENSE-2.0
1085 
1086     Unless required by applicable law or agreed to in writing, software
1087     distributed under the License is distributed on an "AS IS" BASIS,
1088     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1089     See the License for the specific language governing permissions and
1090     limitations under the License.
1091 */
1092 contract IDollar is IERC20 {
1093     function burn(uint256 amount) public;
1094     function burnFrom(address account, uint256 amount) public;
1095     function mint(address account, uint256 amount) public returns (bool);
1096 }
1097 
1098 /*
1099     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1100 
1101     Licensed under the Apache License, Version 2.0 (the "License");
1102     you may not use this file except in compliance with the License.
1103     You may obtain a copy of the License at
1104 
1105     http://www.apache.org/licenses/LICENSE-2.0
1106 
1107     Unless required by applicable law or agreed to in writing, software
1108     distributed under the License is distributed on an "AS IS" BASIS,
1109     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1110     See the License for the specific language governing permissions and
1111     limitations under the License.
1112 */
1113 contract IDAO {
1114     function epoch() external view returns (uint256);
1115 }
1116 
1117 /*
1118     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1119 
1120     Licensed under the Apache License, Version 2.0 (the "License");
1121     you may not use this file except in compliance with the License.
1122     You may obtain a copy of the License at
1123 
1124     http://www.apache.org/licenses/LICENSE-2.0
1125 
1126     Unless required by applicable law or agreed to in writing, software
1127     distributed under the License is distributed on an "AS IS" BASIS,
1128     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1129     See the License for the specific language governing permissions and
1130     limitations under the License.
1131 */
1132 contract IUSDC {
1133     function isBlacklisted(address _account) external view returns (bool);
1134 }
1135 
1136 /*
1137     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1138 
1139     Licensed under the Apache License, Version 2.0 (the "License");
1140     you may not use this file except in compliance with the License.
1141     You may obtain a copy of the License at
1142 
1143     http://www.apache.org/licenses/LICENSE-2.0
1144 
1145     Unless required by applicable law or agreed to in writing, software
1146     distributed under the License is distributed on an "AS IS" BASIS,
1147     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1148     See the License for the specific language governing permissions and
1149     limitations under the License.
1150 */
1151 contract PoolAccount {
1152     enum Status {
1153         Frozen,
1154         Fluid,
1155         Locked
1156     }
1157 
1158     struct State {
1159         uint256 staged;
1160         uint256 claimable;
1161         uint256 bonded;
1162         uint256 phantom;
1163         uint256 fluidUntil;
1164     }
1165 }
1166 
1167 contract PoolStorage {
1168     struct Balance {
1169         uint256 staged;
1170         uint256 claimable;
1171         uint256 bonded;
1172         uint256 phantom;
1173     }
1174     
1175     struct Provider {
1176         address oracle;
1177         address dollar;
1178         address usdc;
1179         address uniV2;
1180         address dao;
1181     }
1182 
1183     struct State {
1184         Balance balance;
1185         Provider provider;
1186         bool paused;
1187 
1188         mapping(address => PoolAccount.State) accounts;
1189     }
1190 }
1191 
1192 contract PoolState {
1193     PoolStorage.State _state;
1194 }
1195 
1196 /*
1197     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1198 
1199     Licensed under the Apache License, Version 2.0 (the "License");
1200     you may not use this file except in compliance with the License.
1201     You may obtain a copy of the License at
1202 
1203     http://www.apache.org/licenses/LICENSE-2.0
1204 
1205     Unless required by applicable law or agreed to in writing, software
1206     distributed under the License is distributed on an "AS IS" BASIS,
1207     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1208     See the License for the specific language governing permissions and
1209     limitations under the License.
1210 */
1211 contract PoolGetters is PoolState {
1212     using SafeMath for uint256;
1213 
1214     /**
1215      * Global
1216      */
1217 
1218     function usdc() public view returns (address) {
1219         return _state.provider.usdc;
1220     }
1221 
1222     function dao() public view returns (address) {
1223         return _state.provider.dao;
1224     }
1225 
1226     function dollar() public view returns (address) {
1227         return _state.provider.dollar;
1228     }
1229 
1230     function univ2() public view returns (IERC20) {
1231         return IERC20(_state.provider.uniV2);
1232     }
1233     
1234     function oracle() public view returns (address) {
1235         return _state.provider.oracle;
1236     }
1237 
1238     function totalBonded() public view returns (uint256) {
1239         return _state.balance.bonded;
1240     }
1241 
1242     function totalStaged() public view returns (uint256) {
1243         return _state.balance.staged;
1244     }
1245 
1246     function totalClaimable() public view returns (uint256) {
1247         return _state.balance.claimable;
1248     }
1249 
1250     function totalPhantom() public view returns (uint256) {
1251         return _state.balance.phantom;
1252     }
1253 
1254     function totalRewarded() public view returns (uint256) {
1255         return IDollar(dollar()).balanceOf(address(this)).sub(totalClaimable());
1256     }
1257 
1258     function paused() public view returns (bool) {
1259         return _state.paused;
1260     }
1261 
1262     /**
1263      * Account
1264      */
1265 
1266     function balanceOfStaged(address account) public view returns (uint256) {
1267         return _state.accounts[account].staged;
1268     }
1269 
1270     function balanceOfClaimable(address account) public view returns (uint256) {
1271         return _state.accounts[account].claimable;
1272     }
1273 
1274     function balanceOfBonded(address account) public view returns (uint256) {
1275         return _state.accounts[account].bonded;
1276     }
1277 
1278     function balanceOfPhantom(address account) public view returns (uint256) {
1279         return _state.accounts[account].phantom;
1280     }
1281 
1282     function balanceOfRewarded(address account) public view returns (uint256) {
1283         uint256 totalBonded = totalBonded();
1284         if (totalBonded == 0) {
1285             return 0;
1286         }
1287 
1288         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1289         uint256 balanceOfRewardedWithPhantom = totalRewardedWithPhantom
1290             .mul(balanceOfBonded(account))
1291             .div(totalBonded);
1292 
1293         uint256 balanceOfPhantom = balanceOfPhantom(account);
1294         if (balanceOfRewardedWithPhantom > balanceOfPhantom) {
1295             return balanceOfRewardedWithPhantom.sub(balanceOfPhantom);
1296         }
1297         return 0;
1298     }
1299 
1300     function statusOf(address account) public view returns (PoolAccount.Status) {
1301         return epoch() >= _state.accounts[account].fluidUntil ?
1302             PoolAccount.Status.Frozen :
1303             PoolAccount.Status.Fluid;
1304     }
1305 
1306     /**
1307      * Epoch
1308      */
1309 
1310     function epoch() internal view returns (uint256) {
1311         return IDAO(dao()).epoch();
1312     }
1313 }
1314 
1315 /*
1316     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1317 
1318     Licensed under the Apache License, Version 2.0 (the "License");
1319     you may not use this file except in compliance with the License.
1320     You may obtain a copy of the License at
1321 
1322     http://www.apache.org/licenses/LICENSE-2.0
1323 
1324     Unless required by applicable law or agreed to in writing, software
1325     distributed under the License is distributed on an "AS IS" BASIS,
1326     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1327     See the License for the specific language governing permissions and
1328     limitations under the License.
1329 */
1330 contract PoolSetters is PoolState, PoolGetters {
1331     using SafeMath for uint256;
1332 
1333     /**
1334      * Global
1335      */
1336 
1337     function pause() internal {
1338         _state.paused = true;
1339     }
1340 
1341     /**
1342      * Account
1343      */
1344 
1345     function incrementBalanceOfBonded(address account, uint256 amount) internal {
1346         _state.accounts[account].bonded = _state.accounts[account].bonded.add(amount);
1347         _state.balance.bonded = _state.balance.bonded.add(amount);
1348     }
1349 
1350     function decrementBalanceOfBonded(address account, uint256 amount, string memory reason) internal {
1351         _state.accounts[account].bonded = _state.accounts[account].bonded.sub(amount, reason);
1352         _state.balance.bonded = _state.balance.bonded.sub(amount, reason);
1353     }
1354 
1355     function incrementBalanceOfStaged(address account, uint256 amount) internal {
1356         _state.accounts[account].staged = _state.accounts[account].staged.add(amount);
1357         _state.balance.staged = _state.balance.staged.add(amount);
1358     }
1359 
1360     function decrementBalanceOfStaged(address account, uint256 amount, string memory reason) internal {
1361         _state.accounts[account].staged = _state.accounts[account].staged.sub(amount, reason);
1362         _state.balance.staged = _state.balance.staged.sub(amount, reason);
1363     }
1364 
1365     function incrementBalanceOfClaimable(address account, uint256 amount) internal {
1366         _state.accounts[account].claimable = _state.accounts[account].claimable.add(amount);
1367         _state.balance.claimable = _state.balance.claimable.add(amount);
1368     }
1369 
1370     function decrementBalanceOfClaimable(address account, uint256 amount, string memory reason) internal {
1371         _state.accounts[account].claimable = _state.accounts[account].claimable.sub(amount, reason);
1372         _state.balance.claimable = _state.balance.claimable.sub(amount, reason);
1373     }
1374 
1375     function incrementBalanceOfPhantom(address account, uint256 amount) internal {
1376         _state.accounts[account].phantom = _state.accounts[account].phantom.add(amount);
1377         _state.balance.phantom = _state.balance.phantom.add(amount);
1378     }
1379 
1380     function decrementBalanceOfPhantom(address account, uint256 amount, string memory reason) internal {
1381         _state.accounts[account].phantom = _state.accounts[account].phantom.sub(amount, reason);
1382         _state.balance.phantom = _state.balance.phantom.sub(amount, reason);
1383     }
1384 
1385     function unfreeze(address account) internal {
1386         _state.accounts[account].fluidUntil = epoch().add(Constants.getPoolExitLockupEpochs());
1387     }
1388 }
1389 
1390 interface IUniswapV2Pair {
1391     event Approval(address indexed owner, address indexed spender, uint value);
1392     event Transfer(address indexed from, address indexed to, uint value);
1393 
1394     function name() external pure returns (string memory);
1395     function symbol() external pure returns (string memory);
1396     function decimals() external pure returns (uint8);
1397     function totalSupply() external view returns (uint);
1398     function balanceOf(address owner) external view returns (uint);
1399     function allowance(address owner, address spender) external view returns (uint);
1400 
1401     function approve(address spender, uint value) external returns (bool);
1402     function transfer(address to, uint value) external returns (bool);
1403     function transferFrom(address from, address to, uint value) external returns (bool);
1404 
1405     function DOMAIN_SEPARATOR() external view returns (bytes32);
1406     function PERMIT_TYPEHASH() external pure returns (bytes32);
1407     function nonces(address owner) external view returns (uint);
1408 
1409     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1410 
1411     event Mint(address indexed sender, uint amount0, uint amount1);
1412     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1413     event Swap(
1414         address indexed sender,
1415         uint amount0In,
1416         uint amount1In,
1417         uint amount0Out,
1418         uint amount1Out,
1419         address indexed to
1420     );
1421     event Sync(uint112 reserve0, uint112 reserve1);
1422 
1423     function MINIMUM_LIQUIDITY() external pure returns (uint);
1424     function factory() external view returns (address);
1425     function token0() external view returns (address);
1426     function token1() external view returns (address);
1427     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1428     function price0CumulativeLast() external view returns (uint);
1429     function price1CumulativeLast() external view returns (uint);
1430     function kLast() external view returns (uint);
1431 
1432     function mint(address to) external returns (uint liquidity);
1433     function burn(address to) external returns (uint amount0, uint amount1);
1434     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1435     function skim(address to) external;
1436     function sync() external;
1437 
1438     function initialize(address, address) external;
1439 }
1440 
1441 library UniswapV2Library {
1442     using SafeMath for uint;
1443 
1444     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1445     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1446         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1447         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1448         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1449     }
1450 
1451     // calculates the CREATE2 address for a pair without making any external calls
1452     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1453         (address token0, address token1) = sortTokens(tokenA, tokenB);
1454         pair = address(uint(keccak256(abi.encodePacked(
1455                 hex'ff',
1456                 factory,
1457                 keccak256(abi.encodePacked(token0, token1)),
1458                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1459             ))));
1460     }
1461 
1462     // fetches and sorts the reserves for a pair
1463     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1464         (address token0,) = sortTokens(tokenA, tokenB);
1465         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1466         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1467     }
1468 
1469     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1470     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1471         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1472         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1473         amountB = amountA.mul(reserveB) / reserveA;
1474     }
1475 }
1476 
1477 /*
1478     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1479 
1480     Licensed under the Apache License, Version 2.0 (the "License");
1481     you may not use this file except in compliance with the License.
1482     You may obtain a copy of the License at
1483 
1484     http://www.apache.org/licenses/LICENSE-2.0
1485 
1486     Unless required by applicable law or agreed to in writing, software
1487     distributed under the License is distributed on an "AS IS" BASIS,
1488     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1489     See the License for the specific language governing permissions and
1490     limitations under the License.
1491 */
1492 contract Liquidity is PoolGetters {
1493     address private constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1494 
1495     function addLiquidity(uint256 dollarAmount) internal returns (uint256, uint256) {
1496         (address dollar, address usdc) = (address(dollar()), usdc());
1497         (uint reserveA, uint reserveB) = getReserves(dollar, usdc);
1498 
1499         uint256 usdcAmount = (reserveA == 0 && reserveB == 0) ?
1500              dollarAmount :
1501              UniswapV2Library.quote(dollarAmount, reserveA, reserveB);
1502 
1503         address pair = address(univ2());
1504         IERC20(dollar).transfer(pair, dollarAmount);
1505         IERC20(usdc).transferFrom(msg.sender, pair, usdcAmount);
1506         return (usdcAmount, IUniswapV2Pair(pair).mint(address(this)));
1507     }
1508 
1509     // overridable for testing
1510     function getReserves(address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1511         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
1512         (uint reserve0, uint reserve1,) = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_FACTORY, tokenA, tokenB)).getReserves();
1513         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1514     }
1515 }
1516 
1517 /*
1518     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1519 
1520     Licensed under the Apache License, Version 2.0 (the "License");
1521     you may not use this file except in compliance with the License.
1522     You may obtain a copy of the License at
1523 
1524     http://www.apache.org/licenses/LICENSE-2.0
1525 
1526     Unless required by applicable law or agreed to in writing, software
1527     distributed under the License is distributed on an "AS IS" BASIS,
1528     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1529     See the License for the specific language governing permissions and
1530     limitations under the License.
1531 */
1532 contract Pool is PoolSetters, Liquidity {
1533     using SafeMath for uint256;
1534     
1535     address public owner;
1536 
1537     constructor(address _uniV2, address _oracle, address _dollar, address _usdc) public { 
1538         _state.provider.uniV2 = _uniV2;
1539         _state.provider.oracle = _oracle;
1540         _state.provider.dollar = _dollar;
1541         _state.provider.usdc = _usdc;
1542         owner = msg.sender;
1543     }
1544 
1545     bytes32 private constant FILE = "Pool";
1546 
1547     event Deposit(address indexed account, uint256 value);
1548     event Withdraw(address indexed account, uint256 value);
1549     event Claim(address indexed account, uint256 value);
1550     event Bond(address indexed account, uint256 start, uint256 value);
1551     event Unbond(address indexed account, uint256 start, uint256 value, uint256 newClaimable);
1552     event Provide(address indexed account, uint256 value, uint256 lessUsdc, uint256 newUniv2);
1553     
1554     function setDao(address _dao) public onlyOwner {
1555         _state.provider.dao = _dao;
1556     }
1557     
1558     function setOwner(address _owner) public onlyOwner {
1559         owner = _owner;
1560     }
1561 
1562     function deposit(uint256 value) external onlyFrozen(msg.sender) notPaused {
1563         univ2().transferFrom(msg.sender, address(this), value);
1564         incrementBalanceOfStaged(msg.sender, value);
1565 
1566         balanceCheck();
1567 
1568         emit Deposit(msg.sender, value);
1569     }
1570 
1571     function withdraw(uint256 value) external onlyFrozen(msg.sender) {
1572         univ2().transfer(msg.sender, value);
1573         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1574 
1575         balanceCheck();
1576 
1577         emit Withdraw(msg.sender, value);
1578     }
1579 
1580     function claim(uint256 value) external onlyFrozen(msg.sender) {
1581         IDollar(dollar()).transfer(msg.sender, value);
1582         decrementBalanceOfClaimable(msg.sender, value, "Pool: insufficient claimable balance");
1583 
1584         balanceCheck();
1585 
1586         emit Claim(msg.sender, value);
1587     }
1588 
1589     function bond(uint256 value) external notPaused {
1590         unfreeze(msg.sender);
1591 
1592         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom());
1593         uint256 newPhantom = totalBonded() == 0 ?
1594             totalRewarded() == 0 ? Constants.getInitialStakeMultiple().mul(value) : 0 :
1595             totalRewardedWithPhantom.mul(value).div(totalBonded());
1596 
1597         incrementBalanceOfBonded(msg.sender, value);
1598         incrementBalanceOfPhantom(msg.sender, newPhantom);
1599         decrementBalanceOfStaged(msg.sender, value, "Pool: insufficient staged balance");
1600 
1601         balanceCheck();
1602 
1603         emit Bond(msg.sender, epoch().add(1), value);
1604     }
1605 
1606     function unbond(uint256 value) external {
1607         unfreeze(msg.sender);
1608 
1609         uint256 balanceOfBonded = balanceOfBonded(msg.sender);
1610         Require.that(
1611             balanceOfBonded > 0,
1612             FILE,
1613             "insufficient bonded balance"
1614         );
1615 
1616         uint256 newClaimable = balanceOfRewarded(msg.sender).mul(value).div(balanceOfBonded);
1617         uint256 lessPhantom = balanceOfPhantom(msg.sender).mul(value).div(balanceOfBonded);
1618 
1619         incrementBalanceOfStaged(msg.sender, value);
1620         incrementBalanceOfClaimable(msg.sender, newClaimable);
1621         decrementBalanceOfBonded(msg.sender, value, "Pool: insufficient bonded balance");
1622         decrementBalanceOfPhantom(msg.sender, lessPhantom, "Pool: insufficient phantom balance");
1623 
1624         balanceCheck();
1625 
1626         emit Unbond(msg.sender, epoch().add(1), value, newClaimable);
1627     }
1628 
1629     function provide(uint256 value) external onlyFrozen(msg.sender) notPaused {
1630         Require.that(
1631             totalBonded() > 0,
1632             FILE,
1633             "insufficient total bonded"
1634         );
1635 
1636         Require.that(
1637             totalRewarded() > 0,
1638             FILE,
1639             "insufficient total rewarded"
1640         );
1641 
1642         Require.that(
1643             balanceOfRewarded(msg.sender) >= value,
1644             FILE,
1645             "insufficient rewarded balance"
1646         );
1647 
1648         (uint256 lessUsdc, uint256 newUniv2) = addLiquidity(value);
1649 
1650         uint256 totalRewardedWithPhantom = totalRewarded().add(totalPhantom()).add(value);
1651         uint256 newPhantomFromBonded = totalRewardedWithPhantom.mul(newUniv2).div(totalBonded());
1652 
1653         incrementBalanceOfBonded(msg.sender, newUniv2);
1654         incrementBalanceOfPhantom(msg.sender, value.add(newPhantomFromBonded));
1655 
1656 
1657         balanceCheck();
1658 
1659         emit Provide(msg.sender, value, lessUsdc, newUniv2);
1660     }
1661 
1662     function emergencyWithdraw(address token, uint256 value) external onlyDao {
1663         IERC20(token).transfer(address(dao()), value);
1664     }
1665 
1666     function emergencyPause() external onlyDao {
1667         pause();
1668     }
1669 
1670     function balanceCheck() private {
1671         Require.that(
1672             univ2().balanceOf(address(this)) >= totalStaged().add(totalBonded()),
1673             FILE,
1674             "Inconsistent UNI-V2 balances"
1675         );
1676     }
1677 
1678     modifier onlyFrozen(address account) {
1679         Require.that(
1680             statusOf(account) == PoolAccount.Status.Frozen,
1681             FILE,
1682             "Not frozen"
1683         );
1684 
1685         _;
1686     }
1687 
1688     modifier onlyDao() {
1689         Require.that(
1690             msg.sender == address(dao()),
1691             FILE,
1692             "Not dao"
1693         );
1694 
1695         _;
1696     }
1697     
1698     modifier onlyOwner() {
1699         Require.that(
1700             msg.sender == owner,
1701             FILE,
1702             "Not Owner"
1703         );
1704 
1705         _;
1706     }
1707 
1708     modifier notPaused() {
1709         Require.that(
1710             !paused(),
1711             FILE,
1712             "Paused"
1713         );
1714 
1715         _;
1716     }
1717 }